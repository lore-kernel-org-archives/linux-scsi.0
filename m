Return-Path: <linux-scsi-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 867E7C25B4A
	for <linux-scsi@archiver.kernel.org>; Mon, 23 Oct 2023 21:57:08 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233443AbjJWV5H (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Mon, 23 Oct 2023 17:57:07 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58918 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232738AbjJWV5D (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Mon, 23 Oct 2023 17:57:03 -0400
Received: from mail-pj1-f50.google.com (mail-pj1-f50.google.com [209.85.216.50])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2AE6310D8;
        Mon, 23 Oct 2023 14:57:01 -0700 (PDT)
Received: by mail-pj1-f50.google.com with SMTP id 98e67ed59e1d1-27d45f5658fso3030010a91.3;
        Mon, 23 Oct 2023 14:57:01 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1698098220; x=1698703020;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=H20lDRhK4GDyaMBBwpn1BdMOXepbGFTFy7qq+KEqdsE=;
        b=gy6EVAYX6Mx1yFWDVLX4QWY+v7lgzwue12T7u/pfRTA7ZOE6OG55jG7o0x2XE2pox/
         t7XoDFQSGxGmBpoAnfRaudywxFS5prjKViptX2sQD2GkWQ699127yUc8UDyejJfZL/K8
         jADuYZC3XXoYO4B1zZn/C9wBz8UVMnYRq6uYUUxEPQYupJ3CRtdW5ceRKldddNYwOHJs
         PUcNG4RoeqOuc2Hk9u1oWhAAtjHlKwSN6I0sp9tFd1GDEnZVaRu87dbLt+qBjAlvmFc3
         +NUJSY5BCs43mas7/wkO7NpE5SQrPcJK209M++8ifeLiOdCpJb1qXsVkcDqoKqGwY5zK
         yYzQ==
X-Gm-Message-State: AOJu0YyH3CgJjspj+cS7Gl/Iqc+YCaQCQuJsLenceke87uYQNXp8j9sE
        yM2L3kynftDwBFx0I85V9Pw=
X-Google-Smtp-Source: AGHT+IFj8GUj8LPTAdQXglCzvPWwsAuByUWUeLoVRF/+ro182nUvxiD+SRguSfOtgymzVY6i0GsK9A==
X-Received: by 2002:a17:90a:c087:b0:27e:277:3015 with SMTP id o7-20020a17090ac08700b0027e02773015mr10152039pjs.16.1698098220452;
        Mon, 23 Oct 2023 14:57:00 -0700 (PDT)
Received: from bvanassche-linux.mtv.corp.google.com ([2620:15c:211:201:14f9:170e:9304:1c4e])
        by smtp.gmail.com with ESMTPSA id b12-20020a17090acc0c00b0027d12b1e29dsm7851029pju.25.2023.10.23.14.56.59
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 23 Oct 2023 14:57:00 -0700 (PDT)
From:   Bart Van Assche <bvanassche@acm.org>
To:     Jens Axboe <axboe@kernel.dk>
Cc:     linux-block@vger.kernel.org, linux-scsi@vger.kernel.org,
        "Martin K . Petersen" <martin.petersen@oracle.com>,
        Christoph Hellwig <hch@lst.de>,
        Bart Van Assche <bvanassche@acm.org>,
        Damien Le Moal <dlemoal@kernel.org>,
        Ming Lei <ming.lei@redhat.com>,
        "James E.J. Bottomley" <jejb@linux.ibm.com>
Subject: [PATCH v14 06/19] scsi: core: Introduce a mechanism for reordering requests in the error handler
Date:   Mon, 23 Oct 2023 14:53:57 -0700
Message-ID: <20231023215638.3405959-7-bvanassche@acm.org>
X-Mailer: git-send-email 2.42.0.758.gaed0368e0e-goog
In-Reply-To: <20231023215638.3405959-1-bvanassche@acm.org>
References: <20231023215638.3405959-1-bvanassche@acm.org>
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
 drivers/scsi/scsi_error.c  | 51 ++++++++++++++++++++++++++++++++++++++
 drivers/scsi/scsi_priv.h   |  2 ++
 include/scsi/scsi_driver.h |  1 +
 include/scsi/scsi_host.h   |  6 +++++
 4 files changed, 60 insertions(+)

diff --git a/drivers/scsi/scsi_error.c b/drivers/scsi/scsi_error.c
index 7390131e7f0a..a9588188e8a6 100644
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
+void scsi_call_prepare_resubmit(struct Scsi_Host *shost,
+				struct list_head *done_q)
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
diff --git a/drivers/scsi/scsi_priv.h b/drivers/scsi/scsi_priv.h
index 3f0dfb97db6b..2caf4bcb072a 100644
--- a/drivers/scsi/scsi_priv.h
+++ b/drivers/scsi/scsi_priv.h
@@ -101,6 +101,8 @@ int scsi_eh_get_sense(struct list_head *work_q,
 		      struct list_head *done_q);
 bool scsi_noretry_cmd(struct scsi_cmnd *scmd);
 void scsi_eh_done(struct scsi_cmnd *scmd);
+void scsi_call_prepare_resubmit(struct Scsi_Host *shost,
+				struct list_head *done_q);
 
 /* scsi_lib.c */
 extern void scsi_device_unbusy(struct scsi_device *sdev, struct scsi_cmnd *cmd);
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
index 49f768d0ff37..3e07e5b1a70c 100644
--- a/include/scsi/scsi_host.h
+++ b/include/scsi/scsi_host.h
@@ -461,6 +461,12 @@ struct scsi_host_template {
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
