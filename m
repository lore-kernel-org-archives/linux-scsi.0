From: Christoph Hellwig <hch@lst.de>
Subject: [PATCH] remove RQ_SCSI_* flags
Date: Sat, 10 Jun 2006 18:37:19 +0200
Message-ID: <20060610163719.GA12421@lst.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from verein.lst.de ([213.95.11.210]:30172 "EHLO mail.lst.de")
	by vger.kernel.org with ESMTP id S1030441AbWFJQhW (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Sat, 10 Jun 2006 12:37:22 -0400
Content-Disposition: inline
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: jejb@steeleye.com, axboe@suse.de
Cc: linux-scsi@vger.kernel.org

The RQ_SCSI_* flags are a vestiage of a long past history.  The EH code
still sets them but we never make use of that information.  The other
users is pluto.c which never had a chance to work but needs to be kept
compiling to keep Davem happy, so copy over the definition there.

We could probably get rid of RQ_ACTIVE/RQ_INACTIVE aswell with some
work, there's only two more or less bogus looking uses in ubd and scsi.


Signed-off-by: Christoph Hellwig <hch@lst.de>

Index: scsi-misc-2.6/drivers/scsi/pluto.c
===================================================================
--- scsi-misc-2.6.orig/drivers/scsi/pluto.c	2006-06-02 18:20:23.000000000 +0200
+++ scsi-misc-2.6/drivers/scsi/pluto.c	2006-06-10 18:24:24.000000000 +0200
@@ -27,6 +27,9 @@
 
 #include <linux/module.h>
 
+#define RQ_SCSI_BUSY		0xffff
+#define RQ_SCSI_DONE		0xfffe
+
 /* #define PLUTO_DEBUG */
 
 #define pluto_printk printk ("PLUTO %s: ", fc->name); printk
Index: scsi-misc-2.6/drivers/scsi/scsi_error.c
===================================================================
--- scsi-misc-2.6.orig/drivers/scsi/scsi_error.c	2006-06-10 18:19:38.000000000 +0200
+++ scsi-misc-2.6/drivers/scsi/scsi_error.c	2006-06-10 18:35:02.000000000 +0200
@@ -452,7 +452,6 @@
 			(sdev->lun << 5 & 0xe0);
 
 	shost->eh_action = &done;
-	scmd->request->rq_status = RQ_SCSI_BUSY;
 
 	spin_lock_irqsave(shost->host_lock, flags);
 	scsi_log_send(scmd);
@@ -461,7 +460,6 @@
 
 	timeleft = wait_for_completion_timeout(&done, timeout);
 
-	scmd->request->rq_status = RQ_SCSI_DONE;
 	shost->eh_action = NULL;
 
 	scsi_log_completion(scmd, SUCCESS);
@@ -1657,7 +1655,6 @@
 
 	scmd->request = &req;
 	memset(&scmd->eh_timeout, 0, sizeof(scmd->eh_timeout));
-	scmd->request->rq_status      	= RQ_SCSI_BUSY;
 
 	memset(&scmd->cmnd, '\0', sizeof(scmd->cmnd));
     
Index: scsi-misc-2.6/include/linux/blkdev.h
===================================================================
--- scsi-misc-2.6.orig/include/linux/blkdev.h	2006-06-02 18:20:35.000000000 +0200
+++ scsi-misc-2.6/include/linux/blkdev.h	2006-06-10 18:24:27.000000000 +0200
@@ -439,9 +439,6 @@
 
 #define RQ_INACTIVE		(-1)
 #define RQ_ACTIVE		1
-#define RQ_SCSI_BUSY		0xffff
-#define RQ_SCSI_DONE		0xfffe
-#define RQ_SCSI_DISCONNECTING	0xffe0
 
 #define QUEUE_FLAG_CLUSTER	0	/* cluster several segments into 1 */
 #define QUEUE_FLAG_QUEUED	1	/* uses generic tag queueing */
