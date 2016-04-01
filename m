From: Chad Dupuis <chad.dupuis@qlogic.com>
Subject: [PATCH 2/5] bnx2fc: Print when we send a fip keep alive.
Date: Fri, 1 Apr 2016 09:10:20 -0400
Message-ID: <1459516223-32106-3-git-send-email-chad.dupuis@qlogic.com>
References: <1459516223-32106-1-git-send-email-chad.dupuis@qlogic.com>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mx0a-0016ce01.pphosted.com ([67.231.148.157]:38232 "EHLO
	mx0b-0016ce01.pphosted.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1752565AbcDANvd (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Fri, 1 Apr 2016 09:51:33 -0400
In-Reply-To: <1459516223-32106-1-git-send-email-chad.dupuis@qlogic.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: jejb@linux.vnet.ibm.com, martin.petersen@oracle.com
Cc: chad.dupuis@qlogic.com, saurav.kashyap@qlogic.com, linux-scsi@vger.kernel.org

Signed-off-by: Chad Dupuis <chad.dupuis@qlogic.com>
---
 drivers/scsi/bnx2fc/bnx2fc_fcoe.c | 19 +++++++++++++++++++
 1 file changed, 19 insertions(+)

diff --git a/drivers/scsi/bnx2fc/bnx2fc_fcoe.c b/drivers/scsi/bnx2fc/bnx2fc_fcoe.c
index 600c29d..d95eee6 100644
--- a/drivers/scsi/bnx2fc/bnx2fc_fcoe.c
+++ b/drivers/scsi/bnx2fc/bnx2fc_fcoe.c
@@ -127,6 +127,11 @@ module_param_named(tm_timeout, bnx2fc_tm_timeout, uint, S_IRUGO|S_IWUSR);
 MODULE_PARM_DESC(tm_timeout, " Change the default timeout for "
 	"task management commands. Default 60 seconds.");
 
+uint bnx2fc_log_fka;
+module_param_named(log_fka, bnx2fc_log_fka, uint, S_IRUGO|S_IWUSR);
+MODULE_PARM_DESC(log_fka, " Print message to kernel log when fcoe is "
+	"initiating a FIP keep alive when debug logging is enabled.");
+
 static int bnx2fc_cpu_callback(struct notifier_block *nfb,
 			     unsigned long action, void *hcpu);
 /* notification function for CPU hotplug events */
@@ -1081,6 +1086,20 @@ static u8 *bnx2fc_get_src_mac(struct fc_lport *lport)
  */
 static void bnx2fc_fip_send(struct fcoe_ctlr *fip, struct sk_buff *skb)
 {
+	struct fip_header *fiph;
+	struct ethhdr *eth_hdr;
+	u16 op;
+	u8 sub;
+
+	fiph = (struct fip_header *) ((void *)skb->data + 2 * ETH_ALEN + 2);
+	eth_hdr = (struct ethhdr *)skb_mac_header(skb);
+	op = ntohs(fiph->fip_op);
+	sub = fiph->fip_subcode;
+
+	if (op == FIP_OP_CTRL && sub == FIP_SC_SOL && bnx2fc_log_fka)
+		BNX2FC_MISC_DBG("Sending FKA from %pM to %pM.\n",
+		    eth_hdr->h_source, eth_hdr->h_dest);
+
 	skb->dev = bnx2fc_from_ctlr(fip)->netdev;
 	dev_queue_xmit(skb);
 }
-- 
2.0.0.rc0.26.g779792a

