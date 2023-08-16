Return-Path: <linux-scsi-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 1F4D6C25B7F
	for <linux-scsi@archiver.kernel.org>; Wed, 16 Aug 2023 19:55:55 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1345939AbjHPTzZ (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Wed, 16 Aug 2023 15:55:25 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39054 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1345937AbjHPTzP (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Wed, 16 Aug 2023 15:55:15 -0400
Received: from mail-pg1-f169.google.com (mail-pg1-f169.google.com [209.85.215.169])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4861FE55;
        Wed, 16 Aug 2023 12:55:14 -0700 (PDT)
Received: by mail-pg1-f169.google.com with SMTP id 41be03b00d2f7-565403bda57so4299148a12.3;
        Wed, 16 Aug 2023 12:55:14 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1692215714; x=1692820514;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=odcxs1ViPnFxwilUGJzlR+a6yqgvZFgbIQUNsV7/ZVM=;
        b=SHbxCecBWhHy1y1reJaR/IQ51i7T0TdRe5QPfyaUezctGLgfGVLhuijoBs7UE/KvJW
         lN6yIgYP+hRiuvGt8KLe2Xk29+TjTF87oWp8GxDo1EPc26qAy+v1toOmiSlXaCMzuk7R
         sSknGTEp+dNKR6ueWkf4+859Ou3+3X8Y4vQR/27rAuSy2hfpgLAy9fvqnHI+kauHjtf2
         qgil8H8ygOG23e70v/ceUGSrUas8mwF1NQtyqsQutKGB27Iz1n4dfHlcntoU2AMu1H2g
         6K0QSQ7HAiuHeW70bJJMq+4U+LIFZgiRIeoN5iV4BPstwmysKi4Y5OgoN/3rl1f7MbGd
         01jw==
X-Gm-Message-State: AOJu0YyVmytO9eH4qTyxi/v3AirQy65loBQjdr4oeI1AwnX2YH5BDwUo
        4PRP13YeNpgG4QotRrOroJ0=
X-Google-Smtp-Source: AGHT+IGaQfx1kh4sa48mT3nrUEn4EzJ/T2yw4N+p410g+vF4PdUeGp6Uoaf8/BfG1OklG4tZ0pZCBQ==
X-Received: by 2002:a05:6a20:748b:b0:131:4808:d5a1 with SMTP id p11-20020a056a20748b00b001314808d5a1mr3349403pzd.28.1692215713690;
        Wed, 16 Aug 2023 12:55:13 -0700 (PDT)
Received: from bvanassche-linux.mtv.corp.google.com ([2620:15c:211:201:7141:e456:f574:7de0])
        by smtp.gmail.com with ESMTPSA id r26-20020a62e41a000000b0068890c19c49sm1588508pfh.180.2023.08.16.12.55.12
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 16 Aug 2023 12:55:13 -0700 (PDT)
From:   Bart Van Assche <bvanassche@acm.org>
To:     Jens Axboe <axboe@kernel.dk>
Cc:     linux-block@vger.kernel.org, linux-scsi@vger.kernel.org,
        "Martin K . Petersen" <martin.petersen@oracle.com>,
        Christoph Hellwig <hch@lst.de>,
        Bart Van Assche <bvanassche@acm.org>,
        Damien Le Moal <dlemoal@kernel.org>,
        Ming Lei <ming.lei@redhat.com>,
        "James E.J. Bottomley" <jejb@linux.ibm.com>
Subject: [PATCH v9 06/17] scsi: sd: Sort commands by LBA before resubmitting
Date:   Wed, 16 Aug 2023 12:53:18 -0700
Message-ID: <20230816195447.3703954-7-bvanassche@acm.org>
X-Mailer: git-send-email 2.41.0.694.ge786442a9b-goog
In-Reply-To: <20230816195447.3703954-1-bvanassche@acm.org>
References: <20230816195447.3703954-1-bvanassche@acm.org>
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
 drivers/scsi/sd.c | 35 +++++++++++++++++++++++++++++++++++
 1 file changed, 35 insertions(+)

diff --git a/drivers/scsi/sd.c b/drivers/scsi/sd.c
index 3c668cfb146d..8a4b0874e7fe 100644
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
@@ -117,6 +118,7 @@ static void sd_uninit_command(struct scsi_cmnd *SCpnt);
 static int sd_done(struct scsi_cmnd *);
 static void sd_eh_reset(struct scsi_cmnd *);
 static int sd_eh_action(struct scsi_cmnd *, int);
+static void sd_prepare_resubmit(struct list_head *cmd_list);
 static void sd_read_capacity(struct scsi_disk *sdkp, unsigned char *buffer);
 static void scsi_disk_release(struct device *cdev);
 
@@ -617,6 +619,7 @@ static struct scsi_driver sd_template = {
 	.done			= sd_done,
 	.eh_action		= sd_eh_action,
 	.eh_reset		= sd_eh_reset,
+	.eh_prepare_resubmit	= sd_prepare_resubmit,
 };
 
 /*
@@ -2018,6 +2021,38 @@ static int sd_eh_action(struct scsi_cmnd *scmd, int eh_disp)
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
