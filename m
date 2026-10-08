Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3F29C471255;
	Thu,  8 Oct 2026 11:36:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791459397; cv=none; b=gPlbQoycpMolEDt6S3fTtd42VIYV8M5jv0ASRUWNZoZrZ14otyBhls/lcOlQzPz1mchVmOagLikQrv1Zpwo+Yny2n0DFKKNGaSkWwE4FSgn2Dow9a7zecm1Jh9L9R/BL/PV2F+R8QjWQQVpsSojasB1/Odm2vIY0babZnBRh5IQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791459397; c=relaxed/simple;
	bh=DEMbRY6VV4iEIoWV+q7/xLhIfMejTb+fm+jkifECHO8=;
	h=Message-ID:From:Subject:To:Cc:In-Reply-To:References:Content-Type:
	 Date; b=gPHIb1qutU2lBilIZ5wrvEv1adODweS9aFYEjM5uiaK9v+NnNpjcXFuqAiJVoCNrti4P81iKS2Kcs9yYs7qXSwPaSD/75jDpf2gSyzCpQJgKCjqCkgVRIyOtMmMgYUn25DntvVCIxG+aH72rjPAO18wqBUoplNoQiPZhZuQSSHA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=N+0V/KX/; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="N+0V/KX/"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A57D41F000FF;
	Thu,  8 Oct 2026 11:36:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1791459395;
	bh=4VL5U/E690+KYpIiJvGY/kB03Ey3ce+zoj5ieh4wP/k=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=N+0V/KX//iJ8cXoqkH9Uzjd579+742Oh721RfF+YtnpTNCM5Lyk7qbFWHjioIPcxL
	 Oh6BT6CzMUZJL99Jat2W+MCqNS7l5T5LX7jaiMcxK7VDibU5R2Ws70ewzUtx2cmwqV
	 H+5HJSEYfItc4kFd7fA1SShC0WbMr1RkJVWCigMh9fnxDeXPmsCSEDyxpUhp+N5tdH
	 6otboIq/QsSh1iivn7H1Uhk+lmB8HCXa90SwIOSZJNJR+a1a01rE9yVP2OZeWDAEbf
	 DqfxKEzTeEF3f4sDXOWe+eBRg1AP9fSAepDeHr66H9ek59FFsjaU4N+Jk9UcoIj6q5
	 5zetrlhOEs+HA==
Message-ID: <sashiko-outbox-164096@kernel.org>
From: sashiko-bot@kernel.org
Subject: Re: [PATCH] usb: uas: implement .change_queue_depth to allow
 per-device queue depth override
Reply-To: sashiko-reviews@lists.linux.dev
To: "Luca Cecchi" <luca.cecchi.info@gmail.com>
Cc: linux-usb@vger.kernel.org, linux-scsi@vger.kernel.org
In-Reply-To: <20261008112645.1820678-1-luca.cecchi.info@gmail.com>
References: <f82a72b7-6122-4bbc-adf4-2d08706344a2@suse.com>
 <20261008112645.1820678-1-luca.cecchi.info@gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Thu, 08 Oct 2026 11:36:35 +0000
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>

Thank you for your contribution! Sashiko AI review found 1 potential issue(=
s) to consider:
- [High] uas: negative queue depth underflow via uas_change_queue_depth()
--

commit 9d52d5cb6887ffe601d9599b2dbfb63939e5e572
Author: Luca Cecchi <luca.cecchi.info@gmail.com>

usb: uas: implement .change_queue_depth to allow per-device queue depth ove=
rride

This commit implements .change_queue_depth for UAS devices to allow
per-device queue depth overrides. This helps affected users lower the
depth for just their device without disabling UAS altogether.

> diff --git a/drivers/usb/storage/uas.c b/drivers/usb/storage/uas.c
> index 8655edbd66b16..55291b4d0b825 100644
> --- a/drivers/usb/storage/uas.c
> +++ b/drivers/usb/storage/uas.c

[ ... ]

> @@ -910,6 +910,27 @@ static int uas_sdev_configure(struct scsi_device *sd=
ev,
>  	return 0;
>  }
> =20
> +/*
> + * uas does not implement .change_queue_depth, so the standard sysfs
> + * queue_depth attribute stays read-only for every UAS device (see
> + * scsi_sysfs.c:sdev_store_queue_depth(), which requires
> + * sht->change_queue_depth !=3D NULL). Some bridge chips become
> + * unstable under deep command queueing; wiring this up lets affected
> + * users lower the depth for just their device (e.g. via a udev rule
> + * matching idVendor/idProduct), without disabling UAS altogether.
> + * Default behaviour (qdepth - 2) is unchanged unless userspace asks
> + * for less.
> + */
> +static int uas_change_queue_depth(struct scsi_device *sdev, int depth)
> +{
> +	struct uas_dev_info *devinfo =3D (struct uas_dev_info *)sdev->host->hos=
tdata;
> +	int max_depth =3D devinfo->qdepth - 2;
> +
> +	if (depth > max_depth)
> +		depth =3D max_depth;
> +	return scsi_change_queue_depth(sdev, depth);
> +}

[Severity: High]
Can this underflow queue_depth in the block layer if stream allocation
fails during a reset?

If a USB reset fails (e.g., via uas_post_reset() or uas_reset_resume()),
uas_configure_endpoints() can overwrite devinfo->qdepth with a negative
error code:

drivers/usb/storage/uas.c:uas_configure_endpoints() {
    ...
		devinfo->qdepth =3D usb_alloc_streams(devinfo->intf, eps + 1,
						    3, MAX_CMNDS, GFP_NOIO);
		if (devinfo->qdepth < 0)
			return devinfo->qdepth;
    ...
}

If devinfo->qdepth is negative (e.g. -ENOMEM), uas_change_queue_depth()
will calculate a negative max_depth and clamp the requested depth to this
negative limit.

When this negative depth is passed to scsi_change_queue_depth(), it
bypasses the depth > 0 condition but is still passed to
blk_set_queue_depth():

drivers/scsi/scsi.c:scsi_change_queue_depth() {
    ...
	if (depth > 0) {
		sdev->queue_depth =3D depth;
		wmb();
	}

	if (sdev->request_queue)
		blk_set_queue_depth(sdev->request_queue, depth);
    ...
}

Because blk_set_queue_depth() expects an unsigned int, the negative
value can underflow to a massive integer, corrupting q->queue_depth and
potentially breaking block layer QoS mechanisms (like WBT or Kyber).

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20261008112645.1820=
678-1-luca.cecchi.info@gmail.com?part=3D1
