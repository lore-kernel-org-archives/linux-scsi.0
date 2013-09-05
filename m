From: Robert Love <robert.w.love@intel.com>
Subject: [PATCH 03/16] fcoe: cleanup return codes from fcoe_rcv
Date: Thu, 05 Sep 2013 12:12:34 -0700
Message-ID: <20130905191234.15235.55802.stgit@fritz>
References: <20130905191218.15235.85917.stgit@fritz>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mga03.intel.com ([143.182.124.21]:22673 "EHLO mga03.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756579Ab3IETMg (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Thu, 5 Sep 2013 15:12:36 -0400
In-Reply-To: <20130905191218.15235.85917.stgit@fritz>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org
Cc: Neil Horman <nhorman@tuxdriver.com>

From: Neil Horman <nhorman@tuxdriver.com>

the return codes from fcoe_rcv should be NET_RX_*, not 0 or -1.

Signed-off-by: Neil Horman <nhorman@tuxdriver.com>
Signed-off-by: Robert Love <robert.w.love@intel.com>
---
 drivers/scsi/fcoe/fcoe.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/scsi/fcoe/fcoe.c b/drivers/scsi/fcoe/fcoe.c
index f9b0302..134ca3b 100644
--- a/drivers/scsi/fcoe/fcoe.c
+++ b/drivers/scsi/fcoe/fcoe.c
@@ -1546,13 +1546,13 @@ static int fcoe_rcv(struct sk_buff *skb, struct net_device *netdev,
 		wake_up_process(fps->thread);
 	spin_unlock(&fps->fcoe_rx_list.lock);
 
-	return 0;
+	return NET_RX_SUCCESS;
 err:
 	per_cpu_ptr(lport->stats, get_cpu())->ErrorFrames++;
 	put_cpu();
 err2:
 	kfree_skb(skb);
-	return -1;
+	return NET_RX_DROP;
 }
 
 /**

