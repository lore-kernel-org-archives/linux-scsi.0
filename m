Return-Path: <linux-scsi-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E025CC46467
	for <linux-scsi@archiver.kernel.org>; Mon, 16 Jan 2023 13:38:14 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231216AbjAPNiO (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Mon, 16 Jan 2023 08:38:14 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54300 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231194AbjAPNiL (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Mon, 16 Jan 2023 08:38:11 -0500
X-Greylist: delayed 384 seconds by postgrey-1.37 at lindbergh.monkeyblade.net; Mon, 16 Jan 2023 05:38:09 PST
Received: from air.basealt.ru (air.basealt.ru [194.107.17.39])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C80571A4B1
        for <linux-scsi@vger.kernel.org>; Mon, 16 Jan 2023 05:38:09 -0800 (PST)
Received: by air.basealt.ru (Postfix, from userid 490)
        id BED632F2022D; Mon, 16 Jan 2023 13:31:43 +0000 (UTC)
Received: from localhost (broadband-188-32-10-232.ip.moscow.rt.ru [188.32.10.232])
        by air.basealt.ru (Postfix) with ESMTPSA id 16BE12F2022E;
        Mon, 16 Jan 2023 13:31:41 +0000 (UTC)
Date:   Mon, 16 Jan 2023 16:31:40 +0300
From:   "Alexey V. Vissarionov" <gremlin@altlinux.org>
To:     Don Brace <don.brace@microchip.com>
Cc:     "James E.J. Bottomley" <jejb@linux.ibm.com>,
        James Bottomley <JBottomley@parallels.com>,
        "Martin K. Petersen" <martin.petersen@oracle.com>,
        "Stephen M. Cameron" <scameron@beardog.cce.hp.com>,
        storagedev@microchip.com, linux-scsi@vger.kernel.org,
        lvc-project@linuxtesting.org, gremlin@altlinux.org
Subject: [PATCH] scsi: hpsa: fix allocation size for scsi_host_alloc()
Message-ID: <20230116133140.GB8107@altlinux.org>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha512;
        protocol="application/pgp-signature"; boundary="PmA2V3Z32TCmWXqI"
Content-Disposition: inline
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org


--PmA2V3Z32TCmWXqI
Content-Type: text/plain; charset=koi8-r
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

The 'h' is a pointer to struct ctlr_info, so it's just 4 or 8
bytes, while the structure itself is much bigger.

Found by Linux Verification Center (linuxtesting.org) with SVACE.

Fixes: b705690d8d16f708 ("[SCSI] hpsa: combine hpsa_scsi_detect and hpsa_re=
gister_scsi")
Signed-off-by: Alexey V. Vissarionov <gremlin@altlinux.org>

diff --git a/drivers/scsi/hpsa.c b/drivers/scsi/hpsa.c
index 4dbf51e2623ad543..f6da34850af9dd46 100644
--- a/drivers/scsi/hpsa.c
+++ b/drivers/scsi/hpsa.c
@@ -5850,7 +5850,7 @@ static int hpsa_scsi_host_alloc(struct ctlr_info *h)
 {
 	struct Scsi_Host *sh;
=20
-	sh =3D scsi_host_alloc(&hpsa_driver_template, sizeof(h));
+	sh =3D scsi_host_alloc(&hpsa_driver_template, sizeof(struct ctlr_info));
 	if (sh =3D=3D NULL) {
 		dev_err(&h->pdev->dev, "scsi_host_alloc failed\n");
 		return -ENOMEM;


--=20
Alexey V. Vissarionov
gremlin =F0=F2=E9 altlinux =F4=FE=EB org; +vii-cmiii-ccxxix-lxxix-xlii
GPG: 0D92F19E1C0DC36E27F61A29CD17E2B43D879005 @ hkp://keys.gnupg.net

--PmA2V3Z32TCmWXqI
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQIcBAEBCgAGBQJjxVG8AAoJEFv2F9znRj5KLF8P/0ureOLmo2M7KtLbUtJOTEsh
a0JuFf6hA1CLa0w2Yinj6JQdskBpTtFYEoNQouSvor50PuKyWXiwqNrwRZ2ghwWh
tupS/vo5FATutuPgCGthaf1lD6YYiYZd0KYKxIbf7Wf9/CGtlpA0Rd4ldGOhvjgH
HoCfppM98lhakaCLeVSQTfv+5vAK8W89LpBjPdjWTxFsVLMkBOVWaZwrL0DU8GEC
MJE/KPAHoea0Ie/fdxc/SAym7ClfVvCnaEsb2grInHgYHI/NiIwyCEGwFI2hEYYw
a36MfQtrVd8swgy3RCOEhdnmERfRRWDFl779e4oZ+aHvNZsTbwsRIFzPtznIlj2X
rOD5CXMEJFyEpzZY3EG8jGEq3V6LRKyXlN+9wZj4uwtgSab+6PCzMnORymJhDouE
xn6HJnx5rAfMLO1y6IYwFU1ZQLiEy9bdzmKlnfnPkFDq6iR2UV5WHWxPZ3KrEMye
6Lq/EfO8wbYr5dKAxIuyo+j+vQ0aiswr1xsEt97NasVClD7piZ7jYHsPeiCvXYmF
LP5AWUcD/aAXX/H3bIXm24H6dWg92sdN8iFs0IK7gsAFVVwwWAuiTilinr843d4l
4iOdDh1PWc3zSFX+cjYhVmQLhthfK2HfXfRYJAXeZN/fnK1VnIZiddiQKWuJo10J
xal3nYUbq0H7YOEQyXoJ
=1reu
-----END PGP SIGNATURE-----

--PmA2V3Z32TCmWXqI--
