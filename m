From: Christoph Hellwig <hch@lst.de>
Subject: [PATCH][2.5] avoid scsi_assign_lock in megaraid
Date: Tue, 24 Jun 2003 14:09:42 +0200
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <20030624120942.GA30538@lst.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from verein.lst.de ([212.34.189.10]:22431 "EHLO mail.lst.de")
	by vger.kernel.org with ESMTP id S262023AbTFXLzk (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Tue, 24 Jun 2003 07:55:40 -0400
Content-Disposition: inline
List-Id: linux-scsi@vger.kernel.org
To: Atul.Mukker@lsil.com
Cc: linux-scsi@vger.kernel.org

Use the default scsi host_lock directly instead of assigning host_lock
to a per-HBA lock that isn't used otherwise.

Atul, can you try to forward this to James quickly as I have other
patches depending on this one?


diff -Nru a/drivers/scsi/megaraid.c b/drivers/scsi/megaraid.c
--- a/drivers/scsi/megaraid.c	Mon Jun 23 11:03:07 2003
+++ b/drivers/scsi/megaraid.c	Mon Jun 23 11:03:07 2003
@@ -32,15 +32,16 @@
 
 #include <linux/mm.h>
 #include <linux/fs.h>
-#include <linux/blk.h>
-#include <asm/uaccess.h>
-#include <asm/io.h>
+#include <linux/blkdev.h>
+#include <linux/spinlock.h>
 #include <linux/delay.h>
 #include <linux/reboot.h>
 #include <linux/module.h>
 #include <linux/list.h>
 #include <linux/interrupt.h>
 #include <scsi/scsicam.h>
+#include <asm/uaccess.h>
+#include <asm/io.h>
 
 #include "scsi.h"
 #include "hosts.h"
@@ -368,8 +369,6 @@
 		INIT_LIST_HEAD(&adapter->completed_list);
 
 		adapter->flag = flag;
-		spin_lock_init(&adapter->lock);
-		scsi_assign_lock(host, &adapter->lock);
 
 		host->cmd_per_lun = max_cmd_per_lun;
 		host->max_sectors = max_sectors_per_io;
@@ -1754,7 +1753,7 @@
 	/*
 	 * loop till F/W has more commands for us to complete.
 	 */
-	spin_lock_irqsave(&adapter->lock, flags);
+	spin_lock_irqsave(adapter->host->host_lock, flags);
 
 	do {
 		/* Check if a valid interrupt is pending */
@@ -1800,7 +1799,7 @@
 
  out_unlock:
 
-	spin_unlock_irqrestore(&adapter->lock, flags);
+	spin_unlock_irqrestore(adapter->host->host_lock, flags);
 
 	return IRQ_RETVAL(handled);
 }
@@ -1831,7 +1830,7 @@
 	/*
 	 * loop till F/W has more commands for us to complete.
 	 */
-	spin_lock_irqsave(&adapter->lock, flags);
+	spin_lock_irqsave(adapter->host->host_lock, flags);
 
 	do {
 		/* Check if a valid interrupt is pending */
@@ -1880,7 +1879,7 @@
 
  out_unlock:
 
-	spin_unlock_irqrestore(&adapter->lock, flags);
+	spin_unlock_irqrestore(adapter->host->host_lock, flags);
 
 	return IRQ_RETVAL(handled);
 }
@@ -2608,7 +2607,7 @@
 	mc.cmd = MEGA_CLUSTER_CMD;
 	mc.opcode = MEGA_RESET_RESERVATIONS;
 
-	spin_unlock_irq(&adapter->lock);
+	spin_unlock_irq(adapter->host->host_lock);
 	if( mega_internal_command(adapter, LOCK_INT, &mc, NULL) != 0 ) {
 		printk(KERN_WARNING
 				"megaraid: reservation reset failed.\n");
@@ -2616,7 +2615,7 @@
 	else {
 		printk(KERN_INFO "megaraid: reservation reset.\n");
 	}
-	spin_lock_irq(&adapter->lock);
+	spin_lock_irq(adapter->host->host_lock);
 #endif
 
 	rval =  megaraid_abort_and_reset(adapter, cmd, SCB_RESET);
@@ -4860,7 +4859,7 @@
 
 	rval = mega_do_del_logdrv(adapter, logdrv);
 
-	spin_lock_irqsave(&adapter->lock, flags);
+	spin_lock_irqsave(adapter->host->host_lock, flags);
 
 	/*
 	 * If delete operation was successful, add 0x80 to the logical drive
@@ -4879,7 +4878,7 @@
 
 	mega_runpendq(adapter);
 
-	spin_unlock_irqrestore(&adapter->lock, flags);
+	spin_unlock_irqrestore(adapter->host->host_lock, flags);
 
 	return rval;
 }
@@ -5258,11 +5257,11 @@
 	/*
 	 * Get the lock only if the caller has not acquired it already
 	 */
-	if( ls == LOCK_INT ) spin_lock_irqsave(&adapter->lock, flags);
-
+	if( ls == LOCK_INT )
+		spin_lock_irqsave(adapter->host->host_lock, flags);
 	megaraid_queue(scmd, mega_internal_done);
-
-	if( ls == LOCK_INT ) spin_unlock_irqrestore(&adapter->lock, flags);
+	if( ls == LOCK_INT )
+		spin_unlock_irqrestore(adapter->host->host_lock, flags);
 
 	/*
 	 * Wait till this command finishes. Do not use
diff -Nru a/drivers/scsi/megaraid.h b/drivers/scsi/megaraid.h
--- a/drivers/scsi/megaraid.h	Mon Jun 23 11:03:07 2003
+++ b/drivers/scsi/megaraid.h	Mon Jun 23 11:03:07 2003
@@ -1,10 +1,6 @@
 #ifndef __MEGARAID_H__
 #define __MEGARAID_H__
 
-#include <linux/version.h>
-#include <linux/spinlock.h>
-
-
 #define MEGARAID_VERSION	\
 	"v2.00.3 (Release Date: Wed Feb 19 08:51:30 EST 2003)\n"
 
@@ -879,8 +875,6 @@
 					   drive needs to be done. Stop
 					   sending requests to the hba till
 					   delete operation is completed */
-	spinlock_t	lock;
-
 	u8	logdrv_chan[MAX_CHANNELS+NVIRT_CHAN]; /* logical drive are on
 							what channels. */
 	int	mega_ch_class;
