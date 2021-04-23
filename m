Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-16.7 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 9E8D7C433B4
	for <linux-scsi@archiver.kernel.org>; Fri, 23 Apr 2021 11:40:35 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 795E26115B
	for <linux-scsi@archiver.kernel.org>; Fri, 23 Apr 2021 11:40:34 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S242348AbhDWLlJ (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Fri, 23 Apr 2021 07:41:09 -0400
Received: from mx2.suse.de ([195.135.220.15]:47472 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S242183AbhDWLks (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
        Fri, 23 Apr 2021 07:40:48 -0400
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
Received: from relay2.suse.de (unknown [195.135.221.27])
        by mx2.suse.de (Postfix) with ESMTP id A690AB1E1;
        Fri, 23 Apr 2021 11:39:55 +0000 (UTC)
From:   Hannes Reinecke <hare@suse.de>
To:     "Martin K. Petersen" <martin.petersen@oracle.com>
Cc:     Christoph Hellwig <hch@lst.de>,
        James Bottomley <james.bottomley@hansenpartnership.com>,
        linux-scsi@vger.kernel.org, Bart van Assche <bvanassche@acm.org>,
        Hannes Reinecke <hare@suse.de>
Subject: [PATCH 27/39] acornscsi: translate message byte to host byte
Date:   Fri, 23 Apr 2021 13:39:32 +0200
Message-Id: <20210423113944.42672-28-hare@suse.de>
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
And use SCSI result accessors while we're at it.

Signed-off-by: Hannes Reinecke <hare@suse.de>
---
 drivers/scsi/arm/acornscsi.c | 21 ++++++++++++---------
 1 file changed, 12 insertions(+), 9 deletions(-)

diff --git a/drivers/scsi/arm/acornscsi.c b/drivers/scsi/arm/acornscsi.c
index 8b75d896f393..74767abf79be 100644
--- a/drivers/scsi/arm/acornscsi.c
+++ b/drivers/scsi/arm/acornscsi.c
@@ -794,7 +794,10 @@ static void acornscsi_done(AS_Host *host, struct scsi_cmnd **SCpntp,
 
 	acornscsi_dma_cleanup(host);
 
-	SCpnt->result = result << 16 | host->scsi.SCp.Message << 8 | host->scsi.SCp.Status;
+	set_host_byte(SCpnt, result);
+	if (result == DID_OK)
+		translate_msg_byte(SCpnt, host->scsi.SCp.Message);
+	set_status_byte(SCpnt, host->scsi.SCp.Status);
 
 	/*
 	 * In theory, this should not happen.  In practice, it seems to.
@@ -833,12 +836,12 @@ static void acornscsi_done(AS_Host *host, struct scsi_cmnd **SCpntp,
 			xfer_warn = 0;
 
 		if (xfer_warn) {
-		    switch (status_byte(SCpnt->result)) {
-		    case CHECK_CONDITION:
-		    case COMMAND_TERMINATED:
-		    case BUSY:
-		    case QUEUE_FULL:
-		    case RESERVATION_CONFLICT:
+		    switch (get_status_byte(SCpnt)) {
+		    case SAM_STAT_CHECK_CONDITION:
+		    case SAM_STAT_COMMAND_TERMINATED:
+		    case SAM_STAT_BUSY:
+		    case SAM_STAT_TASK_SET_FULL:
+		    case SAM_STAT_RESERVATION_CONFLICT:
 			break;
 
 		    default:
@@ -2470,7 +2473,7 @@ static int acornscsi_queuecmd_lck(struct scsi_cmnd *SCpnt,
     if (acornscsi_cmdtype(SCpnt->cmnd[0]) == CMD_WRITE && (NO_WRITE & (1 << SCpnt->device->id))) {
 	printk(KERN_CRIT "scsi%d.%c: WRITE attempted with NO_WRITE flag set\n",
 	    host->host->host_no, '0' + SCpnt->device->id);
-	SCpnt->result = DID_NO_CONNECT << 16;
+	set_host_byte(SCpnt, DID_NO_CONNECT);
 	done(SCpnt);
 	return 0;
     }
@@ -2492,7 +2495,7 @@ static int acornscsi_queuecmd_lck(struct scsi_cmnd *SCpnt,
 	unsigned long flags;
 
 	if (!queue_add_cmd_ordered(&host->queues.issue, SCpnt)) {
-	    SCpnt->result = DID_ERROR << 16;
+		set_host_byte(SCpnt, DID_ERROR);
 	    done(SCpnt);
 	    return 0;
 	}
-- 
2.29.2

