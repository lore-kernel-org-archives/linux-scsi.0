From: Robert Love <robert.w.love@intel.com>
Subject: [PATCH 08/10] fcoe: remove frame dropping code from fcoe_percpu_clean
Date: Fri, 09 Mar 2012 14:50:19 -0800
Message-ID: <20120309225019.6515.24193.stgit@localhost6.localdomain6>
References: <20120309224937.6515.83801.stgit@localhost6.localdomain6>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mga01.intel.com ([192.55.52.88]:58131 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S964830Ab2CIWuT (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Fri, 9 Mar 2012 17:50:19 -0500
In-Reply-To: <20120309224937.6515.83801.stgit@localhost6.localdomain6>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org
Cc: "James E.J. Bottomley" <JBottomley@parallels.com>, Vasu Dev <vasu.dev@linux.intel.com>, Neil Horman <nhorman@tuxdriver.com>, Vasu Dev <vasu.dev@intel.com>

From: Neil Horman <nhorman@tuxdriver.com>

commit e7a51997dad4e17395be1209970e18d2e9305b24 added a skb flush to the
fcoe_rx_list, which ensures that we push any pending frames on the list through
the per-cpu receive thread.  Because of this, its redundant to lock and scan the
list first, dropping any arriving frames.

Signed-off-by: Neil Horman <nhorman@tuxdriver.com>
CC: Robert Love <robert.w.love@intel.com>
CC: Vasu Dev <vasu.dev@linux.intel.com>
CC: "James E.J. Bottomley" <JBottomley@parallels.com>
Acked-by: Vasu Dev <vasu.dev@intel.com>
Signed-off-by: Robert Love <robert.w.love@intel.com>
---
 drivers/scsi/fcoe/fcoe.c |   22 +++-------------------
 1 files changed, 3 insertions(+), 19 deletions(-)

diff --git a/drivers/scsi/fcoe/fcoe.c b/drivers/scsi/fcoe/fcoe.c
index 961bf36..d86ca37 100644
--- a/drivers/scsi/fcoe/fcoe.c
+++ b/drivers/scsi/fcoe/fcoe.c
@@ -2254,31 +2254,14 @@ static int fcoe_link_ok(struct fc_lport *lport)
 static void fcoe_percpu_clean(struct fc_lport *lport)
 {
 	struct fcoe_percpu_s *pp;
-	struct fcoe_rcv_info *fr;
-	struct sk_buff_head *list;
-	struct sk_buff *skb, *next;
-	struct sk_buff *head;
+	struct sk_buff *skb;
 	unsigned int cpu;
 
 	for_each_possible_cpu(cpu) {
 		pp = &per_cpu(fcoe_percpu, cpu);
-		spin_lock_bh(&pp->fcoe_rx_list.lock);
-		list = &pp->fcoe_rx_list;
-		head = list->next;
-		for (skb = head; skb != (struct sk_buff *)list;
-		     skb = next) {
-			next = skb->next;
-			fr = fcoe_dev_from_skb(skb);
-			if (fr->fr_dev == lport) {
-				__skb_unlink(skb, list);
-				kfree_skb(skb);
-			}
-		}
 
-		if (!pp->thread || !cpu_online(cpu)) {
-			spin_unlock_bh(&pp->fcoe_rx_list.lock);
+		if (!pp->thread || !cpu_online(cpu))
 			continue;
-		}
 
 		skb = dev_alloc_skb(0);
 		if (!skb) {
@@ -2287,6 +2270,7 @@ static void fcoe_percpu_clean(struct fc_lport *lport)
 		}
 		skb->destructor = fcoe_percpu_flush_done;
 
+		spin_lock_bh(&pp->fcoe_rx_list.lock);
 		__skb_queue_tail(&pp->fcoe_rx_list, skb);
 		if (pp->fcoe_rx_list.qlen == 1)
 			wake_up_process(pp->thread);

