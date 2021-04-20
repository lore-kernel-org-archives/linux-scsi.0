Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-16.8 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 3D812C433ED
	for <linux-scsi@archiver.kernel.org>; Tue, 20 Apr 2021 00:10:35 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 20C1A6109E
	for <linux-scsi@archiver.kernel.org>; Tue, 20 Apr 2021 00:10:35 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234336AbhDTALE (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Mon, 19 Apr 2021 20:11:04 -0400
Received: from mail-pf1-f178.google.com ([209.85.210.178]:42626 "EHLO
        mail-pf1-f178.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233861AbhDTAKs (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Mon, 19 Apr 2021 20:10:48 -0400
Received: by mail-pf1-f178.google.com with SMTP id w8so20843081pfn.9
        for <linux-scsi@vger.kernel.org>; Mon, 19 Apr 2021 17:10:16 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=P3Tcod3TH0JFd5lE7wTXHO86aC+dnMFUel0Qm4DhA8Q=;
        b=aUVfPLyACtF29ODNcPWBxnkrBE/DrnvJFLSKyOn4qhR2dF/FeLEZJLv9yVsnBzk3do
         cPjpNrZtR4euumcwQy+nay5yZk8H1tOv7NBu+7nIbmBnidGFSmE10I9XyM1lp+5/WEVh
         YgaVebHiCAX1Dg2K12G06R8Q8wHKqNz9aRZvKvBmrKe3pL6ceUYUHiGz+KUJpvWfF0bK
         Uvqwv+u560ufmP1lIKOLWJpwDhN1KtY83dTiwZ7hs6IVfAf9x12nFmvJUr1iyG+hRXiW
         eYNcoHe0eTzWOkRLlDDsAdesY+zdB22xIQQCden5aDfB41qJfxVWTfLQ0IQC3eUOQa+p
         i4zw==
X-Gm-Message-State: AOAM533qYl+irpc43gsUzGGepjx/HRqVCjGy+N1+5DFOuLb6yiVpPWJ0
        mBqn3j24zFTxhbcXSDdt+9U=
X-Google-Smtp-Source: ABdhPJyBVwLSNigDINSjjNwbwC3H56jrNE24YlKEMlStzHCnP5mlst8/lhlWNfYP/E6mxotTW3+tIQ==
X-Received: by 2002:a63:2206:: with SMTP id i6mr1477480pgi.265.1618877416028;
        Mon, 19 Apr 2021 17:10:16 -0700 (PDT)
Received: from asus.hsd1.ca.comcast.net ([2601:647:4000:d7:3e77:56a4:910b:42a9])
        by smtp.gmail.com with ESMTPSA id 33sm14006787pgq.21.2021.04.19.17.10.15
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 19 Apr 2021 17:10:15 -0700 (PDT)
From:   Bart Van Assche <bvanassche@acm.org>
To:     "Martin K . Petersen" <martin.petersen@oracle.com>,
        "James E . J . Bottomley" <jejb@linux.vnet.ibm.com>
Cc:     linux-scsi@vger.kernel.org, Christoph Hellwig <hch@lst.de>,
        Bart Van Assche <bvanassche@acm.org>,
        Hannes Reinecke <hare@kernel.org>
Subject: [PATCH 073/117] myrs: Convert to the scsi_status union
Date:   Mon, 19 Apr 2021 17:08:01 -0700
Message-Id: <20210420000845.25873-74-bvanassche@acm.org>
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
 drivers/scsi/myrs.c | 14 +++++++-------
 1 file changed, 7 insertions(+), 7 deletions(-)

diff --git a/drivers/scsi/myrs.c b/drivers/scsi/myrs.c
index 3b68c68d1716..d949de5b9820 100644
--- a/drivers/scsi/myrs.c
+++ b/drivers/scsi/myrs.c
@@ -1593,7 +1593,7 @@ static int myrs_queuecommand(struct Scsi_Host *shost,
 	int nsge;
 
 	if (!scmd->device->hostdata) {
-		scmd->result = (DID_NO_CONNECT << 16);
+		scmd->status.combined = (DID_NO_CONNECT << 16);
 		scmd->scsi_done(scmd);
 		return 0;
 	}
@@ -1602,7 +1602,7 @@ static int myrs_queuecommand(struct Scsi_Host *shost,
 	case REPORT_LUNS:
 		scsi_build_sense_buffer(0, scmd->sense_buffer, ILLEGAL_REQUEST,
 					0x20, 0x0);
-		scmd->result = (DRIVER_SENSE << 24) | SAM_STAT_CHECK_CONDITION;
+		scmd->status.combined = (DRIVER_SENSE << 24) | SAM_STAT_CHECK_CONDITION;
 		scmd->scsi_done(scmd);
 		return 0;
 	case MODE_SENSE:
@@ -1614,11 +1614,11 @@ static int myrs_queuecommand(struct Scsi_Host *shost,
 				/* Illegal request, invalid field in CDB */
 				scsi_build_sense_buffer(0, scmd->sense_buffer,
 					ILLEGAL_REQUEST, 0x24, 0);
-				scmd->result = (DRIVER_SENSE << 24) |
+				scmd->status.combined = (DRIVER_SENSE << 24) |
 					SAM_STAT_CHECK_CONDITION;
 			} else {
 				myrs_mode_sense(cs, scmd, ldev_info);
-				scmd->result = (DID_OK << 16);
+				scmd->status.combined = (DID_OK << 16);
 			}
 			scmd->scsi_done(scmd);
 			return 0;
@@ -1759,7 +1759,7 @@ static int myrs_queuecommand(struct Scsi_Host *shost,
 		scsi_for_each_sg(scmd, sgl, nsge, i) {
 			if (WARN_ON(!hw_sgl)) {
 				scsi_dma_unmap(scmd);
-				scmd->result = (DID_ERROR << 16);
+				scmd->status.combined = (DID_ERROR << 16);
 				scmd->scsi_done(scmd);
 				return 0;
 			}
@@ -2084,9 +2084,9 @@ static void myrs_handle_scsi(struct myrs_hba *cs, struct myrs_cmdblk *cmd_blk,
 		scsi_set_resid(scmd, cmd_blk->residual);
 	if (status == MYRS_STATUS_DEVICE_NON_RESPONSIVE ||
 	    status == MYRS_STATUS_DEVICE_NON_RESPONSIVE2)
-		scmd->result = (DID_BAD_TARGET << 16);
+		scmd->status.combined = (DID_BAD_TARGET << 16);
 	else
-		scmd->result = (DID_OK << 16) | status;
+		scmd->status.combined = (DID_OK << 16) | status;
 	scmd->scsi_done(scmd);
 }
 
