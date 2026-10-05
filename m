Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CEFB8442391
	for <linux-scsi@vger.kernel.org>; Mon,  5 Oct 2026 09:59:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791194385; cv=none; b=nQrY3dZI3ZNzOwTyqqLDi8LeFuo87BP0JC0tOnNG9s6ciqRX1URRqJx4XIGj1rqDAdrmyCf5IaPCCe6Klo6Avn5UzRr7RzgQjaxLesVVUaZ67Ia6L79z6zv5hsmFXZ/eelEXLWokkizsSum9Dn+2OD+WwrxQB6DucHTBWZsf8Nc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791194385; c=relaxed/simple;
	bh=/WPJJt/f4Qw3vw/c/FxmyIxAKfUR9abuIvfN1BZ6e1s=;
	h=From:Subject:To:Cc:In-Reply-To:References:Content-Type:Date:
	 Message-Id; b=UyGI7A2TACc0QXImBISX18apa1Az7mUOp0Nbu3HrYMkom7zuRtOX/qVdBKu7/NU3AG3kRsQujRofjO2LENahMnZuCZG2Z12TQ548gYXx9e3gemxjOMvHOtkbPAGQQfKvjdQFUNnwydtloz4NMCgrwlSi7z7XUoH7Kzsh725NTtk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=QThNToQW; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="QThNToQW"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3C7C11F000FF;
	Mon,  5 Oct 2026 09:59:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1791194383;
	bh=PCgM9iYVOvSLF/V4OLQIxchcyaE00yZgVQCkXbj8FwE=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=QThNToQW0zJZ/UqSbsIO/c9WsNNFdxVTB91kai26Q2FFBaPVdpW7xScmZStyvEE65
	 +uUL8t5fclwY+WAPef7FxwCY30yGu9iCKWpo7RkTEh2BPvy5ivZOF/iWtjOeTQIdZS
	 8WFpYpIBcyi9NjCdJp1Jd4HdJnqiD8r2IBOq5csppVJDzptKugP7E52MNxgaPSP44W
	 tjdUGSY5Bj4t23JDhD0sbZNElkMIldairiNI8WA/SbdvdD6NomyxRo6cmGsUiB867D
	 tYqQoP3/gQmM5haFJCHFCf60uxia3d+7TkJb+vbKJvVO/bjpgj6vN5HRiKEvNQi28b
	 brHBwFpel4knQ==
From: sashiko-bot@kernel.org
Subject: Re: [PATCH 7/7] scsi: sd_zbc: define storage element management
 operations
Reply-To: sashiko-reviews@lists.linux.dev
To: "Damien Le Moal" <dlemoal@kernel.org>
Cc: linux-scsi@vger.kernel.org
In-Reply-To: <20261005094632.580753-8-dlemoal@kernel.org>
References: <20261005094632.580753-1-dlemoal@kernel.org>
 <20261005094632.580753-8-dlemoal@kernel.org>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Mon, 05 Oct 2026 09:59:42 +0000
Message-Id: <20261005095943.3C7C11F000FF@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>

Thank you for your contribution! Sashiko AI review found 5 potential issue(=
s) to consider:
- [High] scsi: sd_zbc: heap OOB read from buf via unvalidated nr_descs
- [High] scsi: sd_zbc: heap OOB leak caused by overwriting caller capacity =
with nr_descs
- [Medium] scsi: sd_zbc: hardcoded 4KB buffer permanently limits storage el=
ements to 127
- [Medium] scsi: sd_zbc: undefined shift via ilog2(0) when zone_blocks is u=
ninitialized
- [Low] build: invalid &NULL assignment for se_ops in non-zoned configs
--

commit dc87627d74d92a84dc8259e4c75a364fd39dae85
Author: Damien Le Moal <dlemoal@kernel.org>

scsi: sd_zbc: define storage element management operations

This commit defines the storage element management operations using
struct blk_storage_elements_ops. These operations are intended for SMR disks
that support the storage element depopulation feature.

> diff --git a/drivers/scsi/sd.c b/drivers/scsi/sd.c
> index b0d2542fd3172..0a252739f5945 100644
> --- a/drivers/scsi/sd.c
> +++ b/drivers/scsi/sd.c
> @@ -3939,6 +3939,7 @@ static const struct block_device_operations sd_fops=
 =3D {
>  	.get_unique_id		=3D sd_get_unique_id,
>  	.free_disk		=3D scsi_disk_free_disk,
>  	.pr_ops			=3D &sd_pr_ops,
> +	.se_ops			=3D &sd_zbc_se_ops,
>  };

[Severity: Low]
Does this cause a build failure when CONFIG_BLK_DEV_ZONED is disabled? Since
sd_zbc_se_ops is defined as NULL in sd.h for non-zoned configs, this expands
to &NULL which is syntactically invalid.

[ ... ]

> diff --git a/drivers/scsi/sd_zbc.c b/drivers/scsi/sd_zbc.c
> index 1bf5f7ea0d9c5..56e8456cd0eca 100644
> --- a/drivers/scsi/sd_zbc.c
> +++ b/drivers/scsi/sd_zbc.c
> @@ -548,6 +548,216 @@ static void sd_zbc_print_zones(struct scsi_disk *sd=
kp)
[ ... ]
> +static void sd_zbc_parse_storage_element(struct scsi_disk *sdkp, u8 *des=
c,
> +					 struct blk_storage_element *element)
> +{
> +	struct scsi_device *sdp =3D sdkp->device;
> +	u64 capacity;
> +
> +	element->id =3D get_unaligned_be32(&desc[4]);
> +
> +	switch (desc[14]) {
> +	case SCSI_PHYS_ELEM_TYPE_ALL_ACCESS_STORAGE:
> +		element->paired_id =3D 0;
> +		element->type =3D BLK_SE_TYPE_RDWR;
> +		capacity =3D get_unaligned_be64(&desc[16]);
> +		element->nr_zones =3D logical_to_sectors(sdp, capacity) >>
> +			ilog2(sd_zbc_zone_sectors(sdkp));

[Severity: Medium]
Does this risk an undefined shift on architectures where ilog2(0) faults? If
this function is called on a device where modify_zones_supported is true but
zone_blocks is zero (such as following a zoned revalidation failure),
sd_zbc_zone_sectors(sdkp) would return 0.

[ ... ]

> +static int sd_zbc_report_storage_elements(struct gendisk *disk,
> +					  unsigned int *nr_elements,
> +					  struct blk_storage_element *elements)
> +{
[ ... ]
> +	memset(cmd, 0, 16);
> +	cmd[0] =3D SERVICE_ACTION_IN_16;
> +	cmd[1] =3D SAI_GET_PHYSICAL_ELEMENT_STATUS;
> +	put_unaligned_be32(SD_ZBC_STORAGE_ELEMENTS_BUF_SIZE, &cmd[10]);

[Severity: Medium]
Does this hardcoded 4KB allocation length permanently limit the number of
reported storage elements to 127? There appears to be no mechanism to query
elements iteratively, which limits functionality for devices with a larger
number of elements.

[ ... ]

> +	nr_descs =3D get_unaligned_be32(&buf[4]);
> +	if (!nr_descs) {
> +		sd_printk(KERN_ERR, sdkp,
> +			"Invalid number of reported phys element descriptors\n");
> +		ret =3D -EIO;
> +		goto free_buf;
> +	}
> +
> +	desc =3D &buf[32];
> +	for (i =3D 0; i < min(*nr_elements, nr_descs); i++, desc +=3D 32)
> +		sd_zbc_parse_storage_element(sdkp, desc, &elements[i]);

[Severity: High]
Can this loop read out-of-bounds of the 4096-byte buf? The driver extracts
nr_descs directly from the device payload without validating it against the
buffer size limit. If a device returns a large nr_descs, this loop will
advance the desc pointer past the end of the allocated buf.

> +	*nr_elements =3D nr_descs;

[Severity: High]
Can this unconditionally overwrite the caller-provided array capacity
(*nr_elements) with the device-reported count? If the caller provided a
smaller array capacity than nr_descs, returning the larger nr_descs can
trick the caller into copying uninitialized out-of-bounds heap memory to
userspace.

> +
> +free_buf:
> +	kfree(buf);
> +
> +	return ret;
> +}

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20261005094632.5807=
53-1-dlemoal@kernel.org?part=3D7
