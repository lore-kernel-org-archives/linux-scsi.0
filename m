From: "jack wang" <jack_wang@usish.com>
Subject: [PATCH 7/9] pm8001: do not reset local sata as it will not be found if reset
Date: Mon, 7 Dec 2009 17:23:05 +0800
Message-ID: <6DF97E1CA0594E098E868D2C554CA49E@usish.com.cn>
Mime-Version: 1.0
Content-Type: multipart/mixed;
	boundary="----=_NextPart_000_0029_01CA7761.EFC61670"
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from sr-smtp.usish.com ([210.5.144.203]:46709 "EHLO
	sr-smtp.usish.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759269AbZLGJXB (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Mon, 7 Dec 2009 04:23:01 -0500
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James.Bottomley@suse.de
Cc: linux-scsi@vger.kernel.org, 'Lindar Liu' <lindar_liu@usish.com>, 'Kevin Ao' <aoqingyun@usish.com>, 'jack wang' <jack_wang@usish.com>

This is a multi-part message in MIME format.

------=_NextPart_000_0029_01CA7761.EFC61670
Content-Type: text/plain;
	charset="US-ASCII"
Content-Transfer-Encoding: 7bit

Do not reset local sata as it will not be found if it was reseted.

Signed-off-by: Jack Wang <jack_wang@usish.com>
---
 drivers/scsi/pm8001/pm8001_sas.c |    2 ++
 1 files changed, 2 insertions(+), 0 deletions(-)

diff --git a/drivers/scsi/pm8001/pm8001_sas.c
b/drivers/scsi/pm8001/pm8001_sas.c
index c86f921..e3d4f38 100644
--- a/drivers/scsi/pm8001/pm8001_sas.c
+++ b/drivers/scsi/pm8001/pm8001_sas.c
@@ -944,6 +944,8 @@ int pm8001_I_T_nexus_reset(struct domain_device *dev)
 
 	if (dev_is_sata(dev)) {
 		DECLARE_COMPLETION_ONSTACK(completion_setstate);
+		if (scsi_is_sas_phy_local(phy))
+			return 0;
 		rc = sas_phy_reset(phy, 1);
 		msleep(2000);
 		rc = pm8001_exec_internal_task_abort(pm8001_ha, pm8001_dev ,
-- 
1.6.5.1.1367.gcd48


------=_NextPart_000_0029_01CA7761.EFC61670
Content-Type: application/octet-stream;
	name="0007-do-not-reset-local-sata-disk-as-it-will-not-be-found.patch"
Content-Transfer-Encoding: quoted-printable
Content-Disposition: attachment;
	filename="0007-do-not-reset-local-sata-disk-as-it-will-not-be-found.patch"

>From c9c55902cbe36f3db28b1d5f93dcfcd81b506699 Mon Sep 17 00:00:00 2001=0A=
From: Jack Wang <jack_wang@usish.com>=0A=
Date: Mon, 7 Dec 2009 15:50:57 +0800=0A=
Subject: [PATCH 7/9] do not reset local sata disk as it will not be =
found if it was reseted=0A=
=0A=
Signed-off-by: Jack Wang <jack_wang@usish.com>=0A=
---=0A=
 drivers/scsi/pm8001/pm8001_sas.c |    2 ++=0A=
 1 files changed, 2 insertions(+), 0 deletions(-)=0A=
=0A=
diff --git a/drivers/scsi/pm8001/pm8001_sas.c =
b/drivers/scsi/pm8001/pm8001_sas.c=0A=
index c86f921..e3d4f38 100644=0A=
--- a/drivers/scsi/pm8001/pm8001_sas.c=0A=
+++ b/drivers/scsi/pm8001/pm8001_sas.c=0A=
@@ -944,6 +944,8 @@ int pm8001_I_T_nexus_reset(struct domain_device *dev)=0A=
 =0A=
 	if (dev_is_sata(dev)) {=0A=
 		DECLARE_COMPLETION_ONSTACK(completion_setstate);=0A=
+		if (scsi_is_sas_phy_local(phy))=0A=
+			return 0;=0A=
 		rc =3D sas_phy_reset(phy, 1);=0A=
 		msleep(2000);=0A=
 		rc =3D pm8001_exec_internal_task_abort(pm8001_ha, pm8001_dev ,=0A=
-- =0A=
1.6.5.1.1367.gcd48=0A=
=0A=

------=_NextPart_000_0029_01CA7761.EFC61670--

