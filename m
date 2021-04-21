Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-16.8 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C2407C433B4
	for <linux-scsi@archiver.kernel.org>; Wed, 21 Apr 2021 17:49:00 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 95C6C61405
	for <linux-scsi@archiver.kernel.org>; Wed, 21 Apr 2021 17:49:00 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S244999AbhDURtc (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Wed, 21 Apr 2021 13:49:32 -0400
Received: from mx2.suse.de ([195.135.220.15]:52386 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S245091AbhDURtO (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
        Wed, 21 Apr 2021 13:49:14 -0400
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
Received: from relay2.suse.de (unknown [195.135.221.27])
        by mx2.suse.de (Postfix) with ESMTP id 2CF49B300;
        Wed, 21 Apr 2021 17:48:02 +0000 (UTC)
From:   Hannes Reinecke <hare@suse.de>
To:     "Martin K. Petersen" <martin.petersen@oracle.com>
Cc:     Christoph Hellwig <hch@lst.de>,
        James Bottomley <james.bottomley@hansenpartnership.com>,
        Bart van Assche <bvanassche@acm.org>,
        linux-scsi@vger.kernel.org, Hannes Reinecke <hare@suse.de>
Subject: [PATCH 38/42] fas216: convert to SCSI Accessors
Date:   Wed, 21 Apr 2021 19:47:45 +0200
Message-Id: <20210421174749.11221-39-hare@suse.de>
X-Mailer: git-send-email 2.29.2
In-Reply-To: <20210421174749.11221-1-hare@suse.de>
References: <20210421174749.11221-1-hare@suse.de>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

Use SCSI accessors to avoid referencing result field.

Signed-off-by: Hannes Reinecke <hare@suse.de>
---
 drivers/scsi/arm/fas216.c | 17 ++++++++++-------
 1 file changed, 10 insertions(+), 7 deletions(-)

diff --git a/drivers/scsi/arm/fas216.c b/drivers/scsi/arm/fas216.c
index 659bcfe5e2e6..0be5366bc38f 100644
--- a/drivers/scsi/arm/fas216.c
+++ b/drivers/scsi/arm/fas216.c
@@ -2048,27 +2048,28 @@ fas216_std_done(FAS216_Info *info, struct scsi_cmnd *SCpnt, unsigned int result)
 	set_status_byte(SCpnt, info->scsi.SCp.Status);
 
 	fas216_log_command(info, LOG_CONNECT, SCpnt,
-		"command complete, result=0x%08x", SCpnt->result);
+		"command complete, result=0x%08x",
+		scsi_get_compat_result(SCpnt));
 
 	/*
 	 * If the driver detected an error, we're all done.
 	 */
-	if (host_byte(SCpnt->result) != DID_OK)
+	if (get_host_byte(SCpnt) != DID_OK)
 		goto done;
 
 	/*
 	 * If the command returned CHECK_CONDITION or COMMAND_TERMINATED
 	 * status, request the sense information.
 	 */
-	if (status_byte(SCpnt->result) == CHECK_CONDITION ||
-	    status_byte(SCpnt->result) == COMMAND_TERMINATED)
+	if (get_status_byte(SCpnt) == SAM_STAT_CHECK_CONDITION ||
+	    get_status_byte(SCpnt) == SAM_STAT_COMMAND_TERMINATED)
 		goto request_sense;
 
 	/*
 	 * If the command did not complete with GOOD status,
 	 * we are all done here.
 	 */
-	if (status_byte(SCpnt->result) != GOOD)
+	if (get_status_byte(SCpnt) != GOOD)
 		goto done;
 
 	/*
@@ -2088,7 +2089,8 @@ fas216_std_done(FAS216_Info *info, struct scsi_cmnd *SCpnt, unsigned int result)
 		default:
 			scmd_printk(KERN_ERR, SCpnt,
 				    "incomplete data transfer detected: res=%08X ptr=%p len=%X\n",
-				    SCpnt->result, info->scsi.SCp.ptr,
+				    scsi_get_compat_result(SCpnt),
+				    info->scsi.SCp.ptr,
 				    info->scsi.SCp.this_residual);
 			scsi_print_command(SCpnt);
 			set_host_byte(SCpnt, DID_ERROR);
@@ -2217,7 +2219,8 @@ static int fas216_queue_command_lck(struct scsi_cmnd *SCpnt,
 
 	SCpnt->scsi_done = done;
 	SCpnt->host_scribble = (void *)fas216_std_done;
-	SCpnt->result = 0;
+	set_host_byte(SCpnt, DID_OK);
+	set_status_byte(SCpnt, SAM_STAT_GOOD);
 
 	init_SCp(SCpnt);
 
-- 
2.29.2

