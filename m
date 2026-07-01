Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9504C37D107
	for <linux-scsi@vger.kernel.org>; Wed,  1 Jul 2026 04:17:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1782879427; cv=none; b=UzG4wtbalodLtpIvLk8BEkjOSM4KPSGJX4g6j6MeqsF5GfQfE+QBLsFh9I0VaAYPTw/l0Qb4T2i3qmhe8Fi3gX61O03H0TIkwI11t8eYgcLzzWfWXg2UoKSvVzTKvdUgwbudNy7mc3Uc+ThMiQHy29XTOSe7608GRwH99mgFNAY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1782879427; c=relaxed/simple;
	bh=f1KLE6LKM9EkzKFlfP3F9JEMq1AlLT18+98ZTbhpwWc=;
	h=From:Subject:To:Cc:In-Reply-To:References:Content-Type:Date:
	 Message-Id; b=GUjFG/gfMAcCF1S67PUOshiCazX17a6HrGB4NUq16T8s0XnBkQfb0HVFT3WHTX/PfDEFSQMO/7+M0Iovwe5+43hfqVPZdKoDet8cL6hy8CIEGyRD5wA3geNJcsts1jfUrMuDhGPYIl19Q/fwf86ReVkqI+Dly3C9fR30a3SGy00=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=hQwFpKPx; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="hQwFpKPx"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EB7971F000E9;
	Wed,  1 Jul 2026 04:17:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1782879421;
	bh=0fZXIwrvO/bEvAxJSx80FfEX5QxwZqburHvu5sOLzu8=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=hQwFpKPxeZryDK3IkoIbsC9tx88TaFyfksVDWgF/SznKb9H9Qfv+mXBGOJ0iPD6Lx
	 fxNf/CV29y8s6M8ROcqT/J93jAqsfGmm++mwkAJVzjq0tLrJ6ba7vmVZCD1qB3lX07
	 PNMuocWsy/dLkISIwT5rlXWYJUgdzOqxZ1cP6X73Nkyp0MN6UgX2A1vQQEZDSylLKE
	 0WJ0gen+0jwVtNqeABNEjhMAhp5kPnzjCyaEfCzL5LhqLnvdezaiotgjQfAwVwsLDt
	 VOo1bDdF4ezwsXM1SyYx1APVHTRFihcWVeE/3VOhSxondAeomGxnf4dwD8qocmQlho
	 QyfDUlO5zx70w==
From: sashiko-bot@kernel.org
Subject: Re: [RFC PATCH] usb: storage: uas: limit consecutive device resets
 in error handling
Reply-To: sashiko-reviews@lists.linux.dev
To: "Sergey Senozhatsky" <senozhatsky@chromium.org>
Cc: linux-scsi@vger.kernel.org
In-Reply-To: <20260701040335.810297-1-senozhatsky@chromium.org>
References: <20260701040335.810297-1-senozhatsky@chromium.org>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Wed, 01 Jul 2026 04:17:00 +0000
Message-Id: <20260701041700.EB7971F000E9@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>

Thank you for your contribution! Sashiko AI review found 2 potential issue(=
s) to consider:
- [High] Prematurely clearing `devinfo->resetting` and dropping the lock be=
fore calling `uas_zap_pending()` creates a race window with `uas_do_work()`=
, leading to a kernel warning and Use-After-Free.
- [Medium] Time-of-Check to Time-of-Use (TOCTOU) race when reading the `uas=
_reset_limit` module parameter.
--

commit 6406fc4d6f651e14233de5d86645319b7366244d
Author: Sergey Senozhatsky <senozhatsky@chromium.org>

usb: storage: uas: limit consecutive device resets in error handling

When a UAS storage device experiences persistent wire or hardware IO failur=
es,
it can cause an infinite loop in the SCSI error handler. This commit
introduces a runtime-configurable module parameter 'reset_limit' to track
consecutive resets and abort the loop by returning FAILED, allowing SCSI EH
to offline the unresponsive device.

> diff --git a/drivers/usb/storage/uas.c b/drivers/usb/storage/uas.c
> index 2651629812694..a63c66c8bbad2 100644
> --- a/drivers/usb/storage/uas.c
> +++ b/drivers/usb/storage/uas.c

[ ... ]

> @@ -796,6 +803,21 @@ static int uas_eh_host_reset_handler(struct scsi_cmn=
d *cmnd)
>  	usb_kill_anchored_urbs(&devinfo->cmd_urbs);
>  	usb_kill_anchored_urbs(&devinfo->sense_urbs);
>  	usb_kill_anchored_urbs(&devinfo->data_urbs);
> +
> +	spin_lock_irqsave(&devinfo->lock, flags);
> +	if (uas_reset_limit > 0 && devinfo->reset_cnt >=3D uas_reset_limit) {

[Severity: Medium]
Can a concurrent sysfs write cause a Time-of-Check to Time-of-Use race here?

The module parameter uas_reset_limit has 0644 permissions. It is read twice
in this condition without a READ_ONCE() wrapper. If it is modified from a
positive value to zero or negative strictly between the two evaluations, the
first check (uas_reset_limit > 0) could pass, while the second check could
evaluate against the new zero or negative value, prematurely failing the re=
set
and offlining the device.

> +		devinfo->resetting =3D 0;
> +		spin_unlock_irqrestore(&devinfo->lock, flags);
> +		uas_zap_pending(devinfo, DID_NO_CONNECT);

[Severity: High]
Does clearing devinfo->resetting and dropping the lock before calling
uas_zap_pending() introduce a race condition with uas_do_work()?

If uas_do_work() is scheduled while the lock is dropped, it will see
devinfo->resetting is 0:

drivers/usb/storage/uas.c:uas_do_work()
	if (devinfo->resetting)
		goto out;

This allows it to bypass the safety check and submit new URBs for pending
commands. Then, when uas_zap_pending() runs, it will fail to complete these
commands because they have newly inflight URBs:

drivers/usb/storage/uas.c:uas_zap_pending()
	err =3D uas_try_complete(cmnd, __func__);
	WARN_ON(err !=3D 0);

uas_try_complete() will return -EBUSY. The error handler then returns FAILE=
D,
which prompts the SCSI EH to offline the device and forcibly complete and f=
ree
the scsi_cmnd structures. When the newly submitted URBs later complete, the=
ir
callbacks might access the freed scsi_cmnd, causing a use-after-free.

> +		usb_unlock_device(udev);
> +		shost_printk(KERN_ERR, sdev->host,
> +			     "%s FAILED reset limit %d exceeded\n",
> +			     __func__, uas_reset_limit);
> +		return FAILED;
> +	}
> +	devinfo->reset_cnt++;
> +	spin_unlock_irqrestore(&devinfo->lock, flags);
> +

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20260701040335.8102=
97-1-senozhatsky@chromium.org?part=3D1
