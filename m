Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-16.8 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 206C4C43460
	for <linux-scsi@archiver.kernel.org>; Tue, 20 Apr 2021 02:14:17 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 02A66613AC
	for <linux-scsi@archiver.kernel.org>; Tue, 20 Apr 2021 02:14:16 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233570AbhDTCOq (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Mon, 19 Apr 2021 22:14:46 -0400
Received: from mail-pj1-f50.google.com ([209.85.216.50]:51126 "EHLO
        mail-pj1-f50.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233354AbhDTCOn (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Mon, 19 Apr 2021 22:14:43 -0400
Received: by mail-pj1-f50.google.com with SMTP id u11so15345197pjr.0
        for <linux-scsi@vger.kernel.org>; Mon, 19 Apr 2021 19:14:13 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=9GsvRWiyVMLvkccm4G2qYrJzFcy2d0F23q8SraQ6RrY=;
        b=J7ijmyxzptHwddCdRAfZc8lE0eJHy4BEMKp4x1A2Te3OYW98RggFvHSI4dSM1ZZFiI
         6bhpZcMuaoc+rPpjprvWNO6ZZZ4b8vZZhOVFm5iVE7Erw7jXyzMSpZMPKDY+g8sptLDd
         k88mu1iRwKtpF2nAb/UFfSudQOHs7yRJ8ZmTTi1DcS9Auv0eNUZmH/+YxAU1iJyuoObG
         wRqLa3iNDFw5sjLaW7nu8cSqQchzkyx0VW3Wqgo23TwmiCV0PRG6W9dw+UXmtuTGx59T
         P1XEWNqq8stLX/iu4udbFLbu2XJzYfqTatIP/Q9dKnIkOvQHD0er/eKin8rtSs6YAaFQ
         VE1w==
X-Gm-Message-State: AOAM531Vjm8PwU5ENG/HS9OSiiCcAjpruU64iDPW9FDhFlxB9SfOqQDa
        ZTgiuBrpEdTd9ovqNE4cQi0gKy3oFiKeig==
X-Google-Smtp-Source: ABdhPJxfRa1c/sloVIF+BCCUcKrnyFqPRiKvBQ2WKKqwYCY1n2E9BF7dtIUjqUMgQjWOVJczI80eZA==
X-Received: by 2002:a17:90a:c209:: with SMTP id e9mr2309049pjt.104.1618884852988;
        Mon, 19 Apr 2021 19:14:12 -0700 (PDT)
Received: from asus.hsd1.ca.comcast.net ([2601:647:4000:d7:3e77:56a4:910b:42a9])
        by smtp.gmail.com with ESMTPSA id mq2sm630984pjb.24.2021.04.19.19.14.11
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 19 Apr 2021 19:14:12 -0700 (PDT)
From:   Bart Van Assche <bvanassche@acm.org>
To:     "Martin K . Petersen" <martin.petersen@oracle.com>,
        "James E . J . Bottomley" <jejb@linux.vnet.ibm.com>
Cc:     linux-scsi@vger.kernel.org, Christoph Hellwig <hch@lst.de>,
        Bart Van Assche <bvanassche@acm.org>,
        Don Brace <don.brace@microchip.com>,
        Charles Chiou <charles.chiou@tw.promise.com>
Subject: [PATCH 094/117] stex: Convert to the scsi_status union
Date:   Mon, 19 Apr 2021 19:13:39 -0700
Message-Id: <20210420021402.27678-4-bvanassche@acm.org>
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

Cc: Charles Chiou <charles.chiou@tw.promise.com>
Signed-off-by: Bart Van Assche <bvanassche@acm.org>
---
 drivers/scsi/stex.c | 20 ++++++++++----------
 1 file changed, 10 insertions(+), 10 deletions(-)

diff --git a/drivers/scsi/stex.c b/drivers/scsi/stex.c
index 12471208c7a8..cb97449181c7 100644
--- a/drivers/scsi/stex.c
+++ b/drivers/scsi/stex.c
@@ -398,7 +398,7 @@ static struct status_msg *stex_get_status(struct st_hba *hba)
 static void stex_invalid_field(struct scsi_cmnd *cmd,
 			       void (*done)(struct scsi_cmnd *))
 {
-	cmd->result = (DRIVER_SENSE << 24) | SAM_STAT_CHECK_CONDITION;
+	cmd->status.combined = (DRIVER_SENSE << 24) | SAM_STAT_CHECK_CONDITION;
 
 	/* "Invalid field in cdb" */
 	scsi_build_sense_buffer(0, cmd->sense_buffer, ILLEGAL_REQUEST, 0x24,
@@ -576,7 +576,7 @@ static void return_abnormal_state(struct st_hba *hba, int status)
 		ccb->req = NULL;
 		if (ccb->cmd) {
 			scsi_dma_unmap(ccb->cmd);
-			ccb->cmd->result = status << 16;
+			ccb->cmd->status.combined = status << 16;
 			ccb->cmd->scsi_done(ccb->cmd);
 			ccb->cmd = NULL;
 		}
@@ -607,7 +607,7 @@ stex_queuecommand_lck(struct scsi_cmnd *cmd, void (*done)(struct scsi_cmnd *))
 	lun = cmd->device->lun;
 	hba = (struct st_hba *) &host->hostdata[0];
 	if (hba->mu_status == MU_STATE_NOCONNECT) {
-		cmd->result = DID_NO_CONNECT;
+		cmd->status.combined = DID_NO_CONNECT;
 		done(cmd);
 		return 0;
 	}
@@ -625,7 +625,7 @@ stex_queuecommand_lck(struct scsi_cmnd *cmd, void (*done)(struct scsi_cmnd *))
 		if (page == 0x8 || page == 0x3f) {
 			scsi_sg_copy_from_buffer(cmd, ms10_caching_page,
 						 sizeof(ms10_caching_page));
-			cmd->result = DID_OK << 16;
+			cmd->status.combined = DID_OK << 16;
 			done(cmd);
 		} else
 			stex_invalid_field(cmd, done);
@@ -644,14 +644,14 @@ stex_queuecommand_lck(struct scsi_cmnd *cmd, void (*done)(struct scsi_cmnd *))
 		break;
 	case TEST_UNIT_READY:
 		if (id == host->max_id - 1) {
-			cmd->result = DID_OK << 16;
+			cmd->status.combined = DID_OK << 16;
 			done(cmd);
 			return 0;
 		}
 		break;
 	case INQUIRY:
 		if (lun >= host->max_lun) {
-			cmd->result = DID_NO_CONNECT << 16;
+			cmd->status.combined = DID_NO_CONNECT << 16;
 			done(cmd);
 			return 0;
 		}
@@ -661,7 +661,7 @@ stex_queuecommand_lck(struct scsi_cmnd *cmd, void (*done)(struct scsi_cmnd *))
 			(cmd->cmnd[1] & INQUIRY_EVPD) == 0) {
 			scsi_sg_copy_from_buffer(cmd, (void *)console_inq_page,
 						 sizeof(console_inq_page));
-			cmd->result = DID_OK << 16;
+			cmd->status.combined = DID_OK << 16;
 			done(cmd);
 		} else
 			stex_invalid_field(cmd, done);
@@ -680,9 +680,9 @@ stex_queuecommand_lck(struct scsi_cmnd *cmd, void (*done)(struct scsi_cmnd *))
 			ver.host_no = hba->host->host_no;
 			cp_len = scsi_sg_copy_from_buffer(cmd, &ver, cp_len);
 			if (sizeof(ver) == cp_len)
-				cmd->result = DID_OK << 16;
+				cmd->status.combined = DID_OK << 16;
 			else
-				cmd->result = DID_ERROR << 16;
+				cmd->status.combined = DID_ERROR << 16;
 			done(cmd);
 			return 0;
 		}
@@ -766,7 +766,7 @@ static void stex_scsi_done(struct st_ccb *ccb)
 			break;
 	}
 
-	cmd->result = result;
+	cmd->status.combined = result;
 	cmd->scsi_done(cmd);
 }
 
