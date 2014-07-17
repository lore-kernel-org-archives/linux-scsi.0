From: Mike Qiu <qiudayu@linux.vnet.ibm.com>
Subject: [PATCH] lpfc: Avoid to disable pci_dev twice
Date: Thu, 17 Jul 2014 02:32:31 -0400
Message-ID: <1405578751-14164-1-git-send-email-qiudayu@linux.vnet.ibm.com>
Return-path: <linux-kernel-owner@vger.kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
To: linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org
Cc: james.smart@emulex.com, JBottomley@parallels.com, Mike Qiu <qiudayu@linux.vnet.ibm.com>
List-Id: linux-scsi@vger.kernel.org

In IBM Power servers, when hardware error occurs during probe
state, EEH subsystem will call driver's error_detected interface,
which will call pci_disable_device(). But driver's probe function also
call pci_disable_device() in this situation.

So pci_dev will be disabled twice:

Device lpfc disabling already-disabled device
------------[ cut here ]------------
WARNING: at drivers/pci/pci.c:1407
CPU: 0 PID: 8744 Comm: kworker/0:0 Tainted: G        W    3.10.42-2002.pkvm2_1_1.6.ppc64 #1
Workqueue: events .work_for_cpu_fn
task: c00000274e3f5400 ti: c0000027d3958000 task.ti: c0000027d3958000
NIP: c000000000471b8c LR: c000000000471b88 CTR: c00000000043ebe0
REGS: c0000027d395b650 TRAP: 0700   Tainted: G        W     (3.10.42-2002.pkvm2_1_1.6.ppc64)
MSR: 9000000100029032 <SF,HV,EE,ME,IR,DR,RI>  CR: 28b52b44  XER: 20000000
CFAR: c000000000879ab8 SOFTE: 1
...
NIP .pci_disable_device+0xcc/0xe0
LR  .pci_disable_device+0xc8/0xe0
Call Trace:
.pci_disable_device+0xc8/0xe0 (unreliable)
.lpfc_disable_pci_dev+0x50/0x80 [lpfc]
.lpfc_pci_probe_one+0x870/0x21a0 [lpfc]
.local_pci_probe+0x68/0xb0
.work_for_cpu_fn+0x38/0x60
.process_one_work+0x1a4/0x4d0
.worker_thread+0x37c/0x490
.kthread+0xf0/0x100
.ret_from_kernel_thread+0x5c/0x80

Signed-off-by: Mike Qiu <qiudayu@linux.vnet.ibm.com>
---
 drivers/scsi/lpfc/lpfc.h      |  1 +
 drivers/scsi/lpfc/lpfc_init.c | 59 +++++++++++++++++++++++++++++++++++++++----
 2 files changed, 55 insertions(+), 5 deletions(-)

diff --git a/drivers/scsi/lpfc/lpfc.h b/drivers/scsi/lpfc/lpfc.h
index 434e903..0c7bad9 100644
--- a/drivers/scsi/lpfc/lpfc.h
+++ b/drivers/scsi/lpfc/lpfc.h
@@ -813,6 +813,7 @@ struct lpfc_hba {
 #define VPD_MASK            0xf         /* mask for any vpd data */
 
 	uint8_t soft_wwn_enable;
+	uint8_t probe_done;
 
 	struct timer_list fcp_poll_timer;
 	struct timer_list eratt_poll;
diff --git a/drivers/scsi/lpfc/lpfc_init.c b/drivers/scsi/lpfc/lpfc_init.c
index 06f9a5b..c2e67ae 100644
--- a/drivers/scsi/lpfc/lpfc_init.c
+++ b/drivers/scsi/lpfc/lpfc_init.c
@@ -9519,6 +9519,9 @@ lpfc_pci_probe_one_s3(struct pci_dev *pdev, const struct pci_device_id *pid)
 		}
 	}
 
+	/* Set the probe flag */
+	phba->probe_done = 1;
+
 	/* Perform post initialization setup */
 	lpfc_post_init_setup(phba);
 
@@ -9795,6 +9798,9 @@ lpfc_sli_prep_dev_for_recover(struct lpfc_hba *phba)
 static void
 lpfc_sli_prep_dev_for_reset(struct lpfc_hba *phba)
 {
+	if (phba)
+		return;
+
 	lpfc_printf_log(phba, KERN_ERR, LOG_INIT,
 			"2710 PCI channel disable preparing for reset\n");
 
@@ -9812,7 +9818,8 @@ lpfc_sli_prep_dev_for_reset(struct lpfc_hba *phba)
 
 	/* Disable interrupt and pci device */
 	lpfc_sli_disable_intr(phba);
-	pci_disable_device(phba->pcidev);
+	if (phba->probe_done && phba->pcidev)
+		pci_disable_device(phba->pcidev);
 }
 
 /**
@@ -10282,6 +10289,9 @@ lpfc_pci_probe_one_s4(struct pci_dev *pdev, const struct pci_device_id *pid)
 		goto out_disable_intr;
 	}
 
+	/* Set probe_done flag */
+	phba->probe_done = 1;
+
 	/* Log the current active interrupt mode */
 	phba->intr_mode = intr_mode;
 	lpfc_log_intr_mode(phba, intr_mode);
@@ -10544,6 +10554,9 @@ lpfc_sli4_prep_dev_for_recover(struct lpfc_hba *phba)
 static void
 lpfc_sli4_prep_dev_for_reset(struct lpfc_hba *phba)
 {
+	if (!phba)
+		return;
+
 	lpfc_printf_log(phba, KERN_ERR, LOG_INIT,
 			"2826 PCI channel disable preparing for reset\n");
 
@@ -10562,7 +10575,9 @@ lpfc_sli4_prep_dev_for_reset(struct lpfc_hba *phba)
 	/* Disable interrupt and pci device */
 	lpfc_sli4_disable_intr(phba);
 	lpfc_sli4_queue_destroy(phba);
-	pci_disable_device(phba->pcidev);
+
+	if (phba->probe_done && phba->pcidev)
+		pci_disable_device(phba->pcidev);
 }
 
 /**
@@ -10893,9 +10908,21 @@ static pci_ers_result_t
 lpfc_io_error_detected(struct pci_dev *pdev, pci_channel_state_t state)
 {
 	struct Scsi_Host *shost = pci_get_drvdata(pdev);
-	struct lpfc_hba *phba = ((struct lpfc_vport *)shost->hostdata)->phba;
+	struct lpfc_hba *phba;
 	pci_ers_result_t rc = PCI_ERS_RESULT_DISCONNECT;
 
+	if (!shost)
+		/* Run here means it may during probe state and
+		 * Scsi_Host has not been created and We can do nothing
+		 * in this state so call for hotplug*/
+		return PCI_ERS_RESULT_NONE;
+
+	phba = ((struct lpfc_vport *)shost->hostdata)->phba;
+
+	if (!phba || !phba->probe_done)
+		/* Run here means it may during probe state */
+		return PCI_ERS_RESULT_NONE;
+
 	switch (phba->pci_dev_grp) {
 	case LPFC_PCI_DEV_LP:
 		rc = lpfc_io_error_detected_s3(pdev, state);
@@ -10930,9 +10957,20 @@ static pci_ers_result_t
 lpfc_io_slot_reset(struct pci_dev *pdev)
 {
 	struct Scsi_Host *shost = pci_get_drvdata(pdev);
-	struct lpfc_hba *phba = ((struct lpfc_vport *)shost->hostdata)->phba;
+	struct lpfc_hba *phba;
 	pci_ers_result_t rc = PCI_ERS_RESULT_DISCONNECT;
 
+	if (!shost)
+		/* Run here means it may during probe state and
+		 * Scsi_Host has not been created */
+		return PCI_ERS_RESULT_NONE;
+
+	phba = ((struct lpfc_vport *)shost->hostdata)->phba;
+
+	if (!phba || !phba->probe_done)
+		/* Run here means it may during probe state */
+		return PCI_ERS_RESULT_NONE;
+
 	switch (phba->pci_dev_grp) {
 	case LPFC_PCI_DEV_LP:
 		rc = lpfc_io_slot_reset_s3(pdev);
@@ -10963,7 +11001,18 @@ static void
 lpfc_io_resume(struct pci_dev *pdev)
 {
 	struct Scsi_Host *shost = pci_get_drvdata(pdev);
-	struct lpfc_hba *phba = ((struct lpfc_vport *)shost->hostdata)->phba;
+	struct lpfc_hba *phba;
+
+	if (!shost)
+		/* Run here means it may during probe state and
+		 * Scsi_Host has not been created */
+		return;
+
+	phba = ((struct lpfc_vport *)shost->hostdata)->phba;
+
+	if (!phba || !phba->probe_done)
+		/* Run here means it may during probe state */
+		return;
 
 	switch (phba->pci_dev_grp) {
 	case LPFC_PCI_DEV_LP:
-- 
1.8.1.4
