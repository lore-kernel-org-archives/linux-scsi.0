Return-Path: <linux-scsi-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 53ABCC25B42
	for <linux-scsi@archiver.kernel.org>; Mon, 23 Oct 2023 21:57:21 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233605AbjJWV5S (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Mon, 23 Oct 2023 17:57:18 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40126 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233620AbjJWV5M (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Mon, 23 Oct 2023 17:57:12 -0400
Received: from mail-pf1-f180.google.com (mail-pf1-f180.google.com [209.85.210.180])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3381B10DC;
        Mon, 23 Oct 2023 14:57:09 -0700 (PDT)
Received: by mail-pf1-f180.google.com with SMTP id d2e1a72fcca58-6b7f0170d7bso3631408b3a.2;
        Mon, 23 Oct 2023 14:57:09 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1698098228; x=1698703028;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=+MwF9wgkw4wG6rVgsbprmoEZnKhhCCis6ECe24Y7w3U=;
        b=gUktnSOhq/AFfjSf2ZeRR91f2qGhA8S2iZDxvXxBAiByqVllzCsQd7lRw1zK6XPRRZ
         PLYBuVTUGJhGm3DHiOZHl598fnut0E1PVsQxlRLQ/oWIHdH5CBlXPeigdwUcH4z86nI6
         RxfVGGXJYAHu6EpfUJgNnBv9xX1+XeNnFBe59izulueCMu8WRF7HiENqfCaqDmgD9fD/
         G1p7T51NdcBvRTBHrgNhhJy+1neOQzZFDOhgsBMEeZh+YT3CnXzw4hECEDcpwWdGAvas
         P9NY9+GPd3v9gN3hqyJljOqi3aGOA5HBYtOyDrYKxITEQwiVv21QWeqId8CoLC2eQOV+
         /4/g==
X-Gm-Message-State: AOJu0YwG3cpTlgYTA3pJTfHJKD0NCGmNwO/UZ2bJai7HnOw6yVDn5k14
        ZWwndtQndZTZKg+P4e31E3o=
X-Google-Smtp-Source: AGHT+IF+CGI0PJ9I+cIeRDIhpuUgpk/AHdlJCkSOXrzp84qBcNJ/hieDhmmIDRVhv9xaP7xTnx/phA==
X-Received: by 2002:a05:6a20:3d1e:b0:14c:f16a:2b78 with SMTP id y30-20020a056a203d1e00b0014cf16a2b78mr947207pzi.45.1698098228461;
        Mon, 23 Oct 2023 14:57:08 -0700 (PDT)
Received: from bvanassche-linux.mtv.corp.google.com ([2620:15c:211:201:14f9:170e:9304:1c4e])
        by smtp.gmail.com with ESMTPSA id b12-20020a17090acc0c00b0027d12b1e29dsm7851029pju.25.2023.10.23.14.57.07
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 23 Oct 2023 14:57:08 -0700 (PDT)
From:   Bart Van Assche <bvanassche@acm.org>
To:     Jens Axboe <axboe@kernel.dk>
Cc:     linux-block@vger.kernel.org, linux-scsi@vger.kernel.org,
        "Martin K . Petersen" <martin.petersen@oracle.com>,
        Christoph Hellwig <hch@lst.de>,
        Bart Van Assche <bvanassche@acm.org>,
        Damien Le Moal <dlemoal@kernel.org>,
        Ming Lei <ming.lei@redhat.com>,
        "James E.J. Bottomley" <jejb@linux.ibm.com>
Subject: [PATCH v14 08/19] scsi: sd: Sort commands by LBA before resubmitting
Date:   Mon, 23 Oct 2023 14:53:59 -0700
Message-ID: <20231023215638.3405959-9-bvanassche@acm.org>
X-Mailer: git-send-email 2.42.0.758.gaed0368e0e-goog
In-Reply-To: <20231023215638.3405959-1-bvanassche@acm.org>
References: <20231023215638.3405959-1-bvanassche@acm.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

Sort SCSI commands by LBA before the SCSI error handler resubmits
these commands. This is necessary when resubmitting zoned writes
(REQ_OP_WRITE) if multiple writes have been queued for a single zone.

Cc: Martin K. Petersen <martin.petersen@oracle.com>
Cc: Damien Le Moal <dlemoal@kernel.org>
Cc: Christoph Hellwig <hch@lst.de>
Cc: Ming Lei <ming.lei@redhat.com>
Signed-off-by: Bart Van Assche <bvanassche@acm.org>
---
 drivers/scsi/sd.c | 34 ++++++++++++++++++++++++++++++++++
 1 file changed, 34 insertions(+)

diff --git a/drivers/scsi/sd.c b/drivers/scsi/sd.c
index c92a317ba547..c9de909ad506 100644
--- a/drivers/scsi/sd.c
+++ b/drivers/scsi/sd.c
@@ -47,6 +47,7 @@
 #include <linux/blkpg.h>
 #include <linux/blk-pm.h>
 #include <linux/delay.h>
+#include <linux/list_sort.h>
 #include <linux/major.h>
 #include <linux/mutex.h>
 #include <linux/string_helpers.h>
@@ -1979,6 +1980,38 @@ static int sd_eh_action(struct scsi_cmnd *scmd, int eh_disp)
 	return eh_disp;
 }
 
+static int sd_cmp_sector(void *priv, const struct list_head *_a,
+			 const struct list_head *_b)
+{
+	struct scsi_cmnd *a = list_entry(_a, typeof(*a), eh_entry);
+	struct scsi_cmnd *b = list_entry(_b, typeof(*b), eh_entry);
+	struct request *rq_a = scsi_cmd_to_rq(a);
+	struct request *rq_b = scsi_cmd_to_rq(b);
+	bool use_zwl_a = rq_a->q->limits.use_zone_write_lock;
+	bool use_zwl_b = rq_b->q->limits.use_zone_write_lock;
+
+	/*
+	 * Order the commands that need zone write locking after the commands
+	 * that do not need zone write locking. Order the commands that do not
+	 * need zone write locking by LBA. Do not reorder the commands that
+	 * need zone write locking. See also the comment above the list_sort()
+	 * definition.
+	 */
+	if (use_zwl_a || use_zwl_b)
+		return use_zwl_a > use_zwl_b;
+	return blk_rq_pos(rq_a) > blk_rq_pos(rq_b);
+}
+
+static void sd_prepare_resubmit(struct list_head *cmd_list)
+{
+	/*
+	 * Sort pending SCSI commands in starting sector order. This is
+	 * important if one of the SCSI devices associated with @shost is a
+	 * zoned block device for which zone write locking is disabled.
+	 */
+	list_sort(NULL, cmd_list, sd_cmp_sector);
+}
+
 static unsigned int sd_completed_bytes(struct scsi_cmnd *scmd)
 {
 	struct request *req = scsi_cmd_to_rq(scmd);
@@ -3915,6 +3948,7 @@ static struct scsi_driver sd_template = {
 	.done			= sd_done,
 	.eh_action		= sd_eh_action,
 	.eh_reset		= sd_eh_reset,
+	.eh_prepare_resubmit	= sd_prepare_resubmit,
 };
 
 /**
