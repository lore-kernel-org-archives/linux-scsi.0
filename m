From: "jack wang" <jack_wang@usish.com>
Subject: Re: [PATCH 4/9] pm8001: set SSC down-spreading only to get less errors on some 6G device.
Date: Mon, 7 Dec 2009 17:46:22 +0800
Message-ID: <7193784671FE41AD99895E61498B1B7B@usish.com.cn>
References: <BB92EEE91A2A4B728CA91756755A67D6@usish.com.cn>
Mime-Version: 1.0
Content-Type: multipart/mixed;
	boundary="----=_NextPart_000_005C_01CA7765.32C51720"
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from sr-smtp.usish.com ([210.5.144.203]:33543 "EHLO
	sr-smtp.usish.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759144AbZLGJqV (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Mon, 7 Dec 2009 04:46:21 -0500
In-Reply-To: <BB92EEE91A2A4B728CA91756755A67D6@usish.com.cn>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: 'jack wang' <jack_wang@usish.com>, James.Bottomley@suse.de
Cc: linux-scsi@vger.kernel.org, 'Lindar Liu' <lindar_liu@usish.com>, 'Kevin Ao' <aoqingyun@usish.com>

This is a multi-part message in MIME format.

------=_NextPart_000_005C_01CA7765.32C51720
Content-Type: text/plain;
	charset="US-ASCII"
Content-Transfer-Encoding: 7bit

Patch attached , sorry for that.
Set SSC down-spreading only to get less error on some 6G device.

Signed-off-by: Jack Wang <jack_wang@usish.com>
---
 drivers/scsi/pm8001/pm8001_hwi.c |   65
++++++++++++-------------------------
 1 files changed, 21 insertions(+), 44 deletions(-)

diff --git a/drivers/scsi/pm8001/pm8001_hwi.c
b/drivers/scsi/pm8001/pm8001_hwi.c
index b4426b5..6e1bdd8 100644
--- a/drivers/scsi/pm8001/pm8001_hwi.c
+++ b/drivers/scsi/pm8001/pm8001_hwi.c
@@ -373,10 +373,7 @@ static int bar4_shift(struct pm8001_hba_info
*pm8001_ha, u32 shiftValue)
 static void __devinit
 mpi_set_phys_g3_with_ssc(struct pm8001_hba_info *pm8001_ha, u32 SSCbit)
 {
-	u32 offset;
-	u32 value;
-	u32 i, j;
-	u32 bit_cnt;
+	u32 value, offset, i;
 
 #define SAS2_SETTINGS_LOCAL_PHY_0_3_SHIFT_ADDR 0x00030000
 #define SAS2_SETTINGS_LOCAL_PHY_4_7_SHIFT_ADDR 0x00040000
@@ -392,55 +389,35 @@ mpi_set_phys_g3_with_ssc(struct pm8001_hba_info
*pm8001_ha, u32 SSCbit)
     */
 	if (-1 == bar4_shift(pm8001_ha,
SAS2_SETTINGS_LOCAL_PHY_0_3_SHIFT_ADDR))
 		return;
-	/* set SSC bit of PHY 0 - 3 */
+
 	for (i = 0; i < 4; i++) {
 		offset = SAS2_SETTINGS_LOCAL_PHY_0_3_OFFSET + 0x4000 * i;
-		value = pm8001_cr32(pm8001_ha, 2, offset);
-		if (SSCbit) {
-			value |= 0x00000001 << PHY_G3_WITH_SSC_BIT_SHIFT;
-			value &= ~(0x00000001 <<
PHY_G3_WITHOUT_SSC_BIT_SHIFT);
-		} else {
-			value |= 0x00000001 << PHY_G3_WITHOUT_SSC_BIT_SHIFT;
-			value &= ~(0x00000001 << PHY_G3_WITH_SSC_BIT_SHIFT);
-		}
-		bit_cnt = 0;
-		for (j = 0; j < 31; j++)
-			if ((value >> j) & 0x00000001)
-				bit_cnt++;
-		if (bit_cnt % 2)
-			value &= ~(0x00000001 <<
SNW3_PHY_CAPABILITIES_PARITY);
-		else
-			value |= 0x00000001 << SNW3_PHY_CAPABILITIES_PARITY;
-
-		pm8001_cw32(pm8001_ha, 2, offset, value);
+		pm8001_cw32(pm8001_ha, 2, offset, 0x80001501);
 	}
-
 	/* shift membase 3 for SAS2_SETTINGS_LOCAL_PHY 4 - 7 */
 	if (-1 == bar4_shift(pm8001_ha,
SAS2_SETTINGS_LOCAL_PHY_4_7_SHIFT_ADDR))
 		return;
-
-	/* set SSC bit of PHY 4 - 7 */
 	for (i = 4; i < 8; i++) {
 		offset = SAS2_SETTINGS_LOCAL_PHY_4_7_OFFSET + 0x4000 *
(i-4);
-		value = pm8001_cr32(pm8001_ha, 2, offset);
-		if (SSCbit) {
-			value |= 0x00000001 << PHY_G3_WITH_SSC_BIT_SHIFT;
-			value &= ~(0x00000001 <<
PHY_G3_WITHOUT_SSC_BIT_SHIFT);
-		} else {
-			value |= 0x00000001 << PHY_G3_WITHOUT_SSC_BIT_SHIFT;
-			value &= ~(0x00000001 << PHY_G3_WITH_SSC_BIT_SHIFT);
-		}
-		bit_cnt = 0;
-		for (j = 0; j < 31; j++)
-			if ((value >> j) & 0x00000001)
-				bit_cnt++;
-		if (bit_cnt % 2)
-			value &= ~(0x00000001 <<
SNW3_PHY_CAPABILITIES_PARITY);
-		else
-			value |= 0x00000001 << SNW3_PHY_CAPABILITIES_PARITY;
-
-		pm8001_cw32(pm8001_ha, 2, offset, value);
+		pm8001_cw32(pm8001_ha, 2, offset, 0x80001501);
 	}
+	/*************************************************************
+	Change the SSC upspreading value to 0x0 so that upspreading is
disabled.
+	Device MABC SMOD0 Controls
+	Address: (via MEMBASE-III):
+	Using shifted destination address 0x0_0000: with Offset 0xD8
+
+	31:28 R/W Reserved Do not change
+	27:24 R/W SAS_SMOD_SPRDUP 0000
+	23:20 R/W SAS_SMOD_SPRDDN 0000
+	19:0  R/W  Reserved Do not change
+	Upon power-up this register will read as 0x8990c016,
+	and I would like you to change the SAS_SMOD_SPRDUP bits to 0b0000
+	so that the written value will be 0x8090c016.
+	This will ensure only down-spreading SSC is enabled on the SPC.
+	*************************************************************/
+	value = pm8001_cr32(pm8001_ha, 2, 0xd8);
+	pm8001_cw32(pm8001_ha, 2, 0xd8, 0x8000C016);
 
 	/*set the shifted destination address to 0x0 to avoid error
operation */
 	bar4_shift(pm8001_ha, 0x0);
-- 
1.6.5.1.1367.gcd48


------=_NextPart_000_005C_01CA7765.32C51720
Content-Type: application/octet-stream;
	name="0004-set-SSC-down-spreading-only-to-get-less-error-on-som.patch"
Content-Transfer-Encoding: quoted-printable
Content-Disposition: attachment;
	filename="0004-set-SSC-down-spreading-only-to-get-less-error-on-som.patch"

>From 2e52b5132488048cde129aab17e99c64373452cf Mon Sep 17 00:00:00 2001=0A=
From: Jack Wang <jack_wang@usish.com>=0A=
Date: Mon, 7 Dec 2009 15:39:45 +0800=0A=
Subject: [PATCH 4/9] set SSC down-spreading only to get less error on =
some SAS 6G disk=0A=
=0A=
Signed-off-by: Jack Wang <jack_wang@usish.com>=0A=
---=0A=
 drivers/scsi/pm8001/pm8001_hwi.c |   65 =
++++++++++++-------------------------=0A=
 1 files changed, 21 insertions(+), 44 deletions(-)=0A=
=0A=
diff --git a/drivers/scsi/pm8001/pm8001_hwi.c =
b/drivers/scsi/pm8001/pm8001_hwi.c=0A=
index b4426b5..6e1bdd8 100644=0A=
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

------=_NextPart_000_005C_01CA7765.32C51720--

