Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6CCA049B1ED;
	Thu,  8 Oct 2026 12:33:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791462811; cv=none; b=o9KURercBQW3aqp+R3mCjhOGc+2H2NzSaOTAQg9ns+jm+mb4gTtO6XHKP9J3e7keogyxqQCZ4ruLVjKeos28MiaHiktJBA8MzR3jrYsV+DzuW6oaG9BFNBX3DzNJgqowgbECyrgXNeFvDYJx2rMlov7K++ZzAHc/rrRntdE334s=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791462811; c=relaxed/simple;
	bh=sE+cMTy7XLi5UV7qJ+PSse8SMYnq6RnWKcy/OO7hkD8=;
	h=Message-ID:From:Subject:To:Cc:In-Reply-To:References:Content-Type:
	 Date; b=jR5VxCQAN4XYIhVdPe1PYLlluS+41j6D4wpWD5Fmslf38D07k2IXJuFOcnqjRT3j9qT1Y1Z5Kzg0QR2Ua3rY0A0X/7C8B0cEO0CJEc6eQyDtK6ueQPqJ7cvkccMJ1r6V/+8IOs8LBIsTZV5mXjXDtdYNFBgo73q+ltZ3IY1lbN0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=HHeH5TiR; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="HHeH5TiR"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D141A1F000FF;
	Thu,  8 Oct 2026 12:33:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1791462810;
	bh=J0Pn77Z2UcCmoVLfwKKAmRiSIknvTwMXt4Z4sX3YnhE=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=HHeH5TiR8M+XGrsCqfV80hVku40CJUx6xbKcr/aalCYT4CuhMpj+NEHYF0E+FsJZD
	 I+L7uu3kjCJ8iTd4sTk3RcyahXyWRN8lmaH6pRY5ybwskLxeQyhuhAY4D85ho0r1OY
	 RbJMcIK07Y1okynmBErUYQbVewgEt/mxHL0bnE5ihNnHMp5Jq8tcK+qdMZ9IIsDh+x
	 W43LOrEXK7XLKRaRVTx3Qq5ohqGLRb3ZW5JVLQmNgxpxGzc6aGu0PEWf4TV3pxd6Wu
	 CMYA67qtlRkXl0kp6QXkzLtA5wrJsLmK6ViKdmAJUitqJD+fM7Wr7dPIBSZotuo7OF
	 s5xYqXkllOksg==
Message-ID: <sashiko-outbox-164150@kernel.org>
From: sashiko-bot@kernel.org
Subject: Re: [PATCH v2 2/2] usb: uas: add US_FL_QDEPTH_075 quirk to cap
 queue depth at probe time
Reply-To: sashiko-reviews@lists.linux.dev
To: "Luca Cecchi" <luca.cecchi.info@gmail.com>
Cc: linux-scsi@vger.kernel.org, linux-usb@vger.kernel.org
In-Reply-To: <20261008122604.1862534-2-luca.cecchi.info@gmail.com>
References: <20261008112645.1820678-1-luca.cecchi.info@gmail.com>
 <20261008122604.1862534-1-luca.cecchi.info@gmail.com>
 <20261008122604.1862534-2-luca.cecchi.info@gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Thu, 08 Oct 2026 12:33:29 +0000
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>

Thank you for your contribution! Sashiko AI review found 2 potential issue(=
s) to consider:
- [High] usb-storage: truncation of US_FL_QDEPTH_075 on 32-bit architectures
- [Medium] usb-storage: UAS queue depth cap overrides and violates 2-tag re=
serve for small qdepths
--

commit e6046cf877ab5ed09e6d0dc6b5f9a570cdfb3bd0
Author: Luca Cecchi <luca.cecchi.info@gmail.com>

usb: uas: add US_FL_QDEPTH_075 quirk to cap queue depth at probe time

This patch introduces the US_FL_QDEPTH_075 quirk to cap the queue depth of
specific USB attached SCSI devices at 3/4 of their reported maximum during
probe time. It applies this quirk to the Lexar ES3 enclosure to prevent
firmware lockups under sustained deep command queueing.

> diff --git a/drivers/usb/storage/uas.c b/drivers/usb/storage/uas.c
> index f745c9ee02d35..975598c6a6613 100644
> --- a/drivers/usb/storage/uas.c
> +++ b/drivers/usb/storage/uas.c
> @@ -1085,6 +1085,16 @@ static int uas_probe(struct usb_interface *intf, c=
onst struct usb_device_id *id)
>  	 */
>  	shost->can_queue =3D devinfo->qdepth - 2;
> =20
> +	/*
> +	 * Some bridge chips lock up under sustained deep command queueing
> +	 * even within the margin above. For those, US_FL_QDEPTH_075 caps
> +	 * the depth to 3/4 of the device's reported maximum at probe time,
> +	 * closing the window a udev-triggered .change_queue_depth write
> +	 * would otherwise leave open between probe and udev acting.
> +	 */
> +	if (devinfo->flags & US_FL_QDEPTH_075)
> +		shost->can_queue =3D (devinfo->qdepth * 3) / 4;

[Severity: Medium]
Does this unconditionally override the previously calculated safe queue dep=
th,
violating the 2-tag reserve for devices with small queue depths?

If a device or host controller limits qdepth to a small value, for example =
4,
the original logic safely restricts can_queue to 2 to reserve 1 tag for
untagged commands and 1 tag for firmware off-by-one errors.

With this change, (4 * 3) / 4 evaluates to 3, which accidentally inflates
can_queue instead of capping it, leaving only 1 tag reserved.

Could this use min_t(int, shost->can_queue, (devinfo->qdepth * 3) / 4) to
ensure the baseline reservations are always respected?

> diff --git a/drivers/usb/storage/unusual_uas.h b/drivers/usb/storage/unus=
ual_uas.h
> index d6f86d5db3bf2..d41f206faea13 100644
> --- a/drivers/usb/storage/unusual_uas.h
> +++ b/drivers/usb/storage/unusual_uas.h
[ ... ]
> +/* Reported-by: Luca Cecchi <luca.cecchi.info@gmail.com> */
> +UNUSUAL_DEV(0x21c4, 0x0003, 0x0000, 0x9999,
> +		"Lexar",
> +		"ES3",
> +		USB_SC_DEVICE, USB_PR_DEVICE, NULL,
> +		US_FL_QDEPTH_075),

[Severity: High]
Will the US_FL_QDEPTH_075 quirk be silently discarded on 32-bit architectur=
es?

The usb_device_id struct uses kernel_ulong_t for the driver_info field,
which is a 32-bit unsigned long on 32-bit platforms.

Because US_FL_QDEPTH_075 is defined as a 33-bit value:

include/linux/usb_usual.h:
    US_FLAG(QDEPTH_075, 0x100000000ULL)

When UNUSUAL_DEV sets this flag in the table here, casting the 64-bit value
to kernel_ulong_t will silently truncate the upper bits to 0 on 32-bit
platforms. This leaves affected devices exposed to the firmware lockups this
patch intends to fix.

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20261008122604.1862=
534-1-luca.cecchi.info@gmail.com?part=3D2
