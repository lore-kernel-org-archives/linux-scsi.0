From: James Bottomley <James.Bottomley@HansenPartnership.com>
Subject: [GIT PULL] SCSI fixes for 3.16-rc3
Date: Sat, 05 Jul 2014 21:41:42 -0700
Message-ID: <1404621702.1961.8.camel@jarvis.lan>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner@vger.kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
To: Andrew Morton <akpm@linux-foundation.org>, Linus Torvalds <torvalds@linux-foundation.org>
Cc: linux-scsi <linux-scsi@vger.kernel.org>, linux-kernel <linux-kernel@vger.kernel.org>
List-Id: linux-scsi@vger.kernel.org

This is a set of 13 fixes, a MAINTAINERS update and a sparse update.
The fixes are mostly correct value initialisations, avoiding NULL derefs
and some uninitialised pointer avoidance.

All the patches have been incubated in -next for a few days.  The final
patch (use the scsi data buffer length to extract transfer size) has
been rebased to add a cc to stable, but only the commit message has
changed.

The patch is available here:

git://git.kernel.org/pub/scm/linux/kernel/git/jejb/scsi.git scsi-for-linus

The short changelog is:

Brian King (2):
      ibmvscsi: Add memory barriers for send / receive
      ibmvscsi: Abort init sequence during error recovery

Hannes Reinecke (1):
      scsi_error: set DID_TIME_OUT correctly

Martin K. Petersen (1):
      use the scsi data buffer length to extract transfer size

Maurizio Lombardi (2):
      bnx2fc: do not scan uninitialized lists in case of error.
      pm8001: Fix potential null pointer dereference and memory leak.

Neil Horman (2):
      bnx2fc: Improve stats update mechanism
      fc: ensure scan_work isn't active when freeing fc_rport

Paolo Bonzini (2):
      virtio-scsi: fix various bad behavior on aborted requests
      virtio-scsi: avoid cancelling uninitialized work items

Quinn Tran (1):
      qla2xxx: Fix sparse warning in qla_target.c.

Reddy, Sreekanth (1):
      MAINTAINERS: Update LSILOGIC MPT FUSION DRIVERS (FC/SAS/SPI) maintainers Email IDs

Tomas Henzl (2):
      be2iscsi: remove potential junk pointer free
      be2iscsi: add an missing goto in error path

Ulrich Obergfell (1):
      scsi_error: fix invalid setting of host byte


And the diffstat:

 MAINTAINERS                       |  9 +++++----
 drivers/scsi/be2iscsi/be_main.c   |  2 ++
 drivers/scsi/be2iscsi/be_mgmt.c   |  4 +---
 drivers/scsi/bnx2fc/bnx2fc_fcoe.c | 16 ++++------------
 drivers/scsi/bnx2fc/bnx2fc_io.c   |  2 ++
 drivers/scsi/ibmvscsi/ibmvscsi.c  | 13 ++++++++++++-
 drivers/scsi/pm8001/pm8001_init.c | 13 ++++++++++---
 drivers/scsi/qla2xxx/qla_target.c | 17 +++++++++++------
 drivers/scsi/qla2xxx/qla_target.h |  4 ++--
 drivers/scsi/scsi_error.c         | 20 ++++++++++----------
 drivers/scsi/scsi_transport_fc.c  |  1 +
 drivers/scsi/virtio_scsi.c        | 26 +++++++++++++++++++++++++-
 include/scsi/scsi_cmnd.h          |  2 +-
 13 files changed, 86 insertions(+), 43 deletions(-)

With the full diff below.

James

---

diff --git a/MAINTAINERS b/MAINTAINERS
index 3cc94ff..636a51a 100644
--- a/MAINTAINERS
+++ b/MAINTAINERS
@@ -5517,10 +5517,11 @@ S:	Maintained
 F:	arch/arm/mach-lpc32xx/
 
 LSILOGIC MPT FUSION DRIVERS (FC/SAS/SPI)
-M:	Nagalakshmi Nandigama <Nagalakshmi.Nandigama@lsi.com>
-M:	Sreekanth Reddy <Sreekanth.Reddy@lsi.com>
-M:	support@lsi.com
-L:	DL-MPTFusionLinux@lsi.com
+M:	Nagalakshmi Nandigama <nagalakshmi.nandigama@avagotech.com>
+M:	Praveen Krishnamoorthy <praveen.krishnamoorthy@avagotech.com>
+M:	Sreekanth Reddy <sreekanth.reddy@avagotech.com>
+M:	Abhijit Mahajan <abhijit.mahajan@avagotech.com>
+L:	MPT-FusionLinux.pdl@avagotech.com
 L:	linux-scsi@vger.kernel.org
 W:	http://www.lsilogic.com/support
 S:	Supported
diff --git a/drivers/scsi/be2iscsi/be_main.c b/drivers/scsi/be2iscsi/be_main.c
index 5543490..56467df 100644
--- a/drivers/scsi/be2iscsi/be_main.c
+++ b/drivers/scsi/be2iscsi/be_main.c
@@ -4198,6 +4198,8 @@ static int hba_setup_cid_tbls(struct beiscsi_hba *phba)
 		kfree(phba->ep_array);
 		phba->ep_array = NULL;
 		ret = -ENOMEM;
+
+		goto free_memory;
 	}
 
 	for (i = 0; i < phba->params.cxns_per_ctrl; i++) {
diff --git a/drivers/scsi/be2iscsi/be_mgmt.c b/drivers/scsi/be2iscsi/be_mgmt.c
index 6045aa7..07934b0 100644
--- a/drivers/scsi/be2iscsi/be_mgmt.c
+++ b/drivers/scsi/be2iscsi/be_mgmt.c
@@ -1008,10 +1008,8 @@ int mgmt_set_ip(struct beiscsi_hba *phba,
 		BE2_IPV6 : BE2_IPV4 ;
 
 	rc = mgmt_get_if_info(phba, ip_type, &if_info);
-	if (rc) {
-		kfree(if_info);
+	if (rc)
 		return rc;
-	}
 
 	if (boot_proto == ISCSI_BOOTPROTO_DHCP) {
 		if (if_info->dhcp_state) {
diff --git a/drivers/scsi/bnx2fc/bnx2fc_fcoe.c b/drivers/scsi/bnx2fc/bnx2fc_fcoe.c
index f548430..785d0d7 100644
--- a/drivers/scsi/bnx2fc/bnx2fc_fcoe.c
+++ b/drivers/scsi/bnx2fc/bnx2fc_fcoe.c
@@ -516,23 +516,17 @@ static void bnx2fc_recv_frame(struct sk_buff *skb)
 	skb_pull(skb, sizeof(struct fcoe_hdr));
 	fr_len = skb->len - sizeof(struct fcoe_crc_eof);
 
-	stats = per_cpu_ptr(lport->stats, get_cpu());
-	stats->RxFrames++;
-	stats->RxWords += fr_len / FCOE_WORD_TO_BYTE;
-
 	fp = (struct fc_frame *)skb;
 	fc_frame_init(fp);
 	fr_dev(fp) = lport;
 	fr_sof(fp) = hp->fcoe_sof;
 	if (skb_copy_bits(skb, fr_len, &crc_eof, sizeof(crc_eof))) {
-		put_cpu();
 		kfree_skb(skb);
 		return;
 	}
 	fr_eof(fp) = crc_eof.fcoe_eof;
 	fr_crc(fp) = crc_eof.fcoe_crc32;
 	if (pskb_trim(skb, fr_len)) {
-		put_cpu();
 		kfree_skb(skb);
 		return;
 	}
@@ -544,7 +538,6 @@ static void bnx2fc_recv_frame(struct sk_buff *skb)
 		port = lport_priv(vn_port);
 		if (!ether_addr_equal(port->data_src_addr, dest_mac)) {
 			BNX2FC_HBA_DBG(lport, "fpma mismatch\n");
-			put_cpu();
 			kfree_skb(skb);
 			return;
 		}
@@ -552,7 +545,6 @@ static void bnx2fc_recv_frame(struct sk_buff *skb)
 	if (fh->fh_r_ctl == FC_RCTL_DD_SOL_DATA &&
 	    fh->fh_type == FC_TYPE_FCP) {
 		/* Drop FCP data. We dont this in L2 path */
-		put_cpu();
 		kfree_skb(skb);
 		return;
 	}
@@ -562,7 +554,6 @@ static void bnx2fc_recv_frame(struct sk_buff *skb)
 		case ELS_LOGO:
 			if (ntoh24(fh->fh_s_id) == FC_FID_FLOGI) {
 				/* drop non-FIP LOGO */
-				put_cpu();
 				kfree_skb(skb);
 				return;
 			}
@@ -572,22 +563,23 @@ static void bnx2fc_recv_frame(struct sk_buff *skb)
 
 	if (fh->fh_r_ctl == FC_RCTL_BA_ABTS) {
 		/* Drop incoming ABTS */
-		put_cpu();
 		kfree_skb(skb);
 		return;
 	}
 
+	stats = per_cpu_ptr(lport->stats, smp_processor_id());
+	stats->RxFrames++;
+	stats->RxWords += fr_len / FCOE_WORD_TO_BYTE;
+
 	if (le32_to_cpu(fr_crc(fp)) !=
 			~crc32(~0, skb->data, fr_len)) {
 		if (stats->InvalidCRCCount < 5)
 			printk(KERN_WARNING PFX "dropping frame with "
 			       "CRC error\n");
 		stats->InvalidCRCCount++;
-		put_cpu();
 		kfree_skb(skb);
 		return;
 	}
-	put_cpu();
 	fc_exch_recv(lport, fp);
 }
 
diff --git a/drivers/scsi/bnx2fc/bnx2fc_io.c b/drivers/scsi/bnx2fc/bnx2fc_io.c
index 32a5e0a..7bc47fc 100644
--- a/drivers/scsi/bnx2fc/bnx2fc_io.c
+++ b/drivers/scsi/bnx2fc/bnx2fc_io.c
@@ -282,6 +282,8 @@ struct bnx2fc_cmd_mgr *bnx2fc_cmd_mgr_alloc(struct bnx2fc_hba *hba)
 				       arr_sz, GFP_KERNEL);
 	if (!cmgr->free_list_lock) {
 		printk(KERN_ERR PFX "failed to alloc free_list_lock\n");
+		kfree(cmgr->free_list);
+		cmgr->free_list = NULL;
 		goto mem_err;
 	}
 
diff --git a/drivers/scsi/ibmvscsi/ibmvscsi.c b/drivers/scsi/ibmvscsi/ibmvscsi.c
index 2ebfb2b..7b23f21 100644
--- a/drivers/scsi/ibmvscsi/ibmvscsi.c
+++ b/drivers/scsi/ibmvscsi/ibmvscsi.c
@@ -185,6 +185,11 @@ static struct viosrp_crq *crq_queue_next_crq(struct crq_queue *queue)
 	if (crq->valid & 0x80) {
 		if (++queue->cur == queue->size)
 			queue->cur = 0;
+
+		/* Ensure the read of the valid bit occurs before reading any
+		 * other bits of the CRQ entry
+		 */
+		rmb();
 	} else
 		crq = NULL;
 	spin_unlock_irqrestore(&queue->lock, flags);
@@ -203,6 +208,11 @@ static int ibmvscsi_send_crq(struct ibmvscsi_host_data *hostdata,
 {
 	struct vio_dev *vdev = to_vio_dev(hostdata->dev);
 
+	/*
+	 * Ensure the command buffer is flushed to memory before handing it
+	 * over to the VIOS to prevent it from fetching any stale data.
+	 */
+	mb();
 	return plpar_hcall_norets(H_SEND_CRQ, vdev->unit_address, word1, word2);
 }
 
@@ -797,7 +807,8 @@ static void purge_requests(struct ibmvscsi_host_data *hostdata, int error_code)
 				       evt->hostdata->dev);
 			if (evt->cmnd_done)
 				evt->cmnd_done(evt->cmnd);
-		} else if (evt->done)
+		} else if (evt->done && evt->crq.format != VIOSRP_MAD_FORMAT &&
+			   evt->iu.srp.login_req.opcode != SRP_LOGIN_REQ)
 			evt->done(evt);
 		free_event_struct(&evt->hostdata->pool, evt);
 		spin_lock_irqsave(hostdata->host->host_lock, flags);
diff --git a/drivers/scsi/pm8001/pm8001_init.c b/drivers/scsi/pm8001/pm8001_init.c
index c4f31b21..e90c89f 100644
--- a/drivers/scsi/pm8001/pm8001_init.c
+++ b/drivers/scsi/pm8001/pm8001_init.c
@@ -677,7 +677,7 @@ static void pm8001_init_sas_add(struct pm8001_hba_info *pm8001_ha)
  * pm8001_get_phy_settings_info : Read phy setting values.
  * @pm8001_ha : our hba.
  */
-void pm8001_get_phy_settings_info(struct pm8001_hba_info *pm8001_ha)
+static int pm8001_get_phy_settings_info(struct pm8001_hba_info *pm8001_ha)
 {
 
 #ifdef PM8001_READ_VPD
@@ -691,11 +691,15 @@ void pm8001_get_phy_settings_info(struct pm8001_hba_info *pm8001_ha)
 	payload.offset = 0;
 	payload.length = 4096;
 	payload.func_specific = kzalloc(4096, GFP_KERNEL);
+	if (!payload.func_specific)
+		return -ENOMEM;
 	/* Read phy setting values from flash */
 	PM8001_CHIP_DISP->get_nvmd_req(pm8001_ha, &payload);
 	wait_for_completion(&completion);
 	pm8001_set_phy_profile(pm8001_ha, sizeof(u8), payload.func_specific);
+	kfree(payload.func_specific);
 #endif
+	return 0;
 }
 
 #ifdef PM8001_USE_MSIX
@@ -879,8 +883,11 @@ static int pm8001_pci_probe(struct pci_dev *pdev,
 	pm8001_init_sas_add(pm8001_ha);
 	/* phy setting support for motherboard controller */
 	if (pdev->subsystem_vendor != PCI_VENDOR_ID_ADAPTEC2 &&
-		pdev->subsystem_vendor != 0)
-		pm8001_get_phy_settings_info(pm8001_ha);
+		pdev->subsystem_vendor != 0) {
+		rc = pm8001_get_phy_settings_info(pm8001_ha);
+		if (rc)
+			goto err_out_shost;
+	}
 	pm8001_post_sas_ha_init(shost, chip);
 	rc = sas_register_ha(SHOST_TO_SAS_HA(shost));
 	if (rc)
diff --git a/drivers/scsi/qla2xxx/qla_target.c b/drivers/scsi/qla2xxx/qla_target.c
index 4b188b0..e632e14 100644
--- a/drivers/scsi/qla2xxx/qla_target.c
+++ b/drivers/scsi/qla2xxx/qla_target.c
@@ -1128,7 +1128,7 @@ static void qlt_24xx_retry_term_exchange(struct scsi_qla_host *vha,
 	ctio->u.status1.flags =
 	    __constant_cpu_to_le16(CTIO7_FLAGS_STATUS_MODE_1 |
 		CTIO7_FLAGS_TERMINATE);
-	ctio->u.status1.ox_id = entry->fcp_hdr_le.ox_id;
+	ctio->u.status1.ox_id = cpu_to_le16(entry->fcp_hdr_le.ox_id);
 
 	qla2x00_start_iocbs(vha, vha->req);
 
@@ -1262,6 +1262,7 @@ static void qlt_24xx_send_task_mgmt_ctio(struct scsi_qla_host *ha,
 {
 	struct atio_from_isp *atio = &mcmd->orig_iocb.atio;
 	struct ctio7_to_24xx *ctio;
+	uint16_t temp;
 
 	ql_dbg(ql_dbg_tgt, ha, 0xe008,
 	    "Sending task mgmt CTIO7 (ha=%p, atio=%p, resp_code=%x\n",
@@ -1292,7 +1293,8 @@ static void qlt_24xx_send_task_mgmt_ctio(struct scsi_qla_host *ha,
 	ctio->u.status1.flags = (atio->u.isp24.attr << 9) |
 	    __constant_cpu_to_le16(CTIO7_FLAGS_STATUS_MODE_1 |
 		CTIO7_FLAGS_SEND_STATUS);
-	ctio->u.status1.ox_id = swab16(atio->u.isp24.fcp_hdr.ox_id);
+	temp = be16_to_cpu(atio->u.isp24.fcp_hdr.ox_id);
+	ctio->u.status1.ox_id = cpu_to_le16(temp);
 	ctio->u.status1.scsi_status =
 	    __constant_cpu_to_le16(SS_RESPONSE_INFO_LEN_VALID);
 	ctio->u.status1.response_len = __constant_cpu_to_le16(8);
@@ -1513,6 +1515,7 @@ static int qlt_24xx_build_ctio_pkt(struct qla_tgt_prm *prm,
 	struct ctio7_to_24xx *pkt;
 	struct qla_hw_data *ha = vha->hw;
 	struct atio_from_isp *atio = &prm->cmd->atio;
+	uint16_t temp;
 
 	pkt = (struct ctio7_to_24xx *)vha->req->ring_ptr;
 	prm->pkt = pkt;
@@ -1541,13 +1544,13 @@ static int qlt_24xx_build_ctio_pkt(struct qla_tgt_prm *prm,
 	pkt->initiator_id[2] = atio->u.isp24.fcp_hdr.s_id[0];
 	pkt->exchange_addr = atio->u.isp24.exchange_addr;
 	pkt->u.status0.flags |= (atio->u.isp24.attr << 9);
-	pkt->u.status0.ox_id = swab16(atio->u.isp24.fcp_hdr.ox_id);
+	temp = be16_to_cpu(atio->u.isp24.fcp_hdr.ox_id);
+	pkt->u.status0.ox_id = cpu_to_le16(temp);
 	pkt->u.status0.relative_offset = cpu_to_le32(prm->cmd->offset);
 
 	ql_dbg(ql_dbg_tgt, vha, 0xe00c,
 	    "qla_target(%d): handle(cmd) -> %08x, timeout %d, ox_id %#x\n",
-	    vha->vp_idx, pkt->handle, QLA_TGT_TIMEOUT,
-	    le16_to_cpu(pkt->u.status0.ox_id));
+	    vha->vp_idx, pkt->handle, QLA_TGT_TIMEOUT, temp);
 	return 0;
 }
 
@@ -2619,6 +2622,7 @@ static int __qlt_send_term_exchange(struct scsi_qla_host *vha,
 	struct qla_hw_data *ha = vha->hw;
 	request_t *pkt;
 	int ret = 0;
+	uint16_t temp;
 
 	ql_dbg(ql_dbg_tgt, vha, 0xe01c, "Sending TERM EXCH CTIO (ha=%p)\n", ha);
 
@@ -2655,7 +2659,8 @@ static int __qlt_send_term_exchange(struct scsi_qla_host *vha,
 	ctio24->u.status1.flags = (atio->u.isp24.attr << 9) |
 	    __constant_cpu_to_le16(CTIO7_FLAGS_STATUS_MODE_1 |
 		CTIO7_FLAGS_TERMINATE);
-	ctio24->u.status1.ox_id = swab16(atio->u.isp24.fcp_hdr.ox_id);
+	temp = be16_to_cpu(atio->u.isp24.fcp_hdr.ox_id);
+	ctio24->u.status1.ox_id = cpu_to_le16(temp);
 
 	/* Most likely, it isn't needed */
 	ctio24->u.status1.residual = get_unaligned((uint32_t *)
diff --git a/drivers/scsi/qla2xxx/qla_target.h b/drivers/scsi/qla2xxx/qla_target.h
index e0a58fd..d1d24fb 100644
--- a/drivers/scsi/qla2xxx/qla_target.h
+++ b/drivers/scsi/qla2xxx/qla_target.h
@@ -443,7 +443,7 @@ struct ctio7_to_24xx {
 			uint16_t reserved1;
 			__le16 flags;
 			uint32_t residual;
-			uint16_t ox_id;
+			__le16 ox_id;
 			uint16_t scsi_status;
 			uint32_t relative_offset;
 			uint32_t reserved2;
@@ -458,7 +458,7 @@ struct ctio7_to_24xx {
 			uint16_t sense_length;
 			uint16_t flags;
 			uint32_t residual;
-			uint16_t ox_id;
+			__le16 ox_id;
 			uint16_t scsi_status;
 			uint16_t response_len;
 			uint16_t reserved;
diff --git a/drivers/scsi/scsi_error.c b/drivers/scsi/scsi_error.c
index cbe38e5..7e95791 100644
--- a/drivers/scsi/scsi_error.c
+++ b/drivers/scsi/scsi_error.c
@@ -131,7 +131,7 @@ scmd_eh_abort_handler(struct work_struct *work)
 				    "aborting command %p\n", scmd));
 		rtn = scsi_try_to_abort_cmd(sdev->host->hostt, scmd);
 		if (rtn == SUCCESS) {
-			scmd->result |= DID_TIME_OUT << 16;
+			set_host_byte(scmd, DID_TIME_OUT);
 			if (scsi_host_eh_past_deadline(sdev->host)) {
 				SCSI_LOG_ERROR_RECOVERY(3,
 					scmd_printk(KERN_INFO, scmd,
@@ -167,7 +167,7 @@ scmd_eh_abort_handler(struct work_struct *work)
 			scmd_printk(KERN_WARNING, scmd,
 				    "scmd %p terminate "
 				    "aborted command\n", scmd));
-		scmd->result |= DID_TIME_OUT << 16;
+		set_host_byte(scmd, DID_TIME_OUT);
 		scsi_finish_command(scmd);
 	}
 }
@@ -287,15 +287,15 @@ enum blk_eh_timer_return scsi_times_out(struct request *req)
 	else if (host->hostt->eh_timed_out)
 		rtn = host->hostt->eh_timed_out(scmd);
 
-	if (rtn == BLK_EH_NOT_HANDLED && !host->hostt->no_async_abort)
-		if (scsi_abort_command(scmd) == SUCCESS)
+	if (rtn == BLK_EH_NOT_HANDLED) {
+		if (!host->hostt->no_async_abort &&
+		    scsi_abort_command(scmd) == SUCCESS)
 			return BLK_EH_NOT_HANDLED;
 
-	scmd->result |= DID_TIME_OUT << 16;
-
-	if (unlikely(rtn == BLK_EH_NOT_HANDLED &&
-		     !scsi_eh_scmd_add(scmd, SCSI_EH_CANCEL_CMD)))
-		rtn = BLK_EH_HANDLED;
+		set_host_byte(scmd, DID_TIME_OUT);
+		if (!scsi_eh_scmd_add(scmd, SCSI_EH_CANCEL_CMD))
+			rtn = BLK_EH_HANDLED;
+	}
 
 	return rtn;
 }
@@ -1777,7 +1777,7 @@ int scsi_decide_disposition(struct scsi_cmnd *scmd)
 		break;
 	case DID_ABORT:
 		if (scmd->eh_eflags & SCSI_EH_ABORT_SCHEDULED) {
-			scmd->result |= DID_TIME_OUT << 16;
+			set_host_byte(scmd, DID_TIME_OUT);
 			return SUCCESS;
 		}
 	case DID_NO_CONNECT:
diff --git a/drivers/scsi/scsi_transport_fc.c b/drivers/scsi/scsi_transport_fc.c
index f80908f..521f583 100644
--- a/drivers/scsi/scsi_transport_fc.c
+++ b/drivers/scsi/scsi_transport_fc.c
@@ -2549,6 +2549,7 @@ fc_rport_final_delete(struct work_struct *work)
 			fc_flush_devloss(shost);
 		if (!cancel_delayed_work(&rport->dev_loss_work))
 			fc_flush_devloss(shost);
+		cancel_work_sync(&rport->scan_work);
 		spin_lock_irqsave(shost->host_lock, flags);
 		rport->flags &= ~FC_RPORT_DEVLOSS_PENDING;
 	}
diff --git a/drivers/scsi/virtio_scsi.c b/drivers/scsi/virtio_scsi.c
index 89ee592..308256b 100644
--- a/drivers/scsi/virtio_scsi.c
+++ b/drivers/scsi/virtio_scsi.c
@@ -237,6 +237,16 @@ static void virtscsi_req_done(struct virtqueue *vq)
 	virtscsi_vq_done(vscsi, req_vq, virtscsi_complete_cmd);
 };
 
+static void virtscsi_poll_requests(struct virtio_scsi *vscsi)
+{
+	int i, num_vqs;
+
+	num_vqs = vscsi->num_queues;
+	for (i = 0; i < num_vqs; i++)
+		virtscsi_vq_done(vscsi, &vscsi->req_vqs[i],
+				 virtscsi_complete_cmd);
+}
+
 static void virtscsi_complete_free(struct virtio_scsi *vscsi, void *buf)
 {
 	struct virtio_scsi_cmd *cmd = buf;
@@ -253,6 +263,8 @@ static void virtscsi_ctrl_done(struct virtqueue *vq)
 	virtscsi_vq_done(vscsi, &vscsi->ctrl_vq, virtscsi_complete_free);
 };
 
+static void virtscsi_handle_event(struct work_struct *work);
+
 static int virtscsi_kick_event(struct virtio_scsi *vscsi,
 			       struct virtio_scsi_event_node *event_node)
 {
@@ -260,6 +272,7 @@ static int virtscsi_kick_event(struct virtio_scsi *vscsi,
 	struct scatterlist sg;
 	unsigned long flags;
 
+	INIT_WORK(&event_node->work, virtscsi_handle_event);
 	sg_init_one(&sg, &event_node->event, sizeof(struct virtio_scsi_event));
 
 	spin_lock_irqsave(&vscsi->event_vq.vq_lock, flags);
@@ -377,7 +390,6 @@ static void virtscsi_complete_event(struct virtio_scsi *vscsi, void *buf)
 {
 	struct virtio_scsi_event_node *event_node = buf;
 
-	INIT_WORK(&event_node->work, virtscsi_handle_event);
 	schedule_work(&event_node->work);
 }
 
@@ -589,6 +601,18 @@ static int virtscsi_tmf(struct virtio_scsi *vscsi, struct virtio_scsi_cmd *cmd)
 	    cmd->resp.tmf.response == VIRTIO_SCSI_S_FUNCTION_SUCCEEDED)
 		ret = SUCCESS;
 
+	/*
+	 * The spec guarantees that all requests related to the TMF have
+	 * been completed, but the callback might not have run yet if
+	 * we're using independent interrupts (e.g. MSI).  Poll the
+	 * virtqueues once.
+	 *
+	 * In the abort case, sc->scsi_done will do nothing, because
+	 * the block layer must have detected a timeout and as a result
+	 * REQ_ATOM_COMPLETE has been set.
+	 */
+	virtscsi_poll_requests(vscsi);
+
 out:
 	mempool_free(cmd, virtscsi_cmd_pool);
 	return ret;
diff --git a/include/scsi/scsi_cmnd.h b/include/scsi/scsi_cmnd.h
index 42ed789..e0ae710 100644
--- a/include/scsi/scsi_cmnd.h
+++ b/include/scsi/scsi_cmnd.h
@@ -318,7 +318,7 @@ static inline void set_driver_byte(struct scsi_cmnd *cmd, char status)
 
 static inline unsigned scsi_transfer_length(struct scsi_cmnd *scmd)
 {
-	unsigned int xfer_len = blk_rq_bytes(scmd->request);
+	unsigned int xfer_len = scsi_out(scmd)->length;
 	unsigned int prot_op = scsi_get_prot_op(scmd);
 	unsigned int sector_size = scmd->device->sector_size;
 
