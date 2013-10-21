From: Robert Love <robert.w.love@intel.com>
Subject: [PATCH 03/19] fcoe: cleanup return codes from fcoe_rcv
Date: Mon, 21 Oct 2013 11:00:40 -0700
Message-ID: <20131021180040.31563.94585.stgit@fritz>
References: <20131021180024.31563.89632.stgit@fritz>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mga11.intel.com ([192.55.52.93]:29453 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752052Ab3JUSAw (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Mon, 21 Oct 2013 14:00:52 -0400
In-Reply-To: <20131021180024.31563.89632.stgit@fritz>
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

