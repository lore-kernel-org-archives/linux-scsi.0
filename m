From: Hiral Patel <hiralpat@cisco.com>
Subject: [PATCH 09/10] fnic: Kernel panic due to FIP mode misconfiguration
Date: Tue, 12 Feb 2013 17:01:04 -0800
Message-ID: <1360717265-14130-7-git-send-email-hiralpat@cisco.com>
References: <1360717265-14130-1-git-send-email-hiralpat@cisco.com>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mtv-iport-4.cisco.com ([173.36.130.15]:26456 "EHLO
	mtv-iport-4.cisco.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759521Ab3BMBHA (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Tue, 12 Feb 2013 20:07:00 -0500
In-Reply-To: <1360717265-14130-1-git-send-email-hiralpat@cisco.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org
Cc: jbottomley@parallels.com, Hiral Patel <hiralpat@cisco.com>

If switch configured in FIP and adapter configured in non-fip mode, driver
panics while queueing FIP frame in non-existing fip_frame_queue. Added config
check before queueing FIP frame in misconfiguration case to avoid kernel panic.

Signed-off-by: Hiral Patel <hiralpat@cisco.com>
---
 drivers/scsi/fnic/fnic_fcs.c |    6 ++++++
 1 file changed, 6 insertions(+)

diff --git a/drivers/scsi/fnic/fnic_fcs.c b/drivers/scsi/fnic/fnic_fcs.c
index 41faca4..a0092e8 100644
--- a/drivers/scsi/fnic/fnic_fcs.c
+++ b/drivers/scsi/fnic/fnic_fcs.c
@@ -603,6 +603,12 @@ static inline int fnic_import_rq_eth_pkt(struct fnic *fnic, struct sk_buff *skb)
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

