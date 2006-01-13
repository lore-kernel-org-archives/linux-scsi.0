From: Volker Kuhlmann <list0570@paradise.net.nz>
Subject: [PATCH] sg_io_hdr 32 bit binary compatibility on AMD64
Date: Sat, 14 Jan 2006 11:08:54 +1300
Message-ID: <20060113220854.GD12885@paradise.net.nz>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from 203-79-122-66.cable.paradise.net.nz ([203.79.122.66]:1380 "EHLO
	kereru.site") by vger.kernel.org with ESMTP id S1423002AbWAMWJJ
	(ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Fri, 13 Jan 2006 17:09:09 -0500
Content-Disposition: inline
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Doug Gilbert <dgilbert@interlog.com>
Cc: linux-scsi@vger.kernel.org

Comments?

(A version with debug code included is here:
http://volker.dnsalias.net/soft/patch/kernel-2.6.13-sg-io32-debug.diff )



Purpose of this patch: establish binary compatibility with 32 bit x86 code on
AMD64 64 bit kernels, in the use of struct sg_io_hdr via write()/read() calls.
Currently this binary compatibility only exists with ioctl().
32bit applications which use or are linked with sanei_scsi.c of the SANE project
(sane-project.org) need this patch.

Tested: on AMD64, SUSE Linux 10.0 kernel, with
	a commercial 32 bit scanning application
	xsane 64 bit
	cdrecord 64 bit

Thanks are due to: Abel Deuring, Henning Meier-Geinitz, Dieter Jurzitza - all
sane-devel mailing list.

TODO:
	how many other 32/64 bit architectures does this apply to?

Signed-off-by: Volker Kuhlmann <VolkerKuhlmann.gmx.de>
13 Jan 2006


--- drivers/scsi/sg.c.orig	2005-11-30 09:35:27.000000000 +1300
+++ drivers/scsi/sg.c	2006-01-14 10:30:54.000000000 +1300
@@ -11,6 +11,9 @@
  *
  *  Modified  19-JAN-1998  Richard Gooch <rgooch@atnf.csiro.au>  Devfs support
  *
+ *  Modified 14 Jan 2006 Volker Kuhlmann <coding,top.geek.nz>
+ *    - 32 bit binary compatibility on AMD64 for read()/write() sg_io_hdr.
+ *
  * This program is free software; you can redistribute it and/or modify
  * it under the terms of the GNU General Public License as published by
  * the Free Software Foundation; either version 2, or (at your option)
@@ -18,8 +21,8 @@
  *
  */
 
-static int sg_version_num = 30533;	/* 2 digits for each component */
-#define SG_VERSION_STR "3.5.33"
+static int sg_version_num = 30534;	/* 2 digits for each component */
+#define SG_VERSION_STR "3.5.34"
 
 /*
  *  D. P. Gilbert (dgilbert@interlog.com, dougg@triode.net.au), notes:
@@ -49,6 +52,7 @@
 #include <linux/seq_file.h>
 #include <linux/blkdev.h>
 #include <linux/delay.h>
+#include <linux/compat.h>
 
 #include "scsi.h"
 #include <scsi/scsi_dbg.h>
@@ -61,7 +65,7 @@
 
 #ifdef CONFIG_SCSI_PROC_FS
 #include <linux/proc_fs.h>
-static char *sg_version_date = "20050328";
+static char *sg_version_date = "20060114";
 
 static int sg_proc_init(void);
 static void sg_proc_cleanup(void);
@@ -176,6 +180,41 @@
 	struct cdev * cdev;	/* char_dev [sysfs: /sys/cdev/major/sg<n>] */
 } Sg_device;
 
+/* Replication of struct sg_io_hdr from scsi/sg.h, but with the memory layout
+   of a x86 32 bit architecture, even when compiled on AMD64 64 bit.
+   THIS MUST ALWAYS MATCH a (32 bit architecture) struct sg_io_hdr!!!
+*/
+typedef struct sg_io_hdr32
+{
+    int interface_id;           /* [i] 'S' for SCSI generic (required) */
+    int dxfer_direction;        /* [i] data transfer direction  */
+    unsigned char cmd_len;      /* [i] SCSI command length ( <= 16 bytes) */
+    unsigned char mx_sb_len;    /* [i] max length to write to sbp */
+    unsigned short iovec_count; /* [i] 0 implies no scatter gather */
+    unsigned int dxfer_len;     /* [i] byte count of data transfer */
+    // 16 bytes
+    signed int dxferp; /* pointers are only 4 bytes */
+    signed int cmdp;   /* " */
+    signed int sbp;    /* " */
+    // 12 bytes
+    unsigned int timeout;       /* [i] MAX_UINT->no timeout (unit: millisec) */
+    unsigned int flags;         /* [i] 0 -> default, see SG_FLAG... */
+    int pack_id;                /* [i->o] unused internally (normally) */
+    // 12 bytes
+    signed int usr_ptr; /* pointers are only 4 bytes */
+    // 4 bytes
+    unsigned char status;       /* [o] scsi status */
+    unsigned char masked_status;/* [o] shifted, masked scsi status */
+    unsigned char msg_status;   /* [o] messaging level data (optional) */
+    unsigned char sb_len_wr;    /* [o] byte count actually written to sbp */
+    unsigned short host_status; /* [o] errors from host adapter */
+    unsigned short driver_status;/* [o] errors from software driver */
+    int resid;                  /* [o] dxfer_len - actual_transferred */
+    unsigned int duration;      /* [o] time taken by cmd (unit: millisec) */
+    unsigned int info;          /* [o] auxiliary information */
+    // 20 bytes
+} sg_io_hdr32_t;  /* 64 bytes long (on x86_64!) */
+
 static int sg_fasync(int fd, struct file *filp, int mode);
 static void sg_cmd_done(Scsi_Cmnd * SCpnt);	/* tasklet or soft irq callback */
 static int sg_start_req(Sg_request * srp);
@@ -214,6 +253,8 @@
 #ifdef CONFIG_SCSI_PROC_FS
 static int sg_last_dev(void);
 #endif
+static inline void copy_hdr32_64 (sg_io_hdr_t * new, sg_io_hdr32_t * hdr);
+static inline void copy_64_hdr32 (sg_io_hdr32_t * new, sg_io_hdr_t * hdr);
 
 static Sg_device **sg_dev_arr = NULL;
 static int sg_dev_max;
@@ -221,6 +262,7 @@
 
 #define SZ_SG_HEADER sizeof(struct sg_header)
 #define SZ_SG_IO_HDR sizeof(sg_io_hdr_t)
+#define SZ_SG_IO32_HDR sizeof(sg_io_hdr32_t)
 #define SZ_SG_IOVEC sizeof(sg_iovec_t)
 #define SZ_SG_REQ_INFO sizeof(sg_req_info_t)
 
@@ -480,6 +522,32 @@
 	return retval;
 }
 
+/* Copy a sg_io_hdr32_t (32 bit) to a sg_io_hdr_t (64 bit layout).
+   This must always match struct sg_io_hdr! */
+static inline void
+copy_hdr32_64 (sg_io_hdr_t * new, sg_io_hdr32_t * hdr) {
+	/* memcpy(new, hdr, 16);  already copied when this function is called */
+	new->dxferp = compat_ptr(hdr->dxferp);
+	new->cmdp = compat_ptr(hdr->cmdp);
+	new->sbp = compat_ptr(hdr->sbp);
+	memcpy(&(new->timeout), &(hdr->timeout), 12);
+	new->usr_ptr = compat_ptr(hdr->usr_ptr);
+	memcpy(&(new->status), &(hdr->status), 20);
+}
+
+/* Copy a sg_io_hdr_t (64 bit layout) to a sg_io_hdr32_t (32 bit).
+   This must always match struct sg_io_hdr! */
+static inline void
+copy_64_hdr32 (sg_io_hdr32_t * new, sg_io_hdr_t * hdr) {
+	/* memcpy(new, hdr, 16);  already copied when this function is called */
+	new->dxferp = ptr_to_compat(hdr->dxferp);
+	new->cmdp = ptr_to_compat(hdr->cmdp);
+	new->sbp = ptr_to_compat(hdr->sbp);
+	memcpy(&(new->timeout), &(hdr->timeout), 12);
+	new->usr_ptr = ptr_to_compat(hdr->usr_ptr);
+	memcpy(&(new->status), &(hdr->status), 20);
+}
+
 static ssize_t
 sg_new_read(Sg_fd * sfp, char __user *buf, size_t count, Sg_request * srp)
 {
@@ -487,7 +555,7 @@
 	int err = 0;
 	int len;
 
-	if (count < SZ_SG_IO_HDR) {
+	if (count < SZ_SG_IO_HDR && count != SZ_SG_IO32_HDR) {
 		err = -EINVAL;
 		goto err_out;
 	}
@@ -508,9 +576,17 @@
 	}
 	if (hp->masked_status || hp->host_status || hp->driver_status)
 		hp->info |= SG_INFO_CHECK;
-	if (copy_to_user(buf, hp, SZ_SG_IO_HDR)) {
-		err = -EFAULT;
-		goto err_out;
+	if (count == SZ_SG_IO_HDR) {
+		if (copy_to_user(buf, hp, SZ_SG_IO_HDR)) {
+			err = -EFAULT;
+			goto err_out;
+		}
+	} else {
+		if (copy_to_user(buf, hp, 16)) {/* copy 4 bytes for error checking */
+			err = -EFAULT;
+			goto err_out;
+		}
+		copy_64_hdr32((sg_io_hdr32_t *) buf, hp);
 	}
 	err = sg_read_xfer(srp);
       err_out:
@@ -632,7 +708,7 @@
 	int timeout;
 	unsigned long ul_timeout;
 
-	if (count < SZ_SG_IO_HDR)
+	if (count < SZ_SG_IO_HDR && count != SZ_SG_IO32_HDR)
 		return -EINVAL;
 	if (!access_ok(VERIFY_READ, buf, count))
 		return -EFAULT; /* protects following copy_from_user()s + get_user()s */
@@ -643,9 +719,17 @@
 		return -EDOM;
 	}
 	hp = &srp->header;
-	if (__copy_from_user(hp, buf, SZ_SG_IO_HDR)) {
-		sg_remove_request(sfp, srp);
-		return -EFAULT;
+	if (count == SZ_SG_IO_HDR) {
+		if (__copy_from_user(hp, buf, SZ_SG_IO_HDR)) {
+			sg_remove_request(sfp, srp);
+			return -EFAULT;
+		}
+	} else {
+		if (__copy_from_user(hp, buf, 16)) {/* copy 4 bytes for error checking */
+			sg_remove_request(sfp, srp);
+			return -EFAULT;
+		}
+		copy_hdr32_64(hp, (sg_io_hdr32_t *) buf);
 	}
 	if (hp->interface_id != 'S') {
 		sg_remove_request(sfp, srp);



-- 
Volker Kuhlmann			is possibly list0570 with the domain in header
http://volker.dnsalias.net/		Please do not CC list postings to me.
