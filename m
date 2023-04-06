Return-Path: <linux-scsi-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id EAA7AC76196
	for <linux-scsi@archiver.kernel.org>; Thu,  6 Apr 2023 11:40:50 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238396AbjDFLkp (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Thu, 6 Apr 2023 07:40:45 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46034 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238480AbjDFLj2 (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Thu, 6 Apr 2023 07:39:28 -0400
Received: from mail-lf1-x134.google.com (mail-lf1-x134.google.com [IPv6:2a00:1450:4864:20::134])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 637CEAF3F;
        Thu,  6 Apr 2023 04:35:51 -0700 (PDT)
Received: by mail-lf1-x134.google.com with SMTP id x17so50462517lfu.5;
        Thu, 06 Apr 2023 04:35:51 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1680780894;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:dkim-signature:dkim-signature
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=uxkPXt/BJV64yINVeMw3iyNk+2W+/NvxrZXmnm6vVkc=;
        b=Fna9eKEFVG5CgPZJTrPyTQExtoGgxXxEfpBtIKWptOFzXMo4eRiMi+PgRAB+HzVJfd
         UQEjhDuoTz8fMKNyEGvXCYJ40Sco0huj0im51F0S5C0pEKGfv7UuIjsNrLjto81h/ipu
         X9QIFg/7+EviRjoNOEV3/jabCU0xWvpnJj81MYI0QUvy7kQ5BFyk6fSFyoqjRwIcamAM
         uPgMAWdIEEUzvI3BMv5f/vzj1ZZBds4H3tl9+BAVTJEoWMv1AbIwUwH2bTQO5HYMiHWf
         Y3n+yPNMUmfH2zUTVprSbo5R8RtvPjsK0Uc42KRc4h7dNmoQllA+sfYmhU+bKFoDSOZA
         JHpw==
X-Gm-Message-State: AAQBX9cDPzGclma2SNGzbQvOgwGbkswgmLYRYLTsheTe6qd+zqzmXnhI
        fFxc5mWCMzkt1eYJoZKJ4OrhFhlOOnXhRA==
X-Google-Smtp-Source: AKy350YPd8nACD/MEGbXapD2saTg0hTxTInGN/v9jhod6gupmdZq4bWennaNJ8no1YQkE3pFl8RH9g==
X-Received: by 2002:a19:c209:0:b0:4eb:4552:61aa with SMTP id l9-20020a19c209000000b004eb455261aamr2658961lfc.12.1680780893656;
        Thu, 06 Apr 2023 04:34:53 -0700 (PDT)
Received: from flawful.org (c-fcf6e255.011-101-6d6c6d3.bbcust.telenor.se. [85.226.246.252])
        by smtp.gmail.com with ESMTPSA id l2-20020ac25542000000b004a0589786ddsm225755lfk.69.2023.04.06.04.34.53
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 06 Apr 2023 04:34:53 -0700 (PDT)
Received: by flawful.org (Postfix, from userid 112)
        id 6921412A1; Thu,  6 Apr 2023 13:34:52 +0200 (CEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=flawful.org; s=mail;
        t=1680780892; bh=ebpTNycMZn1flsaux/oqOg/RKm/7dkblNsrcl9srxNc=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=O69y/dbUnEdofy+NxftR1kH3K1G8XmSEaAzoJBx91r6RGSbHRepQt0cWse1XlfXLM
         V82Ye+R6dUXaI4MOGS8mvh/HBGkgSOgFUTj3XTvOY33V04M38VyRtJx0tgtesgtV7d
         tRWtld6BQ7sU0uwLKAH3STLX+d4n0nSK/j9YBUoI=
Received: from x1-carbon.lan (OpenWrt.lan [192.168.1.1])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
        (No client certificate requested)
        by flawful.org (Postfix) with ESMTPSA id 77327666;
        Thu,  6 Apr 2023 13:33:06 +0200 (CEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=flawful.org; s=mail;
        t=1680780786; bh=ebpTNycMZn1flsaux/oqOg/RKm/7dkblNsrcl9srxNc=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=ULytm6a3uQPd+Bs/l0rmW98i4Vhxj+mhP+AgQ3VYIzrxePLTbo9zmzWbQm40odzXn
         usw5YcIDuAEJGiQwTwwzaC0dfszIRets/JaLKUieNIH05D6fuVHUV8P/qcqU3U6s9l
         knHlLhY4LELDGjShLCa32gHqz+fm1IKC8Ga6Bd/I=
From:   Niklas Cassel <nks@flawful.org>
To:     Jens Axboe <axboe@kernel.dk>,
        "Martin K. Petersen" <martin.petersen@oracle.com>,
        Paolo Valente <paolo.valente@linaro.org>
Cc:     Bart Van Assche <bvanassche@acm.org>,
        Christoph Hellwig <hch@lst.de>, Hannes Reinecke <hare@suse.de>,
        Damien Le Moal <damien.lemoal@opensource.wdc.com>,
        Damien Le Moal <dlemoal@fastmail.com>,
        linux-scsi@vger.kernel.org, linux-ide@vger.kernel.org,
        linux-block@vger.kernel.org, Niklas Cassel <niklas.cassel@wdc.com>
Subject: [PATCH v6 01/19] ioprio: cleanup interface definition
Date:   Thu,  6 Apr 2023 13:32:30 +0200
Message-Id: <20230406113252.41211-2-nks@flawful.org>
X-Mailer: git-send-email 2.39.2
In-Reply-To: <20230406113252.41211-1-nks@flawful.org>
References: <20230406113252.41211-1-nks@flawful.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

From: Damien Le Moal <damien.lemoal@opensource.wdc.com>

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

Signed-off-by: Damien Le Moal <damien.lemoal@opensource.wdc.com>
Signed-off-by: Niklas Cassel <niklas.cassel@wdc.com>
Reviewed-by: Hannes Reinecke <hare@suse.de>
---
 block/bfq-iosched.c         |  8 ++++----
 block/ioprio.c              |  6 +++---
 include/uapi/linux/ioprio.h | 19 ++++++++++++++-----
 3 files changed, 21 insertions(+), 12 deletions(-)

diff --git a/block/bfq-iosched.c b/block/bfq-iosched.c
index d9ed3108c17a..a4d2879096a5 100644
--- a/block/bfq-iosched.c
+++ b/block/bfq-iosched.c
@@ -5523,16 +5523,16 @@ bfq_set_next_ioprio_data(struct bfq_queue *bfqq, struct bfq_io_cq *bic)
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
 
@@ -5829,7 +5829,7 @@ static struct bfq_queue *bfq_get_queue(struct bfq_data *bfqd,
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
2.39.2

