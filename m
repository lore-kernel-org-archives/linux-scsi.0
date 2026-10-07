Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4B93E3BB69F
	for <linux-scsi@vger.kernel.org>; Wed,  7 Oct 2026 08:40:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791362450; cv=none; b=vAsj7VdXb7IE0RydyIxc3VEP0MOU3q8kFk+jd8TWxsXabhuYeXsXF224tFVB0oi84pu6r3U/eSaVJuhi84PMTNqAqrthV8xCCFRcKJGnSpNY1jabKEDj3tWpGODyVv7YpB1EL968bVweJtI729YOuK7yIWGkccCaARz4Xz36CKE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791362450; c=relaxed/simple;
	bh=4DOoSi3K5EjGXuM+11IAE+PyyDZQejffroYJ4ikX1s8=;
	h=Message-ID:From:Subject:To:Cc:In-Reply-To:References:Content-Type:
	 Date; b=NKBcCPBHlHsUXDfbGfN39ZAepNsKDwxeA+HdGBn3qu8A3yZ/P2XoWYszt94wWzYx0w36RG0i7W2Cjrw0KZeDoo5AmzG7Bo8xxYdjK8KqJU9syDXPbDS6NHf+PcawK3qaE9cZsOoLcHXNOWzbix6h3iZTvqpdc202s1kVY/HDzuc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=ZLDW1n9E; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="ZLDW1n9E"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A4C971F0089B;
	Wed,  7 Oct 2026 08:40:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1791362447;
	bh=y7LJ0JDZ3ML1T7i1FqLuvew1cE7HWbeZhFkVc7ws450=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=ZLDW1n9E0Yv4XBIVABmPxyGVUdiQj7Pbkby0AhyGw0DySHR2s42UjKdYNW+XMKzz8
	 2hGJrPEQmmlhPToaaUTcvRDbycr636eyQSQeNq5K4u1q1lhfiDF5H2+zyfTbc/lahv
	 SVE2NZ73LAFrfEBdMCK6v2mINqHhllmTGXiDR3VBF9EOVjY6IG39lGp095lTGo3n2a
	 Rxqqp7D8rVJnUv2EJqHJ5JNdNuCvxm0VnkWdzZMhr+uA/1GfnPHZk+/+eaPPcxRwjt
	 XuJtyyz+Wej/5T6bqAyoUrJ2wuSQXilsDbfDw5LCosjIVD/JfMEH0iSXMihYhl63ks
	 ISbjNYxXuO3Hw==
Message-ID: <sashiko-outbox-162754@kernel.org>
From: sashiko-bot@kernel.org
Subject: Re: [PATCH v3 7/7] scsi: sd_zbc: define storage element management
 operations
Reply-To: sashiko-reviews@lists.linux.dev
To: "Damien Le Moal" <dlemoal@kernel.org>
Cc: linux-scsi@vger.kernel.org
In-Reply-To: <20261007082344.1049179-8-dlemoal@kernel.org>
References: <20261007082344.1049179-1-dlemoal@kernel.org>
 <20261007082344.1049179-8-dlemoal@kernel.org>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Wed, 07 Oct 2026 08:40:47 +0000
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>

Thank you for your contribution! Sashiko AI review found 3 potential issue(=
s) to consider:
- [High] block: race in bdev_remove_storage_element allows DIO during zone =
removal
- [Medium] scsi: sd_zbc: runt zone omitted from element->nr_zones calculati=
on
- [Medium] scsi: sd_zbc: data race on sdkp->zone_info in sd_zbc_parse_stora=
ge_element()
--

commit 944c56308f45deb202a2ccbb04113e14aa6d2842
Author: Damien Le Moal <dlemoal@kernel.org>

scsi: sd_zbc: define storage element management operations

Define the storage element management operations using struct
blk_storage_elements_ops. These operations are valid only on SMR disks
supporting the storage element depopulation feature.

> diff --git a/drivers/scsi/sd_zbc.c b/drivers/scsi/sd_zbc.c
> index 1bf5f7ea0d9c5..80ed7a8e09a40 100644
> --- a/drivers/scsi/sd_zbc.c
> +++ b/drivers/scsi/sd_zbc.c
> @@ -548,6 +548,239 @@ static void sd_zbc_print_zones(struct scsi_disk *sd=
kp)
>  			  sdkp->zone_info.zone_blocks);
>  }
> =20
> +static void sd_zbc_parse_storage_element(struct scsi_disk *sdkp, u8 *des=
c,
> +					 struct blk_storage_element *element)
> +{
> +	struct scsi_device *sdp =3D sdkp->device;
> +	sector_t zone_sectors =3D sd_zbc_zone_sectors(sdkp);

[Severity: Medium]
Could this read of sdkp->zone_info.zone_blocks (via sd_zbc_zone_sectors) ra=
ce
with concurrent disk revalidation?

It appears that sd_zbc_parse_storage_element() accesses zone_blocks without
acquiring disk->zone_revalidate_mutex or freezing the request queue via
blk_queue_enter(). Concurrently, disk revalidation (e.g., via the partition
scan ioctl or uevent rescan) can call sd_zbc_revalidate_zones() which modif=
ies
sdkp->zone_info before acquiring zone_revalidate_mutex:

drivers/scsi/sd_zbc.c:sd_zbc_revalidate_zones() {
    ...
    sdkp->zone_info.zone_blocks =3D zone_blocks;
    sdkp->zone_info.nr_zones =3D nr_zones;
    ...
}

Can this lead to torn reads, or an ilog2(0) evaluation if the variable is
zeroed concurrently?

> +	u64 capacity;
> +
> +	memset(element, 0, sizeof(*element));
> +
> +	element->id =3D get_unaligned_be32(&desc[4]);
> +
> +	switch (desc[14]) {
> +	case SCSI_PHYS_ELEM_TYPE_ALL_ACCESS_STORAGE:
> +		element->type =3D BLK_SE_TYPE_RDWR;
> +		capacity =3D get_unaligned_be64(&desc[16]);
> +		if (!zone_sectors || capacity =3D=3D ULLONG_MAX)
> +			element->nr_zones =3D 0;
> +		else
> +			element->nr_zones =3D
> +				logical_to_sectors(sdp, capacity) >>
> +					ilog2(zone_sectors);

[Severity: Medium]
Does this floor division drop the remainder of the capacity, improperly
omitting the runt zone from the element's zone count?

When the driver parses a BLK_SE_TYPE_RDWR storage element descriptor spanni=
ng
a capacity that does not divide perfectly by the zone size (e.g., reaching
the end of the disk where a runt zone resides), the bitwise right shift
silently truncates the remainder.

For comparison, sd_zbc_read_zones() calculates the total disk zones using
round_up(sdkp->capacity, zone_blocks) >> ilog2(zone_blocks) to correctly
account for the runt zone.

[ ... ]

> +static int sd_zbc_remove_storage_element(struct gendisk *disk,
> +					 unsigned int element_id)
> +{

[Severity: High]
Is it safe to rely on the caller for synchronization here when the block
layer queue freeze has been dropped?

The caller in the block layer actively drops the queue freeze before execut=
ing
the removal:

block/blk-zoned.c:bdev_remove_storage_element() {
    ...
    memflags =3D blk_mq_freeze_queue(disk->queue);
    blk_mq_unfreeze_queue(disk->queue, memflags);

    ret =3D disk->fops->se_ops->remove_element(disk, element_id);
    ...
}

And the ioctl only holds inode_lock:

block/blk-zoned.c:blkdev_remove_storage_element_ioctl() {
    ...
    filemap_invalidate_unlock(bdev->bd_mapping);
    if (!ret)
        ret =3D bdev_remove_storage_element(bdev, element_id);
    inode_unlock(bdev->bd_mapping->host);
    ...
}

Since direct I/O (via blkdev_write_iter) explicitly bypasses inode_lock for
block devices, this seems to allow direct I/O to be issued while the element
is actively being removed. Could this cause torn state between the hardware
and the block layer's in-memory zone write plug tracking?

> +	struct scsi_disk *sdkp =3D scsi_disk(disk);
> +	struct scsi_device *sdp =3D sdkp->device;
> +	const int timeout =3D sdp->request_queue->rq_timeout;
> +	struct scsi_sense_hdr sshdr;

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20261007082344.1049=
179-1-dlemoal@kernel.org?part=3D7
