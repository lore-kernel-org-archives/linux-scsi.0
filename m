From: Robert Love <robert.w.love@intel.com>
Subject: [PATCH 02/64] libfc: Fix misleading debug statement
Date: Tue, 25 Aug 2009 13:58:37 -0700
Message-ID: <20090825205837.1553.62204.stgit@localhost.localdomain>
References: <20090825205826.1553.94414.stgit@localhost.localdomain>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mga09.intel.com ([134.134.136.24]:11254 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755565AbZHYU6f (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Tue, 25 Aug 2009 16:58:35 -0400
In-Reply-To: <20090825205826.1553.94414.stgit@localhost.localdomain>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James.Bottomley@HansenPartnership.com, linux-scsi@vger.kernel.org
Cc: Robert Love <robert.w.love@intel.com>

The statement reads, "Exchange timed out, notifying the upper layer",
however, this statement is printed whenever the timer is armed. This
is confusing to someone debugging the code because every time an
exchange is initialized, there is an incorrect statement stating that
the timer has already timed out. This patch changes the statement to
read, "Exchange timer armed" which is more accurate.

This patch also adds a debug statement in the timeout handler to
properly indicate that the exchange has timed out.

Signed-off-by: Robert Love <robert.w.love@intel.com>
---

 drivers/scsi/libfc/fc_exch.c |    4 +++-
 1 files changed, 3 insertions(+), 1 deletions(-)

diff --git a/drivers/scsi/libfc/fc_exch.c b/drivers/scsi/libfc/fc_exch.c
index 11ddd11..40c3427 100644
--- a/drivers/scsi/libfc/fc_exch.c
+++ b/drivers/scsi/libfc/fc_exch.c
@@ -326,7 +326,7 @@ static inline void fc_exch_timer_set_locked(struct fc_exch *ep,
 	if (ep->state & (FC_EX_RST_CLEANUP | FC_EX_DONE))
 		return;
 
-	FC_EXCH_DBG(ep, "Exchange timed out, notifying the upper layer\n");
+	FC_EXCH_DBG(ep, "Exchange timer armed\n");
 
 	if (schedule_delayed_work(&ep->timeout_work,
 				  msecs_to_jiffies(timer_msec)))
@@ -412,6 +412,8 @@ static void fc_exch_timeout(struct work_struct *work)
 	u32 e_stat;
 	int rc = 1;
 
+	FC_EXCH_DBG(ep, "Exchange timed out\n");
+
 	spin_lock_bh(&ep->ex_lock);
 	if (ep->state & (FC_EX_RST_CLEANUP | FC_EX_DONE))
 		goto unlock;

