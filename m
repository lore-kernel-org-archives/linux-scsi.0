Return-Path: <linux-scsi-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E663DE784BF
	for <linux-scsi@archiver.kernel.org>; Mon,  2 Oct 2023 15:43:51 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238192AbjJBPnw (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Mon, 2 Oct 2023 11:43:52 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41118 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238164AbjJBPnu (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Mon, 2 Oct 2023 11:43:50 -0400
Received: from smtp-out1.suse.de (smtp-out1.suse.de [195.135.220.28])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E18F3BD
        for <linux-scsi@vger.kernel.org>; Mon,  2 Oct 2023 08:43:44 -0700 (PDT)
Received: from relay2.suse.de (relay2.suse.de [149.44.160.134])
        by smtp-out1.suse.de (Postfix) with ESMTP id 8E44E21866;
        Mon,  2 Oct 2023 15:43:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
        t=1696261423; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=3d2bePvtn8rp8JqzVM+GMYwJwHrHCANK3GJHCy7ehjc=;
        b=DF7IUX4SivxcPw1NX0d6qLS2QU2Lsxo5Rs6eMO068FX/oMtE2DnR6WLJYwqNOog+JRWM2E
        cGRxuWelfNUtjl2c5mHqwGGcvVHlDdCnnfOteZ++J9ONsa0aDeNI+UKl9YWI8RoimibASG
        T/dfDtn+VSxhi+GWyVC3BISwGgB5Op8=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
        s=susede2_ed25519; t=1696261423;
        h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=3d2bePvtn8rp8JqzVM+GMYwJwHrHCANK3GJHCy7ehjc=;
        b=g9cjQsrE/zZRhX75ndV/Pl0nqWe31rancmf10eiyACYopxBPc//6dzHhTOWqfEHP++eC5d
        +EV7BZ9qAbjp4TDg==
Received: from adalid.arch.suse.de (adalid.arch.suse.de [10.161.8.13])
        by relay2.suse.de (Postfix) with ESMTP id 6E7652C152;
        Mon,  2 Oct 2023 15:43:43 +0000 (UTC)
Received: by adalid.arch.suse.de (Postfix, from userid 16045)
        id 8594351E7547; Mon,  2 Oct 2023 17:43:43 +0200 (CEST)
From:   Hannes Reinecke <hare@suse.de>
To:     "Martin K. Petersen" <martin.petersen@oracle.com>
Cc:     James Bottomley <james.bottomley@hansenpartnership.com>,
        linux-scsi@vger.kernel.org, Christoph Hellwig <hch@lst.de>,
        Hannes Reinecke <hare@suse.de>,
        Johannes Thumshirn <johannes.thumshirn@wdc.com>
Subject: [PATCH 08/18] aic79xx: make BUILD_SCSIID() a function
Date:   Mon,  2 Oct 2023 17:43:18 +0200
Message-Id: <20231002154328.43718-9-hare@suse.de>
X-Mailer: git-send-email 2.35.3
In-Reply-To: <20231002154328.43718-1-hare@suse.de>
References: <20231002154328.43718-1-hare@suse.de>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

Convert BUILD_SCSIID() into a function and add a scsi_device argument.

Signed-off-by: Hannes Reinecke <hare@suse.de>
Reviewed-by: Johannes Thumshirn <johannes.thumshirn@wdc.com>
---
 drivers/scsi/aic7xxx/aic79xx_osm.c | 11 +++++++----
 1 file changed, 7 insertions(+), 4 deletions(-)

diff --git a/drivers/scsi/aic7xxx/aic79xx_osm.c b/drivers/scsi/aic7xxx/aic79xx_osm.c
index f2f3405cdec5..7e5253da04cd 100644
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
2.35.3

