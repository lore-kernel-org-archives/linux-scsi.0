Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4AAD53F4108
	for <linux-scsi@vger.kernel.org>; Fri, 17 Jul 2026 16:21:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784305299; cv=none; b=DuY1Pm17h5kKR17MH/wlE5BFgBkVebbfp0ws4i4eAIBYid/6N6+4Xz7LQCo+X/oFDRp1t2++9NmAa/cf6Pb71JKzkcRQrjWFRk3WshJLIulP5QEIORyPlICyml9O7dz4WerlMSenpMs0rvp/ejINfcTgS7N7V1k27s1XlkbRBNQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784305299; c=relaxed/simple;
	bh=3vZQzZU5fxJbK18IxL3AIkigR+ebov6FDuFVHj8mnh8=;
	h=From:Subject:To:Cc:In-Reply-To:References:Content-Type:Date:
	 Message-Id; b=A284kdIGNuRfidNOP1FjikHumKMe81gqzwc0zohJho2zOrmtg1TDn2Wq1ZxHlcNqk3TZZgkLxTp43zVFio16ZyHlORBpPt2O7CwwyerPFLThaZHOAu9UhxIjPqI4Y8yp6a/K8Xjdg4UswsUxo0Udx6HUTischozguFY+AaRYi8c=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=kKqQ4M2C; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="kKqQ4M2C"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id ACF8C1F000E9;
	Fri, 17 Jul 2026 16:21:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1784305297;
	bh=pqbdo/d3DP0V7nNyO4Yx8D4JXsxatTNyLiJDVLYVxT4=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=kKqQ4M2C9xpscoZwiJBYbGVKM2xF7J7QZB4OR4rqIcKQM+3EC9t3thTM6jbxYgS64
	 BnCM9tLX6mbQVJzQrib3iz7CL+c8lx7+hY37vaELeiVRVDuiC1ElBcKWBM8RiT2G5T
	 gLMolFfH1Gx0Rt6tl19lC6UPDi+ayDD8VOGOflWP4rTopyoyyKfw7j2fs6r2Un11G5
	 IZmEN7GA71LwmFtKTUVix8EI50nun9jOKRTGdofIBI9KzHG/SDqSPkLgV+mVfDhCL6
	 Wie4Z8hL7xJLFVfMkKKvzJRlWAwYemV/WrpfYgn3KVyWZxEYflg/KhBdeIMsLPzUeM
	 /lX19plr30Q5w==
From: sashiko-bot@kernel.org
Subject: Re: [PATCH v2 3/6] scsi: ufs: core: Validate connected lane counts
Reply-To: sashiko-reviews@lists.linux.dev
To: "Li Qiang" <liqiang01@kylinos.cn>
Cc: linux-scsi@vger.kernel.org
In-Reply-To: <20260717153914.26321-4-liqiang01@kylinos.cn>
References: <cover.1784182493.git.liqiang01@kylinos.cn>
 <20260717153914.26321-1-liqiang01@kylinos.cn>
 <20260717153914.26321-4-liqiang01@kylinos.cn>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Fri, 17 Jul 2026 16:21:37 +0000
Message-Id: <20260717162137.ACF8C1F000E9@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>

Thank you for your contribution! Sashiko AI review found 1 potential issue(=
s) to consider:

Pre-existing issues:
- [High] Missing bounds check on untrusted `tx_lanes` value read from the d=
evice in `ufshcd_disable_tx_lcc` could lead to an excessive loop and kernel=
 hang.
--

--- Patch [3]: [PATCH v2 3/6] scsi: ufs: core: Validate connected lane coun=
ts ---
commit a03fd44c15e264d545e15508efe3bce7ec4082a8
Author: Li Qiang <liqiang01@kylinos.cn>

scsi: ufs: core: Validate connected lane counts

This commit updates ufshcd_get_max_pwr_mode() to validate that RX and TX
lane counts read from the device do not exceed UFS_MAX_LANES. It ensures
these counts are bounded before they are propagated.

> diff --git a/drivers/ufs/core/ufshcd.c b/drivers/ufs/core/ufshcd.c
> index d1b989abc9e2d..bbadddcd661a0 100644
> --- a/drivers/ufs/core/ufshcd.c
> +++ b/drivers/ufs/core/ufshcd.c
> @@ -4729,7 +4729,9 @@ static int ufshcd_get_max_pwr_mode(struct ufs_hba *=
hba)
>  	ufshcd_dme_get(hba, UIC_ARG_MIB(PA_CONNECTEDTXDATALANES),
>  			&pwr_info->lane_tx);
> =20
> -	if (!pwr_info->lane_rx || !pwr_info->lane_tx) {
> +	if (!pwr_info->lane_rx || !pwr_info->lane_tx ||
> +	    pwr_info->lane_rx > UFS_MAX_LANES ||
> +	    pwr_info->lane_tx > UFS_MAX_LANES) {
>  		dev_err(hba->dev, "%s: invalid connected lanes value. rx=3D%d, tx=3D%d=
\n",
>  				__func__,
>  				pwr_info->lane_rx,

[Severity: High]
This isn't a bug introduced by this patch, but since we are adding bounds
checking for PA_CONNECTEDTXDATALANES here, is it possible we need similar
validation in ufshcd_disable_tx_lcc()?

When ufshcd_disable_tx_lcc() reads the connected TX lane count, it uses the
value directly as a loop boundary:

drivers/ufs/core/ufshcd.c:ufshcd_disable_tx_lcc() {
	...
	if (!peer)
		ufshcd_dme_get(hba, UIC_ARG_MIB(PA_CONNECTEDTXDATALANES),
			       &tx_lanes);
	else
		ufshcd_dme_peer_get(hba, UIC_ARG_MIB(PA_CONNECTEDTXDATALANES),
				    &tx_lanes);
	for (i =3D 0; i < tx_lanes; i++) {
	...
}

If a malicious endpoint or UniPro link error causes the read to return an
abnormally large integer, the code could enter an unvalidated loop.

If the endpoint continuously returns success to the synchronous
ufshcd_dme_peer_set() commands inside the loop, could this force the kernel
to execute an excessive number of slow hardware commands?

This might potentially block the probe or error handler thread and result
in a kernel hang.

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20260717153914.2632=
1-1-liqiang01@kylinos.cn?part=3D3
