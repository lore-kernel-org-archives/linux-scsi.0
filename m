Return-Path: <linux-scsi-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 0FCBFE784BE
	for <linux-scsi@archiver.kernel.org>; Mon,  2 Oct 2023 15:49:37 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238247AbjJBPth (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Mon, 2 Oct 2023 11:49:37 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44860 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238225AbjJBPtf (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Mon, 2 Oct 2023 11:49:35 -0400
Received: from smtp-out1.suse.de (smtp-out1.suse.de [195.135.220.28])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0570DDA
        for <linux-scsi@vger.kernel.org>; Mon,  2 Oct 2023 08:49:32 -0700 (PDT)
Received: from relay2.suse.de (relay2.suse.de [149.44.160.134])
        by smtp-out1.suse.de (Postfix) with ESMTP id BA2EB21866;
        Mon,  2 Oct 2023 15:49:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
        t=1696261770; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=nDCCx2clL9jRQIDWhtSZNAWMZqQZLjRIfSvRZ7BOSg0=;
        b=maH/YFM++gAwDjbFg+h5mWMSIdUoUB76cuNZO/5VM7gZnGyDzV9zYRtWrmJjmqErxBEapF
        0MHN3v3WRBtBnuH82Hi0EAe6+oywbyH5SMuueYa0q+yWHhCt7le6gDfFTnwBRH1HSsZkkC
        osmf77O2r2FsfH6TuvyThP+wUhF+rug=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
        s=susede2_ed25519; t=1696261770;
        h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=nDCCx2clL9jRQIDWhtSZNAWMZqQZLjRIfSvRZ7BOSg0=;
        b=bahAHJ9yKfNz1GKS1pYneDsUhJoep+p9LjQ4/BiMYzUr6T9/qfu3wqROdg30DfcRUtIhJr
        ljHhLa5TdoM10PBQ==
Received: from adalid.arch.suse.de (adalid.arch.suse.de [10.161.8.13])
        by relay2.suse.de (Postfix) with ESMTP id 9B5382C146;
        Mon,  2 Oct 2023 15:49:30 +0000 (UTC)
Received: by adalid.arch.suse.de (Postfix, from userid 16045)
        id B249051E7563; Mon,  2 Oct 2023 17:49:30 +0200 (CEST)
From:   Hannes Reinecke <hare@suse.de>
To:     "Martin K. Petersen" <martin.petersen@oracle.com>
Cc:     James Bottomley <james.bottomley@hansenpartnership.com>,
        linux-scsi@vger.kernel.org, Christoph Hellwig <hch@lst.de>,
        Hannes Reinecke <hare@suse.de>
Subject: [PATCH 03/15] aha152x: look for stuck command when resetting device
Date:   Mon,  2 Oct 2023 17:49:15 +0200
Message-Id: <20231002154927.68643-4-hare@suse.de>
X-Mailer: git-send-email 2.35.3
In-Reply-To: <20231002154927.68643-1-hare@suse.de>
References: <20231002154927.68643-1-hare@suse.de>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

The LLDD needs a command to send the reset with, so look at the
list of outstanding commands to get one.

Signed-off-by: Hannes Reinecke <hare@suse.de>
---
 drivers/scsi/aha152x.c | 26 +++++++++++++++-----------
 1 file changed, 15 insertions(+), 11 deletions(-)

diff --git a/drivers/scsi/aha152x.c b/drivers/scsi/aha152x.c
index 055adb349b0e..936c9f5c6f23 100644
--- a/drivers/scsi/aha152x.c
+++ b/drivers/scsi/aha152x.c
@@ -1070,24 +1070,28 @@ static int aha152x_abort(struct scsi_cmnd *SCpnt)
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
 
 	aha152x_internal_queue(SCpnt, &done, resetting);
 
-- 
2.35.3

