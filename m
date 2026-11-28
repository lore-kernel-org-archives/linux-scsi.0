Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795859191;
	b=Fgu1SovFPC39NpCm1H0GHI3LsC8JTKhtL0gSeJRExhX8Y+0EXF/Cp8HZvz4uicO0PXh8
	 Ntr+Pz6Bd+c1mTFsbEQ2bXUXUrayMpcpezywdojazI56b0CLZIMeI51Vz1lQMMg2HlnE5
	 bbmBZfp19fcbtIfL79G6YAKDi83XYENGdKR5uGYm30PHU8BI/X3b414TcI7/NLunX3Rn0
	 atVWMtO6tLaAiBUDOGr1mrlqOFI+0zgs1W2Ioet49iKznREd2W1YBP2Eg/71hQjv9mHBM
	 nL+22K0nwzfsLQVbkzuhB0ehkerQVEdtRZIjfdIZX5I4Uk+FnTbQuZ8YJAEJcJzyCJA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795859191;
	h=Received:DKIM-Signature:Message-ID:From:Subject:Reply-To:To:Cc:
	 In-Reply-To:References:Content-Type:Content-Transfer-Encoding:Date;
	bh=oc5t0qtg5Kn7eUYPQvKXaPL8N4cgapsVCQ0IPBClZoY=;
	b=H+T29ru0GzR88RKPHtEnIGzmQepeYPqkqXMtCYxff/ARKgZ3T3T0Br4coA9sRELHU+59
	 fB7WQbJPl6zg+kdSLZLoZYtUJr3ymdsMcDCk64o+riV57HBdBt7kNrUloLBa/C0CdFfIm
	 eQxVLasXfbPDAemJeq45gCxpldk0gwKD222K7dXJ5gbLzmUSAfYm6iS1r+NI7mFYgJzLI
	 1SReOMMUDH4iGP99tWdzT0T0SMLmNAhYJQ8sxk1xqTm7WBeAnQh07KujO9OUgvMTms450
	 u09yatmU0i2+zyXlKSvFj6bMx+XlJFn5iVKKO7Wg16YVxALD/VW3HwiZL+gGYQ7Yvng==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b="Jvtk//DI";
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6C2E1606A332
	for <linux-scsi@vger.kernel.org>; Sat, 28 Nov 2026 09:46:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=Jvtk//DI
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 87B341F0089C;
	Sat, 28 Nov 2026 09:46:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1795859190;
	bh=oc5t0qtg5Kn7eUYPQvKXaPL8N4cgapsVCQ0IPBClZoY=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=Jvtk//DITP9dY5YJozDmUBKOUySJsXduvKLj1pUySRXXd07yznTlO9ZqVDvy05EHt
	 OtcEy4oOTBHPj7eRz3QceAKIU+vaFPxrOrttgJH+Ney/wX1qKpAAq77OQTY+4yQEhB
	 SdJ4VClOSUGozUcdyydbt7uaMCxVL9QU/+o4yWFAPVr0egCylBFP6d0Xx7NrhQozEg
	 W3olaBqVxbASQM/cld/7A0x+/VbUg5oe3A+W7oQK+uaEB+U3SVRgqUiUOBIsmklObA
	 dCP6AqY4dTB8/IME+ZFWGUTG1QyCB5q9HsEDNDV6fT7kd6fKaOcbqHMb4P00m740W4
	 7ZFRCfdyCnwPg==
Message-ID: <sashiko-outbox-238601@kernel.org>
From: sashiko-bot@kernel.org
Subject: Re: [PATCH v2 4/5] scsi: sd: Fix WRITE SAME(10) count truncation
 when the mode changes
Reply-To: sashiko-reviews@lists.linux.dev
To: "Chris Down" <chris@chrisdown.name>
Cc: linux-scsi@vger.kernel.org
In-Reply-To: <a1acc1de43d8ee89d64e345da817f7ac3585e86d.1795842371.git.chris@chrisdown.name>
References: <cover.1795842371.git.chris@chrisdown.name>
 <a1acc1de43d8ee89d64e345da817f7ac3585e86d.1795842371.git.chris@chrisdown.name>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Sat, 28 Nov 2026 09:46:30 +0000
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Post: <mailto:linux-scsi@vger.kernel.org>
List-Help: <mailto:linux-scsi+help@vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-scsi+owner@vger.kernel.org>
Precedence: list

Thank you for your contribution! Sashiko AI review found 1 potential
issue to consider:
- [Medium] scsi: sd: unlocked set_capacity_and_notify() in
  sd_revalidate_disk()
--

commit c8bf97f59b4ffaebd830de4ab08208e4fd13924d
Author: Chris Down <chris@chrisdown.name>

scsi: sd: Fix WRITE SAME(10) count truncation when the mode changes

This commit updates provisioning_mode and zeroing_mode only while the
request queue is frozen, and defers increasing the gendisk capacity in
sd_revalidate_disk() until after the modes and queue limits are updated.

> diff --git a/drivers/scsi/sd.c b/drivers/scsi/sd.c
> index d995650bc8a10..792058f52f65e 100644
> --- a/drivers/scsi/sd.c
> +++ b/drivers/scsi/sd.c
[ ... ]
> @@ -3901,10 +3906,27 @@ static void sd_revalidate_disk(struct gendisk *di=
sk)
> =20
>  	sdkp->first_scan =3D 0;
> =20
> -	set_capacity_and_notify(disk, logical_to_sectors(sdp, sdkp->capacity));
> -	sd_config_write_same(sdkp, lim);
> +	/*
> +	 * The WRITE SAME(10) modes can't address all of a disk with more than
> +	 * 2^32 blocks, so don't show a bigger capacity until they are gone.
> +	 */
> +	sectors =3D logical_to_sectors(sdp, sdkp->capacity);
> +	grown =3D sectors > get_capacity(disk);
> +	if (!grown)
> +		set_capacity_and_notify(disk, sectors);
> =20
> -	err =3D queue_limits_commit_update_frozen(sdkp->disk->queue, lim);
> +	/*
> +	 * Queued requests are sized for the old modes, so only change the
> +	 * modes once the queue is frozen.
> +	 */
> +	memflags =3D blk_mq_freeze_queue(sdkp->disk->queue);
> +	if (sdkp->media_present)
> +		sd_config_discard(sdkp, lim, sd_discard_mode(sdkp));
> +	sd_config_write_same(sdkp, lim);
> +	err =3D queue_limits_commit_update(sdkp->disk->queue, lim);
> +	blk_mq_unfreeze_queue(sdkp->disk->queue, memflags);
> +	if (grown)
> +		set_capacity_and_notify(disk, sectors);
>  	if (err)
>  		goto out;

[Severity: Medium]
Can calling set_capacity_and_notify() in the grown path after
queue_limits_commit_update() unlocks q->limits_lock race with a
concurrent sd_revalidate_disk() or update the capacity after a failed
limits commit?

sd_revalidate_disk() can be entered concurrently from sd_rescan(),
sd_open(), and cache_type_store(), relying on q->limits_lock to serialize
updates.  When the disk grows past 2^32 blocks and then shrinks back:

CPU0                              CPU1
sd_revalidate_disk()
  queue_limits_start_update()
  sd_read_capacity() (> 2^32)
  grown =3D true
  queue_limits_commit_update()
    mutex_unlock(&q->limits_lock)
                                  sd_revalidate_disk()
                                    queue_limits_start_update()
                                    sd_read_capacity() (<=3D 2^32)
                                    grown =3D false
                                    set_capacity_and_notify()
                                    sd_config_discard() (SD_LBP_WS10)
                                    queue_limits_commit_update()
  set_capacity_and_notify()
    <-- overwrites capacity with > 2^32 while in WRITE SAME(10) mode

In addition, because err is checked after set_capacity_and_notify(), a
failed queue_limits_commit_update() still publishes the new capacity while
leaving the old queue limits in place and skipping
sd_zbc_revalidate_zones().

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/cover.1795842371.gi=
t.chris@chrisdown.name?part=3D4
