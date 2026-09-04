Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6BF4444237A
	for <linux-scsi@vger.kernel.org>; Fri,  4 Sep 2026 11:15:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788520501; cv=none; b=gJi6teHF9tnNTsRRPBeV3BnkrqlJ8+PisIotaNTmBs8JhRQU7wRlGaxTJ6gQS9XC6CvKRam7oz+rj8xz9icevP5EGL3L7K99NXSY/Ao376SV+HKq9vrWhgInxBIoiJ50WFmiAkNCDX2poJ3IWONUffWUcdG8dT2XBXoFoweAZoo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788520501; c=relaxed/simple;
	bh=xLahlQXCjoPIJuk4y0UstapXMP/bwGARju4ZjNsyHYg=;
	h=From:Subject:To:Cc:In-Reply-To:References:Content-Type:Date:
	 Message-Id; b=atSoLU3n4HeakA9I3eGOvLEy2jcTOYu7bxJvtUffk+uw5mjVXCBQkUBb19Mv2B/EvZYbQ1kD7mxOzdQ6GHhLTQL11/w0AexlgSTnUJRF/mUrk0v/HJ7zElh3bAAuGzqVIeicvFK6WdvrdVmRH991YuluihJAGiBimhpFSja86ks=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=NhAZd8eo; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="NhAZd8eo"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C43FC1F00A3D;
	Fri,  4 Sep 2026 11:14:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1788520500;
	bh=zF9zQ2ecHCemLkb4kFNYqR1lZfwbI8efiIx/UVKqW2g=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=NhAZd8eoIK2dDvDAMy/oiHaUjg5Q5vTukq6LVMonxWVc6TlI+iWPCDRZiyMPQdNsh
	 ehg8tIJ94sC5QEcy8oDVidUZ05yCBswglETcmwF+jUDFDtBfgSrwdhVL/CiX9/eQzj
	 9fiupqggJPDl18RGWJDcgCwdV94VqrREwMgEckifKPr9ankWafgxLUMjdX8yF+KXSS
	 KHXFBsc6I7nWnl5anVtEO6Ha5livieZIVH8GEh1jsy8hw9kll+Hvlpk5dbyhdp/NMk
	 1+RBgK3rUkb3o/z5JPp3DWNrfd89QEwETa0gg3X5tduCbd85oUM5JZ+RBJlrk3ExJi
	 76SnR4tVk+Svg==
From: sashiko-bot@kernel.org
Subject: Re: [PATCH 1/2] scsi: ufs: rpmb: Decouple device lifecycle from
 devres to avoid UAF
Reply-To: sashiko-reviews@lists.linux.dev
To: "Stanley Jhu" <stanleyjhu@google.com>
Cc: linux-scsi@vger.kernel.org
In-Reply-To: <20260904110017.3444852-2-stanleyjhu@google.com>
References: <20260904110017.3444852-1-stanleyjhu@google.com>
 <20260904110017.3444852-2-stanleyjhu@google.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Fri, 04 Sep 2026 11:14:59 +0000
Message-Id: <20260904111459.C43FC1F00A3D@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>

Thank you for your contribution! Sashiko AI review found 1 potential issue(=
s) to consider:

Pre-existing issues:
- [Critical] The patch fails to fully resolve the Use-After-Free (UAF) duri=
ng concurrent RPMB accesses. The refcount-based lifecycle fix assumes the R=
PMB subsystem safely pins the parent device (`ufs_rpmb->dev`) for the lifet=
ime of the RPMB device (`rdev`), but it drops this reference prematurely.
--

commit 21fd8683771415df1dde0fd462d6c27a0d117593
Author: Stanley Jhu <stanleyjhu@google.com>
Subject: scsi: ufs: rpmb: Decouple device lifecycle from devres to avoid UAF

This commit decouples the ufs_rpmb_dev lifecycle from devres, replacing it
with standard device reference counting via the release callback. It also
ensures the underlying SCSI device is pinned while the RPMB device exists,
and corrects subsystem teardown paths.

> diff --git a/drivers/ufs/core/ufs-rpmb.c b/drivers/ufs/core/ufs-rpmb.c
> index aa925cbb07e86..4f41d0b64d208 100644
> --- a/drivers/ufs/core/ufs-rpmb.c
> +++ b/drivers/ufs/core/ufs-rpmb.c
[ ... ]
> @@ -242,14 +257,13 @@ void ufs_rpmb_remove(struct ufs_hba *hba)
> =20
>  	/* Remove all registered RPMB devices */
>  	list_for_each_entry_safe(ufs_rpmb, tmp, &hba->rpmbs, node) {
> -		dev_info(hba->dev, "Removing UFS RPMB region %d\n", ufs_rpmb->region_i=
d);
> -		/* Remove from list first */
> -		list_del(&ufs_rpmb->node);
> -		/* Unregister device */
> +		list_del_init(&ufs_rpmb->node);
> +		if (ufs_rpmb->rdev) {
> +			rpmb_dev_unregister(ufs_rpmb->rdev);
> +			ufs_rpmb->rdev =3D NULL;
> +		}
>  		device_unregister(&ufs_rpmb->dev);
>  	}
> -
> -	dev_info(hba->dev, "All UFS RPMB devices unregistered\n");
>  }

[Severity: Critical]
This is a pre-existing issue, but does device_unregister() here prematurely
drop the refcount on ufs_rpmb->dev?

If an external client (like OP-TEE) has grabbed a reference to the RPMB
device via rpmb_dev_get(), it pins rdev. However, the implicit parent
reference held by rdev is dropped synchronously during rpmb_dev_unregister(=
).
The subsequent call to device_unregister(&ufs_rpmb->dev) can drop
ufs_rpmb->dev's refcount to zero, freeing ufs_rpmb.

When OP-TEE later submits a request, it calls rpmb_route_frames() in
drivers/misc/rpmb-core.c with the dangling parent pointer:

	return rdev->descr.route_frames(rdev->dev.parent, req, req_len,
					rsp, rsp_len);

This dangling pointer is then passed into ufs_rpmb_route_frames() in
drivers/ufs/core/ufs-rpmb.c:

	struct ufs_rpmb_dev *ufs_rpmb =3D dev_get_drvdata(dev);

Does this sequence still result in a use-after-free despite the new
refcount-based lifecycle?

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20260904110017.3444=
852-1-stanleyjhu@google.com?part=3D1
