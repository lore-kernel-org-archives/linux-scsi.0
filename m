Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C16CC3B774F
	for <linux-scsi@vger.kernel.org>; Fri,  3 Jul 2026 10:48:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1783075713; cv=none; b=tyCAt7STJXJQwJlEDOniPwpLi7fMwwoDcv+o8k8bXJBX/4VD6hHWW0d0j6ckPwfnPIdayscWW7domFiCZlxLmP39s3QvD8Is+nuXbvM6O/Q+QP1hVZqLb9wpREfGSNm7CQOgDbjKTUA5ukFsevkF2UPProjXzcXeGcqcRoQjydw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1783075713; c=relaxed/simple;
	bh=nd/roxwaq8h8kR1IPY8kefzjiEAIkijUic6Hj70cq5c=;
	h=From:Subject:To:Cc:In-Reply-To:References:Content-Type:Date:
	 Message-Id; b=X31skSj+aTb8NKRaqTy68mm6RYsQLwQArR7hd/m6wFIw1w6FkruB/oYtbr2hEDb9rdDqz0e58H2LdqllJaL90xIaFbwWM0ld776plOjt9J9HXQRysX8vQ/biqFk5opOUL59gVBK2e6HvZKt1hz3yd4DXikNEUZKwXnWnKtNTqQQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=OKhmKd0V; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="OKhmKd0V"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5166A1F000E9;
	Fri,  3 Jul 2026 10:48:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1783075712;
	bh=0SS42den7l6WAuCZ6r60YTaBfYB02zMwghVa/o6LqG8=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=OKhmKd0Vp5aVeaFNyrG80v9OqHleuad8Ktamp7sDcLrWg4ZHmW0wRKN77Nmq9PwHQ
	 sx6Tp58+fJ3DECAyCbEX47mBr470a62WpruJZkXtIdivPsAfkbJuRjO9YxEHR3G2RG
	 x6HiQkbE4thPB4kjBe9uSWn9skCOAtDSIInJXo2Z0KrpOxY/pMa8wRzpVw+tjW/Meg
	 hV9bGtTxjuxmAGiIDtUJpWAtPhJjcxVWATrTSjWxzcKFi7GM8KcDLsju6OBFFSTWag
	 W5lGBMiFu+R8Fw/8pGID/IKE8XGUC3Z50CvTJS8Cl4+5D8AhxLN/QTSeMto57sLR3b
	 Ce4McLgIS5W2g==
From: sashiko-bot@kernel.org
Subject: Re: [PATCH v3 07/13] libmultipath: Add cdev support
Reply-To: sashiko-reviews@lists.linux.dev
To: "John Garry" <john.g.garry@oracle.com>
Cc: linux-scsi@vger.kernel.org
In-Reply-To: <20260703102918.3723667-8-john.g.garry@oracle.com>
References: <20260703102918.3723667-1-john.g.garry@oracle.com>
 <20260703102918.3723667-8-john.g.garry@oracle.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Fri, 03 Jul 2026 10:48:31 +0000
Message-Id: <20260703104832.5166A1F000E9@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>

Thank you for your contribution! Sashiko AI review found 2 potential issue(=
s) to consider:
- [Critical] Dropping the SRCU read lock during ioctl execution leaves the =
`mpath_device` pointer unprotected, causing a use-after-free when passed to=
 `cdev_ioctl` or accessed.
- [High] Decoupled lifetime between the embedded `cdev` and `mpath_head` re=
ference counting leads to Use-After-Free during VFS file open and release.
--

commit 9a6527083c29f0b9d58867aa52ca2ea700cf1168
Author: John Garry <john.g.garry@oracle.com>

libmultipath: Add cdev support

Add support to create a cdev multipath device. The functionality is much
the same as NVMe, where the cdev is created when a mpath device is set
live.

> diff --git a/lib/multipath.c b/lib/multipath.c
> index 78f88b0664c78..6d2e1186a10f8 100644
> --- a/lib/multipath.c
> +++ b/lib/multipath.c

[ ... ]

> +static int mpath_chr_open(struct inode *inode, struct file *file)
> +{
> +	struct cdev *cdev =3D file_inode(file)->i_cdev;
> +	struct mpath_head *mpath_head =3D
> +			container_of(cdev, struct mpath_head, cdev);
> +
> +	return mpath_get_head(mpath_head);
> +}

[Severity: High]
Is there a race condition with driver teardown here?=20

If teardown occurs after the VFS has looked up the cdev but before this
function calls mpath_get_head() to increment the refcount, mpath_head could
be freed, potentially causing a use-after-free when this accesses the freed
memory.

> +
> +static int mpath_chr_release(struct inode *inode, struct file *file)
> +{
> +	struct cdev *cdev =3D file_inode(file)->i_cdev;
> +	struct mpath_head *mpath_head =3D
> +			container_of(cdev, struct mpath_head, cdev);
> +
> +	mpath_put_head(mpath_head);
> +	return 0;
> +}

[Severity: High]
Does this sequence cause the embedded cdev to be freed prematurely?=20

When the last file descriptor is closed, VFS __fput() calls
mpath_chr_release(). If mpath_put_head() drops the mpath_head refcount to 0,
the mpath_head structure (and the embedded cdev) is freed.=20

When this returns, VFS __fput() will subsequently call
cdev_put(inode->i_cdev). Could this result in a use-after-free on the now
freed cdev->kobj?

> +
> +static long mpath_chr_ioctl(struct file *file, unsigned int cmd,
> +		unsigned long arg)
> +{
> +	struct cdev *cdev =3D file_inode(file)->i_cdev;
> +	struct mpath_head *mpath_head =3D
> +			container_of(cdev, struct mpath_head, cdev);
> +	struct mpath_device *mpath_device;
> +	int srcu_idx, err =3D -EWOULDBLOCK;
> +	void *unlocked_ioctl_data =3D NULL;
> +
> +	srcu_idx =3D srcu_read_lock(&mpath_head->srcu);
> +	mpath_device =3D mpath_find_path(mpath_head);
> +	if (!mpath_device)
> +		goto out_unlock;
> +	if (mpath_head->mpdt->ioctl_begin)
> +		mpath_head->mpdt->ioctl_begin(mpath_device, cmd,
> +					&unlocked_ioctl_data);
> +	if (unlocked_ioctl_data)
> +		srcu_read_unlock(&mpath_head->srcu, srcu_idx);
> +	err =3D mpath_head->mpdt->cdev_ioctl(mpath_device, cmd, arg,
> +					file->f_mode & FMODE_WRITE);

[Severity: Critical]
Are we exposing the mpath_device pointer to a use-after-free here?

If unlocked_ioctl_data is present, the SRCU lock is dropped just before
calling cdev_ioctl(). Since the lock is dropped, a concurrent hot-unplug
removal process calling synchronize_srcu() might not wait for this ioctl to
finish and could free the mpath_device.

This would leave the mpath_device pointer unprotected, which is then
immediately passed into cdev_ioctl().=20

Also, does mpath_bdev_ioctl() suffer from this exact same problem when it
calls mpath_device->disk->fops->ioctl() after potentially dropping its SRCU
lock?

> +	if (unlocked_ioctl_data) {
> +		mpath_head->mpdt->ioctl_finish(unlocked_ioctl_data);
> +		return err;
> +	}
> +
> +out_unlock:
> +	srcu_read_unlock(&mpath_head->srcu, srcu_idx);
> +	return err;
> +}

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20260703102918.3723=
667-1-john.g.garry@oracle.com?part=3D7
