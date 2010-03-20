From: Douglas Gilbert <dgilbert@interlog.com>
Subject: [PATCH] sg: retrofit SG_FLAG_Q_AT_TAIL flag
Date: Sat, 20 Mar 2010 15:15:02 -0400
Message-ID: <4BA51EB6.5040401@interlog.com>
Reply-To: dgilbert@interlog.com
Mime-Version: 1.0
Content-Type: multipart/mixed;
 boundary="------------020106070306000300040209"
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from smtp.infotech.no ([82.134.31.41]:54053 "EHLO elrond.infotech.no"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751329Ab0CTTPK (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Sat, 20 Mar 2010 15:15:10 -0400
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James Bottomley <James.Bottomley@suse.de>, SCSI development list <linux-scsi@vger.kernel.org>
Cc: mh-linux-kernel@loup.net

This is a multi-part message in MIME format.
--------------020106070306000300040209
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit

In response to
    http://bugzilla.kernel.org/show_bug.cgi?id=15565
and the fact this capability has been present
in bsg for some time, add SG_FLAG_Q_AT_TAIL flag. It has
the same binary value as the bsg flag and the define name
is the same apart from the leading "B". The semantics are
the same, namely to override the default queue at head
action of the SCSI midlevel when a low level driver
blocks (i.e. when a LLD returns non-zero to a
queuecommand() ). Tested with scsi_debug.

Changelog
   - add SG_FLAG_Q_AT_TAIL flag to override default
     queue at head semantics of the SCSI midlevel queue.

Signed-off-by: Douglas Gilbert <dgilbert@interlog.com>

--------------020106070306000300040209
Content-Type: text/x-patch;
 name="sg2633qat1.patch"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline;
 filename="sg2633qat1.patch"

--- linux/include/scsi/sg.h	2008-10-10 17:04:54.000000000 -0400
+++ linux/include/scsi/sg.h2633qat1	2010-03-20 14:28:31.000000000 -0400
@@ -11,9 +11,9 @@
 Original driver (sg.h):
 *       Copyright (C) 1992 Lawrence Foard
 Version 2 and 3 extensions to driver:
-*       Copyright (C) 1998 - 2006 Douglas Gilbert
+*       Copyright (C) 1998 - 2010 Douglas Gilbert
 
-    Version: 3.5.34 (20060920)
+    Version: 3.5.35 (20100319)
     This version is for 2.6 series kernels.
 
     For a full changelog see http://www.torque.net/sg
@@ -124,6 +124,7 @@
 #define SG_FLAG_UNUSED_LUN_INHIBIT 2   /* default is overwrite lun in SCSI */
 				/* command block (when <= SCSI_2) */
 #define SG_FLAG_MMAP_IO 4       /* request memory mapped IO */
+#define SG_FLAG_Q_AT_TAIL 0x10  /* default, without this flag, is Q_AT_HEAD */
 #define SG_FLAG_NO_DXFER 0x10000 /* no transfer of kernel buffers to/from */
 				/* user space (debug indirect IO) */
 
--- linux/drivers/scsi/sg.c	2009-12-03 11:11:18.000000000 -0500
+++ linux/drivers/scsi/sg.c2633qat1	2010-03-19 19:42:10.000000000 -0400
@@ -18,8 +18,8 @@
  *
  */
 
-static int sg_version_num = 30534;	/* 2 digits for each component */
-#define SG_VERSION_STR "3.5.34"
+static int sg_version_num = 30535;	/* 2 digits for each component */
+#define SG_VERSION_STR "3.5.35"
 
 /*
  *  D. P. Gilbert (dgilbert@interlog.com, dougg@triode.net.au), notes:
@@ -61,7 +61,7 @@
 
 #ifdef CONFIG_SCSI_PROC_FS
 #include <linux/proc_fs.h>
-static char *sg_version_date = "20061027";
+static char *sg_version_date = "20100319";
 
 static int sg_proc_init(void);
 static void sg_proc_cleanup(void);
@@ -710,8 +710,11 @@
 	int k, data_dir;
 	Sg_device *sdp = sfp->parentdp;
 	sg_io_hdr_t *hp = &srp->header;
+	int at_head = 1;
 
 	srp->data.cmd_opcode = cmnd[0];	/* hold opcode of command */
+	if ('\0' != hp->interface_id)	/* old interface misuses flags */
+		at_head = (SG_FLAG_Q_AT_TAIL & hp->flags) ? 0 : 1;
 	hp->status = 0;
 	hp->masked_status = 0;
 	hp->msg_status = 0;
@@ -753,7 +756,7 @@
 	srp->rq->timeout = timeout;
 	kref_get(&sfp->f_ref); /* sg_rq_end_io() does kref_put(). */
 	blk_execute_rq_nowait(sdp->device->request_queue, sdp->disk,
-			      srp->rq, 1, sg_rq_end_io);
+			      srp->rq, at_head, sg_rq_end_io);
 	return 0;
 }
 

--------------020106070306000300040209--
