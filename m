Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A6D863DB964
	for <linux-scsi@vger.kernel.org>; Tue, 29 Sep 2026 17:41:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790703703; cv=none; b=uUwx3mkduTj74WyYqejGPJEOKTg9qPEzkfn1q2qJ/9Yk8P59lgp6DA6ilBBaj1HU4ujzt5JxrngmWwzXYwz29w7ChgcapT/ZYYQvxRbKshEJ1xAz/9VcBag++OYcGZU9i+up6Iyu1oQFlIDyiderpFPDcGUOT3GTRRRBVGr2fK8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790703703; c=relaxed/simple;
	bh=eIO4seTJYt5bycDnZVovXZxGj0hUGwb/YT9qrN9AIxw=;
	h=From:Subject:To:Cc:In-Reply-To:References:Content-Type:Date:
	 Message-Id; b=DapndoGBm9LiGdBnzB/V1mZTJBA/nqnyNASUaBkQ2vBZY7RQNnpG3nNK2+IjiCc4bd1dVMKFAmhAfT69V1XBW9MUpjINFEoFRdTRj9IgO2DMAyKeIu/UFMusCWKZfZP2w6dReptRBUUpWzKVhzhuZP4wSIyxLhqa5rL76RdQJhM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=U8AjGuzf; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="U8AjGuzf"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 172051F000FF;
	Tue, 29 Sep 2026 17:41:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1790703702;
	bh=gk6kBTyiYIxB/pd8MJTHhlQZwvoCb6Pnq8gXmpqbhoM=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=U8AjGuzfxqqat6jf8Uo07iw+E4OkSmHvPWqLdgIuwI7GqHydSf6it8yeIZHLb4r79
	 RlO8C7T5ayk9AZDF4bveDFrFckybH/NRWKXK/4wvZmsWVjeo9HHVbPmuThkpL9wXO5
	 yNm2T2FZajVzOiYjK4RPBjZ2cCpl9Ft2muSdf88tvdifDUClIeUsyOaqIXoz0CetN7
	 fQ76aiYoadG4+3nOdDq/tD2Hm1tFA16G0m9tD9bfznjSSggUdLTOP0+vqSnXvfC7uZ
	 +76m/DyD5hI0DTfxaRx/1t+Lb9ZiPZEdVzvgRR+APUU/YTRgjSJ7GEwDS8ERZyFpUl
	 2Ai+HCErU8H8Q==
From: sashiko-bot@kernel.org
Subject: Re: [PATCH v3 2/4] scsi: st: Record the tape position after a
 successful MTLOAD
Reply-To: sashiko-reviews@lists.linux.dev
To: "Laurence Oberman" <loberman@redhat.com>
Cc: linux-scsi@vger.kernel.org
In-Reply-To: <20260929171813.844733-3-loberman@redhat.com>
References: <20260929171813.844733-1-loberman@redhat.com>
 <20260929171813.844733-3-loberman@redhat.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Tue, 29 Sep 2026 17:41:41 +0000
Message-Id: <20260929174142.172051F000FF@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>

Thank you for your contribution! Sashiko AI review found 1 potential issue(=
s) to consider:
- [High] scsi: st: data corruption via rogue filemarks after MTLOAD
--

commit fa623b9485fe23a48925ee926b259a954fdd216e
Author: Laurence Oberman <loberman@redhat.com>

scsi: st: Record the tape position after a successful MTLOAD

This commit records the tape partition, position, and EOF state after a
successful MTLOAD, similar to how check_tape() does for a new session.
This fixes an issue where the driver would incorrectly report file/block
as -1 because drives didn't report a new-medium unit attention when
already loaded.

> diff --git a/drivers/scsi/st.c b/drivers/scsi/st.c
> index 0a4263bef9cbb..e5b2e2d4872d3 100644
> --- a/drivers/scsi/st.c
> +++ b/drivers/scsi/st.c
> @@ -2686,6 +2686,22 @@ static int do_load_unload(struct scsi_tape *STp, s=
truct file *filp, int load_cod
>  		else {
>  			STp->rew_at_close =3D STp->autorew_dev;
>  			retval =3D check_tape(STp, filp);
> +			/*
> +			 * LOAD leaves the medium at the beginning of partition
> +			 * 0.  check_tape() records that only for a new session;
> +			 * without a new-medium unit attention (the medium was
> +			 * already loaded) the partition, position and EOF state
> +			 * would be left as before the load.  Set them as a new
> +			 * session and MTREW do.
> +			 */
> +			if (retval =3D=3D CHKRES_READY) {
> +				STp->partition =3D STp->new_partition =3D 0;
> +				STps =3D &(STp->ps[0]);
> +				STps->drv_file =3D STps->drv_block =3D 0;
> +				STps->eof =3D ST_NOEOF;
> +				STps->at_sm =3D 0;
> +				STps->last_block_valid =3D 0;

[Severity: High]
Does this code risk data corruption by omitting a reset of the rw state?

If a user writes data to partition 0 (setting ps[0].rw =3D ST_WRITING), iss=
ues
MTSETPART 1, and then switches to partition 1, ps[0].rw remains ST_WRITING.

If the user then issues MTLOAD, the ioctl clears the rw state for the curre=
nt
partition (ps[1]), but do_load_unload() then forces STp->partition =3D 0 wi=
thout
clearing ps[0].rw.

Upon closing the device, st_flush() would see ps[0].rw =3D=3D ST_WRITING and
unconditionally execute WRITE_FILEMARKS at the beginning of the tape (BOT),
overwriting and destroying previously recorded data.

Should STps->rw =3D ST_IDLE; be added to this block to prevent rogue filema=
rk
writes at BOT?

> +			}
>  			if (retval > 0)
>  				retval =3D 0;
>  		}

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20260929171813.8447=
33-1-loberman@redhat.com?part=3D2
