Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-18.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,
	USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A373FC432BE
	for <linux-scsi@archiver.kernel.org>; Tue, 17 Aug 2021 09:17:05 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 8E29260FA0
	for <linux-scsi@archiver.kernel.org>; Tue, 17 Aug 2021 09:17:05 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239660AbhHQJRh (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Tue, 17 Aug 2021 05:17:37 -0400
Received: from smtp-out2.suse.de ([195.135.220.29]:47560 "EHLO
        smtp-out2.suse.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239349AbhHQJRR (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Tue, 17 Aug 2021 05:17:17 -0400
Received: from relay2.suse.de (relay2.suse.de [149.44.160.134])
        by smtp-out2.suse.de (Postfix) with ESMTP id 1F06B2001C;
        Tue, 17 Aug 2021 09:16:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
        t=1629191802; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=8NCxU4/1zd+k2/TeWycg5N5FfmmIoUDYnXA4EHkYlAk=;
        b=QXqiNd7x6hm7AANfPhB7hgF/gQrBoHWmKSjkzfSj5mKZcicrGlJpLuvoXA90EV04MrXfJS
        Ii5a5tor8jt+cMiig4gXs8RfpDN63CkhTnmplkhXsTvdbvOkMW9FMcSzYm/F4Ke+z7gQt1
        bk21iQX9T2FiynnU00cwv7m0NI7IRWU=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
        s=susede2_ed25519; t=1629191802;
        h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=8NCxU4/1zd+k2/TeWycg5N5FfmmIoUDYnXA4EHkYlAk=;
        b=ywj/hCwMpjNTnhgo6B+anfICcSVaTHc+tkkRYghM1w/Nm1hEmIyC6X7fJ4r7fTB7WxDdtz
        GzVc8kUznmN+tlAg==
Received: from adalid.arch.suse.de (adalid.arch.suse.de [10.161.8.13])
        by relay2.suse.de (Postfix) with ESMTP id 1843FA3BA6;
        Tue, 17 Aug 2021 09:16:42 +0000 (UTC)
Received: by adalid.arch.suse.de (Postfix, from userid 16045)
        id 15B6C518CE85; Tue, 17 Aug 2021 11:16:42 +0200 (CEST)
From:   Hannes Reinecke <hare@suse.de>
To:     "Martin K. Petersen" <martin.petersen@oracle.com>
Cc:     Christoph Hellwig <hch@lst.de>,
        James Bottomley <james.bottomley@hansenpartnership.com>,
        linux-scsi@vger.kernel.org, Hannes Reinecke <hare@suse.com>
Subject: [PATCH 19/51] ncr53c8xx: Complete all commands during bus reset
Date:   Tue, 17 Aug 2021 11:14:24 +0200
Message-Id: <20210817091456.73342-20-hare@suse.de>
X-Mailer: git-send-email 2.29.2
In-Reply-To: <20210817091456.73342-1-hare@suse.de>
References: <20210817091456.73342-1-hare@suse.de>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

From: Hannes Reinecke <hare@suse.com>

ncr_reset_bus() will complete all outstanding commands anyway, so
there's no need to single out a specific command.

Signed-off-by: Hannes Reinecke <hare@suse.com>
---
 drivers/scsi/ncr53c8xx.c | 35 ++---------------------------------
 1 file changed, 2 insertions(+), 33 deletions(-)

diff --git a/drivers/scsi/ncr53c8xx.c b/drivers/scsi/ncr53c8xx.c
index 3d2daaf2368c..1c1f5df83dca 100644
--- a/drivers/scsi/ncr53c8xx.c
+++ b/drivers/scsi/ncr53c8xx.c
@@ -4553,12 +4553,8 @@ static void ncr_start_reset(struct ncb *np)
 **
 **==========================================================
 */
-static int ncr_reset_bus (struct ncb *np, struct scsi_cmnd *cmd)
+static int ncr_reset_bus (struct ncb *np)
 {
-/*	struct scsi_device        *device    = cmd->device; */
-	struct ccb *cp;
-	int found;
-
 /*
  * Return immediately if reset is in progress.
  */
@@ -4572,24 +4568,6 @@ static int ncr_reset_bus (struct ncb *np, struct scsi_cmnd *cmd)
  * delay of 2 seconds will be completed.
  */
 	ncr_start_reset(np);
-/*
- * First, look in the wakeup list
- */
-	for (found=0, cp=np->ccb; cp; cp=cp->link_ccb) {
-		/*
-		**	look for the ccb of this command.
-		*/
-		if (cp->host_status == HS_IDLE) continue;
-		if (cp->cmd == cmd) {
-			found = 1;
-			break;
-		}
-	}
-/*
- * Then, look in the waiting list
- */
-	if (!found && retrieve_from_waiting_list(0, np, cmd))
-		found = 1;
 /*
  * Wake-up all awaiting commands with DID_RESET.
  */
@@ -4598,15 +4576,6 @@ static int ncr_reset_bus (struct ncb *np, struct scsi_cmnd *cmd)
  * Wake-up all pending commands with HS_RESET -> DID_RESET.
  */
 	ncr_wakeup(np, HS_RESET);
-/*
- * If the involved command was not in a driver queue, and the 
- * command is not currently in the waiting list, complete it
- * with DID_RESET status in order to keep it alive.
- */
-	if (!found && !retrieve_from_waiting_list(0, np, cmd)) {
-		set_host_byte(cmd, DID_RESET);
-		ncr_queue_done_cmd(np, cmd);
-	}
 
 	return SUCCESS;
 }
@@ -8124,7 +8093,7 @@ static int ncr53c8xx_bus_reset(struct scsi_cmnd *cmd)
 	 */
 
 	spin_lock_irqsave(&np->smp_lock, flags);
-	sts = ncr_reset_bus(np, cmd);
+	sts = ncr_reset_bus(np);
 
 	done_list     = np->done_list;
 	np->done_list = NULL;
-- 
2.29.2

