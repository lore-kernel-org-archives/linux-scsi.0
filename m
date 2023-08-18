Return-Path: <linux-scsi-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 7ED86EE499A
	for <linux-scsi@archiver.kernel.org>; Fri, 18 Aug 2023 19:46:08 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1379812AbjHRTpj (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Fri, 18 Aug 2023 15:45:39 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39328 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1379857AbjHRTpY (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Fri, 18 Aug 2023 15:45:24 -0400
Received: from mail-pl1-f182.google.com (mail-pl1-f182.google.com [209.85.214.182])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E7882421E;
        Fri, 18 Aug 2023 12:44:49 -0700 (PDT)
Received: by mail-pl1-f182.google.com with SMTP id d9443c01a7336-1bf3a2f4528so8112215ad.2;
        Fri, 18 Aug 2023 12:44:49 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1692387794; x=1692992594;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=CZv/GCTChROxyk79tHpawLiGp2hTN5F6+jFSRDwuk9c=;
        b=kkQrfTPGGTsruYZiNBhux9X32SF13eraCeSoefQr1h28fLsx6USFkeMy7WyqZ18MQ5
         ZWrLXRt65h/VghZ7F61JWGZV6QIgz5gzgAECRYKFIGzD17uAR6/KplX182dMrjAxEw0z
         DToF7MsBESe3DjkTsZqXAY4KipOMoAfZtK8vsPaCA1PrGEI/b5te/3eZ5uLPl8psGxcr
         oOxCXkPDim4k/cpDj3vzKh0OPpA8475u5DH+f3QhuRlhECFGKtNZ8FiGMNNaVp7AC3EA
         AP/XXS8XE6ckGddeoByOx1B6eWYsyTAMIIE3G+ZU5OdOZrr37m3wp+ih5ParXL5OJFX+
         PQ5w==
X-Gm-Message-State: AOJu0YxOrqoUry2On0fVUDjq2HAPzGaOsX4lGIDtpJQehsTgyW9hAEYD
        9fV2SSAxyxQW5u/43MrmvI8=
X-Google-Smtp-Source: AGHT+IEAR5Sk6Zy4lpk0jvURmNoj1FCAoxycnR2AmEian94uY9DRfAQ/rq6joO08n3jH8fL2z+FfMg==
X-Received: by 2002:a17:902:e78a:b0:1bb:dbec:40ba with SMTP id cp10-20020a170902e78a00b001bbdbec40bamr162933plb.16.1692387794095;
        Fri, 18 Aug 2023 12:43:14 -0700 (PDT)
Received: from bvanassche-linux.mtv.corp.google.com ([2620:15c:211:201:5012:5192:47aa:c304])
        by smtp.gmail.com with ESMTPSA id u16-20020a170903125000b001bb8be10a84sm2115801plh.304.2023.08.18.12.43.13
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 18 Aug 2023 12:43:13 -0700 (PDT)
From:   Bart Van Assche <bvanassche@acm.org>
To:     Jens Axboe <axboe@kernel.dk>
Cc:     linux-block@vger.kernel.org, linux-scsi@vger.kernel.org,
        "Martin K . Petersen" <martin.petersen@oracle.com>,
        Christoph Hellwig <hch@lst.de>,
        Bart Van Assche <bvanassche@acm.org>,
        Damien Le Moal <dlemoal@kernel.org>,
        Ming Lei <ming.lei@redhat.com>,
        "James E.J. Bottomley" <jejb@linux.ibm.com>
Subject: [PATCH v10 04/18] scsi: core: Introduce a mechanism for reordering requests in the error handler
Date:   Fri, 18 Aug 2023 12:34:07 -0700
Message-ID: <20230818193546.2014874-5-bvanassche@acm.org>
X-Mailer: git-send-email 2.42.0.rc1.204.g551eb34607-goog
In-Reply-To: <20230818193546.2014874-1-bvanassche@acm.org>
References: <20230818193546.2014874-1-bvanassche@acm.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

Introduce the .eh_needs_prepare_resubmit and the .eh_prepare_resubmit
function pointers in struct scsi_driver. Make the error handler call
.eh_prepare_resubmit() before resubmitting commands if any of the
.eh_needs_prepare_resubmit() invocations return true. A later patch
will use this functionality to sort SCSI commands by LBA from inside
the SCSI disk driver before these are resubmitted by the error handler.

Cc: Martin K. Petersen <martin.petersen@oracle.com>
Cc: Damien Le Moal <dlemoal@kernel.org>
Cc: Christoph Hellwig <hch@lst.de>
Cc: Ming Lei <ming.lei@redhat.com>
Signed-off-by: Bart Van Assche <bvanassche@acm.org>
---
 drivers/scsi/scsi_error.c  | 65 ++++++++++++++++++++++++++++++++++++++
 drivers/scsi/scsi_priv.h   |  1 +
 include/scsi/scsi_driver.h |  2 ++
 3 files changed, 68 insertions(+)

diff --git a/drivers/scsi/scsi_error.c b/drivers/scsi/scsi_error.c
index c67cdcdc3ba8..c4d817f044a0 100644
--- a/drivers/scsi/scsi_error.c
+++ b/drivers/scsi/scsi_error.c
@@ -27,6 +27,7 @@
 #include <linux/blkdev.h>
 #include <linux/delay.h>
 #include <linux/jiffies.h>
+#include <linux/list_sort.h>
 
 #include <scsi/scsi.h>
 #include <scsi/scsi_cmnd.h>
@@ -2186,6 +2187,68 @@ void scsi_eh_ready_devs(struct Scsi_Host *shost,
 }
 EXPORT_SYMBOL_GPL(scsi_eh_ready_devs);
 
+/*
+ * Returns true if .eh_prepare_resubmit should be called for the commands in
+ * @done_q.
+ */
+static bool scsi_needs_preparation(struct list_head *done_q)
+{
+	struct scsi_cmnd *scmd;
+
+	list_for_each_entry(scmd, done_q, eh_entry) {
+		struct scsi_driver *uld = scsi_cmd_to_driver(scmd);
+		bool (*npr)(struct scsi_cmnd *) = uld->eh_needs_prepare_resubmit;
+
+		if (npr && npr(scmd))
+			return true;
+	}
+
+	return false;
+}
+
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
+	if (!scsi_needs_preparation(done_q))
+		return;
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
@@ -2194,6 +2257,8 @@ void scsi_eh_flush_done_q(struct list_head *done_q)
 {
 	struct scsi_cmnd *scmd, *next;
 
+	scsi_call_prepare_resubmit(done_q);
+
 	list_for_each_entry_safe(scmd, next, done_q, eh_entry) {
 		list_del_init(&scmd->eh_entry);
 		if (scsi_device_online(scmd->device) &&
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
index 4ce1988b2ba0..00ffa470724a 100644
--- a/include/scsi/scsi_driver.h
+++ b/include/scsi/scsi_driver.h
@@ -18,6 +18,8 @@ struct scsi_driver {
 	int (*done)(struct scsi_cmnd *);
 	int (*eh_action)(struct scsi_cmnd *, int);
 	void (*eh_reset)(struct scsi_cmnd *);
+	bool (*eh_needs_prepare_resubmit)(struct scsi_cmnd *cmd);
+	void (*eh_prepare_resubmit)(struct list_head *cmd_list);
 };
 #define to_scsi_driver(drv) \
 	container_of((drv), struct scsi_driver, gendrv)
