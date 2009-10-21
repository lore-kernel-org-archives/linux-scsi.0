From: Robert Love <robert.w.love@intel.com>
Subject: [PATCH 07/20] libfc: lport: fix minor documentation errors
Date: Wed, 21 Oct 2009 16:27:17 -0700
Message-ID: <20091021232717.12986.18606.stgit@localhost.localdomain>
References: <20091021232640.12986.79205.stgit@localhost.localdomain>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mga02.intel.com ([134.134.136.20]:60597 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751718AbZJUX1d (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Wed, 21 Oct 2009 19:27:33 -0400
In-Reply-To: <20091021232640.12986.79205.stgit@localhost.localdomain>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James.Bottomley@HansenPartnership.com, linux-scsi@vger.kernel.org
Cc: Joe Eykholt <jeykholt@cisco.com>, Robert Love <robert.w.love@intel.com>

From: Joe Eykholt <jeykholt@cisco.com>

Fix minor errors.
A debug message said an RLIR was received instead of ECHO.
"Expected" was misspelled in several places.
Fix a type cast from u32 to __be32.

Rob, Some of these may have been also taken care of in your
other doc cleanup patch.  Feel free to fold them in.

Signed-off-by: Joe Eykholt <jeykholt@cisco.com>
Signed-off-by: Robert Love <robert.w.love@intel.com>
---

 drivers/scsi/libfc/fc_lport.c |   20 ++++++++++----------
 1 files changed, 10 insertions(+), 10 deletions(-)

diff --git a/drivers/scsi/libfc/fc_lport.c b/drivers/scsi/libfc/fc_lport.c
index bd2f771..eefe87d 100644
--- a/drivers/scsi/libfc/fc_lport.c
+++ b/drivers/scsi/libfc/fc_lport.c
@@ -329,7 +329,7 @@ static void fc_lport_add_fc4_type(struct fc_lport *lport, enum fc_fh_type type)
  * @sp: current sequence in the RLIR exchange
  * @fp: RLIR request frame
  *
- * Locking Note: The lport lock is exected to be held before calling
+ * Locking Note: The lport lock is expected to be held before calling
  * this function.
  */
 static void fc_lport_recv_rlir_req(struct fc_seq *sp, struct fc_frame *fp,
@@ -348,7 +348,7 @@ static void fc_lport_recv_rlir_req(struct fc_seq *sp, struct fc_frame *fp,
  * @sp: current sequence in the ECHO exchange
  * @fp: ECHO request frame
  *
- * Locking Note: The lport lock is exected to be held before calling
+ * Locking Note: The lport lock is expected to be held before calling
  * this function.
  */
 static void fc_lport_recv_echo_req(struct fc_seq *sp, struct fc_frame *in_fp,
@@ -361,7 +361,7 @@ static void fc_lport_recv_echo_req(struct fc_seq *sp, struct fc_frame *in_fp,
 	void *dp;
 	u32 f_ctl;
 
-	FC_LPORT_DBG(lport, "Received RLIR request while in state %s\n",
+	FC_LPORT_DBG(lport, "Received ECHO request while in state %s\n",
 		     fc_lport_state(lport));
 
 	len = fr_len(in_fp) - sizeof(struct fc_frame_header);
@@ -374,7 +374,7 @@ static void fc_lport_recv_echo_req(struct fc_seq *sp, struct fc_frame *in_fp,
 	if (fp) {
 		dp = fc_frame_payload_get(fp, len);
 		memcpy(dp, pp, len);
-		*((u32 *)dp) = htonl(ELS_LS_ACC << 24);
+		*((__be32 *)dp) = htonl(ELS_LS_ACC << 24);
 		sp = lport->tt.seq_start_next(sp);
 		f_ctl = FC_FC_EX_CTX | FC_FC_LAST_SEQ | FC_FC_END_SEQ;
 		fc_fill_fc_hdr(fp, FC_RCTL_ELS_REP, ep->did, ep->sid,
@@ -385,12 +385,12 @@ static void fc_lport_recv_echo_req(struct fc_seq *sp, struct fc_frame *in_fp,
 }
 
 /**
- * fc_lport_recv_echo_req() - Handle received Request Node ID data request
- * @lport: Fibre Channel local port recieving the RNID
- * @sp: current sequence in the RNID exchange
- * @fp: RNID request frame
+ * fc_lport_recv_rnid_req() - Handle received Request Node ID data request
+ * @sp:	   The sequence in the RNID exchange
+ * @fp:	   The RNID request frame
+ * @lport: The local port recieving the RNID
  *
- * Locking Note: The lport lock is exected to be held before calling
+ * Locking Note: The lport lock is expected to be held before calling
  * this function.
  */
 static void fc_lport_recv_rnid_req(struct fc_seq *sp, struct fc_frame *in_fp,
@@ -667,7 +667,7 @@ static void fc_lport_enter_ready(struct fc_lport *lport)
  * Accept it with the common service parameters indicating our N port.
  * Set up to do a PLOGI if we have the higher-number WWPN.
  *
- * Locking Note: The lport lock is exected to be held before calling
+ * Locking Note: The lport lock is expected to be held before calling
  * this function.
  */
 static void fc_lport_recv_flogi_req(struct fc_seq *sp_in,

