From: James Smart <james.smart@emulex.com>
Subject: [PATCH 05/10] lpfc 8.3.32: Correct provisioning change failure on
 local function
Date: Tue, 12 Jun 2012 13:54:36 -0400
Message-ID: <1339523677.2162.5.camel@ogier>
Reply-To: james.smart@emulex.com
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from exht1.emulex.com ([138.239.113.183]:17659 "EHLO
	exht1.ad.emulex.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1753377Ab2FLRy7 (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Tue, 12 Jun 2012 13:54:59 -0400
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org

Fixed system held-up when performing resource provsion through same PCI function


Signed-off-by: Alex Iannicelli <alex.iannicelli@emulex.com>
Signed-off-by: James Smart <james.smart@emulex.com>

 ---

 lpfc.h         |    4 +
 lpfc_crtn.h    |    4 -
 lpfc_hbadisc.c |    2 
 lpfc_init.c    |  122 ++++++++++++++++++++++++++++++++++++++-------------------
 lpfc_scsi.c    |    2 
 lpfc_sli.c     |   10 +++-
 6 files changed, 98 insertions(+), 46 deletions(-)


diff -upNr a/drivers/scsi/lpfc/lpfc_crtn.h b/drivers/scsi/lpfc/lpfc_crtn.h
--- a/drivers/scsi/lpfc/lpfc_crtn.h	2012-06-08 10:07:43.000000000 -0400
+++ b/drivers/scsi/lpfc/lpfc_crtn.h	2012-06-08 11:55:40.000000000 -0400
@@ -183,7 +183,7 @@ int lpfc_post_buffer(struct lpfc_hba *, 
 void lpfc_decode_firmware_rev(struct lpfc_hba *, char *, int);
 int lpfc_online(struct lpfc_hba *);
 void lpfc_unblock_mgmt_io(struct lpfc_hba *);
-void lpfc_offline_prep(struct lpfc_hba *);
+void lpfc_offline_prep(struct lpfc_hba *, int);
 void lpfc_offline(struct lpfc_hba *);
 void lpfc_reset_hba(struct lpfc_hba *);
 
@@ -273,7 +273,7 @@ int lpfc_sli_host_down(struct lpfc_vport
 int lpfc_sli_hba_down(struct lpfc_hba *);
 int lpfc_sli_issue_mbox(struct lpfc_hba *, LPFC_MBOXQ_t *, uint32_t);
 int lpfc_sli_handle_mb_event(struct lpfc_hba *);
-void lpfc_sli_mbox_sys_shutdown(struct lpfc_hba *);
+void lpfc_sli_mbox_sys_shutdown(struct lpfc_hba *, int);
 int lpfc_sli_check_eratt(struct lpfc_hba *);
 void lpfc_sli_handle_slow_ring_event(struct lpfc_hba *,
 				    struct lpfc_sli_ring *, uint32_t);
diff -upNr a/drivers/scsi/lpfc/lpfc.h b/drivers/scsi/lpfc/lpfc.h
--- a/drivers/scsi/lpfc/lpfc.h	2012-06-08 10:07:43.000000000 -0400
+++ b/drivers/scsi/lpfc/lpfc.h	2012-06-08 11:55:40.000000000 -0400
@@ -96,6 +96,10 @@ struct lpfc_sli2_slim;
 /* queue dump line buffer size */
 #define LPFC_LBUF_SZ		128
 
+/* mailbox system shutdown options */
+#define LPFC_MBX_NO_WAIT	0
+#define LPFC_MBX_WAIT		1
+
 enum lpfc_polling_flags {
 	ENABLE_FCP_RING_POLLING = 0x1,
 	DISABLE_FCP_RING_INT    = 0x2
diff -upNr a/drivers/scsi/lpfc/lpfc_hbadisc.c b/drivers/scsi/lpfc/lpfc_hbadisc.c
--- a/drivers/scsi/lpfc/lpfc_hbadisc.c	2012-06-08 10:07:43.000000000 -0400
+++ b/drivers/scsi/lpfc/lpfc_hbadisc.c	2012-06-08 11:55:40.000000000 -0400
@@ -530,7 +530,7 @@ lpfc_work_list_done(struct lpfc_hba *phb
 			break;
 		case LPFC_EVT_OFFLINE_PREP:
 			if (phba->link_state >= LPFC_LINK_DOWN)
-				lpfc_offline_prep(phba);
+				lpfc_offline_prep(phba, LPFC_MBX_WAIT);
 			*(int *)(evtp->evt_arg1) = 0;
 			complete((struct completion *)(evtp->evt_arg2));
 			break;
diff -upNr a/drivers/scsi/lpfc/lpfc_init.c b/drivers/scsi/lpfc/lpfc_init.c
--- a/drivers/scsi/lpfc/lpfc_init.c	2012-06-08 11:55:38.000000000 -0400
+++ b/drivers/scsi/lpfc/lpfc_init.c	2012-06-08 11:55:40.000000000 -0400
@@ -73,6 +73,8 @@ static int lpfc_hba_down_post_s4(struct 
 static int lpfc_sli4_cq_event_pool_create(struct lpfc_hba *);
 static void lpfc_sli4_cq_event_pool_destroy(struct lpfc_hba *);
 static void lpfc_sli4_cq_event_release_all(struct lpfc_hba *);
+static void lpfc_sli4_disable_intr(struct lpfc_hba *);
+static uint32_t lpfc_sli4_enable_intr(struct lpfc_hba *, uint32_t);
 
 static struct scsi_transport_template *lpfc_transport_template = NULL;
 static struct scsi_transport_template *lpfc_vport_transport_template = NULL;
@@ -1169,7 +1171,7 @@ lpfc_offline_eratt(struct lpfc_hba *phba
 	spin_lock_irq(&phba->hbalock);
 	psli->sli_flag &= ~LPFC_SLI_ACTIVE;
 	spin_unlock_irq(&phba->hbalock);
-	lpfc_offline_prep(phba);
+	lpfc_offline_prep(phba, LPFC_MBX_NO_WAIT);
 
 	lpfc_offline(phba);
 	lpfc_reset_barrier(phba);
@@ -1193,7 +1195,7 @@ lpfc_offline_eratt(struct lpfc_hba *phba
 static void
 lpfc_sli4_offline_eratt(struct lpfc_hba *phba)
 {
-	lpfc_offline_prep(phba);
+	lpfc_offline_prep(phba, LPFC_MBX_NO_WAIT);
 	lpfc_offline(phba);
 	lpfc_sli4_brdreset(phba);
 	lpfc_hba_down_post(phba);
@@ -1251,7 +1253,7 @@ lpfc_handle_deferred_eratt(struct lpfc_h
 	 * There was a firmware error. Take the hba offline and then
 	 * attempt to restart it.
 	 */
-	lpfc_offline_prep(phba);
+	lpfc_offline_prep(phba, LPFC_MBX_WAIT);
 	lpfc_offline(phba);
 
 	/* Wait for the ER1 bit to clear.*/
@@ -1372,7 +1374,7 @@ lpfc_handle_eratt_s3(struct lpfc_hba *ph
 		 * There was a firmware error.  Take the hba offline and then
 		 * attempt to restart it.
 		 */
-		lpfc_offline_prep(phba);
+		lpfc_offline_prep(phba, LPFC_MBX_NO_WAIT);
 		lpfc_offline(phba);
 		lpfc_sli_brdrestart(phba);
 		if (lpfc_online(phba) == 0) {	/* Initialize the HBA */
@@ -1428,6 +1430,54 @@ lpfc_handle_eratt_s3(struct lpfc_hba *ph
 }
 
 /**
+ * lpfc_sli4_port_sta_fn_reset - The SLI4 function reset due to port status reg
+ * @phba: pointer to lpfc hba data structure.
+ * @mbx_action: flag for mailbox shutdown action.
+ *
+ * This routine is invoked to perform an SLI4 port PCI function reset in
+ * response to port status register polling attention. It waits for port
+ * status register (ERR, RDY, RN) bits before proceeding with function reset.
+ * During this process, interrupt vectors are freed and later requested
+ * for handling possible port resource change.
+ **/
+static int
+lpfc_sli4_port_sta_fn_reset(struct lpfc_hba *phba, int mbx_action)
+{
+	int rc;
+	uint32_t intr_mode;
+
+	/*
+	 * On error status condition, driver need to wait for port
+	 * ready before performing reset.
+	 */
+	rc = lpfc_sli4_pdev_status_reg_wait(phba);
+	if (!rc) {
+		/* need reset: attempt for port recovery */
+		lpfc_printf_log(phba, KERN_ERR, LOG_INIT,
+				"2887 Reset Needed: Attempting Port "
+				"Recovery...\n");
+		lpfc_offline_prep(phba, mbx_action);
+		lpfc_offline(phba);
+		/* release interrupt for possible resource change */
+		lpfc_sli4_disable_intr(phba);
+		lpfc_sli_brdrestart(phba);
+		/* request and enable interrupt */
+		intr_mode = lpfc_sli4_enable_intr(phba, phba->intr_mode);
+		if (intr_mode == LPFC_INTR_ERROR) {
+			lpfc_printf_log(phba, KERN_ERR, LOG_INIT,
+					"3175 Failed to enable interrupt\n");
+			return -EIO;
+		} else {
+			phba->intr_mode = intr_mode;
+		}
+		rc = lpfc_online(phba);
+		if (rc == 0)
+			lpfc_unblock_mgmt_io(phba);
+	}
+	return rc;
+}
+
+/**
  * lpfc_handle_eratt_s4 - The SLI4 HBA hardware error handler
  * @phba: pointer to lpfc hba data structure.
  *
@@ -1506,30 +1556,18 @@ lpfc_handle_eratt_s4(struct lpfc_hba *ph
 			 reg_err2 == SLIPORT_ERR2_REG_FUNC_PROVISON)
 			lpfc_printf_log(phba, KERN_ERR, LOG_INIT,
 					"3145 Port Down: Provisioning\n");
-		/*
-		 * On error status condition, driver need to wait for port
-		 * ready before performing reset.
-		 */
-		rc = lpfc_sli4_pdev_status_reg_wait(phba);
-		if (!rc) {
-			/* need reset: attempt for port recovery */
-			lpfc_printf_log(phba, KERN_ERR, LOG_INIT,
-					"2887 Reset Needed: Attempting Port "
-					"Recovery...\n");
-			lpfc_offline_prep(phba);
-			lpfc_offline(phba);
-			lpfc_sli_brdrestart(phba);
-			if (lpfc_online(phba) == 0) {
-				lpfc_unblock_mgmt_io(phba);
-				/* don't report event on forced debug dump */
-				if (reg_err1 == SLIPORT_ERR1_REG_ERR_CODE_2 &&
-				    reg_err2 == SLIPORT_ERR2_REG_FORCED_DUMP)
-					return;
-				else
-					break;
-			}
-			/* fall through for not able to recover */
+
+		/* Check port status register for function reset */
+		rc = lpfc_sli4_port_sta_fn_reset(phba, LPFC_MBX_NO_WAIT);
+		if (rc == 0) {
+			/* don't report event on forced debug dump */
+			if (reg_err1 == SLIPORT_ERR1_REG_ERR_CODE_2 &&
+			    reg_err2 == SLIPORT_ERR2_REG_FORCED_DUMP)
+				return;
+			else
+				break;
 		}
+		/* fall through for not able to recover */
 		lpfc_printf_log(phba, KERN_ERR, LOG_INIT,
 				"3152 Unrecoverable error, bring the port "
 				"offline\n");
@@ -2494,15 +2532,19 @@ lpfc_stop_hba_timers(struct lpfc_hba *ph
  * driver prepares the HBA interface for online or offline.
  **/
 static void
-lpfc_block_mgmt_io(struct lpfc_hba * phba)
+lpfc_block_mgmt_io(struct lpfc_hba *phba, int mbx_action)
 {
 	unsigned long iflag;
 	uint8_t actcmd = MBX_HEARTBEAT;
 	unsigned long timeout;
 
-	timeout = msecs_to_jiffies(LPFC_MBOX_TMO * 1000) + jiffies;
 	spin_lock_irqsave(&phba->hbalock, iflag);
 	phba->sli.sli_flag |= LPFC_BLOCK_MGMT_IO;
+	spin_unlock_irqrestore(&phba->hbalock, iflag);
+	if (mbx_action == LPFC_MBX_NO_WAIT)
+		return;
+	timeout = msecs_to_jiffies(LPFC_MBOX_TMO * 1000) + jiffies;
+	spin_lock_irqsave(&phba->hbalock, iflag);
 	if (phba->sli.mbox_active) {
 		actcmd = phba->sli.mbox_active->u.mb.mbxCommand;
 		/* Determine how long we might wait for the active mailbox
@@ -2592,7 +2634,7 @@ lpfc_online(struct lpfc_hba *phba)
 	lpfc_printf_log(phba, KERN_WARNING, LOG_INIT,
 			"0458 Bring Adapter online\n");
 
-	lpfc_block_mgmt_io(phba);
+	lpfc_block_mgmt_io(phba, LPFC_MBX_WAIT);
 
 	if (!lpfc_sli_queue_setup(phba)) {
 		lpfc_unblock_mgmt_io(phba);
@@ -2660,7 +2702,7 @@ lpfc_unblock_mgmt_io(struct lpfc_hba * p
  * queue to make it ready to be brought offline.
  **/
 void
-lpfc_offline_prep(struct lpfc_hba * phba)
+lpfc_offline_prep(struct lpfc_hba *phba, int mbx_action)
 {
 	struct lpfc_vport *vport = phba->pport;
 	struct lpfc_nodelist  *ndlp, *next_ndlp;
@@ -2671,7 +2713,7 @@ lpfc_offline_prep(struct lpfc_hba * phba
 	if (vport->fc_flag & FC_OFFLINE_MODE)
 		return;
 
-	lpfc_block_mgmt_io(phba);
+	lpfc_block_mgmt_io(phba, mbx_action);
 
 	lpfc_linkdown(phba);
 
@@ -2718,7 +2760,7 @@ lpfc_offline_prep(struct lpfc_hba * phba
 	}
 	lpfc_destroy_vport_work_array(phba, vports);
 
-	lpfc_sli_mbox_sys_shutdown(phba);
+	lpfc_sli_mbox_sys_shutdown(phba, mbx_action);
 }
 
 /**
@@ -4312,7 +4354,7 @@ lpfc_reset_hba(struct lpfc_hba *phba)
 		phba->link_state = LPFC_HBA_ERROR;
 		return;
 	}
-	lpfc_offline_prep(phba);
+	lpfc_offline_prep(phba, LPFC_MBX_WAIT);
 	lpfc_offline(phba);
 	lpfc_sli_brdrestart(phba);
 	lpfc_online(phba);
@@ -8890,7 +8932,7 @@ lpfc_pci_suspend_one_s3(struct pci_dev *
 			"0473 PCI device Power Management suspend.\n");
 
 	/* Bring down the device */
-	lpfc_offline_prep(phba);
+	lpfc_offline_prep(phba, LPFC_MBX_WAIT);
 	lpfc_offline(phba);
 	kthread_stop(phba->worker_thread);
 
@@ -9016,7 +9058,7 @@ lpfc_sli_prep_dev_for_reset(struct lpfc_
 			"2710 PCI channel disable preparing for reset\n");
 
 	/* Block any management I/Os to the device */
-	lpfc_block_mgmt_io(phba);
+	lpfc_block_mgmt_io(phba, LPFC_MBX_WAIT);
 
 	/* Block all SCSI devices' I/Os on the host */
 	lpfc_scsi_dev_block(phba);
@@ -9160,7 +9202,7 @@ lpfc_io_slot_reset_s3(struct pci_dev *pd
 		phba->intr_mode = intr_mode;
 
 	/* Take device offline, it will perform cleanup */
-	lpfc_offline_prep(phba);
+	lpfc_offline_prep(phba, LPFC_MBX_WAIT);
 	lpfc_offline(phba);
 	lpfc_sli_brdrestart(phba);
 
@@ -9634,7 +9676,7 @@ lpfc_pci_suspend_one_s4(struct pci_dev *
 			"2843 PCI device Power Management suspend.\n");
 
 	/* Bring down the device */
-	lpfc_offline_prep(phba);
+	lpfc_offline_prep(phba, LPFC_MBX_WAIT);
 	lpfc_offline(phba);
 	kthread_stop(phba->worker_thread);
 
@@ -9760,7 +9802,7 @@ lpfc_sli4_prep_dev_for_reset(struct lpfc
 			"2826 PCI channel disable preparing for reset\n");
 
 	/* Block any management I/Os to the device */
-	lpfc_block_mgmt_io(phba);
+	lpfc_block_mgmt_io(phba, LPFC_MBX_NO_WAIT);
 
 	/* Block all SCSI devices' I/Os on the host */
 	lpfc_scsi_dev_block(phba);
@@ -9933,7 +9975,7 @@ lpfc_io_resume_s4(struct pci_dev *pdev)
 	 */
 	if (!(phba->sli.sli_flag & LPFC_SLI_ACTIVE)) {
 		/* Perform device reset */
-		lpfc_offline_prep(phba);
+		lpfc_offline_prep(phba, LPFC_MBX_WAIT);
 		lpfc_offline(phba);
 		lpfc_sli_brdrestart(phba);
 		/* Bring the device back online */
diff -upNr a/drivers/scsi/lpfc/lpfc_scsi.c b/drivers/scsi/lpfc/lpfc_scsi.c
--- a/drivers/scsi/lpfc/lpfc_scsi.c	2012-06-08 10:07:46.000000000 -0400
+++ b/drivers/scsi/lpfc/lpfc_scsi.c	2012-06-08 11:55:40.000000000 -0400
@@ -4982,7 +4982,7 @@ lpfc_host_reset_handler(struct scsi_cmnd
 	struct lpfc_hba *phba = vport->phba;
 	int rc, ret = SUCCESS;
 
-	lpfc_offline_prep(phba);
+	lpfc_offline_prep(phba, LPFC_MBX_WAIT);
 	lpfc_offline(phba);
 	rc = lpfc_sli_brdrestart(phba);
 	if (rc)
diff -upNr a/drivers/scsi/lpfc/lpfc_sli.c b/drivers/scsi/lpfc/lpfc_sli.c
--- a/drivers/scsi/lpfc/lpfc_sli.c	2012-06-08 11:40:44.000000000 -0400
+++ b/drivers/scsi/lpfc/lpfc_sli.c	2012-06-08 11:55:40.000000000 -0400
@@ -8984,7 +8984,7 @@ lpfc_sli_hba_down(struct lpfc_hba *phba)
 	int i;
 
 	/* Shutdown the mailbox command sub-system */
-	lpfc_sli_mbox_sys_shutdown(phba);
+	lpfc_sli_mbox_sys_shutdown(phba, LPFC_MBX_WAIT);
 
 	lpfc_hba_down_prep(phba);
 
@@ -9996,11 +9996,17 @@ lpfc_sli_issue_mbox_wait(struct lpfc_hba
  * sub-system flush routine to gracefully bring down mailbox sub-system.
  **/
 void
-lpfc_sli_mbox_sys_shutdown(struct lpfc_hba *phba)
+lpfc_sli_mbox_sys_shutdown(struct lpfc_hba *phba, int mbx_action)
 {
 	struct lpfc_sli *psli = &phba->sli;
 	unsigned long timeout;
 
+	if (mbx_action == LPFC_MBX_NO_WAIT) {
+		/* delay 100ms for port state */
+		msleep(100);
+		lpfc_sli_mbox_sys_flush(phba);
+		return;
+	}
 	timeout = msecs_to_jiffies(LPFC_MBOX_TMO * 1000) + jiffies;
 
 	spin_lock_irq(&phba->hbalock);



