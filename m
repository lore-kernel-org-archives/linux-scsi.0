From: Christoph Hellwig <hch@lst.de>
Subject: [PATCH] ifdef out broken fc4 EH code
Date: Mon, 27 Jun 2005 22:43:06 +0200
Message-ID: <20050627204306.GA20086@lst.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from verein.lst.de ([213.95.11.210]:10374 "EHLO mail.lst.de")
	by vger.kernel.org with ESMTP id S261750AbVF0UnU (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Mon, 27 Jun 2005 16:43:20 -0400
Content-Disposition: inline
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: jejb@steeleye.com
Cc: linux-scsi@vger.kernel.org

This code pokes deep into EH internals and duplicates scsi_error.c code
wrongly.  It doesn't compile anymore in scsi-misc, so let's #if 0 out
the code - the driver hasn't worked for more than five years anyway.


Index: linux-2.6/drivers/fc4/fc.c
===================================================================
--- linux-2.6.orig/drivers/fc4/fc.c	2005-06-26 13:26:22.000000000 +0200
+++ linux-2.6/drivers/fc4/fc.c	2005-06-27 22:41:10.000000000 +0200
@@ -365,6 +365,7 @@
 			kfree (fc->scsi_bitmap);
 			kfree (fc->cmd_slots);
 			FCND(("Unregistering\n"));
+#if 0
 			if (fc->rst_pkt) {
 				if (fc->rst_pkt->eh_state == SCSI_STATE_UNUSED)
 					kfree(fc->rst_pkt);
@@ -373,6 +374,7 @@
 					printk("FC: Reset in progress. Now?!");
 				}
 			}
+#endif
 			FCND(("Unregistered\n"));
 		}
 	} else
@@ -915,6 +917,7 @@
 	}
 }
 
+#if 0
 void fcp_scsi_reset_done(Scsi_Cmnd *SCpnt)
 {
 	fc_channel *fc = FC_SCMND(SCpnt);
@@ -922,11 +925,13 @@
 	fc->rst_pkt->eh_state = SCSI_STATE_FINISHED;
 	up(fc->rst_pkt->device->host->eh_action);
 }
+#endif
 
 #define FCP_RESET_TIMEOUT (2*HZ)
 
 int fcp_scsi_dev_reset(Scsi_Cmnd *SCpnt)
 {
+#if 0 /* broken junk, but if davem wants to compile this driver, let him.. */
 	unsigned long flags;
 	fcp_cmd *cmd;
 	fcp_cmnd *fcmd;
@@ -1000,6 +1005,7 @@
 	}
 	fc->rst_pkt->eh_state = SCSI_STATE_UNUSED;
 	return SUCCESS;
+#endif
 }
 
 static int __fcp_scsi_host_reset(Scsi_Cmnd *SCpnt)
