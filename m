Return-Path: <linux-scsi-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 4AE7DE784BE
	for <linux-scsi@archiver.kernel.org>; Mon,  2 Oct 2023 15:43:54 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238197AbjJBPnz (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Mon, 2 Oct 2023 11:43:55 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41140 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238167AbjJBPnu (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Mon, 2 Oct 2023 11:43:50 -0400
Received: from smtp-out1.suse.de (smtp-out1.suse.de [195.135.220.28])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0FB19C6
        for <linux-scsi@vger.kernel.org>; Mon,  2 Oct 2023 08:43:45 -0700 (PDT)
Received: from relay2.suse.de (relay2.suse.de [149.44.160.134])
        by smtp-out1.suse.de (Postfix) with ESMTP id 929EA21869;
        Mon,  2 Oct 2023 15:43:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
        t=1696261423; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=DQYA1981XSJH0/6qlRvEFyAgukmdOpFq7h2yqk5+eIs=;
        b=cYzjif6QaGDAgFUmgkwpeuB85HcLW4LYXVNoFxCvr5iE9TU1XC2UeVBrRp5k7r3Ap8CIBn
        xSeyTQZYNAu4W15l7PSnUlr/j8S5hXnbrbDnE+4a2T9pQgg4/iDNsih9cPRIfy72g/y3Nl
        A0pU7yX6voMTyE1GaY6S2RMiCUiltMo=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
        s=susede2_ed25519; t=1696261423;
        h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=DQYA1981XSJH0/6qlRvEFyAgukmdOpFq7h2yqk5+eIs=;
        b=3P4mzYC/eJlmINuAnCtghQMwuolKAxYnsqOaBNy4xM2kzJBwNa1hNly0CAxWQuzhjUDumr
        sCxecBu++Y0xs/BQ==
Received: from adalid.arch.suse.de (adalid.arch.suse.de [10.161.8.13])
        by relay2.suse.de (Postfix) with ESMTP id 73FB52C153;
        Mon,  2 Oct 2023 15:43:43 +0000 (UTC)
Received: by adalid.arch.suse.de (Postfix, from userid 16045)
        id 8AE4B51E7549; Mon,  2 Oct 2023 17:43:43 +0200 (CEST)
From:   Hannes Reinecke <hare@suse.de>
To:     "Martin K. Petersen" <martin.petersen@oracle.com>
Cc:     James Bottomley <james.bottomley@hansenpartnership.com>,
        linux-scsi@vger.kernel.org, Christoph Hellwig <hch@lst.de>,
        Hannes Reinecke <hare@suse.de>,
        Johannes Thumshirn <johannes.thumshirn@wdc.com>
Subject: [PATCH 09/18] aic79xx: do not reference scsi command when resetting device
Date:   Mon,  2 Oct 2023 17:43:19 +0200
Message-Id: <20231002154328.43718-10-hare@suse.de>
X-Mailer: git-send-email 2.35.3
In-Reply-To: <20231002154328.43718-1-hare@suse.de>
References: <20231002154328.43718-1-hare@suse.de>
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
index 7e5253da04cd..b3075a022d99 100644
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
2.35.3

