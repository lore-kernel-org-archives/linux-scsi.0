Return-Path: <linux-scsi-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 9566CC25B42
	for <linux-scsi@archiver.kernel.org>; Mon, 23 Oct 2023 21:57:17 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233548AbjJWV5R (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Mon, 23 Oct 2023 17:57:17 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40098 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233605AbjJWV5L (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Mon, 23 Oct 2023 17:57:11 -0400
Received: from mail-pj1-f45.google.com (mail-pj1-f45.google.com [209.85.216.45])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D505910D4;
        Mon, 23 Oct 2023 14:57:07 -0700 (PDT)
Received: by mail-pj1-f45.google.com with SMTP id 98e67ed59e1d1-27d1aee5aa1so2762582a91.0;
        Mon, 23 Oct 2023 14:57:07 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1698098227; x=1698703027;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=M4qqSCthtEfa+k90uThG1cM6ynrgRU2Y8NB50k0g/ic=;
        b=sXrqUNkf2bDd92zsT3v/SuYwOusB7i5NUI+kNwggd14lznFhhGQ9JBajs1LhmNN8px
         4E4pX23akal94hpYv86hbazTWFEmU1XVFzXRPUGTagfDRyTpLCOF0wx0KvQlyhFf7btL
         nmbc0agMrZxjAhcMYhnajr2/THmoswf27NmMRVYCfVQihc7WCznzSuGyI9Q7gghfpF6J
         QQ6p70L98Tk/+j/Egee1m4o+8eALQzo7e8+R32mpmi6nXCqnc00czohiuLmqq2I0zWKJ
         PscuGrn9NU/wKsVqi+5AIHlfTrvDBrsIs2zo0ts6NgxvGS3hxE5yj9DmHuw7qHegiJRq
         TaSA==
X-Gm-Message-State: AOJu0Yyb0aVFhz41Fz7P5L9M4Wab/OQy0Imn8nvLKxcffCiNkUukghTx
        4iZCqCBGZFRDhYG5x4yBP+4=
X-Google-Smtp-Source: AGHT+IG2bc8X7lilwVmwvpTiMyHw/gPAteWrTlhMz3iUhPz4C8LeY9OF1VFO+qHD1CvvmZLNR79FUw==
X-Received: by 2002:a17:90a:6fc5:b0:268:808:8e82 with SMTP id e63-20020a17090a6fc500b0026808088e82mr13849848pjk.1.1698098227093;
        Mon, 23 Oct 2023 14:57:07 -0700 (PDT)
Received: from bvanassche-linux.mtv.corp.google.com ([2620:15c:211:201:14f9:170e:9304:1c4e])
        by smtp.gmail.com with ESMTPSA id b12-20020a17090acc0c00b0027d12b1e29dsm7851029pju.25.2023.10.23.14.57.06
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 23 Oct 2023 14:57:06 -0700 (PDT)
From:   Bart Van Assche <bvanassche@acm.org>
To:     Jens Axboe <axboe@kernel.dk>
Cc:     linux-block@vger.kernel.org, linux-scsi@vger.kernel.org,
        "Martin K . Petersen" <martin.petersen@oracle.com>,
        Christoph Hellwig <hch@lst.de>,
        Bart Van Assche <bvanassche@acm.org>,
        Damien Le Moal <dlemoal@kernel.org>,
        Ming Lei <ming.lei@redhat.com>,
        "James E.J. Bottomley" <jejb@linux.ibm.com>
Subject: [PATCH v14 07/19] scsi: core: Add unit tests for scsi_call_prepare_resubmit()
Date:   Mon, 23 Oct 2023 14:53:58 -0700
Message-ID: <20231023215638.3405959-8-bvanassche@acm.org>
X-Mailer: git-send-email 2.42.0.758.gaed0368e0e-goog
In-Reply-To: <20231023215638.3405959-1-bvanassche@acm.org>
References: <20231023215638.3405959-1-bvanassche@acm.org>
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
 drivers/scsi/scsi_error.c      |   3 +
 drivers/scsi/scsi_error_test.c | 227 +++++++++++++++++++++++++++++++++
 6 files changed, 239 insertions(+)
 create mode 100644 drivers/scsi/Kconfig.kunit
 create mode 100644 drivers/scsi/Makefile.kunit
 create mode 100644 drivers/scsi/scsi_error_test.c

diff --git a/drivers/scsi/Kconfig b/drivers/scsi/Kconfig
index 695a57d894cd..734a5b10e94c 100644
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
diff --git a/drivers/scsi/scsi_error.c b/drivers/scsi/scsi_error.c
index a9588188e8a6..8b1eb637ffa8 100644
--- a/drivers/scsi/scsi_error.c
+++ b/drivers/scsi/scsi_error.c
@@ -2234,6 +2234,9 @@ void scsi_call_prepare_resubmit(struct Scsi_Host *shost,
 		list_splice(&uld_cmd_list, prev);
 	}
 }
+#if IS_MODULE(CONFIG_SCSI_ERROR_TEST)
+EXPORT_SYMBOL_GPL(scsi_call_prepare_resubmit);
+#endif
 
 /**
  * scsi_eh_flush_done_q - finish processed commands or retry them.
diff --git a/drivers/scsi/scsi_error_test.c b/drivers/scsi/scsi_error_test.c
new file mode 100644
index 000000000000..b9b0f2045ede
--- /dev/null
+++ b/drivers/scsi/scsi_error_test.c
@@ -0,0 +1,227 @@
+// SPDX-License-Identifier: GPL-2.0-only
+/*
+ * Copyright 2023 Google LLC
+ */
+#include <kunit/test.h>
+#include <linux/cleanup.h>
+#include <scsi/scsi_cmnd.h>
+#include <scsi/scsi_driver.h>
+#include <scsi/scsi_host.h>
+#include "scsi_priv.h"
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
+	static const struct scsi_host_template host_template;
+	static struct Scsi_Host host = {
+		.hostt = &host_template,
+	};
+	static struct scsi_device dev = {
+		.request_queue = &q,
+		.sdev_gendev.driver = &uld.gendrv,
+		.host = &host,
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
+	scsi_call_prepare_resubmit(&host, &cmd_list);
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
+	static const struct scsi_host_template host_template = {
+		.needs_prepare_resubmit = true,
+	};
+	static struct Scsi_Host host = {
+		.hostt = &host_template,
+	};
+	struct gendisk *disk __free(kfree) = NULL;
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
+	disk = kzalloc(sizeof(*disk), GFP_KERNEL);
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
+	cmd4->rq.__sector = 2,
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
