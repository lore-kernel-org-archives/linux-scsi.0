From: Robert Love <robert.w.love@intel.com>
Subject: [PATCH 02/10] fcoe: Ensure fcoe_recv_frame is always called in
 process context
Date: Fri, 09 Mar 2012 14:49:48 -0800
Message-ID: <20120309224948.6515.58974.stgit@localhost6.localdomain6>
References: <20120309224937.6515.83801.stgit@localhost6.localdomain6>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mga09.intel.com ([134.134.136.24]:63318 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S964830Ab2CIWuu (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Fri, 9 Mar 2012 17:50:50 -0500
In-Reply-To: <20120309224937.6515.83801.stgit@localhost6.localdomain6>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org
Cc: Neil Horman <nhorman@tuxdriver.com>, Vasu Dev <vasu.dev@intel.com>

From: Neil Horman <nhorman@tuxdriver.com>

commit 859b7b649ab58ee5cbfb761491317d5b315c1b0f introduced the ability to call
fcoe_recv_frame in softirq context.  While this is beneficial to performance,
its not safe to do, as it breaks the serialization of access to the lport
structure (i.e. when an fcoe interface is being torn down, theres no way to
serialize the teardown effort with the completion of receieve operations
occuring in softirq context.  As a result, lport (and other) data structures can
be read and modified in parallel leading to corruption.  Most notable is the
vport list, which is protected by a mutex, that will cause a panic if a softirq
receive while said mutex is locked.  Additionaly, the ema_list, discussed here:

http://lists.open-fcoe.org/pipermail/devel/2012-February/011947.html

Can be corrupted if a list traversal occurs in softirq context at the same time
as a list delete in process context.  And generally the lport state variables
will not be stable, and may lead to unpredictable results.

The most direct fix is to remove the bits from the above commit that allowed
fcoe_recv_frame to be called in softirq context.  We just force all frames to be
handled by the per-cpu rx threads.  This will allow the fcoe_if_destroy's use of
fcoe_percpu_clean to function properly, ensuring that no frames are being
received while the lport is being torn down.

Signed-off-by: Neil Horman <nhorman@tuxdriver.com>
Reviewed-by: Vasu Dev <vasu.dev@intel.com>
Signed-off-by: Robert Love <robert.w.love@intel.com>
---
 drivers/scsi/fcoe/fcoe.c |   27 ++++++++++-----------------
 1 files changed, 10 insertions(+), 17 deletions(-)

diff --git a/drivers/scsi/fcoe/fcoe.c b/drivers/scsi/fcoe/fcoe.c
index 2789581..22ae295 100644
--- a/drivers/scsi/fcoe/fcoe.c
+++ b/drivers/scsi/fcoe/fcoe.c
@@ -1463,24 +1463,17 @@ static int fcoe_rcv(struct sk_buff *skb, struct net_device *netdev,
 	 * so we're free to queue skbs into it's queue.
 	 */
 
-	/* If this is a SCSI-FCP frame, and this is already executing on the
-	 * correct CPU, and the queue for this CPU is empty, then go ahead
-	 * and process the frame directly in the softirq context.
-	 * This lets us process completions without context switching from the
-	 * NET_RX softirq, to our receive processing thread, and then back to
-	 * BLOCK softirq context.
+	/*
+	 * Note: We used to have a set of conditions under which we would
+	 * call fcoe_recv_frame directly, rather than queuing to the rx list
+	 * as it could save a few cycles, but doing so is prohibited, as
+	 * fcoe_recv_frame has several paths that may sleep, which is forbidden
+	 * in softirq context.
 	 */
-	if (fh->fh_type == FC_TYPE_FCP &&
-	    cpu == smp_processor_id() &&
-	    skb_queue_empty(&fps->fcoe_rx_list)) {
-		spin_unlock_bh(&fps->fcoe_rx_list.lock);
-		fcoe_recv_frame(skb);
-	} else {
-		__skb_queue_tail(&fps->fcoe_rx_list, skb);
-		if (fps->fcoe_rx_list.qlen == 1)
-			wake_up_process(fps->thread);
-		spin_unlock_bh(&fps->fcoe_rx_list.lock);
-	}
+	__skb_queue_tail(&fps->fcoe_rx_list, skb);
+	if (fps->fcoe_rx_list.qlen == 1)
+		wake_up_process(fps->thread);
+	spin_unlock_bh(&fps->fcoe_rx_list.lock);
 
 	return 0;
 err:

