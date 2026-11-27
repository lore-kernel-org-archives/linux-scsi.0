Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795747532;
	b=Y7oMwTPLBn7z271qIYVfC/31+FfgTiAzUChVNJKUTWMaJPFr7OLDbCf0IjS+GSymaDIx
	 afv1LynEs/UrVZvLz84QqHfsLbuD+9ajzpr7mxEejwrvZ0Fh4wbTS9ngOAw2wbNBr4PhK
	 9H7yeipp5eu3umY1iI7mTIfCpZyKC7kLW6gk1kFm8WJSOL+2OYVl1Jc1+cd7e3jAoyvcB
	 8slZ8s9rJh//08qlA8C++9IlE3afhRckh7+u5fouqiPpx1k2H1PZmBsmV1vsi8FZkrd6C
	 PMBBf7tdrl+QfR9GpJ13GAOLy42cMzvw6XGqHVHM5ick7dZ5IZMXXDYOjvtTGdbfozw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795747532;
	h=Received:DKIM-Signature:Message-ID:From:Subject:Reply-To:To:Cc:
	 In-Reply-To:References:Content-Type:Content-Transfer-Encoding:Date;
	bh=K6wAuMX29qVgObEsC+wl2OggAcCv3DDZc6r4h3BUsY4=;
	b=Uq3aBzthCg+ly9B1gfrJVNqNohdHUXjzkmEU2TOSQM970VTokKI4stIeWt+TgtJW7idO
	 xK+tLafovDR4ZYoycprOjRLC1ehtFhZcdFaU5h7QB7ObfVnVKE864soqfDTSB5+oSTcZ8
	 wStD6TuMrV/Lv3L6GW+v18jIe6mX5Dic23CekAZIejmXh3krepCzMYNdWaqdcJHdk31YE
	 aMO98Ny32KhxaAV1Igrje2K4vsg4uIE8C/c2L1i0UeEVaPkATOxEUOgtxQh+NAJzCM/9e
	 7AaPwUoBJje45AxnqEF1bqISFMGVHaVnIsIrVjc4hKVz4SP1GGKgCt4oiH25UrWWhvQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=eiTMIs0M;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0C5E8606A31C;
	Fri, 27 Nov 2026 02:45:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=eiTMIs0M
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A21781F00897;
	Fri, 27 Nov 2026 02:45:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1795747531;
	bh=K6wAuMX29qVgObEsC+wl2OggAcCv3DDZc6r4h3BUsY4=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=eiTMIs0Mc04lLzbafmqzlzZIKCg/gQeBulKRHs+pcf6ZADtbfswIsZHo2p1xUI835
	 iU6a/ly8erhRFXyVQebUVudzam4V4na/af4Q6QABPfySNClJslj+ejA8sH/5aZyWv/
	 W6Sl2AGK0PkSo1GV+nP2iKT8POP6CpArJ7FSCpaGDR1+2hzxuKnmDa+LitnOGxWDCm
	 xa2ScrZ3mRORNBixrR/RA2KPwt179OzluoTlTbDmgkMUNs9LQt37xSwPS88yQA64YF
	 eshqhP1HsaiJAAYLDtBDTKLlSr8AOeGNdp8yHxOV1Qrq4ZenPe7/cAt+QpQ5AYudVa
	 HguHatrPr79pw==
Message-ID: <sashiko-outbox-236459@kernel.org>
From: sashiko-bot@kernel.org
Subject: Re: [PATCH 1/1] tcmu: Fix inode use-after-free in global data block
 pool
Reply-To: sashiko-reviews@lists.linux.dev
To: "Tao Zou" <zoutao@linux.alibaba.com>
Cc: linux-scsi@vger.kernel.org, target-devel@vger.kernel.org
In-Reply-To: <20261127023346.37933-2-zoutao@linux.alibaba.com>
References: <20261127023346.37933-1-zoutao@linux.alibaba.com>
 <20261127023346.37933-2-zoutao@linux.alibaba.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Fri, 27 Nov 2026 02:45:31 +0000
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Post: <mailto:linux-scsi@vger.kernel.org>
List-Help: <mailto:linux-scsi+help@vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-scsi+owner@vger.kernel.org>
Precedence: list

Thank you for your contribution! Sashiko AI review found 1 potential
issue to consider:
- [High] tcmu: pinning udev->inode past tcmu_release() breaks superblock
  unmount
--

commit b2536748e9ead622de5208515ec23331a1f19191
Author: Tao Zou <zoutao@linux.alibaba.com>

tcmu: Fix inode use-after-free in global data block pool

This commit takes an inode reference in tcmu_open() under cmdr_lock and
holds it until tcmu_dev_kref_release() or a subsequent reopen so
find_free_blocks() does not dereference a reclaimed inode after the UIO
device is closed.

> diff --git a/drivers/target/target_core_user.c b/drivers/target/target_co=
re_user.c
> index 80da90accac56..1bd53cdd1d964 100644
> --- a/drivers/target/target_core_user.c
> +++ b/drivers/target/target_core_user.c
> @@ -1741,6 +1741,8 @@ static void tcmu_dev_kref_release(struct kref *kref)
>  	bitmap_free(udev->data_bitmap);
>  	mutex_unlock(&udev->cmdr_lock);
> =20
> +	iput(udev->inode);
> +
>  	pr_debug("dev_kref_release\n");
> =20
>  	call_rcu(&dev->rcu_head, tcmu_dev_call_rcu);
> @@ -1954,12 +1956,21 @@ static int tcmu_mmap_prepare(struct uio_info *inf=
o, struct vm_area_desc *desc)
>  static int tcmu_open(struct uio_info *info, struct inode *inode)
>  {
>  	struct tcmu_dev *udev =3D container_of(info, struct tcmu_dev, uio_info);
> +	struct inode *old_inode;
> =20
>  	/* O_EXCL not supported for char devs, so fake it? */
>  	if (test_and_set_bit(TCMU_DEV_BIT_OPEN, &udev->flags))
>  		return -EBUSY;
> =20
> +	/* find_free_blocks() may use the inode after the last UIO close. */
> +	ihold(inode);
> +
> +	mutex_lock(&udev->cmdr_lock);
> +	old_inode =3D udev->inode;
>  	udev->inode =3D inode;
> +	mutex_unlock(&udev->cmdr_lock);
> +
> +	iput(old_inode);
> =20
>  	pr_debug("open\n");

[Severity: High]
Can holding udev->inode past tcmu_release() leave a busy inode when the
filesystem hosting the character device node is unmounted?

After the last file descriptor and all VMAs are closed, __fput() invokes
tcmu_release() and drops the file's dentry and vfsmount references.
Because ihold() does not pin the mount or sb->s_active, unmounting that
filesystem while the TCMU device is still configured reaches
generic_shutdown_super() with udev->inode still on sb->s_inodes,
triggering CHECK_DATA_CORRUPTION ("VFS: Busy inodes after unmount") and
poisoning inode->i_op, inode->i_sb, and inode->i_mapping with
VFS_PTR_POISON.  Any later find_free_blocks() call or final iput() then
dereferences VFS_PTR_POISON.

Since __fput() only calls tcmu_release() after all VMAs mapping the file
have been unmapped, could tcmu_release() instead clear udev->inode =3D NULL
under udev->cmdr_lock and find_free_blocks() skip unmap_mapping_range()
when udev->inode is NULL?

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20261127023346.3793=
3-1-zoutao@linux.alibaba.com?part=3D1
