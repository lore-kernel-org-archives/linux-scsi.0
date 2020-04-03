Return-Path: <SRS0=YASp=5T=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.8 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT autolearn=unavailable
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 026BAC2BA15
	for <linux-scsi@archiver.kernel.org>; Fri,  3 Apr 2020 16:47:35 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id C67032073B
	for <linux-scsi@archiver.kernel.org>; Fri,  3 Apr 2020 16:47:34 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=gmx.net header.i=@gmx.net header.b="SNCFkrIf"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2404111AbgDCQrb (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Fri, 3 Apr 2020 12:47:31 -0400
Received: from mout.gmx.net ([212.227.15.15]:47233 "EHLO mout.gmx.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2403971AbgDCQra (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
        Fri, 3 Apr 2020 12:47:30 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=gmx.net;
        s=badeba3b8450; t=1585932436;
        bh=qJteazr5M6rwWKSsYgV4eOwWceCPewIZnI3tMHV1Y2I=;
        h=X-UI-Sender-Class:From:To:Cc:Subject:Date;
        b=SNCFkrIfIPOKdBTGy463Mce00xt08x4XosNguyLfOuH4tEKBw4R0TR+wrU+++L4tD
         EM1m61pKA5ox4h01dU0rkFgxpLNuZQJkHngSj7+RK9xb01skBMBioJhNczQpAyMg3h
         0FqiGkqwu78EfNXzEKaucp6sp1v6wN9vKAbZ+MGc=
X-UI-Sender-Class: 01bb95c1-4bf8-414a-932a-4f6e2808ef9c
Received: from localhost.localdomain ([82.19.195.159]) by mail.gmx.com
 (mrgmx004 [212.227.17.184]) with ESMTPSA (Nemesis) id
 1My36T-1j7ZPv0LdP-00zYMG; Fri, 03 Apr 2020 18:47:16 +0200
From:   Alex Dewar <alex.dewar@gmx.co.uk>
To:     alex.dewar@gmx.co.uk
Cc:     Hannes Reinecke <hare@suse.com>,
        "James E.J. Bottomley" <jejb@linux.ibm.com>,
        "Martin K. Petersen" <martin.petersen@oracle.com>,
        linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH] scsi: aic7xxx: Remove unnecessary NULL checks before kfree
Date:   Fri,  3 Apr 2020 17:47:11 +0100
Message-Id: <20200403164712.49579-1-alex.dewar@gmx.co.uk>
X-Mailer: git-send-email 2.26.0
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Provags-ID: V03:K1:fnsZtus8vNbCBY2l68QzfmvYtczTkefNM+aGSl3RyTk2e+DXBXk
 wEDRz6OgFRCXEdrv+NpkHLVjRaws1mylcq9DNiGDqApMnkLPDY9Xe1XFC3C0EqOqp1Sq0Yn
 c9Y9MpdbNlPbl0iViUnwHMAmHxgiR53ZguiJ754BSO6bKjeuH2DOvJ3pSnSsP+HjNAMmI4m
 ZIeh6YgE37FR9L2n0NwMA==
X-UI-Out-Filterresults: notjunk:1;V03:K0:ek0cCF4NXEU=:OcYrwIpjcMVElXigWXJWip
 2LmcqvXH2HTV18sVTxm+bUojVhC/yMR786lpck4U3mwgoLRaavWHssi6SQNiRGNrk2hzNmyfP
 SCGMQHM3oUTJ4LgIeELHNe87NJ5VPYWrwW33yj2XaxEtPqpnujLNb4qjEv9FQS7K92Wustngx
 DUUkyCAXwcF2SooL+LhnjUkBgrme2WqvgOn+Ntsr/NF/BSJVRp8TkMHkZALah9kq2dMs3SRfk
 +uYseCckrbaukq/cRVSegMeYKbXyu/aYoB/2L5dQSZN6V31/c4LZjz6u1z/OPpA6a/J9PsYSr
 wBQpDTVEapNve6oDzXZYVabAjmoBwZDYlhu0heRjuf9JMdemUpNFBpEV7lOUQPNoIZEL6jcSB
 D7hpsHLBxtMHymYwhZFqk/iUXLHMy79ce9BqkHKIZDM3IRnOnIhYn1QEKNo5GH1uuHju0yGtp
 MBRuslXnoRcLMHqn3ezPBoyeRH9WVA8f5FgqEHnqn52b78MHTLSDpm0BIOe0zPCfJLHKwjoyh
 L4qIfIKht9faa0PPdbiGxVGQDRnrH8y+V8ZZ8eQuudMxLEAStQkepNAvgKJa1hhGJVxgxm1dO
 Q3kZfVHx8pVakqxUv2sNLXCqy76w/fbq7zROR9RFbKwWnUPvh74f/yvEWXVCQJ/ayU5pCApBG
 2ohv2yPIH5EruD+SnGqsIOXiyTpOpZBHJFdQ2JKOjmBVdU+JZ5R3pahqjmGnUXSRW26DcMS5W
 hEL+TEtA2+RnatpiwaKoOA1Gxy2vvUEex4R0T94FtpPWp36D1KV8ozZP9yhEDlXmLwMa7nQ8u
 jq6K6vVunjBk+Y5Y/pDeGvoWPIT6p+TQ2j06ElZXM9Ps2o0PgMW59/I5ehPl+NiuBDslIXSbn
 ijEZVAJ+3ladYgmVHtlokZM24G3DOs4u0owzJIS8+XzF7xOSW8z5V9aQBQ4XaOWvP7ErTaehj
 Qyfv6C2ZP2EMmyxoQK+v2haoqT0t3KfDHvT5DYIkzRhmGBJlaIIxGXG1TuIft5oBVDzslDxJ1
 xfHFuuLS1+CtyFZB4VTmTuZR4Dq5m6riROkjO1W0z/bn8qIfkiyVApkJOb4B/wiesXmvvUhcT
 lv1E3Wmyl1+VGQbtUEI91bYbiLBPUAKKHlh6qWX6VSEW27A0ZvXOky0mDdnr3WqKbd08y4s69
 ffQL36CJ5eUvBMhiKV2R/cLOQTbWM0d5ZmM6/z/mt9FohgBpg51AnX3PzKaO1nZZUCdGuxREM
 FDTg/vPs1/7GsYeJ1
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

There are a number of places in the aic7xxx driver where a NULL check is
performed before a kfree(). However, kfree() already performs NULL checks
so this is unnecessary. Remove the checks.

Issue identified with Coccinelle.

Signed-off-by: Alex Dewar <alex.dewar@gmx.co.uk>
=2D--
 drivers/scsi/aic7xxx/aic79xx_core.c | 15 +++++----------
 drivers/scsi/aic7xxx/aic7xxx_core.c | 15 +++++----------
 2 files changed, 10 insertions(+), 20 deletions(-)

diff --git a/drivers/scsi/aic7xxx/aic79xx_core.c b/drivers/scsi/aic7xxx/ai=
c79xx_core.c
index a336a458c978..72eaad4aef9c 100644
=2D-- a/drivers/scsi/aic7xxx/aic79xx_core.c
+++ b/drivers/scsi/aic7xxx/aic79xx_core.c
@@ -3662,8 +3662,7 @@ ahd_free_tstate(struct ahd_softc *ahd, u_int scsi_id=
, char channel, int force)
 		return;

 	tstate =3D ahd->enabled_targets[scsi_id];
-	if (tstate !=3D NULL)
-		kfree(tstate);
+	kfree(tstate);
 	ahd->enabled_targets[scsi_id] =3D NULL;
 }
 #endif
@@ -6120,8 +6119,7 @@ ahd_set_unit(struct ahd_softc *ahd, int unit)
 void
 ahd_set_name(struct ahd_softc *ahd, char *name)
 {
-	if (ahd->name !=3D NULL)
-		kfree(ahd->name);
+	kfree(ahd->name);
 	ahd->name =3D name;
 }

@@ -6182,12 +6180,9 @@ ahd_free(struct ahd_softc *ahd)
 		kfree(ahd->black_hole);
 	}
 #endif
-	if (ahd->name !=3D NULL)
-		kfree(ahd->name);
-	if (ahd->seep_config !=3D NULL)
-		kfree(ahd->seep_config);
-	if (ahd->saved_stack !=3D NULL)
-		kfree(ahd->saved_stack);
+	kfree(ahd->name);
+	kfree(ahd->seep_config);
+	kfree(ahd->saved_stack);
 	kfree(ahd);
 	return;
 }
diff --git a/drivers/scsi/aic7xxx/aic7xxx_core.c b/drivers/scsi/aic7xxx/ai=
c7xxx_core.c
index 84fc499cb1e6..5a10feea17fe 100644
=2D-- a/drivers/scsi/aic7xxx/aic7xxx_core.c
+++ b/drivers/scsi/aic7xxx/aic7xxx_core.c
@@ -2178,8 +2178,7 @@ ahc_free_tstate(struct ahc_softc *ahc, u_int scsi_id=
, char channel, int force)
 	if (channel =3D=3D 'B')
 		scsi_id +=3D 8;
 	tstate =3D ahc->enabled_targets[scsi_id];
-	if (tstate !=3D NULL)
-		kfree(tstate);
+	kfree(tstate);
 	ahc->enabled_targets[scsi_id] =3D NULL;
 }
 #endif
@@ -4453,8 +4452,7 @@ ahc_set_unit(struct ahc_softc *ahc, int unit)
 void
 ahc_set_name(struct ahc_softc *ahc, char *name)
 {
-	if (ahc->name !=3D NULL)
-		kfree(ahc->name);
+	kfree(ahc->name);
 	ahc->name =3D name;
 }

@@ -4515,10 +4513,8 @@ ahc_free(struct ahc_softc *ahc)
 		kfree(ahc->black_hole);
 	}
 #endif
-	if (ahc->name !=3D NULL)
-		kfree(ahc->name);
-	if (ahc->seep_config !=3D NULL)
-		kfree(ahc->seep_config);
+	kfree(ahc->name);
+	kfree(ahc->seep_config);
 	kfree(ahc);
 	return;
 }
@@ -4927,8 +4923,7 @@ ahc_fini_scbdata(struct ahc_softc *ahc)
 	case 0:
 		break;
 	}
-	if (scb_data->scbarray !=3D NULL)
-		kfree(scb_data->scbarray);
+	kfree(scb_data->scbarray);
 }

 static void
=2D-
2.26.0

