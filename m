From: Robert Love <robert.w.love@intel.com>
Subject: [PATCH 11/22] libfc: rename rport state "NONE" to "DELETE".
Date: Wed, 29 Jul 2009 17:04:43 -0700
Message-ID: <20090730000443.24658.69933.stgit@localhost.localdomain>
References: <20090730000345.24658.24830.stgit@localhost.localdomain>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mga02.intel.com ([134.134.136.20]:49533 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755344AbZG3AEn (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Wed, 29 Jul 2009 20:04:43 -0400
In-Reply-To: <20090730000345.24658.24830.stgit@localhost.localdomain>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James.Bottomley@HansenPartnership.com, linux-scsi@vger.kernel.org
Cc: Joe Eykholt <jeykholt@cisco.com>, Robert Love <robert.w.love@intel.com>

From: Joe Eykholt <jeykholt@cisco.com>

State RPORT_ST_NONE was intented to be an invalid state (0), never used.
This was a misguided attempt to be sure it was always initialized.
Having an extra state meaning nothing requires switch statements to
have a case covering that state.

State NONE has been used instead to mean the remote port is being deleted.
Changing the name to RPORT_ST_DELETE.

Signed-off-by: Joe Eykholt <jeykholt@cisco.com>
Signed-off-by: Robert Love <robert.w.love@intel.com>
---

 drivers/scsi/libfc/fc_rport.c |   28 ++++++++++++++--------------
 include/scsi/libfc.h          |    2 +-
 2 files changed, 15 insertions(+), 15 deletions(-)

diff --git a/drivers/scsi/libfc/fc_rport.c b/drivers/scsi/libfc/fc_rport.c
index 7162385..bf7364f 100644
--- a/drivers/scsi/libfc/fc_rport.c
+++ b/drivers/scsi/libfc/fc_rport.c
@@ -77,13 +77,13 @@ static void fc_rport_error_retry(struct fc_rport *, struct fc_frame *);
 static void fc_rport_work(struct work_struct *);
 
 static const char *fc_rport_state_names[] = {
-	[RPORT_ST_NONE] = "None",
 	[RPORT_ST_INIT] = "Init",
 	[RPORT_ST_PLOGI] = "PLOGI",
 	[RPORT_ST_PRLI] = "PRLI",
 	[RPORT_ST_RTV] = "RTV",
 	[RPORT_ST_READY] = "Ready",
 	[RPORT_ST_LOGO] = "LOGO",
+	[RPORT_ST_DELETE] = "Delete",
 };
 
 static void fc_rport_rogue_destroy(struct device *dev)
@@ -326,8 +326,8 @@ int fc_rport_logoff(struct fc_rport *rport)
 
 	FC_RPORT_DBG(rport, "Remove port\n");
 
-	if (rdata->rp_state == RPORT_ST_NONE) {
-		FC_RPORT_DBG(rport, "Port in NONE state, not removing\n");
+	if (rdata->rp_state == RPORT_ST_DELETE) {
+		FC_RPORT_DBG(rport, "Port in Delete state, not removing\n");
 		mutex_unlock(&rdata->rp_mutex);
 		goto out;
 	}
@@ -335,10 +335,10 @@ int fc_rport_logoff(struct fc_rport *rport)
 	fc_rport_enter_logo(rport);
 
 	/*
-	 * Change the state to NONE so that we discard
+	 * Change the state to Delete so that we discard
 	 * the response.
 	 */
-	fc_rport_state_enter(rport, RPORT_ST_NONE);
+	fc_rport_state_enter(rport, RPORT_ST_DELETE);
 
 	mutex_unlock(&rdata->rp_mutex);
 
@@ -405,7 +405,7 @@ static void fc_rport_timeout(struct work_struct *work)
 		break;
 	case RPORT_ST_READY:
 	case RPORT_ST_INIT:
-	case RPORT_ST_NONE:
+	case RPORT_ST_DELETE:
 		break;
 	}
 
@@ -433,14 +433,14 @@ static void fc_rport_error(struct fc_rport *rport, struct fc_frame *fp)
 	case RPORT_ST_PRLI:
 	case RPORT_ST_LOGO:
 		rdata->event = RPORT_EV_FAILED;
-		fc_rport_state_enter(rport, RPORT_ST_NONE);
+		fc_rport_state_enter(rport, RPORT_ST_DELETE);
 		queue_work(rport_event_queue,
 			   &rdata->event_work);
 		break;
 	case RPORT_ST_RTV:
 		fc_rport_enter_ready(rport);
 		break;
-	case RPORT_ST_NONE:
+	case RPORT_ST_DELETE:
 	case RPORT_ST_READY:
 	case RPORT_ST_INIT:
 		break;
@@ -652,7 +652,7 @@ static void fc_rport_prli_resp(struct fc_seq *sp, struct fc_frame *fp,
 	} else {
 		FC_RPORT_DBG(rport, "Bad ELS response for PRLI command\n");
 		rdata->event = RPORT_EV_FAILED;
-		fc_rport_state_enter(rport, RPORT_ST_NONE);
+		fc_rport_state_enter(rport, RPORT_ST_DELETE);
 		queue_work(rport_event_queue, &rdata->event_work);
 	}
 
@@ -703,7 +703,7 @@ static void fc_rport_logo_resp(struct fc_seq *sp, struct fc_frame *fp,
 	} else {
 		FC_RPORT_DBG(rport, "Bad ELS response for LOGO command\n");
 		rdata->event = RPORT_EV_LOGO;
-		fc_rport_state_enter(rport, RPORT_ST_NONE);
+		fc_rport_state_enter(rport, RPORT_ST_DELETE);
 		queue_work(rport_event_queue, &rdata->event_work);
 	}
 
@@ -1012,7 +1012,7 @@ static void fc_rport_recv_plogi_req(struct fc_rport *rport,
 			     "- ignored for now\n", rdata->rp_state);
 		/* XXX TBD - should reset */
 		break;
-	case RPORT_ST_NONE:
+	case RPORT_ST_DELETE:
 	default:
 		FC_RPORT_DBG(rport, "Received PLOGI in unexpected "
 			     "state %d\n", rdata->rp_state);
@@ -1238,7 +1238,7 @@ static void fc_rport_recv_prlo_req(struct fc_rport *rport, struct fc_seq *sp,
 	FC_RPORT_DBG(rport, "Received PRLO request while in state %s\n",
 		     fc_rport_state(rport));
 
-	if (rdata->rp_state == RPORT_ST_NONE) {
+	if (rdata->rp_state == RPORT_ST_DELETE) {
 		fc_frame_free(fp);
 		return;
 	}
@@ -1271,13 +1271,13 @@ static void fc_rport_recv_logo_req(struct fc_rport *rport, struct fc_seq *sp,
 	FC_RPORT_DBG(rport, "Received LOGO request while in state %s\n",
 		     fc_rport_state(rport));
 
-	if (rdata->rp_state == RPORT_ST_NONE) {
+	if (rdata->rp_state == RPORT_ST_DELETE) {
 		fc_frame_free(fp);
 		return;
 	}
 
 	rdata->event = RPORT_EV_LOGO;
-	fc_rport_state_enter(rport, RPORT_ST_NONE);
+	fc_rport_state_enter(rport, RPORT_ST_DELETE);
 	queue_work(rport_event_queue, &rdata->event_work);
 
 	lport->tt.seq_els_rsp_send(sp, ELS_LS_ACC, NULL);
diff --git a/include/scsi/libfc.h b/include/scsi/libfc.h
index b5c9b28..04db7a9 100644
--- a/include/scsi/libfc.h
+++ b/include/scsi/libfc.h
@@ -147,13 +147,13 @@ enum fc_disc_event {
 };
 
 enum fc_rport_state {
-	RPORT_ST_NONE = 0,
 	RPORT_ST_INIT,		/* initialized */
 	RPORT_ST_PLOGI,		/* waiting for PLOGI completion */
 	RPORT_ST_PRLI,		/* waiting for PRLI completion */
 	RPORT_ST_RTV,		/* waiting for RTV completion */
 	RPORT_ST_READY,		/* ready for use */
 	RPORT_ST_LOGO,		/* port logout sent */
+	RPORT_ST_DELETE,	/* port being deleted */
 };
 
 enum fc_rport_trans_state {

