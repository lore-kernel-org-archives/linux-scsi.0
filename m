From: "J.E.J. Bottomley" <James.Bottomley@steeleye.com>
Subject: Re: [PATCH] fix 2.5 scsi queue depth setting
Date: Wed, 06 Nov 2002 12:47:28 -0500
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <200211061747.gA6HlS803188@localhost.localdomain>
References: <patmans@us.ibm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: (from root@localhost)
	by pogo.mtv1.steeleye.com (8.9.3/8.9.3) id JAA26696
	for <linux-scsi@vger.kernel.org>; Wed, 6 Nov 2002 09:47:36 -0800
In-Reply-To: Message from Patrick Mansfield <patmans@us.ibm.com>
   of "Tue, 05 Nov 2002 20:24:17 PST." <20021105202417.A26520@eng2.beaverton.ibm.com>
List-Id: linux-scsi@vger.kernel.org
To: Patrick Mansfield <patmans@us.ibm.com>
Cc: James Bottomley <James.Bottomley@SteelEye.com>, Christoph Hellwig <hch@lst.de>, linux-scsi@vger.kernel.org

This is what I think needs to be done to the patch, does this look OK?

James
===== drivers/scsi/scsi.c 1.55 vs edited =====
--- 1.55/drivers/scsi/scsi.c	Tue Nov  5 14:05:10 2002
+++ edited/drivers/scsi/scsi.c	Wed Nov  6 11:33:16 2002
@@ -2019,6 +2019,13 @@
 		/*
 		 * No one was attached.
 		 */
+		scsi_build_commandblocks(sdev);
+		if (sdev->current_queue_depth == 0) {
+			printk(KERN_ERR "scsi: Allocation failure during"
+			       " attach, some SCSI devices might not be"
+			       " configured\n");
+			return 1;
+		}
 		if ((sdev->host->hostt->slave_attach != NULL) &&
 		    (sdev->host->hostt->slave_attach(sdev) != 0)) {
 			printk(KERN_INFO "scsi: failed low level driver"
@@ -2030,15 +2037,6 @@
 		    (sdev->host->cmd_per_lun != 0))
 			scsi_adjust_queue_depth(sdev, 0,
 						sdev->host->cmd_per_lun);
-		scsi_build_commandblocks(sdev);
-		if (sdev->current_queue_depth == 0) {
-			printk(KERN_ERR "scsi: Allocation failure during"
-			       " attach, some SCSI devices might not be"
-			       " configured\n");
-			if (sdev->host->hostt->slave_detach != NULL)
-				sdev->host->hostt->slave_detach(sdev);
-			return 1;
-		}
 	}
 	return 0;
 }
===== drivers/scsi/scsi_syms.c 1.17 vs edited =====
--- 1.17/drivers/scsi/scsi_syms.c	Mon Nov  4 15:55:09 2002
+++ edited/drivers/scsi/scsi_syms.c	Wed Nov  6 11:33:58 2002
@@ -82,6 +82,8 @@
 
 EXPORT_SYMBOL(scsi_register_blocked_host);
 EXPORT_SYMBOL(scsi_deregister_blocked_host);
+EXPORT_SYMBOL(scsi_slave_attach);
+EXPORT_SYMBOL(scsi_slave_detach);
 
 /*
  * This symbol is for the highlevel drivers (e.g. sg) only.


