From: Robert Love <robert.w.love@intel.com>
Subject: [PATCH 06/10] foce: remove bh disable from fcoe sw transport rcv
 function
Date: Fri, 09 Mar 2012 14:50:08 -0800
Message-ID: <20120309225008.6515.73884.stgit@localhost6.localdomain6>
References: <20120309224937.6515.83801.stgit@localhost6.localdomain6>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mga09.intel.com ([134.134.136.24]:8030 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1030296Ab2CIWuv (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Fri, 9 Mar 2012 17:50:51 -0500
In-Reply-To: <20120309224937.6515.83801.stgit@localhost6.localdomain6>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org
Cc: Neil Horman <nhorman@tuxdriver.com>, Vasu Dev <vasu.dev@intel.com>

From: Neil Horman <nhorman@tuxdriver.com>

The fcoe sw recive packet function (fcoe_rcv) only ever executes in softirq
context.  Given that, and the fact that no use of the fcoe_rx_list is made in
irq context, its not necessecary to disable bottom halves while actually
receiving the frame.  Convert spin_*_bh calls in that function to their
lock-only equivalents

Signed-off-by: Neil Horman <nhorman@tuxdriver.com>
Acked-by: Vasu Dev <vasu.dev@intel.com>
Signed-off-by: Robert Love <robert.w.love@intel.com>
---
 drivers/scsi/fcoe/fcoe.c |   10 +++++-----
 1 files changed, 5 insertions(+), 5 deletions(-)

diff --git a/drivers/scsi/fcoe/fcoe.c b/drivers/scsi/fcoe/fcoe.c
index 22ae295..961bf36 100644
--- a/drivers/scsi/fcoe/fcoe.c
+++ b/drivers/scsi/fcoe/fcoe.c
@@ -1436,7 +1436,7 @@ static int fcoe_rcv(struct sk_buff *skb, struct net_device *netdev,
 		goto err;
 
 	fps = &per_cpu(fcoe_percpu, cpu);
-	spin_lock_bh(&fps->fcoe_rx_list.lock);
+	spin_lock(&fps->fcoe_rx_list.lock);
 	if (unlikely(!fps->thread)) {
 		/*
 		 * The targeted CPU is not ready, let's target
@@ -1447,12 +1447,12 @@ static int fcoe_rcv(struct sk_buff *skb, struct net_device *netdev,
 				"ready for incoming skb- using first online "
 				"CPU.\n");
 
-		spin_unlock_bh(&fps->fcoe_rx_list.lock);
+		spin_unlock(&fps->fcoe_rx_list.lock);
 		cpu = cpumask_first(cpu_online_mask);
 		fps = &per_cpu(fcoe_percpu, cpu);
-		spin_lock_bh(&fps->fcoe_rx_list.lock);
+		spin_lock(&fps->fcoe_rx_list.lock);
 		if (!fps->thread) {
-			spin_unlock_bh(&fps->fcoe_rx_list.lock);
+			spin_unlock(&fps->fcoe_rx_list.lock);
 			goto err;
 		}
 	}
@@ -1473,7 +1473,7 @@ static int fcoe_rcv(struct sk_buff *skb, struct net_device *netdev,
 	__skb_queue_tail(&fps->fcoe_rx_list, skb);
 	if (fps->fcoe_rx_list.qlen == 1)
 		wake_up_process(fps->thread);
-	spin_unlock_bh(&fps->fcoe_rx_list.lock);
+	spin_unlock(&fps->fcoe_rx_list.lock);
 
 	return 0;
 err:

