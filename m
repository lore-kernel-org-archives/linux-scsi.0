From: Vasu Dev <vasu.dev@intel.com>
Subject: [PATCH 5/5] Removed fc_port from fc_frame_alloc()
Date: Mon, 25 Feb 2008 03:20:33 -0800
Message-ID: <20080225112033.22380.86888.stgit@vdinit.jf.intel.com>
References: <20080225111856.22380.70951.stgit@vdinit.jf.intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mga02.intel.com ([134.134.136.20]:41542 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758218AbYBYT2d (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Mon, 25 Feb 2008 14:28:33 -0500
In-Reply-To: <20080225111856.22380.70951.stgit@vdinit.jf.intel.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org, devel@open-fcoe.org

Instead used fcdev.

Signed-off-by: Vasu Dev <vasu.dev@intel.com>
---

 drivers/scsi/ofc/include/fc_frame.h    |   17 +++++++++--------
 drivers/scsi/ofc/libfc/fc_disc_targ.c  |    4 ++--
 drivers/scsi/ofc/libfc/fc_frame.c      |    4 ++--
 drivers/scsi/ofc/libfc/fc_local_port.c |   18 +++++++++---------
 drivers/scsi/ofc/libfc/fc_sess.c       |   12 ++++++------
 drivers/scsi/ofc/openfc/openfc_ioctl.c |    4 ++--
 drivers/scsi/ofc/openfc/openfc_scsi.c  |    9 ++++-----
 7 files changed, 34 insertions(+), 34 deletions(-)

diff --git a/drivers/scsi/ofc/include/fc_frame.h b/drivers/scsi/ofc/include/fc_frame.h
index 7c7e0c5..e30686d 100644
--- a/drivers/scsi/ofc/include/fc_frame.h
+++ b/drivers/scsi/ofc/include/fc_frame.h
@@ -29,6 +29,7 @@
 #include "fc_fs.h"
 #include "fc_encaps.h"
 #include "fc_port.h"
+#include "fcdev.h"
 
 #include <linux/scatterlist.h>
 
@@ -120,18 +121,18 @@ static inline int fc_frame_freed_static(struct fc_frame *fp)
  */
 struct fc_frame *fc_frame_alloc_int(size_t payload_size);
 
-struct fc_frame *fc_frame_alloc_fill(struct fc_port *, size_t payload_len);
+struct fc_frame *fc_frame_alloc_fill(struct fcdev *, size_t payload_len);
 
 /*
  * Get frame for sending via port.
  */
-static inline struct fc_frame *fc_port_frame_alloc(struct fc_port *port,
+static inline struct fc_frame *_fc_frame_alloc(struct fcdev *dev,
 	size_t payload_len)
 {
-	return (*port->np_frame_alloc)(payload_len);
+	return ((dev->port_ops.frame_alloc)(payload_len));
 }
 
-static inline struct fc_frame *fc_frame_alloc_inline(struct fc_port *port,
+static inline struct fc_frame *fc_frame_alloc_inline(struct fcdev *dev,
 		size_t len, const char *stamp)
 {
 	struct fc_frame *fp;
@@ -141,9 +142,9 @@ static inline struct fc_frame *fc_frame_alloc_inline(struct fc_port *port,
 	 * this check will usually be evaluated and eliminated at compile time.
 	 */
 	if ((len % 4) != 0)
-		fp = fc_frame_alloc_fill(port, len);
+		fp = fc_frame_alloc_fill(dev, len);
 	else
-		fp = fc_port_frame_alloc(port, len);
+		fp = _fc_frame_alloc(dev, len);
 #ifdef FC_FRAME_DEBUG
 	if (fp)
 		fp->fr_stamp = stamp;
@@ -156,8 +157,8 @@ static inline struct fc_frame *fc_frame_alloc_inline(struct fc_port *port,
  * payload_size + sizeof (struct fc_frame_header).
  * This version of fc_frame_alloc() stamps the frame to help find leaks.
  */
-#define fc_frame_alloc(port, len) \
-	fc_frame_alloc_inline(port, len, __FUNCTION__)
+#define fc_frame_alloc(dev, len) \
+	fc_frame_alloc_inline(dev, len, __FUNCTION__)
 /*
  * Free the fc_frame structure and buffer.
  */
diff --git a/drivers/scsi/ofc/libfc/fc_disc_targ.c b/drivers/scsi/ofc/libfc/fc_disc_targ.c
index b6a5d64..c200b04 100644
--- a/drivers/scsi/ofc/libfc/fc_disc_targ.c
+++ b/drivers/scsi/ofc/libfc/fc_disc_targ.c
@@ -340,7 +340,7 @@ static void fcdt_gpn_ft_req(struct fc_local_port *lp)
 
 	lp->fl_disc_buf_len = 0;
 	lp->fl_disc_seq_cnt = 0;
-	fp = fc_frame_alloc(lp->fl_port, sizeof(*rp));
+	fp = fc_frame_alloc(lp->dev, sizeof(*rp));
 	if (fp == NULL) {
 		error = ENOMEM;
 	} else {
@@ -562,7 +562,7 @@ static int fcdt_gpn_id_req(struct fc_local_port *lp, struct fc_remote_port *rp)
 	} *cp;
 	int error;
 
-	fp = fc_frame_alloc(lp->fl_port, sizeof(*cp));
+	fp = fc_frame_alloc(lp->dev, sizeof(*cp));
 	if (fp == NULL) {
 		error = ENOMEM;
 	} else {
diff --git a/drivers/scsi/ofc/libfc/fc_frame.c b/drivers/scsi/ofc/libfc/fc_frame.c
index 34d7a8a..359018d 100644
--- a/drivers/scsi/ofc/libfc/fc_frame.c
+++ b/drivers/scsi/ofc/libfc/fc_frame.c
@@ -52,7 +52,7 @@ u_int32_t fc_frame_crc_check(struct fc_frame *fp)
 	return (error);
 }
 
-struct fc_frame *fc_frame_alloc_fill(struct fc_port *port, size_t payload_len)
+struct fc_frame *fc_frame_alloc_fill(struct fcdev *dev, size_t payload_len)
 {
 	struct fc_frame *fp;
 	size_t fill;
@@ -60,7 +60,7 @@ struct fc_frame *fc_frame_alloc_fill(struct fc_port *port, size_t payload_len)
 	fill = payload_len % 4;
 	if (fill != 0)
 		fill = 4 - fill;
-	fp = fc_port_frame_alloc(port, payload_len + fill);
+	fp = _fc_frame_alloc(dev, payload_len + fill);
 	if (fp) {
 		fp->fr_len -= fill;
 		memset((char *)fp->fr_hdr + fp->fr_len, 0, fill);
diff --git a/drivers/scsi/ofc/libfc/fc_local_port.c b/drivers/scsi/ofc/libfc/fc_local_port.c
index 6160bdf..f0c5625 100644
--- a/drivers/scsi/ofc/libfc/fc_local_port.c
+++ b/drivers/scsi/ofc/libfc/fc_local_port.c
@@ -421,7 +421,7 @@ static void fc_local_port_flogi_send(struct fc_local_port *lp)
 	sp = fc_seq_start_exch(lp->fl_vf->vf_exch_mgr,
 			       fc_local_port_flogi_resp,
 			       fc_local_port_error, lp, 0, FC_FID_FLOGI);
-	fp = fc_frame_alloc(lp->fl_port, sizeof(*flp));
+	fp = fc_frame_alloc(lp->dev, sizeof(*flp));
 	if (fp) {
 		flp = fc_frame_payload_get(fp, sizeof(*flp));
 		fc_local_port_flogi_fill(lp, flp, ELS_FLOGI);
@@ -486,7 +486,7 @@ static void fc_local_port_recv_flogi_req(struct fc_seq *sp_in,
 
 	fc_local_port_enter_ready(lp);
 
-	fp = fc_frame_alloc(lp->fl_port, sizeof(*flp));
+	fp = fc_frame_alloc(lp->dev, sizeof(*flp));
 	if (fp) {
 		sp = fc_seq_start_next(rx_fp->fr_seq);
 		fc_seq_set_addr(sp, remote_fid, local_fid);
@@ -657,7 +657,7 @@ static void fc_local_port_enter_reg_pn(struct fc_local_port *lp)
 	} *rp;
 
 	fc_local_port_enter_state(lp, LOCAL_PORT_ST_REG_PN);
-	fp = fc_frame_alloc(lp->fl_port, sizeof(*rp));
+	fp = fc_frame_alloc(lp->dev, sizeof(*rp));
 	if (!fp) {
 		fc_local_port_retry(lp);
 		return;
@@ -718,7 +718,7 @@ static void fc_local_port_enter_reg_ft(struct fc_local_port *lp)
 		if (net32_get(&lps->ff_type_map[i]) != 0)
 			break;
 	if (i >= 0) {
-		fp = fc_frame_alloc(lp->fl_port, sizeof(*rp));
+		fp = fc_frame_alloc(lp->dev, sizeof(*rp));
 		if (fp) {
 			rp = fc_frame_payload_get(fp, sizeof(*rp));
 			fc_local_port_fill_dns_hdr(lp, &rp->ct,
@@ -750,7 +750,7 @@ static void fc_local_port_enter_scr(struct fc_local_port *lp)
 	sp = fc_seq_start_exch(lp->fl_vf->vf_exch_mgr,
 			       fc_local_port_scr_resp, fc_local_port_error,
 			       lp, lp->fl_fid, FC_FID_FCTRL);
-	fp = fc_frame_alloc(lp->fl_port, sizeof(*scr));
+	fp = fc_frame_alloc(lp->dev, sizeof(*scr));
 	if (fp) {
 		scr = fc_frame_payload_get(fp, sizeof(*scr));
 		memset(scr, 0, sizeof(*scr));
@@ -831,7 +831,7 @@ static void fc_local_port_enter_logo(struct fc_local_port *lp)
 			       fc_local_port_logo_resp,
 			       fc_local_port_error, lp, lp->fl_fid,
 			       FC_FID_FLOGI);
-	fp = fc_frame_alloc(lp->fl_port, sizeof(*logo));
+	fp = fc_frame_alloc(lp->dev, sizeof(*logo));
 	if (fp) {
 		logo = fc_frame_payload_get(fp, sizeof(*logo));
 		memset(logo, 0, sizeof(*logo));
@@ -1348,7 +1348,7 @@ static void fc_local_port_echo_req(struct fc_seq *sp, struct fc_frame *in_fp,
 
 	if (len < sizeof(net32_t))
 		len = sizeof(net32_t);
-	fp = fc_frame_alloc(lp->fl_port, len);
+	fp = fc_frame_alloc(lp->dev, len);
 	if (fp) {
 		dp = fc_frame_payload_get(fp, len);
 		memcpy(dp, pp, len);
@@ -1389,7 +1389,7 @@ static void fc_local_port_rnid_req(struct fc_seq *sp, struct fc_frame *in_fp,
 			fmt = ELS_RNIDF_NONE;	/* nothing to provide */
 			len -= sizeof(rp->gen);
 		}
-		fp = fc_frame_alloc(lp->fl_port, len);
+		fp = fc_frame_alloc(lp->dev, len);
 		if (fp) {
 			rp = fc_frame_payload_get(fp, len);
 			memset(rp, 0, len);
@@ -1750,7 +1750,7 @@ static int fc_local_port_send_gid_pn(struct fc_local_port_handle *lp_handle)
 		struct fc_ns_gid_pn pn;
 	} *req;
 
-	fp = fc_frame_alloc(lp->fl_port, sizeof(*req));
+	fp = fc_frame_alloc(lp->dev, sizeof(*req));
 	if (!fp)
 		return ENOMEM;
 
diff --git a/drivers/scsi/ofc/libfc/fc_sess.c b/drivers/scsi/ofc/libfc/fc_sess.c
index ff570e5..e73e565 100644
--- a/drivers/scsi/ofc/libfc/fc_sess.c
+++ b/drivers/scsi/ofc/libfc/fc_sess.c
@@ -747,7 +747,7 @@ static void fc_sess_enter_plogi(struct fc_sess *sess)
 
 	fc_sess_state_enter(sess, SESS_ST_PLOGI);
 	sess->fs_max_payload = sess->fs_local_port->fl_max_payload;
-	fp = fc_frame_alloc(sess->fs_local_port->fl_port, sizeof(*rp));
+	fp = fc_frame_alloc(sess->fs_local_port->dev, sizeof(*rp));
 	if (!fp) {
 		fc_sess_retry(sess);
 		return;
@@ -830,7 +830,7 @@ static void fc_sess_enter_prli(struct fc_sess *sess)
 		fc_sess_enter_ready(sess);
 		return;
 	}
-	fp = fc_frame_alloc(sess->fs_local_port->fl_port, sizeof(*pp));
+	fp = fc_frame_alloc(sess->fs_local_port->dev, sizeof(*pp));
 	if (!fp) {
 		fc_sess_retry(sess);
 		return;
@@ -898,7 +898,7 @@ static void fc_sess_enter_rtv(struct fc_sess *sess)
 
 	fc_sess_state_enter(sess, SESS_ST_RTV);
 
-	fp = fc_frame_alloc(sess->fs_local_port->fl_port, sizeof(*rtv));
+	fp = fc_frame_alloc(sess->fs_local_port->dev, sizeof(*rtv));
 	if (!fp) {
 		fc_sess_retry(sess);
 		return;
@@ -967,7 +967,7 @@ static void fc_sess_enter_logo(struct fc_sess *sess)
 	fc_sess_state_enter(sess, SESS_ST_LOGO);
 
 	lp = sess->fs_local_port;
-	fp = fc_frame_alloc(lp->fl_port, sizeof(*logo));
+	fp = fc_frame_alloc(lp->dev, sizeof(*logo));
 	if (!fp) {
 		fc_sess_retry(sess);
 		return;
@@ -1190,7 +1190,7 @@ static void fc_sess_recv_plogi_req(struct fc_sess *sess,
 		fc_seq_ls_rjt(sp, reject, ELS_EXPL_NONE);
 		fc_frame_free(fp);
 	} else {
-		fp = fc_frame_alloc(lp->fl_port, sizeof(*pl));
+		fp = fc_frame_alloc(lp->dev, sizeof(*pl));
 		if (fp == NULL) {
 			fp = rx_fp;
 			fc_seq_ls_rjt(sp, ELS_RJT_UNAB, ELS_EXPL_NONE);
@@ -1286,7 +1286,7 @@ static void fc_sess_recv_prli_req(struct fc_sess *sess,
 		rspp = &pp->spp;
 	}
 	if (reason != ELS_RJT_NONE ||
-	    (fp = fc_frame_alloc(lp->fl_port, len)) == NULL) {
+	    (fp = fc_frame_alloc(lp->dev, len)) == NULL) {
 		fc_seq_ls_rjt(sp, reason, explan);
 	} else {
 		sp = fc_seq_start_next(sp);
diff --git a/drivers/scsi/ofc/openfc/openfc_ioctl.c b/drivers/scsi/ofc/openfc/openfc_ioctl.c
index 0b1ec62..0791837 100644
--- a/drivers/scsi/ofc/openfc/openfc_ioctl.c
+++ b/drivers/scsi/ofc/openfc/openfc_ioctl.c
@@ -360,10 +360,10 @@ static int openfc_ioctl_send_cmd(void __user *_arg)
 	if (cp->ic_resp_len > 0xffff)	/* arbitrary defensive max */
 		return -EINVAL;
 	rc = -ENOMEM;
-	fp = fc_frame_alloc(openfcp->fcs_port, len);
+	fp = fc_frame_alloc(openfcp->dev, len);
 	if (!fp)
 		goto out;
-	rfp = fc_frame_alloc(openfcp->fcs_port, cp->ic_resp_len);
+	rfp = fc_frame_alloc(openfcp->dev, cp->ic_resp_len);
 	if (!rfp)
 		goto out;
 	rc = -EFAULT;
diff --git a/drivers/scsi/ofc/openfc/openfc_scsi.c b/drivers/scsi/ofc/openfc/openfc_scsi.c
index f4c742f..1833e8b 100644
--- a/drivers/scsi/ofc/openfc/openfc_scsi.c
+++ b/drivers/scsi/ofc/openfc/openfc_scsi.c
@@ -302,10 +302,9 @@ static void openfc_scsi_send_data(struct fc_scsi_pkt *fsp, struct fc_seq *sp,
 		if (!fp) {
 			tlen = min(mfs, remaining);
 			if (using_sg) {
-				fp = fc_port_frame_alloc(openfcp->fcs_port, 0);
+				fp = _fc_frame_alloc(openfcp->dev, 0);
 			} else {
-				fp = fc_port_frame_alloc(openfcp->fcs_port,
-							 tlen);
+				fp = _fc_frame_alloc(openfcp->dev, tlen);
 				data = (void *)(fp->fr_hdr + 1);
 			}
 			BUG_ON(!fp);
@@ -679,7 +678,7 @@ int openfc_scsi_send(struct fcdev *dev, struct fc_scsi_pkt *fsp)
 		rc = -1;
 		goto out;
 	} else {
-		fp = fc_frame_alloc(openfcp->fcs_port, sizeof(fsp->cdb_cmd));
+		fp = fc_frame_alloc(openfcp->dev, sizeof(fsp->cdb_cmd));
 		if (fp) {
 			fc_seq_hold(sp);
 			fsp->seq_ptr = sp;
@@ -885,7 +884,7 @@ int openfc_target_reset(struct fcdev *dev, struct fc_scsi_pkt *fsp)
 			       openfc_scsi_error, (void *)fsp);
 	if (sp) {
 		fc_seq_hold(sp);
-		fp = fc_frame_alloc(openfcp->fcs_port, sizeof(fsp->cdb_cmd));
+		fp = fc_frame_alloc(openfcp->dev, sizeof(fsp->cdb_cmd));
 		if (fp == NULL) {
 			OFC_DBG("could not allocate frame");
 			fc_seq_exch_complete(sp);

