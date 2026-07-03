Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 69D9225785D
	for <linux-scsi@vger.kernel.org>; Fri,  3 Jul 2026 11:32:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1783078347; cv=none; b=EcKPLsjRlfU4boIcBIzr1UZ7I4cNAgWZnHwHRZmTwMWZ64fs4h5S5Lzj90X9dmMcD5azdXwjlNLqjs8IYz4BbkBE3TtlZ6G2lA5zq3HVQN1hjSCXC5fswiRH4/vRgFDJGx1KMJ2PqNmnP4yB0C7EBIk7CgRX6pFeBd7ZoyIjTkw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1783078347; c=relaxed/simple;
	bh=ukE469K47m3E1lgRuFuDIVCLx5i24H5q99QohedjLdg=;
	h=From:Subject:To:Cc:In-Reply-To:References:Content-Type:Date:
	 Message-Id; b=KjVi3QkU/NPvjXPavL8t7J9Uxb/dHzJY4JjrtRaPpo3FTQam4X/u3/ZaNkamhfvb+6NOOMloaHZ9mt8DeYsItaIMLMTZZUu1jhBou19mJqLuEkMHzYh+MPxInyjP5Sr9+JUqYhcnI6C8nFCNhqQFXgheaWrgij6EcZPB+r/D+i8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=QJkOrBF8; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="QJkOrBF8"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D312B1F000E9;
	Fri,  3 Jul 2026 11:32:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1783078346;
	bh=tXXNRXhP6JFPQM/VAx+UFIIlZ+4JceYlzxVaq/51wGs=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=QJkOrBF8X2rW+fsz/KPw0yG4RPAQNb03j6H2Zw9t+EQtJOZsZ1Ijcrq8/yqkLZrIH
	 GzA8KbOHZcxUdwQb9kpP1ZdWDJz18y6YdO2DORFvYBmozVu+A5hxB3lY/pGRI7AMG9
	 1Q6P4biU1ry5/QGr5EB42X7eBUKa/l4vBhMMeFXQdabLzxV3JpUqLp9RbhlkKOLGVX
	 o5SGs8t0F7R1IQTpYL28kMD5hAwdqDNvaaaQ0nxTjvTEc0pNzQfz/cDIiFkUqnuiwC
	 iaTdNhnyKmJ+z9UjdfSLjMcFrHPjwOjNGAdYNH2D3gxv1qFRzSs2rC9FQg2/Mg77C/
	 wdZ+jhV/xJ14A==
From: sashiko-bot@kernel.org
Subject: Re: [PATCH v3 06/17] scsi-multipath: clear path when device is
 blocked
Reply-To: sashiko-reviews@lists.linux.dev
To: "John Garry" <john.g.garry@oracle.com>
Cc: linux-scsi@vger.kernel.org
In-Reply-To: <20260703103402.3725011-7-john.g.garry@oracle.com>
References: <20260703103402.3725011-1-john.g.garry@oracle.com>
 <20260703103402.3725011-7-john.g.garry@oracle.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Fri, 03 Jul 2026 11:32:25 +0000
Message-Id: <20260703113225.D312B1F000E9@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>

Thank you for your contribution! Sashiko AI review found 5 potential issue(=
s) to consider:

New issues:
- [Critical] Unsafe lockless access to `scsi_mpath_head` in `scsi_mpath_dev=
_clear_path` races with device removal, causing a NULL pointer dereference =
or Use-After-Free.
- [High] Adding a blocking synchronization call to the `nowait` context of =
`__scsi_internal_device_block_nowait` violates non-blocking guarantees.
- [High] Publishing `sdev->scsi_mpath_dev` before `scsi_mpath_head` is init=
ialized leads to NULL pointer dereferences during concurrent block requests.

Pre-existing issues:
- [High] The error path in `scsi_mpath_alloc_head()` double-frees the `scsi=
_mpath_head` structure and its associated resources.
- [High] The error path for `device_add()` failure in `scsi_mpath_dev_alloc=
()` causes a NULL pointer dereference and an invalid `device_unregister()`.
--

commit 848d562af61faa57ddead6bc3e5e7a75ce63ea4e
Author: John Garry <john.g.garry@oracle.com>
Subject: scsi-multipath: clear path when device is blocked

This patch adds scsi_mpath_dev_clear_path() to clear a device path when it
becomes blocked. It updates __scsi_internal_device_block_nowait() to call
this new function when a path is available.

> diff --git a/drivers/scsi/scsi_lib.c b/drivers/scsi/scsi_lib.c
> index daeb3693fe559..3c493068adb98 100644
> --- a/drivers/scsi/scsi_lib.c
> +++ b/drivers/scsi/scsi_lib.c
[ ... ]
> @@ -2923,6 +2924,8 @@ EXPORT_SYMBOL(scsi_target_resume);
> =20
>  static int __scsi_internal_device_block_nowait(struct scsi_device *sdev)
>  {
> +	if (sdev->scsi_mpath_dev)

[Severity: High]
Does this early access race with device probe?=20

If scsi_multipath_sdev_init() publishes sdev->scsi_mpath_dev before
allocating scsi_mpath_head, could an asynchronous block request see this as
true and invoke scsi_mpath_dev_clear_path(), leading to a NULL pointer
dereference on the head?

> +		scsi_mpath_dev_clear_path(sdev->scsi_mpath_dev);
>  	if (scsi_device_set_state(sdev, SDEV_BLOCK))
>  		return scsi_device_set_state(sdev, SDEV_CREATED_BLOCK);
> =20
> diff --git a/drivers/scsi/scsi_multipath.c b/drivers/scsi/scsi_multipath.c
> index ca4ab720c19af..0f3f3f9fa5fae 100644
> --- a/drivers/scsi/scsi_multipath.c
> +++ b/drivers/scsi/scsi_multipath.c
[ ... ]
> @@ -113,6 +113,17 @@ static ssize_t scsi_mpath_device_vpd_id_show(struct =
device *dev,
>  }
>  static DEVICE_ATTR(vpd_id, S_IRUGO, scsi_mpath_device_vpd_id_show, NULL);
> =20
> +void scsi_mpath_dev_clear_path(struct scsi_mpath_device *scsi_mpath_dev)
> +{
> +	struct mpath_device *mpath_device =3D &scsi_mpath_dev->mpath_device;
> +	struct scsi_mpath_head *scsi_mpath_head =3D scsi_mpath_dev->scsi_mpath_=
head;

[Severity: Critical]
Is this lockless access safe against concurrent device removal?

If scsi_mpath_remove_head() drops the head reference locklessly and sets:
    scsi_mpath_dev->scsi_mpath_head =3D NULL;

Could a concurrent event hitting __scsi_internal_device_block_nowait()
unconditionally call this and blindly dereference the NULL or freed
scsi_mpath_head?

> +	struct mpath_head *mpath_head =3D &scsi_mpath_head->mpath_head;
> +
> +	if (mpath_clear_current_path(mpath_device))
> +		mpath_synchronize(mpath_head);

[Severity: High]
Does this introduce a sleeping call into a nowait context?

__scsi_internal_device_block_nowait() is designed not to sleep to preserve
batching optimizations. Since mpath_synchronize() typically sleeps to wait
for grace periods or draining I/O, will calling it here break those
optimizations or cause scheduling while atomic panics?

> +}
> +EXPORT_SYMBOL_GPL(scsi_mpath_dev_clear_path);
> +
>  static ssize_t scsi_mpath_device_iopolicy_store(struct device *dev,


While reviewing this patch, I also noticed a couple of pre-existing issues
in the earlier patches of this series:

[Severity: High]
This is a pre-existing issue, but does the error path in
scsi_mpath_alloc_head() double-free the structure?

If dev_set_name() fails:
    if (dev_set_name(&scsi_mpath_head->dev, ...)) {
        put_device(&scsi_mpath_head->dev);
        goto out_free_ida;
    }

put_device() drops the refcount to 0, which invokes the release function
scsi_mpath_head_release() to free the structure and its resources.
The code then falls through to out_free_ida where it manually executes the
IDA free, bioset exit, and a second kfree() on the already freed struct.


[Severity: High]
This is a pre-existing issue, but does the error path for device_add()
cause a NULL pointer dereference in scsi_mpath_dev_alloc()?

If device_add() fails, it jumps to out_put_head:
    ret =3D device_add(&scsi_mpath_head->dev);
    if (ret) {
        mutex_unlock(&scsi_mpath_heads_lock);
        goto out_put_head;
    }

This ultimately calls scsi_mpath_free_head(), which unconditionally
executes:
    list_del_init(&scsi_mpath_head->entry);

Since the device was never added to the list on this error path, entry is
still zero-initialized. Will list_del_init() dereference a NULL pointer
here? Also, would the cleanup code call device_unregister() on a device
that failed device_add()?

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20260703103402.3725=
011-1-john.g.garry@oracle.com?part=3D6
