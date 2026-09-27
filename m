Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 175EF348C7D
	for <linux-scsi@vger.kernel.org>; Sun, 27 Sep 2026 13:23:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790515434; cv=none; b=QC8VMJ0ao2m3ok6WPX90+AQf1jJNPKgmwTEcmBxG9pwI1OaTDEUKWT0foytrWBV5U5ndUiJT68UsB9zF+vr694hdNK8pGzlu1HOx9+iupwb/pqdSJw1yFjMfZLou41u/CBLUXcam/5c/eJX2rMypy95EKZrxM8E+n2gJfV8O/IY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790515434; c=relaxed/simple;
	bh=d7sZhHqz2SZ2OaMFqCt5z/mKdOrHn677YjzhDis69BU=;
	h=From:Subject:To:Cc:In-Reply-To:References:Content-Type:Date:
	 Message-Id; b=aUMTk1CNBWli0M/VsdJHftH8ZsGsJul3zAVStUTmyl+C5leRR6krBk3v7rGjxzg72G/+jUZ1XkKIL/8HrpyAEKd+XsD21y7r/T7vfuXDjKWaA86pU1mBElnF/ky/T15p6Gub7UcSBJHKCgaXdaA6J1OuCwNrtPYLibW0yiJrySM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=hDWfNiwF; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="hDWfNiwF"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7E2EE1F000FF;
	Sun, 27 Sep 2026 13:23:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1790515432;
	bh=DN5V5fFmEQmJtdf0T4pCl3C9JXTihCa6zVe/sJjcZdU=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=hDWfNiwFbviDtcMeNAlgBdSGt1sVOkx+GE5Yi5xR5Un9VI7pnNK803Vs9fI169Zzs
	 H/sGTE0y2dgPcCiC8wEdE9zYWmWXYJlQEcYRW5dak3hbw1FYoWtVrwy23WBMprRz6f
	 IawPslIbYZhf5r1MEHpOJr0xGcdoyIkUPgqx4OVuB0rRiQgT7iaRSeusZx2D4LkzHP
	 veXP9eciphTJ+o4AbL8VPDphSPg3psQP03ro6nVgqWQ8L+ej1IHLZpdTUeHd9fQA+4
	 0Ft4UPf8423mUogLVHK+nKi/e3PZteC4GiJFZKuTbEiP1aSfkoCS7Uf7Rp4+MK1WvL
	 aGDa/vxQ7iUiA==
From: sashiko-bot@kernel.org
Subject: Re: [PATCH 2/2] scsi: st: Record the tape position after a
 successful MTLOAD
Reply-To: sashiko-reviews@lists.linux.dev
To: "Laurence Oberman" <loberman@redhat.com>
Cc: linux-scsi@vger.kernel.org
In-Reply-To: <20260927131019.4188777-3-loberman@redhat.com>
References: <20260927131019.4188777-1-loberman@redhat.com>
 <20260927131019.4188777-3-loberman@redhat.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Sun, 27 Sep 2026 13:23:52 +0000
Message-Id: <20260927132352.7E2EE1F000FF@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>

Thank you for your contribution! Sashiko AI review found 1 potential issue(=
s) to consider:
- [Medium] scsi: st: Incomplete state reset in MTLOAD leaves eof active
--

commit bbaf6dbbc22cda3f48df1d40d4f966097f9dac28
Author: Laurence Oberman <loberman@redhat.com>

scsi: st: Record the tape position after a successful MTLOAD

This commit sets the tape file and block numbers to 0 after a successful
MTLOAD when the current partition is 0. This addresses an issue with drives
that do not report a new-medium unit attention when the medium is already
loaded, keeping the position state unknown.

> diff --git a/drivers/scsi/st.c b/drivers/scsi/st.c
> index 3280ec5702493..02aec1cea2470 100644
> --- a/drivers/scsi/st.c
> +++ b/drivers/scsi/st.c
> @@ -2688,6 +2688,14 @@ static int do_load_unload(struct scsi_tape *STp, s=
truct file *filp, int load_cod
>  		else {
>  			STp->rew_at_close =3D STp->autorew_dev;
>  			retval =3D check_tape(STp, filp);
> +			/*
> +			 * LOAD leaves the medium at the beginning of partition
> +			 * 0.  check_tape() records that only for a new session;
> +			 * without a new-medium unit attention (the medium was
> +			 * already loaded) the position would stay unknown.
> +			 */
> +			if (retval =3D=3D CHKRES_READY && STp->partition =3D=3D 0)
> +				STp->ps[0].drv_file =3D STp->ps[0].drv_block =3D 0;

[Severity: Medium]
Will this leave the EOF and filemark state flags desynchronized?

If a user reads a tape until EOD, setting STps->eof =3D ST_EOD, and then
issues an MTLOAD, the tape is physically rewound. The patched code in
do_load_unload() resets the file and block numbers to 0 here, but the
STps->eof flag does not appear to be cleared to ST_NOEOF as it would be
for an MTREW command.

If they attempt to read again, won't st_read() check STps->eof >=3D ST_EOD_1
and abort with -EIO? Does STps->eof also need to be cleared here to ensure
read() operations succeed after an MTLOAD?

>  			if (retval > 0)
>  				retval =3D 0;
>  		}

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20260927131019.4188=
777-1-loberman@redhat.com?part=3D2
