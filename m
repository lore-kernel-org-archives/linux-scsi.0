From: Varun Prakash <varun@chelsio.com>
Subject: [PATCH] scsi: cxgb4i: assign rxqs in round robin mode
Date: Thu, 22 Jun 2017 15:47:49 +0530
Message-ID: <1498126669-5654-1-git-send-email-varun@chelsio.com>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from stargate.chelsio.com ([12.32.117.8]:41310 "EHLO
        stargate.chelsio.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1753135AbdFVKSJ (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Thu, 22 Jun 2017 06:18:09 -0400
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: martin.petersen@oracle.com
Cc: linux-scsi@vger.kernel.org, indranil@chelsio.com, varun@chelsio.com

Assign rxq to TCP connections in round robin mode
to use all available rxqs.

Signed-off-by: Varun Prakash <varun@chelsio.com>
---
 drivers/scsi/cxgbi/cxgb4i/cxgb4i.c | 5 ++++-
 drivers/scsi/cxgbi/libcxgbi.h      | 1 +
 2 files changed, 5 insertions(+), 1 deletion(-)

diff --git a/drivers/scsi/cxgbi/cxgb4i/cxgb4i.c b/drivers/scsi/cxgbi/cxgb4i/cxgb4i.c
index 0aae094..fa99471 100644
--- a/drivers/scsi/cxgbi/cxgb4i/cxgb4i.c
+++ b/drivers/scsi/cxgbi/cxgb4i/cxgb4i.c
@@ -1606,6 +1606,7 @@ static int init_act_open(struct cxgbi_sock *csk)
 	struct neighbour *n = NULL;
 	void *daddr;
 	unsigned int step;
+	unsigned int rxq_idx;
 	unsigned int size, size6;
 	unsigned int linkspeed;
 	unsigned int rcv_winf, snd_winf;
@@ -1684,7 +1685,9 @@ static int init_act_open(struct cxgbi_sock *csk)
 	step = lldi->ntxq / lldi->nchan;
 	csk->txq_idx = cxgb4_port_idx(ndev) * step;
 	step = lldi->nrxq / lldi->nchan;
-	csk->rss_qid = lldi->rxq_ids[cxgb4_port_idx(ndev) * step];
+	rxq_idx = (cxgb4_port_idx(ndev) * step) + (cdev->rxq_idx_cntr % step);
+	cdev->rxq_idx_cntr++;
+	csk->rss_qid = lldi->rxq_ids[rxq_idx];
 	linkspeed = ((struct port_info *)netdev_priv(ndev))->link_cfg.speed;
 	csk->snd_win = cxgb4i_snd_win;
 	csk->rcv_win = cxgb4i_rcv_win;
diff --git a/drivers/scsi/cxgbi/libcxgbi.h b/drivers/scsi/cxgbi/libcxgbi.h
index 37f07aa..31a5816 100644
--- a/drivers/scsi/cxgbi/libcxgbi.h
+++ b/drivers/scsi/cxgbi/libcxgbi.h
@@ -477,6 +477,7 @@ struct cxgbi_device {
 	unsigned int skb_rx_extra;	/* for msg coalesced mode */
 	unsigned int tx_max_size;
 	unsigned int rx_max_size;
+	unsigned int rxq_idx_cntr;
 	struct cxgbi_ports_map pmap;
 
 	void (*dev_ddp_cleanup)(struct cxgbi_device *);
-- 
2.0.2
