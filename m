From: Tejun Heo <tj@kernel.org>
Subject: [PATCH 1/4] scsi: remove flush_scheduled_work() usages
Date: Mon, 24 Jan 2011 14:57:28 +0100
Message-ID: <1295877451-16602-2-git-send-email-tj@kernel.org>
References: <1295877451-16602-1-git-send-email-tj@kernel.org>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-fx0-f46.google.com ([209.85.161.46]:60520 "EHLO
	mail-fx0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751673Ab1AXN5o (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Mon, 24 Jan 2011 08:57:44 -0500
Received: by mail-fx0-f46.google.com with SMTP id 20so4042379fxm.19
        for <linux-scsi@vger.kernel.org>; Mon, 24 Jan 2011 05:57:43 -0800 (PST)
In-Reply-To: <1295877451-16602-1-git-send-email-tj@kernel.org>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James.Bottomley@HansenPartnership.com, linux-scsi@vger.kernel.org, Eric.Moore@lsi.com
Cc: Tejun Heo <tj@kernel.org>

Simple conversions to drop flush_scheduled_work() usages in
drivers/scsi.  More involved ones will be done in separate patches.

* NCR5380, megaraid_sas: cancel_delayed_work() +
  flush_scheduled_work() -> cancel_delayed_work_sync().

* mpt2sas_scsih: drop unnecessary flush_scheduled_work().

* arcmsr_hba, ipr, pmcraid: flush the used work explicitly instead of
  using flush_scheduled_work().

Signed-off-by: Tejun Heo <tj@kernel.org>
---
 drivers/scsi/NCR5380.c                    |    3 +--
 drivers/scsi/arcmsr/arcmsr_hba.c          |    4 ++--
 drivers/scsi/ipr.c                        |    2 +-
 drivers/scsi/megaraid/megaraid_sas_base.c |    6 ++----
 drivers/scsi/mpt2sas/mpt2sas_scsih.c      |    1 -
 drivers/scsi/pmcraid.c                    |    2 +-
 6 files changed, 7 insertions(+), 11 deletions(-)

diff --git a/drivers/scsi/NCR5380.c b/drivers/scsi/NCR5380.c
index 9a5629f..e7cd2fc 100644
--- a/drivers/scsi/NCR5380.c
+++ b/drivers/scsi/NCR5380.c
@@ -936,8 +936,7 @@ static void NCR5380_exit(struct Scsi_Host *instance)
 {
 	struct NCR5380_hostdata *hostdata = (struct NCR5380_hostdata *) instance->hostdata;
 
-	cancel_delayed_work(&hostdata->coroutine);
-	flush_scheduled_work();
+	cancel_delayed_work_sync(&hostdata->coroutine);
 }
 
 /**
diff --git a/drivers/scsi/arcmsr/arcmsr_hba.c b/drivers/scsi/arcmsr/arcmsr_hba.c
index 1cadcd6..d6d17a1 100644
--- a/drivers/scsi/arcmsr/arcmsr_hba.c
+++ b/drivers/scsi/arcmsr/arcmsr_hba.c
@@ -1022,7 +1022,7 @@ static void arcmsr_remove(struct pci_dev *pdev)
 	int poll_count = 0;
 	arcmsr_free_sysfs_attr(acb);
 	scsi_remove_host(host);
-	flush_scheduled_work();
+	flush_work_sync(&acb->arcmsr_do_message_isr_bh);
 	del_timer_sync(&acb->eternal_timer);
 	arcmsr_disable_outbound_ints(acb);
 	arcmsr_stop_adapter_bgrb(acb);
@@ -1068,7 +1068,7 @@ static void arcmsr_shutdown(struct pci_dev *pdev)
 		(struct AdapterControlBlock *)host->hostdata;
 	del_timer_sync(&acb->eternal_timer);
 	arcmsr_disable_outbound_ints(acb);
-	flush_scheduled_work();
+	flush_work_sync(&acb->arcmsr_do_message_isr_bh);
 	arcmsr_stop_adapter_bgrb(acb);
 	arcmsr_flush_adapter_cache(acb);
 }
diff --git a/drivers/scsi/ipr.c b/drivers/scsi/ipr.c
index 9c5c8be..a8e24f0 100644
--- a/drivers/scsi/ipr.c
+++ b/drivers/scsi/ipr.c
@@ -8865,7 +8865,7 @@ static void __ipr_remove(struct pci_dev *pdev)
 
 	spin_unlock_irqrestore(ioa_cfg->host->host_lock, host_lock_flags);
 	wait_event(ioa_cfg->reset_wait_q, !ioa_cfg->in_reset_reload);
-	flush_scheduled_work();
+	flush_work_sync(&ioa_cfg->work_q);
 	spin_lock_irqsave(ioa_cfg->host->host_lock, host_lock_flags);
 
 	spin_lock(&ipr_driver_lock);
diff --git a/drivers/scsi/megaraid/megaraid_sas_base.c b/drivers/scsi/megaraid/megaraid_sas_base.c
index 5d6d07b..e7c9b41 100644
--- a/drivers/scsi/megaraid/megaraid_sas_base.c
+++ b/drivers/scsi/megaraid/megaraid_sas_base.c
@@ -4242,9 +4242,8 @@ megasas_suspend(struct pci_dev *pdev, pm_message_t state)
 	/* cancel the delayed work if this work still in queue */
 	if (instance->ev != NULL) {
 		struct megasas_aen_event *ev = instance->ev;
-		cancel_delayed_work(
+		cancel_delayed_work_sync(
 			(struct delayed_work *)&ev->hotplug_work);
-		flush_scheduled_work();
 		instance->ev = NULL;
 	}
 
@@ -4417,9 +4416,8 @@ static void __devexit megasas_detach_one(struct pci_dev *pdev)
 	/* cancel the delayed work if this work still in queue*/
 	if (instance->ev != NULL) {
 		struct megasas_aen_event *ev = instance->ev;
-		cancel_delayed_work(
+		cancel_delayed_work_sync(
 			(struct delayed_work *)&ev->hotplug_work);
-		flush_scheduled_work();
 		instance->ev = NULL;
 	}
 
diff --git a/drivers/scsi/mpt2sas/mpt2sas_scsih.c b/drivers/scsi/mpt2sas/mpt2sas_scsih.c
index eda347c..b375150 100644
--- a/drivers/scsi/mpt2sas/mpt2sas_scsih.c
+++ b/drivers/scsi/mpt2sas/mpt2sas_scsih.c
@@ -6935,7 +6935,6 @@ _scsih_suspend(struct pci_dev *pdev, pm_message_t state)
 	u32 device_state;
 
 	mpt2sas_base_stop_watchdog(ioc);
-	flush_scheduled_work();
 	scsi_block_requests(shost);
 	device_state = pci_choose_state(pdev, state);
 	printk(MPT2SAS_INFO_FMT "pdev=0x%p, slot=%s, entering "
diff --git a/drivers/scsi/pmcraid.c b/drivers/scsi/pmcraid.c
index 321cf3a..bcf858e 100644
--- a/drivers/scsi/pmcraid.c
+++ b/drivers/scsi/pmcraid.c
@@ -5454,7 +5454,7 @@ static void __devexit pmcraid_remove(struct pci_dev *pdev)
 	pmcraid_shutdown(pdev);
 
 	pmcraid_disable_interrupts(pinstance, ~0);
-	flush_scheduled_work();
+	flush_work_sync(&pinstance->worker_q);
 
 	pmcraid_kill_tasklets(pinstance);
 	pmcraid_unregister_interrupt_handler(pinstance);
-- 
1.7.1

