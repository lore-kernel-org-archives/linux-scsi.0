Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 12729469831
	for <linux-scsi@vger.kernel.org>; Wed, 29 Jul 2026 17:01:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785344502; cv=none; b=C5naQ6+UEsUw1LF7DfQrH72MqfGHAlDKxjCs4XBlCJZgza67jCySviHhctqOPNwij4UMhV6VBylGsP/XpgxKRtD10vME9irzEzpZvG3ffIEEs7M2QBcmbAdMlvQFG852KQvrqcEd1319+XVIc4iSTkzcMtaapb40B7CuEIDoeUU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785344502; c=relaxed/simple;
	bh=bBYR/XD70KTazAhY4Kvn4i2jQ59KTalArIN1HiNc320=;
	h=From:Subject:To:Cc:In-Reply-To:References:Content-Type:Date:
	 Message-Id; b=NaeSfW5twUkAow7NC9OMerZKxRXpjVle/lDAWefBgPpsjZ3MtxVgawbxI/QsYg5Rcx6efFP1x3COWlkEz/+61pmIel3/MrEdy4AtFZ90e0UPw/UvtRGzTVro2XJa6LphQomK5AZZn21lF1/pbiFUD2Ds83elgyEgEoggjdJz0sg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=M3aKKLgG; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="M3aKKLgG"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 87D7D1F000E9;
	Wed, 29 Jul 2026 17:01:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1785344500;
	bh=rSOEXYxTrpXHcS4HoAz7+rp7q9w79JfQ8AmwP5m3Ks8=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=M3aKKLgG5KHQ2h2E+zyOXUoxcdqeEUXq5yWeTBh2fcxNthZ7TwuN0MM5LtP8t6XLr
	 jfNKxZ4tMuZKmpDKX5GDhUYkLVlIqRjyLSTlKZJLzXlnLfQDO0ncIDNFdjW75sIhGB
	 MjZI81ccUY8Vnf/7x49PXgx8TzaN1Qpb4K56rr8MnUpLag+OMT2wQJfUKYAIDhtR8q
	 OZDZVBndbGQI2GP/W1iHpuD9dfbFXcA1wZPXEMsac+Ii7XfKmeycx+ncAYU/4Hw5GW
	 Hq3zbnt1jGS5gOc+lWJPEHnN7HYjPeXyR2O/7bdg0RuES2H1SQ0ZlxqweVkCKQmgKA
	 VLmQwoFlNEnPA==
From: sashiko-bot@kernel.org
Subject: Re: [PATCH v6 24/27] scsi: sd: support multipath disk
Reply-To: sashiko-reviews@lists.linux.dev
To: "John Garry" <john.g.garry@oracle.com>
Cc: linux-scsi@vger.kernel.org
In-Reply-To: <20260729105107.255712-25-john.g.garry@oracle.com>
References: <20260729105107.255712-1-john.g.garry@oracle.com>
 <20260729105107.255712-25-john.g.garry@oracle.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Wed, 29 Jul 2026 17:01:40 +0000
Message-Id: <20260729170140.87D7D1F000E9@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>

Thank you for your contribution! Sashiko AI review found 5 potential issue(=
s) to consider:

New issues:
- [High] Missing `put_device()` in the `sd_mpath_add_disk()` error path per=
manently leaks the `sdkp` structure.
- [High] Inverted device teardown order causes double `device_del()` and sy=
sfs warnings.
- [High] Cyclic kobject reference between `sd_mpath_disk` and its child gen=
disk guarantees both are permanently leaked on removal.
- [Medium] Ignored return value of `scsi_mpath_get_head()` leads to potenti=
al kref underflow and use-after-free.

Pre-existing issues:
- [High] `kfree()` is called on an active kobject when `sd_large_pool_creat=
e()` fails, leading to UAF / Sysfs Corruption.
--

--- Patch [24]: [PATCH v6 24/27] scsi: sd: support multipath disk ---
commit 1896d58c043437e813525b463ccbb2249c843f33
Author: John Garry <john.garry@linux.dev>
scsi: sd: support multipath disk

This commit adds support for attaching a multipath disk in the SCSI sd
subsystem. It allocates gendisks per-path but marks them as hidden, and
maintains a global list of sd_mpath_disks to match with scsi_devices.

> --- a/drivers/scsi/sd.c
> +++ b/drivers/scsi/sd.c
> @@ -115,12 +115,30 @@ static mempool_t *sd_large_page_pool;
>  static atomic_t sd_large_page_pool_users =3D ATOMIC_INIT(0);
>  static struct lock_class_key sd_bio_compl_lkclass;
>  #ifdef CONFIG_SCSI_MULTIPATH
> +static LIST_HEAD(sd_mpath_disks_list);
> +static DEFINE_MUTEX(sd_mpath_disks_lock);
> +
>  struct sd_mpath_disk {
> +	struct device			dev;
> +	int				disk_index;
> +	int				disk_count;
> +	struct list_head		entry;
>  	struct scsi_mpath_head		*scsi_mpath_head;
>  };
> =20
>  static void sd_mpath_disk_release(struct device *dev)
>  {
> +	struct sd_mpath_disk *sd_mpath_disk =3D
> +		container_of(dev, struct sd_mpath_disk, dev);
> +	struct scsi_mpath_head *scsi_mpath_head =3D
> +		sd_mpath_disk->scsi_mpath_head;
> +	struct mpath_head *mpath_head =3D &scsi_mpath_head->mpath_head;
> +
> +	mpath_put_disk(mpath_head);

[Severity: High]
Does this create an unbreakable cyclic kobject reference? The child disk is
created as a child of sd_mpath_disk->dev, meaning it holds a reference to
the parent. If the child's reference is only dropped via mpath_put_disk()
inside the parent's release function (sd_mpath_disk_release), the parent's
release function will never execute because the child still holds a
reference to it. Will this permanently leak both the sd_mpath_disk and the
multipath gendisk on removal?

[ ... ]

> @@ -4035,13 +4138,259 @@ static const struct attribute_group sd_mpath_dis=
k_attr_group =3D {
>  	.attrs		=3D sd_mpath_disk_attrs,
>  };
> =20
> +static int sd_mpath_probe(struct scsi_disk *sdkp)
> +{
[ ... ]
> +	device_initialize(&sd_mpath_disk->dev);
> +	sd_mpath_disk->dev.class =3D &sd_mpath_disk_class;
> +
> +	/* undone in sd_mpath_disk_release() */
> +	scsi_mpath_get_head(scsi_mpath_head);

[Severity: Medium]
Is it safe to ignore the return value here? In sd_mpath_probe(),
scsi_mpath_get_head() is called but its return value is discarded. Since
scsi_mpath_get_head() explicitly uses kref_get_unless_zero() and can return
-ENXIO, could a failure lead to a refcount underflow and a use-after-free
during the release path?

[ ... ]

> +static void sd_mpath_remove(struct scsi_disk *sdkp)
> +{
[ ... ]
> +	if (remove) {
> +		device_del(&sd_mpath_disk->dev);
> +		mpath_remove_disk(mpath_head);
> +	}
> +	sd_mpath_put_disk(sd_mpath_disk);
> +}

[Severity: High]
Is this device teardown order inverted? In sd_mpath_remove() and the related
sd_mpath_remove_head(), the parent device (sd_mpath_disk->dev) is deleted
via device_del() before the child gendisk is removed via mpath_remove_disk(=
).
Does this cause double device_del() operations or sysfs hierarchy corruptio=
n,
since the device model requires children to be unregistered before their
parents?

[ ... ]

> +static void sd_mpath_fail_probe(struct scsi_disk *sdkp)
> +{
[ ... ]
> +	if (remove) {
> +		device_del(&sd_mpath_disk->dev);
> +		mpath_remove_disk(mpath_head);
> +	}
> +	sd_mpath_put_disk(sd_mpath_disk);
> +}

[Severity: High]
Does the same inverted teardown order apply here in sd_mpath_fail_probe()?
Deleting the parent device before the child gendisk violates the device
model requirements and can trigger sysfs warnings.

[ ... ]

> @@ -4158,11 +4515,18 @@ static int sd_probe(struct scsi_device *sdp)
>  	sd_revalidate_disk(gd);
>  	if (sdp->sector_size > PAGE_SIZE) {
>  		if (sd_large_pool_create()) {
> +			sd_mpath_fail_probe(sdkp);
>  			error =3D -ENOMEM;
>  			goto out_free_index;
>  		}
>  	}

[Severity: High]
This is a pre-existing issue, but does jumping to out_free_index here leak
the active kobject? In sd_probe(), device_add(&sdkp->disk_dev) has already
succeeded earlier in the function. When sd_large_pool_create() fails, it
jumps to out_free_index and eventually calls kfree(sdkp). Should this error
path use device_del() and put_device() instead to prevent sysfs corruption
and a use-after-free on the active kobject?

[ ... ]

> @@ -4177,6 +4541,7 @@ static int sd_probe(struct scsi_device *sdp)
[ ... ]
>  	error =3D device_add_disk(dev, gd, NULL);
>  	if (error) {
> +		sd_mpath_fail_probe(sdkp);
>  		device_unregister(&sdkp->disk_dev);
>  		put_disk(gd);
>  		if (sdp->sector_size > PAGE_SIZE)
> @@ -4184,6 +4549,19 @@ static int sd_probe(struct scsi_device *sdp)
>  		goto out;
>  	}
> =20
> +	if (sdp->scsi_mpath_dev) {
> +		error =3D sd_mpath_add_disk(sdkp);
> +		if (error) {
> +			sd_mpath_fail_probe(sdkp);
> +			device_del(&sdkp->disk_dev);
> +			del_gendisk(sdkp->disk);
> +
> +			put_disk(sdkp->disk);
> +			if (sdp->sector_size > PAGE_SIZE)
> +				sd_large_pool_destroy();
> +			goto out;
> +		}
> +	}

[Severity: High]
Does this error path leak the sdkp structure? In sd_probe(), if
sd_mpath_add_disk() fails, the code manually calls device_del() and
del_gendisk() but entirely omits put_device(&sdkp->disk_dev). Because the
initial reference count set by device_initialize() is never decremented to
zero, will this permanently leak the scsi_disk structure and its associated
resources?

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20260729105107.2557=
12-1-john.g.garry@oracle.com?part=3D24
