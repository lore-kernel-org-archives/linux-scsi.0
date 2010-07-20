From: Robert Love <robert.w.love@intel.com>
Subject: [PATCH 21/28] libfc: add fc_frame_sid() and fc_frame_did() functions
Date: Tue, 20 Jul 2010 15:20:56 -0700
Message-ID: <20100720222056.17116.33817.stgit@localhost.localdomain>
References: <20100720221904.17116.78553.stgit@localhost.localdomain>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mga09.intel.com ([134.134.136.24]:10407 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932812Ab0GTWU4 (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Tue, 20 Jul 2010 18:20:56 -0400
In-Reply-To: <20100720221904.17116.78553.stgit@localhost.localdomain>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James.Bottomley@suse.de, linux-scsi@vger.kernel.org
Cc: Joe Eykholt <jeykholt@cisco.com>

From: Joe Eykholt <jeykholt@cisco.com>

To pave the way for eliminating exchanges from incoming requests,
add simple inline fc_frame_sid() and fc_frame_did() functions
which get the FC_IDs from the frame header.  This can be almost
as efficient as getting them from the sequence/exchange.

Move ntohll, htonll, ntoh24 and hton24 to <scsi/fc_frame.h>
since we need them there and that's included by <scsi/libfc.h>

Signed-off-by: Joe Eykholt <jeykholt@cisco.com>
Signed-off-by: Robert Love <robert.w.love@intel.com>
---
 drivers/scsi/libfc/fc_lport.c |   12 ++++-------
 drivers/scsi/libfc/fc_rport.c |   26 +++++-------------------
 include/scsi/fc_frame.h       |   45 ++++++++++++++++++++++++++++++++++++++++-
 include/scsi/libfc.h          |   18 ----------------
 4 files changed, 54 insertions(+), 47 deletions(-)

diff --git a/drivers/scsi/libfc/fc_lport.c b/drivers/scsi/libfc/fc_lport.c
index ec9850c..be3c2ce 100644
--- a/drivers/scsi/libfc/fc_lport.c
+++ b/drivers/scsi/libfc/fc_lport.c
@@ -800,7 +800,6 @@ static void fc_lport_recv_flogi_req(struct fc_seq *sp_in,
 				    struct fc_lport *lport)
 {
 	struct fc_frame *fp;
-	struct fc_frame_header *fh;
 	struct fc_seq *sp;
 	struct fc_exch *ep;
 	struct fc_els_flogi *flp;
@@ -813,8 +812,7 @@ static void fc_lport_recv_flogi_req(struct fc_seq *sp_in,
 	FC_LPORT_DBG(lport, "Received FLOGI request while in state %s\n",
 		     fc_lport_state(lport));
 
-	fh = fc_frame_header_get(rx_fp);
-	remote_fid = ntoh24(fh->fh_s_id);
+	remote_fid = fc_frame_sid(rx_fp);
 	flp = fc_frame_payload_get(rx_fp, sizeof(*flp));
 	if (!flp)
 		goto out;
@@ -910,7 +908,7 @@ static void fc_lport_recv_req(struct fc_lport *lport, struct fc_seq *sp,
 				recv = fc_lport_recv_flogi_req;
 			break;
 		case ELS_LOGO:
-			if (ntoh24(fh->fh_s_id) == FC_FID_FLOGI)
+			if (fc_frame_sid(fp) == FC_FID_FLOGI)
 				recv = fc_lport_recv_logo_req;
 			break;
 		case ELS_RSCN:
@@ -1468,7 +1466,6 @@ void fc_lport_flogi_resp(struct fc_seq *sp, struct fc_frame *fp,
 			 void *lp_arg)
 {
 	struct fc_lport *lport = lp_arg;
-	struct fc_frame_header *fh;
 	struct fc_els_flogi *flp;
 	u32 did;
 	u16 csp_flags;
@@ -1496,8 +1493,7 @@ void fc_lport_flogi_resp(struct fc_seq *sp, struct fc_frame *fp,
 		goto err;
 	}
 
-	fh = fc_frame_header_get(fp);
-	did = ntoh24(fh->fh_d_id);
+	did = fc_frame_did(fp);
 	if (fc_frame_payload_op(fp) == ELS_LS_ACC && did != 0) {
 		flp = fc_frame_payload_get(fp, sizeof(*flp));
 		if (flp) {
@@ -1523,7 +1519,7 @@ void fc_lport_flogi_resp(struct fc_seq *sp, struct fc_frame *fp,
 				       "Port (%6.6x) entered "
 				       "point-to-point mode\n",
 				       lport->host->host_no, did);
-				fc_lport_ptp_setup(lport, ntoh24(fh->fh_s_id),
+				fc_lport_ptp_setup(lport, fc_frame_sid(fp),
 						   get_unaligned_be64(
 							   &flp->fl_wwpn),
 						   get_unaligned_be64(
diff --git a/drivers/scsi/libfc/fc_rport.c b/drivers/scsi/libfc/fc_rport.c
index c06d63e..1234931 100644
--- a/drivers/scsi/libfc/fc_rport.c
+++ b/drivers/scsi/libfc/fc_rport.c
@@ -747,13 +747,11 @@ static void fc_rport_recv_flogi_req(struct fc_lport *lport,
 	struct fc_rport_priv *rdata;
 	struct fc_frame *fp = rx_fp;
 	struct fc_exch *ep;
-	struct fc_frame_header *fh;
 	struct fc_seq_els_data rjt_data;
 	u32 sid, f_ctl;
 
 	rjt_data.fp = NULL;
-	fh = fc_frame_header_get(fp);
-	sid = ntoh24(fh->fh_s_id);
+	sid = fc_frame_sid(fp);
 
 	FC_RPORT_ID_DBG(lport, sid, "Received FLOGI request\n");
 
@@ -1430,17 +1428,14 @@ static void fc_rport_recv_els_req(struct fc_lport *lport,
 				  struct fc_seq *sp, struct fc_frame *fp)
 {
 	struct fc_rport_priv *rdata;
-	struct fc_frame_header *fh;
 	struct fc_seq_els_data els_data;
 
 	els_data.fp = NULL;
 	els_data.reason = ELS_RJT_UNAB;
 	els_data.explan = ELS_EXPL_PLOGI_REQD;
 
-	fh = fc_frame_header_get(fp);
-
 	mutex_lock(&lport->disc.disc_mutex);
-	rdata = lport->tt.rport_lookup(lport, ntoh24(fh->fh_s_id));
+	rdata = lport->tt.rport_lookup(lport, fc_frame_sid(fp));
 	if (!rdata) {
 		mutex_unlock(&lport->disc.disc_mutex);
 		goto reject;
@@ -1555,14 +1550,12 @@ static void fc_rport_recv_plogi_req(struct fc_lport *lport,
 	struct fc_rport_priv *rdata;
 	struct fc_frame *fp = rx_fp;
 	struct fc_exch *ep;
-	struct fc_frame_header *fh;
 	struct fc_els_flogi *pl;
 	struct fc_seq_els_data rjt_data;
 	u32 sid, f_ctl;
 
 	rjt_data.fp = NULL;
-	fh = fc_frame_header_get(fp);
-	sid = ntoh24(fh->fh_s_id);
+	sid = fc_frame_sid(fp);
 
 	FC_RPORT_ID_DBG(lport, sid, "Received PLOGI request\n");
 
@@ -1682,7 +1675,6 @@ static void fc_rport_recv_prli_req(struct fc_rport_priv *rdata,
 	struct fc_lport *lport = rdata->local_port;
 	struct fc_exch *ep;
 	struct fc_frame *fp;
-	struct fc_frame_header *fh;
 	struct {
 		struct fc_els_prli prli;
 		struct fc_els_spp spp;
@@ -1698,12 +1690,10 @@ static void fc_rport_recv_prli_req(struct fc_rport_priv *rdata,
 	u32 roles = FC_RPORT_ROLE_UNKNOWN;
 
 	rjt_data.fp = NULL;
-	fh = fc_frame_header_get(rx_fp);
-
 	FC_RPORT_DBG(rdata, "Received PRLI request while in state %s\n",
 		     fc_rport_state(rdata));
 
-	len = fr_len(rx_fp) - sizeof(*fh);
+	len = fr_len(rx_fp) - sizeof(struct fc_frame_header);
 	pp = fc_frame_payload_get(rx_fp, sizeof(*pp));
 	if (!pp)
 		goto reject_len;
@@ -1817,7 +1807,6 @@ static void fc_rport_recv_prlo_req(struct fc_rport_priv *rdata,
 				   struct fc_frame *rx_fp)
 {
 	struct fc_lport *lport = rdata->local_port;
-	struct fc_frame_header *fh;
 	struct fc_exch *ep;
 	struct fc_frame *fp;
 	struct {
@@ -1832,12 +1821,11 @@ static void fc_rport_recv_prlo_req(struct fc_rport_priv *rdata,
 	struct fc_seq_els_data rjt_data;
 
 	rjt_data.fp = NULL;
-	fh = fc_frame_header_get(rx_fp);
 
 	FC_RPORT_DBG(rdata, "Received PRLO request while in state %s\n",
 		     fc_rport_state(rdata));
 
-	len = fr_len(rx_fp) - sizeof(*fh);
+	len = fr_len(rx_fp) - sizeof(struct fc_frame_header);
 	pp = fc_frame_payload_get(rx_fp, sizeof(*pp));
 	if (!pp)
 		goto reject_len;
@@ -1901,14 +1889,12 @@ static void fc_rport_recv_logo_req(struct fc_lport *lport,
 				   struct fc_seq *sp,
 				   struct fc_frame *fp)
 {
-	struct fc_frame_header *fh;
 	struct fc_rport_priv *rdata;
 	u32 sid;
 
 	lport->tt.seq_els_rsp_send(sp, ELS_LS_ACC, NULL);
 
-	fh = fc_frame_header_get(fp);
-	sid = ntoh24(fh->fh_s_id);
+	sid = fc_frame_sid(fp);
 
 	mutex_lock(&lport->disc.disc_mutex);
 	rdata = lport->tt.rport_lookup(lport, sid);
diff --git a/include/scsi/fc_frame.h b/include/scsi/fc_frame.h
index 29dd97d..4ad0204 100644
--- a/include/scsi/fc_frame.h
+++ b/include/scsi/fc_frame.h
@@ -30,6 +30,23 @@
 
 #include <linux/if_ether.h>
 
+/* some helpful macros */
+
+#define ntohll(x) be64_to_cpu(x)
+#define htonll(x) cpu_to_be64(x)
+
+static inline u32 ntoh24(const u8 *p)
+{
+	return (p[0] << 16) | (p[1] << 8) | p[2];
+}
+
+static inline void hton24(u8 *p, u32 v)
+{
+	p[0] = (v >> 16) & 0xff;
+	p[1] = (v >> 8) & 0xff;
+	p[2] = v & 0xff;
+}
+
 /*
  * The fc_frame interface is used to pass frame data between functions.
  * The frame includes the data buffer, length, and SOF / EOF delimiter types.
@@ -139,13 +156,39 @@ static inline int fc_frame_is_linear(struct fc_frame *fp)
 
 /*
  * Get frame header from message in fc_frame structure.
+ * This version doesn't do a length check.
+ */
+static inline
+struct fc_frame_header *__fc_frame_header_get(const struct fc_frame *fp)
+{
+	return (struct fc_frame_header *)fr_hdr(fp);
+}
+
+/*
+ * Get frame header from message in fc_frame structure.
  * This hides a cast and provides a place to add some checking.
  */
 static inline
 struct fc_frame_header *fc_frame_header_get(const struct fc_frame *fp)
 {
 	WARN_ON(fr_len(fp) < sizeof(struct fc_frame_header));
-	return (struct fc_frame_header *) fr_hdr(fp);
+	return __fc_frame_header_get(fp);
+}
+
+/*
+ * Get source FC_ID (S_ID) from frame header in message.
+ */
+static inline u32 fc_frame_sid(const struct fc_frame *fp)
+{
+	return ntoh24(__fc_frame_header_get(fp)->fh_s_id);
+}
+
+/*
+ * Get destination FC_ID (D_ID) from frame header in message.
+ */
+static inline u32 fc_frame_did(const struct fc_frame *fp)
+{
+	return ntoh24(__fc_frame_header_get(fp)->fh_d_id);
 }
 
 /*
diff --git a/include/scsi/libfc.h b/include/scsi/libfc.h
index e6f07fb..f1ce793 100644
--- a/include/scsi/libfc.h
+++ b/include/scsi/libfc.h
@@ -42,24 +42,6 @@
 #define	FC_EX_TIMEOUT	1	/* Exchange timeout */
 #define	FC_EX_CLOSED	2	/* Exchange closed */
 
-/* some helpful macros */
-
-#define ntohll(x) be64_to_cpu(x)
-#define htonll(x) cpu_to_be64(x)
-
-
-static inline u32 ntoh24(const u8 *p)
-{
-	return (p[0] << 16) | (p[1] << 8) | p[2];
-}
-
-static inline void hton24(u8 *p, u32 v)
-{
-	p[0] = (v >> 16) & 0xff;
-	p[1] = (v >> 8) & 0xff;
-	p[2] = v & 0xff;
-}
-
 /**
  * enum fc_lport_state - Local port states
  * @LPORT_ST_DISABLED: Disabled

