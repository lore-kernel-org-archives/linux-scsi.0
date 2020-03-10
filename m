Return-Path: <SRS0=Pfrg=43=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.6 required=3.0 tests=DKIM_INVALID,DKIM_SIGNED,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT autolearn=unavailable
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 5D522C18E5C
	for <linux-scsi@archiver.kernel.org>; Tue, 10 Mar 2020 09:47:25 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 35F6D2467D
	for <linux-scsi@archiver.kernel.org>; Tue, 10 Mar 2020 09:47:25 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="signature verification failed" (2048-bit key) header.d=wdc.com header.i=@wdc.com header.b="iHm3JEd/"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726391AbgCJJrY (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Tue, 10 Mar 2020 05:47:24 -0400
Received: from esa2.hgst.iphmx.com ([68.232.143.124]:26501 "EHLO
        esa2.hgst.iphmx.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726202AbgCJJrW (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Tue, 10 Mar 2020 05:47:22 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=wdc.com; i=@wdc.com; q=dns/txt; s=dkim.wdc.com;
  t=1583833649; x=1615369649;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=hKeEpOS2tHfv2S2nqYpCIKfQHW+iPi0t+T2+Lvls+fI=;
  b=iHm3JEd/xOSWEO+pDtI8EROhij/jl286NcIahjiHNkCDQWrvIBTanZea
   CwIkhBvHE7663A7UF/C0hl6ZJhfDxYUv0L9CMzdksIkPJ55dnSYrz9USR
   VVLAjHCaYUMCKsNILYLIFef69RHgSDhv0NOIWxsVMY8GiGKZGWuhkHnG0
   7rMdgG9G8DdtqkaGQH6VtGLDAhL6wmgzJmDIV3t4nn1Efki0n7U6MlE33
   KCIT8Mr2F75Em+YEagrVpGxfokxU11NwaNfpRoagjeaXkqlbIyHducuvf
   A4wiebprS2xKmJZC8JQeuSYh+Cd8aTlIBJ6pjLcW1scYKcdHs71e05oQO
   A==;
IronPort-SDR: hwRKxOKXPgwUbcqha4iWuX9Gb3h1bFoGw/S3amN22bpgejFEGBDcxM8xHkABnzUAStz7deBe/9
 4ddFIUQEL7IDCtD2K6jz3Do63wrVMsn57bcVZ/9TrUWGf/2UYRFKpFBq2FGKR8W4jG8X8YoPaY
 8/3wQnefVwBAIGQ1uMazodAWcLEhEuuggYHiq/zrVjeXhvb3SyMtP0Ac3TSNcCRh//SBvoeip5
 0mG0K9KwG/GFBtbFewsNHkcKiSJwBoPngMPjP6ulEbJ1gqCwKrJcOBoQ26ELdcarxOkp9NZp2/
 zKs=
X-IronPort-AV: E=Sophos;i="5.70,536,1574092800"; 
   d="scan'208";a="234082793"
Received: from uls-op-cesaip02.wdc.com (HELO uls-op-cesaep02.wdc.com) ([199.255.45.15])
  by ob1.hgst.iphmx.com with ESMTP; 10 Mar 2020 17:47:29 +0800
IronPort-SDR: tbG0fC0Mx9qvVkrRNJfBr2Nw0BmkHAq8aQKmDn+GN2YstujcsHBmx9MF4lI53KLyXtxb63OmSD
 GiJsMCy7Meg1Q1k/xLlaywhfag4fcN3oe+mc/xsqbbO5/Y0A/uq9C6YpWAnp5a++t9erYkZi2M
 FElvPVXnGW6qUYioXrPsCNVdwFM/IQdiJ8iDhdVRDVcTzZiW+PgBhWK7RVavOfrE7TKdGblTYz
 gmHow7I67nm+iUoz/mdW60qRe/+j+TvrzYhCzZNAgYGAbcPRwlYJlbfRW1r5xw1WQajHInnaXT
 aaZnmm+ZcbyvxgrdWPeHmNur
Received: from uls-op-cesaip02.wdc.com ([10.248.3.37])
  by uls-op-cesaep02.wdc.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 10 Mar 2020 02:39:03 -0700
IronPort-SDR: OkjUZnWHvpaydu5PLh/LrfCKpb1me7GRleP4vCJeZgbL+8yY+FUojtoTMOEQ/4MQvWVN2eKb9f
 aLilg/BPQmYoYeX/01znRih65Xehr5HFZfKbXfwSGVLMLlEEY+dDbCpNnFYBkW0R2+TWQ2y0Nz
 YU3HibWQ+R6bz+DrX3T6UpC2tar3guZcp0s4n+mxk4yDQ/vrmRbEcDl7cror/YgHVTI2f9blCv
 fIjtZb56b6kEuGcViH2LEPhf+SB8QbL1fScwKD1lOwjmJ+51eSYWScF++c8mdflkcYOUrH7slF
 9q0=
WDCIronportException: Internal
Received: from unknown (HELO redsun60.ssa.fujisawa.hgst.com) ([10.149.66.36])
  by uls-op-cesaip02.wdc.com with ESMTP; 10 Mar 2020 02:47:21 -0700
From:   Johannes Thumshirn <johannes.thumshirn@wdc.com>
To:     Jens Axboe <axboe@kernel.dk>
Cc:     Christoph Hellwig <hch@infradead.org>,
        linux-block <linux-block@vger.kernel.org>,
        Damien Le Moal <Damien.LeMoal@wdc.com>,
        Keith Busch <kbusch@kernel.org>,
        "linux-scsi @ vger . kernel . org" <linux-scsi@vger.kernel.org>,
        "Martin K . Petersen" <martin.petersen@oracle.com>,
        Johannes Thumshirn <johannes.thumshirn@wdc.com>
Subject: [PATCH 07/11] block: factor out requeue handling from dispatch code
Date:   Tue, 10 Mar 2020 18:46:49 +0900
Message-Id: <20200310094653.33257-8-johannes.thumshirn@wdc.com>
X-Mailer: git-send-email 2.24.1
In-Reply-To: <20200310094653.33257-1-johannes.thumshirn@wdc.com>
References: <20200310094653.33257-1-johannes.thumshirn@wdc.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

Factor out the requeue handling from the dispatch code, this will make
subsequent addition of different requeueing schemes easier.

Signed-off-by: Johannes Thumshirn <johannes.thumshirn@wdc.com>
---
 block/blk-mq.c | 29 ++++++++++++++++++-----------
 1 file changed, 18 insertions(+), 11 deletions(-)

diff --git a/block/blk-mq.c b/block/blk-mq.c
index d92088dec6c3..f7ab75ef4d0e 100644
--- a/block/blk-mq.c
+++ b/block/blk-mq.c
@@ -1178,6 +1178,23 @@ static void blk_mq_update_dispatch_busy(struct blk_mq_hw_ctx *hctx, bool busy)
 
 #define BLK_MQ_RESOURCE_DELAY	3		/* ms units */
 
+static void blk_mq_handle_dev_resource(struct request *rq,
+				       struct list_head *list)
+{
+	struct request *next =
+		list_first_entry_or_null(list, struct request, queuelist);
+
+	/*
+	 * If an I/O scheduler has been configured and we got a driver tag for
+	 * the next request already, free it.
+	 */
+	if (next)
+		blk_mq_put_driver_tag(next);
+
+	list_add(&rq->queuelist, list);
+	__blk_mq_requeue_request(rq);
+}
+
 /*
  * Returns true if we did some work AND can potentially do more.
  */
@@ -1245,17 +1262,7 @@ bool blk_mq_dispatch_rq_list(struct request_queue *q, struct list_head *list,
 
 		ret = q->mq_ops->queue_rq(hctx, &bd);
 		if (ret == BLK_STS_RESOURCE || ret == BLK_STS_DEV_RESOURCE) {
-			/*
-			 * If an I/O scheduler has been configured and we got a
-			 * driver tag for the next request already, free it
-			 * again.
-			 */
-			if (!list_empty(list)) {
-				nxt = list_first_entry(list, struct request, queuelist);
-				blk_mq_put_driver_tag(nxt);
-			}
-			list_add(&rq->queuelist, list);
-			__blk_mq_requeue_request(rq);
+			blk_mq_handle_dev_resource(rq, list);
 			break;
 		}
 
-- 
2.24.1

