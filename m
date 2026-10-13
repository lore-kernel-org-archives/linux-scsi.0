Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 72A1D3EC80B
	for <linux-scsi@vger.kernel.org>; Tue, 13 Oct 2026 10:41:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791888117; cv=none; b=AWaSPVczJMsucRUlbcEd/bUyh5X9YqvUIgNfYQO1YR75cJG7QRwua/HnYpnzpvj3mKwdFjpP2EGemQlGK4pU1fx2NhVLe9O8dI1sGPZ+p/Q3OTBq601yb3/l5SbuAtK9853ZuwaxF6Hl3I8F5NvsVA/IfRQcbN6Fvz1yh0IdNHE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791888117; c=relaxed/simple;
	bh=GfZ5f3A4P3FUGnGDtq4bdzPFBvPDYKJBkENQ5JW4agQ=;
	h=Message-ID:From:Subject:To:Cc:In-Reply-To:References:Content-Type:
	 Date; b=B7VHyh/SNcKueJCj7NcZKI7BOAQABH1IlmpX7nxUhzdREw2nkdLKL0w4Hjdz4NXzkzkVm1CG6+3BAGfEeWuY+WPHQe1RROxy1w1p0WHbAbp3h6PApWDEvHs+bQcKXhT2SfJWrJC4AmJNsK7ruqVRHi0nRSwgNvinUg+ixKGL154=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=hD9w+0W8; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="hD9w+0W8"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D0EF01F000FF;
	Tue, 13 Oct 2026 10:41:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1791888116;
	bh=WZewdXl5TBc4XZkCRbYrxiqFYnEtis5YDggIkcRi9L8=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=hD9w+0W8ZIS+GTRbBnl+9nf1fvFyba+dvMuWDS0fhJ7APxgvSMqvge9AlMFyDOPBY
	 /5bDHdBJYaNS7EU1+7kWW4VjvezHsBHp4ZrY7ZlZGLQVaO6mj9YeFDMLFQql9g98XB
	 UllN7TpdzSIuklMw34Qei8WJ1Q4rlUd7L4K0lUu+5dO0nw/EbYdrE4JOXn6NKBM1EY
	 /6sxFUYR0vF+aKn5EnBoWXOygOFOBHKF5oQcvIVcGuVEXDGuK/jTfg9XYfZ6tCn7jd
	 /jfZ/HL5MncPD9E08Ld8xZ/pxOIVOJfIOay8C1MwmlGv4nnrFTTimF6nUru9o8GDRc
	 USGAVEVVbl/ww==
Message-ID: <sashiko-outbox-169530@kernel.org>
From: sashiko-bot@kernel.org
Subject: Re: [PATCH 3/3] scsi: ufs: core: Clear stale UIC result byte before
 peer DME retries
Reply-To: sashiko-reviews@lists.linux.dev
To: "Stanley Jhu" <stanleyjhu@google.com>
Cc: linux-scsi@vger.kernel.org
In-Reply-To: <20261013102913.948718-4-stanleyjhu@google.com>
References: <20261013102913.948718-1-stanleyjhu@google.com>
 <20261013102913.948718-4-stanleyjhu@google.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Tue, 13 Oct 2026 10:41:55 +0000
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>

Thank you for your contribution! Sashiko AI review found 1 potential issue(=
s) to consider:
- [Medium] scsi: ufs: dme_set retry loop reuses potentially corrupted argum=
ent3
--

commit b7bd98803047d25927dcd2349ce8724199680d23
Author: Stanley Jhu <stanleyjhu@google.com>

scsi: ufs: core: Clear stale UIC result byte before peer DME retries

Peer DME get and set retry a failed attempt with the same struct
uic_command. This commit clears the result byte in argument2 before
each attempt to prevent transient failures from becoming hard failures
due to stale error codes.

Fixes: 64238fbd15ea ("scsi: ufs: add retries to dme_peer get and set attrib=
ute")
Cc: stable@vger.kernel.org
Signed-off-by: Stanley Jhu <stanleyjhu@google.com>

> diff --git a/drivers/ufs/core/ufshcd.c b/drivers/ufs/core/ufshcd.c
> index cc75384c65021..1f254402d3b4b 100644
> --- a/drivers/ufs/core/ufshcd.c
> +++ b/drivers/ufs/core/ufshcd.c
> @@ -4398,6 +4398,7 @@ int ufshcd_dme_set_attr(struct ufs_hba *hba, u32 at=
tr_sel,
>  	int retries =3D UFS_UIC_COMMAND_RETRIES;
> =20
>  	do {
> +		uic_cmd.argument2 &=3D ~MASK_UIC_COMMAND_RESULT;

[Severity: Medium]
When ufshcd_send_uic_cmd() fails, does the completion handler overwrite
argument3?

Looking at ufshcd_uic_cmd_compl(), it appears argument3 is unconditionally
updated with the hardware register's contents:

ufshcd_uic_cmd_compl() {
	...
	/* Store the DME attribute value in cmd->argument3. */
	cmd->argument3 =3D ufshcd_readl(hba, REG_UIC_COMMAND_ARG_3);
	...
}

Since uic_cmd.argument3 is initialized to mib_val only once outside the
retry loop in ufshcd_dme_set_attr(), can this regression cause a subsequent
retry to write whatever value the hardware left in the register during the
failure?

Should uic_cmd.argument3 be restored to mib_val before retrying, similar
to how argument2 is cleared here?

>  		/* for peer attributes we retry upon failure */
>  		ret =3D ufshcd_send_uic_cmd(hba, &uic_cmd);
>  		if (ret)

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20261013102913.9487=
18-1-stanleyjhu@google.com?part=3D3
