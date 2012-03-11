From: Dan Williams <dan.j.williams@intel.com>
Subject: [isci PATCH v2 05/18] isci: kill ->status,
 and ->state_lock in isci_host
Date: Sat, 10 Mar 2012 23:28:10 -0800
Message-ID: <20120311072810.6320.39409.stgit@dwillia2-linux.jf.intel.com>
References: <20120311072518.6320.61717.stgit@dwillia2-linux.jf.intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mga14.intel.com ([143.182.124.37]:57919 "EHLO mga14.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751084Ab2CKHMx (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Sun, 11 Mar 2012 03:12:53 -0400
In-Reply-To: <20120311072518.6320.61717.stgit@dwillia2-linux.jf.intel.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org
Cc: linux-ide@vger.kernel.org

They serve no incremental purpose over the existing sas_ha state.

Signed-off-by: Dan Williams <dan.j.williams@intel.com>
---
 drivers/scsi/isci/host.c |   11 -----------
 drivers/scsi/isci/host.h |   23 -----------------------
 2 files changed, 0 insertions(+), 34 deletions(-)

diff --git a/drivers/scsi/isci/host.c b/drivers/scsi/isci/host.c
index 83886a2..d647b07 100644
--- a/drivers/scsi/isci/host.c
+++ b/drivers/scsi/isci/host.c
@@ -642,7 +642,6 @@ static void isci_host_start_complete(struct isci_host *ihost, enum sci_status co
 	if (completion_status != SCI_SUCCESS)
 		dev_info(&ihost->pdev->dev,
 			"controller start timed out, continuing...\n");
-	isci_host_change_state(ihost, isci_ready);
 	clear_bit(IHOST_START_PENDING, &ihost->flags);
 	wake_up(&ihost->eventq);
 }
@@ -657,12 +656,7 @@ int isci_host_scan_finished(struct Scsi_Host *shost, unsigned long time)
 
 	sas_drain_work(ha);
 
-	dev_dbg(&ihost->pdev->dev,
-		"%s: ihost->status = %d, time = %ld\n",
-		 __func__, isci_host_get_state(ihost), time);
-
 	return 1;
-
 }
 
 /**
@@ -1054,7 +1048,6 @@ void isci_host_scan_start(struct Scsi_Host *shost)
 
 static void isci_host_stop_complete(struct isci_host *ihost, enum sci_status completion_status)
 {
-	isci_host_change_state(ihost, isci_stopped);
 	sci_controller_disable_interrupts(ihost);
 	clear_bit(IHOST_STOP_PENDING, &ihost->flags);
 	wake_up(&ihost->eventq);
@@ -1262,7 +1255,6 @@ void isci_host_deinit(struct isci_host *ihost)
 	for (i = 0; i < isci_gpio_count(ihost); i++)
 		writel(SGPIO_HW_CONTROL, &ihost->scu_registers->peg0.sgpio.output_data_select[i]);
 
-	isci_host_change_state(ihost, isci_stopping);
 	for (i = 0; i < SCI_MAX_PORTS; i++) {
 		struct isci_port *iport = &ihost->ports[i];
 		struct isci_remote_device *idev, *d;
@@ -2494,12 +2486,9 @@ int isci_host_init(struct isci_host *ihost)
 	struct sci_user_parameters sci_user_params;
 	struct isci_pci_info *pci_info = to_pci_info(ihost->pdev);
 
-	spin_lock_init(&ihost->state_lock);
 	spin_lock_init(&ihost->scic_lock);
 	init_waitqueue_head(&ihost->eventq);
 
-	isci_host_change_state(ihost, isci_starting);
-
 	status = sci_controller_construct(ihost, scu_base(ihost),
 					  smu_base(ihost));
 
diff --git a/drivers/scsi/isci/host.h b/drivers/scsi/isci/host.h
index a9679ee..81485b4 100644
--- a/drivers/scsi/isci/host.h
+++ b/drivers/scsi/isci/host.h
@@ -191,9 +191,7 @@ struct isci_host {
 	struct asd_sas_port sas_ports[SCI_MAX_PORTS];
 	struct sas_ha_struct sas_ha;
 
-	spinlock_t state_lock;
 	struct pci_dev *pdev;
-	enum isci_status status;
 	#define IHOST_START_PENDING 0
 	#define IHOST_STOP_PENDING 1
 	unsigned long flags;
@@ -315,27 +313,6 @@ static inline struct isci_pci_info *to_pci_info(struct pci_dev *pdev)
 	     id < ARRAY_SIZE(to_pci_info(pdev)->hosts) && ihost; \
 	     ihost = to_pci_info(pdev)->hosts[++id])
 
-static inline enum isci_status isci_host_get_state(struct isci_host *isci_host)
-{
-	return isci_host->status;
-}
-
-static inline void isci_host_change_state(struct isci_host *isci_host,
-					  enum isci_status status)
-{
-	unsigned long flags;
-
-	dev_dbg(&isci_host->pdev->dev,
-		"%s: isci_host = %p, state = 0x%x",
-		__func__,
-		isci_host,
-		status);
-	spin_lock_irqsave(&isci_host->state_lock, flags);
-	isci_host->status = status;
-	spin_unlock_irqrestore(&isci_host->state_lock, flags);
-
-}
-
 static inline void wait_for_start(struct isci_host *ihost)
 {
 	wait_event(ihost->eventq, !test_bit(IHOST_START_PENDING, &ihost->flags));

