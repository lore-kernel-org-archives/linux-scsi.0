Return-Path: <SRS0=/6u/=WU=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.6 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT autolearn=unavailable
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 58EC9C3A5A4
	for <linux-scsi@archiver.kernel.org>; Sat, 24 Aug 2019 15:02:46 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 2EB472173E
	for <linux-scsi@archiver.kernel.org>; Sat, 24 Aug 2019 15:02:46 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="sQCRGRLg"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727682AbfHXPCn (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Sat, 24 Aug 2019 11:02:43 -0400
Received: from mail-pf1-f194.google.com ([209.85.210.194]:42656 "EHLO
        mail-pf1-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727556AbfHXPCn (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Sat, 24 Aug 2019 11:02:43 -0400
Received: by mail-pf1-f194.google.com with SMTP id i30so8658096pfk.9;
        Sat, 24 Aug 2019 08:02:42 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id;
        bh=yvlfcwHhYYEt45AEV3kpvsKP89qUArjfynDA7p15x1g=;
        b=sQCRGRLg0XwcENprB4U9XKoLQbl1pdzKeXP908+f4eAo2UBXTk8lR9dNTjBJMd7qBG
         AjPytexu7y1JIqX9qSxvYS3BDFBhCXAmy1f5ghYVnz1r2QawaNcH7wQJm0CJOg5yhwZD
         MCqF3oV8hnNpxiafdWmsdXf79QMdNCKteycBGb5ZaMMUHTF3MsQLo8bzPpfswjEsL3fe
         LVWfVUtzaUcYy0CxenU+6kOHySLPDYzvqb/Mre5xRKuprWH7CpNPlMKGunl/Phq5Jc9p
         3hFHov4jyt3cN+W/+xhJvEvp4s8hgisDyEWn/Bw/qca59reUvTJQTc7OS0199PxeXHqf
         T2kA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id;
        bh=yvlfcwHhYYEt45AEV3kpvsKP89qUArjfynDA7p15x1g=;
        b=XgqJRH0fKcVnhmLTIsRgnhEbvRDac+cuAvfvkH17hERL83E3oTv9fgarHbO55e2XP6
         KE4HT98PZBciMYxFZb6iDZBa4/931f6vbFcAiUiEE2ApedBO0YO3TeDdf0KgBaRBkLFz
         onot/eAzfOLgOdUdh3GdjYFVww4nL/yotBXhWdeFfil7oI/sDqYsaiCH0eyVf2GVFttc
         /OKN8GvK9evcPaItOrVoZz0EYCmg9tqJkMIsxEvgpvCeD+Ad4hESCWiAySav6asrHTjU
         LTOp0ahuviB0vFzazKlnqOnAgj9ytOBAPkYUOz3SNPRiuzbgzFpTuL8IyH6kWzCzifQm
         nnhA==
X-Gm-Message-State: APjAAAUt5RTOElQS1EZ9irPZ1d7GearvIa8z0MiYkk3z1n4mSpmen6hc
        r1BDMFufEYHUTRIL1GYQl8w=
X-Google-Smtp-Source: APXvYqwVdR14UXJ4cILqtv2OODOEEm6/JWssfKvn3BXAgbuL/zLqTejw/DZHr0LenO5mEuGLQEP1GA==
X-Received: by 2002:a17:90a:23c5:: with SMTP id g63mr10621207pje.124.1566658962276;
        Sat, 24 Aug 2019 08:02:42 -0700 (PDT)
Received: from jordon-HP-15-Notebook-PC.domain.name ([106.51.17.2])
        by smtp.gmail.com with ESMTPSA id c12sm8680413pfc.22.2019.08.24.08.02.38
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-SHA bits=128/128);
        Sat, 24 Aug 2019 08:02:41 -0700 (PDT)
From:   Souptick Joarder <jrdr.linux@gmail.com>
To:     hare@suse.com, jejb@linux.ibm.com, martin.petersen@oracle.com
Cc:     linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org,
        Souptick Joarder <jrdr.linux@gmail.com>
Subject: [PATCH] scsi: aic7xxx: Remove dead code
Date:   Sat, 24 Aug 2019 20:38:22 +0530
Message-Id: <1566659302-3514-1-git-send-email-jrdr.linux@gmail.com>
X-Mailer: git-send-email 1.9.1
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

These are dead code since 2.6.13. If there is no plan
to use it further, these can be removed forever.

Signed-off-by: Souptick Joarder <jrdr.linux@gmail.com>
---
 drivers/scsi/aic7xxx/aic7xxx_osm.c | 68 --------------------------------------
 1 file changed, 68 deletions(-)

diff --git a/drivers/scsi/aic7xxx/aic7xxx_osm.c b/drivers/scsi/aic7xxx/aic7xxx_osm.c
index d5c4a0d..98d2e14 100644
--- a/drivers/scsi/aic7xxx/aic7xxx_osm.c
+++ b/drivers/scsi/aic7xxx/aic7xxx_osm.c
@@ -2445,68 +2445,6 @@ static void ahc_linux_set_dt(struct scsi_target *starget, int dt)
 	ahc_unlock(ahc, &flags);
 }
 
-#if 0
-/* FIXME: This code claims to support IU and QAS.  However, the actual
- * sequencer code and aic7xxx_core have no support for these parameters and
- * will get into a bad state if they're negotiated.  Do not enable this
- * unless you know what you're doing */
-static void ahc_linux_set_qas(struct scsi_target *starget, int qas)
-{
-	struct Scsi_Host *shost = dev_to_shost(starget->dev.parent);
-	struct ahc_softc *ahc = *((struct ahc_softc **)shost->hostdata);
-	struct ahc_tmode_tstate *tstate;
-	struct ahc_initiator_tinfo *tinfo 
-		= ahc_fetch_transinfo(ahc,
-				      starget->channel + 'A',
-				      shost->this_id, starget->id, &tstate);
-	struct ahc_devinfo devinfo;
-	unsigned int ppr_options = tinfo->goal.ppr_options
-		& ~MSG_EXT_PPR_QAS_REQ;
-	unsigned int period = tinfo->goal.period;
-	unsigned long flags;
-	struct ahc_syncrate *syncrate;
-
-	if (qas)
-		ppr_options |= MSG_EXT_PPR_QAS_REQ;
-
-	ahc_compile_devinfo(&devinfo, shost->this_id, starget->id, 0,
-			    starget->channel + 'A', ROLE_INITIATOR);
-	syncrate = ahc_find_syncrate(ahc, &period, &ppr_options, AHC_SYNCRATE_DT);
-	ahc_lock(ahc, &flags);
-	ahc_set_syncrate(ahc, &devinfo, syncrate, period, tinfo->goal.offset,
-			 ppr_options, AHC_TRANS_GOAL, FALSE);
-	ahc_unlock(ahc, &flags);
-}
-
-static void ahc_linux_set_iu(struct scsi_target *starget, int iu)
-{
-	struct Scsi_Host *shost = dev_to_shost(starget->dev.parent);
-	struct ahc_softc *ahc = *((struct ahc_softc **)shost->hostdata);
-	struct ahc_tmode_tstate *tstate;
-	struct ahc_initiator_tinfo *tinfo 
-		= ahc_fetch_transinfo(ahc,
-				      starget->channel + 'A',
-				      shost->this_id, starget->id, &tstate);
-	struct ahc_devinfo devinfo;
-	unsigned int ppr_options = tinfo->goal.ppr_options
-		& ~MSG_EXT_PPR_IU_REQ;
-	unsigned int period = tinfo->goal.period;
-	unsigned long flags;
-	struct ahc_syncrate *syncrate;
-
-	if (iu)
-		ppr_options |= MSG_EXT_PPR_IU_REQ;
-
-	ahc_compile_devinfo(&devinfo, shost->this_id, starget->id, 0,
-			    starget->channel + 'A', ROLE_INITIATOR);
-	syncrate = ahc_find_syncrate(ahc, &period, &ppr_options, AHC_SYNCRATE_DT);
-	ahc_lock(ahc, &flags);
-	ahc_set_syncrate(ahc, &devinfo, syncrate, period, tinfo->goal.offset,
-			 ppr_options, AHC_TRANS_GOAL, FALSE);
-	ahc_unlock(ahc, &flags);
-}
-#endif
-
 static void ahc_linux_get_signalling(struct Scsi_Host *shost)
 {
 	struct ahc_softc *ahc = *(struct ahc_softc **)shost->hostdata;
@@ -2545,12 +2483,6 @@ static void ahc_linux_get_signalling(struct Scsi_Host *shost)
 	.show_width	= 1,
 	.set_dt		= ahc_linux_set_dt,
 	.show_dt	= 1,
-#if 0
-	.set_iu		= ahc_linux_set_iu,
-	.show_iu	= 1,
-	.set_qas	= ahc_linux_set_qas,
-	.show_qas	= 1,
-#endif
 	.get_signalling	= ahc_linux_get_signalling,
 };
 
-- 
1.9.1

