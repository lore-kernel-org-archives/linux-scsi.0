Return-Path: <linux-scsi-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 654DCC54E94
	for <linux-scsi@archiver.kernel.org>; Tue, 24 Jan 2023 19:03:33 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234465AbjAXTDc (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Tue, 24 Jan 2023 14:03:32 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42050 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233989AbjAXTDY (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Tue, 24 Jan 2023 14:03:24 -0500
Received: from esa5.hgst.iphmx.com (esa5.hgst.iphmx.com [216.71.153.144])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 476404ABD9;
        Tue, 24 Jan 2023 11:03:20 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=wdc.com; i=@wdc.com; q=dns/txt; s=dkim.wdc.com;
  t=1674587000; x=1706123000;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=UzT5GVJNV/JFPdkmk0111+wWTNNszb/ahmQd8s5F0yY=;
  b=Y6wAjNHa5/cnBcCUsak0oo98A8EmLZHX6xAL5ejpt0C88nff+AoEnRcz
   fVW73HgiLJZXetd8PHIQENOFv/KhH6SiaVtw/MnHm3gRyK0TjELRvoHIe
   5+8WYsaHyNvmWpiD2y1abUlJgqqAvEQj0w+rI2LibqO38ym+NwHGAFRfE
   Dx3mRX0yxXmyavGk49aluR5Kdm70jknrKbjtr0P9g66vFvxN/IS+uHk0l
   Z6v7wv5PXv/03kKwq1cm6i3APDEKBZR4C2FnucTj1sJqwC2pUNF/shsXH
   P8F3cZGDZ3CrSz/x0mH4DfI7l3vxgXHm2uTJ8K6JL+V+gyj9JVA72psLt
   Q==;
X-IronPort-AV: E=Sophos;i="5.97,243,1669046400"; 
   d="scan'208";a="221472921"
Received: from h199-255-45-15.hgst.com (HELO uls-op-cesaep02.wdc.com) ([199.255.45.15])
  by ob1.hgst.iphmx.com with ESMTP; 25 Jan 2023 03:03:19 +0800
IronPort-SDR: B752Nl9NcMpbFC+veqL9xcaxfqJGlkN+eyC10CXT5KLD9ubvIWffwn/bTsv3qo9Nld6I2MAltF
 KR7j/grYDnbsk2ziQe63Ew6tGhCmk+gY+zJ0t1NpcG9hIhGC5PrmgUZUTimoX44wxvyr/Xo4dx
 JzzqjRz7dG8CItneM1QcYbBQ9DQxNlyjred/b6zo3luD19WayqngL4ut+8lmbM1GLUcD9n22jf
 v6RC10FlVmD4hYTWfdytaxweT2j3OFTegdhACCEX6yTkmDU+l3w4aZM4QZy8UZG6X5T1iAz/6b
 5/I=
Received: from uls-op-cesaip02.wdc.com ([10.248.3.37])
  by uls-op-cesaep02.wdc.com with ESMTP/TLS/ECDHE-RSA-AES128-GCM-SHA256; 24 Jan 2023 10:15:08 -0800
IronPort-SDR: qSTBWHUaiYtsGCSECsfB4ZOnKpmpHJ67q9P9Jb0AqpR/smS8JB/+pD9rqPALjTzs4IKwMOvciZ
 W8mQMN8ASMMuTTSuLXwBfPId4ldsawqUJPFYH3duhP5AGSw1noqzxAY8/3hsMLPjAisA99iEaN
 ijL5FBtQBT2A0P4IJBQtkXz2xfY5mb39KR4Ve13Q3G6lFUXjgYlbWxSiLaRaq6u/dS2D3ATSOf
 RqOPG7BaTLCYCnZYlVeo2wd6m/lPqghvQ9dDRDcQ4bHonhNK/MP37Si8TWigBDLBtZSM1aFKWw
 cWI=
WDCIronportException: Internal
Received: from unknown (HELO x1-carbon.lan) ([10.225.164.48])
  by uls-op-cesaip02.wdc.com with ESMTP; 24 Jan 2023 11:03:17 -0800
From:   Niklas Cassel <niklas.cassel@wdc.com>
To:     Paolo Valente <paolo.valente@linaro.org>,
        Jens Axboe <axboe@kernel.dk>
Cc:     Christoph Hellwig <hch@lst.de>, Hannes Reinecke <hare@suse.de>,
        Damien Le Moal <damien.lemoal@opensource.wdc.com>,
        linux-scsi@vger.kernel.org, linux-ide@vger.kernel.org,
        linux-block@vger.kernel.org, Niklas Cassel <niklas.cassel@wdc.com>
Subject: [PATCH v3 01/18] block: introduce duration-limits priority class
Date:   Tue, 24 Jan 2023 20:02:47 +0100
Message-Id: <20230124190308.127318-2-niklas.cassel@wdc.com>
X-Mailer: git-send-email 2.39.1
In-Reply-To: <20230124190308.127318-1-niklas.cassel@wdc.com>
References: <20230124190308.127318-1-niklas.cassel@wdc.com>
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

While it is recommended to not use an ioscheduler when using the
IOPRIO_CLASS_DL priority class, if using the BFQ or mq-deadline scheduler,
IOPRIO_CLASS_DL is mapped to IOPRIO_CLASS_RT.

The reason for this is twofold:
1) Each priority level for the IOPRIO_CLASS_DL priority class represents a
duration limit descriptor (DLD) inside the device. Users can configure
these limits themselves using passthrough commands, so from a block layer
perspective, Linux has no idea of how each DLD is actually configured.

By mapping a command to IOPRIO_CLASS_RT, the chance that a command exceeds
its duration limit (because it was held too long in the scheduler) is
decreased. It is still possible to use the IOPRIO_CLASS_DL priority class
for "low priority" IOs by configuring a large limit in the respective DLD.

2) On ATA drives, IOPRIO_CLASS_DL commands and NCQ priority commands
(IOPRIO_CLASS_RT) cannot be used together. A mix of CDL and high priority
commands cannot be sent to a device. By mapping IOPRIO_CLASS_DL to
IOPRIO_CLASS_RT, we ensure that a device will never receive a mix of these
two incompatible priority classes.

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
2.39.1

