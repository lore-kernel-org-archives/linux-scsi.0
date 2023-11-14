Return-Path: <linux-scsi-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D3733C4167D
	for <linux-scsi@archiver.kernel.org>; Tue, 14 Nov 2023 21:18:43 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234081AbjKNVSo (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Tue, 14 Nov 2023 16:18:44 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55092 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234082AbjKNVSl (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Tue, 14 Nov 2023 16:18:41 -0500
Received: from mail-pl1-f176.google.com (mail-pl1-f176.google.com [209.85.214.176])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9612AF0;
        Tue, 14 Nov 2023 13:18:36 -0800 (PST)
Received: by mail-pl1-f176.google.com with SMTP id d9443c01a7336-1cc2fc281cdso47167325ad.0;
        Tue, 14 Nov 2023 13:18:36 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1699996716; x=1700601516;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=YVWi2Q1sV9spaxry37mpQP98JceOEq6IkdRxW6ewZhs=;
        b=QoQYuBFEoHVC4QE0z09vVrjHq9ybM9jAINOBhrDotJG1xijnOUUBkIPW3OvMSXmcN9
         p3w6LJPQO5YhHOFJ3tuTQ2qyKLLrBz8h2pkyqh3/SlTDefjSC+p4PsV2Nnh5wG/y2DUL
         mSqrsZDlRhl83RRIk4OmsyScgtj4eJdesgmZut1ofuyFGTjvjw02f2tve+3wXnjUTHlE
         ay2yHoa2rSnXKGuxHiqtUm0/O0G2WOG+ztSnovsYR+WEftTCQxhSxCvSDcPNQZfNgg8g
         rSbXBeoXvyV8jFwZ9honwNI2dLRgF92GKubVweimaOejoaCipKyajYUuy0G6/6JDHuiG
         Fo5Q==
X-Gm-Message-State: AOJu0YyQUo+7m89s8TQElkOcG0I7MS54Xgvg+f5SHjSLpHldaFWcMrib
        3ICzb4rIgEprljmc0hOeD1M=
X-Google-Smtp-Source: AGHT+IEp9+kqkeTpv4Xkg1juZDhsct2JPEvKd7Xw3fYoiyHC5+VwP3N5Q+HgdM1Q86Mj/INBMQF9vA==
X-Received: by 2002:a17:902:8542:b0:1cc:ef37:664a with SMTP id d2-20020a170902854200b001ccef37664amr3088361plo.31.1699996716016;
        Tue, 14 Nov 2023 13:18:36 -0800 (PST)
Received: from bvanassche-linux.mtv.corp.google.com ([2620:0:1000:8411:2278:ad72:cefb:4d49])
        by smtp.gmail.com with ESMTPSA id ix7-20020a170902f80700b001c71ec1866fsm6169288plb.258.2023.11.14.13.18.35
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 14 Nov 2023 13:18:35 -0800 (PST)
From:   Bart Van Assche <bvanassche@acm.org>
To:     "Martin K . Petersen" <martin.petersen@oracle.com>
Cc:     linux-scsi@vger.kernel.org, linux-block@vger.kernel.org,
        Jens Axboe <axboe@kernel.dk>, Christoph Hellwig <hch@lst.de>,
        Bart Van Assche <bvanassche@acm.org>,
        Damien Le Moal <dlemoal@kernel.org>,
        Ming Lei <ming.lei@redhat.com>,
        "James E.J. Bottomley" <jejb@linux.ibm.com>
Subject: [PATCH v15 08/19] scsi: sd: Support sorting commands by LBA before resubmitting
Date:   Tue, 14 Nov 2023 13:16:16 -0800
Message-ID: <20231114211804.1449162-9-bvanassche@acm.org>
X-Mailer: git-send-email 2.43.0.rc0.421.g78406f8d94-goog
In-Reply-To: <20231114211804.1449162-1-bvanassche@acm.org>
References: <20231114211804.1449162-1-bvanassche@acm.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

Support sorting SCSI commands by LBA before the SCSI error handler
resubmits these commands. This is necessary when resubmitting zoned writes
(REQ_OP_WRITE) if multiple writes have been queued for a single zone.

Reviewed-by: Damien Le Moal <dlemoal@kernel.org>
Cc: Martin K. Petersen <martin.petersen@oracle.com>
Cc: Christoph Hellwig <hch@lst.de>
Cc: Ming Lei <ming.lei@redhat.com>
Signed-off-by: Bart Van Assche <bvanassche@acm.org>
---
 drivers/scsi/sd.c | 34 ++++++++++++++++++++++++++++++++++
 1 file changed, 34 insertions(+)

diff --git a/drivers/scsi/sd.c b/drivers/scsi/sd.c
index 530918cbfce2..63bb01ddadde 100644
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
@@ -2058,6 +2059,38 @@ static int sd_eh_action(struct scsi_cmnd *scmd, int eh_disp)
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
@@ -4014,6 +4047,7 @@ static struct scsi_driver sd_template = {
 	.done			= sd_done,
 	.eh_action		= sd_eh_action,
 	.eh_reset		= sd_eh_reset,
+	.eh_prepare_resubmit	= sd_prepare_resubmit,
 };
 
 /**
