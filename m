From: Joe Perches <joe@perches.com>
Subject: Re: [PATCH] [SCSI] bnx2i: add a prefix to a printk
Date: Thu, 21 Nov 2013 01:07:05 -0800
Message-ID: <1385024825.2164.47.camel@joe-AO722>
References: <1340825211.1911.42.camel@x61.thuisdomein>
	 <1385022862.11741.9.camel@x220.thuisdomein>
Mime-Version: 1.0
Content-Type: text/plain; charset="ISO-8859-1"
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from smtprelay0051.hostedemail.com ([216.40.44.51]:42701 "EHLO
	smtprelay.hostedemail.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1753337Ab3KUJHK (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Thu, 21 Nov 2013 04:07:10 -0500
In-Reply-To: <1385022862.11741.9.camel@x220.thuisdomein>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Paul Bolle <pebolle@tiscali.nl>
Cc: Eddie Wai <eddie.wai@broadcom.com>, "James E.J. Bottomley" <JBottomley@parallels.com>, linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org

On Thu, 2013-11-21 at 09:34 +0100, Paul Bolle wrote:
> (Eddie was added as maintainer a few months ago, so Eddie receives this
> message too.)
> 
> On Wed, 2012-06-27 at 21:26 +0200, Paul Bolle wrote:
> > During each suspend and resume cycle a mysterious message is added to
> > the logs:
> >     CPU 1 offline: Remove Rx thread
> > 
> > Some grepping of the tree revealed this message is printed by bnx2i.
> > Add a prefix to this message to make it clear that it is printed by
> > bnx2i. That should also make it obvious it is the mirror of the
> >     bnx2i: CPU 1 online: Create Rx thread

I would have done it by converting all the printks to use pr_<level>
and adding pr_fmt.  This standardizes all log output from bnx2i to be
prefixed with "bnx2i: " instead of a mix of unprefixed, "bnx2i: " and
"bnx2i - "

Coalesce all format fragments.
Fix typo in format.
Use %s: and __func__ instead of embedding formats
Add missing "\n" at end of format
Fix enable/enabled grammar

---
 drivers/scsi/bnx2i/bnx2i.h       |   6 ++
 drivers/scsi/bnx2i/bnx2i_hwi.c   | 129 ++++++++++++++++++---------------------
 drivers/scsi/bnx2i/bnx2i_init.c  |  42 ++++++-------
 drivers/scsi/bnx2i/bnx2i_iscsi.c |  67 ++++++++++----------
 drivers/scsi/bnx2i/bnx2i_sysfs.c |   4 +-
 5 files changed, 116 insertions(+), 132 deletions(-)

diff --git a/drivers/scsi/bnx2i/bnx2i.h b/drivers/scsi/bnx2i/bnx2i.h
index c73bbcb..1845352 100644
--- a/drivers/scsi/bnx2i/bnx2i.h
+++ b/drivers/scsi/bnx2i/bnx2i.h
@@ -15,6 +15,12 @@
 #ifndef _BNX2I_H_
 #define _BNX2I_H_
 
+#ifdef pr_fmt
+#undef pr_fmt
+#endif
+
+#define pr_fmt(fmt) KBUILD_MODNAME ": " fmt
+
 #include <linux/module.h>
 #include <linux/moduleparam.h>
 
diff --git a/drivers/scsi/bnx2i/bnx2i_hwi.c b/drivers/scsi/bnx2i/bnx2i_hwi.c
index e4cf23d..c4f4252 100644
--- a/drivers/scsi/bnx2i/bnx2i_hwi.c
+++ b/drivers/scsi/bnx2i/bnx2i_hwi.c
@@ -113,13 +113,11 @@ static void bnx2i_iscsi_license_error(struct bnx2i_hba *hba, u32 error_code)
 {
 	if (error_code == ISCSI_KCQE_COMPLETION_STATUS_ISCSI_NOT_SUPPORTED)
 		/* iSCSI offload not supported on this device */
-		printk(KERN_ERR "bnx2i: iSCSI not supported, dev=%s\n",
-				hba->netdev->name);
+		pr_err("iSCSI not supported, dev=%s\n", hba->netdev->name);
 	if (error_code == ISCSI_KCQE_COMPLETION_STATUS_LOM_ISCSI_NOT_ENABLED)
 		/* iSCSI offload not supported on this LOM device */
-		printk(KERN_ERR "bnx2i: LOM is not enable to "
-				"offload iSCSI connections, dev=%s\n",
-				hba->netdev->name);
+		pr_err("LOM is not enabled to offload iSCSI connections, dev=%s\n",
+		       hba->netdev->name);
 	set_bit(ADAPTER_STATE_INIT_FAILED, &hba->adapter_state);
 }
 
@@ -574,7 +572,7 @@ int bnx2i_send_iscsi_nopout(struct bnx2i_conn *bnx2i_conn,
 	nopout_wqe->data_length = data_len;
 	if (data_len) {
 		/* handle payload data, not required in first release */
-		printk(KERN_ALERT "NOPOUT: WARNING!! payload len != 0\n");
+		pr_alert("NOPOUT: WARNING!! payload len != 0\n");
 	} else {
 		nopout_wqe->bd_list_addr_lo = (u32)
 					bnx2i_conn->hba->mp_bd_dma;
@@ -701,13 +699,13 @@ void bnx2i_ep_ofld_timer(unsigned long data)
 	struct bnx2i_endpoint *ep = (struct bnx2i_endpoint *) data;
 
 	if (ep->state == EP_STATE_OFLD_START) {
-		printk(KERN_ALERT "ofld_timer: CONN_OFLD timeout\n");
+		pr_alert("ofld_timer: CONN_OFLD timeout\n");
 		ep->state = EP_STATE_OFLD_FAILED;
 	} else if (ep->state == EP_STATE_DISCONN_START) {
-		printk(KERN_ALERT "ofld_timer: CONN_DISCON timeout\n");
+		pr_alert("ofld_timer: CONN_DISCON timeout\n");
 		ep->state = EP_STATE_DISCONN_TIMEDOUT;
 	} else if (ep->state == EP_STATE_CLEANUP_START) {
-		printk(KERN_ALERT "ofld_timer: CONN_CLEANUP timeout\n");
+		pr_alert("ofld_timer: CONN_CLEANUP timeout\n");
 		ep->state = EP_STATE_CLEANUP_FAILED;
 	}
 
@@ -1074,8 +1072,8 @@ int bnx2i_alloc_qp_resc(struct bnx2i_hba *hba, struct bnx2i_endpoint *ep)
 		dma_alloc_coherent(&hba->pcidev->dev, ep->qp.sq_pgtbl_size,
 				   &ep->qp.sq_pgtbl_phys, GFP_KERNEL);
 	if (!ep->qp.sq_pgtbl_virt) {
-		printk(KERN_ALERT "bnx2i: unable to alloc SQ PT mem (%d)\n",
-				  ep->qp.sq_pgtbl_size);
+		pr_alert("unable to alloc SQ PT mem (%d)\n",
+			 ep->qp.sq_pgtbl_size);
 		goto mem_alloc_err;
 	}
 
@@ -1084,8 +1082,8 @@ int bnx2i_alloc_qp_resc(struct bnx2i_hba *hba, struct bnx2i_endpoint *ep)
 		dma_alloc_coherent(&hba->pcidev->dev, ep->qp.sq_mem_size,
 				   &ep->qp.sq_phys, GFP_KERNEL);
 	if (!ep->qp.sq_virt) {
-		printk(KERN_ALERT "bnx2i: unable to alloc SQ BD memory %d\n",
-				  ep->qp.sq_mem_size);
+		pr_alert("unable to alloc SQ BD memory %d\n",
+			 ep->qp.sq_mem_size);
 		goto mem_alloc_err;
 	}
 
@@ -1111,8 +1109,8 @@ int bnx2i_alloc_qp_resc(struct bnx2i_hba *hba, struct bnx2i_endpoint *ep)
 		dma_alloc_coherent(&hba->pcidev->dev, ep->qp.cq_pgtbl_size,
 				   &ep->qp.cq_pgtbl_phys, GFP_KERNEL);
 	if (!ep->qp.cq_pgtbl_virt) {
-		printk(KERN_ALERT "bnx2i: unable to alloc CQ PT memory %d\n",
-				  ep->qp.cq_pgtbl_size);
+		pr_alert("unable to alloc CQ PT memory %d\n",
+			 ep->qp.cq_pgtbl_size);
 		goto mem_alloc_err;
 	}
 
@@ -1121,8 +1119,8 @@ int bnx2i_alloc_qp_resc(struct bnx2i_hba *hba, struct bnx2i_endpoint *ep)
 		dma_alloc_coherent(&hba->pcidev->dev, ep->qp.cq_mem_size,
 				   &ep->qp.cq_phys, GFP_KERNEL);
 	if (!ep->qp.cq_virt) {
-		printk(KERN_ALERT "bnx2i: unable to alloc CQ BD memory %d\n",
-				  ep->qp.cq_mem_size);
+		pr_alert("unable to alloc CQ BD memory %d\n",
+			 ep->qp.cq_mem_size);
 		goto mem_alloc_err;
 	}
 	memset(ep->qp.cq_virt, 0x00, ep->qp.cq_mem_size);
@@ -1154,8 +1152,8 @@ int bnx2i_alloc_qp_resc(struct bnx2i_hba *hba, struct bnx2i_endpoint *ep)
 		dma_alloc_coherent(&hba->pcidev->dev, ep->qp.rq_pgtbl_size,
 				   &ep->qp.rq_pgtbl_phys, GFP_KERNEL);
 	if (!ep->qp.rq_pgtbl_virt) {
-		printk(KERN_ALERT "bnx2i: unable to alloc RQ PT mem %d\n",
-				  ep->qp.rq_pgtbl_size);
+		pr_alert("unable to alloc RQ PT mem %d\n",
+			 ep->qp.rq_pgtbl_size);
 		goto mem_alloc_err;
 	}
 
@@ -1164,8 +1162,8 @@ int bnx2i_alloc_qp_resc(struct bnx2i_hba *hba, struct bnx2i_endpoint *ep)
 		dma_alloc_coherent(&hba->pcidev->dev, ep->qp.rq_mem_size,
 				   &ep->qp.rq_phys, GFP_KERNEL);
 	if (!ep->qp.rq_virt) {
-		printk(KERN_ALERT "bnx2i: unable to alloc RQ BD memory %d\n",
-				  ep->qp.rq_mem_size);
+		pr_alert("unable to alloc RQ BD memory %d\n",
+			 ep->qp.rq_mem_size);
 		goto mem_alloc_err;
 	}
 
@@ -1852,8 +1850,8 @@ static void bnx2i_process_cmd_cleanup_resp(struct iscsi_session *session,
 	task = iscsi_itt_to_task(conn,
 			cmd_clean_rsp->itt & ISCSI_CLEANUP_RESPONSE_INDEX);
 	if (!task)
-		printk(KERN_ALERT "bnx2i: cmd clean ITT %x not active\n",
-			cmd_clean_rsp->itt & ISCSI_CLEANUP_RESPONSE_INDEX);
+		pr_alert("cmd clean ITT %x not active\n",
+			 cmd_clean_rsp->itt & ISCSI_CLEANUP_RESPONSE_INDEX);
 	spin_unlock(&session->lock);
 	complete(&bnx2i_conn->cmd_cleanup_cmpl);
 }
@@ -1987,8 +1985,8 @@ static int bnx2i_process_new_cqes(struct bnx2i_conn *bnx2i_conn)
 	qp = &bnx2i_conn->ep->qp;
 
 	if (!qp->cq_virt) {
-		printk(KERN_ALERT "bnx2i (%s): cq resr freed in bh execution!",
-		       hba->netdev->name);
+		pr_alert("(%s): cq resr freed in bh execution!\n",
+			 hba->netdev->name);
 		goto out;
 	}
 	while (1) {
@@ -1999,10 +1997,8 @@ static int bnx2i_process_new_cqes(struct bnx2i_conn *bnx2i_conn)
 		if (unlikely(test_bit(ISCSI_SUSPEND_BIT, &conn->suspend_rx))) {
 			if (nopin->op_code == ISCSI_OP_NOOP_IN &&
 			    nopin->itt == (u16) RESERVED_ITT) {
-				printk(KERN_ALERT "bnx2i: Unsolicited "
-				       "NOP-In detected for suspended "
-				       "connection dev=%s!\n",
-				       hba->netdev->name);
+				pr_alert("Unsolicited NOP-In detected for suspended connection dev=%s!\n",
+					 hba->netdev->name);
 				bnx2i_unsol_pdu_adjust_rq(bnx2i_conn);
 				goto cqe_out;
 			}
@@ -2056,8 +2052,7 @@ static int bnx2i_process_new_cqes(struct bnx2i_conn *bnx2i_conn)
 						       qp->cq_cons_qe);
 			break;
 		default:
-			printk(KERN_ALERT "bnx2i: unknown opcode 0x%x\n",
-					  nopin->op_code);
+			pr_alert("unknown opcode 0x%x\n", nopin->op_code);
 		}
 
 		ADD_STATS_64(hba, rx_pdus, 1);
@@ -2065,10 +2060,9 @@ static int bnx2i_process_new_cqes(struct bnx2i_conn *bnx2i_conn)
 done:
 		if (!tgt_async_msg) {
 			if (!atomic_read(&bnx2i_conn->ep->num_active_cmds))
-				printk(KERN_ALERT "bnx2i (%s): no active cmd! "
-				       "op 0x%x\n",
-				       hba->netdev->name,
-				       nopin->op_code);
+				pr_alert("(%s): no active cmd! op 0x%x\n",
+					 hba->netdev->name,
+					 nopin->op_code);
 			else
 				atomic_dec(&bnx2i_conn->ep->num_active_cmds);
 		}
@@ -2113,11 +2107,11 @@ static void bnx2i_fastpath_notification(struct bnx2i_hba *hba,
 	bnx2i_conn = bnx2i_get_conn_from_id(hba, iscsi_cid);
 
 	if (!bnx2i_conn) {
-		printk(KERN_ALERT "cid #%x not valid\n", iscsi_cid);
+		pr_alert("cid #%x not valid\n", iscsi_cid);
 		return;
 	}
 	if (!bnx2i_conn->ep) {
-		printk(KERN_ALERT "cid #%x - ep not bound\n", iscsi_cid);
+		pr_alert("cid #%x - ep not bound\n", iscsi_cid);
 		return;
 	}
 
@@ -2146,16 +2140,16 @@ static void bnx2i_process_update_conn_cmpl(struct bnx2i_hba *hba,
 	conn = bnx2i_get_conn_from_id(hba, iscsi_cid);
 
 	if (!conn) {
-		printk(KERN_ALERT "conn_update: cid %x not valid\n", iscsi_cid);
+		pr_alert("conn_update: cid %x not valid\n", iscsi_cid);
 		return;
 	}
 	if (!conn->ep) {
-		printk(KERN_ALERT "cid %x does not have ep bound\n", iscsi_cid);
+		pr_alert("cid %x does not have ep bound\n", iscsi_cid);
 		return;
 	}
 
 	if (update_kcqe->completion_status) {
-		printk(KERN_ALERT "request failed cid %x\n", iscsi_cid);
+		pr_alert("request failed cid %x\n", iscsi_cid);
 		conn->ep->state = EP_STATE_ULP_UPDATE_FAILED;
 	} else
 		conn->ep->state = EP_STATE_ULP_UPDATE_COMPL;
@@ -2197,12 +2191,12 @@ static void bnx2i_process_tcp_error(struct bnx2i_hba *hba,
 	bnx2i_conn = bnx2i_get_conn_from_id(hba, iscsi_cid);
 
 	if (!bnx2i_conn) {
-		printk(KERN_ALERT "bnx2i - cid 0x%x not valid\n", iscsi_cid);
+		pr_alert("cid 0x%x not valid\n", iscsi_cid);
 		return;
 	}
 
-	printk(KERN_ALERT "bnx2i - cid 0x%x had TCP errors, error code 0x%x\n",
-			  iscsi_cid, tcp_err->completion_status);
+	pr_alert("cid 0x%x had TCP errors, error code 0x%x\n",
+		 iscsi_cid, tcp_err->completion_status);
 	bnx2i_recovery_que_add_conn(bnx2i_conn->hba, bnx2i_conn);
 }
 
@@ -2235,7 +2229,7 @@ static void bnx2i_process_iscsi_error(struct bnx2i_hba *hba,
 	iscsi_cid = iscsi_err->iscsi_conn_id;
 	bnx2i_conn = bnx2i_get_conn_from_id(hba, iscsi_cid);
 	if (!bnx2i_conn) {
-		printk(KERN_ALERT "bnx2i - cid 0x%x not valid\n", iscsi_cid);
+		pr_alert("cid 0x%x not valid\n", iscsi_cid);
 		return;
 	}
 
@@ -2372,8 +2366,8 @@ static void bnx2i_process_iscsi_error(struct bnx2i_hba *hba,
 		strcpy(additional_notice, "urgent flag error");
 		break;
 	default:
-		printk(KERN_ALERT "iscsi_err - unknown err %x\n",
-				  iscsi_err->completion_status);
+		pr_alert("iscsi_err - unknown err %x\n",
+			 iscsi_err->completion_status);
 	}
 
 	if (need_recovery) {
@@ -2414,18 +2408,18 @@ static void bnx2i_process_conn_destroy_cmpl(struct bnx2i_hba *hba,
 
 	ep = bnx2i_find_ep_in_destroy_list(hba, conn_destroy->iscsi_conn_id);
 	if (!ep) {
-		printk(KERN_ALERT "bnx2i_conn_destroy_cmpl: no pending "
-				  "offload request, unexpected complection\n");
+		pr_alert("%s: no pending offload request, unexpected completion\n",
+			 __func__);
 		return;
 	}
 
 	if (hba != ep->hba) {
-		printk(KERN_ALERT "conn destroy- error hba mis-match\n");
+		pr_alert("%s: error hba mis-match\n", __func__);
 		return;
 	}
 
 	if (conn_destroy->completion_status) {
-		printk(KERN_ALERT "conn_destroy_cmpl: op failed\n");
+		pr_alert("%s: op failed\n", __func__);
 		ep->state = EP_STATE_CLEANUP_FAILED;
 	} else
 		ep->state = EP_STATE_CLEANUP_CMPL;
@@ -2450,12 +2444,12 @@ static void bnx2i_process_ofld_cmpl(struct bnx2i_hba *hba,
 
 	ep = bnx2i_find_ep_in_ofld_list(hba, ofld_kcqe->iscsi_conn_id);
 	if (!ep) {
-		printk(KERN_ALERT "ofld_cmpl: no pend offload request\n");
+		pr_alert("%s: no pend offload request\n", __func__);
 		return;
 	}
 
 	if (hba != ep->hba) {
-		printk(KERN_ALERT "ofld_cmpl: error hba mis-match\n");
+		pr_alert("%s: error hba mis-match\n", __func__);
 		return;
 	}
 
@@ -2463,21 +2457,20 @@ static void bnx2i_process_ofld_cmpl(struct bnx2i_hba *hba,
 		ep->state = EP_STATE_OFLD_FAILED;
 		if (ofld_kcqe->completion_status ==
 		    ISCSI_KCQE_COMPLETION_STATUS_CTX_ALLOC_FAILURE)
-			printk(KERN_ALERT "bnx2i (%s): ofld1 cmpl - unable "
-				"to allocate iSCSI context resources\n",
-				hba->netdev->name);
+			pr_alert("(%s): ofld1 cmpl - unable to allocate iSCSI context resources\n",
+				 hba->netdev->name);
 		else if (ofld_kcqe->completion_status ==
 			 ISCSI_KCQE_COMPLETION_STATUS_INVALID_OPCODE)
-			printk(KERN_ALERT "bnx2i (%s): ofld1 cmpl - invalid "
-				"opcode\n", hba->netdev->name);
+			pr_alert("(%s): ofld1 cmpl - invalid opcode\n",
+				 hba->netdev->name);
 		else if (ofld_kcqe->completion_status ==
 			 ISCSI_KCQE_COMPLETION_STATUS_CID_BUSY)
 			/* error status code valid only for 5771x chipset */
 			ep->state = EP_STATE_OFLD_FAILED_CID_BUSY;
 		else
-			printk(KERN_ALERT "bnx2i (%s): ofld1 cmpl - invalid "
-				"error code %d\n", hba->netdev->name,
-				ofld_kcqe->completion_status);
+			pr_alert("(%s): ofld1 cmpl - invalid error code %d\n",
+				 hba->netdev->name,
+				 ofld_kcqe->completion_status);
 	} else {
 		ep->state = EP_STATE_OFLD_COMPL;
 		cid_addr = ofld_kcqe->iscsi_conn_context_id;
@@ -2520,13 +2513,10 @@ static void bnx2i_indicate_kcqe(void *context, struct kcqe *kcqe[],
 			else {
 				set_bit(ADAPTER_STATE_UP, &hba->adapter_state);
 				bnx2i_get_link_state(hba);
-				printk(KERN_INFO "bnx2i [%.2x:%.2x.%.2x]: "
-						 "ISCSI_INIT passed\n",
-						 (u8)hba->pcidev->bus->number,
-						 hba->pci_devno,
-						 (u8)hba->pci_func);
-
-
+				pr_info("[%.2x:%.2x.%.2x]: ISCSI_INIT passed\n",
+					(u8)hba->pcidev->bus->number,
+					hba->pci_devno,
+					(u8)hba->pci_func);
 			}
 		} else if (ikcqe->op_code == ISCSI_KCQE_OPCODE_DESTROY_CONN)
 			bnx2i_process_conn_destroy_cmpl(hba, ikcqe);
@@ -2535,8 +2525,7 @@ static void bnx2i_indicate_kcqe(void *context, struct kcqe *kcqe[],
 		else if (ikcqe->op_code == ISCSI_KCQE_OPCODE_TCP_ERROR)
 			bnx2i_process_tcp_error(hba, ikcqe);
 		else
-			printk(KERN_ALERT "bnx2i: unknown opcode 0x%x\n",
-					  ikcqe->op_code);
+			pr_alert("unknown opcode 0x%x\n", ikcqe->op_code);
 	}
 }
 
@@ -2687,7 +2676,7 @@ static int bnx2i_send_nl_mesg(void *context, u32 msg_type,
 	rc = iscsi_offload_mesg(hba->shost, &bnx2i_iscsi_transport,
 				msg_type, buf, buflen);
 	if (rc)
-		printk(KERN_ALERT "bnx2i: private nl message send error\n");
+		pr_alert("private nl message send error\n");
 
 	return rc;
 }
diff --git a/drivers/scsi/bnx2i/bnx2i_init.c b/drivers/scsi/bnx2i/bnx2i_init.c
index 34c294b..615f26e 100644
--- a/drivers/scsi/bnx2i/bnx2i_init.c
+++ b/drivers/scsi/bnx2i/bnx2i_init.c
@@ -22,8 +22,8 @@ static u32 adapter_count;
 #define DRV_MODULE_RELDATE	"Jun 06, 2013"
 
 static char version[] =
-		"Broadcom NetXtreme II iSCSI Driver " DRV_MODULE_NAME \
-		" v" DRV_MODULE_VERSION " (" DRV_MODULE_RELDATE ")\n";
+		"Broadcom NetXtreme II iSCSI Driver " DRV_MODULE_NAME 
+		" v" DRV_MODULE_VERSION " (" DRV_MODULE_RELDATE ")";
 
 
 MODULE_AUTHOR("Anil Veerabhadrappa <anilgv@broadcom.com> and "
@@ -103,8 +103,7 @@ void bnx2i_identify_device(struct bnx2i_hba *hba, struct cnic_dev *dev)
 	} else if (test_bit(CNIC_F_BNX2X_CLASS, &dev->flags)) {
 		set_bit(BNX2I_NX2_DEV_57710, &hba->cnic_dev_type);
 	} else {
-		printk(KERN_ALERT "bnx2i: unknown device, 0x%x\n",
-				  hba->pci_did);
+		pr_alert("unknown device, 0x%x\n", hba->pci_did);
 	}
 }
 
@@ -201,9 +200,8 @@ static void bnx2i_chip_cleanup(struct bnx2i_hba *hba)
 		 * This is the case where the daemon is either slow or
 		 * not present
 		 */
-		printk(KERN_ALERT "bnx2i: (%s) chip cleanup for %d active "
-			"connections\n", hba->netdev->name,
-			hba->ofld_conns_active);
+		pr_alert("(%s) chip cleanup for %d active connections\n",
+			 hba->netdev->name, hba->ofld_conns_active);
 		mutex_lock(&hba->net_dev_lock);
 		list_for_each_safe(pos, tmp, &hba->ep_active_list) {
 			bnx2i_ep = list_entry(pos, struct bnx2i_endpoint, link);
@@ -282,8 +280,7 @@ static int bnx2i_init_one(struct bnx2i_hba *hba, struct cnic_dev *cnic)
 
 	mutex_lock(&bnx2i_dev_lock);
 	if (!cnic->max_iscsi_conn) {
-		printk(KERN_ALERT "bnx2i: dev %s does not support "
-			"iSCSI\n", hba->netdev->name);
+		pr_alert("dev %s does not support iSCSI\n", hba->netdev->name);
 		rc = -EOPNOTSUPP;
 		goto out;
 	}
@@ -296,14 +293,13 @@ static int bnx2i_init_one(struct bnx2i_hba *hba, struct cnic_dev *cnic)
 		list_add_tail(&hba->link, &adapter_list);
 		adapter_count++;
 	} else if (rc == -EBUSY) 	/* duplicate registration */
-		printk(KERN_ALERT "bnx2i, duplicate registration"
-				  "hba=%p, cnic=%p\n", hba, cnic);
+		pr_alert("duplicate registration hba=%p, cnic=%p\n", hba, cnic);
 	else if (rc == -EAGAIN)
-		printk(KERN_ERR "bnx2i, driver not registered\n");
+		pr_err("driver not registered\n");
 	else if (rc == -EINVAL)
-		printk(KERN_ERR "bnx2i, invalid type %d\n", CNIC_ULP_ISCSI);
+		pr_err("invalid type %d\n", CNIC_ULP_ISCSI);
 	else
-		printk(KERN_ERR "bnx2i dev reg, unknown error, %d\n", rc);
+		pr_err("dev reg, unknown error, %d\n", rc);
 
 out:
 	mutex_unlock(&bnx2i_dev_lock);
@@ -327,14 +323,14 @@ void bnx2i_ulp_init(struct cnic_dev *dev)
 	/* Allocate a HBA structure for this device */
 	hba = bnx2i_alloc_hba(dev);
 	if (!hba) {
-		printk(KERN_ERR "bnx2i init: hba initialization failed\n");
+		pr_err("%s: hba initialization failed\n", __func__);
 		return;
 	}
 
 	/* Get PCI related information and update hba struct members */
 	clear_bit(BNX2I_CNIC_REGISTERED, &hba->reg_with_cnic);
 	if (bnx2i_init_one(hba, dev)) {
-		printk(KERN_ERR "bnx2i - hba %p init failed\n", hba);
+		pr_err("hba %p init failed\n", hba);
 		bnx2i_free_hba(hba);
 	}
 }
@@ -351,8 +347,7 @@ void bnx2i_ulp_exit(struct cnic_dev *dev)
 
 	hba = bnx2i_find_hba_for_cnic(dev);
 	if (!hba) {
-		printk(KERN_INFO "bnx2i_ulp_exit: hba not "
-				 "found, dev 0x%p\n", dev);
+		pr_info("%s: hba not found, dev 0x%p\n", __func__, dev);
 		return;
 	}
 	mutex_lock(&bnx2i_dev_lock);
@@ -479,13 +474,12 @@ static int bnx2i_cpu_callback(struct notifier_block *nfb,
 	switch (action) {
 	case CPU_ONLINE:
 	case CPU_ONLINE_FROZEN:
-		printk(KERN_INFO "bnx2i: CPU %x online: Create Rx thread\n",
-			cpu);
+		pr_info("CPU %x online: Create Rx thread\n", cpu);
 		bnx2i_percpu_thread_create(cpu);
 		break;
 	case CPU_DEAD:
 	case CPU_DEAD_FROZEN:
-		printk(KERN_INFO "CPU %x offline: Remove Rx thread\n", cpu);
+		pr_info("CPU %x offline: Remove Rx thread\n", cpu);
 		bnx2i_percpu_thread_destroy(cpu);
 		break;
 	default:
@@ -508,7 +502,7 @@ static int __init bnx2i_mod_init(void)
 	unsigned cpu = 0;
 	struct bnx2i_percpu_s *p;
 
-	printk(KERN_INFO "%s", version);
+	pr_info("%s\n", version);
 
 	if (sq_size && !is_power_of_2(sq_size))
 		sq_size = roundup_pow_of_two(sq_size);
@@ -518,14 +512,14 @@ static int __init bnx2i_mod_init(void)
 	bnx2i_scsi_xport_template =
 			iscsi_register_transport(&bnx2i_iscsi_transport);
 	if (!bnx2i_scsi_xport_template) {
-		printk(KERN_ERR "Could not register bnx2i transport.\n");
+		pr_err("Could not register bnx2i transport\n");
 		err = -ENOMEM;
 		goto out;
 	}
 
 	err = cnic_register_driver(CNIC_ULP_ISCSI, &bnx2i_cnic_cb);
 	if (err) {
-		printk(KERN_ERR "Could not register bnx2i cnic driver.\n");
+		pr_err("Could not register bnx2i cnic driver\n");
 		goto unreg_xport;
 	}
 
diff --git a/drivers/scsi/bnx2i/bnx2i_iscsi.c b/drivers/scsi/bnx2i/bnx2i_iscsi.c
index 854dad7..ae39726 100644
--- a/drivers/scsi/bnx2i/bnx2i_iscsi.c
+++ b/drivers/scsi/bnx2i/bnx2i_iscsi.c
@@ -257,11 +257,11 @@ struct bnx2i_conn *bnx2i_get_conn_from_id(struct bnx2i_hba *hba,
 					  u16 iscsi_cid)
 {
 	if (!hba->cid_que.conn_cid_tbl) {
-		printk(KERN_ERR "bnx2i: ERROR - missing conn<->cid table\n");
+		pr_err("ERROR - missing conn<->cid table\n");
 		return NULL;
 
 	} else if (iscsi_cid >= hba->max_active_conns) {
-		printk(KERN_ERR "bnx2i: wrong cid #%d\n", iscsi_cid);
+		pr_err("wrong cid #%d\n", iscsi_cid);
 		return NULL;
 	}
 	return hba->cid_que.conn_cid_tbl[iscsi_cid];
@@ -384,7 +384,7 @@ static struct iscsi_endpoint *bnx2i_alloc_ep(struct bnx2i_hba *hba)
 
 	ep = iscsi_create_endpoint(sizeof(*bnx2i_ep));
 	if (!ep) {
-		printk(KERN_ERR "bnx2i: Could not allocate ep\n");
+		pr_err("Could not allocate ep\n");
 		return NULL;
 	}
 
@@ -528,7 +528,7 @@ static int bnx2i_setup_mp_bdt(struct bnx2i_hba *hba)
 	hba->mp_bd_tbl = dma_alloc_coherent(&hba->pcidev->dev, PAGE_SIZE,
 					    &hba->mp_bd_dma, GFP_KERNEL);
 	if (!hba->mp_bd_tbl) {
-		printk(KERN_ERR "unable to allocate Middle Path BDT\n");
+		pr_err("unable to allocate Middle Path BDT\n");
 		rc = -1;
 		goto out;
 	}
@@ -536,7 +536,7 @@ static int bnx2i_setup_mp_bdt(struct bnx2i_hba *hba)
 	hba->dummy_buffer = dma_alloc_coherent(&hba->pcidev->dev, PAGE_SIZE,
 					       &hba->dummy_buf_dma, GFP_KERNEL);
 	if (!hba->dummy_buffer) {
-		printk(KERN_ERR "unable to alloc Middle Path Dummy Buffer\n");
+		pr_err("unable to alloc Middle Path Dummy Buffer\n");
 		dma_free_coherent(&hba->pcidev->dev, PAGE_SIZE,
 				  hba->mp_bd_tbl, hba->mp_bd_dma);
 		hba->mp_bd_tbl = NULL;
@@ -685,7 +685,7 @@ bnx2i_find_ep_in_ofld_list(struct bnx2i_hba *hba, u32 iscsi_cid)
 	read_unlock_bh(&hba->ep_rdwr_lock);
 
 	if (!ep)
-		printk(KERN_ERR "l5 cid %d not found\n", iscsi_cid);
+		pr_err("l5 cid %d not found\n", iscsi_cid);
 	return ep;
 }
 
@@ -713,7 +713,7 @@ bnx2i_find_ep_in_destroy_list(struct bnx2i_hba *hba, u32 iscsi_cid)
 	read_unlock_bh(&hba->ep_rdwr_lock);
 
 	if (!ep)
-		printk(KERN_ERR "l5 cid %d not found\n", iscsi_cid);
+		pr_err("l5 cid %d not found\n", iscsi_cid);
 
 	return ep;
 }
@@ -1289,7 +1289,7 @@ bnx2i_session_create(struct iscsi_endpoint *ep,
 	struct bnx2i_endpoint *bnx2i_ep;
 
 	if (!ep) {
-		printk(KERN_ERR "bnx2i: missing ep.\n");
+		pr_err("missing ep\n");
 		return NULL;
 	}
 
@@ -1667,8 +1667,7 @@ static struct bnx2i_hba *bnx2i_check_route(struct sockaddr *dst_addr)
 	if (hba && hba->cnic)
 		cnic = hba->cnic->cm_select_dev(desti, CNIC_ULP_ISCSI);
 	if (!cnic) {
-		printk(KERN_ALERT "bnx2i: no route,"
-		       "can't connect using cnic\n");
+		pr_alert("no route, can't connect using cnic\n");
 		goto no_nx2_route;
 	}
 	hba = bnx2i_find_hba_for_cnic(cnic);
@@ -1676,14 +1675,14 @@ static struct bnx2i_hba *bnx2i_check_route(struct sockaddr *dst_addr)
 		goto no_nx2_route;
 
 	if (bnx2i_adapter_ready(hba)) {
-		printk(KERN_ALERT "bnx2i: check route, hba not found\n");
+		pr_alert("check route, hba not found\n");
 		goto no_nx2_route;
 	}
 	if (hba->netdev->mtu > hba->mtu_supported) {
-		printk(KERN_ALERT "bnx2i: %s network i/f mtu is set to %d\n",
-				  hba->netdev->name, hba->netdev->mtu);
-		printk(KERN_ALERT "bnx2i: iSCSI HBA can support mtu of %d\n",
-				  hba->mtu_supported);
+		pr_alert("%s network i/f mtu is set to %d\n",
+			 hba->netdev->name, hba->netdev->mtu);
+		pr_alert("iSCSI HBA can support mtu of %d\n",
+			 hba->mtu_supported);
 		goto no_nx2_route;
 	}
 	return hba;
@@ -1718,10 +1717,8 @@ static int bnx2i_tear_down_conn(struct bnx2i_hba *hba,
 		 * on what transcribed in TCP layer, different targets behave
 		 * differently
 		 */
-		printk(KERN_ALERT "bnx2i (%s): - WARN - CONN_DISCON timed out, "
-				  "please submit GRC Dump, NW/PCIe trace, "
-				  "driver msgs to developers for analysis\n",
-				  hba->netdev->name);
+		pr_alert("(%s): - WARN - CONN_DISCON timed out, please submit GRC Dump, NW/PCIe trace, driver msgs to developers for analysis\n",
+			 hba->netdev->name);
 	}
 
 	ep->state = EP_STATE_CLEANUP_START;
@@ -1748,7 +1745,7 @@ static int bnx2i_tear_down_conn(struct bnx2i_hba *hba,
 
 	if (ep->state != EP_STATE_CLEANUP_CMPL)
 		/* should never happen */
-		printk(KERN_ALERT "bnx2i - conn destroy failed\n");
+		pr_alert("conn destroy failed\n");
 
 	return 0;
 }
@@ -1811,8 +1808,8 @@ static struct iscsi_endpoint *bnx2i_ep_connect(struct Scsi_Host *shost,
 	atomic_set(&bnx2i_ep->num_active_cmds, 0);
 	iscsi_cid = bnx2i_alloc_iscsi_cid(hba);
 	if (iscsi_cid == -1) {
-		printk(KERN_ALERT "bnx2i (%s): alloc_ep - unable to allocate "
-			"iscsi cid\n", hba->netdev->name);
+		pr_alert("(%s): alloc_ep - unable to allocate iscsi cid\n",
+			 hba->netdev->name);
 		rc = -ENOMEM;
 		bnx2i_free_ep(ep);
 		goto check_busy;
@@ -1821,8 +1818,8 @@ static struct iscsi_endpoint *bnx2i_ep_connect(struct Scsi_Host *shost,
 
 	rc = bnx2i_alloc_qp_resc(hba, bnx2i_ep);
 	if (rc != 0) {
-		printk(KERN_ALERT "bnx2i (%s): ep_conn - alloc QP resc error"
-			"\n", hba->netdev->name);
+		pr_alert("(%s): ep_conn - alloc QP resc error\n",
+			 hba->netdev->name);
 		rc = -ENOMEM;
 		goto qp_resc_err;
 	}
@@ -1839,13 +1836,13 @@ static struct iscsi_endpoint *bnx2i_ep_connect(struct Scsi_Host *shost,
 
 	if (bnx2i_send_conn_ofld_req(hba, bnx2i_ep)) {
 		if (bnx2i_ep->state == EP_STATE_OFLD_FAILED_CID_BUSY) {
-			printk(KERN_ALERT "bnx2i (%s): iscsi cid %d is busy\n",
-				hba->netdev->name, bnx2i_ep->ep_iscsi_cid);
+			pr_alert("(%s): iscsi cid %d is busy\n",
+				 hba->netdev->name, bnx2i_ep->ep_iscsi_cid);
 			rc = -EBUSY;
 		} else
 			rc = -ENOSPC;
-		printk(KERN_ALERT "bnx2i (%s): unable to send conn offld kwqe"
-			"\n", hba->netdev->name);
+		pr_alert("(%s): unable to send conn offld kwqe\n",
+			 hba->netdev->name);
 		bnx2i_ep_ofld_list_del(hba, bnx2i_ep);
 		goto conn_failed;
 	}
@@ -1862,8 +1859,8 @@ static struct iscsi_endpoint *bnx2i_ep_connect(struct Scsi_Host *shost,
 
 	if (bnx2i_ep->state != EP_STATE_OFLD_COMPL) {
 		if (bnx2i_ep->state == EP_STATE_OFLD_FAILED_CID_BUSY) {
-			printk(KERN_ALERT "bnx2i (%s): iscsi cid %d is busy\n",
-				hba->netdev->name, bnx2i_ep->ep_iscsi_cid);
+			pr_alert("(%s): iscsi cid %d is busy\n",
+				 hba->netdev->name, bnx2i_ep->ep_iscsi_cid);
 			rc = -EBUSY;
 		} else
 			rc = -ENOSPC;
@@ -2064,10 +2061,8 @@ int bnx2i_hw_ep_disconnect(struct bnx2i_endpoint *bnx2i_ep)
 			if (session->state == ISCSI_STATE_LOGGING_OUT) {
 				if (bnx2i_ep->state == EP_STATE_LOGOUT_SENT) {
 					/* Logout sent, but no resp */
-					printk(KERN_ALERT "bnx2i (%s): WARNING"
-						" logout response was not "
-						"received!\n",
-						bnx2i_ep->hba->netdev->name);
+					pr_alert("(%s): WARNING logout response was not received!\n",
+						 bnx2i_ep->hba->netdev->name);
 				} else if (bnx2i_ep->state ==
 					   EP_STATE_LOGOUT_RESP_RCVD)
 					close = 1;
@@ -2086,8 +2081,8 @@ int bnx2i_hw_ep_disconnect(struct bnx2i_endpoint *bnx2i_ep)
 		close_ret = cnic->cm_abort(bnx2i_ep->cm_sk);
 
 	if (close_ret)
-		printk(KERN_ALERT "bnx2i (%s): close/abort(%d) returned %d\n",
-			bnx2i_ep->hba->netdev->name, close, close_ret);
+		pr_alert("(%s): close/abort(%d) returned %d\n",
+			 bnx2i_ep->hba->netdev->name, close, close_ret);
 	else
 		/* wait for option-2 conn teardown */
 		wait_event_interruptible(bnx2i_ep->ofld_wait,
diff --git a/drivers/scsi/bnx2i/bnx2i_sysfs.c b/drivers/scsi/bnx2i/bnx2i_sysfs.c
index a0a3d9f..622c578 100644
--- a/drivers/scsi/bnx2i/bnx2i_sysfs.c
+++ b/drivers/scsi/bnx2i/bnx2i_sysfs.c
@@ -77,7 +77,7 @@ static ssize_t bnx2i_set_sq_info(struct device *dev,
 	return count;
 
 skip_config:
-	printk(KERN_ERR "bnx2i: device busy, cannot change SQ size\n");
+	pr_err("device busy, cannot change SQ size\n");
 	return 0;
 }
 
@@ -126,7 +126,7 @@ static ssize_t bnx2i_set_ccell_info(struct device *dev,
 	return count;
 
 skip_config:
-	printk(KERN_ERR "bnx2i: device busy, cannot change CCELL size\n");
+	pr_err("device busy, cannot change CCELL size\n");
 	return 0;
 }
 


