Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F2221497B7E
	for <linux-scsi@vger.kernel.org>; Fri,  9 Oct 2026 09:28:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791538132; cv=none; b=Cq0aXnSV/vdcu8M/MRsdVNL5Fm7q3kdyKTVBFacsfwuNtsfoBAfKROvjHVB2ewTHbPnIbUV1nXU+UKurnXTjQNRYih2ASCdnsB4QPaCGGTk+3BlwAWo4O/uSKLXRFJEnTSN2WdEgAN3Dhx4ohSutHRAUWJqh1qBvKGUDDNBqvh0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791538132; c=relaxed/simple;
	bh=OP9Qn096zdgwammVHrhC0dN01yTpcqzfSvfhzwKL8hM=;
	h=Message-ID:From:Subject:To:Cc:In-Reply-To:References:Content-Type:
	 Date; b=ooGDafVSKyg5NszgGmQxo/VTuVSCiHmQl+ob91+px5YFh7XmfCCCZFwzlI8koO6oirGtZZ6Pmcp9unR4m/0QDN5zUcKpVTF+j45LVu+uDaAuU2pRYeFa3DtnLGsJhTcD391AQmyWrAGzhvdvdHlndNBNtXhL8YY3JmmMUT2PdfY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=i70RCGFj; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="i70RCGFj"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AEFD71F00893;
	Fri,  9 Oct 2026 09:28:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1791538130;
	bh=oGk9S4j5SSB0d2x+skZhdTBWiqx4+jfsj+jHO3rLCdg=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=i70RCGFjk9bMF6l+/shodVc5LPA7CiMs2lQYXr47YiLqar7YKMr7OdjTqtFbLwqav
	 vSAQtpHxtL2ak7ey3q+HN7R4i6ZrT5sLDmLVbgg8pzTYZWEqRIhJrqPiXNgdcHQxAt
	 PY2ITEOG/yPzf2ZlSRf7G/eoyNfOBQE1MOzyCe3vQ6NsjKF8kQgYzvn0lWvaDOype+
	 /eNgciz5gamvk8xAa0ajiGBfnfyqzvonIqw6sqHUhdYNQnuxqD/FBPICusE0r6XvpB
	 TXJQrId3rrfm1jABU3nIKwsfLD3NetvQkl06cTtLE7DNze4FHOzGYaVsd5N2M5n17A
	 w3A+6ifwnZ4zw==
Message-ID: <sashiko-outbox-165167@kernel.org>
From: sashiko-bot@kernel.org
Subject: Re: [PATCH v4 4/9] block: add storage element management ioctls
Reply-To: sashiko-reviews@lists.linux.dev
To: "Damien Le Moal" <dlemoal@kernel.org>
Cc: linux-scsi@vger.kernel.org
In-Reply-To: <20261009090945.1504194-5-dlemoal@kernel.org>
References: <20261009090945.1504194-1-dlemoal@kernel.org>
 <20261009090945.1504194-5-dlemoal@kernel.org>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Fri, 09 Oct 2026 09:28:50 +0000
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>

Thank you for your contribution! Sashiko AI review found 2 potential issue(=
s) to consider:
- [High] block: concurrent direct I/O races with storage element reconfigur=
ation
- [High] block: Unbounded polling loop holds inode_lock and zone_revalidate=
_mutex causing Hung Task panics
--

commit e4cab0ff5a156be0f826cb9112e51fcf1c9f08e0
Author: Damien Le Moal <dlemoal@kernel.org>

block: add storage element management ioctls

Define the new ioctl commands BLKGETNRSTORELEMS, BLKREPORTSTORELEMS,
BLKREMOVESTORELEM, and BLKRESTORESTORELEMS to provide users accessing
zoned block devices directly with an interface to the storage elements
management operations of the block layer.

> diff --git a/block/blk-zoned.c b/block/blk-zoned.c
> index 8ca5470d65173..10fb3ca5adcd6 100644
> --- a/block/blk-zoned.c
> +++ b/block/blk-zoned.c

[ ... ]

> @@ -2895,6 +2946,54 @@ int bdev_remove_storage_element(struct block_devic=
e *bdev,
>  }
>  EXPORT_SYMBOL_GPL(bdev_remove_storage_element);
> =20
> +static int blkdev_flush_and_truncate(struct block_device *bdev,
> +				     blk_mode_t mode)
> +{
> +	int ret;
> +
> +	filemap_invalidate_lock(bdev->bd_mapping);
> +	ret =3D blkdev_issue_flush(bdev->bd_disk->part0);
> +	if (!ret)
> +		ret =3D truncate_bdev_range(bdev, mode, 0,
> +					  bdev_nr_bytes(bdev) - 1);
> +	filemap_invalidate_unlock(bdev->bd_mapping);
> +
> +	return ret;
> +}
> +
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
> +	inode_lock(bdev->bd_mapping->host);
> +
> +	/*
> +	 * Flush the device volatile write cache and invalidate all cached data
> +	 * so that reads do not return old data for zones that went offline.
> +	 * Since a user can only write to zoned devices using direct IOs, we
> +	 * should never have any dirty page invalidated and so no data loss as
> +	 * long as the device cache flush succeeds, that is, as long as the
> +	 * flush does not use degraded storage elements.
> +	 */
> +	ret =3D blkdev_flush_and_truncate(bdev, mode);
> +	if (!ret)
> +		ret =3D bdev_remove_storage_element(bdev, element_id);

[Severity: High]
Does this actually prevent concurrent direct I/O?

The comment implies that inode_lock() will prevent concurrent direct I/O
during the hardware operation. However, blkdev_write_iter() and
blkdev_read_iter() explicitly bypass inode_lock() for block devices when
IOCB_DIRECT is set.

Since bdev_remove_storage_element() explicitly unfreezes the block queue
to allow the management command to execute, couldn't concurrent O_DIRECT re=
ads
and writes be issued to the device, bypassing the VFS lock and racing with =
the
destructive hardware reconfiguration?

[Severity: High]
Can holding these locks during the operation cause a Hung Task panic?

bdev_remove_storage_element() acquires zone_revalidate_mutex and then waits
for the hardware operation to complete via disk_wait_for_se_mgmt_completion=
(),
which contains an unbounded polling loop using msleep(1000).

Because this loop runs while both inode_lock() and zone_revalidate_mutex are
held, any concurrent task attempting to acquire either lock=E2=80=94such as
blk_revalidate_disk_zones() or a buffered I/O operation=E2=80=94will be blo=
cked in
TASK_UNINTERRUPTIBLE. If the hardware reconfiguration takes longer than 120
seconds, won't this trigger the kernel's Hung Task watchdog and panic the
system?

> +
> +	inode_unlock(bdev->bd_mapping->host);
> +
> +	return ret;
> +}

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20261009090945.1504=
194-1-dlemoal@kernel.org?part=3D4
