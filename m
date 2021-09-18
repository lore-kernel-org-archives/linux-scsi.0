Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-16.8 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 11771C433F5
	for <linux-scsi@archiver.kernel.org>; Sat, 18 Sep 2021 00:07:59 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id EEC6F610C7
	for <linux-scsi@archiver.kernel.org>; Sat, 18 Sep 2021 00:07:58 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1345024AbhIRAJT (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Fri, 17 Sep 2021 20:09:19 -0400
Received: from mail-pl1-f174.google.com ([209.85.214.174]:38431 "EHLO
        mail-pl1-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1344930AbhIRAJH (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Fri, 17 Sep 2021 20:09:07 -0400
Received: by mail-pl1-f174.google.com with SMTP id 5so7226976plo.5
        for <linux-scsi@vger.kernel.org>; Fri, 17 Sep 2021 17:07:45 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=pPkrLdSumEnx50+XwNbBHzTBTsGAttI9yp2MXlE2JtM=;
        b=nGCn+uYdx0wiy+o8O7tKOrjenqIjsWCTncPVUPxI5U2y4dAwtC0pvj4w0QThG/J0C4
         9nSNS7oHi4iEK9qptIRh/Mt3H5qK6KD5byG1BRUcK/8uhNsrnLfmoqhKKaPPuISDi4kM
         T0CvF5SPO0tXAsN3qYgUXJGZNtQPS3Sothzc+S1G+g21FCae64le3w0Dg8/KrWi+EH+s
         tlADdVYZIC3WID2kPtzNg5HnOR9j8KF0OtHV6MUeCSHyxdagwuOpPgt8WYBeoIj+9BHy
         n2q+ceS/hj115V8Yezf+QnTNkaLsHqlhu04se9Yg9K/9nvC933U1A1ZeDcQ/91+8ncKN
         VNSg==
X-Gm-Message-State: AOAM532L34d7uaiGMNWK+jJWsE0ZgXZMuXkg0RDE8/xFD1reQatfmo3r
        9BfAFeLGplx6IToxrUsoqoA=
X-Google-Smtp-Source: ABdhPJxLiAQpeIbH7/ih1M5nMylWtw7Et8Hb6wl3JPFuYWvMs5LcskhSHNMQGR80V4nMhgloyeRb2A==
X-Received: by 2002:a17:90a:e7ca:: with SMTP id kb10mr24223725pjb.33.1631923664860;
        Fri, 17 Sep 2021 17:07:44 -0700 (PDT)
Received: from bvanassche-linux.mtv.corp.google.com ([2620:15c:211:201:4c45:d635:d2d2:93])
        by smtp.gmail.com with ESMTPSA id bv16sm6403129pjb.12.2021.09.17.17.07.43
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 17 Sep 2021 17:07:44 -0700 (PDT)
From:   Bart Van Assche <bvanassche@acm.org>
To:     "Martin K . Petersen" <martin.petersen@oracle.com>
Cc:     linux-scsi@vger.kernel.org, Bart Van Assche <bvanassche@acm.org>,
        Hannes Reinecke <hare@kernel.org>,
        "James E.J. Bottomley" <jejb@linux.ibm.com>
Subject: [PATCH 54/84] myrb: Call scsi_done() directly
Date:   Fri, 17 Sep 2021 17:05:37 -0700
Message-Id: <20210918000607.450448-55-bvanassche@acm.org>
X-Mailer: git-send-email 2.33.0.464.g1972c5931b-goog
In-Reply-To: <20210918000607.450448-1-bvanassche@acm.org>
References: <20210918000607.450448-1-bvanassche@acm.org>
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
