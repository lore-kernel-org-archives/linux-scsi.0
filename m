From: "Jack Wang" <jack_wang@usish.com>
Subject: [PATCH v3] libsas: fix bug for vacant phy
Date: Wed, 6 Oct 2010 16:05:35 +0800
Message-ID: <CD6A000CF99C4DF2AEAF5EDC2F2E362E@usish.com.cn>
Mime-Version: 1.0
Content-Type: multipart/mixed;
	boundary="----=_NextPart_000_0000_01CB6570.5737D350"
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from sr-smtp.usish.com ([210.5.144.203]:54812 "EHLO
	sr-smtp.usish.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755290Ab0JFICV (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Wed, 6 Oct 2010 04:02:21 -0400
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: 'James Bottomley' <jejb@kernel.org>, james.bottomley@suse.de
Cc: linux-scsi@vger.kernel.org, 'lindar_liu' <lindar_liu@usish.com>, 'roy' <roy_wang@usish.com>, 'Chuck Tuffli' <Chuck_Tuffli@pmc-sierra.com>, 'Hannes Reinecke' <hare@suse.de>

This is a multi-part message in MIME format.

------=_NextPart_000_0000_01CB6570.5737D350
Content-Type: text/plain;
	charset="utf-8"
Content-Transfer-Encoding: quoted-printable

Hi=EF=BC=8C James

This patch fix bug reported by Chuck. And this new version incorporate =
comments
from Hannes. Please consider to include it into mainline.=09

Jack.                                                        =20
From: Jack Wang <jack_wang@usish.com>
Date: Wed, 15 Sep 2010 16:43:03 +0800
Subject: [PATCH] fix bug for vacant phy

Signed-off-by: Jack Wang <jack_wang@usish.com>
Signed-off-by: Lindar Liu <lindar_liu@usish.com>
Tested-by: Chuck Tuffli <Chuck_Tuffli@pmc-sierra.com>

---
 sas_expander.c |    9 ++++++---
 1 files changed, 6 insertions(+), 3 deletions(-)

diff --git a/sas_expander.c b/sas_expander.c
index d1d86a6..f282234 100644
--- a/sas_expander.c
+++ b/sas_expander.c
@@ -175,10 +175,10 @@ static void sas_set_ex_phy(struct domain_device =
*dev, int phy_id,
 	switch (resp->result) {
 	case SMP_RESP_PHY_VACANT:
 		phy->phy_state =3D PHY_VACANT;
-		return;
+		break;
 	default:
 		phy->phy_state =3D PHY_NOT_PRESENT;
-		return;
+		break;
 	case SMP_RESP_FUNC_ACC:
 		phy->phy_state =3D PHY_EMPTY; /* do not know yet */
 		break;
@@ -209,7 +209,10 @@ static void sas_set_ex_phy(struct domain_device =
*dev, int phy_id,
 	phy->phy->negotiated_linkrate =3D phy->linkrate;
=20
 	if (!rediscover)
-		sas_phy_add(phy->phy);
+		if (sas_phy_add(phy->phy)) {
+			sas_phy_free(phy->phy);
+			return;
+		}
=20
 	SAS_DPRINTK("ex %016llx phy%02d:%c attached: %016llx\n",
 		    SAS_ADDR(dev->sas_addr), phy->phy_id,
--=20
1.7.2.3.msysgit.0

------=_NextPart_000_0000_01CB6570.5737D350
Content-Type: application/octet-stream;
	name="0001-fix-bug-for-vacant-phy.patch"
Content-Transfer-Encoding: quoted-printable
Content-Disposition: attachment;
	filename="0001-fix-bug-for-vacant-phy.patch"

>From 57f6f219f378624628d2c31090de934ad5a772eb Mon Sep 17 00:00:00 2001=0A=
From: Jack Wang <jack_wang@usish.com>=0A=
Date: Wed, 15 Sep 2010 16:43:03 +0800=0A=
Subject: [PATCH] fix bug for vacant phy=0A=
=0A=
Signed-off-by: Jack Wang <jack_wang@usish.com>=0A=
Signed-off-by: Lindar Liu <lindar_liu@usish.com>=0A=
Tested-by: Chuck Tuffli <Chuck_Tuffli@pmc-sierra.com>=0A=
=0A=
---=0A=
 sas_expander.c |    9 ++++++---=0A=
 1 files changed, 6 insertions(+), 3 deletions(-)=0A=
=0A=
diff --git a/sas_expander.c b/sas_expander.c=0A=
index d1d86a6..f282234 100644=0A=
--- a/sas_expander.c=0A=
+++ b/sas_expander.c=0A=
@@ -175,10 +175,10 @@ static void sas_set_ex_phy(struct domain_device =
*dev, int phy_id,=0A=
 	switch (resp->result) {=0A=
 	case SMP_RESP_PHY_VACANT:=0A=
 		phy->phy_state =3D PHY_VACANT;=0A=
-		return;=0A=
+		break;=0A=
 	default:=0A=
 		phy->phy_state =3D PHY_NOT_PRESENT;=0A=
-		return;=0A=
+		break;=0A=
 	case SMP_RESP_FUNC_ACC:=0A=
 		phy->phy_state =3D PHY_EMPTY; /* do not know yet */=0A=
 		break;=0A=
@@ -209,7 +209,10 @@ static void sas_set_ex_phy(struct domain_device =
*dev, int phy_id,=0A=
 	phy->phy->negotiated_linkrate =3D phy->linkrate;=0A=
 =0A=
 	if (!rediscover)=0A=
-		sas_phy_add(phy->phy);=0A=
+		if (sas_phy_add(phy->phy)) {=0A=
+			sas_phy_free(phy->phy);=0A=
+			return;=0A=
+		}=0A=
 =0A=
 	SAS_DPRINTK("ex %016llx phy%02d:%c attached: %016llx\n",=0A=
 		    SAS_ADDR(dev->sas_addr), phy->phy_id,=0A=
-- =0A=
1.7.2.3.msysgit.0=0A=
=0A=

------=_NextPart_000_0000_01CB6570.5737D350--

