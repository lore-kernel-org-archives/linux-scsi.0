Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BA601346E7A
	for <linux-scsi@vger.kernel.org>; Mon, 27 Jul 2026 15:17:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785165440; cv=none; b=hlU1dOxv+8ISVcVu8yJdpoqdJXwOy2JW30EYkJuAqRR3++jXDtAO0HzCKh+ZfkDKJqLWrwevjGu2j0fXN4N4X5VGMVEa8xN5MIgYMciPPXIcjJeVJUoA5O3xbGN1P8dbUK+aLfjccu0MVnpxQ6ohFuJ6BGrVh5nJEj7Jo92qZy0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785165440; c=relaxed/simple;
	bh=76XNsW0IuQOryRPxY589hBqbFSDfDKdhmLAzE2asTaY=;
	h=From:Subject:To:Cc:In-Reply-To:References:Content-Type:Date:
	 Message-Id; b=oaI9YUyCdkTBdY9eA8yUnfRGIWGFYK+mH1V1ygVgLWjhb7WUWQV5a1XQ2L3eVl8jybMyTmCBRa66u5fPJhfzX/LxG7Y0IW+BlG7jHNrSNglvrMC6QRSdSO1gz5elYwK9fKv3Sph5gNX92FBms5bM+mAlDEcrSDoBsTXNqGqm67I=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=lhIZRiqf; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="lhIZRiqf"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3ED9C1F000E9;
	Mon, 27 Jul 2026 15:17:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1785165439;
	bh=FEPojtBWCzTaAhWrrxdgm09VLjy9pBWdTxBqDNQUZZw=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=lhIZRiqfWTQiFRitLmjlLVFa+UrfgFzK3PdsWZkB/Nd2MVllE9s2/wheOWIzJUI2K
	 r4N92jGiMtCP96UYciUoIiYxORvW8ZV8IsHaL/eauo/gfqOus4abYYo3fWsIoKVeQx
	 XHAWvY6EMPZGIYVnszCtIqiQlPiGw9IQQueZb2/Tcr1xLj/H/YI4TarIPdfSbyZ277
	 BBxUqRFnaxQM9WmpFyF68uBzRwp7PdC+dj1HfprSXNCxz5WdcAoywVaplGtZth2Gsv
	 sBlBxDq0Kc6B7H4Ej+IOqQHe6GwIfkB4NQHJbxKB/pbX6nt2RZWE3hrkuJ0kkYV5bM
	 eIU0sew8UNEFw==
From: sashiko-bot@kernel.org
Subject: Re: [PATCH v5 17/27] scsi-multipath: revalidate paths upon device
 unblock
Reply-To: sashiko-reviews@lists.linux.dev
To: "John Garry" <john.g.garry@oracle.com>
Cc: linux-scsi@vger.kernel.org
In-Reply-To: <20260727144234.3802948-18-john.g.garry@oracle.com>
References: <20260727144234.3802948-1-john.g.garry@oracle.com>
 <20260727144234.3802948-18-john.g.garry@oracle.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Mon, 27 Jul 2026 15:17:18 +0000
Message-Id: <20260727151719.3ED9C1F000E9@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>

Thank you for your contribution! Sashiko AI review found 2 potential issue(=
s) to consider:
- [High] Race condition in `scsi_internal_device_unblock` and `scsi_device_=
block` leading to NULL pointer dereference.
- [High] Concurrent execution of `scsi_mpath_dev_alloc` and transport block=
/unblock leads to Use-After-Free and NULL pointer dereference.
--

--- Patch [17]: [PATCH v5 17/27] scsi-multipath: revalidate paths upon devi=
ce unblock ---
commit d7b8727956ce248cf872dc90fa72742ade627f54
Author: John Garry <john.garry@linux.dev>

scsi-multipath: revalidate paths upon device unblock
   =20
When a scsi_device is unblocked, this patch clears paths and requeues
any queued bios to revalidate the paths.

> diff --git a/drivers/scsi/scsi_lib.c b/drivers/scsi/scsi_lib.c
> --- a/drivers/scsi/scsi_lib.c
> +++ b/drivers/scsi/scsi_lib.c
[ ... ]
> @@ -3092,6 +3092,8 @@ static int scsi_internal_device_unblock(struct scsi=
_device *sdev,
>  	mutex_lock(&sdev->state_mutex);
>  	ret =3D scsi_internal_device_unblock_nowait(sdev, new_state);
>  	mutex_unlock(&sdev->state_mutex);
> +	if ((ret =3D=3D 0) && sdev->scsi_mpath_dev)
> +		scsi_mpath_revalidate_paths(sdev->scsi_mpath_dev);
> =20
>  	return ret;
>  }

[Severity: High]
Can this lockless check of sdev->scsi_mpath_dev lead to a use-after-free or=
=20
NULL pointer dereference?

During device discovery, scsi_alloc_sdev() publishes the scsi_device to=20
shost->__devices. After this, scsi_mpath_dev_alloc() assigns=20
sdev->scsi_mpath_dev but can fail and jump to out_uninit where it frees=20
the structure:

drivers/scsi/scsi_multipath.c:scsi_mpath_dev_alloc() {
    ...
    ret =3D scsi_multipath_sdev_init(sdev);
    if (ret)
        return ret;

    ret =3D scsi_mpath_unique_lun_id(sdev);
    if (ret < 0)
        goto out_uninit;
    ...
}

If an asynchronous transport event triggers scsi_internal_device_unblock()=
=20
during this window, could it read a freed sdev->scsi_mpath_dev, or one wher=
e=20
scsi_mpath_head is not yet initialized?

Could a concurrent device removal also trigger a similar race?

If __scsi_remove_device() executes after the mutex_unlock() but before=20
sdev->scsi_mpath_dev is evaluated, it could set the device state to=20
SDEV_CANCEL and call scsi_mpath_remove_device(). This sets=20
scsi_mpath_dev->scsi_mpath_head to NULL.

(Note: An earlier patch in this series appears to introduce an identical=20
lockless pattern in scsi_device_block() checking sdev->scsi_mpath_dev.)

> diff --git a/drivers/scsi/scsi_multipath.c b/drivers/scsi/scsi_multipath.c
> --- a/drivers/scsi/scsi_multipath.c
> +++ b/drivers/scsi/scsi_multipath.c
[ ... ]
> @@ -231,6 +231,14 @@ static int scsi_multipath_sdev_init(struct scsi_devi=
ce *sdev)
>  	return 0;
>  }
> =20
> +void scsi_mpath_revalidate_paths(struct scsi_mpath_device *scsi_mpath_de=
v)
> +{
> +       struct scsi_mpath_head *scsi_mpath_head =3D scsi_mpath_dev->scsi_=
mpath_head;
> +       struct mpath_head *mpath_head =3D &scsi_mpath_head->mpath_head;
> +
> +       mpath_revalidate_paths(mpath_head);
> +}

[Severity: High]
Does this code safely handle a NULL scsi_mpath_head?

If the race mentioned above occurs and a concurrent teardown clears=20
scsi_mpath_head to NULL, would this assignment dereference the NULL pointer=
=20
when attempting to resolve mpath_head?

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20260727144234.3802=
948-1-john.g.garry@oracle.com?part=3D17
