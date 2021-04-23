Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-16.7 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A4C72C433ED
	for <linux-scsi@archiver.kernel.org>; Fri, 23 Apr 2021 11:40:35 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 61DA761445
	for <linux-scsi@archiver.kernel.org>; Fri, 23 Apr 2021 11:40:35 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S242152AbhDWLlK (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Fri, 23 Apr 2021 07:41:10 -0400
Received: from mx2.suse.de ([195.135.220.15]:47474 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S238429AbhDWLks (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
        Fri, 23 Apr 2021 07:40:48 -0400
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
Received: from relay2.suse.de (unknown [195.135.221.27])
        by mx2.suse.de (Postfix) with ESMTP id B976EB1F6;
        Fri, 23 Apr 2021 11:39:55 +0000 (UTC)
From:   Hannes Reinecke <hare@suse.de>
To:     "Martin K. Petersen" <martin.petersen@oracle.com>
Cc:     Christoph Hellwig <hch@lst.de>,
        James Bottomley <james.bottomley@hansenpartnership.com>,
        linux-scsi@vger.kernel.org, Bart van Assche <bvanassche@acm.org>,
        Hannes Reinecke <hare@suse.de>
Subject: [PATCH 31/39] fas216: translate message to host byte status
Date:   Fri, 23 Apr 2021 13:39:36 +0200
Message-Id: <20210423113944.42672-32-hare@suse.de>
X-Mailer: git-send-email 2.29.2
In-Reply-To: <20210423113944.42672-1-hare@suse.de>
References: <20210423113944.42672-1-hare@suse.de>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

Instead of setting the message byte translate it to the appropriate
host byte. As error recovery would return DID_ERROR for any non-zero
message byte the translation doesn't change the error handling.

Signed-off-by: Hannes Reinecke <hare@suse.de>
---
 drivers/scsi/arm/fas216.c | 9 +++++----
 1 file changed, 5 insertions(+), 4 deletions(-)

diff --git a/drivers/scsi/arm/fas216.c b/drivers/scsi/arm/fas216.c
index 2e687ce60753..96db9058d61b 100644
--- a/drivers/scsi/arm/fas216.c
+++ b/drivers/scsi/arm/fas216.c
@@ -2042,8 +2042,10 @@ fas216_std_done(FAS216_Info *info, struct scsi_cmnd *SCpnt, unsigned int result)
 {
 	info->stats.fins += 1;
 
-	SCpnt->result = result << 16 | info->scsi.SCp.Message << 8 |
-			info->scsi.SCp.Status;
+	set_host_byte(SCpnt, result);
+	if (result == DID_OK)
+		translate_msg_byte(SCpnt, info->scsi.SCp.Message);
+	set_status_byte(SCpnt, info->scsi.SCp.Status);
 
 	fas216_log_command(info, LOG_CONNECT, SCpnt,
 		"command complete, result=0x%08x", SCpnt->result);
@@ -2051,8 +2053,7 @@ fas216_std_done(FAS216_Info *info, struct scsi_cmnd *SCpnt, unsigned int result)
 	/*
 	 * If the driver detected an error, we're all done.
 	 */
-	if (host_byte(SCpnt->result) != DID_OK ||
-	    msg_byte(SCpnt->result) != COMMAND_COMPLETE)
+	if (get_host_byte(SCpnt->result) != DID_OK)
 		goto done;
 
 	/*
-- 
2.29.2

