Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-16.8 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E32A9C433B4
	for <linux-scsi@archiver.kernel.org>; Tue, 20 Apr 2021 00:10:34 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id C347B6109E
	for <linux-scsi@archiver.kernel.org>; Tue, 20 Apr 2021 00:10:34 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234332AbhDTALE (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Mon, 19 Apr 2021 20:11:04 -0400
Received: from mail-pj1-f48.google.com ([209.85.216.48]:51914 "EHLO
        mail-pj1-f48.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233679AbhDTAKp (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Mon, 19 Apr 2021 20:10:45 -0400
Received: by mail-pj1-f48.google.com with SMTP id lt13so10010654pjb.1
        for <linux-scsi@vger.kernel.org>; Mon, 19 Apr 2021 17:10:15 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=AKuCJw4hvxbOEZYMOymCke3KW1R+kZZU80rjRoEIlLY=;
        b=oxTmp6aRDItoXXeeSezcYZEmoGbSc6ntdzhdNJVf3JgryKGaK9TXXNSrqy3dpS2i2j
         YFTpsUE3fRYHxybwfOZMy656zidny16yQpb0cSqbDMyVQC/d5TyhnJMzYCQj81PMlV0l
         5sWFXQwO7RbZFVntAm1083BAgy7n0EI/n18mIoEFnWxrWdOxylzyJPTcSXznhFGrvt3U
         ZPHfZ6HXqygwKe5kWpG+QgO73WKT4QYmzYmMvY/4HqGWouKZ5YQaT0pJU8XPuR2LZTQM
         nZUsoYTrXRHqsCgA3bExOTebuvU66OVaUe2/P9UVvb3e/56zAQp8wRZsVG5Wj+iD2np+
         eKCQ==
X-Gm-Message-State: AOAM533pfPspgt2JJzF+yMLMTfR1+TKc2QZlQ6gMFZPrWOE8aOHXV7UL
        3V4TOKq6WwP7cO0MxknXmVk=
X-Google-Smtp-Source: ABdhPJw/zvZnK0rZamBFbZxR5jCzjdaiM7bP33OFWW1YGPH+9/gw971Db71UA4crNvWE4aqe9nlNbA==
X-Received: by 2002:a17:90b:388c:: with SMTP id mu12mr1798953pjb.51.1618877414886;
        Mon, 19 Apr 2021 17:10:14 -0700 (PDT)
Received: from asus.hsd1.ca.comcast.net ([2601:647:4000:d7:3e77:56a4:910b:42a9])
        by smtp.gmail.com with ESMTPSA id 33sm14006787pgq.21.2021.04.19.17.10.13
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 19 Apr 2021 17:10:14 -0700 (PDT)
From:   Bart Van Assche <bvanassche@acm.org>
To:     "Martin K . Petersen" <martin.petersen@oracle.com>,
        "James E . J . Bottomley" <jejb@linux.vnet.ibm.com>
Cc:     linux-scsi@vger.kernel.org, Christoph Hellwig <hch@lst.de>,
        Bart Van Assche <bvanassche@acm.org>,
        Hannes Reinecke <hare@kernel.org>
Subject: [PATCH 072/117] myrb: Convert to the scsi_status union
Date:   Mon, 19 Apr 2021 17:08:00 -0700
Message-Id: <20210420000845.25873-73-bvanassche@acm.org>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20210420000845.25873-1-bvanassche@acm.org>
References: <20210420000845.25873-1-bvanassche@acm.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

An explanation of the purpose of this patch is available in the patch
"scsi: Introduce the scsi_status union".

Cc: Hannes Reinecke <hare@kernel.org>
Signed-off-by: Bart Van Assche <bvanassche@acm.org>
---
 drivers/scsi/myrb.c | 48 ++++++++++++++++++++++-----------------------
 1 file changed, 24 insertions(+), 24 deletions(-)

diff --git a/drivers/scsi/myrb.c b/drivers/scsi/myrb.c
index d9c82e211ae7..ecd6af832c94 100644
--- a/drivers/scsi/myrb.c
+++ b/drivers/scsi/myrb.c
@@ -1280,7 +1280,7 @@ static int myrb_pthru_queuecommand(struct Scsi_Host *shost,
 	nsge = scsi_dma_map(scmd);
 	if (nsge > 1) {
 		dma_pool_free(cb->dcdb_pool, dcdb, dcdb_addr);
-		scmd->result = (DID_ERROR << 16);
+		scmd->status.combined = (DID_ERROR << 16);
 		scmd->scsi_done(scmd);
 		return 0;
 	}
@@ -1435,13 +1435,13 @@ static int myrb_ldev_queuecommand(struct Scsi_Host *shost,
 	    ldev_info->state != MYRB_DEVICE_WO) {
 		dev_dbg(&shost->shost_gendev, "ldev %u in state %x, skip\n",
 			sdev->id, ldev_info ? ldev_info->state : 0xff);
-		scmd->result = (DID_BAD_TARGET << 16);
+		scmd->status.combined = (DID_BAD_TARGET << 16);
 		scmd->scsi_done(scmd);
 		return 0;
 	}
 	switch (scmd->cmnd[0]) {
 	case TEST_UNIT_READY:
-		scmd->result = (DID_OK << 16);
+		scmd->status.combined = (DID_OK << 16);
 		scmd->scsi_done(scmd);
 		return 0;
 	case INQUIRY:
@@ -1449,16 +1449,16 @@ static int myrb_ldev_queuecommand(struct Scsi_Host *shost,
 			/* Illegal request, invalid field in CDB */
 			scsi_build_sense_buffer(0, scmd->sense_buffer,
 						ILLEGAL_REQUEST, 0x24, 0);
-			scmd->result = (DRIVER_SENSE << 24) |
+			scmd->status.combined = (DRIVER_SENSE << 24) |
 				SAM_STAT_CHECK_CONDITION;
 		} else {
 			myrb_inquiry(cb, scmd);
-			scmd->result = (DID_OK << 16);
+			scmd->status.combined = (DID_OK << 16);
 		}
 		scmd->scsi_done(scmd);
 		return 0;
 	case SYNCHRONIZE_CACHE:
-		scmd->result = (DID_OK << 16);
+		scmd->status.combined = (DID_OK << 16);
 		scmd->scsi_done(scmd);
 		return 0;
 	case MODE_SENSE:
@@ -1467,11 +1467,11 @@ static int myrb_ldev_queuecommand(struct Scsi_Host *shost,
 			/* Illegal request, invalid field in CDB */
 			scsi_build_sense_buffer(0, scmd->sense_buffer,
 						ILLEGAL_REQUEST, 0x24, 0);
-			scmd->result = (DRIVER_SENSE << 24) |
+			scmd->status.combined = (DRIVER_SENSE << 24) |
 				SAM_STAT_CHECK_CONDITION;
 		} else {
 			myrb_mode_sense(cb, scmd, ldev_info);
-			scmd->result = (DID_OK << 16);
+			scmd->status.combined = (DID_OK << 16);
 		}
 		scmd->scsi_done(scmd);
 		return 0;
@@ -1481,7 +1481,7 @@ static int myrb_ldev_queuecommand(struct Scsi_Host *shost,
 			/* Illegal request, invalid field in CDB */
 			scsi_build_sense_buffer(0, scmd->sense_buffer,
 						ILLEGAL_REQUEST, 0x24, 0);
-			scmd->result = (DRIVER_SENSE << 24) |
+			scmd->status.combined = (DRIVER_SENSE << 24) |
 				SAM_STAT_CHECK_CONDITION;
 			scmd->scsi_done(scmd);
 			return 0;
@@ -1491,7 +1491,7 @@ static int myrb_ldev_queuecommand(struct Scsi_Host *shost,
 			/* Illegal request, invalid field in CDB */
 			scsi_build_sense_buffer(0, scmd->sense_buffer,
 						ILLEGAL_REQUEST, 0x24, 0);
-			scmd->result = (DRIVER_SENSE << 24) |
+			scmd->status.combined = (DRIVER_SENSE << 24) |
 				SAM_STAT_CHECK_CONDITION;
 			scmd->scsi_done(scmd);
 			return 0;
@@ -1501,18 +1501,18 @@ static int myrb_ldev_queuecommand(struct Scsi_Host *shost,
 		return 0;
 	case REQUEST_SENSE:
 		myrb_request_sense(cb, scmd);
-		scmd->result = (DID_OK << 16);
+		scmd->status.combined = (DID_OK << 16);
 		return 0;
 	case SEND_DIAGNOSTIC:
 		if (scmd->cmnd[1] != 0x04) {
 			/* Illegal request, invalid field in CDB */
 			scsi_build_sense_buffer(0, scmd->sense_buffer,
 						ILLEGAL_REQUEST, 0x24, 0);
-			scmd->result = (DRIVER_SENSE << 24) |
+			scmd->status.combined = (DRIVER_SENSE << 24) |
 				SAM_STAT_CHECK_CONDITION;
 		} else {
 			/* Assume good status */
-			scmd->result = (DID_OK << 16);
+			scmd->status.combined = (DID_OK << 16);
 		}
 		scmd->scsi_done(scmd);
 		return 0;
@@ -1521,7 +1521,7 @@ static int myrb_ldev_queuecommand(struct Scsi_Host *shost,
 			/* Data protect, attempt to read invalid data */
 			scsi_build_sense_buffer(0, scmd->sense_buffer,
 						DATA_PROTECT, 0x21, 0x06);
-			scmd->result = (DRIVER_SENSE << 24) |
+			scmd->status.combined = (DRIVER_SENSE << 24) |
 				SAM_STAT_CHECK_CONDITION;
 			scmd->scsi_done(scmd);
 			return 0;
@@ -1538,7 +1538,7 @@ static int myrb_ldev_queuecommand(struct Scsi_Host *shost,
 			/* Data protect, attempt to read invalid data */
 			scsi_build_sense_buffer(0, scmd->sense_buffer,
 						DATA_PROTECT, 0x21, 0x06);
-			scmd->result = (DRIVER_SENSE << 24) |
+			scmd->status.combined = (DRIVER_SENSE << 24) |
 				SAM_STAT_CHECK_CONDITION;
 			scmd->scsi_done(scmd);
 			return 0;
@@ -1555,7 +1555,7 @@ static int myrb_ldev_queuecommand(struct Scsi_Host *shost,
 			/* Data protect, attempt to read invalid data */
 			scsi_build_sense_buffer(0, scmd->sense_buffer,
 						DATA_PROTECT, 0x21, 0x06);
-			scmd->result = (DRIVER_SENSE << 24) |
+			scmd->status.combined = (DRIVER_SENSE << 24) |
 				SAM_STAT_CHECK_CONDITION;
 			scmd->scsi_done(scmd);
 			return 0;
@@ -1571,7 +1571,7 @@ static int myrb_ldev_queuecommand(struct Scsi_Host *shost,
 		/* Illegal request, invalid opcode */
 		scsi_build_sense_buffer(0, scmd->sense_buffer,
 					ILLEGAL_REQUEST, 0x20, 0);
-		scmd->result = (DRIVER_SENSE << 24) | SAM_STAT_CHECK_CONDITION;
+		scmd->status.combined = (DRIVER_SENSE << 24) | SAM_STAT_CHECK_CONDITION;
 		scmd->scsi_done(scmd);
 		return 0;
 	}
@@ -1635,7 +1635,7 @@ static int myrb_queuecommand(struct Scsi_Host *shost,
 	struct scsi_device *sdev = scmd->device;
 
 	if (sdev->channel > myrb_logical_channel(shost)) {
-		scmd->result = (DID_BAD_TARGET << 16);
+		scmd->status.combined = (DID_BAD_TARGET << 16);
 		scmd->scsi_done(scmd);
 		return 0;
 	}
@@ -2345,7 +2345,7 @@ static void myrb_handle_scsi(struct myrb_hba *cb, struct myrb_cmdblk *cmd_blk,
 	switch (status) {
 	case MYRB_STATUS_SUCCESS:
 	case MYRB_STATUS_DEVICE_BUSY:
-		scmd->result = (DID_OK << 16) | status;
+		scmd->status.combined = (DID_OK << 16) | status;
 		break;
 	case MYRB_STATUS_BAD_DATA:
 		dev_dbg(&scmd->device->sdev_gendev,
@@ -2358,7 +2358,7 @@ static void myrb_handle_scsi(struct myrb_hba *cb, struct myrb_cmdblk *cmd_blk,
 			/* Write error */
 			scsi_build_sense_buffer(0, scmd->sense_buffer,
 						MEDIUM_ERROR, 0x0C, 0);
-		scmd->result = (DID_OK << 16) | SAM_STAT_CHECK_CONDITION;
+		scmd->status.combined = (DID_OK << 16) | SAM_STAT_CHECK_CONDITION;
 		break;
 	case MYRB_STATUS_IRRECOVERABLE_DATA_ERROR:
 		scmd_printk(KERN_ERR, scmd, "Irrecoverable Data Error\n");
@@ -2370,12 +2370,12 @@ static void myrb_handle_scsi(struct myrb_hba *cb, struct myrb_cmdblk *cmd_blk,
 			/* Write error, auto-reallocation failed */
 			scsi_build_sense_buffer(0, scmd->sense_buffer,
 						MEDIUM_ERROR, 0x0C, 0x02);
-		scmd->result = (DID_OK << 16) | SAM_STAT_CHECK_CONDITION;
+		scmd->status.combined = (DID_OK << 16) | SAM_STAT_CHECK_CONDITION;
 		break;
 	case MYRB_STATUS_LDRV_NONEXISTENT_OR_OFFLINE:
 		dev_dbg(&scmd->device->sdev_gendev,
 			    "Logical Drive Nonexistent or Offline");
-		scmd->result = (DID_BAD_TARGET << 16);
+		scmd->status.combined = (DID_BAD_TARGET << 16);
 		break;
 	case MYRB_STATUS_ACCESS_BEYOND_END_OF_LDRV:
 		dev_dbg(&scmd->device->sdev_gendev,
@@ -2386,12 +2386,12 @@ static void myrb_handle_scsi(struct myrb_hba *cb, struct myrb_cmdblk *cmd_blk,
 		break;
 	case MYRB_STATUS_DEVICE_NONRESPONSIVE:
 		dev_dbg(&scmd->device->sdev_gendev, "Device nonresponsive\n");
-		scmd->result = (DID_BAD_TARGET << 16);
+		scmd->status.combined = (DID_BAD_TARGET << 16);
 		break;
 	default:
 		scmd_printk(KERN_ERR, scmd,
 			    "Unexpected Error Status %04X", status);
-		scmd->result = (DID_ERROR << 16);
+		scmd->status.combined = (DID_ERROR << 16);
 		break;
 	}
 	scmd->scsi_done(scmd);
