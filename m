Return-Path: <linux-scsi-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E6AB5C25B45
	for <linux-scsi@archiver.kernel.org>; Mon, 23 Oct 2023 21:57:26 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233572AbjJWV50 (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Mon, 23 Oct 2023 17:57:26 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59018 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233387AbjJWV5S (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Mon, 23 Oct 2023 17:57:18 -0400
Received: from mail-pj1-f46.google.com (mail-pj1-f46.google.com [209.85.216.46])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C4B7AD79;
        Mon, 23 Oct 2023 14:57:15 -0700 (PDT)
Received: by mail-pj1-f46.google.com with SMTP id 98e67ed59e1d1-27d0251d305so2477076a91.2;
        Mon, 23 Oct 2023 14:57:15 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1698098235; x=1698703035;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=eslftmeaUhr6gGr/R7540wMyMB4pipneawlcocLt5qY=;
        b=ZKYONOk6+nMhxpwcOwD5CIjj6JhSIb4A+qGYbrbD9DmJSN9HlPTXV0eS74AbZTnmlY
         ztHfZvunRiUZqSdZBjfH+DWuMV90LoOtLhzyp5EzpL205/LPf77NyEvgzs9j2FQ42Ylu
         ZacfgVXg8xYnn1AVvHTRMUlha+NrabGAniYk5DECbxfc6YY3Q+O37jtQd4buW3Jc3FV8
         tfQ1Dr6cVAMaSMN5jrTQBc7yNHVjT9F+qWeai5a4WdLKUI85VmLuyCEyuwIRsJzV0z//
         rtVztg6bG4T67Il8mxmvAyeUGw7ngPtDNzdQR+gQw7r6s411cT7dzBw2rOGYkm+Okj0k
         QZ6Q==
X-Gm-Message-State: AOJu0YwY6HXm/34sTbHJHsP2dv6PnQbCXBelepowXNDnFpEMY2x+Y9UG
        IPQl03EndRC6FJ6ZjNZBV9A=
X-Google-Smtp-Source: AGHT+IF89FVXIfoPrVM7/ipFwSNPc0oTakHnELADax/9myEN88959OyA9/138kjoBFR1O7P4stiugg==
X-Received: by 2002:a17:90b:f98:b0:27d:3e90:9ee1 with SMTP id ft24-20020a17090b0f9800b0027d3e909ee1mr9074086pjb.23.1698098235043;
        Mon, 23 Oct 2023 14:57:15 -0700 (PDT)
Received: from bvanassche-linux.mtv.corp.google.com ([2620:15c:211:201:14f9:170e:9304:1c4e])
        by smtp.gmail.com with ESMTPSA id b12-20020a17090acc0c00b0027d12b1e29dsm7851029pju.25.2023.10.23.14.57.14
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 23 Oct 2023 14:57:14 -0700 (PDT)
From:   Bart Van Assche <bvanassche@acm.org>
To:     Jens Axboe <axboe@kernel.dk>
Cc:     linux-block@vger.kernel.org, linux-scsi@vger.kernel.org,
        "Martin K . Petersen" <martin.petersen@oracle.com>,
        Christoph Hellwig <hch@lst.de>,
        Bart Van Assche <bvanassche@acm.org>,
        Damien Le Moal <dlemoal@kernel.org>,
        Ming Lei <ming.lei@redhat.com>,
        "James E.J. Bottomley" <jejb@linux.ibm.com>
Subject: [PATCH v14 09/19] scsi: sd: Add a unit test for sd_cmp_sector()
Date:   Mon, 23 Oct 2023 14:54:00 -0700
Message-ID: <20231023215638.3405959-10-bvanassche@acm.org>
X-Mailer: git-send-email 2.42.0.758.gaed0368e0e-goog
In-Reply-To: <20231023215638.3405959-1-bvanassche@acm.org>
References: <20231023215638.3405959-1-bvanassche@acm.org>
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
 drivers/scsi/Kconfig.kunit  |  5 +++
 drivers/scsi/Makefile.kunit |  1 +
 drivers/scsi/sd.c           |  7 ++-
 drivers/scsi/sd.h           |  2 +
 drivers/scsi/sd_test.c      | 86 +++++++++++++++++++++++++++++++++++++
 5 files changed, 99 insertions(+), 2 deletions(-)
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
index c9de909ad506..82abc721b543 100644
--- a/drivers/scsi/sd.c
+++ b/drivers/scsi/sd.c
@@ -1980,8 +1980,8 @@ static int sd_eh_action(struct scsi_cmnd *scmd, int eh_disp)
 	return eh_disp;
 }
 
-static int sd_cmp_sector(void *priv, const struct list_head *_a,
-			 const struct list_head *_b)
+int sd_cmp_sector(void *priv, const struct list_head *_a,
+		  const struct list_head *_b)
 {
 	struct scsi_cmnd *a = list_entry(_a, typeof(*a), eh_entry);
 	struct scsi_cmnd *b = list_entry(_b, typeof(*b), eh_entry);
@@ -2001,6 +2001,9 @@ static int sd_cmp_sector(void *priv, const struct list_head *_a,
 		return use_zwl_a > use_zwl_b;
 	return blk_rq_pos(rq_a) > blk_rq_pos(rq_b);
 }
+#if IS_MODULE(CONFIG_SD_TEST)
+EXPORT_SYMBOL_GPL(sd_cmp_sector);
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
index 000000000000..b9c3d2bf311e
--- /dev/null
+++ b/drivers/scsi/sd_test.c
@@ -0,0 +1,86 @@
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
+#define ALLOC(type, ...)					\
+	({							\
+		type *obj;					\
+		obj = kmalloc(sizeof(*obj), GFP_KERNEL);	\
+		if (obj)					\
+			*obj = (type){ __VA_ARGS__ };		\
+		obj;						\
+	})
+
+#define ALLOC_Q(...) ALLOC(struct request_queue, __VA_ARGS__)
+
+#define ALLOC_CMD(...) ALLOC(struct rq_and_cmd, __VA_ARGS__)
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
