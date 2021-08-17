Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-18.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,
	USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 7D311C43214
	for <linux-scsi@archiver.kernel.org>; Tue, 17 Aug 2021 09:16:59 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 66EA360FA0
	for <linux-scsi@archiver.kernel.org>; Tue, 17 Aug 2021 09:16:59 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239573AbhHQJRb (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Tue, 17 Aug 2021 05:17:31 -0400
Received: from smtp-out2.suse.de ([195.135.220.29]:47558 "EHLO
        smtp-out2.suse.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234347AbhHQJRQ (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Tue, 17 Aug 2021 05:17:16 -0400
Received: from relay2.suse.de (relay2.suse.de [149.44.160.134])
        by smtp-out2.suse.de (Postfix) with ESMTP id 01C9E2001A;
        Tue, 17 Aug 2021 09:16:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
        t=1629191802; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=2AbeA5ShB3lXtR9kF5FC6uyxPwkXQ0MdHy4poxrqhk0=;
        b=ccx9zG8nS1oK2H96MUksKbv6GUzL6e+eQdSE3A88uo/M6/yiUBF7vVsJbFRvTeFCMt736y
        wQ3PHt69qaDBjqTtqGgnG9YC4OFzJGJKZSzEVaVUSDVn9fofbArVVOJ2edeRp+bDPnqYO7
        HsvTmt7ziRnxhkiXSarJAsDSVLpanM0=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
        s=susede2_ed25519; t=1629191802;
        h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=2AbeA5ShB3lXtR9kF5FC6uyxPwkXQ0MdHy4poxrqhk0=;
        b=KbUK1V0105gEad1UlvP2M8aKyUKySrx87eMAOdm5RaonriJjsdoauDhXde4bCrFpiY8zpT
        7YcbUeo2K9BkkoAw==
Received: from adalid.arch.suse.de (adalid.arch.suse.de [10.161.8.13])
        by relay2.suse.de (Postfix) with ESMTP id EE814A3BA0;
        Tue, 17 Aug 2021 09:16:41 +0000 (UTC)
Received: by adalid.arch.suse.de (Postfix, from userid 16045)
        id EB7C7518CE7B; Tue, 17 Aug 2021 11:16:41 +0200 (CEST)
From:   Hannes Reinecke <hare@suse.de>
To:     "Martin K. Petersen" <martin.petersen@oracle.com>
Cc:     Christoph Hellwig <hch@lst.de>,
        James Bottomley <james.bottomley@hansenpartnership.com>,
        linux-scsi@vger.kernel.org, Hannes Reinecke <hare@suse.de>,
        Hannes Reinecke <hare@suse.com>
Subject: [PATCH 14/51] pmcraid: Select device in pmcraid_eh_bus_reset_handler()
Date:   Tue, 17 Aug 2021 11:14:19 +0200
Message-Id: <20210817091456.73342-15-hare@suse.de>
X-Mailer: git-send-email 2.29.2
In-Reply-To: <20210817091456.73342-1-hare@suse.de>
References: <20210817091456.73342-1-hare@suse.de>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

The reset code requires a device to be selected, but we shouldn't
rely on the command to provide a device for us. So select the first
device on the bus when sending down a bus reset.

Signed-off-by: Hannes Reinecke <hare@suse.com>
---
 drivers/scsi/pmcraid.c | 46 ++++++++++++++++++++++++++++++++++--------
 1 file changed, 38 insertions(+), 8 deletions(-)

diff --git a/drivers/scsi/pmcraid.c b/drivers/scsi/pmcraid.c
index f9cd69889fe7..f29107536887 100644
--- a/drivers/scsi/pmcraid.c
+++ b/drivers/scsi/pmcraid.c
@@ -2691,7 +2691,7 @@ static int pmcraid_error_handler(struct pmcraid_cmd *cmd)
  *	SUCCESS / FAILED
  */
 static int pmcraid_reset_device(
-	struct scsi_cmnd *scsi_cmd,
+	struct scsi_device *scsi_dev,
 	unsigned long timeout,
 	u8 modifier)
 {
@@ -2703,11 +2703,11 @@ static int pmcraid_reset_device(
 	u32 ioasc;
 
 	pinstance =
-		(struct pmcraid_instance *)scsi_cmd->device->host->hostdata;
-	res = scsi_cmd->device->hostdata;
+		(struct pmcraid_instance *)scsi_dev->host->hostdata;
+	res = scsi_dev->hostdata;
 
 	if (!res) {
-		sdev_printk(KERN_ERR, scsi_cmd->device,
+		sdev_printk(KERN_ERR, scsi_dev,
 			    "reset_device: NULL resource pointer\n");
 		return FAILED;
 	}
@@ -3018,16 +3018,46 @@ static int pmcraid_eh_device_reset_handler(struct scsi_cmnd *scmd)
 {
 	scmd_printk(KERN_INFO, scmd,
 		    "resetting device due to an I/O command timeout.\n");
-	return pmcraid_reset_device(scmd,
+	return pmcraid_reset_device(scmd->device,
 				    PMCRAID_INTERNAL_TIMEOUT,
 				    RESET_DEVICE_LUN);
 }
 
 static int pmcraid_eh_bus_reset_handler(struct scsi_cmnd *scmd)
 {
-	scmd_printk(KERN_INFO, scmd,
+	struct Scsi_Host *host = scmd->device->host;
+	struct pmcraid_instance *pinstance =
+		(struct pmcraid_instance *)host->hostdata;
+	struct pmcraid_resource_entry *res = NULL;
+	struct pmcraid_resource_entry *temp;
+	struct scsi_device *sdev = NULL;
+	unsigned long lock_flags;
+
+	/*
+	 * The reset device code insists on us passing down
+	 * a device, so grab the first device on the bus.
+	 */
+	spin_lock_irqsave(&pinstance->resource_lock, lock_flags);
+	list_for_each_entry(temp, &pinstance->used_res_q, queue) {
+		if (scmd->device->channel == PMCRAID_VSET_BUS_ID &&
+		    RES_IS_VSET(temp->cfg_entry)) {
+			res = temp;
+			break;
+		} else if (scmd->device->channel == PMCRAID_PHYS_BUS_ID &&
+			   RES_IS_GSCSI(temp->cfg_entry)) {
+			res = temp;
+			break;
+		}
+	}
+	if (res)
+		sdev = res->scsi_dev;
+	spin_unlock_irqrestore(&pinstance->resource_lock, lock_flags);
+	if (!sdev)
+		return FAILED;
+
+	sdev_printk(KERN_INFO, sdev,
 		    "Doing bus reset due to an I/O command timeout.\n");
-	return pmcraid_reset_device(scmd,
+	return pmcraid_reset_device(sdev,
 				    PMCRAID_RESET_BUS_TIMEOUT,
 				    RESET_DEVICE_BUS);
 }
@@ -3036,7 +3066,7 @@ static int pmcraid_eh_target_reset_handler(struct scsi_cmnd *scmd)
 {
 	scmd_printk(KERN_INFO, scmd,
 		    "Doing target reset due to an I/O command timeout.\n");
-	return pmcraid_reset_device(scmd,
+	return pmcraid_reset_device(scmd->device,
 				    PMCRAID_INTERNAL_TIMEOUT,
 				    RESET_DEVICE_TARGET);
 }
-- 
2.29.2

