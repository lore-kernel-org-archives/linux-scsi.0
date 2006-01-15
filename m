From: Volker Kuhlmann <list0570@paradise.net.nz>
Subject: Re: [PATCH] sg_io_hdr 32 bit binary compatibility on AMD64
Date: Sun, 15 Jan 2006 19:57:52 +1300
Message-ID: <20060115065752.GE12885@paradise.net.nz>
References: <20060113220854.GD12885@paradise.net.nz>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from 203-79-122-66.cable.paradise.net.nz ([203.79.122.66]:9243 "EHLO
	kereru.site") by vger.kernel.org with ESMTP id S1751870AbWAOG6C
	(ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Sun, 15 Jan 2006 01:58:02 -0500
Received: from kereru.site (localhost [127.0.0.1])
	by kereru.site (8.13.4/8.13.4/SuSE Linux 0.7) with ESMTP id k0F6vqN3016320
	for <linux-scsi@vger.kernel.org>; Sun, 15 Jan 2006 19:57:55 +1300
Received: (from volker@localhost)
	by kereru.site (8.13.4/8.13.4/Submit) id k0F6vqsP016319
	for linux-scsi@vger.kernel.org; Sun, 15 Jan 2006 19:57:52 +1300
Content-Disposition: inline
In-Reply-To: <20060113220854.GD12885@paradise.net.nz>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org

Same patch but applied to 2.6.15-git10.

> Purpose of this patch: establish binary compatibility with 32 bit x86 code on
> AMD64 64 bit kernels, in the use of struct sg_io_hdr via write()/read() calls.
> Currently this binary compatibility only exists with ioctl().
> 32bit applications which use or are linked with sanei_scsi.c of the SANE project
> (sane-project.org) need this patch.

> Signed-off-by: Volker Kuhlmann <VolkerKuhlmann.gmx.de>
> 13 Jan 2006

--- drivers/scsi/sg.c.orig	2006-01-15 19:29:03.000000000 +1300
+++ drivers/scsi/sg.c	2006-01-15 19:44:24.000000000 +1300
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
@@ -50,6 +53,7 @@
 #include <linux/blkdev.h>
 #include <linux/delay.h>
 #include <linux/scatterlist.h>
+#include <linux/compat.h>
 
 #include "scsi.h"
 #include <scsi/scsi_dbg.h>
@@ -170,6 +174,41 @@
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
 /* tasklet or soft irq callback */
 static void sg_cmd_done(void *data, char *sense, int result, int resid);
@@ -208,6 +247,8 @@
 #ifdef CONFIG_SCSI_PROC_FS
 static int sg_last_dev(void);
 #endif
+static inline void copy_hdr32_64 (sg_io_hdr_t * new, sg_io_hdr32_t * hdr);
+static inline void copy_64_hdr32 (sg_io_hdr32_t * new, sg_io_hdr_t * hdr);
 
 static Sg_device **sg_dev_arr = NULL;
 static int sg_dev_max;
@@ -215,6 +256,7 @@
 
 #define SZ_SG_HEADER sizeof(struct sg_header)
 #define SZ_SG_IO_HDR sizeof(sg_io_hdr_t)
+#define SZ_SG_IO32_HDR sizeof(sg_io_hdr32_t)
 #define SZ_SG_IOVEC sizeof(sg_iovec_t)
 #define SZ_SG_REQ_INFO sizeof(sg_req_info_t)
 
@@ -477,6 +519,32 @@
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
@@ -484,7 +552,7 @@
 	int err = 0;
 	int len;
 
-	if (count < SZ_SG_IO_HDR) {
+	if (count < SZ_SG_IO_HDR && count != SZ_SG_IO32_HDR) {
 		err = -EINVAL;
 		goto err_out;
 	}
@@ -505,9 +573,17 @@
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
@@ -629,7 +705,7 @@
 	int timeout;
 	unsigned long ul_timeout;
 
-	if (count < SZ_SG_IO_HDR)
+	if (count < SZ_SG_IO_HDR && count != SZ_SG_IO32_HDR)
 		return -EINVAL;
 	if (!access_ok(VERIFY_READ, buf, count))
 		return -EFAULT; /* protects following copy_from_user()s + get_user()s */
@@ -640,9 +716,17 @@
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
