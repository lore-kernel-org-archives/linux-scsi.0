From: Robert Love <robert.w.love@intel.com>
Subject: [PATCH 01/24] libfc: lport: fix minor documentation errors
Date: Fri, 18 Sep 2009 15:48:53 -0700
Message-ID: <20090918224853.5928.59059.stgit@localhost.localdomain>
References: <20090918224847.5928.52092.stgit@localhost.localdomain>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mga03.intel.com ([143.182.124.21]:62593 "EHLO mga03.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754018AbZIRWsu (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Fri, 18 Sep 2009 18:48:50 -0400
In-Reply-To: <20090918224847.5928.52092.stgit@localhost.localdomain>
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

 drivers/scsi/libfc/fc_lport.c |   14 +++++++-------
 1 files changed, 7 insertions(+), 7 deletions(-)

diff --git a/drivers/scsi/libfc/fc_lport.c b/drivers/scsi/libfc/fc_lport.c
index a80c61a..278fb04 100644
--- a/drivers/scsi/libfc/fc_lport.c
+++ b/drivers/scsi/libfc/fc_lport.c
@@ -385,7 +385,7 @@ static void fc_lport_add_fc4_type(struct fc_lport *lport, enum fc_fh_type type)
  * @fp:	   The RLIR request frame
  * @lport: Fibre Channel local port recieving the RLIR
  *
- * Locking Note: The lport lock is exected to be held before calling
+ * Locking Note: The lport lock is expected to be held before calling
  * this function.
  */
 static void fc_lport_recv_rlir_req(struct fc_seq *sp, struct fc_frame *fp,
@@ -404,7 +404,7 @@ static void fc_lport_recv_rlir_req(struct fc_seq *sp, struct fc_frame *fp,
  * @fp:	   ECHO request frame
  * @lport: The local port recieving the ECHO
  *
- * Locking Note: The lport lock is exected to be held before calling
+ * Locking Note: The lport lock is expected to be held before calling
  * this function.
  */
 static void fc_lport_recv_echo_req(struct fc_seq *sp, struct fc_frame *in_fp,
@@ -417,7 +417,7 @@ static void fc_lport_recv_echo_req(struct fc_seq *sp, struct fc_frame *in_fp,
 	void *dp;
 	u32 f_ctl;
 
-	FC_LPORT_DBG(lport, "Received RLIR request while in state %s\n",
+	FC_LPORT_DBG(lport, "Received ECHO request while in state %s\n",
 		     fc_lport_state(lport));
 
 	len = fr_len(in_fp) - sizeof(struct fc_frame_header);
@@ -430,7 +430,7 @@ static void fc_lport_recv_echo_req(struct fc_seq *sp, struct fc_frame *in_fp,
 	if (fp) {
 		dp = fc_frame_payload_get(fp, len);
 		memcpy(dp, pp, len);
-		*((u32 *)dp) = htonl(ELS_LS_ACC << 24);
+		*((__be32 *)dp) = htonl(ELS_LS_ACC << 24);
 		sp = lport->tt.seq_start_next(sp);
 		f_ctl = FC_FC_EX_CTX | FC_FC_LAST_SEQ | FC_FC_END_SEQ;
 		fc_fill_fc_hdr(fp, FC_RCTL_ELS_REP, ep->did, ep->sid,
@@ -441,12 +441,12 @@ static void fc_lport_recv_echo_req(struct fc_seq *sp, struct fc_frame *in_fp,
 }
 
 /**
- * fc_lport_recv_echo_req() - Handle received Request Node ID data request
+ * fc_lport_recv_rnid_req() - Handle received Request Node ID data request
  * @sp:	   The sequence in the RNID exchange
  * @fp:	   The RNID request frame
  * @lport: The local port recieving the RNID
  *
- * Locking Note: The lport lock is exected to be held before calling
+ * Locking Note: The lport lock is expected to be held before calling
  * this function.
  */
 static void fc_lport_recv_rnid_req(struct fc_seq *sp, struct fc_frame *in_fp,
@@ -742,7 +742,7 @@ static void fc_lport_enter_ready(struct fc_lport *lport)
  * Accept it with the common service parameters indicating our N port.
  * Set up to do a PLOGI if we have the higher-number WWPN.
  *
- * Locking Note: The lport lock is exected to be held before calling
+ * Locking Note: The lport lock is expected to be held before calling
  * this function.
  */
 static void fc_lport_recv_flogi_req(struct fc_seq *sp_in,

