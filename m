Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B773F498930
	for <linux-scsi@vger.kernel.org>; Fri,  9 Oct 2026 09:28:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791538132; cv=none; b=k4O4Bc0zW7hU9WHr+JYiDcpgkAdumKvQ91JK/k2qOmOvvAcR/4rE2mU6WJJZ91YiaC8m2YBVzpYHL+7fgKz16IU/scTrgfxUXzKcqMMMcQEv9m650aUNCodM0qSnuGJw2EQ8HshYMAFmckqJxY4mpFumFz9MvwImLgm33dz/Xto=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791538132; c=relaxed/simple;
	bh=mOpew8gPgXA6RbIZd1Pt4OgVSQEZ75KNyCMBRoE+0KU=;
	h=Message-ID:From:Subject:To:Cc:In-Reply-To:References:Content-Type:
	 Date; b=GRBVrqMOzuaj3nbc0f3gDWMCJcbZapGgA8gLikln9SPOjCDpVAIz5VLKr/Q/OxA0oum54IOj7wUtGm943yzIARX0Um96fPhA1+obP//xJ6d01iuYoWZn/IxYpKYhatSaRjh+Wwm+rqAJGmlWwccKNtdQiFCQP9HYjW1U4Rt6Eno=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=ZsiyZJcm; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="ZsiyZJcm"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 348D41F000FF;
	Fri,  9 Oct 2026 09:28:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1791538130;
	bh=EQIXgmhS7vlC86rBttszklhCGac32R5bVqIAsmOUH5s=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=ZsiyZJcm/OsP4gU+Sy//oxHHAH3Wuq0KDwqjVMOJOoooQivzL6XLHVpvn4x9adu+V
	 Tcv0QIBxwP6ubXcZQtH9qSoW6ZqPC6rcCfcLccYRfGfCiZCjgrcv6ArqGUq021nFKa
	 AbNTM83pX8m5QZ7U4VDdR6WtIquvT7SbqBiHb6oeqlGjUlYHFMTMDT8db0bNT2LQL8
	 UPq/Uwhtb4gKN5bXhQauhWab707fwdBYSp8FAwy20xOSuz5vfRvRHIMIsc6RBA37qg
	 pPaN3twvQeCpcxBRf/YSY07BzbVz5Cg6Hrf2ny+MuN9LnWs/lyCeHx0bTr2qALs2CY
	 wUGnkMs8WxLlw==
Message-ID: <sashiko-outbox-165166@kernel.org>
From: sashiko-bot@kernel.org
Subject: Re: [PATCH v4 9/9] scsi: sd_zbc: define storage element management
 operations
Reply-To: sashiko-reviews@lists.linux.dev
To: "Damien Le Moal" <dlemoal@kernel.org>
Cc: linux-scsi@vger.kernel.org
In-Reply-To: <20261009090945.1504194-10-dlemoal@kernel.org>
References: <20261009090945.1504194-1-dlemoal@kernel.org>
 <20261009090945.1504194-10-dlemoal@kernel.org>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Fri, 09 Oct 2026 09:28:49 +0000
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>

Thank you for your contribution! Sashiko AI review found 2 potential issue(=
s) to consider:
- [High] scsi: sd_zbc: concurrent I/O races with storage element modificati=
on due to unfrozen queue
- [Medium] scsi: sd_zbc: nr_zones calculation for ALL_ACCESS_STORAGE omits =
runt zone
--

commit f862e7a8a5445f6170e01d1055958c0159fb3b36
Author: Damien Le Moal <dlemoal@kernel.org>

scsi: sd_zbc: define storage element management operations

This commit defines storage element management operations (report, remove,
restore) via struct blk_se_ops. These operations are intended for SMR disks
supporting the storage element depopulation feature.

> diff --git a/drivers/scsi/sd_zbc.c b/drivers/scsi/sd_zbc.c
> index 1bf5f7ea0d9c5..2f79a8d7b9d93 100644
> --- a/drivers/scsi/sd_zbc.c
> +++ b/drivers/scsi/sd_zbc.c
[ ... ]
> @@ -548,6 +548,239 @@ static void sd_zbc_print_zones(struct scsi_disk *sd=
kp)
>  			  sdkp->zone_info.zone_blocks);
>  }
> =20
> +static void sd_zbc_parse_storage_element(struct scsi_disk *sdkp, u8 *des=
c,
> +					 struct blk_se *element)
> +{
> +	struct scsi_device *sdp =3D sdkp->device;
> +	sector_t zone_sectors =3D sd_zbc_zone_sectors(sdkp);
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
For devices with a "runt" zone at the end, the total capacity is not a
perfect multiple of the zone size. Since the bitwise right shift performs
integer division that rounds down, could this silently truncate the
remainder blocks?

If so, does this cause the element to under-report the total number of zones
by one, creating a mismatch with the core block layer's zone count (which
properly rounds up)?

> +		break;
> +	case SCSI_PHYS_ELEM_TYPE_FRAC_ACCESS_STORAGE:
[ ... ]
> +static int sd_zbc_remove_storage_element(struct gendisk *disk,
> +					 unsigned int element_id)
> +{
> +	struct scsi_disk *sdkp =3D scsi_disk(disk);
> +	struct scsi_device *sdp =3D sdkp->device;
> +	const int timeout =3D sdp->request_queue->rq_timeout;
> +	struct scsi_sense_hdr sshdr;
> +	const struct scsi_exec_args exec_args =3D {
> +		.sshdr =3D &sshdr,
> +	};
> +	unsigned char cmd[16];
> +	int result;
> +
> +	if (!sdkp->modify_zones_supported)
> +		return -EOPNOTSUPP;
> +
> +	memset(cmd, 0, 16);
> +	cmd[0] =3D SERVICE_ACTION_IN_16;
> +	cmd[1] =3D SAI_REMOVE_ELEMENT_AND_MODIFY_ZONES;
> +	put_unaligned_be32(element_id, &cmd[10]);
> +
> +	result =3D scsi_execute_cmd(sdp, cmd, REQ_OP_DRV_IN, NULL, 0,
> +				  timeout, 1, &exec_args);

[Severity: High]
The block layer explicitly unfreezes the queue before invoking the se_ops
callback. For example, in bdev_remove_storage_element():

    memflags =3D blk_mq_freeze_queue(disk->queue);
    blk_mq_unfreeze_queue(disk->queue, memflags);
    ret =3D disk->fops->se_ops->remove_element(disk, element_id);

Because the queue is unfrozen when sd_zbc_remove_storage_element() is
called, another process could issue direct I/Os (e.g. via io_uring) to the
queue. Can the hardware zone topology modification sent via this SCSI
command race with concurrent I/O operations and lead to I/O failures or
data corruption?

> +	if (result) {
> +		sd_printk(KERN_ERR, sdkp,
> +			  "REMOVE ELEMENT AND MODIFY ZONES failed\n");

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20261009090945.1504=
194-1-dlemoal@kernel.org?part=3D9
