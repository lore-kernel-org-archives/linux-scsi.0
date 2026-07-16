Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 73BED33DED5
	for <linux-scsi@vger.kernel.org>; Thu, 16 Jul 2026 08:52:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784191933; cv=none; b=TwDyRFCvVZXdADbMATSr8VYM8EUvzjTUA09qi6yFBvi421n9IS/+IYyzAtioiY+fFr/kGXUDFKjAbFXJ4fX+sr3b5NIUN9J9oICkTLJ5zIh3F9YvKsGqd8yu3htO3Z3JXIKJ+AQT8rHlzRg5GIiVW1EO1sdKckI3gg9jhcWjucI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784191933; c=relaxed/simple;
	bh=5yPm1O3cpPxkMhMyDLB5swQVm25coqIJvNDvE4sEyYM=;
	h=From:Subject:To:Cc:In-Reply-To:References:Content-Type:Date:
	 Message-Id; b=az2JTdXJrgLJ5w6Xsh6+z1ONgb3IZZ0idXdIC++sP1cn6AMPdEJsViyjz7K43gYcpQJu17/1b9p+y30jeZT72IiAqTALhaV0XKmFeYSQkrdAPd9TkaYO53RTFtTKjJn95k6VmX8+TqHzQYoSL7RP9/UyowGSdZqSr5ZDTv+uiTY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=liLJ77RE; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="liLJ77RE"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1DD571F00A3A;
	Thu, 16 Jul 2026 08:52:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1784191930;
	bh=WYx1mrNAQ6XP3axP4PJpaW7t07W34QbC2FoPRR2+dJY=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=liLJ77RE//h9XnnJU932PvKHza+ckaAtbSbPe6/vG0Nlh91fQ3U4TeCqbXIVcLsNS
	 fEx6M9f8MpiR9siu9GGAwUVSvWlezn0wYI5Y4B/dFmzxF5aRGiwikqBndnd7OXUYrU
	 hFl1fgLJXrSWUuzfumgv4GfeGWV8BXPXWF94aKjcajJ3EKEpLlNf1ttQHJIcqCz0W/
	 1eF3IMgZw38vYeJOBgnBVpMr3YpzGczhEBSjtIyStYvVAZLC9k633hXfsH9nKefWz6
	 olDMplVp76RPZnyItwLTxSypqdyABgT0T9Z91FzOrxyZe0NLatoALiTpviBq7KAfUM
	 1S0gXyhvH/Azg==
From: sashiko-bot@kernel.org
Subject: Re: [PATCH v1 2/2] ufs: rpmb: use a fixed-length RPMB dev_id
Reply-To: sashiko-reviews@lists.linux.dev
To: "Jorge Ramirez-Ortiz" <jorge.ramirez@oss.qualcomm.com>
Cc: linux-scsi@vger.kernel.org
In-Reply-To: <20260716083728.2226422-3-jorge.ramirez@oss.qualcomm.com>
References: <20260716083728.2226422-1-jorge.ramirez@oss.qualcomm.com>
 <20260716083728.2226422-3-jorge.ramirez@oss.qualcomm.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Thu, 16 Jul 2026 08:52:09 +0000
Message-Id: <20260716085210.1DD571F00A3A@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>

Thank you for your contribution! Sashiko AI review found 2 potential issue(=
s) to consider:

Pre-existing issues:
- [High] The `ufs_rpmb->dev` device release function is structurally preven=
ted from running, leaking RPMB child devices and their associated memory.
- [High] The `struct ufs_rpmb_dev` embeds a refcounted `struct device` but =
is allocated via `devm_kzalloc()`, leading to a use-after-free.
--

--- Patch [2]: [PATCH v1 2/2] ufs: rpmb: use a fixed-length RPMB dev_id ---
commit b0359490487ec8ad9999a553b0e7ff80b787f32c
Author: Jorge Ramirez-Ortiz <jorge.ramirez@oss.qualcomm.com>

ufs: rpmb: use a fixed-length RPMB dev_id

This commit modifies the UFS RPMB driver to generate a fixed 16-byte
device ID by hashing the variable-length UFS device ID and region string
using blake2s. This aligns the UFS device ID length with the eMMC CID
format, allowing OP-TEE's key derivation to work without modification.

> diff --git a/drivers/ufs/core/ufs-rpmb.c b/drivers/ufs/core/ufs-rpmb.c
> index d0c7ea7a36f49..b800871269bb3 100644
> --- a/drivers/ufs/core/ufs-rpmb.c
> +++ b/drivers/ufs/core/ufs-rpmb.c
[ ... ]
> @@ -154,6 +156,7 @@ int ufs_rpmb_probe(struct ufs_hba *hba)
>  {
>  	struct ufs_rpmb_dev *ufs_rpmb, *it, *tmp;

[Severity: High]
This is a pre-existing issue, but does embedding a refcounted struct device
in a devres-managed allocation lead to a use-after-free?

The ufs_rpmb structure is allocated via devm_kzalloc() in the probe loop.
Its lifecycle is tied to the host controller's devres, which frees the
memory when the controller unbinds.

However, the embedded struct device is refcounted independently. If any
references (such as sysfs files) remain when devres frees the structure,
the final reference drop will attempt to access the already-freed struct
device to call ufs_rpmb_device_release(), leading to a use-after-free.

>  	struct rpmb_dev *rdev;
> +	char *dev_id =3D NULL;
>  	char *cid =3D NULL;
[ ... ]
> @@ -240,6 +254,7 @@ int ufs_rpmb_probe(struct ufs_hba *hba)
>  	return 0;
>  err_out:
>  	kfree(cid);
> +	kfree(dev_id);
>  	list_for_each_entry_safe(it, tmp, &hba->rpmbs, node) {
>  		list_del(&it->node);
>  		device_unregister(&it->dev);

[Severity: High]
This is a pre-existing issue, but does this error path permanently leak
RPMB child devices and their associated memory?

The rpmb_dev_register() call creates a child device (rdev) with
ufs_rpmb->dev as its parent, which automatically takes a reference on the
parent.

When device_unregister(&it->dev) is called here, the parent's refcount
does not drop to zero because the child still holds a reference. This
prevents ufs_rpmb_device_release() from ever running, meaning
rpmb_dev_unregister() is never called for the child, forming an
unbreakable circular dependency.

>  	}

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20260716083728.2226=
422-1-jorge.ramirez@oss.qualcomm.com?part=3D2
