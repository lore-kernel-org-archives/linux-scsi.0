Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0618F35CB95
	for <linux-scsi@vger.kernel.org>; Thu, 23 Jul 2026 03:57:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784779050; cv=none; b=P1muGQIFi0CL0p5KgWXzvBLx8vZhORti4/vsC1nM6TCNHJZ/BRI1tu/1U4uCI6v18af90+KMs1sQ9CkN5lBfwhkMalJ7Qereh4obl9ZGqYhOuIVkzUAP4AKIB5jP4vpv7WSgTXnzl/Ebq93xQq+xKNolnkmDlrZmvw1PaqvHRDY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784779050; c=relaxed/simple;
	bh=xVZ8w8jb/rnuWchnwV8q83zNNSoAZDIsHCsqcHF09ws=;
	h=From:Subject:To:Cc:In-Reply-To:References:Content-Type:Date:
	 Message-Id; b=uafHueajNC6+sXCQFeCwjxnM3bXBMDniFfhmKnpRxv18QEhRkYG9bkb7POOZrsiu/HGOciEXg52vDvJL5LLcd3yX2zOz9/IfWX0mU7v92C3VVS/mxOEJ9qvQXwg7eyZ38tzx1+UURSyfewiT17R5gAv+hxh8aLLWYkM9fU2dAvQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=nWnglTGA; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="nWnglTGA"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 46F8E1F000E9;
	Thu, 23 Jul 2026 03:57:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1784779047;
	bh=fSUCFZ6Jf6Jd1hWBceFQepO9BTCl/55TzbsU1EseH/I=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=nWnglTGAo6QEWYRtPlDNz4HsvOn7YjwSt3Z64sWJPIfyDtMcVbTsh4NE/jrVXXoER
	 W8rfs0iTrE3oZt4A/AOSZCrz1pmy03zK1k3IGsB3ZN9rhXoNzRs55KW1KTVAC4LWfD
	 NablS+v8y4/DOfMSzcX5v8KXMFSWPef91nJSFroL53j49ycSbChsLXpoPZveTdTuVr
	 awu6/iF8kAJX0v6f1fpWX10BGC9eXZ/asx2B9MoEC6McnDIQis914RSuFd+M6aFqbW
	 lQAiQwo/1zku18s07COl00DhyqG2nqnwJNgAiLOZ8C/TpiKFd+TCkfINGqwT3x2krn
	 cbWOkMglcabhQ==
From: sashiko-bot@kernel.org
Subject: Re: [PATCH] scsi: ufs: core: Initialize hba->rpmbs list in ufshcd
Reply-To: sashiko-reviews@lists.linux.dev
To: "Ao Sun" <ao.sun@transsion.com>
Cc: linux-scsi@vger.kernel.org
In-Reply-To: <20260723034440.217-1-ao.sun@transsion.com>
References: <20260723034440.217-1-ao.sun@transsion.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Thu, 23 Jul 2026 03:57:26 +0000
Message-Id: <20260723035727.46F8E1F000E9@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>

Thank you for your contribution! Sashiko AI review found 2 potential issue(=
s) to consider:

Pre-existing issues:
- [High] This problem wasn't introduced by this patch, but a circular depen=
dency between the parent UFS RPMB device and its child RPMB device prevents=
 both from being unregistered and freed.
- [High] This problem wasn't introduced by this patch, but the `struct ufs_=
rpmb_dev` embeds a `struct device` and is incorrectly allocated using `devm=
_kzalloc()`, violating the Linux device model and risking a Use-After-Free =
on unbind.
--

--- Patch [1]: [PATCH] scsi: ufs: core: Initialize hba->rpmbs list in ufshc=
d ---
commit b69c44ec9068da0584fce2f43d2e235ffbfe2675
Author: Ao Sun <ao.sun@transsion.com>

scsi: ufs: core: Initialize hba->rpmbs list in ufshcd
   =20
Initialize the hba->rpmbs list in ufshcd_alloc_host() to prevent NULL
pointer dereference in the device teardown path if ufs_rpmb_probe()
fails.

> diff --git a/drivers/ufs/core/ufs-rpmb.c b/drivers/ufs/core/ufs-rpmb.c
> index ffad049872b9a..62120dc2e9da7 100644
> --- a/drivers/ufs/core/ufs-rpmb.c
> +++ b/drivers/ufs/core/ufs-rpmb.c
> @@ -152,8 +152,6 @@ int ufs_rpmb_probe(struct ufs_hba *hba)
>  		return -EINVAL;
>  	}
> =20
> -	INIT_LIST_HEAD(&hba->rpmbs);
> -

[Severity: High]
This isn't a bug introduced by this patch, but is it safe to allocate
ufs_rpmb using devm_kzalloc() when it embeds a struct device?

The ufs_rpmb structure is tied to the host device's devres lifecycle:

ufs_rpmb_probe() {
        ...
        ufs_rpmb =3D devm_kzalloc(hba->dev, sizeof(*ufs_rpmb), GFP_KERNEL);
        ...
}

When the host controller unbinds, devres will free this memory. However,
if a userspace process holds an open file descriptor to the sysfs
attributes of ufs_rpmb->dev, the kobject reference count remains elevated.

When userspace later closes the file, the driver core will drop the final
reference and invoke ufs_rpmb_device_release(), which will access the
already-freed ufs_rpmb_dev structure.

Could this result in a use-after-free on unbind?


[Severity: High]
This isn't a bug introduced by this patch, but does the error path in
ufs_rpmb_probe() fully clean up the registered RPMB devices?

If device_unregister() is called on ufs_rpmb->dev during probe error or
unbind, the parent device is unregistered. However, rpmb_dev_register()
creates a child device that holds a reference to this parent.

Because the child holds a reference, the parent's reference count will
not drop to zero, preventing its release callback from ever running:

ufs_rpmb_device_release() {
        ...
        rpmb_dev_unregister(ufs_rpmb->rdev);
        ...
}

Since rpmb_dev_unregister() is called inside that release callback, neither
device gets fully unregistered.

Does this create a circular dependency that leaks device structures and
sysfs entries?

>  	struct rpmb_descr descr =3D {
>  		.type =3D RPMB_TYPE_UFS,
>  		.route_frames =3D ufs_rpmb_route_frames,

[ ... ]

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20260723034440.217-=
1-ao.sun@transsion.com?part=3D1
