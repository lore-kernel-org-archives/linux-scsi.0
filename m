Return-Path: <SRS0=MVi0=Y4=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.7 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	URIBL_BLOCKED,USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 81937CA9ED4
	for <linux-scsi@archiver.kernel.org>; Mon,  4 Nov 2019 09:02:24 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 590FD20656
	for <linux-scsi@archiver.kernel.org>; Mon,  4 Nov 2019 09:02:24 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728372AbfKDJCX (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Mon, 4 Nov 2019 04:02:23 -0500
Received: from mx2.suse.de ([195.135.220.15]:57312 "EHLO mx1.suse.de"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1728317AbfKDJCS (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
        Mon, 4 Nov 2019 04:02:18 -0500
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
Received: from relay2.suse.de (unknown [195.135.220.254])
        by mx1.suse.de (Postfix) with ESMTP id 5008FB4BB;
        Mon,  4 Nov 2019 09:02:11 +0000 (UTC)
From:   Hannes Reinecke <hare@suse.de>
To:     "Martin K. Petersen" <martin.petersen@oracle.com>
Cc:     Christoph Hellwig <hch@lst.de>,
        Bart van Assche <bvanassche@acm.org>,
        James Bottomley <james.bottomley@hansenpartnership.com>,
        linux-scsi@vger.kernel.org, Hannes Reinecke <hare@suse.de>
Subject: [PATCH 33/52] myrb: use scsi_build_sense()
Date:   Mon,  4 Nov 2019 10:01:32 +0100
Message-Id: <20191104090151.129140-34-hare@suse.de>
X-Mailer: git-send-email 2.16.4
In-Reply-To: <20191104090151.129140-1-hare@suse.de>
References: <20191104090151.129140-1-hare@suse.de>
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

Use scsi_build_sense() to format the sense code.

Signed-off-by: Hannes Reinecke <hare@suse.de>
---
 drivers/scsi/myrb.c | 61 ++++++++++++-----------------------------------------
 1 file changed, 14 insertions(+), 47 deletions(-)

diff --git a/drivers/scsi/myrb.c b/drivers/scsi/myrb.c
index 539ac8ce4fcd..04a75bd0dcb5 100644
--- a/drivers/scsi/myrb.c
+++ b/drivers/scsi/myrb.c
@@ -1449,10 +1449,7 @@ static int myrb_ldev_queuecommand(struct Scsi_Host *shost,
 	case INQUIRY:
 		if (scmd->cmnd[1] & 1) {
 			/* Illegal request, invalid field in CDB */
-			scsi_build_sense_buffer(0, scmd->sense_buffer,
-						ILLEGAL_REQUEST, 0x24, 0);
-			scmd->result = (DRIVER_SENSE << 24) |
-				SAM_STAT_CHECK_CONDITION;
+			scsi_build_sense(scmd, 0, ILLEGAL_REQUEST, 0x24, 0);
 		} else {
 			myrb_inquiry(cb, scmd);
 			scmd->result = (DID_OK << 16);
@@ -1467,10 +1464,7 @@ static int myrb_ldev_queuecommand(struct Scsi_Host *shost,
 		if ((scmd->cmnd[2] & 0x3F) != 0x3F &&
 		    (scmd->cmnd[2] & 0x3F) != 0x08) {
 			/* Illegal request, invalid field in CDB */
-			scsi_build_sense_buffer(0, scmd->sense_buffer,
-						ILLEGAL_REQUEST, 0x24, 0);
-			scmd->result = (DRIVER_SENSE << 24) |
-				SAM_STAT_CHECK_CONDITION;
+			scsi_build_sense(scmd, 0, ILLEGAL_REQUEST, 0x24, 0);
 		} else {
 			myrb_mode_sense(cb, scmd, ldev_info);
 			scmd->result = (DID_OK << 16);
@@ -1481,20 +1475,14 @@ static int myrb_ldev_queuecommand(struct Scsi_Host *shost,
 		if ((scmd->cmnd[1] & 1) ||
 		    (scmd->cmnd[8] & 1)) {
 			/* Illegal request, invalid field in CDB */
-			scsi_build_sense_buffer(0, scmd->sense_buffer,
-						ILLEGAL_REQUEST, 0x24, 0);
-			scmd->result = (DRIVER_SENSE << 24) |
-				SAM_STAT_CHECK_CONDITION;
+			scsi_build_sense(scmd, 0, ILLEGAL_REQUEST, 0x24, 0);
 			scmd->scsi_done(scmd);
 			return 0;
 		}
 		lba = get_unaligned_be32(&scmd->cmnd[2]);
 		if (lba) {
 			/* Illegal request, invalid field in CDB */
-			scsi_build_sense_buffer(0, scmd->sense_buffer,
-						ILLEGAL_REQUEST, 0x24, 0);
-			scmd->result = (DRIVER_SENSE << 24) |
-				SAM_STAT_CHECK_CONDITION;
+			scsi_build_sense(scmd, 0, ILLEGAL_REQUEST, 0x24, 0);
 			scmd->scsi_done(scmd);
 			return 0;
 		}
@@ -1508,10 +1496,7 @@ static int myrb_ldev_queuecommand(struct Scsi_Host *shost,
 	case SEND_DIAGNOSTIC:
 		if (scmd->cmnd[1] != 0x04) {
 			/* Illegal request, invalid field in CDB */
-			scsi_build_sense_buffer(0, scmd->sense_buffer,
-						ILLEGAL_REQUEST, 0x24, 0);
-			scmd->result = (DRIVER_SENSE << 24) |
-				SAM_STAT_CHECK_CONDITION;
+			scsi_build_sense(scmd, 0, ILLEGAL_REQUEST, 0x24, 0);
 		} else {
 			/* Assume good status */
 			scmd->result = (DID_OK << 16);
@@ -1521,10 +1506,7 @@ static int myrb_ldev_queuecommand(struct Scsi_Host *shost,
 	case READ_6:
 		if (ldev_info->state == MYRB_DEVICE_WO) {
 			/* Data protect, attempt to read invalid data */
-			scsi_build_sense_buffer(0, scmd->sense_buffer,
-						DATA_PROTECT, 0x21, 0x06);
-			scmd->result = (DRIVER_SENSE << 24) |
-				SAM_STAT_CHECK_CONDITION;
+			scsi_build_sense(scmd, 0, DATA_PROTECT, 0x21, 0x06);
 			scmd->scsi_done(scmd);
 			return 0;
 		}
@@ -1538,10 +1520,7 @@ static int myrb_ldev_queuecommand(struct Scsi_Host *shost,
 	case READ_10:
 		if (ldev_info->state == MYRB_DEVICE_WO) {
 			/* Data protect, attempt to read invalid data */
-			scsi_build_sense_buffer(0, scmd->sense_buffer,
-						DATA_PROTECT, 0x21, 0x06);
-			scmd->result = (DRIVER_SENSE << 24) |
-				SAM_STAT_CHECK_CONDITION;
+			scsi_build_sense(scmd, 0, DATA_PROTECT, 0x21, 0x06);
 			scmd->scsi_done(scmd);
 			return 0;
 		}
@@ -1555,10 +1534,7 @@ static int myrb_ldev_queuecommand(struct Scsi_Host *shost,
 	case READ_12:
 		if (ldev_info->state == MYRB_DEVICE_WO) {
 			/* Data protect, attempt to read invalid data */
-			scsi_build_sense_buffer(0, scmd->sense_buffer,
-						DATA_PROTECT, 0x21, 0x06);
-			scmd->result = (DRIVER_SENSE << 24) |
-				SAM_STAT_CHECK_CONDITION;
+			scsi_build_sense(scmd, 0, DATA_PROTECT, 0x21, 0x06);
 			scmd->scsi_done(scmd);
 			return 0;
 		}
@@ -1571,9 +1547,7 @@ static int myrb_ldev_queuecommand(struct Scsi_Host *shost,
 		break;
 	default:
 		/* Illegal request, invalid opcode */
-		scsi_build_sense_buffer(0, scmd->sense_buffer,
-					ILLEGAL_REQUEST, 0x20, 0);
-		scmd->result = (DRIVER_SENSE << 24) | SAM_STAT_CHECK_CONDITION;
+		scsi_build_sense(scmd, 0, ILLEGAL_REQUEST, 0x20, 0);
 		scmd->scsi_done(scmd);
 		return 0;
 	}
@@ -2354,25 +2328,19 @@ static void myrb_handle_scsi(struct myrb_hba *cb, struct myrb_cmdblk *cmd_blk,
 			"Bad Data Encountered\n");
 		if (scmd->sc_data_direction == DMA_FROM_DEVICE)
 			/* Unrecovered read error */
-			scsi_build_sense_buffer(0, scmd->sense_buffer,
-						MEDIUM_ERROR, 0x11, 0);
+			scsi_build_sense(scmd, 0, MEDIUM_ERROR, 0x11, 0);
 		else
 			/* Write error */
-			scsi_build_sense_buffer(0, scmd->sense_buffer,
-						MEDIUM_ERROR, 0x0C, 0);
-		scmd->result = (DID_OK << 16) | SAM_STAT_CHECK_CONDITION;
+			scsi_build_sense(scmd, 0, MEDIUM_ERROR, 0x0C, 0);
 		break;
 	case MYRB_STATUS_IRRECOVERABLE_DATA_ERROR:
 		scmd_printk(KERN_ERR, scmd, "Irrecoverable Data Error\n");
 		if (scmd->sc_data_direction == DMA_FROM_DEVICE)
 			/* Unrecovered read error, auto-reallocation failed */
-			scsi_build_sense_buffer(0, scmd->sense_buffer,
-						MEDIUM_ERROR, 0x11, 0x04);
+			scsi_build_sense(scmd, 0, MEDIUM_ERROR, 0x11, 0x04);
 		else
 			/* Write error, auto-reallocation failed */
-			scsi_build_sense_buffer(0, scmd->sense_buffer,
-						MEDIUM_ERROR, 0x0C, 0x02);
-		scmd->result = (DID_OK << 16) | SAM_STAT_CHECK_CONDITION;
+			scsi_build_sense(scmd, 0, MEDIUM_ERROR, 0x0C, 0x02);
 		break;
 	case MYRB_STATUS_LDRV_NONEXISTENT_OR_OFFLINE:
 		dev_dbg(&scmd->device->sdev_gendev,
@@ -2383,8 +2351,7 @@ static void myrb_handle_scsi(struct myrb_hba *cb, struct myrb_cmdblk *cmd_blk,
 		dev_dbg(&scmd->device->sdev_gendev,
 			    "Attempt to Access Beyond End of Logical Drive");
 		/* Logical block address out of range */
-		scsi_build_sense_buffer(0, scmd->sense_buffer,
-					NOT_READY, 0x21, 0);
+		scsi_build_sense(scmd, 0, NOT_READY, 0x21, 0);
 		break;
 	case MYRB_STATUS_DEVICE_NONRESPONSIVE:
 		dev_dbg(&scmd->device->sdev_gendev, "Device nonresponsive\n");
-- 
2.16.4

