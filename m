Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C7146C433EF
	for <linux-scsi@archiver.kernel.org>; Wed, 29 Sep 2021 07:03:34 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id AA2AD6138E
	for <linux-scsi@archiver.kernel.org>; Wed, 29 Sep 2021 07:03:34 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S244395AbhI2HFO (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Wed, 29 Sep 2021 03:05:14 -0400
Received: from mailgw02.mediatek.com ([210.61.82.184]:55520 "EHLO
        mailgw02.mediatek.com" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
        with ESMTP id S244487AbhI2HDH (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Wed, 29 Sep 2021 03:03:07 -0400
X-UUID: 09f38eee42fc49fd9aa086be41ebcf0d-20210929
X-UUID: 09f38eee42fc49fd9aa086be41ebcf0d-20210929
Received: from mtkcas11.mediatek.inc [(172.21.101.40)] by mailgw02.mediatek.com
        (envelope-from <powen.kao@mediatek.com>)
        (Generic MTA with TLSv1.2 ECDHE-RSA-AES256-SHA384 256/256)
        with ESMTP id 179617446; Wed, 29 Sep 2021 15:01:20 +0800
Received: from mtkcas11.mediatek.inc (172.21.101.40) by
 mtkmbs10n2.mediatek.inc (172.21.101.183) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA384) id 15.2.792.3;
 Wed, 29 Sep 2021 15:01:18 +0800
Received: from mtksdccf07.mediatek.inc (172.21.84.99) by mtkcas11.mediatek.inc
 (172.21.101.73) with Microsoft SMTP Server id 15.0.1497.2 via Frontend
 Transport; Wed, 29 Sep 2021 15:01:18 +0800
From:   Po-Wen Kao <powen.kao@mediatek.com>
To:     <linux-block@vger.kernel.org>, <axboe@kernel.dk>,
        <linux-kernel@vger.kernel.org>, <stanley.chu@mediatek.com>,
        <linux-scsi@vger.kernel.org>, <martin.petersen@oracle.com>,
        <avri.altman@wdc.com>, <alim.akhtar@samsung.com>,
        <jejb@linux.ibm.com>
CC:     <peter.wang@mediatek.com>, <chun-hung.wu@mediatek.com>,
        <alice.chao@mediatek.com>, <jonathan.hsu@mediatek.com>,
        <powen.kao@mediatek.com>, <cc.chou@mediatek.com>,
        <chaotian.jing@mediatek.com>, <jiajie.hao@mediatek.com>,
        <wsd_upstream@mediatek.com>, <ed.tsai@mediatek.com>
Subject: [PATCH 1/2] blk-mq: new busy request iterator for driver
Date:   Wed, 29 Sep 2021 15:00:46 +0800
Message-ID: <20210929070047.4223-2-powen.kao@mediatek.com>
X-Mailer: git-send-email 2.18.0
In-Reply-To: <20210929070047.4223-1-powen.kao@mediatek.com>
References: <20210929070047.4223-1-powen.kao@mediatek.com>
MIME-Version: 1.0
Content-Type: text/plain
X-MTK:  N
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

Driver occasionally execute allocated request directly without
dispatching to block layer, thus request never appears in tags->rqs.
To allow driver to iterate through requests in static_rqs, a new
interface blk_mq_drv_tagset_busy_iter() is introduced.

Signed-off-by: Po-Wen Kao <powen.kao@mediatek.com>
---
 block/blk-mq-tag.c     | 36 ++++++++++++++++++++++++++++++------
 include/linux/blk-mq.h |  4 ++++
 2 files changed, 34 insertions(+), 6 deletions(-)

diff --git a/block/blk-mq-tag.c b/block/blk-mq-tag.c
index 86f87346232a..7723689e7714 100644
--- a/block/blk-mq-tag.c
+++ b/block/blk-mq-tag.c
@@ -365,6 +365,31 @@ void blk_mq_all_tag_iter(struct blk_mq_tags *tags, busy_tag_iter_fn *fn,
 
 /**
  * blk_mq_tagset_busy_iter - iterate over all started requests in a tag set
+ * Refer to __blk_mq_tagset_iter() for parameter details.
+ */
+void blk_mq_tagset_busy_iter(struct blk_mq_tag_set *tagset,
+		busy_tag_iter_fn *fn, void *priv)
+{
+	__blk_mq_tagset_iter(tagset, fn, priv,
+			BT_TAG_ITER_STARTED);
+}
+EXPORT_SYMBOL(blk_mq_tagset_busy_iter);
+
+/**
+ * blk_mq_drv_tagset_busy_iter - iterate over all started static requests
+ * in a tag set.
+ * Refer to __blk_mq_tagset_iter() for parameter details.
+ */
+void blk_mq_drv_tagset_busy_iter(struct blk_mq_tag_set *tagset,
+		busy_tag_iter_fn *fn, void *priv)
+{
+	__blk_mq_tagset_iter(tagset, fn, priv,
+			BT_TAG_ITER_STARTED | BT_TAG_ITER_STATIC_RQS);
+}
+EXPORT_SYMBOL(blk_mq_drv_tagset_busy_iter);
+
+/**
+ * blk_mq_tm_tagset_busy_iter - iterate over all requests in a tagset.
  * @tagset:	Tag set to iterate over.
  * @fn:		Pointer to the function that will be called for each started
  *		request. @fn will be called as follows: @fn(rq, @priv,
@@ -375,19 +400,18 @@ void blk_mq_all_tag_iter(struct blk_mq_tags *tags, busy_tag_iter_fn *fn,
  *
  * We grab one request reference before calling @fn and release it after
  * @fn returns.
+ * @flags: BT_TAG_ITER_*
  */
-void blk_mq_tagset_busy_iter(struct blk_mq_tag_set *tagset,
-		busy_tag_iter_fn *fn, void *priv)
+void __blk_mq_tagset_iter(struct blk_mq_tag_set *tagset,
+		busy_tag_iter_fn *fn, void *priv, unsigned int flags)
 {
 	int i;
-
 	for (i = 0; i < tagset->nr_hw_queues; i++) {
 		if (tagset->tags && tagset->tags[i])
-			__blk_mq_all_tag_iter(tagset->tags[i], fn, priv,
-					      BT_TAG_ITER_STARTED);
+			__blk_mq_all_tag_iter(tagset->tags[i], fn, priv, flags);
 	}
 }
-EXPORT_SYMBOL(blk_mq_tagset_busy_iter);
+
 
 static bool blk_mq_tagset_count_completed_rqs(struct request *rq,
 		void *data, bool reserved)
diff --git a/include/linux/blk-mq.h b/include/linux/blk-mq.h
index 13ba1861e688..29c851192093 100644
--- a/include/linux/blk-mq.h
+++ b/include/linux/blk-mq.h
@@ -545,6 +545,10 @@ void blk_mq_run_hw_queues(struct request_queue *q, bool async);
 void blk_mq_delay_run_hw_queues(struct request_queue *q, unsigned long msecs);
 void blk_mq_tagset_busy_iter(struct blk_mq_tag_set *tagset,
 		busy_tag_iter_fn *fn, void *priv);
+void blk_mq_drv_tagset_busy_iter(struct blk_mq_tag_set *tagset,
+		busy_tag_iter_fn *fn, void *priv);
+void __blk_mq_tagset_iter(struct blk_mq_tag_set *tagset,
+		busy_tag_iter_fn *fn, void *priv, unsigned int flags);
 void blk_mq_tagset_wait_completed_request(struct blk_mq_tag_set *tagset);
 void blk_mq_freeze_queue(struct request_queue *q);
 void blk_mq_unfreeze_queue(struct request_queue *q);
-- 
2.18.0

