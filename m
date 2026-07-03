Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9FFEA356754
	for <linux-scsi@vger.kernel.org>; Fri,  3 Jul 2026 11:49:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1783079359; cv=none; b=c43kYlgkEq+EFvgERzWcQyt35JW69kUXso0BhPwJOWZMSNkFaGPC4m/YTZlxXCPoR0cyCwTNAr5gFErTwW8cEjTJvyhZfmrbIes2f/8Efrc5kor1TV2cMqzQe159qlu3PRcjYcPFLt06K3t9rbk6HRcLv0+eBXg7qLng6Ja9TnU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1783079359; c=relaxed/simple;
	bh=eEyMd6BYx7e4BJAcv7d4hV5+3UfKbW9vpjD5+vr9OXs=;
	h=From:Subject:To:Cc:In-Reply-To:References:Content-Type:Date:
	 Message-Id; b=RRfNiwGbwibB87+8WGvrxNcTv4vhV5vPpMnJNknlLz0crm6CMpykW1QGyJb/XtTHA4f9JEQ9EquZT8ZhtnyUePL7uMRMNFF+QYcykpWP9OkpBVXcjWYfN2s1J8z1FuSMJe2Q/4GeOAqHLMHkpAMxkLyZDSwVaUXv+GPMmM4eBMM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=Cx4N0yIB; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="Cx4N0yIB"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1CC661F000E9;
	Fri,  3 Jul 2026 11:49:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1783079358;
	bh=N6kTjP5I6J30DRyl/Xz/dZKcBLnlJ/jtJFnhj62GgcY=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=Cx4N0yIBGa2xlQfokRalM6k+8SFWDrbPkdk2Buc/VtnHI/0AEOc0Y8fwAoqqPOWkz
	 oJLk8HmJPwTOsRNJpsI7rSUqmAySDSPVvNmC5QifiqrRpoGc86FtXG0SpQU/ndlAC4
	 aNgibZsO+NQbsEaJF999T+RmG+frzXb1hVlXX6st01c0o26OORoNwy0d5Yk0P1DR4M
	 NtTvvPf1tW5D80iMn3wx4RUVcjB0QqvSVkkUcy2ASfjvzDk44roPtEBYz49tR2Gl4k
	 NmSmei32CMVVcal5zWHZUe+r7aj3ing8FctVkVo9ONoJe2qKJ9YA+BA+3Eyqhwgyoz
	 HamOSS07OEk7g==
From: sashiko-bot@kernel.org
Subject: Re: [PATCH v3 08/17] scsi-multipath: provide callbacks for path
 state
Reply-To: sashiko-reviews@lists.linux.dev
To: "John Garry" <john.g.garry@oracle.com>
Cc: linux-scsi@vger.kernel.org
In-Reply-To: <20260703103402.3725011-9-john.g.garry@oracle.com>
References: <20260703103402.3725011-1-john.g.garry@oracle.com>
 <20260703103402.3725011-9-john.g.garry@oracle.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Fri, 03 Jul 2026 11:49:17 +0000
Message-Id: <20260703114918.1CC661F000E9@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>

Thank you for your contribution! Sashiko AI review found 2 potential issue(=
s) to consider:
- [High] `scsi_mpath_is_disabled` and `scsi_mpath_is_optimized` fail to mas=
k out the `SCSI_ACCESS_STATE_PREFERRED` flag from `sdev->access_state`.
- [High] `scsi_mpath_available_path()` incorrectly treats `SDEV_CREATED_BLO=
CK` as an available path.
--

commit 71967b8cc1b7e6dc50c814782c317913564b9ee9
Author: John Garry <john.g.garry@oracle.com>

scsi-multipath: provide callbacks for path state

This patch provides callbacks for path states in SCSI multipath, including
scsi_mpath_is_disabled, scsi_mpath_is_optimized, and
scsi_mpath_available_path. These rely on the SCSI device's sdev_state and
access_state to determine path availability.

> diff --git a/drivers/scsi/scsi_multipath.c b/drivers/scsi/scsi_multipath.c
> index f22e3677cf2ad..d8ea9ffe8942c 100644
> --- a/drivers/scsi/scsi_multipath.c
> +++ b/drivers/scsi/scsi_multipath.c
> @@ -301,7 +301,53 @@ static struct bio *scsi_mpath_clone_bio(struct bio *=
bio)

[ ... ]

> +static bool scsi_mpath_is_disabled(struct mpath_device *mpath_device)
> +{
> +	struct scsi_mpath_device *scsi_mpath_dev =3D
> +				to_scsi_mpath_device(mpath_device);
> +	struct scsi_device *sdev =3D scsi_mpath_dev->sdev;
> +	unsigned char access_state =3D READ_ONCE(sdev->access_state);
> +
> +	if (sdev->sdev_state !=3D SDEV_RUNNING)
> +		return true;
> +
> +	if (access_state =3D=3D SCSI_ACCESS_STATE_OPTIMAL ||
> +	    access_state =3D=3D SCSI_ACCESS_STATE_ACTIVE)

[Severity: High]
Does this comparison correctly handle ALUA preferred paths?

If a device handler sets sdev->access_state to include the preferred bit
(SCSI_ACCESS_STATE_OPTIMAL | SCSI_ACCESS_STATE_PREFERRED), this raw byte
comparison will fail. This would cause the multipath layer to incorrectly
classify valid, optimal preferred paths as disabled, potentially discarding
them from I/O consideration.

Should this mask the access_state with SCSI_ACCESS_STATE_MASK before
comparing?

> +		return false;
> +
> +	return true;
> +}
> +
> +static bool scsi_mpath_is_optimized(struct mpath_device *mpath_device)
> +{
> +	struct scsi_mpath_device *scsi_mpath_dev =3D
> +				to_scsi_mpath_device(mpath_device);
> +	struct scsi_device *sdev =3D scsi_mpath_dev->sdev;
> +
> +	if (sdev->sdev_state !=3D SDEV_RUNNING)
> +		return false;
> +
> +	return READ_ONCE(sdev->access_state) =3D=3D SCSI_ACCESS_STATE_OPTIMAL;

[Severity: High]
Similar to the check in scsi_mpath_is_disabled(), will this strict equality
check misclassify optimal paths that also have the
SCSI_ACCESS_STATE_PREFERRED flag set?

> +}
> +
> +static bool scsi_mpath_available_path(struct mpath_device *mpath_device)
> +{
> +	struct scsi_mpath_device *scsi_mpath_dev =3D
> +				to_scsi_mpath_device(mpath_device);
> +	struct scsi_device *sdev =3D scsi_mpath_dev->sdev;
> +	enum scsi_device_state sdev_state =3D sdev->sdev_state;
> +
> +	if (sdev_state =3D=3D SDEV_RUNNING || sdev_state =3D=3D SDEV_QUIESCE ||
> +	    sdev_state =3D=3D SDEV_BLOCK || sdev_state =3D=3D SDEV_CREATED_BLOC=
K)

[Severity: High]
Is it intended to route user I/O to a device in the SDEV_CREATED_BLOCK stat=
e?

Devices in SDEV_CREATED and SDEV_CREATED_BLOCK are newly created, not fully
initialized, and generally only accept internal commands. If a newly created
device is temporarily blocked, this function returns true and routes user I=
/O
to it, which could lead to I/O rejection or indefinite blocking.

Furthermore, when the device unblocks and returns to SDEV_CREATED, this
function would suddenly return false. Should SDEV_CREATED_BLOCK be excluded
from the available paths list?

> +		return true;
> +
> +	return false;
> +}

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20260703103402.3725=
011-1-john.g.garry@oracle.com?part=3D8
