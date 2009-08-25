From: Robert Love <robert.w.love@intel.com>
Subject: [PATCH 33/64] libfc: fix rport event race between READY and LOGO
Date: Tue, 25 Aug 2009 14:01:23 -0700
Message-ID: <20090825210123.1553.33025.stgit@localhost.localdomain>
References: <20090825205826.1553.94414.stgit@localhost.localdomain>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mga11.intel.com ([192.55.52.93]:19979 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932176AbZHYVBV (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Tue, 25 Aug 2009 17:01:21 -0400
In-Reply-To: <20090825205826.1553.94414.stgit@localhost.localdomain>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James.Bottomley@HansenPartnership.com, linux-scsi@vger.kernel.org
Cc: Joe Eykholt <jeykholt@cisco.com>, Robert Love <robert.w.love@intel.com>

From: Joe Eykholt <jeykholt@cisco.com>

When a remote port becomes ready and a LOGO is received before
the READY event is in rport_work waiting on the mutex, the
event is changed to LOGO and the work queued, so both the
calls to rport_work see the LOGO event, and both try to do
the list_del(), causing a crash.

Don't change the event if it is already set.

Signed-off-by: Joe Eykholt <jeykholt@cisco.com>
Signed-off-by: Robert Love <robert.w.love@intel.com>
---

 drivers/scsi/libfc/fc_rport.c |    4 +---
 1 files changed, 1 insertions(+), 3 deletions(-)

diff --git a/drivers/scsi/libfc/fc_rport.c b/drivers/scsi/libfc/fc_rport.c
index a1794a3..cbf6c9f 100644
--- a/drivers/scsi/libfc/fc_rport.c
+++ b/drivers/scsi/libfc/fc_rport.c
@@ -1267,9 +1267,7 @@ static void fc_rport_recv_logo_req(struct fc_rport_priv *rdata,
 		return;
 	}
 
-	rdata->event = RPORT_EV_LOGO;
-	fc_rport_state_enter(rdata, RPORT_ST_DELETE);
-	queue_work(rport_event_queue, &rdata->event_work);
+	fc_rport_enter_delete(rdata, RPORT_EV_LOGO);
 
 	lport->tt.seq_els_rsp_send(sp, ELS_LS_ACC, NULL);
 	fc_frame_free(fp);

