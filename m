Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 963FA4718DA;
	Mon, 14 Sep 2026 13:03:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789390984; cv=none; b=OTvbD48E7y3gPADA7T5bpqAKQ/V87WQYlHQqv9Te4BJFFJcMa/Ptxd8rq24E2Q6Es9Db63pWUVJw0P90lx8HW6oXs5JdHEXYvG4OayM6lplbAYRgyYY2VnZ8j88R7C2eJSBB5uc5J/Szk8ElQ6hq9jnzTFAzSFNtx9Y/sGdhb6o=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789390984; c=relaxed/simple;
	bh=h4+g314dISLc4nmNK6lN+nc5NS+KtRZhN74qYEKIaGc=;
	h=From:Subject:To:Cc:In-Reply-To:References:Content-Type:Date:
	 Message-Id; b=MxkxTxUBvj48oJh8QHajr8yXsqgPzHid+hnzgJihe9jVz1IsdXzBJLRwDSlPtBYgWhgRlhnIuMlX92jTXcFasdU0ldn6j3SA/LE2kJuAWm9Oa++Ds9cUMSqs6vIx9YenELSQBINIVrsRoSXEn5YBQ99fVexYKQrBeksrYZCspmA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=jxdbFdXe; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="jxdbFdXe"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CA7381F000FF;
	Mon, 14 Sep 2026 13:03:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1789390983;
	bh=ES7FJM+Izh3s5krxUmK4wJgOmhiK/PFbKS8ZGjTEiNU=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=jxdbFdXeZeZc+qFyuzBLG/Hazm8BvbHCaxKSiYcxfFwa0tiowAA2vyA8jXm+5kWNr
	 G3ZmAuol4ReRoUi0wNFb8FoxJ5Lk1NA14csRtPiKO+7H6qnaXZNq9w53PJYBMOSezo
	 yPqSX5ZVS3lNYDRrRbPRFNtdbtmrN89qet/Q2SP/k0F0NyJDMLaXdAn2WVa+DoL1Zq
	 EDISPe89xfpGIfqCELxZKePaw9oF4sEJgcI9r/EqjbBpp0oUcrjZv42ADT484pjyjl
	 53/xusRUawbQZrBmyDralkaLs/IQ37PkDFPfk1pdUfSbqJIrDZpDgAtv8wgmN8/s7g
	 unRNUIRX/AQkQ==
From: sashiko-bot@kernel.org
Subject: Re: [PATCH v12 16/24] scsi: ufs: mediatek: Rework
 _ufs_mtk_clk_scale error paths
Reply-To: sashiko-reviews@lists.linux.dev
To: "Louis-Alexis Eyraud" <louisalexis.eyraud@collabora.com>
Cc: vkoul@kernel.org, linux-phy@lists.infradead.org, olteanv@gmail.com, linux-scsi@vger.kernel.org, robh@kernel.org, conor+dt@kernel.org, devicetree@vger.kernel.org, neil.armstrong@linaro.org
In-Reply-To: <20260914-mt8196-ufs-v12-16-9279d7ef814d@collabora.com>
References: <20260914-mt8196-ufs-v12-0-9279d7ef814d@collabora.com>
 <20260914-mt8196-ufs-v12-16-9279d7ef814d@collabora.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Mon, 14 Sep 2026 13:03:02 +0000
Message-Id: <20260914130302.CA7381F000FF@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>

Thank you for your contribution! Sashiko AI review found 2 potential issue(=
s) to consider:

Pre-existing issues:
- [High] The internal clock scaling function `_ufs_mtk_clk_scale()` returns=
 `void` and does not propagate hardware configuration failures to its calle=
r, causing silent software state desynchronization.
- [High] Clock scaling is silently disabled and triggers clock tree corrupt=
ion if the optional FDE clock is missing from the device tree.
--

commit 6954740ae6011cf83d515e18a54406e92942ec76
Author: Nicolas Frattaroli <nicolas.frattaroli@collabora.com>

    scsi: ufs: mediatek: Rework _ufs_mtk_clk_scale error paths

This commit reworks error paths in _ufs_mtk_clk_scale() to use the correct
logging levels via dev_err(). It also adds missing goto out statements in t=
he
scale up case for consistency with the scale down branch.

> diff --git a/drivers/ufs/host/ufs-mediatek.c b/drivers/ufs/host/ufs-media=
tek.c
> index 8e2aeb877de83..b5b13444d27cb 100644
> --- a/drivers/ufs/host/ufs-mediatek.c
> +++ b/drivers/ufs/host/ufs-mediatek.c

[Severity: High]
This isn't a bug introduced by this patch, but I wanted to ask about the
early return just above this first hunk in _ufs_mtk_clk_scale():

	if (!clki || !fde_clki)
		return;

Since ufs_mtk_is_clk_scale_ready() does not require the FDE clock to be
present, does this early return incorrectly skip main clock scaling on
platforms without an FDE clock?

If this returns early, ufs_mtk_clk_scale() will unconditionally update the
clki->curr_freq state, and the UFS core might apply the new frequency to the
unswitched parent clock.

> @@ -2020,16 +2020,16 @@ static void _ufs_mtk_clk_scale(struct ufs_hba *hb=
a, bool scale_up)
> =20
>  	ret =3D clk_prepare_enable(clki->clk);
>  	if (ret) {
> -		dev_info(hba->dev,
> -			 "clk_prepare_enable() fail, ret: %d\n", ret);
> +		dev_err(hba->dev, "%s: Failed to enable clock: %pe\n", __func__, ERR_P=
TR(ret));
>  		return;
>  	}

[ ... ]

> @@ -2038,51 +2038,48 @@ static void _ufs_mtk_clk_scale(struct ufs_hba *hb=
a, bool scale_up)
>  		if (clk_bind_vcore) {
>  			ret =3D regulator_set_voltage(reg, volt, INT_MAX);
>  			if (ret) {
> -				dev_info(hba->dev,
> -					"Failed to set vcore to %d\n", volt);
> +				dev_err(hba->dev, "Failed to set vcore to %d\n", volt);
>  				goto out;
>  			}
>  		}
> =20
>  		ret =3D clk_set_parent(clki->clk, mclk->ufs_sel_max_clki->clk);
>  		if (ret) {
> -			dev_info(hba->dev, "Failed to set clk mux, ret =3D %d\n",
> -				ret);
> +			dev_err(hba->dev, "%s: Failed to set clock mux: %pe\n",
> +				__func__, ERR_PTR(ret));
> +			goto out;
>  		}

[Severity: High]
This is a pre-existing issue, but should _ufs_mtk_clk_scale() propagate
these errors back to the caller instead of returning void?

When this takes the "goto out" path on failure, the caller
ufs_mtk_clk_scale() assumes success and unconditionally applies the target
frequency to the software state:

ufs_mtk_clk_scale() {
    ...
	if (scale_up)
		_ufs_mtk_clk_scale(hba, true);
	else
		_ufs_mtk_clk_scale(hba, false);

	host->clk_scale_up =3D scale_up;

	/* Must always set before clk_set_rate() */
	if (scale_up)
		clki->curr_freq =3D clki->max_freq;
	else
		clki->curr_freq =3D clki->min_freq;
    ...
}

Because ufs_mtk_clk_scale_notify() then returns 0, the UFS core proceeds to
call clk_set_rate() on the mux clock. If the parent was never switched,
does this apply the rate change to the original parent clock, potentially
corrupting the clock tree?

[ ... ]

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20260914-mt8196-ufs=
-v12-0-9279d7ef814d@collabora.com?part=3D16
