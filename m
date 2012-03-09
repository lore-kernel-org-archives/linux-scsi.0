From: Robert Love <robert.w.love@intel.com>
Subject: [PATCH 07/10] bnx2fc: Remove bh disable in softirq context
Date: Fri, 09 Mar 2012 14:50:13 -0800
Message-ID: <20120309225013.6515.6374.stgit@localhost6.localdomain6>
References: <20120309224937.6515.83801.stgit@localhost6.localdomain6>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mga03.intel.com ([143.182.124.21]:65039 "EHLO mga03.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755601Ab2CIWuO (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Fri, 9 Mar 2012 17:50:14 -0500
In-Reply-To: <20120309224937.6515.83801.stgit@localhost6.localdomain6>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org
Cc: Neil Horman <nhorman@tuxdriver.com>, Bhanu Prakash Gollapudi <bprakash@broadcom.com>

From: Neil Horman <nhorman@tuxdriver.com>

As with the fcoe sw transport, the bnx2fc packet handler function runs only in
softirq context.  Theres no need to disable bottom halves here

Signed-off-by: Neil Horman <nhorman@tuxdriver.com>
Acked-by: Bhanu Prakash Gollapudi <bprakash@broadcom.com>
Signed-off-by: Robert Love <robert.w.love@intel.com>
---
 drivers/scsi/bnx2fc/bnx2fc_fcoe.c |    4 ++--
 1 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/scsi/bnx2fc/bnx2fc_fcoe.c b/drivers/scsi/bnx2fc/bnx2fc_fcoe.c
index 796fd30..1c34a44 100644
--- a/drivers/scsi/bnx2fc/bnx2fc_fcoe.c
+++ b/drivers/scsi/bnx2fc/bnx2fc_fcoe.c
@@ -440,13 +440,13 @@ static int bnx2fc_rcv(struct sk_buff *skb, struct net_device *dev,
 	fr->fr_dev = lport;
 
 	bg = &bnx2fc_global;
-	spin_lock_bh(&bg->fcoe_rx_list.lock);
+	spin_lock(&bg->fcoe_rx_list.lock);
 
 	__skb_queue_tail(&bg->fcoe_rx_list, skb);
 	if (bg->fcoe_rx_list.qlen == 1)
 		wake_up_process(bg->thread);
 
-	spin_unlock_bh(&bg->fcoe_rx_list.lock);
+	spin_unlock(&bg->fcoe_rx_list.lock);
 
 	return 0;
 err:

