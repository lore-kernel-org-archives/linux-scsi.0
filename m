Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E5EAC47A0C7
	for <linux-scsi@vger.kernel.org>; Tue,  1 Sep 2026 11:05:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788260750; cv=none; b=IWZ4hjxMEkGsf3m112qmUJ6Kre2M6QGuyXrYcmnoW4zyROkMK+sDerpbM9o3ttc/B/H3PQtL4fBwtPYKyHW4wbW3FAm2oVq/20h22zcOO/1KPlP4Gdkpyn1sDiNt8PuElVOyZg2HEllUm0bW/wv59KpHbwA1TQxm2pTSgrPfcug=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788260750; c=relaxed/simple;
	bh=EHOLmqUpHwzpPZEj3GknA6UsFpa+ImBy1c3L80N66c8=;
	h=From:Subject:To:Cc:In-Reply-To:References:Content-Type:Date:
	 Message-Id; b=c5OFrw4gkuTm9IMLrYRQBMp9zGvqJUfBWJ9Q9AoLAF3SQuTvMTl94hdVU34cdPdZspMe/iIgsnGYCfTBffP7kx/al7c3c74EEXGQRIWzEJ3Vl3C3vrNUThTkl0Im/sYLG/ts6t8ID3c9f1q/AU5WW0QnnJqWtLocMXxdq1Vr5uE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=k13urAE4; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="k13urAE4"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A06911F000E9;
	Tue,  1 Sep 2026 11:05:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1788260748;
	bh=n4Ls5VwmkLFLRY3Ac6wO/8d4rl3avLi4jAQf4yRA5kE=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=k13urAE4CycbvTTIyp2mSfjg4ZfLe1oAWs+z4oAcZ9Cgood7PsAp6cArU6gzm/fVv
	 +FhUvv/uzN6m7Too31m0sm0AYkQiFWcsdF2gANkd96E5PMFsoqO0FWd6gMpP8qvzKs
	 WPelxw9hIA8laknKdz3sw3d0V+hw/j5zdfYawwaZDzldjN86IKBIN40BZcIh00sG0Q
	 zPmcnvqSVjgUx4GEN6WEgaGmKhCkRrzysHmNaxD5jRlzpXq8NO8c+K56UxA4g6y5Z6
	 8CR8juwz3BVMuwqS/19FsfsSi3y5lz/XvSpLcWZEVEZbg1uM3qbdr1sOPY5lFzTj6A
	 KtDiyAyY9DncQ==
From: sashiko-bot@kernel.org
Subject: Re: [PATCH v7 06/27] libmultipath: Add delayed removal support
Reply-To: sashiko-reviews@lists.linux.dev
To: "John Garry" <john.g.garry@oracle.com>
Cc: linux-scsi@vger.kernel.org
In-Reply-To: <20260901104526.3850621-7-john.g.garry@oracle.com>
References: <20260901104526.3850621-1-john.g.garry@oracle.com>
 <20260901104526.3850621-7-john.g.garry@oracle.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Tue, 01 Sep 2026 11:05:48 +0000
Message-Id: <20260901110548.A06911F000E9@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>

Thank you for your contribution! Sashiko AI review found 1 potential issue(=
s) to consider:
- [High] Setting `delayed_removal_secs` to 0 via sysfs clears the `MPATH_HE=
AD_QUEUE_IF_NO_PATH` flag but fails to kick the requeue list, leaving alrea=
dy-queued I/Os stranded indefinitely.
--

commit 751b8b804bd2a99a7fc5d0ec1509ae11a6846846
Author: John Garry <john.garry@linux.dev>
Subject: libmultipath: Add delayed removal support

This commit adds support for delayed removal of multipath devices, similar
to NVMe, to keep the disk and cdev present during intermittent periods with
no available paths. A delayed work callback is utilized to handle the teard=
own,
and sysfs helpers are exposed for the driver to configure the duration.

> diff --git a/lib/multipath.c b/lib/multipath.c
> index 6b8f6e846987a..fada92bf9754c 100644
> --- a/lib/multipath.c
> +++ b/lib/multipath.c

[ ... ]

> @@ -572,6 +620,47 @@ void mpath_device_set_live(struct mpath_device *mpat=
h_device)
>  }
>  EXPORT_SYMBOL_GPL(mpath_device_set_live);

[ ... ]

> +ssize_t mpath_delayed_removal_secs_store(struct mpath_head *mpath_head,
> +			const char *buf, size_t count)
> +{
> +	unsigned int sec;
> +	ssize_t ret;
> +
> +	ret =3D kstrtouint(buf, 0, &sec);
> +	if (ret < 0)
> +		return ret;
> +
> +	mutex_lock(&mpath_head->lock);
> +	mpath_head->delayed_removal_secs =3D sec;
> +	if (sec)
> +		set_bit(MPATH_HEAD_QUEUE_IF_NO_PATH, &mpath_head->flags);
> +	else
> +		clear_bit(MPATH_HEAD_QUEUE_IF_NO_PATH, &mpath_head->flags);
> +	mutex_unlock(&mpath_head->lock);
> +
> +	/*
> +	 * Ensure that update to MPATH_HEAD_QUEUE_IF_NO_PATH is seen
> +	 * by its reader.
> +	 */
> +	mpath_synchronize(mpath_head);
> +
> +	return count;

[Severity: High]
When delayed_removal_secs is set to 0, this clears the
MPATH_HEAD_QUEUE_IF_NO_PATH flag, but does it also need to kick the requeue
list (e.g., via mpath_schedule_requeue_work())?

If there are I/Os already placed in mpath_head->requeue_list during a path
failure while the delay was active, could they remain stranded indefinitely
once the delay is disabled?

> +}
> +EXPORT_SYMBOL_GPL(mpath_delayed_removal_secs_store);

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20260901104526.3850=
621-1-john.g.garry@oracle.com?part=3D6
