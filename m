Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 5A890C433F5
	for <linux-scsi@archiver.kernel.org>; Mon,  2 May 2022 22:01:09 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1387803AbiEBWD4 (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Mon, 2 May 2022 18:03:56 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47662 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1387777AbiEBWDc (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Mon, 2 May 2022 18:03:32 -0400
Received: from smtp-out2.suse.de (smtp-out2.suse.de [195.135.220.29])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E6FEC113C
        for <linux-scsi@vger.kernel.org>; Mon,  2 May 2022 15:00:01 -0700 (PDT)
Received: from relay2.suse.de (relay2.suse.de [149.44.160.134])
        by smtp-out2.suse.de (Postfix) with ESMTP id 93C271F747;
        Mon,  2 May 2022 22:00:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
        t=1651528800; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=grGOyvjqtNuoSpgbKAnaztGM3uA0gTsCWUxiXlhAWEc=;
        b=K9qfI732aSrfbVh3JIVGFGI01ePT7A46GS0dbx8lu0yBS7gxuEGf/uPZ6/Sysqcey0r2Sr
        FiPHOdSkmFQnP52O7U185h9zTUFQERzAB8M/F6iPzvF/87uy5LyBs1YVdp8j3N4NUhh+4X
        yZPEzQ58QVkuLh4mHCyUIBOLFyw9Pjg=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
        s=susede2_ed25519; t=1651528800;
        h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=grGOyvjqtNuoSpgbKAnaztGM3uA0gTsCWUxiXlhAWEc=;
        b=D/O9k3gocanY3EZIDBTCl0a8GcIyQoINjFDRqy3yZnvAAn0PhAy41VSTGhjXme9oGiK2zi
        q2rW06oh/P4EjJDw==
Received: from adalid.arch.suse.de (adalid.arch.suse.de [10.161.8.13])
        by relay2.suse.de (Postfix) with ESMTP id 8CC3C2C143;
        Mon,  2 May 2022 22:00:00 +0000 (UTC)
Received: by adalid.arch.suse.de (Postfix, from userid 16045)
        id 7CEDF5194140; Tue,  3 May 2022 00:00:00 +0200 (CEST)
From:   Hannes Reinecke <hare@suse.de>
To:     "Martin K. Petersen" <martin.petersen@oracle.com>
Cc:     Christoph Hellwig <hch@lst.de>,
        James Bottomley <james.bottomley@hansenpartnership.com>,
        linux-scsi@vger.kernel.org, Hannes Reinecke <hare@suse.de>,
        Hannes Reinecke <hare@suse.com>
Subject: [PATCH 01/11] pmcraid: Select device in pmcraid_eh_bus_reset_handler()
Date:   Mon,  2 May 2022 23:59:36 +0200
Message-Id: <20220502215953.5463-2-hare@suse.de>
X-Mailer: git-send-email 2.29.2
In-Reply-To: <20220502215953.5463-1-hare@suse.de>
References: <20220502215953.5463-1-hare@suse.de>
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
index 3d5cd337a2a6..d508e81a03db 100644
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

