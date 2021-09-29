Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 16C70C433EF
	for <linux-scsi@archiver.kernel.org>; Wed, 29 Sep 2021 22:07:51 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id EA0E761425
	for <linux-scsi@archiver.kernel.org>; Wed, 29 Sep 2021 22:07:50 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1347169AbhI2WJb (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Wed, 29 Sep 2021 18:09:31 -0400
Received: from mail-pg1-f170.google.com ([209.85.215.170]:35742 "EHLO
        mail-pg1-f170.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1347137AbhI2WJY (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Wed, 29 Sep 2021 18:09:24 -0400
Received: by mail-pg1-f170.google.com with SMTP id e7so4166611pgk.2
        for <linux-scsi@vger.kernel.org>; Wed, 29 Sep 2021 15:07:42 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=pPkrLdSumEnx50+XwNbBHzTBTsGAttI9yp2MXlE2JtM=;
        b=iW/OKZJS5mvqJ2ecN3Bg41dP8QoHckyLt9E0M9X3bOy7fzEOHR2GzvRYNPXC8ntJyd
         16trLlqgerm5F0WOe+p0xGOyDwiBPF2zp0+iABQotqoJNI33ks7Jlu1ZqBD2EXJL0adS
         Ikf1G11+uhBouTWktpefjvyZa4bBkyK7v4dzjK3FF3bpQ9GuEERR3b3XH+8jGlW6E7M7
         89k6yVLVgtcibMbL7kQ7Gx8YjgBOmeoJs1NkgHrdlVLV1BfvDckJmDfLcRhRWWXloYbz
         NZPmfd9hqWTA/fd+jl4ARvn4/BSMmNtFDNSt71qEfetPRXOblCY6ks6yN9NCGF5XW30B
         1bGA==
X-Gm-Message-State: AOAM532QMnXlDsSfugSoAgLDQYhidvNEJLasvEvgdfIsWs6StF1TdeHE
        4VDgzrgii9RmbOGpxud8Ogg=
X-Google-Smtp-Source: ABdhPJzjjUlz+WwcY43cdbaUrQTg570av3QC59jXHjjX6pMvtQmYkHzF/1lf/BvB52FCn22b4mmBQQ==
X-Received: by 2002:a65:51c7:: with SMTP id i7mr1938848pgq.300.1632953262468;
        Wed, 29 Sep 2021 15:07:42 -0700 (PDT)
Received: from bvanassche-linux.mtv.corp.google.com ([2620:15c:211:201:5c11:c4f:db56:119])
        by smtp.gmail.com with ESMTPSA id gk14sm2785585pjb.35.2021.09.29.15.07.41
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 29 Sep 2021 15:07:41 -0700 (PDT)
From:   Bart Van Assche <bvanassche@acm.org>
To:     "Martin K . Petersen" <martin.petersen@oracle.com>
Cc:     linux-scsi@vger.kernel.org, Bart Van Assche <bvanassche@acm.org>,
        Hannes Reinecke <hare@kernel.org>,
        "James E.J. Bottomley" <jejb@linux.ibm.com>
Subject: [PATCH v2 54/84] myrb: Call scsi_done() directly
Date:   Wed, 29 Sep 2021 15:05:30 -0700
Message-Id: <20210929220600.3509089-55-bvanassche@acm.org>
X-Mailer: git-send-email 2.33.0.685.g46640cef36-goog
In-Reply-To: <20210929220600.3509089-1-bvanassche@acm.org>
References: <20210929220600.3509089-1-bvanassche@acm.org>
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
