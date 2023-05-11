Return-Path: <linux-scsi-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 8FF70C77B7D
	for <linux-scsi@archiver.kernel.org>; Thu, 11 May 2023 01:16:34 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236736AbjEKBQe (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Wed, 10 May 2023 21:16:34 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48978 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231313AbjEKBQc (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Wed, 10 May 2023 21:16:32 -0400
Received: from mail-lj1-x233.google.com (mail-lj1-x233.google.com [IPv6:2a00:1450:4864:20::233])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DE654E70;
        Wed, 10 May 2023 18:16:30 -0700 (PDT)
Received: by mail-lj1-x233.google.com with SMTP id 38308e7fff4ca-2ac785015d7so88224731fa.1;
        Wed, 10 May 2023 18:16:30 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1683767789; x=1686359789;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:dkim-signature:dkim-signature
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=nlW4d3pOg2GqxWJ11zMVe1q046B9Gj18oEU1QcocFSQ=;
        b=JnfzRGkvkUgo9dQO0wGskGPGA/7N/HtZBEErb7WtiC40juxJZk7Ra5sTiBWV7eRwVP
         XH3yj+wMGxBfyv5dRnONL4to35oEti/ej+39dvZ7k6DoE3Ce2+LbYtib+SL9KZiSRzyB
         eQSIUT5okF50IV5PTiJ0X/GIe0xK8PoI5aYtZvNGIhv8kPZw3nUHFONmYb11U5xYzjct
         4nWb0pkX3ZW0ArVQ/YoKcHDRQkkQMVATvJ/J26ketvC6m6d/giSr5LEsVpqSCoxZ0HBZ
         i/vwifPZmVCa599e7Oyj77+Iwqm1QcOPY7f9dICHMlaJiZYGB8tufLKsoPXhWFHuaF1P
         75Vg==
X-Gm-Message-State: AC+VfDwRfQm/+JAtnBIDvr5Lz9Gv/yQn393kMm0W9VEZnNxIV8bT4FmT
        Swgl16ITCGz8pzpZtb9zAPi0zhWxS8rcHjOd
X-Google-Smtp-Source: ACHHUZ6UCTy8Z1PyBpohAmtEBhZL6kpawnZR045qkYh+Uqzoiti6vTBqo4SOAxMS+NbW49FqyduFow==
X-Received: by 2002:a2e:908c:0:b0:2ac:7e64:ef8 with SMTP id l12-20020a2e908c000000b002ac7e640ef8mr2384147ljg.16.1683767789137;
        Wed, 10 May 2023 18:16:29 -0700 (PDT)
Received: from flawful.org (c-fcf6e255.011-101-6d6c6d3.bbcust.telenor.se. [85.226.246.252])
        by smtp.gmail.com with ESMTPSA id r3-20020a2eb603000000b002a8c1462ecbsm2207739ljn.137.2023.05.10.18.16.28
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 10 May 2023 18:16:28 -0700 (PDT)
Received: by flawful.org (Postfix, from userid 112)
        id D70AD21E; Thu, 11 May 2023 03:16:27 +0200 (CEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=flawful.org; s=mail;
        t=1683767788; bh=GyoxypksNyPnkk4CrHnVumY8DqB1AhCv8hIV0ITDiL8=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=aEVjbKCoqy+9j5anJprbDSFSBA5nv5XA4Hs0MHierBlChmNS2o54go7zCx4WEA7K8
         pvOZ6Ex9WcnFctzcqaZWxMxuZ/Iq732Lzmve5TfFU6OkMS1yHvMj8E0QyYqI12nspc
         smfWl7dDb803d1TA7oy8jSDpr2QXr9du29AHt03I=
Received: from x1-carbon.. (unknown [64.141.80.140])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
        (No client certificate requested)
        by flawful.org (Postfix) with ESMTPSA id F15CE21E;
        Thu, 11 May 2023 03:14:36 +0200 (CEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=flawful.org; s=mail;
        t=1683767679; bh=GyoxypksNyPnkk4CrHnVumY8DqB1AhCv8hIV0ITDiL8=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=MKvw/VK51GuRAbcFF0dVjyaOu3m8k0WhKVaKv9IuiaLYe098Bv/pOH9UnzYq8nF6e
         GbAtEY+3xnB90AEcZ2f2utfheswRmesTf/EBRCVp7GSgrp8zJOdD55m2yXyI4NY5Uo
         6XHLbmGBnyAn2EUESDIRAciRNbrox8zmXtlCQonY=
From:   Niklas Cassel <nks@flawful.org>
To:     Jens Axboe <axboe@kernel.dk>,
        "Martin K. Petersen" <martin.petersen@oracle.com>,
        Paolo Valente <paolo.valente@linaro.org>
Cc:     Bart Van Assche <bvanassche@acm.org>,
        Christoph Hellwig <hch@lst.de>, Hannes Reinecke <hare@suse.de>,
        Damien Le Moal <dlemoal@kernel.org>,
        linux-scsi@vger.kernel.org, linux-ide@vger.kernel.org,
        linux-block@vger.kernel.org, Niklas Cassel <niklas.cassel@wdc.com>
Subject: [PATCH v7 01/19] ioprio: cleanup interface definition
Date:   Thu, 11 May 2023 03:13:34 +0200
Message-Id: <20230511011356.227789-2-nks@flawful.org>
X-Mailer: git-send-email 2.40.1
In-Reply-To: <20230511011356.227789-1-nks@flawful.org>
References: <20230511011356.227789-1-nks@flawful.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

From: Damien Le Moal <dlemoal@kernel.org>

The IO priority user interface defines the 16-bits ioprio values as
the combination of the upper 3-bits for an IO priority class and the
lower 13-bits as priority data. However, the kernel only uses the
lower 3-bits of the priority data to define priority levels for the RT
and BE priority classes. The data part of an ioprio value is completely
ignored for the IDLE and NONE classes. This is enforced by checks done
in ioprio_check_cap(), which is called for all paths that allow defining
an IO priority for IOs: the per-context ioprio_set() system call, aio
interface and io-uring interface.

Clarify this fact in the uapi ioprio.h header file and introduce the
IOPRIO_PRIO_LEVEL_MASK and IOPRIO_PRIO_LEVEL() macros for users to
define and get priority levels in an ioprio value. The coarser macro
IOPRIO_PRIO_DATA() is retained for backward compatibility with old
applications already using it. There is no functional change introduced
with this.

In-kernel users of the IOPRIO_PRIO_DATA() macro which are explicitly
handling IO priority data as a priority level are modified to use the
new IOPRIO_PRIO_LEVEL() macro without any functional change. Since f2fs
is the only user of this macro not explicitly using that value as a
priority level, it is left unchanged.

Signed-off-by: Damien Le Moal <dlemoal@kernel.org>
Reviewed-by: Hannes Reinecke <hare@suse.de>
Reviewed-by: Christoph Hellwig <hch@lst.de>
Signed-off-by: Niklas Cassel <niklas.cassel@wdc.com>
---
 block/bfq-iosched.c         |  8 ++++----
 block/ioprio.c              |  6 +++---
 include/uapi/linux/ioprio.h | 19 ++++++++++++++-----
 3 files changed, 21 insertions(+), 12 deletions(-)

diff --git a/block/bfq-iosched.c b/block/bfq-iosched.c
index 3164e3177965..3067b75f3fd0 100644
--- a/block/bfq-iosched.c
+++ b/block/bfq-iosched.c
@@ -5524,16 +5524,16 @@ bfq_set_next_ioprio_data(struct bfq_queue *bfqq, struct bfq_io_cq *bic)
 		bfqq->new_ioprio_class = task_nice_ioclass(tsk);
 		break;
 	case IOPRIO_CLASS_RT:
-		bfqq->new_ioprio = IOPRIO_PRIO_DATA(bic->ioprio);
+		bfqq->new_ioprio = IOPRIO_PRIO_LEVEL(bic->ioprio);
 		bfqq->new_ioprio_class = IOPRIO_CLASS_RT;
 		break;
 	case IOPRIO_CLASS_BE:
-		bfqq->new_ioprio = IOPRIO_PRIO_DATA(bic->ioprio);
+		bfqq->new_ioprio = IOPRIO_PRIO_LEVEL(bic->ioprio);
 		bfqq->new_ioprio_class = IOPRIO_CLASS_BE;
 		break;
 	case IOPRIO_CLASS_IDLE:
 		bfqq->new_ioprio_class = IOPRIO_CLASS_IDLE;
-		bfqq->new_ioprio = 7;
+		bfqq->new_ioprio = IOPRIO_NR_LEVELS - 1;
 		break;
 	}
 
@@ -5830,7 +5830,7 @@ static struct bfq_queue *bfq_get_queue(struct bfq_data *bfqd,
 				       struct bfq_io_cq *bic,
 				       bool respawn)
 {
-	const int ioprio = IOPRIO_PRIO_DATA(bic->ioprio);
+	const int ioprio = IOPRIO_PRIO_LEVEL(bic->ioprio);
 	const int ioprio_class = IOPRIO_PRIO_CLASS(bic->ioprio);
 	struct bfq_queue **async_bfqq = NULL;
 	struct bfq_queue *bfqq;
diff --git a/block/ioprio.c b/block/ioprio.c
index 32a456b45804..f0d9e818abc5 100644
--- a/block/ioprio.c
+++ b/block/ioprio.c
@@ -33,7 +33,7 @@
 int ioprio_check_cap(int ioprio)
 {
 	int class = IOPRIO_PRIO_CLASS(ioprio);
-	int data = IOPRIO_PRIO_DATA(ioprio);
+	int level = IOPRIO_PRIO_LEVEL(ioprio);
 
 	switch (class) {
 		case IOPRIO_CLASS_RT:
@@ -49,13 +49,13 @@ int ioprio_check_cap(int ioprio)
 			fallthrough;
 			/* rt has prio field too */
 		case IOPRIO_CLASS_BE:
-			if (data >= IOPRIO_NR_LEVELS || data < 0)
+			if (level >= IOPRIO_NR_LEVELS)
 				return -EINVAL;
 			break;
 		case IOPRIO_CLASS_IDLE:
 			break;
 		case IOPRIO_CLASS_NONE:
-			if (data)
+			if (level)
 				return -EINVAL;
 			break;
 		default:
diff --git a/include/uapi/linux/ioprio.h b/include/uapi/linux/ioprio.h
index f70f2596a6bf..4444b4e4fdad 100644
--- a/include/uapi/linux/ioprio.h
+++ b/include/uapi/linux/ioprio.h
@@ -17,7 +17,7 @@
 	 ((data) & IOPRIO_PRIO_MASK))
 
 /*
- * These are the io priority groups as implemented by the BFQ and mq-deadline
+ * These are the io priority classes as implemented by the BFQ and mq-deadline
  * schedulers. RT is the realtime class, it always gets premium service. For
  * ATA disks supporting NCQ IO priority, RT class IOs will be processed using
  * high priority NCQ commands. BE is the best-effort scheduling class, the
@@ -32,11 +32,20 @@ enum {
 };
 
 /*
- * The RT and BE priority classes both support up to 8 priority levels.
+ * The RT and BE priority classes both support up to 8 priority levels that
+ * can be specified using the lower 3-bits of the priority data.
  */
-#define IOPRIO_NR_LEVELS	8
-#define IOPRIO_BE_NR		IOPRIO_NR_LEVELS
+#define IOPRIO_LEVEL_NR_BITS		3
+#define IOPRIO_NR_LEVELS		(1 << IOPRIO_LEVEL_NR_BITS)
+#define IOPRIO_LEVEL_MASK		(IOPRIO_NR_LEVELS - 1)
+#define IOPRIO_PRIO_LEVEL(ioprio)	((ioprio) & IOPRIO_LEVEL_MASK)
 
+#define IOPRIO_BE_NR			IOPRIO_NR_LEVELS
+
+/*
+ * Possible values for the "which" argument of the ioprio_get() and
+ * ioprio_set() system calls (see "man ioprio_set").
+ */
 enum {
 	IOPRIO_WHO_PROCESS = 1,
 	IOPRIO_WHO_PGRP,
@@ -44,7 +53,7 @@ enum {
 };
 
 /*
- * Fallback BE priority level.
+ * Fallback BE class priority level.
  */
 #define IOPRIO_NORM	4
 #define IOPRIO_BE_NORM	IOPRIO_NORM
-- 
2.40.1

