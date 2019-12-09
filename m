Return-Path: <SRS0=QSh0=Z7=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.8 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id EC1C7C43603
	for <linux-scsi@archiver.kernel.org>; Mon,  9 Dec 2019 17:46:47 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id C448F2080D
	for <linux-scsi@archiver.kernel.org>; Mon,  9 Dec 2019 17:46:47 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726589AbfLIRqr (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Mon, 9 Dec 2019 12:46:47 -0500
Received: from mail-pj1-f66.google.com ([209.85.216.66]:35831 "EHLO
        mail-pj1-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726584AbfLIRqr (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Mon, 9 Dec 2019 12:46:47 -0500
Received: by mail-pj1-f66.google.com with SMTP id w23so6208340pjd.2
        for <linux-scsi@vger.kernel.org>; Mon, 09 Dec 2019 09:46:46 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=nqnUyJcMvuVuu9zmohjldoGUo0I+EIH38mK4xG/QvaM=;
        b=EdIWk+703nloyJr8O5am2Fr9r2Ag093kc4U07MLGGKoLTIVITFcMTzeFmtaTgcVGP2
         6ge1pdMm8BdHFnVvry0mJwRe5qnk571lGnK5B3Ne87HzHzNbbFkOYYKkeDJcXHBI8i1c
         VJmqiteeIFnMIqU0ORw1FgXLtFX5qfXguN+9Wnj2rQIgsQ5CTAlgUpUrlKKLsd6HAHqe
         XxdNvuGDAnlNGOaD0mqCYlTsQQGwBvjdLfOgEXyfMd2oM2BG8+37F9d3LRsDlGUMUzXR
         WOrKQChDna2v/uB9dX42kiguuTTr/USyL5QPFVph+JHXL8bcigC7R5E19+DbdHXXfG7T
         WrPA==
X-Gm-Message-State: APjAAAWQiqROzeFuvskXlZEIs/kw8fFbrIjgH3mOtYXOHVTi8Jb5+uck
        2DQzlFUy1qUvuT7hrLvBGj9xUqDe
X-Google-Smtp-Source: APXvYqz+X0zyjAYRWvgtlsSUC0rQ3uT4DTfkwm4ujRLrPpXajFsCfMXnoYhQJ7w3fbeIkw7LgL8bVA==
X-Received: by 2002:a17:90a:cc04:: with SMTP id b4mr217934pju.136.1575913606357;
        Mon, 09 Dec 2019 09:46:46 -0800 (PST)
Received: from bvanassche-glaptop.roam.corp.google.com ([216.9.110.7])
        by smtp.gmail.com with ESMTPSA id d22sm80492pfo.187.2019.12.09.09.46.45
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 09 Dec 2019 09:46:45 -0800 (PST)
From:   Bart Van Assche <bvanassche@acm.org>
To:     "Martin K . Petersen" <martin.petersen@oracle.com>,
        "James E . J . Bottomley" <jejb@linux.vnet.ibm.com>
Cc:     linux-scsi@vger.kernel.org, Bart Van Assche <bvanassche@acm.org>,
        Douglas Gilbert <dgilbert@interlog.com>
Subject: [PATCH] Move the scsi_medium_access_command() definition
Date:   Mon,  9 Dec 2019 09:46:40 -0800
Message-Id: <20191209174640.191076-1-bvanassche@acm.org>
X-Mailer: git-send-email 2.24.0.393.g34dc348eaf-goog
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

Move the scsi_medium_access_command() definition from a header file into a .c
file to reduce the kernel build time. This function is used by the scsi_debug
and by the sd drivers.

Cc: Douglas Gilbert <dgilbert@interlog.com>
Signed-off-by: Bart Van Assche <bvanassche@acm.org>
---
 drivers/scsi/scsi_lib.c  | 33 +++++++++++++++++++++++++++++++++
 drivers/scsi/sd.h        | 32 --------------------------------
 include/scsi/scsi_cmnd.h |  2 ++
 3 files changed, 35 insertions(+), 32 deletions(-)

diff --git a/drivers/scsi/scsi_lib.c b/drivers/scsi/scsi_lib.c
index 3e7a45d0daca..ae95e2e9e6d8 100644
--- a/drivers/scsi/scsi_lib.c
+++ b/drivers/scsi/scsi_lib.c
@@ -3119,3 +3119,36 @@ int scsi_vpd_tpg_id(struct scsi_device *sdev, int *rel_id)
 	return group_id;
 }
 EXPORT_SYMBOL(scsi_vpd_tpg_id);
+
+bool scsi_medium_access_command(const struct scsi_cmnd *scmd)
+{
+	switch (scmd->cmnd[0]) {
+	case READ_6:
+	case READ_10:
+	case READ_12:
+	case READ_16:
+	case SYNCHRONIZE_CACHE:
+	case VERIFY:
+	case VERIFY_12:
+	case VERIFY_16:
+	case WRITE_6:
+	case WRITE_10:
+	case WRITE_12:
+	case WRITE_16:
+	case WRITE_SAME:
+	case WRITE_SAME_16:
+	case UNMAP:
+		return true;
+	case VARIABLE_LENGTH_CMD:
+		switch (scmd->cmnd[9]) {
+		case READ_32:
+		case VERIFY_32:
+		case WRITE_32:
+		case WRITE_SAME_32:
+			return true;
+		}
+	}
+
+	return false;
+}
+EXPORT_SYMBOL(scsi_medium_access_command);
diff --git a/drivers/scsi/sd.h b/drivers/scsi/sd.h
index 50fff0bf8c8e..5c338e1c4270 100644
--- a/drivers/scsi/sd.h
+++ b/drivers/scsi/sd.h
@@ -136,38 +136,6 @@ static inline struct scsi_disk *scsi_disk(struct gendisk *disk)
 			sd_printk(prefix, sdsk, fmt, ##a);		\
 	} while (0)
 
-static inline int scsi_medium_access_command(struct scsi_cmnd *scmd)
-{
-	switch (scmd->cmnd[0]) {
-	case READ_6:
-	case READ_10:
-	case READ_12:
-	case READ_16:
-	case SYNCHRONIZE_CACHE:
-	case VERIFY:
-	case VERIFY_12:
-	case VERIFY_16:
-	case WRITE_6:
-	case WRITE_10:
-	case WRITE_12:
-	case WRITE_16:
-	case WRITE_SAME:
-	case WRITE_SAME_16:
-	case UNMAP:
-		return 1;
-	case VARIABLE_LENGTH_CMD:
-		switch (scmd->cmnd[9]) {
-		case READ_32:
-		case VERIFY_32:
-		case WRITE_32:
-		case WRITE_SAME_32:
-			return 1;
-		}
-	}
-
-	return 0;
-}
-
 static inline sector_t logical_to_sectors(struct scsi_device *sdev, sector_t blocks)
 {
 	return blocks << (ilog2(sdev->sector_size) - 9);
diff --git a/include/scsi/scsi_cmnd.h b/include/scsi/scsi_cmnd.h
index a2849bb9cd19..f6bbf48b3694 100644
--- a/include/scsi/scsi_cmnd.h
+++ b/include/scsi/scsi_cmnd.h
@@ -168,6 +168,8 @@ extern void scsi_kunmap_atomic_sg(void *virt);
 
 extern blk_status_t scsi_init_io(struct scsi_cmnd *cmd);
 
+extern bool scsi_medium_access_command(const struct scsi_cmnd *scmd);
+
 #ifdef CONFIG_SCSI_DMA
 extern int scsi_dma_map(struct scsi_cmnd *cmd);
 extern void scsi_dma_unmap(struct scsi_cmnd *cmd);
