From: Robert Love <robert.w.love@intel.com>
Subject: [PATCH 04/10] [FCoE] Remove ASSERTs from libfc
Date: Tue, 22 Jan 2008 16:36:24 -0800
Message-ID: <20080123003624.8469.28729.stgit@fritz>
References: <20080123003523.8469.62236.stgit@fritz>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mga03.intel.com ([143.182.124.21]:33866 "EHLO mga03.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757462AbYAWAuR (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Tue, 22 Jan 2008 19:50:17 -0500
In-Reply-To: <20080123003523.8469.62236.stgit@fritz>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org


---

 drivers/scsi/ofc/include/fc_frame.h         |   17 +----
 drivers/scsi/ofc/libfc/fc_disc_targ.c       |   25 ++------
 drivers/scsi/ofc/libfc/fc_exch.c            |   89 ++++++++-------------------
 drivers/scsi/ofc/libfc/fc_frame.c           |    1 
 drivers/scsi/ofc/libfc/fc_local_port.c      |   60 ++++--------------
 drivers/scsi/ofc/libfc/fc_local_port_impl.h |    1 
 drivers/scsi/ofc/libfc/fc_port.c            |    9 +--
 drivers/scsi/ofc/libfc/fc_print.c           |    1 
 drivers/scsi/ofc/libfc/fc_remote_port.c     |   21 +++---
 drivers/scsi/ofc/libfc/fc_sess.c            |   63 +++++++------------
 drivers/scsi/ofc/libfc/fc_virt_fab.c        |    1 
 drivers/scsi/ofc/libfc/fcs_attr.c           |    1 
 drivers/scsi/ofc/libfc/fcs_cmd.c            |    7 +-
 drivers/scsi/ofc/libfc/fcs_event.c          |    3 -
 drivers/scsi/ofc/libfc/fcs_state.c          |   25 +++-----
 15 files changed, 103 insertions(+), 221 deletions(-)


diff --git a/drivers/scsi/ofc/include/fc_frame.h b/drivers/scsi/ofc/include/fc_frame.h
index 36e9dce..6f8e85e 100644
--- a/drivers/scsi/ofc/include/fc_frame.h
+++ b/drivers/scsi/ofc/include/fc_frame.h
@@ -109,7 +109,6 @@ static inline void fc_frame_init_static(struct fc_frame *fp)
  */
 static inline int fc_frame_freed_static(struct fc_frame *fp)
 {
-	ASSERT(fp->fr_flags & FCPHF_STATIC);
 	return (fp->fr_flags & FCPHF_FREED);
 }
 
@@ -127,8 +126,7 @@ struct fc_frame *fc_frame_alloc_fill(struct fc_port *, size_t payload_len);
 static inline struct fc_frame *fc_port_frame_alloc(struct fc_port *port,
 	size_t payload_len)
 {
-	ASSERT(port->np_frame_alloc);
-	ASSERT((payload_len % 4) == 0);
+	WARN_ON((payload_len % 4) != 0);
 	return (*port->np_frame_alloc)(payload_len);
 }
 
@@ -137,8 +135,6 @@ static inline struct fc_frame *fc_frame_alloc_inline(struct fc_port *port,
 {
 	struct fc_frame *fp;
 
-	ASSERT(port);
-
 	/*
 	 * Note: Since len will often be a constant multiple of 4,
 	 * this check will usually be evaluated and eliminated at compile time.
@@ -166,9 +162,6 @@ static inline struct fc_frame *fc_frame_alloc_inline(struct fc_port *port,
  */
 static inline void fc_frame_free(struct fc_frame *fp)
 {
-	ASSERT(fp);
-	ASSERT(fp->fr_free);
-	ASSERT(fp->fr_hdr);
 	FC_FRAME_STAMP(fp);
 	fp->fr_hdr = NULL;
 	(*fp->fr_free)(fp);
@@ -186,8 +179,7 @@ static inline int fc_frame_is_linear(struct fc_frame *fp)
 static inline struct fc_frame_header *fc_frame_header_get(const struct
 							  fc_frame *fp)
 {
-	ASSERT(fp != NULL);
-	ASSERT(fp->fr_len >= sizeof(struct fc_frame_header));
+	WARN_ON(fp->fr_len < sizeof(struct fc_frame_header));
 	return fp->fr_hdr;
 }
 
@@ -206,7 +198,6 @@ static inline void *fc_frame_payload_get(const struct fc_frame *fp,
 {
 	void *pp = NULL;
 
-	ASSERT(fp != NULL);
 	if (fp->fr_len >= sizeof(struct fc_frame_header) + len)
 		pp = fc_frame_header_get(fp) + 1;
 	return pp;
@@ -239,8 +230,7 @@ static inline void fc_frame_setup(struct fc_frame *fp, enum fc_rctl r_ctl,
 	struct fc_frame_header *fh;
 
 	fh = fc_frame_header_get(fp);
-	ASSERT(fh != NULL);
-	ASSERT(r_ctl != 0);
+	WARN_ON(r_ctl == 0);
 	fh->fh_r_ctl = r_ctl;
 	fh->fh_type = type;
 	net32_put(&fh->fh_parm_offset, 0);
@@ -255,7 +245,6 @@ fc_frame_set_offset(struct fc_frame *fp, u_int32_t offset)
 	struct fc_frame_header *fh;
 
 	fh = fc_frame_header_get(fp);
-	ASSERT(fh != NULL);
 	net32_put(&fh->fh_parm_offset, offset);
 }
 
diff --git a/drivers/scsi/ofc/libfc/fc_disc_targ.c b/drivers/scsi/ofc/libfc/fc_disc_targ.c
index 4906a2b..eb24e52 100644
--- a/drivers/scsi/ofc/libfc/fc_disc_targ.c
+++ b/drivers/scsi/ofc/libfc/fc_disc_targ.c
@@ -26,7 +26,6 @@
 #undef LIST_HEAD
 #include "net_types.h"
 
-#include "sa_assert.h"
 #include "ofc_dbg.h"
 #include "sa_timer.h"
 #include "sa_event.h"
@@ -204,7 +203,6 @@ static int fcdt_new_target(struct fc_local_port *lp,
 	int error = 0;
 
 	if (rp && wwpn) {
-		ASSERT(atomic_read(&rp->rp_refcnt) > 0);
 		if (rp->rp_port_wwn == 0) {
 			/*
 			 * Set WWN and fall through to notify of create.
@@ -258,7 +256,6 @@ static void fcdt_del_target(struct fc_local_port *lp, struct fc_remote_port *rp)
 {
 	struct fc_sess *sess;
 
-	ASSERT(atomic_read(&rp->rp_refcnt) > 0);	/* caller holds rp */
 	sess = rp->rp_sess;
 	if (sess) {
 		rp->rp_sess_ready = 0;
@@ -310,7 +307,7 @@ static void fcdt_done(struct fc_local_port *lp)
 		else
 			held = NULL;
 	}
-	ASSERT(!held);
+	WARN_ON(held);
 	fc_virt_fab_unlock(vp);
 	(*lp->fl_disc_cb) (lp->fl_disc_cb_arg, NULL, FC_EV_NONE);
 	lp->fl_disc_in_prog = 0;
@@ -347,12 +344,10 @@ static void fcdt_gpn_ft_req(struct fc_local_port *lp)
 		error = ENOMEM;
 	} else {
 		rp = fc_frame_payload_get(fp, sizeof(*rp));
-		ASSERT(rp);
 		fcdt_fill_dns_hdr(lp, &rp->ct, FC_NS_GPN_FT, sizeof(rp->gid));
 		rp->gid.fn_fc4_type = lp->fl_disc_type;
 
-		ASSERT(lp->fl_dns_sess);
-		ASSERT(fc_local_port_test_ready(lp));
+		WARN_ON(!fc_local_port_test_ready(lp));
 
 		fc_frame_setup(fp, FC_RCTL_DD_UNSOL_CTL, FC_TYPE_CT);
 		error = fc_sess_send_req(lp->fl_dns_sess, fp, fcdt_gpn_ft_resp,
@@ -406,10 +401,10 @@ static int fcdt_gpn_ft_parse(struct fc_local_port *lp, void *buf, size_t len)
 	np = (struct fc_gpn_ft_resp *)bp;
 	tlen = lp->fl_disc_buf_len;
 	if (tlen) {
-		ASSERT(tlen < sizeof(*np));
+		WARN_ON(tlen >= sizeof(*np));
 		plen = sizeof(*np) - tlen;
-		ASSERT(plen > 0);
-		ASSERT(plen < sizeof(*np));
+		WARN_ON(plen <= 0);
+		WARN_ON(plen >= sizeof(*np));
 		if (plen > len)
 			plen = len;
 		np = &lp->fl_disc_buf;
@@ -492,7 +487,7 @@ static void fcdt_gpn_ft_resp(struct fc_seq *sp, struct fc_frame *fp,
 	u_int len;
 	int error;
 
-	ASSERT(fc_frame_is_linear(fp));	/* buffer must be contiguous */
+	WARN_ON(!fc_frame_is_linear(fp));	/* buffer must be contiguous */
 	fh = fc_frame_header_get(fp);
 	len = fp->fr_len - sizeof(*fh);;
 	seq_cnt = net16_get(&fh->fh_seq_cnt);
@@ -571,12 +566,10 @@ static int fcdt_gpn_id_req(struct fc_local_port *lp, struct fc_remote_port *rp)
 		error = ENOMEM;
 	} else {
 		cp = fc_frame_payload_get(fp, sizeof(*cp));
-		ASSERT(cp);
 		fcdt_fill_dns_hdr(lp, &cp->ct, FC_NS_GPN_ID, sizeof(cp->fid));
 		net24_put(&cp->fid.fp_fid, rp->rp_fid);
 
-		ASSERT(lp->fl_dns_sess);
-		ASSERT(fc_local_port_test_ready(lp));
+		WARN_ON(!fc_local_port_test_ready(lp));
 
 		fc_frame_setup(fp, FC_RCTL_DD_UNSOL_CTL, FC_TYPE_CT);
 		error = fc_sess_send_req(lp->fl_dns_sess, fp, fcdt_gpn_id_resp,
@@ -601,8 +594,7 @@ static void fcdt_gpn_id_resp(struct fc_seq *sp, struct fc_frame *fp,
 	u_int cmd;
 
 	lp = list_first_entry(&rp->rp_vf->vf_local_ports, struct fc_local_port, fl_list);
-	ASSERT(lp);
-	ASSERT(fc_frame_is_linear(fp));	/* buffer must be contiguous */
+	WARN_ON(!fc_frame_is_linear(fp));	/* buffer must be contiguous */
 
 	cp = fc_frame_payload_get(fp, sizeof(cp->ct));
 	if (cp == NULL) {
@@ -652,7 +644,6 @@ static void fcdt_gpn_id_error(enum fc_event event, void *rp_arg)
 	case FC_EV_TIMEOUT:
 	case FC_EV_READY:
 		lp = list_first_entry(&rp->rp_vf->vf_local_ports, struct fc_local_port, fl_list);
-		ASSERT(lp);
 		fc_disc_targ_restart(lp);
 		break;
 	case FC_EV_CLOSED:
diff --git a/drivers/scsi/ofc/libfc/fc_exch.c b/drivers/scsi/ofc/libfc/fc_exch.c
index 9a5cd98..ff9b301 100644
--- a/drivers/scsi/ofc/libfc/fc_exch.c
+++ b/drivers/scsi/ofc/libfc/fc_exch.c
@@ -22,7 +22,6 @@
  */
 
 #include "sa_kernel.h"
-#include "sa_assert.h"
 #include "net_types.h"
 #include "ofc_dbg.h"
 #include "sa_hash.h"
@@ -225,7 +224,7 @@ static int fc_exch_mgr_init(struct fc_exch_mgr *mp, enum fc_class class,
 	 */
 	min_xid = (min_xid + (pool_count - 1)) & ~(pool_count - 1);
 	max_xid = (max_xid - (pool_count - 1)) | (pool_count - 1);
-	ASSERT(min_xid < max_xid);
+	WARN_ON(min_xid > max_xid);
 	mp->em_min_xid = min_xid;
 	mp->em_max_xid = max_xid;
 
@@ -243,7 +242,7 @@ static int fc_exch_mgr_init(struct fc_exch_mgr *mp, enum fc_class class,
 		for (xid = min_xid + pool; xid <= max_xid;
 		     xid += (fc_xid_t) pool_count) {
 
-			ASSERT((xid % pool_count) == pool);
+			WARN_ON((xid % pool_count) != pool);
 			ep = &mp->em_exch[xid - min_xid];
 			ep->ex_pool = pp;
 			ep->ex_xid = xid;
@@ -269,7 +268,7 @@ struct fc_exch_mgr *fc_exch_mgr_alloc(enum fc_class class,
 
 	if (!min_xid)
 		min_xid++;
-	ASSERT(min_xid < max_xid);
+	WARN_ON(min_xid > max_xid);
 	len = (max_xid + 1 - min_xid) * sizeof(struct fc_exch) + sizeof(*mp);
 
 	while (len > (PAGE_SIZE << order))
@@ -306,7 +305,7 @@ static inline struct fc_exch *fc_exch_lookup(struct fc_exch_mgr *mp,
 
 	if (xid >= mp->em_min_xid && xid <= mp->em_max_xid) {
 		ep = &mp->em_exch[xid - mp->em_min_xid];
-		ASSERT(ep->ex_xid == xid);
+		WARN_ON(ep->ex_xid != xid);
 		if (atomic_read(&ep->ex_refcnt) == 0 &&
 		    (ep->ex_e_stat & ESB_ST_COMPLETE)) {
 			ep = NULL;	/* exchange is free */
@@ -321,7 +320,6 @@ static inline struct fc_exch *fc_exch_lookup(struct fc_exch_mgr *mp,
 static void fc_exch_hold(struct fc_exch *ep)
 {
 	atomic_inc(&ep->ex_refcnt);
-	ASSERT(atomic_read(&ep->ex_refcnt) != 0);	/* detect overflow */
 }
 
 /*
@@ -332,14 +330,12 @@ static void fc_exch_release(struct fc_exch *ep)
 {
 	struct fc_exch_pool *pp;
 
-	ASSERT(atomic_read(&ep->ex_refcnt) != 0);
-
 	if (atomic_dec_and_test(&ep->ex_refcnt) &&
 	    (ep->ex_e_stat & ESB_ST_COMPLETE)) {
 		sa_timer_cancel(&ep->ex_timer);
 		pp = ep->ex_pool;
 		spin_lock_bh(&pp->emp_lock);
-		ASSERT(pp->emp_exch_in_use > 0);
+		WARN_ON(pp->emp_exch_in_use <= 0);
 		pp->emp_exch_in_use--;
 		list_del(&ep->ex_list);
 		list_add_tail(&ep->ex_list, &pp->emp_exch_free);
@@ -353,7 +349,7 @@ static void fc_exch_release(struct fc_exch *ep)
  */
 inline struct fc_exch *fc_seq_exch(const struct fc_seq *sp)
 {
-	ASSERT(sp);
+	WARN_ON(!sp);
 	return (struct fc_exch *)
 	    ((char *)sp - offsetof(struct fc_exch, ex_seq));
 }
@@ -364,7 +360,6 @@ inline struct fc_exch *fc_seq_exch(const struct fc_seq *sp)
 inline void fc_seq_hold(struct fc_seq *sp)
 {
 	atomic_inc(&sp->seq_refcnt);
-	ASSERT(atomic_read(&sp->seq_refcnt) != 0);
 }
 
 /*
@@ -378,7 +373,6 @@ static struct fc_seq *fc_seq_alloc(struct fc_exch *ep, u_int8_t seq_id)
 {
 	struct fc_seq *sp;
 
-	ASSERT(ep);
 	sp = &ep->ex_seq;
 	if (atomic_read(&sp->seq_refcnt) == 0 && sp->seq_active == 0)
 		fc_exch_hold(ep);	/* hold exchange for the sequence */
@@ -407,7 +401,6 @@ void fc_seq_release(struct fc_seq *sp)
  */
 inline void fc_seq_complete(struct fc_seq *sp)
 {
-	ASSERT(atomic_read(&sp->seq_refcnt) != 0);
 	sp->seq_active = 0;
 }
 
@@ -423,7 +416,7 @@ static void fc_exch_timeout(void *ep_arg)
 	void *arg;
 
 	fc_seq_hold(sp);
-	ASSERT(sp->seq_active);
+	WARN_ON(!sp->seq_active);
 	if (ep->ex_aborted) {
 		fc_seq_exch_complete(sp);
 	} else {
@@ -466,7 +459,6 @@ int fc_seq_abort_exch(const struct fc_seq *req_sp)
 	int error;
 
 	ep = fc_seq_exch(req_sp);
-	ASSERT(ep);
 
 	/*
 	 * Send the abort on a new sequence if possible.
@@ -563,10 +555,8 @@ static struct fc_exch *fc_exch_alloc(struct fc_exch_mgr *mp)
 		pp->emp_exch_in_use++;
 		spin_unlock_bh(&pp->emp_lock);
 
-		ASSERT(ep->ex_pool == pp);
-		ASSERT(atomic_read(&ep->ex_refcnt) == 0);
-		ASSERT(ep->ex_xid != 0);
-		ASSERT(spin_can_lock(&ep->ex_lock));
+		WARN_ON(ep->ex_pool != pp);
+		WARN_ON(ep->ex_xid == 0);
 
 		/*
 		 * Clear the portion of the exchange not maintained
@@ -576,10 +566,8 @@ static struct fc_exch *fc_exch_alloc(struct fc_exch_mgr *mp)
 		       offsetof(struct fc_exch, fc_exch_clear_start), 0,
 		       sizeof(*ep) - offsetof(struct fc_exch,
 					      fc_exch_clear_start));
-		ASSERT(ep->ex_pool == pp);
-		ASSERT(atomic_read(&ep->ex_refcnt) == 0);
-		ASSERT(ep->ex_xid != 0);
-		ASSERT(spin_can_lock(&ep->ex_lock));
+		WARN_ON(ep->ex_pool != pp);
+		WARN_ON(ep->ex_xid == 0);
 
 		ep->ex_f_ctl = FC_FC_FIRST_SEQ;	/* next seq is first seq */
 		ep->ex_rx_id = FC_XID_UNKNOWN;
@@ -653,7 +641,7 @@ static struct fc_exch *fc_exch_resp(struct fc_exch_mgr *mp,
 		 */
 		if (fh->fh_type != FC_TYPE_BLS) {
 			rx_id = net16_get(&fh->fh_rx_id);
-			ASSERT(rx_id == FC_XID_UNKNOWN);
+			WARN_ON(rx_id != FC_XID_UNKNOWN);
 			net16_put(&fh->fh_rx_id, ep->ex_rx_id);
 		}
 	}
@@ -674,7 +662,7 @@ fc_seq_lookup_recip(struct fc_exch_mgr *mp, struct fc_frame *fp)
 	fc_xid_t xid;
 
 	f_ctl = net24_get(&fh->fh_f_ctl);
-	ASSERT((f_ctl & FC_FC_SEQ_CTX) == 0);
+	WARN_ON((f_ctl & FC_FC_SEQ_CTX) != 0);
 
 	/*
 	 * Lookup or create the exchange if we will be creating the sequence.
@@ -733,7 +721,6 @@ fc_seq_lookup_recip(struct fc_exch_mgr *mp, struct fc_frame *fp)
 	 * At this point, we should have the exchange.
 	 * Find or create the sequence.
 	 */
-	ASSERT(ep);
 	if (fc_sof_is_init(fp->fr_sof)) {
 		sp = fc_seq_alloc(ep, fh->fh_seq_id);
 		fc_exch_release(ep);	/* sequence now holds exch */
@@ -754,10 +741,7 @@ fc_seq_lookup_recip(struct fc_exch_mgr *mp, struct fc_frame *fp)
 			goto out;
 		}
 	}
-	ASSERT(sp);
-	ASSERT(ep);
-	ASSERT(ep == fc_seq_exch(sp));
-	ASSERT(atomic_read(&sp->seq_refcnt));
+	WARN_ON(ep != fc_seq_exch(sp));
 
 	if (f_ctl & FC_FC_SEQ_INIT)
 		ep->ex_e_stat |= ESB_ST_SEQ_INIT;
@@ -783,7 +767,7 @@ static struct fc_seq *fc_seq_lookup_orig(struct fc_exch_mgr *mp,
 	fc_xid_t xid;
 
 	f_ctl = net24_get(&fh->fh_f_ctl);
-	ASSERT(f_ctl & FC_FC_SEQ_CTX);
+	WARN_ON((f_ctl & FC_FC_SEQ_CTX) != FC_FC_SEQ_CTX);
 	xid = net16_get((f_ctl & FC_FC_EX_CTX) ? &fh->fh_ox_id : &fh->fh_rx_id);
 	ep = fc_exch_lookup(mp, xid);
 	if (ep && ep->ex_seq.seq_id == fh->fh_seq_id) {
@@ -840,10 +824,10 @@ struct fc_seq *fc_seq_start(struct fc_exch *ep)
 	struct fc_seq *sp = NULL;
 
 	spin_lock_bh(&ep->ex_lock);
-	ASSERT((ep->ex_e_stat & ESB_ST_COMPLETE) == 0);
+	WARN_ON((ep->ex_e_stat & ESB_ST_COMPLETE) != 0);
 
 	sp = fc_seq_alloc(ep, ep->ex_seq_id++);
-	ASSERT(sp);
+
 	if (fc_exch_debug)
 		OFC_DBG("exch %4x f_ctl %6x seq %2x f_ctl %6x\n",
 		       ep->ex_xid, ep->ex_f_ctl, sp->seq_id, sp->seq_f_ctl);
@@ -920,8 +904,8 @@ size_t fc_seq_mfs(struct fc_seq *sp)
 	size_t mfs;
 
 	mfs = fc_seq_exch(sp)->ex_max_payload;
-	ASSERT(mfs >= FC_SP_MIN_MAX_PAYLOAD);
-	ASSERT(mfs <= FC_SP_MAX_MAX_PAYLOAD);
+	WARN_ON(mfs < FC_SP_MIN_MAX_PAYLOAD);
+	WARN_ON(mfs > FC_SP_MAX_MAX_PAYLOAD);
 	return mfs;
 }
 
@@ -956,12 +940,11 @@ int fc_seq_send_frag(struct fc_seq *sp, struct fc_frame *fp)
 	int error;
 
 	ep = fc_seq_exch(sp);
-	ASSERT(ep);
-	ASSERT(ep->ex_e_stat & ESB_ST_SEQ_INIT);
+	WARN_ON((ep->ex_e_stat & ESB_ST_SEQ_INIT) != ESB_ST_SEQ_INIT);
 	port = ep->ex_port;
-	ASSERT(port);
-	ASSERT((sp->seq_f_ctl & FC_FC_END_SEQ) == 0);
-	ASSERT(fp->fr_len % 4 == 0);	/* can't pad except on last frame */
+
+	WARN_ON((sp->seq_f_ctl & FC_FC_END_SEQ) != 0);
+	WARN_ON(fp->fr_len % 4 != 0);	/* can't pad except on last frame */
 
 	class = ep->ex_class;
 	fp->fr_sof = class;
@@ -1013,11 +996,9 @@ int fc_seq_send(struct fc_seq *sp, struct fc_frame *fp)
 	int error;
 
 	ep = fc_seq_exch(sp);
-	ASSERT(ep);
-	ASSERT(ep->ex_e_stat & ESB_ST_SEQ_INIT);
+	WARN_ON((ep->ex_e_stat & ESB_ST_SEQ_INIT) != ESB_ST_SEQ_INIT);
 	port = ep->ex_port;
-	ASSERT(port);
-	ASSERT((sp->seq_f_ctl & FC_FC_END_SEQ) == 0);
+	WARN_ON((sp->seq_f_ctl & FC_FC_END_SEQ) != 0);
 
 	class = ep->ex_class;
 	fp->fr_sof = class;
@@ -1114,7 +1095,6 @@ int fc_seq_send_req(struct fc_seq *sp, struct fc_frame *fp,
 int fc_seq_send_next_req(struct fc_seq *sp, struct fc_frame *fp)
 {
 	sp = fc_seq_start_next(sp);
-	ASSERT(sp);
 	sp->seq_f_ctl |= FC_FC_SEQ_INIT;
 	return fc_seq_send(sp, fp);
 }
@@ -1197,11 +1177,7 @@ void fc_exch_recv_req(struct fc_exch_mgr *mp, struct fc_frame *fp,
 	reject = fc_seq_lookup_recip(mp, fp);
 	if (reject == FC_RJT_NONE) {
 		sp = fp->fr_seq;	/* sequence will be held */
-		ASSERT(sp);
-		ASSERT(atomic_read(&sp->seq_refcnt) != 0);
 		ep = fc_seq_exch(sp);
-		ASSERT(ep);
-		ASSERT(atomic_read(&ep->ex_refcnt) != 0);
 		ep->ex_max_payload = (u_int16_t) max_payload;
 		sof = fp->fr_sof;
 		eof = fp->fr_eof;
@@ -1223,8 +1199,8 @@ void fc_exch_recv_req(struct fc_exch_mgr *mp, struct fc_frame *fp,
 			if ((f_ctl & (FC_FC_LAST_SEQ | FC_FC_END_SEQ)) ==
 			    (FC_FC_LAST_SEQ | FC_FC_END_SEQ))
 				fc_exch_complete_locked(ep);
-			ASSERT(atomic_read(&sp->seq_refcnt) != 0);
-			ASSERT(fc_seq_exch(sp) == ep);
+
+			WARN_ON(fc_seq_exch(sp) != ep);
 			fc_seq_complete(sp);
 		}
 		spin_unlock_bh(&ep->ex_lock);
@@ -1316,7 +1292,6 @@ void fc_exch_recv_seq_resp(struct fc_exch_mgr *mp, struct fc_frame *fp)
 	sof = fp->fr_sof;
 	if (fc_sof_is_init(sof)) {
 		sp = fc_seq_alloc(ep, fh->fh_seq_id);
-		ASSERT(sp);
 		sp->seq_s_stat |= SSB_ST_RESP;
 	} else {
 		sp = &ep->ex_seq;
@@ -1348,8 +1323,7 @@ void fc_exch_recv_seq_resp(struct fc_exch_mgr *mp, struct fc_frame *fp)
 		if ((f_ctl & (FC_FC_LAST_SEQ | FC_FC_END_SEQ)) ==
 		    (FC_FC_LAST_SEQ | FC_FC_END_SEQ))
 			fc_exch_complete_locked(ep);
-		ASSERT(atomic_read(&sp->seq_refcnt) != 0);
-		ASSERT(fc_seq_exch(sp) == ep);
+		WARN_ON(fc_seq_exch(sp) != ep);
 		fc_seq_complete(sp);
 		spin_unlock_bh(&ep->ex_lock);
 	}
@@ -1397,7 +1371,6 @@ void fc_exch_recv_resp(struct fc_exch_mgr *mp, struct fc_frame *fp)
 			OFC_DBG("seq lookup failed: reject %x\n", reject);
 	} else {
 		ep = fc_seq_exch(sp);
-		ASSERT(ep);
 		if (fh->fh_type == FC_TYPE_BLS) {
 			spin_lock_bh(&ep->ex_lock);
 			f_ctl = net24_get(&fh->fh_f_ctl);
@@ -1455,7 +1428,6 @@ static void fc_seq_fill_hdr(struct fc_seq *sp, struct fc_frame *fp)
 	struct fc_exch *ep;
 
 	ep = fc_seq_exch(sp);
-	ASSERT(ep);
 
 	net24_put(&fh->fh_s_id, ep->ex_s_id);
 	net24_put(&fh->fh_d_id, ep->ex_d_id);
@@ -1478,11 +1450,9 @@ void fc_seq_ls_acc(struct fc_seq *req_sp)
 	struct fc_frame *fp;
 
 	sp = fc_seq_start_next(req_sp);
-	ASSERT(sp);
 	fp = fc_frame_alloc(fc_seq_exch(sp)->ex_port, sizeof(*acc));
 	if (fp) {
 		acc = fc_frame_payload_get(fp, sizeof(*acc));
-		ASSERT(acc);
 		memset(acc, 0, sizeof(*acc));
 		acc->la_cmd = ELS_LS_ACC;
 		fc_seq_send_last(sp, fp, FC_RCTL_ELS_REP, FC_TYPE_ELS);
@@ -1504,11 +1474,9 @@ void fc_seq_ls_rjt(struct fc_seq *req_sp, enum fc_els_rjt_reason reason,
 	struct fc_frame *fp;
 
 	sp = fc_seq_start_next(req_sp);
-	ASSERT(sp);
 	fp = fc_frame_alloc(fc_seq_exch(sp)->ex_port, sizeof(*rjt));
 	if (fp) {
 		rjt = fc_frame_payload_get(fp, sizeof(*rjt));
-		ASSERT(rjt);
 		memset(rjt, 0, sizeof(*rjt));
 		rjt->er_cmd = ELS_LS_RJT;
 		rjt->er_reason = reason;
@@ -1575,7 +1543,6 @@ struct fc_seq *fc_seq_rec_req(struct fc_seq *inq_sp,
 	}
 	fc_seq_exch(sp)->ex_port = ep->ex_port;
 	rp = fc_frame_payload_get(fp, sizeof(*rp));
-	ASSERT(rp);
 	memset(rp, 0, sizeof(*rp));
 	rp->rec_cmd = ELS_REC;
 	if (ep->ex_f_ctl & FC_FC_EX_CTX)
diff --git a/drivers/scsi/ofc/libfc/fc_frame.c b/drivers/scsi/ofc/libfc/fc_frame.c
index c609ebd..34d7a8a 100644
--- a/drivers/scsi/ofc/libfc/fc_frame.c
+++ b/drivers/scsi/ofc/libfc/fc_frame.c
@@ -23,7 +23,6 @@
 
 #include "sa_kernel.h"
 #include "net_types.h"
-#include "sa_assert.h"
 #include "ofc_dbg.h"
 #include "fc_fs.h"
 #include "fc_types.h"
diff --git a/drivers/scsi/ofc/libfc/fc_local_port.c b/drivers/scsi/ofc/libfc/fc_local_port.c
index cd70c74..be3a77b 100644
--- a/drivers/scsi/ofc/libfc/fc_local_port.c
+++ b/drivers/scsi/ofc/libfc/fc_local_port.c
@@ -24,7 +24,6 @@
 #include "sa_kernel.h"
 #undef LIST_HEAD
 #include "net_types.h"
-#include "sa_assert.h"
 #include "ofc_dbg.h"
 #include "sa_timer.h"
 #include "sa_event.h"
@@ -209,7 +208,6 @@ const char *fc_local_port_state(struct fc_local_port *lp)
  */
 static void fc_local_port_retry(struct fc_local_port *lp)
 {
-	ASSERT(fc_local_port_locked(lp));
 	if (lp->fl_retry_count == 0)
 		OFC_DBG("local port %6x alloc failure in state %s "
 			"- will retry", lp->fl_fid, fc_local_port_state(lp));
@@ -266,7 +264,6 @@ static void fc_local_port_ptp_clear(struct fc_local_port *lp)
 {
 	struct fc_remote_port *rp;
 
-	ASSERT(fc_local_port_locked(lp));
 	rp = lp->fl_ptp_rp;
 	if (rp) {
 		lp->fl_ptp_rp = NULL;
@@ -425,7 +422,6 @@ static void fc_local_port_flogi_send(struct fc_local_port *lp)
 	fp = fc_frame_alloc(lp->fl_port, sizeof(*flp));
 	if (fp) {
 		flp = fc_frame_payload_get(fp, sizeof(*flp));
-		ASSERT(flp);
 		fc_local_port_flogi_fill(lp, flp, ELS_FLOGI);
 	}
 	fc_local_port_els_send(lp, sp, fp);
@@ -450,7 +446,6 @@ static void fc_local_port_recv_flogi_req(struct fc_seq *sp_in,
 	fc_fid_t local_fid;
 
 	fh = fc_frame_header_get(rx_fp);
-	ASSERT(fh);
 	remote_fid = net24_get(&fh->fh_s_id);
 	flp = fc_frame_payload_get(rx_fp, sizeof(*flp));
 	if (!flp)
@@ -469,7 +464,7 @@ static void fc_local_port_recv_flogi_req(struct fc_seq *sp_in,
 	 */
 #if 0	/* XXX - can't do this yet without clearing the FLOGI exchange */
 	fc_local_port_enter_init(lp);
-	ASSERT(lp->fl_fid == 0);
+	WARN_ON(lp->fl_fid != 0);
 #endif /* XXX */
 
 	/*
@@ -492,10 +487,8 @@ static void fc_local_port_recv_flogi_req(struct fc_seq *sp_in,
 	fp = fc_frame_alloc(lp->fl_port, sizeof(*flp));
 	if (fp) {
 		sp = fc_seq_start_next(rx_fp->fr_seq);
-		ASSERT(sp);
 		fc_seq_set_addr(sp, remote_fid, local_fid);
 		new_flp = fc_frame_payload_get(fp, sizeof(*flp));
-		ASSERT(new_flp);
 		fc_local_port_flogi_fill(lp, new_flp, ELS_FLOGI);
 		new_flp->fl_cmd = (net8_t) ELS_LS_ACC;
 
@@ -549,7 +542,6 @@ static void fc_local_port_sess_event(int event, void *lp_arg)
 		break;
 	case FC_EV_CLOSED:
 		sess = lp->fl_dns_sess;
-		ASSERT(sess);
 		lp->fl_dns_sess = NULL;
 		if (lp->fl_state == LOCAL_PORT_ST_DNS_STOP)
 			fc_local_port_enter_logo(lp);
@@ -577,6 +569,7 @@ static void fc_local_port_enter_dns(struct fc_local_port *lp)
 	struct fc_remote_port *rp;
 
 	fc_local_port_enter_state(lp, LOCAL_PORT_ST_DNS);
+
 	sess = lp->fl_dns_sess;
 	if (!sess) {
 		/*
@@ -668,7 +661,6 @@ static void fc_local_port_enter_reg_pn(struct fc_local_port *lp)
 		return;
 	}
 	rp = fc_frame_payload_get(fp, sizeof(*rp));
-	ASSERT(rp);
 	memset(rp, 0, sizeof(*rp));
 	fc_local_port_fill_dns_hdr(lp, &rp->ct, FC_NS_RPN_ID, sizeof(rp->rn));
 	net24_put(&rp->rn.fr_fid.fp_fid, lp->fl_fid);
@@ -717,6 +709,7 @@ static void fc_local_port_enter_reg_ft(struct fc_local_port *lp)
 	int i;
 
 	fc_local_port_enter_state(lp, LOCAL_PORT_ST_REG_FT);
+
 	lps = &lp->fl_ns_fts;
 	i = sizeof(lps->ff_type_map) / sizeof(lps->ff_type_map[0]);
 	while (--i >= 0)
@@ -726,7 +719,6 @@ static void fc_local_port_enter_reg_ft(struct fc_local_port *lp)
 		fp = fc_frame_alloc(lp->fl_port, sizeof(*rp));
 		if (fp) {
 			rp = fc_frame_payload_get(fp, sizeof(*rp));
-			ASSERT(rp);
 			fc_local_port_fill_dns_hdr(lp, &rp->ct,
 						   FC_NS_RFT_ID,
 						   sizeof(*rp) -
@@ -759,7 +751,6 @@ static void fc_local_port_enter_scr(struct fc_local_port *lp)
 	fp = fc_frame_alloc(lp->fl_port, sizeof(*scr));
 	if (fp) {
 		scr = fc_frame_payload_get(fp, sizeof(*scr));
-		ASSERT(scr);
 		memset(scr, 0, sizeof(*scr));
 		scr->scr_cmd = ELS_SCR;
 		scr->scr_reg_func = ELS_SCRF_FULL;
@@ -794,6 +785,7 @@ static void fc_local_port_enter_dns_stop(struct fc_local_port *lp)
 	struct fc_sess *sess;
 
 	fc_local_port_enter_state(lp, LOCAL_PORT_ST_DNS_STOP);
+
 	sess = lp->fl_dns_sess;
 	if (sess) {
 		fc_sess_stop(sess);
@@ -840,7 +832,6 @@ static void fc_local_port_enter_logo(struct fc_local_port *lp)
 	fp = fc_frame_alloc(lp->fl_port, sizeof(*logo));
 	if (fp) {
 		logo = fc_frame_payload_get(fp, sizeof(*logo));
-		ASSERT(logo);
 		memset(logo, 0, sizeof(*logo));
 		logo->fl_cmd = ELS_LOGO;
 		net24_put(&logo->fl_n_port_id, lp->fl_fid);
@@ -853,8 +844,7 @@ int fc_local_port_table_create(struct fc_virt_fab *vp)
 {
 	struct sa_hash *hp;
 
-	ASSERT(vp);
-	ASSERT(!vp->vf_lport_by_fid);
+	WARN_ON(vp->vf_lport_by_fid);
 
 	hp = sa_hash_create(&fc_local_port_hash_by_fid,
 			    FC_LOCAL_PORT_HASH_SIZE);
@@ -869,7 +859,7 @@ int fc_local_port_table_create(struct fc_virt_fab *vp)
 
 void fc_local_port_table_destroy(struct fc_virt_fab *vp)
 {
-	ASSERT(list_empty(&vp->vf_local_ports));
+	WARN_ON(!list_empty(&vp->vf_local_ports));
 	sa_hash_destroy(vp->vf_lport_by_fid);
 }
 
@@ -884,19 +874,6 @@ struct fc_local_port *fc_local_port_create(struct fc_virt_fab *vf,
 {
 	struct fc_local_port *lp;
 
-	/*
-	 * Static checks for packet structure sizes.
-	 * These catch some obvious errors in structure definitions.
-	 * These should generate no code since they can be tested
-	 * at compile time.
-	 */
-#ifdef DEBUG_ASSERTS
-	fc_fs_size_checks();
-	fc_gs_size_checks();
-	fc_ils_size_checks();
-	fc_els_size_checks();
-#endif /* DEBUG_ASSERTS */
-
 	lp = sa_malloc(sizeof(*lp));
 	if (!lp)
 		return NULL;
@@ -951,7 +928,6 @@ static void fc_local_port_set_fid_int(struct fc_local_port *lp, fc_fid_t fid)
 	struct fc_local_port *found;
 	struct fc_virt_fab *vf;
 
-	ASSERT(fc_local_port_locked(lp));
 	vf = lp->fl_vf;
 	if (lp->fl_fid != fid) {
 		if (fc_local_port_debug) {
@@ -962,10 +938,9 @@ static void fc_local_port_set_fid_int(struct fc_local_port *lp, fc_fid_t fid)
 		if (lp->fl_fid) {
 			found = sa_hash_lookup_delete(vf->vf_lport_by_fid,
 						      &lp->fl_fid);
-			ASSERT(found);
-			ASSERT(found == lp);
+			WARN_ON(found != lp);
 		}
-		ASSERT(!sa_hash_lookup(vf->vf_lport_by_fid, &fid));
+		WARN_ON(sa_hash_lookup(vf->vf_lport_by_fid, &fid));
 		lp->fl_fid = fid;
 		if (fid != 0)
 			sa_hash_insert(vf->vf_lport_by_fid, &fid, lp);
@@ -1041,8 +1016,6 @@ static void fc_local_port_delete(struct fc_local_port *lp)
 	struct fc_local_port *found;
 	struct fc_virt_fab *vf;
 
-	ASSERT(!atomic_read(&lp->fl_refcnt));
-
 	if (fc_local_port_debug)
 		OFC_DBG("local port %6x delete", lp->fl_fid);
 	vf = lp->fl_vf;
@@ -1050,12 +1023,11 @@ static void fc_local_port_delete(struct fc_local_port *lp)
 	fc_virt_fab_lock(vf);
 	if (lp->fl_fid) {
 		found = sa_hash_lookup_delete(vf->vf_lport_by_fid, &lp->fl_fid);
-		ASSERT(found = lp);
+		WARN_ON(found != lp);
 		lp->fl_fid = 0;
 	}
 	list_del(&lp->fl_list);
 	fc_virt_fab_unlock(vf);
-	ASSERT(!lp->fl_dns_sess);	/* otherwise it holds the local port */
 	sa_event_list_free(lp->fl_events);
 	sa_free(lp);
 }
@@ -1063,12 +1035,10 @@ static void fc_local_port_delete(struct fc_local_port *lp)
 void fc_local_port_hold(struct fc_local_port *lp)
 {
 	atomic_inc(&lp->fl_refcnt);
-	ASSERT(atomic_read(&lp->fl_refcnt) > 0);
 }
 
 void fc_local_port_release(struct fc_local_port *lp)
 {
-	ASSERT(atomic_read(&lp->fl_refcnt) > 0);
 	if (atomic_dec_and_test(&lp->fl_refcnt))
 		fc_local_port_delete(lp);
 }
@@ -1154,9 +1124,6 @@ static void fc_local_port_enter_init(struct fc_local_port *lp)
 	struct fc_sess *sess;
 	u_int mfs;
 
-	ASSERT(atomic_read(&lp->fl_refcnt) > 0);
-	ASSERT(fc_local_port_locked(lp));
-
 	if (fc_local_port_debug)
 		OFC_DBG("new state init");
 	sess = lp->fl_dns_sess;
@@ -1374,13 +1341,12 @@ static void fc_local_port_echo_req(struct fc_seq *sp, struct fc_frame *in_fp,
 
 	len = in_fp->fr_len - sizeof(struct fc_frame_header);
 	pp = fc_frame_payload_get(in_fp, len);
-	ASSERT(pp);
+
 	if (len < sizeof(net32_t))
 		len = sizeof(net32_t);
 	fp = fc_frame_alloc(lp->fl_port, len);
 	if (fp) {
 		dp = fc_frame_payload_get(fp, len);
-		ASSERT(dp);
 		memcpy(dp, pp, len);
 		net32_put(dp, ELS_LS_ACC << 24);
 		fc_seq_send_last(fc_seq_start_next(sp), fp,
@@ -1422,7 +1388,6 @@ static void fc_local_port_rnid_req(struct fc_seq *sp, struct fc_frame *in_fp,
 		fp = fc_frame_alloc(lp->fl_port, len);
 		if (fp) {
 			rp = fc_frame_payload_get(fp, len);
-			ASSERT(rp);
 			memset(rp, 0, len);
 			rp->rnid.rnid_cmd = ELS_LS_ACC;
 			rp->rnid.rnid_fmt = fmt;
@@ -1715,7 +1680,7 @@ static void fc_local_port_gid_pn_resp(struct fc_seq *sp, struct fc_frame *fp,
 
 	fc_local_port_lock(lp);
 
-	ASSERT(rp->dns_lookup == arg);
+	WARN_ON(rp->dns_lookup != arg);
 	rp->dns_lookup = NULL;
 	rp->dns_lookup_count = 0;
 	sa_free(lp_handle);
@@ -1786,7 +1751,6 @@ static int fc_local_port_send_gid_pn(struct fc_local_port_handle *lp_handle)
 		return ENOMEM;
 
 	req = fc_frame_payload_get(fp, sizeof(*req));
-	ASSERT(req);
 	fc_local_port_fill_dns_hdr(lp, &req->ct, FC_NS_GID_PN, sizeof(req->pn));
 	net64_put(&req->pn.fn_wwpn, rp->rp_port_wwn);
 
@@ -1820,7 +1784,7 @@ static void fc_local_port_gid_pn_error(enum fc_event event, void *arg)
 		}
 	}
 
-	ASSERT(rp->dns_lookup == arg);
+	WARN_ON(rp->dns_lookup != arg);
 	rp->dns_lookup = NULL;
 	sa_free(lp_handle);
 
diff --git a/drivers/scsi/ofc/libfc/fc_local_port_impl.h b/drivers/scsi/ofc/libfc/fc_local_port_impl.h
index d5825f1..4b5f342 100644
--- a/drivers/scsi/ofc/libfc/fc_local_port_impl.h
+++ b/drivers/scsi/ofc/libfc/fc_local_port_impl.h
@@ -138,7 +138,6 @@ static inline void fc_local_port_unlock(struct fc_local_port *lp)
 static inline void fc_local_port_unlock_send(struct fc_local_port *lp)
 {
 	fc_local_port_unlock(lp);
-	ASSERT(atomic_read(&lp->fl_refcnt) != 0);
 	sa_event_send_deferred(lp->fl_events);
 }
 
diff --git a/drivers/scsi/ofc/libfc/fc_port.c b/drivers/scsi/ofc/libfc/fc_port.c
index 191ab4f..c225fed 100644
--- a/drivers/scsi/ofc/libfc/fc_port.c
+++ b/drivers/scsi/ofc/libfc/fc_port.c
@@ -18,7 +18,6 @@
  */
 
 #include "sa_kernel.h"
-#include "sa_assert.h"
 #include "sa_error_inject.h"
 #include "ofc_dbg.h"
 #include "sa_event.h"
@@ -88,7 +87,7 @@ void fc_port_free(struct fc_port *port)
 void fc_port_set_max_frame_size(struct fc_port *port, u_int mfs)
 {
 	mfs &= ~3;
-	ASSERT((size_t) mfs >= FC_MIN_MAX_FRAME);
+	WARN_ON((size_t) mfs < FC_MIN_MAX_FRAME);
 	if (mfs > FC_MAX_FRAME)
 		mfs = FC_MAX_FRAME;
 	port->np_max_frame = mfs;
@@ -157,7 +156,7 @@ void fc_port_close_ingress(struct fc_port *port)
  */
 int fc_port_egress(struct fc_port *port, struct fc_frame *fp)
 {
-	ASSERT(port->np_egress);
+	WARN_ON(!port->np_egress);
 	if (SA_ERROR_INJECT) {
 		fc_frame_free(fp);
 		return EBUSY;
@@ -170,8 +169,8 @@ int fc_port_egress(struct fc_port *port, struct fc_frame *fp)
  */
 void fc_port_ingress(struct fc_port *port, struct fc_frame *fp)
 {
-	ASSERT(port != NULL);
-	ASSERT(port->np_ingress != NULL);
+	WARN_ON(!port);
+	WARN_ON(!(port->np_ingress));
 	(*port->np_ingress) (port->np_ingress_arg, fp);
 }
 
diff --git a/drivers/scsi/ofc/libfc/fc_print.c b/drivers/scsi/ofc/libfc/fc_print.c
index ae6fa1e..2b51a5b 100644
--- a/drivers/scsi/ofc/libfc/fc_print.c
+++ b/drivers/scsi/ofc/libfc/fc_print.c
@@ -22,7 +22,6 @@
  */
 
 #include "sa_kernel.h"
-#include "sa_assert.h"
 #include "net_types.h"
 #include "ofc_dbg.h"
 #include "fc_fs.h"
diff --git a/drivers/scsi/ofc/libfc/fc_remote_port.c b/drivers/scsi/ofc/libfc/fc_remote_port.c
index 9a5e62a..b0061f5 100644
--- a/drivers/scsi/ofc/libfc/fc_remote_port.c
+++ b/drivers/scsi/ofc/libfc/fc_remote_port.c
@@ -26,7 +26,6 @@
 
 #include "sa_kernel.h"
 #undef LIST_HEAD
-#include "sa_assert.h"
 #include "sa_event.h"
 #include "sa_hash.h"
 #include "ofc_dbg.h"
@@ -89,7 +88,7 @@ int fc_remote_port_table_create(struct fc_virt_fab *vp)
 
 void fc_remote_port_table_destroy(struct fc_virt_fab *vp)
 {
-	ASSERT(list_empty(&vp->vf_remote_ports));
+	WARN_ON(!list_empty(&vp->vf_remote_ports));
 	INIT_LIST_HEAD(&vp->vf_remote_ports);
 	if (vp->vf_rport_by_fid)
 		sa_hash_destroy(vp->vf_rport_by_fid);
@@ -226,8 +225,8 @@ void fc_remote_port_set_name(struct fc_remote_port *rp, fc_wwn_t wwpn,
 	if (old_name) {
 		found_rp = sa_hash_lookup_delete(vp->vf_rport_by_wwpn,
 						 &old_name);
-		ASSERT(found_rp);
-		ASSERT(found_rp == rp);
+		WARN_ON(!found_rp);
+		WARN_ON(found_rp != rp);
 	}
 #endif /* FC_REMOTE_PORT_BY_WWPN */
 	rp->rp_node_wwn = wwnn;
@@ -253,8 +252,8 @@ void fc_remote_port_set_fid(struct fc_remote_port *rp, fc_fid_t fid)
 		if (rp->rp_fid != 0) {
 			found_rp = sa_hash_lookup_delete(vp->vf_rport_by_fid,
 							 &rp->rp_fid);
-			ASSERT(found_rp);
-			ASSERT(found_rp == rp);
+			WARN_ON(!found_rp);
+			WARN_ON(found_rp != rp);
 		}
 		rp->rp_fid = fid;
 		if (fid)
@@ -273,15 +272,15 @@ static void fc_remote_port_delete(struct fc_remote_port *rp)
 	if (rp->rp_fid != 0) {
 		found = sa_hash_lookup_delete(rp->rp_vf->vf_rport_by_fid,
 					      &rp->rp_fid);
-		ASSERT(found);
-		ASSERT(found == rp);
+		WARN_ON(!found);
+		WARN_ON(found != rp);
 	}
 #ifdef FC_REMOTE_PORT_BY_WWPN
 	if (rp->rp_port_wwn) {
 		found = sa_hash_lookup_delete(rp->rp_vf->vf_rport_by_wwpn,
 					      &rp->rp_port_wwn);
-		ASSERT(found);
-		ASSERT(found == rp);
+		WARN_ON(!found);
+		WARN_ON(found != rp);
 	}
 #endif /* FC_REMOTE_PORT_BY_WWPN */
 	list_del(&rp->rp_list);
@@ -293,12 +292,10 @@ static void fc_remote_port_delete(struct fc_remote_port *rp)
 void fc_remote_port_hold(struct fc_remote_port *rp)
 {
 	atomic_inc(&rp->rp_refcnt);
-	ASSERT(atomic_read(&rp->rp_refcnt) > 0);
 }
 
 void fc_remote_port_release(struct fc_remote_port *rp)
 {
-	ASSERT(atomic_read(&rp->rp_refcnt) > 0);
 	if (atomic_dec_and_test(&rp->rp_refcnt))
 		fc_remote_port_delete(rp);
 }
diff --git a/drivers/scsi/ofc/libfc/fc_sess.c b/drivers/scsi/ofc/libfc/fc_sess.c
index ee08c97..c218c70 100644
--- a/drivers/scsi/ofc/libfc/fc_sess.c
+++ b/drivers/scsi/ofc/libfc/fc_sess.c
@@ -28,7 +28,6 @@
 #undef LIST_HEAD
 #include "net_types.h"
 
-#include "sa_assert.h"
 #include "ofc_dbg.h"
 #include "sa_timer.h"
 #include "sa_event.h"
@@ -126,8 +125,6 @@ static inline void fc_sess_unlock_send(struct fc_sess *sess)
 	struct fc_local_port *lp;
 	enum fc_sess_state state = sess->fs_state;
 
-	ASSERT(atomic_read(&sess->fs_refcnt) != 0);
-
 	/*
 	 * If the session is in the INIT or ERROR state and the session
 	 * has been started, meaning there's an internal reference, and that's
@@ -166,7 +163,6 @@ static inline void fc_sess_unlock_send(struct fc_sess *sess)
 
 static void fc_sess_state_enter(struct fc_sess *sess, enum fc_sess_state new)
 {
-	ASSERT(fc_sess_locked(sess));
 	if (sess->fs_state != new)
 		sess->fs_retries = 0;
 	sess->fs_state = new;
@@ -272,7 +268,7 @@ struct fc_sess *fc_sess_create(struct fc_local_port *lp,
 	struct fc_virt_fab *vp;
 	u_int64_t key;
 
-	ASSERT(lp->fl_vf == rp->rp_vf);
+	WARN_ON(lp->fl_vf != rp->rp_vf);
 
 	sess = sa_malloc(sizeof(*sess));
 	if (sess) {
@@ -358,9 +354,9 @@ static void fc_sess_delete(struct fc_sess *sess, void *arg)
 
 	if (fc_sess_debug)
 		OFC_DBG("sess to %6x delete", sess->fs_remote_fid);
-	ASSERT(sess);
-	ASSERT(sess->fs_local_port);
-	ASSERT(sess->fs_remote_port);
+	WARN_ON(!sess);
+	WARN_ON(!(sess->fs_local_port));
+	WARN_ON(!(sess->fs_remote_port));
 	lp = sess->fs_local_port;
 	rp = sess->fs_remote_port;
 	vp = lp->fl_vf;
@@ -369,8 +365,8 @@ static void fc_sess_delete(struct fc_sess *sess, void *arg)
 
 	fc_virt_fab_lock(vp);
 	found = sa_hash_lookup_delete(vp->vf_sess_by_fids, &key);
-	ASSERT(found);
-	ASSERT(found == sess);
+	WARN_ON(!found);
+	WARN_ON(found != sess);
 	list_del(&sess->fs_list);			/* under vf_lock */
 	fc_virt_fab_unlock(vp);
 
@@ -384,12 +380,10 @@ static void fc_sess_delete(struct fc_sess *sess, void *arg)
 void fc_sess_hold(struct fc_sess *sess)
 {
 	atomic_inc(&sess->fs_refcnt);
-	ASSERT(atomic_read(&sess->fs_refcnt) != 0);
 }
 
 void fc_sess_release(struct fc_sess *sess)
 {
-	ASSERT(atomic_read(&sess->fs_refcnt) > 0);
 	if (atomic_dec_and_test(&sess->fs_refcnt))
 		fc_sess_delete(sess, NULL);
 }
@@ -458,8 +452,8 @@ void fc_sess_reset(struct fc_sess *sess)
 		key = fc_sess_key(sess->fs_local_fid, sess->fs_remote_fid);
 		vp = lp->fl_vf;
 		found = sa_hash_lookup_delete(vp->vf_sess_by_fids, &key);
-		ASSERT(found);
-		ASSERT(found == sess);
+		WARN_ON(!found);
+		WARN_ON(found != sess);
 		sess->fs_local_fid = lp->fl_fid;
 		key = fc_sess_key(sess->fs_local_fid, sess->fs_remote_fid);
 		sa_hash_insert(vp->vf_sess_by_fids, &key, sess);
@@ -544,8 +538,8 @@ int fc_sess_send_req(struct fc_sess *sess, struct fc_frame *fp,
 	int rc;
 
 	fh = fc_frame_header_get(fp);
-	ASSERT(fh);
-	ASSERT(fh->fh_r_ctl != 0);	/* caller must use fc_frame_setup() */
+	WARN_ON(!fh);
+	WARN_ON(fh->fh_r_ctl == 0); /* caller must use fc_frame_setup() */
 
 	sp = fc_sess_seq_alloc(sess, recv, errh, arg);
 	if (sp) {
@@ -585,6 +579,7 @@ static void fc_sess_enter_started(struct fc_sess *sess)
 	 * Otherwise the local port will be logged on by fc_sess_unlock().
 	 */
 	fc_sess_state_enter(sess, SESS_ST_STARTED);
+
 	lp = sess->fs_local_port;
 	if (sess == lp->fl_dns_sess || fc_local_port_test_ready(lp))
 		fc_sess_enter_plogi(sess);
@@ -655,8 +650,6 @@ static void fc_sess_retry(struct fc_sess *sess)
 {
 	struct fc_local_port *lp;
 
-	ASSERT(fc_sess_locked(sess));
-
 	lp = sess->fs_local_port;
 
 	if (sess->fs_retries < lp->fl_retry_limit) {
@@ -749,7 +742,6 @@ static void fc_sess_enter_plogi(struct fc_sess *sess)
 	struct fc_frame *fp;
 	struct fc_els_flogi *rp;
 
-	ASSERT(fc_sess_locked(sess));
 	fc_sess_state_enter(sess, SESS_ST_PLOGI);
 	sess->fs_max_payload = sess->fs_local_port->fl_max_payload;
 	fp = fc_frame_alloc(sess->fs_local_port->fl_port, sizeof(*rp));
@@ -758,7 +750,7 @@ static void fc_sess_enter_plogi(struct fc_sess *sess)
 		return;
 	}
 	rp = fc_frame_payload_get(fp, sizeof(*rp));
-	ASSERT(rp);
+	WARN_ON(!rp);
 	fc_local_port_flogi_fill(sess->fs_local_port, rp, ELS_PLOGI);
 	sess->fs_e_d_tov = sess->fs_local_port->fl_e_d_tov;
 	fc_frame_setup(fp, FC_RCTL_ELS_REQ, FC_TYPE_ELS);
@@ -824,7 +816,6 @@ static void fc_sess_enter_prli(struct fc_sess *sess)
 	} *pp;
 	struct fc_frame *fp;
 
-	ASSERT(fc_sess_locked(sess));
 	fc_sess_state_enter(sess, SESS_ST_PRLI);
 
 	/*
@@ -842,7 +833,7 @@ static void fc_sess_enter_prli(struct fc_sess *sess)
 		return;
 	}
 	pp = fc_frame_payload_get(fp, sizeof(*pp));
-	ASSERT(pp);
+	WARN_ON(!pp);
 	memset(pp, 0, sizeof(*pp));
 	pp->prli.prli_cmd = ELS_PRLI;
 	pp->prli.prli_spp_len = sizeof(struct fc_els_spp);
@@ -902,7 +893,6 @@ static void fc_sess_enter_rtv(struct fc_sess *sess)
 	struct fc_els_rtv *rtv;
 	struct fc_frame *fp;
 
-	ASSERT(fc_sess_locked(sess));
 	fc_sess_state_enter(sess, SESS_ST_RTV);
 
 	fp = fc_frame_alloc(sess->fs_local_port->fl_port, sizeof(*rtv));
@@ -911,7 +901,7 @@ static void fc_sess_enter_rtv(struct fc_sess *sess)
 		return;
 	}
 	rtv = fc_frame_payload_get(fp, sizeof(*rtv));
-	ASSERT(rtv);
+	WARN_ON(!rtv);
 	memset(rtv, 0, sizeof(*rtv));
 	rtv->rtv_cmd = ELS_RTV;
 	fc_frame_setup(fp, FC_RCTL_ELS_REQ, FC_TYPE_ELS);
@@ -943,7 +933,6 @@ void fc_sess_event_deq(struct fc_sess *sess, sa_event_handler_t handler,
 
 static void fc_sess_enter_ready(struct fc_sess *sess)
 {
-	ASSERT(fc_sess_locked(sess));
 	fc_sess_state_enter(sess, SESS_ST_READY);
 	sa_event_call_cancel(sess->fs_events, FC_EV_CLOSED);
 	sa_event_call_cancel(sess->fs_events, FC_EV_RJT);
@@ -952,7 +941,6 @@ static void fc_sess_enter_ready(struct fc_sess *sess)
 
 static void fc_sess_enter_init(struct fc_sess *sess)
 {
-	ASSERT(fc_sess_locked(sess));
 	fc_sess_state_enter(sess, SESS_ST_INIT);
 	sa_event_call_cancel(sess->fs_events, FC_EV_READY);
 	sa_event_call_cancel(sess->fs_events, FC_EV_RJT);
@@ -961,7 +949,6 @@ static void fc_sess_enter_init(struct fc_sess *sess)
 
 static void fc_sess_enter_error(struct fc_sess *sess)
 {
-	ASSERT(fc_sess_locked(sess));
 	fc_sess_state_enter(sess, SESS_ST_ERROR);
 	sa_event_call_cancel(sess->fs_events, FC_EV_READY);
 	sa_event_call_cancel(sess->fs_events, FC_EV_CLOSED);
@@ -974,8 +961,8 @@ static void fc_sess_enter_logo(struct fc_sess *sess)
 	struct fc_els_logo *logo;
 	struct fc_local_port *lp;
 
-	ASSERT(fc_sess_locked(sess));
 	fc_sess_state_enter(sess, SESS_ST_LOGO);
+
 	lp = sess->fs_local_port;
 	fp = fc_frame_alloc(lp->fl_port, sizeof(*logo));
 	if (!fp) {
@@ -983,7 +970,6 @@ static void fc_sess_enter_logo(struct fc_sess *sess)
 		return;
 	}
 	logo = fc_frame_payload_get(fp, sizeof(*logo));
-	ASSERT(logo);
 	memset(logo, 0, sizeof(*logo));
 	logo->fl_cmd = ELS_LOGO;
 	net24_put(&logo->fl_n_port_id, lp->fl_fid);
@@ -1077,7 +1063,6 @@ void fc_sess_recv_req(struct fc_seq *sp, struct fc_frame *fp, void *sess_arg)
 	u_char op;
 
 	fh = fc_frame_header_get(fp);
-	ASSERT(fp);
 	op = fc_frame_payload_op(fp);
 
 	if (fh->fh_r_ctl == FC_RCTL_ELS_REQ && fh->fh_type == FC_TYPE_ELS) {
@@ -1125,11 +1110,11 @@ static void fc_sess_recv_plogi_req(struct fc_sess *sess,
 	pl = fc_frame_payload_get(fp, sizeof(*pl));
 	if (!pl) {
 		OFC_DBG("incoming PLOGI from %x too short", sid);
+		WARN_ON(1);
 		/* XXX TBD: send reject? */
 		fc_frame_free(fp);
 		return;
 	}
-	ASSERT(pl);		/* checked above */
 	wwpn = net64_get(&pl->fl_wwpn);
 	wwnn = net64_get(&pl->fl_wwnn);
 	fc_sess_lock(sess);
@@ -1207,7 +1192,7 @@ static void fc_sess_recv_plogi_req(struct fc_sess *sess,
 		fc_frame_free(fp);
 	} else {
 		sp = fc_seq_start_next(sp);
-		ASSERT(sp);
+		WARN_ON(!sp);
 		fc_frame_free(rx_fp);
 		fc_remote_port_set_name(rp, wwpn, wwnn);
 
@@ -1217,7 +1202,7 @@ static void fc_sess_recv_plogi_req(struct fc_sess *sess,
 		sess->fs_max_payload = (uint16_t)
 		    fc_local_port_get_payload_size(pl, lp->fl_max_payload);
 		pl = fc_frame_payload_get(fp, sizeof(*pl));
-		ASSERT(pl);
+		WARN_ON(!pl);
 		fc_local_port_flogi_fill(lp, pl, ELS_LS_ACC);
 
 		/*
@@ -1297,9 +1282,9 @@ static void fc_sess_recv_prli_req(struct fc_sess *sess,
 		fc_seq_ls_rjt(sp, reason, explan);
 	} else {
 		sp = fc_seq_start_next(sp);
-		ASSERT(sp);
+		WARN_ON(!sp);
 		pp = fc_frame_payload_get(fp, len);
-		ASSERT(pp);
+		WARN_ON(!pp);
 		memset(pp, 0, len);
 		pp->prli.prli_cmd = ELS_LS_ACC;
 		pp->prli.prli_spp_len = plen;
@@ -1324,7 +1309,7 @@ static void fc_sess_recv_prli_req(struct fc_sess *sess,
 				break;
 			case FC_TYPE_FCP:
 				rp = sess->fs_remote_port;
-				ASSERT(rp);
+				WARN_ON(!rp);
 				rp->rp_fcp_parm = net32_get(&rspp->spp_params);
 				net32_put(&spp->spp_params,
 					  rp->rp_local_fcp_parm);
@@ -1426,9 +1411,9 @@ struct fc_sess *fc_sess_lookup_create(struct fc_local_port *lp,
 	struct fc_sess *sess;
 	u_int64_t key;
 
-	ASSERT(fid != 0);
-	ASSERT(lp);
-	ASSERT(lp->fl_vf);
+	WARN_ON(fid == 0);
+	WARN_ON(!lp);
+	WARN_ON(!(lp->fl_vf));
 
 	vp = lp->fl_vf;
 
diff --git a/drivers/scsi/ofc/libfc/fc_virt_fab.c b/drivers/scsi/ofc/libfc/fc_virt_fab.c
index ff87244..dd84628 100644
--- a/drivers/scsi/ofc/libfc/fc_virt_fab.c
+++ b/drivers/scsi/ofc/libfc/fc_virt_fab.c
@@ -26,7 +26,6 @@
 
 #include "sa_kernel.h"
 #undef LIST_HEAD
-#include "sa_assert.h"
 #include "sa_event.h"
 #include "net_types.h"
 
diff --git a/drivers/scsi/ofc/libfc/fcs_attr.c b/drivers/scsi/ofc/libfc/fcs_attr.c
index 5b355de..cc6ad1f 100644
--- a/drivers/scsi/ofc/libfc/fcs_attr.c
+++ b/drivers/scsi/ofc/libfc/fcs_attr.c
@@ -35,7 +35,6 @@
 #include <scsi/scsi_tcq.h>
 
 #include "sa_kernel.h"
-#include "sa_assert.h"
 #include "ofc_dbg.h"
 #include "sa_event.h"
 #include "net_types.h"
diff --git a/drivers/scsi/ofc/libfc/fcs_cmd.c b/drivers/scsi/ofc/libfc/fcs_cmd.c
index 5564f82..fb066bd 100644
--- a/drivers/scsi/ofc/libfc/fcs_cmd.c
+++ b/drivers/scsi/ofc/libfc/fcs_cmd.c
@@ -18,7 +18,6 @@
  */
 
 #include "sa_kernel.h"
-#include "sa_assert.h"
 #include "ofc_dbg.h"
 #include "fc_types.h"
 #include "fc_event.h"
@@ -90,7 +89,7 @@ int fcs_cmd_send(struct fcs_state *sp, struct fc_frame *fp,
 	int rc;
 
 	might_sleep();
-	ASSERT(!rfp->fr_sg_len);
+	WARN_ON(rfp->fr_sg_len);
 	lp = sp->fs_local_port;
 	fh = fc_frame_header_get(fp);
 
@@ -198,8 +197,8 @@ static void fcs_cmd_recv(struct fc_seq *seq, struct fc_frame *fp, void *arg)
 	uint32_t len;
 	u_int error = 0;	/* XXX for debugging */
 
-	ASSERT(!fp->fr_sg_len);
-	ASSERT(!(fp->fr_flags & FCPHF_CRC_UNCHECKED));
+	WARN_ON(fp->fr_sg_len);
+	WARN_ON((fp->fr_flags & FCPHF_CRC_UNCHECKED) == FCPHF_CRC_UNCHECKED);
 
 	fh = fc_frame_header_get(fp);
 	if (fh->fh_type != cp->fcc_req_hdr.fh_type)
diff --git a/drivers/scsi/ofc/libfc/fcs_event.c b/drivers/scsi/ofc/libfc/fcs_event.c
index d6ab9d9..5d5cfa6 100644
--- a/drivers/scsi/ofc/libfc/fcs_event.c
+++ b/drivers/scsi/ofc/libfc/fcs_event.c
@@ -32,7 +32,7 @@
 #include <scsi/scsi_cmnd.h>
 #include <scsi/scsi_transport.h>
 #include <scsi/scsi_transport_fc.h>
-#include "sa_assert.h"
+
 #include "ofc_dbg.h"
 #include "fc_types.h"
 #include "fc_frame.h"
@@ -87,7 +87,6 @@ static struct fcs_ev_elem *fcs_ev_peek(struct fcs_event_queue *qp)
 {
 	struct fcs_ev_elem *fp = NULL;
 
-	ASSERT(spin_is_locked(&qp->fev_lock));
 	if (!list_empty(&qp->fev_list))
 		fp = list_entry(qp->fev_list.next, struct fcs_ev_elem, ev_list);
 	return fp;
diff --git a/drivers/scsi/ofc/libfc/fcs_state.c b/drivers/scsi/ofc/libfc/fcs_state.c
index 794f440..78dd61a 100644
--- a/drivers/scsi/ofc/libfc/fcs_state.c
+++ b/drivers/scsi/ofc/libfc/fcs_state.c
@@ -18,7 +18,6 @@
  */
 
 #include "sa_kernel.h"
-#include "sa_assert.h"
 #include "ofc_dbg.h"
 #include "fc_types.h"
 #include "fc_frame.h"
@@ -79,8 +78,8 @@ struct fcs_state *fcs_create(struct fcs_create_args *ap)
 	struct fc_port *outer_port;
 	size_t mfs;
 
-	ASSERT(ap->fca_disc_done);
-	ASSERT(ap->fca_port);
+	WARN_ON(!ap->fca_disc_done);
+	WARN_ON(!ap->fca_port);
 
 	sp = sa_malloc(sizeof(*sp));
 	if (!sp)
@@ -145,7 +144,7 @@ void fcs_destroy(struct fcs_state *sp)
 {
 	struct fc_port *port;
 
-	ASSERT(sp->fs_args.fca_port);
+	WARN_ON(!sp->fs_args.fca_port);
 
 	sp->fs_args.fca_disc_done = (void (*)(void *))fcs_nop;
 	sp->fs_args.fca_remote_port_state_change =
@@ -196,7 +195,6 @@ static void fcs_recv_req(void *sp_arg, struct fc_frame *fp)
 	struct fc_frame_header *fh;
 
 	fh = fc_frame_header_get(fp);
-	ASSERT(fh);
 
 	if (fh->fh_type == FC_TYPE_FCP && sp->fs_args.fca_fcp_recv) {
 		(*sp->fs_args.fca_fcp_recv) (fp->fr_seq,
@@ -215,8 +213,8 @@ int fcs_local_port_set(struct fcs_state *sp, fc_wwn_t wwnn, fc_wwn_t wwpn)
 {
 	struct fc_local_port *lp;
 
-	ASSERT(sp->fs_inner_port);
-	ASSERT(!sp->fs_local_port);
+	WARN_ON(!sp->fs_inner_port);
+	WARN_ON(sp->fs_local_port);
 	lp = fc_local_port_create(sp->fs_vf, sp->fs_inner_port, wwpn, wwnn,
 				  sp->fs_args.fca_e_d_tov,
 				  sp->fs_args.fca_plogi_retries);
@@ -236,7 +234,7 @@ int fcs_local_port_set(struct fcs_state *sp, fc_wwn_t wwnn, fc_wwn_t wwpn)
  */
 void fcs_start(struct fcs_state *sp)
 {
-	ASSERT(sp->fs_local_port);
+	WARN_ON(!sp->fs_local_port);
 	fc_local_port_logon(sp->fs_local_port, fcs_local_port_event, sp);
 }
 
@@ -245,7 +243,7 @@ void fcs_start(struct fcs_state *sp)
  */
 void fcs_stop(struct fcs_state *sp)
 {
-	ASSERT(sp->fs_local_port);
+	WARN_ON(!sp->fs_local_port);
 	fc_local_port_logoff(sp->fs_local_port);
 }
 
@@ -259,7 +257,7 @@ void fcs_reset(struct fcs_state *sp)
 {
 	struct fc_local_port *lp;
 
-	ASSERT(sp->fs_local_port);
+	WARN_ON(!sp->fs_local_port);
 	lp = sp->fs_local_port;
 	sp->fs_disc_done = 0;
 	fc_local_port_reset(lp);
@@ -336,10 +334,10 @@ static void fcs_add_remote(void *fcs_arg, struct fc_remote_port *rp,
 	struct fc_sess *sess;
 
 	lp = sp->fs_local_port;
-	ASSERT(lp);
+	WARN_ON(!lp);
 
 	if (event == FC_EV_CLOSED) {
-		ASSERT(rp->rp_sess_ready == 0);
+		WARN_ON(rp->rp_sess_ready != 0);
 		if (fcs_debug)
 			OFC_DBG("removing remote fid %x wwpn %llx ref %d",
 			       rp->rp_fid, rp->rp_port_wwn,
@@ -386,7 +384,6 @@ static void fcs_sess_event(int event, void *rp_arg)
 	void *arg;
 
 	sp = rp->rp_fcs_priv;
-	ASSERT(sp);
 	arg = sp->fs_args.fca_cb_arg;
 
 	switch (event) {
@@ -441,7 +438,7 @@ static void fcs_port_event(int event, void *sp_arg)
 		fcs_ev_add(sp, OFC_EV_LINK_UP, NULL, 0);
 		break;
 	}
-	ASSERT(sp->fs_inner_port);
+	WARN_ON(!sp->fs_inner_port);
 	fc_port_send_event(sp->fs_inner_port, event);
 }
 

