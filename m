Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CF6703BC664
	for <linux-scsi@vger.kernel.org>; Fri,  3 Jul 2026 10:51:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1783075894; cv=none; b=M+Hm4YZHJlxXMTrlzArpOFeNNWWGjEqkz14mCU+5AAKja+XElqKmpjlClHT2H2Uzur/D+gEydYUJzFdgZ2/fZmZtOcOis2AQAUq/69dutpvY12l/7UzKKG9aU3rzqYptQgxnC/S6nBUa6H0dpRO2GssFXJLb17qgzx5VeX+uBQ8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1783075894; c=relaxed/simple;
	bh=xiPKUtgXtXjy218JDApeE+WjGR2IW2gX8mTpLGUtufw=;
	h=From:Subject:To:Cc:In-Reply-To:References:Content-Type:Date:
	 Message-Id; b=OTU3EMDTbWrSrAVNnTnl6lU2Kky5f2jcwmY4cMsaWeku4uOzq5SN67Y9QHRc0V6yjmFuV+z58nO+xDQyahTWaEgLwmy3+IOasFRVNSyhHMoAIujH1mK5rHpvb6bGJkzNz4ZiAstEzv0g1NEEOtZmKAvUkLhQG/bqqBugz1vWT6Q=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=UlLYFhG+; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="UlLYFhG+"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 44EF31F000E9;
	Fri,  3 Jul 2026 10:51:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1783075892;
	bh=5iuMdGXBqUr5r7RvwGrOiX62DPMrH+elbAjPzo/EJVk=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=UlLYFhG+CEGmD2p50PI86Oh7FeKay4ddG3xQIhDvntHSmaGnaaofpuu6H0/mbwfPW
	 0E9/i6tiIiGSSHy4sMonk+G5IY7PZZBlbrNeZvRKT+BLIfwU5fkarcnf7GpPvhEvqB
	 X043N8xFLHDldbdD6rL5oMRvxCn2AOS95mK5y5WR8jCVAWtb7SXokvPjmRqjeArXt+
	 TD3TmDuO/DPlOekdlmM0i2opQguFeZdn8OJNub7PN8yT5Vhaf3Lx1KoumUpE4f8n3j
	 S/DAs76dCzHzSIvc1I3Ty3pV1BKBlyEA90RpjA8bbnhmMpEss0gpgqoIbgNuUj2KPw
	 QNThuZqIArTpw==
From: sashiko-bot@kernel.org
Subject: Re: [PATCH v3 02/13] libmultipath: Add basic gendisk support
Reply-To: sashiko-reviews@lists.linux.dev
To: "John Garry" <john.g.garry@oracle.com>
Cc: linux-scsi@vger.kernel.org
In-Reply-To: <20260703102918.3723667-3-john.g.garry@oracle.com>
References: <20260703102918.3723667-1-john.g.garry@oracle.com>
 <20260703102918.3723667-3-john.g.garry@oracle.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Fri, 03 Jul 2026 10:51:31 +0000
Message-Id: <20260703105132.44EF31F000E9@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>

Thank you for your contribution! Sashiko AI review found 3 potential issue(=
s) to consider:
- [High] `mpath_alloc_head_disk()` leaves `ERR_PTR` in `mpath_head->disk` o=
n failure, causing a kernel panic during cleanup or state updates.
- [High] A TOCTOU race between `mpath_device_set_live()` and `mpath_remove_=
disk()` permanently leaks the gendisk.
- [High] Synchronous wait in `mpath_head_uninit()` allows unprivileged open=
ers to block device teardown indefinitely.
--

commit bba05c007c446cdb19dbac857c9ce717ca5f2a08
Author: John Garry <john.g.garry@oracle.com>
Subject: libmultipath: Add basic gendisk support

This patch adds support to allocate and free a multipath gendisk. It also
introduces struct mpath_head_template as a method for drivers to provide
custom multipath functionality.

> diff --git a/lib/multipath.c b/lib/multipath.c
> index 009d4bb875c6f..79be84d3d4f75 100644
> --- a/lib/multipath.c
> +++ b/lib/multipath.c
> @@ -44,12 +44,111 @@ void mpath_head_uninit(struct mpath_head *mpath_head)
>  }
>  EXPORT_SYMBOL_GPL(mpath_head_uninit);
> =20
> +static int mpath_bdev_open(struct gendisk *disk, blk_mode_t mode)
> +{
> +	struct mpath_head *mpath_head =3D disk->private_data;
> +
> +	return mpath_get_head(mpath_head);
> +}

[Severity: High]
Does this increment the refcount on behalf of userspace openers?

If unprivileged users open the block device, this calls mpath_get_head()
which increments mpath_head->refcount. If the admin later removes the devic=
e,
the driver calls mpath_head_uninit() which synchronously waits for the
refcount to hit zero. Since the user can hold the file descriptor open,
couldn't this allow unprivileged openers to permanently hang the kernel
thread handling device removal?

[ ... ]

> +void mpath_remove_disk(struct mpath_head *mpath_head)
> +{
> +	if (test_and_clear_bit(MPATH_HEAD_DISK_LIVE, &mpath_head->flags)) {
> +		struct gendisk *disk =3D mpath_head->disk;
> +
> +		del_gendisk(disk);
> +	}
> +}
> +EXPORT_SYMBOL_GPL(mpath_remove_disk);

[Severity: High]
Is there a race here with mpath_device_set_live() that could permanently
leak the gendisk?

If Thread A calls mpath_device_set_live() and sets MPATH_HEAD_DISK_LIVE
locklessly via test_and_set_bit(), and Thread B concurrently calls
mpath_remove_disk(), Thread B will clear the flag and call del_gendisk().

Because device_add_disk() in Thread A hasn't completed and set GD_ADDED
yet, del_gendisk() observes the disk is not live and returns early without
doing anything.=20

Thread A then completes device_add_disk() making the disk live, but the
flag is now 0. Any subsequent mpath_remove_disk() will do nothing, leaking
the active block device.

> +void mpath_put_disk(struct mpath_head *mpath_head)
> +{
> +	if (!mpath_head->disk)
> +		return;
> +
> +	/* make sure all pending bios are cleaned up */
> +	flush_work(&mpath_head->partition_scan_work);
> +	put_disk(mpath_head->disk);
> +}
> +EXPORT_SYMBOL_GPL(mpath_put_disk);
> +
> +int mpath_alloc_head_disk(struct mpath_head *mpath_head,
> +			struct queue_limits *lim, int numa_node)
> +{
> +	if (!mpath_head->disk_groups || !mpath_head->parent)
> +		return -EINVAL;
> +
> +	mpath_head->disk =3D blk_alloc_disk(lim, numa_node);
> +	if (IS_ERR(mpath_head->disk))
> +		return PTR_ERR(mpath_head->disk);

[Severity: High]
If blk_alloc_disk() fails, does this leave an ERR_PTR in mpath_head->disk?

When the driver cleans up on error and calls mpath_put_disk(), the
if (!mpath_head->disk) check will pass because the ERR_PTR is not NULL.
Will this result in a kernel panic when put_disk() attempts to dereference
the invalid pointer?

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20260703102918.3723=
667-1-john.g.garry@oracle.com?part=3D2
