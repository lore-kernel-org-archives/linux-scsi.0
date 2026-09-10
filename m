Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5CFDF2931C1
	for <linux-scsi@vger.kernel.org>; Thu, 10 Sep 2026 02:09:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789006159; cv=none; b=ZWbeLda4MBI1Fn/v2vqp67OxIFNVxqsC3oFg0mh0Lskby+Gb+Jwk18kc9Qyk6dPoFBbzUDZcvcqpDtnZlXm+yW4W+FRgZdZr9+vmWw2zuFkdcbpC2iQhlTD+KuiVDD6saeMNX4AG7yxlAzfSoHLSqZUwrBXV0ujbs+SR6m5sUG8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789006159; c=relaxed/simple;
	bh=l8zmk7012eKFZkmUvE27WmmbKBNk/Ki8uw2BxAVN668=;
	h=From:Subject:To:Cc:In-Reply-To:References:Content-Type:Date:
	 Message-Id; b=O6G+e2QlfmGOIZrjk78LQhYmvlJIMISKrdbOit+hllElDWyflt4UBHVopaxAF6YPK0EpN1IWxxYMC+bjfw4fK+PkF9J0l1AoCz7ImXg5WXk7qmiKO/VksxbvGofyW0+YKVHdbLjZleLE8VujyftMGj3iNCdX0PZLcy/LHRItlD0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=hQUiBtf7; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="hQUiBtf7"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C22961F000FF;
	Thu, 10 Sep 2026 02:09:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1789006158;
	bh=4VUiefbUCx68js855eDd67qvMMfJp3aUcw5D8KQfIGo=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=hQUiBtf7PIhSwaf8QYEzWetImbYpQboCyEHDRNYUmi0kl6VMEfU2o9iDYbpSKyrFS
	 HasrDYRXhBnt92M1KZ5cuzooNfYA3F6iyLCn7PrFB1lO05Mlq1WSH/N4eYnbODRODK
	 rt5i5GGNoM9ig9WVghiD6/spwNlvvf7kAN/WmsedyOoGtyETVmXyXkzTAly3xwcs17
	 XvJXcRsBj2zR4xKE6mBc5SXhHDxFWKGjqC5FaVf+BGUxI5A7Kd10AnkSJrdp4S2vZQ
	 pUQRo52oLyzRUZG+L9Vkr6nLSUjFzOrnlMlSQ7autPrHsA1bnEhEhOVRVFUstdJg58
	 J33/08R54E57g==
From: sashiko-bot@kernel.org
Subject: Re: [PATCH v3 2/2] scsi: ufs: rpmb: Decouple device lifecycle from
 devres to avoid UAF
Reply-To: sashiko-reviews@lists.linux.dev
To: "Stanley Jhu" <stanleyjhu@google.com>
Cc: linux-scsi@vger.kernel.org
In-Reply-To: <20260910015503.1991119-3-stanleyjhu@google.com>
References: <20260910015503.1991119-1-stanleyjhu@google.com>
 <20260910015503.1991119-3-stanleyjhu@google.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Thu, 10 Sep 2026 02:09:17 +0000
Message-Id: <20260910020917.C22961F000FF@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>

Thank you for your contribution! Sashiko AI review found 1 potential issue(=
s) to consider:

Pre-existing issues:
- [Critical] This problem wasn't introduced by this patch, but the patch fa=
ils to resolve the pre-existing Use-After-Free during device removal. The d=
evice model's `device_del()` drops the parent reference, meaning `rdev->dev=
.parent` becomes a dangling pointer if a consumer holds a reference to `rde=
v`.
--

commit 19c2abff2bd57dbeee481738657ea4d9e1123a19
Author: Stanley Jhu <stanleyjhu@google.com>

scsi: ufs: rpmb: Decouple device lifecycle from devres to avoid UAF

This commit changes the allocation of the UFS RPMB device from devres to
a reference-counted lifecycle. It also explicitly unregisters the RPMB
child device during host removal before unregistering the parent device
to prevent memory safety issues.

Cc: stable@vger.kernel.org

> diff --git a/drivers/ufs/core/ufs-rpmb.c b/drivers/ufs/core/ufs-rpmb.c
> index c7aade96c823e..33b9a4a1b120e 100644
> --- a/drivers/ufs/core/ufs-rpmb.c
> +++ b/drivers/ufs/core/ufs-rpmb.c

[ ... ]

> @@ -252,14 +266,13 @@ void ufs_rpmb_remove(struct ufs_hba *hba)
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

[Severity: Critical]
This isn't a bug introduced by this patch, but does this sequence still
leave a use-after-free window during device removal?

When rpmb_dev_unregister() is called, it internally calls device_del() on
the child device, which immediately drops the reference to its parent device
(ufs_rpmb->dev).

If a consumer is actively holding a reference to the child device via
rpmb_dev_get(), the child device itself remains allocated. However, the
subsequent call to device_unregister() here drops the final reference to
the parent ufs_rpmb structure, causing it to be freed.

If the consumer then concurrently executes a request, the framework will
pass the now-dangling parent pointer to the route_frames callback:

drivers/ufs/core/ufs-rpmb.c:ufs_rpmb_route_frames() {
    struct ufs_rpmb_dev *ufs_rpmb =3D dev_get_drvdata(dev);
    ...
}

Could this dev_get_drvdata(dev) dereference the freed parent memory,
resulting in a use-after-free despite the new lifecycle management?

>  	}
> -
> -	dev_info(hba->dev, "All UFS RPMB devices unregistered\n");
>  }
> =20
>  MODULE_LICENSE("GPL v2");

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20260910015503.1991=
119-1-stanleyjhu@google.com?part=3D2
