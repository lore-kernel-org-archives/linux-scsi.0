From: Vasu Dev <vasu.dev@intel.com>
Subject: [PATCH 3/5] Removed outer port use in fc_exch
Date: Mon, 25 Feb 2008 03:20:21 -0800
Message-ID: <20080225112021.22380.45522.stgit@vdinit.jf.intel.com>
References: <20080225111856.22380.70951.stgit@vdinit.jf.intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mga02.intel.com ([134.134.136.20]:7145 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754394AbYBYTcC (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Mon, 25 Feb 2008 14:32:02 -0500
In-Reply-To: <20080225111856.22380.70951.stgit@vdinit.jf.intel.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org, devel@open-fcoe.org

Used fcdev for frame_alloc instead outer port. The frame_alloc() is modified
in next patch with its all other references.

Signed-off-by: Vasu Dev <vasu.dev@intel.com>
---

 drivers/scsi/ofc/include/fc_exch.h     |    5 +++--
 drivers/scsi/ofc/include/fc_frame.h    |    2 ++
 drivers/scsi/ofc/libfc/fc_exch.c       |   32 ++++++++++++++++----------------
 drivers/scsi/ofc/libfc/fc_exch_impl.h  |    4 ++--
 drivers/scsi/ofc/libfc/fc_local_port.c |    2 +-
 drivers/scsi/ofc/libfc/fc_sess.c       |    2 +-
 drivers/scsi/ofc/libfc/fcs_cmd.c       |    2 +-
 drivers/scsi/ofc/libfc/fcs_state.c     |    1 +
 8 files changed, 27 insertions(+), 23 deletions(-)

diff --git a/drivers/scsi/ofc/include/fc_exch.h b/drivers/scsi/ofc/include/fc_exch.h
index 91339ca..b97263f 100644
--- a/drivers/scsi/ofc/include/fc_exch.h
+++ b/drivers/scsi/ofc/include/fc_exch.h
@@ -27,6 +27,7 @@
 #include "fc_event.h"
 #include "fc_fs.h"
 #include "fc_els.h"
+#include "fcdev.h"
 
 /*
  * Principles of Operation.
@@ -92,9 +93,9 @@ void fc_exch_mgr_reset(struct fc_exch_mgr *, fc_fid_t s_id, fc_fid_t d_id);
 void fc_exch_set_addr(struct fc_exch *, fc_fid_t orig, fc_fid_t resp);
 
 /*
- * Set the output port to be used for an exchange.
+ * Set the device to be used for an exchange.
  */
-void fc_exch_set_port(struct fc_exch *, struct fc_port *);
+void fc_exch_set_dev(struct fc_exch *, struct fcdev *);
 
 /*
  * Start a new sequence as originator on a new exchange.
diff --git a/drivers/scsi/ofc/include/fc_frame.h b/drivers/scsi/ofc/include/fc_frame.h
index 3fce700..7c7e0c5 100644
--- a/drivers/scsi/ofc/include/fc_frame.h
+++ b/drivers/scsi/ofc/include/fc_frame.h
@@ -44,6 +44,7 @@
 
 struct fc_frame {
 	struct fc_port	*fr_in_port;	/* port where frame was received */
+	struct fcdev	*dev;		/* fc device instance */
 	struct fc_seq	*fr_seq;	/* for use with exchange manager */
 	struct fc_frame_header *fr_hdr;	/* pointer to frame header in buffer */
 	const char	*fr_stamp;	/* debug info on last usage */
@@ -85,6 +86,7 @@ struct fc_frame {
 static inline void fc_frame_init(struct fc_frame *fp)
 {
 	fp->fr_in_port = NULL;
+	fp->dev = NULL;
 	fp->fr_seq = NULL;
 	fp->fr_flags = 0;
 	fp->fr_sg_len = 0;
diff --git a/drivers/scsi/ofc/libfc/fc_exch.c b/drivers/scsi/ofc/libfc/fc_exch.c
index db67d98..a6ea157 100644
--- a/drivers/scsi/ofc/libfc/fc_exch.c
+++ b/drivers/scsi/ofc/libfc/fc_exch.c
@@ -481,7 +481,7 @@ int fc_seq_abort_exch(const struct fc_seq *req_sp)
 		/*
 		 * Send an abort for the sequence that timed out.
 		 */
-		fp = fc_frame_alloc(ep->ex_port, 0);
+		fp = fc_frame_alloc(ep->dev, 0);
 		if (fp) {
 			fc_frame_setup(fp, FC_RCTL_BA_ABTS, FC_TYPE_BLS);
 			sp->seq_f_ctl |= FC_FC_SEQ_INIT;
@@ -609,7 +609,7 @@ static struct fc_exch *fc_exch_resp(struct fc_exch_mgr *mp,
 
 	ep = fc_exch_alloc(mp);
 	if (ep) {
-		ep->ex_port = fp->fr_in_port;
+		ep->dev = fp->dev;
 		ep->ex_class = fc_frame_class(fp);
 
 		/*
@@ -788,9 +788,9 @@ static struct fc_seq *fc_seq_lookup_orig(struct fc_exch_mgr *mp,
 /*
  * Set the output port to be used for an exchange.
  */
-void fc_exch_set_port(struct fc_exch *ep, struct fc_port *port)
+void fc_exch_set_dev(struct fc_exch *ep, struct fcdev *dev)
 {
-	ep->ex_port = port;
+	ep->dev = dev;
 }
 
 /*
@@ -934,7 +934,7 @@ size_t fc_seq_mfs(struct fc_seq *sp)
 int fc_seq_send_frag(struct fc_seq *sp, struct fc_frame *fp)
 {
 	struct fc_exch *ep;
-	struct fc_port *port;
+	struct fcdev *dev;
 	struct fc_frame_header *fh;
 	enum fc_class class;
 	u_int32_t f_ctl;
@@ -942,7 +942,7 @@ int fc_seq_send_frag(struct fc_seq *sp, struct fc_frame *fp)
 
 	ep = fc_seq_exch(sp);
 	WARN_ON((ep->ex_e_stat & ESB_ST_SEQ_INIT) != ESB_ST_SEQ_INIT);
-	port = ep->ex_port;
+	dev = ep->dev;
 
 	WARN_ON((sp->seq_f_ctl & FC_FC_END_SEQ) != 0);
 	WARN_ON(fp->fr_len % 4 != 0);	/* can't pad except on last frame */
@@ -969,7 +969,7 @@ int fc_seq_send_frag(struct fc_seq *sp, struct fc_frame *fp)
 	/*
 	 * Send the frame.
 	 */
-	error = fc_port_egress(port, fp);
+	error = dev->port_ops.send(dev, fp);
 
 	/*
 	 * Update the exchange and sequence flags.
@@ -989,7 +989,7 @@ int fc_seq_send_frag(struct fc_seq *sp, struct fc_frame *fp)
 int fc_seq_send(struct fc_seq *sp, struct fc_frame *fp)
 {
 	struct fc_exch *ep;
-	struct fc_port *port;
+	struct fcdev *dev;
 	struct fc_frame_header *fh;
 	enum fc_class class;
 	u_int32_t f_ctl;
@@ -998,7 +998,7 @@ int fc_seq_send(struct fc_seq *sp, struct fc_frame *fp)
 
 	ep = fc_seq_exch(sp);
 	WARN_ON((ep->ex_e_stat & ESB_ST_SEQ_INIT) != ESB_ST_SEQ_INIT);
-	port = ep->ex_port;
+	dev = ep->dev;
 	WARN_ON((sp->seq_f_ctl & FC_FC_END_SEQ) != 0);
 
 	class = ep->ex_class;
@@ -1032,7 +1032,7 @@ int fc_seq_send(struct fc_seq *sp, struct fc_frame *fp)
 	/*
 	 * Send the frame.
 	 */
-	error = fc_port_egress(port, fp);
+	error = dev->port_ops.send(dev, fp);
 
 	/*
 	 * Update the exchange and sequence flags,
@@ -1115,7 +1115,7 @@ static void fc_seq_send_ack(struct fc_seq *sp, const struct fc_frame *rx_fp)
 	 * Don't send ACKs for class 3.
 	 */
 	if (fc_sof_needs_ack(rx_fp->fr_sof)) {
-		fp = fc_frame_alloc(fc_seq_exch(sp)->ex_port, 0);
+		fp = fc_frame_alloc(fc_seq_exch(sp)->dev, 0);
 		BUG_ON(!fp);
 		if (!fp)
 			return;
@@ -1150,7 +1150,7 @@ static void fc_seq_send_ack(struct fc_seq *sp, const struct fc_frame *rx_fp)
 		} else {
 			fp->fr_eof = FC_EOF_N;
 		}
-		(void)fc_port_egress(rx_fp->fr_in_port, fp);
+		(void) rx_fp->dev->port_ops.send(rx_fp->dev, fp);
 	}
 }
 
@@ -1451,7 +1451,7 @@ void fc_seq_ls_acc(struct fc_seq *req_sp)
 	struct fc_frame *fp;
 
 	sp = fc_seq_start_next(req_sp);
-	fp = fc_frame_alloc(fc_seq_exch(sp)->ex_port, sizeof(*acc));
+	fp = fc_frame_alloc(fc_seq_exch(sp)->dev, sizeof(*acc));
 	if (fp) {
 		acc = fc_frame_payload_get(fp, sizeof(*acc));
 		memset(acc, 0, sizeof(*acc));
@@ -1475,7 +1475,7 @@ void fc_seq_ls_rjt(struct fc_seq *req_sp, enum fc_els_rjt_reason reason,
 	struct fc_frame *fp;
 
 	sp = fc_seq_start_next(req_sp);
-	fp = fc_frame_alloc(fc_seq_exch(sp)->ex_port, sizeof(*rjt));
+	fp = fc_frame_alloc(fc_seq_exch(sp)->dev, sizeof(*rjt));
 	if (fp) {
 		rjt = fc_frame_payload_get(fp, sizeof(*rjt));
 		memset(rjt, 0, sizeof(*rjt));
@@ -1533,7 +1533,7 @@ struct fc_seq *fc_seq_rec_req(struct fc_seq *inq_sp,
 	struct fc_els_rec *rp;
 
 	ep = fc_seq_exch(inq_sp);
-	fp = fc_frame_alloc(ep->ex_port, sizeof(*rp));
+	fp = fc_frame_alloc(ep->dev, sizeof(*rp));
 	if (!fp)
 		return NULL;
 	sp = fc_seq_start_exch(ep->ex_pool->emp_mgr, recv, errh, arg,
@@ -1542,7 +1542,7 @@ struct fc_seq *fc_seq_rec_req(struct fc_seq *inq_sp,
 		fc_frame_free(fp);
 		return NULL;
 	}
-	fc_seq_exch(sp)->ex_port = ep->ex_port;
+	fc_seq_exch(sp)->dev = ep->dev;
 	rp = fc_frame_payload_get(fp, sizeof(*rp));
 	memset(rp, 0, sizeof(*rp));
 	rp->rec_cmd = ELS_REC;
diff --git a/drivers/scsi/ofc/libfc/fc_exch_impl.h b/drivers/scsi/ofc/libfc/fc_exch_impl.h
index 98eeee2..9b798fd 100644
--- a/drivers/scsi/ofc/libfc/fc_exch_impl.h
+++ b/drivers/scsi/ofc/libfc/fc_exch_impl.h
@@ -77,8 +77,8 @@ struct fc_exch {
 	/*
 	 * Fields after ex_refcnt are cleared when an exchange is reallocated.
 	 */
-#define fc_exch_clear_start ex_port
-	struct fc_port 	*ex_port;	/* port to peer (s/b in remote port) */
+#define fc_exch_clear_start dev
+	struct fcdev 	*dev;		/* fc device instance */
 	fc_xid_t	ex_ox_id;	/* originator's exchange ID */
 	fc_xid_t	ex_rx_id;	/* responder's exchange ID */
 	fc_fid_t	ex_orig_fid;	/* originator's FCID */
diff --git a/drivers/scsi/ofc/libfc/fc_local_port.c b/drivers/scsi/ofc/libfc/fc_local_port.c
index be5a559..6160bdf 100644
--- a/drivers/scsi/ofc/libfc/fc_local_port.c
+++ b/drivers/scsi/ofc/libfc/fc_local_port.c
@@ -398,7 +398,7 @@ static void fc_local_port_els_send(struct fc_local_port *lp,
 				   struct fc_seq *sp, struct fc_frame *fp)
 {
 	if (sp && fp) {
-		fc_seq_exch(sp)->ex_port = lp->fl_port;
+		fc_seq_exch(sp)->dev = lp->dev;
 		fc_exch_timer_set(fc_seq_exch(sp), lp->fl_e_d_tov);
 		if (fc_seq_send_req(sp, fp, FC_RCTL_ELS_REQ, FC_TYPE_ELS, 0))
 			fc_local_port_retry(lp);
diff --git a/drivers/scsi/ofc/libfc/fc_sess.c b/drivers/scsi/ofc/libfc/fc_sess.c
index 1eb3bc3..0d5f611 100644
--- a/drivers/scsi/ofc/libfc/fc_sess.c
+++ b/drivers/scsi/ofc/libfc/fc_sess.c
@@ -519,7 +519,7 @@ struct fc_seq *fc_sess_seq_alloc(struct fc_sess *sess,
 			       sess->fs_remote_fid);
 	if (sp) {
 		ep = fc_seq_exch(sp);
-		ep->ex_port = lp->fl_port;
+		ep->dev = lp->dev;
 		ep->ex_max_payload = sess->fs_max_payload;
 	}
 	return sp;
diff --git a/drivers/scsi/ofc/libfc/fcs_cmd.c b/drivers/scsi/ofc/libfc/fcs_cmd.c
index fb066bd..3253abd 100644
--- a/drivers/scsi/ofc/libfc/fcs_cmd.c
+++ b/drivers/scsi/ofc/libfc/fcs_cmd.c
@@ -140,7 +140,7 @@ int fcs_cmd_send(struct fcs_state *sp, struct fc_frame *fp,
 	}
 
 	cp->fcc_seq = seq;
-	fc_exch_set_port(fc_seq_exch(seq), sp->fs_args.fca_port);
+	fc_exch_set_dev(fc_seq_exch(seq), sp->fs_args.dev);
 	cp->fcc_req_hdr = *fh;
 	kref_get(&cp->fcc_kref);	/* take ref for response */
 
diff --git a/drivers/scsi/ofc/libfc/fcs_state.c b/drivers/scsi/ofc/libfc/fcs_state.c
index e514504..0669427 100644
--- a/drivers/scsi/ofc/libfc/fcs_state.c
+++ b/drivers/scsi/ofc/libfc/fcs_state.c
@@ -178,6 +178,7 @@ void fcs_recv(struct fcs_state *sp, struct fc_frame *fp)
 
 	if (sp->fs_local_port) {
 		fp->fr_in_port = sp->fs_inner_port;
+		fp->dev = sp->fs_args.dev;
 		fc_local_port_recv(sp->fs_local_port, fp);
 	} else {
 		OFC_DBG("fcs_local_port_set needed before receiving");

