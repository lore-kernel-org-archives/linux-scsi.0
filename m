Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-18.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,
	USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 4206CC4320E
	for <linux-scsi@archiver.kernel.org>; Tue, 17 Aug 2021 09:17:38 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 3081E60720
	for <linux-scsi@archiver.kernel.org>; Tue, 17 Aug 2021 09:17:38 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239895AbhHQJSK (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Tue, 17 Aug 2021 05:18:10 -0400
Received: from smtp-out2.suse.de ([195.135.220.29]:47742 "EHLO
        smtp-out2.suse.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235887AbhHQJRV (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Tue, 17 Aug 2021 05:17:21 -0400
Received: from relay2.suse.de (relay2.suse.de [149.44.160.134])
        by smtp-out2.suse.de (Postfix) with ESMTP id B6AE32002B;
        Tue, 17 Aug 2021 09:16:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
        t=1629191802; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=Cq3NbcYvVoQCzwLi2ao7Y/cjANlv7n8J6GU36jDz5N4=;
        b=0PRciFAZajhAAFiTnHbAxcmnxeeFSAVsQ4RlW/T7FuSytk+xKczYGbeRz+U1jjtkUMZFxZ
        HZ1a58GulzBjiZheBT05+yzZbK1qlrlCR4u6iRdDPXpJKHPzhrXg4GNzoF0FU4i8rX6zb+
        Q79CGEGO1wu2j52dIbsEeY1PTti2kMw=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
        s=susede2_ed25519; t=1629191802;
        h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=Cq3NbcYvVoQCzwLi2ao7Y/cjANlv7n8J6GU36jDz5N4=;
        b=bOQhedZXJXsK6YzFroJQOKjC8Kv9xPnDl4ViSINmyc7JJipA8FZc85TZ6yOL4UuMQxIvy5
        uJ6oFaxEsmKbNmCQ==
Received: from adalid.arch.suse.de (adalid.arch.suse.de [10.161.8.13])
        by relay2.suse.de (Postfix) with ESMTP id B2955A3BB9;
        Tue, 17 Aug 2021 09:16:42 +0000 (UTC)
Received: by adalid.arch.suse.de (Postfix, from userid 16045)
        id AF789518CEB5; Tue, 17 Aug 2021 11:16:42 +0200 (CEST)
From:   Hannes Reinecke <hare@suse.de>
To:     "Martin K. Petersen" <martin.petersen@oracle.com>
Cc:     Christoph Hellwig <hch@lst.de>,
        James Bottomley <james.bottomley@hansenpartnership.com>,
        linux-scsi@vger.kernel.org, Hannes Reinecke <hare@suse.de>,
        Hannes Reinecke <hare@suse.com>
Subject: [PATCH 43/51] aic79xx: do not reference scsi command when resetting device
Date:   Tue, 17 Aug 2021 11:14:48 +0200
Message-Id: <20210817091456.73342-44-hare@suse.de>
X-Mailer: git-send-email 2.29.2
In-Reply-To: <20210817091456.73342-1-hare@suse.de>
References: <20210817091456.73342-1-hare@suse.de>
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
index ab40f89febea..4ffd5c9d78e5 100644
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
@@ -817,7 +819,7 @@ ahd_linux_dev_reset(struct scsi_cmnd *cmd)
 
 	tinfo = ahd_fetch_transinfo(ahd, 'A', ahd->our_id,
 				    cmd->device->id, &tstate);
-	reset_scb->io_ctx = cmd;
+	reset_scb->io_ctx = NULL;
 	reset_scb->platform_data->dev = dev;
 	reset_scb->sg_count = 0;
 	ahd_set_residual(reset_scb, 0);
@@ -1772,9 +1774,16 @@ ahd_done(struct ahd_softc *ahd, struct scb *scb)
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

