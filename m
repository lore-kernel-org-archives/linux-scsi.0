From: Jayamohan Kallickal <jayamohank@serverengines.com>
Subject: [PATCH 1/2] be2iscsi: Bug Fixes for starting with Non-Zero cid etc
Date: Wed, 4 Nov 2009 04:48:10 +0530
Message-ID: <20091103231758.GA2449@serverengines.com>
Reply-To: Jayamohan Kalickal <jayamohank@serverengines.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from segment-124-30.sify.net ([124.30.166.146]:5563 "EHLO
	akhaparde.serverengines.com" rhost-flags-OK-FAIL-OK-FAIL)
	by vger.kernel.org with ESMTP id S1751682AbZKCXR6 (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Tue, 3 Nov 2009 18:17:58 -0500
Content-Disposition: inline
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org
Cc: michaelc@cs.wisc.edu

 This patch contains fixes for condition where the first
cid is Non-Zero as well as other bugs.

Signed-off-by: Jayamohan Kallickal <jayamohank@serverengines.com>
---
 drivers/scsi/be2iscsi/be_iscsi.c |   11 ++-
 drivers/scsi/be2iscsi/be_main.c  |  164 ++++++++++++++++++++------------------
 drivers/scsi/be2iscsi/be_main.h  |   16 ++--
 drivers/scsi/be2iscsi/be_mgmt.c  |   13 +++-
 drivers/scsi/be2iscsi/be_mgmt.h  |    4 -
 5 files changed, 113 insertions(+), 95 deletions(-)

diff --git a/drivers/scsi/be2iscsi/be_iscsi.c b/drivers/scsi/be2iscsi/be_iscsi.c
index d587b03..ef11683 100644
--- a/drivers/scsi/be2iscsi/be_iscsi.c
+++ b/drivers/scsi/be2iscsi/be_iscsi.c
@@ -431,9 +431,10 @@ static int beiscsi_open_conn(struct iscsi_endpoint *ep,
 	}
 	SE_DEBUG(DBG_LVL_8, "In beiscsi_open_conn, ep_cid=%d ",
 		 beiscsi_ep->ep_cid);
-	phba->ep_array[beiscsi_ep->ep_cid] = ep;
-	if (beiscsi_ep->ep_cid >
-	    (phba->fw_config.iscsi_cid_start + phba->params.cxns_per_ctrl)) {
+	phba->ep_array[beiscsi_ep->ep_cid -
+		       phba->fw_config.iscsi_cid_start] = ep;
+	if (beiscsi_ep->ep_cid > (phba->fw_config.iscsi_cid_start +
+				  phba->params.cxns_per_ctrl * 2)) {
 		SE_DEBUG(DBG_LVL_1, "Failed in allocate iscsi cid\n");
 		return ret;
 	}
@@ -497,7 +498,7 @@ beiscsi_ep_connect(struct Scsi_Host *shost, struct sockaddr *dst_addr,
 
 	if (phba->state) {
 		ret = -EBUSY;
-		SE_DEBUG(DBG_LVL_1, "The Adapet state is Not UP \n");
+		SE_DEBUG(DBG_LVL_1, "The Adapter state is Not UP \n");
 		return ERR_PTR(ret);
 	}
 
@@ -511,7 +512,7 @@ beiscsi_ep_connect(struct Scsi_Host *shost, struct sockaddr *dst_addr,
 	beiscsi_ep->phba = phba;
 
 	if (beiscsi_open_conn(ep, NULL, dst_addr, non_blocking)) {
-		SE_DEBUG(DBG_LVL_1, "Failed in allocate iscsi cid\n");
+		SE_DEBUG(DBG_LVL_1, "Failed in beiscsi_open_conn \n");
 		ret = -ENOMEM;
 		goto free_ep;
 	}
diff --git a/drivers/scsi/be2iscsi/be_main.c b/drivers/scsi/be2iscsi/be_main.c
index d15df07..06e1aa6 100644
--- a/drivers/scsi/be2iscsi/be_main.c
+++ b/drivers/scsi/be2iscsi/be_main.c
@@ -59,7 +59,6 @@ static int beiscsi_slave_configure(struct scsi_device *sdev)
 	return 0;
 }
 
-/*------------------- PCI Driver operations and data ----------------- */
 static DEFINE_PCI_DEVICE_TABLE(beiscsi_pci_id_table) = {
 	{ PCI_DEVICE(BE_VENDOR_ID, BE_DEVICE_ID1) },
 	{ PCI_DEVICE(BE_VENDOR_ID, OC_DEVICE_ID1) },
@@ -87,6 +86,7 @@ static struct scsi_host_template beiscsi_sht = {
 	.max_sectors = BEISCSI_MAX_SECTORS,
 	.cmd_per_lun = BEISCSI_CMD_PER_LUN,
 	.use_clustering = ENABLE_CLUSTERING,
+	.vendor_id = BEISCSI_VENDOR_ID,
 };
 
 static struct scsi_transport_template *beiscsi_scsi_transport;
@@ -112,6 +112,7 @@ static struct beiscsi_hba *beiscsi_hba_alloc(struct pci_dev *pcidev)
 	memset(phba, 0, sizeof(*phba));
 	phba->shost = shost;
 	phba->pcidev = pci_dev_get(pcidev);
+	pci_set_drvdata(pcidev, phba);
 
 	if (iscsi_host_add(shost, &phba->pcidev->dev))
 		goto free_devices;
@@ -230,29 +231,27 @@ static int be_ctrl_init(struct beiscsi_hba *phba, struct pci_dev *pdev)
 
 static void beiscsi_get_params(struct beiscsi_hba *phba)
 {
-	phba->params.ios_per_ctrl = BE2_IO_DEPTH;
-	phba->params.cxns_per_ctrl = BE2_MAX_SESSIONS;
-	phba->params.asyncpdus_per_ctrl = BE2_ASYNCPDUS;
-	phba->params.icds_per_ctrl = BE2_MAX_ICDS / 2;
+	phba->params.ios_per_ctrl = (phba->fw_config.iscsi_icd_count
+				    - (phba->fw_config.iscsi_cid_count
+				    + BE2_TMFS
+				    + BE2_NOPOUT_REQ));
+	phba->params.cxns_per_ctrl = phba->fw_config.iscsi_cid_count;
+	phba->params.asyncpdus_per_ctrl = phba->fw_config.iscsi_cid_count;;
+	phba->params.icds_per_ctrl = phba->fw_config.iscsi_icd_count;;
 	phba->params.num_sge_per_io = BE2_SGE;
 	phba->params.defpdu_hdr_sz = BE2_DEFPDU_HDR_SZ;
 	phba->params.defpdu_data_sz = BE2_DEFPDU_DATA_SZ;
 	phba->params.eq_timer = 64;
 	phba->params.num_eq_entries =
-	    (((BE2_CMDS_PER_CXN * 2 + BE2_LOGOUTS + BE2_TMFS + BE2_ASYNCPDUS) /
-								512) + 1) * 512;
+	    (((BE2_CMDS_PER_CXN * 2 + phba->fw_config.iscsi_cid_count * 2
+				    + BE2_TMFS) / 512) + 1) * 512;
 	phba->params.num_eq_entries = (phba->params.num_eq_entries < 1024)
 				? 1024 : phba->params.num_eq_entries;
 	SE_DEBUG(DBG_LVL_8, "phba->params.num_eq_entries=%d \n",
-		 phba->params.num_eq_entries);
+			     phba->params.num_eq_entries);
 	phba->params.num_cq_entries =
-	    (((BE2_CMDS_PER_CXN * 2 + BE2_LOGOUTS + BE2_TMFS + BE2_ASYNCPDUS) /
-								512) + 1) * 512;
-	SE_DEBUG(DBG_LVL_8,
-		"phba->params.num_cq_entries=%d BE2_CMDS_PER_CXN=%d"
-		"BE2_LOGOUTS=%d BE2_TMFS=%d BE2_ASYNCPDUS=%d \n",
-		phba->params.num_cq_entries, BE2_CMDS_PER_CXN,
-		BE2_LOGOUTS, BE2_TMFS, BE2_ASYNCPDUS);
+	    (((BE2_CMDS_PER_CXN * 2 +  phba->fw_config.iscsi_cid_count * 2
+				    + BE2_TMFS) / 512) + 1) * 512;
 	phba->params.wrbs_per_cxn = 256;
 }
 
@@ -566,6 +565,8 @@ beiscsi_process_async_pdu(struct beiscsi_conn *beiscsi_conn,
 		login_hdr = (struct iscsi_hdr *)ppdu;
 		login_hdr->itt = io_task->libiscsi_itt;
 		break;
+	case ISCSI_OP_TEXT_RSP:
+		break;
 	default:
 		shost_printk(KERN_WARNING, phba->shost,
 			     "Unrecognized opcode 0x%x in async msg \n",
@@ -630,7 +631,6 @@ free_io_sgl_handle(struct beiscsi_hba *phba, struct sgl_handle *psgl_handle)
 /**
  * alloc_wrb_handle - To allocate a wrb handle
  * @phba: The hba pointer
- * @cid: The cid to use for allocation
  * @index: index allocation and wrb index
  *
  * This happens under session_lock until submission to chip
@@ -640,20 +640,22 @@ struct wrb_handle *alloc_wrb_handle(struct beiscsi_hba *phba, unsigned int cid,
 {
 	struct hwi_wrb_context *pwrb_context;
 	struct hwi_controller *phwi_ctrlr;
-	struct wrb_handle *pwrb_handle;
+	struct wrb_handle *pwrb_handle, *pwrb_handle_tmp;
 
 	phwi_ctrlr = phba->phwi_ctrlr;
 	pwrb_context = &phwi_ctrlr->wrb_context[cid];
-	if (pwrb_context->wrb_handles_available) {
+	if (pwrb_context->wrb_handles_available >= 2) {
 		pwrb_handle = pwrb_context->pwrb_handle_base[
 					    pwrb_context->alloc_index];
 		pwrb_context->wrb_handles_available--;
-		pwrb_handle->nxt_wrb_index = pwrb_handle->wrb_index;
 		if (pwrb_context->alloc_index ==
 						(phba->params.wrbs_per_cxn - 1))
 			pwrb_context->alloc_index = 0;
 		else
 			pwrb_context->alloc_index++;
+		pwrb_handle_tmp = pwrb_context->pwrb_handle_base[
+						pwrb_context->alloc_index];
+		pwrb_handle->nxt_wrb_index = pwrb_handle_tmp->wrb_index;
 	} else
 		pwrb_handle = NULL;
 	return pwrb_handle;
@@ -790,6 +792,7 @@ be_complete_io(struct beiscsi_conn *beiscsi_conn,
 		memcpy(task->sc->sense_buffer, sense,
 		       min_t(u16, sense_len, SCSI_SENSE_BUFFERSIZE));
 	}
+
 	if (io_task->cmd_bhs->iscsi_hdr.flags & ISCSI_FLAG_CMD_READ) {
 		if (psol->dw[offsetof(struct amap_sol_cqe, i_res_cnt) / 32]
 							& SOL_RES_CNT_MASK)
@@ -811,6 +814,7 @@ be_complete_logout(struct beiscsi_conn *beiscsi_conn,
 	struct iscsi_conn *conn = beiscsi_conn->conn;
 
 	hdr = (struct iscsi_logout_rsp *)task->hdr;
+	hdr->opcode = ISCSI_OP_LOGOUT_RSP;
 	hdr->t2wait = 5;
 	hdr->t2retain = 0;
 	hdr->flags = ((psol->dw[offsetof(struct amap_sol_cqe, i_flags) / 32]
@@ -825,6 +829,9 @@ be_complete_logout(struct beiscsi_conn *beiscsi_conn,
 					& SOL_EXP_CMD_SN_MASK) +
 			((psol->dw[offsetof(struct amap_sol_cqe, i_cmd_wnd)
 					/ 32] & SOL_CMD_WND_MASK) >> 24) - 1);
+	hdr->dlength[0] = 0;
+	hdr->dlength[1] = 0;
+	hdr->dlength[2] = 0;
 	hdr->hlength = 0;
 	hdr->itt = io_task->libiscsi_itt;
 	__iscsi_complete_pdu(conn, (struct iscsi_hdr *)hdr, NULL, 0);
@@ -839,6 +846,7 @@ be_complete_tmf(struct beiscsi_conn *beiscsi_conn,
 	struct beiscsi_io_task *io_task = task->dd_data;
 
 	hdr = (struct iscsi_tm_rsp *)task->hdr;
+	hdr->opcode = ISCSI_OP_SCSI_TMFUNC_RSP;
 	hdr->flags = ((psol->dw[offsetof(struct amap_sol_cqe, i_flags) / 32]
 					& SOL_FLAGS_MASK) >> 24) | 0x80;
 	hdr->response = (psol->dw[offsetof(struct amap_sol_cqe, i_resp) /
@@ -877,7 +885,8 @@ hwi_complete_drvr_msgs(struct beiscsi_conn *beiscsi_conn,
 	} else {
 		pwrb_context = &phwi_ctrlr->wrb_context[((psol->
 				dw[offsetof(struct amap_sol_cqe, cid) / 32] &
-				SOL_CID_MASK) >> 6)];
+				SOL_CID_MASK) >> 6) -
+				phba->fw_config.iscsi_cid_start];
 		pwrb_handle = pwrb_context->pwrb_handle_basestd[((psol->
 				dw[offsetof(struct amap_sol_cqe, wrb_index) /
 				32] & SOL_WRB_INDEX_MASK) >> 16)];
@@ -939,7 +948,8 @@ static void hwi_complete_cmd(struct beiscsi_conn *beiscsi_conn,
 		pwrb_context = &phwi_ctrlr->
 				wrb_context[((psol->dw[offsetof
 				(struct amap_sol_cqe, cid) / 32]
-				& SOL_CID_MASK) >> 6)];
+				& SOL_CID_MASK) >> 6) -
+				phba->fw_config.iscsi_cid_start];
 		pwrb_handle = pwrb_context->pwrb_handle_basestd[((psol->
 				dw[offsetof(struct amap_sol_cqe, wrb_index) /
 				32] & SOL_WRB_INDEX_MASK) >> 16)];
@@ -1077,7 +1087,8 @@ hwi_get_async_handle(struct beiscsi_hba *phba,
 
 	WARN_ON(!pasync_handle);
 
-	pasync_handle->cri = (unsigned short)beiscsi_conn->beiscsi_conn_cid;
+	pasync_handle->cri = (unsigned short)beiscsi_conn->beiscsi_conn_cid -
+					     phba->fw_config.iscsi_cid_start;
 	pasync_handle->is_header = is_header;
 	pasync_handle->buffer_len = ((pdpdu_cqe->
 			dw[offsetof(struct amap_i_t_dpdu_cqe, dpl) / 32]
@@ -1327,9 +1338,10 @@ hwi_fwd_async_msg(struct beiscsi_conn *beiscsi_conn,
 	}
 
 	status = beiscsi_process_async_pdu(beiscsi_conn, phba,
-					   beiscsi_conn->beiscsi_conn_cid,
-					   phdr, hdr_len, pfirst_buffer,
-					   buf_len);
+					   (beiscsi_conn->beiscsi_conn_cid -
+					    phba->fw_config.iscsi_cid_start),
+					    phdr, hdr_len, pfirst_buffer,
+					    buf_len);
 
 	if (status == 0)
 		hwi_free_async_msg(phba, cri);
@@ -1432,6 +1444,8 @@ static unsigned int beiscsi_process_cq(struct be_eq_obj *pbe_eq)
 	unsigned int tot_nump = 0;
 	struct beiscsi_conn *beiscsi_conn;
 	struct sgl_handle *psgl_handle = NULL;
+	struct beiscsi_endpoint *beiscsi_ep;
+	struct iscsi_endpoint *ep;
 	struct beiscsi_hba *phba;
 
 	cq = pbe_eq->cq;
@@ -1447,27 +1461,15 @@ static unsigned int beiscsi_process_cq(struct be_eq_obj *pbe_eq)
 				      dw[offsetof(struct amap_sol_cqe_ring,
 				      icd_index) / 32] & SOL_ICD_INDEX_MASK)
 				      >> 6)];
-			beiscsi_conn = phba->conn_table[psgl_handle->cid];
-			if (!beiscsi_conn || !beiscsi_conn->ep) {
-				shost_printk(KERN_WARNING, phba->shost,
-				     "Connection table empty for cid = %d\n",
-				      psgl_handle->cid);
-				return 0;
-			}
-
+			ep = phba->ep_array[psgl_handle->cid];
 		} else {
-			beiscsi_conn = phba->conn_table[(u32) (sol->
-				 dw[offsetof(struct amap_sol_cqe, cid) / 32] &
-				 SOL_CID_MASK) >> 6];
-
-			if (!beiscsi_conn || !beiscsi_conn->ep) {
-				shost_printk(KERN_WARNING, phba->shost,
-				     "Connection table empty for cid = %d\n",
-				     (u32)(sol->dw[offsetof(struct amap_sol_cqe,
-				     cid) / 32] & SOL_CID_MASK) >> 6);
-				return 0;
-			}
+			ep = phba->ep_array[(u32) ((sol->
+				   dw[offsetof(struct amap_sol_cqe, cid) / 32] &
+				   SOL_CID_MASK) >> 6) -
+				   phba->fw_config.iscsi_cid_start];
 		}
+		beiscsi_ep = ep->dd_data;
+		beiscsi_conn = beiscsi_ep->conn;
 
 		if (num_processed >= 32) {
 			hwi_ring_cq_db(phba, cq->id,
@@ -1557,8 +1559,8 @@ static unsigned int beiscsi_process_cq(struct be_eq_obj *pbe_eq)
 				 "0x%x...\n",
 				 sol->dw[offsetof(struct amap_sol_cqe, code) /
 				 32] & CQE_CODE_MASK,
-				 sol->dw[offsetof(struct amap_sol_cqe, cid) /
-				 32] & CQE_CID_MASK);
+				 (sol->dw[offsetof(struct amap_sol_cqe, cid) /
+				 32] & CQE_CID_MASK));
 			}
 			iscsi_conn_failure(beiscsi_conn->conn,
 					   ISCSI_ERR_CONN_FAILED);
@@ -1575,8 +1577,8 @@ static unsigned int beiscsi_process_cq(struct be_eq_obj *pbe_eq)
 				"received/sent on CID 0x%x...\n",
 				 sol->dw[offsetof(struct amap_sol_cqe, code) /
 				 32] & CQE_CODE_MASK,
-				 sol->dw[offsetof(struct amap_sol_cqe, cid) /
-				 32] & CQE_CID_MASK);
+				 (sol->dw[offsetof(struct amap_sol_cqe, cid) /
+				 32] & CQE_CID_MASK));
 			}
 			iscsi_conn_failure(beiscsi_conn->conn,
 					   ISCSI_ERR_CONN_FAILED);
@@ -1586,8 +1588,8 @@ static unsigned int beiscsi_process_cq(struct be_eq_obj *pbe_eq)
 				 "received on CID 0x%x...\n",
 				 sol->dw[offsetof(struct amap_sol_cqe, code) /
 				 32] & CQE_CODE_MASK,
-				 sol->dw[offsetof(struct amap_sol_cqe, cid) /
-				 32] & CQE_CID_MASK);
+				 (sol->dw[offsetof(struct amap_sol_cqe, cid) /
+				 32] & CQE_CID_MASK));
 			break;
 		}
 
@@ -2383,7 +2385,7 @@ static int beiscsi_create_cqs(struct beiscsi_hba *phba,
 						     &paddr);
 		if (!cq_vaddress)
 			goto create_cq_error;
-		ret = be_fill_queue(cq, phba->params.icds_per_ctrl / 2,
+		ret = be_fill_queue(cq, phba->params.num_cq_entries,
 				    sizeof(struct sol_cqe), cq_vaddress);
 		if (ret) {
 			shost_printk(KERN_ERR, phba->shost,
@@ -2634,7 +2636,8 @@ beiscsi_create_wrb_rings(struct beiscsi_hba *phba,
 				     "wrbq create failed.");
 			return status;
 		}
-		phwi_ctrlr->wrb_context[i].cid = phwi_context->be_wrbq[i].id;
+		phwi_ctrlr->wrb_context[i * 2].cid = phwi_context->be_wrbq[i].
+								   id;
 	}
 	kfree(pwrb_arr);
 	return 0;
@@ -2807,12 +2810,6 @@ static int hwi_init_port(struct beiscsi_hba *phba)
 		ring_mode = 1;
 	else
 		ring_mode = 0;
-	status = mgmt_get_fw_config(ctrl, phba);
-	if (status != 0) {
-		shost_printk(KERN_ERR, phba->shost,
-			     "Error getting fw config\n");
-		goto error;
-	}
 
 	status = beiscsi_create_cqs(phba, phwi_context);
 	if (status != 0) {
@@ -3032,7 +3029,7 @@ static int beiscsi_init_sgl_handle(struct beiscsi_hba *phba)
 			AMAP_SET_BITS(struct amap_iscsi_sge, addr_lo, pfrag, 0);
 			pfrag += phba->params.num_sge_per_io;
 			psgl_handle->sgl_index =
-				phba->fw_config.iscsi_cid_start + arr_index++;
+				phba->fw_config.iscsi_icd_start + arr_index++;
 		}
 		idx++;
 	}
@@ -3047,7 +3044,7 @@ static int hba_setup_cid_tbls(struct beiscsi_hba *phba)
 {
 	int i, new_cid;
 
-	phba->cid_array = kmalloc(sizeof(void *) * phba->params.cxns_per_ctrl,
+	phba->cid_array = kzalloc(sizeof(void *) * phba->params.cxns_per_ctrl,
 				  GFP_KERNEL);
 	if (!phba->cid_array) {
 		shost_printk(KERN_ERR, phba->shost,
@@ -3055,7 +3052,7 @@ static int hba_setup_cid_tbls(struct beiscsi_hba *phba)
 			     "hba_setup_cid_tbls\n");
 		return -ENOMEM;
 	}
-	phba->ep_array = kmalloc(sizeof(struct iscsi_endpoint *) *
+	phba->ep_array = kzalloc(sizeof(struct iscsi_endpoint *) *
 				 phba->params.cxns_per_ctrl * 2, GFP_KERNEL);
 	if (!phba->ep_array) {
 		shost_printk(KERN_ERR, phba->shost,
@@ -3064,7 +3061,7 @@ static int hba_setup_cid_tbls(struct beiscsi_hba *phba)
 		kfree(phba->cid_array);
 		return -ENOMEM;
 	}
-	new_cid = phba->fw_config.iscsi_icd_start;
+	new_cid = phba->fw_config.iscsi_cid_start;
 	for (i = 0; i < phba->params.cxns_per_ctrl; i++) {
 		phba->cid_array[i] = new_cid;
 		new_cid += 2;
@@ -3219,7 +3216,8 @@ beiscsi_offload_connection(struct beiscsi_conn *beiscsi_conn,
 	 * We can always use 0 here because it is reserved by libiscsi for
 	 * login/startup related tasks.
 	 */
-	pwrb_handle = alloc_wrb_handle(phba, beiscsi_conn->beiscsi_conn_cid, 0);
+	pwrb_handle = alloc_wrb_handle(phba, (beiscsi_conn->beiscsi_conn_cid -
+				       phba->fw_config.iscsi_cid_start), 0);
 	pwrb = (struct iscsi_target_context_update_wrb *)pwrb_handle->pwrb;
 	memset(pwrb, 0, sizeof(*pwrb));
 	AMAP_SET_BITS(struct amap_iscsi_target_context_update_wrb,
@@ -3328,7 +3326,8 @@ static int beiscsi_alloc_pdu(struct iscsi_task *task, uint8_t opcode)
 	io_task->bhs_pa.u.a64.address = paddr;
 	io_task->libiscsi_itt = (itt_t)task->itt;
 	io_task->pwrb_handle = alloc_wrb_handle(phba,
-						beiscsi_conn->beiscsi_conn_cid,
+						beiscsi_conn->beiscsi_conn_cid -
+						phba->fw_config.iscsi_cid_start,
 						task->itt);
 	io_task->conn = beiscsi_conn;
 
@@ -3343,7 +3342,7 @@ static int beiscsi_alloc_pdu(struct iscsi_task *task, uint8_t opcode)
 			goto free_hndls;
 	} else {
 		io_task->scsi_cmnd = NULL;
-		if ((task->hdr->opcode & ISCSI_OPCODE_MASK) == ISCSI_OP_LOGIN) {
+		if ((opcode & ISCSI_OPCODE_MASK) == ISCSI_OP_LOGIN) {
 			if (!beiscsi_conn->login_in_progress) {
 				spin_lock(&phba->mgmt_sgl_lock);
 				io_task->psgl_handle = (struct sgl_handle *)
@@ -3372,10 +3371,11 @@ static int beiscsi_alloc_pdu(struct iscsi_task *task, uint8_t opcode)
 				(io_task->psgl_handle->sgl_index));
 	if (ring_mode) {
 		phba->sgl_hndl_array[io_task->psgl_handle->sgl_index -
-				     phba->fw_config.iscsi_cid_start] =
+				     phba->fw_config.iscsi_icd_start] =
 				     io_task->psgl_handle;
 		io_task->psgl_handle->task = task;
-		io_task->psgl_handle->cid = beiscsi_conn->beiscsi_conn_cid;
+		io_task->psgl_handle->cid = beiscsi_conn->beiscsi_conn_cid  -
+					    phba->fw_config.iscsi_cid_start;
 	} else
 		io_task->pwrb_handle->pio_handle = task;
 
@@ -3384,7 +3384,9 @@ static int beiscsi_alloc_pdu(struct iscsi_task *task, uint8_t opcode)
 
 free_hndls:
 	phwi_ctrlr = phba->phwi_ctrlr;
-	pwrb_context = &phwi_ctrlr->wrb_context[beiscsi_conn->beiscsi_conn_cid];
+	pwrb_context = &phwi_ctrlr->wrb_context[
+			beiscsi_conn->beiscsi_conn_cid -
+			phba->fw_config.iscsi_cid_start];
 	free_wrb_handle(phba, pwrb_context, io_task->pwrb_handle);
 	io_task->pwrb_handle = NULL;
 	pci_pool_free(beiscsi_sess->bhs_pool, io_task->cmd_bhs,
@@ -3404,7 +3406,8 @@ static void beiscsi_cleanup_task(struct iscsi_task *task)
 	struct hwi_controller *phwi_ctrlr;
 
 	phwi_ctrlr = phba->phwi_ctrlr;
-	pwrb_context = &phwi_ctrlr->wrb_context[beiscsi_conn->beiscsi_conn_cid];
+	pwrb_context = &phwi_ctrlr->wrb_context[beiscsi_conn->beiscsi_conn_cid
+			- phba->fw_config.iscsi_cid_start];
 	if (io_task->pwrb_handle) {
 		free_wrb_handle(phba, pwrb_context, io_task->pwrb_handle);
 		io_task->pwrb_handle = NULL;
@@ -3546,6 +3549,10 @@ static int beiscsi_mtask(struct iscsi_task *task)
 		else
 			AMAP_SET_BITS(struct amap_iscsi_wrb, type, pwrb,
 				      INI_RD_CMD);
+		if (task->hdr->ttt == ISCSI_RESERVED_TAG)
+			AMAP_SET_BITS(struct amap_iscsi_wrb, dmsg, pwrb, 0);
+		else
+			AMAP_SET_BITS(struct amap_iscsi_wrb, dmsg, pwrb, 1);
 		hwi_write_buffer(pwrb, task);
 		break;
 	case ISCSI_OP_TEXT:
@@ -3554,6 +3561,7 @@ static int beiscsi_mtask(struct iscsi_task *task)
 		else
 			AMAP_SET_BITS(struct amap_iscsi_wrb, type, pwrb,
 				      INI_WR_CMD);
+		AMAP_SET_BITS(struct amap_iscsi_wrb, dmsg, pwrb, 0);
 		AMAP_SET_BITS(struct amap_iscsi_wrb, dsp, pwrb, 1);
 		hwi_write_buffer(pwrb, task);
 		break;
@@ -3561,7 +3569,8 @@ static int beiscsi_mtask(struct iscsi_task *task)
 		session = conn->session;
 		i = ((struct iscsi_tm *)task->hdr)->rtt;
 		phwi_ctrlr = phba->phwi_ctrlr;
-		pwrb_context = &phwi_ctrlr->wrb_context[cid];
+		pwrb_context = &phwi_ctrlr->wrb_context[cid -
+					    phba->fw_config.iscsi_cid_start];
 		pwrb_handle = pwrb_context->pwrb_handle_basestd[be32_to_cpu(i)
 								>> 16];
 		aborted_task = pwrb_handle->pio_handle;
@@ -3600,7 +3609,7 @@ static int beiscsi_mtask(struct iscsi_task *task)
 	}
 
 	AMAP_SET_BITS(struct amap_iscsi_wrb, r2t_exp_dtl, pwrb,
-		      be32_to_cpu(task->data_count));
+		      task->data_count);
 	AMAP_SET_BITS(struct amap_iscsi_wrb, ptr2nextwrb, pwrb,
 		      io_task->pwrb_handle->nxt_wrb_index);
 	be_dws_le_to_cpu(pwrb, sizeof(struct iscsi_wrb));
@@ -3636,8 +3645,6 @@ static int beiscsi_task_xmit(struct iscsi_task *task)
 		SE_DEBUG(DBG_LVL_1, " scsi_dma_map Failed\n")
 		return num_sg;
 	}
-	SE_DEBUG(DBG_LVL_4, "xferlen=0x%08x scmd=%p num_sg=%d sernum=%lu\n",
-		  (scsi_bufflen(sc)), sc, num_sg, sc->serial_number);
 	xferlen = scsi_bufflen(sc);
 	sg = scsi_sglist(sc);
 	if (sc->sc_data_direction == DMA_TO_DEVICE) {
@@ -3649,7 +3656,6 @@ static int beiscsi_task_xmit(struct iscsi_task *task)
 	return beiscsi_iotask(task, sg, num_sg, xferlen, writedir);
 }
 
-
 static void beiscsi_remove(struct pci_dev *pcidev)
 {
 	struct beiscsi_hba *phba = NULL;
@@ -3732,9 +3738,7 @@ static int __devinit beiscsi_dev_probe(struct pci_dev *pcidev,
 			" Failed in beiscsi_hba_alloc \n");
 		goto disable_pci;
 	}
-	SE_DEBUG(DBG_LVL_8, " phba = %p \n", phba);
 
-	pci_set_drvdata(pcidev, phba);
 	if (enable_msix)
 		num_cpus = find_num_cpus();
 	else
@@ -3754,6 +3758,14 @@ static int __devinit beiscsi_dev_probe(struct pci_dev *pcidev,
 	spin_lock_init(&phba->io_sgl_lock);
 	spin_lock_init(&phba->mgmt_sgl_lock);
 	spin_lock_init(&phba->isr_lock);
+	ret = mgmt_get_fw_config(&phba->ctrl, phba);
+	if (ret != 0) {
+		shost_printk(KERN_ERR, phba->shost,
+			     "Error getting fw config\n");
+		goto free_port;
+	}
+	phba->shost->max_id = phba->fw_config.iscsi_cid_count;
+	phba->shost->can_queue = phba->params.ios_per_ctrl;
 	beiscsi_get_params(phba);
 	ret = beiscsi_init_port(phba);
 	if (ret < 0) {
diff --git a/drivers/scsi/be2iscsi/be_main.h b/drivers/scsi/be2iscsi/be_main.h
index 25e6b20..a82297c 100644
--- a/drivers/scsi/be2iscsi/be_main.h
+++ b/drivers/scsi/be2iscsi/be_main.h
@@ -27,6 +27,7 @@
 #include <scsi/scsi.h>
 #include <scsi/scsi_cmnd.h>
 #include <scsi/scsi_device.h>
+#include <scsi/scsi_netlink.h>
 #include <scsi/scsi_host.h>
 #include <scsi/iscsi_proto.h>
 #include <scsi/libiscsi.h>
@@ -46,23 +47,18 @@
 #define OC_DEVICE_ID3		0x712
 #define OC_DEVICE_ID4		0x222
 
-#define BE2_MAX_SESSIONS	64
+#define BE2_IO_DEPTH		1024
+#define BE2_MAX_SESSIONS	256
 #define BE2_CMDS_PER_CXN	128
-#define BE2_LOGOUTS		BE2_MAX_SESSIONS
 #define BE2_TMFS		16
 #define BE2_NOPOUT_REQ		16
-#define BE2_ASYNCPDUS		BE2_MAX_SESSIONS
-#define BE2_MAX_ICDS		2048
 #define BE2_SGE			32
 #define BE2_DEFPDU_HDR_SZ	64
 #define BE2_DEFPDU_DATA_SZ	8192
-#define BE2_IO_DEPTH \
-	(BE2_MAX_ICDS / 2 - (BE2_LOGOUTS + BE2_TMFS + BE2_NOPOUT_REQ))
 
 #define MAX_CPUS		31
 #define BEISCSI_SGLIST_ELEMENTS	BE2_SGE
 
-#define BEISCSI_MAX_CMNDS	1024	/* Max IO's per Ctrlr sht->can_queue */
 #define BEISCSI_CMD_PER_LUN	128	/* scsi_host->cmd_per_lun */
 #define BEISCSI_MAX_SECTORS	2048	/* scsi_host->max_sectors */
 
@@ -79,6 +75,11 @@
 #define MAX_CMD_SZ			65536
 #define IIOC_SCSI_DATA                  0x05	/* Write Operation */
 
+/* vendor ID used in SCSI netlink calls */
+#define PCI_VENDOR_ID_SERVERENGINES 0x19a2
+#define BEISCSI_VENDOR_ID (SCSI_NL_VID_TYPE_PCI | PCI_VENDOR_ID_SERVERENGINES)
+
+
 #define DBG_LVL				0x00000001
 #define DBG_LVL_1			0x00000001
 #define DBG_LVL_2			0x00000002
@@ -802,7 +803,6 @@ struct hwi_controller {
 	struct be_ring default_pdu_hdr;
 	struct be_ring default_pdu_data;
 	struct hwi_context_memory *phwi_ctxt;
-	unsigned short cq_errors[CXN_KILLED_CMND_DATA_NOT_ON_SAME_CONN];
 };
 
 enum hwh_type_enum {
diff --git a/drivers/scsi/be2iscsi/be_mgmt.c b/drivers/scsi/be2iscsi/be_mgmt.c
index 79c2bd5..8bfb574 100644
--- a/drivers/scsi/be2iscsi/be_mgmt.c
+++ b/drivers/scsi/be2iscsi/be_mgmt.c
@@ -20,6 +20,7 @@
 
 #include "be_mgmt.h"
 #include "be_iscsi.h"
+#include <scsi/scsi_transport_iscsi.h>
 
 unsigned char mgmt_get_fw_config(struct be_ctrl_info *ctrl,
 				struct beiscsi_hba *phba)
@@ -48,6 +49,14 @@ unsigned char mgmt_get_fw_config(struct be_ctrl_info *ctrl,
 					pfw_cfg->ulp[0].sq_base;
 		phba->fw_config.iscsi_cid_count =
 					pfw_cfg->ulp[0].sq_count;
+		if (phba->fw_config.iscsi_cid_count > (BE2_MAX_SESSIONS / 2)) {
+			status = 1;
+			shost_printk(KERN_WARNING, phba->shost,
+			     "FW reported MAX CXNS as %d \t"
+			     "Max Supported = %d. Failing to load \n",
+					phba->fw_config.iscsi_cid_count,
+					BE2_MAX_SESSIONS);
+		}
 	} else {
 		shost_printk(KERN_WARNING, phba->shost,
 			     "Failed in mgmt_get_fw_config \n");
@@ -108,7 +117,6 @@ unsigned char mgmt_check_supported_fw(struct be_ctrl_info *ctrl,
 	return status;
 }
 
-
 unsigned char mgmt_epfw_cleanup(struct beiscsi_hba *phba, unsigned short chute)
 {
 	struct be_ctrl_info *ctrl = &phba->ctrl;
@@ -317,7 +325,8 @@ int mgmt_open_connection(struct beiscsi_hba *phba,
 		struct tcp_connect_and_offload_out *ptcpcnct_out =
 							embedded_payload(wrb);
 
-		ep = phba->ep_array[ptcpcnct_out->cid];
+		ep = phba->ep_array[ptcpcnct_out->cid -
+				    phba->fw_config.iscsi_cid_start];
 		beiscsi_ep = ep->dd_data;
 		beiscsi_ep->fw_handle = ptcpcnct_out->connection_handle;
 		beiscsi_ep->cid_vld = 1;
diff --git a/drivers/scsi/be2iscsi/be_mgmt.h b/drivers/scsi/be2iscsi/be_mgmt.h
index 24eaff9..b97c3cd 100644
--- a/drivers/scsi/be2iscsi/be_mgmt.h
+++ b/drivers/scsi/be2iscsi/be_mgmt.h
@@ -248,8 +248,4 @@ unsigned char mgmt_invalidate_connection(struct beiscsi_hba *phba,
 					 unsigned short cid,
 					 unsigned short issue_reset,
 					 unsigned short savecfg_flag);
-
-unsigned char mgmt_fw_cmd(struct be_ctrl_info *ctrl,
-			  struct beiscsi_hba *phba,
-			  char *buf, unsigned int len);
 #endif
-- 
1.6.4

