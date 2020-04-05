Return-Path: <SRS0=3U4t=5V=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.6 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id F039EC2BA1B
	for <linux-scsi@archiver.kernel.org>; Sun,  5 Apr 2020 09:01:00 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id A82DF206B8
	for <linux-scsi@archiver.kernel.org>; Sun,  5 Apr 2020 09:01:00 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="IQzGYW7l"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726402AbgDEJA5 (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Sun, 5 Apr 2020 05:00:57 -0400
Received: from mail-pg1-f196.google.com ([209.85.215.196]:35936 "EHLO
        mail-pg1-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726308AbgDEJA5 (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Sun, 5 Apr 2020 05:00:57 -0400
Received: by mail-pg1-f196.google.com with SMTP id c23so6009600pgj.3;
        Sun, 05 Apr 2020 02:00:56 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id;
        bh=C3DKHqFF1QCT9SKqcOsEde3IYDbstDW/l6K2MKOt7IQ=;
        b=IQzGYW7l6NC43L3AKAWdfRigHVEgTsXVUFr3j/W1sZDICh7EE0gGJPKtnme44E6VGK
         84TD4JnVJIHa2WbN4V8kfV676tOBqP1i2gPHY7NZI4LLGUMqYXxC0wLxtUt3p0tAtfgQ
         4d5jCmPkb0mOckJZFhaZdhD2hO0xrns7rz383UesOCebq0ikOxdnF3leY+FWiioxkPFm
         xjJyZzyOoX46XbDFenneVCm12r2hA9a6uXslgOitrhhNXy2JuErku9XjCiXzATOExBSb
         TJtAAaZV29Pv+7C2EWprUZ2mNUqPCMjpAlXZZx7ZqveU7SU3OkNLLStLJr/yuhlFnCfJ
         jXLA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id;
        bh=C3DKHqFF1QCT9SKqcOsEde3IYDbstDW/l6K2MKOt7IQ=;
        b=GkXUI8XxdcfS5IQLn1ZT/TZNxhjouXpAn0bHIffYNEWMW21rceshCJUHWPj1Pme0ik
         9nMAzYD5OfXfIBG0gJztYnWZ4xCeRiyh+BbvAn6QNAwUylbqjPvEsT1NQooPntKeX5xf
         jNRWHAt3Ohu84glwzA9p3jjYAfDsJwVs60Apr+IpPHt1rxoUYpWbsqL9h1YZA7ZRLN3b
         vNTPsW76d9gOAboWh/MRrtEgBOshN4RPAxxf3q6lRhijvc1354pPUka+RnJJgV6rin6l
         JatbP4FsGtWPpifVlT3h4LSpIneKsXkKiPZ7NYA+0VBFrHoshQ3dGvvZ1Y0PytWB8A24
         3JDA==
X-Gm-Message-State: AGi0PubfH7F0UedMGQ82Z7KmzgINhEU7v3Vr9RzaVkQRWDRBKnzXPJbR
        G7H28CzdX1Ib20uokRWGAZU=
X-Google-Smtp-Source: APiQypJsHVf6GyysweAe/1bPGo6zHgQbzzOZwulYM/cOPNz7LazsGhbU9DyKDJPlhFeaAKOaW53QFw==
X-Received: by 2002:a63:1c1:: with SMTP id 184mr16864268pgb.203.1586077255898;
        Sun, 05 Apr 2020 02:00:55 -0700 (PDT)
Received: from localhost (n112120135125.netvigator.com. [112.120.135.125])
        by smtp.gmail.com with ESMTPSA id f15sm9157708pfd.215.2020.04.05.02.00.55
        (version=TLS1_2 cipher=ECDHE-RSA-CHACHA20-POLY1305 bits=256/256);
        Sun, 05 Apr 2020 02:00:55 -0700 (PDT)
From:   Qiujun Huang <hqjagain@gmail.com>
To:     hare@suse.com, jejb@linux.ibm.com, martin.petersen@oracle.com
Cc:     linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org,
        Qiujun Huang <hqjagain@gmail.com>
Subject: [PATCH] scsi: aic7xxx: Remove NULL check before kfree
Date:   Sun,  5 Apr 2020 17:00:34 +0800
Message-Id: <20200405090034.29622-1-hqjagain@gmail.com>
X-Mailer: git-send-email 2.17.1
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

NULL check before kfree is unnecessary so remove it.
This issue was detected by using the Coccinelle software.

Signed-off-by: Qiujun Huang <hqjagain@gmail.com>
---
 drivers/scsi/aic7xxx/aic7xxx_core.c | 15 +++++----------
 1 file changed, 5 insertions(+), 10 deletions(-)

diff --git a/drivers/scsi/aic7xxx/aic7xxx_core.c b/drivers/scsi/aic7xxx/aic7xxx_core.c
index 4190a025381a..a45365b0651a 100644
--- a/drivers/scsi/aic7xxx/aic7xxx_core.c
+++ b/drivers/scsi/aic7xxx/aic7xxx_core.c
@@ -2193,8 +2193,7 @@ ahc_free_tstate(struct ahc_softc *ahc, u_int scsi_id, char channel, int force)
 	if (channel == 'B')
 		scsi_id += 8;
 	tstate = ahc->enabled_targets[scsi_id];
-	if (tstate != NULL)
-		kfree(tstate);
+	kfree(tstate);
 	ahc->enabled_targets[scsi_id] = NULL;
 }
 #endif
@@ -4474,8 +4473,7 @@ ahc_set_unit(struct ahc_softc *ahc, int unit)
 void
 ahc_set_name(struct ahc_softc *ahc, char *name)
 {
-	if (ahc->name != NULL)
-		kfree(ahc->name);
+	kfree(ahc->name);
 	ahc->name = name;
 }
 
@@ -4536,10 +4534,8 @@ ahc_free(struct ahc_softc *ahc)
 		kfree(ahc->black_hole);
 	}
 #endif
-	if (ahc->name != NULL)
-		kfree(ahc->name);
-	if (ahc->seep_config != NULL)
-		kfree(ahc->seep_config);
+	kfree(ahc->name);
+	kfree(ahc->seep_config);
 #ifndef __FreeBSD__
 	kfree(ahc);
 #endif
@@ -4950,8 +4946,7 @@ ahc_fini_scbdata(struct ahc_softc *ahc)
 	case 0:
 		break;
 	}
-	if (scb_data->scbarray != NULL)
-		kfree(scb_data->scbarray);
+	kfree(scb_data->scbarray);
 }
 
 static void
-- 
2.17.1

