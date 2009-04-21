From: Robert Love <robert.w.love@intel.com>
Subject: [PATCH 06/11] libfc: whenever queueing delete ev for rport,
	set state to NONE
Date: Tue, 21 Apr 2009 16:27:19 -0700
Message-ID: <20090421232719.8165.28977.stgit@fritz>
References: <20090421232647.8165.46673.stgit@fritz>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mga02.intel.com ([134.134.136.20]:59748 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752644AbZDUX1U (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Tue, 21 Apr 2009 19:27:20 -0400
In-Reply-To: <20090421232647.8165.46673.stgit@fritz>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James.Bottomley@HansenPartnership.com, linux-scsi@vger.kernel.org
Cc: Abhijeet Joglekar <abjoglek@cisco.com>, Robert Love <robert.w.love@intel.com>

From: Abhijeet Joglekar <abjoglek@cisco.com>

When a delete event is queued for an rport, set state to NONE so that no
other processing is done on the rport as it is being removed.

Signed-off-by: Abhijeet Joglekar <abjoglek@cisco.com>
Signed-off-by: Robert Love <robert.w.love@intel.com>
---

 drivers/scsi/libfc/fc_rport.c |    4 ++++
 1 files changed, 4 insertions(+), 0 deletions(-)

diff --git a/drivers/scsi/libfc/fc_rport.c b/drivers/scsi/libfc/fc_rport.c
index 5bf7a94..e675f5a 100644
--- a/drivers/scsi/libfc/fc_rport.c
+++ b/drivers/scsi/libfc/fc_rport.c
@@ -444,6 +444,7 @@ static void fc_rport_error(struct fc_rport *rport, struct fc_frame *fp)
 	case RPORT_ST_PRLI:
 	case RPORT_ST_LOGO:
 		rdata->event = RPORT_EV_FAILED;
+		fc_rport_state_enter(rport, RPORT_ST_NONE);
 		queue_work(rport_event_queue,
 			   &rdata->event_work);
 		break;
@@ -664,6 +665,7 @@ static void fc_rport_prli_resp(struct fc_seq *sp, struct fc_frame *fp,
 	} else {
 		FC_DBG("Bad ELS response\n");
 		rdata->event = RPORT_EV_FAILED;
+		fc_rport_state_enter(rport, RPORT_ST_NONE);
 		queue_work(rport_event_queue, &rdata->event_work);
 	}
 
@@ -715,6 +717,7 @@ static void fc_rport_logo_resp(struct fc_seq *sp, struct fc_frame *fp,
 	} else {
 		FC_DBG("Bad ELS response\n");
 		rdata->event = RPORT_EV_LOGO;
+		fc_rport_state_enter(rport, RPORT_ST_NONE);
 		queue_work(rport_event_queue, &rdata->event_work);
 	}
 
@@ -1293,6 +1296,7 @@ static void fc_rport_recv_logo_req(struct fc_rport *rport, struct fc_seq *sp,
 	}
 
 	rdata->event = RPORT_EV_LOGO;
+	fc_rport_state_enter(rport, RPORT_ST_NONE);
 	queue_work(rport_event_queue, &rdata->event_work);
 
 	lport->tt.seq_els_rsp_send(sp, ELS_LS_ACC, NULL);

