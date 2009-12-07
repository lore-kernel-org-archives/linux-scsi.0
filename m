From: "jack wang" <jack_wang@usish.com>
Subject: Re: [PATCH 5/9] pm8001:fix potential NULL pointer dereference
Date: Mon, 7 Dec 2009 17:46:27 +0800
Message-ID: <1068AB1D3AE946039D1324D03D7AE5CC@usish.com.cn>
References: <D81A6649F91A4CF89FC9254CE8FA7CF9@usish.com.cn>
Mime-Version: 1.0
Content-Type: multipart/mixed;
	boundary="----=_NextPart_000_005F_01CA7765.3364D990"
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from sr-smtp.usish.com ([210.5.144.203]:33545 "EHLO
	sr-smtp.usish.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759175AbZLGJqV (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Mon, 7 Dec 2009 04:46:21 -0500
In-Reply-To: <D81A6649F91A4CF89FC9254CE8FA7CF9@usish.com.cn>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: 'jack wang' <jack_wang@usish.com>, James.Bottomley@suse.de
Cc: linux-scsi@vger.kernel.org, 'Lindar Liu' <lindar_liu@usish.com>, 'Kevin Ao' <aoqingyun@usish.com>

This is a multi-part message in MIME format.

------=_NextPart_000_005F_01CA7765.3364D990
Content-Type: text/plain;
	charset="US-ASCII"
Content-Transfer-Encoding: 7bit

Patch attached, sorry for that.
Signed-off-by: Jack Wang <jack_wang@usish.com>
---
 drivers/scsi/pm8001/pm8001_sas.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/drivers/scsi/pm8001/pm8001_sas.c
b/drivers/scsi/pm8001/pm8001_sas.c
index 49721c8..487f78f 100644
--- a/drivers/scsi/pm8001/pm8001_sas.c
+++ b/drivers/scsi/pm8001/pm8001_sas.c
@@ -616,11 +616,11 @@ static int pm8001_dev_found_notify(struct
domain_device *dev)
 	spin_lock_irqsave(&pm8001_ha->lock, flags);
 
 	pm8001_device = pm8001_alloc_dev(pm8001_ha);
-	pm8001_device->sas_device = dev;
 	if (!pm8001_device) {
 		res = -1;
 		goto found_out;
 	}
+	pm8001_device->sas_device = dev;
 	dev->lldd_dev = pm8001_device;
 	pm8001_device->dev_type = dev->dev_type;
 	pm8001_device->dcompletion = &completion;
-- 
1.6.5.1.1367.gcd48


------=_NextPart_000_005F_01CA7765.3364D990
Content-Type: application/octet-stream;
	name="0005-fix-NULL-pointer-dereference.patch"
Content-Transfer-Encoding: quoted-printable
Content-Disposition: attachment;
	filename="0005-fix-NULL-pointer-dereference.patch"

>From 3c4f470e8065460d01c2e25c1e77416dfcce8a66 Mon Sep 17 00:00:00 2001=0A=
From: Jack Wang <jack_wang@usish.com>=0A=
Date: Mon, 7 Dec 2009 15:44:49 +0800=0A=
Subject: [PATCH 5/9] fix NULL pointer dereference=0A=
=0A=
Signed-off-by: Jack Wang <jack_wang@usish.com>=0A=
---=0A=
 drivers/scsi/pm8001/pm8001_sas.c |    2 +-=0A=
 1 files changed, 1 insertions(+), 1 deletions(-)=0A=
=0A=
diff --git a/drivers/scsi/pm8001/pm8001_sas.c =
b/drivers/scsi/pm8001/pm8001_sas.c=0A=
index 49721c8..487f78f 100644=0A=
--- a/drivers/scsi/pm8001/pm8001_sas.c=0A=
+++ b/drivers/scsi/pm8001/pm8001_sas.c=0A=
@@ -616,11 +616,11 @@ static int pm8001_dev_found_notify(struct =
domain_device *dev)=0A=
 	spin_lock_irqsave(&pm8001_ha->lock, flags);=0A=
 =0A=
 	pm8001_device =3D pm8001_alloc_dev(pm8001_ha);=0A=
-	pm8001_device->sas_device =3D dev;=0A=
 	if (!pm8001_device) {=0A=
 		res =3D -1;=0A=
 		goto found_out;=0A=
 	}=0A=
+	pm8001_device->sas_device =3D dev;=0A=
 	dev->lldd_dev =3D pm8001_device;=0A=
 	pm8001_device->dev_type =3D dev->dev_type;=0A=
 	pm8001_device->dcompletion =3D &completion;=0A=
-- =0A=
1.6.5.1.1367.gcd48=0A=
=0A=

------=_NextPart_000_005F_01CA7765.3364D990--

