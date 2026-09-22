Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 842313F412B
	for <linux-scsi@vger.kernel.org>; Tue, 22 Sep 2026 23:41:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790120475; cv=none; b=RIzzOFSr+72W2iaDxGM/vFz13nISZ1ZqTXTCwHwDP8ysPCGWFKeFC4WkI5dS+PG94/BJaoi7cFHiRcUrW6TzEJSdqXaj/s4WYj7ayrQYq64rq0OsDZLOBm+YiU+W3fvVNS48A4+iYc+SS1GoDJEpBquUsI0laUSKhHS55OPicTg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790120475; c=relaxed/simple;
	bh=ovIVGfSUZDOt4jeuU/QojF6PR4g50B0KENYtX8MpXNY=;
	h=From:Subject:To:Cc:In-Reply-To:References:Content-Type:Date:
	 Message-Id; b=Ga685N7EwazmZgi44XgyOM6HwreScZ2PTPS8FVvfscLXIOXfMiL/dMZvYLSmy9FkfROPDr8zNoBBPS2EaZIq/UCexY8IptncbJFJ6c7PFkkdq04644cT11Dm6YAAlqSPnFxwnWFqBc65A9vU9LCcCKoLa6VvJWzj9MVD0rI2nqM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=mRvk+PJY; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="mRvk+PJY"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2C3951F000FF;
	Tue, 22 Sep 2026 23:41:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1790120473;
	bh=SssA1E97eB1B+xE2LPFQi51xiIB1dfSS56uv5CEYETs=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=mRvk+PJYY4vD/0FxQRw4w2lE2wTAfQfJB5gYDz1AkyX0IuzQt4nm1CPyn3iWhd6l0
	 X65Db4CgPFit2dpZpCUcbqUdyL6S1NXg7szmqF3QS9/6T0a2C868/feKbseERzbF4D
	 f19AzujKcRe/6OVYNGk6NjdgSCoeFA9T0NYXDX8ssBxi1U/su/Ae+VojqlmK9bnv8C
	 TsfM7hwgPsBWV0YyVbZsA+9scLkypaA6Wv0eVwfVOHvz/gGUEoMJUPmOIYoqKVpi4g
	 qOlVt8f1pAj445MVcA2LfazaVrimaWPtSbHmGP2BXDVnZ2Ysj81aXmIXZv5sHgTHXw
	 t7LcuxJv0q8Hg==
From: sashiko-bot@kernel.org
Subject: Re: [PATCH 5/7] scsi: scsi_debug: Split resp_write_dt0()
Reply-To: sashiko-reviews@lists.linux.dev
To: "Bart Van Assche" <bvanassche@acm.org>
Cc: linux-scsi@vger.kernel.org
In-Reply-To: <206aacd14ccbe8c5923d844cdc9f26ecbc229b04.1790119506.git.bvanassche@acm.org>
References: <cover.1790119506.git.bvanassche@acm.org>
 <206aacd14ccbe8c5923d844cdc9f26ecbc229b04.1790119506.git.bvanassche@acm.org>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Tue, 22 Sep 2026 23:41:12 +0000
Message-Id: <20260922234113.2C3951F000FF@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>

Thank you for your contribution! Sashiko AI review found 3 potential issue(=
s) to consider:
- [High] scsi: scsi_debug: resp_write_dt0() incorrectly returns byte count =
instead of SCSI status
- [High] scsi: scsi_debug: resp_read_dt0() incorrectly returns byte count i=
nstead of SCSI status
- [Medium] scsi: scsi_debug: __resp_write_same() overwrites error return va=
lue with 0
--

commit 57d85f04864ae775754845a9070f7d8499a51930
Author: Bart Van Assche <bvanassche@acm.org>

scsi: scsi_debug: Split resp_write_dt0()
   =20
Prepare for enabling lock context analysis by eliminating conditional locki=
ng.

> diff --git a/drivers/scsi/scsi_debug.c b/drivers/scsi/scsi_debug.c
> index ac3b9bfa7e634..ed30b3950c4e2 100644
> --- a/drivers/scsi/scsi_debug.c
> +++ b/drivers/scsi/scsi_debug.c
> @@ -5032,6 +5032,55 @@ static int corrupt_lbas(struct sdebug_dev_info *de=
vip, u64 lba, u32 num,
>  	return error;
>  }
> =20
> +static int __resp_write_dt0(struct scsi_cmnd *scp, struct sdebug_dev_inf=
o *devip,
> +			    struct sdeb_store_info *sip, u64 lba, u32 num,
> +			    u32 ei_lba, u8 group)
> +{
> +	int ret;
> +
> +	ret =3D check_device_access_params(scp, lba, num, true);
> +	if (ret)
> +		return ret;
[ ... ]
> +	ret =3D do_device_access(sip, scp, 0, lba, num, group, true, false);
> +	if (unlikely(scsi_debug_lbp()))
> +		map_region(sip, lba, num);
> +
> +	/* If ZBC zone then bump its write pointer */
> +	if (sdebug_dev_is_zoned(devip))
> +		zbc_inc_wp(devip, lba, num);
> +
> +	return ret;
> +}
[ ... ]
> @@ -5110,59 +5158,18 @@ static int resp_write_dt0(struct scsi_cmnd *scp, =
struct sdebug_dev_info *devip)
> =20
>  	if (sdebug_dev_is_zoned(devip) ||
>  	    (sdebug_dix && scsi_prot_sg_count(scp)) ||
> -	    scsi_debug_lbp())  {
> +	    scsi_debug_lbp()) {
>  		sdeb_meta_write_lock(sip);
> -		meta_data_locked =3D true;
> +		ret =3D __resp_write_dt0(scp, devip, sip, lba, num, ei_lba,
> +				       group);
> +		sdeb_meta_write_unlock(sip);
> +	} else {
> +		ret =3D __resp_write_dt0(scp, devip, sip, lba, num, ei_lba,
> +				       group);
>  	}
> =20
> -	ret =3D check_device_access_params(scp, lba, num, true);
> -	if (ret) {
> -		if (meta_data_locked)
> -			sdeb_meta_write_unlock(sip);
> +	if (ret > 0)
>  		return ret;

[Severity: High]
Can this cause normal completion and error injection to be skipped?

In __resp_write_dt0(), do_device_access() returns a positive byte count on
success, which __resp_write_dt0() then returns.

By adding 'if (ret > 0) return ret;', resp_write_dt0() will return this byte
count rather than a valid SCSI status tuple, which skips the remaining
successful path logic.

commit 17ea9421189072b59343f9ec94fa5ff956adb17f
Author: Bart Van Assche <bvanassche@acm.org>

scsi: scsi_debug: Split resp_read_dt0()
   =20
Split this function to remove conditional locking. This patch prepares
for enabling context analysis.

> diff --git a/drivers/scsi/scsi_debug.c b/drivers/scsi/scsi_debug.c
> index fcfb49df9ee17..ac3b9bfa7e634 100644
> --- a/drivers/scsi/scsi_debug.c
> +++ b/drivers/scsi/scsi_debug.c
> @@ -4577,6 +4577,42 @@ static int resp_read_tape(struct scsi_cmnd *scp, s=
truct sdebug_dev_info *devip)
>  	return 0;
>  }
> =20
> +static int __resp_read_dt0(struct scsi_cmnd *scp, struct sdeb_store_info=
 *sip,
> +			   u64 lba, u32 num, u32 ei_lba)
> +{
[ ... ]
> +	return do_device_access(sip, scp, 0, lba, num, 0, false, false);
> +}
[ ... ]
> @@ -4668,46 +4703,17 @@ static int resp_read_dt0(struct scsi_cmnd *scp, s=
truct sdebug_dev_info *devip)
>  	}
> =20
>  	if (sdebug_dev_is_zoned(devip) ||
> -	    (sdebug_dix && scsi_prot_sg_count(scp)))  {
> +	    (sdebug_dix && scsi_prot_sg_count(scp))) {
>  		sdeb_meta_read_lock(sip);
> -		meta_data_locked =3D true;
> +		ret =3D __resp_read_dt0(scp, sip, lba, num, ei_lba);
> +		sdeb_meta_read_unlock(sip);
> +	} else {
> +		ret =3D __resp_read_dt0(scp, sip, lba, num, ei_lba);
>  	}
> =20
> +	if (ret > 0)
> +		return ret;

[Severity: High]
Is it possible that this intercepts the positive byte count and returns it
prematurely, similar to resp_write_dt0()?

The helper __resp_read_dt0() propagates the positive byte count out of
do_device_access() on success.

The caller's 'if (ret > 0) return ret;' condition intercepts this count and
returns it directly, which skips scsi_set_resid() and error injection.

commit 9e547db0a77591a35683cc5b28aeb6cb6d633c73
Author: Bart Van Assche <bvanassche@acm.org>

scsi: scsi_debug: Fix a locking bug in resp_write_same()
   =20
If fetch_to_dev_buffer() fails in resp_write_same(), the function jumps
to 'out' without releasing the data write lock acquired earlier via
sdeb_data_write_lock(). Jump to 'unlock' instead so that
sdeb_data_write_unlock() is called on the error path.

> diff --git a/drivers/scsi/scsi_debug.c b/drivers/scsi/scsi_debug.c
> index 6941809dfdb75..b854102e6caa1 100644
> --- a/drivers/scsi/scsi_debug.c
> +++ b/drivers/scsi/scsi_debug.c
> @@ -5402,7 +5402,7 @@ static int resp_write_same(struct scsi_cmnd *scp, u=
64 lba, u32 num,
> =20
>  	if (-1 =3D=3D ret) {
>  		ret =3D DID_ERROR << 16;
> -		goto out;
> +		goto unlock;
>  	} else if (sdebug_verbose && !ndob && (ret < lb_size))
>  		sdev_printk(KERN_INFO, scp->device,
>  			    "%s: %s: lb size=3D%u, IO sent=3D%d bytes\n",
> @@ -5419,6 +5419,7 @@ static int resp_write_same(struct scsi_cmnd *scp, u=
64 lba, u32 num,
>  	/* If ZBC zone then bump its write pointer */
>  	if (sdebug_dev_is_zoned(devip))
>  		zbc_inc_wp(devip, lba, num);
> +unlock:
>  	sdeb_data_write_unlock(sip);
>  	ret =3D 0;
>  out:

[Severity: Medium]
Will this change unintentionally overwrite the error return value with 0?

When fetch_to_dev_buffer() fails and returns -1, the error handling block s=
ets
ret =3D DID_ERROR << 16 and jumps to unlock.

However, at the unlock label, ret is overwritten with 0 before returning,
masking the error.

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/cover.1790119506.gi=
t.bvanassche@acm.org?part=3D5
