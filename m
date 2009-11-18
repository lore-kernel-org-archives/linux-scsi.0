From: "jack wang" <jack_wang@usish.com>
Subject: [PATCH 5/5] pm8001: set SSC down-spreading only to get less errors on some 6G device.
Date: Wed, 18 Nov 2009 17:18:08 +0800
Message-ID: <D4CF37FAFD46434DA0A26997FA03DF07@usish.com.cn>
References: <20091118004345.GA10344@serverengines.com>
Mime-Version: 1.0
Content-Type: multipart/mixed;
	boundary="----=_NextPart_000_002A_01CA6873.195D67C0"
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from sr-smtp.usish.com ([210.5.144.203]:49403 "EHLO
	sr-smtp.usish.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756504AbZKRJSD (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Wed, 18 Nov 2009 04:18:03 -0500
In-Reply-To: <20091118004345.GA10344@serverengines.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James.Bottomley@suse.de
Cc: linux-scsi@vger.kernel.org, 'Lindar Liu' <lindar_liu@usish.com>, 'Kevin Ao' <aoqingyun@usish.com>, 'jack wang' <jack_wang@usish.com>

This is a multi-part message in MIME format.

------=_NextPart_000_002A_01CA6873.195D67C0
Content-Type: text/plain;
	charset="us-ascii"
Content-Transfer-Encoding: 7bit

Set SSC down-spreading only to get less error on some 6G device.

------=_NextPart_000_002A_01CA6873.195D67C0
Content-Type: application/octet-stream;
	name="0005-set-ssc-to-down-spreading-only.patch"
Content-Transfer-Encoding: quoted-printable
Content-Disposition: attachment;
	filename="0005-set-ssc-to-down-spreading-only.patch"

>From 083d1c5f98a36ffec6400084e727bac1c6bd864c Mon Sep 17 00:00:00 2001=0A=
From: Jack Wang <jack_wang@usish.com>=0A=
Date: Wed, 18 Nov 2009 16:36:39 +0800=0A=
Subject: [PATCH 5/5] set ssc to down-spreading only=0A=
=0A=
Signed-off-by: Jack Wang <jack_wang@usish.com>=0A=
---=0A=
 drivers/scsi/pm8001/pm8001_hwi.c |   65 =
++++++++++++-------------------------=0A=
 1 files changed, 21 insertions(+), 44 deletions(-)=0A=
=0A=
diff --git a/drivers/scsi/pm8001/pm8001_hwi.c =
b/drivers/scsi/pm8001/pm8001_hwi.c=0A=
index 83374dc..f8bddda 100644=0A=
--- a/drivers/scsi/pm8001/pm8001_hwi.c=0A=
+++ b/drivers/scsi/pm8001/pm8001_hwi.c=0A=
@@ -373,10 +373,7 @@ static int bar4_shift(struct pm8001_hba_info =
*pm8001_ha, u32 shiftValue)=0A=
 static void __devinit=0A=
 mpi_set_phys_g3_with_ssc(struct pm8001_hba_info *pm8001_ha, u32 SSCbit)=0A=
 {=0A=
-	u32 offset;=0A=
-	u32 value;=0A=
-	u32 i, j;=0A=
-	u32 bit_cnt;=0A=
+	u32 value, offset, i;=0A=
 =0A=
 #define SAS2_SETTINGS_LOCAL_PHY_0_3_SHIFT_ADDR 0x00030000=0A=
 #define SAS2_SETTINGS_LOCAL_PHY_4_7_SHIFT_ADDR 0x00040000=0A=
@@ -392,55 +389,35 @@ mpi_set_phys_g3_with_ssc(struct pm8001_hba_info =
*pm8001_ha, u32 SSCbit)=0A=
     */=0A=
 	if (-1 =3D=3D bar4_shift(pm8001_ha, =
SAS2_SETTINGS_LOCAL_PHY_0_3_SHIFT_ADDR))=0A=
 		return;=0A=
-	/* set SSC bit of PHY 0 - 3 */=0A=
+=0A=
 	for (i =3D 0; i < 4; i++) {=0A=
 		offset =3D SAS2_SETTINGS_LOCAL_PHY_0_3_OFFSET + 0x4000 * i;=0A=
-		value =3D pm8001_cr32(pm8001_ha, 2, offset);=0A=
-		if (SSCbit) {=0A=
-			value |=3D 0x00000001 << PHY_G3_WITH_SSC_BIT_SHIFT;=0A=
-			value &=3D ~(0x00000001 << PHY_G3_WITHOUT_SSC_BIT_SHIFT);=0A=
-		} else {=0A=
-			value |=3D 0x00000001 << PHY_G3_WITHOUT_SSC_BIT_SHIFT;=0A=
-			value &=3D ~(0x00000001 << PHY_G3_WITH_SSC_BIT_SHIFT);=0A=
-		}=0A=
-		bit_cnt =3D 0;=0A=
-		for (j =3D 0; j < 31; j++)=0A=
-			if ((value >> j) & 0x00000001)=0A=
-				bit_cnt++;=0A=
-		if (bit_cnt % 2)=0A=
-			value &=3D ~(0x00000001 << SNW3_PHY_CAPABILITIES_PARITY);=0A=
-		else=0A=
-			value |=3D 0x00000001 << SNW3_PHY_CAPABILITIES_PARITY;=0A=
-=0A=
-		pm8001_cw32(pm8001_ha, 2, offset, value);=0A=
+		pm8001_cw32(pm8001_ha, 2, offset, 0x80001501);=0A=
 	}=0A=
-=0A=
 	/* shift membase 3 for SAS2_SETTINGS_LOCAL_PHY 4 - 7 */=0A=
 	if (-1 =3D=3D bar4_shift(pm8001_ha, =
SAS2_SETTINGS_LOCAL_PHY_4_7_SHIFT_ADDR))=0A=
 		return;=0A=
-=0A=
-	/* set SSC bit of PHY 4 - 7 */=0A=
 	for (i =3D 4; i < 8; i++) {=0A=
 		offset =3D SAS2_SETTINGS_LOCAL_PHY_4_7_OFFSET + 0x4000 * (i-4);=0A=
-		value =3D pm8001_cr32(pm8001_ha, 2, offset);=0A=
-		if (SSCbit) {=0A=
-			value |=3D 0x00000001 << PHY_G3_WITH_SSC_BIT_SHIFT;=0A=
-			value &=3D ~(0x00000001 << PHY_G3_WITHOUT_SSC_BIT_SHIFT);=0A=
-		} else {=0A=
-			value |=3D 0x00000001 << PHY_G3_WITHOUT_SSC_BIT_SHIFT;=0A=
-			value &=3D ~(0x00000001 << PHY_G3_WITH_SSC_BIT_SHIFT);=0A=
-		}=0A=
-		bit_cnt =3D 0;=0A=
-		for (j =3D 0; j < 31; j++)=0A=
-			if ((value >> j) & 0x00000001)=0A=
-				bit_cnt++;=0A=
-		if (bit_cnt % 2)=0A=
-			value &=3D ~(0x00000001 << SNW3_PHY_CAPABILITIES_PARITY);=0A=
-		else=0A=
-			value |=3D 0x00000001 << SNW3_PHY_CAPABILITIES_PARITY;=0A=
-=0A=
-		pm8001_cw32(pm8001_ha, 2, offset, value);=0A=
+		pm8001_cw32(pm8001_ha, 2, offset, 0x80001501);=0A=
 	}=0A=
+	/*************************************************************=0A=
+	Change the SSC upspreading value to 0x0 so that upspreading is =
disabled.=0A=
+	Device MABC SMOD0 Controls=0A=
+	Address: (via MEMBASE-III):=0A=
+	Using shifted destination address 0x0_0000: with Offset 0xD8=0A=
+=0A=
+	31:28 R/W Reserved Do not change=0A=
+	27:24 R/W SAS_SMOD_SPRDUP 0000=0A=
+	23:20 R/W SAS_SMOD_SPRDDN 0000=0A=
+	19:0  R/W  Reserved Do not change=0A=
+	Upon power-up this register will read as 0x8990c016,=0A=
+	and I would like you to change the SAS_SMOD_SPRDUP bits to 0b0000=0A=
+	so that the written value will be 0x8090c016.=0A=
+	This will ensure only down-spreading SSC is enabled on the SPC.=0A=
+	*************************************************************/=0A=
+	value =3D pm8001_cr32(pm8001_ha, 2, 0xd8);=0A=
+	pm8001_cw32(pm8001_ha, 2, 0xd8, 0x8000C016);=0A=
 =0A=
 	/*set the shifted destination address to 0x0 to avoid error operation =
*/=0A=
 	bar4_shift(pm8001_ha, 0x0);=0A=
-- =0A=
1.6.5.1.1367.gcd48=0A=
=0A=

------=_NextPart_000_002A_01CA6873.195D67C0--

