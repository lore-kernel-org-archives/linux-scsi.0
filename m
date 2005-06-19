From: Christoph Hellwig <hch@lst.de>
Subject: [PATCH] megaraid: fix compilation after eh locking changes
Date: Sun, 19 Jun 2005 13:38:14 +0200
Message-ID: <20050619113814.GA18801@lst.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from verein.lst.de ([213.95.11.210]:5548 "EHLO mail.lst.de")
	by vger.kernel.org with ESMTP id S262243AbVFSLiR (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Sun, 19 Jun 2005 07:38:17 -0400
Content-Disposition: inline
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: jejb@steeleye.com
Cc: linux-scsi@vger.kernel.org


Index: linux-2.6/drivers/scsi/megaraid.c
===================================================================
--- linux-2.6.orig/drivers/scsi/megaraid.c	2005-06-19 12:29:53.000000000 +0200
+++ linux-2.6/drivers/scsi/megaraid.c	2005-06-19 12:31:24.000000000 +0200
@@ -1939,7 +1939,7 @@
 
 
 static int
-__megaraid_reset(Scsi_Cmnd *cmd)
+megaraid_reset(struct scsi_cmnd *cmd)
 {
 	adapter_t	*adapter;
 	megacmd_t	mc;
@@ -1951,7 +1951,6 @@
 	mc.cmd = MEGA_CLUSTER_CMD;
 	mc.opcode = MEGA_RESET_RESERVATIONS;
 
-	spin_unlock_irq(&adapter->lock);
 	if( mega_internal_command(adapter, LOCK_INT, &mc, NULL) != 0 ) {
 		printk(KERN_WARNING
 				"megaraid: reservation reset failed.\n");
@@ -1959,9 +1958,10 @@
 	else {
 		printk(KERN_INFO "megaraid: reservation reset.\n");
 	}
-	spin_lock_irq(&adapter->lock);
 #endif
 
+	spin_lock_irq(&adapter->lock);
+
 	rval =  megaraid_abort_and_reset(adapter, cmd, SCB_RESET);
 
 	/*
@@ -1970,23 +1970,10 @@
 	 */
 	mega_rundoneq(adapter);
 
-	return rval;
-}
-
-static int
-megaraid_reset(Scsi_Cmnd *cmd)
-{
-	adapter = (adapter_t *)cmd->device->host->hostdata;
-	int rc;
-
-	spin_lock_irq(&adapter->lock);
-	rc = __megaraid_reset(cmd);
 	spin_unlock_irq(&adapter->lock);
-
-	return rc;
+	return rval;
 }
 
-
 /**
  * megaraid_abort_and_reset()
  * @adapter - megaraid soft state
