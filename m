Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 4CE45C433EF
	for <linux-scsi@archiver.kernel.org>; Tue,  1 Mar 2022 14:40:15 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234244AbiCAOkx (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Tue, 1 Mar 2022 09:40:53 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43504 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234046AbiCAOkp (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Tue, 1 Mar 2022 09:40:45 -0500
Received: from smtp-out1.suse.de (smtp-out1.suse.de [195.135.220.28])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3333F558A
        for <linux-scsi@vger.kernel.org>; Tue,  1 Mar 2022 06:40:04 -0800 (PST)
Received: from relay2.suse.de (relay2.suse.de [149.44.160.134])
        by smtp-out1.suse.de (Postfix) with ESMTP id E6DA6212C9;
        Tue,  1 Mar 2022 14:40:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
        t=1646145602; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=o6rqziKHEPrA1x4Or+kKZTwVj13Dibc/2H48iGNyz/w=;
        b=u8aPt+Eqwez19nlNNLeHiJtfqS1fVZGSJHf3q651+hbT0OsoVYLqb0wVeUCC6gHrJ2Df3T
        CpQORIh4cWBZ8CZP7uRhS0zsFFJaRoJha5GlZ2X11ABTNFg4XE8zOAR7V/ZdM2CT3YRcrb
        hNOgnQX6rC7BGtnEoonEnx9To6a7PWM=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
        s=susede2_ed25519; t=1646145602;
        h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=o6rqziKHEPrA1x4Or+kKZTwVj13Dibc/2H48iGNyz/w=;
        b=yQKl5tY3Z1X1zJAVp9nfVJMb1w8ouzxmvX9+W+DD5g7ID9qLNlMfbzRytKJXHq7DUec3N/
        HPu4yYWYHScA8CAQ==
Received: from adalid.arch.suse.de (adalid.arch.suse.de [10.161.8.13])
        by relay2.suse.de (Postfix) with ESMTP id DEC67A3B8B;
        Tue,  1 Mar 2022 14:40:02 +0000 (UTC)
Received: by adalid.arch.suse.de (Postfix, from userid 16045)
        id CCC4C51933D4; Tue,  1 Mar 2022 15:40:02 +0100 (CET)
From:   Hannes Reinecke <hare@suse.de>
To:     "Martin K. Petersen" <martin.petersen@oracle.com>
Cc:     Christoph Hellwig <hch@lst.de>,
        James Bottomley <james.bottomley@hansenpartnership.com>,
        linux-scsi@vger.kernel.org, Hannes Reinecke <hare@suse.de>,
        Hannes Reinecke <hare@suse.com>
Subject: [PATCH 1/4] aic7xxx: use scsi device as argument for BUILD_SCSIID()
Date:   Tue,  1 Mar 2022 15:39:54 +0100
Message-Id: <20220301143957.40998-2-hare@suse.de>
X-Mailer: git-send-email 2.29.2
In-Reply-To: <20220301143957.40998-1-hare@suse.de>
References: <20220301143957.40998-1-hare@suse.de>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

Signed-off-by: Hannes Reinecke <hare@suse.com>
---
 drivers/scsi/aic7xxx/aic7xxx_osm.c | 10 +++++-----
 1 file changed, 5 insertions(+), 5 deletions(-)

diff --git a/drivers/scsi/aic7xxx/aic7xxx_osm.c b/drivers/scsi/aic7xxx/aic7xxx_osm.c
index d3b1082654d5..16d7a7310e90 100644
--- a/drivers/scsi/aic7xxx/aic7xxx_osm.c
+++ b/drivers/scsi/aic7xxx/aic7xxx_osm.c
@@ -799,10 +799,10 @@ struct scsi_host_template aic7xxx_driver_template = {
 /**************************** Tasklet Handler *********************************/
 
 /******************************** Macros **************************************/
-#define BUILD_SCSIID(ahc, cmd)						    \
-	((((cmd)->device->id << TID_SHIFT) & TID)			    \
-	| (((cmd)->device->channel == 0) ? (ahc)->our_id : (ahc)->our_id_b) \
-	| (((cmd)->device->channel == 0) ? 0 : TWIN_CHNLB))
+#define BUILD_SCSIID(ahc, sdev)						    \
+	((((sdev)->id << TID_SHIFT) & TID)			    \
+	| (((sdev)->channel == 0) ? (ahc)->our_id : (ahc)->our_id_b) \
+	| (((sdev)->channel == 0) ? 0 : TWIN_CHNLB))
 
 /******************************** Bus DMA *************************************/
 int
@@ -1457,7 +1457,7 @@ ahc_linux_run_command(struct ahc_softc *ahc, struct ahc_linux_device *dev,
 	 * Fill out basics of the HSCB.
 	 */
 	hscb->control = 0;
-	hscb->scsiid = BUILD_SCSIID(ahc, cmd);
+	hscb->scsiid = BUILD_SCSIID(ahc, cmd->device);
 	hscb->lun = cmd->device->lun;
 	mask = SCB_GET_TARGET_MASK(ahc, scb);
 	tinfo = ahc_fetch_transinfo(ahc, SCB_GET_CHANNEL(ahc, scb),
-- 
2.29.2

