Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5A93B2C11CF
	for <linux-scsi@vger.kernel.org>; Thu, 16 Jul 2026 06:28:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784183302; cv=none; b=WeSwfdNfGsc20k/NhAhLmWINRtfPGSEWRzj0szIpgMqYc04oIyzR58fwFOW5YxSK9wmDdBaIOd67UYXIUooUta6byPgb0P2eAmsoiARPTy//F8r9WQhsXBuKSQdXNvT+NJnOIkqNs24T99m6hhvdP5etHi4HVx5F5X+ctRLxnj8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784183302; c=relaxed/simple;
	bh=plnT+Bkd2R7MmUs3eHOD+s6BDZx8JArjicTBBed/HN4=;
	h=From:Subject:To:Cc:In-Reply-To:References:Content-Type:Date:
	 Message-Id; b=Gsj584a7lrXsIFw2Pr94CIuzaAQbd/HxV4kNieGbXM8tqjgzoG9dKKJus4US/0BN5aPu3e8A8UeTOotay/SRKO6YfgAkbRaeInOZ8ktHlY3JFMlFExthzEq0uVk02soQmqkWK9+UeRAnHgMJPVd+8ylBbY+EJyjcTq0ADGA/JHc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=fNFULlHf; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="fNFULlHf"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1F9C41F000E9;
	Thu, 16 Jul 2026 06:28:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1784183299;
	bh=M9RmUQRGAXWEeWjMyZL7WayR+sjb9ADp1AF2na4jB2c=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=fNFULlHfip60eU715lh7zvfj8oO14esV/+c4tYv5dFUgY9SolzAVj0MPafPSCJ8vO
	 YdbNDCHIOmuTd4UnY1f35R15mHwKcsjZ/isKTrbKJbD9XvaDlhZRrt3NqHwF82MdLw
	 LuQ8/rTXvp3C9uhfDC5BKl5V6Hw07TSL3v52IxLmx5n+NMKCnPReMY6PN03zG97x/w
	 3mRNXqv6YOhsY/702kx6Fu6CJE+ayn7djH60quiivUUpkLLnkfZVfpKIfQvRU7aE4e
	 h+5hsHG3G/Ep3YCLnXFWOG19TgXd5mmG3+u89q89Ox+DGlfnbK+lHQiQ+yirA2CYtH
	 RQfJvoZ6t95jg==
From: sashiko-bot@kernel.org
Subject: Re: [PATCH 4/5] scsi: ufs: rpmb: Validate frame before parsing
Reply-To: sashiko-reviews@lists.linux.dev
To: liqiang <liqiang01@kylinos.cn>
Cc: linux-scsi@vger.kernel.org
In-Reply-To: <70412f5cb24714052127ada81a7aac0f9d86000e.1784182493.git.liqiang01@kylinos.cn>
References: <cover.1784182493.git.liqiang01@kylinos.cn>
 <70412f5cb24714052127ada81a7aac0f9d86000e.1784182493.git.liqiang01@kylinos.cn>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Thu, 16 Jul 2026 06:28:18 +0000
Message-Id: <20260716062819.1F9C41F000E9@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>

Thank you for your contribution! Sashiko AI review found 1 potential issue(=
s) to consider:

Pre-existing issues:
- [High] The UFS RPMB driver mismanages the lifecycle of `struct ufs_rpmb_d=
ev`, resulting in Use-After-Free (UAF) vulnerabilities during teardown and =
unbind operations. This problem wasn't introduced by this patch, but it is =
a critical flaw in the driver's device management.
--

--- Patch [4]: [PATCH 4/5] scsi: ufs: rpmb: Validate frame before parsing -=
--
commit 52562de70e8a3a9ec694967f1ae0889763de9535
Author: Li Qiang <liqiang01@kylinos.cn>

scsi: ufs: rpmb: Validate frame before parsing
   =20
This commit validates the request length before accessing req_resp at the
end of the first request frame. It also uses unaligned accessors for safe
access to the RPMB buffers.

> diff --git a/drivers/ufs/core/ufs-rpmb.c b/drivers/ufs/core/ufs-rpmb.c
> index ffad049872b9a..53f66b274acac 100644
> --- a/drivers/ufs/core/ufs-rpmb.c
> +++ b/drivers/ufs/core/ufs-rpmb.c

[ ... ]

> @@ -69,7 +69,11 @@ static int ufs_rpmb_route_frames(struct device *dev, u=
8 *req, unsigned int req_l
> =20
>  	hba =3D ufs_rpmb->hba;
> =20
> -	req_type =3D be16_to_cpu(frm_out->req_resp);
> +	/* req_resp is at the end of an RPMB frame. */
> +	if (req_len < sizeof(*frm_out))
> +		return -EINVAL;
> +
> +	req_type =3D get_unaligned_be16(&frm_out->req_resp);

[Severity: High]
This isn't a bug introduced by this patch, but while reviewing this file I
noticed a pre-existing issue with the lifecycle management of ufs_rpmb_dev.

Can this lead to a use-after-free during device unbind? The struct is
allocated using devm_kzalloc():

drivers/ufs/core/ufs-rpmb.c:ufs_rpmb_probe() {
    ...
    ufs_rpmb =3D devm_kzalloc(hba->dev, sizeof(*ufs_rpmb), GFP_KERNEL);
    ...
}

But it embeds a reference-counted struct device. When the UFS host controll=
er
unbinds, the devres cleanup executes and frees ufs_rpmb_dev. If a user-space
process holds a sysfs reference to the UFS RPMB device, the delayed
release callback will later access this freed memory:

drivers/ufs/core/ufs-rpmb.c:ufs_rpmb_device_release() {
    ...
    rpmb_dev_unregister(ufs_rpmb->rdev);
    ...
}

Additionally, because rpmb_dev_unregister() is called asynchronously in the
.release callback rather than synchronously in ufs_rpmb_remove():

drivers/ufs/core/ufs-rpmb.c:ufs_rpmb_remove() {
    ...
    device_unregister(&ufs_rpmb->dev);
    ...
}

Could the RPMB core issue requests to a fully torn-down UFS host controller?

Should rpmb_dev_unregister() be moved to ufs_rpmb_remove(), and should
ufs_rpmb_dev be freed with kfree() inside ufs_rpmb_device_release() instead
of relying on devm?

[ ... ]

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/cover.1784182493.gi=
t.liqiang01@kylinos.cn?part=3D4
