Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C5943443AA7
	for <linux-scsi@vger.kernel.org>; Wed, 29 Jul 2026 11:57:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785326226; cv=none; b=dzMsQoc3Km83+uYtQyWzsjGe5K45bhH4hsZlYq4FiTm4RxmdITWxBaWkASur4SWPX1OiBStsZtEEuAd0jHgYZJnHms9UQGRBcZ9gVQMtrgYjwwg/5EfYaBjAT2I4TrjCCZfCIfrGDHHROZVHVaGmnu00E+NSRdkx4lDVus+98GM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785326226; c=relaxed/simple;
	bh=XHoVHQt79VIEVcecYyCickY2X8ycrpt7rbg3bzELPhM=;
	h=From:Subject:To:Cc:In-Reply-To:References:Content-Type:Date:
	 Message-Id; b=t4csWSkoKemFNCKNAo5V57SmH06yRpkSOJfYRXpe3Nz9EIBqJzrAhVex3I9S39N2mhpu5ta4owMo2JzNLU6N+SmmlGkuSHQVn8701KizUlWybNzqJyjwpejb9OaHr8Izv0oeSZ/ZvA8XUAANqVVnro+Rl2lTMAM0H4NUBd8lHv8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=LZMeqLoT; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="LZMeqLoT"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 31F781F000E9;
	Wed, 29 Jul 2026 11:57:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1785326224;
	bh=k46PI3eo8wfO39AmbT3dMlc97jqU8TuLORjLZWIcti4=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=LZMeqLoTe7MAclJ4uD77nKVjEc4yzBr6hRPOtvqrGZl+lSo7V0NDOAtnbFVPtOysg
	 Z5mTCFDV8SOqvLENfpHonioGT4Xc0l+Kh4f+aHjB8Po+2raioXpDj4PULNW8AyKIea
	 ISKQcLm9c0pQXbbihjcfN0CkOV1uBxCI5AFBM9fQkMv7GL8YwVAjoqD46jnr9QfSYS
	 DGFKJbZvPPzRdLPAHTP4Dhj3A3RCUkP0F1VSoJxisI/c/06AGVrnGRk03ArdrYSVF7
	 l+MIIxSGemCIqLG/YMiQ783o8B3w70kg9EGjK43zh9Xw9FD1h/AplcqGyRUmesWERT
	 n8mSdPtxoAWVg==
From: sashiko-bot@kernel.org
Subject: Re: [PATCH v6 05/27] libmultipath: Add support for mpath_device
 management
Reply-To: sashiko-reviews@lists.linux.dev
To: "John Garry" <john.g.garry@oracle.com>
Cc: linux-scsi@vger.kernel.org
In-Reply-To: <20260729105107.255712-6-john.g.garry@oracle.com>
References: <20260729105107.255712-1-john.g.garry@oracle.com>
 <20260729105107.255712-6-john.g.garry@oracle.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Wed, 29 Jul 2026 11:57:03 +0000
Message-Id: <20260729115704.31F781F000E9@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>

Thank you for your contribution! Sashiko AI review found 4 potential issue(=
s) to consider:
- [High] RCU Use-After-Free Vulnerability in mpath_delete_device()
- [High] NULL Pointer Dereference in sysfs link management
- [High] Race condition causing sysfs link leak and dangling kobject refere=
nces
- [Medium] TOCTOU race in mpath_remove_sysfs_link
--

--- Patch [5]: [PATCH v6 05/27] libmultipath: Add support for mpath_device =
management ---
commit a32651ca51a97ca7e06ffd62321d0190b9e9cfa0
Author: John Garry <john.g.garry@oracle.com>

libmultipath: Add support for mpath_device management
   =20
Add support to add or remove a mpath_device as a path.
   =20
NVMe has almost like-for-like equivalents here:
- nvme_mpath_clear_current_path() -> mpath_clear_current_path()
- nvme_mpath_add_sysfs_link() -> mpath_add_sysfs_link()
- nvme_mpath_remove_sysfs_link() -> mpath_remove_sysfs_link()
- nvme_mpath_revalidate_paths() -> mpath_revalidate_paths()

The functionality in mpath_clear_paths() and mpath_synchronize() have the
same pattern which is frequently used in the NVMe code.

> diff --git a/lib/multipath.c b/lib/multipath.c
> index 93b82eea7d38b..6b8f6e846987a 100644
> --- a/lib/multipath.c
> +++ b/lib/multipath.c

[ ... ]

> @@ -51,6 +51,87 @@ void mpath_synchronize(struct mpath_head *mpath_head)
>  }
>  EXPORT_SYMBOL_GPL(mpath_synchronize);
> =20

[ ... ]

> +bool mpath_delete_device(struct mpath_device *mpath_device)
> +{
> +	bool empty;
> +
> +	mutex_lock(&mpath_device->mpath_head->lock);
> +	list_del_rcu(&mpath_device->siblings);
> +	empty =3D list_empty(&mpath_device->mpath_head->dev_list);
> +	mutex_unlock(&mpath_device->mpath_head->lock);
> +
> +	mpath_synchronize(mpath_device->mpath_head);

[Severity: High]
Does this sequence safely handle RCU readers accessing current_path?

Because mpath_delete_device() removes the device from dev_list and
immediately calls mpath_synchronize() without clearing it from
mpath_head->current_path, the RCU-protected current_path array may still
hold a pointer to the device. Lockless readers can then dereference the
freed device.

If callers attempt to clear current_path before calling
mpath_delete_device(), couldn't the pointer be repopulated from dev_list
by concurrent readers during the race window? If cleared after, the
synchronization has already passed, providing no protection against
use-after-free.

> +
> +	return empty;
> +}
> +EXPORT_SYMBOL_GPL(mpath_delete_device);

[ ... ]

> @@ -489,6 +572,77 @@ void mpath_device_set_live(struct mpath_device *mpat=
h_device)
>  }
>  EXPORT_SYMBOL_GPL(mpath_device_set_live);
> =20
> +void mpath_add_sysfs_link(struct mpath_head *mpath_head)
> +{
> +	struct device *target;
> +	struct device *source;
> +	int rc, srcu_idx;
> +	struct kobject *mpath_gd_kobj;
> +	struct mpath_device *mpath_device;
> +
> +	/*
> +	 * Ensure head disk node is already added otherwise we may get invalid
> +	 * kobj for head disk node
> +	 */
> +	if (!test_bit(GD_ADDED, &mpath_head->disk->state))
> +		return;

[Severity: High]
Is it possible for mpath_head->disk to be NULL here?

When a multi-path head disk is removed, mpath_put_disk() is called, which
sets mpath_head->disk =3D NULL. If a path subsequently goes live,
mpath_add_sysfs_link() appears to dereference it without checking for NULL.

Could this cause a deterministic oops when path teardown outlives the head,
such as during an abrupt controller removal?

> +
> +	mpath_gd_kobj =3D &disk_to_dev(mpath_head->disk)->kobj;
> +	srcu_idx =3D srcu_read_lock(&mpath_head->srcu);
> +
> +	list_for_each_entry_srcu(mpath_device, &mpath_head->dev_list, siblings,
> +				 srcu_read_lock_held(&mpath_head->srcu)) {
> +		if (!test_bit(GD_ADDED, &mpath_device->disk->state))
> +			continue;
> +
> +		if (test_and_set_bit(MPATH_DEVICE_SYSFS_ATTR_LINK,
> +					&mpath_device->flags))
> +			continue;
> +
> +		target =3D disk_to_dev(mpath_device->disk);
> +		source =3D disk_to_dev(mpath_head->disk);
> +		/*
> +		 * Create sysfs link from head gendisk kobject @kobj to the
> +		 * ns path gendisk kobject @target->kobj.
> +		 */

[Severity: High]
Could this re-create a sysfs link for a device that is in the middle of
being deleted?

During path removal, mpath_remove_sysfs_link() clears the
MPATH_DEVICE_SYSFS_ATTR_LINK bit before mpath_delete_device() removes
the device from the RCU dev_list.

If a different path concurrently goes live, mpath_add_sysfs_link() iterates
over dev_list, observes the cleared bit on the dying device, and might
mistakenly re-create the sysfs link. When the dying device is finally
removed and freed, the re-created sysfs link is permanently leaked and
points to a freed block device kobject.

> +		rc =3D sysfs_add_link_to_group(mpath_gd_kobj, "multipath",
> +				&target->kobj, dev_name(target));

[ ... ]

> +void mpath_remove_sysfs_link(struct mpath_device *mpath_device)
> +{
> +	struct device *target;
> +	struct kobject *mpath_gd_kobj;
> +	struct mpath_head *mpath_head =3D mpath_device->mpath_head;
> +
> +	if (!test_bit(MPATH_DEVICE_SYSFS_ATTR_LINK, &mpath_device->flags))
> +		return;
> +
> +	target =3D disk_to_dev(mpath_device->disk);
> +	mpath_gd_kobj =3D &disk_to_dev(mpath_head->disk)->kobj;

[Severity: High]
Does mpath_head->disk need to be checked for NULL before dereferencing it
here?

Similar to mpath_add_sysfs_link(), if underlying paths are detached after
mpath_put_disk() sets mpath_head->disk =3D NULL, this will cause a NULL
pointer dereference during teardown.

> +
> +	sysfs_remove_link_from_group(mpath_gd_kobj, "multipath",
> +			dev_name(target));
> +
> +	clear_bit(MPATH_DEVICE_SYSFS_ATTR_LINK, &mpath_device->flags);

[Severity: Medium]
Is there a race condition between test_bit() at the start of this function
and clear_bit() here?

A concurrent execution for the same device could pass the test_bit() check
and issue duplicate removals to the sysfs core. Should this diverging
non-atomic pattern be replaced with test_and_clear_bit() to match the safe
pattern used in mpath_add_sysfs_link()?

> +}

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20260729105107.2557=
12-1-john.g.garry@oracle.com?part=3D5
