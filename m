From: Zhouyi Zhou <zhouzhouyi@gmail.com>
Subject: [PATCH 1/1] scsi: fcoe: return value of skb_linearize should be handled
Date: Wed,  7 Dec 2016 16:00:00 +0800
Message-ID: <1481097600-25604-1-git-send-email-zhouzhouyi@gmail.com>
Return-path: <linux-kernel-owner@vger.kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
To: jejb@linux.vnet.ibm.com, martin.petersen@oracle.com, jth@kernel.org, fcoe-devel@open-fcoe.org, linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org
Cc: Zhouyi Zhou <zhouzhouyi@gmail.com>, Zhouyi Zhou <yizhouzhou@ict.ac.cn>
List-Id: linux-scsi@vger.kernel.org

Return value of skb_linearize should be handled.

Signed-off-by: Zhouyi Zhou <yizhouzhou@ict.ac.cn>
Reviewed-by: Yuval Shaia <yuval.shaia@oracle.com> 
---
 drivers/scsi/bnx2fc/bnx2fc_fcoe.c | 6 ++++--
 drivers/scsi/fcoe/fcoe.c          | 5 ++++-
 2 files changed, 8 insertions(+), 3 deletions(-)

diff --git a/drivers/scsi/bnx2fc/bnx2fc_fcoe.c b/drivers/scsi/bnx2fc/bnx2fc_fcoe.c
index f9ddb61..142f7e2 100644
--- a/drivers/scsi/bnx2fc/bnx2fc_fcoe.c
+++ b/drivers/scsi/bnx2fc/bnx2fc_fcoe.c
@@ -542,8 +542,10 @@ static void bnx2fc_recv_frame(struct sk_buff *skb)
 		return;
 	}
 
-	if (skb_is_nonlinear(skb))
-		skb_linearize(skb);
+	if (skb_linearize(skb)) {
+		kfree_skb(skb);
+		return;
+	}
 	mac = eth_hdr(skb)->h_source;
 	dest_mac = eth_hdr(skb)->h_dest;
 
diff --git a/drivers/scsi/fcoe/fcoe.c b/drivers/scsi/fcoe/fcoe.c
index 9bd41a3..4e3499c 100644
--- a/drivers/scsi/fcoe/fcoe.c
+++ b/drivers/scsi/fcoe/fcoe.c
@@ -1685,7 +1685,10 @@ static void fcoe_recv_frame(struct sk_buff *skb)
 			skb->dev ? skb->dev->name : "<NULL>");
 
 	port = lport_priv(lport);
-	skb_linearize(skb); /* check for skb_is_nonlinear is within skb_linearize */
+	if (skb_linearize(skb)) {
+		kfree_skb(skb);
+		return;
+	}
 
 	/*
 	 * Frame length checks and setting up the header pointers
-- 
1.9.1
