Received: from mailout1.samsung.com (mailout1.samsung.com [203.254.224.24])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BC4DD17753
	for <linux-scsi@vger.kernel.org>; Tue, 18 Jun 2024 01:45:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=203.254.224.24
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1718675109; cv=none; b=H3w99IBqiglzlcPVueeOq3EJ2BIZ+pd2N0acslBDYzGnNV8DdUBins8zl/mbWC0OT6av6yTgIqf4AOjxrbzF70Hu1A/Nd+rJnsCJk5LR1DpxKMZ8zxQESrIUy47AsyYl4cXu2C9px3RDMDtJsgtdBWw/VdiOTY8PJuNFJooOgOg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1718675109; c=relaxed/simple;
	bh=EIX5+Jkr4Ry0fVcVVX+HGR8uBxFKC+OGqVMq7SrIccc=;
	h=Mime-Version:Subject:From:To:CC:In-Reply-To:Message-ID:Date:
	 Content-Type:References; b=TZSI6g1UaPT8FS1pYCgGLCu9NRAPDEitT/dCq2xPC4SEToR5/yN5iDsBlu8aKi6I6xc+o9M4bimNd6ZlO5qy8vrW+VNUEycPfkYxn7aesz8o7M8YyP4zAYPy6EuPD6Xu5mAh0PLeL3BkiTQhT2D01nGBFj5MLWGMomWLKOmsPFE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=samsung.com; spf=pass smtp.mailfrom=samsung.com; dkim=pass (1024-bit key) header.d=samsung.com header.i=@samsung.com header.b=PgH0fw2t; arc=none smtp.client-ip=203.254.224.24
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=samsung.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=samsung.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=samsung.com header.i=@samsung.com header.b="PgH0fw2t"
Received: from epcas2p1.samsung.com (unknown [182.195.41.53])
	by mailout1.samsung.com (KnoxPortal) with ESMTP id 20240618014503epoutp01a6c6d5ab1ab3248cf7804efd5af6f872~Z9eaYkjrb2578825788epoutp01Q
	for <linux-scsi@vger.kernel.org>; Tue, 18 Jun 2024 01:45:03 +0000 (GMT)
DKIM-Filter: OpenDKIM Filter v2.11.0 mailout1.samsung.com 20240618014503epoutp01a6c6d5ab1ab3248cf7804efd5af6f872~Z9eaYkjrb2578825788epoutp01Q
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=samsung.com;
	s=mail20170921; t=1718675103;
	bh=EIX5+Jkr4Ry0fVcVVX+HGR8uBxFKC+OGqVMq7SrIccc=;
	h=Subject:Reply-To:From:To:CC:In-Reply-To:Date:References:From;
	b=PgH0fw2tGLrMALb0cgD7mIFpeV7b/KV5E7wKdrC9/jsY4KUuJxV+5cY2lOwhWFfEb
	 f4nPe9FtT8peFp/5u2ewWIXWhheqDOlf92DZQJ9Q0q10pBHb61iZz9co26GJU7SF7r
	 wo0oc0RdqdmxiNBuY1r9ZeQlJgq+jVg1vYnQ7AaM=
Received: from epsnrtp4.localdomain (unknown [182.195.42.165]) by
	epcas2p4.samsung.com (KnoxPortal) with ESMTP id
	20240618014502epcas2p47288eaf86f0dd9860044b0f12345dfa6~Z9eZi18a00615806158epcas2p4U;
	Tue, 18 Jun 2024 01:45:02 +0000 (GMT)
Received: from epcpadp3 (unknown [182.195.40.17]) by epsnrtp4.localdomain
	(Postfix) with ESMTP id 4W38hG4R3Wz4x9Pq; Tue, 18 Jun 2024 01:45:02 +0000
	(GMT)
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
Subject: RE: [PATCH 1/8] scsi: ufs: Initialize struct uic_command once
Reply-To: daejun7.park@samsung.com
Sender: Daejun Park <daejun7.park@samsung.com>
From: Daejun Park <daejun7.park@samsung.com>
To: Bart Van Assche <bvanassche@acm.org>, "Martin K . Petersen"
	<martin.petersen@oracle.com>
CC: "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>, "James E.J.
 Bottomley" <James.Bottomley@HansenPartnership.com>, Avri Altman
	<avri.altman@wdc.com>, Peter Wang <peter.wang@mediatek.com>, Manivannan
	Sadhasivam <manivannan.sadhasivam@linaro.org>, Bean Huo
	<beanhuo@micron.com>, Minwoo Im <minwoo.im@samsung.com>, Maramaina Naresh
	<quic_mnaresh@quicinc.com>, Akinobu Mita <akinobu.mita@gmail.com>, Daejun
	Park <daejun7.park@samsung.com>
X-Priority: 3
X-Content-Kind-Code: NORMAL
In-Reply-To: <20240617210844.337476-2-bvanassche@acm.org>
X-CPGS-Detection: blocking_info_exchange
X-Drm-Type: N,general
X-Msg-Generator: Mail
X-Msg-Type: PERSONAL
X-Reply-Demand: N
Message-ID: <1891546521.01718675102603.JavaMail.epsvc@epcpadp3>
Date: Tue, 18 Jun 2024 10:25:10 +0900
X-CMS-MailID: 20240618012510epcms2p8c047bad9c392685771a8da9b7f8a2249
Content-Transfer-Encoding: quoted-printable
Content-Type: text/plain; charset="utf-8"
X-Sendblock-Type: AUTO_CONFIDENTIAL
CMS-TYPE: 102P
X-CPGSPASS: Y
X-CPGSPASS: Y
X-Hop-Count: 3
X-CMS-RootMailID: 20240617210921epcas2p157b0455482794b03d35185bdbfeac6d3
References: <20240617210844.337476-2-bvanassche@acm.org>
	<20240617210844.337476-1-bvanassche@acm.org>
	<CGME20240617210921epcas2p157b0455482794b03d35185bdbfeac6d3@epcms2p8>

Hi Bart,
=C2=A0
> Instead of first zero-initializing struct uic_command and next initializi=
ng
> it memberwise, initialize all members at once.
>=20
> Signed-off-by: Bart Van Assche <bvanassche@acm.org>
> ---
> drivers/ufs/core/ufshcd.c 62 ++++++++++++++++++++-------------------
> include/ufs/ufshcd.h=C2=A0 =C2=A0 =C2=A0 =C2=A0 4 +--
> 2 files changed, 34 insertions(+), 32 deletions(-)
>=20
> diff --git a/drivers/ufs/core/ufshcd.c b/drivers/ufs/core/ufshcd.c
> index 41bf2e249c83..5d784876513e 100644
> --- a/drivers/ufs/core/ufshcd.c
> +++ b/drivers/ufs/core/ufshcd.c
> @@ -3993,11 +3993,11 @@ static void ufshcd_host_memory_configure(struct u=
fs_hba *hba)
> =C2=A0 */
> static int ufshcd_dme_link_startup(struct ufs_hba *hba)
> {
> - =C2=A0 =C2=A0 =C2=A0 =C2=A0struct uic_command uic_cmd =3D {0};
> + =C2=A0 =C2=A0 =C2=A0 =C2=A0struct uic_command uic_cmd =3D {
> + =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0.command =3D UIC=
_CMD_DME_LINK_STARTUP,
> + =C2=A0 =C2=A0 =C2=A0 =C2=A0};
> =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0int ret;
>=20
> - =C2=A0 =C2=A0 =C2=A0 =C2=A0uic_cmd.command =3D UIC_CMD_DME_LINK_STARTUP=
;
> -
> =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0ret =3D ufshcd_send_uic_cmd(hba, &uic_c=
md);
> =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0if (ret)
> =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0dev_dbg(hba=
->dev,
> @@ -4015,11 +4015,11 @@ static int ufshcd_dme_link_startup(struct ufs_hba=
 *hba)
> =C2=A0 */
> static int ufshcd_dme_reset(struct ufs_hba *hba)
> {
> - =C2=A0 =C2=A0 =C2=A0 =C2=A0struct uic_command uic_cmd =3D {0};
> + =C2=A0 =C2=A0 =C2=A0 =C2=A0struct uic_command uic_cmd =3D {
> + =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0.command =3D UIC=
_CMD_DME_RESET,
> + =C2=A0 =C2=A0 =C2=A0 =C2=A0};
> =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0int ret;
>=20
> - =C2=A0 =C2=A0 =C2=A0 =C2=A0uic_cmd.command =3D UIC_CMD_DME_RESET;
> -
> =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0ret =3D ufshcd_send_uic_cmd(hba, &uic_c=
md);
> =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0if (ret)
> =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0dev_err(hba=
->dev,
> @@ -4054,11 +4054,11 @@ EXPORT_SYMBOL_GPL(ufshcd_dme_configure_adapt);
> =C2=A0 */
> static int ufshcd_dme_enable(struct ufs_hba *hba)
> {
> - =C2=A0 =C2=A0 =C2=A0 =C2=A0struct uic_command uic_cmd =3D {0};
> + =C2=A0 =C2=A0 =C2=A0 =C2=A0struct uic_command uic_cmd =3D {
> + =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0.command =3D UIC=
_CMD_DME_ENABLE,
> + =C2=A0 =C2=A0 =C2=A0 =C2=A0};
> =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0int ret;
>=20
> - =C2=A0 =C2=A0 =C2=A0 =C2=A0uic_cmd.command =3D UIC_CMD_DME_ENABLE;
> -
> =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0ret =3D ufshcd_send_uic_cmd(hba, &uic_c=
md);
> =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0if (ret)
> =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0dev_err(hba=
->dev,
> @@ -4111,7 +4111,12 @@ static inline void ufshcd_add_delay_before_dme_cmd=
(struct ufs_hba *hba)
> int ufshcd_dme_set_attr(struct ufs_hba *hba, u32 attr_sel,
> =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=
=A0 =C2=A0 =C2=A0u8 attr_set, u32 mib_val, u8 peer)
> {
> - =C2=A0 =C2=A0 =C2=A0 =C2=A0struct uic_command uic_cmd =3D {0};
> + =C2=A0 =C2=A0 =C2=A0 =C2=A0struct uic_command uic_cmd =3D {
> + =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0.command =3D pee=
r ? UIC_CMD_DME_PEER_SET : UIC_CMD_DME_SET,
> + =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0.argument1 =3D a=
ttr_sel,
> + =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0.argument2 =3D U=
IC_ARG_ATTR_TYPE(attr_set),
> + =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0.argument3 =3D m=
ib_val,
> + =C2=A0 =C2=A0 =C2=A0 =C2=A0};
> =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0static const char *const action[] =3D {
> =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0"dme-set",
> =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0"dme-peer-s=
et"
> @@ -4120,12 +4125,6 @@ int ufshcd_dme_set_attr(struct ufs_hba *hba, u32 a=
ttr_sel,
> =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0int ret;
> =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0int retries =3D UFS_UIC_COMMAND_RETRIES=
;
>=20
> - =C2=A0 =C2=A0 =C2=A0 =C2=A0uic_cmd.command =3D peer ?
> - =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0UIC_CMD_DME_PEER=
_SET : UIC_CMD_DME_SET;
> - =C2=A0 =C2=A0 =C2=A0 =C2=A0uic_cmd.argument1 =3D attr_sel;
> - =C2=A0 =C2=A0 =C2=A0 =C2=A0uic_cmd.argument2 =3D UIC_ARG_ATTR_TYPE(attr=
_set);
> - =C2=A0 =C2=A0 =C2=A0 =C2=A0uic_cmd.argument3 =3D mib_val;
> -
> =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0do {
> =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0/* for peer=
 attributes we retry upon failure */
> =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0ret =3D ufs=
hcd_send_uic_cmd(hba, &uic_cmd);
> @@ -4155,7 +4154,11 @@ EXPORT_SYMBOL_GPL(ufshcd_dme_set_attr);
> int ufshcd_dme_get_attr(struct ufs_hba *hba, u32 attr_sel,
> =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=
=A0 =C2=A0 =C2=A0u32 *mib_val, u8 peer)
> {
> - =C2=A0 =C2=A0 =C2=A0 =C2=A0struct uic_command uic_cmd =3D {0};
> + =C2=A0 =C2=A0 =C2=A0 =C2=A0struct uic_command uic_cmd =3D {
> + =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0.command =3D pee=
r ? UIC_CMD_DME_PEER_GET : UIC_CMD_DME_GET,
> + =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0.argument1 =3D a=
ttr_sel,
> +
Empty line.

> + =C2=A0 =C2=A0 =C2=A0 =C2=A0};
> =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0static const char *const action[] =3D {
> =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0"dme-get",
> =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0"dme-peer-g=
et"
> @@ -4189,10 +4192,6 @@ int ufshcd_dme_get_attr(struct ufs_hba *hba, u32 a=
ttr_sel,
> =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0}
> =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0}
>=20
> - =C2=A0 =C2=A0 =C2=A0 =C2=A0uic_cmd.command =3D peer ?
> - =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0UIC_CMD_DME_PEER=
_GET : UIC_CMD_DME_GET;
> - =C2=A0 =C2=A0 =C2=A0 =C2=A0uic_cmd.argument1 =3D attr_sel;
> -
> =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0do {
> =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0/* for peer=
 attributes we retry upon failure */
> =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0ret =3D ufs=
hcd_send_uic_cmd(hba, &uic_cmd);
> @@ -4325,7 +4324,11 @@ static int ufshcd_uic_pwr_ctrl(struct ufs_hba *hba=
, struct uic_command *cmd)
> =C2=A0 */
> int ufshcd_uic_change_pwr_mode(struct ufs_hba *hba, u8 mode)
> {
> - =C2=A0 =C2=A0 =C2=A0 =C2=A0struct uic_command uic_cmd =3D {0};
> + =C2=A0 =C2=A0 =C2=A0 =C2=A0struct uic_command uic_cmd =3D {
> + =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0.command =3D UIC=
_CMD_DME_SET,
> + =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0.argument1 =3D U=
IC_ARG_MIB(PA_PWRMODE),
> + =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0.argument3 =3D m=
ode,
> + =C2=A0 =C2=A0 =C2=A0 =C2=A0};
> =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0int ret;
>=20
> =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0if (hba->quirks & UFSHCD_QUIRK_BROKEN_P=
A_RXHSUNTERMCAP) {
> @@ -4338,9 +4341,6 @@ int ufshcd_uic_change_pwr_mode(struct ufs_hba *hba,=
 u8 mode)
> =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0}
> =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0}
>=20
> - =C2=A0 =C2=A0 =C2=A0 =C2=A0uic_cmd.command =3D UIC_CMD_DME_SET;
> - =C2=A0 =C2=A0 =C2=A0 =C2=A0uic_cmd.argument1 =3D UIC_ARG_MIB(PA_PWRMODE=
);
> - =C2=A0 =C2=A0 =C2=A0 =C2=A0uic_cmd.argument3 =3D mode;
> =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0ufshcd_hold(hba);
> =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0ret =3D ufshcd_uic_pwr_ctrl(hba, &uic_c=
md);
> =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0ufshcd_release(hba);
> @@ -4381,13 +4381,14 @@ EXPORT_SYMBOL_GPL(ufshcd_link_recovery);
>=20
> int ufshcd_uic_hibern8_enter(struct ufs_hba *hba)
> {
> - =C2=A0 =C2=A0 =C2=A0 =C2=A0int ret;
> - =C2=A0 =C2=A0 =C2=A0 =C2=A0struct uic_command uic_cmd =3D {0};
> + =C2=A0 =C2=A0 =C2=A0 =C2=A0struct uic_command uic_cmd =3D {
> + =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0.command =3D UIC=
_CMD_DME_HIBER_ENTER,
> + =C2=A0 =C2=A0 =C2=A0 =C2=A0};
> =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0ktime_t start =3D ktime_get();
> + =C2=A0 =C2=A0 =C2=A0 =C2=A0int ret;
>=20
> =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0ufshcd_vops_hibern8_notify(hba, UIC_CMD=
_DME_HIBER_ENTER, PRE_CHANGE);
>=20
> - =C2=A0 =C2=A0 =C2=A0 =C2=A0uic_cmd.command =3D UIC_CMD_DME_HIBER_ENTER;
> =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0ret =3D ufshcd_uic_pwr_ctrl(hba, &uic_c=
md);
> =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0trace_ufshcd_profile_hibern8(dev_name(h=
ba->dev), "enter",
> =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=
=A0 =C2=A0 =C2=A0=C2=A0 =C2=A0 ktime_to_us(ktime_sub(ktime_get(), start)), =
ret);
> @@ -4405,13 +4406,14 @@ EXPORT_SYMBOL_GPL(ufshcd_uic_hibern8_enter);
>=20
> int ufshcd_uic_hibern8_exit(struct ufs_hba *hba)
> {
> - =C2=A0 =C2=A0 =C2=A0 =C2=A0struct uic_command uic_cmd =3D {0};
> + =C2=A0 =C2=A0 =C2=A0 =C2=A0struct uic_command uic_cmd =3D {
> + =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0.command =3D UIC=
_CMD_DME_HIBER_EXIT,
> + =C2=A0 =C2=A0 =C2=A0 =C2=A0};
> =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0int ret;
> =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0ktime_t start =3D ktime_get();
>=20
> =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0ufshcd_vops_hibern8_notify(hba, UIC_CMD=
_DME_HIBER_EXIT, PRE_CHANGE);
>=20
> - =C2=A0 =C2=A0 =C2=A0 =C2=A0uic_cmd.command =3D UIC_CMD_DME_HIBER_EXIT;
> =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0ret =3D ufshcd_uic_pwr_ctrl(hba, &uic_c=
md);
> =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0trace_ufshcd_profile_hibern8(dev_name(h=
ba->dev), "exit",
> =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=
=A0 =C2=A0 =C2=A0=C2=A0 =C2=A0 ktime_to_us(ktime_sub(ktime_get(), start)), =
ret);
> diff --git a/include/ufs/ufshcd.h b/include/ufs/ufshcd.h
> index 9e0581115b34..d4d63507d090 100644
> --- a/include/ufs/ufshcd.h
> +++ b/include/ufs/ufshcd.h
> @@ -73,8 +73,8 @@ enum ufs_event_type {
> =C2=A0 * @done: UIC command completion
> =C2=A0 */
> struct uic_command {
> - =C2=A0 =C2=A0 =C2=A0 =C2=A0u32 command;
> - =C2=A0 =C2=A0 =C2=A0 =C2=A0u32 argument1;
> + =C2=A0 =C2=A0 =C2=A0 =C2=A0const u32 command;
> + =C2=A0 =C2=A0 =C2=A0 =C2=A0const u32 argument1;
> =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0u32 argument2;
> =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0u32 argument3;
> =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0int cmd_active;

Reviewed-by: Daejun Park <daejun7.park@samsung.com>

Thanks,

Daejun
