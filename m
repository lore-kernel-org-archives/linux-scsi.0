Return-Path: <linux-scsi-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 4E9CDCD37B0
	for <linux-scsi@archiver.kernel.org>; Mon, 18 Sep 2023 16:57:43 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231264AbjIRQ5q (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Mon, 18 Sep 2023 12:57:46 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49878 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231207AbjIRQ5j (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Mon, 18 Sep 2023 12:57:39 -0400
Received: from mail-oi1-f174.google.com (mail-oi1-f174.google.com [209.85.167.174])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5301891;
        Mon, 18 Sep 2023 09:57:33 -0700 (PDT)
Received: by mail-oi1-f174.google.com with SMTP id 5614622812f47-3a76d882080so3291020b6e.2;
        Mon, 18 Sep 2023 09:57:33 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1695056252; x=1695661052;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=lLb5i0/TR3kiC/m3HJ1Jjw6cNBZjizWe/WoYwXQLlOE=;
        b=XGwoXfSr9xA4hNcSH3pJyA4wIYvuJ0jxCc1mGZlcRkxBYXKxUWq1eCrq2CMEIkza0f
         SYwCWZ6AlckkHlpsLZsptt4rpYmpPOf+zc+rOOjf3vF01UN8h48L7Rp1dt3RyAL5Cnv/
         p6BUKWy/SgkwtltuLlg/Psz3Zl7mI6lB3uMGvpxatBjlEBddyG8hCSwh5ix7HssP1zNc
         HhFaCbGGrs52P97FHvEAs8Eoa0nE2f8doDvumwnekpXP/lJl6dW4+cSIrRPYAU402HPv
         EuH6oqa3Y6+Cex/WKoMLYH9CHAW9EJuqsynJwdq5DmoAmLW29IUzUCZESkQZQFOGfb/X
         LhGQ==
X-Gm-Message-State: AOJu0Yx/L3GJ3VQen17UqWCSNredpQiC78DqR94vpoG7ujVefYMWo5Fm
        Tcetu0uymIKEf+ievASlIh4=
X-Google-Smtp-Source: AGHT+IGpngGay8+qtbJlCeOP9HjKaFoYZnjduqQaD3CvhD5QAnmtNwYWJ4sn6zM75Wy3bxH/yomqaw==
X-Received: by 2002:a05:6808:182:b0:3a3:6e43:e681 with SMTP id w2-20020a056808018200b003a36e43e681mr10596616oic.58.1695056252503;
        Mon, 18 Sep 2023 09:57:32 -0700 (PDT)
Received: from bvanassche-linux.mtv.corp.google.com ([2620:15c:211:201:33e7:1437:5d00:8e3b])
        by smtp.gmail.com with ESMTPSA id p17-20020a639511000000b005740aa41237sm5658041pgd.74.2023.09.18.09.57.31
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 18 Sep 2023 09:57:31 -0700 (PDT)
From:   Bart Van Assche <bvanassche@acm.org>
To:     Jens Axboe <axboe@kernel.dk>
Cc:     linux-block@vger.kernel.org, linux-scsi@vger.kernel.org,
        "Martin K . Petersen" <martin.petersen@oracle.com>,
        Christoph Hellwig <hch@lst.de>,
        Bart Van Assche <bvanassche@acm.org>,
        Damien Le Moal <dlemoal@kernel.org>,
        Ming Lei <ming.lei@redhat.com>,
        "James E.J. Bottomley" <jejb@linux.ibm.com>
Subject: [PATCH v12 04/16] scsi: core: Introduce a mechanism for reordering requests in the error handler
Date:   Mon, 18 Sep 2023 09:55:43 -0700
Message-ID: <20230918165713.1598705-5-bvanassche@acm.org>
X-Mailer: git-send-email 2.42.0.459.ge4e396fd5e-goog
In-Reply-To: <20230918165713.1598705-1-bvanassche@acm.org>
References: <20230918165713.1598705-1-bvanassche@acm.org>
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
index c67cdcdc3ba8..2e42c7c51df7 100644
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
+		bool (*npr)(struct scsi_cmnd *);
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
