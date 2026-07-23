Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 90E2C421243
	for <linux-scsi@vger.kernel.org>; Thu, 23 Jul 2026 10:39:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784803145; cv=none; b=dopcn0Cw5zHuoCNVYNjFrIQt5uvYmikCAgj8yEX1+gZIoaO1IfKBTFwwr+AlfW5gSmroCqbYtUuLRNZUXAwSBCubdj/Abfc1WHE6EYyvKg7rzfakM2rhkIxKRPWqcL4XSGAngskzwQsfK7YaI2R5TkmU/VegDAJcD3XaqUKkguQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784803145; c=relaxed/simple;
	bh=8YBzqkZzzYy4peHVbNiW5YrxfHfj0FD8gt2bubQOn0I=;
	h=From:Subject:To:Cc:In-Reply-To:References:Content-Type:Date:
	 Message-Id; b=lHjhOK+xb9pz6lPVC2+3nRvMz949rO8H1bjLqkxTqar+F7iKDnDGJXmouVRNd+HtqVKaAUagv0Stq/JGuxouDdDsx9KLdkGAGdNvl86ChMg07EvNdMyq96+X5pCiaLgixB2sf9w33VDIilGT7sL8P0mrH0cI7flJ/uMXmvx+v3w=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=QzNgyeFm; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="QzNgyeFm"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 43CA01F000E9;
	Thu, 23 Jul 2026 10:39:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1784803144;
	bh=Cchn2jqIm0W3ucKiLxCJVveHlBEv5Y8d1oDWOZoNOnI=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=QzNgyeFmjH5c4Ro0ezRcsLNcbYP8YDbr/6EbXANhumby7MlWDzIdbMAjqc4FDXLwC
	 YvIgKojEaaavu3WDBxl/4fKF9lUTTmY/xCLe1vNAGUM2qEze1hT1Rw5QVoARD5WufQ
	 ACmfHkGGtw3HzajP8u4vKU+/lp9GHeH34vAd9PHVq6/SgdIfc+w+hHQqcWJN5wxuAR
	 vqHec7vzN1rRma4AR57tr3yIFlI2QXoKENCCAaLFqIX+xtN3nzzJJDbOwj0pwCbz9R
	 oE+45OCHPxZ7WZoY5rdasZwNleBMX1UeHI5nJMEEuZEYEYeth8aDQKmc4CujftBTIL
	 MwpyiYUCIn47w==
From: sashiko-bot@kernel.org
Subject: Re: [PATCH v4 18/28] scsi-multipath: revalidate paths upon device
 unblock
Reply-To: sashiko-reviews@lists.linux.dev
To: "John Garry" <john.g.garry@oracle.com>
Cc: linux-scsi@vger.kernel.org
In-Reply-To: <20260723093627.2327456-19-john.g.garry@oracle.com>
References: <20260723093627.2327456-1-john.g.garry@oracle.com>
 <20260723093627.2327456-19-john.g.garry@oracle.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Thu, 23 Jul 2026 10:39:03 +0000
Message-Id: <20260723103904.43CA01F000E9@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>

Thank you for your contribution! Sashiko AI review found 3 potential issue(=
s) to consider:
- [High] The newly added call to `scsi_mpath_revalidate_paths()` in `scsi_i=
nternal_device_unblock()` races with device initialization and teardown, le=
ading to a NULL pointer dereference or Use-After-Free.
- [High] Missing cancellation of `mpath_head->requeue_work` causes use-afte=
r-free when `scsi_mpath_head` is freed.
- [Medium] Path revalidation is skipped for devices unblocked via `scsi_int=
ernal_device_unblock_nowait()`.
--

--- Patch [18]: [PATCH v4 18/28] scsi-multipath: revalidate paths upon devi=
ce unblock ---
commit b434ea17223b4b11754a84ac3b62a1af5b823144
Author: John Garry <john.garry@linux.dev>

scsi-multipath: revalidate paths upon device unblock

This patch adds functionality to revalidate paths when a scsi_device is
unblocked. It introduces scsi_mpath_revalidate_paths() to clear paths and
requeue bios, and hooks it into scsi_internal_device_unblock().

> diff --git a/drivers/scsi/scsi_lib.c b/drivers/scsi/scsi_lib.c
> index f2729c0969801..d98c3239c13ad 100644
> --- a/drivers/scsi/scsi_lib.c
> +++ b/drivers/scsi/scsi_lib.c
> @@ -3092,6 +3092,8 @@ static int scsi_internal_device_unblock(struct scsi=
_device *sdev,
> =20
>  	mutex_lock(&sdev->state_mutex);
>  	ret =3D scsi_internal_device_unblock_nowait(sdev, new_state);
> +	if ((ret =3D=3D 0) && sdev->scsi_mpath_dev)
> +		scsi_mpath_revalidate_paths(sdev->scsi_mpath_dev);

[Severity: High]
Can this lead to a use-after-free or NULL pointer dereference during device
removal?

If __scsi_remove_device() transitions the device to SDEV_CANCEL and unlocks
state_mutex, it then locklessly calls scsi_mpath_remove_device() which sets
scsi_mpath_head to NULL and frees it.

If scsi_internal_device_unblock() runs concurrently,=20
scsi_internal_device_unblock_nowait() will return 0 (success) because the
device state is SDEV_CANCEL.

Does this cause the unblock path to mistakenly proceed and call
scsi_mpath_revalidate_paths(), dereferencing the freed or NULL
scsi_mpath_head?

[Severity: Medium]
Are there callers that bypass scsi_internal_device_unblock() and call
scsi_internal_device_unblock_nowait() directly?

If drivers directly call the nowait variant to unblock a device, it seems
they will successfully transition the device to SDEV_RUNNING but skip this
new path revalidation. Will this leave their queued bios stuck?

>  	mutex_unlock(&sdev->state_mutex);
> =20
>  	return ret;
> diff --git a/drivers/scsi/scsi_multipath.c b/drivers/scsi/scsi_multipath.c
> index 6a2b06c148c1a..b896d28a7dd9a 100644
> --- a/drivers/scsi/scsi_multipath.c
> +++ b/drivers/scsi/scsi_multipath.c
> [ ... ]
> @@ -230,6 +230,14 @@ static int scsi_multipath_sdev_init(struct scsi_devi=
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
Does this introduce a race condition with mpath_head->requeue_work?

Calling mpath_revalidate_paths() schedules requeue_work locklessly. If this
revalidation happens right as the device is being removed, is the work item
properly canceled?

If scsi_mpath_head_release() frees the scsi_mpath_head structure without
calling cancel_work_sync() or flush_work() on the embedded requeue_work,
could the mpath_requeue_work() callback execute against freed memory?

> +
>  void scsi_mpath_dev_clear_path(struct scsi_mpath_device *scsi_mpath_dev)
>  {

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20260723093627.2327=
456-1-john.g.garry@oracle.com?part=3D18
