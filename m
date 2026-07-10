Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AE1DE384248
	for <linux-scsi@vger.kernel.org>; Fri, 10 Jul 2026 06:05:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1783663544; cv=none; b=ajgu6UXRnBYlvPSJDzjXpYYgcAK+O7mWsDoSnxeEgtd4TYZVpSoH9ygnu4UA7JdIyw29jdSAvTtk2KufcCzs/2/zHWB1gQJeM1qK+7nfoCG9eSlTGF8fSKtUVdnW3q/R3tOw0dhuPyfXmI7mwCJe+rSY4L1kEB/d4avb5gygfs8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1783663544; c=relaxed/simple;
	bh=nRlunw+cFVKJZy8CK/YR6vl+H4a6LD4tA08A8KF9jrI=;
	h=From:Subject:To:Cc:In-Reply-To:References:Content-Type:Date:
	 Message-Id; b=a1y3D9gvXLSiHtTQGWD5Ym2V89Eg2DYZkAkVGhcvWMxxg0R6BDsFgSoqPRXheRmjOPuj7MYRYhoPV7u0icFeF4Dvr2oAbhizbQnuSGvuCja5YfpdFqQ/w7pizjDOZJb5puSmzk1a4orMAbnkcZRAAyjohmxFkTA+PjWya6+rcx0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=nZNeORpu; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="nZNeORpu"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 621591F000E9;
	Fri, 10 Jul 2026 06:05:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1783663543;
	bh=AK3mdKx4nxFf8STZGvgtfw+QqlBol2EZRLMqaLgaRP8=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=nZNeORpuGuxEbdxQnOARXXJD8Dh3y9U4RsT80tnXArPr0bJnyarwTiVAjuMlY+IcG
	 xpkSbF0Ydby7Sa7F9YQDzV755KVprzyXdrmjmB7vYLhRnE3zmN6LfQK6zwQ+/pzhdB
	 OJg4ZFP59pTL6BMP2+OwY4GLYtGG2DOS6O1MRFF6KI2Yyg3NcZDYYWWRx7H1wxDB5f
	 HhklWyb7My4HxFzwN/TEDBDjaGvNWGef0xYNE4RdI9jWNDY3rex/jsbE8wZzjmAQ2O
	 9xqZu2pjN8LiE2Uw91R0trDrytBRopTqxI4OI8chKis2UuzQ+aWDkFUPaSI4GUTVxq
	 nUKge46iaNewA==
From: sashiko-bot@kernel.org
Subject: Re: [PATCH v3] scsi: scsi_debug: fix REPORT ZONES alloc_len
 underflow OOB write
Reply-To: sashiko-reviews@lists.linux.dev
To: "Ibrahim Hashimov" <security@auditcode.ai>
Cc: linux-scsi@vger.kernel.org
In-Reply-To: <20260710055755.53830-1-security@auditcode.ai>
References: <1357dbf9-e135-4ba3-896d-1472a208f82f@kernel.org>
 <20260710055755.53830-1-security@auditcode.ai>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Fri, 10 Jul 2026 06:05:42 +0000
Message-Id: <20260710060543.621591F000E9@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>

Thank you for your contribution! Sashiko AI review found 1 potential issue(=
s) to consider:
- [High] Integer truncation on 32-bit platforms leads to ZERO_SIZE_PTR out-=
of-bounds write and kernel panic
--

--- Patch [1]: [PATCH v3] scsi: scsi_debug: fix REPORT ZONES alloc_len unde=
rflow OOB write ---
commit 1e0d50f19491d296aa99221a898bda21deff84db
Author: Ibrahim Hashimov <security@auditcode.ai>

scsi: scsi_debug: fix REPORT ZONES alloc_len underflow OOB write

This commit fixes an out-of-bounds write in resp_report_zones() by sizing
the buffer to a whole number of 64-byte blocks that cover the requested
allocation length. It aligns the length and computes the buffer size in
64-bit to avoid a u32 wrap.

> diff --git a/drivers/scsi/scsi_debug.c b/drivers/scsi/scsi_debug.c
> --- a/drivers/scsi/scsi_debug.c
> +++ b/drivers/scsi/scsi_debug.c
> @@ -5911,9 +5912,11 @@ static int resp_report_zones(struct scsi_cmnd *scp,
>  		return check_condition_result;
>  	}
> =20
> -	rep_max_zones =3D (alloc_len - 64) >> ilog2(RZONES_DESC_HD);
> +	rep_max_zones =3D (ALIGN((u64)alloc_len, RZONES_DESC_HD) - RZONES_DESC_=
HD) >>
> +			ilog2(RZONES_DESC_HD);
> +	arr_len =3D (u64)RZONES_DESC_HD * (rep_max_zones + 1);
> =20
> -	arr =3D kzalloc(alloc_len, GFP_ATOMIC | __GFP_NOWARN);
> +	arr =3D kzalloc(arr_len, GFP_ATOMIC | __GFP_NOWARN);

[Severity: High]
Does this code cause a truncation and kernel panic on 32-bit systems?

If a user with raw IO access sends a REPORT ZONES SCSI command with an
alloc_len between 0xFFFFFFC1 and 0xFFFFFFFF, ALIGN() rounds it up to exactly
0x100000000 (4 GB) making arr_len exactly 0x100000000.

On 32-bit platforms, kzalloc() takes a 32-bit size_t, which silently
truncates 0x100000000 to 0. Calling kzalloc(0) returns ZERO_SIZE_PTR, which
bypasses the (!arr) NULL check.

>  	if (!arr) {
>  		mk_sense_buffer(scp, ILLEGAL_REQUEST, INSUFF_RES_ASC,
>  				INSUFF_RES_ASCQ);
>  		return check_condition_result;
>  	}
> =20
>  	sdeb_meta_read_lock(sip);
> =20
>  	desc =3D arr + 64;

Since arr is ZERO_SIZE_PTR (typically 0x10), desc becomes an unmapped
address (0x50).

[ ... ]

>  		if (nrz < rep_max_zones) {
>  			/* Fill zone descriptor */
>  			desc[0] =3D zsp->z_type;
>  			desc[1] =3D zsp->z_cond << 4;

The driver unconditionally dereferences the unmapped memory here, which
will trigger a deterministic kernel panic.=20

Could we add a bounds check for alloc_len to ensure it doesn't exceed 32-bit
bounds or a reasonable maximum allocation size before passing it to kzalloc=
()?

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20260710055755.5383=
0-1-security@auditcode.ai?part=3D1
