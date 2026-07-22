Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 169D04252BB
	for <linux-scsi@vger.kernel.org>; Wed, 22 Jul 2026 20:39:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784752779; cv=none; b=C3rBf4TTTFf+d+zbAUY38TndRKAa4ZKJLFIQc1mueeUT0Sp9H9hUsuY8tBF+thlWC3ZsIqPn/x2HAzr6iIO2z4LR8x0dj9rq3KhXJeOcIK+GadWqZ3i1CuCGcjKG/iz8xq5YOEMs41snmMrNkhqw1PFrSxkiy9QofuMBvG7JV48=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784752779; c=relaxed/simple;
	bh=Yt7CWrgBp09WePH0n42lzhNIJpb/ZnrOQ5c8kiOGnoo=;
	h=From:Subject:To:Cc:In-Reply-To:References:Content-Type:Date:
	 Message-Id; b=BcUIQSNT7xAOCOioHeMmwPdOdXY32tifdShWvp6NJMhKf9aAXuXPviGVEdOBcwCUbsTRTHaJCKkcPvbN5kIEVNGAC9w50hkZmPSxE380p2tNFsnFtTksuKqvnlT7klyZEwXmYAOXFpwJSMkbXkobKAORnhL+fj9ntRMDmPSHh68=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=llZZrYcV; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="llZZrYcV"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 787DA1F000E9;
	Wed, 22 Jul 2026 20:39:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1784752777;
	bh=fxnhKATtPhKQnc67hMrHelripSLNlZCu/2NYDOZ5ogU=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=llZZrYcVH6y0nPSUzPYcTB0IiNzFgXrEHtOA7yLrFS+dPY43sOiqPSHhFJkmiluOy
	 mK1j+r+ebyyVbiRAL3cjfOJSMXghi6fmpP7H8dge6WwVK2WzUXC9LU+1absStZ86Kt
	 jx+6BCK/aES5hdoRpjduJ3KyCPyBlA+Jzsb8ttLwd5XSrbF6BxeZ5+4RSFkIuUG5Cr
	 MLnU7xkEanjqUa+FkWtRUNGX7HTWot925CH7Y8wjBAsRNZR6C7HGX+5V4RO8JiYWIC
	 htblIqTs3tCWkHobuxyxnqfOzRIT/sumc3G8BUt2xlpP+d2KXwOXZ61fo6lgk1KMrO
	 H2zcrq/w1Mhog==
From: sashiko-bot@kernel.org
Subject: Re: [PATCH] scsi: smartpqi: Fix AIO retry marker cleared by SCSI
 core between dispatches
Reply-To: sashiko-reviews@lists.linux.dev
To: "David Strahan" <david.strahan@microchip.com>
Cc: linux-scsi@vger.kernel.org
In-Reply-To: <20260722202327.5242-3-david.strahan@microchip.com>
References: <20260722202327.5242-1-david.strahan@microchip.com>
 <20260722202327.5242-3-david.strahan@microchip.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Wed, 22 Jul 2026 20:39:37 +0000
Message-Id: <20260722203937.787DA1F000E9@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>

Thank you for your contribution! Sashiko AI review found 1 potential issue(=
s) to consider:
- [High] The driver-private retry marker (`this_residual`) is leaked across=
 block layer tag reuses if a command completing with `DID_IMM_RETRY` is ter=
minally completed by the SCSI midlayer. This permanently poisons the tag, d=
isabling AIO bypass for future requests and causing the driver to erroneous=
ly offline healthy physical drives on routine errors.
--

--- Patch [1]: [PATCH] scsi: smartpqi: Fix AIO retry marker cleared by SCSI=
 core between dispatches ---
commit b11e42cf8728d0b2c04d732af5bc5bfb1648bc25
Author: David Strahan <David.Strahan@microchip.com>

scsi: smartpqi: Fix AIO retry marker cleared by SCSI core between dispatches

This patch registers a per-command initialization callback to prevent the
SCSI core from clearing driver private data between dispatches. It allows an
AIO retry marker (this_residual) to survive requeues, with the driver taking
over the responsibility of clearing the marker on terminal completions.

> diff --git a/drivers/scsi/smartpqi/smartpqi_init.c b/drivers/scsi/smartpq=
i/smartpqi_init.c
> --- a/drivers/scsi/smartpqi/smartpqi_init.c
> +++ b/drivers/scsi/smartpqi/smartpqi_init.c

[ ... ]

> @@ -5958,6 +5964,17 @@ void pqi_prep_for_scsi_done(struct scsi_cmnd *scmd)
>  	struct pqi_scsi_dev *device;
>  	struct completion *wait;
> =20
> +	/*
> +	 * Clear the AIO-retry marker on final completion so the tag
> +	 * starts clean on its next dispatch.  On DID_IMM_RETRY leave
> +	 * it intact: pqi_aio_io_complete() sets DID_IMM_RETRY and
> +	 * bumps the marker to steer the requeue onto the RAID path,
> +	 * and pqi_process_raid_io_error() consumes the non-zero
> +	 * marker to offline a misbehaving drive.
> +	 */
> +	if (host_byte(scmd->result) !=3D DID_IMM_RETRY)
> +		pqi_cmd_priv(scmd)->this_residual =3D 0;
> +

[Severity: High]
Does this code risk leaking the this_residual marker across unrelated
requests that reuse the same blk-mq tag?

If a command completing with DID_IMM_RETRY is terminally completed by the
SCSI midlayer instead of being requeued (for instance, if
scsi_cmd_runtime_exceeced(cmd) overrides the disposition to SUCCESS in
scsi_lib.c:scsi_complete()), the driver-private command data will not be
cleared here.

Because this patch disables the SCSI core's per-dispatch zeroing via
pqi_init_cmd_priv(), the stale this_residual > 0 marker would remain on
the tag.

If that poisoned tag is reused for a new request targeting a physical drive,
and the new request encounters a routine SCSI error (like ILLEGAL_REQUEST),
would pqi_process_raid_io_error() misinterpret the stale marker as a failed
AIO retry and erroneously call pqi_take_device_offline() on a healthy
physical drive?

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20260722202327.5242=
-3-david.strahan@microchip.com?part=3D1
