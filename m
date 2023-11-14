Return-Path: <linux-scsi-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 830CAC4332F
	for <linux-scsi@archiver.kernel.org>; Tue, 14 Nov 2023 21:18:42 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234079AbjKNVSo (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Tue, 14 Nov 2023 16:18:44 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55070 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234078AbjKNVSk (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Tue, 14 Nov 2023 16:18:40 -0500
Received: from mail-pl1-f182.google.com (mail-pl1-f182.google.com [209.85.214.182])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 64996D3;
        Tue, 14 Nov 2023 13:18:35 -0800 (PST)
Received: by mail-pl1-f182.google.com with SMTP id d9443c01a7336-1cc5916d578so54649025ad.2;
        Tue, 14 Nov 2023 13:18:35 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1699996715; x=1700601515;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=zO/ChiiZm3CqAyVOLnE1irAFBX4OB6MDooFslSh0zhI=;
        b=ENsPewi+m603dtLn0cteJ62op7wcWo67r7gXL1cgopZblbVsri9/5k7yvrOACo4ud8
         Q2M6GInC28mN8iQ/K/oF0G9F3XmlMsV4iR7ZM4TYc4MNKggLNn2oBd4VNRZMzj44zAP0
         P7V8Y+NRAvJOPWNsoXjdJ7WnzPiGTso6mISXfwOl8nLrDC4p9xfVXr7rhVetMIadPs+e
         pRJnYvVVULLyKKOIoZ8svEh4cCa5skM6FzcKXz4t0Glg/GYQEch9dOxQ8FmcvllL/OVH
         mBZPTxRo1yIDrnKGgPXB2QkGOjC1esHfgnhlbIm3opFX2Eqk/S9NAsCr7NX1wVNZQ8PT
         8/Qg==
X-Gm-Message-State: AOJu0YydI6mAAzqP1wwC1IDp6GDS1kwlznHaedq+MQtr379I9PAA6opS
        jCQra1pNKJxWtW5t4E645+k=
X-Google-Smtp-Source: AGHT+IHD3X3stfLSj9IM+KAmQ+R21ZGjPqGzkswaha4DeQrZsb20e/40TRMyJkgTs/wNleJwW40e5w==
X-Received: by 2002:a17:903:32c5:b0:1ca:72f9:253a with SMTP id i5-20020a17090332c500b001ca72f9253amr3703563plr.23.1699996714729;
        Tue, 14 Nov 2023 13:18:34 -0800 (PST)
Received: from bvanassche-linux.mtv.corp.google.com ([2620:0:1000:8411:2278:ad72:cefb:4d49])
        by smtp.gmail.com with ESMTPSA id ix7-20020a170902f80700b001c71ec1866fsm6169288plb.258.2023.11.14.13.18.33
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 14 Nov 2023 13:18:34 -0800 (PST)
From:   Bart Van Assche <bvanassche@acm.org>
To:     "Martin K . Petersen" <martin.petersen@oracle.com>
Cc:     linux-scsi@vger.kernel.org, linux-block@vger.kernel.org,
        Jens Axboe <axboe@kernel.dk>, Christoph Hellwig <hch@lst.de>,
        Bart Van Assche <bvanassche@acm.org>,
        Damien Le Moal <dlemoal@kernel.org>,
        Ming Lei <ming.lei@redhat.com>,
        "James E.J. Bottomley" <jejb@linux.ibm.com>
Subject: [PATCH v15 07/19] scsi: core: Add unit tests for scsi_call_prepare_resubmit()
Date:   Tue, 14 Nov 2023 13:16:15 -0800
Message-ID: <20231114211804.1449162-8-bvanassche@acm.org>
X-Mailer: git-send-email 2.43.0.rc0.421.g78406f8d94-goog
In-Reply-To: <20231114211804.1449162-1-bvanassche@acm.org>
References: <20231114211804.1449162-1-bvanassche@acm.org>
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
 drivers/scsi/Kconfig           |   5 +
 drivers/scsi/scsi_error.c      |   4 +
 drivers/scsi/scsi_error_test.c | 233 +++++++++++++++++++++++++++++++++
 3 files changed, 242 insertions(+)
 create mode 100644 drivers/scsi/scsi_error_test.c

diff --git a/drivers/scsi/Kconfig b/drivers/scsi/Kconfig
index addac7fbe37b..2e57afdbbc4d 100644
--- a/drivers/scsi/Kconfig
+++ b/drivers/scsi/Kconfig
@@ -232,6 +232,11 @@ config SCSI_SCAN_ASYNC
 	  Note that this setting also affects whether resuming from
 	  system suspend will be performed asynchronously.
 
+config SCSI_ERROR_TEST
+	tristate "scsi_error.c unit tests" if !KUNIT_ALL_TESTS
+	depends on SCSI && KUNIT
+	default KUNIT_ALL_TESTS
+
 menu "SCSI Transports"
 	depends on SCSI
 
diff --git a/drivers/scsi/scsi_error.c b/drivers/scsi/scsi_error.c
index 4214d7b79b06..3a2643293abf 100644
--- a/drivers/scsi/scsi_error.c
+++ b/drivers/scsi/scsi_error.c
@@ -2621,3 +2621,7 @@ bool scsi_get_sense_info_fld(const u8 *sense_buffer, int sb_len,
 	}
 }
 EXPORT_SYMBOL(scsi_get_sense_info_fld);
+
+#ifdef CONFIG_SCSI_ERROR_TEST
+#include "scsi_error_test.c"
+#endif
diff --git a/drivers/scsi/scsi_error_test.c b/drivers/scsi/scsi_error_test.c
new file mode 100644
index 000000000000..46362766ad48
--- /dev/null
+++ b/drivers/scsi/scsi_error_test.c
@@ -0,0 +1,233 @@
+// SPDX-License-Identifier: GPL-2.0-only
+/*
+ * Copyright 2023 Google LLC
+ */
+#include <kunit/test.h>
+#include <linux/cleanup.h>
+#include <scsi/scsi_cmnd.h>
+#include <scsi/scsi_driver.h>
+#include <scsi/scsi_host.h>
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
+#define ALLOC_DISK(...) ALLOC(struct gendisk, __VA_ARGS__)
+
+#define ALLOC_Q(...) ALLOC(struct request_queue, __VA_ARGS__)
+
+#define ALLOC_SDEV(...) ALLOC(struct scsi_device, __VA_ARGS__)
+
+#define ALLOC_CMD(...) ALLOC(struct rq_and_cmd, __VA_ARGS__)
+
+static struct kunit *kunit_test;
+
+static void uld_prepare_resubmit(struct list_head *cmd_list)
+{
+	/* This function must not be called. */
+	KUNIT_EXPECT_TRUE(kunit_test, false);
+}
+
+/*
+ * Verify that .eh_prepare_resubmit() is not called if needs_prepare_resubmit is
+ * false.
+ */
+static void test_prepare_resubmit1(struct kunit *test)
+{
+	struct gendisk *disk __free(kfree) = ALLOC_DISK();
+	struct request_queue *q __free(kfree) = ALLOC_Q(
+		.limits = {
+			.driver_preserves_write_order = false,
+			.use_zone_write_lock = true,
+			.zoned = BLK_ZONED_HM,
+		}
+	);
+	static struct scsi_driver uld = {
+		.eh_prepare_resubmit = uld_prepare_resubmit,
+	};
+	static const struct scsi_host_template host_template;
+	static struct Scsi_Host host = {
+		.hostt = &host_template,
+	};
+	struct scsi_device *dev __free(kfree) = ALLOC_SDEV(
+		.request_queue = q,
+		.sdev_gendev.driver = &uld.gendrv,
+		.host = &host,
+	);
+	struct rq_and_cmd {
+		struct request rq;
+		struct scsi_cmnd cmd;
+	} *cmd1 __free(kfree) = NULL, *cmd2 __free(kfree);
+	LIST_HEAD(cmd_list);
+
+	BUILD_BUG_ON(scsi_cmd_to_rq(&cmd1->cmd) != &cmd1->rq);
+
+	q->disk = disk;
+	disk->queue = q;
+	cmd1 = ALLOC_CMD(
+		.rq = {
+			.q = q,
+			.cmd_flags = REQ_OP_WRITE,
+			.__sector = 2,
+		},
+		.cmd.device = dev,
+	);
+	cmd2 = ALLOC_CMD(
+		.rq = {
+			.q = q,
+			.cmd_flags = REQ_OP_WRITE,
+			.__sector = 1,
+		},
+		.cmd.device = dev,
+	);
+	list_add_tail(&cmd1->cmd.eh_entry, &cmd_list);
+	list_add_tail(&cmd2->cmd.eh_entry, &cmd_list);
+
+	KUNIT_EXPECT_EQ(test, list_count_nodes(&cmd_list), 2);
+	kunit_test = test;
+	scsi_call_prepare_resubmit(&host, &cmd_list);
+	kunit_test = NULL;
+	KUNIT_EXPECT_EQ(test, list_count_nodes(&cmd_list), 2);
+	KUNIT_EXPECT_PTR_EQ(test, cmd_list.next, &cmd1->cmd.eh_entry);
+	KUNIT_EXPECT_PTR_EQ(test, cmd_list.next->next, &cmd2->cmd.eh_entry);
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
+	static const struct scsi_host_template host_template = {
+		.needs_prepare_resubmit = true,
+	};
+	static struct Scsi_Host host = {
+		.hostt = &host_template,
+	};
+	struct gendisk *disk __free(kfree);
+	struct request_queue *q __free(kfree) =
+		ALLOC_Q(.limits = {
+				.driver_preserves_write_order = true,
+				.use_zone_write_lock = false,
+				.zoned = BLK_ZONED_HM,
+			});
+	struct rq_and_cmd {
+		struct request rq;
+		struct scsi_cmnd cmd;
+	} *cmd1 __free(kfree), *cmd2 __free(kfree), *cmd3 __free(kfree),
+		*cmd4 __free(kfree), *cmd5 __free(kfree), *cmd6 __free(kfree);
+	struct scsi_device *dev1 __free(kfree), *dev2 __free(kfree),
+		*dev3 __free(kfree);
+	struct scsi_driver *uld __free(kfree);
+	LIST_HEAD(cmd_list);
+
+	BUILD_BUG_ON(scsi_cmd_to_rq(&cmd1->cmd) != &cmd1->rq);
+
+	uld = kzalloc(3 * sizeof(*uld), GFP_KERNEL);
+	uld1 = &uld[0];
+	uld1->eh_prepare_resubmit = uld1_prepare_resubmit;
+	uld2 = &uld[1];
+	uld2->eh_prepare_resubmit = uld2_prepare_resubmit;
+	uld3 = &uld[2];
+	disk = ALLOC_DISK();
+	disk->queue = q;
+	q->disk = disk;
+	dev1 = ALLOC_SDEV(.sdev_gendev.driver = &uld1->gendrv,
+			  .request_queue = q, .host = &host);
+	dev2 = ALLOC_SDEV(.sdev_gendev.driver = &uld2->gendrv,
+			  .request_queue = q, .host = &host);
+	dev3 = ALLOC_SDEV(.sdev_gendev.driver = &uld3->gendrv,
+			  .request_queue = q, .host = &host);
+	cmd1 = ALLOC_CMD(
+		.rq = {
+			.q = q,
+			.cmd_flags = REQ_OP_WRITE,
+			.__sector = 3,
+		},
+		.cmd.device = dev1,
+			 );
+	cmd2 = ALLOC_CMD();
+	*cmd2 = *cmd1;
+	cmd2->rq.__sector = 4;
+	cmd3 = ALLOC_CMD(
+		.rq = {
+			.q = q,
+			.cmd_flags = REQ_OP_WRITE,
+			.__sector = 1,
+		},
+		.cmd.device = dev2,
+			 );
+	cmd4 = kmemdup(cmd3, sizeof(*cmd3), GFP_KERNEL);
+	cmd4->rq.__sector = 2;
+	cmd5 = ALLOC_CMD(
+		.rq = {
+			.q = q,
+			.cmd_flags = REQ_OP_WRITE,
+			.__sector = 5,
+		},
+		.cmd.device = dev3,
+			 );
+	cmd6 = kmemdup(cmd5, sizeof(*cmd3), GFP_KERNEL);
+	cmd6->rq.__sector = 6;
+	list_add_tail(&cmd3->cmd.eh_entry, &cmd_list);
+	list_add_tail(&cmd1->cmd.eh_entry, &cmd_list);
+	list_add_tail(&cmd2->cmd.eh_entry, &cmd_list);
+	list_add_tail(&cmd5->cmd.eh_entry, &cmd_list);
+	list_add_tail(&cmd6->cmd.eh_entry, &cmd_list);
+	list_add_tail(&cmd4->cmd.eh_entry, &cmd_list);
+
+	KUNIT_EXPECT_EQ(test, list_count_nodes(&cmd_list), 6);
+	kunit_test = test;
+	scsi_call_prepare_resubmit(&host, &cmd_list);
+	kunit_test = NULL;
+	KUNIT_EXPECT_EQ(test, list_count_nodes(&cmd_list), 6);
+	KUNIT_EXPECT_TRUE(test, uld1 < uld2);
+	KUNIT_EXPECT_TRUE(test, uld2 < uld3);
+	KUNIT_EXPECT_PTR_EQ(test, cmd_list.next, &cmd1->cmd.eh_entry);
+	KUNIT_EXPECT_PTR_EQ(test, cmd_list.next->next, &cmd2->cmd.eh_entry);
+	KUNIT_EXPECT_PTR_EQ(test, cmd_list.next->next->next,
+			    &cmd3->cmd.eh_entry);
+	KUNIT_EXPECT_PTR_EQ(test, cmd_list.next->next->next->next,
+			    &cmd4->cmd.eh_entry);
+	KUNIT_EXPECT_PTR_EQ(test, cmd_list.next->next->next->next->next,
+			    &cmd5->cmd.eh_entry);
+	KUNIT_EXPECT_PTR_EQ(test, cmd_list.next->next->next->next->next->next,
+			    &cmd6->cmd.eh_entry);
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
