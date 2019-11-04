Return-Path: <SRS0=MVi0=Y4=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.7 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	URIBL_BLOCKED,USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 0BAA0CA9EDB
	for <linux-scsi@archiver.kernel.org>; Mon,  4 Nov 2019 09:02:37 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id E1FC02190F
	for <linux-scsi@archiver.kernel.org>; Mon,  4 Nov 2019 09:02:36 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728427AbfKDJCg (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Mon, 4 Nov 2019 04:02:36 -0500
Received: from mx2.suse.de ([195.135.220.15]:57148 "EHLO mx1.suse.de"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1728020AbfKDJCO (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
        Mon, 4 Nov 2019 04:02:14 -0500
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
Received: from relay2.suse.de (unknown [195.135.220.254])
        by mx1.suse.de (Postfix) with ESMTP id B841AB4A3;
        Mon,  4 Nov 2019 09:02:10 +0000 (UTC)
From:   Hannes Reinecke <hare@suse.de>
To:     "Martin K. Petersen" <martin.petersen@oracle.com>
Cc:     Christoph Hellwig <hch@lst.de>,
        Bart van Assche <bvanassche@acm.org>,
        James Bottomley <james.bottomley@hansenpartnership.com>,
        linux-scsi@vger.kernel.org, Hannes Reinecke <hare@suse.de>
Subject: [PATCH 34/52] myrs: use scsi_build_sense()
Date:   Mon,  4 Nov 2019 10:01:33 +0100
Message-Id: <20191104090151.129140-35-hare@suse.de>
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
 drivers/scsi/myrs.c | 9 ++-------
 1 file changed, 2 insertions(+), 7 deletions(-)

diff --git a/drivers/scsi/myrs.c b/drivers/scsi/myrs.c
index eb0dd566330a..70ba289aa24f 100644
--- a/drivers/scsi/myrs.c
+++ b/drivers/scsi/myrs.c
@@ -1602,9 +1602,7 @@ static int myrs_queuecommand(struct Scsi_Host *shost,
 
 	switch (scmd->cmnd[0]) {
 	case REPORT_LUNS:
-		scsi_build_sense_buffer(0, scmd->sense_buffer, ILLEGAL_REQUEST,
-					0x20, 0x0);
-		scmd->result = (DRIVER_SENSE << 24) | SAM_STAT_CHECK_CONDITION;
+		scsi_build_sense(scmd, 0, ILLEGAL_REQUEST, 0x20, 0x0);
 		scmd->scsi_done(scmd);
 		return 0;
 	case MODE_SENSE:
@@ -1614,10 +1612,7 @@ static int myrs_queuecommand(struct Scsi_Host *shost,
 			if ((scmd->cmnd[2] & 0x3F) != 0x3F &&
 			    (scmd->cmnd[2] & 0x3F) != 0x08) {
 				/* Illegal request, invalid field in CDB */
-				scsi_build_sense_buffer(0, scmd->sense_buffer,
-					ILLEGAL_REQUEST, 0x24, 0);
-				scmd->result = (DRIVER_SENSE << 24) |
-					SAM_STAT_CHECK_CONDITION;
+				scsi_build_sense(scmd, 0, ILLEGAL_REQUEST, 0x24, 0);
 			} else {
 				myrs_mode_sense(cs, scmd, ldev_info);
 				scmd->result = (DID_OK << 16);
-- 
2.16.4

