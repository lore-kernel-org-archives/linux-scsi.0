Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E49833A1696
	for <linux-scsi@vger.kernel.org>; Tue, 22 Sep 2026 23:32:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790119948; cv=none; b=De2cqj8lZBMyl9pjeRVTowNRSY2BJQeI0q72+nvcfEbYU4n3A+X32xG3QKgo9Cv2am+qGN0FKEEH6rv70qJ4M5r6t/RfOnAxFuVBQi0du/cvNQM0YB33k77qAil9Nzx5jYZ1zfDK6dph5rUv1wFz9FHTj3hv1/lUlvyXPN6doec=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790119948; c=relaxed/simple;
	bh=R25W10VCXSU4dqYJJsxs3a4dOIJG1CpqsRa8brIrirs=;
	h=From:Subject:To:Cc:In-Reply-To:References:Content-Type:Date:
	 Message-Id; b=sVD0cTmmKWXUUZM8Us1g2VuPO+2z76XC7NAjJIgrxU1FxT0xZAGp2iMJ0fIj8kx13tkDKyrkEN773qgTwb6grWYzBQ/SFJH7TtumN2cwBJVgCJRydFB4jdmRUG3dGREJfkuU1bmxfGrmSmhTbUbuK3NoOOwNW+X+MO36yiMJdoc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=NEbLh81f; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="NEbLh81f"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 26CEB1F000FF;
	Tue, 22 Sep 2026 23:32:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1790119946;
	bh=JXMa2Z/G20lJon2+t525CY44SfmqGhMmvmbj/mmgk+U=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=NEbLh81fgvSW55MqrkMb6v54IXoIragpXN0Ckhhv6dUUNLX90EChh4MsfKayNyGFm
	 bL/Re8RDyU+/HpDlhuD0UagdZwqXvBFSC2VcT3qGrwUgdssoGlvlwj576SnNVf6zX0
	 DQZer2yTzDDUFSZ/OktKRoyF3q4af+tMDxNUcB+Y0nIdDcs33twkPygJezYKiP6JnT
	 4+Lj9QENfFnkT2A+1SKOW9TwPeRJD7HJdSfVzs4s8IzfmlI2ZUEBO4UGuQS+3TcKfT
	 gCD9ZOMwAS9IA6HV3GS36YB3r+UUezF6SAMJT42lHeeR+L4WMdAga+85hf49lvcQae
	 Jen5IbjLu7Fjw==
From: sashiko-bot@kernel.org
Subject: Re: [PATCH 1/7] scsi: scsi_debug: Fix a locking bug in
 resp_write_same()
Reply-To: sashiko-reviews@lists.linux.dev
To: "Bart Van Assche" <bvanassche@acm.org>
Cc: linux-scsi@vger.kernel.org
In-Reply-To: <295c14b6d2d011597284f09f7a3de42a49e08863.1790119506.git.bvanassche@acm.org>
References: <cover.1790119506.git.bvanassche@acm.org>
 <295c14b6d2d011597284f09f7a3de42a49e08863.1790119506.git.bvanassche@acm.org>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Tue, 22 Sep 2026 23:32:25 +0000
Message-Id: <20260922233226.26CEB1F000FF@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>

Thank you for your contribution! Sashiko AI review found 1 potential issue(=
s) to consider:
- [Medium] scsi: scsi_debug: error masked in resp_write_same()
--

commit 9e547db0a77591a35683cc5b28aeb6cb6d633c73
Author: Bart Van Assche <bvanassche@acm.org>

scsi: scsi_debug: Fix a locking bug in resp_write_same()

This commit fixes a missing lock release in resp_write_same() when
fetch_to_dev_buffer() fails. It redirects the error path to a new
unlock label to ensure sdeb_data_write_unlock() is called.

> diff --git a/drivers/scsi/scsi_debug.c b/drivers/scsi/scsi_debug.c
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

[ ... ]

> @@ -5419,6 +5419,7 @@ static int resp_write_same(struct scsi_cmnd *scp, u=
64 lba, u32 num,
>  	/* If ZBC zone then bump its write pointer */
>  	if (sdebug_dev_is_zoned(devip))
>  		zbc_inc_wp(devip, lba, num);
> +unlock:
>  	sdeb_data_write_unlock(sip);
>  	ret =3D 0;

[Severity: Medium]
Does this unconditionally overwrite the error code?

By jumping to the new unlock label when fetch_to_dev_buffer() fails, ret
is initially set to DID_ERROR << 16, but then it appears ret =3D 0 is
executed unconditionally right below the unlock label.

Could this silently mask I/O failures by returning 0 on the error path?

>  out:
>  	if (meta_data_locked)
>  		sdeb_meta_write_unlock(sip);
>  	return ret;
>  }

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/cover.1790119506.gi=
t.bvanassche@acm.org?part=3D1
