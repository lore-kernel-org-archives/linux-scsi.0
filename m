Return-Path: <linux-scsi-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 6E56AC4332F
	for <linux-scsi@archiver.kernel.org>; Tue, 14 Nov 2023 21:18:54 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234085AbjKNVS4 (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Tue, 14 Nov 2023 16:18:56 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43264 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234095AbjKNVSr (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Tue, 14 Nov 2023 16:18:47 -0500
Received: from mail-pl1-f182.google.com (mail-pl1-f182.google.com [209.85.214.182])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5EF1BFB;
        Tue, 14 Nov 2023 13:18:44 -0800 (PST)
Received: by mail-pl1-f182.google.com with SMTP id d9443c01a7336-1cc34c3420bso47872865ad.3;
        Tue, 14 Nov 2023 13:18:44 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1699996724; x=1700601524;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=u5C8QTqGh/a0Jki+l9qVpbMBnpDJv7ICCSUZf0jmocU=;
        b=EOB8NZFyVNa6urdrdea1Aibe7UenZylCH3z6bKCdSs6Nzv5PhMVGWhWk4kIZBuzQ4j
         tsnnzb2ak3Y+8innvquEQGi4mvlCzendDPV6pLWoo/NmqU46CQlpek7esBMwj8vrkf/Q
         cBuvcKl4QXYUjiLqnM+R1p/hHicTGc5S1KCwwLM4KODdWilIiwwu5xn6mIQCvQnUt+ac
         0dEhOIujR8tUrd5DOTgUfKWowm9klhIRoYxiKUS1YhOjjojRLQPTlenSZUCJAh2WEjyu
         ppmmxKz4Qnz/VHFaGlqpTdQJeiEQkRYr6Msje4FsXru7lGfRM6Zfad8q/9Y0vyYsWklD
         zUZA==
X-Gm-Message-State: AOJu0Yz2Cdf0yV8rwY+/L2wSEQ6MjSUiHd+x2+tv79o/CLl03D/FiBSb
        hg+hO4LW4sDfHwnFFIer5nMmwZyUIO8=
X-Google-Smtp-Source: AGHT+IGuLpK5c0LU1HnWPaHYPG5YSuXxZ0RuTZFXErMNKVuIgISMT1OPYL1QI22cdBlFo57goyPK3w==
X-Received: by 2002:a17:902:db03:b0:1cc:32ae:4afd with SMTP id m3-20020a170902db0300b001cc32ae4afdmr4367405plx.46.1699996723778;
        Tue, 14 Nov 2023 13:18:43 -0800 (PST)
Received: from bvanassche-linux.mtv.corp.google.com ([2620:0:1000:8411:2278:ad72:cefb:4d49])
        by smtp.gmail.com with ESMTPSA id ix7-20020a170902f80700b001c71ec1866fsm6169288plb.258.2023.11.14.13.18.42
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 14 Nov 2023 13:18:43 -0800 (PST)
From:   Bart Van Assche <bvanassche@acm.org>
To:     "Martin K . Petersen" <martin.petersen@oracle.com>
Cc:     linux-scsi@vger.kernel.org, linux-block@vger.kernel.org,
        Jens Axboe <axboe@kernel.dk>, Christoph Hellwig <hch@lst.de>,
        Bart Van Assche <bvanassche@acm.org>,
        Damien Le Moal <dlemoal@kernel.org>,
        Ming Lei <ming.lei@redhat.com>,
        "James E.J. Bottomley" <jejb@linux.ibm.com>
Subject: [PATCH v15 09/19] scsi: sd: Add a unit test for sd_cmp_sector()
Date:   Tue, 14 Nov 2023 13:16:17 -0800
Message-ID: <20231114211804.1449162-10-bvanassche@acm.org>
X-Mailer: git-send-email 2.43.0.rc0.421.g78406f8d94-goog
In-Reply-To: <20231114211804.1449162-1-bvanassche@acm.org>
References: <20231114211804.1449162-1-bvanassche@acm.org>
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
 drivers/scsi/Kconfig   |  5 +++
 drivers/scsi/sd.c      |  4 ++
 drivers/scsi/sd_test.c | 86 ++++++++++++++++++++++++++++++++++++++++++
 3 files changed, 95 insertions(+)
 create mode 100644 drivers/scsi/sd_test.c

diff --git a/drivers/scsi/Kconfig b/drivers/scsi/Kconfig
index 2e57afdbbc4d..ba2b81ddd7f8 100644
--- a/drivers/scsi/Kconfig
+++ b/drivers/scsi/Kconfig
@@ -237,6 +237,11 @@ config SCSI_ERROR_TEST
 	depends on SCSI && KUNIT
 	default KUNIT_ALL_TESTS
 
+config SD_TEST
+	tristate "sd.c unit tests" if !KUNIT_ALL_TESTS
+	depends on SCSI && BLK_DEV_SD && KUNIT
+	default KUNIT_ALL_TESTS
+
 menu "SCSI Transports"
 	depends on SCSI
 
diff --git a/drivers/scsi/sd.c b/drivers/scsi/sd.c
index 63bb01ddadde..d52ea605ada8 100644
--- a/drivers/scsi/sd.c
+++ b/drivers/scsi/sd.c
@@ -4141,3 +4141,7 @@ void sd_print_result(const struct scsi_disk *sdkp, const char *msg, int result)
 			  "%s: Result: hostbyte=0x%02x driverbyte=%s\n",
 			  msg, host_byte(result), "DRIVER_OK");
 }
+
+#ifdef CONFIG_SD_TEST
+#include "sd_test.c"
+#endif
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
