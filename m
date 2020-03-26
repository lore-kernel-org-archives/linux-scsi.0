Return-Path: <SRS0=ycLx=5L=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.5 required=3.0 tests=DKIM_INVALID,DKIM_SIGNED,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT autolearn=unavailable
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 8111CC43331
	for <linux-scsi@archiver.kernel.org>; Thu, 26 Mar 2020 19:38:51 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 5414E20714
	for <linux-scsi@archiver.kernel.org>; Thu, 26 Mar 2020 19:38:51 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="signature verification failed" (1024-bit key) header.d=gmx.net header.i=@gmx.net header.b="JPx1PEc5"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727354AbgCZTiq (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Thu, 26 Mar 2020 15:38:46 -0400
Received: from mout.gmx.net ([212.227.15.18]:33791 "EHLO mout.gmx.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726340AbgCZTiq (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
        Thu, 26 Mar 2020 15:38:46 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=gmx.net;
        s=badeba3b8450; t=1585251514;
        bh=nIDDfq+abaAHQYUdKZ8Szi95vJE1wabuhvaK9tddpb8=;
        h=X-UI-Sender-Class:From:To:Cc:Subject:Date;
        b=JPx1PEc54q6qkFcBInrqKWb080RTe8zqI7V8Jyf0uTmnyTE4QNP0ERKPtQfqIbQFa
         AjOvcFDLBeU5TR5/zY86dLlnRM1ky+dzW7qGZplsJ2CzkGtYTe8nWFRFOy1odh0vi9
         1wgt/6n/dvlsG4GkbHDG3ZIwHWygFYFLq3FwREvY=
X-UI-Sender-Class: 01bb95c1-4bf8-414a-932a-4f6e2808ef9c
Received: from localhost.localdomain ([82.19.195.159]) by mail.gmx.com
 (mrgmx004 [212.227.17.184]) with ESMTPSA (Nemesis) id
 1MOA3P-1itAv23I0f-00Oam8; Thu, 26 Mar 2020 20:38:33 +0100
From:   Alex Dewar <alex.dewar@gmx.co.uk>
Cc:     alex.dewar@gmx.co.uk, Hannes Reinecke <hare@suse.com>,
        "James E.J. Bottomley" <jejb@linux.ibm.com>,
        "Martin K. Petersen" <martin.petersen@oracle.com>,
        linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH] scsi: aic7xxx: aic97xx: Remove FreeBSD-specific code
Date:   Thu, 26 Mar 2020 19:38:17 +0000
Message-Id: <20200326193817.12568-1-alex.dewar@gmx.co.uk>
X-Mailer: git-send-email 2.26.0
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Provags-ID: V03:K1:EoKMGVgPqbm/NudaV7nK++v76WAKtvCJBuKOB1zX72dFD34r6O1
 +YVbeQuCCDao2oBEV+B/nMqxaHkxGqtB3DcnO/GovLlWmTG3Zl0a0ZcW6s8T/mW9Mip+rNE
 VWMXhEe6+Jymb4fXULwNHdFX2qkeFYxv4b2u/Uw6dCDrfMZ02GOxsKq9JH5es4BDWNa6uQo
 W3MP4YwZmiah9WxkNAOvQ==
X-UI-Out-Filterresults: notjunk:1;V03:K0:/VWNwnjenT4=:hnj19P/M1lK5/XCAcRQQvf
 Zb4lLrtIXHElMj7Ih5uqZrFlp2Np4HsXskBmm2McYdJ+yiCBn4dq6qIQOSRm9nL29GKgrNDvB
 RgkW5s+D5zfm7mnf/osiLmMpM0oO4lEgyHRNHNuDCKwTGwPUudiuvSAE6czetjCgKH4lQMfbN
 Ui0BWhWV5ZN+kA/7sBhy+a9PSwxEEm6Ce1dLPwEjF/XzF+rS9j/S2Q4zr/YCqNcU0odLaK5+U
 Y6I34ej01AsKaKJiwnJmavS+DlVThPYR6CdvPRmAgB754O5apAsUGupPgkU/LiNdaO7L5/1F0
 6jtYr7/LKTFANKx4derX9E1LC1RXIAX2mLZCaMFAPeJgxxw7S7mmihNobR68K9TKTps6V5y7M
 B62Q5SHvt+IIgqLb/5iIJYe6JiuHyoseE6erN9B/XN3sTMgZLBg2bj3oLLcoGclAvu5qsP59Q
 3tkOgTBwI8R7Vm4GNg5Um44SRn57qw43VS5WuwoUmDOBPHEyuGE6iHatsGBikFOH+TlhI4tnB
 vSZ+3Yj0Be9cjpYaIMR5D3/qQxjnmDAEgf+XaJYZzjNt9NLbYmsQmiUxPBTj/hCPgKqWkjECA
 HPg6nr2yDTLlyXquXhCUQC6xjRnfgKym+eubXzzqP6v6phhXyaqvIJH2gcFqLeIoxnx9osOhG
 lEfBwOmoCxNm1TGOMP0/rDfHHQguSEP7N0Vv06aY2oxFo1lpRmAFjP5U32V6M9Sbwhr6Ec+Aj
 nZtk+qPhynFYLNN+pN8vRTo70m0uurySeVmIV6PtFzLKAyweIMQXdEBIopizRYOg7f0HZPjnO
 mQU/Xf2wx0s8HJ5ENLeE6Ui0bj4BwMqjIxy7zjGsl4vnPoiKOZYcwrGbT7xC+K5qVqAHQBHP7
 XV0Yj79QRoPkw1GXzkgsLysCb6z0BpDjrquxIgaBOtRQDoPVstW51oCwdQLZcoTIiGWRBgg7t
 tzWsy8P0CT0WYF3H4h6lvF7bQU2QfxPDggFJOh3ENLSNTQHc2uZCVUIkXKCxYC0qHI4fudlwZ
 Birfm2mqrBXuAKPjodGJx78DvbLCqX7s/Snbqj+oLoBwxLomcYzYXttlzDZfyYa6HrLSooYtd
 /b18v8hXCbPkU+xjnHPEB4k+h/6jpwiUxtX4RRxLc+DBHHh03E6NeLK3oZlMvOyPARxS0TO6R
 nnWro31Pfk0gAOKG8gSoWsVCOlInYPokDWWsTqQFkrSvTwcUTA82vMJYph0pT8GbwmItR/wQn
 UnuC0xBFYmNQvKwfe
To:     unlisted-recipients:; (no To-header on input)
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

The file aic79xx_core.c still contains some FreeBSD-specific code/macro
guards, although cross-compatibility was in theory removed with
commit cca6cb8ad7a8 ("scsi: aic7xxx: Fix build using bare-metal
toolchain"). Remove it.

Signed-off-by: Alex Dewar <alex.dewar@gmx.co.uk>
=2D--
 drivers/scsi/aic7xxx/aic79xx_core.c | 22 +---------------------
 1 file changed, 1 insertion(+), 21 deletions(-)

diff --git a/drivers/scsi/aic7xxx/aic79xx_core.c b/drivers/scsi/aic7xxx/ai=
c79xx_core.c
index 7e5044bf05c0..a336a458c978 100644
=2D-- a/drivers/scsi/aic7xxx/aic79xx_core.c
+++ b/drivers/scsi/aic7xxx/aic79xx_core.c
@@ -3107,19 +3107,6 @@ ahd_handle_nonpkt_busfree(struct ahd_softc *ahd)
 			printerror =3D 0;
 		} else if (ahd_sent_msg(ahd, AHDMSG_1B,
 					MSG_BUS_DEV_RESET, TRUE)) {
-#ifdef __FreeBSD__
-			/*
-			 * Don't mark the user's request for this BDR
-			 * as completing with CAM_BDR_SENT.  CAM3
-			 * specifies CAM_REQ_CMP.
-			 */
-			if (scb !=3D NULL
-			 && scb->io_ctx->ccb_h.func_code=3D=3D XPT_RESET_DEV
-			 && ahd_match_scb(ahd, scb, target, 'A',
-					  CAM_LUN_WILDCARD, SCB_LIST_NULL,
-					  ROLE_INITIATOR))
-				ahd_set_transaction_status(scb, CAM_REQ_CMP);
-#endif
 			ahd_handle_devreset(ahd, &devinfo, CAM_LUN_WILDCARD,
 					    CAM_BDR_SENT, "Bus Device Reset",
 					    /*verbose_level*/0);
@@ -6067,22 +6054,17 @@ ahd_alloc(void *platform_arg, char *name)
 {
 	struct  ahd_softc *ahd;

-#ifndef	__FreeBSD__
 	ahd =3D kmalloc(sizeof(*ahd), GFP_ATOMIC);
 	if (!ahd) {
 		printk("aic7xxx: cannot malloc softc!\n");
 		kfree(name);
 		return NULL;
 	}
-#else
-	ahd =3D device_get_softc((device_t)platform_arg);
-#endif
+
 	memset(ahd, 0, sizeof(*ahd));
 	ahd->seep_config =3D kmalloc(sizeof(*ahd->seep_config), GFP_ATOMIC);
 	if (ahd->seep_config =3D=3D NULL) {
-#ifndef	__FreeBSD__
 		kfree(ahd);
-#endif
 		kfree(name);
 		return (NULL);
 	}
@@ -6206,9 +6188,7 @@ ahd_free(struct ahd_softc *ahd)
 		kfree(ahd->seep_config);
 	if (ahd->saved_stack !=3D NULL)
 		kfree(ahd->saved_stack);
-#ifndef __FreeBSD__
 	kfree(ahd);
-#endif
 	return;
 }

=2D-
2.26.0

