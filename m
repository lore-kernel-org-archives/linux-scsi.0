From: Douglas Gilbert <dgilbert@interlog.com>
Subject: [PATCH] sg + block/scsi_ioctl: Q_AT_HEAD and Q_AT_TAIL
Date: Thu, 25 Mar 2010 17:28:18 -0400
Message-ID: <4BABD572.8000709@interlog.com>
Reply-To: dgilbert@interlog.com
Mime-Version: 1.0
Content-Type: multipart/mixed;
 boundary="------------080303040304000205060805"
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from smtp.infotech.no ([82.134.31.41]:38060 "EHLO elrond.infotech.no"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751787Ab0CYV3K (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Thu, 25 Mar 2010 17:29:10 -0400
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James Bottomley <James.Bottomley@suse.de>, SCSI development list <linux-scsi@vger.kernel.org>
Cc: mh-linux-kernel@loup.net, Jens Axboe <jens.axboe@oracle.com>

This is a multi-part message in MIME format.
--------------080303040304000205060805
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit

This is a replacement and extension of the patch
titled:
"[PATCH] sg: retrofit SG_FLAG_Q_AT_TAIL flag"

The aim is to give control over midlevel queuing
when commands are submitted via the sg, bsg and
the block layer SG_IO ioctl pass-throughs. The
current defaults remain: sg and bsg queue at_head
while the block layer SG_IO ioctl queues at_tail .
This patch allows user space programs that care to
override the default queuing for the sg driver and
the block layer SG_IO ioctl. The bsg driver already
has this capability.

This patch is against lk 2.6.33

Changelog
   - add SG_FLAG_Q_AT_TAIL and add SG_FLAG_Q_AT_HEAD
     flags to sg.h
   - act on these flags in the sg driver and the
     block layer SG_IO ioctl
   - correct stale urls in the sg driver code

Signed-off-by: Douglas Gilbert <dgilbert@interlog.com>

--------------080303040304000205060805
Content-Type: text/x-patch;
 name="sg2633qat2.patch"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline;
 filename="sg2633qat2.patch"

--- linux/include/scsi/sg.h	2008-10-10 17:04:54.000000000 -0400
+++ linux/include/scsi/sg.h2633qat2	2010-03-23 18:58:28.000000000 -0400
@@ -11,12 +11,12 @@
 Original driver (sg.h):
 *       Copyright (C) 1992 Lawrence Foard
 Version 2 and 3 extensions to driver:
-*       Copyright (C) 1998 - 2006 Douglas Gilbert
+*       Copyright (C) 1998 - 2010 Douglas Gilbert
 
-    Version: 3.5.34 (20060920)
+    Version: 3.5.35 (20100323)
     This version is for 2.6 series kernels.
 
-    For a full changelog see http://www.torque.net/sg
+    For a full changelog see http://sg.danny.cz/sg
 
 Map of SG verions to the Linux kernels in which they appear:
        ----------        ----------------------------------
@@ -52,17 +52,17 @@
  Documentation
  =============
  A web site for the SG device driver can be found at:
-	http://www.torque.net/sg  [alternatively check the MAINTAINERS file]
+	http://sg.danny.cz/sg  [alternatively check the MAINTAINERS file]
  The documentation for the sg version 3 driver can be found at:
- 	http://www.torque.net/sg/p/sg_v3_ho.html
+ 	http://sg.danny.cz/sg/p/sg_v3_ho.html
  This is a rendering from DocBook source [change the extension to "sgml"
  or "xml"]. There are renderings in "ps", "pdf", "rtf" and "txt" (soon).
  The SG_IO ioctl is now found in other parts kernel (e.g. the block layer).
- For more information see http://www.torque.net/sg/sg_io.html
+ For more information see http://sg.danny.cz/sg/sg_io.html
 
  The older, version 2 documents discuss the original sg interface in detail:
-	http://www.torque.net/sg/p/scsi-generic.txt
-	http://www.torque.net/sg/p/scsi-generic_long.txt
+	http://sg.danny.cz/sg/p/scsi-generic.txt
+	http://sg.danny.cz/sg/p/scsi-generic_long.txt
  Also available: <kernel_source>/Documentation/scsi/scsi-generic.txt
 
  Utility and test programs are available at the sg web site. They are 
@@ -124,6 +124,9 @@
 #define SG_FLAG_UNUSED_LUN_INHIBIT 2   /* default is overwrite lun in SCSI */
 				/* command block (when <= SCSI_2) */
 #define SG_FLAG_MMAP_IO 4       /* request memory mapped IO */
+/* If initiator cannot take command, midlevel queue discipline override */
+#define SG_FLAG_Q_AT_TAIL 0x10  /* default action of block layer SG_IO */
+#define SG_FLAG_Q_AT_HEAD 0x20  /* default action of sg and bsg drivers */
 #define SG_FLAG_NO_DXFER 0x10000 /* no transfer of kernel buffers to/from */
 				/* user space (debug indirect IO) */
 
--- linux/drivers/scsi/sg.c	2009-12-03 11:11:18.000000000 -0500
+++ linux/drivers/scsi/sg.c2633qat2	2010-03-23 21:09:05.000000000 -0400
@@ -7,7 +7,7 @@
  * Original driver (sg.c):
  *        Copyright (C) 1992 Lawrence Foard
  * Version 2 and 3 extensions to driver:
- *        Copyright (C) 1998 - 2005 Douglas Gilbert
+ *        Copyright (C) 1998 - 2010 Douglas Gilbert
  *
  *  Modified  19-JAN-1998  Richard Gooch <rgooch@atnf.csiro.au>  Devfs support
  *
@@ -18,8 +18,8 @@
  *
  */
 
-static int sg_version_num = 30534;	/* 2 digits for each component */
-#define SG_VERSION_STR "3.5.34"
+static int sg_version_num = 30535;	/* 2 digits for each component */
+#define SG_VERSION_STR "3.5.35"
 
 /*
  *  D. P. Gilbert (dgilbert@interlog.com, dougg@triode.net.au), notes:
@@ -61,7 +61,7 @@ static int sg_version_num = 30534;	/* 2 
 
 #ifdef CONFIG_SCSI_PROC_FS
 #include <linux/proc_fs.h>
-static char *sg_version_date = "20061027";
+static char *sg_version_date = "20100323";
 
 static int sg_proc_init(void);
 static void sg_proc_cleanup(void);
@@ -710,8 +710,15 @@ sg_common_write(Sg_fd * sfp, Sg_request 
 	int k, data_dir;
 	Sg_device *sdp = sfp->parentdp;
 	sg_io_hdr_t *hp = &srp->header;
+	int at_head = 1;	/* current default: Q_AT_HEAD */
 
 	srp->data.cmd_opcode = cmnd[0];	/* hold opcode of command */
+	if ('\0' != hp->interface_id) {	/* old interface misuses flags */
+		if (SG_FLAG_Q_AT_TAIL & hp->flags)
+			at_head = 0;
+		if (SG_FLAG_Q_AT_HEAD & hp->flags)
+			at_head = 1;
+	}
 	hp->status = 0;
 	hp->masked_status = 0;
 	hp->msg_status = 0;
@@ -753,7 +760,7 @@ sg_common_write(Sg_fd * sfp, Sg_request 
 	srp->rq->timeout = timeout;
 	kref_get(&sfp->f_ref); /* sg_rq_end_io() does kref_put(). */
 	blk_execute_rq_nowait(sdp->device->request_queue, sdp->disk,
-			      srp->rq, 1, sg_rq_end_io);
+			      srp->rq, at_head, sg_rq_end_io);
 	return 0;
 }
 
--- linux/block/scsi_ioctl.c	2010-02-26 12:27:51.000000000 -0500
+++ linux/block/scsi_ioctl.c2633qat2	2010-03-23 21:15:40.000000000 -0400
@@ -288,11 +288,16 @@ static int sg_io(struct request_queue *q
 	struct request *rq;
 	char sense[SCSI_SENSE_BUFFERSIZE];
 	struct bio *bio;
+	int at_head = 0;	/* existing default was q_at_tail */
 
 	if (hdr->interface_id != 'S')
 		return -EINVAL;
 	if (hdr->cmd_len > BLK_MAX_CDB)
 		return -EINVAL;
+	if (hdr->flags & SG_FLAG_Q_AT_HEAD)
+		at_head = 1;
+	if (hdr->flags & SG_FLAG_Q_AT_TAIL) 
+		at_head = 0;
 
 	if (hdr->dxfer_len > (queue_max_hw_sectors(q) << 9))
 		return -EIO;
@@ -367,7 +372,7 @@ static int sg_io(struct request_queue *q
 	 * (if he doesn't check that is his problem).
 	 * N.B. a non-zero SCSI status is _not_ necessarily an error.
 	 */
-	blk_execute_rq(q, bd_disk, rq, 0);
+	blk_execute_rq(q, bd_disk, rq, at_head);
 
 	hdr->duration = jiffies_to_msecs(jiffies - start_time);
 

--------------080303040304000205060805--
