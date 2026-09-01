Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7F55E44064D;
	Tue,  1 Sep 2026 16:16:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788279390; cv=none; b=s3VAGIING1Af6e4YcfzAIl+3kogi8+mKPMOeu7Hg3JZ5vnXNeeHMzAhdoZg6T1oXecXO6/aMUHmHeRaINS5UMEFU0NsHQLjSSCkSlmkqhi8WgsS8LnO3Xky2o+D9pLGq3ZSOWmPVCiyeqVABkViCF3jbNvEXLGRxIeVdWGEMEQw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788279390; c=relaxed/simple;
	bh=RdkaNeRHJ11pU66Pkk5K7QoSE3hHLLMgH4hClCMdmyw=;
	h=From:Subject:To:Cc:In-Reply-To:References:Content-Type:Date:
	 Message-Id; b=hPMvrwyxG6UzArqWgksMiUFI9T9SDdMS+GeD9LRpHX6UxvyWiRKKVWrGuLvSVDd1QOP9Rp0PBAwc9W5MBlQnzso68xks3in5kUFC5Ro4LDUjAiG+MRCzY3grEyA1Y6JwNXzepfQPJOYBAwXUUKC+uRiH2ffD5Vfcy2km9SrwJ3A=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=DJj6cdAL; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="DJj6cdAL"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9C4B61F000E9;
	Tue,  1 Sep 2026 16:16:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1788279389;
	bh=1ULfzuk6SCvsD92qGEoFRFVf2Tf/24qgQyvN/na9zwg=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=DJj6cdALes8mwwlS3CeOV4/7y6E8OLX8CeUm69pTaRoqG5O5wxFJxUpjMfhBKStye
	 9TWHWfXffDzFvqWXAawAAcTM/DYsj+z+SNs16jjRZGmj1Jpq5D5HrrtfCrRp3sDRKE
	 vV87qWCEGKyuhc4NAK9mv+5ux5r1KOsR5WqOGXu7vgUF5KMe9zblktvGHsTNal+gZz
	 oSsdlfhC5mzEHBiGCtU/oJa4PF1LKKt3xGmCj0m23k67m7xDjYqG07nCYhE+TN1Ne4
	 trf783hFbKO9IyI358Z+RI4EXEfwaur7SDKVhUg9EIMmp1jwj3sM4PpwaCBO3qsTSp
	 GOS0OJgGwwccQ==
From: sashiko-bot@kernel.org
Subject: Re: [PATCH v11 16/24] scsi: ufs: mediatek: Rework
 _ufs_mtk_clk_scale error paths
Reply-To: sashiko-reviews@lists.linux.dev
To: "Louis-Alexis Eyraud" <louisalexis.eyraud@collabora.com>
Cc: devicetree@vger.kernel.org, robh@kernel.org, olteanv@gmail.com, neil.armstrong@linaro.org, vkoul@kernel.org, conor+dt@kernel.org, linux-scsi@vger.kernel.org, linux-phy@lists.infradead.org
In-Reply-To: <20260901-mt8196-ufs-v11-16-dbd007704490@collabora.com>
References: <20260901-mt8196-ufs-v11-0-dbd007704490@collabora.com>
 <20260901-mt8196-ufs-v11-16-dbd007704490@collabora.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Tue, 01 Sep 2026 16:16:28 +0000
Message-Id: <20260901161628.9C4B61F000E9@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>

Thank you for your contribution! Sashiko AI review found 1 potential issue(=
s) to consider:

Pre-existing issues:
- [High] _ufs_mtk_clk_scale ignores hardware configuration failures, causin=
g the UFS core to apply clock rates to the wrong parent.
--

commit ea79392ecd3d0415deb8de00d83deee028772b07
Author: Nicolas Frattaroli <nicolas.frattaroli@collabora.com>

scsi: ufs: mediatek: Rework _ufs_mtk_clk_scale error paths

This commit updates the error logging in _ufs_mtk_clk_scale to use
dev_err instead of dev_info. It also adds missing goto statements in
the scale-up branches to ensure proper cleanup on failure.

> diff --git a/drivers/ufs/host/ufs-mediatek.c b/drivers/ufs/host/ufs-media=
tek.c
> index 5d8c02b7a857b..43fb5dbb250b0 100644
> --- a/drivers/ufs/host/ufs-mediatek.c
> +++ b/drivers/ufs/host/ufs-mediatek.c

[ ... ]

> @@ -2029,51 +2029,48 @@ static void _ufs_mtk_clk_scale(struct ufs_hba *hb=
a, bool scale_up)
>  		if (clk_bind_vcore) {
>  			ret =3D regulator_set_voltage(reg, volt, INT_MAX);
>  			if (ret) {
> -				dev_info(hba->dev,
> -					"Failed to set vcore to %d\n", volt);
> +				dev_err(hba->dev, "Failed to set vcore to %d\n", volt);
>  				goto out;

[Severity: High]
This is a pre-existing issue, but by handling the error internally and=20
returning void, _ufs_mtk_clk_scale() prevents error propagation.

If regulator_set_voltage() or clk_set_parent() fails here and jumps to out,
the calling function ufs_mtk_clk_scale() will incorrectly update the driver
state as if the operation succeeded:

drivers/ufs/host/ufs-mediatek.c:ufs_mtk_clk_scale() {
    ...
    if (scale_up)
        _ufs_mtk_clk_scale(hba, true);
    ...
    host->clk_scale_up =3D scale_up;
    ...
    clki->curr_freq =3D clki->max_freq;
}

Because ufs_mtk_clk_scale_notify() unconditionally returns 0 to the UFS
core regardless of PRE_CHANGE failures, the UFS core will proceed as if the
clock scaling completed.

Will this mismatch between the physical hardware state and the driver state
cause the UFS core to apply target frequencies to the wrong clock parent,
potentially leading to controller hangs or data corruption? Should
_ufs_mtk_clk_scale() and ufs_mtk_clk_scale() be updated to return an int so
ufs_mtk_clk_scale_notify() can properly abort the scale operation?

>  			}
>  		}

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20260901-mt8196-ufs=
-v11-0-dbd007704490@collabora.com?part=3D16
