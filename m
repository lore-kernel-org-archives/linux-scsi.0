Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 40164C433EF
	for <linux-scsi@archiver.kernel.org>; Tue, 24 May 2022 06:16:36 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234822AbiEXGQd (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Tue, 24 May 2022 02:16:33 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51534 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232557AbiEXGQQ (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Tue, 24 May 2022 02:16:16 -0400
Received: from smtp-out1.suse.de (smtp-out1.suse.de [195.135.220.28])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D26D9DFA6
        for <linux-scsi@vger.kernel.org>; Mon, 23 May 2022 23:16:14 -0700 (PDT)
Received: from relay2.suse.de (relay2.suse.de [149.44.160.134])
        by smtp-out1.suse.de (Postfix) with ESMTP id F028321A59;
        Tue, 24 May 2022 06:16:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
        t=1653372970; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=PYapeo9LLsL7NQobmzSI065crYTSLSNoL+Y2r909dNM=;
        b=IBMEXOFYhWpv0nDTxYxF2Lt55xB67DAUrkVg7GpcR0+IeBf2T37DVEgxJa1lGJ4ZGXSRis
        ZIdP6CG0l0Nv/VkAuypin0znTvq5LMLZau97V/wL5C+T2Q5P/pVvHa47chxPEuX83rkxMC
        1NybqUlDAorSZGJa1uvd8aDosYCFDO8=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
        s=susede2_ed25519; t=1653372970;
        h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=PYapeo9LLsL7NQobmzSI065crYTSLSNoL+Y2r909dNM=;
        b=G6x7buh7FRu9IPa75XW3//taIXuN//QiQRZiHqxhi1CKq9jP7FvEomgih49ieKAfOqjlUP
        AM1ttrHl2AoAwFDA==
Received: from adalid.arch.suse.de (adalid.arch.suse.de [10.161.8.13])
        by relay2.suse.de (Postfix) with ESMTP id CF86C2C15F;
        Tue, 24 May 2022 06:16:10 +0000 (UTC)
Received: by adalid.arch.suse.de (Postfix, from userid 16045)
        id CD6F05194654; Tue, 24 May 2022 08:16:10 +0200 (CEST)
From:   Hannes Reinecke <hare@suse.de>
To:     "Martin K. Petersen" <martin.petersen@oracle.com>
Cc:     Christoph Hellwig <hch@lst.de>,
        James Bottomley <james.bottomley@hansenpartnership.com>,
        linux-scsi@vger.kernel.org, Hannes Reinecke <hare@suse.de>,
        Johannes Thumshirn <johannes.thumshirn@wdc.com>
Subject: [PATCH 14/16] aic79xx: do not reference scsi command when resetting device
Date:   Tue, 24 May 2022 08:16:00 +0200
Message-Id: <20220524061602.86760-15-hare@suse.de>
X-Mailer: git-send-email 2.29.2
In-Reply-To: <20220524061602.86760-1-hare@suse.de>
References: <20220524061602.86760-1-hare@suse.de>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

When sending a device reset we should not take a reference to the
scsi command.

Signed-off-by: Hannes Reinecke <hare@suse.de>
Reviewed-by: Christoph Hellwig <hch@lst.de>
Reviewed-by: Johannes Thumshirn <johannes.thumshirn@wdc.com>
---
 drivers/scsi/aic7xxx/aic79xx_osm.c | 21 +++++++++++++++------
 1 file changed, 15 insertions(+), 6 deletions(-)

diff --git a/drivers/scsi/aic7xxx/aic79xx_osm.c b/drivers/scsi/aic7xxx/aic79xx_osm.c
index 8172ec43736c..109a61162fcc 100644
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
@@ -814,7 +816,7 @@ ahd_linux_dev_reset(struct scsi_cmnd *cmd)
 
 	tinfo = ahd_fetch_transinfo(ahd, 'A', ahd->our_id,
 				    cmd->device->id, &tstate);
-	reset_scb->io_ctx = cmd;
+	reset_scb->io_ctx = NULL;
 	reset_scb->platform_data->dev = dev;
 	reset_scb->sg_count = 0;
 	ahd_set_residual(reset_scb, 0);
@@ -1769,9 +1771,16 @@ ahd_done(struct ahd_softc *ahd, struct scb *scb)
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

