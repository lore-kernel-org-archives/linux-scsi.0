Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DDBD037E5D1
	for <linux-scsi@vger.kernel.org>; Mon, 27 Jul 2026 15:14:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785165272; cv=none; b=i/LfTcTWBRX6o0FR9zBpRbFCl499JANCBOVKeKaBfyDdjZnsNlBBYxNXHoVxmBqGMnA0PRbDanTxQoYHWZ+JticZSUgs3h1pgVOuqzuK5juL2sVzPazzlUkh+xGtwK8rqux4TLl5CoHMScZgYt7QYaTrUWRLY/S61tzAmMro0MM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785165272; c=relaxed/simple;
	bh=oz1JYSpRN2VwDNd1YdxWMBRSqrJlxu6rbwsPMwHszeQ=;
	h=From:Subject:To:Cc:In-Reply-To:References:Content-Type:Date:
	 Message-Id; b=S87zbVYJnCN+pk6WkFJwzOA8tkXl2Q+0L8N6RcLDDWQfUPha0BSPyqqCGN3GvZ1FXsvWqpmJsMz93ACosmf/20Xj49FLVhsOdKVWG6Tg+9/iSX2h6fQhSVoo6EsbXgQf2pSc7g4Lb+l/0FNIafCFAZy73CpHVCZ+lBc/3Zl9zDA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=GYk1OLsM; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="GYk1OLsM"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9A09E1F000E9;
	Mon, 27 Jul 2026 15:14:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1785165270;
	bh=7oYkDo6iKtSsP0LwPqK8xE0ZFPvYzYptnWiXGFh06nM=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=GYk1OLsMHRGonsxl4b+oFOjC4tKUYJEfdKlIHIyUW3QTeuTjTXyT39+K7WRzsv/YA
	 67bo807Vm92IESTvO3uQ+U9ktmOTwH1zFufCO22lWT0u1GtzXYh8eZXkbkw81gzF7q
	 Lh7PVxTLIFmpZOliYN9huc857VQpgckSTo+r1kDpQajtU+BCf8D6Fojr0kl2ljUK9P
	 VREhEe3iTPnswTU458ZEB0YoWqODDgvrZju0eI3vUjgtJUt5C6Y+CCisNZQth+0MMp
	 UBEFaKiJshgX5y5DnMjitATUunWVeh3d0yI1bTwEkpQ3EfvJJQmYfgiFDrn+bNp2eT
	 RhjpOyK8iQaTw==
From: sashiko-bot@kernel.org
Subject: Re: [PATCH v5 16/27] scsi-multipath: clear path when device is
 blocked
Reply-To: sashiko-reviews@lists.linux.dev
To: "John Garry" <john.g.garry@oracle.com>
Cc: linux-scsi@vger.kernel.org
In-Reply-To: <20260727144234.3802948-17-john.g.garry@oracle.com>
References: <20260727144234.3802948-1-john.g.garry@oracle.com>
 <20260727144234.3802948-17-john.g.garry@oracle.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Mon, 27 Jul 2026 15:14:30 +0000
Message-Id: <20260727151430.9A09E1F000E9@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>

Thank you for your contribution! Sashiko AI review found 1 potential issue(=
s) to consider:
- [High] A Time-of-Check to Time-of-Use (TOCTOU) race condition in `scsi_de=
vice_block()` due to lockless access to `sdev->scsi_mpath_dev` leads to NUL=
L pointer dereferences and Use-After-Free vulnerabilities during device ini=
tialization, teardown, and initialization failure.
--

--- Patch [16]: [PATCH v5 16/27] scsi-multipath: clear path when device is =
blocked ---
commit 029c1109c722c76acac1333821c2190171087cb6
Author: John Garry <john.garry@linux.dev>

scsi-multipath: clear path when device is blocked

Add scsi_mpath_dev_clear_path() to clear a device path when it becomes
blocked.

Signed-off-by: John Garry <john.g.garry@oracle.com>

> diff --git a/drivers/scsi/scsi_lib.c b/drivers/scsi/scsi_lib.c
> index daeb3693fe559..a1ec11050090c 100644
> --- a/drivers/scsi/scsi_lib.c
> +++ b/drivers/scsi/scsi_lib.c

[ ... ]

> @@ -3008,6 +3009,8 @@ static void scsi_device_block(struct scsi_device *s=
dev, void *data)
>  		scsi_stop_queue(sdev);
> =20
>  	mutex_unlock(&sdev->state_mutex);
> +	if ((err =3D=3D 0) && sdev->scsi_mpath_dev)
> +		scsi_mpath_dev_clear_path(sdev->scsi_mpath_dev);

[Severity: High]
Since sdev->scsi_mpath_dev is read locklessly after dropping state_mutex,
can this race with device teardown or initialization failures?

If a concurrent teardown or error path calls scsi_multipath_sdev_uninit()=20
and frees sdev->scsi_mpath_dev, could this result in a use-after-free when=
=20
evaluating or passing the pointer to scsi_mpath_dev_clear_path()?

>  	WARN_ONCE(err, "%s: failed to block %s in state %d\n",
>  		  __func__, dev_name(&sdev->sdev_gendev), state);

[ ... ]

> diff --git a/drivers/scsi/scsi_multipath.c b/drivers/scsi/scsi_multipath.c
> index 5999c59bf7297..801d95652fc6b 100644
> --- a/drivers/scsi/scsi_multipath.c
> +++ b/drivers/scsi/scsi_multipath.c

[ ... ]

> @@ -231,6 +231,16 @@ static int scsi_multipath_sdev_init(struct scsi_devi=
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
Could scsi_mpath_dev->scsi_mpath_head be NULL here?

Looking at scsi_multipath_sdev_init(), sdev->scsi_mpath_dev is published
globally before the inner scsi_mpath_head structure is fully initialized:

scsi_multipath_sdev_init() {
    ...
    scsi_mpath_dev->sdev =3D sdev;
    sdev->scsi_mpath_dev =3D scsi_mpath_dev;
    ...
}

If a concurrent scsi_device_block() call sees the non-NULL wrapper, would
this dereference a NULL scsi_mpath_head?

> +
> +       if (mpath_clear_current_path(mpath_device))
> +               mpath_synchronize(mpath_head);
> +}

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20260727144234.3802=
948-1-john.g.garry@oracle.com?part=3D16
