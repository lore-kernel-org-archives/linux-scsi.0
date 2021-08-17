Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-18.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,
	USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A71A2C4338F
	for <linux-scsi@archiver.kernel.org>; Tue, 17 Aug 2021 09:17:23 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 8FD1760720
	for <linux-scsi@archiver.kernel.org>; Tue, 17 Aug 2021 09:17:23 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239790AbhHQJRv (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Tue, 17 Aug 2021 05:17:51 -0400
Received: from smtp-out2.suse.de ([195.135.220.29]:47556 "EHLO
        smtp-out2.suse.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239475AbhHQJRT (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Tue, 17 Aug 2021 05:17:19 -0400
Received: from relay2.suse.de (relay2.suse.de [149.44.160.134])
        by smtp-out2.suse.de (Postfix) with ESMTP id 84F7F20026;
        Tue, 17 Aug 2021 09:16:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
        t=1629191802; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=0vwyJBWng0TPVjo41nAhl0juWjGVuG5WfGU5eoZAWu0=;
        b=n6mO7tNtOuJ2l30izjUJBx8ReE7pXn7ETrYFmxWSdTl9jry6idTAvywsBrPdhWhNFoISXa
        gQqsmlNQ4TSc4X+y2jNEmXEBHFV/K2mO6APIWw6U5TAYuBAuUQNw6ZBSg59WEYmxW6Qekf
        pFKJa9YA2sq3u1BA11t+3kJOxRpOcBY=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
        s=susede2_ed25519; t=1629191802;
        h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=0vwyJBWng0TPVjo41nAhl0juWjGVuG5WfGU5eoZAWu0=;
        b=uiZCJ4W5gFsCcsszA5LF4g28BpQEFPDAent4mnTDUuOJdQJgltZodB52w2kj+DOD2hZj4Q
        o42A/Z5OlFG/AsBA==
Received: from adalid.arch.suse.de (adalid.arch.suse.de [10.161.8.13])
        by relay2.suse.de (Postfix) with ESMTP id 7ED43A3BB3;
        Tue, 17 Aug 2021 09:16:42 +0000 (UTC)
Received: by adalid.arch.suse.de (Postfix, from userid 16045)
        id 7BF86518CEA5; Tue, 17 Aug 2021 11:16:42 +0200 (CEST)
From:   Hannes Reinecke <hare@suse.de>
To:     "Martin K. Petersen" <martin.petersen@oracle.com>
Cc:     Christoph Hellwig <hch@lst.de>,
        James Bottomley <james.bottomley@hansenpartnership.com>,
        linux-scsi@vger.kernel.org, Hannes Reinecke <hare@suse.de>,
        Hannes Reinecke <hare@suse.com>
Subject: [PATCH 35/51] pmcraid: select first available device for target reset
Date:   Tue, 17 Aug 2021 11:14:40 +0200
Message-Id: <20210817091456.73342-36-hare@suse.de>
X-Mailer: git-send-email 2.29.2
In-Reply-To: <20210817091456.73342-1-hare@suse.de>
References: <20210817091456.73342-1-hare@suse.de>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

As we're moving away from using a scsi command as argument for
eh_XX callbacks we should be selecting the first available device
for sending a target reset to.

Signed-off-by: Hannes Reinecke <hare@suse.com>
---
 drivers/scsi/pmcraid.c | 16 ++++++++++++++--
 1 file changed, 14 insertions(+), 2 deletions(-)

diff --git a/drivers/scsi/pmcraid.c b/drivers/scsi/pmcraid.c
index 9397eaef0bac..27a625be7618 100644
--- a/drivers/scsi/pmcraid.c
+++ b/drivers/scsi/pmcraid.c
@@ -3063,9 +3063,21 @@ static int pmcraid_eh_bus_reset_handler(struct Scsi_Host *host, int channel)
 
 static int pmcraid_eh_target_reset_handler(struct scsi_cmnd *scmd)
 {
-	scmd_printk(KERN_INFO, scmd,
+	struct Scsi_Host *shost = scmd->device->host;
+	struct scsi_device *scsi_dev = NULL, *tmp;
+
+	shost_for_each_device(tmp, shost) {
+		if ((tmp->channel == scmd->device->channel) &&
+		    (tmp->id == scmd->device->id)) {
+			scsi_dev = tmp;
+			break;
+		}
+	}
+	if (!scsi_dev)
+		return FAILED;
+	sdev_printk(KERN_INFO, scsi_dev,
 		    "Doing target reset due to an I/O command timeout.\n");
-	return pmcraid_reset_device(scmd->device,
+	return pmcraid_reset_device(scsi_dev,
 				    PMCRAID_INTERNAL_TIMEOUT,
 				    RESET_DEVICE_TARGET);
 }
-- 
2.29.2

