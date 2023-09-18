Return-Path: <linux-scsi-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 292A3C46CA1
	for <linux-scsi@archiver.kernel.org>; Mon, 18 Sep 2023 16:57:55 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231287AbjIRQ55 (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Mon, 18 Sep 2023 12:57:57 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42146 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231246AbjIRQ5u (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Mon, 18 Sep 2023 12:57:50 -0400
Received: from mail-pf1-f171.google.com (mail-pf1-f171.google.com [209.85.210.171])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 22103A3;
        Mon, 18 Sep 2023 09:57:43 -0700 (PDT)
Received: by mail-pf1-f171.google.com with SMTP id d2e1a72fcca58-690ba63891dso345791b3a.2;
        Mon, 18 Sep 2023 09:57:43 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1695056262; x=1695661062;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=NrLWXaeR/EgbK40UM+EivZPIK4WgHuTtooGjxb8KUx4=;
        b=vRxVns3uMhgPJs3AkDAtb8lrVmRQ/rEambHfKkFQ6szx4cZcVhLx+UP3A2lv8PlC3E
         W8uz/XmqhUpzcYHSazICcG0BSTu1TWNcFXZXqdqLoy+AnT77hLXFoZY9e7eSOoWgcQDI
         2+dlDNGo39tEKHq9byQrc2EOquKyhAKno6f6X/laY1q+rw0eiukt3MnWD2m5iL+hXfag
         ddBDS/3fOdU6aXW1x4VS8erlxtEOKANrY7ljiBTcxDySKnSM8zkqTDKOrDYrhO9iAfaj
         G8/4wpsVOGN+b+HqtKPNw0drwvKBdMfdgGXhqYXqRcgtmnid4LEK1RlpUf5EoQjkm6dH
         rJ5Q==
X-Gm-Message-State: AOJu0Yze4xwgPbzRqA/JlSziPgcyiRW5rfuxKPfGKwieOWJe4N09zteo
        /GQ5uBmMgQ/xjQmoinyEK/M=
X-Google-Smtp-Source: AGHT+IEYLid3kOcnNCKptDSvkI0k1SyIyedb/LwkfVqqSC3GipoHSNKXfyx6se/6IVf92BuHmoaHpw==
X-Received: by 2002:a05:6a00:4790:b0:690:bdda:7c35 with SMTP id dh16-20020a056a00479000b00690bdda7c35mr292861pfb.1.1695056262383;
        Mon, 18 Sep 2023 09:57:42 -0700 (PDT)
Received: from bvanassche-linux.mtv.corp.google.com ([2620:15c:211:201:33e7:1437:5d00:8e3b])
        by smtp.gmail.com with ESMTPSA id p17-20020a639511000000b005740aa41237sm5658041pgd.74.2023.09.18.09.57.40
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 18 Sep 2023 09:57:41 -0700 (PDT)
From:   Bart Van Assche <bvanassche@acm.org>
To:     Jens Axboe <axboe@kernel.dk>
Cc:     linux-block@vger.kernel.org, linux-scsi@vger.kernel.org,
        "Martin K . Petersen" <martin.petersen@oracle.com>,
        Christoph Hellwig <hch@lst.de>,
        Bart Van Assche <bvanassche@acm.org>,
        Damien Le Moal <dlemoal@kernel.org>,
        Ming Lei <ming.lei@redhat.com>,
        "James E.J. Bottomley" <jejb@linux.ibm.com>
Subject: [PATCH v12 06/16] scsi: sd: Sort commands by LBA before resubmitting
Date:   Mon, 18 Sep 2023 09:55:45 -0700
Message-ID: <20230918165713.1598705-7-bvanassche@acm.org>
X-Mailer: git-send-email 2.42.0.459.ge4e396fd5e-goog
In-Reply-To: <20230918165713.1598705-1-bvanassche@acm.org>
References: <20230918165713.1598705-1-bvanassche@acm.org>
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
 drivers/scsi/sd.c | 43 +++++++++++++++++++++++++++++++++++++++++++
 1 file changed, 43 insertions(+)

diff --git a/drivers/scsi/sd.c b/drivers/scsi/sd.c
index c92a317ba547..6f26d6d6f50b 100644
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
@@ -1979,6 +1980,46 @@ static int sd_eh_action(struct scsi_cmnd *scmd, int eh_disp)
 	return eh_disp;
 }
 
+static bool sd_needs_prepare_resubmit(struct scsi_cmnd *cmd)
+{
+	struct request *rq = scsi_cmd_to_rq(cmd);
+
+	return !rq->q->limits.use_zone_write_lock &&
+		blk_rq_is_seq_zoned_write(rq);
+}
+
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
@@ -3915,6 +3956,8 @@ static struct scsi_driver sd_template = {
 	.done			= sd_done,
 	.eh_action		= sd_eh_action,
 	.eh_reset		= sd_eh_reset,
+	.eh_needs_prepare_resubmit = sd_needs_prepare_resubmit,
+	.eh_prepare_resubmit	= sd_prepare_resubmit,
 };
 
 /**
