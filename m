Return-Path: <linux-scsi-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 2DE9EC41513
	for <linux-scsi@archiver.kernel.org>; Fri,  4 Aug 2023 15:48:32 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232067AbjHDPsb (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Fri, 4 Aug 2023 11:48:31 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45508 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230393AbjHDPs3 (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Fri, 4 Aug 2023 11:48:29 -0400
Received: from mail-pf1-f173.google.com (mail-pf1-f173.google.com [209.85.210.173])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2DF2D2D71;
        Fri,  4 Aug 2023 08:48:29 -0700 (PDT)
Received: by mail-pf1-f173.google.com with SMTP id d2e1a72fcca58-68783004143so1710361b3a.2;
        Fri, 04 Aug 2023 08:48:29 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1691164108; x=1691768908;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=MRGGTee1EfuJznTKSeCwQWUyvPF1KRjQA3G7OxPoxWA=;
        b=EB8qEO4xYlaf+400CtuPNsBA9WG9iIpaoq4rMN0XNY357j1lyhaAUgRF6pQE9FwG6E
         rHQj1OmlFQJl2urB/y2N37tTyoR7k5v5TG+2mqww4XXg5uFWkW7bxveex0+InPwQ8/f5
         ZGfHWRJU61IzIs9ZqfpMQETooliP20k5lmV5M9nzIXy+70kmwit8dhQ2iEBIACeBnQ8x
         pzqztbJ1a6M8PLmHhP0JQISpIjQLkh7Bv17dL3KIW3cmLapqgtC6ikI515Sviqd0YUGm
         DDV4sGd7EieZsUTzNBWkZk9+DvgIiaNvzyrLcKGe9G8/o5Snj00Hz6lMhW/8JZvNMVkd
         agpQ==
X-Gm-Message-State: AOJu0YxZ2ri4N/EnVbjOdWQUQsiOa5fVb9B5u/r3aGRar7YlFZqhRVJS
        XtAbyFtmK9gNsMn/kCiFVVw=
X-Google-Smtp-Source: AGHT+IGa1EAXh0qhNk01FU/LJgav8URArUMP/5xjHCiJgt9k/3QPP96L0zPlTaRn4E6A5Tfa7E7SNA==
X-Received: by 2002:a05:6a00:23cc:b0:686:6e90:a99b with SMTP id g12-20020a056a0023cc00b006866e90a99bmr2306242pfc.25.1691164108549;
        Fri, 04 Aug 2023 08:48:28 -0700 (PDT)
Received: from bvanassche-linux.mtv.corp.google.com ([2620:15c:211:201:4af5:d063:a66d:403b])
        by smtp.gmail.com with ESMTPSA id h8-20020a62b408000000b00640ddad2e0dsm1760839pfn.47.2023.08.04.08.48.27
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 04 Aug 2023 08:48:28 -0700 (PDT)
From:   Bart Van Assche <bvanassche@acm.org>
To:     Jens Axboe <axboe@kernel.dk>
Cc:     linux-block@vger.kernel.org, linux-scsi@vger.kernel.org,
        "Martin K . Petersen" <martin.petersen@oracle.com>,
        Christoph Hellwig <hch@lst.de>,
        Bart Van Assche <bvanassche@acm.org>,
        Damien Le Moal <dlemoal@kernel.org>,
        Ming Lei <ming.lei@redhat.com>
Subject: [PATCH v6 1/7] block: Introduce the flag QUEUE_FLAG_NO_ZONE_WRITE_LOCK
Date:   Fri,  4 Aug 2023 08:47:59 -0700
Message-ID: <20230804154821.3232094-2-bvanassche@acm.org>
X-Mailer: git-send-email 2.41.0.640.ga95def55d0-goog
In-Reply-To: <20230804154821.3232094-1-bvanassche@acm.org>
References: <20230804154821.3232094-1-bvanassche@acm.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

Writes in sequential write required zones must happen at the write
pointer. Even if the submitter of the write commands (e.g. a filesystem)
submits writes for sequential write required zones in order, the block
layer or the storage controller may reorder these write commands.

The zone locking mechanism in the mq-deadline I/O scheduler serializes
write commands for sequential zones. Some but not all storage controllers
require this serialization. Introduce a new request queue flag to allow
block drivers to indicate that they preserve the order of write commands
and thus do not require serialization of writes per zone.

Reviewed-by: Damien Le Moal <dlemoal@kernel.org>
Cc: Christoph Hellwig <hch@lst.de>
Cc: Ming Lei <ming.lei@redhat.com>
Signed-off-by: Bart Van Assche <bvanassche@acm.org>
---
 include/linux/blkdev.h | 11 +++++++++++
 1 file changed, 11 insertions(+)

diff --git a/include/linux/blkdev.h b/include/linux/blkdev.h
index 2f5371b8482c..b6eb988f81f3 100644
--- a/include/linux/blkdev.h
+++ b/include/linux/blkdev.h
@@ -534,6 +534,12 @@ struct request_queue {
 #define QUEUE_FLAG_NONROT	6	/* non-rotational device (SSD) */
 #define QUEUE_FLAG_VIRT		QUEUE_FLAG_NONROT /* paravirt device */
 #define QUEUE_FLAG_IO_STAT	7	/* do disk/partitions IO accounting */
+/*
+ * The device supports not using the zone write locking mechanism to serialize
+ * write operations (REQ_OP_WRITE, REQ_OP_WRITE_ZEROES) issued to a sequential
+ * write required zone (BLK_ZONE_TYPE_SEQWRITE_REQ).
+ */
+#define QUEUE_FLAG_NO_ZONE_WRITE_LOCK 8
 #define QUEUE_FLAG_NOXMERGES	9	/* No extended merges */
 #define QUEUE_FLAG_ADD_RANDOM	10	/* Contributes to random pool */
 #define QUEUE_FLAG_SYNCHRONOUS	11	/* always completes in submit context */
@@ -597,6 +603,11 @@ bool blk_queue_flag_test_and_set(unsigned int flag, struct request_queue *q);
 #define blk_queue_skip_tagset_quiesce(q) \
 	test_bit(QUEUE_FLAG_SKIP_TAGSET_QUIESCE, &(q)->queue_flags)
 
+static inline bool blk_queue_no_zone_write_lock(struct request_queue *q)
+{
+	return test_bit(QUEUE_FLAG_NO_ZONE_WRITE_LOCK, &q->queue_flags);
+}
+
 extern void blk_set_pm_only(struct request_queue *q);
 extern void blk_clear_pm_only(struct request_queue *q);
 
