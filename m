Return-Path: <linux-scsi-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 1322BC0015E
	for <linux-scsi@archiver.kernel.org>; Fri, 11 Aug 2023 21:36:21 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236949AbjHKVgU (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Fri, 11 Aug 2023 17:36:20 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49402 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236452AbjHKVgT (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Fri, 11 Aug 2023 17:36:19 -0400
Received: from mail-pl1-f171.google.com (mail-pl1-f171.google.com [209.85.214.171])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9065B2684;
        Fri, 11 Aug 2023 14:36:18 -0700 (PDT)
Received: by mail-pl1-f171.google.com with SMTP id d9443c01a7336-1bc8045e09dso18139305ad.0;
        Fri, 11 Aug 2023 14:36:18 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1691789778; x=1692394578;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=VejU/kV71hFZ1/4fu0TIDkfHCBIfE8lpTp30B2bYt/c=;
        b=Wdq+6oNbkeBtBHaJVftwHBs/Aa41Eb5gyITAwt8B3gmbg3upjfBxWz1gZrax0Ci+si
         TySDfRCeea3Zh9oNIyxbvebLUZsnjUFu2Goc3uwNIxA4kWfdMra5l9Fw7v6FPlI2IhIT
         YoX5gLBa5ZVzcO35Tw1DC8J1Q3cRGWpC78pa5m98h+D7LXBqmj4x2R7iKV4S/SNb6nEW
         cb/hgXSy3Upde4P4E8cESG3Y6/PJYfOtu+dcIPdMdjJhb0fsnFHTo3JE5B3yhpZj3Ene
         HOARnLIIWe5kgkS/fazhxzOnsg6TAaP59PUSRCmr4prnX5GFEX9iQAwzlGx4RpeJMlTg
         mzsQ==
X-Gm-Message-State: AOJu0YyxnbZ3JIzLwGKdjQogUet8yIT1/cGz3WDZG+0/JEsjnSMXOPv+
        mvZRhrHPW9x0eWCRBcAhyQc=
X-Google-Smtp-Source: AGHT+IHs3Q18FSrv8FFeF9SEcE57+rV8IYmFvxLSxTlFa2KQNn/9UHl/VJTRDyeDtg6e2uIuG2BnOA==
X-Received: by 2002:a17:902:f7ce:b0:1bd:b05c:c752 with SMTP id h14-20020a170902f7ce00b001bdb05cc752mr2783107plw.26.1691789777931;
        Fri, 11 Aug 2023 14:36:17 -0700 (PDT)
Received: from bvanassche-linux.mtv.corp.google.com ([2620:15c:211:201:cdd8:4c3:2f3c:adea])
        by smtp.gmail.com with ESMTPSA id c10-20020a170903234a00b001b89c313185sm4394865plh.205.2023.08.11.14.36.17
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 11 Aug 2023 14:36:17 -0700 (PDT)
From:   Bart Van Assche <bvanassche@acm.org>
To:     Jens Axboe <axboe@kernel.dk>
Cc:     linux-block@vger.kernel.org, linux-scsi@vger.kernel.org,
        "Martin K . Petersen" <martin.petersen@oracle.com>,
        Christoph Hellwig <hch@lst.de>,
        Bart Van Assche <bvanassche@acm.org>,
        Damien Le Moal <dlemoal@kernel.org>,
        Ming Lei <ming.lei@redhat.com>,
        "James E.J. Bottomley" <jejb@linux.ibm.com>
Subject: [PATCH v8 3/9] scsi: core: Call .eh_prepare_resubmit() before resubmitting
Date:   Fri, 11 Aug 2023 14:35:37 -0700
Message-ID: <20230811213604.548235-4-bvanassche@acm.org>
X-Mailer: git-send-email 2.41.0.640.ga95def55d0-goog
In-Reply-To: <20230811213604.548235-1-bvanassche@acm.org>
References: <20230811213604.548235-1-bvanassche@acm.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

Make the error handler call .eh_prepare_resubmit() before resubmitting
commands. A later patch will use this functionality to sort SCSI
commands per LBA from inside the SCSI disk driver.

Cc: Martin K. Petersen <martin.petersen@oracle.com>
Cc: Damien Le Moal <dlemoal@kernel.org>
Cc: Christoph Hellwig <hch@lst.de>
Cc: Ming Lei <ming.lei@redhat.com>
Signed-off-by: Bart Van Assche <bvanassche@acm.org>
---
 drivers/scsi/Kconfig           |  2 +
 drivers/scsi/Kconfig.kunit     |  4 ++
 drivers/scsi/Makefile          |  2 +
 drivers/scsi/Makefile.kunit    |  1 +
 drivers/scsi/scsi_error.c      | 43 ++++++++++++++++
 drivers/scsi/scsi_error_test.c | 92 ++++++++++++++++++++++++++++++++++
 drivers/scsi/scsi_priv.h       |  1 +
 include/scsi/scsi_driver.h     |  1 +
 8 files changed, 146 insertions(+)
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
index 000000000000..68e3d90d49e9
--- /dev/null
+++ b/drivers/scsi/Kconfig.kunit
@@ -0,0 +1,4 @@
+config SCSI_ERROR_TEST
+	tristate "scsi_error.c unit tests" if !KUNIT_ALL_TESTS
+	depends on SCSI_MOD && KUNIT
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
index c67cdcdc3ba8..0d7835bdc8af 100644
--- a/drivers/scsi/scsi_error.c
+++ b/drivers/scsi/scsi_error.c
@@ -27,6 +27,7 @@
 #include <linux/blkdev.h>
 #include <linux/delay.h>
 #include <linux/jiffies.h>
+#include <linux/list_sort.h>
 
 #include <scsi/scsi.h>
 #include <scsi/scsi_cmnd.h>
@@ -2186,6 +2187,46 @@ void scsi_eh_ready_devs(struct Scsi_Host *shost,
 }
 EXPORT_SYMBOL_GPL(scsi_eh_ready_devs);
 
+/*
+ * Comparison function that allows to sort SCSI commands by ULD driver.
+ */
+static int scsi_cmp_uld(void *priv, const struct list_head *_a,
+			const struct list_head *_b)
+{
+	struct scsi_cmnd *a = list_entry(_a, typeof(*a), eh_entry);
+	struct scsi_cmnd *b = list_entry(_b, typeof(*b), eh_entry);
+
+	/* See also the comment above the list_sort() definition. */
+	return scsi_cmd_to_driver(a) > scsi_cmd_to_driver(b);
+}
+
+void scsi_call_prepare_resubmit(struct list_head *done_q)
+{
+	struct scsi_cmnd *scmd, *next;
+
+	/* Sort pending SCSI commands by ULD. */
+	list_sort(NULL, done_q, scsi_cmp_uld);
+
+	/*
+	 * Call .eh_prepare_resubmit for each range of commands with identical
+	 * ULD driver pointer.
+	 */
+	list_for_each_entry_safe(scmd, next, done_q, eh_entry) {
+		struct scsi_driver *uld = scsi_cmd_to_driver(scmd);
+		struct list_head *prev, uld_cmd_list;
+
+		while (&next->eh_entry != done_q &&
+		       scsi_cmd_to_driver(next) == uld)
+			next = list_next_entry(next, eh_entry);
+		if (!uld->eh_prepare_resubmit)
+			continue;
+		prev = scmd->eh_entry.prev;
+		list_cut_position(&uld_cmd_list, prev, next->eh_entry.prev);
+		uld->eh_prepare_resubmit(&uld_cmd_list);
+		list_splice(&uld_cmd_list, prev);
+	}
+}
+
 /**
  * scsi_eh_flush_done_q - finish processed commands or retry them.
  * @done_q:	list_head of processed commands.
@@ -2194,6 +2235,8 @@ void scsi_eh_flush_done_q(struct list_head *done_q)
 {
 	struct scsi_cmnd *scmd, *next;
 
+	scsi_call_prepare_resubmit(done_q);
+
 	list_for_each_entry_safe(scmd, next, done_q, eh_entry) {
 		list_del_init(&scmd->eh_entry);
 		if (scsi_device_online(scmd->device) &&
diff --git a/drivers/scsi/scsi_error_test.c b/drivers/scsi/scsi_error_test.c
new file mode 100644
index 000000000000..fd616527f726
--- /dev/null
+++ b/drivers/scsi/scsi_error_test.c
@@ -0,0 +1,92 @@
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
+static void test_prepare_resubmit(struct kunit *test)
+{
+	static struct scsi_cmnd cmd1, cmd2, cmd3, cmd4, cmd5, cmd6;
+	static struct scsi_device dev1, dev2, dev3;
+	struct scsi_driver *uld;
+	LIST_HEAD(cmd_list);
+
+	uld = kzalloc(3 * sizeof(uld), GFP_KERNEL);
+	uld1 = &uld[0];
+	uld1->eh_prepare_resubmit = uld1_prepare_resubmit;
+	uld2 = &uld[1];
+	uld2->eh_prepare_resubmit = uld2_prepare_resubmit;
+	uld3 = &uld[2];
+	dev1.sdev_gendev.driver = &uld1->gendrv;
+	dev2.sdev_gendev.driver = &uld2->gendrv;
+	dev3.sdev_gendev.driver = &uld3->gendrv;
+	cmd1.device = &dev1;
+	cmd2.device = &dev1;
+	cmd3.device = &dev2;
+	cmd4.device = &dev2;
+	cmd5.device = &dev3;
+	cmd6.device = &dev3;
+	list_add_tail(&cmd1.eh_entry, &cmd_list);
+	list_add_tail(&cmd3.eh_entry, &cmd_list);
+	list_add_tail(&cmd5.eh_entry, &cmd_list);
+	list_add_tail(&cmd2.eh_entry, &cmd_list);
+	list_add_tail(&cmd4.eh_entry, &cmd_list);
+	list_add_tail(&cmd6.eh_entry, &cmd_list);
+
+	KUNIT_EXPECT_EQ(test, list_count_nodes(&cmd_list), 6);
+	kunit_test = test;
+	scsi_call_prepare_resubmit(&cmd_list);
+	kunit_test = NULL;
+	KUNIT_EXPECT_EQ(test, list_count_nodes(&cmd_list), 6);
+	KUNIT_EXPECT_TRUE(test, uld1 < uld2);
+	KUNIT_EXPECT_TRUE(test, uld2 < uld3);
+	KUNIT_EXPECT_PTR_EQ(test, cmd_list.next, &cmd1.eh_entry);
+	KUNIT_EXPECT_PTR_EQ(test, cmd_list.next->next, &cmd2.eh_entry);
+	KUNIT_EXPECT_PTR_EQ(test, cmd_list.next->next->next, &cmd3.eh_entry);
+	KUNIT_EXPECT_PTR_EQ(test, cmd_list.next->next->next->next,
+			    &cmd4.eh_entry);
+	KUNIT_EXPECT_PTR_EQ(test, cmd_list.next->next->next->next->next,
+			    &cmd5.eh_entry);
+	KUNIT_EXPECT_PTR_EQ(test, cmd_list.next->next->next->next->next->next,
+			    &cmd6.eh_entry);
+	kfree(uld);
+}
+
+static struct kunit_case prepare_resubmit_test_cases[] = {
+	KUNIT_CASE(test_prepare_resubmit),
+	{}
+};
+
+static struct kunit_suite prepare_resubmit_test_suite = {
+	.name = "prepare_resubmit",
+	.test_cases = prepare_resubmit_test_cases,
+};
+kunit_test_suite(prepare_resubmit_test_suite);
+
+MODULE_AUTHOR("Bart Van Assche");
+MODULE_LICENSE("GPL");
diff --git a/drivers/scsi/scsi_priv.h b/drivers/scsi/scsi_priv.h
index f42388ecb024..df4af4645430 100644
--- a/drivers/scsi/scsi_priv.h
+++ b/drivers/scsi/scsi_priv.h
@@ -101,6 +101,7 @@ int scsi_eh_get_sense(struct list_head *work_q,
 		      struct list_head *done_q);
 bool scsi_noretry_cmd(struct scsi_cmnd *scmd);
 void scsi_eh_done(struct scsi_cmnd *scmd);
+void scsi_call_prepare_resubmit(struct list_head *done_q);
 
 /* scsi_lib.c */
 extern int scsi_maybe_unblock_host(struct scsi_device *sdev);
diff --git a/include/scsi/scsi_driver.h b/include/scsi/scsi_driver.h
index 4ce1988b2ba0..2b11be896eee 100644
--- a/include/scsi/scsi_driver.h
+++ b/include/scsi/scsi_driver.h
@@ -18,6 +18,7 @@ struct scsi_driver {
 	int (*done)(struct scsi_cmnd *);
 	int (*eh_action)(struct scsi_cmnd *, int);
 	void (*eh_reset)(struct scsi_cmnd *);
+	void (*eh_prepare_resubmit)(struct list_head *cmd_list);
 };
 #define to_scsi_driver(drv) \
 	container_of((drv), struct scsi_driver, gendrv)
