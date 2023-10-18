Return-Path: <linux-scsi-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C89D3CDB47E
	for <linux-scsi@archiver.kernel.org>; Wed, 18 Oct 2023 17:56:28 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232067AbjJRR42 (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Wed, 18 Oct 2023 13:56:28 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59022 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231929AbjJRR4X (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Wed, 18 Oct 2023 13:56:23 -0400
Received: from mail-oo1-f53.google.com (mail-oo1-f53.google.com [209.85.161.53])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1DC5711A;
        Wed, 18 Oct 2023 10:56:20 -0700 (PDT)
Received: by mail-oo1-f53.google.com with SMTP id 006d021491bc7-57babef76deso3939524eaf.0;
        Wed, 18 Oct 2023 10:56:20 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1697651779; x=1698256579;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=brIl8BbMZiSDDShSYZ1n3Fk5rZQIHjD8DD65DedRTmw=;
        b=Fl9NUTE74/pNiZBDIlBSU1UERFL8htZ6sGx5O6IaqvUMVoDhaVol+f0SHRw/saVt0N
         nnwZQwp8NhRP2bCz1LHbbkI9AJEpT7WBMGPmrDNrTvvxm2Rhmr43/xLTYT8oy7OBNtYI
         pS+QuPSfc5cdp/Igg87LGF5FmkaVaK+aErKmnPg4+NgBUAH6VfI0AnZOn6zJnf4B/Qif
         xILbJkB9MCkGW6O09IToB6JXrtT/9rUEAteyQV22bD5GE+qSUFsD2mTvMjdG3bB79cZL
         cY2hLafzvjY7m6zgPvdOqgAk36ila5xldCaY8DVrp0yNmBLUtYT6NPQbEmo0Gn8fmW7y
         n2UA==
X-Gm-Message-State: AOJu0Yw/ZkNaVp7s1qsHcWCbbMJBGBavDKly0h1TRkWDeAoO21czcyKa
        reo5qYXstmczdVV0XOXmX2U=
X-Google-Smtp-Source: AGHT+IHgGVNmPWS2hKiIIOxkKivicFdJ7ipNBuKrYq2+dmhFQ7KTO4Bkk9kctTlNIgaLUXcOsdrJ2w==
X-Received: by 2002:a05:6358:24a2:b0:168:9d60:e6b4 with SMTP id m34-20020a05635824a200b001689d60e6b4mr906058rwc.16.1697651779166;
        Wed, 18 Oct 2023 10:56:19 -0700 (PDT)
Received: from bvanassche-linux.mtv.corp.google.com ([2620:15c:211:201:66c1:dd00:1e1e:add3])
        by smtp.gmail.com with ESMTPSA id p15-20020aa7860f000000b00690cd981652sm3628612pfn.61.2023.10.18.10.56.18
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 18 Oct 2023 10:56:18 -0700 (PDT)
From:   Bart Van Assche <bvanassche@acm.org>
To:     Jens Axboe <axboe@kernel.dk>
Cc:     linux-block@vger.kernel.org, linux-scsi@vger.kernel.org,
        "Martin K . Petersen" <martin.petersen@oracle.com>,
        Christoph Hellwig <hch@lst.de>,
        Bart Van Assche <bvanassche@acm.org>,
        Damien Le Moal <dlemoal@kernel.org>,
        Ming Lei <ming.lei@redhat.com>,
        "James E.J. Bottomley" <jejb@linux.ibm.com>
Subject: [PATCH v13 05/18] scsi: core: Introduce a mechanism for reordering requests in the error handler
Date:   Wed, 18 Oct 2023 10:54:27 -0700
Message-ID: <20231018175602.2148415-6-bvanassche@acm.org>
X-Mailer: git-send-email 2.42.0.655.g421f12c284-goog
In-Reply-To: <20231018175602.2148415-1-bvanassche@acm.org>
References: <20231018175602.2148415-1-bvanassche@acm.org>
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
 drivers/scsi/scsi_error.c  | 72 ++++++++++++++++++++++++++++++++++++++
 drivers/scsi/scsi_priv.h   |  1 +
 include/scsi/scsi_driver.h |  2 ++
 3 files changed, 75 insertions(+)

diff --git a/drivers/scsi/scsi_error.c b/drivers/scsi/scsi_error.c
index c67cdcdc3ba8..c877db23a72d 100644
--- a/drivers/scsi/scsi_error.c
+++ b/drivers/scsi/scsi_error.c
@@ -27,6 +27,7 @@
 #include <linux/blkdev.h>
 #include <linux/delay.h>
 #include <linux/jiffies.h>
+#include <linux/list_sort.h>
 
 #include <scsi/scsi.h>
 #include <scsi/scsi_cmnd.h>
@@ -2186,6 +2187,75 @@ void scsi_eh_ready_devs(struct Scsi_Host *shost,
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
+		struct scsi_driver *uld;
+		bool (*npr)(struct scsi_cmnd *scmd);
+
+		if (!scmd->device)
+			continue;
+		uld = scsi_cmd_to_driver(scmd);
+		if (!uld)
+			continue;
+		npr = uld->eh_needs_prepare_resubmit;
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
+		struct scsi_driver *uld =
+			scmd->device ? scsi_cmd_to_driver(scmd) : NULL;
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
@@ -2194,6 +2264,8 @@ void scsi_eh_flush_done_q(struct list_head *done_q)
 {
 	struct scsi_cmnd *scmd, *next;
 
+	scsi_call_prepare_resubmit(done_q);
+
 	list_for_each_entry_safe(scmd, next, done_q, eh_entry) {
 		list_del_init(&scmd->eh_entry);
 		if (scsi_device_online(scmd->device) &&
diff --git a/drivers/scsi/scsi_priv.h b/drivers/scsi/scsi_priv.h
index 3f0dfb97db6b..64070e530c4d 100644
--- a/drivers/scsi/scsi_priv.h
+++ b/drivers/scsi/scsi_priv.h
@@ -101,6 +101,7 @@ int scsi_eh_get_sense(struct list_head *work_q,
 		      struct list_head *done_q);
 bool scsi_noretry_cmd(struct scsi_cmnd *scmd);
 void scsi_eh_done(struct scsi_cmnd *scmd);
+void scsi_call_prepare_resubmit(struct list_head *done_q);
 
 /* scsi_lib.c */
 extern void scsi_device_unbusy(struct scsi_device *sdev, struct scsi_cmnd *cmd);
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
