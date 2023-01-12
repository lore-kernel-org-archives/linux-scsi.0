Return-Path: <linux-scsi-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 91415C678D7
	for <linux-scsi@archiver.kernel.org>; Thu, 12 Jan 2023 14:08:47 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233993AbjALOIp (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Thu, 12 Jan 2023 09:08:45 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58106 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235089AbjALOHl (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Thu, 12 Jan 2023 09:07:41 -0500
Received: from esa1.hgst.iphmx.com (esa1.hgst.iphmx.com [68.232.141.245])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D5BDA559E9;
        Thu, 12 Jan 2023 06:04:42 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=wdc.com; i=@wdc.com; q=dns/txt; s=dkim.wdc.com;
  t=1673532282; x=1705068282;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=TvFJrrRGb6/CjlxRBQb19gVXCyf7apsABVJeIRcea14=;
  b=QCL4K3+IEk8d9T6apG+sNBd0ZRS3lSFWETfjCemzCh4fR1cLaDUxXmv7
   Dcaz54U4Vtd7jAWZR0xIgQsKifIt2CULW6UY7FaDCBC65SGzn7BJth6/g
   HDUr4CtITBLHIevpKtmsoleYvT6g3sYdUDLiaVrx8+rxIj4vV7fItHqXk
   5NHst50ymeyAorHXdXulpkn0/K/uvOGczJoFYMnGawR8ZXxj6bmyJQTfq
   Wn5kGAY+1jwH+G4ivUfg+22HnbbBCCIuqYqOSiPYTGoYhWP2AKinB7RIh
   Lymfg8oAezBounlG/31ZdQ0dqIJi4UT3aHwqjeyMIjP4APS204L0IOnbp
   g==;
X-IronPort-AV: E=Sophos;i="5.97,211,1669046400"; 
   d="scan'208";a="332632695"
Received: from uls-op-cesaip02.wdc.com (HELO uls-op-cesaep02.wdc.com) ([199.255.45.15])
  by ob1.hgst.iphmx.com with ESMTP; 12 Jan 2023 22:04:39 +0800
IronPort-SDR: IlvPRu+er7jnBBaD2b32m3880nC2mV8lryCCbn8P9P9/Rx3bpYU76Z/6uqGuRmob/pHYRG/DUY
 XeJdPkzhzFGV2rjHxqW79Hzi9Uf30VLHD+Q/wxG5xq9PX9mUFK+OXN4ucQapLlyjbhV+vOGpDv
 v6u3g/AZKBxIHdZBxh22eL1X+U2Q8zd3BPiXVYjm7MowySXZ2MUWYtaMkkiFLgtwz8mlIZ7HTo
 dv4C6yN7ajUs/wilVwyLQJdgL+1C/s5uKJBp63ytlBiuXBImFFKdpTtxzeQWUHD+axYY1tFTei
 p0A=
Received: from uls-op-cesaip01.wdc.com ([10.248.3.36])
  by uls-op-cesaep02.wdc.com with ESMTP/TLS/ECDHE-RSA-AES128-GCM-SHA256; 12 Jan 2023 05:16:42 -0800
IronPort-SDR: 2mvmYa0yJHI6Njz/eHZob4gcI7ntL+n5eqtA8TlWFCJRzaTgM6VlxTNT7MJ1A/eKbK5YBGtVg6
 RrM1QS5sL6N1dhKkQDeDHHKCEjFsjKTAuYMTpt0gqK0P9ZyYtqYbc14T0ixx2vka09z5D4dy+N
 ApUX+WrTb9JBZsQ8z4vO5QVqXX0AEQkhMYdamsZmMvcNdNCjBDQ6WyPNbiI68nraY6ZUij/3k2
 ayn6pA7sdMqiPNS6KA/v8F4c6glVjDsENkn5XnZp5IkuUXV4YGBo99XgiQquOJo86vHZ/wRh2n
 ErE=
WDCIronportException: Internal
Received: from unknown (HELO x1-carbon.wdc.com) ([10.225.164.12])
  by uls-op-cesaip01.wdc.com with ESMTP; 12 Jan 2023 06:04:38 -0800
From:   Niklas Cassel <niklas.cassel@wdc.com>
To:     Paolo Valente <paolo.valente@linaro.org>,
        Jens Axboe <axboe@kernel.dk>
Cc:     Hannes Reinecke <hare@suse.de>,
        Damien Le Moal <damien.lemoal@opensource.wdc.com>,
        linux-scsi@vger.kernel.org, linux-ide@vger.kernel.org,
        linux-block@vger.kernel.org, Niklas Cassel <niklas.cassel@wdc.com>
Subject: [PATCH v2 07/18] block: introduce duration-limits priority class
Date:   Thu, 12 Jan 2023 15:03:56 +0100
Message-Id: <20230112140412.667308-8-niklas.cassel@wdc.com>
X-Mailer: git-send-email 2.39.0
In-Reply-To: <20230112140412.667308-1-niklas.cassel@wdc.com>
References: <20230112140412.667308-1-niklas.cassel@wdc.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

From: Damien Le Moal <damien.lemoal@opensource.wdc.com>

Introduce the IOPRIO_CLASS_DL priority class to indicate that IOs should
be executed using duration-limits targets. The duration target to apply
to a command is indicated using the priority level. Up to 8 levels are
supported, with level 0 indiating "no limit".

This priority class has effect only if the target device supports the
command duration limits feature and this feature is enabled by the user.
In BFQ and mq-deadline, all requests with this new priority class are
handled using the highest priority class RT and priority level 0.

Signed-off-by: Damien Le Moal <damien.lemoal@opensource.wdc.com>
Signed-off-by: Niklas Cassel <niklas.cassel@wdc.com>
---
 block/bfq-iosched.c         | 10 ++++++++++
 block/blk-ioprio.c          |  3 +++
 block/ioprio.c              |  3 ++-
 block/mq-deadline.c         |  1 +
 include/linux/ioprio.h      |  2 +-
 include/uapi/linux/ioprio.h |  7 +++++++
 6 files changed, 24 insertions(+), 2 deletions(-)

diff --git a/block/bfq-iosched.c b/block/bfq-iosched.c
index 815b884d6c5a..7add9346c585 100644
--- a/block/bfq-iosched.c
+++ b/block/bfq-iosched.c
@@ -5545,6 +5545,14 @@ bfq_set_next_ioprio_data(struct bfq_queue *bfqq, struct bfq_io_cq *bic)
 		bfqq->new_ioprio_class = IOPRIO_CLASS_IDLE;
 		bfqq->new_ioprio = 7;
 		break;
+	case IOPRIO_CLASS_DL:
+		/*
+		 * For the duration-limits class, we want the disk to do the
+		 * scheduling. So map all levels to the highest RT level.
+		 */
+		bfqq->new_ioprio = 0;
+		bfqq->new_ioprio_class = IOPRIO_CLASS_RT;
+		break;
 	}
 
 	if (bfqq->new_ioprio >= IOPRIO_NR_LEVELS) {
@@ -5673,6 +5681,8 @@ static struct bfq_queue **bfq_async_queue_prio(struct bfq_data *bfqd,
 		return &bfqg->async_bfqq[1][ioprio][act_idx];
 	case IOPRIO_CLASS_IDLE:
 		return &bfqg->async_idle_bfqq[act_idx];
+	case IOPRIO_CLASS_DL:
+		return &bfqg->async_bfqq[0][0][act_idx];
 	default:
 		return NULL;
 	}
diff --git a/block/blk-ioprio.c b/block/blk-ioprio.c
index 8bb6b8eba4ce..dfb5c3f447f4 100644
--- a/block/blk-ioprio.c
+++ b/block/blk-ioprio.c
@@ -27,6 +27,7 @@
  * @POLICY_RESTRICT_TO_BE: modify IOPRIO_CLASS_NONE and IOPRIO_CLASS_RT into
  *		IOPRIO_CLASS_BE.
  * @POLICY_ALL_TO_IDLE: change the I/O priority class into IOPRIO_CLASS_IDLE.
+ * @POLICY_ALL_TO_DL: change the I/O priority class into IOPRIO_CLASS_DL.
  *
  * See also <linux/ioprio.h>.
  */
@@ -35,6 +36,7 @@ enum prio_policy {
 	POLICY_NONE_TO_RT	= 1,
 	POLICY_RESTRICT_TO_BE	= 2,
 	POLICY_ALL_TO_IDLE	= 3,
+	POLICY_ALL_TO_DL	= 4,
 };
 
 static const char *policy_name[] = {
@@ -42,6 +44,7 @@ static const char *policy_name[] = {
 	[POLICY_NONE_TO_RT]	= "none-to-rt",
 	[POLICY_RESTRICT_TO_BE]	= "restrict-to-be",
 	[POLICY_ALL_TO_IDLE]	= "idle",
+	[POLICY_ALL_TO_DL]	= "duration-limits",
 };
 
 static struct blkcg_policy ioprio_policy;
diff --git a/block/ioprio.c b/block/ioprio.c
index 32a456b45804..1b3a9da82597 100644
--- a/block/ioprio.c
+++ b/block/ioprio.c
@@ -37,6 +37,7 @@ int ioprio_check_cap(int ioprio)
 
 	switch (class) {
 		case IOPRIO_CLASS_RT:
+		case IOPRIO_CLASS_DL:
 			/*
 			 * Originally this only checked for CAP_SYS_ADMIN,
 			 * which was implicitly allowed for pid 0 by security
@@ -47,7 +48,7 @@ int ioprio_check_cap(int ioprio)
 			if (!capable(CAP_SYS_ADMIN) && !capable(CAP_SYS_NICE))
 				return -EPERM;
 			fallthrough;
-			/* rt has prio field too */
+			/* RT and DL have prio field too */
 		case IOPRIO_CLASS_BE:
 			if (data >= IOPRIO_NR_LEVELS || data < 0)
 				return -EINVAL;
diff --git a/block/mq-deadline.c b/block/mq-deadline.c
index f10c2a0d18d4..526d0ea4dbf9 100644
--- a/block/mq-deadline.c
+++ b/block/mq-deadline.c
@@ -113,6 +113,7 @@ static const enum dd_prio ioprio_class_to_prio[] = {
 	[IOPRIO_CLASS_RT]	= DD_RT_PRIO,
 	[IOPRIO_CLASS_BE]	= DD_BE_PRIO,
 	[IOPRIO_CLASS_IDLE]	= DD_IDLE_PRIO,
+	[IOPRIO_CLASS_DL]	= DD_RT_PRIO,
 };
 
 static inline struct rb_root *
diff --git a/include/linux/ioprio.h b/include/linux/ioprio.h
index 7578d4f6a969..2f3fc2fbd668 100644
--- a/include/linux/ioprio.h
+++ b/include/linux/ioprio.h
@@ -20,7 +20,7 @@ static inline bool ioprio_valid(unsigned short ioprio)
 {
 	unsigned short class = IOPRIO_PRIO_CLASS(ioprio);
 
-	return class > IOPRIO_CLASS_NONE && class <= IOPRIO_CLASS_IDLE;
+	return class > IOPRIO_CLASS_NONE && class <= IOPRIO_CLASS_DL;
 }
 
 /*
diff --git a/include/uapi/linux/ioprio.h b/include/uapi/linux/ioprio.h
index f70f2596a6bf..15908b9e9d8c 100644
--- a/include/uapi/linux/ioprio.h
+++ b/include/uapi/linux/ioprio.h
@@ -29,6 +29,7 @@ enum {
 	IOPRIO_CLASS_RT,
 	IOPRIO_CLASS_BE,
 	IOPRIO_CLASS_IDLE,
+	IOPRIO_CLASS_DL,
 };
 
 /*
@@ -37,6 +38,12 @@ enum {
 #define IOPRIO_NR_LEVELS	8
 #define IOPRIO_BE_NR		IOPRIO_NR_LEVELS
 
+/*
+ * The Duration limits class allows 8 levels: level 0 for "no limit" and levels
+ * 1 to 7, each corresponding to a read or write limit descriptor.
+ */
+#define IOPRIO_DL_NR_LEVELS	8
+
 enum {
 	IOPRIO_WHO_PROCESS = 1,
 	IOPRIO_WHO_PGRP,
-- 
2.39.0

