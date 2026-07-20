Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A99F03D45C1
	for <linux-scsi@vger.kernel.org>; Mon, 20 Jul 2026 09:28:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784539707; cv=none; b=P2MxxgPF90QvbaNeTRY4k5RvDxKT8Vct97c2DwiIDDvZ3CNDNsA4jOLSykDAcV9ex4MgM+Sv/186DKtCDIaFDzoqFXZmHLHUKQI6DXrYjXXBpSPNhFfge/4lC2bn4w6oEUx3eYrtiIHjTxwWiU6IBjFtXUyUJzQiCtHC5ZQZQ1Q=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784539707; c=relaxed/simple;
	bh=ikx1LdDNvMWUfwe3BSna2NMt2ZRbdhmK0Vi+73R/NPM=;
	h=From:Subject:To:Cc:In-Reply-To:References:Content-Type:Date:
	 Message-Id; b=tTsRJUN7Gd1MbjNjzXOm1Sb+dTrHInY4EQ1iBjnw2wK1pXC75F5FvA+fCxrybi6wn7XxM7hq7jPi2sV+Jz5af2tSHIsN9PgiQlcmCl9exU/CshMAUbx4KsThOjwjG4voCrADoCWT0KPkjrX2PoJEavAZrY6lMyIpvJqoSuj0Jyc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=mWhLt+3N; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="mWhLt+3N"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6C5D41F000E9;
	Mon, 20 Jul 2026 09:28:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1784539706;
	bh=hvuD7AFH7GF28dXOYWo2GvHwzsUh73pHk6/GVj8GxVI=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=mWhLt+3N2EBDvgJpQIfb+MbL6JFo+DgcgIWNcJ77r+rBse/QN2+548WyeXy0OgeIy
	 Unkp9tjx0lOekqSnLx4XANL8ZJloLooTUQkLbSVF5Mkzw54fS3KzL0N6SIytYp9Qr+
	 zGvH0eTB7KNo0Bx/AxvvEUxHGXpcra0bUyMFloG58YSjj3Jd8+x6uI3mqhVlMsaZGJ
	 AsIXPWRj4MyhF/VxQ/uNyst1uv+AtvOZ1o4Bl6qJRUPn6wKiv9QBK0UgAVG75J6LA4
	 d87Vl+7Sgyfwp4QvQnvSAhgUl9biNWMrP83FgiX0K1OVYeGaVC7Be5yuAMsP/ZG9DY
	 2dmJfIqE0l1Zg==
From: sashiko-bot@kernel.org
Subject: Re: [PATCH v2 2/2] ufs: rpmb: use a fixed-length RPMB dev_id
Reply-To: sashiko-reviews@lists.linux.dev
To: "Jorge Ramirez-Ortiz" <jorge.ramirez@oss.qualcomm.com>
Cc: linux-scsi@vger.kernel.org
In-Reply-To: <20260720091614.544968-3-jorge.ramirez@oss.qualcomm.com>
References: <20260720091614.544968-1-jorge.ramirez@oss.qualcomm.com>
 <20260720091614.544968-3-jorge.ramirez@oss.qualcomm.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Mon, 20 Jul 2026 09:28:26 +0000
Message-Id: <20260720092826.6C5D41F000E9@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>

Thank you for your contribution! Sashiko AI review found 3 potential issue(=
s) to consider:

Pre-existing issues:
- [High] Use-After-Free on device unbind due to devm_kzalloc used for struc=
t embedding a device
- [High] Circular dependency between parent and child devices prevents clea=
nup and causes resource leak
- [High] NULL pointer dereference in ufs_rpmb_remove if ufs_rpmb_probe bail=
s out early
--

--- Patch [2]: [PATCH v2 2/2] ufs: rpmb: use a fixed-length RPMB dev_id ---
commit 2720876781cfffc7b6138bf9c11da0d2249234f9
Author: Jorge Ramirez-Ortiz <jorge.ramirez@oss.qualcomm.com>

ufs: rpmb: use a fixed-length RPMB dev_id

The RPMB authentication key is derived from the dev_id handed to the
RPMB subsystem. This commit hashes the variable-length UFS id into a fixed
16-byte dev_id using blake2b to match the eMMC CID layout OP-TEE relies on.

> diff --git a/drivers/ufs/core/ufs-rpmb.c b/drivers/ufs/core/ufs-rpmb.c
> index d0c7ea7a36f49..0d8399b6497a1 100644
> --- a/drivers/ufs/core/ufs-rpmb.c
> +++ b/drivers/ufs/core/ufs-rpmb.c

[ ... ]

> @@ -154,6 +156,7 @@ int ufs_rpmb_probe(struct ufs_hba *hba)
>  {
>  	struct ufs_rpmb_dev *ufs_rpmb, *it, *tmp;
>  	struct rpmb_dev *rdev;
> +	char *dev_id =3D NULL;
>  	char *cid =3D NULL;

[Severity: High]
This isn't a bug introduced by this patch, but does the early return in
ufs_rpmb_probe() leave the rpmbs list head uninitialized?

If the function returns early due to a missing device ID:

drivers/ufs/core/ufs-rpmb.c:ufs_rpmb_probe() {
    if (!hba->dev_info.device_id) {
        dev_err(hba->dev, "UFS Device ID not available\n");
        return -EINVAL;
    }

    INIT_LIST_HEAD(&hba->rpmbs);
    ...
}

When ufs_rpmb_remove() is later called on driver unbind, list_empty()
evaluates to false because hba->rpmbs is completely zeroed out rather than
pointing to itself. This causes a NULL pointer dereference when traversing
the list:

drivers/ufs/core/ufs-rpmb.c:ufs_rpmb_remove() {
    if (list_empty(&hba->rpmbs))
        return;

    list_for_each_entry_safe(ufs_rpmb, tmp, &hba->rpmbs, node) {
    ...
}

[Severity: High]
This is a pre-existing issue, but does using devm_kzalloc() for a structure
that embeds a device cause a use-after-free on driver unbind?

drivers/ufs/core/ufs-rpmb.c:ufs_rpmb_probe() {
    ...
    ufs_rpmb =3D devm_kzalloc(hba->dev, sizeof(*ufs_rpmb), GFP_KERNEL);
    ...
    device_register(&ufs_rpmb->dev);
    ...
}

If a userspace process opens a sysfs file for this device, the device
reference count is elevated. If the UFS driver is unbound at this point,
devres will automatically free the ufs_rpmb structure.

Later, when the sysfs file is closed, the device core drops the final
reference and calls ufs_rpmb_device_release(), which accesses the
already-freed memory:

drivers/ufs/core/ufs-rpmb.c:ufs_rpmb_device_release() {
    struct ufs_rpmb_dev *ufs_rpmb =3D dev_get_drvdata(dev);

    rpmb_dev_unregister(ufs_rpmb->rdev);
}

Should ufs_rpmb be allocated with a standard kzalloc() and explicitly freed
in the device release callback instead?

[Severity: High]
This is a pre-existing issue, but is there a circular dependency preventing
the release callback from ever running?

The child device (rdev) holds a reference to its parent (ufs_rpmb->dev).
However, the child is only unregistered in the parent's release callback:

drivers/ufs/core/ufs-rpmb.c:ufs_rpmb_device_release() {
    struct ufs_rpmb_dev *ufs_rpmb =3D dev_get_drvdata(dev);

    rpmb_dev_unregister(ufs_rpmb->rdev);
}

During driver unbind, only the parent device is unregistered:

drivers/ufs/core/ufs-rpmb.c:ufs_rpmb_remove() {
    ...
    list_for_each_entry_safe(ufs_rpmb, tmp, &hba->rpmbs, node) {
        ...
        device_unregister(&ufs_rpmb->dev);
    }
}

Because the child is left registered, it continues to hold a reference to
the parent. As a result, the parent's reference count never reaches zero,
ufs_rpmb_device_release() is never called, and the device structures are
leaked.

Should the child device be explicitly unregistered in ufs_rpmb_remove()
before unregistering the parent?

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20260720091614.5449=
68-1-jorge.ramirez@oss.qualcomm.com?part=3D2
