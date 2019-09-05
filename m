Return-Path: <SRS0=/77Q=XA=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.6 required=3.0 tests=DKIM_INVALID,DKIM_SIGNED,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id CBB9CC3A5AA
	for <linux-scsi@archiver.kernel.org>; Thu,  5 Sep 2019 04:29:09 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 9E1562082E
	for <linux-scsi@archiver.kernel.org>; Thu,  5 Sep 2019 04:29:09 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="signature verification failed" (2048-bit key) header.d=wdc.com header.i=@wdc.com header.b="Tzdm29At"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731153AbfIEE3J (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Thu, 5 Sep 2019 00:29:09 -0400
Received: from esa1.hgst.iphmx.com ([68.232.141.245]:62208 "EHLO
        esa1.hgst.iphmx.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1731140AbfIEE3I (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Thu, 5 Sep 2019 00:29:08 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=wdc.com; i=@wdc.com; q=dns/txt; s=dkim.wdc.com;
  t=1567657747; x=1599193747;
  h=from:to:subject:date:message-id:in-reply-to:references:
   mime-version:content-transfer-encoding;
  bh=fyqaXKmTgfoQv/FSTOhGEWhXUip2jSRO9hudTs5/bE4=;
  b=Tzdm29AtlUJvmXnfoMbZFSWlEAdQQCGvuw1CJHLNLJW/5tvaPz+/Cn1W
   mMb/3Rativ9kLkbf351ySYOLZYD/2AR2wO0jc7WdTCxFMY1EATQrutTNX
   OTYXO5ygZATqoa8UlciwtGrPIv0cy/oapex0X44zVwJ37zFRqd4YYrAhu
   9MtlQ8zRMlxYHbquqpoxhaenKv3NopSAcEpO8DWuueRhUCVWov/l/1r8y
   d9c7XBVqY3fnAIqF4vfQRfbPRANy633uGfpOqv2pafrtAJpNQQPuWYn0R
   O2BQ9TDbRGstXamDx99g+rilZ+WAqKByuMZK85w3X4t/6swYusAwEBQAY
   g==;
IronPort-SDR: NcGkjKrdf3z4V9yChlstFH2KG1sr8HyXKRR3ki83fmkg/vAPK3JhURKg/OPV7wBhNZGEhwMomd
 T87+TwD2dZnEYQ002G455ImtBJ2goqfHW0cszA3kT2NiV08SzJyumtJwfq5/3mYQQ7yVuffc12
 aWQr3MeFJ1gewSqkJWpVQvjUQnjW+c1Zz7mmuKuHo6GL6J4JE9Rsist+AcN28/y9nQd6Rerv4w
 6xjRyHaq5ttMU390VsU75Z9Ve1OcphRm5YhQcvBqb1qxkws5X1t684vZ4IwRsFj+jVu8+fyJcc
 Q+s=
X-IronPort-AV: E=Sophos;i="5.64,469,1559491200"; 
   d="scan'208";a="224233081"
Received: from uls-op-cesaip02.wdc.com (HELO uls-op-cesaep02.wdc.com) ([199.255.45.15])
  by ob1.hgst.iphmx.com with ESMTP; 05 Sep 2019 12:29:06 +0800
IronPort-SDR: g7FpDfEWRDX/u3TEEiQ2nkEcfpWUisk3HkNT4cPi9vfk0JL0BYuVG4q7cLAiiyAE0B2kV/1nxB
 7Vmj71WtgpQl9DvNLJmhkTlXc1LgyMoYZhijBUjrKPZEx2rKxRRmss2+UyIgoaJkNy4RMQ2XGh
 wNB5cyqOLCZRhxo1cw91pC82+IPlHaKxoYm23dNvzO1sLEDu5IRngbhi7G/pcvbt1jJLGTwdQM
 eKkjBhep0xUjztEKiDdwa2CrfzZLDqW9cd56RHEyd3XXZbAmcADxxB/Hen9pfV9Uf97p1/O4ib
 JqbOH1C6KWjNu1jqXLcRyPxA
Received: from uls-op-cesaip01.wdc.com ([10.248.3.36])
  by uls-op-cesaep02.wdc.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 04 Sep 2019 21:26:03 -0700
IronPort-SDR: 0QxZhPPTCnKUaSwUbfDxnxhuVK5+LKhjklSYQ7k9SQ3lFHGK9sp19qFphWAPtOSvcsPQTf8Om+
 LpIPM8742/yJWVHrXTaGSu8CIiYqC0Z5uWt8wE8o3Oro9WrwfjcGxen5QAb3NHwB0Gx/MH5AX7
 +rzJ0JZWO1BXBcbG44DDT4E+29QCkcRcf2rwnyjQaTmQ8f53/rPk00vM4e2WM/rd6bAspkhmuc
 i+a6FOQNc2/jzt6oLmW0nyVLT/gs60tIVuIDmdtPSC09heYtUbLLsaGtI15FSi8T5CAp90Jg8Z
 EKc=
WDCIronportException: Internal
Received: from washi.fujisawa.hgst.com ([10.149.53.254])
  by uls-op-cesaip01.wdc.com with ESMTP; 04 Sep 2019 21:29:06 -0700
From:   Damien Le Moal <damien.lemoal@wdc.com>
To:     linux-block@vger.kernel.org, Jens Axboe <axboe@kernel.dk>,
        linux-scsi@vger.kernel.org,
        "Martin K . Petersen" <martin.petersen@oracle.com>
Subject: [PATCH v4 4/7] block: Improve default elevator selection
Date:   Thu,  5 Sep 2019 13:28:58 +0900
Message-Id: <20190905042901.5830-5-damien.lemoal@wdc.com>
X-Mailer: git-send-email 2.21.0
In-Reply-To: <20190905042901.5830-1-damien.lemoal@wdc.com>
References: <20190905042901.5830-1-damien.lemoal@wdc.com>
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

