Return-Path: <SRS0=4YdN=D5=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.5 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=unavailable autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 57E6FC388F2
	for <linux-scsi@archiver.kernel.org>; Thu, 22 Oct 2020 09:00:22 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id D53AF21775
	for <linux-scsi@archiver.kernel.org>; Thu, 22 Oct 2020 09:00:21 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=gmx.net header.i=@gmx.net header.b="dHaNfa5S"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2509172AbgJVJAU (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Thu, 22 Oct 2020 05:00:20 -0400
Received: from mout.gmx.net ([212.227.17.20]:57411 "EHLO mout.gmx.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2438092AbgJVJAU (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
        Thu, 22 Oct 2020 05:00:20 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=gmx.net;
        s=badeba3b8450; t=1603357209;
        bh=XsMIsfv73jp2VtudzQOahStXJllvYSuk50TIG/4B3hI=;
        h=X-UI-Sender-Class:Date:From:To:Cc:Subject;
        b=dHaNfa5Sl81aCoWioehKqUHGeOxrNNAGY2axGVSr3D5cKHRK18dVlw3ekcUny+K7A
         LnmdSBOTenCENzfbBselLSyN7rL6QawXoYQL0SR4GS3AgE9HJFM45GnxQSFzUxFS29
         noyIcSEiJean+UFKNDR2DY+OJi0rSjRiNu0Le6/k=
X-UI-Sender-Class: 01bb95c1-4bf8-414a-932a-4f6e2808ef9c
Received: from ls3530.fritz.box ([92.116.134.214]) by mail.gmx.com (mrgmx105
 [212.227.17.168]) with ESMTPSA (Nemesis) id 1N2mFY-1kQ7ev1c5c-0132kH; Thu, 22
 Oct 2020 11:00:09 +0200
Date:   Thu, 22 Oct 2020 11:00:05 +0200
From:   Helge Deller <deller@gmx.de>
To:     Sathya Prakash <sathya.prakash@broadcom.com>,
        Sreekanth Reddy <sreekanth.reddy@broadcom.com>,
        Suganath Prabu Subramani 
        <suganath-prabu.subramani@broadcom.com>,
        MPT-FusionLinux.pdl@broadcom.com, linux-scsi@vger.kernel.org,
        linux-kernel@vger.kernel.org
Cc:     linux-parisc@vger.kernel.org,
        James Bottomley <James.Bottomley@hansenpartnership.com>
Subject: [PATCH] scsi: mptfusion: Fix null pointer dereferences in
 mptscsih_remove()
Message-ID: <20201022090005.GA9000@ls3530.fritz.box>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
X-Provags-ID: V03:K1:SYKXNjRyYP+ihkolsMwKc+AEwJmHzKc4SEdOSjrbKDfQkLUFS6D
 VFfU/BCUR8AdvAbFUA4bqeflI29smpv9b9YGA3XGFr9ki2kSxGtiBHY3Z4WC0PnP0nKLGhg
 bslhgztdi/sU2uUGoGQ8m3YmkSkWjLt4IfNx8g6UOYaS+Wc40o44JbP/CMZmIQg/2reE70r
 iDILYlmX5QVAKE8xEYKpw==
X-UI-Out-Filterresults: notjunk:1;V03:K0:/AbSNMgCKKw=:adbcFUZEXwobSbEB8Mya4p
 5XRIOheOUwKAO5XyjfJ5hlVdMpatdzaq0xKzNkfhNkOyJUOZ64Ux2uRIM5teQVXrFBHaHwiua
 JcNbw1s5qd8VJn4iskYy8rNQ9VAbLOt3dkbpbJpnp9N98hwIVFDGK3Fw3LEMCex1q4r/J1obI
 R0/eB3/Z1LOR6wn2cYaZPwcuxnvU3CiE0HQlOfhLL9cXu2xaS9J3bWAdkat/XRptxn8K5YqUQ
 LgpyyNflkQ/Ao4/XV9t06zqKBsP1ywIZgujKpYXNT33JTGGynitkcBOHCQL7sXSafFMfQSh+g
 wM/VnMKm7rswktxF3OZLQ68We8sxYh8Hf+9VKC5SdzXh68weTVoqwhA+iNv0HW8Ivk5qUlHCs
 D65ISUbHiagqHfRvJ8xsrBOk6OxUGHFipMxoVX1iGSgpw5pVfHzEyH2T3E/e+/2azB6UBuMuO
 PCm2jNzDrQRK23Pfg7mS8jrbOaikTEfnrVtt+jK7G+3Od3VJJBcKU2k8gNKS43Lrve35Qe2Pi
 lRMhGcia9mli0LJ8TgtfpfqO10KZ0ubCWxVp7k2JcHVRRcAHjcZkakOa3iZhYbPeH4DE6KGgz
 A2libZfzu9PQEjvX6yJ7/RyU4cQG+/oj5DpRwWxGNXxkMBKJ9ePYQ2NtDzb/GSHhL1AvrIU6A
 pJfb8zjsq/OzBwaMEL5VK3CLdwVxjRBEyl66wNT3hzICYE5kbhqa+TkQ5Xmvs+q6+Lb7ifW4b
 rZRMBgnooLuume6YlpA9QfoHD+6YJYiIADlyabduQzL1d1ml5PRImVi7tNgACBNWbEcCXzJht
 1S4ls6yLisWUHE/oKK1PrC3xlWKr3Uvoisttn7q1/z6gY1w1r+vjBsobw9srEwYNHlCiBNn0U
 x0A1x7DVY+2UT5N8MIUg==
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

The mptscsih_remove() function triggers a kernel oops if the
Scsi_Host pointer (ioc->sh) is NULL, as can be seen in this syslog:

 ioc0: LSI53C1030 B2: Capabilities=3D{Initiator,Target}
 Begin: Waiting for root file system ...
 scsi host2: error handler thread failed to spawn, error =3D -4
 mptspi: ioc0: WARNING - Unable to register controller with SCSI subsystem
 Backtrace:
  [<000000001045b7cc>] mptspi_probe+0x248/0x3d0 [mptspi]
  [<0000000040946470>] pci_device_probe+0x1ac/0x2d8
  [<0000000040add668>] really_probe+0x1bc/0x988
  [<0000000040ade704>] driver_probe_device+0x160/0x218
  [<0000000040adee24>] device_driver_attach+0x160/0x188
  [<0000000040adef90>] __driver_attach+0x144/0x320
  [<0000000040ad7c78>] bus_for_each_dev+0xd4/0x158
  [<0000000040adc138>] driver_attach+0x4c/0x80
  [<0000000040adb3ec>] bus_add_driver+0x3e0/0x498
  [<0000000040ae0130>] driver_register+0xf4/0x298
  [<00000000409450c4>] __pci_register_driver+0x78/0xa8
  [<000000000007d248>] mptspi_init+0x18c/0x1c4 [mptspi]

This patch adds the necessary NULL-pointer checks.
Successfully tested on a HP C8000 parisc workstation with buggy SCSI drive=
s.

Signed-off-by: Helge Deller <deller@gmx.de>
Cc: <stable@vger.kernel.org>

diff --git a/drivers/message/fusion/mptscsih.c b/drivers/message/fusion/mp=
tscsih.c
index 8543f0324d5a..0d1b2b0eb843 100644
=2D-- a/drivers/message/fusion/mptscsih.c
+++ b/drivers/message/fusion/mptscsih.c
@@ -1176,8 +1176,10 @@ mptscsih_remove(struct pci_dev *pdev)
 	MPT_SCSI_HOST		*hd;
 	int sz1;

-	if((hd =3D shost_priv(host)) =3D=3D NULL)
-		return;
+	if (host =3D=3D NULL)
+		hd =3D NULL;
+	else
+		hd =3D shost_priv(host);

 	mptscsih_shutdown(pdev);

@@ -1193,14 +1195,15 @@ mptscsih_remove(struct pci_dev *pdev)
 	    "Free'd ScsiLookup (%d) memory\n",
 	    ioc->name, sz1));

-	kfree(hd->info_kbuf);
+	if (hd)
+		kfree(hd->info_kbuf);

 	/* NULL the Scsi_Host pointer
 	 */
 	ioc->sh =3D NULL;

-	scsi_host_put(host);
-
+	if (host)
+		scsi_host_put(host);
 	mpt_detach(pdev);

 }
