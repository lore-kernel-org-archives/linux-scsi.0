From: Jitendra Bhivare <jitendra.bhivare@broadcom.com>
Subject: [PATCH 15/28] be2iscsi: Fix checks for HBA in error state
Date: Thu, 21 Jul 2016 14:37:52 +0530
Message-ID: <1469092085-14311-16-git-send-email-jitendra.bhivare@broadcom.com>
References: <1469092085-14311-1-git-send-email-jitendra.bhivare@broadcom.com>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-wm0-f54.google.com ([74.125.82.54]:34664 "EHLO
	mail-wm0-f54.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751814AbcGUJJO (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Thu, 21 Jul 2016 05:09:14 -0400
Received: by mail-wm0-f54.google.com with SMTP id q128so2350327wma.1
        for <linux-scsi@vger.kernel.org>; Thu, 21 Jul 2016 02:09:13 -0700 (PDT)
In-Reply-To: <1469092085-14311-1-git-send-email-jitendra.bhivare@broadcom.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org
Cc: mchristi@redhat.com, Jitendra Bhivare <jitendra.bhivare@broadcom.com>

Save ue_detected and fw_timeout errors in state field of beiscsi_hba.
BEISCSI_HBA_RUNNING
BEISCSI_HBA_LINK_UP
BEISCSI_HBA_BOOT_FOUND
BEISCSI_HBA_PCI_ERR
BEISCSI_HBA_FW_TIMEOUT
BEISCSI_HBA_IN_UE

Make sure no PCI transaction happens once in error state.
Add checks in IO path to detect HBA in error.

Skip hwi_purge_eq step which can't be done in error state.

Signed-off-by: Jitendra Bhivare <jitendra.bhivare@broadcom.com>
---
 drivers/scsi/be2iscsi/be_cmds.c  | 28 +++++++-----
 drivers/scsi/be2iscsi/be_iscsi.c | 81 ++++++++++++++-------------------
 drivers/scsi/be2iscsi/be_main.c  | 97 +++++++++++++++++++++++++++-------------
 drivers/scsi/be2iscsi/be_main.h  | 36 +++++++--------
 drivers/scsi/be2iscsi/be_mgmt.c  |  5 +--
 5 files changed, 134 insertions(+), 113 deletions(-)

diff --git a/drivers/scsi/be2iscsi/be_cmds.c b/drivers/scsi/be2iscsi/be_cmds.c
index 4032962..f16de6c 100644
--- a/drivers/scsi/be2iscsi/be_cmds.c
+++ b/drivers/scsi/be2iscsi/be_cmds.c
@@ -152,8 +152,11 @@ int beiscsi_mccq_compl_wait(struct beiscsi_hba *phba,
 	struct be_cmd_resp_hdr *mbx_resp_hdr;
 	struct be_queue_info *mccq = &phba->ctrl.mcc_obj.q;
 
-	if (beiscsi_error(phba))
-		return -EPERM;
+	if (beiscsi_hba_in_error(phba)) {
+		clear_bit(MCC_TAG_STATE_RUNNING,
+			  &phba->ctrl.ptag_state[tag].tag_state);
+		return -EIO;
+	}
 
 	/* wait for the mccq completion */
 	rc = wait_event_interruptible_timeout(
@@ -315,13 +318,16 @@ static void beiscsi_process_async_link(struct beiscsi_hba *phba,
 	 * This has been newly introduced in SKH-R Firmware 10.0.338.45.
 	 **/
 	if (evt->port_link_status & BE_ASYNC_LINK_UP_MASK) {
-		phba->state = BE_ADAPTER_LINK_UP | BE_ADAPTER_CHECK_BOOT;
 		phba->get_boot = BE_GET_BOOT_RETRIES;
+		/* first this needs to be visible to worker thread */
+		wmb();
+		set_bit(BEISCSI_HBA_LINK_UP | BEISCSI_HBA_BOOT_FOUND,
+			&phba->state);
 		__beiscsi_log(phba, KERN_ERR,
 			      "BC_%d : Link Up on Port %d tag 0x%x\n",
 			      evt->physical_port, evt->event_tag);
 	} else {
-		phba->state = BE_ADAPTER_LINK_DOWN;
+		clear_bit(BEISCSI_HBA_LINK_UP, &phba->state);
 		__beiscsi_log(phba, KERN_ERR,
 			      "BC_%d : Link Down on Port %d tag 0x%x\n",
 			      evt->physical_port, evt->event_tag);
@@ -406,8 +412,10 @@ void beiscsi_process_async_event(struct beiscsi_hba *phba,
 		beiscsi_process_async_link(phba, compl);
 		break;
 	case ASYNC_EVENT_CODE_ISCSI:
-		phba->state |= BE_ADAPTER_CHECK_BOOT;
 		phba->get_boot = BE_GET_BOOT_RETRIES;
+		/* first this needs to be visible to worker thread */
+		wmb();
+		set_bit(BEISCSI_HBA_BOOT_FOUND, &phba->state);
 		sev = KERN_ERR;
 		break;
 	case ASYNC_EVENT_CODE_SLI:
@@ -504,7 +512,7 @@ int be_mcc_compl_poll(struct beiscsi_hba *phba, unsigned int tag)
 		return 0;
 	}
 	for (i = 0; i < mcc_timeout; i++) {
-		if (beiscsi_error(phba))
+		if (beiscsi_hba_in_error(phba))
 			return -EIO;
 
 		beiscsi_process_mcc_cq(phba);
@@ -522,7 +530,7 @@ int be_mcc_compl_poll(struct beiscsi_hba *phba, unsigned int tag)
 
 	beiscsi_log(phba, KERN_ERR, BEISCSI_LOG_CONFIG | BEISCSI_LOG_MBOX,
 		    "BC_%d : FW Timed Out\n");
-	phba->fw_timeout = true;
+	set_bit(BEISCSI_HBA_FW_TIMEOUT, &phba->state);
 	beiscsi_ue_detect(phba);
 	return -EBUSY;
 }
@@ -566,7 +574,7 @@ static int be_mbox_db_ready_poll(struct be_ctrl_info *ctrl)
 	 */
 	timeout = jiffies + msecs_to_jiffies(BEISCSI_MBX_RDY_BIT_TIMEOUT);
 	do {
-		if (beiscsi_error(phba))
+		if (beiscsi_hba_in_error(phba))
 			return -EIO;
 
 		ready = ioread32(db);
@@ -586,10 +594,8 @@ static int be_mbox_db_ready_poll(struct be_ctrl_info *ctrl)
 	beiscsi_log(phba, KERN_ERR,
 			BEISCSI_LOG_CONFIG | BEISCSI_LOG_MBOX,
 			"BC_%d : FW Timed Out\n");
-
-	phba->fw_timeout = true;
+	set_bit(BEISCSI_HBA_FW_TIMEOUT, &phba->state);
 	beiscsi_ue_detect(phba);
-
 	return -EBUSY;
 }
 
diff --git a/drivers/scsi/be2iscsi/be_iscsi.c b/drivers/scsi/be2iscsi/be_iscsi.c
index faa37f6..ddb458ab 100644
--- a/drivers/scsi/be2iscsi/be_iscsi.c
+++ b/drivers/scsi/be2iscsi/be_iscsi.c
@@ -52,22 +52,20 @@ struct iscsi_cls_session *beiscsi_session_create(struct iscsi_endpoint *ep,
 
 
 	if (!ep) {
-		printk(KERN_ERR
-		       "beiscsi_session_create: invalid ep\n");
+		pr_err("beiscsi_session_create: invalid ep\n");
 		return NULL;
 	}
 	beiscsi_ep = ep->dd_data;
 	phba = beiscsi_ep->phba;
 
-	if (phba->state & BE_ADAPTER_PCI_ERR) {
-		beiscsi_log(phba, KERN_ERR, BEISCSI_LOG_CONFIG,
-			    "BS_%d : PCI_ERROR Recovery\n");
-		return NULL;
-	} else {
+	if (beiscsi_hba_in_error(phba)) {
 		beiscsi_log(phba, KERN_INFO, BEISCSI_LOG_CONFIG,
-			    "BS_%d : In beiscsi_session_create\n");
+			    "BS_%d : HBA in error 0x%lx\n", phba->state);
+		return NULL;
 	}
 
+	beiscsi_log(phba, KERN_INFO, BEISCSI_LOG_CONFIG,
+		    "BS_%d : In beiscsi_session_create\n");
 	if (cmds_max > beiscsi_ep->phba->params.wrbs_per_cxn) {
 		beiscsi_log(phba, KERN_ERR, BEISCSI_LOG_CONFIG,
 			    "BS_%d : Cannot handle %d cmds."
@@ -436,9 +434,9 @@ int beiscsi_iface_set_param(struct Scsi_Host *shost,
 	uint32_t rm_len = dt_len;
 	int ret;
 
-	if (phba->state & BE_ADAPTER_PCI_ERR) {
-		beiscsi_log(phba, KERN_ERR, BEISCSI_LOG_CONFIG,
-			    "BS_%d : In PCI_ERROR Recovery\n");
+	if (beiscsi_hba_in_error(phba)) {
+		beiscsi_log(phba, KERN_INFO, BEISCSI_LOG_CONFIG,
+			    "BS_%d : HBA in error 0x%lx\n", phba->state);
 		return -EBUSY;
 	}
 
@@ -579,9 +577,9 @@ int beiscsi_iface_get_param(struct iscsi_iface *iface,
 
 	if (param_type != ISCSI_NET_PARAM)
 		return 0;
-	if (phba->state & BE_ADAPTER_PCI_ERR) {
-		beiscsi_log(phba, KERN_ERR, BEISCSI_LOG_CONFIG,
-			    "BS_%d : In PCI_ERROR Recovery\n");
+	if (beiscsi_hba_in_error(phba)) {
+		beiscsi_log(phba, KERN_INFO, BEISCSI_LOG_CONFIG,
+			    "BS_%d : HBA in error 0x%lx\n", phba->state);
 		return -EBUSY;
 	}
 
@@ -737,7 +735,7 @@ static void beiscsi_get_port_state(struct Scsi_Host *shost)
 	struct beiscsi_hba *phba = iscsi_host_priv(shost);
 	struct iscsi_cls_host *ihost = shost->shost_data;
 
-	ihost->port_state = (phba->state & BE_ADAPTER_LINK_UP) ?
+	ihost->port_state = test_bit(BEISCSI_HBA_LINK_UP, &phba->state) ?
 		ISCSI_PORT_STATE_UP : ISCSI_PORT_STATE_DOWN;
 }
 
@@ -789,16 +787,13 @@ int beiscsi_get_host_param(struct Scsi_Host *shost,
 	struct beiscsi_hba *phba = iscsi_host_priv(shost);
 	int status = 0;
 
-
-	if (phba->state & BE_ADAPTER_PCI_ERR) {
-		beiscsi_log(phba, KERN_ERR, BEISCSI_LOG_CONFIG,
-			    "BS_%d : In PCI_ERROR Recovery\n");
-		return -EBUSY;
-	} else {
+	if (beiscsi_hba_in_error(phba)) {
 		beiscsi_log(phba, KERN_INFO, BEISCSI_LOG_CONFIG,
-			    "BS_%d : In beiscsi_get_host_param,"
-			    " param = %d\n", param);
+			    "BS_%d : HBA in error 0x%lx\n", phba->state);
+		return -EBUSY;
 	}
+	beiscsi_log(phba, KERN_INFO, BEISCSI_LOG_CONFIG,
+		    "BS_%d : In beiscsi_get_host_param, param = %d\n", param);
 
 	switch (param) {
 	case ISCSI_HOST_PARAM_HWADDRESS:
@@ -940,15 +935,13 @@ int beiscsi_conn_start(struct iscsi_cls_conn *cls_conn)
 
 	phba = ((struct beiscsi_conn *)conn->dd_data)->phba;
 
-	if (phba->state & BE_ADAPTER_PCI_ERR) {
-		beiscsi_log(phba, KERN_ERR, BEISCSI_LOG_CONFIG,
-			    "BS_%d : In PCI_ERROR Recovery\n");
+	if (beiscsi_hba_in_error(phba)) {
+		beiscsi_log(phba, KERN_INFO, BEISCSI_LOG_CONFIG,
+			    "BS_%d : HBA in error 0x%lx\n", phba->state);
 		return -EBUSY;
-	} else {
-		beiscsi_log(beiscsi_conn->phba, KERN_INFO,
-			    BEISCSI_LOG_CONFIG,
-			    "BS_%d : In beiscsi_conn_start\n");
 	}
+	beiscsi_log(beiscsi_conn->phba, KERN_INFO, BEISCSI_LOG_CONFIG,
+		    "BS_%d : In beiscsi_conn_start\n");
 
 	memset(&params, 0, sizeof(struct beiscsi_offload_params));
 	beiscsi_ep = beiscsi_conn->ep;
@@ -1165,28 +1158,20 @@ beiscsi_ep_connect(struct Scsi_Host *shost, struct sockaddr *dst_addr,
 	struct iscsi_endpoint *ep;
 	int ret;
 
-	if (shost)
-		phba = iscsi_host_priv(shost);
-	else {
+	if (!shost) {
 		ret = -ENXIO;
-		printk(KERN_ERR
-		       "beiscsi_ep_connect shost is NULL\n");
+		pr_err("beiscsi_ep_connect shost is NULL\n");
 		return ERR_PTR(ret);
 	}
 
-	if (beiscsi_error(phba)) {
+	phba = iscsi_host_priv(shost);
+	if (beiscsi_hba_in_error(phba)) {
 		ret = -EIO;
-		beiscsi_log(phba, KERN_WARNING, BEISCSI_LOG_CONFIG,
-			    "BS_%d : The FW state Not Stable!!!\n");
+		beiscsi_log(phba, KERN_INFO, BEISCSI_LOG_CONFIG,
+			    "BS_%d : HBA in error 0x%lx\n", phba->state);
 		return ERR_PTR(ret);
 	}
-
-	if (phba->state & BE_ADAPTER_PCI_ERR) {
-		ret = -EBUSY;
-		beiscsi_log(phba, KERN_ERR, BEISCSI_LOG_CONFIG,
-			    "BS_%d : In PCI_ERROR Recovery\n");
-		return ERR_PTR(ret);
-	} else if (phba->state & BE_ADAPTER_LINK_DOWN) {
+	if (!test_bit(BEISCSI_HBA_LINK_UP, &phba->state)) {
 		ret = -EBUSY;
 		beiscsi_log(phba, KERN_WARNING, BEISCSI_LOG_CONFIG,
 			    "BS_%d : The Adapter Port state is Down!!!\n");
@@ -1340,9 +1325,9 @@ void beiscsi_ep_disconnect(struct iscsi_endpoint *ep)
 		tcp_upload_flag = CONNECTION_UPLOAD_ABORT;
 	}
 
-	if (phba->state & BE_ADAPTER_PCI_ERR) {
-		beiscsi_log(phba, KERN_ERR, BEISCSI_LOG_CONFIG,
-			    "BS_%d : PCI_ERROR Recovery\n");
+	if (beiscsi_hba_in_error(phba)) {
+		beiscsi_log(phba, KERN_INFO, BEISCSI_LOG_CONFIG,
+			    "BS_%d : HBA in error 0x%lx\n", phba->state);
 		goto free_ep;
 	}
 
diff --git a/drivers/scsi/be2iscsi/be_main.c b/drivers/scsi/be2iscsi/be_main.c
index 408fbdb..a2197c6 100644
--- a/drivers/scsi/be2iscsi/be_main.c
+++ b/drivers/scsi/be2iscsi/be_main.c
@@ -2026,6 +2026,9 @@ void beiscsi_process_mcc_cq(struct beiscsi_hba *phba)
 	mcc_compl = queue_tail_node(mcc_cq);
 	mcc_compl->flags = le32_to_cpu(mcc_compl->flags);
 	while (mcc_compl->flags & CQE_FLAGS_VALID_MASK) {
+		if (beiscsi_hba_in_error(phba))
+			return;
+
 		if (num_processed >= 32) {
 			hwi_ring_cq_db(phba, mcc_cq->id,
 					num_processed, 0);
@@ -2057,7 +2060,8 @@ static void beiscsi_mcc_work(struct work_struct *work)
 	phba = pbe_eq->phba;
 	beiscsi_process_mcc_cq(phba);
 	/* rearm EQ for further interrupts */
-	hwi_ring_eq_db(phba, pbe_eq->q.id, 0, 0, 1, 1);
+	if (!beiscsi_hba_in_error(phba))
+		hwi_ring_eq_db(phba, pbe_eq->q.id, 0, 0, 1, 1);
 }
 
 /**
@@ -2088,6 +2092,9 @@ unsigned int beiscsi_process_cq(struct be_eq_obj *pbe_eq, int budget)
 
 	while (sol->dw[offsetof(struct amap_sol_cqe, valid) / 32] &
 	       CQE_VALID_MASK) {
+		if (beiscsi_hba_in_error(phba))
+			return 0;
+
 		be_dws_le_to_cpu(sol, sizeof(struct sol_cqe));
 
 		 code = (sol->dw[offsetof(struct amap_sol_cqe, code) /
@@ -2257,12 +2264,16 @@ static int be_iopoll(struct irq_poll *iop, int budget)
 	struct be_eq_entry *eqe = NULL;
 	struct be_queue_info *eq;
 
-	io_events = 0;
 	pbe_eq = container_of(iop, struct be_eq_obj, iopoll);
 	phba = pbe_eq->phba;
+	if (beiscsi_hba_in_error(phba)) {
+		irq_poll_complete(iop);
+		return 0;
+	}
+
+	io_events = 0;
 	eq = &pbe_eq->q;
 	eqe = queue_tail_node(eq);
-
 	while (eqe->dw[offsetof(struct amap_eq_entry, valid) / 32] &
 			EQE_VALID_MASK) {
 		AMAP_SET_BITS(struct amap_eq_entry, valid, eqe, 0);
@@ -2270,7 +2281,6 @@ static int be_iopoll(struct irq_poll *iop, int budget)
 		eqe = queue_tail_node(eq);
 		io_events++;
 	}
-
 	hwi_ring_eq_db(phba, eq->id, 1, io_events, 0, 1);
 
 	ret = beiscsi_process_cq(pbe_eq, budget);
@@ -2281,7 +2291,8 @@ static int be_iopoll(struct irq_poll *iop, int budget)
 			    BEISCSI_LOG_CONFIG | BEISCSI_LOG_IO,
 			    "BM_%d : rearm pbe_eq->q.id =%d ret %d\n",
 			    pbe_eq->q.id, ret);
-		hwi_ring_eq_db(phba, pbe_eq->q.id, 0, 0, 1, 1);
+		if (!beiscsi_hba_in_error(phba))
+			hwi_ring_eq_db(phba, pbe_eq->q.id, 0, 0, 1, 1);
 	}
 	return ret;
 }
@@ -4642,7 +4653,8 @@ static void beiscsi_cleanup_task(struct iscsi_task *task)
 		}
 
 		if (io_task->scsi_cmnd) {
-			scsi_dma_unmap(io_task->scsi_cmnd);
+			if (io_task->num_sg)
+				scsi_dma_unmap(io_task->scsi_cmnd);
 			io_task->scsi_cmnd = NULL;
 		}
 	} else {
@@ -5121,6 +5133,15 @@ static int beiscsi_task_xmit(struct iscsi_task *task)
 	int num_sg;
 	unsigned int  writedir = 0, xferlen = 0;
 
+	phba = io_task->conn->phba;
+	/**
+	 * HBA in error includes BEISCSI_HBA_FW_TIMEOUT. IO path might be
+	 * operational if FW still gets heartbeat from EP FW. Is management
+	 * path really needed to continue further?
+	 */
+	if (beiscsi_hba_in_error(phba))
+		return -EIO;
+
 	if (!io_task->conn->login_in_progress)
 		task->hdr->exp_statsn = 0;
 
@@ -5128,8 +5149,8 @@ static int beiscsi_task_xmit(struct iscsi_task *task)
 		return beiscsi_mtask(task);
 
 	io_task->scsi_cmnd = sc;
+	io_task->num_sg = 0;
 	num_sg = scsi_dma_map(sc);
-	phba = io_task->conn->phba;
 	if (num_sg < 0) {
 		beiscsi_log(phba, KERN_ERR,
 			    BEISCSI_LOG_IO | BEISCSI_LOG_ISCSI,
@@ -5140,6 +5161,11 @@ static int beiscsi_task_xmit(struct iscsi_task *task)
 
 		return num_sg;
 	}
+	/**
+	 * For scsi cmd task, check num_sg before unmapping in cleanup_task.
+	 * For management task, cleanup_task checks mtask_addr before unmapping.
+	 */
+	io_task->num_sg = num_sg;
 	xferlen = scsi_bufflen(sc);
 	sg = scsi_sglist(sc);
 	if (sc->sc_data_direction == DMA_TO_DEVICE)
@@ -5169,6 +5195,12 @@ static int beiscsi_bsg_request(struct bsg_job *job)
 	shost = iscsi_job_to_shost(job);
 	phba = iscsi_host_priv(shost);
 
+	if (beiscsi_hba_in_error(phba)) {
+		beiscsi_log(phba, KERN_INFO, BEISCSI_LOG_CONFIG,
+			    "BM_%d : HBA in error 0x%lx\n", phba->state);
+		return -ENXIO;
+	}
+
 	switch (bsg_req->msgcode) {
 	case ISCSI_BSG_HST_VENDOR:
 		nonemb_cmd.va = pci_alloc_consistent(phba->ctrl.pdev,
@@ -5242,12 +5274,10 @@ void beiscsi_hba_attrs_init(struct beiscsi_hba *phba)
 /*
  * beiscsi_quiesce()- Cleanup Driver resources
  * @phba: Instance Priv structure
- * @unload_state:i Clean or EEH unload state
  *
  * Free the OS and HW resources held by the driver
  **/
-static void beiscsi_quiesce(struct beiscsi_hba *phba,
-		uint32_t unload_state)
+static void beiscsi_quiesce(struct beiscsi_hba *phba)
 {
 	struct hwi_controller *phwi_ctrlr;
 	struct hwi_context_memory *phwi_context;
@@ -5274,21 +5304,22 @@ static void beiscsi_quiesce(struct beiscsi_hba *phba,
 		irq_poll_disable(&pbe_eq->iopoll);
 	}
 
-	if (unload_state == BEISCSI_CLEAN_UNLOAD) {
-		destroy_workqueue(phba->wq);
-		beiscsi_clean_port(phba);
-		beiscsi_free_mem(phba);
-
-		beiscsi_unmap_pci_function(phba);
-		pci_free_consistent(phba->pcidev,
-				    phba->ctrl.mbox_mem_alloced.size,
-				    phba->ctrl.mbox_mem_alloced.va,
-				    phba->ctrl.mbox_mem_alloced.dma);
-	} else {
-		hwi_purge_eq(phba);
+	/* PCI_ERR is set then check if driver is not unloading */
+	if (test_bit(BEISCSI_HBA_RUNNING, &phba->state) &&
+	    test_bit(BEISCSI_HBA_PCI_ERR, &phba->state)) {
 		hwi_cleanup(phba);
+		return;
 	}
 
+	destroy_workqueue(phba->wq);
+	beiscsi_clean_port(phba);
+	beiscsi_free_mem(phba);
+
+	beiscsi_unmap_pci_function(phba);
+	pci_free_consistent(phba->pcidev,
+			    phba->ctrl.mbox_mem_alloced.size,
+			    phba->ctrl.mbox_mem_alloced.va,
+			    phba->ctrl.mbox_mem_alloced.dma);
 }
 
 static void beiscsi_remove(struct pci_dev *pcidev)
@@ -5301,10 +5332,11 @@ static void beiscsi_remove(struct pci_dev *pcidev)
 		return;
 	}
 
+	clear_bit(BEISCSI_HBA_RUNNING, &phba->state);
 	beiscsi_iface_destroy_default(phba);
 	iscsi_boot_destroy_kset(phba->boot_kset);
 	iscsi_host_remove(phba->shost);
-	beiscsi_quiesce(phba, BEISCSI_CLEAN_UNLOAD);
+	beiscsi_quiesce(phba);
 	pci_dev_put(phba->pcidev);
 	iscsi_host_free(phba->shost);
 	pci_disable_pcie_error_reporting(pcidev);
@@ -5340,6 +5372,9 @@ static void be_eqd_update(struct beiscsi_hba *phba)
 	u32 pps, delta;
 	unsigned int tag;
 
+	if (beiscsi_hba_in_error(phba))
+		return;
+
 	phwi_ctrlr = phba->phwi_ctrlr;
 	phwi_context = phwi_ctrlr->phwi_ctxt;
 
@@ -5381,6 +5416,9 @@ static void be_eqd_update(struct beiscsi_hba *phba)
 
 static void be_check_boot_session(struct beiscsi_hba *phba)
 {
+	if (beiscsi_hba_in_error(phba))
+		return;
+
 	if (beiscsi_setup_boot_info(phba))
 		beiscsi_log(phba, KERN_ERR, BEISCSI_LOG_INIT,
 			    "BM_%d : Could not set up "
@@ -5402,13 +5440,13 @@ beiscsi_hw_health_check(struct work_struct *work)
 
 	be_eqd_update(phba);
 
-	if (phba->state & BE_ADAPTER_CHECK_BOOT) {
+	if (test_bit(BEISCSI_HBA_BOOT_FOUND, &phba->state)) {
 		if ((phba->get_boot > 0) && (!phba->boot_kset)) {
 			phba->get_boot--;
 			if (!(phba->get_boot % BE_GET_BOOT_TO))
 				be_check_boot_session(phba);
 		} else {
-			phba->state &= ~BE_ADAPTER_CHECK_BOOT;
+			clear_bit(BEISCSI_HBA_BOOT_FOUND, &phba->state);
 			phba->get_boot = 0;
 		}
 	}
@@ -5426,12 +5464,12 @@ static pci_ers_result_t beiscsi_eeh_err_detected(struct pci_dev *pdev,
 	struct beiscsi_hba *phba = NULL;
 
 	phba = (struct beiscsi_hba *)pci_get_drvdata(pdev);
-	phba->state |= BE_ADAPTER_PCI_ERR;
+	set_bit(BEISCSI_HBA_PCI_ERR, &phba->state);
 
 	beiscsi_log(phba, KERN_ERR, BEISCSI_LOG_INIT,
 		    "BM_%d : EEH error detected\n");
 
-	beiscsi_quiesce(phba, BEISCSI_EEH_UNLOAD);
+	beiscsi_quiesce(phba);
 
 	if (state == pci_channel_io_perm_failure) {
 		beiscsi_log(phba, KERN_ERR, BEISCSI_LOG_INIT,
@@ -5563,7 +5601,7 @@ static void beiscsi_eeh_resume(struct pci_dev *pdev)
 	}
 
 	hwi_enable_intr(phba);
-	phba->state &= ~BE_ADAPTER_PCI_ERR;
+	clear_bit(BEISCSI_HBA_PCI_ERR, &phba->state);
 
 	return;
 ret_err:
@@ -5606,10 +5644,8 @@ static int beiscsi_dev_probe(struct pci_dev *pcidev,
 	/* Initialize Driver configuration Paramters */
 	beiscsi_hba_attrs_init(phba);
 
-	phba->fw_timeout = false;
 	phba->mac_addr_set = false;
 
-
 	switch (pcidev->device) {
 	case BE_DEVICE_ID1:
 	case OC_DEVICE_ID1:
@@ -5638,6 +5674,7 @@ static int beiscsi_dev_probe(struct pci_dev *pcidev,
 		goto hba_free;
 	}
 
+	set_bit(BEISCSI_HBA_RUNNING, &phba->state);
 	/*
 	 * FUNCTION_RESET should clean up any stale info in FW for this fn
 	 */
diff --git a/drivers/scsi/be2iscsi/be_main.h b/drivers/scsi/be2iscsi/be_main.h
index 90cdc10..8ab1651 100644
--- a/drivers/scsi/be2iscsi/be_main.h
+++ b/drivers/scsi/be2iscsi/be_main.h
@@ -98,20 +98,9 @@
 
 #define INVALID_SESS_HANDLE	0xFFFFFFFF
 
-/**
- * Adapter States
- **/
-#define BE_ADAPTER_LINK_UP	0x001
-#define BE_ADAPTER_LINK_DOWN	0x002
-#define BE_ADAPTER_PCI_ERR	0x004
-#define BE_ADAPTER_CHECK_BOOT	0x008
-
-
-#define BEISCSI_CLEAN_UNLOAD	0x01
-#define BEISCSI_EEH_UNLOAD	0x02
-
 #define BE_GET_BOOT_RETRIES	45
 #define BE_GET_BOOT_TO		20
+
 /**
  * hardware needs the async PDU buffers to be posted in multiples of 8
  * So have atleast 8 of them by default
@@ -417,11 +406,20 @@ struct beiscsi_hba {
 		unsigned long ulp_supported;
 	} fw_config;
 
-	unsigned int state;
+	unsigned long state;
+#define BEISCSI_HBA_RUNNING	0
+#define BEISCSI_HBA_LINK_UP	1
+#define BEISCSI_HBA_BOOT_FOUND	2
+#define BEISCSI_HBA_PCI_ERR	3
+#define BEISCSI_HBA_FW_TIMEOUT	4
+#define BEISCSI_HBA_IN_UE	5
+/* error bits */
+#define BEISCSI_HBA_IN_ERR	((1 << BEISCSI_HBA_PCI_ERR) | \
+				 (1 << BEISCSI_HBA_FW_TIMEOUT) | \
+				 (1 << BEISCSI_HBA_IN_UE))
+
 	u8 optic_state;
 	int get_boot;
-	bool fw_timeout;
-	bool ue_detected;
 	struct delayed_work beiscsi_hw_check_task;
 
 	bool mac_addr_set;
@@ -445,6 +443,8 @@ struct beiscsi_hba {
 			uint32_t writedir);
 };
 
+#define beiscsi_hba_in_error(phba) ((phba)->state & BEISCSI_HBA_IN_ERR)
+
 struct beiscsi_session {
 	struct pci_pool *bhs_pool;
 };
@@ -507,6 +507,7 @@ struct beiscsi_io_task {
 	struct sgl_handle *psgl_handle;
 	struct beiscsi_conn *conn;
 	struct scsi_cmnd *scsi_cmnd;
+	int num_sg;
 	struct hwi_wrb_context *pwrb_context;
 	unsigned int cmd_sn;
 	unsigned int flags;
@@ -854,11 +855,6 @@ void hwi_ring_cq_db(struct beiscsi_hba *phba,
 unsigned int beiscsi_process_cq(struct be_eq_obj *pbe_eq, int budget);
 void beiscsi_process_mcc_cq(struct beiscsi_hba *phba);
 
-static inline bool beiscsi_error(struct beiscsi_hba *phba)
-{
-	return phba->ue_detected || phba->fw_timeout;
-}
-
 struct pdu_nop_out {
 	u32 dw[12];
 };
diff --git a/drivers/scsi/be2iscsi/be_mgmt.c b/drivers/scsi/be2iscsi/be_mgmt.c
index 8069ef0..4f2194e 100644
--- a/drivers/scsi/be2iscsi/be_mgmt.c
+++ b/drivers/scsi/be2iscsi/be_mgmt.c
@@ -108,9 +108,6 @@ void beiscsi_ue_detect(struct beiscsi_hba *phba)
 	uint32_t ue_mask_hi = 0, ue_mask_lo = 0;
 	uint8_t i = 0;
 
-	if (phba->ue_detected)
-		return;
-
 	pci_read_config_dword(phba->pcidev,
 			      PCICFG_UE_STATUS_LOW, &ue_lo);
 	pci_read_config_dword(phba->pcidev,
@@ -128,7 +125,7 @@ void beiscsi_ue_detect(struct beiscsi_hba *phba)
 
 
 	if (ue_lo || ue_hi) {
-		phba->ue_detected = true;
+		set_bit(BEISCSI_HBA_IN_UE, &phba->state);
 		beiscsi_log(phba, KERN_ERR,
 			    BEISCSI_LOG_CONFIG | BEISCSI_LOG_MBOX,
 			    "BG_%d : Error detected on the adapter\n");
-- 
1.9.1

