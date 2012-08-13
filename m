From: Masatake YAMATO <yamato@redhat.com>
Subject: [PATCH v2] be2iscsi: cleanup format strings
Date: Tue, 14 Aug 2012 02:51:16 +0900
Message-ID: <1344880276-9491-1-git-send-email-yamato@redhat.com>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from h219-110-095-176.catv01.itscom.jp ([219.110.95.176]:47989 "EHLO
	localhost.localdomain" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1750861Ab2HMRvw (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Mon, 13 Aug 2012 13:51:52 -0400
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org
Cc: Masatake YAMATO <yamato@redhat.com>

In format strings for printk in be2iscsi, concatenations of
constant c strings are used widely. However, the log output is a bit
hard to read because whitespaces are missed in the constant c
strings like:

    SE_DEBUG(DBG_LVL_1, "CQ Error %d, reset"
			"received/sent on CID 0x%x...\n",

You will see "CQ Error 0xffffffff resetreceived/sent on CID ..." and
wonder what is "resetreceived".

This patch does cleanup these log format strings:

    * joining concatenated constant c strings into one,
    * inserting a white space after punctuation, and
    * inserting white spaces before/after hypen.

In v2 patch concatenated constant c strings are joined into one
as suggested by Joe Perches <joe@perches.com>.

Signed-off-by: Masatake YAMATO <yamato@redhat.com>
---
 drivers/scsi/be2iscsi/be_cmds.c  |  12 ++-
 drivers/scsi/be2iscsi/be_iscsi.c |  48 +++++-------
 drivers/scsi/be2iscsi/be_main.c  | 160 +++++++++++++++------------------------
 drivers/scsi/be2iscsi/be_mgmt.c  |  10 +--
 4 files changed, 90 insertions(+), 140 deletions(-)

diff --git a/drivers/scsi/be2iscsi/be_cmds.c b/drivers/scsi/be2iscsi/be_cmds.c
index d2e9e93..f6510a2 100644
--- a/drivers/scsi/be2iscsi/be_cmds.c
+++ b/drivers/scsi/be2iscsi/be_cmds.c
@@ -93,8 +93,8 @@ int be_chk_reset_complete(struct beiscsi_hba *phba)
 	}
 
 	if ((status & 0x80000000) || (!num_loop)) {
-		printk(KERN_ERR "Failed in be_chk_reset_complete"
-		"status = 0x%x\n", status);
+		printk(KERN_ERR "Failed in be_chk_reset_complete status = 0x%x\n",
+		       status);
 		return -EIO;
 	}
 
@@ -245,8 +245,7 @@ void beiscsi_async_link_state_process(struct beiscsi_hba *phba,
 						evt->physical_port);
 		break;
 	default:
-		SE_DEBUG(DBG_LVL_1, "Unexpected Async Notification %d on"
-				    "Physical Port %d\n",
+		SE_DEBUG(DBG_LVL_1, "Unexpected Async Notification %d on Physical Port %d\n",
 				     evt->port_link_status,
 				     evt->physical_port);
 	}
@@ -279,9 +278,8 @@ int beiscsi_process_mcc(struct beiscsi_hba *phba)
 				beiscsi_async_link_state_process(phba,
 				   (struct be_async_event_link_state *) compl);
 			else
-				SE_DEBUG(DBG_LVL_1,
-					 " Unsupported Async Event, flags"
-					 " = 0x%08x\n", compl->flags);
+				SE_DEBUG(DBG_LVL_1, " Unsupported Async Event, flags = 0x%08x\n",
+					 compl->flags);
 
 		} else if (compl->flags & CQE_FLAGS_COMPLETED_MASK) {
 				status = be_mcc_compl_process(ctrl, compl);
diff --git a/drivers/scsi/be2iscsi/be_iscsi.c b/drivers/scsi/be2iscsi/be_iscsi.c
index 43f3503..589212d 100644
--- a/drivers/scsi/be2iscsi/be_iscsi.c
+++ b/drivers/scsi/be2iscsi/be_iscsi.c
@@ -60,11 +60,11 @@ struct iscsi_cls_session *beiscsi_session_create(struct iscsi_endpoint *ep,
 	phba = beiscsi_ep->phba;
 	shost = phba->shost;
 	if (cmds_max > beiscsi_ep->phba->params.wrbs_per_cxn) {
-		shost_printk(KERN_ERR, shost, "Cannot handle %d cmds."
-			     "Max cmds per session supported is %d. Using %d. "
-			     "\n", cmds_max,
-			      beiscsi_ep->phba->params.wrbs_per_cxn,
-			      beiscsi_ep->phba->params.wrbs_per_cxn);
+		shost_printk(KERN_ERR, shost,
+			     "Cannot handle %d cmds. Max cmds per session supported is %d. Using %d.\n",
+			     cmds_max,
+			     beiscsi_ep->phba->params.wrbs_per_cxn,
+			     beiscsi_ep->phba->params.wrbs_per_cxn);
 		cmds_max = beiscsi_ep->phba->params.wrbs_per_cxn;
 	}
 
@@ -123,8 +123,8 @@ beiscsi_conn_create(struct iscsi_cls_session *cls_session, u32 cid)
 	struct iscsi_session *sess;
 	struct beiscsi_session *beiscsi_sess;
 
-	SE_DEBUG(DBG_LVL_8, "In beiscsi_conn_create ,cid"
-		 "from iscsi layer=%d\n", cid);
+	SE_DEBUG(DBG_LVL_8, "In beiscsi_conn_create, cid from iscsi layer=%d\n",
+		 cid);
 	shost = iscsi_session_to_shost(cls_session);
 	phba = iscsi_host_priv(shost);
 
@@ -219,8 +219,7 @@ static int beiscsi_create_ipv4_iface(struct beiscsi_hba *phba)
 					      ISCSI_IFACE_TYPE_IPV4,
 					      0, 0);
 	if (!phba->ipv4_iface) {
-		shost_printk(KERN_ERR, phba->shost, "Could not "
-			     "create default IPv4 address.\n");
+		shost_printk(KERN_ERR, phba->shost, "Could not create default IPv4 address.\n");
 		return -ENODEV;
 	}
 
@@ -237,8 +236,7 @@ static int beiscsi_create_ipv6_iface(struct beiscsi_hba *phba)
 					      ISCSI_IFACE_TYPE_IPV6,
 					      0, 0);
 	if (!phba->ipv6_iface) {
-		shost_printk(KERN_ERR, phba->shost, "Could not "
-			     "create default IPv6 address.\n");
+		shost_printk(KERN_ERR, phba->shost, "Could not create default IPv6 address.\n");
 		return -ENODEV;
 	}
 
@@ -404,8 +402,7 @@ int be2iscsi_iface_set_param(struct Scsi_Host *shost,
 		 * BE2ISCSI only supports 1 interface
 		 */
 		if (iface_param->iface_num) {
-			shost_printk(KERN_ERR, shost, "Invalid iface_num %d."
-				     "Only iface_num 0 is supported.\n",
+			shost_printk(KERN_ERR, shost, "Invalid iface_num %d. Only iface_num 0 is supported.\n",
 				     iface_param->iface_num);
 			return -EINVAL;
 		}
@@ -421,7 +418,7 @@ int be2iscsi_iface_set_param(struct Scsi_Host *shost,
 			break;
 		default:
 			shost_printk(KERN_ERR, shost,
-				     "Invalid iface type :%d passed\n",
+				     "Invalid iface type: %d passed\n",
 				     iface_param->iface_type);
 			break;
 		}
@@ -604,9 +601,8 @@ static int beiscsi_get_initname(char *buf, struct beiscsi_hba *phba)
 	status = phba->ctrl.mcc_numtag[tag] & 0x000000FF;
 
 	if (status || extd_status) {
-		SE_DEBUG(DBG_LVL_1, "MailBox Command Failed with "
-				"status = %d extd_status = %d\n",
-				status, extd_status);
+		SE_DEBUG(DBG_LVL_1, "MailBox Command Failed with status = %d extd_status = %d\n",
+			            status, extd_status);
 		free_mcc_tag(&phba->ctrl, tag);
 		return -EAGAIN;
 	}
@@ -661,9 +657,8 @@ static int beiscsi_get_port_speed(struct Scsi_Host *shost)
 	status = phba->ctrl.mcc_numtag[tag] & 0x000000FF;
 
 	if (status || extd_status) {
-		SE_DEBUG(DBG_LVL_1, "MailBox Command Failed with "
-				"status = %d extd_status = %d\n",
-				status, extd_status);
+		SE_DEBUG(DBG_LVL_1, "MailBox Command Failed with status = %d extd_status = %d\n",
+			            status, extd_status);
 		free_mcc_tag(&phba->ctrl, tag);
 		return -EAGAIN;
 	}
@@ -833,7 +828,7 @@ int beiscsi_conn_start(struct iscsi_cls_conn *cls_conn)
 	memset(&params, 0, sizeof(struct beiscsi_offload_params));
 	beiscsi_ep = beiscsi_conn->ep;
 	if (!beiscsi_ep)
-		SE_DEBUG(DBG_LVL_1, "In beiscsi_conn_start , no beiscsi_ep\n");
+		SE_DEBUG(DBG_LVL_1, "In beiscsi_conn_start, no beiscsi_ep\n");
 
 	beiscsi_conn->login_in_progress = 0;
 	beiscsi_set_params_for_offld(beiscsi_conn, &params);
@@ -929,8 +924,7 @@ static int beiscsi_open_conn(struct iscsi_endpoint *ep,
 				&nonemb_cmd.dma);
 	if (nonemb_cmd.va == NULL) {
 		SE_DEBUG(DBG_LVL_1,
-			 "Failed to allocate memory for mgmt_open_connection"
-			 "\n");
+			 "Failed to allocate memory for mgmt_open_connection\n");
 		beiscsi_put_cid(phba, beiscsi_ep->ep_cid);
 		return -ENOMEM;
 	}
@@ -953,9 +947,8 @@ static int beiscsi_open_conn(struct iscsi_endpoint *ep,
 	extd_status = (phba->ctrl.mcc_numtag[tag] & 0x0000FF00) >> 8;
 	status = phba->ctrl.mcc_numtag[tag] & 0x000000FF;
 	if (status || extd_status) {
-		SE_DEBUG(DBG_LVL_1, "mgmt_open_connection Failed"
-				    " status = %d extd_status = %d\n",
-				    status, extd_status);
+		SE_DEBUG(DBG_LVL_1, "mgmt_open_connection Failed status = %d extd_status = %d\n",
+			            status, extd_status);
 		free_mcc_tag(&phba->ctrl, tag);
 		pci_free_consistent(phba->ctrl.pdev, nonemb_cmd.size,
 			    nonemb_cmd.va, nonemb_cmd.dma);
@@ -1112,8 +1105,7 @@ void beiscsi_ep_disconnect(struct iscsi_endpoint *ep)
 			     beiscsi_ep->ep_cid);
 
 	if (!beiscsi_ep->conn) {
-		SE_DEBUG(DBG_LVL_8, "In beiscsi_ep_disconnect, no "
-			 "beiscsi_ep\n");
+		SE_DEBUG(DBG_LVL_8, "In beiscsi_ep_disconnect, no beiscsi_ep\n");
 		return;
 	}
 	beiscsi_conn = beiscsi_ep->conn;
diff --git a/drivers/scsi/be2iscsi/be_main.c b/drivers/scsi/be2iscsi/be_main.c
index 0b1d99c..8d01fb4 100644
--- a/drivers/scsi/be2iscsi/be_main.c
+++ b/drivers/scsi/be2iscsi/be_main.c
@@ -113,8 +113,7 @@ static int beiscsi_eh_abort(struct scsi_cmnd *sc)
 				&nonemb_cmd.dma);
 	if (nonemb_cmd.va == NULL) {
 		SE_DEBUG(DBG_LVL_1,
-			 "Failed to allocate memory for"
-			 "mgmt_invalidate_icds\n");
+			 "Failed to allocate memory for mgmt_invalidate_icds\n");
 		return FAILED;
 	}
 	nonemb_cmd.size = sizeof(struct invalidate_commands_params_in);
@@ -123,8 +122,7 @@ static int beiscsi_eh_abort(struct scsi_cmnd *sc)
 				   cid, &nonemb_cmd);
 	if (!tag) {
 		shost_printk(KERN_WARNING, phba->shost,
-			     "mgmt_invalidate_icds could not be"
-			     " submitted\n");
+			     "mgmt_invalidate_icds could not be submitted\n");
 		pci_free_consistent(phba->ctrl.pdev, nonemb_cmd.size,
 				    nonemb_cmd.va, nonemb_cmd.dma);
 
@@ -189,8 +187,7 @@ static int beiscsi_eh_device_reset(struct scsi_cmnd *sc)
 				&nonemb_cmd.dma);
 	if (nonemb_cmd.va == NULL) {
 		SE_DEBUG(DBG_LVL_1,
-			 "Failed to allocate memory for"
-			 "mgmt_invalidate_icds\n");
+			 "Failed to allocate memory for mgmt_invalidate_icds\n");
 		return FAILED;
 	}
 	nonemb_cmd.size = sizeof(struct invalidate_commands_params_in);
@@ -199,8 +196,7 @@ static int beiscsi_eh_device_reset(struct scsi_cmnd *sc)
 				   cid, &nonemb_cmd);
 	if (!tag) {
 		shost_printk(KERN_WARNING, phba->shost,
-			     "mgmt_invalidate_icds could not be"
-			     " submitted\n");
+			     "mgmt_invalidate_icds could not be submitted\n");
 		pci_free_consistent(phba->ctrl.pdev, nonemb_cmd.size,
 				    nonemb_cmd.va, nonemb_cmd.dma);
 		return FAILED;
@@ -843,8 +839,8 @@ static int beiscsi_init_irqs(struct beiscsi_hba *phba)
 					  &phwi_context->be_eq[i]);
 			if (ret) {
 				shost_printk(KERN_ERR, phba->shost,
-					     "beiscsi_init_irqs-Failed to"
-					     "register msix for i = %d\n", i);
+					     "beiscsi_init_irqs-Failed to register msix for i = %d\n",
+					     i);
 				kfree(phba->msi_name[i]);
 				goto free_msix_irqs;
 			}
@@ -860,8 +856,7 @@ static int beiscsi_init_irqs(struct beiscsi_hba *phba)
 		ret = request_irq(msix_vec, be_isr_mcc, 0, phba->msi_name[i],
 				  &phwi_context->be_eq[i]);
 		if (ret) {
-			shost_printk(KERN_ERR, phba->shost, "beiscsi_init_irqs-"
-				     "Failed to register beiscsi_msix_mcc\n");
+			shost_printk(KERN_ERR, phba->shost, "beiscsi_init_irqs - Failed to register beiscsi_msix_mcc\n");
 			kfree(phba->msi_name[i]);
 			goto free_msix_irqs;
 		}
@@ -870,8 +865,7 @@ static int beiscsi_init_irqs(struct beiscsi_hba *phba)
 		ret = request_irq(pcidev->irq, be_isr, IRQF_SHARED,
 				  "beiscsi", phba);
 		if (ret) {
-			shost_printk(KERN_ERR, phba->shost, "beiscsi_init_irqs-"
-				     "Failed to register irq\\n");
+			shost_printk(KERN_ERR, phba->shost, "beiscsi_init_irqs - Failed to register irq\n");
 			return ret;
 		}
 	}
@@ -979,9 +973,9 @@ free_io_sgl_handle(struct beiscsi_hba *phba, struct sgl_handle *psgl_handle)
 		 * failed in xmit_task or alloc_pdu.
 		 */
 		 SE_DEBUG(DBG_LVL_8,
-			 "Double Free in IO SGL io_sgl_free_index=%d,"
-			 "value there=%p\n", phba->io_sgl_free_index,
-			 phba->io_sgl_hndl_base[phba->io_sgl_free_index]);
+			  "Double Free in IO SGL io_sgl_free_index=%d, value there=%p\n",
+			  phba->io_sgl_free_index,
+			  phba->io_sgl_hndl_base[phba->io_sgl_free_index]);
 		return;
 	}
 	phba->io_sgl_hndl_base[phba->io_sgl_free_index] = psgl_handle;
@@ -1044,8 +1038,7 @@ free_wrb_handle(struct beiscsi_hba *phba, struct hwi_wrb_context *pwrb_context,
 		pwrb_context->free_index++;
 
 	SE_DEBUG(DBG_LVL_8,
-		 "FREE WRB: pwrb_handle=%p free_index=0x%x"
-		 "wrb_handles_available=%d\n",
+		 "FREE WRB: pwrb_handle=%p free_index=0x%x wrb_handles_available=%d\n",
 		 pwrb_handle, pwrb_context->free_index,
 		 pwrb_context->wrb_handles_available);
 }
@@ -1075,7 +1068,7 @@ void
 free_mgmt_sgl_handle(struct beiscsi_hba *phba, struct sgl_handle *psgl_handle)
 {
 
-	SE_DEBUG(DBG_LVL_8, "In  free_mgmt_sgl_handle,eh_sgl_free_index=%d\n",
+	SE_DEBUG(DBG_LVL_8, "In  free_mgmt_sgl_handle, eh_sgl_free_index=%d\n",
 			     phba->eh_sgl_free_index);
 	if (phba->eh_sgl_hndl_base[phba->eh_sgl_free_index]) {
 		/*
@@ -1083,7 +1076,7 @@ free_mgmt_sgl_handle(struct beiscsi_hba *phba, struct sgl_handle *psgl_handle)
 		 * failed in xmit_task or alloc_pdu.
 		 */
 		SE_DEBUG(DBG_LVL_8,
-			 "Double Free in eh SGL ,eh_sgl_free_index=%d\n",
+			 "Double Free in eh SGL, eh_sgl_free_index=%d\n",
 			 phba->eh_sgl_free_index);
 		return;
 	}
@@ -1327,8 +1320,7 @@ static void hwi_complete_cmd(struct beiscsi_conn *beiscsi_conn,
 
 	case HWH_TYPE_LOGIN:
 		SE_DEBUG(DBG_LVL_1,
-			 "\t\t No HWH_TYPE_LOGIN Expected in hwi_complete_cmd"
-			 "- Solicited path\n");
+			 "\t\t No HWH_TYPE_LOGIN Expected in hwi_complete_cmd - Solicited path\n");
 		break;
 
 	case HWH_TYPE_NOP:
@@ -1337,8 +1329,8 @@ static void hwi_complete_cmd(struct beiscsi_conn *beiscsi_conn,
 
 	default:
 		shost_printk(KERN_WARNING, phba->shost,
-				"In hwi_complete_cmd, unknown type = %d"
-				"wrb_index 0x%x CID 0x%x\n", type,
+				"In hwi_complete_cmd, unknown type = %d wrb_index 0x%x CID 0x%x\n",
+			        type,
 				((psol->dw[offsetof(struct amap_iscsi_wrb,
 				type) / 32] & SOL_WRB_INDEX_MASK) >> 16),
 				((psol->dw[offsetof(struct amap_sol_cqe,
@@ -1775,8 +1767,8 @@ static void  beiscsi_process_mcc_isr(struct beiscsi_hba *phba)
 				(struct be_async_event_link_state *) mcc_compl);
 			else
 				SE_DEBUG(DBG_LVL_1,
-					" Unsupported Async Event, flags"
-					" = 0x%08x\n", mcc_compl->flags);
+					" Unsupported Async Event, flags = 0x%08x\n",
+					 mcc_compl->flags);
 		} else if (mcc_compl->flags & CQE_FLAGS_COMPLETED_MASK) {
 			be_mcc_compl_process_isr(&phba->ctrl, mcc_compl);
 			atomic_dec(&phba->ctrl.mcc_obj.q.used);
@@ -1853,8 +1845,7 @@ static unsigned int beiscsi_process_cq(struct be_eq_obj *pbe_eq)
 		case CMD_INVALIDATED_NOTIFY:
 		case CXN_INVALIDATE_NOTIFY:
 			SE_DEBUG(DBG_LVL_1,
-				 "Ignoring CQ Error notification for cmd/cxn"
-				 "invalidate\n");
+				 "Ignoring CQ Error notification for cmd/cxn invalidate\n");
 			break;
 		case SOL_CMD_KILLED_DATA_DIGEST_ERR:
 		case CMD_KILLED_INVALID_STATSN_RCVD:
@@ -1865,8 +1856,7 @@ static unsigned int beiscsi_process_cq(struct be_eq_obj *pbe_eq)
 		case CMD_CXN_KILLED_SEQ_OUTOFORDER:
 		case CMD_CXN_KILLED_INVALID_DATASN_RCVD:
 			SE_DEBUG(DBG_LVL_1,
-				 "CQ Error notification for cmd.. "
-				 "code %d cid 0x%x\n",
+				 "CQ Error notification for cmd.. code %d cid 0x%x\n",
 				 sol->dw[offsetof(struct amap_sol_cqe, code) /
 				 32] & CQE_CODE_MASK,
 				 (sol->dw[offsetof(struct amap_sol_cqe, cid) /
@@ -1892,8 +1882,7 @@ static unsigned int beiscsi_process_cq(struct be_eq_obj *pbe_eq)
 		case CXN_KILLED_OVER_RUN_RESIDUAL:
 		case CXN_KILLED_UNDER_RUN_RESIDUAL:
 		case CXN_KILLED_CMND_DATA_NOT_ON_SAME_CONN:
-			SE_DEBUG(DBG_LVL_1, "CQ Error %d, reset CID "
-				 "0x%x...\n",
+			SE_DEBUG(DBG_LVL_1, "CQ Error %d, reset CID 0x%x...\n",
 				 sol->dw[offsetof(struct amap_sol_cqe, code) /
 				 32] & CQE_CODE_MASK,
 				 (sol->dw[offsetof(struct amap_sol_cqe, cid) /
@@ -1903,8 +1892,7 @@ static unsigned int beiscsi_process_cq(struct be_eq_obj *pbe_eq)
 			break;
 		case CXN_KILLED_RST_SENT:
 		case CXN_KILLED_RST_RCVD:
-			SE_DEBUG(DBG_LVL_1, "CQ Error %d, reset"
-				"received/sent on CID 0x%x...\n",
+			SE_DEBUG(DBG_LVL_1, "CQ Error %d, reset received/sent on CID 0x%x...\n",
 				 sol->dw[offsetof(struct amap_sol_cqe, code) /
 				 32] & CQE_CODE_MASK,
 				 (sol->dw[offsetof(struct amap_sol_cqe, cid) /
@@ -1913,8 +1901,7 @@ static unsigned int beiscsi_process_cq(struct be_eq_obj *pbe_eq)
 					   ISCSI_ERR_CONN_FAILED);
 			break;
 		default:
-			SE_DEBUG(DBG_LVL_1, "CQ Error Invalid code= %d "
-				 "received on CID 0x%x...\n",
+			SE_DEBUG(DBG_LVL_1, "CQ Error Invalid code= %d received on CID 0x%x...\n",
 				 sol->dw[offsetof(struct amap_sol_cqe, code) /
 				 32] & CQE_CODE_MASK,
 				 (sol->dw[offsetof(struct amap_sol_cqe, cid) /
@@ -2439,8 +2426,8 @@ static void hwi_init_async_pdu_ctx(struct beiscsi_hba *phba)
 	mem_descr += HWI_MEM_ASYNC_HEADER_BUF;
 	if (mem_descr->mem_array[0].virtual_address) {
 		SE_DEBUG(DBG_LVL_8,
-			 "hwi_init_async_pdu_ctx HWI_MEM_ASYNC_HEADER_BUF"
-			 "va=%p\n", mem_descr->mem_array[0].virtual_address);
+			 "hwi_init_async_pdu_ctx HWI_MEM_ASYNC_HEADER_BUF va=%p\n",
+			 mem_descr->mem_array[0].virtual_address);
 	} else
 		shost_printk(KERN_WARNING, phba->shost,
 			     "No Virtual address\n");
@@ -2455,8 +2442,8 @@ static void hwi_init_async_pdu_ctx(struct beiscsi_hba *phba)
 	mem_descr += HWI_MEM_ASYNC_HEADER_RING;
 	if (mem_descr->mem_array[0].virtual_address) {
 		SE_DEBUG(DBG_LVL_8,
-			 "hwi_init_async_pdu_ctx HWI_MEM_ASYNC_HEADER_RING"
-			 "va=%p\n", mem_descr->mem_array[0].virtual_address);
+			 "hwi_init_async_pdu_ctx HWI_MEM_ASYNC_HEADER_RING va=%p\n",
+			 mem_descr->mem_array[0].virtual_address);
 	} else
 		shost_printk(KERN_WARNING, phba->shost,
 			    "No Virtual address\n");
@@ -2467,8 +2454,8 @@ static void hwi_init_async_pdu_ctx(struct beiscsi_hba *phba)
 	mem_descr += HWI_MEM_ASYNC_HEADER_HANDLE;
 	if (mem_descr->mem_array[0].virtual_address) {
 		SE_DEBUG(DBG_LVL_8,
-			 "hwi_init_async_pdu_ctx HWI_MEM_ASYNC_HEADER_HANDLE"
-			 "va=%p\n", mem_descr->mem_array[0].virtual_address);
+			 "hwi_init_async_pdu_ctx HWI_MEM_ASYNC_HEADER_HANDLE va=%p\n",
+			 mem_descr->mem_array[0].virtual_address);
 	} else
 		shost_printk(KERN_WARNING, phba->shost,
 			    "No Virtual address\n");
@@ -2483,8 +2470,8 @@ static void hwi_init_async_pdu_ctx(struct beiscsi_hba *phba)
 	mem_descr += HWI_MEM_ASYNC_DATA_RING;
 	if (mem_descr->mem_array[0].virtual_address) {
 		SE_DEBUG(DBG_LVL_8,
-			 "hwi_init_async_pdu_ctx HWI_MEM_ASYNC_DATA_RING"
-			 "va=%p\n", mem_descr->mem_array[0].virtual_address);
+			 "hwi_init_async_pdu_ctx HWI_MEM_ASYNC_DATA_RING va=%p\n",
+			 mem_descr->mem_array[0].virtual_address);
 	} else
 		shost_printk(KERN_WARNING, phba->shost,
 			     "No Virtual address\n");
@@ -2512,8 +2499,8 @@ static void hwi_init_async_pdu_ctx(struct beiscsi_hba *phba)
 	mem_descr += HWI_MEM_ASYNC_DATA_BUF;
 	if (mem_descr->mem_array[0].virtual_address) {
 		SE_DEBUG(DBG_LVL_8,
-			 "hwi_init_async_pdu_ctx HWI_MEM_ASYNC_DATA_BUF"
-			 "va=%p\n", mem_descr->mem_array[0].virtual_address);
+			 "hwi_init_async_pdu_ctx HWI_MEM_ASYNC_DATA_BUF va=%p\n",
+			 mem_descr->mem_array[0].virtual_address);
 	} else
 		shost_printk(KERN_WARNING, phba->shost,
 			    "No Virtual address\n");
@@ -2694,8 +2681,7 @@ static int beiscsi_create_eqs(struct beiscsi_hba *phba,
 					    phwi_context->cur_eqd);
 		if (ret) {
 			shost_printk(KERN_ERR, phba->shost,
-				     "beiscsi_cmd_eq_create"
-				     "Failedfor EQ\n");
+				     "beiscsi_cmd_eq_create Failed for EQ\n");
 			goto create_eq_error;
 		}
 		SE_DEBUG(DBG_LVL_8, "eqid = %d\n", phwi_context->be_eq[i].q.id);
@@ -2752,8 +2738,7 @@ static int beiscsi_create_cqs(struct beiscsi_hba *phba,
 					    false, 0);
 		if (ret) {
 			shost_printk(KERN_ERR, phba->shost,
-				     "beiscsi_cmd_eq_create"
-				     "Failed for ISCSI CQ\n");
+				     "beiscsi_cmd_eq_create Failed for ISCSI CQ\n");
 			goto create_cq_error;
 		}
 		SE_DEBUG(DBG_LVL_8, "iscsi cq_id is %d for eq_id %d\n",
@@ -2855,8 +2840,7 @@ beiscsi_create_def_data(struct beiscsi_hba *phba,
 					      phba->params.defpdu_data_sz);
 	if (ret) {
 		shost_printk(KERN_ERR, phba->shost,
-			     "be_cmd_create_default_pdu_queue Failed"
-			     " for DEF PDU DATA\n");
+			     "be_cmd_create_default_pdu_queue Failed for DEF PDU DATA\n");
 		return ret;
 	}
 	phwi_ctrlr->default_pdu_data.id = phwi_context->be_def_dataq.id;
@@ -3221,8 +3205,7 @@ static int hwi_init_controller(struct beiscsi_hba *phba)
 			 phwi_ctrlr->phwi_ctxt);
 	} else {
 		shost_printk(KERN_ERR, phba->shost,
-			     "HWI_MEM_ADDN_CONTEXT is more than one element."
-			     "Failing to load\n");
+			     "HWI_MEM_ADDN_CONTEXT is more than one element. Failing to load\n");
 		return -ENOMEM;
 	}
 
@@ -3268,8 +3251,7 @@ static int beiscsi_init_controller(struct beiscsi_hba *phba)
 
 	ret = beiscsi_get_memory(phba);
 	if (ret < 0) {
-		shost_printk(KERN_ERR, phba->shost, "beiscsi_dev_probe -"
-			     "Failed in beiscsi_alloc_memory\n");
+		shost_printk(KERN_ERR, phba->shost, "beiscsi_dev_probe - Failed in beiscsi_alloc_memory\n");
 		return ret;
 	}
 
@@ -3317,8 +3299,7 @@ static int beiscsi_init_sgl_handle(struct beiscsi_hba *phba)
 		}
 	} else {
 		shost_printk(KERN_ERR, phba->shost,
-			     "HWI_MEM_SGLH is more than one element."
-			     "Failing to load\n");
+			     "HWI_MEM_SGLH is more than one element. Failing to load\n");
 		return -ENOMEM;
 	}
 
@@ -3345,8 +3326,7 @@ static int beiscsi_init_sgl_handle(struct beiscsi_hba *phba)
 		idx++;
 	}
 	SE_DEBUG(DBG_LVL_8,
-		 "phba->io_sgl_hndl_avbl=%d"
-		 "phba->eh_sgl_hndl_avbl=%d\n",
+		 "phba->io_sgl_hndl_avbl=%d phba->eh_sgl_hndl_avbl=%d\n",
 		 phba->io_sgl_hndl_avbl,
 		 phba->eh_sgl_hndl_avbl);
 	mem_descr_sg = phba->init_mem;
@@ -3391,16 +3371,14 @@ static int hba_setup_cid_tbls(struct beiscsi_hba *phba)
 				  GFP_KERNEL);
 	if (!phba->cid_array) {
 		shost_printk(KERN_ERR, phba->shost,
-			     "Failed to allocate memory in "
-			     "hba_setup_cid_tbls\n");
+			     "Failed to allocate memory in hba_setup_cid_tbls\n");
 		return -ENOMEM;
 	}
 	phba->ep_array = kzalloc(sizeof(struct iscsi_endpoint *) *
 				 phba->params.cxns_per_ctrl * 2, GFP_KERNEL);
 	if (!phba->ep_array) {
 		shost_printk(KERN_ERR, phba->shost,
-			     "Failed to allocate memory in "
-			     "hba_setup_cid_tbls\n");
+			     "Failed to allocate memory in hba_setup_cid_tbls\n");
 		kfree(phba->cid_array);
 		return -ENOMEM;
 	}
@@ -3489,9 +3467,8 @@ static int beiscsi_get_boot_info(struct beiscsi_hba *phba)
 	extd_status = (phba->ctrl.mcc_numtag[tag] & 0x0000FF00) >> 8;
 	status = phba->ctrl.mcc_numtag[tag] & 0x000000FF;
 	if (status || extd_status) {
-		SE_DEBUG(DBG_LVL_1, "beiscsi_get_boot_info Failed"
-				    " status = %d extd_status = %d\n",
-				    status, extd_status);
+		SE_DEBUG(DBG_LVL_1, "beiscsi_get_boot_info Failed status = %d extd_status = %d\n",
+			            status, extd_status);
 		free_mcc_tag(&phba->ctrl, tag);
 		return -EBUSY;
 	}
@@ -3509,8 +3486,7 @@ static int beiscsi_get_boot_info(struct beiscsi_hba *phba)
 				&nonemb_cmd.dma);
 	if (nonemb_cmd.va == NULL) {
 		SE_DEBUG(DBG_LVL_1,
-			 "Failed to allocate memory for"
-			 "beiscsi_get_session_info\n");
+			 "Failed to allocate memory for beiscsi_get_session_info\n");
 		return -ENOMEM;
 	}
 
@@ -3518,8 +3494,7 @@ static int beiscsi_get_boot_info(struct beiscsi_hba *phba)
 	tag = mgmt_get_session_info(phba, boot_resp->boot_session_handle,
 				    &nonemb_cmd);
 	if (!tag) {
-		SE_DEBUG(DBG_LVL_1, "beiscsi_get_session_info"
-			" Failed\n");
+		SE_DEBUG(DBG_LVL_1, "beiscsi_get_session_info Failed\n");
 		goto boot_freemem;
 	} else
 		wait_event_interruptible(phba->ctrl.mcc_wait[tag],
@@ -3529,9 +3504,8 @@ static int beiscsi_get_boot_info(struct beiscsi_hba *phba)
 	extd_status = (phba->ctrl.mcc_numtag[tag] & 0x0000FF00) >> 8;
 	status = phba->ctrl.mcc_numtag[tag] & 0x000000FF;
 	if (status || extd_status) {
-		SE_DEBUG(DBG_LVL_1, "beiscsi_get_session_info Failed"
-				    " status = %d extd_status = %d\n",
-				    status, extd_status);
+		SE_DEBUG(DBG_LVL_1, "beiscsi_get_session_info Failed status = %d extd_status = %d\n",
+			            status, extd_status);
 		free_mcc_tag(&phba->ctrl, tag);
 		goto boot_freemem;
 	}
@@ -3612,15 +3586,13 @@ static int beiscsi_init_port(struct beiscsi_hba *phba)
 	ret = beiscsi_init_controller(phba);
 	if (ret < 0) {
 		shost_printk(KERN_ERR, phba->shost,
-			     "beiscsi_dev_probe - Failed in"
-			     "beiscsi_init_controller\n");
+			     "beiscsi_dev_probe - Failed in beiscsi_init_controller\n");
 		return ret;
 	}
 	ret = beiscsi_init_sgl_handle(phba);
 	if (ret < 0) {
 		shost_printk(KERN_ERR, phba->shost,
-			     "beiscsi_dev_probe - Failed in"
-			     "beiscsi_init_sgl_handle\n");
+			     "beiscsi_dev_probe - Failed in beiscsi_init_sgl_handle\n");
 		goto do_cleanup_ctrlr;
 	}
 
@@ -4162,8 +4134,7 @@ static int beiscsi_bsg_request(struct bsg_job *job)
 					job->request_payload.payload_len,
 					&nonemb_cmd.dma);
 		if (nonemb_cmd.va == NULL) {
-			SE_DEBUG(DBG_LVL_1, "Failed to allocate memory for "
-				 "beiscsi_bsg_request\n");
+			SE_DEBUG(DBG_LVL_1, "Failed to allocate memory for beiscsi_bsg_request\n");
 			return -EIO;
 		}
 		tag = mgmt_vendor_specific_fw_cmd(&phba->ctrl, phba, job,
@@ -4191,8 +4162,7 @@ static int beiscsi_bsg_request(struct bsg_job *job)
 		pci_free_consistent(phba->ctrl.pdev, nonemb_cmd.size,
 				    nonemb_cmd.va, nonemb_cmd.dma);
 		if (status || extd_status) {
-			SE_DEBUG(DBG_LVL_1, "be_cmd_get_mac_addr Failed"
-				 " status = %d extd_status = %d\n",
+			SE_DEBUG(DBG_LVL_1, "be_cmd_get_mac_addr Failed status = %d extd_status = %d\n",
 				 status, extd_status);
 			return -EIO;
 		}
@@ -4356,8 +4326,7 @@ static int __devinit beiscsi_dev_probe(struct pci_dev *pcidev,
 	}
 	ret = be_ctrl_init(phba, pcidev);
 	if (ret) {
-		shost_printk(KERN_ERR, phba->shost, "beiscsi_dev_probe-"
-				"Failed in be_ctrl_init\n");
+		shost_printk(KERN_ERR, phba->shost, "beiscsi_dev_probe - Failed in be_ctrl_init\n");
 		goto hba_free;
 	}
 
@@ -4377,8 +4346,7 @@ static int __devinit beiscsi_dev_probe(struct pci_dev *pcidev,
 			ret = be_chk_reset_complete(phba);
 			if (ret) {
 				shost_printk(KERN_ERR, phba->shost,
-					"Failed to get out of reset."
-					"Aborting Crashdump\n");
+					"Failed to get out of reset. Aborting Crashdump\n");
 				goto hba_free;
 			}
 		} else {
@@ -4402,8 +4370,7 @@ static int __devinit beiscsi_dev_probe(struct pci_dev *pcidev,
 	phba->shost->can_queue = phba->params.ios_per_ctrl;
 	ret = beiscsi_init_port(phba);
 	if (ret < 0) {
-		shost_printk(KERN_ERR, phba->shost, "beiscsi_dev_probe-"
-			     "Failed in beiscsi_init_port\n");
+		shost_printk(KERN_ERR, phba->shost, "beiscsi_dev_probe - Failed in beiscsi_init_port\n");
 		goto free_port;
 	}
 
@@ -4420,8 +4387,7 @@ static int __devinit beiscsi_dev_probe(struct pci_dev *pcidev,
 		 phba->shost->host_no);
 	phba->wq = alloc_workqueue(phba->wq_name, WQ_MEM_RECLAIM, 1);
 	if (!phba->wq) {
-		shost_printk(KERN_ERR, phba->shost, "beiscsi_dev_probe-"
-				"Failed to allocate work queue\n");
+		shost_printk(KERN_ERR, phba->shost, "beiscsi_dev_probe - Failed to allocate work queue\n");
 		goto free_twq;
 	}
 
@@ -4439,8 +4405,7 @@ static int __devinit beiscsi_dev_probe(struct pci_dev *pcidev,
 	}
 	ret = beiscsi_init_irqs(phba);
 	if (ret < 0) {
-		shost_printk(KERN_ERR, phba->shost, "beiscsi_dev_probe-"
-			     "Failed to beiscsi_init_irqs\n");
+		shost_printk(KERN_ERR, phba->shost, "beiscsi_dev_probe - Failed to beiscsi_init_irqs\n");
 		goto free_blkenbld;
 	}
 	hwi_enable_intr(phba);
@@ -4450,8 +4415,7 @@ static int __devinit beiscsi_dev_probe(struct pci_dev *pcidev,
 		 * log error but continue, because we may not be using
 		 * iscsi boot.
 		 */
-		shost_printk(KERN_ERR, phba->shost, "Could not set up "
-			     "iSCSI boot info.\n");
+		shost_printk(KERN_ERR, phba->shost, "Could not set up iSCSI boot info.\n");
 
 	beiscsi_create_def_ifaces(phba);
 	SE_DEBUG(DBG_LVL_8, "\n\n\n SUCCESS - DRIVER LOADED\n\n\n");
@@ -4543,8 +4507,7 @@ static int __init beiscsi_module_init(void)
 			iscsi_register_transport(&beiscsi_iscsi_transport);
 	if (!beiscsi_scsi_transport) {
 		SE_DEBUG(DBG_LVL_1,
-			 "beiscsi_module_init - Unable to  register beiscsi"
-			 "transport.\n");
+			 "beiscsi_module_init - Unable to  register beiscsi transport.\n");
 		return -ENOMEM;
 	}
 	SE_DEBUG(DBG_LVL_8, "In beiscsi_module_init, tt=%p\n",
@@ -4553,8 +4516,7 @@ static int __init beiscsi_module_init(void)
 	ret = pci_register_driver(&beiscsi_pci_driver);
 	if (ret) {
 		SE_DEBUG(DBG_LVL_1,
-			 "beiscsi_module_init - Unable to  register"
-			 "beiscsi pci driver.\n");
+			 "beiscsi_module_init - Unable to register beiscsi pci driver.\n");
 		goto unregister_iscsi_transport;
 	}
 	return 0;
diff --git a/drivers/scsi/be2iscsi/be_mgmt.c b/drivers/scsi/be2iscsi/be_mgmt.c
index 2a09679..433eabe 100644
--- a/drivers/scsi/be2iscsi/be_mgmt.c
+++ b/drivers/scsi/be2iscsi/be_mgmt.c
@@ -122,8 +122,7 @@ int mgmt_get_fw_config(struct be_ctrl_info *ctrl,
 					pfw_cfg->ulp[0].sq_count;
 		if (phba->fw_config.iscsi_cid_count > (BE2_MAX_SESSIONS / 2)) {
 			SE_DEBUG(DBG_LVL_8,
-				"FW reported MAX CXNS as %d\t"
-				"Max Supported = %d.\n",
+				"FW reported MAX CXNS as %d\tMax Supported = %d.\n",
 				phba->fw_config.iscsi_cid_count,
 				BE2_MAX_SESSIONS);
 			phba->fw_config.iscsi_cid_count = BE2_MAX_SESSIONS / 2;
@@ -151,8 +150,7 @@ int mgmt_check_supported_fw(struct be_ctrl_info *ctrl,
 				&nonemb_cmd.dma);
 	if (nonemb_cmd.va == NULL) {
 		SE_DEBUG(DBG_LVL_1,
-			 "Failed to allocate memory for mgmt_check_supported_fw"
-			 "\n");
+			 "Failed to allocate memory for mgmt_check_supported_fw\n");
 		return -ENOMEM;
 	}
 	nonemb_cmd.size = sizeof(struct be_mgmt_controller_attributes);
@@ -551,8 +549,8 @@ static int mgmt_exec_nonemb_cmd(struct beiscsi_hba *phba,
 	status = phba->ctrl.mcc_numtag[tag] & 0x000000FF;
 	if (status || extd_status) {
 		SE_DEBUG(DBG_LVL_1,
-			 "mgmt_exec_nonemb_cmd Failed status = %d"
-			 "extd_status = %d\n", status, extd_status);
+			 "mgmt_exec_nonemb_cmd Failed status = %d extd_status = %d\n",
+			 status, extd_status);
 		rc = -EIO;
 		goto free_tag;
 	}
-- 
1.7.11.2

