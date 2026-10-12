Received: from verein.lst.de (verein.lst.de [213.95.11.211])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7235F490C12;
	Mon, 12 Oct 2026 14:31:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=213.95.11.211
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791815513; cv=none; b=rvL5gWSiEa+VlfZzCAwGYRwxOvUWqCvYd7D/Yb/A5y16czAkt4OjuTUSlDDCEPFZrcNZ7o6EsJy/DjcStQ5h101lQrBCIN/Em6IJKP8aYM6fY7O/fufh6SgyjUW4DCDyL1OIt2kRRXci8ro5LsbtPR94lIQziMpZRtsrdHSrLUw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791815513; c=relaxed/simple;
	bh=8bxS+YxNhJJ0HlU0hk6WP0aADrsJhyPfgMGXTQ4yz7g=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=JFcyPoOMfJ34BXJYcaYoDIi3SqhM0DvwhqwIQbum2xz9agZD5vwpJfGQ/HefkSsnPrk8gksK4DjSYlujoKvNqjyb41OJhl6YGCxuArp4NgPZ+IdAby+BerqdFl6Z6SGEqWMJygYpGYo+YU+rZe22WfjTkDECH+sIU2Ny1WLfgaU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=lst.de; spf=pass smtp.mailfrom=lst.de; arc=none smtp.client-ip=213.95.11.211
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=lst.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=lst.de
Received: by verein.lst.de (Postfix, from userid 2407)
	id BED79227A88; Mon, 12 Oct 2026 16:31:46 +0200 (CEST)
Date: Mon, 12 Oct 2026 16:31:46 +0200
From: Christoph Hellwig <hch@lst.de>
To: Damien Le Moal <dlemoal@kernel.org>
Cc: Jens Axboe <axboe@kernel.dk>, linux-block@vger.kernel.org,
	Christoph Hellwig <hch@lst.de>, linux-scsi@vger.kernel.org,
	"Martin K . Petersen" <martin.petersen@oracle.com>
Subject: Re: [PATCH v5 4/9] block: add storage element management ioctls
Message-ID: <20261012143146.GB8609@lst.de>
References: <20261012130121.1902634-1-dlemoal@kernel.org> <20261012130121.1902634-5-dlemoal@kernel.org>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20261012130121.1902634-5-dlemoal@kernel.org>
User-Agent: Mutt/1.5.17 (2007-11-01)

On Mon, Oct 12, 2026 at 10:01:16PM +0900, Damien Le Moal wrote:
> +static int blkdev_get_nr_storage_elements_ioctl(struct block_device *bdev,
> +						void __user *argp)
> +{

The normal nameing would be more blkdev_ioctl_foo instead of the
ioctl at the end.

> +	struct gendisk *disk = bdev->bd_disk;
> +
> +	if (put_user(disk->nr_storage_elements, (unsigned int __user *)argp))

Just type the argument as unsigned int and avoid the cast?

> +static int blkdev_report_storage_elements_ioctl(struct block_device *bdev,
> +						void __user *argp)

Same naming and typing nitpick here.

> +{
> +	struct gendisk *disk = bdev->bd_disk;
> +	struct blk_se_report *rep;
> +	int ret;
> +
> +	if (!argp)
> +		return -EINVAL;

copy_from_user will fault on a NULL pointer, so there should be no
need for this.

> +	rep = kzalloc_flex(*rep, elements, disk->nr_storage_elements);
> +	if (!rep)
> +		return -ENOMEM;
> +
> +	if (copy_from_user(rep, argp, sizeof(struct blk_se_report))) {
> +		ret = -EFAULT;
> +		goto free_rep;
> +	}
> +
> +	if (rep->nr_elements < disk->nr_storage_elements) {
> +		ret = -EINVAL;
> +		goto free_rep;
> +	}

Just report the number of elements the user asked for in this case?
That would also allow you to incorporate the nr storage elements query
ioctl into this one by querying for 0 descriptors and just looking at:

> +	rep->nr_reported_elements = disk->nr_storage_elements;

this to size the array in userspace.

> +	ret = bdev_report_storage_elements(bdev, rep->elements,
> +					   &rep->nr_reported_elements);
> +	if (ret)
> +		goto free_rep;
> +
> +	if (copy_to_user(argp, rep, struct_size_t(struct blk_se_report,
> +					elements, rep->nr_reported_elements)))

The indent looks a bit odd here.  Also can't you use struct_size on
rep, e.g.:

	if (copy_to_user(argp, rep,
			struct_size(rep, elements, rep->nr_reported_elements)))

> +static int blkdev_flush_and_truncate(struct block_device *bdev,
> +				     blk_mode_t mode)
> +{
> +	int ret;
> +
> +	inode_lock(bdev->bd_mapping->host);
> +	filemap_invalidate_lock(bdev->bd_mapping);
> +	ret = blkdev_issue_flush(bdev->bd_disk->part0);
> +	if (!ret)
> +		ret = truncate_bdev_range(bdev, mode, 0,
> +					  bdev_nr_bytes(bdev) - 1);
> +	filemap_invalidate_unlock(bdev->bd_mapping);
> +	inode_unlock(bdev->bd_mapping->host);

Sashiko is obviously confused here about partitions that aren't supported
on zoned devices.  The conventional zones argument isn't entirely
stupid, but also not a great one.  Maybe we should add a check to just
reject the ioctls if conventional zones are present, as that would make
a mess of the depop anyway?

> +static int blkdev_remove_storage_element_ioctl(struct block_device *bdev,
> +					blk_mode_t mode, void __user *argp)

The usual naming and type nit here again.  I'm going to stop that now.

