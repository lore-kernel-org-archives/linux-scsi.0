From: Hiral Patel <hiralpat@cisco.com>
Subject: [PATCH 09/10] fnic: Kernel panic due to FIP mode misconfiguration
Date: Mon, 10 Dec 2012 01:21:38 -0800
Message-ID: <1355131299-3313-10-git-send-email-hiralpat@cisco.com>
References: <1355131299-3313-1-git-send-email-hiralpat@cisco.com>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mtv-iport-4.cisco.com ([173.36.130.15]:35687 "EHLO
	mtv-iport-4.cisco.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753788Ab2LJJ0Y (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Mon, 10 Dec 2012 04:26:24 -0500
In-Reply-To: <1355131299-3313-1-git-send-email-hiralpat@cisco.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org
Cc: JBottomley@parallels.com, Hiral Patel <hiralpat@cisco.com>

If switch configured in FIP and adapter configured in non-fip mode, driver
panics while queueing FIP frame in non-existing fip_frame_queue. Added config
check before queueing FIP frame in misconfiguration case to avoid kernel panic.

Signed-off-by: Hiral Patel <hiralpat@cisco.com>
---
 drivers/scsi/fnic/fnic_fcs.c |    6 ++++++
 1 file changed, 6 insertions(+)

diff --git a/drivers/scsi/fnic/fnic_fcs.c b/drivers/scsi/fnic/fnic_fcs.c
index 3810c0b..d1cc7a4 100644
--- a/drivers/scsi/fnic/fnic_fcs.c
+++ b/drivers/scsi/fnic/fnic_fcs.c
@@ -602,6 +602,12 @@ static inline int fnic_import_rq_eth_pkt(struct fnic *fnic, struct sk_buff *skb)
 		skb_reset_mac_header(skb);
 	}
 	if (eh->h_proto == htons(ETH_P_FIP)) {
+		if (!(fnic->config.flags & VFCF_FIP_CAPABLE)) {
+			printk(KERN_ERR "Dropped FIP frame, as firmware "
+					"uses non-FIP mode, Enable FIP "
+					"using UCSM\n");
+			goto drop;
+		}
 		skb_queue_tail(&fnic->fip_frame_queue, skb);
 		queue_work(fnic_fip_queue, &fnic->fip_frame_work);
 		return 1;		/* let caller know packet was used */
-- 
1.7.9.5

