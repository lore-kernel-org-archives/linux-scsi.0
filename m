Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EB5842EEE7C
	for <linux-scsi@vger.kernel.org>; Fri,  3 Jul 2026 11:40:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1783078854; cv=none; b=AhtoeY3b3K74klsVU/rJ35YE3VDq0BOqrFIGm2PyQBJtC60h2B5w9tI0fNvWCsPSQGExlNnzcuExiKHasVlcgxWKopcAq45WL8H9AoBW0dRxcg8Xk1DyrfqyHGeLZMmgU8nuswvtQdL2L4raNsdbZufmz/wKxuJoxUJ1H2ISGtE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1783078854; c=relaxed/simple;
	bh=CDxkLe56Kfvo1qWsM7AmbPI0jiR95UxHUU/qwbah7Q4=;
	h=From:Subject:To:Cc:In-Reply-To:References:Content-Type:Date:
	 Message-Id; b=a07adywjp8Go3zKzlMyVmcJImFBqpmy307eNV/hpXBNYNhN+glb7DSNlaqONx/dqgY6RTfulI6vNZftKgn+TZVGDU2Z9LGlxv6INPDpVTcwCPl8Y+3V34dNw9rCIeyazAx8vLq04wqrztI78urBkvc9m5gZ4CmLILhPzruZJ4+E=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=jg1+K6nn; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="jg1+K6nn"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6437E1F000E9;
	Fri,  3 Jul 2026 11:40:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1783078852;
	bh=qZZZ/fZMiKn5pOlFcms53TdGLWVYjYySpOpL+qTPzxg=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=jg1+K6nnn/9Y1J+ydh2j7TV1wjuGLazDkAco3+MwVWSCabLNUk9HnZELd4OpzQoqe
	 nEY1yVCt/h1DJuF2NfjeqY/NVhXtZc34cZVk563UXMnSpIfAM1eRnV80mis2kvo4Q9
	 B6DHcKCmPamFDBULw5DoOL8Xhx5TS5mw6Iy6P8DrW8IRaDYfckXoerB0d32FEvAnEI
	 JFEBDPYu/d97MKTDRVDbQPcuyOD76tqPoIzhAbot+AKO8RiFyuDt4EIpYcRfhd65iO
	 63wq+Rc9vyeUL7Y0NjZqhbGn3KvM8hdcaqTmynW0iEL4MguDH7VYwaiexHQGQY9yyr
	 ibkhA05A/jD9Q==
From: sashiko-bot@kernel.org
Subject: Re: [PATCH v3 07/17] scsi-multipath: failover handling
Reply-To: sashiko-reviews@lists.linux.dev
To: "John Garry" <john.g.garry@oracle.com>
Cc: linux-scsi@vger.kernel.org
In-Reply-To: <20260703103402.3725011-8-john.g.garry@oracle.com>
References: <20260703103402.3725011-1-john.g.garry@oracle.com>
 <20260703103402.3725011-8-john.g.garry@oracle.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Fri, 03 Jul 2026 11:40:51 +0000
Message-Id: <20260703114052.6437E1F000E9@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>

Thank you for your contribution! Sashiko AI review found 3 potential issue(=
s) to consider:
- [High] Unchecked dereference of `sdev` returned by `scsi_device_from_queu=
e()` leading to an immediate kernel panic.
- [High] Leaking a reference to `scsi_device` acquired by `scsi_device_from=
_queue()`.
- [High] Calling a sleepable synchronization function in `bio_end_io` atomi=
c context.
--

commit 8a70735872bb7cb2125e8980a60e0bae2a38b040
Author: John Garry <john.g.garry@oracle.com>

scsi-multipath: failover handling

This commit implements failover handling for scsi commands that fail due to
the target device's transport going down. It requeues the master bio of each
bio attached to the request by handling the failover inside the
scsi_mpath_clone_end_io() completion handler.

> diff --git a/drivers/scsi/scsi_multipath.c b/drivers/scsi/scsi_multipath.c
> index 0f3f3f9fa5fae..f22e3677cf2ad 100644
> --- a/drivers/scsi/scsi_multipath.c
> +++ b/drivers/scsi/scsi_multipath.c
[ ... ]
> @@ -242,11 +242,44 @@ static int scsi_multipath_sdev_init(struct scsi_dev=
ice *sdev)
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
> +		struct scsi_mpath_device *scsi_mpath_dev =3D sdev->scsi_mpath_dev;

[Severity: High]
Can scsi_device_from_queue() return NULL here? If a path error occurs=20
concurrently with a device removal or hot-unplug, get_device() inside=20
scsi_device_from_queue() could fail. If sdev is NULL, wouldn't accessing=20
sdev->scsi_mpath_dev on the very next line cause an immediate NULL pointer=
=20
dereference?

> +		struct mpath_device *mpath_device =3D &scsi_mpath_dev->mpath_device;
> +		struct mpath_head *mpath_head =3D mpath_device->mpath_head;
> +		unsigned long flags;
> +
> +		scsi_mpath_dev_clear_path(scsi_mpath_dev);

[Severity: High]
Is it safe to call scsi_mpath_dev_clear_path() from a bio completion handle=
r?=20
Since scsi_mpath_clone_end_io() runs in atomic softirq context, and=20
scsi_mpath_dev_clear_path() can call mpath_synchronize() which might sleep=
=20
to wait for grace periods, could this trigger a sleeping in atomic context=
=20
BUG?

> +
> +		spin_lock_irqsave(&mpath_head->requeue_lock, flags);
> +		bio_list_add_clone(&mpath_head->requeue_list, clone);
> +		spin_unlock_irqrestore(&mpath_head->requeue_lock, flags);
> +
> +		mpath_schedule_requeue_work(mpath_head);
> +		return;

[Severity: High]
Does this return path leak the reference to the scsi_device?=20

When scsi_device_from_queue() is called earlier, it increments the device's=
=20
kobject reference count via get_device(). There doesn't appear to be a=20
corresponding put_device() before returning here, which might permanently=20
prevent device cleanup on unplug if repeated failovers occur.

> +	}
> +
>  	bio_put(clone);
>  	bio_endio(master_bio);
>  }

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20260703103402.3725=
011-1-john.g.garry@oracle.com?part=3D7
