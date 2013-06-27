From: James Bottomley <James.Bottomley@HansenPartnership.com>
Subject: [GIT PULL] SCSI fixes for 3.10-rc7
Date: Wed, 26 Jun 2013 23:25:23 -0700
Message-ID: <1372314323.557.26.camel@dabdike>
Mime-Version: 1.0
Content-Type: text/plain; charset="ISO-8859-15"
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner@vger.kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
To: Andrew Morton <akpm@linux-foundation.org>, Linus Torvalds <torvalds@linux-foundation.org>
Cc: linux-scsi <linux-scsi@vger.kernel.org>, linux-kernel <linux-kernel@vger.kernel.org>
List-Id: linux-scsi@vger.kernel.org

This is  a set of seven bug fixes.  Several fcoe fixes for locking
problems, initiator issues and a VLAN API change, all of which could
eventually lead to data corruption, one fix for a qla2xxx locking
problem which could lead to multiple completions of the same request
(and subsequent data corruption) and a use after free in the ipr driver.
Plus one minor MAINTAINERS file update for a mailing list change.

The patch is available here:

git://git.kernel.org/pub/scm/linux/kernel/git/jejb/scsi.git scsi-fixes

The short changelog is:

Krishna Mohan (1):
      libfcoe: Fix Conflicting FCFs issue in the fabric

Mark Rustad (1):
      libfc: Correct check for initiator role

Neil Horman (2):
      MAINTAINERS: Fix fcoe mailing list
      libfc: extend ex_lock to protect all of fc_seq_send

Robert Love (1):
      fcoe: Use correct API to set vlan tag for FCoE Ethertype skbs

gurinder.shergill@hp.com (1):
      qla2xxx: Fix for locking issue between driver ISR and mailbox routines

wenxiong@linux.vnet.ibm.com (1):
      ipr: Avoid target_destroy accessing memory after it was freed

And the diffstat:

 MAINTAINERS                       |  2 +-
 drivers/scsi/fcoe/fcoe.c          |  7 +++++--
 drivers/scsi/fcoe/fcoe_ctlr.c     | 15 +++++----------
 drivers/scsi/ipr.c                | 16 ----------------
 drivers/scsi/ipr.h                |  6 +++---
 drivers/scsi/libfc/fc_exch.c      | 37 ++++++++++++++++++++++++-------------
 drivers/scsi/libfc/fc_rport.c     |  2 +-
 drivers/scsi/qla2xxx/qla_inline.h | 11 +++++++++++
 drivers/scsi/qla2xxx/qla_isr.c    | 27 ++++-----------------------
 drivers/scsi/qla2xxx/qla_mbx.c    |  2 --
 drivers/scsi/qla2xxx/qla_mr.c     | 10 ++--------
 drivers/scsi/qla2xxx/qla_nx.c     | 26 ++++++++++----------------
 12 files changed, 66 insertions(+), 95 deletions(-)

Full diff is below

James

---

diff --git a/MAINTAINERS b/MAINTAINERS
index 5be702c..ad7e322 100644
--- a/MAINTAINERS
+++ b/MAINTAINERS
@@ -3220,7 +3220,7 @@ F:	lib/fault-inject.c
 
 FCOE SUBSYSTEM (libfc, libfcoe, fcoe)
 M:	Robert Love <robert.w.love@intel.com>
-L:	devel@open-fcoe.org
+L:	fcoe-devel@open-fcoe.org
 W:	www.Open-FCoE.org
 S:	Supported
 F:	drivers/scsi/libfc/
diff --git a/drivers/scsi/fcoe/fcoe.c b/drivers/scsi/fcoe/fcoe.c
index 292b24f..32ae6c6 100644
--- a/drivers/scsi/fcoe/fcoe.c
+++ b/drivers/scsi/fcoe/fcoe.c
@@ -1656,9 +1656,12 @@ static int fcoe_xmit(struct fc_lport *lport, struct fc_frame *fp)
 
 	if (fcoe->netdev->priv_flags & IFF_802_1Q_VLAN &&
 	    fcoe->realdev->features & NETIF_F_HW_VLAN_CTAG_TX) {
-		skb->vlan_tci = VLAN_TAG_PRESENT |
-				vlan_dev_vlan_id(fcoe->netdev);
+		/* must set skb->dev before calling vlan_put_tag */
 		skb->dev = fcoe->realdev;
+		skb = __vlan_hwaccel_put_tag(skb, htons(ETH_P_8021Q),
+					     vlan_dev_vlan_id(fcoe->netdev));
+		if (!skb)
+			return -ENOMEM;
 	} else
 		skb->dev = fcoe->netdev;
 
diff --git a/drivers/scsi/fcoe/fcoe_ctlr.c b/drivers/scsi/fcoe/fcoe_ctlr.c
index cd743c5..795843d 100644
--- a/drivers/scsi/fcoe/fcoe_ctlr.c
+++ b/drivers/scsi/fcoe/fcoe_ctlr.c
@@ -1548,9 +1548,6 @@ static struct fcoe_fcf *fcoe_ctlr_select(struct fcoe_ctlr *fip)
 {
 	struct fcoe_fcf *fcf;
 	struct fcoe_fcf *best = fip->sel_fcf;
-	struct fcoe_fcf *first;
-
-	first = list_first_entry(&fip->fcfs, struct fcoe_fcf, list);
 
 	list_for_each_entry(fcf, &fip->fcfs, list) {
 		LIBFCOE_FIP_DBG(fip, "consider FCF fab %16.16llx "
@@ -1568,17 +1565,15 @@ static struct fcoe_fcf *fcoe_ctlr_select(struct fcoe_ctlr *fip)
 					"" : "un");
 			continue;
 		}
-		if (fcf->fabric_name != first->fabric_name ||
-		    fcf->vfid != first->vfid ||
-		    fcf->fc_map != first->fc_map) {
+		if (!best || fcf->pri < best->pri || best->flogi_sent)
+			best = fcf;
+		if (fcf->fabric_name != best->fabric_name ||
+		    fcf->vfid != best->vfid ||
+		    fcf->fc_map != best->fc_map) {
 			LIBFCOE_FIP_DBG(fip, "Conflicting fabric, VFID, "
 					"or FC-MAP\n");
 			return NULL;
 		}
-		if (fcf->flogi_sent)
-			continue;
-		if (!best || fcf->pri < best->pri || best->flogi_sent)
-			best = fcf;
 	}
 	fip->sel_fcf = best;
 	if (best) {
diff --git a/drivers/scsi/ipr.c b/drivers/scsi/ipr.c
index 82a3c1e..6c4cedb 100644
--- a/drivers/scsi/ipr.c
+++ b/drivers/scsi/ipr.c
@@ -8980,19 +8980,6 @@ static int ipr_alloc_mem(struct ipr_ioa_cfg *ioa_cfg)
 	if (!ioa_cfg->res_entries)
 		goto out;
 
-	if (ioa_cfg->sis64) {
-		ioa_cfg->target_ids = kzalloc(sizeof(unsigned long) *
-					      BITS_TO_LONGS(ioa_cfg->max_devs_supported), GFP_KERNEL);
-		ioa_cfg->array_ids = kzalloc(sizeof(unsigned long) *
-					     BITS_TO_LONGS(ioa_cfg->max_devs_supported), GFP_KERNEL);
-		ioa_cfg->vset_ids = kzalloc(sizeof(unsigned long) *
-					    BITS_TO_LONGS(ioa_cfg->max_devs_supported), GFP_KERNEL);
-
-		if (!ioa_cfg->target_ids || !ioa_cfg->array_ids
-			|| !ioa_cfg->vset_ids)
-			goto out_free_res_entries;
-	}
-
 	for (i = 0; i < ioa_cfg->max_devs_supported; i++) {
 		list_add_tail(&ioa_cfg->res_entries[i].queue, &ioa_cfg->free_res_q);
 		ioa_cfg->res_entries[i].ioa_cfg = ioa_cfg;
@@ -9089,9 +9076,6 @@ out_free_vpd_cbs:
 			    ioa_cfg->vpd_cbs, ioa_cfg->vpd_cbs_dma);
 out_free_res_entries:
 	kfree(ioa_cfg->res_entries);
-	kfree(ioa_cfg->target_ids);
-	kfree(ioa_cfg->array_ids);
-	kfree(ioa_cfg->vset_ids);
 	goto out;
 }
 
diff --git a/drivers/scsi/ipr.h b/drivers/scsi/ipr.h
index a1fb840..07a85ce 100644
--- a/drivers/scsi/ipr.h
+++ b/drivers/scsi/ipr.h
@@ -1440,9 +1440,9 @@ struct ipr_ioa_cfg {
 	/*
 	 * Bitmaps for SIS64 generated target values
 	 */
-	unsigned long *target_ids;
-	unsigned long *array_ids;
-	unsigned long *vset_ids;
+	unsigned long target_ids[BITS_TO_LONGS(IPR_MAX_SIS64_DEVS)];
+	unsigned long array_ids[BITS_TO_LONGS(IPR_MAX_SIS64_DEVS)];
+	unsigned long vset_ids[BITS_TO_LONGS(IPR_MAX_SIS64_DEVS)];
 
 	u16 type; /* CCIN of the card */
 
diff --git a/drivers/scsi/libfc/fc_exch.c b/drivers/scsi/libfc/fc_exch.c
index c772d8d..8b928c6 100644
--- a/drivers/scsi/libfc/fc_exch.c
+++ b/drivers/scsi/libfc/fc_exch.c
@@ -463,13 +463,7 @@ static void fc_exch_delete(struct fc_exch *ep)
 	fc_exch_release(ep);	/* drop hold for exch in mp */
 }
 
-/**
- * fc_seq_send() - Send a frame using existing sequence/exchange pair
- * @lport: The local port that the exchange will be sent on
- * @sp:	   The sequence to be sent
- * @fp:	   The frame to be sent on the exchange
- */
-static int fc_seq_send(struct fc_lport *lport, struct fc_seq *sp,
+static int fc_seq_send_locked(struct fc_lport *lport, struct fc_seq *sp,
 		       struct fc_frame *fp)
 {
 	struct fc_exch *ep;
@@ -479,7 +473,7 @@ static int fc_seq_send(struct fc_lport *lport, struct fc_seq *sp,
 	u8 fh_type = fh->fh_type;
 
 	ep = fc_seq_exch(sp);
-	WARN_ON((ep->esb_stat & ESB_ST_SEQ_INIT) != ESB_ST_SEQ_INIT);
+	WARN_ON(!(ep->esb_stat & ESB_ST_SEQ_INIT));
 
 	f_ctl = ntoh24(fh->fh_f_ctl);
 	fc_exch_setup_hdr(ep, fp, f_ctl);
@@ -502,17 +496,34 @@ static int fc_seq_send(struct fc_lport *lport, struct fc_seq *sp,
 	error = lport->tt.frame_send(lport, fp);
 
 	if (fh_type == FC_TYPE_BLS)
-		return error;
+		goto out;
 
 	/*
 	 * Update the exchange and sequence flags,
 	 * assuming all frames for the sequence have been sent.
 	 * We can only be called to send once for each sequence.
 	 */
-	spin_lock_bh(&ep->ex_lock);
 	ep->f_ctl = f_ctl & ~FC_FC_FIRST_SEQ;	/* not first seq */
 	if (f_ctl & FC_FC_SEQ_INIT)
 		ep->esb_stat &= ~ESB_ST_SEQ_INIT;
+out:
+	return error;
+}
+
+/**
+ * fc_seq_send() - Send a frame using existing sequence/exchange pair
+ * @lport: The local port that the exchange will be sent on
+ * @sp:	   The sequence to be sent
+ * @fp:	   The frame to be sent on the exchange
+ */
+static int fc_seq_send(struct fc_lport *lport, struct fc_seq *sp,
+		       struct fc_frame *fp)
+{
+	struct fc_exch *ep;
+	int error;
+	ep = fc_seq_exch(sp);
+	spin_lock_bh(&ep->ex_lock);
+	error = fc_seq_send_locked(lport, sp, fp);
 	spin_unlock_bh(&ep->ex_lock);
 	return error;
 }
@@ -629,7 +640,7 @@ static int fc_exch_abort_locked(struct fc_exch *ep,
 	if (fp) {
 		fc_fill_fc_hdr(fp, FC_RCTL_BA_ABTS, ep->did, ep->sid,
 			       FC_TYPE_BLS, FC_FC_END_SEQ | FC_FC_SEQ_INIT, 0);
-		error = fc_seq_send(ep->lp, sp, fp);
+		error = fc_seq_send_locked(ep->lp, sp, fp);
 	} else
 		error = -ENOBUFS;
 	return error;
@@ -1132,7 +1143,7 @@ static void fc_seq_send_last(struct fc_seq *sp, struct fc_frame *fp,
 	f_ctl = FC_FC_LAST_SEQ | FC_FC_END_SEQ | FC_FC_SEQ_INIT;
 	f_ctl |= ep->f_ctl;
 	fc_fill_fc_hdr(fp, rctl, ep->did, ep->sid, fh_type, f_ctl, 0);
-	fc_seq_send(ep->lp, sp, fp);
+	fc_seq_send_locked(ep->lp, sp, fp);
 }
 
 /**
@@ -1307,8 +1318,8 @@ static void fc_exch_recv_abts(struct fc_exch *ep, struct fc_frame *rx_fp)
 		ap->ba_low_seq_cnt = htons(sp->cnt);
 	}
 	sp = fc_seq_start_next_locked(sp);
-	spin_unlock_bh(&ep->ex_lock);
 	fc_seq_send_last(sp, fp, FC_RCTL_BA_ACC, FC_TYPE_BLS);
+	spin_unlock_bh(&ep->ex_lock);
 	fc_frame_free(rx_fp);
 	return;
 
diff --git a/drivers/scsi/libfc/fc_rport.c b/drivers/scsi/libfc/fc_rport.c
index d518d17..6bbb944 100644
--- a/drivers/scsi/libfc/fc_rport.c
+++ b/drivers/scsi/libfc/fc_rport.c
@@ -1962,7 +1962,7 @@ static int fc_rport_fcp_prli(struct fc_rport_priv *rdata, u32 spp_len,
 		rdata->flags |= FC_RP_FLAGS_RETRY;
 	rdata->supported_classes = FC_COS_CLASS3;
 
-	if (!(lport->service_params & FC_RPORT_ROLE_FCP_INITIATOR))
+	if (!(lport->service_params & FCP_SPPF_INIT_FCN))
 		return 0;
 
 	spp->spp_flags |= rspp->spp_flags & FC_SPP_EST_IMG_PAIR;
diff --git a/drivers/scsi/qla2xxx/qla_inline.h b/drivers/scsi/qla2xxx/qla_inline.h
index 98ab921..0a5c895 100644
--- a/drivers/scsi/qla2xxx/qla_inline.h
+++ b/drivers/scsi/qla2xxx/qla_inline.h
@@ -278,3 +278,14 @@ qla2x00_do_host_ramp_up(scsi_qla_host_t *vha)
 
 	set_bit(HOST_RAMP_UP_QUEUE_DEPTH, &vha->dpc_flags);
 }
+
+static inline void
+qla2x00_handle_mbx_completion(struct qla_hw_data *ha, int status)
+{
+	if (test_bit(MBX_INTR_WAIT, &ha->mbx_cmd_flags) &&
+	    (status & MBX_INTERRUPT) && ha->flags.mbox_int) {
+		set_bit(MBX_INTERRUPT, &ha->mbx_cmd_flags);
+		clear_bit(MBX_INTR_WAIT, &ha->mbx_cmd_flags);
+		complete(&ha->mbx_intr_comp);
+	}
+}
diff --git a/drivers/scsi/qla2xxx/qla_isr.c b/drivers/scsi/qla2xxx/qla_isr.c
index 259d920..d2a4c75 100644
--- a/drivers/scsi/qla2xxx/qla_isr.c
+++ b/drivers/scsi/qla2xxx/qla_isr.c
@@ -104,14 +104,9 @@ qla2100_intr_handler(int irq, void *dev_id)
 			RD_REG_WORD(&reg->hccr);
 		}
 	}
+	qla2x00_handle_mbx_completion(ha, status);
 	spin_unlock_irqrestore(&ha->hardware_lock, flags);
 
-	if (test_bit(MBX_INTR_WAIT, &ha->mbx_cmd_flags) &&
-	    (status & MBX_INTERRUPT) && ha->flags.mbox_int) {
-		set_bit(MBX_INTERRUPT, &ha->mbx_cmd_flags);
-		complete(&ha->mbx_intr_comp);
-	}
-
 	return (IRQ_HANDLED);
 }
 
@@ -221,14 +216,9 @@ qla2300_intr_handler(int irq, void *dev_id)
 		WRT_REG_WORD(&reg->hccr, HCCR_CLR_RISC_INT);
 		RD_REG_WORD_RELAXED(&reg->hccr);
 	}
+	qla2x00_handle_mbx_completion(ha, status);
 	spin_unlock_irqrestore(&ha->hardware_lock, flags);
 
-	if (test_bit(MBX_INTR_WAIT, &ha->mbx_cmd_flags) &&
-	    (status & MBX_INTERRUPT) && ha->flags.mbox_int) {
-		set_bit(MBX_INTERRUPT, &ha->mbx_cmd_flags);
-		complete(&ha->mbx_intr_comp);
-	}
-
 	return (IRQ_HANDLED);
 }
 
@@ -2613,14 +2603,9 @@ qla24xx_intr_handler(int irq, void *dev_id)
 		if (unlikely(IS_QLA83XX(ha) && (ha->pdev->revision == 1)))
 			ndelay(3500);
 	}
+	qla2x00_handle_mbx_completion(ha, status);
 	spin_unlock_irqrestore(&ha->hardware_lock, flags);
 
-	if (test_bit(MBX_INTR_WAIT, &ha->mbx_cmd_flags) &&
-	    (status & MBX_INTERRUPT) && ha->flags.mbox_int) {
-		set_bit(MBX_INTERRUPT, &ha->mbx_cmd_flags);
-		complete(&ha->mbx_intr_comp);
-	}
-
 	return IRQ_HANDLED;
 }
 
@@ -2763,13 +2748,9 @@ qla24xx_msix_default(int irq, void *dev_id)
 		}
 		WRT_REG_DWORD(&reg->hccr, HCCRX_CLR_RISC_INT);
 	} while (0);
+	qla2x00_handle_mbx_completion(ha, status);
 	spin_unlock_irqrestore(&ha->hardware_lock, flags);
 
-	if (test_bit(MBX_INTR_WAIT, &ha->mbx_cmd_flags) &&
-	    (status & MBX_INTERRUPT) && ha->flags.mbox_int) {
-		set_bit(MBX_INTERRUPT, &ha->mbx_cmd_flags);
-		complete(&ha->mbx_intr_comp);
-	}
 	return IRQ_HANDLED;
 }
 
diff --git a/drivers/scsi/qla2xxx/qla_mbx.c b/drivers/scsi/qla2xxx/qla_mbx.c
index 9e5d89d..3587ec2 100644
--- a/drivers/scsi/qla2xxx/qla_mbx.c
+++ b/drivers/scsi/qla2xxx/qla_mbx.c
@@ -179,8 +179,6 @@ qla2x00_mailbox_command(scsi_qla_host_t *vha, mbx_cmd_t *mcp)
 
 		wait_for_completion_timeout(&ha->mbx_intr_comp, mcp->tov * HZ);
 
-		clear_bit(MBX_INTR_WAIT, &ha->mbx_cmd_flags);
-
 	} else {
 		ql_dbg(ql_dbg_mbx, vha, 0x1011,
 		    "Cmd=%x Polling Mode.\n", command);
diff --git a/drivers/scsi/qla2xxx/qla_mr.c b/drivers/scsi/qla2xxx/qla_mr.c
index 937fed8..a6df558 100644
--- a/drivers/scsi/qla2xxx/qla_mr.c
+++ b/drivers/scsi/qla2xxx/qla_mr.c
@@ -148,9 +148,6 @@ qlafx00_mailbox_command(scsi_qla_host_t *vha, struct mbx_cmd_32 *mcp)
 		spin_unlock_irqrestore(&ha->hardware_lock, flags);
 
 		wait_for_completion_timeout(&ha->mbx_intr_comp, mcp->tov * HZ);
-
-		clear_bit(MBX_INTR_WAIT, &ha->mbx_cmd_flags);
-
 	} else {
 		ql_dbg(ql_dbg_mbx, vha, 0x112c,
 		    "Cmd=%x Polling Mode.\n", command);
@@ -2934,13 +2931,10 @@ qlafx00_intr_handler(int irq, void *dev_id)
 		QLAFX00_CLR_INTR_REG(ha, clr_intr);
 		QLAFX00_RD_INTR_REG(ha);
 	}
+
+	qla2x00_handle_mbx_completion(ha, status);
 	spin_unlock_irqrestore(&ha->hardware_lock, flags);
 
-	if (test_bit(MBX_INTR_WAIT, &ha->mbx_cmd_flags) &&
-	    (status & MBX_INTERRUPT) && ha->flags.mbox_int) {
-		set_bit(MBX_INTERRUPT, &ha->mbx_cmd_flags);
-		complete(&ha->mbx_intr_comp);
-	}
 	return IRQ_HANDLED;
 }
 
diff --git a/drivers/scsi/qla2xxx/qla_nx.c b/drivers/scsi/qla2xxx/qla_nx.c
index 10754f51..cce0cd0 100644
--- a/drivers/scsi/qla2xxx/qla_nx.c
+++ b/drivers/scsi/qla2xxx/qla_nx.c
@@ -2074,9 +2074,6 @@ qla82xx_intr_handler(int irq, void *dev_id)
 		}
 		WRT_REG_DWORD(&reg->host_int, 0);
 	}
-	spin_unlock_irqrestore(&ha->hardware_lock, flags);
-	if (!ha->flags.msi_enabled)
-		qla82xx_wr_32(ha, ha->nx_legacy_intr.tgt_mask_reg, 0xfbff);
 
 #ifdef QL_DEBUG_LEVEL_17
 	if (!irq && ha->flags.eeh_busy)
@@ -2085,11 +2082,12 @@ qla82xx_intr_handler(int irq, void *dev_id)
 		    status, ha->mbx_cmd_flags, ha->flags.mbox_int, stat);
 #endif
 
-	if (test_bit(MBX_INTR_WAIT, &ha->mbx_cmd_flags) &&
-	    (status & MBX_INTERRUPT) && ha->flags.mbox_int) {
-		set_bit(MBX_INTERRUPT, &ha->mbx_cmd_flags);
-		complete(&ha->mbx_intr_comp);
-	}
+	qla2x00_handle_mbx_completion(ha, status);
+	spin_unlock_irqrestore(&ha->hardware_lock, flags);
+
+	if (!ha->flags.msi_enabled)
+		qla82xx_wr_32(ha, ha->nx_legacy_intr.tgt_mask_reg, 0xfbff);
+
 	return IRQ_HANDLED;
 }
 
@@ -2149,8 +2147,6 @@ qla82xx_msix_default(int irq, void *dev_id)
 		WRT_REG_DWORD(&reg->host_int, 0);
 	} while (0);
 
-	spin_unlock_irqrestore(&ha->hardware_lock, flags);
-
 #ifdef QL_DEBUG_LEVEL_17
 	if (!irq && ha->flags.eeh_busy)
 		ql_log(ql_log_warn, vha, 0x5044,
@@ -2158,11 +2154,9 @@ qla82xx_msix_default(int irq, void *dev_id)
 		    status, ha->mbx_cmd_flags, ha->flags.mbox_int, stat);
 #endif
 
-	if (test_bit(MBX_INTR_WAIT, &ha->mbx_cmd_flags) &&
-		(status & MBX_INTERRUPT) && ha->flags.mbox_int) {
-			set_bit(MBX_INTERRUPT, &ha->mbx_cmd_flags);
-			complete(&ha->mbx_intr_comp);
-	}
+	qla2x00_handle_mbx_completion(ha, status);
+	spin_unlock_irqrestore(&ha->hardware_lock, flags);
+
 	return IRQ_HANDLED;
 }
 
@@ -3345,7 +3339,7 @@ void qla82xx_clear_pending_mbx(scsi_qla_host_t *vha)
 		ha->flags.mbox_busy = 0;
 		ql_log(ql_log_warn, vha, 0x6010,
 		    "Doing premature completion of mbx command.\n");
-		if (test_bit(MBX_INTR_WAIT, &ha->mbx_cmd_flags))
+		if (test_and_clear_bit(MBX_INTR_WAIT, &ha->mbx_cmd_flags))
 			complete(&ha->mbx_intr_comp);
 	}
 }
