Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 99F0AC433F5
	for <linux-scsi@archiver.kernel.org>; Mon,  2 May 2022 21:39:17 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1384965AbiEBVmn (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Mon, 2 May 2022 17:42:43 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37750 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1387731AbiEBVmH (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Mon, 2 May 2022 17:42:07 -0400
Received: from smtp-out2.suse.de (smtp-out2.suse.de [195.135.220.29])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E1FCEE0E3
        for <linux-scsi@vger.kernel.org>; Mon,  2 May 2022 14:38:37 -0700 (PDT)
Received: from relay2.suse.de (relay2.suse.de [149.44.160.134])
        by smtp-out2.suse.de (Postfix) with ESMTP id 0BD501F8A3;
        Mon,  2 May 2022 21:38:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
        t=1651527513; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=ohUvPGWSnDaTAJMOL5mEM3iqU+8gUGfdhY+2qP6gaO0=;
        b=mBtQp5NYmYNUqbwEaq8F47YEMof+H8+7tvZt0YUi4IgI4RdqLzBv6N1pn1L2uRP0ITxj3+
        eRJjycCwpo+lDjk3hZsAL0i9D3mm53d3NP0FM1M29cuAo04VresQXqg5Ge5Y/V/rcPeEZf
        /VETY2OZNwxdPWgQeo7JRWcf2JX52aQ=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
        s=susede2_ed25519; t=1651527513;
        h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=ohUvPGWSnDaTAJMOL5mEM3iqU+8gUGfdhY+2qP6gaO0=;
        b=zlI1ciEcRuoG2QcugXtVJxujIfInh9CX9RhDXbIYrVUsmupLJ0kyAhVtHlYrvmcefMfmgN
        NRedsMrAiMxoFJAw==
Received: from adalid.arch.suse.de (adalid.arch.suse.de [10.161.8.13])
        by relay2.suse.de (Postfix) with ESMTP id 079322C15B;
        Mon,  2 May 2022 21:38:33 +0000 (UTC)
Received: by adalid.arch.suse.de (Postfix, from userid 16045)
        id 049B55194110; Mon,  2 May 2022 23:38:33 +0200 (CEST)
From:   Hannes Reinecke <hare@suse.de>
To:     "Martin K. Petersen" <martin.petersen@oracle.com>
Cc:     Christoph Hellwig <hch@lst.de>,
        James Bottomley <james.bottomley@hansenpartnership.com>,
        linux-scsi@vger.kernel.org, Hannes Reinecke <hare@suse.de>,
        Hannes Reinecke <hare@suse.com>
Subject: [PATCH 14/24] aic79xx: make BUILD_SCSIID() a function
Date:   Mon,  2 May 2022 23:38:10 +0200
Message-Id: <20220502213820.3187-15-hare@suse.de>
X-Mailer: git-send-email 2.29.2
In-Reply-To: <20220502213820.3187-1-hare@suse.de>
References: <20220502213820.3187-1-hare@suse.de>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

Convert BUILD_SCSIID() into a function and add a scsi_device argument.

Signed-off-by: Hannes Reinecke <hare@suse.com>
---
 drivers/scsi/aic7xxx/aic79xx_osm.c | 14 ++++++++++----
 1 file changed, 10 insertions(+), 4 deletions(-)

diff --git a/drivers/scsi/aic7xxx/aic79xx_osm.c b/drivers/scsi/aic7xxx/aic79xx_osm.c
index 928099163f0f..b9b214ef5a2a 100644
--- a/drivers/scsi/aic7xxx/aic79xx_osm.c
+++ b/drivers/scsi/aic7xxx/aic79xx_osm.c
@@ -541,8 +541,14 @@ ahd_linux_unmap_scb(struct ahd_softc *ahd, struct scb *scb)
 }
 
 /******************************** Macros **************************************/
-#define BUILD_SCSIID(ahd, cmd)						\
-	(((scmd_id(cmd) << TID_SHIFT) & TID) | (ahd)->our_id)
+static inline unsigned int ahd_build_scsiid(struct ahd_softc *ahd,
+					    struct scsi_device *sdev)
+{
+	unsigned int scsiid =
+		((sdev_id(sdev) << TID_SHIFT) & TID) | (ahd)->our_id;
+
+	return scsiid;
+}
 
 /*
  * Return a string describing the driver.
@@ -818,7 +824,7 @@ ahd_linux_dev_reset(struct scsi_cmnd *cmd)
 	ahd_set_sense_residual(reset_scb, 0);
 	reset_scb->platform_data->xfer_len = 0;
 	reset_scb->hscb->control = 0;
-	reset_scb->hscb->scsiid = BUILD_SCSIID(ahd,cmd);
+	reset_scb->hscb->scsiid = ahd_build_scsiid(ahd, cmd->device);
 	reset_scb->hscb->lun = cmd->device->lun;
 	reset_scb->hscb->cdb_len = 0;
 	reset_scb->hscb->task_management = SIU_TASKMGMT_LUN_RESET;
@@ -1577,7 +1583,7 @@ ahd_linux_run_command(struct ahd_softc *ahd, struct ahd_linux_device *dev,
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

