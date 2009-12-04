From: Jayamohan Kallickal <jayamohank@serverengines.com>
Subject: [PATCH 01/15] be2iscsi: Use start cid and number of cid and icd
 from FW
Date: Fri, 4 Dec 2009 08:47:23 +0530
Message-ID: <20091204031714.GA5977@serverengines.com>
Reply-To: Jayamohan Kalickal <jayamohank@serverengines.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from segment-124-30.sify.net ([124.30.166.146]:6520 "EHLO
	akhaparde.serverengines.com" rhost-flags-OK-FAIL-OK-FAIL)
	by vger.kernel.org with ESMTP id S1752834AbZLDDRK (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Thu, 3 Dec 2009 22:17:10 -0500
Content-Disposition: inline
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org
Cc: James.Bottomley@suse.de, michaelc@cs.wisc.edu

  This patch enablesi be2iscsi to use the start number and number
 of cids/icd provided by FW rather than hard coded values.

Signed-off-by: Jayamohan Kallickal <jayamohank@serverengines.com>
---
 drivers/scsi/be2iscsi/be_iscsi.c |    7 ++-
 drivers/scsi/be2iscsi/be_main.c  |  106 +++++++++++++++++++++-----------------
 drivers/scsi/be2iscsi/be_main.h  |   10 +---
 drivers/scsi/be2iscsi/be_mgmt.c  |   11 ++++-
 4 files changed, 75 insertions(+), 59 deletions(-)

diff --git a/drivers/scsi/be2iscsi/be_iscsi.c b/drivers/scsi/be2iscsi/be_iscsi.c
index d587b03..2b3c58b 100644
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
diff --git a/drivers/scsi/be2iscsi/be_main.c b/drivers/scsi/be2iscsi/be_main.c
index 1a557fa..6c512b6 100644
--- a/drivers/scsi/be2iscsi/be_main.c
+++ b/drivers/scsi/be2iscsi/be_main.c
@@ -230,29 +230,27 @@ static int be_ctrl_init(struct beiscsi_hba *phba, struct pci_dev *pdev)
 
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
 
@@ -877,7 +875,8 @@ hwi_complete_drvr_msgs(struct beiscsi_conn *beiscsi_conn,
 	} else {
 		pwrb_context = &phwi_ctrlr->wrb_context[((psol->
 				dw[offsetof(struct amap_sol_cqe, cid) / 32] &
-				SOL_CID_MASK) >> 6)];
+				SOL_CID_MASK) >> 6) -
+				phba->fw_config.iscsi_cid_start];
 		pwrb_handle = pwrb_context->pwrb_handle_basestd[((psol->
 				dw[offsetof(struct amap_sol_cqe, wrb_index) /
 				32] & SOL_WRB_INDEX_MASK) >> 16)];
@@ -939,7 +938,8 @@ static void hwi_complete_cmd(struct beiscsi_conn *beiscsi_conn,
 		pwrb_context = &phwi_ctrlr->
 				wrb_context[((psol->dw[offsetof
 				(struct amap_sol_cqe, cid) / 32]
-				& SOL_CID_MASK) >> 6)];
+				& SOL_CID_MASK) >> 6) -
+				phba->fw_config.iscsi_cid_start];
 		pwrb_handle = pwrb_context->pwrb_handle_basestd[((psol->
 				dw[offsetof(struct amap_sol_cqe, wrb_index) /
 				32] & SOL_WRB_INDEX_MASK) >> 16)];
@@ -1077,7 +1077,8 @@ hwi_get_async_handle(struct beiscsi_hba *phba,
 
 	WARN_ON(!pasync_handle);
 
-	pasync_handle->cri = (unsigned short)beiscsi_conn->beiscsi_conn_cid;
+	pasync_handle->cri = (unsigned short)beiscsi_conn->beiscsi_conn_cid -
+					     phba->fw_config.iscsi_cid_start;
 	pasync_handle->is_header = is_header;
 	pasync_handle->buffer_len = ((pdpdu_cqe->
 			dw[offsetof(struct amap_i_t_dpdu_cqe, dpl) / 32]
@@ -1327,9 +1328,10 @@ hwi_fwd_async_msg(struct beiscsi_conn *beiscsi_conn,
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
@@ -1456,10 +1458,10 @@ static unsigned int beiscsi_process_cq(struct be_eq_obj *pbe_eq)
 			}
 
 		} else {
-			beiscsi_conn = phba->conn_table[(u32) (sol->
+			beiscsi_conn = phba->conn_table[(u32) ((sol->
 				 dw[offsetof(struct amap_sol_cqe, cid) / 32] &
-				 SOL_CID_MASK) >> 6];
-
+				 SOL_CID_MASK) >> 6) -
+				   phba->fw_config.iscsi_cid_start];
 			if (!beiscsi_conn || !beiscsi_conn->ep) {
 				shost_printk(KERN_WARNING, phba->shost,
 				     "Connection table empty for cid = %d\n",
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
@@ -3561,7 +3564,8 @@ static int beiscsi_mtask(struct iscsi_task *task)
 		session = conn->session;
 		i = ((struct iscsi_tm *)task->hdr)->rtt;
 		phwi_ctrlr = phba->phwi_ctrlr;
-		pwrb_context = &phwi_ctrlr->wrb_context[cid];
+		pwrb_context = &phwi_ctrlr->wrb_context[cid -
+					    phba->fw_config.iscsi_cid_start];
 		pwrb_handle = pwrb_context->pwrb_handle_basestd[be32_to_cpu(i)
 								>> 16];
 		aborted_task = pwrb_handle->pio_handle;
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
@@ -3859,7 +3871,7 @@ struct iscsi_transport beiscsi_iscsi_transport = {
 		ISCSI_USERNAME | ISCSI_PASSWORD |
 		ISCSI_USERNAME_IN | ISCSI_PASSWORD_IN |
 		ISCSI_FAST_ABORT | ISCSI_ABORT_TMO |
-		ISCSI_LU_RESET_TMO | ISCSI_TGT_RESET_TMO |
+		ISCSI_LU_RESET_TMO |
 		ISCSI_PING_TMO | ISCSI_RECV_TMO |
 		ISCSI_IFACE_NAME | ISCSI_INITIATOR_NAME,
 	.host_param_mask = ISCSI_HOST_HWADDRESS | ISCSI_HOST_IPADDRESS |
diff --git a/drivers/scsi/be2iscsi/be_main.h b/drivers/scsi/be2iscsi/be_main.h
index 25e6b20..0e2eac6 100644
--- a/drivers/scsi/be2iscsi/be_main.h
+++ b/drivers/scsi/be2iscsi/be_main.h
@@ -46,23 +46,18 @@
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
 
@@ -802,7 +797,6 @@ struct hwi_controller {
 	struct be_ring default_pdu_hdr;
 	struct be_ring default_pdu_data;
 	struct hwi_context_memory *phwi_ctxt;
-	unsigned short cq_errors[CXN_KILLED_CMND_DATA_NOT_ON_SAME_CONN];
 };
 
 enum hwh_type_enum {
diff --git a/drivers/scsi/be2iscsi/be_mgmt.c b/drivers/scsi/be2iscsi/be_mgmt.c
index 79c2bd5..df1b327 100644
--- a/drivers/scsi/be2iscsi/be_mgmt.c
+++ b/drivers/scsi/be2iscsi/be_mgmt.c
@@ -48,6 +48,14 @@ unsigned char mgmt_get_fw_config(struct be_ctrl_info *ctrl,
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
@@ -317,7 +325,8 @@ int mgmt_open_connection(struct beiscsi_hba *phba,
 		struct tcp_connect_and_offload_out *ptcpcnct_out =
 							embedded_payload(wrb);
 
-		ep = phba->ep_array[ptcpcnct_out->cid];
+		ep = phba->ep_array[ptcpcnct_out->cid -
+				    phba->fw_config.iscsi_cid_start];
 		beiscsi_ep = ep->dd_data;
 		beiscsi_ep->fw_handle = ptcpcnct_out->connection_handle;
 		beiscsi_ep->cid_vld = 1;
-- 
1.6.4

