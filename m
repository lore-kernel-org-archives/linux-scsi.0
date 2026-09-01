Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9C1D047CC69
	for <linux-scsi@vger.kernel.org>; Tue,  1 Sep 2026 11:02:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788260532; cv=none; b=DsbPucgvqWaFa3feYuu9LIxihMJ2nP37B0Wi4hMKdEZeOx6Rt3SkjXSH5HRP5C+hpIA2ItHiz6rEGEC3yf1qZt+D+0gBgCxIJCUSX27vwt7TUSJ/G+OmHusKhpKq3Ps4jrF0gXsxu7U0cpVlKUk0QFjImC6nc8fpbzY9BjdT8tQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788260532; c=relaxed/simple;
	bh=ZQR3CkIo+GkIlLLzT3uBEcvyiwNUXyApkzV2S7qPrdk=;
	h=From:Subject:To:Cc:In-Reply-To:References:Content-Type:Date:
	 Message-Id; b=l0NAOoFz+X9MkjmRbPNlhu6tZxtUJuOZZklnvnoznpIi5gkUO6dItP3I1bBbhdCjxMQcZAmWoAnzNChusKYSIwNyini7Sz5sh5O7vXbhqjdrVX5vV0rzaKuddTIxeq4TYIp4y5v5cAYzYVCpac2O0+cL+HiupHquWpFf/Q8CPlY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=Fd24Py04; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="Fd24Py04"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2409C1F000E9;
	Tue,  1 Sep 2026 11:02:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1788260530;
	bh=vys99H3bOUBtApurUVmwX/e0DEOZA2gjRAwoANFRN40=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=Fd24Py04vuh07SuhvRyMvVcU+RBMrFoZPeNBa51Nr/7HeaAMwrDCWGIMXTkrpfJng
	 jATS2AelEBIz4DplEFvHSS2RekcJWUu8EAii+0CFR3alIcpIfMZ1Ya58BkueqKjUAJ
	 IGViz0Zf/m9rGUtbHK89onrGHrzu43tJ0G8IXviFdi//Bd8iqeAkb1wuJcWPZXuL40
	 Sbcfcqj7tctdhj1xDNhThetm3nU5VBfB/4B+cWDvDKTHQ5zgChGjRVUFV0npYw5u7N
	 TRBHuo82hnrqP+Z9zKGChXSWM5ZQutyGSkNnsSspo6HUowQXP35SbZ1FTvHwK18Z02
	 0N+PYWBdTbuvQ==
From: sashiko-bot@kernel.org
Subject: Re: [PATCH v7 16/27] scsi-multipath: clear path when device is
 blocked
Reply-To: sashiko-reviews@lists.linux.dev
To: "John Garry" <john.g.garry@oracle.com>
Cc: linux-scsi@vger.kernel.org
In-Reply-To: <20260901104526.3850621-17-john.g.garry@oracle.com>
References: <20260901104526.3850621-1-john.g.garry@oracle.com>
 <20260901104526.3850621-17-john.g.garry@oracle.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Tue, 01 Sep 2026 11:02:09 +0000
Message-Id: <20260901110210.2409C1F000E9@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>

Thank you for your contribution! Sashiko AI review found 3 potential issue(=
s) to consider:
- [High] Calling synchronize_srcu() inside an iteration loop defeats bulk q=
uiesce optimizations and stalls transport error recovery.
- [High] Path clearing is missing for devices blocked natively by low-level=
 drivers.
- [High] TOCTOU race in `scsi_device_block` accessing `sdev->scsi_mpath_dev=
` without locking causes NULL pointer dereferences and Use-After-Free durin=
g device initialization or removal.
--

commit a4233dac056f9047f69ee519256fc76b917ab456
Author: John Garry <john.garry@linux.dev>

scsi-multipath: clear path when device is blocked
   =20
This commit adds scsi_mpath_dev_clear_path() and invokes it from
scsi_device_block() to clear a device path when it becomes blocked.

> diff --git a/drivers/scsi/scsi_lib.c b/drivers/scsi/scsi_lib.c
> index af27fd3df8d46..f02b3a50e20cd 100644
> --- a/drivers/scsi/scsi_lib.c
> +++ b/drivers/scsi/scsi_lib.c
[ ... ]
> @@ -3009,6 +3010,8 @@ static void scsi_device_block(struct scsi_device *s=
dev, void *data)
>  		scsi_stop_queue(sdev);
> =20
>  	mutex_unlock(&sdev->state_mutex);
> +	if ((err =3D=3D 0) && sdev->scsi_mpath_dev)
> +		scsi_mpath_dev_clear_path(sdev->scsi_mpath_dev);

[Severity: High]
Is there a TOCTOU race when accessing sdev->scsi_mpath_dev after releasing
the state_mutex?

If __scsi_remove_device() runs concurrently on another CPU, it can acquire
the state_mutex, change the state to SDEV_DEL, release the lock, and invoke
scsi_mpath_remove_device(), which sets scsi_mpath_head to NULL.

Since err was cached as 0, this execution path could proceed to safely
evaluate the if-statement, then call scsi_mpath_dev_clear_path(), resulting
in a NULL pointer dereference on scsi_mpath_head.


[Severity: High]
Are low-level driver initiated blocks missing this path clearing logic?

When low-level drivers natively block devices due to hardware errors, they
call scsi_internal_device_block_nowait(). This bypasses scsi_device_block()
entirely and directly calls scsi_stop_queue(sdev), meaning multipath
failover won't be triggered.

Should path clearing be added for native blocks as well?

> =20
>  	WARN_ONCE(err, "%s: failed to block %s in state %d\n",
>  		  __func__, dev_name(&sdev->sdev_gendev), state);
> diff --git a/drivers/scsi/scsi_multipath.c b/drivers/scsi/scsi_multipath.c
> index 68fe50f62158c..b16fe6a55fa73 100644
> --- a/drivers/scsi/scsi_multipath.c
> +++ b/drivers/scsi/scsi_multipath.c
[ ... ]
> @@ -238,6 +238,16 @@ static int scsi_multipath_sdev_init(struct scsi_devi=
ce *sdev)
>  	return 0;
>  }
> =20
> +void scsi_mpath_dev_clear_path(struct scsi_mpath_device *scsi_mpath_dev)
> +{
> +       struct mpath_device *mpath_device =3D &scsi_mpath_dev->mpath_devi=
ce;
> +       struct scsi_mpath_head *scsi_mpath_head =3D scsi_mpath_dev->scsi_=
mpath_head;
> +       struct mpath_head *mpath_head =3D &scsi_mpath_head->mpath_head;
> +
> +       if (mpath_clear_current_path(mpath_device))
> +               mpath_synchronize(mpath_head);

[Severity: High]
Does this code stall bulk quiesce operations during error recovery?

This function is called by scsi_device_block(), which is executed in a loop
for all targets and LUNs during error recovery:

scsi_block_targets()
  device_for_each_child() -> target_block()
    starget_for_each_device() -> scsi_device_block()

Since mpath_synchronize() is a wrapper for synchronize_srcu(), waiting
synchronously on an SRCU grace period here inside the loop could result in
multi-second stalls, potentially cascading into command timeouts and
unrecoverable host resets.

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20260901104526.3850=
621-1-john.g.garry@oracle.com?part=3D16
