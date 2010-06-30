From: Jayamohan Kallickal <jayamohank@serverengines.com>
Subject: [PATCH 07/12] be2iscsi: Fix for premature buffer free
Date: Wed, 30 Jun 2010 05:30:32 +0530
Message-ID: <20100630000021.GA20279@serverengines.com>
Reply-To: Jayamohan Kalickal <jayamohank@serverengines.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from segment-124-30.sify.net ([124.30.166.146]:34395 "EHLO
	akhaparde.serverengines.com" rhost-flags-OK-FAIL-OK-FAIL)
	by vger.kernel.org with ESMTP id S1754065Ab0F3AAX (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Tue, 29 Jun 2010 20:00:23 -0400
Content-Disposition: inline
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org
Cc: James.Bottomley@suse.de, michaelc@cs.wisc.edu

  This patch fixes a bug where the buffer was being freed as soon as submission to HW
is done.

Signed-off-by: Jayamohan Kallickal <jayamohank@serverengines.com>
---
 drivers/scsi/be2iscsi/be_iscsi.c |   24 ++++++++++++++++++--
 drivers/scsi/be2iscsi/be_main.c  |   43 +++++++++++++++++++++++++++++++++---
 drivers/scsi/be2iscsi/be_mgmt.c  |   44 ++++++++++++++++++-------------------
 drivers/scsi/be2iscsi/be_mgmt.h  |   10 +++++---
 4 files changed, 87 insertions(+), 34 deletions(-)

diff --git a/drivers/scsi/be2iscsi/be_iscsi.c b/drivers/scsi/be2iscsi/be_iscsi.c
index 49e3718..7acf351 100644
--- a/drivers/scsi/be2iscsi/be_iscsi.c
+++ b/drivers/scsi/be2iscsi/be_iscsi.c
@@ -488,6 +488,7 @@ static int beiscsi_open_conn(struct iscsi_endpoint *ep,
 	struct be_mcc_wrb *wrb;
 	struct tcp_connect_and_offload_out *ptcpcnct_out;
 	unsigned short status, extd_status;
+	struct be_dma_mem nonemb_cmd;
 	unsigned int tag, wrb_num;
 	int ret = -1;
 
@@ -508,7 +509,20 @@ static int beiscsi_open_conn(struct iscsi_endpoint *ep,
 	}
 
 	beiscsi_ep->cid_vld = 0;
-	tag = mgmt_open_connection(phba, dst_addr, beiscsi_ep);
+
+	nonemb_cmd.va = pci_alloc_consistent(phba->ctrl.pdev,
+				sizeof(struct tcp_connect_and_offload_in),
+				&nonemb_cmd.dma);
+	if (nonemb_cmd.va == NULL) {
+		SE_DEBUG(DBG_LVL_1,
+			 "Failed to allocate memory for mgmt_open_connection"
+			 "\n");
+		goto free_ep;
+	}
+	nonemb_cmd.size = sizeof(struct tcp_connect_and_offload_in);
+	memset(nonemb_cmd.va, 0, nonemb_cmd.size);
+	tag = mgmt_open_connection(phba, dst_addr, beiscsi_ep, &nonemb_cmd);
+
 	if (!tag) {
 		SE_DEBUG(DBG_LVL_1,
 			 "mgmt_open_connection Failed for cid=%d\n",
@@ -525,6 +539,8 @@ static int beiscsi_open_conn(struct iscsi_endpoint *ep,
 				    " status = %d extd_status = %d\n",
 				    status, extd_status);
 		free_mcc_tag(&phba->ctrl, tag);
+		pci_free_consistent(phba->ctrl.pdev, nonemb_cmd.size,
+			    nonemb_cmd.va, nonemb_cmd.dma);
 		goto free_ep;
 	} else {
 		wrb = queue_get_wrb(mccq, wrb_num);
@@ -536,6 +552,8 @@ static int beiscsi_open_conn(struct iscsi_endpoint *ep,
 		beiscsi_ep->cid_vld = 1;
 		SE_DEBUG(DBG_LVL_8, "mgmt_open_connection Success\n");
 	}
+	pci_free_consistent(phba->ctrl.pdev, nonemb_cmd.size,
+			    nonemb_cmd.va, nonemb_cmd.dma);
 	return 0;
 
 free_ep:
@@ -587,12 +605,12 @@ beiscsi_ep_connect(struct Scsi_Host *shost, struct sockaddr *dst_addr,
 	if (beiscsi_open_conn(ep, NULL, dst_addr, non_blocking)) {
 		SE_DEBUG(DBG_LVL_1, "Failed in beiscsi_open_conn\n");
 		ret = -ENOMEM;
-		goto free_ep;
+		goto dstry_ep;
 	}
 
 	return ep;
 
-free_ep:
+dstry_ep:
 	iscsi_destroy_endpoint(ep);
 	return ERR_PTR(ret);
 }
diff --git a/drivers/scsi/be2iscsi/be_main.c b/drivers/scsi/be2iscsi/be_main.c
index 8f3e4b9..b17897b 100644
--- a/drivers/scsi/be2iscsi/be_main.c
+++ b/drivers/scsi/be2iscsi/be_main.c
@@ -71,6 +71,7 @@ static int beiscsi_eh_abort(struct scsi_cmnd *sc)
 	struct beiscsi_hba *phba;
 	struct iscsi_session *session;
 	struct invalidate_command_table *inv_tbl;
+	struct be_dma_mem nonemb_cmd;
 	unsigned int cid, tag, num_invalidate;
 
 	cls_session = starget_to_session(scsi_target(sc->device));
@@ -101,18 +102,35 @@ static int beiscsi_eh_abort(struct scsi_cmnd *sc)
 	inv_tbl->cid = cid;
 	inv_tbl->icd = aborted_io_task->psgl_handle->sgl_index;
 	num_invalidate = 1;
-	tag = mgmt_invalidate_icds(phba, inv_tbl, num_invalidate, cid);
+	nonemb_cmd.va = pci_alloc_consistent(phba->ctrl.pdev,
+				sizeof(struct invalidate_commands_params_in),
+				&nonemb_cmd.dma);
+	if (nonemb_cmd.va == NULL) {
+		SE_DEBUG(DBG_LVL_1,
+			 "Failed to allocate memory for"
+			 "mgmt_invalidate_icds\n");
+		return -1;
+	}
+	nonemb_cmd.size = sizeof(struct invalidate_commands_params_in);
+
+	tag = mgmt_invalidate_icds(phba, inv_tbl, num_invalidate,
+				   cid, &nonemb_cmd);
 	if (!tag) {
 		shost_printk(KERN_WARNING, phba->shost,
 			     "mgmt_invalidate_icds could not be"
 			     " submitted\n");
+		if (nonemb_cmd.va)
+			pci_free_consistent(phba->ctrl.pdev, nonemb_cmd.size,
+				    nonemb_cmd.va, nonemb_cmd.dma);
+
 		return FAILED;
 	} else {
 		wait_event_interruptible(phba->ctrl.mcc_wait[tag],
 					 phba->ctrl.mcc_numtag[tag]);
 		free_mcc_tag(&phba->ctrl, tag);
 	}
-
+	pci_free_consistent(phba->ctrl.pdev, nonemb_cmd.size,
+				    nonemb_cmd.va, nonemb_cmd.dma);
 	return iscsi_eh_abort(sc);
 }
 
@@ -126,6 +144,7 @@ static int beiscsi_eh_device_reset(struct scsi_cmnd *sc)
 	struct iscsi_session *session;
 	struct iscsi_cls_session *cls_session;
 	struct invalidate_command_table *inv_tbl;
+	struct be_dma_mem nonemb_cmd;
 	unsigned int cid, tag, i, num_invalidate;
 	int rc = FAILED;
 
@@ -160,18 +179,34 @@ static int beiscsi_eh_device_reset(struct scsi_cmnd *sc)
 	spin_unlock_bh(&session->lock);
 	inv_tbl = phba->inv_tbl;
 
-	tag = mgmt_invalidate_icds(phba, inv_tbl, num_invalidate, cid);
+	nonemb_cmd.va = pci_alloc_consistent(phba->ctrl.pdev,
+				sizeof(struct invalidate_commands_params_in),
+				&nonemb_cmd.dma);
+	if (nonemb_cmd.va == NULL) {
+		SE_DEBUG(DBG_LVL_1,
+			 "Failed to allocate memory for"
+			 "mgmt_invalidate_icds\n");
+		return -1;
+	}
+	nonemb_cmd.size = sizeof(struct invalidate_commands_params_in);
+	memset(nonemb_cmd.va, 0, nonemb_cmd.size);
+	tag = mgmt_invalidate_icds(phba, inv_tbl, num_invalidate,
+				   cid, &nonemb_cmd);
+
 	if (!tag) {
 		shost_printk(KERN_WARNING, phba->shost,
 			     "mgmt_invalidate_icds could not be"
 			     " submitted\n");
+		pci_free_consistent(phba->ctrl.pdev, nonemb_cmd.size,
+				    nonemb_cmd.va, nonemb_cmd.dma);
 		return FAILED;
 	} else {
 		wait_event_interruptible(phba->ctrl.mcc_wait[tag],
 					 phba->ctrl.mcc_numtag[tag]);
 		free_mcc_tag(&phba->ctrl, tag);
 	}
-
+	pci_free_consistent(phba->ctrl.pdev, nonemb_cmd.size,
+			    nonemb_cmd.va, nonemb_cmd.dma);
 	return iscsi_eh_device_reset(sc);
 unlock:
 	spin_unlock_bh(&session->lock);
diff --git a/drivers/scsi/be2iscsi/be_mgmt.c b/drivers/scsi/be2iscsi/be_mgmt.c
index 3eba889..c33aa3c 100644
--- a/drivers/scsi/be2iscsi/be_mgmt.c
+++ b/drivers/scsi/be2iscsi/be_mgmt.c
@@ -50,7 +50,7 @@ unsigned char mgmt_get_fw_config(struct be_ctrl_info *ctrl,
 					pfw_cfg->ulp[0].sq_count;
 		if (phba->fw_config.iscsi_cid_count > (BE2_MAX_SESSIONS / 2)) {
 			SE_DEBUG(DBG_LVL_8,
-				"FW reported MAX CXNS as %d \t"
+				"FW reported MAX CXNS as %d\t"
 				"Max Supported = %d.\n",
 				phba->fw_config.iscsi_cid_count,
 				BE2_MAX_SESSIONS);
@@ -146,9 +146,10 @@ unsigned char mgmt_epfw_cleanup(struct beiscsi_hba *phba, unsigned short chute)
 
 unsigned char mgmt_invalidate_icds(struct beiscsi_hba *phba,
 				struct invalidate_command_table *inv_tbl,
-				unsigned int num_invalidate, unsigned int cid)
+				unsigned int num_invalidate, unsigned int cid,
+				struct be_dma_mem *nonemb_cmd)
+
 {
-	struct be_dma_mem nonemb_cmd;
 	struct be_ctrl_info *ctrl = &phba->ctrl;
 	struct be_mcc_wrb *wrb;
 	struct be_sge *sge;
@@ -162,17 +163,7 @@ unsigned char mgmt_invalidate_icds(struct beiscsi_hba *phba,
 		return tag;
 	}
 
-	nonemb_cmd.va = pci_alloc_consistent(ctrl->pdev,
-				sizeof(struct invalidate_commands_params_in),
-				&nonemb_cmd.dma);
-	if (nonemb_cmd.va == NULL) {
-		SE_DEBUG(DBG_LVL_1,
-			 "Failed to alloc memory for mgmt_invalidate_icds\n");
-		spin_unlock(&ctrl->mbox_lock);
-		return 0;
-	}
-	nonemb_cmd.size = sizeof(struct invalidate_commands_params_in);
-	req = nonemb_cmd.va;
+	req = nonemb_cmd->va;
 	memset(req, 0, sizeof(*req));
 	wrb = wrb_from_mccq(phba);
 	sge = nonembedded_sgl(wrb);
@@ -190,15 +181,12 @@ unsigned char mgmt_invalidate_icds(struct beiscsi_hba *phba,
 		req->icd_count++;
 		inv_tbl++;
 	}
-	sge->pa_hi = cpu_to_le32(upper_32_bits(nonemb_cmd.dma));
-	sge->pa_lo = cpu_to_le32(nonemb_cmd.dma & 0xFFFFFFFF);
-	sge->len = cpu_to_le32(nonemb_cmd.size);
+	sge->pa_hi = cpu_to_le32(upper_32_bits(nonemb_cmd->dma));
+	sge->pa_lo = cpu_to_le32(nonemb_cmd->dma & 0xFFFFFFFF);
+	sge->len = cpu_to_le32(nonemb_cmd->size);
 
 	be_mcc_notify(phba);
 	spin_unlock(&ctrl->mbox_lock);
-	if (nonemb_cmd.va)
-		pci_free_consistent(ctrl->pdev, nonemb_cmd.size,
-				    nonemb_cmd.va, nonemb_cmd.dma);
 	return tag;
 }
 
@@ -269,7 +257,9 @@ unsigned char mgmt_upload_connection(struct beiscsi_hba *phba,
 
 int mgmt_open_connection(struct beiscsi_hba *phba,
 			 struct sockaddr *dst_addr,
-			 struct beiscsi_endpoint *beiscsi_ep)
+			 struct beiscsi_endpoint *beiscsi_ep,
+			 struct be_dma_mem *nonemb_cmd)
+
 {
 	struct hwi_controller *phwi_ctrlr;
 	struct hwi_context_memory *phwi_context;
@@ -285,6 +275,7 @@ int mgmt_open_connection(struct beiscsi_hba *phba,
 	unsigned int tag = 0;
 	unsigned int i;
 	unsigned short cid = beiscsi_ep->ep_cid;
+	struct be_sge *sge;
 
 	phwi_ctrlr = phba->phwi_ctrlr;
 	phwi_context = phwi_ctrlr->phwi_ctxt;
@@ -300,10 +291,14 @@ int mgmt_open_connection(struct beiscsi_hba *phba,
 		return tag;
 	}
 	wrb = wrb_from_mccq(phba);
-	req = embedded_payload(wrb);
+	memset(wrb, 0, sizeof(*wrb));
+	sge = nonembedded_sgl(wrb);
+
+	req = nonemb_cmd->va;
+	memset(req, 0, sizeof(*req));
 	wrb->tag0 |= tag;
 
-	be_wrb_hdr_prepare(wrb, sizeof(*req), true, 0);
+	be_wrb_hdr_prepare(wrb, sizeof(*req), true, 1);
 	be_cmd_hdr_prepare(&req->hdr, CMD_SUBSYSTEM_ISCSI,
 			   OPCODE_COMMON_ISCSI_TCP_CONNECT_AND_OFFLOAD,
 			   sizeof(*req));
@@ -346,6 +341,9 @@ int mgmt_open_connection(struct beiscsi_hba *phba,
 	req->do_offload = 1;
 	req->dataout_template_pa.lo = ptemplate_address->lo;
 	req->dataout_template_pa.hi = ptemplate_address->hi;
+	sge->pa_hi = cpu_to_le32(upper_32_bits(nonemb_cmd->dma));
+	sge->pa_lo = cpu_to_le32(nonemb_cmd->dma & 0xFFFFFFFF);
+	sge->len = cpu_to_le32(nonemb_cmd->size);
 	be_mcc_notify(phba);
 	spin_unlock(&ctrl->mbox_lock);
 	return tag;
diff --git a/drivers/scsi/be2iscsi/be_mgmt.h b/drivers/scsi/be2iscsi/be_mgmt.h
index 3d316b8..a1ae347 100644
--- a/drivers/scsi/be2iscsi/be_mgmt.h
+++ b/drivers/scsi/be2iscsi/be_mgmt.h
@@ -87,15 +87,17 @@ struct mcc_wrb {
 };
 
 unsigned char mgmt_epfw_cleanup(struct beiscsi_hba *phba, unsigned short chute);
-int mgmt_open_connection(struct beiscsi_hba *phba, struct sockaddr *dst_addr,
-			 struct beiscsi_endpoint *beiscsi_ep);
-
+int mgmt_open_connection(struct beiscsi_hba *phba,
+			 struct sockaddr *dst_addr,
+			 struct beiscsi_endpoint *beiscsi_ep,
+			 struct be_dma_mem *nonemb_cmd);
 unsigned char mgmt_upload_connection(struct beiscsi_hba *phba,
 				     unsigned short cid,
 				     unsigned int upload_flag);
 unsigned char mgmt_invalidate_icds(struct beiscsi_hba *phba,
 				struct invalidate_command_table *inv_tbl,
-				unsigned int num_invalidate, unsigned int cid);
+				unsigned int num_invalidate, unsigned int cid,
+				struct be_dma_mem *nonemb_cmd);
 
 struct iscsi_invalidate_connection_params_in {
 	struct be_cmd_req_hdr hdr;
-- 
1.6.5.2

