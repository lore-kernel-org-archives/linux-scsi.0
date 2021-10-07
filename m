Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id DC2ADC433F5
	for <linux-scsi@archiver.kernel.org>; Thu,  7 Oct 2021 20:31:07 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id BE93461130
	for <linux-scsi@archiver.kernel.org>; Thu,  7 Oct 2021 20:31:07 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S242479AbhJGUdA (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Thu, 7 Oct 2021 16:33:00 -0400
Received: from mail-pg1-f181.google.com ([209.85.215.181]:37812 "EHLO
        mail-pg1-f181.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233837AbhJGUc7 (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Thu, 7 Oct 2021 16:32:59 -0400
Received: by mail-pg1-f181.google.com with SMTP id r201so923303pgr.4
        for <linux-scsi@vger.kernel.org>; Thu, 07 Oct 2021 13:31:05 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=pPkrLdSumEnx50+XwNbBHzTBTsGAttI9yp2MXlE2JtM=;
        b=OEQhZ9atTMhEFSE497r/koDVKowM5lxu8iABYeP/QPAxm1VdrnGex0wS2hm4/D6IG7
         xyONwhpOCschw6P4+e0X5opp91DqSSI+xCnhyPkHQ82lrLvAt6WQ7yyaokr4An2jkwKf
         r0cemwDKDzMVZhv7wcyrbHzM1q+aDkutBG5BZ8TFOkQyUWEJN6vg6X0tgI2vbiHS92kw
         5bUwG2J4j0Ee7S7/jbfInDp2HxN9tZ+1lzV5KfOSbZcxCD4FvcUzYkh2rJYm8T0xjtTr
         LYLMxjFBZty9T2fUzldGBqZZtXZo8erVOqL55m6L+5fC3WLPktJtFAJHGLW5Fltc9wJF
         RikQ==
X-Gm-Message-State: AOAM533MfCq3YoJrPNXO3Ryz5agOWclMOzAv4MvYEemvvpzjJLWoZmSk
        ArlWmVVdBoqkiKDMYz5vkgA=
X-Google-Smtp-Source: ABdhPJz/z/ymKWYDSYGh9XyvY7XA2VQGqGadBhdDCcNTCX27KGmpkIQSTgmqPzOPPO7GD3Rw5RJNVw==
X-Received: by 2002:aa7:9735:0:b0:44c:619f:29fc with SMTP id k21-20020aa79735000000b0044c619f29fcmr6062890pfg.79.1633638664728;
        Thu, 07 Oct 2021 13:31:04 -0700 (PDT)
Received: from bvanassche-linux.mtv.corp.google.com ([2620:15c:211:201:ae88:8f16:b90b:5f1d])
        by smtp.gmail.com with ESMTPSA id x35sm303499pfh.52.2021.10.07.13.31.03
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 07 Oct 2021 13:31:04 -0700 (PDT)
From:   Bart Van Assche <bvanassche@acm.org>
To:     "Martin K . Petersen" <martin.petersen@oracle.com>
Cc:     linux-scsi@vger.kernel.org, Bart Van Assche <bvanassche@acm.org>,
        Hannes Reinecke <hare@kernel.org>,
        "James E.J. Bottomley" <jejb@linux.ibm.com>
Subject: [PATCH v3 54/88] myrb: Call scsi_done() directly
Date:   Thu,  7 Oct 2021 13:28:49 -0700
Message-Id: <20211007202923.2174984-55-bvanassche@acm.org>
X-Mailer: git-send-email 2.33.0.882.g93a45727a2-goog
In-Reply-To: <20211007202923.2174984-1-bvanassche@acm.org>
References: <20211007202923.2174984-1-bvanassche@acm.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

Conditional statements are faster than indirect calls. Hence call
scsi_done() directly.

Signed-off-by: Bart Van Assche <bvanassche@acm.org>
---
 drivers/scsi/myrb.c | 32 ++++++++++++++++----------------
 1 file changed, 16 insertions(+), 16 deletions(-)

diff --git a/drivers/scsi/myrb.c b/drivers/scsi/myrb.c
index a4a88323e020..e8a7bcce4674 100644
--- a/drivers/scsi/myrb.c
+++ b/drivers/scsi/myrb.c
@@ -1282,7 +1282,7 @@ static int myrb_pthru_queuecommand(struct Scsi_Host *shost,
 	if (nsge > 1) {
 		dma_pool_free(cb->dcdb_pool, dcdb, dcdb_addr);
 		scmd->result = (DID_ERROR << 16);
-		scmd->scsi_done(scmd);
+		scsi_done(scmd);
 		return 0;
 	}
 
@@ -1436,13 +1436,13 @@ static int myrb_ldev_queuecommand(struct Scsi_Host *shost,
 		dev_dbg(&shost->shost_gendev, "ldev %u in state %x, skip\n",
 			sdev->id, ldev_info ? ldev_info->state : 0xff);
 		scmd->result = (DID_BAD_TARGET << 16);
-		scmd->scsi_done(scmd);
+		scsi_done(scmd);
 		return 0;
 	}
 	switch (scmd->cmnd[0]) {
 	case TEST_UNIT_READY:
 		scmd->result = (DID_OK << 16);
-		scmd->scsi_done(scmd);
+		scsi_done(scmd);
 		return 0;
 	case INQUIRY:
 		if (scmd->cmnd[1] & 1) {
@@ -1452,11 +1452,11 @@ static int myrb_ldev_queuecommand(struct Scsi_Host *shost,
 			myrb_inquiry(cb, scmd);
 			scmd->result = (DID_OK << 16);
 		}
-		scmd->scsi_done(scmd);
+		scsi_done(scmd);
 		return 0;
 	case SYNCHRONIZE_CACHE:
 		scmd->result = (DID_OK << 16);
-		scmd->scsi_done(scmd);
+		scsi_done(scmd);
 		return 0;
 	case MODE_SENSE:
 		if ((scmd->cmnd[2] & 0x3F) != 0x3F &&
@@ -1467,25 +1467,25 @@ static int myrb_ldev_queuecommand(struct Scsi_Host *shost,
 			myrb_mode_sense(cb, scmd, ldev_info);
 			scmd->result = (DID_OK << 16);
 		}
-		scmd->scsi_done(scmd);
+		scsi_done(scmd);
 		return 0;
 	case READ_CAPACITY:
 		if ((scmd->cmnd[1] & 1) ||
 		    (scmd->cmnd[8] & 1)) {
 			/* Illegal request, invalid field in CDB */
 			scsi_build_sense(scmd, 0, ILLEGAL_REQUEST, 0x24, 0);
-			scmd->scsi_done(scmd);
+			scsi_done(scmd);
 			return 0;
 		}
 		lba = get_unaligned_be32(&scmd->cmnd[2]);
 		if (lba) {
 			/* Illegal request, invalid field in CDB */
 			scsi_build_sense(scmd, 0, ILLEGAL_REQUEST, 0x24, 0);
-			scmd->scsi_done(scmd);
+			scsi_done(scmd);
 			return 0;
 		}
 		myrb_read_capacity(cb, scmd, ldev_info);
-		scmd->scsi_done(scmd);
+		scsi_done(scmd);
 		return 0;
 	case REQUEST_SENSE:
 		myrb_request_sense(cb, scmd);
@@ -1499,13 +1499,13 @@ static int myrb_ldev_queuecommand(struct Scsi_Host *shost,
 			/* Assume good status */
 			scmd->result = (DID_OK << 16);
 		}
-		scmd->scsi_done(scmd);
+		scsi_done(scmd);
 		return 0;
 	case READ_6:
 		if (ldev_info->state == MYRB_DEVICE_WO) {
 			/* Data protect, attempt to read invalid data */
 			scsi_build_sense(scmd, 0, DATA_PROTECT, 0x21, 0x06);
-			scmd->scsi_done(scmd);
+			scsi_done(scmd);
 			return 0;
 		}
 		fallthrough;
@@ -1519,7 +1519,7 @@ static int myrb_ldev_queuecommand(struct Scsi_Host *shost,
 		if (ldev_info->state == MYRB_DEVICE_WO) {
 			/* Data protect, attempt to read invalid data */
 			scsi_build_sense(scmd, 0, DATA_PROTECT, 0x21, 0x06);
-			scmd->scsi_done(scmd);
+			scsi_done(scmd);
 			return 0;
 		}
 		fallthrough;
@@ -1533,7 +1533,7 @@ static int myrb_ldev_queuecommand(struct Scsi_Host *shost,
 		if (ldev_info->state == MYRB_DEVICE_WO) {
 			/* Data protect, attempt to read invalid data */
 			scsi_build_sense(scmd, 0, DATA_PROTECT, 0x21, 0x06);
-			scmd->scsi_done(scmd);
+			scsi_done(scmd);
 			return 0;
 		}
 		fallthrough;
@@ -1546,7 +1546,7 @@ static int myrb_ldev_queuecommand(struct Scsi_Host *shost,
 	default:
 		/* Illegal request, invalid opcode */
 		scsi_build_sense(scmd, 0, ILLEGAL_REQUEST, 0x20, 0);
-		scmd->scsi_done(scmd);
+		scsi_done(scmd);
 		return 0;
 	}
 
@@ -1610,7 +1610,7 @@ static int myrb_queuecommand(struct Scsi_Host *shost,
 
 	if (sdev->channel > myrb_logical_channel(shost)) {
 		scmd->result = (DID_BAD_TARGET << 16);
-		scmd->scsi_done(scmd);
+		scsi_done(scmd);
 		return 0;
 	}
 	if (sdev->channel == myrb_logical_channel(shost))
@@ -2361,7 +2361,7 @@ static void myrb_handle_scsi(struct myrb_hba *cb, struct myrb_cmdblk *cmd_blk,
 		scmd->result = (DID_ERROR << 16);
 		break;
 	}
-	scmd->scsi_done(scmd);
+	scsi_done(scmd);
 }
 
 static void myrb_handle_cmdblk(struct myrb_hba *cb, struct myrb_cmdblk *cmd_blk)
