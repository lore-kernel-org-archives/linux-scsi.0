Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9D18F3EB0E6
	for <linux-scsi@vger.kernel.org>; Fri, 26 Jun 2026 16:18:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1782490690; cv=none; b=BhS2RnK+gPlrDA93IrvYACY2nQeLm6Koskl6nlWD7EDnPesuh6XWNh3FbPaVZQowv8hiVFFXuYw+ZXwBjI56B1ovUt3/+5T0gZ45Hm3lp1ztADrAVgjZD4ct2TiI3MORi4RzFnVZ5ub2pw6+vWknKGg+0S3IlRnGQDnu6n4mWrA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1782490690; c=relaxed/simple;
	bh=GhtxSYWhEa7qNco6vi33w75E06zQnPKA791tsJko5eM=;
	h=From:Subject:To:Cc:In-Reply-To:References:Content-Type:Date:
	 Message-Id; b=ZIkFUoUGe4un4dDOzgMbN56jEGU93ll4eeZiidzHL/oEo7ZmjHQ6HkeKwv1xgGY4gScrQpxXcMbyhGgrt1GVrnqXWm2JbXA96bIO0xVbME+9LC0ICTwTWb2KRM39Fq+NEZqYO3eLzSzfBYciGyyrEi49q4dc0ATFKKJG37lOxnc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=NhqQF69Z; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="NhqQF69Z"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id F3DC01F000E9;
	Fri, 26 Jun 2026 16:18:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1782490688;
	bh=6UI/MgMvucxa1SR1M5ZXRPJU0qb3R4bEQOqZXoD4pa4=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=NhqQF69ZaZFjb/JXEw7sXM3uA4CqeNbOwr3rJN6DPTshxIWQ9v19jsUbkX3Tap6rs
	 cYxdCtS6YVSXjPKomQMJ5Omb/mCKX0xrZ+AfZpbquBWBuCvIzWdfouBH6qnWX0hozq
	 5cg5MtwY+Ng+eAkEIVeh1Rr1p4oh3O2fEtaw3huiX1Uv7pttEesiEBr63BjC2Jsmiu
	 Nx1dcjzkL56aVLco0z2XCYtpdHGWp1PhZb4jX2Zaf+GYQUyE+23sF4bFNDqXXt3M9K
	 PClRRhvMsGToiNCjV4DE2qUcfAt9/FzWnPy3fkOiWuOrFnkruQ9pNQO9gIHhGRbwmh
	 djYDP8CpW8IPA==
From: sashiko-bot@kernel.org
Subject: Re: [PATCH] fix: scsi: srp_reconnect_rport: unbalanced
   scsi_block_targets/scsi_target_unblock
Reply-To: sashiko-reviews@lists.linux.dev
To: "WenTao Liang" <vulab@iscas.ac.cn>
Cc: linux-scsi@vger.kernel.org
In-Reply-To: <20260626161402.55116-1-vulab@iscas.ac.cn>
References: <20260626161402.55116-1-vulab@iscas.ac.cn>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Fri, 26 Jun 2026 16:18:07 +0000
Message-Id: <20260626161807.F3DC01F000E9@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>

Thank you for your contribution! Sashiko AI review found 1 potential issue(=
s) to consider:
- [High] Missing curly braces around the `if` block causes `blocked =3D tru=
e;` to execute unconditionally, defeating the intended fix.
--

commit c11303cf8aa2900f23dfb0d36f22857ab2b9cb38
Author: WenTao Liang <vulab@iscas.ac.cn>

fix: scsi: srp_reconnect_rport: unbalanced scsi_block_targets/scsi_target_u=
nblock

This commit introduces a blocked flag to srp_reconnect_rport() to track
if scsi_block_targets() was called. This is intended to prevent an extra
scsi_target_unblock() call which results in an unbalanced kref_put.

> diff --git a/drivers/scsi/scsi_transport_srp.c b/drivers/scsi/scsi_transp=
ort_srp.c
> index a61cbb079ab4e..d7c2608b73ef3 100644
> --- a/drivers/scsi/scsi_transport_srp.c
> +++ b/drivers/scsi/scsi_transport_srp.c
[ ... ]
> @@ -549,6 +550,7 @@ int srp_reconnect_rport(struct srp_rport *rport)
>  		 * treats SDEV_TRANSPORT_OFFLINE like SDEV_BLOCK.
>  		 */
>  		scsi_block_targets(shost, &shost->shost_gendev);
> +		blocked =3D true;

[Severity: High]
Does this missing brace cause the blocked flag to be set unconditionally?

Looking at srp_reconnect_rport(), the preceding if statement lacks curly
braces:

	if (rport->state !=3D SRP_RPORT_FAIL_FAST && rport->state !=3D SRP_RPORT_L=
OST)
		/* ... */
		scsi_block_targets(shost, &shost->shost_gendev);
		blocked =3D true;

Because blocked =3D true is treated as a separate sequential statement, it =
will
execute regardless of the rport->state check.

Does this entirely defeat the fix by leaving the unbalanced
scsi_target_unblock() reference counting issue active?

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20260626161402.5511=
6-1-vulab@iscas.ac.cn?part=3D1
