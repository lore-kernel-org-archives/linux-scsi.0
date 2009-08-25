From: Robert Love <robert.w.love@intel.com>
Subject: [PATCH 59/64] libfc: LOGO response code had extraeous enter_rtv
Date: Tue, 25 Aug 2009 14:03:42 -0700
Message-ID: <20090825210342.1553.70239.stgit@localhost.localdomain>
References: <20090825205826.1553.94414.stgit@localhost.localdomain>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mga11.intel.com ([192.55.52.93]:3398 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932232AbZHYVD7 (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Tue, 25 Aug 2009 17:03:59 -0400
In-Reply-To: <20090825205826.1553.94414.stgit@localhost.localdomain>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James.Bottomley@HansenPartnership.com, linux-scsi@vger.kernel.org
Cc: Joe Eykholt <jeykholt@cisco.com>, Robert Love <robert.w.love@intel.com>

From: Joe Eykholt <jeykholt@cisco.com>

fc_rport_logo_resp() had a call to fc_rport_enter_rtv() if the
LOGO was accepted.  This must've been a copy/paste mistake, but
it didn't matter since we don't stay in the LOGO state long enough
to hit this code.

Change fc_rport_logo_resp() to just enter the delete state
no matter what.

Signed-off-by: Joe Eykholt <jeykholt@cisco.com>
Signed-off-by: Robert Love <robert.w.love@intel.com>
---

 drivers/scsi/libfc/fc_rport.c |   10 ++++------
 1 files changed, 4 insertions(+), 6 deletions(-)

diff --git a/drivers/scsi/libfc/fc_rport.c b/drivers/scsi/libfc/fc_rport.c
index dc97c60..b5bc872 100644
--- a/drivers/scsi/libfc/fc_rport.c
+++ b/drivers/scsi/libfc/fc_rport.c
@@ -725,12 +725,10 @@ static void fc_rport_logo_resp(struct fc_seq *sp, struct fc_frame *fp,
 	}
 
 	op = fc_frame_payload_op(fp);
-	if (op == ELS_LS_ACC) {
-		fc_rport_enter_rtv(rdata);
-	} else {
-		FC_RPORT_DBG(rdata, "Bad ELS response for LOGO command\n");
-		fc_rport_enter_delete(rdata, RPORT_EV_LOGO);
-	}
+	if (op != ELS_LS_ACC)
+		FC_RPORT_DBG(rdata, "Bad ELS response op %x for LOGO command\n",
+			     op);
+	fc_rport_enter_delete(rdata, RPORT_EV_LOGO);
 
 out:
 	fc_frame_free(fp);

