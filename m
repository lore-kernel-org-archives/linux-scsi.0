Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 9B13FC433F5
	for <linux-scsi@archiver.kernel.org>; Mon,  2 May 2022 21:55:25 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1348244AbiEBV6u (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Mon, 2 May 2022 17:58:50 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45060 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1387742AbiEBV5w (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Mon, 2 May 2022 17:57:52 -0400
Received: from smtp-out2.suse.de (smtp-out2.suse.de [195.135.220.29])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 593E3646D
        for <linux-scsi@vger.kernel.org>; Mon,  2 May 2022 14:54:22 -0700 (PDT)
Received: from relay2.suse.de (relay2.suse.de [149.44.160.134])
        by smtp-out2.suse.de (Postfix) with ESMTP id 96B891F74D;
        Mon,  2 May 2022 21:54:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
        t=1651528460; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=Qg8pe/ZT6UuzTw+xkQ7k5SEqWlac313RiBRByvf/Hwk=;
        b=l4t2N5WGuy+htVJHxTPUg46b31tcKeKEmu9RRK5iJcW+R9jTK0WzTNpBlM/RxeF1yY+HqK
        jJPR0jYYfKvquf4cp9jZIwrdk17V/zUlH5o3BzIftEgiM0p8SC/GwIOqLI3JdSqKSwWwjL
        4nO3J/4xjo2ZlI3wha8tflph6+xKcIo=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
        s=susede2_ed25519; t=1651528460;
        h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=Qg8pe/ZT6UuzTw+xkQ7k5SEqWlac313RiBRByvf/Hwk=;
        b=4P/C5p8hfYEevzd1BDzTOXXqQ5WZwwLbLkxKliXCQXCtXzN/vKlGOVl/fEdd/OmoYrVOMe
        XrUSW0P087zYCFDg==
Received: from adalid.arch.suse.de (adalid.arch.suse.de [10.161.8.13])
        by relay2.suse.de (Postfix) with ESMTP id 925052C14E;
        Mon,  2 May 2022 21:54:20 +0000 (UTC)
Received: by adalid.arch.suse.de (Postfix, from userid 16045)
        id 909A55194134; Mon,  2 May 2022 23:54:20 +0200 (CEST)
From:   Hannes Reinecke <hare@suse.de>
To:     "Martin K. Petersen" <martin.petersen@oracle.com>
Cc:     Christoph Hellwig <hch@lst.de>,
        James Bottomley <james.bottomley@hansenpartnership.com>,
        linux-scsi@vger.kernel.org, Hannes Reinecke <hare@suse.com>
Subject: [PATCH 07/11] aha152x: look for stuck command when resetting device
Date:   Mon,  2 May 2022 23:54:12 +0200
Message-Id: <20220502215416.5351-8-hare@suse.de>
X-Mailer: git-send-email 2.29.2
In-Reply-To: <20220502215416.5351-1-hare@suse.de>
References: <20220502215416.5351-1-hare@suse.de>
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
index caeebfb67149..7e58f25c599b 100644
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
2.29.2

