Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4AB91201113
	for <linux-scsi@vger.kernel.org>; Thu, 23 Jul 2026 10:33:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784802793; cv=none; b=NlCyk8Hc5id+5JOr64MqUOUYV3NdaJdwNySwH4RNi0h7iGoEC6U/4I+fxtdBB1YxLSDggP7oQe+EXqgMf/znXSmvX7IMtAOgFF5c9xYhJp7qBb71ntSa2nEY7cxPtLFVGS7s8Kf5XuaybLvdIWJl+/9MXw2ZPuBsAp446+BS9jI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784802793; c=relaxed/simple;
	bh=D1HgBHKXsCDX8Kiut6oRE4feMBLiewIYU2SqufxM0YI=;
	h=From:Subject:To:Cc:In-Reply-To:References:Content-Type:Date:
	 Message-Id; b=iR8l/GJd7zTx0n3TlBVXblzvK6h70WViWLSOHai+O5hoguVzH8SRVRK8P9w6nqfRlkAB7xinU7HHYx956qiMs6Km+oOcN9ZTpeT5jKZC76RG+JkztEAZkgtDZYowHIqw7FmbWuidryUwPFrUblnbdvyM0X3QDfnqXQzfKHxWC0Y=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 816FC1F000E9;
	Thu, 23 Jul 2026 10:33:11 +0000 (UTC)
From: sashiko-bot@kernel.org
Subject: Re: [PATCH v4 17/28] scsi-multipath: clear path when device is
 blocked
Reply-To: sashiko-reviews@lists.linux.dev
To: "John Garry" <john.g.garry@oracle.com>
Cc: linux-scsi@vger.kernel.org
In-Reply-To: <20260723093627.2327456-18-john.g.garry@oracle.com>
References: <20260723093627.2327456-1-john.g.garry@oracle.com>
 <20260723093627.2327456-18-john.g.garry@oracle.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Thu, 23 Jul 2026 10:33:10 +0000
Message-Id: <20260723103311.816FC1F000E9@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>

Thank you for your contribution! Sashiko AI review found 3 potential issue(=
s) to consider:
- [High] Calling mpath_synchronize() while the block device queue is quiesc=
ed and sdev->state_mutex is held causes a circular dependency deadlock unde=
r IO load.
- [High] scsi_mpath_dev_clear_path() triggers a guaranteed NULL pointer der=
eference because mpath_device->mpath_head is never initialized in the SCSI =
multipath framework.
- [High] Lifecycle races during device removal, initialization, or error pa=
ths cause scsi_mpath_dev_clear_path() to calculate and dereference an inval=
id pointer or freed memory.
--

--- Patch [17]: [PATCH v4 17/28] scsi-multipath: clear path when device is =
blocked ---
commit 5b8022a9b2f8e87d8f78b7424101ac5ed615cc6f
Author: John Garry <john.garry@linux.dev>

scsi-multipath: clear path when device is blocked

Add scsi_mpath_dev_clear_path() to clear a device path when it becomes
blocked.

> diff --git a/drivers/scsi/scsi_lib.c b/drivers/scsi/scsi_lib.c
> --- a/drivers/scsi/scsi_lib.c
> +++ b/drivers/scsi/scsi_lib.c

[ ... ]

> @@ -2999,13 +3000,16 @@ static void scsi_device_block(struct scsi_device =
*sdev, void *data)
>  	mutex_lock(&sdev->state_mutex);
>  	err =3D __scsi_internal_device_block_nowait(sdev);
>  	state =3D sdev->sdev_state;
> -	if (err =3D=3D 0)
> +	if (err =3D=3D 0) {
>  		/*
>  		 * scsi_stop_queue() must be called with the state_mutex
>  		 * held. Otherwise a simultaneous scsi_start_queue() call
>  		 * might unquiesce the queue before we quiesce it.
>  		 */
>  		scsi_stop_queue(sdev);
> +		if (sdev->scsi_mpath_dev)
> +			scsi_mpath_dev_clear_path(sdev->scsi_mpath_dev);

[Severity: High]
Could this lead to a circular dependency deadlock under IO load?

When scsi_device_block() stops the queue via scsi_stop_queue(),
no further requests are dispatched. If it then calls
scsi_mpath_dev_clear_path(), it ends up calling mpath_synchronize(),
which executes synchronize_srcu() while sdev->state_mutex is still held.

Concurrently, a thread inside mpath_bdev_submit_bio() could be holding
the SRCU read lock:

lib/multipath.c:mpath_bdev_submit_bio()
    srcu_idx =3D srcu_read_lock(&mpath_head->srcu);
    ...
    submit_bio_noacct(bio);

If this submit_bio_noacct() path blocks on tag exhaustion because the
queue is quiesced, it will never release the SRCU read lock.
mpath_synchronize() would then block indefinitely waiting for the SRCU
reader. Any subsequent attempt to unquiesce the queue would require
sdev->state_mutex, which is held by the thread blocked in
mpath_synchronize().

> +	}
> =20
>  	mutex_unlock(&sdev->state_mutex);

> diff --git a/drivers/scsi/scsi_multipath.c b/drivers/scsi/scsi_multipath.c
> --- a/drivers/scsi/scsi_multipath.c
> +++ b/drivers/scsi/scsi_multipath.c

[ ... ]

> @@ -230,6 +230,16 @@ static int scsi_multipath_sdev_init(struct scsi_devi=
ce *sdev)
>  	return 0;
>  }
> =20
> +void scsi_mpath_dev_clear_path(struct scsi_mpath_device *scsi_mpath_dev)
> +{
> +       struct mpath_device *mpath_device =3D &scsi_mpath_dev->mpath_devi=
ce;
> +       struct scsi_mpath_head *scsi_mpath_head =3D scsi_mpath_dev->scsi_=
mpath_head;
> +       struct mpath_head *mpath_head =3D &scsi_mpath_head->mpath_head;

[Severity: High]
Are there lifecycle races when dereferencing scsi_mpath_dev here?

The scsi_device_block() function calls this while holding state_mutex,
but pointers like scsi_mpath_dev->scsi_mpath_head are mutated locklessly
relative to state_mutex. For example, during removal,
scsi_mpath_remove_head() sets scsi_mpath_dev->scsi_mpath_head to NULL
before state_mutex is acquired in __scsi_remove_device().

If a concurrent device block event occurs while the head is NULL, computing
&scsi_mpath_head->mpath_head will yield an invalid pointer. Similarly,
initialization error paths free sdev->scsi_mpath_dev without holding
state_mutex, which could lead to a use-after-free if scsi_device_block()
observes a non-NULL pointer before the memory is freed.

> +
> +       if (mpath_clear_current_path(mpath_device))

[Severity: High]
Is mpath_device->mpath_head guaranteed to be initialized before calling thi=
s?

The scsi_mpath_dev is allocated using kzalloc() in
scsi_multipath_sdev_init(), meaning the embedded mpath_device is
zero-initialized. The mpath_device->mpath_head pointer doesn't appear to be
explicitly assigned anywhere in the SCSI multipath framework.

If mpath_clear_current_path() is called, it executes:

lib/multipath.c:mpath_clear_current_path()
    struct mpath_head *mpath_head =3D mpath_device->mpath_head;
    ...
    if (mpath_device =3D=3D rcu_access_pointer(mpath_head->current_path[nod=
e]))

Since mpath_device->mpath_head is NULL, wouldn't this unconditional
dereference result in an immediate panic whenever a SCSI multipath
device is blocked?

> +               mpath_synchronize(mpath_head);
> +}

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20260723093627.2327=
456-1-john.g.garry@oracle.com?part=3D17
