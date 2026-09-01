Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F294A47CA9D
	for <linux-scsi@vger.kernel.org>; Tue,  1 Sep 2026 11:09:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788260992; cv=none; b=FKIACvcRaCQnRmtsAr4B+fRrJfQsTttog5RuakOuKIRMGl7s/yyIYy5atxkiylMD4BeXSK/peFy+myy9Y1YseCHxlzyK24p4Z82hMBmxyerwr7oNjKiCFhdE3DOfHPGpKmPVAIQpyjTbvszNqKvtahTtkDhdXlsGUX3XX5aPYXY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788260992; c=relaxed/simple;
	bh=ROW6bGNRxFoaqbfZelJUaWBEOHJGT1FbYZ2HtG6JU50=;
	h=From:Subject:To:Cc:In-Reply-To:References:Content-Type:Date:
	 Message-Id; b=bPfBDNIuyuT57LWAs5b3SnDi9CsTOBWOEVtcR2Ymijv5sR6DG0jxf8m1lw4Z5TF/b7vTo5myqFOvro7/KOUfHBWQ7phrAXL/5RIeNWAqooPfDLzAk1EcWW5w0WJNUNZbJbnwBg1b4CgypktWknGviOkAu+qoouUdAvoaQzxEXy4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=LupzVQ9f; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="LupzVQ9f"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8159E1F000E9;
	Tue,  1 Sep 2026 11:09:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1788260990;
	bh=JM6nK2TEKCmyaItB5NKkVKhjJcHKq6CTmwSSl/d21kc=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=LupzVQ9fa5RvW0xETRqdjvYrBa6ZHf7rkxbIqs/8Y/FORfoffs1SWfcR3yyQ3MXhF
	 M5C9KSuOxRcAzM8OdTsWx0tuzVUamD9gDIJCN297hV6EdrWDAiYeEPbsAZEUwL1wf0
	 6CDcU0HmYYpsew3RfSoJXz8PADnYAxNTMQ1YWXk2Y/CnyTNMuLeHJ2vAHQHdcTUBmk
	 wtgTAFXxYwY46c1hNHVf2hjzp2yqnEFGUDX9Fps0Df0DCFNgUEZxPNFye3nMY6FlZ6
	 T+n5kDiarLaLfHlbEXvh0sZJDY+O2fFSCNUNfiQUoYtm8b5LhSwHrLOhkc655c5sUW
	 nx4YvT8yr6OLg==
From: sashiko-bot@kernel.org
Subject: Re: [PATCH v7 18/27] scsi-multipath: failover handling
Reply-To: sashiko-reviews@lists.linux.dev
To: "John Garry" <john.g.garry@oracle.com>
Cc: linux-scsi@vger.kernel.org
In-Reply-To: <20260901104526.3850621-19-john.g.garry@oracle.com>
References: <20260901104526.3850621-1-john.g.garry@oracle.com>
 <20260901104526.3850621-19-john.g.garry@oracle.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Tue, 01 Sep 2026 11:09:49 +0000
Message-Id: <20260901110950.8159E1F000E9@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>

Thank you for your contribution! Sashiko AI review found 1 potential issue(=
s) to consider:
- [High] Path failover is prematurely aborted if the underlying path device=
 is removed, and dropping its reference causes a sleep-in-atomic bug.
--

commit 657b83f2533d51dce7950c14bb5248625186e04d
Author: John Garry <john.garry@linux.dev>
Subject: scsi-multipath: failover handling

This commit implements failover handling for scsi_cmnd by requeuing the
master bio of each bio attached to a failed request. Failover is detected
in scsi_mpath_clone_end_io() when blk_path_error() occurs.

> diff --git a/drivers/scsi/scsi_multipath.c b/drivers/scsi/scsi_multipath.c
> --- a/drivers/scsi/scsi_multipath.c
> +++ b/drivers/scsi/scsi_multipath.c

[ ... ]

>  static void scsi_mpath_clone_end_io(struct bio *clone)
>  {
>  	struct bio *master_bio =3D clone->bi_private;
> =20
> +	if (clone->bi_status && blk_path_error(clone->bi_status)) {
> +		struct block_device *bi_bdev =3D clone->bi_bdev;
> +		struct request_queue *q =3D bi_bdev->bd_queue;
> +		struct scsi_device *sdev =3D scsi_device_from_queue(q);
> +		struct scsi_mpath_device *scsi_mpath_dev;
> +		struct mpath_device *mpath_device;
> +		struct mpath_head *mpath_head;
> +		unsigned long flags;
> +
> +		if (!sdev)
> +			goto end_bio;

[Severity: High]
If the underlying device is being removed and scsi_device_from_queue()
returns NULL, does this prematurely abort the failover?

Bailing out here directly propagates the path error to the master bio,
which seems to break the multipath failover guarantee.

> +
> +		scsi_mpath_dev =3D sdev->scsi_mpath_dev;
> +		mpath_device =3D &scsi_mpath_dev->mpath_device;
> +		mpath_head =3D mpath_device->mpath_head;
> +
> +		spin_lock_irqsave(&mpath_head->requeue_lock, flags);
> +		bio_list_add_clone(&mpath_head->requeue_list, clone);
> +		spin_unlock_irqrestore(&mpath_head->requeue_lock, flags);
> +
> +		mpath_schedule_requeue_work(mpath_head);
> +		put_device(&sdev->sdev_gendev);

[Severity: High]
Can this put_device() call trigger a sleep-in-atomic panic?

Since scsi_mpath_clone_end_io() executes in the softirq context of a bio
end_io handler, dropping the last reference here can call
scsi_device_dev_release(), which explicitly enforces might_sleep().

Could mpath_head be safely derived directly from
master_bio->bi_bdev->bd_disk->private_data instead of indirectly through
the underlying path device?

> +		return;
> +	}
> +
> +end_bio:
>  	master_bio->bi_status =3D clone->bi_status;
>  	bio_put(clone);
>  	bio_endio(master_bio);

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20260901104526.3850=
621-1-john.g.garry@oracle.com?part=3D18
