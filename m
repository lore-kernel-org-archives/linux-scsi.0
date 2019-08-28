Return-Path: <SRS0=d3SH=WY=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.5 required=3.0 tests=DKIM_INVALID,DKIM_SIGNED,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT autolearn=unavailable
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 45CE2C3A5A8
	for <linux-scsi@archiver.kernel.org>; Wed, 28 Aug 2019 02:29:56 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 1DCB0214DA
	for <linux-scsi@archiver.kernel.org>; Wed, 28 Aug 2019 02:29:56 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="signature verification failed" (2048-bit key) header.d=wdc.com header.i=@wdc.com header.b="rSTcij9Z"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726342AbfH1C3z (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Tue, 27 Aug 2019 22:29:55 -0400
Received: from esa1.hgst.iphmx.com ([68.232.141.245]:27205 "EHLO
        esa1.hgst.iphmx.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726264AbfH1C3x (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Tue, 27 Aug 2019 22:29:53 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=wdc.com; i=@wdc.com; q=dns/txt; s=dkim.wdc.com;
  t=1566959393; x=1598495393;
  h=from:to:subject:date:message-id:in-reply-to:references:
   mime-version:content-transfer-encoding;
  bh=14KBgK6sEfrhkErHEFF5RolwRhVpkLH6Q2DFKYot8N0=;
  b=rSTcij9Z1nfpE7ETDQ75HYecjpjK0GV61IvBJMc8+5lDAuuWiixF0Xq+
   DoxhZF+e6sTmDBa/osq6zpzWji5JwGVHCVBpdfu8b8WsvI6eL0O46FihM
   OrOzrsfcDWWY4ZZ/tjCBqsGO1crVHlOm9VPkfu991wHGXgiTH7ZEp8beG
   DZRVoDtNp34Tc07oszc8TufchACwpWZ6bHH20kNSiGn1LOoDBRlucvKj2
   GcgOWrdIF+aRsc+i7BTsvMA5B9asM++/NAD5j7YvraQxPb3Y5KEpEKb3A
   7Y0JN4OM/ZDrhQws8iTN2DNasFelMzpKQToSh0PBrO6UF8tM51XsPYMhC
   Q==;
IronPort-SDR: kxtEMteMl4LwAyN7uUM1Dg28uA4185XMp33TIMfhsuMlo/CVcwvmK9Hwkq3AwWebO7mhq+h+dk
 AcHRL3xBbf329yawCrFJNamUErdfA3aT3s7/Sk+XdoyfsjCLJyDeidrj08XcL0e8NAsezyR4r/
 CxjkcIW2vjssKgtUl4uE1CgM2RO0nssa521/bFGKArBgxVdJkZuKaK9y79V/EylBuxSjoV1FL0
 jqO9tU+lCJ4Yt3IC4lXhMu8jyYWW12BN/F3nSM0CpAtJDpTuI0GaRT/H6ilo7le74IGHansKPX
 0LM=
X-IronPort-AV: E=Sophos;i="5.64,439,1559491200"; 
   d="scan'208";a="223475486"
Received: from h199-255-45-14.hgst.com (HELO uls-op-cesaep01.wdc.com) ([199.255.45.14])
  by ob1.hgst.iphmx.com with ESMTP; 28 Aug 2019 10:29:52 +0800
IronPort-SDR: 9avGSX5f1w6hSuxnbMZ/Ycd3+xSGK+GBLDI4fp4kNvo3tU5FkLw65kKcri2R72KV+N4mnJSV+F
 98Y0yKUuBvZb5NszrGWauwHuOZWYLYyjsLCeXnRnO0wnUePRQW0/HcM2oyFfHqZovfa3ZHE+Hf
 pJvmZ/AIld0syUr5mLP+APjChhbAjYqwQjgbDkmBd0UIKgswAhy4Z8MYyEi896ttjwD1FmnRM1
 IooeY0cmTa4F+30afKcJMSIhYoKOfxKVyAVm6fHbFF2sj7QdbchhLQuTPbcG+SQq1P8DsTTZb1
 gdv8rubn1udKQWAFCKf2XZOZ
Received: from uls-op-cesaip01.wdc.com ([10.248.3.36])
  by uls-op-cesaep01.wdc.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 27 Aug 2019 19:27:03 -0700
IronPort-SDR: eXtu997fIjzfm6NB84BvXLExuk9fZhrI5lvNPFFcnEQ4nHr+68uk4akqGYZB/fO3C23RXdNvm3
 qQrrc5F4PTfwIA1BOyVF3cyNj1OLCCSM4ED4H4dz/w9iSwkKm8+8ovuj0acMvtlcJkER4RztXK
 S36flbc079puM0CCNR3QEFcfiDW98akbcTrvNkyvmU75aU7Z6hSUpk+CC75fp7+z2Q6XbfPcpG
 eI+jcgdOsgp/es8SM2d2CuIbGrCJbQavS3q7zKgH3mJza/p+PgqOInwR0x0jPHmX8Xnu6ifbNe
 pd4=
WDCIronportException: Internal
Received: from washi.fujisawa.hgst.com ([10.149.53.254])
  by uls-op-cesaip01.wdc.com with ESMTP; 27 Aug 2019 19:29:52 -0700
From:   Damien Le Moal <damien.lemoal@wdc.com>
To:     linux-block@vger.kernel.org, Jens Axboe <axboe@kernel.dk>,
        linux-scsi@vger.kernel.org,
        "Martin K . Petersen" <martin.petersen@oracle.com>
Subject: [PATCH v2 4/7] block: Improve default elevator selection
Date:   Wed, 28 Aug 2019 11:29:44 +0900
Message-Id: <20190828022947.23364-5-damien.lemoal@wdc.com>
X-Mailer: git-send-email 2.21.0
In-Reply-To: <20190828022947.23364-1-damien.lemoal@wdc.com>
References: <20190828022947.23364-1-damien.lemoal@wdc.com>
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
 block/elevator.c | 48 ++++++++++++++++++++++++++++++++++++++++++++----
 1 file changed, 44 insertions(+), 4 deletions(-)

diff --git a/block/elevator.c b/block/elevator.c
index 2235dfe6755b..81d0877dbc34 100644
--- a/block/elevator.c
+++ b/block/elevator.c
@@ -665,9 +665,46 @@ static inline bool elv_support_iosched(struct request_queue *q)
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
@@ -685,7 +722,10 @@ void elevator_init_mq(struct request_queue *q)
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

