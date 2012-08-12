From: Masatake YAMATO <yamato@redhat.com>
Subject: [PATCH] be2iscsi: cleanup format strings using literal string concatenations
Date: Mon, 13 Aug 2012 00:25:30 +0900
Message-ID: <1344785130-24172-1-git-send-email-yamato@redhat.com>
Return-path: <linux-kernel-owner@vger.kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
To: linux-scsi@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, Masatake YAMATO <yamato@redhat.com>
List-Id: linux-scsi@vger.kernel.org

In format strings for printk in be2iscsi, literal c string
concatenations are used widely. However, the log output is a bit
difficult to read because whitespaces are missed in the literal c
strings like:

    SE_DEBUG(DBG_LVL_1, "CQ Error %d, reset"
			"received/sent on CID 0x%x...\n",

You will see "CQ Error 0xffffffff resetreceived/sent on CID ..." and
wonder what is "resetreceived".

This patch cleanup these log messages:

- inserting a white space between c string concatenations,
- inserting a white space after punctuation, and
- inserting white spaces before/after hypen.

Signed-off-by: Masatake YAMATO <yamato@redhat.com>
---
 drivers/scsi/be2iscsi/be_cmds.c  |  4 +--
 drivers/scsi/be2iscsi/be_iscsi.c | 10 +++---
 drivers/scsi/be2iscsi/be_main.c  | 70 ++++++++++++++++++++--------------------
 drivers/scsi/be2iscsi/be_mgmt.c  |  2 +-
 4 files changed, 43 insertions(+), 43 deletions(-)

diff --git a/drivers/scsi/be2iscsi/be_cmds.c b/drivers/scsi/be2iscsi/be_cmds.c
index d2e9e93..d117e7a 100644
--- a/drivers/scsi/be2iscsi/be_cmds.c
+++ b/drivers/scsi/be2iscsi/be_cmds.c
@@ -93,7 +93,7 @@ int be_chk_reset_complete(struct beiscsi_hba *phba)
 	}
 
 	if ((status & 0x80000000) || (!num_loop)) {
-		printk(KERN_ERR "Failed in be_chk_reset_complete"
+		printk(KERN_ERR "Failed in be_chk_reset_complete "
 		"status = 0x%x\n", status);
 		return -EIO;
 	}
@@ -245,7 +245,7 @@ void beiscsi_async_link_state_process(struct beiscsi_hba *phba,
 						evt->physical_port);
 		break;
 	default:
-		SE_DEBUG(DBG_LVL_1, "Unexpected Async Notification %d on"
+		SE_DEBUG(DBG_LVL_1, "Unexpected Async Notification %d on "
 				    "Physical Port %d\n",
 				     evt->port_link_status,
 				     evt->physical_port);
diff --git a/drivers/scsi/be2iscsi/be_iscsi.c b/drivers/scsi/be2iscsi/be_iscsi.c
index 43f3503..15270dd 100644
--- a/drivers/scsi/be2iscsi/be_iscsi.c
+++ b/drivers/scsi/be2iscsi/be_iscsi.c
@@ -60,8 +60,8 @@ struct iscsi_cls_session *beiscsi_session_create(struct iscsi_endpoint *ep,
 	phba = beiscsi_ep->phba;
 	shost = phba->shost;
 	if (cmds_max > beiscsi_ep->phba->params.wrbs_per_cxn) {
-		shost_printk(KERN_ERR, shost, "Cannot handle %d cmds."
-			     "Max cmds per session supported is %d. Using %d. "
+		shost_printk(KERN_ERR, shost, "Cannot handle %d cmds. "
+			     "Max cmds per session supported is %d. Using %d."
 			     "\n", cmds_max,
 			      beiscsi_ep->phba->params.wrbs_per_cxn,
 			      beiscsi_ep->phba->params.wrbs_per_cxn);
@@ -123,7 +123,7 @@ beiscsi_conn_create(struct iscsi_cls_session *cls_session, u32 cid)
 	struct iscsi_session *sess;
 	struct beiscsi_session *beiscsi_sess;
 
-	SE_DEBUG(DBG_LVL_8, "In beiscsi_conn_create ,cid"
+	SE_DEBUG(DBG_LVL_8, "In beiscsi_conn_create, cid "
 		 "from iscsi layer=%d\n", cid);
 	shost = iscsi_session_to_shost(cls_session);
 	phba = iscsi_host_priv(shost);
@@ -404,7 +404,7 @@ int be2iscsi_iface_set_param(struct Scsi_Host *shost,
 		 * BE2ISCSI only supports 1 interface
 		 */
 		if (iface_param->iface_num) {
-			shost_printk(KERN_ERR, shost, "Invalid iface_num %d."
+			shost_printk(KERN_ERR, shost, "Invalid iface_num %d. "
 				     "Only iface_num 0 is supported.\n",
 				     iface_param->iface_num);
 			return -EINVAL;
@@ -833,7 +833,7 @@ int beiscsi_conn_start(struct iscsi_cls_conn *cls_conn)
 	memset(&params, 0, sizeof(struct beiscsi_offload_params));
 	beiscsi_ep = beiscsi_conn->ep;
 	if (!beiscsi_ep)
-		SE_DEBUG(DBG_LVL_1, "In beiscsi_conn_start , no beiscsi_ep\n");
+		SE_DEBUG(DBG_LVL_1, "In beiscsi_conn_start, no beiscsi_ep\n");
 
 	beiscsi_conn->login_in_progress = 0;
 	beiscsi_set_params_for_offld(beiscsi_conn, &params);
diff --git a/drivers/scsi/be2iscsi/be_main.c b/drivers/scsi/be2iscsi/be_main.c
index 0b1d99c..92e534b 100644
--- a/drivers/scsi/be2iscsi/be_main.c
+++ b/drivers/scsi/be2iscsi/be_main.c
@@ -113,7 +113,7 @@ static int beiscsi_eh_abort(struct scsi_cmnd *sc)
 				&nonemb_cmd.dma);
 	if (nonemb_cmd.va == NULL) {
 		SE_DEBUG(DBG_LVL_1,
-			 "Failed to allocate memory for"
+			 "Failed to allocate memory for "
 			 "mgmt_invalidate_icds\n");
 		return FAILED;
 	}
@@ -189,7 +189,7 @@ static int beiscsi_eh_device_reset(struct scsi_cmnd *sc)
 				&nonemb_cmd.dma);
 	if (nonemb_cmd.va == NULL) {
 		SE_DEBUG(DBG_LVL_1,
-			 "Failed to allocate memory for"
+			 "Failed to allocate memory for "
 			 "mgmt_invalidate_icds\n");
 		return FAILED;
 	}
@@ -843,7 +843,7 @@ static int beiscsi_init_irqs(struct beiscsi_hba *phba)
 					  &phwi_context->be_eq[i]);
 			if (ret) {
 				shost_printk(KERN_ERR, phba->shost,
-					     "beiscsi_init_irqs-Failed to"
+					     "beiscsi_init_irqs-Failed to "
 					     "register msix for i = %d\n", i);
 				kfree(phba->msi_name[i]);
 				goto free_msix_irqs;
@@ -860,7 +860,7 @@ static int beiscsi_init_irqs(struct beiscsi_hba *phba)
 		ret = request_irq(msix_vec, be_isr_mcc, 0, phba->msi_name[i],
 				  &phwi_context->be_eq[i]);
 		if (ret) {
-			shost_printk(KERN_ERR, phba->shost, "beiscsi_init_irqs-"
+			shost_printk(KERN_ERR, phba->shost, "beiscsi_init_irqs - "
 				     "Failed to register beiscsi_msix_mcc\n");
 			kfree(phba->msi_name[i]);
 			goto free_msix_irqs;
@@ -870,7 +870,7 @@ static int beiscsi_init_irqs(struct beiscsi_hba *phba)
 		ret = request_irq(pcidev->irq, be_isr, IRQF_SHARED,
 				  "beiscsi", phba);
 		if (ret) {
-			shost_printk(KERN_ERR, phba->shost, "beiscsi_init_irqs-"
+			shost_printk(KERN_ERR, phba->shost, "beiscsi_init_irqs - "
 				     "Failed to register irq\\n");
 			return ret;
 		}
@@ -979,7 +979,7 @@ free_io_sgl_handle(struct beiscsi_hba *phba, struct sgl_handle *psgl_handle)
 		 * failed in xmit_task or alloc_pdu.
 		 */
 		 SE_DEBUG(DBG_LVL_8,
-			 "Double Free in IO SGL io_sgl_free_index=%d,"
+			 "Double Free in IO SGL io_sgl_free_index=%d, "
 			 "value there=%p\n", phba->io_sgl_free_index,
 			 phba->io_sgl_hndl_base[phba->io_sgl_free_index]);
 		return;
@@ -1044,7 +1044,7 @@ free_wrb_handle(struct beiscsi_hba *phba, struct hwi_wrb_context *pwrb_context,
 		pwrb_context->free_index++;
 
 	SE_DEBUG(DBG_LVL_8,
-		 "FREE WRB: pwrb_handle=%p free_index=0x%x"
+		 "FREE WRB: pwrb_handle=%p free_index=0x%x "
 		 "wrb_handles_available=%d\n",
 		 pwrb_handle, pwrb_context->free_index,
 		 pwrb_context->wrb_handles_available);
@@ -1075,7 +1075,7 @@ void
 free_mgmt_sgl_handle(struct beiscsi_hba *phba, struct sgl_handle *psgl_handle)
 {
 
-	SE_DEBUG(DBG_LVL_8, "In  free_mgmt_sgl_handle,eh_sgl_free_index=%d\n",
+	SE_DEBUG(DBG_LVL_8, "In  free_mgmt_sgl_handle, eh_sgl_free_index=%d\n",
 			     phba->eh_sgl_free_index);
 	if (phba->eh_sgl_hndl_base[phba->eh_sgl_free_index]) {
 		/*
@@ -1083,7 +1083,7 @@ free_mgmt_sgl_handle(struct beiscsi_hba *phba, struct sgl_handle *psgl_handle)
 		 * failed in xmit_task or alloc_pdu.
 		 */
 		SE_DEBUG(DBG_LVL_8,
-			 "Double Free in eh SGL ,eh_sgl_free_index=%d\n",
+			 "Double Free in eh SGL, eh_sgl_free_index=%d\n",
 			 phba->eh_sgl_free_index);
 		return;
 	}
@@ -1328,7 +1328,7 @@ static void hwi_complete_cmd(struct beiscsi_conn *beiscsi_conn,
 	case HWH_TYPE_LOGIN:
 		SE_DEBUG(DBG_LVL_1,
 			 "\t\t No HWH_TYPE_LOGIN Expected in hwi_complete_cmd"
-			 "- Solicited path\n");
+			 " - Solicited path\n");
 		break;
 
 	case HWH_TYPE_NOP:
@@ -1337,7 +1337,7 @@ static void hwi_complete_cmd(struct beiscsi_conn *beiscsi_conn,
 
 	default:
 		shost_printk(KERN_WARNING, phba->shost,
-				"In hwi_complete_cmd, unknown type = %d"
+				"In hwi_complete_cmd, unknown type = %d "
 				"wrb_index 0x%x CID 0x%x\n", type,
 				((psol->dw[offsetof(struct amap_iscsi_wrb,
 				type) / 32] & SOL_WRB_INDEX_MASK) >> 16),
@@ -1854,7 +1854,7 @@ static unsigned int beiscsi_process_cq(struct be_eq_obj *pbe_eq)
 		case CXN_INVALIDATE_NOTIFY:
 			SE_DEBUG(DBG_LVL_1,
 				 "Ignoring CQ Error notification for cmd/cxn"
-				 "invalidate\n");
+				 " invalidate\n");
 			break;
 		case SOL_CMD_KILLED_DATA_DIGEST_ERR:
 		case CMD_KILLED_INVALID_STATSN_RCVD:
@@ -1903,7 +1903,7 @@ static unsigned int beiscsi_process_cq(struct be_eq_obj *pbe_eq)
 			break;
 		case CXN_KILLED_RST_SENT:
 		case CXN_KILLED_RST_RCVD:
-			SE_DEBUG(DBG_LVL_1, "CQ Error %d, reset"
+			SE_DEBUG(DBG_LVL_1, "CQ Error %d, reset "
 				"received/sent on CID 0x%x...\n",
 				 sol->dw[offsetof(struct amap_sol_cqe, code) /
 				 32] & CQE_CODE_MASK,
@@ -2439,7 +2439,7 @@ static void hwi_init_async_pdu_ctx(struct beiscsi_hba *phba)
 	mem_descr += HWI_MEM_ASYNC_HEADER_BUF;
 	if (mem_descr->mem_array[0].virtual_address) {
 		SE_DEBUG(DBG_LVL_8,
-			 "hwi_init_async_pdu_ctx HWI_MEM_ASYNC_HEADER_BUF"
+			 "hwi_init_async_pdu_ctx HWI_MEM_ASYNC_HEADER_BUF "
 			 "va=%p\n", mem_descr->mem_array[0].virtual_address);
 	} else
 		shost_printk(KERN_WARNING, phba->shost,
@@ -2455,7 +2455,7 @@ static void hwi_init_async_pdu_ctx(struct beiscsi_hba *phba)
 	mem_descr += HWI_MEM_ASYNC_HEADER_RING;
 	if (mem_descr->mem_array[0].virtual_address) {
 		SE_DEBUG(DBG_LVL_8,
-			 "hwi_init_async_pdu_ctx HWI_MEM_ASYNC_HEADER_RING"
+			 "hwi_init_async_pdu_ctx HWI_MEM_ASYNC_HEADER_RING "
 			 "va=%p\n", mem_descr->mem_array[0].virtual_address);
 	} else
 		shost_printk(KERN_WARNING, phba->shost,
@@ -2467,7 +2467,7 @@ static void hwi_init_async_pdu_ctx(struct beiscsi_hba *phba)
 	mem_descr += HWI_MEM_ASYNC_HEADER_HANDLE;
 	if (mem_descr->mem_array[0].virtual_address) {
 		SE_DEBUG(DBG_LVL_8,
-			 "hwi_init_async_pdu_ctx HWI_MEM_ASYNC_HEADER_HANDLE"
+			 "hwi_init_async_pdu_ctx HWI_MEM_ASYNC_HEADER_HANDLE "
 			 "va=%p\n", mem_descr->mem_array[0].virtual_address);
 	} else
 		shost_printk(KERN_WARNING, phba->shost,
@@ -2483,7 +2483,7 @@ static void hwi_init_async_pdu_ctx(struct beiscsi_hba *phba)
 	mem_descr += HWI_MEM_ASYNC_DATA_RING;
 	if (mem_descr->mem_array[0].virtual_address) {
 		SE_DEBUG(DBG_LVL_8,
-			 "hwi_init_async_pdu_ctx HWI_MEM_ASYNC_DATA_RING"
+			 "hwi_init_async_pdu_ctx HWI_MEM_ASYNC_DATA_RING "
 			 "va=%p\n", mem_descr->mem_array[0].virtual_address);
 	} else
 		shost_printk(KERN_WARNING, phba->shost,
@@ -2512,7 +2512,7 @@ static void hwi_init_async_pdu_ctx(struct beiscsi_hba *phba)
 	mem_descr += HWI_MEM_ASYNC_DATA_BUF;
 	if (mem_descr->mem_array[0].virtual_address) {
 		SE_DEBUG(DBG_LVL_8,
-			 "hwi_init_async_pdu_ctx HWI_MEM_ASYNC_DATA_BUF"
+			 "hwi_init_async_pdu_ctx HWI_MEM_ASYNC_DATA_BUF "
 			 "va=%p\n", mem_descr->mem_array[0].virtual_address);
 	} else
 		shost_printk(KERN_WARNING, phba->shost,
@@ -2694,8 +2694,8 @@ static int beiscsi_create_eqs(struct beiscsi_hba *phba,
 					    phwi_context->cur_eqd);
 		if (ret) {
 			shost_printk(KERN_ERR, phba->shost,
-				     "beiscsi_cmd_eq_create"
-				     "Failedfor EQ\n");
+				     "beiscsi_cmd_eq_create "
+				     "Failed for EQ\n");
 			goto create_eq_error;
 		}
 		SE_DEBUG(DBG_LVL_8, "eqid = %d\n", phwi_context->be_eq[i].q.id);
@@ -2752,7 +2752,7 @@ static int beiscsi_create_cqs(struct beiscsi_hba *phba,
 					    false, 0);
 		if (ret) {
 			shost_printk(KERN_ERR, phba->shost,
-				     "beiscsi_cmd_eq_create"
+				     "beiscsi_cmd_eq_create "
 				     "Failed for ISCSI CQ\n");
 			goto create_cq_error;
 		}
@@ -3221,7 +3221,7 @@ static int hwi_init_controller(struct beiscsi_hba *phba)
 			 phwi_ctrlr->phwi_ctxt);
 	} else {
 		shost_printk(KERN_ERR, phba->shost,
-			     "HWI_MEM_ADDN_CONTEXT is more than one element."
+			     "HWI_MEM_ADDN_CONTEXT is more than one element. "
 			     "Failing to load\n");
 		return -ENOMEM;
 	}
@@ -3268,7 +3268,7 @@ static int beiscsi_init_controller(struct beiscsi_hba *phba)
 
 	ret = beiscsi_get_memory(phba);
 	if (ret < 0) {
-		shost_printk(KERN_ERR, phba->shost, "beiscsi_dev_probe -"
+		shost_printk(KERN_ERR, phba->shost, "beiscsi_dev_probe - "
 			     "Failed in beiscsi_alloc_memory\n");
 		return ret;
 	}
@@ -3317,7 +3317,7 @@ static int beiscsi_init_sgl_handle(struct beiscsi_hba *phba)
 		}
 	} else {
 		shost_printk(KERN_ERR, phba->shost,
-			     "HWI_MEM_SGLH is more than one element."
+			     "HWI_MEM_SGLH is more than one element. "
 			     "Failing to load\n");
 		return -ENOMEM;
 	}
@@ -3345,7 +3345,7 @@ static int beiscsi_init_sgl_handle(struct beiscsi_hba *phba)
 		idx++;
 	}
 	SE_DEBUG(DBG_LVL_8,
-		 "phba->io_sgl_hndl_avbl=%d"
+		 "phba->io_sgl_hndl_avbl=%d "
 		 "phba->eh_sgl_hndl_avbl=%d\n",
 		 phba->io_sgl_hndl_avbl,
 		 phba->eh_sgl_hndl_avbl);
@@ -3509,7 +3509,7 @@ static int beiscsi_get_boot_info(struct beiscsi_hba *phba)
 				&nonemb_cmd.dma);
 	if (nonemb_cmd.va == NULL) {
 		SE_DEBUG(DBG_LVL_1,
-			 "Failed to allocate memory for"
+			 "Failed to allocate memory for "
 			 "beiscsi_get_session_info\n");
 		return -ENOMEM;
 	}
@@ -3612,14 +3612,14 @@ static int beiscsi_init_port(struct beiscsi_hba *phba)
 	ret = beiscsi_init_controller(phba);
 	if (ret < 0) {
 		shost_printk(KERN_ERR, phba->shost,
-			     "beiscsi_dev_probe - Failed in"
+			     "beiscsi_dev_probe - Failed in "
 			     "beiscsi_init_controller\n");
 		return ret;
 	}
 	ret = beiscsi_init_sgl_handle(phba);
 	if (ret < 0) {
 		shost_printk(KERN_ERR, phba->shost,
-			     "beiscsi_dev_probe - Failed in"
+			     "beiscsi_dev_probe - Failed in "
 			     "beiscsi_init_sgl_handle\n");
 		goto do_cleanup_ctrlr;
 	}
@@ -4356,7 +4356,7 @@ static int __devinit beiscsi_dev_probe(struct pci_dev *pcidev,
 	}
 	ret = be_ctrl_init(phba, pcidev);
 	if (ret) {
-		shost_printk(KERN_ERR, phba->shost, "beiscsi_dev_probe-"
+		shost_printk(KERN_ERR, phba->shost, "beiscsi_dev_probe - "
 				"Failed in be_ctrl_init\n");
 		goto hba_free;
 	}
@@ -4377,7 +4377,7 @@ static int __devinit beiscsi_dev_probe(struct pci_dev *pcidev,
 			ret = be_chk_reset_complete(phba);
 			if (ret) {
 				shost_printk(KERN_ERR, phba->shost,
-					"Failed to get out of reset."
+					"Failed to get out of reset. "
 					"Aborting Crashdump\n");
 				goto hba_free;
 			}
@@ -4402,7 +4402,7 @@ static int __devinit beiscsi_dev_probe(struct pci_dev *pcidev,
 	phba->shost->can_queue = phba->params.ios_per_ctrl;
 	ret = beiscsi_init_port(phba);
 	if (ret < 0) {
-		shost_printk(KERN_ERR, phba->shost, "beiscsi_dev_probe-"
+		shost_printk(KERN_ERR, phba->shost, "beiscsi_dev_probe - "
 			     "Failed in beiscsi_init_port\n");
 		goto free_port;
 	}
@@ -4420,7 +4420,7 @@ static int __devinit beiscsi_dev_probe(struct pci_dev *pcidev,
 		 phba->shost->host_no);
 	phba->wq = alloc_workqueue(phba->wq_name, WQ_MEM_RECLAIM, 1);
 	if (!phba->wq) {
-		shost_printk(KERN_ERR, phba->shost, "beiscsi_dev_probe-"
+		shost_printk(KERN_ERR, phba->shost, "beiscsi_dev_probe - "
 				"Failed to allocate work queue\n");
 		goto free_twq;
 	}
@@ -4439,7 +4439,7 @@ static int __devinit beiscsi_dev_probe(struct pci_dev *pcidev,
 	}
 	ret = beiscsi_init_irqs(phba);
 	if (ret < 0) {
-		shost_printk(KERN_ERR, phba->shost, "beiscsi_dev_probe-"
+		shost_printk(KERN_ERR, phba->shost, "beiscsi_dev_probe - "
 			     "Failed to beiscsi_init_irqs\n");
 		goto free_blkenbld;
 	}
@@ -4543,7 +4543,7 @@ static int __init beiscsi_module_init(void)
 			iscsi_register_transport(&beiscsi_iscsi_transport);
 	if (!beiscsi_scsi_transport) {
 		SE_DEBUG(DBG_LVL_1,
-			 "beiscsi_module_init - Unable to  register beiscsi"
+			 "beiscsi_module_init - Unable to  register beiscsi "
 			 "transport.\n");
 		return -ENOMEM;
 	}
@@ -4553,7 +4553,7 @@ static int __init beiscsi_module_init(void)
 	ret = pci_register_driver(&beiscsi_pci_driver);
 	if (ret) {
 		SE_DEBUG(DBG_LVL_1,
-			 "beiscsi_module_init - Unable to  register"
+			 "beiscsi_module_init - Unable to register "
 			 "beiscsi pci driver.\n");
 		goto unregister_iscsi_transport;
 	}
diff --git a/drivers/scsi/be2iscsi/be_mgmt.c b/drivers/scsi/be2iscsi/be_mgmt.c
index 2a09679..0ffce2d 100644
--- a/drivers/scsi/be2iscsi/be_mgmt.c
+++ b/drivers/scsi/be2iscsi/be_mgmt.c
@@ -551,7 +551,7 @@ static int mgmt_exec_nonemb_cmd(struct beiscsi_hba *phba,
 	status = phba->ctrl.mcc_numtag[tag] & 0x000000FF;
 	if (status || extd_status) {
 		SE_DEBUG(DBG_LVL_1,
-			 "mgmt_exec_nonemb_cmd Failed status = %d"
+			 "mgmt_exec_nonemb_cmd Failed status = %d "
 			 "extd_status = %d\n", status, extd_status);
 		rc = -EIO;
 		goto free_tag;
-- 
1.7.11.2
