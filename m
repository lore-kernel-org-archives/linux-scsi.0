Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E716B33ADAC
	for <linux-scsi@vger.kernel.org>; Tue, 25 Aug 2026 16:07:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1787674070; cv=none; b=so6e5tlGBFeG7YKKhO7kOy6PdOGeQ6uA9MGNz5eMsiaSGJGT0gnZ4avT985jacYqblK0oTHahahwRKiqeShlU8nQnGQ7BEJ94fKrEcpIPuOYuEav6YoGX83crWV+6Mib5joo7BEHbV6z88TR4Tl+YFtj6uG/+OjTDqfjcKSgApU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1787674070; c=relaxed/simple;
	bh=kGK5T3vaBl9HFh3oPkkdyxewy1cksYx4bhdoXLoa/gg=;
	h=From:Subject:To:Cc:In-Reply-To:References:Content-Type:Date:
	 Message-Id; b=iz3zMDxTSx8nTnqduysliDjVZoR84EdOEeD4S6gmqJQxLyfvN96+htdHVXNDK9xJ2Z7XgKh7yBLR6rEDioLAqHZbpGrWQIlOASgdELtHcZMClFsWuhYUl0MgU84DTzjGyS9qlzG4IVSmuYtkmDDr+3mVpCQPI7EnGScfWGu1IJM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=PH7cJ6ql; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="PH7cJ6ql"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id ADC511F000E9;
	Tue, 25 Aug 2026 16:07:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1787674068;
	bh=WSI5ygRgozsobDl2AWXDKNCDLQ7lNQo7vnPuztq3W8Y=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=PH7cJ6qlpCuzYwNxR3zpiaEI5S8f59YzLHu9BkQERVNKw01Ab/xMZ0owoS0ZK3tU9
	 AJmtE3O+CnT/DKKR4IWqXKhJrpJO5B9z0MdBXHnMj9KfmKNSjeJtmxgfqdVZTWDqgj
	 Y43vHbew0Xd5+K9a9SCLKQcB3F77UndEmHRa7IHoyROxp9KaT+ko02r4mavNZLfTgO
	 rZ9lwPcm5XS84Jm8lPqcMeVIk/StMN9Ut9Wv6LIdjfpLZ9W1qVJv4YRcp3FsCIy6m+
	 kLIF41RlRArtYx6NINDT6TUVKHiHNPOWawOvZMFTiak+kaGV53CdbaF2cIN1p5I/8n
	 sgkkmFm+RWyJQ==
From: sashiko-bot@kernel.org
Subject: Re: [PATCH v2 13/17] mpi3mr: Fix buffer overflow in the BSG target
 device map
Reply-To: sashiko-reviews@lists.linux.dev
To: "Chandrakanth Patil" <chandrakanth.patil@broadcom.com>
Cc: linux-scsi@vger.kernel.org
In-Reply-To: <20260825210411.301535-14-chandrakanth.patil@broadcom.com>
References: <20260825210411.301535-1-chandrakanth.patil@broadcom.com>
 <20260825210411.301535-14-chandrakanth.patil@broadcom.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Tue, 25 Aug 2026 16:07:48 +0000
Message-Id: <20260825160748.ADC511F000E9@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>

Thank you for your contribution! Sashiko AI review found 2 potential issue(=
s) to consider:

Pre-existing issues:
- [Medium] Pre-existing integer overflow in `mpi3mr_get_logdata` when calcu=
lating total buffer size
- [Medium] Time-of-Check to Time-of-Use (TOCTOU) race condition in `mpi3mr_=
get_all_tgt_info`
--

commit db64ca74e30e89ca553a673a670db46d0985b8fa
Author: Chandrakanth Patil <chandrakanth.patil@broadcom.com>

    mpi3mr: Fix buffer overflow in the BSG target device map

This commit changes the size variable to size_t in mpi3mr_get_all_tgt_info
to fix a buffer overflow when calculating the target device map buffer size.

> diff --git a/drivers/scsi/mpi3mr/mpi3mr_app.c b/drivers/scsi/mpi3mr/mpi3m=
r_app.c
> index cd772b2cb98ae..f5b48c95cf055 100644
> --- a/drivers/scsi/mpi3mr/mpi3mr_app.c
> +++ b/drivers/scsi/mpi3mr/mpi3mr_app.c
> @@ -1466,7 +1466,8 @@ static long mpi3mr_bsg_pel_enable(struct mpi3mr_ioc=
 *mrioc,
>  static long mpi3mr_get_all_tgt_info(struct mpi3mr_ioc *mrioc,
>  	struct bsg_job *job)
>  {
> -	u16 num_devices =3D 0, i =3D 0, size;
> +	u16 num_devices =3D 0, i =3D 0;
> +	size_t size;
>  	unsigned long flags;
>  	struct mpi3mr_tgt_dev *tgtdev;
>  	struct mpi3mr_device_map_info *devmap_info =3D NULL;

[ ... ]

> @@ -1492,8 +1493,8 @@ static long mpi3mr_get_all_tgt_info(struct mpi3mr_i=
oc *mrioc,
>  		return 0;
>  	}

[Severity: Medium]
This is a pre-existing issue, but is there a Time-of-Check to Time-of-Use
(TOCTOU) race condition here?

Right above this block, the code evaluates list_empty(&mrioc->tgtdev_list)
without holding a lock:

	if ((job->request_payload.payload_len <=3D sizeof(u64)) ||
		list_empty(&mrioc->tgtdev_list)) {
		sg_copy_from_buffer(job->request_payload.sg_list,
				    job->request_payload.sg_cnt,
				    &num_devices, sizeof(num_devices));
		return 0;
	}

If a target device is removed (e.g., hot unplug) right after the tgtdev_lock
is released (where num_devices was counted) but before this list_empty()
check, could we return a non-zero device count to user space without actual=
ly
populating the device mapping data array?

This might lead the application to read uninitialized memory from its own
buffer as valid device information.

> -	kern_entrylen =3D num_devices * sizeof(*devmap_info);
> -	size =3D sizeof(u64) + kern_entrylen;
> +	kern_entrylen =3D (uint32_t)num_devices * sizeof(*devmap_info);
> +	size =3D sizeof(u64) + (size_t)kern_entrylen;
>  	alltgt_info =3D kzalloc(size, GFP_KERNEL);
>  	if (!alltgt_info)
>  		return -ENOMEM;

[Severity: Medium]
This isn't a bug introduced by this patch, but while reviewing the integer
overflow fix here, I noticed a similar pre-existing issue in
mpi3mr_get_logdata().

In mpi3mr_get_logdata(), the sz variable is declared as u16 and can
overflow when multiplied:

drivers/scsi/mpi3mr/mpi3mr_app.c:mpi3mr_get_logdata() {
    ...
	u16 sz, num_entries, entry_sz;
    ...
	sz =3D num_entries * entry_sz;
    ...
}

If the firmware advertises a reply_frame_size that makes entry_sz > 163 byt=
es
(e.g., a standard 256-byte frame), and we request MPI3MR_BSG_LOGDATA_MAX_EN=
TRIES
(400), could num_entries * entry_sz overflow the 16-bit sz variable?

This could silently truncate the amount of log data copied to user space,
causing the management tool to read uninitialized memory for the remaining
entries.

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20260825210411.3015=
35-1-chandrakanth.patil@broadcom.com?part=3D13
