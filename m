From: Christoph Hellwig <hch@lst.de>
Subject: [PATCH] megaraid_mbox: remove scsi_assign_lock usage
Date: Mon, 31 Oct 2005 21:06:02 +0100
Message-ID: <20051031200602.GA17753@lst.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from verein.lst.de ([213.95.11.210]:32418 "EHLO mail.lst.de")
	by vger.kernel.org with ESMTP id S964815AbVJaUGJ (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Mon, 31 Oct 2005 15:06:09 -0500
Content-Disposition: inline
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: jejb@steeleye.com, Seokmann.Ju@engenio.com
Cc: linux-scsi@vger.kernel.org

also remove the adapter->host_lock alias for adapter->lock and remove
some superflous locking aswell as removing the tiny locking wrappers
for the EH routines.


Signed-off-by: Christoph Hellwig <hch@lst.de>

Index: linux-2.6/drivers/scsi/megaraid/mega_common.h
===================================================================
--- linux-2.6.orig/drivers/scsi/megaraid/mega_common.h	2005-08-11 16:46:00.000000000 +0200
+++ linux-2.6/drivers/scsi/megaraid/mega_common.h	2005-10-31 10:36:40.000000000 +0100
@@ -97,7 +97,6 @@
  * @param dpc_h			: tasklet handle
  * @param pdev			: pci configuration pointer for kernel
  * @param host			: pointer to host structure of mid-layer
- * @param host_lock		: pointer to appropriate lock
  * @param lock			: synchronization lock for mid-layer and driver
  * @param quiescent		: driver is quiescent for now.
  * @param outstanding_cmds	: number of commands pending in the driver
@@ -152,7 +151,6 @@
 	struct tasklet_struct	dpc_h;
 	struct pci_dev		*pdev;
 	struct Scsi_Host	*host;
-	spinlock_t		*host_lock;
 	spinlock_t		lock;
 	uint8_t			quiescent;
 	int			outstanding_cmds;
Index: linux-2.6/drivers/scsi/megaraid/megaraid_mbox.c
===================================================================
--- linux-2.6.orig/drivers/scsi/megaraid/megaraid_mbox.c	2005-10-29 01:42:46.000000000 +0200
+++ linux-2.6/drivers/scsi/megaraid/megaraid_mbox.c	2005-10-31 10:45:31.000000000 +0100
@@ -533,8 +533,6 @@
 
 	// Initialize the synchronization lock for kernel and LLD
 	spin_lock_init(&adapter->lock);
-	adapter->host_lock = &adapter->lock;
-
 
 	// Initialize the command queues: the list of free SCBs and the list
 	// of pending SCBs.
@@ -715,9 +713,6 @@
 	SCSIHOST2ADAP(host)	= (caddr_t)adapter;
 	adapter->host		= host;
 
-	// export the parameters required by the mid-layer
-	scsi_assign_lock(host, adapter->host_lock);
-
 	host->irq		= adapter->irq;
 	host->unique_id		= adapter->unique_id;
 	host->can_queue		= adapter->max_cmds;
@@ -1560,10 +1555,6 @@
 	scp->scsi_done	= done;
 	scp->result	= 0;
 
-	assert_spin_locked(adapter->host_lock);
-
-	spin_unlock(adapter->host_lock);
-
 	/*
 	 * Allocate and build a SCB request
 	 * if_busy flag will be set if megaraid_mbox_build_cmd() command could
@@ -1573,23 +1564,16 @@
 	 * return 0 in that case, and we would do the callback right away.
 	 */
 	if_busy	= 0;
-	scb	= megaraid_mbox_build_cmd(adapter, scp, &if_busy);
-
-	if (scb) {
-		megaraid_mbox_runpendq(adapter, scb);
-	}
-
-	spin_lock(adapter->host_lock);
-
+	scb = megaraid_mbox_build_cmd(adapter, scp, &if_busy);
 	if (!scb) {	// command already completed
 		done(scp);
 		return 0;
 	}
 
+	megaraid_mbox_runpendq(adapter, scb);
 	return if_busy;
 }
 
-
 /**
  * megaraid_mbox_build_cmd - transform the mid-layer scsi command to megaraid
  * firmware lingua
@@ -2546,9 +2530,7 @@
 		megaraid_dealloc_scb(adapter, scb);
 
 		// send the scsi packet back to kernel
-		spin_lock(adapter->host_lock);
 		scp->scsi_done(scp);
-		spin_unlock(adapter->host_lock);
 	}
 
 	return;
@@ -2563,7 +2545,7 @@
  * aborted. All the commands issued to the F/W must complete.
  **/
 static int
-__megaraid_abort_handler(struct scsi_cmnd *scp)
+megaraid_abort_handler(struct scsi_cmnd *scp)
 {
 	adapter_t		*adapter;
 	mraid_device_t		*raid_dev;
@@ -2577,8 +2559,6 @@
 	adapter		= SCP2ADAPTER(scp);
 	raid_dev	= ADAP2RAIDDEV(adapter);
 
-	assert_spin_locked(adapter->host_lock);
-
 	con_log(CL_ANN, (KERN_WARNING
 		"megaraid: aborting-%ld cmd=%x <c=%d t=%d l=%d>\n",
 		scp->serial_number, scp->cmnd[0], SCP2CHANNEL(scp),
@@ -2658,6 +2638,7 @@
 	// traverse through the list of all SCB, since driver does not
 	// maintain these SCBs on any list
 	found = 0;
+	spin_lock_irq(&adapter->lock);
 	for (i = 0; i < MBOX_MAX_SCSI_CMDS; i++) {
 		scb = adapter->kscb_list + i;
 
@@ -2680,6 +2661,7 @@
 			}
 		}
 	}
+	spin_unlock_irq(&adapter->lock);
 
 	if (!found) {
 		con_log(CL_ANN, (KERN_WARNING
@@ -2696,22 +2678,6 @@
 	return FAILED;
 }
 
-static int
-megaraid_abort_handler(struct scsi_cmnd *scp)
-{
-	adapter_t	*adapter;
-	int rc;
-
-	adapter		= SCP2ADAPTER(scp);
-
-	spin_lock_irq(adapter->host_lock);
-	rc = __megaraid_abort_handler(scp);
-	spin_unlock_irq(adapter->host_lock);
-
-	return rc;
-}
-
-
 /**
  * megaraid_reset_handler - device reset hadler for mailbox based driver
  * @scp		: reference command
@@ -2723,7 +2689,7 @@
  * host
  **/
 static int
-__megaraid_reset_handler(struct scsi_cmnd *scp)
+megaraid_reset_handler(struct scsi_cmnd *scp)
 {
 	adapter_t	*adapter;
 	scb_t		*scb;
@@ -2739,10 +2705,6 @@
 	adapter		= SCP2ADAPTER(scp);
 	raid_dev	= ADAP2RAIDDEV(adapter);
 
-	assert_spin_locked(adapter->host_lock);
-
-	con_log(CL_ANN, (KERN_WARNING "megaraid: reseting the host...\n"));
-
 	// return failure if adapter is not responding
 	if (raid_dev->hw_error) {
 		con_log(CL_ANN, (KERN_NOTICE
@@ -2779,8 +2741,6 @@
 			adapter->outstanding_cmds, MBOX_RESET_WAIT));
 	}
 
-	spin_unlock(adapter->host_lock);
-
 	recovery_window = MBOX_RESET_WAIT + MBOX_RESET_EXT_WAIT;
 
 	recovering = adapter->outstanding_cmds;
@@ -2806,7 +2766,7 @@
 		msleep(1000);
 	}
 
-	spin_lock(adapter->host_lock);
+	spin_lock(&adapter->lock);
 
 	// If still outstanding commands, bail out
 	if (adapter->outstanding_cmds) {
@@ -2815,7 +2775,8 @@
 
 		raid_dev->hw_error = 1;
 
-		return FAILED;
+		rval = FAILED;
+		goto out;
 	}
 	else {
 		con_log(CL_ANN, (KERN_NOTICE
@@ -2824,7 +2785,10 @@
 
 
 	// If the controller supports clustering, reset reservations
-	if (!adapter->ha) return SUCCESS;
+	if (!adapter->ha) {
+		rval = SUCCESS;
+		goto out;
+	}
 
 	// clear reservations if any
 	raw_mbox[0] = CLUSTER_CMD;
@@ -2841,22 +2805,11 @@
 				"megaraid: reservation reset failed\n"));
 	}
 
+ out:
+	spin_unlock_irq(&adapter->lock);
 	return rval;
 }
 
-static int
-megaraid_reset_handler(struct scsi_cmnd *cmd)
-{
-	int rc;
-
-	spin_lock_irq(cmd->device->host->host_lock);
-	rc = __megaraid_reset_handler(cmd);
-	spin_unlock_irq(cmd->device->host->host_lock);
-
-	return rc;
-}
-
-
 /*
  * START: internal commands library
  *
@@ -3776,9 +3729,9 @@
 	/*
 	 * Set the quiescent flag to stop issuing cmds to FW.
 	 */
-	spin_lock_irqsave(adapter->host_lock, flags);
+	spin_lock_irqsave(&adapter->lock, flags);
 	adapter->quiescent++;
-	spin_unlock_irqrestore(adapter->host_lock, flags);
+	spin_unlock_irqrestore(&adapter->lock, flags);
 
 	/*
 	 * Wait till there are no more cmds outstanding at FW. Try for at most
