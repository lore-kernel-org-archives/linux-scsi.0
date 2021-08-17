Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-18.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,
	USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 60F67C4320E
	for <linux-scsi@archiver.kernel.org>; Tue, 17 Aug 2021 09:17:10 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 4495160F11
	for <linux-scsi@archiver.kernel.org>; Tue, 17 Aug 2021 09:17:10 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239505AbhHQJRm (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Tue, 17 Aug 2021 05:17:42 -0400
Received: from smtp-out1.suse.de ([195.135.220.28]:33328 "EHLO
        smtp-out1.suse.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239385AbhHQJRR (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Tue, 17 Aug 2021 05:17:17 -0400
Received: from relay2.suse.de (relay2.suse.de [149.44.160.134])
        by smtp-out1.suse.de (Postfix) with ESMTP id 9250A21D79;
        Tue, 17 Aug 2021 09:16:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
        t=1629191802; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=JecH4CfJXhymQm/c1omSTVfsGKipcjuifjDv8CkMsYM=;
        b=FaUW4qUYGKmO/IDlflL5Y+CX5ubdke8n0UArDJQanwJMqX4J+CcImVsPft8fWkWoU79Gid
        iFmNAvDs9+iZ1oPL0M/8uqMZ4vZTHwVn4GGVBcNRvffMJMa5HQhVmn/YqYvIos6/sjzIbT
        ovY3cZguTb8+fwrleVB+betIhBAexT4=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
        s=susede2_ed25519; t=1629191802;
        h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=JecH4CfJXhymQm/c1omSTVfsGKipcjuifjDv8CkMsYM=;
        b=LY39z50nky/O9RivEp3lL+ouYb74TqyGfBJKLqMt7vor6OV/6gZ3Y784TIkCQLXedXQNYH
        0Kn0ZAkj7v2L4PCw==
Received: from adalid.arch.suse.de (adalid.arch.suse.de [10.161.8.13])
        by relay2.suse.de (Postfix) with ESMTP id 8D1F5A3B91;
        Tue, 17 Aug 2021 09:16:42 +0000 (UTC)
Received: by adalid.arch.suse.de (Postfix, from userid 16045)
        id 8AC03518CEA9; Tue, 17 Aug 2021 11:16:42 +0200 (CEST)
From:   Hannes Reinecke <hare@suse.de>
To:     "Martin K. Petersen" <martin.petersen@oracle.com>
Cc:     Christoph Hellwig <hch@lst.de>,
        James Bottomley <james.bottomley@hansenpartnership.com>,
        linux-scsi@vger.kernel.org, Hannes Reinecke <hare@suse.com>
Subject: [PATCH 37/51] aha152x: look for stuck command when resetting device
Date:   Tue, 17 Aug 2021 11:14:42 +0200
Message-Id: <20210817091456.73342-38-hare@suse.de>
X-Mailer: git-send-email 2.29.2
In-Reply-To: <20210817091456.73342-1-hare@suse.de>
References: <20210817091456.73342-1-hare@suse.de>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

From: Hannes Reinecke <hare@suse.com>

The LLDD needs a command to send the reset with, so look at the
list of outstanding commands to get one.

Signed-off-by: Hannes Reinecke <hare@suse.com>
---
 drivers/scsi/aha152x.c | 26 +++++++++++++++-----------
 1 file changed, 15 insertions(+), 11 deletions(-)

diff --git a/drivers/scsi/aha152x.c b/drivers/scsi/aha152x.c
index 6fbdb6f3c996..3f96b38b7b56 100644
--- a/drivers/scsi/aha152x.c
+++ b/drivers/scsi/aha152x.c
@@ -1045,24 +1045,28 @@ static int aha152x_abort(struct scsi_cmnd *SCpnt)
  */
 static int aha152x_device_reset(struct scsi_cmnd * SCpnt)
 {
-	struct Scsi_Host *shpnt = SCpnt->device->host;
+	struct scsi_device *sdev = SCpnt->device;
+	struct Scsi_Host *shpnt = sdev->host;
 	DECLARE_COMPLETION(done);
 	int ret, issued, disconnected;
-	unsigned char old_cmd_len = SCpnt->cmd_len;
+	unsigned char old_cmd_len;
 	unsigned long flags;
 	unsigned long timeleft;
 
-	if(CURRENT_SC==SCpnt) {
-		scmd_printk(KERN_ERR, SCpnt, "cannot reset current device\n");
-		return FAILED;
-	}
-
 	DO_LOCK(flags);
-	issued       = remove_SC(&ISSUE_SC, SCpnt) == NULL;
-	disconnected = issued && remove_SC(&DISCONNECTED_SC, SCpnt);
+	/* Look for the stuck command */
+	SCpnt = remove_lun_SC(&ISSUE_SC, sdev->id, sdev->lun);
+	if (SCpnt)
+		issued = 1;
+	else
+		SCpnt = remove_lun_SC(&DISCONNECTED_SC, sdev->id, sdev->lun);
+	if (!issued && SCpnt)
+		disconnected = 1;
 	DO_UNLOCK(flags);
-
-	SCpnt->cmd_len         = 0;
+	if (!SCpnt)
+		return FAILED;
+	old_cmd_len = SCpnt->cmd_len;
+	SCpnt->cmd_len = 0;
 
 	aha152x_internal_queue(SCpnt, &done, resetting, reset_done);
 
-- 
2.29.2

