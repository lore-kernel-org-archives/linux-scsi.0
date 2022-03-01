Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 48EF4C433FE
	for <linux-scsi@archiver.kernel.org>; Tue,  1 Mar 2022 14:40:11 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231557AbiCAOkt (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Tue, 1 Mar 2022 09:40:49 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43656 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231256AbiCAOkr (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Tue, 1 Mar 2022 09:40:47 -0500
Received: from smtp-out2.suse.de (smtp-out2.suse.de [195.135.220.29])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 51510630B
        for <linux-scsi@vger.kernel.org>; Tue,  1 Mar 2022 06:40:04 -0800 (PST)
Received: from relay2.suse.de (relay2.suse.de [149.44.160.134])
        by smtp-out2.suse.de (Postfix) with ESMTP id F2E0F1F8A6;
        Tue,  1 Mar 2022 14:40:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
        t=1646145602; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=jU5dO8yW/zX264uLAxDn+GCDGtKpgTwgXLS6EYa1LFs=;
        b=CxhigvOIDxyI1zNdYw7gc+gZid2aWbzHJ3W9PKPGF3l0iLGHaQnHNI8LAglbP9ytg7HGKB
        aC/q6Z8GZipcBJO0BtugHVcNLVgk9ro5kZpwTXqvt8lYGpaINdpNUTlFZ3DpcxIb6E1cZY
        wSTFezMqi+TNimvZo1anCWdN+1G7HfE=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
        s=susede2_ed25519; t=1646145602;
        h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=jU5dO8yW/zX264uLAxDn+GCDGtKpgTwgXLS6EYa1LFs=;
        b=YH0mk6X/1jI5Qjt3vfOdZCiN8neD39TgCpC7/ZUJjgQVq6iabdwbosLzjzjTntk7FaRvXq
        E1CVhmhX90sGgDDQ==
Received: from adalid.arch.suse.de (adalid.arch.suse.de [10.161.8.13])
        by relay2.suse.de (Postfix) with ESMTP id EA616A3B8D;
        Tue,  1 Mar 2022 14:40:02 +0000 (UTC)
Received: by adalid.arch.suse.de (Postfix, from userid 16045)
        id DBB3351933DA; Tue,  1 Mar 2022 15:40:02 +0100 (CET)
From:   Hannes Reinecke <hare@suse.de>
To:     "Martin K. Petersen" <martin.petersen@oracle.com>
Cc:     Christoph Hellwig <hch@lst.de>,
        James Bottomley <james.bottomley@hansenpartnership.com>,
        linux-scsi@vger.kernel.org, Hannes Reinecke <hare@suse.de>,
        Hannes Reinecke <hare@suse.com>
Subject: [PATCH 4/4] aic79xx: do not reference scsi command when resetting device
Date:   Tue,  1 Mar 2022 15:39:57 +0100
Message-Id: <20220301143957.40998-5-hare@suse.de>
X-Mailer: git-send-email 2.29.2
In-Reply-To: <20220301143957.40998-1-hare@suse.de>
References: <20220301143957.40998-1-hare@suse.de>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

When sending a device reset we should not take a reference to the
scsi command.

Signed-off-by: Hannes Reinecke <hare@suse.com>
---
 drivers/scsi/aic7xxx/aic79xx_osm.c | 21 +++++++++++++++------
 1 file changed, 15 insertions(+), 6 deletions(-)

diff --git a/drivers/scsi/aic7xxx/aic79xx_osm.c b/drivers/scsi/aic7xxx/aic79xx_osm.c
index f900ed05f36a..b7b19fd8a2e3 100644
--- a/drivers/scsi/aic7xxx/aic79xx_osm.c
+++ b/drivers/scsi/aic7xxx/aic79xx_osm.c
@@ -536,8 +536,10 @@ ahd_linux_unmap_scb(struct ahd_softc *ahd, struct scb *scb)
 	struct scsi_cmnd *cmd;
 
 	cmd = scb->io_ctx;
-	ahd_sync_sglist(ahd, scb, BUS_DMASYNC_POSTWRITE);
-	scsi_dma_unmap(cmd);
+	if (cmd) {
+		ahd_sync_sglist(ahd, scb, BUS_DMASYNC_POSTWRITE);
+		scsi_dma_unmap(cmd);
+	}
 }
 
 /******************************** Macros **************************************/
@@ -811,7 +813,7 @@ ahd_linux_dev_reset(struct scsi_cmnd *cmd)
 
 	tinfo = ahd_fetch_transinfo(ahd, 'A', ahd->our_id,
 				    cmd->device->id, &tstate);
-	reset_scb->io_ctx = cmd;
+	reset_scb->io_ctx = NULL;
 	reset_scb->platform_data->dev = dev;
 	reset_scb->sg_count = 0;
 	ahd_set_residual(reset_scb, 0);
@@ -1766,9 +1768,16 @@ ahd_done(struct ahd_softc *ahd, struct scb *scb)
 	dev = scb->platform_data->dev;
 	dev->active--;
 	dev->openings++;
-	if ((cmd->result & (CAM_DEV_QFRZN << 16)) != 0) {
-		cmd->result &= ~(CAM_DEV_QFRZN << 16);
-		dev->qfrozen--;
+	if (cmd) {
+		if ((cmd->result & (CAM_DEV_QFRZN << 16)) != 0) {
+			cmd->result &= ~(CAM_DEV_QFRZN << 16);
+			dev->qfrozen--;
+		}
+	} else if (scb->flags & SCB_DEVICE_RESET) {
+		if (ahd->platform_data->eh_done)
+			complete(ahd->platform_data->eh_done);
+		ahd_free_scb(ahd, scb);
+		return;
 	}
 	ahd_linux_unmap_scb(ahd, scb);
 
-- 
2.29.2

