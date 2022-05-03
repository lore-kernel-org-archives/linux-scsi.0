Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 37BBDC433EF
	for <linux-scsi@archiver.kernel.org>; Tue,  3 May 2022 20:07:45 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S242175AbiECULQ (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Tue, 3 May 2022 16:11:16 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45552 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237899AbiECUKx (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Tue, 3 May 2022 16:10:53 -0400
Received: from smtp-out1.suse.de (smtp-out1.suse.de [195.135.220.28])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4FEFA3FBE9
        for <linux-scsi@vger.kernel.org>; Tue,  3 May 2022 13:07:20 -0700 (PDT)
Received: from relay2.suse.de (relay2.suse.de [149.44.160.134])
        by smtp-out1.suse.de (Postfix) with ESMTP id 3B3D021878;
        Tue,  3 May 2022 20:07:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
        t=1651608435; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=9+DFd5tYEYUTELYptk0qKbNANlmdUVFUPdr/2BBo/uI=;
        b=SOBzM8NauxSCTBhR3INjbPVvCSAuxflsbKye2LhulPkrI74DVk0Yew7S++zH3l3JDKcdEQ
        zTLqOkOsO6J8vq/vxfkVFK+iuVmDp7iyxtiXEYGkYhFJ3O77VwnTCGONuvvp9MScdlWtiW
        ePMeoCwhAXtmz3Xc4hbel+GL/zJ+s1o=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
        s=susede2_ed25519; t=1651608435;
        h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=9+DFd5tYEYUTELYptk0qKbNANlmdUVFUPdr/2BBo/uI=;
        b=hjJV0t4SKD8YK6F0C3qVPZH2cmZfE1KuxYo2dW5ni7X5nJf49P3ULW9/JyAXCW4ZtH3nTr
        mGNuuobsSCR8KWBQ==
Received: from adalid.arch.suse.de (adalid.arch.suse.de [10.161.8.13])
        by relay2.suse.de (Postfix) with ESMTP id 21DEA2C162;
        Tue,  3 May 2022 20:07:15 +0000 (UTC)
Received: by adalid.arch.suse.de (Postfix, from userid 16045)
        id 316F351941E0; Tue,  3 May 2022 22:07:15 +0200 (CEST)
From:   Hannes Reinecke <hare@suse.de>
To:     "Martin K. Petersen" <martin.petersen@oracle.com>
Cc:     Christoph Hellwig <hch@lst.de>,
        James Bottomley <james.bottomley@hansenpartnership.com>,
        linux-scsi@vger.kernel.org, Hannes Reinecke <hare@suse.de>,
        kernel test robot <lkp@intel.com>
Subject: [PATCH 13/24] aic7xxx: make BUILD_SCSIID() a function
Date:   Tue,  3 May 2022 22:06:53 +0200
Message-Id: <20220503200704.88003-14-hare@suse.de>
X-Mailer: git-send-email 2.29.2
In-Reply-To: <20220503200704.88003-1-hare@suse.de>
References: <20220503200704.88003-1-hare@suse.de>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

Convert BUILD_SCSIID() into a function and add a scsi_device argument.

Reported-by: kernel test robot <lkp@intel.com>
Signed-off-by: Hannes Reinecke <hare@suse.de>
---
 drivers/scsi/aic7xxx/aic7xxx_osm.c | 19 +++++++++++++------
 1 file changed, 13 insertions(+), 6 deletions(-)

diff --git a/drivers/scsi/aic7xxx/aic7xxx_osm.c b/drivers/scsi/aic7xxx/aic7xxx_osm.c
index d3b1082654d5..05591650f89f 100644
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
+		scsi_id |= ahc->our_id;
+	else
+		scsi_id |= ahc->our_id_b | TWIN_CHNLB;
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

