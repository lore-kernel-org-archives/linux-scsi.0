Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8ABA02367DF
	for <linux-scsi@vger.kernel.org>; Wed, 22 Jul 2026 22:36:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784759788; cv=none; b=Nhm8XevziXOqCPTTlXpOUqfK4tL93laibbOerukHBF8NXbgCQtIKzjSYlYSE+Yg583DQlw5TMSx5ttdUpWW2lUNKyOzOQvLPrc1NPK/amAqMOo9OqFw1cwbXSyWQkp4AR5yGucHhfw+Xd+Qo5u3qGQ10vPsVnP4vOY4zLmDLWZs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784759788; c=relaxed/simple;
	bh=ljqmP6BcnXEFCJV46iuFBJxPd5Ja+DTsLXMlWDdyZM0=;
	h=From:Subject:To:Cc:In-Reply-To:References:Content-Type:Date:
	 Message-Id; b=ostEQNB2vYHQ1V5OIbCVj3yVmKu84HhI8qnnROwY6pbHO9lp4PjWAy/W1w8Lpgamf4W5/J1V9PJFWSlaM1PtmRyLprqknKCd/8LYz+9pj8FBKKmQIeNhpqStY1E0Oug4CiL8lTi9A1bNhepKZRcWwI39xEkjLAf2V4ZV3DS41YM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=XMnEU9Rt; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="XMnEU9Rt"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 05DE61F000E9;
	Wed, 22 Jul 2026 22:36:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1784759787;
	bh=kCE/pj9Dkf+LgzZ1ILFVU4SjRaeq36VOEDX2oiHU+GM=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=XMnEU9RtXzm79vhXR6OtmBoiOV++4POpXDJor0kZ/rkwM0tiYYw7wa8QHxGTGoKPM
	 30SMMpP3d1C06CXG3z2U47i/47alK9I/9bYE5OkcQlW4E5jTg7XSFNWqj22w1xTjY+
	 Ucxnu3jB8pI6UFYA8vnwci1WPsPlDi6ZXdYIdn00bsh2j2ai8R2zOtCpaPT69dOS5k
	 gx+KEo/j7V6sE2siwtOCJHnTfeuCxYu+gbjNXmwxPFUvUOlLaxl1p+f2J8Bin4T6Yg
	 gBezzgkm38Kzyf1Yx6YAZ52kNPRSFEWCeWLJd4mS2tcyy8wne8TKhVoSxsfd3rk6h4
	 0FczmA2mBsPcw==
From: sashiko-bot@kernel.org
Subject: Re: [PATCH v1 1/4] smartpqi: Fix AIO retry marker cleared by SCSI
 core between dispatches.
Reply-To: sashiko-reviews@lists.linux.dev
To: "David Strahan" <david.strahan@microchip.com>
Cc: linux-scsi@vger.kernel.org
In-Reply-To: <20260722220401.6357-2-david.strahan@microchip.com>
References: <20260722220401.6357-1-david.strahan@microchip.com>
 <20260722220401.6357-2-david.strahan@microchip.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Wed, 22 Jul 2026 22:36:26 +0000
Message-Id: <20260722223627.05DE61F000E9@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>

Thank you for your contribution! Sashiko AI review found 1 potential issue(=
s) to consider:
- [High] State leakage across blk-mq tag reuse leads to erroneous drive off=
lining. By registering `.init_cmd_priv`, the driver opts out of the SCSI co=
re's per-dispatch zeroing of private command data, but fails to reliably cl=
ear `this_residual` on all completion paths.
--

--- Patch [1]: [PATCH v1 1/4] smartpqi: Fix AIO retry marker cleared by SCS=
I core between dispatches. ---
commit 594ef5db683084e131dde7930f0e556c7584b609
Author: David Strahan <David.Strahan@microchip.com>

smartpqi: Fix AIO retry marker cleared by SCSI core between dispatches.

This commit fixes an AIO retry loop issue by registering a per-command
initialization callback with the SCSI core to skip the per-dispatch clear.
This allows the retry marker to survive requeues, while the driver takes
over the responsibility of clearing it on terminal completion.

> diff --git a/drivers/scsi/smartpqi/smartpqi_init.c b/drivers/scsi/smartpq=
i/smartpqi_init.c
> index 5ec583dc2e7df..3a75b9fbedf45 100644
> --- a/drivers/scsi/smartpqi/smartpqi_init.c
> +++ b/drivers/scsi/smartpqi/smartpqi_init.c
> @@ -66,6 +66,12 @@ static struct pqi_cmd_priv *pqi_cmd_priv(struct scsi_c=
mnd *cmd)
>  	return scsi_cmd_priv(cmd);
>  }
> =20
> +static int pqi_init_cmd_priv(struct Scsi_Host *shost, struct scsi_cmnd *=
cmd)
> +{
> +	memset(pqi_cmd_priv(cmd), 0, sizeof(struct pqi_cmd_priv));
> +	return 0;
> +}
> +

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
Does this reliably clear the marker on all completion paths?

If a command is aborted via the SCSI error handler, it can be terminated
directly by the SCSI midlayer via scsi_finish_command(), which bypasses
pqi_prep_for_scsi_done().

Because pqi_init_cmd_priv() prevents the core from zeroing the private data
on dispatch, a reused blk-mq tag could inherit this stale marker state.

If the dirty tag is subsequently used for a request to a physical drive and
encounters an ILLEGAL_REQUEST, it appears pqi_process_raid_io_error() could
misinterpret the leaked marker and erroneously offline a healthy drive:

pqi_process_raid_io_error() {
    ...
    if (pqi_cmd_priv(scmd)->this_residual &&
        !pqi_is_logical_device(scmd->device->hostdata) &&
        scsi_status =3D=3D SAM_STAT_CHECK_CONDITION &&
        host_byte =3D=3D DID_OK &&
        sense_data_length &&
        scsi_normalize_sense(error_info->data, sense_data_length, &sshdr) &&
        sshdr.sense_key =3D=3D ILLEGAL_REQUEST &&
        sshdr.asc =3D=3D 0x26 &&
        sshdr.ascq =3D=3D 0x0) {
            host_byte =3D DID_NO_CONNECT;
            pqi_take_device_offline(scmd->device, "AIO");
    ...
}

Could this lead to unintended drive offlining if the tag is reused?

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20260722220401.6357=
-1-david.strahan@microchip.com?part=3D1
