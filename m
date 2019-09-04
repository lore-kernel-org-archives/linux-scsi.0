Return-Path: <SRS0=LwoI=W7=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.5 required=3.0 tests=DKIM_INVALID,DKIM_SIGNED,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 79104C3A5AB
	for <linux-scsi@archiver.kernel.org>; Wed,  4 Sep 2019 08:43:02 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 47ADD233A1
	for <linux-scsi@archiver.kernel.org>; Wed,  4 Sep 2019 08:43:02 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="signature verification failed" (2048-bit key) header.d=wdc.com header.i=@wdc.com header.b="oAVWZHp5"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729204AbfIDInC (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Wed, 4 Sep 2019 04:43:02 -0400
Received: from esa4.hgst.iphmx.com ([216.71.154.42]:39238 "EHLO
        esa4.hgst.iphmx.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727929AbfIDInB (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Wed, 4 Sep 2019 04:43:01 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=wdc.com; i=@wdc.com; q=dns/txt; s=dkim.wdc.com;
  t=1567586580; x=1599122580;
  h=from:to:subject:date:message-id:in-reply-to:references:
   mime-version:content-transfer-encoding;
  bh=fyqaXKmTgfoQv/FSTOhGEWhXUip2jSRO9hudTs5/bE4=;
  b=oAVWZHp5qb5u1wJ3lV35Szu5hbwW+mWy+/HEBRdfWReqyWb9p7PZxWZp
   u4mhPs9BsIG3uHsL/PLdoYfA6tLrlI236vLDFe3ct8y1DJKbm4mvffUMC
   /ep/5/3bNMWlR4oB3j4IGm3GvgHh8Vh7aYrxetVpGhl+N7V+NJPEFpodo
   +d/sAoLAwB/60VyXqsCB/vhsgb3csN03yIKnDT7DyCzAu0uxmdjnfEFWJ
   V+nzKT9HMlKkNywzReNR0CqKcNGHFq/5dDRtPHnh1GU3Y9TTH6TmmlNXx
   Hu4yVSNgp1lqZ/iPtHs8TmVY7b/8BR0HwAo7JtO51ECGiyicRb1O8yRx7
   g==;
IronPort-SDR: 20UvYgXyLGk1nK6pjQDWs5S3dlYpPHy4jYPdHVXpxOW8uk4aPVa+6Kf0AxHKBhgsin767UjVck
 iJ38LWj8wzlyJYwKPbmqvoC+mPG97L0wsmTsiEW95RaVlzbKmUtWTo26AKAk2S6x7prJmiPzwI
 4MPuKU0GFidQzawynjIa2vrDnZBfafk7bkU5fZnxWOmqsUW0u2fzC7/ENoOwjoWEPn56h1RGLx
 Q25cegd/tVVAAOiMqPNKA2utm3+a/Q1U5xX3E5L/ItjcNvUURQwnePzZEr4EWF3GUW34c38pgz
 4PY=
X-IronPort-AV: E=Sophos;i="5.64,465,1559491200"; 
   d="scan'208";a="117374683"
Received: from h199-255-45-15.hgst.com (HELO uls-op-cesaep02.wdc.com) ([199.255.45.15])
  by ob1.hgst.iphmx.com with ESMTP; 04 Sep 2019 16:42:53 +0800
IronPort-SDR: ioznrVdYbmeOyISeMzoZu5lfjgpRo+VjMd4yP7XxhmaMy/Xz4qBfVvZEHGIMedmv0M56UBIiNd
 5CV3w6yRTJxkpucOIO5VNZeViOitslXpV4Oceorc98wnyiBs7lX/08fpmUj6TzZNCk3pKoXuQ4
 4MlOvonWfwuCkulpJNBpgmON6gYv0rNUlyZzXbWFt4UBATvNWMyhSYvcECdyPrlvZxVG2kNyqC
 v1KdcGMujv4U+140x9Z6bvPGrSRcPwEJmGvetMwgO52HIKYOm5vjLAzTAqDUqdYu4hpwWu+IHV
 12axxkdQEIsOsKnmVGEd6kYY
Received: from uls-op-cesaip02.wdc.com ([10.248.3.37])
  by uls-op-cesaep02.wdc.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 04 Sep 2019 01:39:51 -0700
IronPort-SDR: gybW6RVAYE3RomyMxGkOijCkXQC/kkxJdeF3wj/6TVK8qy/zBKU5foJIOCjfyNbH9H7ojYLQY1
 5w62kqAAtizTNOXtR1enHTbznoU5gUkjALcf1NUi5n77sZ4ZW6onpy6b9rA4NBEOn2rmxwM2/f
 G6jaMN1X9TYBDDSRNWvw0nRYn1xZ5jNhXXmwz2M/2S9OWhO6QY7EpLjrMXhDsc0TVaklSEWwRT
 Ebo1/GG6MrXvftN4pCM2/OfT2vd/e038pNQpF43EaGNoFsyvV56+zGuc6aX0zgWpXkWcud2upR
 zRI=
WDCIronportException: Internal
Received: from washi.fujisawa.hgst.com ([10.149.53.254])
  by uls-op-cesaip02.wdc.com with ESMTP; 04 Sep 2019 01:42:51 -0700
From:   Damien Le Moal <damien.lemoal@wdc.com>
To:     linux-block@vger.kernel.org, Jens Axboe <axboe@kernel.dk>,
        linux-scsi@vger.kernel.org,
        "Martin K . Petersen" <martin.petersen@oracle.com>
Subject: [PATCH v3 4/7] block: Improve default elevator selection
Date:   Wed,  4 Sep 2019 17:42:44 +0900
Message-Id: <20190904084247.23338-5-damien.lemoal@wdc.com>
X-Mailer: git-send-email 2.21.0
In-Reply-To: <20190904084247.23338-1-damien.lemoal@wdc.com>
References: <20190904084247.23338-1-damien.lemoal@wdc.com>
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

