Return-Path: <SRS0=+SnX=5M=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.5 required=3.0 tests=DKIM_INVALID,DKIM_SIGNED,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT autolearn=unavailable
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 537D0C2D0E5
	for <linux-scsi@archiver.kernel.org>; Fri, 27 Mar 2020 19:11:50 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 2C2522072F
	for <linux-scsi@archiver.kernel.org>; Fri, 27 Mar 2020 19:11:50 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="signature verification failed" (1024-bit key) header.d=gmx.net header.i=@gmx.net header.b="VD/Wg3nP"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726959AbgC0TLq (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Fri, 27 Mar 2020 15:11:46 -0400
Received: from mout.gmx.net ([212.227.15.19]:53755 "EHLO mout.gmx.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726738AbgC0TLq (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
        Fri, 27 Mar 2020 15:11:46 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=gmx.net;
        s=badeba3b8450; t=1585336295;
        bh=8Whm2odb9cru4oSy8Pr/kzkWaqvGlKuhyfmTgrfLl/E=;
        h=X-UI-Sender-Class:From:To:Cc:Subject:Date:In-Reply-To:References;
        b=VD/Wg3nPoxEFI9hCPI4+GHYlntpnHzdigoRNMe/hkXeno74XNieAT1M6QJnzypvae
         Sd8O+vou8wVg9eWZBYdFtQJ8Ds0hlzCXsaALeuv90hDMFx0PPz+b/OdPCLAW7Z1dxg
         ya9thv6nTcUNy+DVSv3dqQ4fHi1dpBq+TLNb5WX8=
X-UI-Sender-Class: 01bb95c1-4bf8-414a-932a-4f6e2808ef9c
Received: from localhost.localdomain ([82.19.195.159]) by mail.gmx.com
 (mrgmx004 [212.227.17.184]) with ESMTPSA (Nemesis) id
 1MkYXs-1jec5B02qE-00m0tJ; Fri, 27 Mar 2020 20:11:35 +0100
From:   Alex Dewar <alex.dewar@gmx.co.uk>
Cc:     alex.dewar@gmx.co.uk, Martin Petersen <martin.petersen@oracle.com>,
        Hannes Reinecke <hare@suse.com>,
        "James E.J. Bottomley" <jejb@linux.ibm.com>,
        linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH] scsi: aic7xxx: Remove more FreeBSD-specific code from aic7xxx_core.c
Date:   Fri, 27 Mar 2020 19:11:02 +0000
Message-Id: <20200327191102.78554-1-alex.dewar@gmx.co.uk>
X-Mailer: git-send-email 2.26.0
In-Reply-To: <yq15zepbsve.fsf@oracle.com>
References: <yq15zepbsve.fsf@oracle.com>
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Provags-ID: V03:K1:rQ/y2c9OY/H+OTBiKokF//EIecEuAFClMr6MRPBTWLTEDKo3x5G
 yKN17Vuquz3ReulJpC6ta/o65LDPLkR7L3fe/H2qHdYuvUf9PXOeDW/ODB0xUFO4cwiUtaY
 30DqzvJMVPGCVnP5h8lXtKz9NmfOnX1a65asCOwmoIYdKsg1kv5ndC7/0OawevHAdRX/29d
 kk62uCpi6qfpW6Ye17+7Q==
X-UI-Out-Filterresults: notjunk:1;V03:K0:mVp+m6YWQVo=:0SNnI+n3n0XQJu4myjt0EK
 1QZIOXuRZPiVpDKQQyTTBW4gHKQudcEuHRmDoUzkWHSRL81T+OXrTIFT/iNzhUO7k/C5On7b6
 nPxkdyo1uqvx3j0AXa8g4wElKafKDjX6rhcKXvMq6AFv0OQH1ybJSgHWoW+e3WcM4GyuJnfcc
 +e2OqLnulCHIBRMSkhbaP0/MBOEXLK1NisSh7TGJ7z97yy01gUxIjrEQuVuvmamDNCJnl0XU+
 nfkReh/fDIE0E4yAzUMCnE8r6IoXYLmtv5K72rxFwHuOcgwvveulNQORv6mG4tR8FmxmL3zdf
 MXlmdUC/xVeLyaDzj79VS/7WKs7CAcG08S37DcL2GB6r9oW1ofTrdjvT17vJ6FXMXXxcdgBx4
 SuCTetLOMucGe6KSklCWAo73AloeQE5YMHIcwcJStX+Lmfw0khqJbDC04ymSH6r3R4cdP6/bu
 WtAjaL3JWMqxvRDoesrzZYOTBOwGXD5egL7QCf8+FvD6IOnahkQ/0FoghF6ynJmVxk0hN7n9B
 YxG96nXyp9UsInRCAUIQkn2WGi2sD36QuDlr0EOoKWz0g/ToNFWsSFOrKbRp12IcG3MAW/owh
 2vX//UGEOy1lPq8UoRR3DDdCJU30VHp8Xc999nCRHs7+pscJowyqY+3Sumbe++0sekr5Xsta4
 NLD7Ca5AWYcndS88HEn9CFr/OHSKagRM1gcaMv6RkK5cJ9QW+7cVWzFnpOTOHbW1UamW8LkQu
 wO4/PGRavRvYDAn51SnuSPOD3A0qbG75q/kqsrGn7me+InPukIzZITyDADQIbazHWPqUT2jMQ
 pVcxyA6ebkuj+4YoGmC3yeY7tyapKx64pGMvNwHT7erQFL+SLYwN3KDIDFq9CeSwST+q9LHiE
 /OyTMDDoE2e55AtqAW3h8cbO/8qdmdTwYgYMzzD/8eoNmGT5eLpHhDzny5wjM4+IsIYKuzI3m
 VeCw/JNcM3CLob2AD7RqBm7dokGk6Jj33N0KwO2PCIUctrk1QYdys/ha+yCZV5VkT1xbddprw
 Z5w3xqf7o1rwdl+jnddm4QKdHx7Ibpf6PyifaCnCx2z1MFRg1wyIc8TQnSPOyAsKZ+1F5maxy
 3ZnudH7VOsk4vXAS6cUS/UM/sGpgJC1DGkHw2ct+ybLKWCcr0Nl+U1rQDH54lD2EY+v/YAnN4
 khxRgV7/C1aQjNxqhVGWBVYD3mSugZstLph01a/10346CIwb6U5Bf2waOIqsH7bCRpT5Fz+B1
 al9LJEyj/k8Cu+6UD
To:     unlisted-recipients:; (no To-header on input)
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

Remove additional code for FreeBSD in aic7xxx_core.c, which is unneeded
since commit cca6cb8ad7a8 ("scsi: aic7xxx: Fix build using bare-metal
toolchain").

Suggested-by: Martin Petersen <martin.petersen@oracle.com>
Signed-off-by: Alex Dewar <alex.dewar@gmx.co.uk>
=2D--
 drivers/scsi/aic7xxx/aic7xxx_core.c | 23 -----------------------
 1 file changed, 23 deletions(-)

diff --git a/drivers/scsi/aic7xxx/aic7xxx_core.c b/drivers/scsi/aic7xxx/ai=
c7xxx_core.c
index 4190a025381a..84fc499cb1e6 100644
=2D-- a/drivers/scsi/aic7xxx/aic7xxx_core.c
+++ b/drivers/scsi/aic7xxx/aic7xxx_core.c
@@ -1834,21 +1834,6 @@ ahc_handle_scsiint(struct ahc_softc *ahc, u_int int=
stat)
 				printerror =3D 0;
 			} else if (ahc_sent_msg(ahc, AHCMSG_1B,
 						MSG_BUS_DEV_RESET, TRUE)) {
-#ifdef __FreeBSD__
-				/*
-				 * Don't mark the user's request for this BDR
-				 * as completing with CAM_BDR_SENT.  CAM3
-				 * specifies CAM_REQ_CMP.
-				 */
-				if (scb !=3D NULL
-				 && scb->io_ctx->ccb_h.func_code=3D=3D XPT_RESET_DEV
-				 && ahc_match_scb(ahc, scb, target, channel,
-						  CAM_LUN_WILDCARD,
-						  SCB_LIST_NULL,
-						  ROLE_INITIATOR)) {
-					ahc_set_transaction_status(scb, CAM_REQ_CMP);
-				}
-#endif
 				ahc_compile_devinfo(&devinfo,
 						    initiator_role_id,
 						    target,
@@ -4399,22 +4384,16 @@ ahc_alloc(void *platform_arg, char *name)
 	struct  ahc_softc *ahc;
 	int	i;

-#ifndef	__FreeBSD__
 	ahc =3D kmalloc(sizeof(*ahc), GFP_ATOMIC);
 	if (!ahc) {
 		printk("aic7xxx: cannot malloc softc!\n");
 		kfree(name);
 		return NULL;
 	}
-#else
-	ahc =3D device_get_softc((device_t)platform_arg);
-#endif
 	memset(ahc, 0, sizeof(*ahc));
 	ahc->seep_config =3D kmalloc(sizeof(*ahc->seep_config), GFP_ATOMIC);
 	if (ahc->seep_config =3D=3D NULL) {
-#ifndef	__FreeBSD__
 		kfree(ahc);
-#endif
 		kfree(name);
 		return (NULL);
 	}
@@ -4540,9 +4519,7 @@ ahc_free(struct ahc_softc *ahc)
 		kfree(ahc->name);
 	if (ahc->seep_config !=3D NULL)
 		kfree(ahc->seep_config);
-#ifndef __FreeBSD__
 	kfree(ahc);
-#endif
 	return;
 }

=2D-
2.26.0

