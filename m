Return-Path: <SRS0=/77Q=XA=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.6 required=3.0 tests=DKIM_INVALID,DKIM_SIGNED,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 736E9C3A5A5
	for <linux-scsi@archiver.kernel.org>; Thu,  5 Sep 2019 09:51:58 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 409F721743
	for <linux-scsi@archiver.kernel.org>; Thu,  5 Sep 2019 09:51:58 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="signature verification failed" (2048-bit key) header.d=wdc.com header.i=@wdc.com header.b="QVGCwdO8"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2387620AbfIEJv4 (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Thu, 5 Sep 2019 05:51:56 -0400
Received: from esa6.hgst.iphmx.com ([216.71.154.45]:25326 "EHLO
        esa6.hgst.iphmx.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1730769AbfIEJvw (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Thu, 5 Sep 2019 05:51:52 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=wdc.com; i=@wdc.com; q=dns/txt; s=dkim.wdc.com;
  t=1567677113; x=1599213113;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=q/G6ummKELIlmalkh9GPUWsUwphqsgUz0VruqeowzEs=;
  b=QVGCwdO82v6WXGi2Q5lIWrnkIsRlUG5/nBZ7Lj9cUts4tM67nBrAc9EJ
   3/faBocA4zSzM251rEg9h9LypqYAdL+al5eu1JE02dF/JgYVwsmA02gTL
   i8nOBYvcIs2kQNe2FSzMKy9HDxkB2demguGsM0c4PZIuf0Tz6ty8gfkty
   tbA5AYR5yc0wSKjHu9O/tQTeXEQUJWVL83LbVHisycB7P6lPSTL3Y8jAN
   21lvMOn6qay37IgmKPVU/9sj1yMgxj3ZqeP7OkqNX6ouX5wlawpbPV9QP
   0IpMUCt3kR6di4PBMKi4ziF4gvB/YUqI2F9JkbyXlzDPtGU0lv+r3rrP7
   g==;
IronPort-SDR: EUKwRgaAgN2AFdZ14klUwvkMnx6BDI3NlyOkvnYg2TACQB6vHDrhmuWUfCZM0vYhtGqX1+YK3s
 Wo5Yk3vANy1lNCUjyDfajzAe71yoDUm2YE+z2LwnLpF7MRlOF6xW/pKM2o2DmvqZXbNhdxhz1e
 Pd4LUwMoOyFI8yoQNRG8bLopOsemdff39j6YL/4XnDC3oE9Q4WjIBcVIfOHjHKh2aK9Z6kYa/m
 +EAc5IPQp4DKngcN1WSsJuqPQWDuTghZwtcA4KMWIcDU/Jnhz/kj4CEgHWQcNj86YnawWE0zyM
 10U=
X-IronPort-AV: E=Sophos;i="5.64,470,1559491200"; 
   d="scan'208";a="119106265"
Received: from uls-op-cesaip02.wdc.com (HELO uls-op-cesaep02.wdc.com) ([199.255.45.15])
  by ob1.hgst.iphmx.com with ESMTP; 05 Sep 2019 17:51:43 +0800
IronPort-SDR: 93u8f2l+jwlw36uwinAPZbgj7WSwOuTtKTkvIiNA6ZJwGMLJiaHcew4dEliozZKD1z8tu8eb2o
 UiGdyW7PcdWE6x1RPsBY3MzMEADRfxx+AjYwDctzBA8MbI8JYhYDGz2DnOjiNi9lWsurXTPw/c
 OZcQ3dnQdPW3OUpEDNHLNZNs6UTFRagnymsPP3UQL/SlcDyVy7URfNL52ClTM5ls7kFcrcnXjI
 Uu9giyiyRkZMU/eaArjgfo41//ziew/dOBlwsrfLa5j9MwCDTS+B6KAmNuriT5SQsE9QwF/mPy
 733tmE2PY1cv+zzMuGpdyLcZ
Received: from uls-op-cesaip01.wdc.com ([10.248.3.36])
  by uls-op-cesaep02.wdc.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 05 Sep 2019 02:48:38 -0700
IronPort-SDR: K1Ex14M6z8Ubl9VJIjS/Kv0LAFi/XUeURed2Nlsc0HXRxx6xbqs0ezsNxLfm51qmj288kf7U/T
 e1fpJUE3BpYNEHrHiM0ykEUIRJ8W4FlcPT0pgMszxKLoxNDnNa5MKO/X+RULqk0NmBwp1dMqSE
 EfMKRX5u8UsG6ZzyAxs5xSsNYRyUlmtMMtsVdK3vkAb2707oRzJT4snUEglwHgpX/n+uG3rAhY
 2rnhvhhrILPr+qPNpN5U2VwjTVXv6jPR9cMzmR0HChFqJR28vwz+btMmGlftTmkbtU3+6L+90U
 OVs=
WDCIronportException: Internal
Received: from washi.fujisawa.hgst.com ([10.149.53.254])
  by uls-op-cesaip01.wdc.com with ESMTP; 05 Sep 2019 02:51:42 -0700
From:   Damien Le Moal <damien.lemoal@wdc.com>
To:     linux-block@vger.kernel.org, Jens Axboe <axboe@kernel.dk>,
        linux-scsi@vger.kernel.org,
        "Martin K . Petersen" <martin.petersen@oracle.com>,
        dm-devel@redhat.com, Mike Snitzer <snitzer@redhat.com>
Cc:     Ming Lei <ming.lei@redhat.com>
Subject: [PATCH v5 4/7] block: Improve default elevator selection
Date:   Thu,  5 Sep 2019 18:51:32 +0900
Message-Id: <20190905095135.26026-5-damien.lemoal@wdc.com>
X-Mailer: git-send-email 2.21.0
In-Reply-To: <20190905095135.26026-1-damien.lemoal@wdc.com>
References: <20190905095135.26026-1-damien.lemoal@wdc.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

For block devices that do not specify required features, preserve the
current default elevator selection (mq-deadline for single queue
devices, none for multi-queue devices). However, for devices specifying
required features (e.g. zoned block devices ELEVATOR_F_ZBD_SEQ_WRITE
feature), select the first available elevator providing the required
features.

In all cases, default to "none" if no elevator is available or if the
initialization of the default elevator fails.

Signed-off-by: Damien Le Moal <damien.lemoal@wdc.com>
Reviewed-by: Johannes Thumshirn <jthumshirn@suse.de>
---
 block/elevator.c | 51 +++++++++++++++++++++++++++++++++++++++++-------
 1 file changed, 44 insertions(+), 7 deletions(-)

diff --git a/block/elevator.c b/block/elevator.c
index ac7c8ad580ba..520d6b224b74 100644
--- a/block/elevator.c
+++ b/block/elevator.c
@@ -651,9 +651,46 @@ static inline bool elv_support_iosched(struct request_queue *q)
 }
 
 /*
- * For blk-mq devices supporting IO scheduling, we default to using mq-deadline,
- * if available, for single queue devices. If deadline isn't available OR
- * deadline initialization fails OR we have multiple queues, default to "none".
+ * For single queue devices, default to using mq-deadline. If we have multiple
+ * queues or mq-deadline is not available, default to "none".
+ */
+static struct elevator_type *elevator_get_default(struct request_queue *q)
+{
+	if (q->nr_hw_queues != 1)
+		return NULL;
+
+	return elevator_get(q, "mq-deadline", false);
+}
+
+/*
+ * Get the first elevator providing the features required by the request queue.
+ * Default to "none" if no matching elevator is found.
+ */
+static struct elevator_type *elevator_get_by_features(struct request_queue *q)
+{
+	struct elevator_type *e;
+
+	spin_lock(&elv_list_lock);
+
+	list_for_each_entry(e, &elv_list, list) {
+		if (elv_support_features(e->elevator_features,
+					 q->required_elevator_features))
+			break;
+	}
+
+	if (e && !try_module_get(e->elevator_owner))
+		e = NULL;
+
+	spin_unlock(&elv_list_lock);
+
+	return e;
+}
+
+/*
+ * For a device queue that has no required features, use the default elevator
+ * settings. Otherwise, use the first elevator available matching the required
+ * features. If no suitable elevator is find or if the chosen elevator
+ * initialization fails, fall back to the "none" elevator (no elevator).
  */
 void elevator_init_mq(struct request_queue *q)
 {
@@ -663,15 +700,15 @@ void elevator_init_mq(struct request_queue *q)
 	if (!elv_support_iosched(q))
 		return;
 
-	if (q->nr_hw_queues != 1)
-		return;
-
 	WARN_ON_ONCE(test_bit(QUEUE_FLAG_REGISTERED, &q->queue_flags));
 
 	if (unlikely(q->elevator))
 		return;
 
-	e = elevator_get(q, "mq-deadline", false);
+	if (!q->required_elevator_features)
+		e = elevator_get_default(q);
+	else
+		e = elevator_get_by_features(q);
 	if (!e)
 		return;
 
-- 
2.21.0

