From: Joe Perches <joe@perches.com>
Subject: [PATCH 1/2] be2iscsi: Coalesce split strings and formats
Date: Sat, 13 Aug 2016 13:42:39 -0700
Message-ID: <3d0298e64b4a38e7d002c5c3962ab83aa585367c.1471119911.git.joe@perches.com>
References: <1471107782.3467.28.camel@perches.com>
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <1471107782.3467.28.camel@perches.com>
In-Reply-To: <cover.1471119911.git.joe@perches.com>
References: <cover.1471119911.git.joe@perches.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Christophe JAILLET <christophe.jaillet@wanadoo.fr>, Jayamohan Kallickal <jayamohan.kallickal@avagotech.com>, Ketan Mukadam <ketan.mukadam@avagotech.com>, John Soni Jose <sony.john@avagotech.com>
Cc: "James E.J. Bottomley" <jejb@linux.vnet.ibm.com>, "Martin K. Petersen" <martin.petersen@oracle.com>, linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org

Split strings are not preferred for ease of grep.

Signed-off-by: Joe Perches <joe@perches.com>
---
 drivers/scsi/be2iscsi/be_cmds.c  |  15 ++--
 drivers/scsi/be2iscsi/be_iscsi.c |  33 +++----
 drivers/scsi/be2iscsi/be_main.c  | 180 ++++++++++++++-------------------------
 drivers/scsi/be2iscsi/be_mgmt.c  |   3 +-
 4 files changed, 85 insertions(+), 146 deletions(-)

diff --git a/drivers/scsi/be2iscsi/be_cmds.c b/drivers/scsi/be2iscsi/be_cmds.c
index a55eaee..cefa342 100644
--- a/drivers/scsi/be2iscsi/be_cmds.c
+++ b/drivers/scsi/be2iscsi/be_cmds.c
@@ -96,8 +96,8 @@ int be_chk_reset_complete(struct beiscsi_hba *phba)
 
 	if ((status & 0x80000000) || (!num_loop)) {
 		beiscsi_log(phba, KERN_ERR, BEISCSI_LOG_INIT,
-			    "BC_%d : Failed in be_chk_reset_complete"
-			    "status = 0x%x\n", status);
+			    "BC_%d : Failed in be_chk_reset_complete status = 0x%x\n",
+			    status);
 		return -EIO;
 	}
 
@@ -292,9 +292,7 @@ int beiscsi_mccq_compl_wait(struct beiscsi_hba *phba,
 		beiscsi_log(phba, KERN_WARNING,
 			    BEISCSI_LOG_INIT | BEISCSI_LOG_EH |
 			    BEISCSI_LOG_CONFIG,
-			    "BC_%d : MBX Cmd Failed for "
-			    "Subsys : %d Opcode : %d with "
-			    "Status : %d and Extd_Status : %d\n",
+			    "BC_%d : MBX Cmd Failed for Subsys : %d Opcode : %d with Status : %d and Extd_Status : %d\n",
 			    mbx_hdr->subsystem,
 			    mbx_hdr->opcode,
 			    status, addl_status);
@@ -304,8 +302,7 @@ int beiscsi_mccq_compl_wait(struct beiscsi_hba *phba,
 			beiscsi_log(phba, KERN_WARNING,
 				    BEISCSI_LOG_INIT | BEISCSI_LOG_EH |
 				    BEISCSI_LOG_CONFIG,
-				    "BC_%d : Insufficient Buffer Error "
-				    "Resp_Len : %d Actual_Resp_Len : %d\n",
+				    "BC_%d : Insufficient Buffer Error Resp_Len : %d Actual_Resp_Len : %d\n",
 				    mbx_resp_hdr->response_length,
 				    mbx_resp_hdr->actual_resp_len);
 			rc = -EAGAIN;
@@ -1035,8 +1032,8 @@ int beiscsi_cmd_q_destroy(struct be_ctrl_info *ctrl, struct be_queue_info *q,
 	int status;
 
 	beiscsi_log(phba, KERN_INFO, BEISCSI_LOG_INIT,
-		    "BC_%d : In beiscsi_cmd_q_destroy "
-		    "queue_type : %d\n", queue_type);
+		    "BC_%d : In beiscsi_cmd_q_destroy queue_type : %d\n",
+		    queue_type);
 
 	mutex_lock(&ctrl->mbox_lock);
 	memset(wrb, 0, sizeof(*wrb));
diff --git a/drivers/scsi/be2iscsi/be_iscsi.c b/drivers/scsi/be2iscsi/be_iscsi.c
index 09f89a3..d28ac23 100644
--- a/drivers/scsi/be2iscsi/be_iscsi.c
+++ b/drivers/scsi/be2iscsi/be_iscsi.c
@@ -70,9 +70,8 @@ struct iscsi_cls_session *beiscsi_session_create(struct iscsi_endpoint *ep,
 
 	if (cmds_max > beiscsi_ep->phba->params.wrbs_per_cxn) {
 		beiscsi_log(phba, KERN_ERR, BEISCSI_LOG_CONFIG,
-			    "BS_%d : Cannot handle %d cmds."
-			    "Max cmds per session supported is %d. Using %d."
-			    "\n", cmds_max,
+			    "BS_%d : Cannot handle %d cmds.Max cmds per session supported is %d. Using %d.\n",
+			    cmds_max,
 			    beiscsi_ep->phba->params.wrbs_per_cxn,
 			    beiscsi_ep->phba->params.wrbs_per_cxn);
 
@@ -139,8 +138,8 @@ beiscsi_conn_create(struct iscsi_cls_session *cls_session, u32 cid)
 	phba = iscsi_host_priv(shost);
 
 	beiscsi_log(phba, KERN_INFO, BEISCSI_LOG_CONFIG,
-		    "BS_%d : In beiscsi_conn_create ,cid"
-		    "from iscsi layer=%d\n", cid);
+		    "BS_%d : In beiscsi_conn_create ,cidfrom iscsi layer=%d\n",
+		    cid);
 
 	cls_conn = iscsi_conn_setup(cls_session, sizeof(*beiscsi_conn), cid);
 	if (!cls_conn)
@@ -248,8 +247,7 @@ static int beiscsi_create_ipv4_iface(struct beiscsi_hba *phba)
 					      0, 0);
 	if (!phba->ipv4_iface) {
 		beiscsi_log(phba, KERN_ERR, BEISCSI_LOG_CONFIG,
-			    "BS_%d : Could not "
-			    "create default IPv4 address.\n");
+			    "BS_%d : Could not create default IPv4 address.\n");
 		return -ENODEV;
 	}
 
@@ -267,8 +265,7 @@ static int beiscsi_create_ipv6_iface(struct beiscsi_hba *phba)
 					      0, 0);
 	if (!phba->ipv6_iface) {
 		beiscsi_log(phba, KERN_ERR, BEISCSI_LOG_CONFIG,
-			    "BS_%d : Could not "
-			    "create default IPv6 address.\n");
+			    "BS_%d : Could not create default IPv6 address.\n");
 		return -ENODEV;
 	}
 
@@ -505,8 +502,7 @@ int be2iscsi_iface_set_param(struct Scsi_Host *shost,
 		 */
 		if (iface_param->iface_num) {
 			beiscsi_log(phba, KERN_ERR, BEISCSI_LOG_CONFIG,
-				    "BS_%d : Invalid iface_num %d."
-				    "Only iface_num 0 is supported.\n",
+				    "BS_%d : Invalid iface_num %d.Only iface_num 0 is supported.\n",
 				    iface_param->iface_num);
 
 			return -EINVAL;
@@ -651,8 +647,8 @@ int beiscsi_ep_get_param(struct iscsi_endpoint *ep,
 
 	beiscsi_log(beiscsi_ep->phba, KERN_INFO,
 		    BEISCSI_LOG_CONFIG,
-		    "BS_%d : In beiscsi_ep_get_param,"
-		    " param= %d\n", param);
+		    "BS_%d : In beiscsi_ep_get_param, param= %d\n",
+		    param);
 
 	switch (param) {
 	case ISCSI_PARAM_CONN_PORT:
@@ -680,8 +676,8 @@ int beiscsi_set_param(struct iscsi_cls_conn *cls_conn,
 
 	phba = ((struct beiscsi_conn *)conn->dd_data)->phba;
 	beiscsi_log(phba, KERN_INFO, BEISCSI_LOG_CONFIG,
-		    "BS_%d : In beiscsi_conn_set_param,"
-		    " param= %d\n", param);
+		    "BS_%d : In beiscsi_conn_set_param, param= %d\n",
+		    param);
 
 	ret = iscsi_set_param(cls_conn, param, buf, buflen);
 	if (ret)
@@ -817,8 +813,8 @@ int beiscsi_get_host_param(struct Scsi_Host *shost,
 		return -EBUSY;
 	} else {
 		beiscsi_log(phba, KERN_INFO, BEISCSI_LOG_CONFIG,
-			    "BS_%d : In beiscsi_get_host_param,"
-			    " param = %d\n", param);
+			    "BS_%d : In beiscsi_get_host_param, param = %d\n",
+			    param);
 	}
 
 	switch (param) {
@@ -1123,8 +1119,7 @@ static int beiscsi_open_conn(struct iscsi_endpoint *ep,
 	if (nonemb_cmd.va == NULL) {
 
 		beiscsi_log(phba, KERN_ERR, BEISCSI_LOG_CONFIG,
-			    "BS_%d : Failed to allocate memory for"
-			    " mgmt_open_connection\n");
+			    "BS_%d : Failed to allocate memory for mgmt_open_connection\n");
 
 		beiscsi_free_ep(beiscsi_ep);
 		return -ENOMEM;
diff --git a/drivers/scsi/be2iscsi/be_main.c b/drivers/scsi/be2iscsi/be_main.c
index 826c61b3..63a5643 100644
--- a/drivers/scsi/be2iscsi/be_main.c
+++ b/drivers/scsi/be2iscsi/be_main.c
@@ -57,8 +57,7 @@ module_param(be_iopoll_budget, int, 0);
 module_param(enable_msix, int, 0);
 module_param(be_max_phys_size, uint, S_IRUGO);
 MODULE_PARM_DESC(be_max_phys_size,
-		"Maximum Size (In Kilobytes) of physically contiguous "
-		"memory that can be allocated. Range is 16 - 128");
+		"Maximum Size (In Kilobytes) of physically contiguous memory that can be allocated. Range is 16 - 128");
 
 #define beiscsi_disp_param(_name)\
 ssize_t	\
@@ -268,8 +267,7 @@ static int beiscsi_eh_abort(struct scsi_cmnd *sc)
 				&nonemb_cmd.dma);
 	if (nonemb_cmd.va == NULL) {
 		beiscsi_log(phba, KERN_ERR, BEISCSI_LOG_EH,
-			    "BM_%d : Failed to allocate memory for "
-			    "mgmt_invalidate_icds\n");
+			    "BM_%d : Failed to allocate memory for mgmt_invalidate_icds\n");
 		return FAILED;
 	}
 	nonemb_cmd.size = sizeof(struct invalidate_commands_params_in);
@@ -278,8 +276,7 @@ static int beiscsi_eh_abort(struct scsi_cmnd *sc)
 				   cid, &nonemb_cmd);
 	if (!tag) {
 		beiscsi_log(phba, KERN_WARNING, BEISCSI_LOG_EH,
-			    "BM_%d : mgmt_invalidate_icds could not be "
-			    "submitted\n");
+			    "BM_%d : mgmt_invalidate_icds could not be submitted\n");
 		pci_free_consistent(phba->ctrl.pdev, nonemb_cmd.size,
 				    nonemb_cmd.va, nonemb_cmd.dma);
 
@@ -350,8 +347,7 @@ static int beiscsi_eh_device_reset(struct scsi_cmnd *sc)
 				&nonemb_cmd.dma);
 	if (nonemb_cmd.va == NULL) {
 		beiscsi_log(phba, KERN_ERR, BEISCSI_LOG_EH,
-			    "BM_%d : Failed to allocate memory for "
-			    "mgmt_invalidate_icds\n");
+			    "BM_%d : Failed to allocate memory for mgmt_invalidate_icds\n");
 		return FAILED;
 	}
 	nonemb_cmd.size = sizeof(struct invalidate_commands_params_in);
@@ -360,8 +356,7 @@ static int beiscsi_eh_device_reset(struct scsi_cmnd *sc)
 				   cid, &nonemb_cmd);
 	if (!tag) {
 		beiscsi_log(phba, KERN_WARNING, BEISCSI_LOG_EH,
-			    "BM_%d : mgmt_invalidate_icds could not be"
-			    " submitted\n");
+			    "BM_%d : mgmt_invalidate_icds could not be submitted\n");
 		pci_free_consistent(phba->ctrl.pdev, nonemb_cmd.size,
 				    nonemb_cmd.va, nonemb_cmd.dma);
 		return FAILED;
@@ -1010,8 +1005,7 @@ static int beiscsi_init_irqs(struct beiscsi_hba *phba)
 					  &phwi_context->be_eq[i]);
 			if (ret) {
 				beiscsi_log(phba, KERN_ERR, BEISCSI_LOG_INIT,
-					    "BM_%d : beiscsi_init_irqs-Failed to "
-					    "register msix for i = %d\n",
+					    "BM_%d : beiscsi_init_irqs-Failed to register msix for i = %d\n",
 					    i);
 				kfree(phba->msi_name[i]);
 				goto free_msix_irqs;
@@ -1029,8 +1023,7 @@ static int beiscsi_init_irqs(struct beiscsi_hba *phba)
 				  &phwi_context->be_eq[i]);
 		if (ret) {
 			beiscsi_log(phba, KERN_ERR, BEISCSI_LOG_INIT ,
-				    "BM_%d : beiscsi_init_irqs-"
-				    "Failed to register beiscsi_msix_mcc\n");
+				    "BM_%d : beiscsi_init_irqs-Failed to register beiscsi_msix_mcc\n");
 			kfree(phba->msi_name[i]);
 			goto free_msix_irqs;
 		}
@@ -1134,8 +1127,7 @@ static struct sgl_handle *alloc_io_sgl_handle(struct beiscsi_hba *phba)
 	spin_lock_bh(&phba->io_sgl_lock);
 	if (phba->io_sgl_hndl_avbl) {
 		beiscsi_log(phba, KERN_INFO, BEISCSI_LOG_IO,
-			    "BM_%d : In alloc_io_sgl_handle,"
-			    " io_sgl_alloc_index=%d\n",
+			    "BM_%d : In alloc_io_sgl_handle, io_sgl_alloc_index=%d\n",
 			    phba->io_sgl_alloc_index);
 
 		psgl_handle = phba->io_sgl_hndl_base[phba->
@@ -1167,8 +1159,8 @@ free_io_sgl_handle(struct beiscsi_hba *phba, struct sgl_handle *psgl_handle)
 		 * failed in xmit_task or alloc_pdu.
 		 */
 		 beiscsi_log(phba, KERN_INFO, BEISCSI_LOG_IO,
-			     "BM_%d : Double Free in IO SGL io_sgl_free_index=%d, "
-			     "value there=%p\n", phba->io_sgl_free_index,
+			     "BM_%d : Double Free in IO SGL io_sgl_free_index=%d, value there=%p\n",
+			     phba->io_sgl_free_index,
 			     phba->io_sgl_hndl_base
 			     [phba->io_sgl_free_index]);
 		 spin_unlock_bh(&phba->io_sgl_lock);
@@ -1255,8 +1247,7 @@ free_wrb_handle(struct beiscsi_hba *phba, struct hwi_wrb_context *pwrb_context,
 			       phba->params.wrbs_per_cxn);
 	beiscsi_log(phba, KERN_INFO,
 		    BEISCSI_LOG_IO | BEISCSI_LOG_CONFIG,
-		    "BM_%d : FREE WRB: pwrb_handle=%p free_index=0x%x "
-		    "wrb_handles_available=%d\n",
+		    "BM_%d : FREE WRB: pwrb_handle=%p free_index=0x%x wrb_handles_available=%d\n",
 		    pwrb_handle, pwrb_context->free_index,
 		    pwrb_context->wrb_handles_available);
 }
@@ -1292,8 +1283,7 @@ free_mgmt_sgl_handle(struct beiscsi_hba *phba, struct sgl_handle *psgl_handle)
 {
 	spin_lock_bh(&phba->mgmt_sgl_lock);
 	beiscsi_log(phba, KERN_INFO, BEISCSI_LOG_CONFIG,
-		    "BM_%d : In  free_mgmt_sgl_handle, "
-		    "eh_sgl_free_index=%d\n",
+		    "BM_%d : In  free_mgmt_sgl_handle, eh_sgl_free_index=%d\n",
 		    phba->eh_sgl_free_index);
 
 	if (phba->eh_sgl_hndl_base[phba->eh_sgl_free_index]) {
@@ -1302,8 +1292,7 @@ free_mgmt_sgl_handle(struct beiscsi_hba *phba, struct sgl_handle *psgl_handle)
 		 * failed in xmit_task or alloc_pdu.
 		 */
 		beiscsi_log(phba, KERN_WARNING, BEISCSI_LOG_CONFIG,
-			    "BM_%d : Double Free in eh SGL, "
-			    "eh_sgl_free_index=%d\n",
+			    "BM_%d : Double Free in eh SGL, eh_sgl_free_index=%d\n",
 			    phba->eh_sgl_free_index);
 		spin_unlock_bh(&phba->mgmt_sgl_lock);
 		return;
@@ -1592,8 +1581,7 @@ static void hwi_complete_cmd(struct beiscsi_conn *beiscsi_conn,
 	case HWH_TYPE_LOGIN:
 		beiscsi_log(phba, KERN_ERR,
 			    BEISCSI_LOG_CONFIG | BEISCSI_LOG_IO,
-			    "BM_%d :\t\t No HWH_TYPE_LOGIN Expected in"
-			    " hwi_complete_cmd- Solicited path\n");
+			    "BM_%d :\t\t No HWH_TYPE_LOGIN Expected in hwi_complete_cmd - Solicited path\n");
 		break;
 
 	case HWH_TYPE_NOP:
@@ -1603,8 +1591,8 @@ static void hwi_complete_cmd(struct beiscsi_conn *beiscsi_conn,
 	default:
 		beiscsi_log(phba, KERN_WARNING,
 			    BEISCSI_LOG_CONFIG | BEISCSI_LOG_IO,
-			    "BM_%d : In hwi_complete_cmd, unknown type = %d "
-			    "wrb_index 0x%x CID 0x%x\n", type,
+			    "BM_%d : In hwi_complete_cmd, unknown type = %d wrb_index 0x%x CID 0x%x\n",
+			    type,
 			    csol_cqe.wrb_index,
 			    csol_cqe.cid);
 		break;
@@ -2242,8 +2230,7 @@ unsigned int beiscsi_process_cq(struct be_eq_obj *pbe_eq, int budget)
 		default:
 			beiscsi_log(phba, KERN_ERR,
 				    BEISCSI_LOG_IO | BEISCSI_LOG_CONFIG,
-				    "BM_%d : Invalid CQE Event Received Code : %d "
-				    "CID 0x%x...\n",
+				    "BM_%d : Invalid CQE Event Received Code : %d CID 0x%x...\n",
 				    code, cid);
 			break;
 		}
@@ -2996,8 +2983,7 @@ static int hwi_init_async_pdu_ctx(struct beiscsi_hba *phba)
 				(ulp_num * MEM_DESCR_OFFSET);
 			if (mem_descr->mem_array[0].virtual_address) {
 				beiscsi_log(phba, KERN_INFO, BEISCSI_LOG_INIT,
-					    "BM_%d : hwi_init_async_pdu_ctx"
-					    " HWI_MEM_ASYNC_HEADER_BUF_ULP%d va=%p\n",
+					    "BM_%d : hwi_init_async_pdu_ctx HWI_MEM_ASYNC_HEADER_BUF_ULP%d va=%p\n",
 					    ulp_num,
 					    mem_descr->mem_array[0].
 					    virtual_address);
@@ -3019,8 +3005,7 @@ static int hwi_init_async_pdu_ctx(struct beiscsi_hba *phba)
 				     (ulp_num * MEM_DESCR_OFFSET);
 			if (mem_descr->mem_array[0].virtual_address) {
 				beiscsi_log(phba, KERN_INFO, BEISCSI_LOG_INIT,
-					    "BM_%d : hwi_init_async_pdu_ctx"
-					    " HWI_MEM_ASYNC_HEADER_RING_ULP%d va=%p\n",
+					    "BM_%d : hwi_init_async_pdu_ctx HWI_MEM_ASYNC_HEADER_RING_ULP%d va=%p\n",
 					    ulp_num,
 					    mem_descr->mem_array[0].
 					    virtual_address);
@@ -3038,8 +3023,7 @@ static int hwi_init_async_pdu_ctx(struct beiscsi_hba *phba)
 				     (ulp_num * MEM_DESCR_OFFSET);
 			if (mem_descr->mem_array[0].virtual_address) {
 				beiscsi_log(phba, KERN_INFO, BEISCSI_LOG_INIT,
-					    "BM_%d : hwi_init_async_pdu_ctx"
-					    " HWI_MEM_ASYNC_HEADER_HANDLE_ULP%d va=%p\n",
+					    "BM_%d : hwi_init_async_pdu_ctx HWI_MEM_ASYNC_HEADER_HANDLE_ULP%d va=%p\n",
 					    ulp_num,
 					    mem_descr->mem_array[0].
 					    virtual_address);
@@ -3059,8 +3043,7 @@ static int hwi_init_async_pdu_ctx(struct beiscsi_hba *phba)
 				     (ulp_num * MEM_DESCR_OFFSET);
 			if (mem_descr->mem_array[0].virtual_address) {
 				beiscsi_log(phba, KERN_INFO, BEISCSI_LOG_INIT,
-					    "BM_%d : hwi_init_async_pdu_ctx"
-					    " HWI_MEM_ASYNC_DATA_RING_ULP%d va=%p\n",
+					    "BM_%d : hwi_init_async_pdu_ctx HWI_MEM_ASYNC_DATA_RING_ULP%d va=%p\n",
 					    ulp_num,
 					    mem_descr->mem_array[0].
 					    virtual_address);
@@ -3099,8 +3082,7 @@ static int hwi_init_async_pdu_ctx(struct beiscsi_hba *phba)
 				     (ulp_num * MEM_DESCR_OFFSET);
 			if (mem_descr->mem_array[0].virtual_address) {
 				beiscsi_log(phba, KERN_INFO, BEISCSI_LOG_INIT,
-					    "BM_%d : hwi_init_async_pdu_ctx"
-					    " HWI_MEM_ASYNC_DATA_BUF_ULP%d va=%p\n",
+					    "BM_%d : hwi_init_async_pdu_ctx HWI_MEM_ASYNC_DATA_BUF_ULP%d va=%p\n",
 					    ulp_num,
 					    mem_descr->mem_array[0].
 					    virtual_address);
@@ -3304,8 +3286,7 @@ static int beiscsi_create_eqs(struct beiscsi_hba *phba,
 					    phwi_context->cur_eqd);
 		if (ret) {
 			beiscsi_log(phba, KERN_ERR, BEISCSI_LOG_INIT,
-				    "BM_%d : beiscsi_cmd_eq_create "
-				    "Failed for EQ\n");
+				    "BM_%d : beiscsi_cmd_eq_create Failed for EQ\n");
 			goto create_eq_error;
 		}
 
@@ -3360,8 +3341,7 @@ static int beiscsi_create_cqs(struct beiscsi_hba *phba,
 				    sizeof(struct sol_cqe), cq_vaddress);
 		if (ret) {
 			beiscsi_log(phba, KERN_ERR, BEISCSI_LOG_INIT,
-				    "BM_%d : be_fill_queue Failed "
-				    "for ISCSI CQ\n");
+				    "BM_%d : be_fill_queue Failed for ISCSI CQ\n");
 			goto create_cq_error;
 		}
 
@@ -3370,8 +3350,7 @@ static int beiscsi_create_cqs(struct beiscsi_hba *phba,
 					    false, 0);
 		if (ret) {
 			beiscsi_log(phba, KERN_ERR, BEISCSI_LOG_INIT,
-				    "BM_%d : beiscsi_cmd_eq_create "
-				    "Failed for ISCSI CQ\n");
+				    "BM_%d : beiscsi_cmd_eq_create Failed for ISCSI CQ\n");
 			goto create_cq_error;
 		}
 		beiscsi_log(phba, KERN_INFO, BEISCSI_LOG_INIT,
@@ -3472,8 +3451,7 @@ beiscsi_create_def_data(struct beiscsi_hba *phba,
 			    sizeof(struct phys_addr), dq_vaddress);
 	if (ret) {
 		beiscsi_log(phba, KERN_ERR, BEISCSI_LOG_INIT,
-			    "BM_%d : be_fill_queue Failed for DEF PDU "
-			    "DATA on ULP : %d\n",
+			    "BM_%d : be_fill_queue Failed for DEF PDU DATA on ULP : %d\n",
 			    ulp_num);
 
 		return ret;
@@ -3486,8 +3464,7 @@ beiscsi_create_def_data(struct beiscsi_hba *phba,
 					      BEISCSI_DEFQ_DATA, ulp_num);
 	if (ret) {
 		beiscsi_log(phba, KERN_ERR, BEISCSI_LOG_INIT,
-			    "BM_%d be_cmd_create_default_pdu_queue"
-			    " Failed for DEF PDU DATA on ULP : %d\n",
+			    "BM_%d be_cmd_create_default_pdu_queue Failed for DEF PDU DATA on ULP : %d\n",
 			    ulp_num);
 		return ret;
 	}
@@ -3499,8 +3476,8 @@ beiscsi_create_def_data(struct beiscsi_hba *phba,
 
 	hwi_post_async_buffers(phba, BEISCSI_DEFQ_DATA, ulp_num);
 	beiscsi_log(phba, KERN_INFO, BEISCSI_LOG_INIT,
-		    "BM_%d : DEFAULT PDU DATA RING CREATED "
-		    "on ULP : %d\n", ulp_num);
+		    "BM_%d : DEFAULT PDU DATA RING CREATED on ULP : %d\n",
+		    ulp_num);
 
 	return 0;
 }
@@ -3527,14 +3504,14 @@ beiscsi_post_template_hdr(struct beiscsi_hba *phba)
 
 			if (status != 0) {
 				beiscsi_log(phba, KERN_ERR, BEISCSI_LOG_INIT,
-					    "BM_%d : Post Template HDR Failed for "
-					    "ULP_%d\n", ulp_num);
+					    "BM_%d : Post Template HDR Failed for ULP_%d\n",
+					    ulp_num);
 				return status;
 			}
 
 			beiscsi_log(phba, KERN_INFO, BEISCSI_LOG_INIT,
-				    "BM_%d : Template HDR Pages Posted for "
-				    "ULP_%d\n", ulp_num);
+				    "BM_%d : Template HDR Pages Posted for ULP_%d\n",
+				    ulp_num);
 		}
 	}
 	return 0;
@@ -4017,8 +3994,7 @@ static int hwi_init_controller(struct beiscsi_hba *phba)
 			    phwi_ctrlr->phwi_ctxt);
 	} else {
 		beiscsi_log(phba, KERN_ERR, BEISCSI_LOG_INIT,
-			    "BM_%d : HWI_MEM_ADDN_CONTEXT is more "
-			    "than one element.Failing to load\n");
+			    "BM_%d : HWI_MEM_ADDN_CONTEXT is more than one element.Failing to load\n");
 		return -ENOMEM;
 	}
 
@@ -4073,8 +4049,7 @@ static int beiscsi_init_controller(struct beiscsi_hba *phba)
 	ret = beiscsi_get_memory(phba);
 	if (ret < 0) {
 		beiscsi_log(phba, KERN_ERR, BEISCSI_LOG_INIT,
-			    "BM_%d : beiscsi_dev_probe -"
-			    "Failed in beiscsi_alloc_memory\n");
+			    "BM_%d : beiscsi_dev_probe -Failed in beiscsi_alloc_memory\n");
 		return ret;
 	}
 
@@ -4125,8 +4100,7 @@ static int beiscsi_init_sgl_handle(struct beiscsi_hba *phba)
 		}
 	} else {
 		beiscsi_log(phba, KERN_ERR, BEISCSI_LOG_INIT,
-			    "BM_%d : HWI_MEM_SGLH is more than one element. "
-			    "Failing to load\n");
+			    "BM_%d : HWI_MEM_SGLH is more than one element. Failing to load\n");
 		return -ENOMEM;
 	}
 
@@ -4153,8 +4127,7 @@ static int beiscsi_init_sgl_handle(struct beiscsi_hba *phba)
 		idx++;
 	}
 	beiscsi_log(phba, KERN_INFO, BEISCSI_LOG_INIT,
-		    "BM_%d : phba->io_sgl_hndl_avbl=%d "
-		    "phba->eh_sgl_hndl_avbl=%d\n",
+		    "BM_%d : phba->io_sgl_hndl_avbl=%d phba->eh_sgl_hndl_avbl=%d\n",
 		    phba->io_sgl_hndl_avbl,
 		    phba->eh_sgl_hndl_avbl);
 
@@ -4212,8 +4185,7 @@ static int hba_setup_cid_tbls(struct beiscsi_hba *phba)
 
 			if (!ptr_cid_info) {
 				beiscsi_log(phba, KERN_ERR, BEISCSI_LOG_INIT,
-					    "BM_%d : Failed to allocate memory "
-					    "for ULP_CID_INFO for ULP : %d\n",
+					    "BM_%d : Failed to allocate memory for ULP_CID_INFO for ULP : %d\n",
 					    ulp_num);
 				ret = -ENOMEM;
 				goto free_memory;
@@ -4226,8 +4198,7 @@ static int hba_setup_cid_tbls(struct beiscsi_hba *phba)
 						  ulp_num), GFP_KERNEL);
 			if (!ptr_cid_info->cid_array) {
 				beiscsi_log(phba, KERN_ERR, BEISCSI_LOG_INIT,
-					    "BM_%d : Failed to allocate memory "
-					    "for CID_ARRAY for ULP : %d\n",
+					    "BM_%d : Failed to allocate memory for CID_ARRAY for ULP : %d\n",
 					    ulp_num);
 				kfree(ptr_cid_info);
 				ptr_cid_info = NULL;
@@ -4246,8 +4217,7 @@ static int hba_setup_cid_tbls(struct beiscsi_hba *phba)
 				 phba->params.cxns_per_ctrl, GFP_KERNEL);
 	if (!phba->ep_array) {
 		beiscsi_log(phba, KERN_ERR, BEISCSI_LOG_INIT,
-			    "BM_%d : Failed to allocate memory in "
-			    "hba_setup_cid_tbls\n");
+			    "BM_%d : Failed to allocate memory in hba_setup_cid_tbls\n");
 		ret = -ENOMEM;
 
 		goto free_memory;
@@ -4257,8 +4227,7 @@ static int hba_setup_cid_tbls(struct beiscsi_hba *phba)
 				   phba->params.cxns_per_ctrl, GFP_KERNEL);
 	if (!phba->conn_table) {
 		beiscsi_log(phba, KERN_ERR, BEISCSI_LOG_INIT,
-			    "BM_%d : Failed to allocate memory in "
-			    "hba_setup_cid_tbls\n");
+			    "BM_%d : Failed to allocate memory in hba_setup_cid_tbls\n");
 
 		kfree(phba->ep_array);
 		phba->ep_array = NULL;
@@ -4397,8 +4366,7 @@ static int beiscsi_get_boot_info(struct beiscsi_hba *phba)
 	if (nonemb_cmd.va == NULL) {
 		beiscsi_log(phba, KERN_ERR,
 			    BEISCSI_LOG_INIT | BEISCSI_LOG_CONFIG,
-			    "BM_%d : Failed to allocate memory for "
-			    "beiscsi_get_session_info\n");
+			    "BM_%d : Failed to allocate memory for beiscsi_get_session_info\n");
 
 		return -ENOMEM;
 	}
@@ -4408,8 +4376,7 @@ static int beiscsi_get_boot_info(struct beiscsi_hba *phba)
 	if (!tag) {
 		beiscsi_log(phba, KERN_ERR,
 			    BEISCSI_LOG_INIT | BEISCSI_LOG_CONFIG,
-			    "BM_%d : beiscsi_get_session_info"
-			    " Failed\n");
+			    "BM_%d : beiscsi_get_session_info Failed\n");
 
 		goto boot_freemem;
 	}
@@ -4509,15 +4476,13 @@ static int beiscsi_init_port(struct beiscsi_hba *phba)
 	ret = beiscsi_init_controller(phba);
 	if (ret < 0) {
 		beiscsi_log(phba, KERN_ERR, BEISCSI_LOG_INIT,
-			    "BM_%d : beiscsi_dev_probe - Failed in "
-			    "beiscsi_init_controller\n");
+			    "BM_%d : beiscsi_dev_probe - Failed in beiscsi_init_controller\n");
 		return ret;
 	}
 	ret = beiscsi_init_sgl_handle(phba);
 	if (ret < 0) {
 		beiscsi_log(phba, KERN_ERR, BEISCSI_LOG_INIT,
-			    "BM_%d : beiscsi_dev_probe - Failed in "
-			    "beiscsi_init_sgl_handle\n");
+			    "BM_%d : beiscsi_dev_probe - Failed in beiscsi_init_sgl_handle\n");
 		goto do_cleanup_ctrlr;
 	}
 
@@ -4580,8 +4545,8 @@ static void beiscsi_clean_port(struct beiscsi_hba *phba)
 			if (mgmt_status)
 				beiscsi_log(phba, KERN_WARNING,
 					    BEISCSI_LOG_INIT,
-					    "BM_%d : mgmt_epfw_cleanup FAILED"
-					    " for ULP_%d\n", ulp_num);
+					    "BM_%d : mgmt_epfw_cleanup FAILED for ULP_%d\n",
+					    ulp_num);
 		}
 	}
 
@@ -4806,8 +4771,7 @@ static int beiscsi_alloc_pdu(struct iscsi_task *task, uint8_t opcode)
 		if (!io_task->psgl_handle) {
 			beiscsi_log(phba, KERN_ERR,
 				    BEISCSI_LOG_IO | BEISCSI_LOG_CONFIG,
-				    "BM_%d : Alloc of IO_SGL_ICD Failed "
-				    "for the CID : %d\n",
+				    "BM_%d : Alloc of IO_SGL_ICD Failed for the CID : %d\n",
 				    beiscsi_conn->beiscsi_conn_cid);
 			goto free_hndls;
 		}
@@ -4817,8 +4781,7 @@ static int beiscsi_alloc_pdu(struct iscsi_task *task, uint8_t opcode)
 		if (!io_task->pwrb_handle) {
 			beiscsi_log(phba, KERN_ERR,
 				    BEISCSI_LOG_IO | BEISCSI_LOG_CONFIG,
-				    "BM_%d : Alloc of WRB_HANDLE Failed "
-				    "for the CID : %d\n",
+				    "BM_%d : Alloc of WRB_HANDLE Failed for the CID : %d\n",
 				    beiscsi_conn->beiscsi_conn_cid);
 			goto free_io_hndls;
 		}
@@ -4833,8 +4796,7 @@ static int beiscsi_alloc_pdu(struct iscsi_task *task, uint8_t opcode)
 					beiscsi_log(phba, KERN_ERR,
 						    BEISCSI_LOG_IO |
 						    BEISCSI_LOG_CONFIG,
-						    "BM_%d : Alloc of MGMT_SGL_ICD Failed "
-						    "for the CID : %d\n",
+						    "BM_%d : Alloc of MGMT_SGL_ICD Failed for the CID : %d\n",
 						    beiscsi_conn->
 						    beiscsi_conn_cid);
 					goto free_hndls;
@@ -4851,8 +4813,7 @@ static int beiscsi_alloc_pdu(struct iscsi_task *task, uint8_t opcode)
 					beiscsi_log(phba, KERN_ERR,
 						    BEISCSI_LOG_IO |
 						    BEISCSI_LOG_CONFIG,
-						    "BM_%d : Alloc of WRB_HANDLE Failed "
-						    "for the CID : %d\n",
+						    "BM_%d : Alloc of WRB_HANDLE Failed for the CID : %d\n",
 						    beiscsi_conn->
 						    beiscsi_conn_cid);
 					goto free_mgmt_hndls;
@@ -4872,8 +4833,7 @@ static int beiscsi_alloc_pdu(struct iscsi_task *task, uint8_t opcode)
 				beiscsi_log(phba, KERN_ERR,
 					    BEISCSI_LOG_IO |
 					    BEISCSI_LOG_CONFIG,
-					    "BM_%d : Alloc of MGMT_SGL_ICD Failed "
-					    "for the CID : %d\n",
+					    "BM_%d : Alloc of MGMT_SGL_ICD Failed for the CID : %d\n",
 					    beiscsi_conn->
 					    beiscsi_conn_cid);
 				goto free_hndls;
@@ -4885,8 +4845,7 @@ static int beiscsi_alloc_pdu(struct iscsi_task *task, uint8_t opcode)
 			if (!io_task->pwrb_handle) {
 				beiscsi_log(phba, KERN_ERR,
 					    BEISCSI_LOG_IO | BEISCSI_LOG_CONFIG,
-					    "BM_%d : Alloc of WRB_HANDLE Failed "
-					    "for the CID : %d\n",
+					    "BM_%d : Alloc of WRB_HANDLE Failed for the CID : %d\n",
 					    beiscsi_conn->beiscsi_conn_cid);
 				goto free_mgmt_hndls;
 			}
@@ -5182,8 +5141,7 @@ static int beiscsi_task_xmit(struct iscsi_task *task)
 	if (num_sg < 0) {
 		beiscsi_log(phba, KERN_ERR,
 			    BEISCSI_LOG_IO | BEISCSI_LOG_ISCSI,
-			    "BM_%d : scsi_dma_map Failed "
-			    "Driver_ITT : 0x%x ITT : 0x%x Xferlen : 0x%x\n",
+			    "BM_%d : scsi_dma_map Failed Driver_ITT : 0x%x ITT : 0x%x Xferlen : 0x%x\n",
 			    be32_to_cpu(io_task->cmd_bhs->iscsi_hdr.itt),
 			    io_task->libiscsi_itt, scsi_bufflen(sc));
 
@@ -5225,8 +5183,7 @@ static int beiscsi_bsg_request(struct bsg_job *job)
 					&nonemb_cmd.dma);
 		if (nonemb_cmd.va == NULL) {
 			beiscsi_log(phba, KERN_ERR, BEISCSI_LOG_CONFIG,
-				    "BM_%d : Failed to allocate memory for "
-				    "beiscsi_bsg_request\n");
+				    "BM_%d : Failed to allocate memory for beiscsi_bsg_request\n");
 			return -ENOMEM;
 		}
 		tag = mgmt_vendor_specific_fw_cmd(&phba->ctrl, phba, job,
@@ -5262,8 +5219,7 @@ static int beiscsi_bsg_request(struct bsg_job *job)
 				    nonemb_cmd.va, nonemb_cmd.dma);
 		if (status || extd_status) {
 			beiscsi_log(phba, KERN_ERR, BEISCSI_LOG_CONFIG,
-				    "BM_%d : MBX Cmd Failed"
-				    " status = %d extd_status = %d\n",
+				    "BM_%d : MBX Cmd Failed status = %d extd_status = %d\n",
 				    status, extd_status);
 
 			return -EIO;
@@ -5432,8 +5388,7 @@ static void be_check_boot_session(struct beiscsi_hba *phba)
 {
 	if (beiscsi_setup_boot_info(phba))
 		beiscsi_log(phba, KERN_ERR, BEISCSI_LOG_INIT,
-			    "BM_%d : Could not set up "
-			    "iSCSI boot info on async event.\n");
+			    "BM_%d : Could not set up iSCSI boot info on async event.\n");
 }
 
 /*
@@ -5605,8 +5560,7 @@ static void beiscsi_eeh_resume(struct pci_dev *pdev)
 	ret = beiscsi_init_irqs(phba);
 	if (ret < 0) {
 		beiscsi_log(phba, KERN_ERR, BEISCSI_LOG_INIT,
-			    "BM_%d : beiscsi_eeh_resume - "
-			    "Failed to beiscsi_init_irqs\n");
+			    "BM_%d : beiscsi_eeh_resume - Failed to beiscsi_init_irqs\n");
 		goto ret_err;
 	}
 
@@ -5647,8 +5601,7 @@ static int beiscsi_dev_probe(struct pci_dev *pcidev,
 	ret = pci_enable_pcie_error_reporting(pcidev);
 	if (ret)
 		beiscsi_log(phba, KERN_WARNING, BEISCSI_LOG_INIT,
-			    "BM_%d : PCIe Error Reporting "
-			    "Enabling Failed\n");
+			    "BM_%d : PCIe Error Reporting Enabling Failed\n");
 
 	pci_save_state(pcidev);
 
@@ -5682,8 +5635,7 @@ static int beiscsi_dev_probe(struct pci_dev *pcidev,
 	ret = be_ctrl_init(phba, pcidev);
 	if (ret) {
 		beiscsi_log(phba, KERN_ERR, BEISCSI_LOG_INIT,
-			    "BM_%d : beiscsi_dev_probe-"
-			    "Failed in be_ctrl_init\n");
+			    "BM_%d : beiscsi_dev_probe-Failed in be_ctrl_init\n");
 		goto hba_free;
 	}
 
@@ -5736,8 +5688,7 @@ static int beiscsi_dev_probe(struct pci_dev *pcidev,
 	ret = beiscsi_init_port(phba);
 	if (ret < 0) {
 		beiscsi_log(phba, KERN_ERR, BEISCSI_LOG_INIT,
-			    "BM_%d : beiscsi_dev_probe-"
-			    "Failed in beiscsi_init_port\n");
+			    "BM_%d : beiscsi_dev_probe-Failed in beiscsi_init_port\n");
 		goto free_port;
 	}
 
@@ -5757,8 +5708,7 @@ static int beiscsi_dev_probe(struct pci_dev *pcidev,
 	phba->wq = alloc_workqueue("%s", WQ_MEM_RECLAIM, 1, phba->wq_name);
 	if (!phba->wq) {
 		beiscsi_log(phba, KERN_ERR, BEISCSI_LOG_INIT,
-			    "BM_%d : beiscsi_dev_probe-"
-			    "Failed to allocate work queue\n");
+			    "BM_%d : beiscsi_dev_probe-Failed to allocate work queue\n");
 		ret = -ENOMEM;
 		goto free_twq;
 	}
@@ -5783,8 +5733,7 @@ static int beiscsi_dev_probe(struct pci_dev *pcidev,
 	ret = beiscsi_init_irqs(phba);
 	if (ret < 0) {
 		beiscsi_log(phba, KERN_ERR, BEISCSI_LOG_INIT,
-			    "BM_%d : beiscsi_dev_probe-"
-			    "Failed to beiscsi_init_irqs\n");
+			    "BM_%d : beiscsi_dev_probe-Failed to beiscsi_init_irqs\n");
 		goto free_blkenbld;
 	}
 	hwi_enable_intr(phba);
@@ -5798,8 +5747,7 @@ static int beiscsi_dev_probe(struct pci_dev *pcidev,
 		 * iscsi boot.
 		 */
 		beiscsi_log(phba, KERN_ERR, BEISCSI_LOG_INIT,
-			    "BM_%d : Could not set up "
-			    "iSCSI boot info.\n");
+			    "BM_%d : Could not set up iSCSI boot info.\n");
 
 	beiscsi_create_def_ifaces(phba);
 	schedule_delayed_work(&phba->beiscsi_hw_check_task,
diff --git a/drivers/scsi/be2iscsi/be_mgmt.c b/drivers/scsi/be2iscsi/be_mgmt.c
index 83926e2..888567b 100644
--- a/drivers/scsi/be2iscsi/be_mgmt.c
+++ b/drivers/scsi/be2iscsi/be_mgmt.c
@@ -519,8 +519,7 @@ int mgmt_check_supported_fw(struct be_ctrl_info *ctrl,
 				&nonemb_cmd.dma);
 	if (nonemb_cmd.va == NULL) {
 		beiscsi_log(phba, KERN_ERR, BEISCSI_LOG_INIT,
-			    "BG_%d : Failed to allocate memory for "
-			    "mgmt_check_supported_fw\n");
+			    "BG_%d : Failed to allocate memory for mgmt_check_supported_fw\n");
 		return -ENOMEM;
 	}
 	nonemb_cmd.size = sizeof(struct be_mgmt_controller_attributes);
-- 
2.8.0.rc4.16.g56331f8
