Return-Path: <linux-scsi-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 6233EC4167D
	for <linux-scsi@archiver.kernel.org>; Tue, 14 Nov 2023 21:18:31 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234058AbjKNVSc (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Tue, 14 Nov 2023 16:18:32 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50782 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234052AbjKNVSa (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Tue, 14 Nov 2023 16:18:30 -0500
Received: from mail-pl1-f180.google.com (mail-pl1-f180.google.com [209.85.214.180])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7E1DFC3;
        Tue, 14 Nov 2023 13:18:27 -0800 (PST)
Received: by mail-pl1-f180.google.com with SMTP id d9443c01a7336-1cc30bf9e22so1757245ad.1;
        Tue, 14 Nov 2023 13:18:27 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1699996707; x=1700601507;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=S4050Df3wVHg7KTGgS7dsrp4UQxEW02D6+iCI7Hka50=;
        b=f767J7XoN3AbLztMIm3l9a6cKPFzFsB31FImQOeVHq3XSGh8S3fbkop9fp5/C9jxia
         92k4kQw9uoJxA2wRZ0FfjS2nhoo8PvroAnt7Osvhj89vCH3sidkO49W39+tUj1Y6uYCB
         SvtG8WWoIRa8phQ3lF1286l9zVORRgVn09WYSbAFkPjDz8OKuIY6Q1V3aFwpVVsXiiV0
         sqe+xzgjEVOUwvrHLdSyNmmXZ270F2H9a0ZsNOLXnvu4bf/nxu0DonEDkiPQWEItweKH
         X6FRZxGbQJ28E35GKeo90VEsfeQy+K+p6ZZ4ze55Vt9FELaSlSPqHQNYeLFZUk7m6kSm
         c+xQ==
X-Gm-Message-State: AOJu0Yyd49OEGk/N1S7w6aFLILwEWsQ/sFGlEIscBaSCJq3G5Rl5OTje
        1tVbFBHZAx+3G/OafBurexw=
X-Google-Smtp-Source: AGHT+IFUEGs3c9fwcpw04I5xr9zni4VLuz/t0KQFPwlMkw82wMsPfhCbYmM+D4qGppL4TGN40sh2KQ==
X-Received: by 2002:a17:902:8216:b0:1ce:1b7b:8396 with SMTP id x22-20020a170902821600b001ce1b7b8396mr4018537pln.29.1699996706899;
        Tue, 14 Nov 2023 13:18:26 -0800 (PST)
Received: from bvanassche-linux.mtv.corp.google.com ([2620:0:1000:8411:2278:ad72:cefb:4d49])
        by smtp.gmail.com with ESMTPSA id ix7-20020a170902f80700b001c71ec1866fsm6169288plb.258.2023.11.14.13.18.25
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 14 Nov 2023 13:18:26 -0800 (PST)
From:   Bart Van Assche <bvanassche@acm.org>
To:     "Martin K . Petersen" <martin.petersen@oracle.com>
Cc:     linux-scsi@vger.kernel.org, linux-block@vger.kernel.org,
        Jens Axboe <axboe@kernel.dk>, Christoph Hellwig <hch@lst.de>,
        Bart Van Assche <bvanassche@acm.org>,
        Damien Le Moal <dlemoal@kernel.org>,
        Ming Lei <ming.lei@redhat.com>,
        "James E.J. Bottomley" <jejb@linux.ibm.com>
Subject: [PATCH v15 06/19] scsi: core: Introduce a mechanism for reordering requests in the error handler
Date:   Tue, 14 Nov 2023 13:16:14 -0800
Message-ID: <20231114211804.1449162-7-bvanassche@acm.org>
X-Mailer: git-send-email 2.43.0.rc0.421.g78406f8d94-goog
In-Reply-To: <20231114211804.1449162-1-bvanassche@acm.org>
References: <20231114211804.1449162-1-bvanassche@acm.org>
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

Reviewed-by: Damien Le Moal <dlemoal@kernel.org>
Cc: Martin K. Petersen <martin.petersen@oracle.com>
Cc: Christoph Hellwig <hch@lst.de>
Cc: Ming Lei <ming.lei@redhat.com>
Signed-off-by: Bart Van Assche <bvanassche@acm.org>
---
 drivers/scsi/scsi_error.c  | 51 ++++++++++++++++++++++++++++++++++++++
 include/scsi/scsi_driver.h |  1 +
 include/scsi/scsi_host.h   |  6 +++++
 3 files changed, 58 insertions(+)

diff --git a/drivers/scsi/scsi_error.c b/drivers/scsi/scsi_error.c
index 7390131e7f0a..4214d7b79b06 100644
--- a/drivers/scsi/scsi_error.c
+++ b/drivers/scsi/scsi_error.c
@@ -27,6 +27,7 @@
 #include <linux/blkdev.h>
 #include <linux/delay.h>
 #include <linux/jiffies.h>
+#include <linux/list_sort.h>
 
 #include <scsi/scsi.h>
 #include <scsi/scsi_cmnd.h>
@@ -2186,6 +2187,54 @@ void scsi_eh_ready_devs(struct Scsi_Host *shost,
 }
 EXPORT_SYMBOL_GPL(scsi_eh_ready_devs);
 
+/*
+ * Comparison function for sorting SCSI commands by ULD driver.
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
+static void scsi_call_prepare_resubmit(struct Scsi_Host *shost,
+				       struct list_head *done_q)
+{
+	struct scsi_cmnd *scmd, *next;
+
+	if (!shost->hostt->needs_prepare_resubmit)
+		return;
+
+	if (list_empty(done_q))
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
  * @shost:	SCSI host pointer.
@@ -2195,6 +2244,8 @@ void scsi_eh_flush_done_q(struct Scsi_Host *shost, struct list_head *done_q)
 {
 	struct scsi_cmnd *scmd, *next;
 
+	scsi_call_prepare_resubmit(shost, done_q);
+
 	list_for_each_entry_safe(scmd, next, done_q, eh_entry) {
 		list_del_init(&scmd->eh_entry);
 		if (scsi_device_online(scmd->device) &&
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
diff --git a/include/scsi/scsi_host.h b/include/scsi/scsi_host.h
index 3b907fc2ef08..150ae619c4d2 100644
--- a/include/scsi/scsi_host.h
+++ b/include/scsi/scsi_host.h
@@ -464,6 +464,12 @@ struct scsi_host_template {
 	/* The queuecommand callback may block. See also BLK_MQ_F_BLOCKING. */
 	unsigned queuecommand_may_block:1;
 
+	/*
+	 * The scsi_driver .eh_prepare_resubmit function must be called by
+	 * the SCSI error handler.
+	 */
+	unsigned needs_prepare_resubmit:1;
+
 	/*
 	 * Countdown for host blocking with no commands outstanding.
 	 */
