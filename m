Received: from metis.whiteo.stw.pengutronix.de (metis.whiteo.stw.pengutronix.de [185.203.201.7])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D456A31BC94
	for <linux-scsi@vger.kernel.org>; Wed, 15 Oct 2025 10:08:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=185.203.201.7
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1760522891; cv=none; b=mwJTMmZotxeycC0LWJ6L2pM+PDDevEkhn5j+UwR5HSZqVuUkpxRYhI9DsVT7z/Wk7diLhb8zak9Hq9ude/tVfzI6WAK0lYr8CxN1cCzNKZjB69oHGg3cXouyQnOs9emOZVyX7TJhm5Ot08P39NHcW64B7VvqPfzcQaWj5AteLww=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1760522891; c=relaxed/simple;
	bh=zRHulXzKkomfeepMTC5Jx8qgKTmBkwJfiPgL1AWRJC8=;
	h=Message-ID:Subject:From:To:Cc:Date:In-Reply-To:References:
	 Content-Type:MIME-Version; b=Fm1KY5DR2oE9sHKR616LXY0r2YVzdywjsMoDi1/EJ2e4wqcU1hF0rCltSNKOXXtMXvgxGbDA1JTmqk64/FN2UPN4m4Vku6z8jv6paupx3VXhDkfXRUydkF3uw+sE1bbEnbcBGYyZk4X7PQlrcSPwsYjjVN00wcockv/K0NTkfuk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=pengutronix.de; spf=pass smtp.mailfrom=pengutronix.de; arc=none smtp.client-ip=185.203.201.7
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=pengutronix.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=pengutronix.de
Received: from drehscheibe.grey.stw.pengutronix.de ([2a0a:edc0:0:c01:1d::a2])
	by metis.whiteo.stw.pengutronix.de with esmtps (TLS1.3:ECDHE_RSA_AES_256_GCM_SHA384:256)
	(Exim 4.92)
	(envelope-from <p.zabel@pengutronix.de>)
	id 1v8yPu-00057X-NE; Wed, 15 Oct 2025 12:07:34 +0200
Received: from lupine.office.stw.pengutronix.de ([2a0a:edc0:0:900:1d::4e] helo=lupine)
	by drehscheibe.grey.stw.pengutronix.de with esmtps  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
	(Exim 4.96)
	(envelope-from <p.zabel@pengutronix.de>)
	id 1v8yPt-003hk2-23;
	Wed, 15 Oct 2025 12:07:33 +0200
Received: from pza by lupine with local (Exim 4.98.2)
	(envelope-from <p.zabel@pengutronix.de>)
	id 1v8yPt-000000007Ix-2FwJ;
	Wed, 15 Oct 2025 12:07:33 +0200
Message-ID: <6bea63bb14f2be814762fa719d3d7944bad39b6e.camel@pengutronix.de>
Subject: Re: [PATCH 5/5] scsi: ufs: mediatek: Rework resets
From: Philipp Zabel <p.zabel@pengutronix.de>
To: Nicolas Frattaroli <nicolas.frattaroli@collabora.com>, Alim Akhtar	
 <alim.akhtar@samsung.com>, Avri Altman <avri.altman@wdc.com>, Bart Van
 Assche	 <bvanassche@acm.org>, Rob Herring <robh@kernel.org>, Krzysztof
 Kozlowski	 <krzk+dt@kernel.org>, Conor Dooley <conor+dt@kernel.org>,
 Matthias Brugger	 <matthias.bgg@gmail.com>, AngeloGioacchino Del Regno	
 <angelogioacchino.delregno@collabora.com>, Stanley Chu	
 <stanley.chu@mediatek.com>, Chunfeng Yun <chunfeng.yun@mediatek.com>, Vinod
 Koul <vkoul@kernel.org>, Kishon Vijay Abraham I <kishon@kernel.org>, Peter
 Wang	 <peter.wang@mediatek.com>, Stanley Jhu <chu.stanley@gmail.com>,
 "James E.J. Bottomley" <James.Bottomley@HansenPartnership.com>, "Martin K.
 Petersen" <martin.petersen@oracle.com>
Cc: Louis-Alexis Eyraud <louisalexis.eyraud@collabora.com>, 
	kernel@collabora.com, linux-scsi@vger.kernel.org,
 devicetree@vger.kernel.org, 	linux-kernel@vger.kernel.org,
 linux-arm-kernel@lists.infradead.org, 	linux-mediatek@lists.infradead.org,
 linux-phy@lists.infradead.org
Date: Wed, 15 Oct 2025 12:07:33 +0200
In-Reply-To: <20251014-mt8196-ufs-v1-5-195dceb83bc8@collabora.com>
References: <20251014-mt8196-ufs-v1-0-195dceb83bc8@collabora.com>
	 <20251014-mt8196-ufs-v1-5-195dceb83bc8@collabora.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
User-Agent: Evolution 3.56.1-1 
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-SA-Exim-Connect-IP: 2a0a:edc0:0:c01:1d::a2
X-SA-Exim-Mail-From: p.zabel@pengutronix.de
X-SA-Exim-Scanned: No (on metis.whiteo.stw.pengutronix.de); SAEximRunCond expanded to false
X-PTX-Original-Recipient: linux-scsi@vger.kernel.org

Hi Nicolas,

On Di, 2025-10-14 at 17:10 +0200, Nicolas Frattaroli wrote:
> Rework the reset control getting in the driver's probe function to use
> the "_optional" function instead of defaulting to NULL on IS_ERR, so
> that actual real errors (as opposed to missing resets) can be handled as
> errors in the probe function.
>=20
> Also move the MPHY reset into the PHY driver, where it should live, and
> remove all remnants of it ever having been in this driver.

Part of that happened in the previous patch.

> Signed-off-by: Nicolas Frattaroli <nicolas.frattaroli@collabora.com>
> ---
>  drivers/ufs/host/ufs-mediatek-sip.h |  8 -----
>  drivers/ufs/host/ufs-mediatek.c     | 67 +++++++++++++++++++++----------=
------
>  drivers/ufs/host/ufs-mediatek.h     |  1 -
>  3 files changed, 38 insertions(+), 38 deletions(-)
>=20
> diff --git a/drivers/ufs/host/ufs-mediatek-sip.h b/drivers/ufs/host/ufs-m=
ediatek-sip.h
> index d627dfb4a766..256598cc3b5b 100644
> --- a/drivers/ufs/host/ufs-mediatek-sip.h
> +++ b/drivers/ufs/host/ufs-mediatek-sip.h
> @@ -31,11 +31,6 @@ enum ufs_mtk_vcc_num {
>  	UFS_VCC_MAX
>  };
> =20
> -enum ufs_mtk_mphy_op {
> -	UFS_MPHY_BACKUP =3D 0,
> -	UFS_MPHY_RESTORE
> -};
> -
>  /*
>   * SMC call wrapper function
>   */
> @@ -84,9 +79,6 @@ static inline void _ufs_mtk_smc(struct ufs_mtk_smc_arg =
s)
>  #define ufs_mtk_device_pwr_ctrl(on, ufs_version, res) \
>  	ufs_mtk_smc(UFS_MTK_SIP_DEVICE_PWR_CTRL, &(res), on, ufs_version)
> =20
> -#define ufs_mtk_mphy_ctrl(op, res) \
> -	ufs_mtk_smc(UFS_MTK_SIP_MPHY_CTRL, &(res), op)
> -
>  #define ufs_mtk_mtcmos_ctrl(op, res) \
>  	ufs_mtk_smc(UFS_MTK_SIP_MTCMOS_CTRL, &(res), op)
> =20
> diff --git a/drivers/ufs/host/ufs-mediatek.c b/drivers/ufs/host/ufs-media=
tek.c
> index 758a393a9de1..ac40d4a3a800 100644
> --- a/drivers/ufs/host/ufs-mediatek.c
> +++ b/drivers/ufs/host/ufs-mediatek.c
> @@ -204,49 +204,60 @@ static void ufs_mtk_crypto_enable(struct ufs_hba *h=
ba)
>  static void ufs_mtk_host_reset(struct ufs_hba *hba)
>  {
>  	struct ufs_mtk_host *host =3D ufshcd_get_variant(hba);
> -	struct arm_smccc_res res;
> +	int ret;
> =20
>  	reset_control_assert(host->hci_reset);
>  	reset_control_assert(host->crypto_reset);
>  	reset_control_assert(host->unipro_reset);
> -	reset_control_assert(host->mphy_reset);
> =20
> -	usleep_range(100, 110);
> +	ret =3D phy_reset(host->mphy);
> +
> +	/*
> +	 * Only sleep if MPHY doesn't have a reset implemented (which already
> +	 * sleeps) or the PHY reset function failed somehow, just to be safe
> +	 */
> +	if (ret) {
> +		usleep_range(100, 110);
> +		if (ret !=3D -EOPNOTSUPP)
> +			dev_warn(hba->dev, "PHY reset failed: %pe\n", ERR_PTR(ret));
> +	}
> =20
>  	reset_control_deassert(host->unipro_reset);
>  	reset_control_deassert(host->crypto_reset);
>  	reset_control_deassert(host->hci_reset);
> -	reset_control_deassert(host->mphy_reset);
> -
> -	/* restore mphy setting aftre mphy reset */
> -	if (host->mphy_reset)
> -		ufs_mtk_mphy_ctrl(UFS_MPHY_RESTORE, res);
>  }
> =20
> -static void ufs_mtk_init_reset_control(struct ufs_hba *hba,
> -				       struct reset_control **rc,
> -				       char *str)
> +static int ufs_mtk_init_reset_control(struct ufs_hba *hba,
> +				      struct reset_control **rc,
> +				      const char *str)
>  {
> -	*rc =3D devm_reset_control_get(hba->dev, str);
> +	*rc =3D devm_reset_control_get_optional(hba->dev, str);

Please use

	devm_reset_control_get_optional_exclusive()

directly, or see below for an alternative suggestion.

>  	if (IS_ERR(*rc)) {
> -		dev_info(hba->dev, "Failed to get reset control %s: %ld\n",
> -			 str, PTR_ERR(*rc));
> -		*rc =3D NULL;
> +		dev_err(hba->dev, "Failed to get reset control %s: %pe\n", str, *rc);
> +		return PTR_ERR(*rc);
>  	}
> +
> +	return 0;
>  }
> =20
> -static void ufs_mtk_init_reset(struct ufs_hba *hba)
> +static int ufs_mtk_init_reset(struct ufs_hba *hba)
>  {
>  	struct ufs_mtk_host *host =3D ufshcd_get_variant(hba);
> +	int ret;
> +
> +	ret =3D ufs_mtk_init_reset_control(hba, &host->hci_reset, "hci_rst");
> +	if (ret)
> +		return ret;
> +
> +	ret =3D ufs_mtk_init_reset_control(hba, &host->unipro_reset, "unipro_rs=
t");
> +	if (ret)
> +		return ret;
> +
> +	ret =3D ufs_mtk_init_reset_control(hba, &host->crypto_reset, "crypto_rs=
t");
> +	if (ret)
> +		return ret;

It looks to me like you could combine these into a

	devm_reset_control_bulk_get_optional_exclusive()

and operate the three resets with reset_control_bulk_assert/deassert().


regards
Philipp
