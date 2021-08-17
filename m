Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-18.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,
	USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 1684CC43216
	for <linux-scsi@archiver.kernel.org>; Tue, 17 Aug 2021 09:17:37 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id F3E0360FA0
	for <linux-scsi@archiver.kernel.org>; Tue, 17 Aug 2021 09:17:36 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239890AbhHQJSJ (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Tue, 17 Aug 2021 05:18:09 -0400
Received: from smtp-out2.suse.de ([195.135.220.29]:47544 "EHLO
        smtp-out2.suse.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239502AbhHQJRU (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Tue, 17 Aug 2021 05:17:20 -0400
Received: from relay2.suse.de (relay2.suse.de [149.44.160.134])
        by smtp-out2.suse.de (Postfix) with ESMTP id AB5172002A;
        Tue, 17 Aug 2021 09:16:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
        t=1629191802; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=xGhqkrhOjPH1rOpPihMfpmtlLERPj1NuC8jl9xVjFCI=;
        b=FveKZBO0Pcteaq0PlZOflR72IGobvyTcwBHHZTJqgOFcCxwtf0OYOODmOe8WDzf4fmxLJq
        bzI2Uzw4Ham0zRt0JIKIvTiu7lLA64lD+if4C9zjHlzidLa3uX8aDDAJUXmI5npO9/gxBe
        FOeMQUQDBlFjv+ZfQUFtdB+RpsraXQw=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
        s=susede2_ed25519; t=1629191802;
        h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=xGhqkrhOjPH1rOpPihMfpmtlLERPj1NuC8jl9xVjFCI=;
        b=FAOWaICmm0bfn/lVymhkhIIgEeKQFqeOfV1gx9QT4zsmne1vZgIJlaDufqlnOV8zDxC5OZ
        hXs8dNJWrcvz8ECg==
Received: from adalid.arch.suse.de (adalid.arch.suse.de [10.161.8.13])
        by relay2.suse.de (Postfix) with ESMTP id A56DBA3BB8;
        Tue, 17 Aug 2021 09:16:42 +0000 (UTC)
Received: by adalid.arch.suse.de (Postfix, from userid 16045)
        id A2B05518CEB1; Tue, 17 Aug 2021 11:16:42 +0200 (CEST)
From:   Hannes Reinecke <hare@suse.de>
To:     "Martin K. Petersen" <martin.petersen@oracle.com>
Cc:     Christoph Hellwig <hch@lst.de>,
        James Bottomley <james.bottomley@hansenpartnership.com>,
        linux-scsi@vger.kernel.org, Hannes Reinecke <hare@suse.de>,
        Hannes Reinecke <hare@suse.com>
Subject: [PATCH 41/51] aic79xx: use scsi device as argument for BUILD_SCSIID()
Date:   Tue, 17 Aug 2021 11:14:46 +0200
Message-Id: <20210817091456.73342-42-hare@suse.de>
X-Mailer: git-send-email 2.29.2
In-Reply-To: <20210817091456.73342-1-hare@suse.de>
References: <20210817091456.73342-1-hare@suse.de>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

Signed-off-by: Hannes Reinecke <hare@suse.com>
---
 drivers/scsi/aic7xxx/aic79xx_osm.c | 8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

diff --git a/drivers/scsi/aic7xxx/aic79xx_osm.c b/drivers/scsi/aic7xxx/aic79xx_osm.c
index 9b2e15c4fe07..ab40f89febea 100644
--- a/drivers/scsi/aic7xxx/aic79xx_osm.c
+++ b/drivers/scsi/aic7xxx/aic79xx_osm.c
@@ -541,8 +541,8 @@ ahd_linux_unmap_scb(struct ahd_softc *ahd, struct scb *scb)
 }
 
 /******************************** Macros **************************************/
-#define BUILD_SCSIID(ahd, cmd)						\
-	(((scmd_id(cmd) << TID_SHIFT) & TID) | (ahd)->our_id)
+#define BUILD_SCSIID(ahd, sdev)					\
+	(((sdev_id(sdev) << TID_SHIFT) & TID) | (ahd)->our_id)
 
 /*
  * Return a string describing the driver.
@@ -824,7 +824,7 @@ ahd_linux_dev_reset(struct scsi_cmnd *cmd)
 	ahd_set_sense_residual(reset_scb, 0);
 	reset_scb->platform_data->xfer_len = 0;
 	reset_scb->hscb->control = 0;
-	reset_scb->hscb->scsiid = BUILD_SCSIID(ahd,cmd);
+	reset_scb->hscb->scsiid = BUILD_SCSIID(ahd, cmd->device);
 	reset_scb->hscb->lun = cmd->device->lun;
 	reset_scb->hscb->cdb_len = 0;
 	reset_scb->hscb->task_management = SIU_TASKMGMT_LUN_RESET;
@@ -1583,7 +1583,7 @@ ahd_linux_run_command(struct ahd_softc *ahd, struct ahd_linux_device *dev,
 	 * Fill out basics of the HSCB.
 	 */
 	hscb->control = 0;
-	hscb->scsiid = BUILD_SCSIID(ahd, cmd);
+	hscb->scsiid = BUILD_SCSIID(ahd, cmd->device);
 	hscb->lun = cmd->device->lun;
 	scb->hscb->task_management = 0;
 	mask = SCB_GET_TARGET_MASK(ahd, scb);
-- 
2.29.2

