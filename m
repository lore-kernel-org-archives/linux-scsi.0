Return-Path: <linux-scsi-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 6BDBAC25B78
	for <linux-scsi@archiver.kernel.org>; Wed, 16 Aug 2023 19:55:54 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1345934AbjHPTzY (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Wed, 16 Aug 2023 15:55:24 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39038 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1345936AbjHPTzO (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Wed, 16 Aug 2023 15:55:14 -0400
Received: from mail-pg1-f169.google.com (mail-pg1-f169.google.com [209.85.215.169])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1C568E55;
        Wed, 16 Aug 2023 12:55:13 -0700 (PDT)
Received: by mail-pg1-f169.google.com with SMTP id 41be03b00d2f7-564b6276941so5223603a12.3;
        Wed, 16 Aug 2023 12:55:13 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1692215712; x=1692820512;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=cNIT/AH6U/3H/4Easw6T2cqeSY/Vrxw0YPM041/czqs=;
        b=ievchkL3U/Y/Eys91y936vnKWGoaCZRsB5PAT1c6OvIAnXW7c5DqBBE1Lhu8zO0vFx
         6L98UqA3n7SMzasS125bHxuPqkZcqBN2pnLM6C/hv09Nx+YRt7Y1P03Z2h3V4VXiSOSH
         xEfeXExakcUwpJX/mH+vPtmGIl34UcEvZLg26CWt7Xz/Blw0sudd0aY6rhN/lVKlDwSv
         c9PPIbMRWALOvtldfMC9uIGMxZvKzaBewgsZ0Hhz3VbjB6lTeI+R5n5K/Gw9gAjKoB+m
         mQxDccOEfVMZglYCmuBuWfC4rIr4d8Ztr2IaegTC1Vra7NTj/2Vjb/g5ZLi9o8TWK87C
         92qg==
X-Gm-Message-State: AOJu0YxIbjBqdsTOr+MlyV3xKQxckGMNBveHfCj+Erb9qMrB62DGdM6d
        b8X4zpLlGY1dLRch6cm4IIY=
X-Google-Smtp-Source: AGHT+IEiuGHtdFRuOftauodyOz06rD1vZTz9TKKjq3T/+q+9r8Ywc+LI1yVT2z48oyqaNK4VTEpKUA==
X-Received: by 2002:a05:6a20:13da:b0:132:8620:8d21 with SMTP id ho26-20020a056a2013da00b0013286208d21mr2943145pzc.58.1692215712405;
        Wed, 16 Aug 2023 12:55:12 -0700 (PDT)
Received: from bvanassche-linux.mtv.corp.google.com ([2620:15c:211:201:7141:e456:f574:7de0])
        by smtp.gmail.com with ESMTPSA id r26-20020a62e41a000000b0068890c19c49sm1588508pfh.180.2023.08.16.12.55.11
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 16 Aug 2023 12:55:11 -0700 (PDT)
From:   Bart Van Assche <bvanassche@acm.org>
To:     Jens Axboe <axboe@kernel.dk>
Cc:     linux-block@vger.kernel.org, linux-scsi@vger.kernel.org,
        "Martin K . Petersen" <martin.petersen@oracle.com>,
        Christoph Hellwig <hch@lst.de>,
        Bart Van Assche <bvanassche@acm.org>,
        Damien Le Moal <dlemoal@kernel.org>,
        Ming Lei <ming.lei@redhat.com>,
        "James E.J. Bottomley" <jejb@linux.ibm.com>
Subject: [PATCH v9 05/17] scsi: core: Add unit tests for scsi_call_prepare_resubmit()
Date:   Wed, 16 Aug 2023 12:53:17 -0700
Message-ID: <20230816195447.3703954-6-bvanassche@acm.org>
X-Mailer: git-send-email 2.41.0.694.ge786442a9b-goog
In-Reply-To: <20230816195447.3703954-1-bvanassche@acm.org>
References: <20230816195447.3703954-1-bvanassche@acm.org>
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
 drivers/scsi/scsi_error_test.c | 196 +++++++++++++++++++++++++++++++++
 5 files changed, 205 insertions(+)
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
index 000000000000..c35ac628065e
--- /dev/null
+++ b/drivers/scsi/scsi_error_test.c
@@ -0,0 +1,196 @@
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
+	uld = kzalloc(3 * sizeof(uld), GFP_KERNEL);
+	uld1 = &uld[0];
+	uld1->eh_prepare_resubmit = uld1_prepare_resubmit;
+	uld2 = &uld[1];
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
