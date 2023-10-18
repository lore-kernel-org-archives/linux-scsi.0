Return-Path: <linux-scsi-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 54BD5C41513
	for <linux-scsi@archiver.kernel.org>; Wed, 18 Oct 2023 17:56:52 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232359AbjJRR4v (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Wed, 18 Oct 2023 13:56:51 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48790 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231864AbjJRR4q (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Wed, 18 Oct 2023 13:56:46 -0400
Received: from mail-oo1-f52.google.com (mail-oo1-f52.google.com [209.85.161.52])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3845218F;
        Wed, 18 Oct 2023 10:56:36 -0700 (PDT)
Received: by mail-oo1-f52.google.com with SMTP id 006d021491bc7-57ad95c555eso4013366eaf.3;
        Wed, 18 Oct 2023 10:56:36 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1697651795; x=1698256595;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=tgkcpMeB8iCIlRd5RqoUIvAC4F49icgyF9qAednPXIQ=;
        b=dDTinihSb34rGKoULOp0I3BWM3nAq+hoJVQdH1cD/JwNtIY4pneKLwE2/+23k5oJFK
         +eio9NTtLy84AZOarl5aTEf1UuyKZNAN+m0L2P18pkXeqv0cVJOOjFvI3FeJm8KTUqK3
         RvUDuYmjTBZCh0xW2OgOC5AAdmzsnYEiZ+ZXR9M7McB6fy/hGIIGLe0izjOvS4GggJjE
         5NYPPU4O/ZXy1S5LDWF5rEybbamMhrRSI1VjWFcEFfSFevvXwQ7c/6IPVt2Af46R2/gO
         u37ShyFLszBu40dWYZwOqTRCONyk3TUfz9S2OQMCCGY8EKmmqwCDbtWMg3CEiV/Vm0dV
         aouA==
X-Gm-Message-State: AOJu0YzfmL7Y6TVzW+HNvLhaduek5P3GFH0z+nqLQ+QRyZDW4WWlqNfs
        lNzEUZLLLc+IHEbSCsl+sWQ=
X-Google-Smtp-Source: AGHT+IFartW3SZD3gzSDosUlH5fY5KYz+xtITfvMDuLKNeN1p+x00ehJDAuWiZsgdtTQtmTmum/Wsw==
X-Received: by 2002:a05:6359:3119:b0:166:dc89:8c92 with SMTP id rh25-20020a056359311900b00166dc898c92mr5272939rwb.26.1697651795256;
        Wed, 18 Oct 2023 10:56:35 -0700 (PDT)
Received: from bvanassche-linux.mtv.corp.google.com ([2620:15c:211:201:66c1:dd00:1e1e:add3])
        by smtp.gmail.com with ESMTPSA id p15-20020aa7860f000000b00690cd981652sm3628612pfn.61.2023.10.18.10.56.34
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 18 Oct 2023 10:56:34 -0700 (PDT)
From:   Bart Van Assche <bvanassche@acm.org>
To:     Jens Axboe <axboe@kernel.dk>
Cc:     linux-block@vger.kernel.org, linux-scsi@vger.kernel.org,
        "Martin K . Petersen" <martin.petersen@oracle.com>,
        Christoph Hellwig <hch@lst.de>,
        Bart Van Assche <bvanassche@acm.org>,
        Damien Le Moal <dlemoal@kernel.org>,
        Ming Lei <ming.lei@redhat.com>,
        "James E.J. Bottomley" <jejb@linux.ibm.com>
Subject: [PATCH v13 08/18] scsi: sd: Add a unit test for sd_cmp_sector()
Date:   Wed, 18 Oct 2023 10:54:30 -0700
Message-ID: <20231018175602.2148415-9-bvanassche@acm.org>
X-Mailer: git-send-email 2.42.0.655.g421f12c284-goog
In-Reply-To: <20231018175602.2148415-1-bvanassche@acm.org>
References: <20231018175602.2148415-1-bvanassche@acm.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

Make it easier to test sd_cmp_sector() by adding a unit test for this
function.

Cc: Martin K. Petersen <martin.petersen@oracle.com>
Cc: Damien Le Moal <dlemoal@kernel.org>
Cc: Christoph Hellwig <hch@lst.de>
Cc: Ming Lei <ming.lei@redhat.com>
Signed-off-by: Bart Van Assche <bvanassche@acm.org>
---
 drivers/scsi/Kconfig.kunit  |  5 ++
 drivers/scsi/Makefile.kunit |  1 +
 drivers/scsi/sd.c           |  7 ++-
 drivers/scsi/sd.h           |  2 +
 drivers/scsi/sd_test.c      | 91 +++++++++++++++++++++++++++++++++++++
 5 files changed, 104 insertions(+), 2 deletions(-)
 create mode 100644 drivers/scsi/sd_test.c

diff --git a/drivers/scsi/Kconfig.kunit b/drivers/scsi/Kconfig.kunit
index 90984a6ec7cc..907798967b6f 100644
--- a/drivers/scsi/Kconfig.kunit
+++ b/drivers/scsi/Kconfig.kunit
@@ -2,3 +2,8 @@ config SCSI_ERROR_TEST
 	tristate "scsi_error.c unit tests" if !KUNIT_ALL_TESTS
 	depends on SCSI && KUNIT
 	default KUNIT_ALL_TESTS
+
+config SD_TEST
+	tristate "sd.c unit tests" if !KUNIT_ALL_TESTS
+	depends on SCSI && BLK_DEV_SD && KUNIT
+	default KUNIT_ALL_TESTS
diff --git a/drivers/scsi/Makefile.kunit b/drivers/scsi/Makefile.kunit
index 3e98053b2709..dc0a21d7749f 100644
--- a/drivers/scsi/Makefile.kunit
+++ b/drivers/scsi/Makefile.kunit
@@ -1 +1,2 @@
 obj-$(CONFIG_SCSI_ERROR_TEST) += scsi_error_test.o
+obj-$(CONFIG_SD_TEST) += sd_test.o
diff --git a/drivers/scsi/sd.c b/drivers/scsi/sd.c
index 6f26d6d6f50b..c4a89300d3f9 100644
--- a/drivers/scsi/sd.c
+++ b/drivers/scsi/sd.c
@@ -1988,8 +1988,8 @@ static bool sd_needs_prepare_resubmit(struct scsi_cmnd *cmd)
 		blk_rq_is_seq_zoned_write(rq);
 }
 
-static int sd_cmp_sector(void *priv, const struct list_head *_a,
-			 const struct list_head *_b)
+int sd_cmp_sector(void *priv, const struct list_head *_a,
+		  const struct list_head *_b)
 {
 	struct scsi_cmnd *a = list_entry(_a, typeof(*a), eh_entry);
 	struct scsi_cmnd *b = list_entry(_b, typeof(*b), eh_entry);
@@ -2009,6 +2009,9 @@ static int sd_cmp_sector(void *priv, const struct list_head *_a,
 		return use_zwl_a > use_zwl_b;
 	return blk_rq_pos(rq_a) > blk_rq_pos(rq_b);
 }
+#if IS_MODULE(CONFIG_SD_TEST)
+EXPORT_SYMBOL_GPL(scsi_call_prepare_resubmit);
+#endif
 
 static void sd_prepare_resubmit(struct list_head *cmd_list)
 {
diff --git a/drivers/scsi/sd.h b/drivers/scsi/sd.h
index 5eea762f84d1..35b7cdb7bf3b 100644
--- a/drivers/scsi/sd.h
+++ b/drivers/scsi/sd.h
@@ -292,6 +292,8 @@ static inline blk_status_t sd_zbc_prepare_zone_append(struct scsi_cmnd *cmd,
 
 #endif /* CONFIG_BLK_DEV_ZONED */
 
+int sd_cmp_sector(void *priv, const struct list_head *_a,
+		  const struct list_head *_b);
 void sd_print_sense_hdr(struct scsi_disk *sdkp, struct scsi_sense_hdr *sshdr);
 void sd_print_result(const struct scsi_disk *sdkp, const char *msg, int result);
 
diff --git a/drivers/scsi/sd_test.c b/drivers/scsi/sd_test.c
new file mode 100644
index 000000000000..0dc0f4c67b96
--- /dev/null
+++ b/drivers/scsi/sd_test.c
@@ -0,0 +1,91 @@
+// SPDX-License-Identifier: GPL-2.0-only
+/*
+ * Copyright 2023 Google LLC
+ */
+#include <kunit/test.h>
+#include <linux/cleanup.h>
+#include <linux/list_sort.h>
+#include <linux/slab.h>
+#include <scsi/scsi_cmnd.h>
+#include <scsi/scsi_driver.h>
+#include "sd.h"
+
+#define ALLOC_Q(...)                                                \
+	({                                                          \
+		struct request_queue *q;                            \
+		q = kmalloc(sizeof(*q), GFP_KERNEL);                \
+		if (q)                                              \
+			*q = (struct request_queue){ __VA_ARGS__ }; \
+		q;                                                  \
+	})
+
+#define ALLOC_CMD(...)                                             \
+	({                                                         \
+		struct rq_and_cmd *cmd;                            \
+		cmd = kmalloc(sizeof(*cmd), GFP_KERNEL);           \
+		if (cmd)                                           \
+			*cmd = (struct rq_and_cmd){ __VA_ARGS__ }; \
+		cmd;                                               \
+	})
+
+struct rq_and_cmd {
+	struct request rq;
+	struct scsi_cmnd cmd;
+};
+
+/*
+ * Verify that sd_cmp_sector() does what it is expected to do.
+ */
+static void test_sd_cmp_sector(struct kunit *test)
+{
+	struct request_queue *q1 __free(kfree) =
+		ALLOC_Q(.limits.use_zone_write_lock = true);
+	struct request_queue *q2 __free(kfree) =
+		ALLOC_Q(.limits.use_zone_write_lock = false);
+	struct rq_and_cmd *cmd1 __free(kfree) = ALLOC_CMD(.rq = {
+								  .q = q1,
+								  .__sector = 7,
+							  });
+	struct rq_and_cmd *cmd2 __free(kfree) = ALLOC_CMD(.rq = {
+								  .q = q1,
+								  .__sector = 5,
+							  });
+	struct rq_and_cmd *cmd3 __free(kfree) = ALLOC_CMD(.rq = {
+								  .q = q2,
+								  .__sector = 7,
+							  });
+	struct rq_and_cmd *cmd4 __free(kfree) = ALLOC_CMD(.rq = {
+								  .q = q2,
+								  .__sector = 5,
+							  });
+	LIST_HEAD(cmd_list);
+
+	list_add_tail(&cmd1->cmd.eh_entry, &cmd_list);
+	list_add_tail(&cmd2->cmd.eh_entry, &cmd_list);
+	list_add_tail(&cmd3->cmd.eh_entry, &cmd_list);
+	list_add_tail(&cmd4->cmd.eh_entry, &cmd_list);
+	KUNIT_EXPECT_EQ(test, list_count_nodes(&cmd_list), 4);
+	list_sort(NULL, &cmd_list, sd_cmp_sector);
+	KUNIT_EXPECT_EQ(test, list_count_nodes(&cmd_list), 4);
+	KUNIT_EXPECT_PTR_EQ(test, cmd_list.next, &cmd4->cmd.eh_entry);
+	KUNIT_EXPECT_PTR_EQ(test, cmd_list.next->next, &cmd3->cmd.eh_entry);
+	KUNIT_EXPECT_PTR_EQ(test, cmd_list.next->next->next,
+			    &cmd1->cmd.eh_entry);
+	KUNIT_EXPECT_PTR_EQ(test, cmd_list.next->next->next->next,
+			    &cmd2->cmd.eh_entry);
+}
+
+static struct kunit_case sd_test_cases[] = {
+	KUNIT_CASE(test_sd_cmp_sector),
+	{}
+};
+
+static struct kunit_suite sd_test_suite = {
+	.name = "sd",
+	.test_cases = sd_test_cases,
+};
+kunit_test_suite(sd_test_suite);
+
+MODULE_DESCRIPTION("SCSI disk (sd) driver unit tests");
+MODULE_AUTHOR("Bart Van Assche");
+MODULE_LICENSE("GPL");
