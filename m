Return-Path: <linux-scsi-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 55F49EE49A3
	for <linux-scsi@archiver.kernel.org>; Fri, 18 Aug 2023 19:47:13 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1379856AbjHRTqr (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Fri, 18 Aug 2023 15:46:47 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:32950 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1379851AbjHRTqU (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Fri, 18 Aug 2023 15:46:20 -0400
Received: from mail-pl1-x62d.google.com (mail-pl1-x62d.google.com [IPv6:2607:f8b0:4864:20::62d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A3C7944AF;
        Fri, 18 Aug 2023 12:45:55 -0700 (PDT)
Received: by mail-pl1-x62d.google.com with SMTP id d9443c01a7336-1bf0b24d925so9813725ad.3;
        Fri, 18 Aug 2023 12:45:55 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1692387803; x=1692992603;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=+kT0lODXnQs5o0Wfuh374uESQu7wFS2RjdWOYRnRcYk=;
        b=MR8hYS4xc9GrhxL1vH5j1xuejdraHWHfagU9fdzrltw0ZwJQfaeMtfjsFl3VXJ8m0g
         +JedLgmlpuJBcDkUG3uuKIKHevzsHnTpf9AUnU2k9Kf3H9bwdE9GEeJK1NEdq7C9XPBM
         xe4bl6o9o1UCwZA9zaVN4bSpr+mzLr3IbxS5wCsXjb7Rqyn/J2gWC7QAOYlH4R3eqzIB
         ZXQTaQMgTmPA6muzV1fJSWrkD+Ays4t7TN1LsWvxEX3kUwnK/GhYr5bHNuzJmp4Xh21f
         8w/Y4CgqMz1lfJXJa6MdERAifBNPLfS4odlsqb5KD+m7CGP8d/OaPjCYij7Qs8vwr/ha
         k5Iw==
X-Gm-Message-State: AOJu0YwjrDnpDQCBY8F3plTvZ3tIW8eC6tim0YftZPwu9myRTZWQfxkF
        CaNZk6kcKRVTYrsbmgV20+ihK8Mc4V4=
X-Google-Smtp-Source: AGHT+IEF3BgAgcEuz3dbs6/Pn7ecjoSU8tP8vQ7YMbvZ8XkC23fbFtOk+cZ6uX/aPEZ02HofKZVZ6Q==
X-Received: by 2002:a17:902:d2c9:b0:1bc:8748:8bbf with SMTP id n9-20020a170902d2c900b001bc87488bbfmr186330plc.52.1692387802982;
        Fri, 18 Aug 2023 12:43:22 -0700 (PDT)
Received: from bvanassche-linux.mtv.corp.google.com ([2620:15c:211:201:5012:5192:47aa:c304])
        by smtp.gmail.com with ESMTPSA id u16-20020a170903125000b001bb8be10a84sm2115801plh.304.2023.08.18.12.43.21
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 18 Aug 2023 12:43:22 -0700 (PDT)
From:   Bart Van Assche <bvanassche@acm.org>
To:     Jens Axboe <axboe@kernel.dk>
Cc:     linux-block@vger.kernel.org, linux-scsi@vger.kernel.org,
        "Martin K . Petersen" <martin.petersen@oracle.com>,
        Christoph Hellwig <hch@lst.de>,
        Bart Van Assche <bvanassche@acm.org>,
        Damien Le Moal <dlemoal@kernel.org>,
        Ming Lei <ming.lei@redhat.com>,
        "James E.J. Bottomley" <jejb@linux.ibm.com>
Subject: [PATCH v10 06/18] scsi: sd: Sort commands by LBA before resubmitting
Date:   Fri, 18 Aug 2023 12:34:09 -0700
Message-ID: <20230818193546.2014874-7-bvanassche@acm.org>
X-Mailer: git-send-email 2.42.0.rc1.204.g551eb34607-goog
In-Reply-To: <20230818193546.2014874-1-bvanassche@acm.org>
References: <20230818193546.2014874-1-bvanassche@acm.org>
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
 drivers/scsi/sd.c | 45 +++++++++++++++++++++++++++++++++++++++++++++
 1 file changed, 45 insertions(+)

diff --git a/drivers/scsi/sd.c b/drivers/scsi/sd.c
index 3c668cfb146d..d4feac5de17a 100644
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
@@ -117,6 +118,8 @@ static void sd_uninit_command(struct scsi_cmnd *SCpnt);
 static int sd_done(struct scsi_cmnd *);
 static void sd_eh_reset(struct scsi_cmnd *);
 static int sd_eh_action(struct scsi_cmnd *, int);
+static bool sd_needs_prepare_resubmit(struct scsi_cmnd *cmd);
+static void sd_prepare_resubmit(struct list_head *cmd_list);
 static void sd_read_capacity(struct scsi_disk *sdkp, unsigned char *buffer);
 static void scsi_disk_release(struct device *cdev);
 
@@ -617,6 +620,8 @@ static struct scsi_driver sd_template = {
 	.done			= sd_done,
 	.eh_action		= sd_eh_action,
 	.eh_reset		= sd_eh_reset,
+	.eh_needs_prepare_resubmit = sd_needs_prepare_resubmit,
+	.eh_prepare_resubmit	= sd_prepare_resubmit,
 };
 
 /*
@@ -2018,6 +2023,46 @@ static int sd_eh_action(struct scsi_cmnd *scmd, int eh_disp)
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
