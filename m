Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-18.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,
	USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 2BA11C432BE
	for <linux-scsi@archiver.kernel.org>; Tue, 17 Aug 2021 09:16:55 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 12CED60F11
	for <linux-scsi@archiver.kernel.org>; Tue, 17 Aug 2021 09:16:55 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239545AbhHQJR1 (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Tue, 17 Aug 2021 05:17:27 -0400
Received: from smtp-out1.suse.de ([195.135.220.28]:33304 "EHLO
        smtp-out1.suse.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239151AbhHQJRQ (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Tue, 17 Aug 2021 05:17:16 -0400
Received: from relay2.suse.de (relay2.suse.de [149.44.160.134])
        by smtp-out1.suse.de (Postfix) with ESMTP id 1B08D21D26;
        Tue, 17 Aug 2021 09:16:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
        t=1629191802; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=Oiya3yiIsKryh7s1PYvS4XpqSdNu7+s1gDW8melp4j4=;
        b=Zixd+C5ejuaDyPVkFqCCBqQfvAQ3CNfGBwGszm3glYqzyARA3BLb5pX4UwjG8BswjtgofT
        OXSlBx9v0nuPo5PZ4W7Cypu4z5ew4zFfF6/RIhdCEdgazv4VkW2X5LW5veD03L0UFz+Sdd
        /Ra7atE4UBMoPo1TMKTyhA4y6MMbEIM=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
        s=susede2_ed25519; t=1629191802;
        h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=Oiya3yiIsKryh7s1PYvS4XpqSdNu7+s1gDW8melp4j4=;
        b=teQhy/vWyyCxfv5TaY2HhP5e34kCYjWN3LmShXPQmdCpwQWKJyWBxGiybRGxDTU7H0Z9Az
        M/btEPutaA/bBKCQ==
Received: from adalid.arch.suse.de (adalid.arch.suse.de [10.161.8.13])
        by relay2.suse.de (Postfix) with ESMTP id 0E3B3A3BA4;
        Tue, 17 Aug 2021 09:16:42 +0000 (UTC)
Received: by adalid.arch.suse.de (Postfix, from userid 16045)
        id 09F70518CE81; Tue, 17 Aug 2021 11:16:42 +0200 (CEST)
From:   Hannes Reinecke <hare@suse.de>
To:     "Martin K. Petersen" <martin.petersen@oracle.com>
Cc:     Christoph Hellwig <hch@lst.de>,
        James Bottomley <james.bottomley@hansenpartnership.com>,
        linux-scsi@vger.kernel.org, Hannes Reinecke <hare@suse.de>,
        Hannes Reinecke <hare@suse.com>,
        David Kershner <david.kershner@unisys.com>
Subject: [PATCH 17/51] visorhba: select first device on the bus for bus_reset()
Date:   Tue, 17 Aug 2021 11:14:22 +0200
Message-Id: <20210817091456.73342-18-hare@suse.de>
X-Mailer: git-send-email 2.29.2
In-Reply-To: <20210817091456.73342-1-hare@suse.de>
References: <20210817091456.73342-1-hare@suse.de>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

As we're moving away from having the scsi command as an argument
to bus_reset() we need to select the first device on the bus to
send the bus reset to.

Signed-off-by: Hannes Reinecke <hare@suse.com>
Cc: David Kershner <david.kershner@unisys.com>
---
 .../staging/unisys/visorhba/visorhba_main.c   | 21 ++++++++++---------
 1 file changed, 11 insertions(+), 10 deletions(-)

diff --git a/drivers/staging/unisys/visorhba/visorhba_main.c b/drivers/staging/unisys/visorhba/visorhba_main.c
index fdbcb6576fcd..bfb4a70432f3 100644
--- a/drivers/staging/unisys/visorhba/visorhba_main.c
+++ b/drivers/staging/unisys/visorhba/visorhba_main.c
@@ -368,23 +368,24 @@ static int visorhba_device_reset_handler(struct scsi_cmnd *scsicmd)
  */
 static int visorhba_bus_reset_handler(struct scsi_cmnd *scsicmd)
 {
-	struct scsi_device *scsidev;
+	struct scsi_device *scsidev = NULL, *tmp;
+	struct Scsi_Host *scsihost = scsicmd->device->host;
 	struct visordisk_info *vdisk;
-	int rtn;
+	int rtn = SUCCESS;
 
-	scsidev = scsicmd->device;
-	shost_for_each_device(scsidev, scsidev->host) {
-		vdisk = scsidev->hostdata;
+	shost_for_each_device(tmp, scsihost) {
+		if (tmp->channel != scsicmd->device->channel)
+			continue;
+		vdisk = tmp->hostdata;
 		if (atomic_read(&vdisk->error_count) < VISORHBA_ERROR_COUNT)
 			atomic_inc(&vdisk->error_count);
 		else
 			atomic_set(&vdisk->ios_threshold, IOS_ERROR_THRESHOLD);
+		if (!scsidev)
+			scsidev = tmp;
 	}
-	rtn = forward_taskmgmt_command(TASK_MGMT_BUS_RESET, scsidev);
-	if (rtn == SUCCESS) {
-		scsicmd->result = DID_RESET << 16;
-		scsicmd->scsi_done(scsicmd);
-	}
+	if (scsidev)
+		rtn = forward_taskmgmt_command(TASK_MGMT_BUS_RESET, scsidev);
 	return rtn;
 }
 
-- 
2.29.2

