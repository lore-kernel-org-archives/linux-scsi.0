From: Tejun Heo <tj@kernel.org>
Subject: [PATCH 1/6] scsi: remove flush_scheduled_work() usages
Date: Tue, 21 Dec 2010 16:01:56 +0100
Message-ID: <1292943721-4519-2-git-send-email-tj@kernel.org>
References: <1292943721-4519-1-git-send-email-tj@kernel.org>
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <1292943721-4519-1-git-send-email-tj@kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
To: linux-scsi@vger.kernel.org, James.Bottomley@suse.de, fujita.tomonori@lab.ntt.co.jp, linux-kernel@vger.kernel.org, Eric.Moore@lsi.com, dgilbert@interlog.com
Cc: Tejun Heo <tj@kernel.org>
List-Id: linux-scsi@vger.kernel.org

Simple conversions to drop flush_scheduled_work() usages in
drivers/scsi.  More involved ones will be done in separate patches.

* NCR5380, megaraid_sas: cancel_delayed_work() +
  flush_scheduled_work() -> cancel_delayed_work_sync().

* mpt2sas_scsih: drop unnecessary flush_scheduled_work().

* arcmsr_hba, ipr, pmcraid: flush the used work explicitly instead of
  using flush_scheduled_work().

Signed-off-by: Tejun Heo <tj@kernel.org>
---
 drivers/scsi/NCR5380.c               |    3 +--
 drivers/scsi/arcmsr/arcmsr_hba.c     |    4 ++--
 drivers/scsi/ipr.c                   |    2 +-
 drivers/scsi/megaraid/megaraid_sas.c |    6 ++----
 drivers/scsi/mpt2sas/mpt2sas_scsih.c |    1 -
 drivers/scsi/pmcraid.c               |    2 +-
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
index 17e3df4..36cc467 100644
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
index de2e09e..91a40f9 100644
--- a/drivers/scsi/ipr.c
+++ b/drivers/scsi/ipr.c
@@ -8871,7 +8871,7 @@ static void __ipr_remove(struct pci_dev *pdev)
 
 	spin_unlock_irqrestore(ioa_cfg->host->host_lock, host_lock_flags);
 	wait_event(ioa_cfg->reset_wait_q, !ioa_cfg->in_reset_reload);
-	flush_scheduled_work();
+	flush_work_sync(&ioa_cfg->work_q);
 	spin_lock_irqsave(ioa_cfg->host->host_lock, host_lock_flags);
 
 	spin_lock(&ipr_driver_lock);
diff --git a/drivers/scsi/megaraid/megaraid_sas.c b/drivers/scsi/megaraid/megaraid_sas.c
index 7451bc0..6da090a 100644
--- a/drivers/scsi/megaraid/megaraid_sas.c
+++ b/drivers/scsi/megaraid/megaraid_sas.c
@@ -4036,9 +4036,8 @@ megasas_suspend(struct pci_dev *pdev, pm_message_t state)
 	/* cancel the delayed work if this work still in queue */
 	if (instance->ev != NULL) {
 		struct megasas_aen_event *ev = instance->ev;
-		cancel_delayed_work(
+		cancel_delayed_work_sync(
 			(struct delayed_work *)&ev->hotplug_work);
-		flush_scheduled_work();
 		instance->ev = NULL;
 	}
 
@@ -4186,9 +4185,8 @@ static void __devexit megasas_detach_one(struct pci_dev *pdev)
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
index 300d59f..1d54e7a 100644
--- a/drivers/scsi/pmcraid.c
+++ b/drivers/scsi/pmcraid.c
@@ -5459,7 +5459,7 @@ static void __devexit pmcraid_remove(struct pci_dev *pdev)
 	pmcraid_shutdown(pdev);
 
 	pmcraid_disable_interrupts(pinstance, ~0);
-	flush_scheduled_work();
+	flush_work_sync(&pinstance->worker_q);
 
 	pmcraid_kill_tasklets(pinstance);
 	pmcraid_unregister_interrupt_handler(pinstance);
-- 
1.7.1
