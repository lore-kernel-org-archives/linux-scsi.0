Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 425223A6EE4
	for <linux-scsi@vger.kernel.org>; Tue, 10 Mar 2026 02:41:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1773110466; cv=none; b=uVIL/o400TgTveD5xvDnIuAAXqYVeonwCIQJ8dg1UCDxPnt6EbTGryhlMnBIkQxGp51E9CiD2z1MUB7EstwU1aQbVru0bWja3fxRXroDc1BlabwDJlEKRa24dogud1F6Nyw5FOG2TkDiPGn1Vmy23xZ5A76RJXLattpjgTlR7kQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1773110466; c=relaxed/simple;
	bh=LRcLLBHRU5GLCzyUqdv3jNI81HpymoQj00jKeO2lTzY=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=sckr0r8A+g7Alhg7WWJXc0wfXDhAPAKx/+VZjFTboOAu/NZlnkwnMMWaOL5qO/pDwpcomVAv8ZKIot4dzWloI7zuRHdjnELhhqpzEyflzmmBa7uQWW3jTnk6ch1dxfyi6a4ZK+sKXZ+FXaQxZmDgQFi57d01keBO7G1ySs/LWbA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=SbCJmE+n; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="SbCJmE+n"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1773110464;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=tAGewiFPK0elo/WiSxOjUP/dvI4PkKIm5cf5C8uZl1U=;
	b=SbCJmE+nfymTIA2lj/70eWHSy3P41YI4ApaHZBLJOHzMOLeOs5X0/vMbQH/c5GS+xTTSfA
	ZxEnwjWgJn/vS8nBMegBN5Z8bJDalBbGSzoMIpl5gS6Uy97K/IdNG7/lVywf5i7qBj7zWV
	dVLHfzBNCaHkXz4Gv1NjNfxU+bZUMJo=
Received: from mx-prod-mc-06.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-35-165-154-97.us-west-2.compute.amazonaws.com [35.165.154.97]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-175-b1Rn-TQjPs--YYd2Ud5OpQ-1; Mon,
 09 Mar 2026 22:41:00 -0400
X-MC-Unique: b1Rn-TQjPs--YYd2Ud5OpQ-1
X-Mimecast-MFC-AGG-ID: b1Rn-TQjPs--YYd2Ud5OpQ_1773110458
Received: from mx-prod-int-05.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-05.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.17])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-06.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id 6D3EC180034E;
	Tue, 10 Mar 2026 02:40:57 +0000 (UTC)
Received: from bmarzins-01.fast.eng.rdu2.dc.redhat.com (bmarzins-01.fast.eng.rdu2.dc.redhat.com [10.6.23.12])
	by mx-prod-int-05.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id 0D52B195410D;
	Tue, 10 Mar 2026 02:40:55 +0000 (UTC)
Received: from bmarzins-01.fast.eng.rdu2.dc.redhat.com (localhost [127.0.0.1])
	by bmarzins-01.fast.eng.rdu2.dc.redhat.com (8.18.1/8.17.1) with ESMTPS id 62A2esvQ007596
	(version=TLSv1.3 cipher=TLS_AES_256_GCM_SHA384 bits=256 verify=NOT);
	Mon, 9 Mar 2026 22:40:54 -0400
Received: (from bmarzins@localhost)
	by bmarzins-01.fast.eng.rdu2.dc.redhat.com (8.18.1/8.18.1/Submit) id 62A2erW1007595;
	Mon, 9 Mar 2026 22:40:53 -0400
Date: Mon, 9 Mar 2026 22:40:53 -0400
From: Benjamin Marzinski <bmarzins@redhat.com>
To: John Garry <john.g.garry@oracle.com>
Cc: hch@lst.de, kbusch@kernel.org, sagi@grimberg.me, axboe@fb.com,
        martin.petersen@oracle.com, james.bottomley@hansenpartnership.com,
        hare@suse.com, jmeneghi@redhat.com, linux-nvme@lists.infradead.org,
        linux-scsi@vger.kernel.org, michael.christie@oracle.com,
        snitzer@kernel.org, dm-devel@lists.linux.dev,
        linux-block@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 21/24] scsi: sd: support multipath disk
Message-ID: <aa-EtdqIOX603PVu@redhat.com>
References: <20260225153627.1032500-1-john.g.garry@oracle.com>
 <20260225153627.1032500-22-john.g.garry@oracle.com>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260225153627.1032500-22-john.g.garry@oracle.com>
X-Scanned-By: MIMEDefang 3.0 on 10.30.177.17

On Wed, Feb 25, 2026 at 03:36:24PM +0000, John Garry wrote:
> Add support to attach a multipath disk.
> 
> We still allocate the gendisk per path, and this is required for the
> per-path submission. However, those gendisks are marked as hidden. Those
> disks are named sdX:Y, where X is the multipath disk index and Y is the
> per-path index.
> 
> A global list of sd_mpath_disks is kept for matching scsi_device's.
> 
> The multipath gendisk has the name and disk->major/minor set to minic a
> scsi_disk.
> 
> The following is an example of relevant scsi_disk and block sysfs
> directories:
> 
> $ ls -l /sys/block/ | grep sdc
> lrwxrwxrwx    1 root     root             0 Feb 24 16:01 sdc -> ../devices/virtual/scsi_mpath_disk/0/sdc
> lrwxrwxrwx    1 root     root             0 Feb 24 16:01 sdc:0 -> ../devices/platform/host8/session1/target8:0:0/8:0:0:0/block/sdc:0
> lrwxrwxrwx    1 root     root             0 Feb 24 16:02 sdc:1 -> ../devices/platform/host9/session2/target9:0:0/9:0:0:0/block/sdc:1
> 
> $ ls -l /sys/class/scsi_mpath_disk/0/
> total 0
> drwxr-xr-x    2 root     root             0 Feb 24 16:03 power
> drwxr-xr-x   11 root     root             0 Feb 24 16:01 sdc
> lrwxrwxrwx    1 root     root             0 Feb 24 16:01 subsystem -> ../../../../class/scsi_mpath_disk
> -rw-r--r--    1 root     root          4096 Feb 24 16:01 uevent
> 
> $ ls -l /sys/class/scsi_mpath_disk/0/sdc/multipath/
> total 0
> lrwxrwxrwx    1 root     root             0 Feb 24 16:20 sdc:0 -> ../../../../../platform/host8/session1/target8:0:0/8:0:0:0/block/sdc:0
> lrwxrwxrwx    1 root     root             0 Feb 24 16:20 sdc:1 -> ../../../../../platform/host9/session2/target9:0:0/9:0:0:0/block/sdc:1
> 
> 
> $ ls -l /dev/sdc*
> brw-rw----    1 root     disk        8,  32 Feb 24 16:01 /dev/sdc
> brw-rw----    1 root     disk        8,  33 Feb 24 16:01 /dev/sdc1
> brw-rw----    1 root     disk        8,  34 Feb 24 16:01 /dev/sdc2
> 
> 
> $ lsblk /dev/sdc
> NAME            MAJ:MIN RM  SIZE RO TYPE MOUNTPOINTS
> sdc               8:32   0  600M  0 disk
> |-sdc1            8:33   0    9M  0 part
> `-sdc2            8:34   0  568M  0 part
> 
> Signed-off-by: John Garry <john.g.garry@oracle.com>
> ---
>  drivers/scsi/sd.c | 376 +++++++++++++++++++++++++++++++++++++++++++---
>  1 file changed, 358 insertions(+), 18 deletions(-)
> 
> diff --git a/drivers/scsi/sd.c b/drivers/scsi/sd.c
> index 9617878b53ec6..409c0937764d9 100644
> --- a/drivers/scsi/sd.c
> +++ b/drivers/scsi/sd.c
> @@ -117,12 +117,33 @@ static DEFINE_IDA(sd_index_ida);
>  static mempool_t *sd_page_pool;
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
> +	struct mutex			lock;
>  	struct mpath_disk		*mpath_disk;
> +	struct scsi_mpath_head		*scsi_mpath_head;
>  };
>  
>  static void sd_mpath_disk_release(struct device *dev)
>  {
> +	struct sd_mpath_disk *sd_mpath_disk =
> +		container_of(dev, struct sd_mpath_disk, dev);
> +	struct scsi_mpath_head *scsi_mpath_head =
> +		sd_mpath_disk->scsi_mpath_head;
> +	struct mpath_disk *mpath_disk = sd_mpath_disk->mpath_disk;
> +
> +	mpath_put_disk(mpath_disk);
> +
> +	ida_free(&sd_index_ida, sd_mpath_disk->disk_index);
> +	scsi_mpath_put_head(scsi_mpath_head);
> +
> +	kfree(sd_mpath_disk);
>  }
>  
>  static const struct class sd_mpath_disk_class = {
> @@ -4144,7 +4165,302 @@ static const struct scsi_mpath_pr_ops sd_mpath_pr_ops = {
>  	.pr_read_keys	= sd_mpath_pr_read_keys,
>  	.pr_read_reservation = sd_mpath_pr_read_reservation,
>  };
> +
> +static int sd_mpath_revalidate_head(struct scsi_disk *sdkp)
> +{
> +	struct sd_mpath_disk *sd_mpath_disk = sdkp->sd_mpath_disk;
> +	struct mpath_disk *mpath_disk = sd_mpath_disk->mpath_disk;;
> +	struct gendisk *disk = mpath_disk->disk;
> +	struct queue_limits *sdkp_lim = &sdkp->disk->queue->limits;
> +	struct queue_limits lim;
> +	unsigned int memflags;
> +	int ret;
> +
> +	lim = queue_limits_start_update(disk->queue);
> +	memflags = blk_mq_freeze_queue(disk->queue);
> +
> +	lim.logical_block_size = sdkp_lim->logical_block_size;
> +	lim.physical_block_size = sdkp_lim->physical_block_size;
> +	lim.io_min = sdkp_lim->io_min;
> +	lim.io_opt = sdkp_lim->io_opt;
> +
> +	queue_limits_stack_bdev(&lim, sdkp->disk->part0, 0,
> +					disk->disk_name);
> +
> +	/* TODO: setup integrity limits */
> +	lim.max_write_streams = sdkp_lim->max_write_streams;
> +	lim.write_stream_granularity = sdkp_lim->write_stream_granularity;
> +	ret = queue_limits_commit_update(disk->queue, &lim);
> +
> +	set_capacity_and_notify(disk, get_capacity(sdkp->disk));
> +
> +	blk_mq_unfreeze_queue(disk->queue, memflags);
> +
> +	return ret;
> +}
> +static int sd_mpath_get_disk(struct sd_mpath_disk *sd_mpath_disk)
> +{
> +	if (!get_device(&sd_mpath_disk->dev))
> +		return -ENXIO;
> +	return 0;
> +}
> +
> +static void sd_mpath_put_disk(struct sd_mpath_disk *sd_mpath_disk)
> +{
> +	put_device(&sd_mpath_disk->dev);
> +}
> +
> +static struct sd_mpath_disk *sd_mpath_find_disk(struct scsi_device *sdp)
> +{
> +	struct scsi_mpath_device *scsi_mpath_dev = sdp->scsi_mpath_dev;
> +	struct sd_mpath_disk *sd_mpath_disk;
> +	int ret;
> +
> +	mutex_lock(&sd_mpath_disks_lock);
> +	list_for_each_entry(sd_mpath_disk, &sd_mpath_disks_list, entry) {
> +		struct scsi_mpath_head *scsi_mpath_head;
> +		struct mpath_disk *mpath_disk;
> +		struct mpath_head *mpath_head;
> +
> +		ret = sd_mpath_get_disk(sd_mpath_disk);
> +		if (ret)
> +			continue;
> +		mpath_disk = sd_mpath_disk->mpath_disk;
> +		mpath_head = mpath_disk->mpath_head;
> +		scsi_mpath_head = mpath_head->drvdata;
> +
> +		if (strncmp(scsi_mpath_head->wwid,
> +			scsi_mpath_dev->device_id_str,
> +			SCSI_MPATH_DEVICE_ID_LEN) == 0) {
> +
> +			mutex_unlock(&sd_mpath_disks_lock);
> +			return sd_mpath_disk;
> +		}
> +		sd_mpath_put_disk(sd_mpath_disk);
> +	}
> +
> +	return NULL;
> +}
> +
> +static void sd_mpath_add_disk(struct scsi_disk *sdkp)
> +{
> +	struct scsi_device *sdp = sdkp->device;
> +	struct scsi_mpath_device *scsi_mpath_dev = sdp->scsi_mpath_dev;
> +	struct mpath_device *mpath_device = &scsi_mpath_dev->mpath_device;
> +	struct sd_mpath_disk *sd_mpath_disk = sdkp->sd_mpath_disk;
> +	struct mpath_disk *mpath_disk = sd_mpath_disk->mpath_disk;
> +	struct mpath_head *mpath_head = mpath_disk->mpath_head;
> +
> +	mpath_device->disk = sdkp->disk;
> +	mpath_add_device(mpath_head, mpath_device);
> +	mpath_device_set_live(mpath_disk, mpath_device);
> +}
> +
> +static int sd_mpath_probe(struct scsi_disk *sdkp)
> +{
> +	struct scsi_device *sdp = sdkp->device;
> +	struct scsi_mpath_device *scsi_mpath_dev = sdp->scsi_mpath_dev;
> +	struct device *dma_dev = sdp->host->dma_dev;
> +	struct scsi_mpath_head *scsi_mpath_head =
> +				scsi_mpath_dev->scsi_mpath_head;
> +	struct sd_mpath_disk *sd_mpath_disk;
> +	struct mpath_head *mpath_head = scsi_mpath_head->mpath_head;
> +	struct queue_limits lim;
> +	struct gendisk *disk;
> +	int error;
> +
> +	/*
> +	 * sd_mpath_disks_list is kept locked if no disk found.
> +	 * Otherwise an extra reference is taken.
> +	 */

Again, I personally think the logic is easier to follow when all the
locking isn't split over multiple functions.

> +	sd_mpath_disk = sd_mpath_find_disk(sdp);
> +	if (sd_mpath_disk) {
> +		mutex_lock(&sd_mpath_disk->lock);
> +		sd_mpath_disk->disk_count++;
> +		mutex_unlock(&sd_mpath_disk->lock);
> +		goto found;
> +	}
> +
> +	sd_mpath_disk = kzalloc(sizeof(*sd_mpath_disk), GFP_KERNEL);
> +	if (!sd_mpath_disk) {
> +		error = -ENOMEM;
> +		goto out_unlock;
> +	}
> +
> +	sd_mpath_disk->scsi_mpath_head = scsi_mpath_head;
> +	device_initialize(&sd_mpath_disk->dev);
> +	mutex_init(&sd_mpath_disk->lock);
> +	sd_mpath_disk->dev.class = &sd_mpath_disk_class;
> +
> +	blk_set_stacking_limits(&lim);
> +	lim.dma_alignment = 3;
> +	lim.features |= BLK_FEAT_IO_STAT | BLK_FEAT_NOWAIT |
> +		BLK_FEAT_POLL | BLK_FEAT_ATOMIC_WRITES;
> +
> +	sd_mpath_disk->mpath_disk = mpath_alloc_head_disk(&lim,
> +						dev_to_node(dma_dev));
> +	if (!sd_mpath_disk->mpath_disk) {
> +		error = -ENOMEM;
> +		goto out_free_disk;
> +	}
> +	disk = sd_mpath_disk->mpath_disk->disk;
> +	mpath_get_head(mpath_head); /* undone in mpath_free_disk() */
> +
> +	sd_mpath_disk->mpath_disk->mpath_head = mpath_head;
> +	sd_mpath_disk->mpath_disk->parent = &sd_mpath_disk->dev;
> +
> +	error = ida_alloc(&sd_index_ida, GFP_KERNEL);
> +	if (error < 0) {
> +		sdev_printk(KERN_WARNING, sdp, "sd_probe: memory exhausted.\n");
> +		goto out_put_disk;
> +	}
> +	sd_mpath_disk->disk_index = error;
> +	error = sd_format_disk_name("sd", sd_mpath_disk->disk_index,
> +				disk->disk_name, DISK_NAME_LEN);
> +	if (error)
> +		goto out_free_index;
> +
> +	error = dev_set_name(&sd_mpath_disk->dev, "%s",
> +				dev_name(&scsi_mpath_head->dev));
> +	if (error)
> +		goto out_free_index;
> +
> +	/* undone in sd_mpath_disk_release() */
> +	scsi_mpath_get_head(scsi_mpath_head);
> +
> +	error = device_add(&sd_mpath_disk->dev);
> +	if (error) {
> +		put_device(&sd_mpath_disk->dev);
> +		goto out_unlock;

We should clean up when we fail here, instead of just unlocking without
fully setting things up.

-Ben

> +	}
> +
> +	list_add_tail(&sd_mpath_disk->entry, &sd_mpath_disks_list);
> +	disk->major = sd_major((sd_mpath_disk->disk_index & 0xf0) >> 4);
> +	disk->first_minor = ((sd_mpath_disk->disk_index & 0xf) << 4) |
> +				(sd_mpath_disk->disk_index & 0xfff00);
> +	disk->minors = SD_MINORS;
> +
> +	sd_mpath_disk->disk_count = 1;
> +	mutex_unlock(&sd_mpath_disks_lock);
> +
> +found:
> +	sdkp->sd_mpath_disk = sd_mpath_disk;
> +	sdkp->disk->flags |= GENHD_FL_HIDDEN;
> +	snprintf(sdkp->disk->disk_name, DISK_NAME_LEN, "%s:%d",
> +		sd_mpath_disk->mpath_disk->disk->disk_name,
> +		scsi_mpath_dev->index);
> +
> +	sdkp->index = -1;
> +	return 0;
> +
> +out_free_index:
> +	ida_free(&sd_index_ida, sd_mpath_disk->disk_index);
> +out_put_disk:
> +	mpath_put_disk(sd_mpath_disk->mpath_disk);
> +out_free_disk:
> +	kfree(sd_mpath_disk);
> +out_unlock:
> +	mutex_unlock(&sd_mpath_disks_lock);
> +	return error;
> +}

