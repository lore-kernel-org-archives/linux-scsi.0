Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7141253FD4E
	for <linux-scsi@vger.kernel.org>; Tue, 29 Sep 2026 17:33:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790703216; cv=none; b=muBL3rfmkOcrM2cHlLpu7tDU8Dbl7HU1cq5eYVpnfQJp/fecX/ia9bpf2opoqjrsPGP4AO6dHh6lQnvFcAVuF2yQXkJBCXP4hidwXTA9q5ljhjUBtWYzayQf6Gyzz3JyqnSEbSVYA9KmTJbhiVWw4HZXj5O85cBbdi8pwdoEp2U=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790703216; c=relaxed/simple;
	bh=ymWSU/u6h/3P0pOh4FfzpkH9dwtswMMc7dAYpPmaYGQ=;
	h=From:Subject:To:Cc:In-Reply-To:References:Content-Type:Date:
	 Message-Id; b=nPU9rnNUxx3ngYuDGcwMzy2CdIRb5ztJWTCBz6bubYuScV5f1kkiKuIQk8t0PV1eWF0lHbbqajiBzawL9ewV+V76vZ1++jNukg0ciY6rZ3L/sC2NGWpJteLwi08uiwQLkIfdJkFE6QN5Eb+MZAdSuAwgRkeuIzhVMZj4c8+20vI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=UvmH7kQG; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="UvmH7kQG"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0562F1F000FF;
	Tue, 29 Sep 2026 17:33:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1790703215;
	bh=186dVEq935Po/7EN7KLg1Ha9Mn3d6U2caB7ywNbDM/M=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=UvmH7kQGe/l0H2GF5T3FhyDnsxysJdCWWy4Y1qOYxnL40dbEnv5bJS59Y5KZQPhEV
	 cD/XszE6lcw7furOjpyhq3oeOdAMxGfkSxAB1GK0l9IML4Z5NxLPuVJat2ziWc8SHA
	 Ka0NRMmpKs8lYbqParJgY8I60XLNqZBm6rAY48LtwpukHXVVN3uKQbkAVrjB8pBZBq
	 g1PE16n8UhZhqm1R5fWvhO5+2mehqU2w1kyVcdsl/l2a8P4o3fMJcEIjN2Hz3PQ2OZ
	 g2wp62XYQ9GIo+hs9rMiMaRqn9h6TAfg6DBDbB5eokC+X3AQQ+sJOITJ8fp6sPWegF
	 T05Du3D+6F+0A==
From: sashiko-bot@kernel.org
Subject: Re: [PATCH v3 1/4] scsi: st: Restore changed drive settings after
 reset also for MTLOAD and MTRETEN
Reply-To: sashiko-reviews@lists.linux.dev
To: "Laurence Oberman" <loberman@redhat.com>
Cc: linux-scsi@vger.kernel.org
In-Reply-To: <20260929171813.844733-2-loberman@redhat.com>
References: <20260929171813.844733-1-loberman@redhat.com>
 <20260929171813.844733-2-loberman@redhat.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Tue, 29 Sep 2026 17:33:34 +0000
Message-Id: <20260929173335.0562F1F000FF@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>

Thank you for your contribution! Sashiko AI review found 1 potential issue(=
s) to consider:
- [High] scsi: st: MTLOAD in immediate mode attempts premature settings res=
tore
--

commit 17d984b3de3a58216a78afa696892ddd4aea0bbd
Author: Laurence Oberman <loberman@redhat.com>

scsi: st: Restore changed drive settings after reset also for MTLOAD and MT=
RETEN

A device reset returns the drive's density and block size to their defaults.
This patch attempts to re-apply values changed by the user when recovering
with MTLOAD or MTRETEN.

> diff --git a/drivers/scsi/st.c b/drivers/scsi/st.c
> index f1c3c49466379..0a4263bef9cbb 100644
> --- a/drivers/scsi/st.c
> +++ b/drivers/scsi/st.c
[ ... ]
> @@ -3819,6 +3848,9 @@ static long st_ioctl(struct file *file, unsigned in=
t cmd_in, unsigned long arg)
> =20
>  		if (mtc.mt_op =3D=3D MTLOAD) {
>  			retval =3D do_load_unload(STp, file, max(1, mtc.mt_count));
> +			if (!retval)
> +				st_restore_changed_settings(STp, restore_density,
> +							    restore_blksize);

[Severity: High]
Does this code attempt a premature settings restore if MTLOAD is called
in immediate mode?

If a user application issues MTLOAD with O_NONBLOCK and STp->immediate
set to recover after a drive reset, do_load_unload() will issue the load
command and return immediately. This unconditional call to
st_restore_changed_settings() would then cause MODE SELECT commands to
fail because the drive is still asynchronously loading.

Later, when the drive is accessed, check_tape() detects the new session
and clears the changed flags, causing the drive to silently revert to
its default density and block size. Subsequent writes might then produce
incorrectly formatted tapes without errors.

For MTRETEN, this patch correctly checks for !STp->immediate before restori=
ng
the settings:

>  			goto out;
>  		}
[ ... ]
> @@ -3837,6 +3869,19 @@ static long st_ioctl(struct file *file, unsigned i=
nt cmd_in, unsigned long arg)
>  			retval =3D st_compression(STp, (mtc.mt_count & 1));
>  		else
>  			retval =3D st_int_ioctl(STp, mtc.mt_op, mtc.mt_count);
> +		if (!retval && mtc.mt_op =3D=3D MTRETEN && !STp->immediate &&
> +		    (restore_density >=3D 0 || restore_blksize >=3D 0)) {

Should MTLOAD also verify !STp->immediate before calling
st_restore_changed_settings() in st_ioctl()? Note that follow-up patches
in this series do not correct this omission.

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20260929171813.8447=
33-1-loberman@redhat.com?part=3D1
