Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8C93043B3D1
	for <linux-scsi@vger.kernel.org>; Thu, 23 Jul 2026 10:36:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784802995; cv=none; b=RomkkF7fEa+3mrFQApB0koutkzVWmj1kEUO7h6B8tOnI2iAGN4nJAKtriartLgZD4gA46xqBX8uu/jCexQQkoPcNZwTkWn4ZXscbUW/oJW0I6yCKUKngVABcccbNAP11EV1vcIvXr1bAOO0JiAImKbf+gtC//KXLkMDoRGm4IvI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784802995; c=relaxed/simple;
	bh=PK8ukwAKNkZUAaSHDTlPxUQiiT/gJP9TG7+fq3yVjYM=;
	h=From:Subject:To:Cc:In-Reply-To:References:Content-Type:Date:
	 Message-Id; b=Do9XMhXuZ9rFo88hz8uGRYX2BY7FLqzR8KjdT20b6dF/5yvTqQ7UNveb3rNs15RVrPK7aH1yMCIVK+GTHxK//+2Gj+6KvFkNZ/9di7PKl64Jkwfl07T5yCcVF9SSBRqAnuSsVGPiQS1xwOnNA8WkwUkUvXh7kH2tWk2mLArJXCk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=Vbl1IM3n; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="Vbl1IM3n"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 73BBF1F000E9;
	Thu, 23 Jul 2026 10:36:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1784802986;
	bh=mD7Lhpfyr4MwKXJNaUTwyZc1Vwa9iPxQqHRO78RUoqg=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=Vbl1IM3nj15D28pZyAYzd3zVnxmVpYLuiyfK8o8hd0CGjn7TUIHlGW4RZD9I2jvtm
	 G+hTG2Kfi2vNC8gykDbVLo/5M0hnNAiJpcM9EK6mVsiUCLlpAB18hl+7+8SbOFMwpa
	 Oqei7yr/3C0Bqnom/zY9pyWnVCA0GvMmc4Sp3q85EQ7+RwIbyvS+3a5BNokyIIgofI
	 MACGkKUQ833ILWyNrhW7Cr7t+e60iYWXKJSqIVsMbA8mEIUr0IloCIw4YwL4vri9bl
	 pIKdNla5ZmLq05y3qcJUYn8f04Pi9p0eTJyg1rbcwpT6Zd8WJ3liI5x1I9UNVhtJx+
	 eUimcQuJzoenA==
From: sashiko-bot@kernel.org
Subject: Re: [PATCH v4 20/28] scsi-multipath: provide callbacks for path
 state
Reply-To: sashiko-reviews@lists.linux.dev
To: "John Garry" <john.g.garry@oracle.com>
Cc: linux-scsi@vger.kernel.org
In-Reply-To: <20260723093627.2327456-21-john.g.garry@oracle.com>
References: <20260723093627.2327456-1-john.g.garry@oracle.com>
 <20260723093627.2327456-21-john.g.garry@oracle.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Thu, 23 Jul 2026 10:36:25 +0000
Message-Id: <20260723103626.73BBF1F000E9@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>

Thank you for your contribution! Sashiko AI review found 3 potential issue(=
s) to consider:
- [High] ALUA access state is not synchronized with the core multipath libr=
ary, causing path selection to incorrectly treat non-optimized paths as opt=
imal and resulting in an infinite path re-evaluation loop.
- [High] Missing ALUA path activation and state change notifications cause =
indefinite I/O hangs when only STANDBY, TRANSITIONING, or LBA-dependent pat=
hs are available.
- [Medium] Missing READ_ONCE() on concurrent sdev->sdev_state access can ca=
use TOCTOU vulnerabilities via compiler reloads.
--

--- Patch [20]: [PATCH v4 20/28] scsi-multipath: provide callbacks for path=
 state ---
commit 0d49283b5a1edcf6983ec33d9d54dad0023fe90c
Author: John Garry <john.g.garry@oracle.com>

scsi-multipath: provide callbacks for path state

This commit provides callbacks for .is_disabled, .is_optimized, and
.available_path. These all use scsi_device.sdev_state and
scsi_device.access_state, which will be driven by ALUA.

> diff --git a/drivers/scsi/scsi_multipath.c b/drivers/scsi/scsi_multipath.c
> index a482b6ede21aa..e566d47199fcc 100644
> --- a/drivers/scsi/scsi_multipath.c
> +++ b/drivers/scsi/scsi_multipath.c
> @@ -316,7 +316,56 @@ static struct bio *scsi_mpath_clone_bio(struct bio *=
bio)
>  	return clone;
>  }
> =20
> +static bool scsi_mpath_is_disabled(struct mpath_device *mpath_device)
> +{
> +	struct scsi_mpath_device *scsi_mpath_dev =3D
> +				to_scsi_mpath_device(mpath_device);
> +	struct scsi_device *sdev =3D scsi_mpath_dev->sdev;
> +	unsigned char access_state =3D READ_ONCE(sdev->access_state) &
> +					SCSI_ACCESS_STATE_MASK;
> +
> +	if (sdev->sdev_state !=3D SDEV_RUNNING)
> +		return true;

[Severity: Medium]
Should sdev->sdev_state be read with READ_ONCE() here to avoid compiler
reloads, similar to how access_state is read above?

> +
> +	if (access_state =3D=3D SCSI_ACCESS_STATE_OPTIMAL ||
> +	    access_state =3D=3D SCSI_ACCESS_STATE_ACTIVE)
> +		return false;
> +
> +	return true;

[Severity: High]
If a path is in ALUA STANDBY or TRANSITIONING state, it is treated as disab=
led
and skipped during path selection.

When all paths are in these states, scsi_mpath_available_path() will return
true since the state is SDEV_RUNNING, causing the block layer to requeue the
I/O.

Does this logic ever call scsi_dh_activate() or trigger an implicit ALUA
activation to transition these standby paths to optimal? Could this result =
in
an indefinite I/O hang with the requeue list looping forever?

> +}
> +
> +static bool scsi_mpath_is_optimized(struct mpath_device *mpath_device)
> +{
> +	struct scsi_mpath_device *scsi_mpath_dev =3D
> +				to_scsi_mpath_device(mpath_device);
> +	struct scsi_device *sdev =3D scsi_mpath_dev->sdev;
> +	unsigned char access_state =3D READ_ONCE(sdev->access_state) &
> +					SCSI_ACCESS_STATE_MASK;
> +
> +	if (sdev->sdev_state !=3D SDEV_RUNNING)
> +		return false;

[Severity: Medium]
Should this unlocked read of sdev->sdev_state also use READ_ONCE()?

> +
> +	return access_state =3D=3D SCSI_ACCESS_STATE_OPTIMAL;

[Severity: High]
Does this dynamic check of the ALUA state conflict with the statically
initialized access state in the core multipath library?

If an I/O is submitted to an ALUA Active/Non-Optimized path, won't the core
reject the cached path, fall back to __mpath_find_path() which uses the
static state, and continuously re-cache the exact same path? Could this
result in a perpetual cache miss and an infinite path re-evaluation loop on
every submission?

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
> +		return true;

[Severity: Medium]
Since sdev_state is a local variable assigned via a plain read, can the
compiler reload it from memory for each condition in the if statement?

If the state changes concurrently between SDEV_BLOCK and SDEV_RUNNING, could
all checks evaluate to false even if the state is always one of the valid
values? Should this use READ_ONCE()?

> +
> +	return false;
> +}

[ ... ]

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20260723093627.2327=
456-1-john.g.garry@oracle.com?part=3D20
