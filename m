Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id CB63DC433F5
	for <linux-scsi@archiver.kernel.org>; Tue, 24 May 2022 06:16:41 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234425AbiEXGQi (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Tue, 24 May 2022 02:16:38 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51668 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234757AbiEXGQS (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Tue, 24 May 2022 02:16:18 -0400
Received: from smtp-out2.suse.de (smtp-out2.suse.de [195.135.220.29])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 90EDDF593
        for <linux-scsi@vger.kernel.org>; Mon, 23 May 2022 23:16:16 -0700 (PDT)
Received: from relay2.suse.de (relay2.suse.de [149.44.160.134])
        by smtp-out2.suse.de (Postfix) with ESMTP id D9DF11F927;
        Tue, 24 May 2022 06:16:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
        t=1653372970; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=JC3CsF/AkeW6SKTTT4tLUoMI9vV2+YAePmNG5j7cUZ8=;
        b=mW309uSs69/2DXySYxx7i3bgsSSf2fAOipusFWZ3fT4m3f6TcT3+n0j8KCO2IHG6APZGVV
        kZXCHmMWAI7/JTljgET4iaKQCladtCSNg7tczTaMLKuSRt7dphygvTEccb/ElnrZtz7hHO
        0Ea/N6vJtRs/hCJeag0G+qDMvwyPZvI=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
        s=susede2_ed25519; t=1653372970;
        h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=JC3CsF/AkeW6SKTTT4tLUoMI9vV2+YAePmNG5j7cUZ8=;
        b=WTnvzqQflkKAvRyy74ibN7e7mbeSYUissD4kC5njvlw3hM+ZhsXRgzLEwmTrLVzGoiCeJA
        SKbkoKfCTniVP/BQ==
Received: from adalid.arch.suse.de (adalid.arch.suse.de [10.161.8.13])
        by relay2.suse.de (Postfix) with ESMTP id CCE012C15B;
        Tue, 24 May 2022 06:16:10 +0000 (UTC)
Received: by adalid.arch.suse.de (Postfix, from userid 16045)
        id C1E6B5194650; Tue, 24 May 2022 08:16:10 +0200 (CEST)
From:   Hannes Reinecke <hare@suse.de>
To:     "Martin K. Petersen" <martin.petersen@oracle.com>
Cc:     Christoph Hellwig <hch@lst.de>,
        James Bottomley <james.bottomley@hansenpartnership.com>,
        linux-scsi@vger.kernel.org, Hannes Reinecke <hare@suse.de>,
        Johannes Thumshirn <johannes.thumshirn@wdc.com>
Subject: [PATCH 12/16] aic79xx: make BUILD_SCSIID() a function
Date:   Tue, 24 May 2022 08:15:58 +0200
Message-Id: <20220524061602.86760-13-hare@suse.de>
X-Mailer: git-send-email 2.29.2
In-Reply-To: <20220524061602.86760-1-hare@suse.de>
References: <20220524061602.86760-1-hare@suse.de>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

Convert BUILD_SCSIID() into a function and add a scsi_device argument.

Signed-off-by: Hannes Reinecke <hare@suse.de>
Reviewed-by: Johannes Thumshirn <johannes.thumshirn@wdc.com>
Reviewed-by: Christoph Hellwig <hch@lst.de>
---
 drivers/scsi/aic7xxx/aic79xx_osm.c | 11 +++++++----
 1 file changed, 7 insertions(+), 4 deletions(-)

diff --git a/drivers/scsi/aic7xxx/aic79xx_osm.c b/drivers/scsi/aic7xxx/aic79xx_osm.c
index 928099163f0f..8172ec43736c 100644
--- a/drivers/scsi/aic7xxx/aic79xx_osm.c
+++ b/drivers/scsi/aic7xxx/aic79xx_osm.c
@@ -541,8 +541,11 @@ ahd_linux_unmap_scb(struct ahd_softc *ahd, struct scb *scb)
 }
 
 /******************************** Macros **************************************/
-#define BUILD_SCSIID(ahd, cmd)						\
-	(((scmd_id(cmd) << TID_SHIFT) & TID) | (ahd)->our_id)
+static inline unsigned int ahd_build_scsiid(struct ahd_softc *ahd,
+					    struct scsi_device *sdev)
+{
+	return ((sdev_id(sdev) << TID_SHIFT) & TID) | (ahd)->our_id;
+}
 
 /*
  * Return a string describing the driver.
@@ -818,7 +821,7 @@ ahd_linux_dev_reset(struct scsi_cmnd *cmd)
 	ahd_set_sense_residual(reset_scb, 0);
 	reset_scb->platform_data->xfer_len = 0;
 	reset_scb->hscb->control = 0;
-	reset_scb->hscb->scsiid = BUILD_SCSIID(ahd,cmd);
+	reset_scb->hscb->scsiid = ahd_build_scsiid(ahd, cmd->device);
 	reset_scb->hscb->lun = cmd->device->lun;
 	reset_scb->hscb->cdb_len = 0;
 	reset_scb->hscb->task_management = SIU_TASKMGMT_LUN_RESET;
@@ -1577,7 +1580,7 @@ ahd_linux_run_command(struct ahd_softc *ahd, struct ahd_linux_device *dev,
 	 * Fill out basics of the HSCB.
 	 */
 	hscb->control = 0;
-	hscb->scsiid = BUILD_SCSIID(ahd, cmd);
+	hscb->scsiid = ahd_build_scsiid(ahd, cmd->device);
 	hscb->lun = cmd->device->lun;
 	scb->hscb->task_management = 0;
 	mask = SCB_GET_TARGET_MASK(ahd, scb);
-- 
2.29.2

