Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CD6EA3C1086
	for <linux-scsi@vger.kernel.org>; Tue, 21 Jul 2026 08:59:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784624345; cv=none; b=LbM67MXGgzLJ7LoHi3+pr21GGw9EHJnsy/WwmCTdiCIym+nKYnPuHWoDEHBA8Jw5ASmbOpFlx78o6sCiIwfQQcCqbBOlUBxJqps5zm/xjHEYMqNbxbKUZjTC7B4I6jXwgaO+k5AB9hwlxrf2bVD6rYAK6OPFOM11U7ZQ7i9TuAg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784624345; c=relaxed/simple;
	bh=zEJtnoFfcYO3JU13PFtjNe76Yv59h7BjnBcKaM8HNDA=;
	h=From:Subject:To:Cc:In-Reply-To:References:Content-Type:Date:
	 Message-Id; b=iawT+T/IjiCn8Qmi5hD+W25M2lAKemOySRWGG+ogFEyUbqH75yZOTFeqzKLslX8TYgm2BtFG2smy8c52ysMpczDNXmIG4HWbuNgXKHxuJLMJeawNPJXlYYJAYEJ8R4Fh6ksQ04+hQUAsVufKqBGkhmOLJtVz7hbEkGbZOzgUht8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=X2E8OLNQ; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="X2E8OLNQ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5489C1F000E9;
	Tue, 21 Jul 2026 08:59:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1784624343;
	bh=oa3UpJGB4GEbbkb1g2YGJXEWT9+ocKzwxLdEtcosevM=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=X2E8OLNQ9q4jz5fTYoTRjPwi4YbAuUrjmwwDE30R4iHU+TqeAfU0CLcsyVFIgGi7p
	 pb4yquFpOEJG55F4qn8Jl/g+mq3s1EQCFDBUtfuWZPOrNgtYNOx8oJs33FxVyKmXS4
	 fI0JLihvoA5tnpdz3rXcX2CXBgl7z1bzBVmo5UL7zzkTb7kLeg2oubWP4+qpQPhV+1
	 xM3NTDOO8eBka2MuHVtXN1f0wGdQzo3BGdQypIuPlg78jS0L7eOcSY9MjeMTn2D2YH
	 f9wuuincBaAti0CDr2SMXkg5SOBkngtlq/1cDoWTwdn8oBz71Oci8q3cJOP3mpXjvM
	 3b9hiYUbXXrmQ==
From: sashiko-bot@kernel.org
Subject: Re: [PATCH v3] scsi: ufs: core: Fix UFS RPMB device teardown order
Reply-To: sashiko-reviews@lists.linux.dev
To: "Ao Sun" <ao.sun@transsion.com>
Cc: linux-scsi@vger.kernel.org
In-Reply-To: <20260721084015.319-1-ao.sun@transsion.com>
References: <20260721084015.319-1-ao.sun@transsion.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Tue, 21 Jul 2026 08:59:02 +0000
Message-Id: <20260721085903.5489C1F000E9@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>

Thank you for your contribution! Sashiko AI review found 1 potential issue(=
s) to consider:
- [High] The `ufs_rpmb` memory is freed while its child RPMB device (`rdev`=
) may still be in use by other subsystems (e.g., OP-TEE), leading to a Use-=
After-Free when routing frames.
--

--- Patch [1]: [PATCH v3] scsi: ufs: core: Fix UFS RPMB device teardown ord=
er ---
commit 61bb07aa128e1c613c9b0aaf64bf60f4bcd759c7
Author: Ao Sun <ao.sun@transsion.com>

scsi: ufs: core: Fix UFS RPMB device teardown order

This commit changes the UFS RPMB device teardown sequence to unregister the
child RPMB device before the parent device. It also moves the memory freeing
of the ufs_rpmb_dev struct to the parent device's release callback and
initializes the hba->rpmbs list earlier.

Link: https://lore.kernel.org/all/20260714064356.CF7101F000E9@smtp.kernel.o=
rg/

> diff --git a/drivers/ufs/core/ufs-rpmb.c b/drivers/ufs/core/ufs-rpmb.c
> index ffad049872b9a..cfd1f074d0043 100644
> --- a/drivers/ufs/core/ufs-rpmb.c
> +++ b/drivers/ufs/core/ufs-rpmb.c

[ ... ]

> @@ -224,6 +222,7 @@ int ufs_rpmb_probe(struct ufs_hba *hba)
>  	kfree(cid);
>  	list_for_each_entry_safe(it, tmp, &hba->rpmbs, node) {
>  		list_del(&it->node);
> +		rpmb_dev_unregister(it->rdev);
>  		device_unregister(&it->dev);

[Severity: High]
Could this teardown sequence result in a use-after-free if another
subsystem (like OP-TEE) has already acquired a reference to the RPMB device?

When rpmb_dev_unregister() is called, the driver core removes the child
from the hierarchy and drops its reference to the parent. The subsequent
device_unregister() on the parent drops its refcount to zero, triggering
ufs_rpmb_device_release() and freeing the ufs_rpmb object.

If a concurrent subsystem holds a reference to rdev via rpmb_dev_get(),
it might later call rpmb_route_frames(rdev, ...). This executes
rdev->descr.route_frames(rdev->dev.parent, ...).

Since dev.parent is now a dangling pointer to the freed parent device,
ufs_rpmb_route_frames() will access freed memory when fetching the driver
data.

>  	}
> =20
> @@ -244,6 +243,7 @@ void ufs_rpmb_remove(struct ufs_hba *hba)
>  		/* Remove from list first */
>  		list_del(&ufs_rpmb->node);
>  		/* Unregister device */
> +		rpmb_dev_unregister(ufs_rpmb->rdev);
>  		device_unregister(&ufs_rpmb->dev);

[Severity: High]
Does this have the same use-after-free risk as the probe error path above?

If a concurrent subsystem retains a reference to the child device,
unregistering the devices in this order frees the parent object while the
child device might still route frames, leading to a use-after-free on the
parent device pointer.

>  	}

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20260721084015.319-=
1-ao.sun@transsion.com?part=3D1
