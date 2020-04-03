Return-Path: <SRS0=YASp=5T=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.8 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT autolearn=unavailable
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id BDC19C2BA15
	for <linux-scsi@archiver.kernel.org>; Fri,  3 Apr 2020 16:38:49 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 92FCB206F8
	for <linux-scsi@archiver.kernel.org>; Fri,  3 Apr 2020 16:38:49 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=gmx.net header.i=@gmx.net header.b="dOImOGuo"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728381AbgDCQiq (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Fri, 3 Apr 2020 12:38:46 -0400
Received: from mout.gmx.net ([212.227.15.18]:35189 "EHLO mout.gmx.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728337AbgDCQiq (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
        Fri, 3 Apr 2020 12:38:46 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=gmx.net;
        s=badeba3b8450; t=1585931790;
        bh=E98VMExRB5iPNCFhVMy63LXkoHnjMzBitrH5WXG7qiM=;
        h=X-UI-Sender-Class:From:To:Cc:Subject:Date;
        b=dOImOGuozI8DMcj7GtfGcJ+2x3A02rIMtx66rq0AVmXN7E4q7CI/da7CkeWOTKWum
         IycbGLyWDsRfecjtP1NLyNzrqfNeeoMqQRrzmNqHx+QgXw5fwKZt2L5sbN7VItYE1V
         XWz13lrkuz9UmUFYTqce0CgpC7APcPwy3VaVQJy8=
X-UI-Sender-Class: 01bb95c1-4bf8-414a-932a-4f6e2808ef9c
Received: from localhost.localdomain ([82.19.195.159]) by mail.gmx.com
 (mrgmx005 [212.227.17.184]) with ESMTPSA (Nemesis) id
 1MowKi-1iz57o1gsA-00qRcY; Fri, 03 Apr 2020 18:36:30 +0200
From:   Alex Dewar <alex.dewar@gmx.co.uk>
To:     alex.dewar@gmx.co.uk
Cc:     Hannes Reinecke <hare@suse.com>,
        "James E.J. Bottomley" <jejb@linux.ibm.com>,
        "Martin K. Petersen" <martin.petersen@oracle.com>,
        linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH] scsi: aic7xxx: Use kzalloc() instead of kmalloc()+memset()
Date:   Fri,  3 Apr 2020 17:36:10 +0100
Message-Id: <20200403163611.46756-1-alex.dewar@gmx.co.uk>
X-Mailer: git-send-email 2.26.0
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Provags-ID: V03:K1:fS9C2WUq6W0A/oQG43z3dHsTrS5lIbhUpgQbXvGZQ/vrI87kJb+
 Fdbs4xZkNzfKzc9fcfh9QJa86SXvrj2f2gsHnDtyPcIdsEkzKAIfzVj63JcKL6XrCx551MV
 uhg2dQ32m10T5TByu8cWyWyJwfBI8H6HYI8yUc8zhZ9G4BdPiipDJm3vVRUKlR4LsrVK8T0
 +hP/W1B7p8JaaUTzOCseg==
X-UI-Out-Filterresults: notjunk:1;V03:K0:sDaxh1hmY2Q=:mMPhVPCYFTWiYQV81XN19Z
 r+E9A2Wi3YqJoLIa6dZAwSHRMmBR7ja8qLFTL3eiwl03AcMj20Z00pllIz7kXqAPa1YxnhaTj
 Jif44E1Ua43OynP2NUymyzSoPcE/N0OKuhkpI2kVYn2JvlifA5RogLYIWz07alohAxXx+rq9I
 ukvmuV+JjS3J7qSU3hWehV6sGIa48qOoFNz0zx+eoxJBeS0WjhUcsHTe8SdeUBYLrP4VzPEAo
 YISb5mqEyqIMLS2Cf6Ps42HXQulX/HdC1LsfTs+FKF4oQZ03Kq6qU0hs1KN+ZA/d3c6YPWQ28
 d8fM2cFSziPbJhz6qzHwKf+Mzm7xZ9t0S5FpUbSXMi1kIN2J8QATlZ+NV1fEbNlk88cBhIfkm
 8pj+XFRkaxI4D2TCwyOz0eKj4f75udBO6nam23LAOn5JxBHHG+EzgTDMPP7O9/AHBGlZwmI7f
 g3l4u42r/TdXdOk1XYo6xlCz1FuiF7ABhwK5RiuoRzmaJAKo7KPszXe8G6lhl4VRu9zyC0w94
 mI4Xa7gEwopzA9Pjy7FXc49gGq/ayNZ2qms+LuW/C5yslKqRwJeyiovV/+VgV9MXSxOD83gWj
 +ixfacN00iqSK1dodIzEQ7K6oTyq0eghQZTxWXbU2+8l3bv3pWr7sx6wv81CL2BHc460nXiqY
 XF0w2r/6I7FtR0RCvZ3MMXrBhj27x6AguVTNvG0spFbZL8bnabrC1QW8Fut0h00BOOWuU2peM
 xaGLFweLKhU5nZNhh8elyCeFElw6laK7HhO3ZkLqQ+PD2GAZtF/MBCUJYkxBtWXW47lgLnb/7
 8hr0H+Mge/jN/qz69FKGri6fdExkdt8plOsG7MOGgRsKWZQVkTBMNZt79LxGdlFQzRrJDCOBL
 yMk0Z3pGDS8Fs7tPWY+9asCEGGD8Zd2j7yVC/Uu2X7l6Uaji41b68eAOeXdj8Pn1QhECEypMu
 LH0IRiwMoBS+OWMynA7jyRZsuKvTwf0E0Lhg1UW1LiN95nwOFOAe6h/YZWkTYmF5u4pUnM1l7
 TtRQpd48VL/BoGfvj0NhKJ5954hwkNLPj0G2Yj6efT5qVLN7h+5/z/aSM4uMoRvGuTZ16Y2Iz
 8xv7dY3XoIL9kjqWxV1v+CIRlxJqRF7Y0hyymNZSXFUreoMYyVUZ1qKuq/HST76gIbR+WzjFs
 2/YDUXDkRposv74bOG3vr8d3/8NsqFAtsFDqWsoSp3I/qLWwPgyYroqWQM5LQeLwffvY0nBQr
 fOSiBQolfKVH0t1mD
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

There are a couple of places where kzalloc() could be used directly
instead of calling kmalloc() then memset(). Replace them.

Signed-off-by: Alex Dewar <alex.dewar@gmx.co.uk>
=2D--
 drivers/scsi/aic7xxx/aic79xx_core.c | 3 +--
 drivers/scsi/aic7xxx/aic7xxx_core.c | 4 ++--
 2 files changed, 3 insertions(+), 4 deletions(-)

diff --git a/drivers/scsi/aic7xxx/aic79xx_core.c b/drivers/scsi/aic7xxx/ai=
c79xx_core.c
index a336a458c978..c38163707259 100644
=2D-- a/drivers/scsi/aic7xxx/aic79xx_core.c
+++ b/drivers/scsi/aic7xxx/aic79xx_core.c
@@ -6054,14 +6054,13 @@ ahd_alloc(void *platform_arg, char *name)
 {
 	struct  ahd_softc *ahd;

-	ahd =3D kmalloc(sizeof(*ahd), GFP_ATOMIC);
+	ahd =3D kzalloc(sizeof(*ahd), GFP_ATOMIC);
 	if (!ahd) {
 		printk("aic7xxx: cannot malloc softc!\n");
 		kfree(name);
 		return NULL;
 	}

-	memset(ahd, 0, sizeof(*ahd));
 	ahd->seep_config =3D kmalloc(sizeof(*ahd->seep_config), GFP_ATOMIC);
 	if (ahd->seep_config =3D=3D NULL) {
 		kfree(ahd);
diff --git a/drivers/scsi/aic7xxx/aic7xxx_core.c b/drivers/scsi/aic7xxx/ai=
c7xxx_core.c
index 84fc499cb1e6..36a7ea1ba7da 100644
=2D-- a/drivers/scsi/aic7xxx/aic7xxx_core.c
+++ b/drivers/scsi/aic7xxx/aic7xxx_core.c
@@ -4384,13 +4384,13 @@ ahc_alloc(void *platform_arg, char *name)
 	struct  ahc_softc *ahc;
 	int	i;

-	ahc =3D kmalloc(sizeof(*ahc), GFP_ATOMIC);
+	ahc =3D kzalloc(sizeof(*ahc), GFP_ATOMIC);
 	if (!ahc) {
 		printk("aic7xxx: cannot malloc softc!\n");
 		kfree(name);
 		return NULL;
 	}
-	memset(ahc, 0, sizeof(*ahc));
+
 	ahc->seep_config =3D kmalloc(sizeof(*ahc->seep_config), GFP_ATOMIC);
 	if (ahc->seep_config =3D=3D NULL) {
 		kfree(ahc);
=2D-
2.26.0

