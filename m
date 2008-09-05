From: Chris Leech <christopher.leech-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Subject: [PATCH 3/3] 24-bit types: Convert Open-FCoE to use
	__be24 type and	macros
Date: Fri, 05 Sep 2008 09:57:43 -0700
Message-ID: <20080905165743.16689.14381.stgit@localhost.localdomain>
References: <20080905165732.16689.50256.stgit@localhost.localdomain>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <devel-bounces-s9riP+hp16TNLxjTenLetw@public.gmane.org>
In-Reply-To: <20080905165732.16689.50256.stgit-bi+AKbBUZKY6gyzm1THtWbp2dZbC/Bob@public.gmane.org>
List-Unsubscribe: <http://www.open-fcoe.org/mailman/listinfo/devel>,
	<mailto:devel-request-s9riP+hp16TNLxjTenLetw@public.gmane.org?subject=unsubscribe>
List-Archive: <http://www.open-fcoe.org/pipermail/devel>
List-Post: <mailto:devel-s9riP+hp16TNLxjTenLetw@public.gmane.org>
List-Help: <mailto:devel-request-s9riP+hp16TNLxjTenLetw@public.gmane.org?subject=help>
List-Subscribe: <http://www.open-fcoe.org/mailman/listinfo/devel>,
	<mailto:devel-request-s9riP+hp16TNLxjTenLetw@public.gmane.org?subject=subscribe>
Sender: devel-bounces-s9riP+hp16TNLxjTenLetw@public.gmane.org
Errors-To: devel-bounces-s9riP+hp16TNLxjTenLetw@public.gmane.org
To: linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-scsi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, devel-s9riP+hp16TNLxjTenLetw@public.gmane.org
List-Id: linux-scsi@vger.kernel.org

This converts the Open-FCoE tree to use the common 24-bit types

Signed-off-by: Chris Leech <christopher.leech-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
---

 drivers/scsi/fcoe/fcoe_dev.c  |    6 +++---
 drivers/scsi/libfc/fc_exch.c  |   24 ++++++++++++------------
 drivers/scsi/libfc/fc_fcp.c   |    2 +-
 drivers/scsi/libfc/fc_lport.c |    8 ++++----
 drivers/scsi/libfc/fc_ns.c    |   14 +++++++-------
 drivers/scsi/libfc/fc_rport.c |    4 ++--
 include/scsi/fc/fc_els.h      |   18 +++++++++---------
 include/scsi/fc/fc_fcoe.h     |    6 ++----
 include/scsi/fc/fc_fs.h       |    8 ++++----
 include/scsi/fc/fc_gs.h       |    2 +-
 include/scsi/fc/fc_ns.h       |    6 +++---
 include/scsi/libfc/libfc.h    |   13 -------------
 12 files changed, 48 insertions(+), 63 deletions(-)


diff --git a/drivers/scsi/fcoe/fcoe_dev.c b/drivers/scsi/fcoe/fcoe_dev.c
index d5a354f..d5fc479 100644
--- a/drivers/scsi/fcoe/fcoe_dev.c
+++ b/drivers/scsi/fcoe/fcoe_dev.c
@@ -233,7 +233,7 @@ int fcoe_xmit(struct fc_lport *lp, struct fc_frame *fp)
 			 * MAC in this case would have been set by receving the
 			 * FLOGI.
 			 */
-			fc_fcoe_set_mac(fc->data_src_addr, fh->fh_s_id);
+			fc_fcoe_set_mac(fc->data_src_addr, &fh->fh_s_id);
 			fc->flogi_progress = 0;
 		}
 	}
@@ -311,7 +311,7 @@ int fcoe_xmit(struct fc_lport *lp, struct fc_frame *fp)
 	skb->ip_summed = CHECKSUM_NONE;
 	eh = (struct ethhdr *)skb_push(skb, hlen + sizeof(struct ethhdr));
 	if (fc->address_mode == FCOE_FCOUI_ADDR_MODE)
-		fc_fcoe_set_mac(eh->h_dest, fh->fh_d_id);
+		fc_fcoe_set_mac(eh->h_dest, &fh->fh_d_id);
 	else
 		/* insert GW address */
 		memcpy(eh->h_dest, fc->dest_addr, ETH_ALEN);
@@ -516,7 +516,7 @@ static void fcoe_recv_flogi(struct fcoe_softc *fc, struct fc_frame *fp, u8 *sa)
 		if (compare_ether_addr(fc->data_src_addr, (u8[6]) { 0 }))
 			dev_unicast_delete(fc->real_dev, fc->data_src_addr,
 					   ETH_ALEN);
-		fc_fcoe_set_mac(fc->data_src_addr, fh->fh_d_id);
+		fc_fcoe_set_mac(fc->data_src_addr, &fh->fh_d_id);
 		dev_unicast_add(fc->real_dev, fc->data_src_addr, ETH_ALEN);
 		rtnl_unlock();
 
diff --git a/drivers/scsi/libfc/fc_exch.c b/drivers/scsi/libfc/fc_exch.c
index 11a03bd..9fd011b 100644
--- a/drivers/scsi/libfc/fc_exch.c
+++ b/drivers/scsi/libfc/fc_exch.c
@@ -278,8 +278,8 @@ static void fc_seq_fill_hdr(struct fc_seq *sp, struct fc_frame *fp)
 
 	ep = fc_seq_exch(sp);
 
-	hton24(fh->fh_s_id, ep->sid);
-	hton24(fh->fh_d_id, ep->did);
+	fh->fh_s_id = hton24(ep->sid);
+	fh->fh_d_id = hton24(ep->did);
 	fh->fh_ox_id = htons(ep->oxid);
 	fh->fh_rx_id = htons(ep->rxid);
 	fh->fh_seq_id = sp->id;
@@ -892,7 +892,7 @@ int fc_seq_send(struct fc_lport *lp, struct fc_seq *sp,
 		fr_eof(fp) = FC_EOF_N;
 	}
 
-	hton24(fh->fh_f_ctl, f_ctl | fill);
+	fh->fh_f_ctl = hton24(f_ctl | fill);
 	fh->fh_seq_cnt = htons(sp->cnt++);
 
 	/*
@@ -992,7 +992,7 @@ static void fc_seq_send_ack(struct fc_seq *sp, const struct fc_frame *rx_fp)
 			FC_FC_END_SEQ | FC_FC_END_CONN | FC_FC_SEQ_INIT |
 			FC_FC_RETX_SEQ | FC_FC_UNI_TX;
 		f_ctl ^= FC_FC_EX_CTX | FC_FC_SEQ_CTX;
-		hton24(fh->fh_f_ctl, f_ctl);
+		fh->fh_f_ctl = hton24(f_ctl);
 
 		fh->fh_seq_id = rx_fh->fh_seq_id;
 		fh->fh_seq_cnt = rx_fh->fh_seq_cnt;
@@ -1039,8 +1039,8 @@ fc_exch_send_ba_rjt(struct fc_frame *rx_fp, enum fc_ba_rjt_reason reason,
 	/*
 	 * seq_id, cs_ctl, df_ctl and param/offset are zero.
 	 */
-	memcpy(fh->fh_s_id, rx_fh->fh_d_id, 3);
-	memcpy(fh->fh_d_id, rx_fh->fh_s_id, 3);
+	fh->fh_s_id = rx_fh->fh_d_id;
+	fh->fh_d_id = rx_fh->fh_s_id;
 	fh->fh_ox_id = rx_fh->fh_rx_id;
 	fh->fh_rx_id = rx_fh->fh_ox_id;
 	fh->fh_seq_cnt = rx_fh->fh_seq_cnt;
@@ -1062,7 +1062,7 @@ fc_exch_send_ba_rjt(struct fc_frame *rx_fp, enum fc_ba_rjt_reason reason,
 	f_ctl ^= FC_FC_EX_CTX | FC_FC_SEQ_CTX;
 	f_ctl |= FC_FC_LAST_SEQ | FC_FC_END_SEQ;
 	f_ctl &= ~FC_FC_FIRST_SEQ;
-	hton24(fh->fh_f_ctl, f_ctl);
+	fh->fh_f_ctl = hton24(f_ctl);
 
 	fr_sof(fp) = fc_sof_class(fr_sof(rx_fp));
 	fr_eof(fp) = FC_EOF_T;
@@ -1607,12 +1607,12 @@ static void fc_exch_els_rec(struct fc_seq *sp, struct fc_frame *rfp)
 	memset(acc, 0, sizeof(*acc));
 	acc->reca_cmd = ELS_LS_ACC;
 	acc->reca_ox_id = rp->rec_ox_id;
-	memcpy(acc->reca_ofid, rp->rec_s_id, 3);
+	acc->reca_ofid = rp->rec_s_id;
 	acc->reca_rx_id = htons(ep->rxid);
 	if (ep->sid == ep->oid)
-		hton24(acc->reca_rfid, ep->did);
+		acc->reca_rfid = hton24(ep->did);
 	else
-		hton24(acc->reca_rfid, ep->sid);
+		acc->reca_rfid = hton24(ep->sid);
 	acc->reca_fc4value = htonl(ep->seq.rec_data);
 	acc->reca_e_stat = htonl(ep->esb_stat & (ESB_ST_RESP |
 						  ESB_ST_SEQ_INIT |
@@ -1704,7 +1704,7 @@ static void fc_exch_rrq(struct fc_exch *ep)
 	rrq = fc_frame_payload_get(fp, sizeof(*rrq));
 	memset(rrq, 0, sizeof(*rrq));
 	rrq->rrq_cmd = ELS_RRQ;
-	hton24(rrq->rrq_s_id, ep->sid);
+	rrq->rrq_s_id = hton24(ep->sid);
 	rrq->rrq_ox_id = htons(ep->oxid);
 	rrq->rrq_rx_id = htons(ep->rxid);
 
@@ -1906,7 +1906,7 @@ struct fc_seq *fc_exch_seq_send(struct fc_lport *lp,
 	}
 	f_ctl |= ep->f_ctl;
 	fh = fc_frame_header_get(fp);
-	hton24(fh->fh_f_ctl, f_ctl | fill);
+	fh->fh_f_ctl = hton24(f_ctl | fill);
 	fh->fh_seq_cnt = htons(sp->cnt++);
 
 	if (unlikely(lp->tt.frame_send(lp, fp)))
diff --git a/drivers/scsi/libfc/fc_fcp.c b/drivers/scsi/libfc/fc_fcp.c
index 9402eba..6c24724 100644
--- a/drivers/scsi/libfc/fc_fcp.c
+++ b/drivers/scsi/libfc/fc_fcp.c
@@ -1332,7 +1332,7 @@ static void fc_fcp_rec(struct fc_fcp_pkt *fsp)
 	rec = fc_frame_payload_get(fp, sizeof(*rec));
 	memset(rec, 0, sizeof(*rec));
 	rec->rec_cmd = ELS_REC;
-	hton24(rec->rec_s_id, lp->fid);
+	rec->rec_s_id = hton24(lp->fid);
 	rec->rec_ox_id = htons(ox_id);
 	rec->rec_rx_id = htons(rx_id);
 
diff --git a/drivers/scsi/libfc/fc_lport.c b/drivers/scsi/libfc/fc_lport.c
index b06f519..ad5c5b1 100644
--- a/drivers/scsi/libfc/fc_lport.c
+++ b/drivers/scsi/libfc/fc_lport.c
@@ -244,8 +244,8 @@ static void fc_lport_rnid_req(struct fc_seq *sp, struct fc_frame *in_fp,
 			rp->rnid.rnid_cmd = ELS_LS_ACC;
 			rp->rnid.rnid_fmt = fmt;
 			rp->rnid.rnid_cid_len = sizeof(rp->cid);
-			rp->cid.rnid_wwpn = htonll(lp->wwpn);
-			rp->cid.rnid_wwnn = htonll(lp->wwnn);
+			rp->cid.rnid_wwpn = cpu_to_be64(lp->wwpn);
+			rp->cid.rnid_wwnn = cpu_to_be64(lp->wwnn);
 			if (fmt == ELS_RNIDF_GEN) {
 				rp->rnid.rnid_sid_len = sizeof(rp->gen);
 				memcpy(&rp->gen, &lp->rnid_gen,
@@ -747,8 +747,8 @@ static void fc_lport_enter_logo(struct fc_lport *lp)
 	logo = fc_frame_payload_get(fp, sizeof(*logo));
 	memset(logo, 0, sizeof(*logo));
 	logo->fl_cmd = ELS_LOGO;
-	hton24(logo->fl_n_port_id, lp->fid);
-	logo->fl_n_port_wwn = htonll(lp->wwpn);
+	logo->fl_n_port_id = hton24(lp->fid);
+	logo->fl_n_port_wwn = cpu_to_be64(lp->wwpn);
 
 	fc_frame_setup(fp, FC_RCTL_ELS_REQ, FC_TYPE_ELS);
 	fc_frame_set_offset(fp, 0);
diff --git a/drivers/scsi/libfc/fc_ns.c b/drivers/scsi/libfc/fc_ns.c
index 6204bcc..c280913 100644
--- a/drivers/scsi/libfc/fc_ns.c
+++ b/drivers/scsi/libfc/fc_ns.c
@@ -265,7 +265,7 @@ static void fc_ns_enter_reg_ft(struct fc_lport *lp)
 					      FC_NS_RFT_ID,
 					      sizeof(*req) -
 					      sizeof(struct fc_ct_hdr));
-			hton24(req->fid.fp_fid, lp->fid);
+			req->fid.fp_fid = hton24(lp->fid);
 			req->fts = *lps;
 			fc_frame_setup(fp, FC_RCTL_DD_UNSOL_CTL, FC_TYPE_CT);
 			if (!lp->tt.exch_seq_send(lp, fp,
@@ -774,7 +774,7 @@ static int fc_ns_gpn_ft_parse(struct fc_lport *lp, void *buf, size_t len)
 			break;
 		dp->lp = lp;
 		dp->ids.port_id = ntoh24(np->fp_fid);
-		dp->ids.port_name = ntohll(np->fp_wwpn);
+		dp->ids.port_name = be64_to_cpu(np->fp_wwpn);
 		dp->ids.node_name = -1;
 		dp->ids.roles = FC_RPORT_ROLE_UNKNOWN;
 		error = fc_ns_gnn_id_req(lp, dp);
@@ -934,7 +934,7 @@ static int fc_ns_gpn_id_req(struct fc_lport *lp, struct fc_ns_port *dp)
 
 	cp = fc_frame_payload_get(fp, sizeof(*cp));
 	fc_ns_fill_dns_hdr(lp, &cp->ct, FC_NS_GPN_ID, sizeof(cp->fid));
-	hton24(cp->fid.fp_fid, dp->ids.port_id);
+	cp->fid.fp_fid = hton24(dp->ids.port_id);
 
 	WARN_ON(!fc_lport_test_ready(lp));
 
@@ -989,7 +989,7 @@ static void fc_ns_gpn_id_resp(struct fc_seq *sp, struct fc_frame *fp,
 			       fr_len(fp));
 			break;
 		}
-		dp->ids.port_name = ntohll(cp->wwn);
+		dp->ids.port_name = be64_to_cpu(cp->wwn);
 		fc_ns_gnn_id_req(lp, dp);
 		break;
 	case FC_FS_RJT:
@@ -1137,7 +1137,7 @@ static void fc_ns_enter_reg_pn(struct fc_lport *lp)
 	req = fc_frame_payload_get(fp, sizeof(*req));
 	memset(req, 0, sizeof(*req));
 	fc_lport_fill_dns_hdr(lp, &req->ct, FC_NS_RPN_ID, sizeof(req->rn));
-	hton24(req->rn.fr_fid.fp_fid, lp->fid);
+	req->rn.fr_fid.fp_fid = hton24(lp->fid);
 	put_unaligned_be64(lp->wwpn, &req->rn.fr_wwn);
 	fc_frame_setup(fp, FC_RCTL_DD_UNSOL_CTL, FC_TYPE_CT);
 	if (!lp->tt.exch_seq_send(lp, fp,
@@ -1191,7 +1191,7 @@ static int fc_ns_gnn_id_req(struct fc_lport *lp, struct fc_ns_port *dp)
 
 	cp = fc_frame_payload_get(fp, sizeof(*cp));
 	fc_ns_fill_dns_hdr(lp, &cp->ct, FC_NS_GNN_ID, sizeof(cp->fid));
-	hton24(cp->fid.fp_fid, dp->ids.port_id);
+	cp->fid.fp_fid = hton24(dp->ids.port_id);
 
 	WARN_ON(!fc_lport_test_ready(lp));
 
@@ -1246,7 +1246,7 @@ static void fc_ns_gnn_id_resp(struct fc_seq *sp, struct fc_frame *fp,
 			       fr_len(fp));
 			break;
 		}
-		dp->ids.node_name = ntohll(cp->wwn);
+		dp->ids.node_name = be64_to_cpu(cp->wwn);
 		fc_ns_new_target(lp, NULL, &dp->ids);
 		break;
 	case FC_FS_RJT:
diff --git a/drivers/scsi/libfc/fc_rport.c b/drivers/scsi/libfc/fc_rport.c
index cd559dd..0ca4c12 100644
--- a/drivers/scsi/libfc/fc_rport.c
+++ b/drivers/scsi/libfc/fc_rport.c
@@ -857,8 +857,8 @@ static void fc_rport_enter_logo(struct fc_rport *rport)
 	logo = fc_frame_payload_get(fp, sizeof(*logo));
 	memset(logo, 0, sizeof(*logo));
 	logo->fl_cmd = ELS_LOGO;
-	hton24(logo->fl_n_port_id, lp->fid);
-	logo->fl_n_port_wwn = htonll(lp->wwpn);
+	logo->fl_n_port_id = hton24(lp->fid);
+	logo->fl_n_port_wwn = cpu_to_be64(lp->wwpn);
 
 	fc_frame_setup(fp, FC_RCTL_ELS_REQ, FC_TYPE_ELS);
 	if (!lp->tt.exch_seq_send(lp, fp,
diff --git a/include/scsi/fc/fc_els.h b/include/scsi/fc/fc_els.h
index af4bf0c..c1cfe21 100644
--- a/include/scsi/fc/fc_els.h
+++ b/include/scsi/fc/fc_els.h
@@ -357,7 +357,7 @@ struct fc_els_rrq {
 	__u8		rrq_cmd;	/* command (0x12) */
 	__u8		rrq_zero[3];	/* specified as zero - part of cmd */
 	__u8		rrq_resvd;	/* reserved */
-	__u8		rrq_s_id[3];	/* originator FID */
+	__be24		rrq_s_id;	/* originator FID */
 	__be16		rrq_ox_id;	/* originator exchange ID */
 	__be16		rrq_rx_id;	/* responders exchange ID */
 };
@@ -369,7 +369,7 @@ struct fc_els_rec {
 	__u8		rec_cmd;	/* command (0x13) */
 	__u8		rec_zero[3];	/* specified as zero - part of cmd */
 	__u8		rec_resvd;	/* reserved */
-	__u8		rec_s_id[3];	/* originator FID */
+	__be24		rec_s_id;	/* originator FID */
 	__be16		rec_ox_id;	/* originator exchange ID */
 	__be16		rec_rx_id;	/* responders exchange ID */
 };
@@ -383,9 +383,9 @@ struct fc_els_rec_acc {
 	__be16		reca_ox_id;	/* originator exchange ID */
 	__be16		reca_rx_id;	/* responders exchange ID */
 	__u8		reca_resvd1;	/* reserved */
-	__u8		reca_ofid[3];	/* originator FID */
+	__be24		reca_ofid;	/* originator FID */
 	__u8		reca_resvd2;	/* reserved */
-	__u8		reca_rfid[3];	/* responder FID */
+	__be24		reca_rfid;	/* responder FID */
 	__be32		reca_fc4value;	/* FC4 value */
 	__be32		reca_e_stat;	/* ESB (exchange status block) status */
 };
@@ -407,7 +407,7 @@ struct fc_els_logo {
 	__u8		fl_cmd;		/* command code */
 	__u8		fl_zero[3];	/* specified as zero - part of cmd */
 	__u8		fl_resvd;	/* reserved */
-	__u8		fl_n_port_id[3];/* N port ID */
+	__be24		fl_n_port_id;	/* N port ID */
 	__be64		fl_n_port_wwn;	/* port name */
 };
 
@@ -465,7 +465,7 @@ struct fc_els_rscn {
 
 struct fc_els_rscn_page {
 	__u8		rscn_page_flags; /* event and address format */
-	__u8		rscn_fid[3];	/* fabric ID */
+	__be24		rscn_fid;	/* fabric ID */
 };
 
 #define	ELS_RSCN_EV_QUAL_BIT	2	/* shift count for event qualifier */
@@ -598,7 +598,7 @@ struct fc_els_rpl {
 struct fc_els_pnb {
 	__be32		pnb_phys_pn;	/* physical port number */
 	__u8		pnb_resv;	/* reserved */
-	__u8		pnb_port_id[3];	/* port ID */
+	__be24		pnb_port_id;	/* port ID */
 	__be64		pnb_wwpn;	/* port name */
 };
 
@@ -709,7 +709,7 @@ enum fc_els_srl_flag {
 struct fc_els_rls {
 	__u8		rls_cmd;	/* command */
 	__u8		rls_resv[4];	/* reserved - must be zero */
-	__u8		rls_port_id[3];	/* port ID */
+	__be24		rls_port_id;	/* port ID */
 };
 
 /*
@@ -741,7 +741,7 @@ struct fc_els_clir {
 	__be64		clir_wwpn;	/* incident port name */
 	__be64		clir_wwnn;	/* incident port node name */
 	__u8		clir_port_type;	/* incident port type */
-	__u8		clir_port_id[3];	/* incident port ID */
+	__be24		clir_port_id;	/* incident port ID */
 
 	__be64		clir_conn_wwpn;	/* connected port name */
 	__be64		clir_conn_wwnn;	/* connected node name */
diff --git a/include/scsi/fc/fc_fcoe.h b/include/scsi/fc/fc_fcoe.h
index b2e07ec..4c0f692 100644
--- a/include/scsi/fc/fc_fcoe.h
+++ b/include/scsi/fc/fc_fcoe.h
@@ -83,14 +83,12 @@ struct fcoe_crc_eof {
 /*
  * Store OUI + DID into MAC address field.
  */
-static inline void fc_fcoe_set_mac(u8 *mac, u8 *did)
+static inline void fc_fcoe_set_mac(u8 *mac, __be24 *did)
 {
 	mac[0] = (u8) (FC_FCOE_OUI >> 16);
 	mac[1] = (u8) (FC_FCOE_OUI >> 8);
 	mac[2] = (u8) FC_FCOE_OUI;
-	mac[3] = did[0];
-	mac[4] = did[1];
-	mac[5] = did[2];
+	*(__be24 *) &mac[3] = *did;
 }
 
 /*
diff --git a/include/scsi/fc/fc_fs.h b/include/scsi/fc/fc_fs.h
index ba6df64..125ba15 100644
--- a/include/scsi/fc/fc_fs.h
+++ b/include/scsi/fc/fc_fs.h
@@ -29,14 +29,14 @@
  * Frame header
  */
 struct fc_frame_header {
-	__u8          fh_r_ctl;	/* routing control */
-	__u8          fh_d_id[3];	/* Destination ID */
+	__u8          fh_r_ctl;		/* routing control */
+	__be24        fh_d_id;		/* Destination ID */
 
 	__u8          fh_cs_ctl;	/* class of service control / pri */
-	__u8          fh_s_id[3];	/* Source ID */
+	__be24        fh_s_id;		/* Source ID */
 
 	__u8          fh_type;		/* see enum fc_fh_type below */
-	__u8          fh_f_ctl[3];	/* frame control */
+	__be24        fh_f_ctl;		/* frame control */
 
 	__u8          fh_seq_id;	/* sequence ID */
 	__u8          fh_df_ctl;	/* data field control */
diff --git a/include/scsi/fc/fc_gs.h b/include/scsi/fc/fc_gs.h
index ffab027..fb082bf 100644
--- a/include/scsi/fc/fc_gs.h
+++ b/include/scsi/fc/fc_gs.h
@@ -27,7 +27,7 @@
 
 struct fc_ct_hdr {
 	__u8		ct_rev;		/* revision */
-	__u8		ct_in_id[3];	/* N_Port ID of original requestor */
+	__be24		ct_in_id;	/* N_Port ID of original requestor */
 	__u8		ct_fs_type;	/* type of fibre channel service */
 	__u8		ct_fs_subtype;	/* subtype */
 	__u8		ct_options;
diff --git a/include/scsi/fc/fc_ns.h b/include/scsi/fc/fc_ns.h
index 790d7b9..44c3019 100644
--- a/include/scsi/fc/fc_ns.h
+++ b/include/scsi/fc/fc_ns.h
@@ -76,7 +76,7 @@ struct fc_ns_pt_obj {
  */
 struct fc_ns_fid {
 	__u8		fp_flags;	/* flags for responses only */
-	__u8		fp_fid[3];
+	__be24		fp_fid;
 };
 
 /*
@@ -119,7 +119,7 @@ struct fc_ns_gid_ft {
  */
 struct fc_gpn_ft_resp {
 	__u8		fp_flags;	/* see fp_flags definitions above */
-	__u8		fp_fid[3];	/* port ID */
+	__be24		fp_fid;		/* port ID */
 	__be32		fp_resvd;
 	__be64		fp_wwpn;	/* port name */
 };
@@ -136,7 +136,7 @@ struct fc_ns_gid_pn {
  */
 struct fc_gid_pn_resp {
 	__u8      fp_resvd;
-	__u8      fp_fid[3];     /* port ID */
+	__be24    fp_fid;     /* port ID */
 };
 
 /*
diff --git a/include/scsi/libfc/libfc.h b/include/scsi/libfc/libfc.h
index d8ec019..bfe91cf 100644
--- a/include/scsi/libfc/libfc.h
+++ b/include/scsi/libfc/libfc.h
@@ -53,19 +53,6 @@
 #define	FC_EX_TIMEOUT	1	/* Exchange timeout */
 #define	FC_EX_CLOSED	2	/* Exchange closed */
 
-/* some helpful macros */
-
-#define ntohll(x) be64_to_cpu(x)
-#define htonll(x) cpu_to_be64(x)
-
-#define ntoh24(p)	(((p)[0] << 16) | ((p)[1] << 8) | ((p)[2]))
-
-#define hton24(p, v)	do { \
-	p[0] = (((v) >> 16) & 0xFF); \
-	p[1] = (((v) >> 8) & 0xFF); \
-	p[2] = ((v) & 0xFF); \
-} while (0)
-
 struct fc_exch_mgr;
 
 /*
