Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 3AE7CC433EF
	for <linux-scsi@archiver.kernel.org>; Tue, 24 May 2022 06:16:43 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234833AbiEXGQl (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Tue, 24 May 2022 02:16:41 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51674 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234784AbiEXGQS (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Tue, 24 May 2022 02:16:18 -0400
Received: from smtp-out1.suse.de (smtp-out1.suse.de [195.135.220.28])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9124210FD3
        for <linux-scsi@vger.kernel.org>; Mon, 23 May 2022 23:16:16 -0700 (PDT)
Received: from relay2.suse.de (relay2.suse.de [149.44.160.134])
        by smtp-out1.suse.de (Postfix) with ESMTP id 1652721A5B;
        Tue, 24 May 2022 06:16:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
        t=1653372971; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=9MsSiAAjIWqF4kGXJGghIS0dqc7hWAwta8u5JaVpNeM=;
        b=Xfb+1oVJTu6Yu4Cgv1efzmObpveuT7QRSJqPOl/blkimvE5FGove1zF8IOBcv5g5FXhCMi
        +EgzGlUmSmyljzxSKCAPqNTQLIVWm/CU2YaV/7zT8VsuE5uspfkIRmtSF+RBi34r90nu/x
        wfDKHrG20pAefgNjI/Ha68bxxTUJFg8=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
        s=susede2_ed25519; t=1653372971;
        h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=9MsSiAAjIWqF4kGXJGghIS0dqc7hWAwta8u5JaVpNeM=;
        b=Hs/lMBfHblxuCB2VqvPEAJG6EFclUn4mgKb/4pFfVZsZq9JM2wVTHcR5f7sALizDqFL+c0
        16XsKdR3JJhO7yDw==
Received: from adalid.arch.suse.de (adalid.arch.suse.de [10.161.8.13])
        by relay2.suse.de (Postfix) with ESMTP id CC0E12C153;
        Tue, 24 May 2022 06:16:10 +0000 (UTC)
Received: by adalid.arch.suse.de (Postfix, from userid 16045)
        id BBD66519464E; Tue, 24 May 2022 08:16:10 +0200 (CEST)
From:   Hannes Reinecke <hare@suse.de>
To:     "Martin K. Petersen" <martin.petersen@oracle.com>
Cc:     Christoph Hellwig <hch@lst.de>,
        James Bottomley <james.bottomley@hansenpartnership.com>,
        linux-scsi@vger.kernel.org, Hannes Reinecke <hare@suse.de>,
        kernel test robot <lkp@intel.com>,
        Johannes Thumshirn <johannes.thumshirn@wdc.com>
Subject: [PATCH 11/16] aic7xxx: make BUILD_SCSIID() a function
Date:   Tue, 24 May 2022 08:15:57 +0200
Message-Id: <20220524061602.86760-12-hare@suse.de>
X-Mailer: git-send-email 2.29.2
In-Reply-To: <20220524061602.86760-1-hare@suse.de>
References: <20220524061602.86760-1-hare@suse.de>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

Convert BUILD_SCSIID() into a function and add a scsi_device argument.

Reported-by: kernel test robot <lkp@intel.com>
Signed-off-by: Hannes Reinecke <hare@suse.de>
Reviewed-by: Johannes Thumshirn <johannes.thumshirn@wdc.com>
Reviewed-by: Christoph Hellwig <hch@lst.de>
---
 drivers/scsi/aic7xxx/aic7xxx_osm.c | 19 +++++++++++++------
 1 file changed, 13 insertions(+), 6 deletions(-)

diff --git a/drivers/scsi/aic7xxx/aic7xxx_osm.c b/drivers/scsi/aic7xxx/aic7xxx_osm.c
index d3b1082654d5..15e53b33b955 100644
--- a/drivers/scsi/aic7xxx/aic7xxx_osm.c
+++ b/drivers/scsi/aic7xxx/aic7xxx_osm.c
@@ -798,11 +798,18 @@ struct scsi_host_template aic7xxx_driver_template = {
 
 /**************************** Tasklet Handler *********************************/
 
-/******************************** Macros **************************************/
-#define BUILD_SCSIID(ahc, cmd)						    \
-	((((cmd)->device->id << TID_SHIFT) & TID)			    \
-	| (((cmd)->device->channel == 0) ? (ahc)->our_id : (ahc)->our_id_b) \
-	| (((cmd)->device->channel == 0) ? 0 : TWIN_CHNLB))
+
+static inline unsigned int ahc_build_scsiid(struct ahc_softc *ahc,
+					    struct scsi_device *sdev)
+{
+	unsigned int scsiid = (sdev->id << TID_SHIFT) & TID;
+
+	if (sdev->channel == 0)
+		scsiid |= ahc->our_id;
+	else
+		scsiid |= ahc->our_id_b | TWIN_CHNLB;
+	return scsiid;
+}
 
 /******************************** Bus DMA *************************************/
 int
@@ -1457,7 +1464,7 @@ ahc_linux_run_command(struct ahc_softc *ahc, struct ahc_linux_device *dev,
 	 * Fill out basics of the HSCB.
 	 */
 	hscb->control = 0;
-	hscb->scsiid = BUILD_SCSIID(ahc, cmd);
+	hscb->scsiid = ahc_build_scsiid(ahc, cmd->device);
 	hscb->lun = cmd->device->lun;
 	mask = SCB_GET_TARGET_MASK(ahc, scb);
 	tinfo = ahc_fetch_transinfo(ahc, SCB_GET_CHANNEL(ahc, scb),
-- 
2.29.2

