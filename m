From: James Bottomley <James.Bottomley@suse.de>
Subject: [GIT PATCH] SCSI bug fixes for 2.6.33-rc3
Date: Wed, 06 Jan 2010 12:02:12 -0500
Message-ID: <1262797332.2946.147.camel@mulgrave.site>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from cantor.suse.de ([195.135.220.2]:42335 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755994Ab0AFRC2 (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Wed, 6 Jan 2010 12:02:28 -0500
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Andrew Morton <akpm@linux-foundation.org>, Linus Torvalds <torvalds@linux-foundation.org>
Cc: linux-scsi <linux-scsi@vger.kernel.org>, linux-kernel <linux-kernel@vger.kernel.org>

This patch represents the accumulated bug fixes in a variety of drivers,
with concentrated bug fix updates for emulex NPIV and qla2xxx EEH.

The patch is available at:

master.kernel.org:/pub/scm/linux/kernel/git/jejb/scsi-misc-2.6.git

The short changelog is

Andrew Vasquez (1):
      qla2xxx: Extend base EEH support in qla2xxx.

Anil Ravindranath (1):
      pmcraid: fix to avoid twice scsi_dma_unmap for a command

Anirban Chakraborty (1):
      qla2xxx: Fix for a multiqueue bug in CPU affinity mode

Duane Grigsby (1):
      qla2xxx: Added to EEH support.

Ed Lin (1):
      stex: fix scan of nonexistent lun

Giridhar Malavali (1):
      qla2xxx: Update version number to 8.03.01-k9.

James Smart (6):
      lpfc 8.3.7: Update Driver version to 8.3.7
      lpfc 8.3.7: Fix discovery failures.
      lpfc 8.3.7: Fix SCSI protocol related errors.
      lpfc 8.3.7: Fix hardware/SLI relates issues
      lpfc 8.3.7: Fix NPIV operation errors
      lpfc 8.3.7: Fix FC protocol errors

Michael Hernandez (1):
      qla2xxx: Get the link data rate explicitly during device resync.

Rakesh Ranjan (1):
      cxgb3i: Fix a login over vlan issue

the diffstat

 drivers/scsi/cxgb3i/cxgb3i_offload.c |   34 ++++++++++++-
 drivers/scsi/lpfc/lpfc_els.c         |    4 -
 drivers/scsi/lpfc/lpfc_hbadisc.c     |   25 ++++++++-
 drivers/scsi/lpfc/lpfc_hw4.h         |    3 -
 drivers/scsi/lpfc/lpfc_init.c        |   14 ++++-
 drivers/scsi/lpfc/lpfc_sli.c         |   48 +++++++++++-------
 drivers/scsi/lpfc/lpfc_sli4.h        |    2 
 drivers/scsi/lpfc/lpfc_version.h     |    2 
 drivers/scsi/lpfc/lpfc_vport.c       |    4 +
 drivers/scsi/pmcraid.c               |    8 +--
 drivers/scsi/qla2xxx/qla_attr.c      |   32 ++++++++++--
 drivers/scsi/qla2xxx/qla_dbg.h       |    9 +++
 drivers/scsi/qla2xxx/qla_def.h       |    2 
 drivers/scsi/qla2xxx/qla_gbl.h       |    1 
 drivers/scsi/qla2xxx/qla_init.c      |   22 ++++++++
 drivers/scsi/qla2xxx/qla_isr.c       |    9 ++-
 drivers/scsi/qla2xxx/qla_mbx.c       |   64 +++++++++++++++++++++++-
 drivers/scsi/qla2xxx/qla_mid.c       |    2 
 drivers/scsi/qla2xxx/qla_os.c        |   90 +++++++++++++++++++++++++++++++----
 drivers/scsi/qla2xxx/qla_version.h   |    2 
 drivers/scsi/stex.c                  |    5 +
 21 files changed, 322 insertions(+), 60 deletions(-)

Entire diff is below.

James

---

diff --git a/drivers/scsi/cxgb3i/cxgb3i_offload.c b/drivers/scsi/cxgb3i/cxgb3i_offload.c
index 26ffdcd..15a00e8 100644
--- a/drivers/scsi/cxgb3i/cxgb3i_offload.c
+++ b/drivers/scsi/cxgb3i/cxgb3i_offload.c
@@ -1440,6 +1440,10 @@ void cxgb3i_c3cn_release(struct s3_conn *c3cn)
 static int is_cxgb3_dev(struct net_device *dev)
 {
 	struct cxgb3i_sdev_data *cdata;
+	struct net_device *ndev = dev;
+
+	if (dev->priv_flags & IFF_802_1Q_VLAN)
+		ndev = vlan_dev_real_dev(dev);
 
 	write_lock(&cdata_rwlock);
 	list_for_each_entry(cdata, &cdata_list, list) {
@@ -1447,7 +1451,7 @@ static int is_cxgb3_dev(struct net_device *dev)
 		int i;
 
 		for (i = 0; i < ports->nports; i++)
-			if (dev == ports->lldevs[i]) {
+			if (ndev == ports->lldevs[i]) {
 				write_unlock(&cdata_rwlock);
 				return 1;
 			}
@@ -1566,6 +1570,26 @@ out_err:
 	return -EINVAL;
 }
 
+/**
+ * cxgb3i_find_dev - find the interface associated with the given address
+ * @ipaddr: ip address
+ */
+static struct net_device *
+cxgb3i_find_dev(struct net_device *dev, __be32 ipaddr)
+{
+	struct flowi fl;
+	int err;
+	struct rtable *rt;
+
+	memset(&fl, 0, sizeof(fl));
+	fl.nl_u.ip4_u.daddr = ipaddr;
+
+	err = ip_route_output_key(dev ? dev_net(dev) : &init_net, &rt, &fl);
+	if (!err)
+		return (&rt->u.dst)->dev;
+
+	return NULL;
+}
 
 /**
  * cxgb3i_c3cn_connect - initiates an iscsi tcp connection to a given address
@@ -1581,6 +1605,7 @@ int cxgb3i_c3cn_connect(struct net_device *dev, struct s3_conn *c3cn,
 	struct cxgb3i_sdev_data *cdata;
 	struct t3cdev *cdev;
 	__be32 sipv4;
+	struct net_device *dstdev;
 	int err;
 
 	c3cn_conn_debug("c3cn 0x%p, dev 0x%p.\n", c3cn, dev);
@@ -1591,6 +1616,13 @@ int cxgb3i_c3cn_connect(struct net_device *dev, struct s3_conn *c3cn,
 	c3cn->daddr.sin_port = usin->sin_port;
 	c3cn->daddr.sin_addr.s_addr = usin->sin_addr.s_addr;
 
+	dstdev = cxgb3i_find_dev(dev, usin->sin_addr.s_addr);
+	if (!dstdev || !is_cxgb3_dev(dstdev))
+		return -ENETUNREACH;
+
+	if (dstdev->priv_flags & IFF_802_1Q_VLAN)
+		dev = dstdev;
+
 	rt = find_route(dev, c3cn->saddr.sin_addr.s_addr,
 			c3cn->daddr.sin_addr.s_addr,
 			c3cn->saddr.sin_port,
diff --git a/drivers/scsi/lpfc/lpfc_els.c b/drivers/scsi/lpfc/lpfc_els.c
index ce52270..2cc3968 100644
--- a/drivers/scsi/lpfc/lpfc_els.c
+++ b/drivers/scsi/lpfc/lpfc_els.c
@@ -4142,8 +4142,8 @@ lpfc_els_rcv_rscn(struct lpfc_vport *vport, struct lpfc_iocbq *cmdiocb,
 	spin_lock_irq(shost->host_lock);
 	if (vport->fc_rscn_flush) {
 		/* Another thread is walking fc_rscn_id_list on this vport */
-		spin_unlock_irq(shost->host_lock);
 		vport->fc_flag |= FC_RSCN_DISCOVERY;
+		spin_unlock_irq(shost->host_lock);
 		/* Send back ACC */
 		lpfc_els_rsp_acc(vport, ELS_CMD_ACC, cmdiocb, ndlp, NULL);
 		return 0;
@@ -5948,8 +5948,8 @@ lpfc_cmpl_reg_new_vport(struct lpfc_hba *phba, LPFC_MBOXQ_t *pmb)
 				lpfc_initial_fdisc(vport);
 			break;
 		}
-
 	} else {
+		vport->vpi_state |= LPFC_VPI_REGISTERED;
 		if (vport == phba->pport)
 			if (phba->sli_rev < LPFC_SLI_REV4)
 				lpfc_issue_fabric_reglogin(vport);
diff --git a/drivers/scsi/lpfc/lpfc_hbadisc.c b/drivers/scsi/lpfc/lpfc_hbadisc.c
index 3b94244..2445e39 100755
--- a/drivers/scsi/lpfc/lpfc_hbadisc.c
+++ b/drivers/scsi/lpfc/lpfc_hbadisc.c
@@ -747,6 +747,10 @@ lpfc_linkdown(struct lpfc_hba *phba)
 
 	if (phba->link_state == LPFC_LINK_DOWN)
 		return 0;
+
+	/* Block all SCSI stack I/Os */
+	lpfc_scsi_dev_block(phba);
+
 	spin_lock_irq(&phba->hbalock);
 	phba->fcf.fcf_flag &= ~(FCF_AVAILABLE | FCF_DISCOVERED);
 	if (phba->link_state > LPFC_LINK_DOWN) {
@@ -1555,10 +1559,16 @@ lpfc_mbx_cmpl_read_fcf_record(struct lpfc_hba *phba, LPFC_MBOXQ_t *mboxq)
 	 * to book keeping the FCFIs can be used.
 	 */
 	if (shdr_status || shdr_add_status) {
-		lpfc_printf_log(phba, KERN_ERR, LOG_INIT,
-				"2521 READ_FCF_RECORD mailbox failed "
-				"with status x%x add_status x%x, mbx\n",
-				shdr_status, shdr_add_status);
+		if (shdr_status == STATUS_FCF_TABLE_EMPTY) {
+			lpfc_printf_log(phba, KERN_ERR, LOG_INIT,
+					"2726 READ_FCF_RECORD Indicates empty "
+					"FCF table.\n");
+		} else {
+			lpfc_printf_log(phba, KERN_ERR, LOG_INIT,
+					"2521 READ_FCF_RECORD mailbox failed "
+					"with status x%x add_status x%x, mbx\n",
+					shdr_status, shdr_add_status);
+		}
 		goto out;
 	}
 	/* Interpreting the returned information of FCF records */
@@ -1698,7 +1708,9 @@ lpfc_init_vpi_cmpl(struct lpfc_hba *phba, LPFC_MBOXQ_t *mboxq)
 		lpfc_vport_set_state(vport, FC_VPORT_FAILED);
 		return;
 	}
+	spin_lock_irq(&phba->hbalock);
 	vport->fc_flag &= ~FC_VPORT_NEEDS_INIT_VPI;
+	spin_unlock_irq(&phba->hbalock);
 
 	if (phba->link_flag & LS_NPIV_FAB_SUPPORTED)
 		lpfc_initial_fdisc(vport);
@@ -2259,7 +2271,10 @@ lpfc_mbx_cmpl_unreg_vpi(struct lpfc_hba *phba, LPFC_MBOXQ_t *pmb)
 				 mb->mbxStatus);
 		break;
 	}
+	spin_lock_irq(&phba->hbalock);
 	vport->vpi_state &= ~LPFC_VPI_REGISTERED;
+	vport->fc_flag |= FC_VPORT_NEEDS_REG_VPI;
+	spin_unlock_irq(&phba->hbalock);
 	vport->unreg_vpi_cmpl = VPORT_OK;
 	mempool_free(pmb, phba->mbox_mem_pool);
 	/*
@@ -4475,8 +4490,10 @@ lpfc_unregister_unused_fcf(struct lpfc_hba *phba)
 		(phba->sli3_options & LPFC_SLI3_NPIV_ENABLED))
 		for (i = 0; i <= phba->max_vports && vports[i] != NULL; i++) {
 			lpfc_mbx_unreg_vpi(vports[i]);
+			spin_lock_irq(&phba->hbalock);
 			vports[i]->fc_flag |= FC_VPORT_NEEDS_INIT_VPI;
 			vports[i]->vpi_state &= ~LPFC_VPI_REGISTERED;
+			spin_unlock_irq(&phba->hbalock);
 		}
 	lpfc_destroy_vport_work_array(phba, vports);
 
diff --git a/drivers/scsi/lpfc/lpfc_hw4.h b/drivers/scsi/lpfc/lpfc_hw4.h
old mode 100644
new mode 100755
index 1585148..8a2a1c5
--- a/drivers/scsi/lpfc/lpfc_hw4.h
+++ b/drivers/scsi/lpfc/lpfc_hw4.h
@@ -1013,7 +1013,7 @@ struct lpfc_mbx_wq_destroy {
 };
 
 #define LPFC_HDR_BUF_SIZE 128
-#define LPFC_DATA_BUF_SIZE 4096
+#define LPFC_DATA_BUF_SIZE 2048
 struct rq_context {
 	uint32_t word0;
 #define lpfc_rq_context_rq_size_SHIFT	16
@@ -1371,6 +1371,7 @@ struct lpfc_mbx_query_fw_cfg {
 #define STATUS_ERROR_ACITMAIN				0x2a
 #define STATUS_REBOOT_REQUIRED				0x2c
 #define STATUS_FCF_IN_USE				0x3a
+#define STATUS_FCF_TABLE_EMPTY				0x43
 
 struct lpfc_mbx_sli4_config {
 	struct mbox_header header;
diff --git a/drivers/scsi/lpfc/lpfc_init.c b/drivers/scsi/lpfc/lpfc_init.c
index d4da6bd..b8eb1b6 100644
--- a/drivers/scsi/lpfc/lpfc_init.c
+++ b/drivers/scsi/lpfc/lpfc_init.c
@@ -3006,6 +3006,7 @@ lpfc_sli4_async_fcoe_evt(struct lpfc_hba *phba,
 	struct lpfc_vport *vport;
 	struct lpfc_nodelist *ndlp;
 	struct Scsi_Host  *shost;
+	uint32_t link_state;
 
 	phba->fc_eventTag = acqe_fcoe->event_tag;
 	phba->fcoe_eventtag = acqe_fcoe->event_tag;
@@ -3052,9 +3053,12 @@ lpfc_sli4_async_fcoe_evt(struct lpfc_hba *phba,
 			break;
 		/*
 		 * Currently, driver support only one FCF - so treat this as
-		 * a link down.
+		 * a link down, but save the link state because we don't want
+		 * it to be changed to Link Down unless it is already down.
 		 */
+		link_state = phba->link_state;
 		lpfc_linkdown(phba);
+		phba->link_state = link_state;
 		/* Unregister FCF if no devices connected to it */
 		lpfc_unregister_unused_fcf(phba);
 		break;
@@ -7226,8 +7230,6 @@ lpfc_prep_dev_for_perm_failure(struct lpfc_hba *phba)
 {
 	lpfc_printf_log(phba, KERN_ERR, LOG_INIT,
 			"2711 PCI channel permanent disable for failure\n");
-	/* Block all SCSI devices' I/Os on the host */
-	lpfc_scsi_dev_block(phba);
 	/* Clean up all driver's outstanding SCSI I/Os */
 	lpfc_sli_flush_fcp_rings(phba);
 }
@@ -7256,6 +7258,9 @@ lpfc_io_error_detected_s3(struct pci_dev *pdev, pci_channel_state_t state)
 	struct Scsi_Host *shost = pci_get_drvdata(pdev);
 	struct lpfc_hba *phba = ((struct lpfc_vport *)shost->hostdata)->phba;
 
+	/* Block all SCSI devices' I/Os on the host */
+	lpfc_scsi_dev_block(phba);
+
 	switch (state) {
 	case pci_channel_io_normal:
 		/* Non-fatal error, prepare for recovery */
@@ -7507,6 +7512,9 @@ lpfc_pci_probe_one_s4(struct pci_dev *pdev, const struct pci_device_id *pid)
 			error = -ENODEV;
 			goto out_free_sysfs_attr;
 		}
+		/* Default to single FCP EQ for non-MSI-X */
+		if (phba->intr_type != MSIX)
+			phba->cfg_fcp_eq_count = 1;
 		/* Set up SLI-4 HBA */
 		if (lpfc_sli4_hba_setup(phba)) {
 			lpfc_printf_log(phba, KERN_ERR, LOG_INIT,
diff --git a/drivers/scsi/lpfc/lpfc_sli.c b/drivers/scsi/lpfc/lpfc_sli.c
index 7935667..589549b 100644
--- a/drivers/scsi/lpfc/lpfc_sli.c
+++ b/drivers/scsi/lpfc/lpfc_sli.c
@@ -1383,7 +1383,7 @@ lpfc_sli_hbq_to_firmware_s4(struct lpfc_hba *phba, uint32_t hbqno,
 /* HBQ for ELS and CT traffic. */
 static struct lpfc_hbq_init lpfc_els_hbq = {
 	.rn = 1,
-	.entry_count = 200,
+	.entry_count = 256,
 	.mask_count = 0,
 	.profile = 0,
 	.ring_mask = (1 << LPFC_ELS_RING),
@@ -1482,8 +1482,11 @@ err:
 int
 lpfc_sli_hbqbuf_add_hbqs(struct lpfc_hba *phba, uint32_t qno)
 {
-	return(lpfc_sli_hbqbuf_fill_hbqs(phba, qno,
-					 lpfc_hbq_defs[qno]->add_count));
+	if (phba->sli_rev == LPFC_SLI_REV4)
+		return 0;
+	else
+		return lpfc_sli_hbqbuf_fill_hbqs(phba, qno,
+					 lpfc_hbq_defs[qno]->add_count);
 }
 
 /**
@@ -1498,8 +1501,12 @@ lpfc_sli_hbqbuf_add_hbqs(struct lpfc_hba *phba, uint32_t qno)
 static int
 lpfc_sli_hbqbuf_init_hbqs(struct lpfc_hba *phba, uint32_t qno)
 {
-	return(lpfc_sli_hbqbuf_fill_hbqs(phba, qno,
-					 lpfc_hbq_defs[qno]->init_count));
+	if (phba->sli_rev == LPFC_SLI_REV4)
+		return lpfc_sli_hbqbuf_fill_hbqs(phba, qno,
+					 lpfc_hbq_defs[qno]->entry_count);
+	else
+		return lpfc_sli_hbqbuf_fill_hbqs(phba, qno,
+					 lpfc_hbq_defs[qno]->init_count);
 }
 
 /**
@@ -4110,6 +4117,7 @@ lpfc_sli4_read_rev(struct lpfc_hba *phba, LPFC_MBOXQ_t *mboxq,
 	if (rc) {
 		dma_free_coherent(&phba->pcidev->dev, dma_size,
 				  dmabuf->virt, dmabuf->phys);
+		kfree(dmabuf);
 		return -EIO;
 	}
 
@@ -5848,7 +5856,6 @@ lpfc_sli4_iocb2wqe(struct lpfc_hba *phba, struct lpfc_iocbq *iocbq,
 					iocbq->iocb.un.ulpWord[3]);
 		wqe->generic.word3 = 0;
 		bf_set(wqe_rcvoxid, &wqe->generic, iocbq->iocb.ulpContext);
-		bf_set(wqe_xc, &wqe->generic, 1);
 		/* The entire sequence is transmitted for this IOCB */
 		xmit_len = total_len;
 		cmnd = CMD_XMIT_SEQUENCE64_CR;
@@ -10944,7 +10951,8 @@ lpfc_fc_frame_add(struct lpfc_vport *vport, struct hbq_dmabuf *dmabuf)
 		return dmabuf;
 	}
 	temp_hdr = seq_dmabuf->hbuf.virt;
-	if (new_hdr->fh_seq_cnt < temp_hdr->fh_seq_cnt) {
+	if (be16_to_cpu(new_hdr->fh_seq_cnt) <
+		be16_to_cpu(temp_hdr->fh_seq_cnt)) {
 		list_del_init(&seq_dmabuf->hbuf.list);
 		list_add_tail(&dmabuf->hbuf.list, &vport->rcv_buffer_list);
 		list_add_tail(&dmabuf->dbuf.list, &seq_dmabuf->dbuf.list);
@@ -10955,6 +10963,11 @@ lpfc_fc_frame_add(struct lpfc_vport *vport, struct hbq_dmabuf *dmabuf)
 	list_move_tail(&seq_dmabuf->hbuf.list, &vport->rcv_buffer_list);
 	seq_dmabuf->time_stamp = jiffies;
 	lpfc_update_rcv_time_stamp(vport);
+	if (list_empty(&seq_dmabuf->dbuf.list)) {
+		temp_hdr = dmabuf->hbuf.virt;
+		list_add_tail(&dmabuf->dbuf.list, &seq_dmabuf->dbuf.list);
+		return seq_dmabuf;
+	}
 	/* find the correct place in the sequence to insert this frame */
 	list_for_each_entry_reverse(d_buf, &seq_dmabuf->dbuf.list, list) {
 		temp_dmabuf = container_of(d_buf, struct hbq_dmabuf, dbuf);
@@ -10963,7 +10976,8 @@ lpfc_fc_frame_add(struct lpfc_vport *vport, struct hbq_dmabuf *dmabuf)
 		 * If the frame's sequence count is greater than the frame on
 		 * the list then insert the frame right after this frame
 		 */
-		if (new_hdr->fh_seq_cnt > temp_hdr->fh_seq_cnt) {
+		if (be16_to_cpu(new_hdr->fh_seq_cnt) >
+			be16_to_cpu(temp_hdr->fh_seq_cnt)) {
 			list_add(&dmabuf->dbuf.list, &temp_dmabuf->dbuf.list);
 			return seq_dmabuf;
 		}
@@ -11210,7 +11224,7 @@ lpfc_seq_complete(struct hbq_dmabuf *dmabuf)
 		seq_dmabuf = container_of(d_buf, struct hbq_dmabuf, dbuf);
 		hdr = (struct fc_frame_header *)seq_dmabuf->hbuf.virt;
 		/* If there is a hole in the sequence count then fail. */
-		if (++seq_count != hdr->fh_seq_cnt)
+		if (++seq_count != be16_to_cpu(hdr->fh_seq_cnt))
 			return 0;
 		fctl = (hdr->fh_f_ctl[0] << 16 |
 			hdr->fh_f_ctl[1] << 8 |
@@ -11242,6 +11256,7 @@ lpfc_prep_seq(struct lpfc_vport *vport, struct hbq_dmabuf *seq_dmabuf)
 	struct lpfc_iocbq *first_iocbq, *iocbq;
 	struct fc_frame_header *fc_hdr;
 	uint32_t sid;
+	struct ulp_bde64 *pbde;
 
 	fc_hdr = (struct fc_frame_header *)seq_dmabuf->hbuf.virt;
 	/* remove from receive buffer list */
@@ -11283,8 +11298,9 @@ lpfc_prep_seq(struct lpfc_vport *vport, struct hbq_dmabuf *seq_dmabuf)
 		if (!iocbq->context3) {
 			iocbq->context3 = d_buf;
 			iocbq->iocb.ulpBdeCount++;
-			iocbq->iocb.unsli3.rcvsli3.bde2.tus.f.bdeSize =
-							LPFC_DATA_BUF_SIZE;
+			pbde = (struct ulp_bde64 *)
+					&iocbq->iocb.unsli3.sli3Words[4];
+			pbde->tus.f.bdeSize = LPFC_DATA_BUF_SIZE;
 			first_iocbq->iocb.unsli3.rcvsli3.acc_len +=
 				bf_get(lpfc_rcqe_length,
 				       &seq_dmabuf->cq_event.cqe.rcqe_cmpl);
@@ -11401,15 +11417,9 @@ lpfc_sli4_handle_received_buffer(struct lpfc_hba *phba,
 		return;
 	}
 	/* If not last frame in sequence continue processing frames. */
-	if (!lpfc_seq_complete(seq_dmabuf)) {
-		/*
-		 * When saving off frames post a new one and mark this
-		 * frame to be freed when it is finished.
-		 **/
-		lpfc_sli_hbqbuf_fill_hbqs(phba, LPFC_ELS_HBQ, 1);
-		dmabuf->tag = -1;
+	if (!lpfc_seq_complete(seq_dmabuf))
 		return;
-	}
+
 	/* Send the complete sequence to the upper layer protocol */
 	lpfc_sli4_send_seq_to_ulp(vport, seq_dmabuf);
 }
diff --git a/drivers/scsi/lpfc/lpfc_sli4.h b/drivers/scsi/lpfc/lpfc_sli4.h
index 25d66d0..44e5f57 100644
--- a/drivers/scsi/lpfc/lpfc_sli4.h
+++ b/drivers/scsi/lpfc/lpfc_sli4.h
@@ -28,7 +28,7 @@
 /* Multi-queue arrangement for fast-path FCP work queues */
 #define LPFC_FN_EQN_MAX       8
 #define LPFC_SP_EQN_DEF       1
-#define LPFC_FP_EQN_DEF       1
+#define LPFC_FP_EQN_DEF       4
 #define LPFC_FP_EQN_MIN       1
 #define LPFC_FP_EQN_MAX       (LPFC_FN_EQN_MAX - LPFC_SP_EQN_DEF)
 
diff --git a/drivers/scsi/lpfc/lpfc_version.h b/drivers/scsi/lpfc/lpfc_version.h
index c7f3aed..792f722 100644
--- a/drivers/scsi/lpfc/lpfc_version.h
+++ b/drivers/scsi/lpfc/lpfc_version.h
@@ -18,7 +18,7 @@
  * included with this package.                                     *
  *******************************************************************/
 
-#define LPFC_DRIVER_VERSION "8.3.6"
+#define LPFC_DRIVER_VERSION "8.3.7"
 #define LPFC_DRIVER_NAME		"lpfc"
 #define LPFC_SP_DRIVER_HANDLER_NAME	"lpfc:sp"
 #define LPFC_FP_DRIVER_HANDLER_NAME	"lpfc:fp"
diff --git a/drivers/scsi/lpfc/lpfc_vport.c b/drivers/scsi/lpfc/lpfc_vport.c
index 7d6dd83..e3c7fa6 100644
--- a/drivers/scsi/lpfc/lpfc_vport.c
+++ b/drivers/scsi/lpfc/lpfc_vport.c
@@ -512,8 +512,10 @@ enable_vport(struct fc_vport *fc_vport)
 		return VPORT_OK;
 	}
 
+	spin_lock_irq(&phba->hbalock);
 	vport->load_flag |= FC_LOADING;
 	vport->fc_flag |= FC_VPORT_NEEDS_REG_VPI;
+	spin_unlock_irq(&phba->hbalock);
 
 	/* Use the Physical nodes Fabric NDLP to determine if the link is
 	 * up and ready to FDISC.
@@ -700,7 +702,7 @@ lpfc_vport_delete(struct fc_vport *fc_vport)
 			}
 			spin_unlock_irq(&phba->ndlp_lock);
 		}
-		if (vport->vpi_state != LPFC_VPI_REGISTERED)
+		if (!(vport->vpi_state & LPFC_VPI_REGISTERED))
 			goto skip_logo;
 		vport->unreg_vpi_cmpl = VPORT_INVAL;
 		timeout = msecs_to_jiffies(phba->fc_ratov * 2000);
diff --git a/drivers/scsi/pmcraid.c b/drivers/scsi/pmcraid.c
index e7d2688..b6f1ef9 100644
--- a/drivers/scsi/pmcraid.c
+++ b/drivers/scsi/pmcraid.c
@@ -2483,14 +2483,12 @@ static int pmcraid_error_handler(struct pmcraid_cmd *cmd)
 			sense_copied = 1;
 		}
 
-		if (RES_IS_GSCSI(res->cfg_entry)) {
+		if (RES_IS_GSCSI(res->cfg_entry))
 			pmcraid_cancel_all(cmd, sense_copied);
-		} else if (sense_copied) {
+		else if (sense_copied)
 			pmcraid_erp_done(cmd);
-			return 0;
-		} else  {
+		else
 			pmcraid_request_sense(cmd);
-		}
 
 		return 1;
 
diff --git a/drivers/scsi/qla2xxx/qla_attr.c b/drivers/scsi/qla2xxx/qla_attr.c
index 21e2bc4..3a9f5b2 100644
--- a/drivers/scsi/qla2xxx/qla_attr.c
+++ b/drivers/scsi/qla2xxx/qla_attr.c
@@ -232,6 +232,9 @@ qla2x00_sysfs_write_optrom_ctl(struct kobject *kobj,
 	if (off)
 		return 0;
 
+	if (unlikely(pci_channel_offline(ha->pdev)))
+		return 0;
+
 	if (sscanf(buf, "%d:%x:%x", &val, &start, &size) < 1)
 		return -EINVAL;
 	if (start > ha->optrom_size)
@@ -379,6 +382,9 @@ qla2x00_sysfs_read_vpd(struct kobject *kobj,
 	    struct device, kobj)));
 	struct qla_hw_data *ha = vha->hw;
 
+	if (unlikely(pci_channel_offline(ha->pdev)))
+		return 0;
+
 	if (!capable(CAP_SYS_ADMIN))
 		return 0;
 
@@ -398,6 +404,9 @@ qla2x00_sysfs_write_vpd(struct kobject *kobj,
 	struct qla_hw_data *ha = vha->hw;
 	uint8_t *tmp_data;
 
+	if (unlikely(pci_channel_offline(ha->pdev)))
+		return 0;
+
 	if (!capable(CAP_SYS_ADMIN) || off != 0 || count != ha->vpd_size ||
 	    !ha->isp_ops->write_nvram)
 		return 0;
@@ -1238,10 +1247,11 @@ qla2x00_fw_state_show(struct device *dev, struct device_attribute *attr,
     char *buf)
 {
 	scsi_qla_host_t *vha = shost_priv(class_to_shost(dev));
-	int rval;
+	int rval = QLA_FUNCTION_FAILED;
 	uint16_t state[5];
 
-	rval = qla2x00_get_firmware_state(vha, state);
+	if (!vha->hw->flags.eeh_busy)
+		rval = qla2x00_get_firmware_state(vha, state);
 	if (rval != QLA_SUCCESS)
 		memset(state, -1, sizeof(state));
 
@@ -1452,10 +1462,13 @@ qla2x00_dev_loss_tmo_callbk(struct fc_rport *rport)
 	if (!fcport)
 		return;
 
-	if (unlikely(pci_channel_offline(fcport->vha->hw->pdev)))
+	if (test_bit(ABORT_ISP_ACTIVE, &fcport->vha->dpc_flags))
+		return;
+
+	if (unlikely(pci_channel_offline(fcport->vha->hw->pdev))) {
 		qla2x00_abort_all_cmds(fcport->vha, DID_NO_CONNECT << 16);
-	else
-		qla2x00_abort_fcport_cmds(fcport);
+		return;
+	}
 
 	/*
 	 * Transport has effectively 'deleted' the rport, clear
@@ -1475,6 +1488,9 @@ qla2x00_terminate_rport_io(struct fc_rport *rport)
 	if (!fcport)
 		return;
 
+	if (test_bit(ABORT_ISP_ACTIVE, &fcport->vha->dpc_flags))
+		return;
+
 	if (unlikely(pci_channel_offline(fcport->vha->hw->pdev))) {
 		qla2x00_abort_all_cmds(fcport->vha, DID_NO_CONNECT << 16);
 		return;
@@ -1515,6 +1531,12 @@ qla2x00_get_fc_host_stats(struct Scsi_Host *shost)
 	pfc_host_stat = &ha->fc_host_stat;
 	memset(pfc_host_stat, -1, sizeof(struct fc_host_statistics));
 
+	if (test_bit(UNLOADING, &vha->dpc_flags))
+		goto done;
+
+	if (unlikely(pci_channel_offline(ha->pdev)))
+		goto done;
+
 	stats = dma_pool_alloc(ha->s_dma_pool, GFP_KERNEL, &stats_dma);
 	if (stats == NULL) {
 		DEBUG2_3_11(printk("%s(%ld): Failed to allocate memory.\n",
diff --git a/drivers/scsi/qla2xxx/qla_dbg.h b/drivers/scsi/qla2xxx/qla_dbg.h
index f660dd7..d6d9c86 100644
--- a/drivers/scsi/qla2xxx/qla_dbg.h
+++ b/drivers/scsi/qla2xxx/qla_dbg.h
@@ -26,7 +26,7 @@
 /* #define QL_DEBUG_LEVEL_14 */ /* Output RSCN trace msgs */
 /* #define QL_DEBUG_LEVEL_15 */ /* Output NPIV trace msgs */
 /* #define QL_DEBUG_LEVEL_16 */ /* Output ISP84XX trace msgs */
-/* #define QL_DEBUG_LEVEL_17 */ /* Output MULTI-Q trace messages */
+/* #define QL_DEBUG_LEVEL_17 */ /* Output EEH trace messages */
 
 /*
 * Macros use for debugging the driver.
@@ -132,6 +132,13 @@
 #else
 #define DEBUG16(x)	do {} while (0)
 #endif
+
+#if defined(QL_DEBUG_LEVEL_17)
+#define DEBUG17(x)	do {x;} while (0)
+#else
+#define DEBUG17(x)	do {} while (0)
+#endif
+
 /*
  * Firmware Dump structure definition
  */
diff --git a/drivers/scsi/qla2xxx/qla_def.h b/drivers/scsi/qla2xxx/qla_def.h
index 384afda..608e675 100644
--- a/drivers/scsi/qla2xxx/qla_def.h
+++ b/drivers/scsi/qla2xxx/qla_def.h
@@ -2256,11 +2256,13 @@ struct qla_hw_data {
 		uint32_t	disable_serdes		:1;
 		uint32_t	gpsc_supported		:1;
 		uint32_t	npiv_supported		:1;
+		uint32_t	pci_channel_io_perm_failure	:1;
 		uint32_t	fce_enabled		:1;
 		uint32_t	fac_supported		:1;
 		uint32_t	chip_reset_done		:1;
 		uint32_t	port0			:1;
 		uint32_t	running_gold_fw		:1;
+		uint32_t	eeh_busy		:1;
 		uint32_t	cpu_affinity_enabled	:1;
 		uint32_t	disable_msix_handshake	:1;
 	} flags;
diff --git a/drivers/scsi/qla2xxx/qla_gbl.h b/drivers/scsi/qla2xxx/qla_gbl.h
index 0b6801f..f61fb8d 100644
--- a/drivers/scsi/qla2xxx/qla_gbl.h
+++ b/drivers/scsi/qla2xxx/qla_gbl.h
@@ -324,6 +324,7 @@ qla2x00_read_ram_word(scsi_qla_host_t *, uint32_t, uint32_t *);
 extern int
 qla2x00_write_ram_word(scsi_qla_host_t *, uint32_t, uint32_t);
 
+extern int qla2x00_get_data_rate(scsi_qla_host_t *);
 /*
  * Global Function Prototypes in qla_isr.c source file.
  */
diff --git a/drivers/scsi/qla2xxx/qla_init.c b/drivers/scsi/qla2xxx/qla_init.c
index 73a7935..b4a0eac 100644
--- a/drivers/scsi/qla2xxx/qla_init.c
+++ b/drivers/scsi/qla2xxx/qla_init.c
@@ -269,6 +269,8 @@ qla2x00_initialize_adapter(scsi_qla_host_t *vha)
 	vha->flags.online = 0;
 	ha->flags.chip_reset_done = 0;
 	vha->flags.reset_active = 0;
+	ha->flags.pci_channel_io_perm_failure = 0;
+	ha->flags.eeh_busy = 0;
 	atomic_set(&vha->loop_down_timer, LOOP_DOWN_TIME);
 	atomic_set(&vha->loop_state, LOOP_DOWN);
 	vha->device_flags = DFLG_NO_CABLE;
@@ -581,6 +583,9 @@ qla2x00_reset_chip(scsi_qla_host_t *vha)
 	uint32_t	cnt;
 	uint16_t	cmd;
 
+	if (unlikely(pci_channel_offline(ha->pdev)))
+		return;
+
 	ha->isp_ops->disable_intrs(ha);
 
 	spin_lock_irqsave(&ha->hardware_lock, flags);
@@ -786,6 +791,12 @@ void
 qla24xx_reset_chip(scsi_qla_host_t *vha)
 {
 	struct qla_hw_data *ha = vha->hw;
+
+	if (pci_channel_offline(ha->pdev) &&
+	    ha->flags.pci_channel_io_perm_failure) {
+		return;
+	}
+
 	ha->isp_ops->disable_intrs(ha);
 
 	/* Perform RISC reset. */
@@ -2266,6 +2277,8 @@ qla2x00_configure_loop(scsi_qla_host_t *vha)
 	clear_bit(LOCAL_LOOP_UPDATE, &vha->dpc_flags);
 	clear_bit(RSCN_UPDATE, &vha->dpc_flags);
 
+	qla2x00_get_data_rate(vha);
+
 	/* Determine what we need to do */
 	if (ha->current_topology == ISP_CFG_FL &&
 	    (test_bit(LOCAL_LOOP_UPDATE, &flags))) {
@@ -3560,6 +3573,13 @@ qla2x00_abort_isp(scsi_qla_host_t *vha)
 		/* Requeue all commands in outstanding command list. */
 		qla2x00_abort_all_cmds(vha, DID_RESET << 16);
 
+		if (unlikely(pci_channel_offline(ha->pdev) &&
+		    ha->flags.pci_channel_io_perm_failure)) {
+			clear_bit(ISP_ABORT_RETRY, &vha->dpc_flags);
+			status = 0;
+			return status;
+		}
+
 		ha->isp_ops->get_flash_version(vha, req->ring);
 
 		ha->isp_ops->nvram_config(vha);
@@ -4458,6 +4478,8 @@ qla2x00_try_to_stop_firmware(scsi_qla_host_t *vha)
 	int ret, retries;
 	struct qla_hw_data *ha = vha->hw;
 
+	if (ha->flags.pci_channel_io_perm_failure)
+		return;
 	if (!IS_FWI2_CAPABLE(ha))
 		return;
 	if (!ha->fw_major_version)
diff --git a/drivers/scsi/qla2xxx/qla_isr.c b/drivers/scsi/qla2xxx/qla_isr.c
index 1692a88..ffd0efd 100644
--- a/drivers/scsi/qla2xxx/qla_isr.c
+++ b/drivers/scsi/qla2xxx/qla_isr.c
@@ -152,7 +152,7 @@ qla2300_intr_handler(int irq, void *dev_id)
 	for (iter = 50; iter--; ) {
 		stat = RD_REG_DWORD(&reg->u.isp2300.host_status);
 		if (stat & HSR_RISC_PAUSED) {
-			if (pci_channel_offline(ha->pdev))
+			if (unlikely(pci_channel_offline(ha->pdev)))
 				break;
 
 			hccr = RD_REG_WORD(&reg->hccr);
@@ -1846,12 +1846,15 @@ qla24xx_intr_handler(int irq, void *dev_id)
 	reg = &ha->iobase->isp24;
 	status = 0;
 
+	if (unlikely(pci_channel_offline(ha->pdev)))
+		return IRQ_HANDLED;
+
 	spin_lock_irqsave(&ha->hardware_lock, flags);
 	vha = pci_get_drvdata(ha->pdev);
 	for (iter = 50; iter--; ) {
 		stat = RD_REG_DWORD(&reg->host_status);
 		if (stat & HSRX_RISC_PAUSED) {
-			if (pci_channel_offline(ha->pdev))
+			if (unlikely(pci_channel_offline(ha->pdev)))
 				break;
 
 			hccr = RD_REG_DWORD(&reg->hccr);
@@ -1992,7 +1995,7 @@ qla24xx_msix_default(int irq, void *dev_id)
 	do {
 		stat = RD_REG_DWORD(&reg->host_status);
 		if (stat & HSRX_RISC_PAUSED) {
-			if (pci_channel_offline(ha->pdev))
+			if (unlikely(pci_channel_offline(ha->pdev)))
 				break;
 
 			hccr = RD_REG_DWORD(&reg->hccr);
diff --git a/drivers/scsi/qla2xxx/qla_mbx.c b/drivers/scsi/qla2xxx/qla_mbx.c
index 05d595d..056e4d4 100644
--- a/drivers/scsi/qla2xxx/qla_mbx.c
+++ b/drivers/scsi/qla2xxx/qla_mbx.c
@@ -56,6 +56,12 @@ qla2x00_mailbox_command(scsi_qla_host_t *vha, mbx_cmd_t *mcp)
 
 	DEBUG11(printk("%s(%ld): entered.\n", __func__, base_vha->host_no));
 
+	if (ha->flags.pci_channel_io_perm_failure) {
+		DEBUG(printk("%s(%ld): Perm failure on EEH, timeout MBX "
+			     "Exiting.\n", __func__, vha->host_no));
+		return QLA_FUNCTION_TIMEOUT;
+	}
+
 	/*
 	 * Wait for active mailbox commands to finish by waiting at most tov
 	 * seconds. This is to serialize actual issuing of mailbox cmds during
@@ -154,10 +160,14 @@ qla2x00_mailbox_command(scsi_qla_host_t *vha, mbx_cmd_t *mcp)
 			/* Check for pending interrupts. */
 			qla2x00_poll(ha->rsp_q_map[0]);
 
-			if (command != MBC_LOAD_RISC_RAM_EXTENDED &&
-			    !ha->flags.mbox_int)
+			if (!ha->flags.mbox_int &&
+			    !(IS_QLA2200(ha) &&
+			    command == MBC_LOAD_RISC_RAM_EXTENDED))
 				msleep(10);
 		} /* while */
+		DEBUG17(qla_printk(KERN_WARNING, ha,
+			"Waited %d sec\n",
+			(uint)((jiffies - (wait_time - (mcp->tov * HZ)))/HZ)));
 	}
 
 	/* Check whether we timed out */
@@ -227,7 +237,8 @@ qla2x00_mailbox_command(scsi_qla_host_t *vha, mbx_cmd_t *mcp)
 
 	if (rval == QLA_FUNCTION_TIMEOUT &&
 	    mcp->mb[0] != MBC_GEN_SYSTEM_ERROR) {
-		if (!io_lock_on || (mcp->flags & IOCTL_CMD)) {
+		if (!io_lock_on || (mcp->flags & IOCTL_CMD) ||
+		    ha->flags.eeh_busy) {
 			/* not in dpc. schedule it for dpc to take over. */
 			DEBUG(printk("%s(%ld): timeout schedule "
 			"isp_abort_needed.\n", __func__,
@@ -237,7 +248,7 @@ qla2x00_mailbox_command(scsi_qla_host_t *vha, mbx_cmd_t *mcp)
 			base_vha->host_no));
 			qla_printk(KERN_WARNING, ha,
 			    "Mailbox command timeout occurred. Scheduling ISP "
-			    "abort.\n");
+			    "abort. eeh_busy: 0x%x\n", ha->flags.eeh_busy);
 			set_bit(ISP_ABORT_NEEDED, &base_vha->dpc_flags);
 			qla2xxx_wake_dpc(vha);
 		} else if (!abort_active) {
@@ -2530,6 +2541,9 @@ qla2x00_enable_eft_trace(scsi_qla_host_t *vha, dma_addr_t eft_dma,
 	if (!IS_FWI2_CAPABLE(vha->hw))
 		return QLA_FUNCTION_FAILED;
 
+	if (unlikely(pci_channel_offline(vha->hw->pdev)))
+		return QLA_FUNCTION_FAILED;
+
 	DEBUG11(printk("%s(%ld): entered.\n", __func__, vha->host_no));
 
 	mcp->mb[0] = MBC_TRACE_CONTROL;
@@ -2565,6 +2579,9 @@ qla2x00_disable_eft_trace(scsi_qla_host_t *vha)
 	if (!IS_FWI2_CAPABLE(vha->hw))
 		return QLA_FUNCTION_FAILED;
 
+	if (unlikely(pci_channel_offline(vha->hw->pdev)))
+		return QLA_FUNCTION_FAILED;
+
 	DEBUG11(printk("%s(%ld): entered.\n", __func__, vha->host_no));
 
 	mcp->mb[0] = MBC_TRACE_CONTROL;
@@ -2595,6 +2612,9 @@ qla2x00_enable_fce_trace(scsi_qla_host_t *vha, dma_addr_t fce_dma,
 	if (!IS_QLA25XX(vha->hw) && !IS_QLA81XX(vha->hw))
 		return QLA_FUNCTION_FAILED;
 
+	if (unlikely(pci_channel_offline(vha->hw->pdev)))
+		return QLA_FUNCTION_FAILED;
+
 	DEBUG11(printk("%s(%ld): entered.\n", __func__, vha->host_no));
 
 	mcp->mb[0] = MBC_TRACE_CONTROL;
@@ -2639,6 +2659,9 @@ qla2x00_disable_fce_trace(scsi_qla_host_t *vha, uint64_t *wr, uint64_t *rd)
 	if (!IS_FWI2_CAPABLE(vha->hw))
 		return QLA_FUNCTION_FAILED;
 
+	if (unlikely(pci_channel_offline(vha->hw->pdev)))
+		return QLA_FUNCTION_FAILED;
+
 	DEBUG11(printk("%s(%ld): entered.\n", __func__, vha->host_no));
 
 	mcp->mb[0] = MBC_TRACE_CONTROL;
@@ -3643,3 +3666,36 @@ qla2x00_write_ram_word(scsi_qla_host_t *vha, uint32_t risc_addr, uint32_t data)
 
 	return rval;
 }
+
+int
+qla2x00_get_data_rate(scsi_qla_host_t *vha)
+{
+	int rval;
+	mbx_cmd_t mc;
+	mbx_cmd_t *mcp = &mc;
+	struct qla_hw_data *ha = vha->hw;
+
+	if (!IS_FWI2_CAPABLE(ha))
+		return QLA_FUNCTION_FAILED;
+
+	DEBUG11(printk(KERN_INFO "%s(%ld): entered.\n", __func__, vha->host_no));
+
+	mcp->mb[0] = MBC_DATA_RATE;
+	mcp->mb[1] = 0;
+	mcp->out_mb = MBX_1|MBX_0;
+	mcp->in_mb = MBX_2|MBX_1|MBX_0;
+	mcp->tov = MBX_TOV_SECONDS;
+	mcp->flags = 0;
+	rval = qla2x00_mailbox_command(vha, mcp);
+	if (rval != QLA_SUCCESS) {
+		DEBUG2_3_11(printk(KERN_INFO "%s(%ld): failed=%x mb[0]=%x.\n",
+		    __func__, vha->host_no, rval, mcp->mb[0]));
+	} else {
+		DEBUG11(printk(KERN_INFO
+		    "%s(%ld): done.\n", __func__, vha->host_no));
+		if (mcp->mb[1] != 0x7)
+			ha->link_data_rate = mcp->mb[1];
+	}
+
+	return rval;
+}
diff --git a/drivers/scsi/qla2xxx/qla_mid.c b/drivers/scsi/qla2xxx/qla_mid.c
index 2a4c7f4..b901aa2 100644
--- a/drivers/scsi/qla2xxx/qla_mid.c
+++ b/drivers/scsi/qla2xxx/qla_mid.c
@@ -639,8 +639,10 @@ static void qla_do_work(struct work_struct *work)
 	struct rsp_que *rsp = container_of(work, struct rsp_que, q_work);
 	struct scsi_qla_host *vha;
 
+	spin_lock_irq(&rsp->hw->hardware_lock);
 	vha = qla25xx_get_host(rsp);
 	qla24xx_process_response_queue(vha, rsp);
+	spin_unlock_irq(&rsp->hw->hardware_lock);
 }
 
 /* create response queue */
diff --git a/drivers/scsi/qla2xxx/qla_os.c b/drivers/scsi/qla2xxx/qla_os.c
index 2f873d2..209f50e 100644
--- a/drivers/scsi/qla2xxx/qla_os.c
+++ b/drivers/scsi/qla2xxx/qla_os.c
@@ -475,11 +475,11 @@ qla2xxx_queuecommand(struct scsi_cmnd *cmd, void (*done)(struct scsi_cmnd *))
 	srb_t *sp;
 	int rval;
 
-	if (unlikely(pci_channel_offline(ha->pdev))) {
-		if (ha->pdev->error_state == pci_channel_io_frozen)
-			cmd->result = DID_REQUEUE << 16;
-		else
+	if (ha->flags.eeh_busy) {
+		if (ha->flags.pci_channel_io_perm_failure)
 			cmd->result = DID_NO_CONNECT << 16;
+		else
+			cmd->result = DID_REQUEUE << 16;
 		goto qc24_fail_command;
 	}
 
@@ -552,8 +552,15 @@ qla2x00_eh_wait_on_command(struct scsi_cmnd *cmd)
 #define ABORT_POLLING_PERIOD	1000
 #define ABORT_WAIT_ITER		((10 * 1000) / (ABORT_POLLING_PERIOD))
 	unsigned long wait_iter = ABORT_WAIT_ITER;
+	scsi_qla_host_t *vha = shost_priv(cmd->device->host);
+	struct qla_hw_data *ha = vha->hw;
 	int ret = QLA_SUCCESS;
 
+	if (unlikely(pci_channel_offline(ha->pdev)) || ha->flags.eeh_busy) {
+		DEBUG17(qla_printk(KERN_WARNING, ha, "return:eh_wait\n"));
+		return ret;
+	}
+
 	while (CMD_SP(cmd) && wait_iter--) {
 		msleep(ABORT_POLLING_PERIOD);
 	}
@@ -1810,6 +1817,13 @@ qla2x00_probe_one(struct pci_dev *pdev, const struct pci_device_id *id)
 
 	/* Set ISP-type information. */
 	qla2x00_set_isp_flags(ha);
+
+	/* Set EEH reset type to fundamental if required by hba */
+	if ( IS_QLA24XX(ha) || IS_QLA25XX(ha) || IS_QLA81XX(ha)) {
+		pdev->needs_freset = 1;
+		pci_save_state(pdev);
+	}
+
 	/* Configure PCI I/O space */
 	ret = qla2x00_iospace_config(ha);
 	if (ret)
@@ -2174,6 +2188,24 @@ qla2x00_free_device(scsi_qla_host_t *vha)
 {
 	struct qla_hw_data *ha = vha->hw;
 
+	qla2x00_abort_all_cmds(vha, DID_NO_CONNECT << 16);
+
+	/* Disable timer */
+	if (vha->timer_active)
+		qla2x00_stop_timer(vha);
+
+	/* Kill the kernel thread for this host */
+	if (ha->dpc_thread) {
+		struct task_struct *t = ha->dpc_thread;
+
+		/*
+		 * qla2xxx_wake_dpc checks for ->dpc_thread
+		 * so we need to zero it out.
+		 */
+		ha->dpc_thread = NULL;
+		kthread_stop(t);
+	}
+
 	qla25xx_delete_queues(vha);
 
 	if (ha->flags.fce_enabled)
@@ -2185,6 +2217,8 @@ qla2x00_free_device(scsi_qla_host_t *vha)
 	/* Stop currently executing firmware. */
 	qla2x00_try_to_stop_firmware(vha);
 
+	vha->flags.online = 0;
+
 	/* turn-off interrupts on the card */
 	if (ha->interrupts_on)
 		ha->isp_ops->disable_intrs(ha);
@@ -2859,6 +2893,13 @@ qla2x00_do_dpc(void *data)
 		if (!base_vha->flags.init_done)
 			continue;
 
+		if (ha->flags.eeh_busy) {
+			DEBUG17(qla_printk(KERN_WARNING, ha,
+			    "qla2x00_do_dpc: dpc_flags: %lx\n",
+			    base_vha->dpc_flags));
+			continue;
+		}
+
 		DEBUG3(printk("scsi(%ld): DPC handler\n", base_vha->host_no));
 
 		ha->dpc_active = 1;
@@ -3049,8 +3090,13 @@ qla2x00_timer(scsi_qla_host_t *vha)
 	int		index;
 	srb_t		*sp;
 	int		t;
+	uint16_t        w;
 	struct qla_hw_data *ha = vha->hw;
 	struct req_que *req;
+
+	/* Hardware read to raise pending EEH errors during mailbox waits. */
+	if (!pci_channel_offline(ha->pdev))
+		pci_read_config_word(ha->pdev, PCI_VENDOR_ID, &w);
 	/*
 	 * Ports - Port down timer.
 	 *
@@ -3252,16 +3298,23 @@ qla2x00_release_firmware(void)
 static pci_ers_result_t
 qla2xxx_pci_error_detected(struct pci_dev *pdev, pci_channel_state_t state)
 {
-	scsi_qla_host_t *base_vha = pci_get_drvdata(pdev);
+	scsi_qla_host_t *vha = pci_get_drvdata(pdev);
+	struct qla_hw_data *ha = vha->hw;
+
+	DEBUG2(qla_printk(KERN_WARNING, ha, "error_detected:state %x\n",
+	    state));
 
 	switch (state) {
 	case pci_channel_io_normal:
+		ha->flags.eeh_busy = 0;
 		return PCI_ERS_RESULT_CAN_RECOVER;
 	case pci_channel_io_frozen:
+		ha->flags.eeh_busy = 1;
 		pci_disable_device(pdev);
 		return PCI_ERS_RESULT_NEED_RESET;
 	case pci_channel_io_perm_failure:
-		qla2x00_abort_all_cmds(base_vha, DID_NO_CONNECT << 16);
+		ha->flags.pci_channel_io_perm_failure = 1;
+		qla2x00_abort_all_cmds(vha, DID_NO_CONNECT << 16);
 		return PCI_ERS_RESULT_DISCONNECT;
 	}
 	return PCI_ERS_RESULT_NEED_RESET;
@@ -3312,6 +3365,8 @@ qla2xxx_pci_slot_reset(struct pci_dev *pdev)
 	struct qla_hw_data *ha = base_vha->hw;
 	int rc;
 
+	DEBUG17(qla_printk(KERN_WARNING, ha, "slot_reset\n"));
+
 	if (ha->mem_only)
 		rc = pci_enable_device_mem(pdev);
 	else
@@ -3320,19 +3375,33 @@ qla2xxx_pci_slot_reset(struct pci_dev *pdev)
 	if (rc) {
 		qla_printk(KERN_WARNING, ha,
 		    "Can't re-enable PCI device after reset.\n");
-
 		return ret;
 	}
-	pci_set_master(pdev);
 
 	if (ha->isp_ops->pci_config(base_vha))
 		return ret;
 
+#ifdef QL_DEBUG_LEVEL_17
+	{
+		uint8_t b;
+		uint32_t i;
+
+		printk("slot_reset_1: ");
+		for (i = 0; i < 256; i++) {
+			pci_read_config_byte(ha->pdev, i, &b);
+			printk("%s%02x", (i%16) ? " " : "\n", b);
+		}
+		printk("\n");
+	}
+#endif
 	set_bit(ABORT_ISP_ACTIVE, &base_vha->dpc_flags);
 	if (qla2x00_abort_isp(base_vha) == QLA_SUCCESS)
 		ret =  PCI_ERS_RESULT_RECOVERED;
 	clear_bit(ABORT_ISP_ACTIVE, &base_vha->dpc_flags);
 
+	DEBUG17(qla_printk(KERN_WARNING, ha,
+	    "slot_reset-return:ret=%x\n", ret));
+
 	return ret;
 }
 
@@ -3343,12 +3412,17 @@ qla2xxx_pci_resume(struct pci_dev *pdev)
 	struct qla_hw_data *ha = base_vha->hw;
 	int ret;
 
+	DEBUG17(qla_printk(KERN_WARNING, ha, "pci_resume\n"));
+
 	ret = qla2x00_wait_for_hba_online(base_vha);
 	if (ret != QLA_SUCCESS) {
 		qla_printk(KERN_ERR, ha,
 		    "the device failed to resume I/O "
 		    "from slot/link_reset");
 	}
+
+	ha->flags.eeh_busy = 0;
+
 	pci_cleanup_aer_uncorrect_error_status(pdev);
 }
 
diff --git a/drivers/scsi/qla2xxx/qla_version.h b/drivers/scsi/qla2xxx/qla_version.h
index c482220..a65dd95 100644
--- a/drivers/scsi/qla2xxx/qla_version.h
+++ b/drivers/scsi/qla2xxx/qla_version.h
@@ -7,7 +7,7 @@
 /*
  * Driver version
  */
-#define QLA2XXX_VERSION      "8.03.01-k8"
+#define QLA2XXX_VERSION      "8.03.01-k9"
 
 #define QLA_DRIVER_MAJOR_VER	8
 #define QLA_DRIVER_MINOR_VER	3
diff --git a/drivers/scsi/stex.c b/drivers/scsi/stex.c
index 3058bb1..fd7b15b 100644
--- a/drivers/scsi/stex.c
+++ b/drivers/scsi/stex.c
@@ -623,6 +623,11 @@ stex_queuecommand(struct scsi_cmnd *cmd, void (* done)(struct scsi_cmnd *))
 		}
 		break;
 	case INQUIRY:
+		if (lun >= host->max_lun) {
+			cmd->result = DID_NO_CONNECT << 16;
+			done(cmd);
+			return 0;
+		}
 		if (id != host->max_id - 1)
 			break;
 		if (!lun && !cmd->device->channel &&


