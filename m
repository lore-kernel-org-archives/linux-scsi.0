From: Robert Love <robert.w.love@intel.com>
Subject: [PATCH 08/64] libfcoe: fcoe_ctlr_destroy use cancel_work_sync instead
	of flush_work
Date: Tue, 25 Aug 2009 13:59:08 -0700
Message-ID: <20090825205908.1553.33113.stgit@localhost.localdomain>
References: <20090825205826.1553.94414.stgit@localhost.localdomain>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mga01.intel.com ([192.55.52.88]:33199 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756198AbZHYU7H (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Tue, 25 Aug 2009 16:59:07 -0400
In-Reply-To: <20090825205826.1553.94414.stgit@localhost.localdomain>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James.Bottomley@HansenPartnership.com, linux-scsi@vger.kernel.org
Cc: Chris Leech <christopher.leech@intel.com>, Robert Love <robert.w.love@intel.com>

From: Chris Leech <christopher.leech@intel.com>

Use cancel_work_sync() in place of flush_work(), so that
fcoe_ctlr_destroy() can be called from a workqueue.

Also, purge the receive queue after the recv_work has been cancled because
if recv_work isn't run it's not guaranteed to be empty now.

Signed-off-by: Chris Leech <christopher.leech@intel.com>
Signed-off-by: Robert Love <robert.w.love@intel.com>
---

 drivers/scsi/fcoe/libfcoe.c |    8 ++++++--
 1 files changed, 6 insertions(+), 2 deletions(-)

diff --git a/drivers/scsi/fcoe/libfcoe.c b/drivers/scsi/fcoe/libfcoe.c
index d0b5208..62a4c20 100644
--- a/drivers/scsi/fcoe/libfcoe.c
+++ b/drivers/scsi/fcoe/libfcoe.c
@@ -148,13 +148,17 @@ static void fcoe_ctlr_reset_fcfs(struct fcoe_ctlr *fip)
  */
 void fcoe_ctlr_destroy(struct fcoe_ctlr *fip)
 {
-	flush_work(&fip->recv_work);
+	cancel_work_sync(&fip->recv_work);
+	spin_lock_bh(&fip->fip_recv_list.lock);
+	__skb_queue_purge(&fip->fip_recv_list);
+	spin_unlock_bh(&fip->fip_recv_list.lock);
+
 	spin_lock_bh(&fip->lock);
 	fip->state = FIP_ST_DISABLED;
 	fcoe_ctlr_reset_fcfs(fip);
 	spin_unlock_bh(&fip->lock);
 	del_timer_sync(&fip->timer);
-	flush_work(&fip->link_work);
+	cancel_work_sync(&fip->link_work);
 }
 EXPORT_SYMBOL(fcoe_ctlr_destroy);
 

