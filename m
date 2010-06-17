From: "Kashyap, Desai" <kashyap.desai@lsi.com>
Subject: [PATCH 02/17] mpt2sas: Hold Controller reset when another reset is in progress
Date: Thu, 17 Jun 2010 13:28:55 +0530
Message-ID: <20100617075737.GC28921@lsi.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from na3sys009aog101.obsmtp.com ([74.125.149.67]:39214 "EHLO
	na3sys009aog101.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753180Ab0FQIeb (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Thu, 17 Jun 2010 04:34:31 -0400
Content-Disposition: inline
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org
Cc: Eric.Moore@lsi.com, James.Bottomley@HansenPartnership.com, Sathya.Prakash@lsi.com

Driver should not allow multiple host reset when already host reset is in
progress. It is possible that host reset was sent by scsi mid layer while there was already an host reset active,
either issued via IOCTL interface or internaly, like a config page timeout.
Since there was a host reset active, the driver would return a FAILED response
to the scsi mid layer. The solution is make sure pending host resets will
wait for the active host reset to complete before returning control
back up the call stack.

Signed-off-by: Kashyap Desai <kashyap.desai@lsi.com>
---
diff --git a/drivers/scsi/mpt2sas/mpt2sas_base.c b/drivers/scsi/mpt2sas/mpt2sas_base.c
index 0ec1ed3..f0c0df4 100644
--- a/drivers/scsi/mpt2sas/mpt2sas_base.c
+++ b/drivers/scsi/mpt2sas/mpt2sas_base.c
@@ -3804,7 +3804,7 @@ _wait_for_commands_to_complete(struct MPT2SAS_ADAPTER *ioc, int sleep_flag)
 		return;
 
 	/* wait for pending commands to complete */
-	wait_event_timeout(ioc->reset_wq, ioc->pending_io_count == 0, 3 * HZ);
+	wait_event_timeout(ioc->reset_wq, ioc->pending_io_count == 0, 10 * HZ);
 }
 
 /**
@@ -3828,13 +3828,24 @@ mpt2sas_base_hard_reset_handler(struct MPT2SAS_ADAPTER *ioc, int sleep_flag,
 	if (mpt2sas_fwfault_debug)
 		mpt2sas_halt_firmware(ioc);
 
-	spin_lock_irqsave(&ioc->ioc_reset_in_progress_lock, flags);
-	if (ioc->shost_recovery) {
-		spin_unlock_irqrestore(&ioc->ioc_reset_in_progress_lock, flags);
-		printk(MPT2SAS_ERR_FMT "%s: busy\n",
-		    ioc->name, __func__);
-		return -EBUSY;
+	/* TODO - What we really should be doing is pulling
+	 * out all the code associated with NO_SLEEP; its never used.
+	 * That is legacy code from mpt fusion driver, ported over.
+	 * I will leave this BUG_ON here for now till its been resolved.
+	 */
+	BUG_ON(sleep_flag == NO_SLEEP);
+
+	/* wait for an active reset in progress to complete */
+	if (!mutex_trylock(&ioc->reset_in_progress_mutex)) {
+		do {
+			ssleep(1);
+		} while (ioc->shost_recovery == 1);
+		dtmprintk(ioc, printk(MPT2SAS_DEBUG_FMT "%s: exit\n", ioc->name,
+		    __func__));
+		return ioc->ioc_reset_in_progress_status;
 	}
+
+	spin_lock_irqsave(&ioc->ioc_reset_in_progress_lock, flags);
 	ioc->shost_recovery = 1;
 	spin_unlock_irqrestore(&ioc->ioc_reset_in_progress_lock, flags);
 
@@ -3853,9 +3864,13 @@ mpt2sas_base_hard_reset_handler(struct MPT2SAS_ADAPTER *ioc, int sleep_flag,
 	    ioc->name, __func__, ((r == 0) ? "SUCCESS" : "FAILED")));
 
 	spin_lock_irqsave(&ioc->ioc_reset_in_progress_lock, flags);
+	ioc->ioc_reset_in_progress_status = r;
 	ioc->shost_recovery = 0;
 	complete(&ioc->shost_recovery_done);
 	spin_unlock_irqrestore(&ioc->ioc_reset_in_progress_lock, flags);
+	mutex_unlock(&ioc->reset_in_progress_mutex);
 
+	dtmprintk(ioc, printk(MPT2SAS_DEBUG_FMT "%s: exit\n", ioc->name,
+	    __func__));
 	return r;
 }
diff --git a/drivers/scsi/mpt2sas/mpt2sas_base.h b/drivers/scsi/mpt2sas/mpt2sas_base.h
index 0f41fcd..6032cbf 100644
--- a/drivers/scsi/mpt2sas/mpt2sas_base.h
+++ b/drivers/scsi/mpt2sas/mpt2sas_base.h
@@ -600,9 +600,13 @@ struct MPT2SAS_ADAPTER {
 	int		aen_event_read_flag;
 	u8		broadcast_aen_busy;
 	u8		shost_recovery;
+
+	struct mutex	reset_in_progress_mutex;
 	struct completion	shost_recovery_done;
 	spinlock_t 	ioc_reset_in_progress_lock;
 	u8		ioc_link_reset_in_progress;
+	int		ioc_reset_in_progress_status;
+
 	u8		ignore_loginfos;
 	u8		remove_host;
 	u8		wait_for_port_enable_to_complete;
diff --git a/drivers/scsi/mpt2sas/mpt2sas_scsih.c b/drivers/scsi/mpt2sas/mpt2sas_scsih.c
index 456ea7c..9ce2253 100644
--- a/drivers/scsi/mpt2sas/mpt2sas_scsih.c
+++ b/drivers/scsi/mpt2sas/mpt2sas_scsih.c
@@ -6557,6 +6557,7 @@ _scsih_probe(struct pci_dev *pdev, const struct pci_device_id *id)
 	ioc->tm_sas_control_cb_idx = tm_sas_control_cb_idx;
 	ioc->logging_level = logging_level;
 	/* misc semaphores and spin locks */
+	mutex_init(&ioc->reset_in_progress_mutex);
 	spin_lock_init(&ioc->ioc_reset_in_progress_lock);
 	spin_lock_init(&ioc->scsi_lookup_lock);
 	spin_lock_init(&ioc->sas_device_lock);
