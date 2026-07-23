Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9427A43A7EC
	for <linux-scsi@vger.kernel.org>; Thu, 23 Jul 2026 10:36:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784802984; cv=none; b=R2Go3MaIf7XyilVFF5hDzifEZDiewUWLwSM8uo3kpO7PUusF9LWGwIrutohSo4SRg5hUkJtGVmN2jluhyKiYSScvU0EL9i0lvSOexeDZuR8Wvg+TNsgq/nLVslBdC66M9K+YPP5dRqJuyfFrKFlkpd2GaWGIGtBdcODamrAZnWk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784802984; c=relaxed/simple;
	bh=7J7s6iP6Hn4NKRmFAHpWZS5FACNrmQNME4CoVm7d0c4=;
	h=From:Subject:To:Cc:In-Reply-To:References:Content-Type:Date:
	 Message-Id; b=rDb8AQHCeVgU+xcy9GLdvo/hz1uJaxBkn6KsZ6qDr2qbVC7TrFhFAGR8j7HiZdHovA4+p+81BKwcnjg8oD/7WINWUmtxvHReB6eZJJb5a9th82bLrxJFwFhsw0f9kvhb6wtaazFNRD/oKpJ8s/6c4b59L3tUvLdd/Ocq95nfMQ4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=nVHFmAZg; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="nVHFmAZg"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 816C81F000E9;
	Thu, 23 Jul 2026 10:36:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1784802980;
	bh=zYyZc1XTNSx80dXCLeHEAYjQi9dUUk2++a37aLArjnA=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=nVHFmAZgUqS9mnwjVazdA9HcMwcA6uNqL5jSIYcgccwhcsFs2Qtk1XAQgtLQQ3BrV
	 KmVOB4JPq4nCsocJIVZXE+4HnlT4S/Jq3rDdJpckrB4UVFVgPmYasuadoA8wOOBBdF
	 lz0LXBuV6KG47dkofseaYVr63d3bYmUH3rg9V0T/ak0Z0h41/OgVjVN+V1np5GOwlE
	 LPcko/Gj6MKVnM+mOIoXDfQZjaiSCe5lq7wueYuY+kzAkkBuprrZfsjDW3PB7eFIrv
	 V75MmPeI6LcID0mwjci3dQAvg+RQG1A55A+SaOOaZWVCxVtFr9t3MYTM/7NtfxwzPe
	 C7W+OYUBhFHuw==
From: sashiko-bot@kernel.org
Subject: Re: [PATCH v4 19/28] scsi-multipath: failover handling
Reply-To: sashiko-reviews@lists.linux.dev
To: "John Garry" <john.g.garry@oracle.com>
Cc: linux-scsi@vger.kernel.org
In-Reply-To: <20260723093627.2327456-20-john.g.garry@oracle.com>
References: <20260723093627.2327456-1-john.g.garry@oracle.com>
 <20260723093627.2327456-20-john.g.garry@oracle.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Thu, 23 Jul 2026 10:36:19 +0000
Message-Id: <20260723103620.816C81F000E9@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>

Thank you for your contribution! Sashiko AI review found 5 potential issue(=
s) to consider:
- [High] Missing bi_next clearing in bio_list_add_clone() leads to corrupte=
d bio requeue list.
- [High] Releasing the SCSI device via scsi_device_put() causes a module re=
ference count underflow due to mismatched API usage.
- [High] Uninitialized mpath_device->mpath_head leads to a guaranteed NULL =
pointer dereference during failover.
- [High] The scsi_mpath_clone_end_io handler dereferences mpath_head after =
it has been freed during path device removal.
- [High] Missing cancel_work_sync() allows requeue_work to execute after sc=
si_mpath_head is freed.
--

--- Patch [19]: [PATCH v4 19/28] scsi-multipath: failover handling ---
commit e8daaaa500b47bda767344af0f467a56fa0a6095
Author: John Garry <john.garry@linux.dev>

scsi-multipath: failover handling

Failover occurs when the scsi_cmnd has failed and it is discovered that the
target scsi_device has transport down. For a scsi command which suffers
failover, requeue the master bio of each bio attached to its request.

> diff --git a/drivers/scsi/scsi_multipath.c b/drivers/scsi/scsi_multipath.c
> index b896d28a7dd9a..a482b6ede21aa 100644
> --- a/drivers/scsi/scsi_multipath.c
> +++ b/drivers/scsi/scsi_multipath.c
> @@ -248,11 +248,53 @@ void scsi_mpath_dev_clear_path(struct scsi_mpath_de=
vice *scsi_mpath_dev)
>                 mpath_synchronize(mpath_head);
>  }
> =20
> +static inline void bio_list_add_clone(struct bio_list *bl,
> +				struct bio *clone)
> +{
> +	struct bio *master_bio =3D clone->bi_private;
> +
> +	if (bl->tail)
> +		bl->tail->bi_next =3D master_bio;
> +	else
> +		bl->head =3D master_bio;
> +	bl->tail =3D master_bio;

[Severity: High]
Since master_bio is appended to the tail of the bio_list, shouldn't its
bi_next pointer be explicitly cleared to null to properly terminate the
singly-linked list?=20

When mpath_requeue_work() later iterates through the list, couldn't this
cause it to follow a stale bi_next pointer past the end of the list?

> +	bio_put(clone);
> +}
> +
>  static void scsi_mpath_clone_end_io(struct bio *clone)
>  {
>  	struct bio *master_bio =3D clone->bi_private;
> =20
>  	master_bio->bi_status =3D clone->bi_status;
> +
> +	if (clone->bi_status && blk_path_error(clone->bi_status)) {
> +		struct block_device *bi_bdev =3D clone->bi_bdev;
> +		struct request_queue *q =3D bi_bdev->bd_queue;
> +		struct scsi_device *sdev =3D scsi_device_from_queue(q);
> +		struct scsi_mpath_device *scsi_mpath_dev;
> +		struct mpath_device *mpath_device;
> +		struct mpath_head *mpath_head;
> +		unsigned long flags;
> +
> +		if (!sdev) {
> +			master_bio->bi_status =3D clone->bi_status;
> +			goto end_bio;
> +		}
> +
> +		scsi_mpath_dev =3D sdev->scsi_mpath_dev;
> +		mpath_device =3D &scsi_mpath_dev->mpath_device;
> +		mpath_head =3D mpath_device->mpath_head;

[Severity: High]
Is mpath_device->mpath_head guaranteed to be initialized here?=20

If scsi_mpath_dev_alloc() initializes scsi_mpath_dev with kzalloc but never
assigns this pointer, wouldn't this cause a null pointer dereference when
accessing requeue_lock below?

[Severity: High]
Could an in-flight I/O completion racing with path removal extract a freed
mpath_head here?=20

If scsi_mpath_remove_device() drops the reference to scsi_mpath_head and
frees it, but sdev->scsi_mpath_dev remains valid, it seems this could lead
to a use-after-free when accessing its requeue_lock.

> +
> +		spin_lock_irqsave(&mpath_head->requeue_lock, flags);
> +		bio_list_add_clone(&mpath_head->requeue_list, clone);
> +		spin_unlock_irqrestore(&mpath_head->requeue_lock, flags);
> +
> +		mpath_schedule_requeue_work(mpath_head);

[Severity: High]
When we schedule this requeue work, is there a corresponding cancel_work_sy=
nc()
during cleanup?

Looking at scsi_mpath_head_release(), it frees scsi_mpath_head without
cancelling or flushing mpath_head->requeue_work. Could this allow a
use-after-free if the background worker runs after the head is freed?

> +		scsi_device_put(sdev);

[Severity: High]
Will this cause a module reference count underflow?

scsi_device_from_queue() only acquires a device reference via get_device(),
but scsi_device_put() drops both the device and module reference. Should
this use put_device(&sdev->sdev_gendev) instead?

> +		return;
> +	}
> +
> +end_bio:
>  	bio_put(clone);
>  	bio_endio(master_bio);
>  }

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20260723093627.2327=
456-1-john.g.garry@oracle.com?part=3D19
