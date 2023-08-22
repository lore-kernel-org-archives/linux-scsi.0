Return-Path: <linux-scsi-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id EDC10EE49AF
	for <linux-scsi@archiver.kernel.org>; Tue, 22 Aug 2023 19:19:00 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230076AbjHVTTB (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Tue, 22 Aug 2023 15:19:01 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36820 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229864AbjHVTTA (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Tue, 22 Aug 2023 15:19:00 -0400
Received: from mail-pj1-f41.google.com (mail-pj1-f41.google.com [209.85.216.41])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A9886CFE;
        Tue, 22 Aug 2023 12:18:56 -0700 (PDT)
Received: by mail-pj1-f41.google.com with SMTP id 98e67ed59e1d1-26d4e1ba2dbso2645500a91.1;
        Tue, 22 Aug 2023 12:18:56 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1692731936; x=1693336736;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=adWNOW49kVXe1MZ2NF8xJiy0tj9xGw91as9Acxixn3o=;
        b=CXjdYKXz1xnF9fU+id0lG7JfMIRnKPM+5GJ4KXXidwEGD+14M2WExY2jFgRLZOQDK0
         JtBP9HbAk28A0KYg66VwPAwdkR2w+usjBx9iWWJBTT1swQg94yR4vS3Qy5feas84+P9m
         QbX3GyM+Zyz3DhoyWKWbEgw4+21e5kNyGyBIgU2tYyxRylNsobd3IIabuv7qt/A/JmmD
         ynnE8K+b38zH1s8/0YT2SFRFCChpJZ2JU7r+6zP5sZq9WiHAR3kqzQmJT1QvebFfvi3h
         jgSnuAudIO6u47uVdAc8STPLKvmTZRHrwZ5Yos8xZUJyAQIeh471aNRuFJ0o7DejbctT
         aw9g==
X-Gm-Message-State: AOJu0YxIUFkxQeY3XGXOiX4Ziz5gZghGyYFP3kclLL8uNn8718OBTQrN
        BOf1I0KG8sdnglDq/HvUCdM=
X-Google-Smtp-Source: AGHT+IFTgeHjinpgwEw5ewk3XZ0jajKlF2OI35vr5IvEsv/AYW2+ieYC9HfLRPTQRaCLz59K2E9DOw==
X-Received: by 2002:a17:90b:124b:b0:263:9661:a35c with SMTP id gx11-20020a17090b124b00b002639661a35cmr7806746pjb.8.1692731935960;
        Tue, 22 Aug 2023 12:18:55 -0700 (PDT)
Received: from bvanassche-linux.mtv.corp.google.com ([2620:15c:211:201:88be:bf57:de29:7cc])
        by smtp.gmail.com with ESMTPSA id m11-20020a17090a414b00b002696bd123e4sm8081632pjg.46.2023.08.22.12.18.55
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 22 Aug 2023 12:18:55 -0700 (PDT)
From:   Bart Van Assche <bvanassche@acm.org>
To:     Jens Axboe <axboe@kernel.dk>
Cc:     linux-block@vger.kernel.org, linux-scsi@vger.kernel.org,
        "Martin K . Petersen" <martin.petersen@oracle.com>,
        Christoph Hellwig <hch@lst.de>,
        Bart Van Assche <bvanassche@acm.org>,
        Damien Le Moal <dlemoal@kernel.org>,
        Ming Lei <ming.lei@redhat.com>,
        "James E.J. Bottomley" <jejb@linux.ibm.com>
Subject: [PATCH v11 05/16] scsi: core: Add unit tests for scsi_call_prepare_resubmit()
Date:   Tue, 22 Aug 2023 12:17:00 -0700
Message-ID: <20230822191822.337080-6-bvanassche@acm.org>
X-Mailer: git-send-email 2.42.0.rc1.204.g551eb34607-goog
In-Reply-To: <20230822191822.337080-1-bvanassche@acm.org>
References: <20230822191822.337080-1-bvanassche@acm.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

Triggering all code paths in scsi_call_prepare_resubmit() via manual
testing is difficult. Hence add unit tests for this function.

Cc: Martin K. Petersen <martin.petersen@oracle.com>
Cc: Damien Le Moal <dlemoal@kernel.org>
Cc: Christoph Hellwig <hch@lst.de>
Cc: Ming Lei <ming.lei@redhat.com>
Signed-off-by: Bart Van Assche <bvanassche@acm.org>
---
 drivers/scsi/Kconfig           |   2 +
 drivers/scsi/Kconfig.kunit     |   4 +
 drivers/scsi/Makefile          |   2 +
 drivers/scsi/Makefile.kunit    |   1 +
 drivers/scsi/scsi_error_test.c | 207 +++++++++++++++++++++++++++++++++
 5 files changed, 216 insertions(+)
 create mode 100644 drivers/scsi/Kconfig.kunit
 create mode 100644 drivers/scsi/Makefile.kunit
 create mode 100644 drivers/scsi/scsi_error_test.c

diff --git a/drivers/scsi/Kconfig b/drivers/scsi/Kconfig
index 4962ce989113..fc288f8fb800 100644
--- a/drivers/scsi/Kconfig
+++ b/drivers/scsi/Kconfig
@@ -232,6 +232,8 @@ config SCSI_SCAN_ASYNC
 	  Note that this setting also affects whether resuming from
 	  system suspend will be performed asynchronously.
 
+source "drivers/scsi/Kconfig.kunit"
+
 menu "SCSI Transports"
 	depends on SCSI
 
diff --git a/drivers/scsi/Kconfig.kunit b/drivers/scsi/Kconfig.kunit
new file mode 100644
index 000000000000..90984a6ec7cc
--- /dev/null
+++ b/drivers/scsi/Kconfig.kunit
@@ -0,0 +1,4 @@
+config SCSI_ERROR_TEST
+	tristate "scsi_error.c unit tests" if !KUNIT_ALL_TESTS
+	depends on SCSI && KUNIT
+	default KUNIT_ALL_TESTS
diff --git a/drivers/scsi/Makefile b/drivers/scsi/Makefile
index f055bfd54a68..1c5c3afb6c6e 100644
--- a/drivers/scsi/Makefile
+++ b/drivers/scsi/Makefile
@@ -168,6 +168,8 @@ scsi_mod-$(CONFIG_PM)		+= scsi_pm.o
 scsi_mod-$(CONFIG_SCSI_DH)	+= scsi_dh.o
 scsi_mod-$(CONFIG_BLK_DEV_BSG)	+= scsi_bsg.o
 
+include $(srctree)/drivers/scsi/Makefile.kunit
+
 hv_storvsc-y			:= storvsc_drv.o
 
 sd_mod-objs	:= sd.o
diff --git a/drivers/scsi/Makefile.kunit b/drivers/scsi/Makefile.kunit
new file mode 100644
index 000000000000..3e98053b2709
--- /dev/null
+++ b/drivers/scsi/Makefile.kunit
@@ -0,0 +1 @@
+obj-$(CONFIG_SCSI_ERROR_TEST) += scsi_error_test.o
diff --git a/drivers/scsi/scsi_error_test.c b/drivers/scsi/scsi_error_test.c
new file mode 100644
index 000000000000..be0d25e1fb57
--- /dev/null
+++ b/drivers/scsi/scsi_error_test.c
@@ -0,0 +1,207 @@
+// SPDX-License-Identifier: GPL-2.0-only
+/*
+ * Copyright 2023 Google LLC
+ */
+#include <kunit/test.h>
+#include <scsi/scsi_cmnd.h>
+#include <scsi/scsi_driver.h>
+#include "scsi_priv.h"
+
+static struct kunit *kunit_test;
+
+static bool uld_needs_prepare_resubmit(struct scsi_cmnd *cmd)
+{
+	struct request *rq = scsi_cmd_to_rq(cmd);
+
+	return !rq->q->limits.use_zone_write_lock &&
+		blk_rq_is_seq_zoned_write(rq);
+}
+
+static void uld_prepare_resubmit(struct list_head *cmd_list)
+{
+	/* This function must not be called. */
+	KUNIT_EXPECT_TRUE(kunit_test, false);
+}
+
+/*
+ * Verify that .eh_prepare_resubmit() is not called if use_zone_write_lock is
+ * true.
+ */
+static void test_prepare_resubmit1(struct kunit *test)
+{
+	static struct gendisk disk;
+	static struct request_queue q = {
+		.disk = &disk,
+		.limits = {
+			.driver_preserves_write_order = false,
+			.use_zone_write_lock = true,
+			.zoned = BLK_ZONED_HM,
+		}
+	};
+	static struct scsi_driver uld = {
+		.eh_needs_prepare_resubmit = uld_needs_prepare_resubmit,
+		.eh_prepare_resubmit = uld_prepare_resubmit,
+	};
+	static struct scsi_device dev = {
+		.request_queue = &q,
+		.sdev_gendev.driver = &uld.gendrv,
+	};
+	static struct rq_and_cmd {
+		struct request rq;
+		struct scsi_cmnd cmd;
+	} cmd1, cmd2;
+	LIST_HEAD(cmd_list);
+
+	BUILD_BUG_ON(scsi_cmd_to_rq(&cmd1.cmd) != &cmd1.rq);
+
+	disk.queue = &q;
+	cmd1 = (struct rq_and_cmd){
+		.rq = {
+			.q = &q,
+			.cmd_flags = REQ_OP_WRITE,
+			.__sector = 2,
+		},
+		.cmd.device = &dev,
+	};
+	cmd2 = cmd1;
+	cmd2.rq.__sector = 1;
+	list_add_tail(&cmd1.cmd.eh_entry, &cmd_list);
+	list_add_tail(&cmd2.cmd.eh_entry, &cmd_list);
+
+	KUNIT_EXPECT_EQ(test, list_count_nodes(&cmd_list), 2);
+	kunit_test = test;
+	scsi_call_prepare_resubmit(&cmd_list);
+	kunit_test = NULL;
+	KUNIT_EXPECT_EQ(test, list_count_nodes(&cmd_list), 2);
+	KUNIT_EXPECT_PTR_EQ(test, cmd_list.next, &cmd1.cmd.eh_entry);
+	KUNIT_EXPECT_PTR_EQ(test, cmd_list.next->next, &cmd2.cmd.eh_entry);
+}
+
+static struct scsi_driver *uld1, *uld2, *uld3;
+
+static void uld1_prepare_resubmit(struct list_head *cmd_list)
+{
+	struct scsi_cmnd *cmd;
+
+	KUNIT_EXPECT_EQ(kunit_test, list_count_nodes(cmd_list), 2);
+	list_for_each_entry(cmd, cmd_list, eh_entry)
+		KUNIT_EXPECT_PTR_EQ(kunit_test, scsi_cmd_to_driver(cmd), uld1);
+}
+
+static void uld2_prepare_resubmit(struct list_head *cmd_list)
+{
+	struct scsi_cmnd *cmd;
+
+	KUNIT_EXPECT_EQ(kunit_test, list_count_nodes(cmd_list), 2);
+	list_for_each_entry(cmd, cmd_list, eh_entry)
+		KUNIT_EXPECT_PTR_EQ(kunit_test, scsi_cmd_to_driver(cmd), uld2);
+}
+
+static void test_prepare_resubmit2(struct kunit *test)
+{
+	static struct gendisk disk;
+	static struct request_queue q = {
+		.disk = &disk,
+		.limits = {
+			.driver_preserves_write_order = true,
+			.use_zone_write_lock = false,
+			.zoned = BLK_ZONED_HM,
+		}
+	};
+	static struct rq_and_cmd {
+		struct request rq;
+		struct scsi_cmnd cmd;
+	} cmd1, cmd2, cmd3, cmd4, cmd5, cmd6;
+	static struct scsi_device dev1, dev2, dev3;
+	struct scsi_driver *uld;
+	LIST_HEAD(cmd_list);
+
+	BUILD_BUG_ON(scsi_cmd_to_rq(&cmd1.cmd) != &cmd1.rq);
+
+	uld = kzalloc(3 * sizeof(*uld), GFP_KERNEL);
+	uld1 = &uld[0];
+	uld1->eh_needs_prepare_resubmit = uld_needs_prepare_resubmit;
+	uld1->eh_prepare_resubmit = uld1_prepare_resubmit;
+	uld2 = &uld[1];
+	uld2->eh_needs_prepare_resubmit = uld_needs_prepare_resubmit;
+	uld2->eh_prepare_resubmit = uld2_prepare_resubmit;
+	uld3 = &uld[2];
+	disk.queue = &q;
+	dev1.sdev_gendev.driver = &uld1->gendrv;
+	dev1.request_queue = &q;
+	dev2.sdev_gendev.driver = &uld2->gendrv;
+	dev2.request_queue = &q;
+	dev3.sdev_gendev.driver = &uld3->gendrv;
+	dev3.request_queue = &q;
+	cmd1 = (struct rq_and_cmd){
+		.rq = {
+			.q = &q,
+			.cmd_flags = REQ_OP_WRITE,
+			.__sector = 3,
+		},
+		.cmd.device = &dev1,
+	};
+	cmd2 = cmd1;
+	cmd2.rq.__sector = 4;
+	cmd3 = (struct rq_and_cmd){
+		.rq = {
+			.q = &q,
+			.cmd_flags = REQ_OP_WRITE,
+			.__sector = 1,
+		},
+		.cmd.device = &dev2,
+	};
+	cmd4 = cmd3;
+	cmd4.rq.__sector = 2,
+	cmd5 = (struct rq_and_cmd){
+		.rq = {
+			.q = &q,
+			.cmd_flags = REQ_OP_WRITE,
+			.__sector = 5,
+		},
+		.cmd.device = &dev3,
+	};
+	cmd6 = cmd5;
+	cmd6.rq.__sector = 6;
+	list_add_tail(&cmd3.cmd.eh_entry, &cmd_list);
+	list_add_tail(&cmd1.cmd.eh_entry, &cmd_list);
+	list_add_tail(&cmd2.cmd.eh_entry, &cmd_list);
+	list_add_tail(&cmd5.cmd.eh_entry, &cmd_list);
+	list_add_tail(&cmd6.cmd.eh_entry, &cmd_list);
+	list_add_tail(&cmd4.cmd.eh_entry, &cmd_list);
+
+	KUNIT_EXPECT_EQ(test, list_count_nodes(&cmd_list), 6);
+	kunit_test = test;
+	scsi_call_prepare_resubmit(&cmd_list);
+	kunit_test = NULL;
+	KUNIT_EXPECT_EQ(test, list_count_nodes(&cmd_list), 6);
+	KUNIT_EXPECT_TRUE(test, uld1 < uld2);
+	KUNIT_EXPECT_TRUE(test, uld2 < uld3);
+	KUNIT_EXPECT_PTR_EQ(test, cmd_list.next, &cmd1.cmd.eh_entry);
+	KUNIT_EXPECT_PTR_EQ(test, cmd_list.next->next, &cmd2.cmd.eh_entry);
+	KUNIT_EXPECT_PTR_EQ(test, cmd_list.next->next->next,
+			    &cmd3.cmd.eh_entry);
+	KUNIT_EXPECT_PTR_EQ(test, cmd_list.next->next->next->next,
+			    &cmd4.cmd.eh_entry);
+	KUNIT_EXPECT_PTR_EQ(test, cmd_list.next->next->next->next->next,
+			    &cmd5.cmd.eh_entry);
+	KUNIT_EXPECT_PTR_EQ(test, cmd_list.next->next->next->next->next->next,
+			    &cmd6.cmd.eh_entry);
+	kfree(uld);
+}
+
+static struct kunit_case prepare_resubmit_test_cases[] = {
+	KUNIT_CASE(test_prepare_resubmit1),
+	KUNIT_CASE(test_prepare_resubmit2),
+	{}
+};
+
+static struct kunit_suite prepare_resubmit_test_suite = {
+	.name = "prepare_resubmit",
+	.test_cases = prepare_resubmit_test_cases,
+};
+kunit_test_suite(prepare_resubmit_test_suite);
+
+MODULE_DESCRIPTION("scsi_call_prepare_resubmit() unit tests");
+MODULE_AUTHOR("Bart Van Assche");
+MODULE_LICENSE("GPL");
