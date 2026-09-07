Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4A20A39280C
	for <linux-scsi@vger.kernel.org>; Mon,  7 Sep 2026 11:56:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788782166; cv=none; b=FTXA6CR2rbTvT29x/fXbaQS9EqEuAOxun4gyq37XSQgHsYcwEP9BQeS8DoWhngHwAkDAZwqYL7Kv/2MQXLIH8XV+nyUh4udUEAzSSMaBJW+W5tX3CnK9AtwqvYsEPR5gU8aZMZFdomzM3+1/oPb3pEnZIFfY6eIPWLNJbxQUWcA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788782166; c=relaxed/simple;
	bh=1AixA4bkl8pQG6cUgCv925UfbvQBf7HX9WyAdDznv+Y=;
	h=From:Subject:To:Cc:In-Reply-To:References:Content-Type:Date:
	 Message-Id; b=upMGIzKtJJTrFT4EW298x/7YypObJm5sgtJomWebY9FxXhDSjXUsAccWcfCpJGrni8i8exyhjbNdG5kMFT4o6OQv5fT3LbAon+oiBcN6+64J1yzlsRLlkbAfrJzIGM14qUIum5LsZLISh4dlIbeXk/TloJwsIkO0f+NV36la2Fc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=dHPQjK2/; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="dHPQjK2/"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 63C811F00A3A;
	Mon,  7 Sep 2026 11:56:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1788782164;
	bh=S8U4xIIY4JYoyKcBUJVASF0nWJFYoCsJjjvP0kgrMqc=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=dHPQjK2/ezjZuY3cWrIa7G8OQC5Q3LPWr1r3tkw+KNTvz0cjgaEXl208uaVlDeYHX
	 +Ec6399Ze5ChuDeOrVe/MBg4tjqQUdBZzRPJXnuwqBxpF0ZLfA6e/cBxhFXHCquXE8
	 JoxY1QOgByuqLwFxa30tVTlSIfzaTZDHHSye1gId6q/DBcZ2gc9F71HVexrV8kdGep
	 nhjook61hT5JYPhzqI9Wz7Db1b8J0bMhbWgyi8Aka6QSeeL0UxHre1Pa7dEKvr7qxX
	 dEOC0VxLI5zo1xUaDP69u8q+kHRgMS6NvwdDMKZlWkZxi6JvK03wcBcwtwe+dA2/O3
	 hbLCFI5NHbp6g==
From: sashiko-bot@kernel.org
Subject: Re: [PATCH v8 17/27] scsi-multipath: revalidate paths upon device
 unblock
Reply-To: sashiko-reviews@lists.linux.dev
To: "John Garry" <john.g.garry@oracle.com>
Cc: linux-scsi@vger.kernel.org
In-Reply-To: <20260907105021.1763236-18-john.g.garry@oracle.com>
References: <20260907105021.1763236-1-john.g.garry@oracle.com>
 <20260907105021.1763236-18-john.g.garry@oracle.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Mon, 07 Sep 2026 11:56:03 +0000
Message-Id: <20260907115604.63C811F00A3A@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>

Thank you for your contribution! Sashiko AI review found 2 potential issue(=
s) to consider:
- [High] Concurrent invocation of device block/unblock during initializatio=
n dereferences a NULL scsi_mpath_head.
- [High] TOCTOU race in scsi_device_block and scsi_internal_device_unblock =
accessing multipath state outside state_mutex, causing a NULL pointer deref=
erence during device teardown.
--

commit d9e004c51ebcdd24da98702a7fb3f90971c90665
Author: John Garry <john.garry@linux.dev>

    scsi-multipath: revalidate paths upon device unblock

This patch adds a revalidation step for multipath devices when a scsi_device
is unblocked, clearing paths and requeuing any queued bios.

> diff --git a/drivers/scsi/scsi_lib.c b/drivers/scsi/scsi_lib.c
> index 56200a7f5c748..1a6f5e1fd80cb 100644
> --- a/drivers/scsi/scsi_lib.c
> +++ b/drivers/scsi/scsi_lib.c
> @@ -3093,6 +3093,8 @@ static int scsi_internal_device_unblock(struct scsi=
_device *sdev,
>  	mutex_lock(&sdev->state_mutex);
>  	ret =3D scsi_internal_device_unblock_nowait(sdev, new_state);
>  	mutex_unlock(&sdev->state_mutex);
> +	if ((ret =3D=3D 0) && sdev->scsi_mpath_dev)
> +		scsi_mpath_revalidate_paths(sdev->scsi_mpath_dev);

[Severity: High]
Are there race conditions involving multipath state modification outside of
the sdev->state_mutex?

It appears a concurrent __scsi_remove_device() could acquire state_mutex,
transition the device to SDEV_CANCEL or SDEV_DEL, and call
scsi_mpath_remove_device(). This sets scsi_mpath_dev->scsi_mpath_head to
NULL. When scsi_internal_device_unblock() resumes, it could call
scsi_mpath_revalidate_paths() which then attempts to use the NULL pointer.

Is it also possible for this code to execute on a partially initialized
multipath device?

During device discovery, scsi_mpath_dev_alloc() assigns sdev->scsi_mpath_dev
but initially leaves scsi_mpath_dev->scsi_mpath_head as NULL while
performing a blocking INQUIRY. If a transport event (like a link flap)
concurrently triggers scsi_target_block() and scsi_target_unblock(),
scsi_internal_device_unblock() could be called and operate on the still-NULL
scsi_mpath_head.

The same unprotected call pattern appears to exist in scsi_device_block(),
which was introduced in a prior patch in this series.

[ ... ]
> diff --git a/drivers/scsi/scsi_multipath.c b/drivers/scsi/scsi_multipath.c
> index b16fe6a55fa73..456351fee4b98 100644
> --- a/drivers/scsi/scsi_multipath.c
> +++ b/drivers/scsi/scsi_multipath.c
> @@ -238,6 +238,14 @@ static int scsi_multipath_sdev_init(struct scsi_devi=
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

[Severity: High]
If scsi_mpath_head is NULL due to the races mentioned above during unblock
or block operations, will this unconditionally dereference the NULL pointer
when calculating the offset for mpath_head?

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20260907105021.1763=
236-1-john.g.garry@oracle.com?part=3D17
