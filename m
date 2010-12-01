From: Robert Love <robert.w.love@intel.com>
Subject: [PATCH 21/27] libfcoe: move some timer code to make it reusable.
Date: Tue, 30 Nov 2010 16:19:46 -0800
Message-ID: <20101201001946.18369.22468.stgit@localhost.localdomain>
References: <20101201001756.18369.7107.stgit@localhost.localdomain>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mga14.intel.com ([143.182.124.37]:8762 "EHLO mga14.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753052Ab0LAATr (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Tue, 30 Nov 2010 19:19:47 -0500
In-Reply-To: <20101201001756.18369.7107.stgit@localhost.localdomain>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James.Bottomley@suse.de, linux-scsi@vger.kernel.org
Cc: Joe Eykholt <jeykholt@cisco.com>

From: Joe Eykholt <jeykholt@cisco.com>

Move some of the code in fcoe_ctlr_timer_work() to
fcoe_ctlr_select() so that it can be shared
with another function in a forthcoming patch.

Signed-off-by: Joe Eykholt <jeykholt@cisco.com>
Signed-off-by: Robert Love <robert.w.love@intel.com>
---
 drivers/scsi/fcoe/libfcoe.c |   10 +++++++---
 1 files changed, 7 insertions(+), 3 deletions(-)

diff --git a/drivers/scsi/fcoe/libfcoe.c b/drivers/scsi/fcoe/libfcoe.c
index 26381f0..4d0be20 100644
--- a/drivers/scsi/fcoe/libfcoe.c
+++ b/drivers/scsi/fcoe/libfcoe.c
@@ -1391,6 +1391,13 @@ static void fcoe_ctlr_select(struct fcoe_ctlr *fip)
 			best = fcf;
 	}
 	fip->sel_fcf = best;
+	if (best) {
+		fip->port_ka_time = jiffies +
+			msecs_to_jiffies(FIP_VN_KA_PERIOD);
+		fip->ctlr_ka_time = jiffies + best->fka_period;
+		if (time_before(fip->ctlr_ka_time, fip->timer.expires))
+			mod_timer(&fip->timer, fip->ctlr_ka_time);
+	}
 }
 
 /**
@@ -1449,9 +1456,6 @@ static void fcoe_ctlr_timer_work(struct work_struct *work)
 		fcf = sel;		/* the old FCF may have been freed */
 		fcoe_ctlr_announce(fip);
 		if (sel) {
-			fip->port_ka_time = jiffies +
-				msecs_to_jiffies(FIP_VN_KA_PERIOD);
-			fip->ctlr_ka_time = jiffies + sel->fka_period;
 			if (time_after(next_timer, fip->ctlr_ka_time))
 				next_timer = fip->ctlr_ka_time;
 		} else

