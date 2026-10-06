Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4362B3DDDDD
	for <linux-scsi@vger.kernel.org>; Tue,  6 Oct 2026 13:02:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791291780; cv=none; b=bMyOAISIAWFowUmcs0NbedohLJaOmjCFgOeFP2cfyLK7xX8Kr7Bm+GlybDzFL9/ovLJhpB+QLd6lLId8Cb2QKsCfUlzXwS9w2tcHD0zS/A12yzCLbThVbTrYIvBTitKu9BENbntSviubsPBpTvaoPwobuncJ4AlcRoqhLMnmLus=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791291780; c=relaxed/simple;
	bh=rqtYQ8ZwZh7FIPFk/leczIKALu8A9eM83jJdcELlIXE=;
	h=From:Subject:To:Cc:In-Reply-To:References:Content-Type:Date:
	 Message-Id; b=dzE3gUHIJJCVu3H8HRF+abz8NiZzJCVtCdoAOAe03KFVCdR2P+2oP5xhlWge9CWKzlcw/l5wYR2ce/GHiH+MVBLy2v/4mNxOWoM1cx/4w2fA9gJAEZ1eSfXCtH1gB8dN3/n28P2GCW4w5wXiqNFPm/uFsxokHpsLqaPDBK9HFPc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=RZ5quJZR; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="RZ5quJZR"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A84261F000FF;
	Tue,  6 Oct 2026 13:02:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1791291778;
	bh=cxB3AYVG3Wcf6K3uUcT6BgjSD1i6yGRqmG2kUD6GN7U=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=RZ5quJZROW/O8unv0gNHYEafS6snaD0MX6zfit63n7z7GFM9IEtfHFVMua/9lO2BM
	 OUuS8CKMD+XgAoFCpZsPzQ8ddHI9uivtvEQshwwYYrMh/Sl614icANfJxGyRlTAuV+
	 +cWpgV4OPB1MqnUvOfsmOZ92EDbRdu5l3A/+KMVc6zd0hIvRkqrgCb2/0MKbaOcVfM
	 oOx3rXlM8M31CzfmDWJxbvcB7+YkDsyJwPlcfijR3WT0pC3MRjk4A2ZiA34BtFGzPz
	 GjYN+pBGVpheFk2MWFcPq+rP12bumPQK+KPMm/NGEj5XkODmHMTRoh4UO/vibW1cDN
	 ZlpyTSqn3rGYA==
From: sashiko-bot@kernel.org
Subject: Re: [PATCH v2 3/7] block: add storage element management ioctls
Reply-To: sashiko-reviews@lists.linux.dev
To: "Damien Le Moal" <dlemoal@kernel.org>
Cc: linux-scsi@vger.kernel.org
In-Reply-To: <20261006124510.882017-4-dlemoal@kernel.org>
References: <20261006124510.882017-1-dlemoal@kernel.org>
 <20261006124510.882017-4-dlemoal@kernel.org>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Tue, 06 Oct 2026 13:02:58 +0000
Message-Id: <20261006130258.A84261F000FF@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>

Thank you for your contribution! Sashiko AI review found 2 potential issue(=
s) to consider:
- [Critical] block: silent data loss via full truncation without writeback
- [High] block: unkillable task and VFS deadlock in disk_wait_for_se_mgmt_c=
ompletion()
--

commit 9851d611abe8fdc4d981018f157a08dd381fede2
Author: Damien Le Moal <dlemoal@kernel.org>
block: add storage element management ioctls

This commit introduces four new ioctls (BLKGETNRSTORELEMS, BLKREPORTSTORELE=
MS,
BLKREMOVESTORELEM, and BLKRESTORESTORELEMS) for managing storage elements on
zoned block devices. It allows querying, removing, and restoring degraded
storage elements from userspace.

> diff --git a/block/blk-zoned.c b/block/blk-zoned.c
> index be57644ee2663..6ebb04e0a1593 100644
> --- a/block/blk-zoned.c
> +++ b/block/blk-zoned.c

[ ... ]

> +static int blkdev_remove_storage_element_ioctl(struct block_device *bdev,
> +					blk_mode_t mode, void __user *argp)
> +{
> +	unsigned int element_id;
> +	int ret;
> +
> +	if (!(mode & BLK_OPEN_WRITE))
> +		return -EBADF;
> +	if (bdev_read_only(bdev))
> +		return -EPERM;
> +
> +	if (get_user(element_id, (unsigned int __user *)argp))
> +		return -EFAULT;
> +
> +	/*
> +	 * Flush the device volatile write cache and invalidate all cached data
> +	 * so that reads do not return old data for zones that went offline.
> +	 */
> +	inode_lock(bdev->bd_mapping->host);
> +	filemap_invalidate_lock(bdev->bd_mapping);
> +
> +	ret =3D blkdev_issue_flush(bdev->bd_disk->part0);
> +	if (ret)
> +		goto out_unlock;
> +
> +	ret =3D truncate_bdev_range(bdev, mode, 0,
> +			(get_capacity(bdev->bd_disk) << SECTOR_SHIFT) - 1);

[Severity: Critical]
Does this truncate the full block device page cache without prior writeback?

The code issues a hardware cache flush via blkdev_issue_flush() but appears
to completely skip writing back dirty pages in the OS page cache (e.g., via
sync_blockdev()). The subsequent truncate_bdev_range() call unconditionally
drops all page cache entries, which could discard dirty data even for zones
that are completely unaffected by the storage element operation.

> +	if (ret)
> +		goto out_unlock;
> +
> +	ret =3D bdev_remove_storage_element(bdev, element_id);

[Severity: High]
Could this lead to a VFS deadlock and an unkillable task if the device hang=
s?

VFS locks (inode_lock and filemap_invalidate_lock) are acquired earlier in
this function before calling bdev_remove_storage_element(). Inside that
function, it delegates to the driver and waits for completion. Looking at
disk_wait_for_se_mgmt_completion(), it uses an infinite loop:

    while (1) {
        ...
        /* Not done yet: wait and retry. */
        msleep(500);
    }

If the device takes an extended time to complete or stops responding, the
polling task can become unkillable because it lacks a timeout, max retry
bound, or fatal_signal_pending() check. Because the ioctl caller holds the
block device's i_rwsem and invalidate_lock during this wait, a hung device
could permanently lock out all other processes attempting to access the blo=
ck
device.

> +
> +out_unlock:
> +	filemap_invalidate_unlock(bdev->bd_mapping);
> +	inode_unlock(bdev->bd_mapping->host);
> +
> +	return ret;
> +}

[ ... ]

> +static int blkdev_restore_storage_elements_ioctl(struct block_device *bd=
ev,
> +						 blk_mode_t mode)
> +{
> +	int ret;
> +
> +	if (!(mode & BLK_OPEN_WRITE))
> +		return -EBADF;
> +	if (bdev_read_only(bdev))
> +		return -EPERM;
> +
> +	/*
> +	 * Flush the device volatile write cache and invalidate all cached data
> +	 * so that reads do not return old data for zones that went offline.
> +	 */
> +	inode_lock(bdev->bd_mapping->host);
> +	filemap_invalidate_lock(bdev->bd_mapping);
> +
> +	ret =3D blkdev_issue_flush(bdev->bd_disk->part0);
> +	if (ret)
> +		goto out_unlock;
> +
> +	ret =3D truncate_bdev_range(bdev, mode, 0,
> +			(get_capacity(bdev->bd_disk) << SECTOR_SHIFT) - 1);

[Severity: Critical]
Does this also drop dirty pages without prior writeback?

Similar to blkdev_remove_storage_element_ioctl(), this appears to truncate
the entire device's page cache unconditionally after issuing a hardware flu=
sh,
which skips writing back dirty pages in the OS page cache first.

> +	if (ret)
> +		goto out_unlock;
> +
> +	ret =3D bdev_restore_storage_elements(bdev);

[Severity: High]
Does this code also suffer from the same VFS deadlock risk?

Similar to the issue above, bdev_restore_storage_elements() invokes
disk_wait_for_se_mgmt_completion() while holding both inode_lock and
filemap_invalidate_lock, which could permanently stall other processes
accessing the block device if the device becomes unresponsive.

> +
> +out_unlock:
> +	filemap_invalidate_unlock(bdev->bd_mapping);
> +	inode_unlock(bdev->bd_mapping->host);
> +
> +	return ret;
> +}

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20261006124510.8820=
17-1-dlemoal@kernel.org?part=3D3
