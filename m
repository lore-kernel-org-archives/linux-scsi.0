Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 07E4D3FFF94;
	Thu, 30 Jul 2026 10:53:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785408822; cv=none; b=dbBIC9yaMgaahLepyCUWTTWDIq3hL1kg+5bmyWdZlLUIMCAVMaxOlTv4ZOhigzTWFl4KlLlhI/m/nxD/EMzTeLT25VJrTDkfUubuyG13GvV3zKbSMd1AOYj0RlNODbQ9ghmKB5Nq8vdBz2Eat+KjP2/wTLwcg05/FYk6pYcOMuY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785408822; c=relaxed/simple;
	bh=ovsIbtH7x7vPLzVIVcr438UeWKzVRzdNiVzAfMZW+Io=;
	h=From:Subject:To:Cc:In-Reply-To:References:Content-Type:Date:
	 Message-Id; b=sktoQRAZJVoij4ASEP774+r4lfjecbhd4V2KjRe5oTd58O9EilsNVzNCi1oMOANeQT6AHRnqSlgR39DfFMZ4cCq4wlkJBWO7rUPXADkXLbxP3wSF5TfqrX3f8TDlv6bBcRx2gKob0vC8op2LW+sNwa2ilMsy/axK8Wkt1QrOT1A=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=jq4NcSy3; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="jq4NcSy3"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D80FA1F000E9;
	Thu, 30 Jul 2026 10:53:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1785408820;
	bh=pJDOR8Kv5HZvweVN+eeDRb3EHC5i492sV6j2rZCPFfc=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=jq4NcSy3EVrqGW+u3uFp9qXCqxsDwk+mi4hS/o8Nzq8mmFwTnE8KULoN9SRKl8vLN
	 jcJpck0h91CykH3LiAva5XpPGQP8yibLHNP3nGJbsyS0WJcJraCRcQ8D2DuH8hcw75
	 AHpwUNb1DZrBdG7p6sZcwbFGfzL/s4EYYaVI/Xr8G1I5WFF13lGJsQNZoZ09zQv7ju
	 d0T1BnhjtrU/ebz+Eso+lpfVl4hwV3rNMvU77Ez+7i2wZ6Q+2024MxfEPwVkZazmaY
	 cVLrxGIvakoBE9QEMLSBbUjR/mj4W+1KTbFazzSzcnyEiBhE2WmYtUZiWDK+l5NCGO
	 eK2uH4i+NPFqQ==
From: sashiko-bot@kernel.org
Subject: Re: [PATCH v10 20/26] scsi: ufs: mediatek: Back up idle timer in
 per-instance struct
Reply-To: sashiko-reviews@lists.linux.dev
To: "Louis-Alexis Eyraud" <louisalexis.eyraud@collabora.com>
Cc: conor+dt@kernel.org, linux-phy@lists.infradead.org, vkoul@kernel.org, neil.armstrong@linaro.org, olteanv@gmail.com, robh@kernel.org, linux-scsi@vger.kernel.org, devicetree@vger.kernel.org
In-Reply-To: <20260730-mt8196-ufs-v10-20-bc5ecef202dc@collabora.com>
References: <20260730-mt8196-ufs-v10-0-bc5ecef202dc@collabora.com>
 <20260730-mt8196-ufs-v10-20-bc5ecef202dc@collabora.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Thu, 30 Jul 2026 10:53:39 +0000
Message-Id: <20260730105339.D80FA1F000E9@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>

Thank you for your contribution! Sashiko AI review found 1 potential issue(=
s) to consider:

Pre-existing issues:
- [High] Skipped POST_CHANGE notification on power change failure leads to =
permanent loss of auto-hibernate configuration, disabling Auto-Hibern8.
--

--- Patch [20]: [PATCH v10 20/26] scsi: ufs: mediatek: Back up idle timer i=
n per-instance struct ---
commit 31da80f38058b251310b08adf616cded137a1bcd
Author: Nicolas Frattaroli <nicolas.frattaroli@collabora.com>

scsi: ufs: mediatek: Back up idle timer in per-instance struct

This commit moves the backup of the auto-hibernate idle timer from a
static local variable to a per-instance host struct member. This ensures
correct behavior when multiple instances of the driver are loaded.

> diff --git a/drivers/ufs/host/ufs-mediatek.c b/drivers/ufs/host/ufs-media=
tek.c
> index c784ecb30e74e..115056927223f 100644
> --- a/drivers/ufs/host/ufs-mediatek.c
> +++ b/drivers/ufs/host/ufs-mediatek.c
> @@ -1400,27 +1400,24 @@ static int ufs_mtk_pwr_change_notify(struct ufs_h=
ba *hba,
>  				enum ufs_notify_change_status stage,
>  				struct ufs_pa_layer_attr *dev_req_params)
>  {
> -	int ret =3D 0;
> -	static u32 reg;
> +	struct ufs_mtk_host *host =3D ufshcd_get_variant(hba);
> =20
>  	switch (stage) {
>  	case PRE_CHANGE:
>  		if (ufshcd_is_auto_hibern8_supported(hba)) {
> -			reg =3D ufshcd_readl(hba, REG_AUTO_HIBERNATE_IDLE_TIMER);
> +			host->ahit =3D ufshcd_readl(
> +				hba, REG_AUTO_HIBERNATE_IDLE_TIMER);

[Severity: High]
This isn't a bug introduced by this patch, but does this sequence permanent=
ly
disable Auto-Hibern8 if a power change fails?

If a DME power mode change fails, the UFS core in ufshcd_change_power_mode()
skips the POST_CHANGE notification:

drivers/ufs/core/ufshcd.c:ufshcd_change_power_mode() {
    ...
    ret =3D ufshcd_dme_change_power_mode(hba, pwr_mode);
    if (!ret)
        ufshcd_vops_pwr_change_notify(hba, POST_CHANGE, pwr_mode);
    ...
}

Because POST_CHANGE is skipped, the hardware register remains at 0 (since
it was disabled right below by ufs_mtk_auto_hibern8_disable).

On the next power mode change attempt, PRE_CHANGE will run again and read t=
he
current register value (0) into host->ahit, overwriting the valid backup.
When POST_CHANGE eventually succeeds, it will write 0 back to the register,
leaving Auto-Hibern8 permanently disabled until a reset or suspend/resume.

>  			ufs_mtk_auto_hibern8_disable(hba);
>  		}

[ ... ]

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20260730-mt8196-ufs=
-v10-0-bc5ecef202dc@collabora.com?part=3D20
