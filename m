Return-Path: <SRS0=Wxou=75=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.8 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 763CEC433E0
	for <linux-scsi@archiver.kernel.org>; Tue, 16 Jun 2020 12:18:34 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 552EB21473
	for <linux-scsi@archiver.kernel.org>; Tue, 16 Jun 2020 12:18:34 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729009AbgFPMSb (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Tue, 16 Jun 2020 08:18:31 -0400
Received: from mx2.suse.de ([195.135.220.15]:37470 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728719AbgFPMSa (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
        Tue, 16 Jun 2020 08:18:30 -0400
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
Received: from relay2.suse.de (unknown [195.135.220.254])
        by mx2.suse.de (Postfix) with ESMTP id 38906B15B;
        Tue, 16 Jun 2020 12:18:33 +0000 (UTC)
From:   Hannes Reinecke <hare@suse.de>
To:     "Martin K. Petersen" <martin.petersen@oracle.com>
Cc:     Christoph Hellwig <hch@lst.de>,
        James Bottomley <james.bottomley@hansenpartnership.com>,
        linux-scsi@vger.kernel.org, Hannes Reinecke <hare@suse.de>
Subject: [PATCH 4/4] gdth: stop abusing ->request pointer for completion
Date:   Tue, 16 Jun 2020 14:18:21 +0200
Message-Id: <20200616121821.99113-5-hare@suse.de>
X-Mailer: git-send-email 2.16.4
In-Reply-To: <20200616121821.99113-1-hare@suse.de>
References: <20200616121821.99113-1-hare@suse.de>
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

Do not overload the request point for completion but rather use
a dedicated field in the cmndinfo structure.

Signed-off-by: Hannes Reinecke <hare@suse.de>
---
 drivers/scsi/gdth.c | 5 ++---
 drivers/scsi/gdth.h | 1 +
 2 files changed, 3 insertions(+), 3 deletions(-)

diff --git a/drivers/scsi/gdth.c b/drivers/scsi/gdth.c
index 6b509ba40017..aeebf10a32a3 100644
--- a/drivers/scsi/gdth.c
+++ b/drivers/scsi/gdth.c
@@ -327,7 +327,7 @@ static void gdth_scsi_done(struct scsi_cmnd *scp)
 	scp->host_scribble = NULL;
 
 	if (internal_command)
-		complete((struct completion *)scp->request);
+		complete(cmndinfo->complete);
 	else
 		scp->scsi_done(scp);
 }
@@ -353,13 +353,12 @@ int gdth_execute(gdth_ha_str *ha, gdth_cmd_str *gdtcmd, char *cmnd,
 	scp->device = ha->sdev;
 	memset(&cmndinfo, 0, sizeof(cmndinfo));
 
-	/* use request field to save the ptr. to completion struct. */
-	scp->request = (struct request *)&wait;
 	scp->cmd_len = 12;
 	scp->cmnd = cmnd;
 	cmndinfo.priority = IOCTL_PRI;
 	cmndinfo.internal_cmd_str = gdtcmd;
 	cmndinfo.internal_command = 1;
+	cmndinfo.complete = &wait;
 
 	TRACE(("__gdth_execute() cmd 0x%x\n", scp->cmnd[0]));
 	__gdth_queuecommand(ha, scp, &cmndinfo);
diff --git a/drivers/scsi/gdth.h b/drivers/scsi/gdth.h
index 01ddfd0cfda6..dca52583eefc 100644
--- a/drivers/scsi/gdth.h
+++ b/drivers/scsi/gdth.h
@@ -877,6 +877,7 @@ typedef struct {
 		u8 priority;
 		int timeout_count;		/* # of timeout calls */
 		volatile int wait_for_completion;
+		struct completion *complete;
 		u16 status;
 		u32 info;
 		enum dma_data_direction dma_dir;
-- 
2.16.4

