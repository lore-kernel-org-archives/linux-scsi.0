Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E8F0B6AA1
	for <linux-scsi@vger.kernel.org>; Mon,  6 Jan 2025 01:02:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1736125381; cv=none; b=ahgw0ubNqNdZFtFbjtshSHSbbPZiQ4ByLxusNevfwJ5u03+KbdqKTv6vrbFGWpI+71avfujNm7riR3/eycawHtodoiM0ooBP20O8Po85EHcAHDZQTKNxM98KJSUU63F1lF+JH7EO5I0UXIG5T0xUp8Dp0UcAmkbRX9GOMenwsSc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1736125381; c=relaxed/simple;
	bh=xkA9Zn4X+yXH0UCvxYk2j6Y84OjTJkiwW/YxuPC0dGQ=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=QHpeUENd2oyvRJXvUbg2DWXdB4rQsapcGWrzi1eL5EiZ29Wzcax89wYkorKgstVbiEc4F3dm+YJuuDfa4xgjgADY/LPpT9cWnqd+XvNSPOAZWoV5lMJyi9uj89hwhaJXOcruEFMP7p28ISDy5Ar7e1EblsaioRTGJRWdcA+xdCc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=HvMJzdgB; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="HvMJzdgB"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1736125377;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=YbqGzPiKkL3ajVfxkjBcXwRnDm5TOVG5O+I58IgqVCQ=;
	b=HvMJzdgB1ZWb8OhWDb18g0R+EVBP+1/pRerNIT7JxX7YH4EKxJpOPNwlKOCdOCV3/hQ6bW
	cVaZvFD92HrqCfH/T8vZEKu4yg7tk9Se7VvHgct8rO98AMo0iVKkBOCqBoauG+SgqHd8l/
	QhSa/VNovf1vIbqfttJiNJlYabUXSHc=
Received: from mx-prod-mc-04.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-54-186-198-63.us-west-2.compute.amazonaws.com [54.186.198.63]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-646-xMFBPXKTPNmxdXz0jm0DHw-1; Sun,
 05 Jan 2025 20:02:54 -0500
X-MC-Unique: xMFBPXKTPNmxdXz0jm0DHw-1
X-Mimecast-MFC-AGG-ID: xMFBPXKTPNmxdXz0jm0DHw
Received: from mx-prod-int-02.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-02.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.15])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-04.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id 7318F19560A2;
	Mon,  6 Jan 2025 01:02:52 +0000 (UTC)
Received: from fedora (unknown [10.72.116.65])
	by mx-prod-int-02.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id 8C0F11956088;
	Mon,  6 Jan 2025 01:02:47 +0000 (UTC)
Date: Mon, 6 Jan 2025 09:02:42 +0800
From: Ming Lei <ming.lei@redhat.com>
To: Damien Le Moal <dlemoal@kernel.org>
Cc: "Martin K . Petersen" <martin.petersen@oracle.com>,
	linux-scsi@vger.kernel.org, linux-block@vger.kernel.org,
	Christoph Hellwig <hch@lst.de>, Nilay Shroff <nilay@linux.ibm.com>
Subject: Re: [PATCH] scsi: avoid to send scsi command with ->queue_limits
 lock held
Message-ID: <Z3srsii5EhZmnU9D@fedora>
References: <20241231042241.171227-1-ming.lei@redhat.com>
 <770947cc-6ce9-4ef0-8577-6966c7b8d555@kernel.org>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <770947cc-6ce9-4ef0-8577-6966c7b8d555@kernel.org>
X-Scanned-By: MIMEDefang 3.0 on 10.30.177.15

On Sat, Jan 04, 2025 at 04:17:47PM +0900, Damien Le Moal wrote:
> On 12/31/24 13:22, Ming Lei wrote:
> > Block request queue is often frozen before acquiring the queue
> > ->limits_lock.
> 
> "often" is rather vague. What cases are we talking about here beside the block
> layer sysfs ->store() operations ? Fixing these is easy and does not need this
> change.

Is it really necessary to make freeze lock to depend on ->limits_lock?

sd_revalidate_disk() is really one special case, so I think this patch
does correct thing.

> 
> Furthermore, this change almost feels like a layering violation as it replicates
> most of the queue limits structure inside sd. This introducing a strong
> dependency to the block layer internals which we should avoid.

No.

block layer is common library, which is storage abstraction, so it is
pretty reasonable for storage drivers to depend block layer. You can
look at it from another way, if any related queue limits change, the
current storage driver need corresponding change too, with or without
this change.

> 
> > 
> > However, in sd_revalidate_disk(), queue_limits_start_update() is called
> > before reading all kinds of queue limits from hardware, and this way
> > causes ABBA lock easily[1][2] because queue usage counter is grabbed
> > when allocating scsi command.
> > 
> > [1] https://lore.kernel.org/linux-block/Z1A8fai9_fQFhs1s@hovoldconsulting.com/
> > [2] https://lore.kernel.org/linux-scsi/ZxG38G9BuFdBpBHZ@fedora/
> > 
> > Fix the issue by reading limits into one scsi disk shadow queue limits
> > structure first, then sync it to the block queue limits with
> > ->limits_lock.
> > 
> > Cc: Christoph Hellwig <hch@lst.de>
> > Cc: Damien Le Moal <dlemoal@kernel.org>
> > Cc: Nilay Shroff <nilay@linux.ibm.com>
> > Fixes: 804e498e0496 ("sd: convert to the atomic queue limits API")
> > Signed-off-by: Ming Lei <ming.lei@redhat.com>
> > ---
> >  drivers/scsi/sd.c     | 156 +++++++++++++++++++++++++++++++-----------
> >  drivers/scsi/sd.h     |  59 +++++++++++++++-
> >  drivers/scsi/sd_dif.c |   3 +-
> >  drivers/scsi/sd_zbc.c |  14 ++--
> >  4 files changed, 181 insertions(+), 51 deletions(-)
> > 
> > diff --git a/drivers/scsi/sd.c b/drivers/scsi/sd.c
> > index 8947dab132d7..6af5334dee2f 100644
> > --- a/drivers/scsi/sd.c
> > +++ b/drivers/scsi/sd.c
> > @@ -102,10 +102,10 @@ MODULE_ALIAS_SCSI_DEVICE(TYPE_ZBC);
> >  
> >  #define SD_MINORS	16
> >  
> > -static void sd_config_discard(struct scsi_disk *sdkp, struct queue_limits *lim,
> > +static void sd_config_discard(struct scsi_disk *sdkp, struct sd_limits *lim,
> >  		unsigned int mode);
> >  static void sd_config_write_same(struct scsi_disk *sdkp,
> > -		struct queue_limits *lim);
> > +		struct sd_limits *lim);
> >  static int  sd_revalidate_disk(struct gendisk *);
> >  static void sd_unlock_native_capacity(struct gendisk *disk);
> >  static void sd_shutdown(struct device *);
> > @@ -121,8 +121,64 @@ static const char *sd_cache_types[] = {
> >  	"write back, no read (daft)"
> >  };
> >  
> > +static void sd_sync_limits(struct queue_limits *blk_lim,
> > +		const struct sd_limits *lim)
> > +{
> > +	if (lim->has_features)
> > +		blk_lim->features |= lim->features;
> > +
> > +	if (lim->has_neg_features)
> > +		blk_lim->features &= ~lim->neg_features;
> > +
> > +	if (lim->has_alignment_offset)
> > +		blk_lim->alignment_offset = lim->alignment_offset;
> > +
> > +	if (lim->has_integrity)
> > +		blk_lim->integrity = lim->integrity;
> > +
> > +	if (lim->has_bs) {
> > +		blk_lim->logical_block_size = lim->bs.logical_block_size;
> > +		blk_lim->physical_block_size = lim->bs.physical_block_size;
> > +	}
> > +
> > +	if (lim->has_discard) {
> > +		blk_lim->discard_granularity =
> > +			lim->discard.discard_granularity;
> > +		blk_lim->discard_alignment =
> > +			lim->discard.discard_alignment;
> > +		blk_lim->max_hw_discard_sectors =
> > +			lim->discard.max_hw_discard_sectors;
> > +	}
> > +
> > +	if (lim->has_ws)
> > +		blk_lim->max_write_zeroes_sectors =
> > +			lim->ws.max_write_zeroes_sectors;
> > +
> > +	if (lim->has_aw) {
> > +		blk_lim->atomic_write_hw_max = lim->aw.atomic_write_hw_max;
> > +		blk_lim->atomic_write_hw_boundary =
> > +			lim->aw.atomic_write_hw_boundary;
> > +		blk_lim->atomic_write_hw_unit_min =
> > +			lim->aw.atomic_write_hw_unit_min;
> > +		blk_lim->atomic_write_hw_unit_max =
> > +			lim->aw.atomic_write_hw_unit_max;
> > +	}
> > +
> > +	if (lim->has_io) {
> > +		blk_lim->max_dev_sectors = lim->io.max_dev_sectors;
> > +		blk_lim->io_opt = lim->io.io_opt;
> > +		blk_lim->io_min = lim->io.io_min;
> > +	}
> > +
> > +	if (lim->has_zone) {
> > +		blk_lim->max_open_zones = lim->zone.max_open_zones;
> > +		blk_lim->max_active_zones = lim->zone.max_active_zones;
> > +		blk_lim->chunk_sectors = lim->zone.chunk_sectors;
> > +	}
> > +}
> > +
> >  static void sd_set_flush_flag(struct scsi_disk *sdkp,
> > -		struct queue_limits *lim)
> > +		struct sd_limits *lim)
> >  {
> >  	if (sdkp->WCE) {
> >  		lim->features |= BLK_FEAT_WRITE_CACHE;
> > @@ -133,6 +189,7 @@ static void sd_set_flush_flag(struct scsi_disk *sdkp,
> >  	} else {
> >  		lim->features &= ~(BLK_FEAT_WRITE_CACHE | BLK_FEAT_FUA);
> >  	}
> > +	lim->has_features = 1;
> >  }
> >  
> >  static ssize_t
> > @@ -170,15 +227,18 @@ cache_type_store(struct device *dev, struct device_attribute *attr,
> >  	wce = (ct & 0x02) && !sdkp->write_prot ? 1 : 0;
> >  
> >  	if (sdkp->cache_override) {
> > -		struct queue_limits lim;
> > +		struct queue_limits blk_lim;
> > +		struct sd_limits lim = { 0 };
> >  
> >  		sdkp->WCE = wce;
> >  		sdkp->RCD = rcd;
> >  
> > -		lim = queue_limits_start_update(sdkp->disk->queue);
> >  		sd_set_flush_flag(sdkp, &lim);
> > +
> > +		blk_lim = queue_limits_start_update(sdkp->disk->queue);
> > +		sd_sync_limits(&blk_lim, &lim);
> >  		blk_mq_freeze_queue(sdkp->disk->queue);
> > -		ret = queue_limits_commit_update(sdkp->disk->queue, &lim);
> > +		ret = queue_limits_commit_update(sdkp->disk->queue, &blk_lim);
> >  		blk_mq_unfreeze_queue(sdkp->disk->queue);
> >  		if (ret)
> >  			return ret;
> > @@ -468,7 +528,8 @@ provisioning_mode_store(struct device *dev, struct device_attribute *attr,
> >  {
> >  	struct scsi_disk *sdkp = to_scsi_disk(dev);
> >  	struct scsi_device *sdp = sdkp->device;
> > -	struct queue_limits lim;
> > +	struct queue_limits blk_lim;
> > +	struct sd_limits lim = { 0 };
> >  	int mode, err;
> >  
> >  	if (!capable(CAP_SYS_ADMIN))
> > @@ -481,10 +542,11 @@ provisioning_mode_store(struct device *dev, struct device_attribute *attr,
> >  	if (mode < 0)
> >  		return -EINVAL;
> >  
> > -	lim = queue_limits_start_update(sdkp->disk->queue);
> >  	sd_config_discard(sdkp, &lim, mode);
> > +	blk_lim = queue_limits_start_update(sdkp->disk->queue);
> > +	sd_sync_limits(&blk_lim, &lim);
> >  	blk_mq_freeze_queue(sdkp->disk->queue);
> > -	err = queue_limits_commit_update(sdkp->disk->queue, &lim);
> > +	err = queue_limits_commit_update(sdkp->disk->queue, &blk_lim);
> >  	blk_mq_unfreeze_queue(sdkp->disk->queue);
> >  	if (err)
> >  		return err;
> > @@ -570,7 +632,8 @@ max_write_same_blocks_store(struct device *dev, struct device_attribute *attr,
> >  {
> >  	struct scsi_disk *sdkp = to_scsi_disk(dev);
> >  	struct scsi_device *sdp = sdkp->device;
> > -	struct queue_limits lim;
> > +	struct queue_limits blk_lim;
> > +	struct sd_limits lim = { 0 };
> >  	unsigned long max;
> >  	int err;
> >  
> > @@ -592,10 +655,11 @@ max_write_same_blocks_store(struct device *dev, struct device_attribute *attr,
> >  		sdkp->max_ws_blocks = max;
> >  	}
> >  
> > -	lim = queue_limits_start_update(sdkp->disk->queue);
> >  	sd_config_write_same(sdkp, &lim);
> > +	blk_lim = queue_limits_start_update(sdkp->disk->queue);
> > +	sd_sync_limits(&blk_lim, &lim);
> >  	blk_mq_freeze_queue(sdkp->disk->queue);
> > -	err = queue_limits_commit_update(sdkp->disk->queue, &lim);
> > +	err = queue_limits_commit_update(sdkp->disk->queue, &blk_lim);
> >  	blk_mq_unfreeze_queue(sdkp->disk->queue);
> >  	if (err)
> >  		return err;
> > @@ -847,14 +911,14 @@ static void sd_disable_discard(struct scsi_disk *sdkp)
> >  	blk_queue_disable_discard(sdkp->disk->queue);
> >  }
> >  
> > -static void sd_config_discard(struct scsi_disk *sdkp, struct queue_limits *lim,
> > +static void sd_config_discard(struct scsi_disk *sdkp, struct sd_limits *lim,
> >  		unsigned int mode)
> >  {
> >  	unsigned int logical_block_size = sdkp->device->sector_size;
> >  	unsigned int max_blocks = 0;
> >  
> > -	lim->discard_alignment = sdkp->unmap_alignment * logical_block_size;
> > -	lim->discard_granularity = max(sdkp->physical_block_size,
> > +	lim->discard.discard_alignment = sdkp->unmap_alignment * logical_block_size;
> > +	lim->discard.discard_granularity = max(sdkp->physical_block_size,
> >  			sdkp->unmap_granularity * logical_block_size);
> >  	sdkp->provisioning_mode = mode;
> >  
> > @@ -893,8 +957,9 @@ static void sd_config_discard(struct scsi_disk *sdkp, struct queue_limits *lim,
> >  		break;
> >  	}
> >  
> > -	lim->max_hw_discard_sectors = max_blocks *
> > +	lim->discard.max_hw_discard_sectors = max_blocks *
> >  		(logical_block_size >> SECTOR_SHIFT);
> > +	lim->has_discard = 1;
> >  }
> >  
> >  static void *sd_set_special_bvec(struct request *rq, unsigned int data_len)
> > @@ -940,7 +1005,7 @@ static blk_status_t sd_setup_unmap_cmnd(struct scsi_cmnd *cmd)
> >  	return scsi_alloc_sgtables(cmd);
> >  }
> >  
> > -static void sd_config_atomic(struct scsi_disk *sdkp, struct queue_limits *lim)
> > +static void sd_config_atomic(struct scsi_disk *sdkp, struct sd_limits *lim)
> >  {
> >  	unsigned int logical_block_size = sdkp->device->sector_size,
> >  		physical_block_size_sectors, max_atomic, unit_min, unit_max;
> > @@ -992,10 +1057,11 @@ static void sd_config_atomic(struct scsi_disk *sdkp, struct queue_limits *lim)
> >  			return;
> >  	}
> >  
> > -	lim->atomic_write_hw_max = max_atomic * logical_block_size;
> > -	lim->atomic_write_hw_boundary = 0;
> > -	lim->atomic_write_hw_unit_min = unit_min * logical_block_size;
> > -	lim->atomic_write_hw_unit_max = unit_max * logical_block_size;
> > +	lim->aw.atomic_write_hw_max = max_atomic * logical_block_size;
> > +	lim->aw.atomic_write_hw_boundary = 0;
> > +	lim->aw.atomic_write_hw_unit_min = unit_min * logical_block_size;
> > +	lim->aw.atomic_write_hw_unit_max = unit_max * logical_block_size;
> > +	lim->has_aw = 1;
> >  }
> >  
> >  static blk_status_t sd_setup_write_same16_cmnd(struct scsi_cmnd *cmd,
> > @@ -1088,7 +1154,7 @@ static void sd_disable_write_same(struct scsi_disk *sdkp)
> >  }
> >  
> >  static void sd_config_write_same(struct scsi_disk *sdkp,
> > -		struct queue_limits *lim)
> > +		struct sd_limits *lim)
> >  {
> >  	unsigned int logical_block_size = sdkp->device->sector_size;
> >  
> > @@ -1143,8 +1209,9 @@ static void sd_config_write_same(struct scsi_disk *sdkp,
> >  	}
> >  
> >  out:
> > -	lim->max_write_zeroes_sectors =
> > +	lim->ws.max_write_zeroes_sectors =
> >  		sdkp->max_ws_blocks * (logical_block_size >> SECTOR_SHIFT);
> > +	lim->has_ws = 1;
> >  }
> >  
> >  static blk_status_t sd_setup_flush_cmnd(struct scsi_cmnd *cmd)
> > @@ -2574,7 +2641,7 @@ static int sd_read_protection_type(struct scsi_disk *sdkp, unsigned char *buffer
> >  }
> >  
> >  static void sd_config_protection(struct scsi_disk *sdkp,
> > -		struct queue_limits *lim)
> > +		struct sd_limits *lim)
> >  {
> >  	struct scsi_device *sdp = sdkp->device;
> >  
> > @@ -2628,7 +2695,7 @@ static void read_capacity_error(struct scsi_disk *sdkp, struct scsi_device *sdp,
> >  #define READ_CAPACITY_RETRIES_ON_RESET	10
> >  
> >  static int read_capacity_16(struct scsi_disk *sdkp, struct scsi_device *sdp,
> > -		struct queue_limits *lim, unsigned char *buffer)
> > +		struct sd_limits *lim, unsigned char *buffer)
> >  {
> >  	unsigned char cmd[16];
> >  	struct scsi_sense_hdr sshdr;
> > @@ -2703,6 +2770,7 @@ static int read_capacity_16(struct scsi_disk *sdkp, struct scsi_device *sdp,
> >  	/* Lowest aligned logical block */
> >  	alignment = ((buffer[14] & 0x3f) << 8 | buffer[15]) * sector_size;
> >  	lim->alignment_offset = alignment;
> > +	lim->has_alignment_offset = 1;
> >  	if (alignment && sdkp->first_scan)
> >  		sd_printk(KERN_NOTICE, sdkp,
> >  			  "physical block alignment offset: %u\n", alignment);
> > @@ -2814,7 +2882,7 @@ static int sd_try_rc16_first(struct scsi_device *sdp)
> >   * read disk capacity
> >   */
> >  static void
> > -sd_read_capacity(struct scsi_disk *sdkp, struct queue_limits *lim,
> > +sd_read_capacity(struct scsi_disk *sdkp, struct sd_limits *lim,
> >  		unsigned char *buffer)
> >  {
> >  	int sector_size;
> > @@ -2900,8 +2968,9 @@ sd_read_capacity(struct scsi_disk *sdkp, struct queue_limits *lim,
> >  		 */
> >  		sector_size = 512;
> >  	}
> > -	lim->logical_block_size = sector_size;
> > -	lim->physical_block_size = sdkp->physical_block_size;
> > +	lim->bs.logical_block_size = sector_size;
> > +	lim->bs.physical_block_size = sdkp->physical_block_size;
> > +	lim->has_bs = 1;
> >  	sdkp->device->sector_size = sector_size;
> >  
> >  	if (sdkp->capacity > 0xffffffff)
> > @@ -3333,7 +3402,7 @@ static unsigned int sd_discard_mode(struct scsi_disk *sdkp)
> >   * Query disk device for preferred I/O sizes.
> >   */
> >  static void sd_read_block_limits(struct scsi_disk *sdkp,
> > -		struct queue_limits *lim)
> > +		struct sd_limits *lim)
> >  {
> >  	struct scsi_vpd *vpd;
> >  
> > @@ -3395,7 +3464,7 @@ static void sd_read_block_limits_ext(struct scsi_disk *sdkp)
> >  
> >  /* Query block device characteristics */
> >  static void sd_read_block_characteristics(struct scsi_disk *sdkp,
> > -		struct queue_limits *lim)
> > +		struct sd_limits *lim)
> >  {
> >  	struct scsi_vpd *vpd;
> >  	u16 rot;
> > @@ -3412,8 +3481,10 @@ static void sd_read_block_characteristics(struct scsi_disk *sdkp,
> >  	sdkp->zoned = (vpd->data[8] >> 4) & 3;
> >  	rcu_read_unlock();
> >  
> > -	if (rot == 1)
> > -		lim->features &= ~(BLK_FEAT_ROTATIONAL | BLK_FEAT_ADD_RANDOM);
> > +	if (rot == 1) {
> > +		lim->neg_features |= (BLK_FEAT_ROTATIONAL | BLK_FEAT_ADD_RANDOM);
> > +		lim->has_neg_features = 1;
> > +	}
> >  
> >  	if (!sdkp->first_scan)
> >  		return;
> > @@ -3700,7 +3771,8 @@ static int sd_revalidate_disk(struct gendisk *disk)
> >  	struct scsi_disk *sdkp = scsi_disk(disk);
> >  	struct scsi_device *sdp = sdkp->device;
> >  	sector_t old_capacity = sdkp->capacity;
> > -	struct queue_limits lim;
> > +	struct queue_limits blk_lim;
> > +	struct sd_limits lim = { 0 };
> >  	unsigned char *buffer;
> >  	unsigned int dev_max;
> >  	int err;
> > @@ -3724,8 +3796,6 @@ static int sd_revalidate_disk(struct gendisk *disk)
> >  
> >  	sd_spinup_disk(sdkp);
> >  
> > -	lim = queue_limits_start_update(sdkp->disk->queue);
> > -
> >  	/*
> >  	 * Without media there is no reason to ask; moreover, some devices
> >  	 * react badly if we do.
> > @@ -3746,6 +3816,7 @@ static int sd_revalidate_disk(struct gendisk *disk)
> >  		 * doesn't support it should be treated as rotational.
> >  		 */
> >  		lim.features |= (BLK_FEAT_ROTATIONAL | BLK_FEAT_ADD_RANDOM);
> > +		lim.has_features = 1;
> >  
> >  		if (scsi_device_supports_vpd(sdp)) {
> >  			sd_read_block_provisioning(sdkp);
> > @@ -3779,23 +3850,24 @@ static int sd_revalidate_disk(struct gendisk *disk)
> >  
> >  	/* Some devices report a maximum block count for READ/WRITE requests. */
> >  	dev_max = min_not_zero(dev_max, sdkp->max_xfer_blocks);
> > -	lim.max_dev_sectors = logical_to_sectors(sdp, dev_max);
> > +	lim.io.max_dev_sectors = logical_to_sectors(sdp, dev_max);
> >  
> >  	if (sd_validate_min_xfer_size(sdkp))
> > -		lim.io_min = logical_to_bytes(sdp, sdkp->min_xfer_blocks);
> > +		lim.io.io_min = logical_to_bytes(sdp, sdkp->min_xfer_blocks);
> >  	else
> > -		lim.io_min = 0;
> > +		lim.io.io_min = 0;
> >  
> >  	/*
> >  	 * Limit default to SCSI host optimal sector limit if set. There may be
> >  	 * an impact on performance for when the size of a request exceeds this
> >  	 * host limit.
> >  	 */
> > -	lim.io_opt = sdp->host->opt_sectors << SECTOR_SHIFT;
> > +	lim.io.io_opt = sdp->host->opt_sectors << SECTOR_SHIFT;
> >  	if (sd_validate_opt_xfer_size(sdkp, dev_max)) {
> > -		lim.io_opt = min_not_zero(lim.io_opt,
> > +		lim.io.io_opt = min_not_zero(lim.io.io_opt,
> >  				logical_to_bytes(sdp, sdkp->opt_xfer_blocks));
> >  	}
> > +	lim.has_io = 1;
> >  
> >  	sdkp->first_scan = 0;
> >  
> > @@ -3803,8 +3875,10 @@ static int sd_revalidate_disk(struct gendisk *disk)
> >  	sd_config_write_same(sdkp, &lim);
> >  	kfree(buffer);
> >  
> > +	blk_lim = queue_limits_start_update(sdkp->disk->queue);
> > +	sd_sync_limits(&blk_lim, &lim);
> >  	blk_mq_freeze_queue(sdkp->disk->queue);
> > -	err = queue_limits_commit_update(sdkp->disk->queue, &lim);
> > +	err = queue_limits_commit_update(sdkp->disk->queue, &blk_lim);
> >  	blk_mq_unfreeze_queue(sdkp->disk->queue);
> >  	if (err)
> >  		return err;
> > diff --git a/drivers/scsi/sd.h b/drivers/scsi/sd.h
> > index 36382eca941c..68c2db27cbf3 100644
> > --- a/drivers/scsi/sd.h
> > +++ b/drivers/scsi/sd.h
> > @@ -67,6 +67,59 @@ enum {
> >  	SD_ZERO_WS10_UNMAP,	/* Use WRITE SAME(10) with UNMAP */
> >  };
> >  
> > +struct sd_limits {
> > +	unsigned int has_features:1;
> > +	unsigned int has_neg_features:1;
> > +	unsigned int has_alignment_offset:1;
> > +	unsigned int has_bs:1;
> > +	unsigned int has_discard:1;
> > +	unsigned int has_integrity:1;
> > +	unsigned int has_aw:1;
> > +	unsigned int has_ws:1;
> > +	unsigned int has_io:1;
> > +	unsigned int has_zone:1;
> > +
> > +	blk_features_t		features;
> > +	blk_features_t		neg_features;
> > +	unsigned int		alignment_offset;
> > +	struct blk_integrity	integrity;
> > +
> > +	struct {
> > +		unsigned int logical_block_size;
> > +		unsigned int physical_block_size;
> > +	} bs;
> > +
> > +	struct {
> > +		unsigned int		discard_granularity;
> > +		unsigned int		discard_alignment;
> > +		unsigned int		max_hw_discard_sectors;
> > +	} discard;
> > +
> > +	struct {
> > +		unsigned int		max_write_zeroes_sectors;
> > +	} ws;
> > +
> > +	struct {
> > +		unsigned int		atomic_write_hw_max;
> > +		unsigned int		atomic_write_hw_boundary;
> > +		unsigned int		atomic_write_hw_unit_min;
> > +		unsigned int		atomic_write_hw_unit_max;
> > +	} aw;
> > +
> > +	struct {
> > +		unsigned int		max_dev_sectors;
> > +		unsigned int		io_opt;
> > +		unsigned int		io_min;
> > +	} io;
> > +
> > +	struct {
> > +		unsigned int		zone_write_granularity;
> > +		unsigned int		max_open_zones;
> > +		unsigned int		max_active_zones;
> > +		unsigned int		chunk_sectors;
> > +	} zone;
> > +};
> > +
> >  /**
> >   * struct zoned_disk_info - Specific properties of a ZBC SCSI device.
> >   * @nr_zones: number of zones.
> > @@ -228,11 +281,11 @@ static inline sector_t sectors_to_logical(struct scsi_device *sdev, sector_t sec
> >  	return sector >> (ilog2(sdev->sector_size) - 9);
> >  }
> >  
> > -void sd_dif_config_host(struct scsi_disk *sdkp, struct queue_limits *lim);
> > +void sd_dif_config_host(struct scsi_disk *sdkp, struct sd_limits *lim);
> >  
> >  #ifdef CONFIG_BLK_DEV_ZONED
> >  
> > -int sd_zbc_read_zones(struct scsi_disk *sdkp, struct queue_limits *lim,
> > +int sd_zbc_read_zones(struct scsi_disk *sdkp, struct sd_limits *lim,
> >  		u8 buf[SD_BUF_SIZE]);
> >  int sd_zbc_revalidate_zones(struct scsi_disk *sdkp);
> >  blk_status_t sd_zbc_setup_zone_mgmt_cmnd(struct scsi_cmnd *cmd,
> > @@ -245,7 +298,7 @@ int sd_zbc_report_zones(struct gendisk *disk, sector_t sector,
> >  #else /* CONFIG_BLK_DEV_ZONED */
> >  
> >  static inline int sd_zbc_read_zones(struct scsi_disk *sdkp,
> > -		struct queue_limits *lim, u8 buf[SD_BUF_SIZE])
> > +		struct sd_limits *lim, u8 buf[SD_BUF_SIZE])
> >  {
> >  	return 0;
> >  }
> > diff --git a/drivers/scsi/sd_dif.c b/drivers/scsi/sd_dif.c
> > index ae6ce6f5d622..081168d4aee3 100644
> > --- a/drivers/scsi/sd_dif.c
> > +++ b/drivers/scsi/sd_dif.c
> > @@ -24,13 +24,14 @@
> >  /*
> >   * Configure exchange of protection information between OS and HBA.
> >   */
> > -void sd_dif_config_host(struct scsi_disk *sdkp, struct queue_limits *lim)
> > +void sd_dif_config_host(struct scsi_disk *sdkp, struct sd_limits *lim)
> >  {
> >  	struct scsi_device *sdp = sdkp->device;
> >  	u8 type = sdkp->protection_type;
> >  	struct blk_integrity *bi = &lim->integrity;
> >  	int dif, dix;
> >  
> > +	lim->has_integrity = 1;
> >  	memset(bi, 0, sizeof(*bi));
> >  
> >  	dif = scsi_host_dif_capable(sdp->host, type);
> > diff --git a/drivers/scsi/sd_zbc.c b/drivers/scsi/sd_zbc.c
> > index 7a447ff600d2..c8e398a08b31 100644
> > --- a/drivers/scsi/sd_zbc.c
> > +++ b/drivers/scsi/sd_zbc.c
> > @@ -588,7 +588,7 @@ int sd_zbc_revalidate_zones(struct scsi_disk *sdkp)
> >   * also the zoned device information in *sdkp. Called by sd_revalidate_disk()
> >   * before the gendisk capacity has been set.
> >   */
> > -int sd_zbc_read_zones(struct scsi_disk *sdkp, struct queue_limits *lim,
> > +int sd_zbc_read_zones(struct scsi_disk *sdkp, struct sd_limits *lim,
> >  		u8 buf[SD_BUF_SIZE])
> >  {
> >  	unsigned int nr_zones;
> > @@ -598,6 +598,7 @@ int sd_zbc_read_zones(struct scsi_disk *sdkp, struct queue_limits *lim,
> >  	if (sdkp->device->type != TYPE_ZBC)
> >  		return 0;
> >  
> > +	lim->has_features = 1;
> >  	lim->features |= BLK_FEAT_ZONED;
> >  
> >  	/*
> > @@ -605,7 +606,7 @@ int sd_zbc_read_zones(struct scsi_disk *sdkp, struct queue_limits *lim,
> >  	 * zones of host-managed devices must be aligned to the device physical
> >  	 * block size.
> >  	 */
> > -	lim->zone_write_granularity = sdkp->physical_block_size;
> > +	lim->zone.zone_write_granularity = sdkp->physical_block_size;
> >  
> >  	/* READ16/WRITE16/SYNC16 is mandatory for ZBC devices */
> >  	sdkp->device->use_16_for_rw = 1;
> > @@ -628,11 +629,12 @@ int sd_zbc_read_zones(struct scsi_disk *sdkp, struct queue_limits *lim,
> >  
> >  	/* The drive satisfies the kernel restrictions: set it up */
> >  	if (sdkp->zones_max_open == U32_MAX)
> > -		lim->max_open_zones = 0;
> > +		lim->zone.max_open_zones = 0;
> >  	else
> > -		lim->max_open_zones = sdkp->zones_max_open;
> > -	lim->max_active_zones = 0;
> > -	lim->chunk_sectors = logical_to_sectors(sdkp->device, zone_blocks);
> > +		lim->zone.max_open_zones = sdkp->zones_max_open;
> > +	lim->zone.max_active_zones = 0;
> > +	lim->zone.chunk_sectors = logical_to_sectors(sdkp->device, zone_blocks);
> > +	lim->has_zone = 1;
> >  
> >  	return 0;
> >  
> 
> 
> -- 
> Damien Le Moal
> Western Digital Research
> 

-- 
Ming

