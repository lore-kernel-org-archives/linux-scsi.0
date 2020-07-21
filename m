Return-Path: <SRS0=19hD=BA=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-13.1 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,
	USER_AGENT_GIT autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 4BAAEC433F4
	for <linux-scsi@archiver.kernel.org>; Tue, 21 Jul 2020 16:44:56 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 2AD9D20720
	for <linux-scsi@archiver.kernel.org>; Tue, 21 Jul 2020 16:44:56 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b="Bv94QDt4"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730418AbgGUQoz (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Tue, 21 Jul 2020 12:44:55 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46778 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1730267AbgGUQl4 (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Tue, 21 Jul 2020 12:41:56 -0400
Received: from mail-wr1-x444.google.com (mail-wr1-x444.google.com [IPv6:2a00:1450:4864:20::444])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4B8EDC061794
        for <linux-scsi@vger.kernel.org>; Tue, 21 Jul 2020 09:41:56 -0700 (PDT)
Received: by mail-wr1-x444.google.com with SMTP id s10so21793490wrw.12
        for <linux-scsi@vger.kernel.org>; Tue, 21 Jul 2020 09:41:56 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=MFwQcwbTCB4l24rfJy2kTJtSqlwy97lYiWoNwLDhtXE=;
        b=Bv94QDt4unIJ9g6Le3faZvrFcIGk8efu0t9DqrS9Xe08GS0yPhgYLxpm3bthoS7g55
         nQNup9hMbn2X2yPbAOWhgH8tQDdAyWHw1prXNyp7r9c8ppXY8cpTAHc7CraqSCTcZG1i
         1WBRGKsTma+ozlyHK+r7tVJXIMgXQDd5/7aT4O9iV5mpG3WG27LUu0UgQpStGfpKOMQK
         +550kpZLqGZJTiGepFqNu1W7hEw9EhUmL3gAf3/gML+wuw8aGgI6R52np4j913upCqnT
         vICorkCyskx2FcuQNX7m5S8QYF2CtPvzLGAh6f4udf8kBVn8/OQWLtFynPs5vppYtOfO
         twuA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=MFwQcwbTCB4l24rfJy2kTJtSqlwy97lYiWoNwLDhtXE=;
        b=G1MIbDfxB/mZffpavPG/GYzllO3uSfFzKUES8EMTSIzNKon5yNApRu/xykfTIsgVhN
         uRcYh8EmRL9znRThzKuVGdiMUD4FNqmaLzvkRIabQR6XGwcg8JnW6W15TAZxf0dGGShu
         JfeNpxaE0Sqyb8TTajq3mOJwOI9izf1SqYV3EzsmQWC6+YKqUdOk6JBoQLj/H4uqL7PF
         lW+7fjjD3AQDDZYksiSLHBv8aKLt7lPAefCezFozOgwILxcuzemrN1KDvjZXzk1KHpMB
         KblmJbQomebq5HMxDSryGv0Ar8Gid2moRmeQP5dXgGlfteg50cEf6FKhsDUyAtWZYQgy
         D++w==
X-Gm-Message-State: AOAM530Avb5mcV9pB0QkUWvsoc4mtNpD/GcMfLcaPdYr/49JBV/STh52
        goGtjmiLWgMwlrszl3VpYuIuCw==
X-Google-Smtp-Source: ABdhPJziFCqK2L01y45cgu4AI91SmHbfPnd9DnO0wdmDYr2+DTfRQR7mUrBTtZTp8tF2s3kh4I46rw==
X-Received: by 2002:adf:df91:: with SMTP id z17mr964095wrl.149.1595349715049;
        Tue, 21 Jul 2020 09:41:55 -0700 (PDT)
Received: from localhost.localdomain ([2.27.167.94])
        by smtp.gmail.com with ESMTPSA id m4sm3933524wmi.48.2020.07.21.09.41.54
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 21 Jul 2020 09:41:54 -0700 (PDT)
From:   Lee Jones <lee.jones@linaro.org>
To:     jejb@linux.ibm.com, martin.petersen@oracle.com
Cc:     linux-kernel@vger.kernel.org, linux-scsi@vger.kernel.org,
        Lee Jones <lee.jones@linaro.org>,
        Hannes Reinecke <hare@suse.com>
Subject: [PATCH 02/40] scsi: aic7xxx: aic79xx_core: Remove a bunch of unused variables
Date:   Tue, 21 Jul 2020 17:41:10 +0100
Message-Id: <20200721164148.2617584-3-lee.jones@linaro.org>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20200721164148.2617584-1-lee.jones@linaro.org>
References: <20200721164148.2617584-1-lee.jones@linaro.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8bit
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

Question: Can 'ahd_inb(ahd, LQISTAT2);' also be safely removed?

Fixes the following W=1 kernel build warning(s):

 drivers/scsi/aic7xxx/aic79xx_core.c: In function ‘ahd_dump_sglist’:
 drivers/scsi/aic7xxx/aic79xx_core.c:1738:14: warning: variable ‘len’ set but not used [-Wunused-but-set-variable]
 1738 | uint32_t len;
 | ^~~
 drivers/scsi/aic7xxx/aic79xx_core.c: In function ‘ahd_handle_seqint’:
 drivers/scsi/aic7xxx/aic79xx_core.c:1911:26: warning: variable ‘tinfo’ set but not used [-Wunused-but-set-variable]
 1911 | struct ahd_transinfo *tinfo;
 | ^~~~~
 drivers/scsi/aic7xxx/aic79xx_core.c: In function ‘ahd_handle_transmission_error’:
 drivers/scsi/aic7xxx/aic79xx_core.c:2672:8: warning: variable ‘lqistat2’ set but not used [-Wunused-but-set-variable]
 2672 | u_int lqistat2;
 | ^~~~~~~~
 drivers/scsi/aic7xxx/aic79xx_core.c: In function ‘ahd_update_pending_scbs’:
 drivers/scsi/aic7xxx/aic79xx_core.c:4221:31: warning: variable ‘tinfo’ set but not used [-Wunused-but-set-variable]
 4221 | struct ahd_initiator_tinfo *tinfo;
 | ^~~~~

Cc: Hannes Reinecke <hare@suse.com>
Signed-off-by: Lee Jones <lee.jones@linaro.org>
---
 drivers/scsi/aic7xxx/aic79xx_core.c | 13 +++----------
 1 file changed, 3 insertions(+), 10 deletions(-)

diff --git a/drivers/scsi/aic7xxx/aic79xx_core.c b/drivers/scsi/aic7xxx/aic79xx_core.c
index e4a09b93d00ce..243e763085a61 100644
--- a/drivers/scsi/aic7xxx/aic79xx_core.c
+++ b/drivers/scsi/aic7xxx/aic79xx_core.c
@@ -1735,10 +1735,8 @@ ahd_dump_sglist(struct scb *scb)
 			sg_list = (struct ahd_dma64_seg*)scb->sg_list;
 			for (i = 0; i < scb->sg_count; i++) {
 				uint64_t addr;
-				uint32_t len;
 
 				addr = ahd_le64toh(sg_list[i].addr);
-				len = ahd_le32toh(sg_list[i].len);
 				printk("sg[%d] - Addr 0x%x%x : Length %d%s\n",
 				       i,
 				       (uint32_t)((addr >> 32) & 0xFFFFFFFF),
@@ -1908,7 +1906,6 @@ ahd_handle_seqint(struct ahd_softc *ahd, u_int intstat)
 			struct	scb *scb;
 			struct	ahd_initiator_tinfo *targ_info;
 			struct	ahd_tmode_tstate *tstate;
-			struct	ahd_transinfo *tinfo;
 			u_int	scbid;
 
 			/*
@@ -1941,7 +1938,6 @@ ahd_handle_seqint(struct ahd_softc *ahd, u_int intstat)
 							devinfo.our_scsiid,
 							devinfo.target,
 							&tstate);
-			tinfo = &targ_info->curr;
 			ahd_set_width(ahd, &devinfo, MSG_EXT_WDTR_BUS_8_BIT,
 				      AHD_TRANS_ACTIVE, /*paused*/TRUE);
 			ahd_set_syncrate(ahd, &devinfo, /*period*/0,
@@ -2669,7 +2665,6 @@ ahd_handle_transmission_error(struct ahd_softc *ahd)
 	struct	scb *scb;
 	u_int	scbid;
 	u_int	lqistat1;
-	u_int	lqistat2;
 	u_int	msg_out;
 	u_int	curphase;
 	u_int	lastphase;
@@ -2680,7 +2675,7 @@ ahd_handle_transmission_error(struct ahd_softc *ahd)
 	scb = NULL;
 	ahd_set_modes(ahd, AHD_MODE_SCSI, AHD_MODE_SCSI);
 	lqistat1 = ahd_inb(ahd, LQISTAT1) & ~(LQIPHASE_LQ|LQIPHASE_NLQ);
-	lqistat2 = ahd_inb(ahd, LQISTAT2);
+	ahd_inb(ahd, LQISTAT2);
 	if ((lqistat1 & (LQICRCI_NLQ|LQICRCI_LQ)) == 0
 	 && (ahd->bugs & AHD_NLQICRC_DELAYED_BUG) != 0) {
 		u_int lqistate;
@@ -4218,13 +4213,11 @@ ahd_update_pending_scbs(struct ahd_softc *ahd)
 	pending_scb_count = 0;
 	LIST_FOREACH(pending_scb, &ahd->pending_scbs, pending_links) {
 		struct ahd_devinfo devinfo;
-		struct ahd_initiator_tinfo *tinfo;
 		struct ahd_tmode_tstate *tstate;
 
 		ahd_scb_devinfo(ahd, &devinfo, pending_scb);
-		tinfo = ahd_fetch_transinfo(ahd, devinfo.channel,
-					    devinfo.our_scsiid,
-					    devinfo.target, &tstate);
+		ahd_fetch_transinfo(ahd, devinfo.channel, devinfo.our_scsiid,
+				    devinfo.target, &tstate);
 		if ((tstate->auto_negotiate & devinfo.target_mask) == 0
 		 && (pending_scb->flags & SCB_AUTO_NEGOTIATE) != 0) {
 			pending_scb->flags &= ~SCB_AUTO_NEGOTIATE;
-- 
2.25.1

