From: Wei Yongjun <yjwei@cn.fujitsu.com>
Subject: [PATCH] cxgb3i: remove some pointless conditionals before kfree_skb()
Date: Wed, 25 Feb 2009 18:25:03 +0800
Message-ID: <49A51C7F.3050903@cn.fujitsu.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=GB2312
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from cn.fujitsu.com ([222.73.24.84]:49573 "EHLO song.cn.fujitsu.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1754041AbZBYKZg (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Wed, 25 Feb 2009 05:25:36 -0500
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James Bottomley <James.Bottomley@HansenPartnership.com>, Wei Yongjun <yjwei@cn.fujitsu.com>
Cc: linux-scsi@vger.kernel.org

Remove some pointless conditionals before kfree_skb().

Signed-off-by: Wei Yongjun <yjwei@cn.fujitsu.com>
---
 drivers/scsi/cxgb3i/cxgb3i_offload.c |    9 +++------
 drivers/scsi/cxgb3i/cxgb3i_pdu.c     |    3 +--
 2 files changed, 4 insertions(+), 8 deletions(-)

diff --git a/drivers/scsi/cxgb3i/cxgb3i_offload.c b/drivers/scsi/cxgb3i/cxgb3i_offload.c
index a865f1f..8b3754a 100644
--- a/drivers/scsi/cxgb3i/cxgb3i_offload.c
+++ b/drivers/scsi/cxgb3i/cxgb3i_offload.c
@@ -1208,12 +1208,9 @@ static int do_wr_ack(struct t3cdev *cdev, struct sk_buff *skb, void *ctx)
  */
 static void c3cn_free_cpl_skbs(struct s3_conn *c3cn)
 {
-	if (c3cn->cpl_close)
-		kfree_skb(c3cn->cpl_close);
-	if (c3cn->cpl_abort_req)
-		kfree_skb(c3cn->cpl_abort_req);
-	if (c3cn->cpl_abort_rpl)
-		kfree_skb(c3cn->cpl_abort_rpl);
+	kfree_skb(c3cn->cpl_close);
+	kfree_skb(c3cn->cpl_abort_req);
+	kfree_skb(c3cn->cpl_abort_rpl);
 }
 
 static int c3cn_alloc_cpl_skbs(struct s3_conn *c3cn)
diff --git a/drivers/scsi/cxgb3i/cxgb3i_pdu.c b/drivers/scsi/cxgb3i/cxgb3i_pdu.c
index ce7ce8c..a0d4f43 100644
--- a/drivers/scsi/cxgb3i/cxgb3i_pdu.c
+++ b/drivers/scsi/cxgb3i/cxgb3i_pdu.c
@@ -149,8 +149,7 @@ void cxgb3i_conn_cleanup_task(struct iscsi_task *task)
 	struct iscsi_tcp_task *tcp_task = task->dd_data;
 
 	/* never reached the xmit task callout */
-	if (tcp_task->dd_data)
-		kfree_skb(tcp_task->dd_data);
+	kfree_skb(tcp_task->dd_data);
 	tcp_task->dd_data = NULL;
 
 	/* MNC - Do we need a check in case this is called but
-- 
1.5.3.8




