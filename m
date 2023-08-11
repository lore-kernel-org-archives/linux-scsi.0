Return-Path: <linux-scsi-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E0FB7C04A94
	for <linux-scsi@archiver.kernel.org>; Fri, 11 Aug 2023 21:36:22 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236047AbjHKVgV (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Fri, 11 Aug 2023 17:36:21 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43646 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236570AbjHKVgU (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Fri, 11 Aug 2023 17:36:20 -0400
Received: from mail-pf1-f171.google.com (mail-pf1-f171.google.com [209.85.210.171])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BD81F213F;
        Fri, 11 Aug 2023 14:36:19 -0700 (PDT)
Received: by mail-pf1-f171.google.com with SMTP id d2e1a72fcca58-68706b39c4cso1883867b3a.2;
        Fri, 11 Aug 2023 14:36:19 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1691789779; x=1692394579;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=0MTRiIPOGKG6b+x9b42B4xdETbTVAE/EoHB9M4Iemm0=;
        b=EhWWUg+5j6P4IEryBdxDw3/wvtPoMpmDFgeCNUp0bJjKNiQiIcBcPGJFHkG2j+EiNL
         EkiAU+bQZ1q0N6g5fiTIfVayw6XgOyUh4ayB/t3w6sqckBXey3l/zBaUuQ50/xEZwXED
         xVl1wrbZSsBKYj9YAri9WqOUWJD/6TPM1QhpqnLV/4Bt13LmEtG46EkEUxrVYoqktZZb
         TDdl/IF+iyNdX6O2U8MrkwzqwFHbTbC1N6xAF/4hOd4egBnHh1sT3IsH2/AmNU4akioO
         0MkS/bFgAZSOSrTPFsM11o2tys2zkwRsXKMNRmhblM6KDRo3mw7TEe0/wPzcGX0TsUsQ
         ZVcg==
X-Gm-Message-State: AOJu0Yy6hAiB3/9SetCcyh3CFTsaqLG7hi4nT22pmauH7j3M1RAyeRl1
        dH/I2sDsxZA7+Lzok5y1FiY=
X-Google-Smtp-Source: AGHT+IH6thqQ6Vhm5jL5/oI97dSKkYiE6b7IUoHLeuLaf99nXleZcKqX7SRd4ex5zgkMQ6j1qsjyhA==
X-Received: by 2002:a17:902:9a06:b0:1bb:673f:36ae with SMTP id v6-20020a1709029a0600b001bb673f36aemr2316144plp.15.1691789779158;
        Fri, 11 Aug 2023 14:36:19 -0700 (PDT)
Received: from bvanassche-linux.mtv.corp.google.com ([2620:15c:211:201:cdd8:4c3:2f3c:adea])
        by smtp.gmail.com with ESMTPSA id c10-20020a170903234a00b001b89c313185sm4394865plh.205.2023.08.11.14.36.18
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 11 Aug 2023 14:36:18 -0700 (PDT)
From:   Bart Van Assche <bvanassche@acm.org>
To:     Jens Axboe <axboe@kernel.dk>
Cc:     linux-block@vger.kernel.org, linux-scsi@vger.kernel.org,
        "Martin K . Petersen" <martin.petersen@oracle.com>,
        Christoph Hellwig <hch@lst.de>,
        Bart Van Assche <bvanassche@acm.org>,
        Damien Le Moal <dlemoal@kernel.org>,
        Ming Lei <ming.lei@redhat.com>,
        "James E.J. Bottomley" <jejb@linux.ibm.com>
Subject: [PATCH v8 4/9] scsi: sd: Sort commands by LBA before resubmitting
Date:   Fri, 11 Aug 2023 14:35:38 -0700
Message-ID: <20230811213604.548235-5-bvanassche@acm.org>
X-Mailer: git-send-email 2.41.0.640.ga95def55d0-goog
In-Reply-To: <20230811213604.548235-1-bvanassche@acm.org>
References: <20230811213604.548235-1-bvanassche@acm.org>
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
 drivers/scsi/sd.c | 23 +++++++++++++++++++++++
 1 file changed, 23 insertions(+)

diff --git a/drivers/scsi/sd.c b/drivers/scsi/sd.c
index 3c668cfb146d..4d9c6ad11cca 100644
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
@@ -2018,6 +2021,26 @@ static int sd_eh_action(struct scsi_cmnd *scmd, int eh_disp)
 	return eh_disp;
 }
 
+static int sd_cmp_sector(void *priv, const struct list_head *_a,
+			 const struct list_head *_b)
+{
+	struct scsi_cmnd *a = list_entry(_a, typeof(*a), eh_entry);
+	struct scsi_cmnd *b = list_entry(_b, typeof(*b), eh_entry);
+
+	/* See also the comment above the list_sort() definition. */
+	return blk_rq_pos(scsi_cmd_to_rq(a)) > blk_rq_pos(scsi_cmd_to_rq(b));
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
