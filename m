Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A260C3DAC13;
	Tue,  1 Sep 2026 16:08:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788278907; cv=none; b=IDYljGYfNYl/lASQ6uqIwvCfRgdoLFssNHMWcmVjSWWR5t2OUyF8TWNej66pGx0D8K2EK+zfgXTIEU7l7SkPCE3kQtSwvvudsgGzh+NRhoIFmw/tiPaDZJbgYBWIL96Yc1H/a9qEaydC+Vs5iRADOejH9t2GXK8IUs/k9v7QDjY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788278907; c=relaxed/simple;
	bh=8zlDjHOGe3rOIi7STdIg/iNBYMkehK5UEMc+PkKoB/c=;
	h=From:Subject:To:Cc:In-Reply-To:References:Content-Type:Date:
	 Message-Id; b=dFLwzXYz2FBNzX+PyQEPRaGp9LUbAHeGPlhyMleP6pzcpYTnK0GfT+4uKz1NbF2QiIhxwtLksL4VYW3Kj0vYvYamuRP6y/R8Pd85lI4C6vkAO16PsQe7Z+2Z9EgRQlXKK6IQLUr5KQv26K7KbYDVhIVTnufQ6anRnxGliTaAbNg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=ecnkQkpZ; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="ecnkQkpZ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E46181F000E9;
	Tue,  1 Sep 2026 16:08:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1788278906;
	bh=yArGgVkrnvTrfPs8c3pzi6fAqm4chPlIOUOySdlZdVw=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=ecnkQkpZjeZ15+GUFNwH2EOemvQTKL++Hi9qgNiVPRg7s/o5cuwnvSz9kQkMdg5rD
	 gdt4/l+lm96Pm9qQDB7RZVyYnfUFN9Kc3bb4Jtawfxu8BFrj4PV0Ss6YXPJjlnUUAC
	 Jt+TnI0XiSqgNUuv/I2FjuHsdZOmT4IOVAYvOky9ZHJYIXT/jRnaoZ+LfqKGIKIywt
	 3vqOwPBIodIeWA8A/3ZDDfjQT43Lz9geqeIIG5MJdUA6dLJsmWFNX7/BMrB31fYlyS
	 3K5EbSV7M6mEe/Wx3C9s2MuAz3oMnTR8zFqMlJrFuLnKM0mXVZDPPff88UbopdCCBp
	 /dOelV1QgKdPQ==
From: sashiko-bot@kernel.org
Subject: Re: [PATCH v11 09/24] scsi: ufs: mediatek: Rework init function
Reply-To: sashiko-reviews@lists.linux.dev
To: "Louis-Alexis Eyraud" <louisalexis.eyraud@collabora.com>
Cc: vkoul@kernel.org, olteanv@gmail.com, robh@kernel.org, linux-phy@lists.infradead.org, linux-scsi@vger.kernel.org, conor+dt@kernel.org, neil.armstrong@linaro.org, devicetree@vger.kernel.org
In-Reply-To: <20260901-mt8196-ufs-v11-9-dbd007704490@collabora.com>
References: <20260901-mt8196-ufs-v11-0-dbd007704490@collabora.com>
 <20260901-mt8196-ufs-v11-9-dbd007704490@collabora.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Tue, 01 Sep 2026 16:08:25 +0000
Message-Id: <20260901160825.E46181F000E9@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>

Thank you for your contribution! Sashiko AI review found 1 potential issue(=
s) to consider:

Pre-existing issues:
- [High] The return value of `ufs_mtk_mphy_power_on()` is ignored inside `u=
fs_mtk_init()`.
--

commit 2db99daf81ccd75c63d7195b2605aed5931e2cbe
Author: Nicolas Frattaroli <nicolas.frattaroli@collabora.com>

scsi: ufs: mediatek: Rework init function

The commit cleans up ufs_mtk_init() by removing unnecessary error messages,
removing the unused of_match_device() call, and returning early on errors
instead of zero-initializing an error variable.

> diff --git a/drivers/ufs/host/ufs-mediatek.c b/drivers/ufs/host/ufs-media=
tek.c
> index f298ea6f6ecb9..c5089815696fe 100644
> --- a/drivers/ufs/host/ufs-mediatek.c
> +++ b/drivers/ufs/host/ufs-mediatek.c
[ ... ]
> @@ -1301,29 +1289,19 @@ static int ufs_mtk_get_supplies(struct ufs_mtk_ho=
st *host)
>   */
>  static int ufs_mtk_init(struct ufs_hba *hba)
>  {

[Severity: High]
This isn't a bug introduced by this patch, but while reviewing this
function's error handling, I noticed the return value of
ufs_mtk_mphy_power_on() is ignored further down:

drivers/ufs/host/ufs-mediatek.c:ufs_mtk_init() {
    ...
    err =3D ufs_mtk_get_supplies(host);
    if (err)
        goto out_variant_clear;

    /*
     * ufshcd_vops_init() is invoked after
     * ufshcd_setup_clock(true) in ufshcd_hba_init() thus
     * phy clock setup is skipped.
     *
     * Enable phy clocks specifically here.
     */
    ufs_mtk_mphy_power_on(hba, true);

    if (ufs_mtk_is_rtff_mtcmos(hba)) {
    ...
}

Does ignoring the return value here lead to the driver operating on unpower=
ed
hardware if the required voltage regulators fail to enable?

ufs_mtk_mphy_power_on() calls ufs_mtk_09v_on(), which can fail if
regulator_enable() fails (returning -ENOMEM or -EIO). Proceeding as if the
phy is powered on when it is not might trigger asynchronous bus errors
on arm hardware and crash the system.

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20260901-mt8196-ufs=
-v11-0-dbd007704490@collabora.com?part=3D9
