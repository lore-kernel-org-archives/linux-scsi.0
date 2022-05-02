Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id EABFBC433FE
	for <linux-scsi@archiver.kernel.org>; Mon,  2 May 2022 21:55:28 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1387805AbiEBV6y (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Mon, 2 May 2022 17:58:54 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45064 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1387758AbiEBV5w (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Mon, 2 May 2022 17:57:52 -0400
Received: from smtp-out2.suse.de (smtp-out2.suse.de [195.135.220.29])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 59627646E
        for <linux-scsi@vger.kernel.org>; Mon,  2 May 2022 14:54:22 -0700 (PDT)
Received: from relay2.suse.de (relay2.suse.de [149.44.160.134])
        by smtp-out2.suse.de (Postfix) with ESMTP id 90F551F74B;
        Mon,  2 May 2022 21:54:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
        t=1651528460; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=YrVm8k2hvraGXYxcRYNzlvlDUmeoz5pQ/UhJRgs3+10=;
        b=LNOlFV2EpzN2IFr1rMCu6Q0fzrn7HmbYIRiwMT71pp/UGnnbrfwtZ6JVnJPEZKvlmpRx2n
        a11vWbgehcUQ68BTw6MvEbsiszlTQl4h+8JWIojnuviR0DwtIj1mOOIz4s79nw2oICKAnj
        PJ25+NLpLOLw7J5GqQQZQUZbtgpoXH0=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
        s=susede2_ed25519; t=1651528460;
        h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=YrVm8k2hvraGXYxcRYNzlvlDUmeoz5pQ/UhJRgs3+10=;
        b=Bni8bsDQI1nrnjZW9Z8QWZJaDa/GI34a9acDrCpJK0si8rTenVHWoDjfcqPFq3iwaBbjFT
        C9qmx4ijZ7V0f0BA==
Received: from adalid.arch.suse.de (adalid.arch.suse.de [10.161.8.13])
        by relay2.suse.de (Postfix) with ESMTP id 8883B2C149;
        Mon,  2 May 2022 21:54:20 +0000 (UTC)
Received: by adalid.arch.suse.de (Postfix, from userid 16045)
        id 842755194130; Mon,  2 May 2022 23:54:20 +0200 (CEST)
From:   Hannes Reinecke <hare@suse.de>
To:     "Martin K. Petersen" <martin.petersen@oracle.com>
Cc:     Christoph Hellwig <hch@lst.de>,
        James Bottomley <james.bottomley@hansenpartnership.com>,
        linux-scsi@vger.kernel.org, Hannes Reinecke <hare@suse.de>,
        Hannes Reinecke <hare@suse.com>
Subject: [PATCH 05/11] pmcraid: select first available device for target reset
Date:   Mon,  2 May 2022 23:54:10 +0200
Message-Id: <20220502215416.5351-6-hare@suse.de>
X-Mailer: git-send-email 2.29.2
In-Reply-To: <20220502215416.5351-1-hare@suse.de>
References: <20220502215416.5351-1-hare@suse.de>
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
index d508e81a03db..62b9de87ff05 100644
--- a/drivers/scsi/pmcraid.c
+++ b/drivers/scsi/pmcraid.c
@@ -3064,9 +3064,21 @@ static int pmcraid_eh_bus_reset_handler(struct scsi_cmnd *scmd)
 
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

