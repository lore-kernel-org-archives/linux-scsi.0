Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 6570CC433EF
	for <linux-scsi@archiver.kernel.org>; Wed, 13 Oct 2021 14:26:22 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 4870560E96
	for <linux-scsi@archiver.kernel.org>; Wed, 13 Oct 2021 14:26:22 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232784AbhJMO2Y (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Wed, 13 Oct 2021 10:28:24 -0400
Received: from stargate.chelsio.com ([12.32.117.8]:11075 "EHLO
        stargate.chelsio.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230348AbhJMO2Y (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Wed, 13 Oct 2021 10:28:24 -0400
Received: from fcoe-test11.asicdesigners.com (fcoe-test11.blr.asicdesigners.com [10.193.185.180])
        by stargate.chelsio.com (8.14.7/8.14.7) with ESMTP id 19DEPEEQ014289;
        Wed, 13 Oct 2021 07:25:15 -0700
From:   Varun Prakash <varun@chelsio.com>
To:     martin.petersen@oracle.com
Cc:     linux-scsi@vger.kernel.org, target-devel@vger.kernel.org,
        varun@chelsio.com
Subject: [PATCH] scsi: target: cxgbit: enable Delayed ACK
Date:   Wed, 13 Oct 2021 19:55:09 +0530
Message-Id: <1634135109-5044-1-git-send-email-varun@chelsio.com>
X-Mailer: git-send-email 2.0.2
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

Enable Delayed ACK to reduce the number of TCP ACKs.

Signed-off-by: Varun Prakash <varun@chelsio.com>
---
 drivers/target/iscsi/cxgbit/cxgbit_cm.c     |  8 +++-----
 drivers/target/iscsi/cxgbit/cxgbit_target.c | 28 +++++++++++++++++++++++-----
 2 files changed, 26 insertions(+), 10 deletions(-)

diff --git a/drivers/target/iscsi/cxgbit/cxgbit_cm.c b/drivers/target/iscsi/cxgbit/cxgbit_cm.c
index 518ded2..da31a30 100644
--- a/drivers/target/iscsi/cxgbit/cxgbit_cm.c
+++ b/drivers/target/iscsi/cxgbit/cxgbit_cm.c
@@ -836,11 +836,13 @@ static void cxgbit_set_tcp_window(struct cxgbit_sock *csk, struct port_info *pi)
 	csk->rcv_win = CXGBIT_10G_RCV_WIN;
 	if (scale)
 		csk->rcv_win *= scale;
+	csk->rcv_win = min(csk->rcv_win, RCV_BUFSIZ_M << 10);
 
 #define CXGBIT_10G_SND_WIN (256 * 1024)
 	csk->snd_win = CXGBIT_10G_SND_WIN;
 	if (scale)
 		csk->snd_win *= scale;
+	csk->snd_win = min(csk->snd_win, 512U * 1024);
 
 	pr_debug("%s snd_win %d rcv_win %d\n",
 		 __func__, csk->snd_win, csk->rcv_win);
@@ -1065,7 +1067,7 @@ int cxgbit_rx_data_ack(struct cxgbit_sock *csk)
 	if (!skb)
 		return -1;
 
-	credit_dack = RX_DACK_CHANGE_F | RX_DACK_MODE_V(1) |
+	credit_dack = RX_DACK_CHANGE_F | RX_DACK_MODE_V(3) |
 		      RX_CREDITS_V(csk->rx_credits);
 
 	cxgb_mk_rx_data_ack(skb, len, csk->tid, csk->ctrlq_idx,
@@ -1197,7 +1199,6 @@ cxgbit_pass_accept_rpl(struct cxgbit_sock *csk, struct cpl_pass_accept_req *req)
 	if (tcph->ece && tcph->cwr)
 		opt2 |= CCTRL_ECN_V(1);
 
-	opt2 |= RX_COALESCE_V(3);
 	opt2 |= CONG_CNTRL_V(CONG_ALG_NEWRENO);
 
 	opt2 |= T5_ISS_F;
@@ -1646,9 +1647,6 @@ cxgbit_pass_establish(struct cxgbit_device *cdev, struct sk_buff *skb)
 
 	csk->rcv_nxt = rcv_isn;
 
-	if (csk->rcv_win > (RCV_BUFSIZ_M << 10))
-		csk->rx_credits = (csk->rcv_win - (RCV_BUFSIZ_M << 10));
-
 	csk->snd_wscale = TCPOPT_SND_WSCALE_G(tcp_opt);
 	cxgbit_set_emss(csk, tcp_opt);
 	dst_confirm(csk->dst);
diff --git a/drivers/target/iscsi/cxgbit/cxgbit_target.c b/drivers/target/iscsi/cxgbit/cxgbit_target.c
index 282297f..d314ee1 100644
--- a/drivers/target/iscsi/cxgbit/cxgbit_target.c
+++ b/drivers/target/iscsi/cxgbit/cxgbit_target.c
@@ -189,8 +189,8 @@ cxgbit_tx_data_wr(struct cxgbit_sock *csk, struct sk_buff *skb, u32 dlen,
 	wr_ulp_mode = FW_OFLD_TX_DATA_WR_ULPMODE_V(ULP_MODE_ISCSI) |
 				FW_OFLD_TX_DATA_WR_ULPSUBMODE_V(submode);
 
-	req->tunnel_to_proxy = htonl((wr_ulp_mode) | force |
-		 FW_OFLD_TX_DATA_WR_SHOVE_V(skb_peek(&csk->txq) ? 0 : 1));
+	req->tunnel_to_proxy = htonl(wr_ulp_mode | force |
+				     FW_OFLD_TX_DATA_WR_SHOVE_F);
 }
 
 static void cxgbit_arp_failure_skb_discard(void *handle, struct sk_buff *skb)
@@ -1531,7 +1531,7 @@ static int cxgbit_process_lro_skb(struct cxgbit_sock *csk, struct sk_buff *skb)
 	return ret;
 }
 
-static int cxgbit_rx_lro_skb(struct cxgbit_sock *csk, struct sk_buff *skb)
+static int cxgbit_t5_rx_lro_skb(struct cxgbit_sock *csk, struct sk_buff *skb)
 {
 	struct cxgbit_lro_cb *lro_cb = cxgbit_skb_lro_cb(skb);
 	struct cxgbit_lro_pdu_cb *pdu_cb = cxgbit_skb_lro_pdu_cb(skb, 0);
@@ -1557,6 +1557,24 @@ static int cxgbit_rx_lro_skb(struct cxgbit_sock *csk, struct sk_buff *skb)
 	return ret;
 }
 
+static int cxgbit_rx_lro_skb(struct cxgbit_sock *csk, struct sk_buff *skb)
+{
+	struct cxgbit_lro_cb *lro_cb = cxgbit_skb_lro_cb(skb);
+	int ret;
+
+	ret = cxgbit_process_lro_skb(csk, skb);
+	if (ret)
+		return ret;
+
+	csk->rx_credits += lro_cb->pdu_totallen;
+	if (csk->rx_credits >= csk->rcv_win) {
+		csk->rx_credits = 0;
+		cxgbit_rx_data_ack(csk);
+	}
+
+	return 0;
+}
+
 static int cxgbit_rx_skb(struct cxgbit_sock *csk, struct sk_buff *skb)
 {
 	struct cxgb4_lld_info *lldi = &csk->com.cdev->lldi;
@@ -1564,9 +1582,9 @@ static int cxgbit_rx_skb(struct cxgbit_sock *csk, struct sk_buff *skb)
 
 	if (likely(cxgbit_skcb_flags(skb) & SKCBF_RX_LRO)) {
 		if (is_t5(lldi->adapter_type))
-			ret = cxgbit_rx_lro_skb(csk, skb);
+			ret = cxgbit_t5_rx_lro_skb(csk, skb);
 		else
-			ret = cxgbit_process_lro_skb(csk, skb);
+			ret = cxgbit_rx_lro_skb(csk, skb);
 	}
 
 	__kfree_skb(skb);
-- 
2.0.2

