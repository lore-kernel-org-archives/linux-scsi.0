From: Robert Love <robert.w.love@intel.com>
Subject: [PATCH 32/54] libfcoe: fip: allow FIP receive to be called from IRQ.
Date: Tue, 03 Nov 2009 11:48:22 -0800
Message-ID: <20091103194822.4085.5737.stgit@localhost.localdomain>
References: <20091103194530.4085.37963.stgit@localhost.localdomain>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mga11.intel.com ([192.55.52.93]:45550 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755177AbZKCTsR (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Tue, 3 Nov 2009 14:48:17 -0500
In-Reply-To: <20091103194530.4085.37963.stgit@localhost.localdomain>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James.Bottomley@HansenPartnership.com, linux-scsi@vger.kernel.org
Cc: Joe Eykholt <jeykholt@cisco.com>, Robert Love <robert.w.love@intel.com>

From: Joe Eykholt <jeykholt@cisco.com>

FIP's fcoe_ctlr_recv() function was previously only called from
the soft IRQ in FCoE.  It's not performance critical and is more
convenient for some drivers to call it from the IRQ level.  Just
Change to use skb_queue()/dequeue() which uses spinlock_irqsave
instead of separate locking with _bh locks.

Signed-off-by: Joe Eykholt <jeykholt@cisco.com>
Signed-off-by: Robert Love <robert.w.love@intel.com>
---

 drivers/scsi/fcoe/libfcoe.c |   17 ++++-------------
 1 files changed, 4 insertions(+), 13 deletions(-)

diff --git a/drivers/scsi/fcoe/libfcoe.c b/drivers/scsi/fcoe/libfcoe.c
index 99f583f..787e722 100644
--- a/drivers/scsi/fcoe/libfcoe.c
+++ b/drivers/scsi/fcoe/libfcoe.c
@@ -156,9 +156,7 @@ static void fcoe_ctlr_reset_fcfs(struct fcoe_ctlr *fip)
 void fcoe_ctlr_destroy(struct fcoe_ctlr *fip)
 {
 	cancel_work_sync(&fip->recv_work);
-	spin_lock_bh(&fip->fip_recv_list.lock);
-	__skb_queue_purge(&fip->fip_recv_list);
-	spin_unlock_bh(&fip->fip_recv_list.lock);
+	skb_queue_purge(&fip->fip_recv_list);
 
 	spin_lock_bh(&fip->lock);
 	fip->state = FIP_ST_DISABLED;
@@ -1005,13 +1003,11 @@ static void fcoe_ctlr_recv_clr_vlink(struct fcoe_ctlr *fip,
  * @fip: The FCoE controller that received the packet
  * @skb: The received FIP packet
  *
- * This is called from NET_RX_SOFTIRQ.
+ * This may be called from either NET_RX_SOFTIRQ or IRQ.
  */
 void fcoe_ctlr_recv(struct fcoe_ctlr *fip, struct sk_buff *skb)
 {
-	spin_lock_bh(&fip->fip_recv_list.lock);
-	__skb_queue_tail(&fip->fip_recv_list, skb);
-	spin_unlock_bh(&fip->fip_recv_list.lock);
+	skb_queue_tail(&fip->fip_recv_list, skb);
 	schedule_work(&fip->recv_work);
 }
 EXPORT_SYMBOL(fcoe_ctlr_recv);
@@ -1251,13 +1247,8 @@ static void fcoe_ctlr_recv_work(struct work_struct *recv_work)
 	struct sk_buff *skb;
 
 	fip = container_of(recv_work, struct fcoe_ctlr, recv_work);
-	spin_lock_bh(&fip->fip_recv_list.lock);
-	while ((skb = __skb_dequeue(&fip->fip_recv_list))) {
-		spin_unlock_bh(&fip->fip_recv_list.lock);
+	while ((skb = skb_dequeue(&fip->fip_recv_list)))
 		fcoe_ctlr_recv_handler(fip, skb);
-		spin_lock_bh(&fip->fip_recv_list.lock);
-	}
-	spin_unlock_bh(&fip->fip_recv_list.lock);
 }
 
 /**

