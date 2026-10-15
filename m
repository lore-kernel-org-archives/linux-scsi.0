Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A61C02FC00D
	for <linux-scsi@vger.kernel.org>; Thu, 15 Oct 2026 02:15:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1792030531; cv=none; b=Kz59Xj9kmxuyff/w4+vbHBEJE510Bbt0r3EuUMvgOm18Fv8nhSxr4HH7nz1iP7Gx2CylRx9q58dCuW+q9CJQsK0KG9qjzx3VhOraMzEJY8cLvRFxHjLHZnryYM5Ek3chpRNJ3FHHgfVXETqSL8yOJrCpZbcmLqeWR380kePmE1U=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1792030531; c=relaxed/simple;
	bh=hELyEo7pzjBPIshKAsqHoGM3sBdwIodhHTsNslkFE2s=;
	h=Message-ID:From:Subject:To:In-Reply-To:References:Content-Type:
	 Date; b=LU0sf64gzY7MZTvqYahWIli/VBrIrDILBSC2eQikSE9UHx5OEE8BnILausWw2ahqGEtNFx+fnRcK70xRamzx5lYeHKm9AKSCsPNj/QFXMLwMollAodmdqNNtVtNogo6pJfID0ooiICXMIRjawKlgvQqWpMalF+UUpKYCSMBQ45E=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=Rm7TXVWl; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="Rm7TXVWl"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 20E7B1F000C5;
	Thu, 15 Oct 2026 02:15:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1792030530;
	bh=4P/pv9+z56m2Vx5zXtqXUTbao7MkE3QQsBRVSvUPGG4=;
	h=From:Subject:Reply-To:To:In-Reply-To:References:Date;
	b=Rm7TXVWlqQXpHeMHdrTUfkFw47e0DzT5U1G5AeYPz9+v6gi2P3yi2Jqbt5uQnohNj
	 N/RaHq/9FkO8QAl9CM9kaPy/K98VYEyySSH33nL0S/XC6dzTxcCu+HJQhWpnDQX1M4
	 WdYmdxystaFeKi6071Npe/5B4I636IVXcopGkP7etoT5dZqNjAwqikk7yMWLGhWgoY
	 CQEvkh+rOflRdC/Is9MEOG3GOFdABUN3L9coqVPm329ukraEN5pmkHLc0n/6ubWZfU
	 1e22/q0q8sD82RD0gYYx3OcVxdzipJ1JX3KDo/iUz1cbIEq81FPo15GUjpJErZqNgx
	 ZwgkRnEugzfhw==
Message-ID: <sashiko-outbox-172135@kernel.org>
From: sashiko-bot@kernel.org
Subject: Re: [PATCH] scsi: mpt3sas: fix OOB SGE write at the request frame
 boundary
Reply-To: sashiko-reviews@lists.linux.dev
To: "Weibin Liu" <liuwb@xiaopeng.com>, linux-scsi@vger.kernel.org
In-Reply-To: <20261015-mpt3sas-sge-offset-v1-1-9b91c265f2c1@xiaopeng.com>
References: <20261015-mpt3sas-sge-offset-v1-1-9b91c265f2c1@xiaopeng.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Thu, 15 Oct 2026 02:15:29 +0000
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>

Thank you for your contribution! Sashiko AI review found 1 potential issue(=
s) to consider:
- [High] scsi: mpt3sas: incomplete bounds check leaves OOB write unpatched
--

commit c6cf70bbba6355fabaab51bc07707d150970dad8
Author: Weibin Liu <liuwb@xiaopeng.com>

scsi: mpt3sas: fix OOB SGE write at the request frame boundary

_ctl_do_mpt_command() bounds the user-supplied data_sge_offset with
strict inequalities. When data_sge_offset * 4 is exactly ioc->request_sz,
both comparisons pass, allowing an OOB write. This commit changes the
comparison to >=3D to reject offsets that point exactly at or past the
end of the request frame.

> diff --git a/drivers/scsi/mpt3sas/mpt3sas_ctl.c b/drivers/scsi/mpt3sas/mp=
t3sas_ctl.c
> index 8bb947004885b..d8d3ee11ed520 100644
> --- a/drivers/scsi/mpt3sas/mpt3sas_ctl.c
> +++ b/drivers/scsi/mpt3sas/mpt3sas_ctl.c
> @@ -739,7 +739,7 @@ _ctl_do_mpt_command(struct MPT3SAS_ADAPTER *ioc, stru=
ct mpt3_ioctl_command karg,
>  	}
> =20
>  	/* Check for overflow and wraparound */
> -	if (karg.data_sge_offset * 4 > ioc->request_sz ||
> +	if (karg.data_sge_offset * 4 >=3D ioc->request_sz ||
>  	    karg.data_sge_offset > (UINT_MAX / 4)) {

[Severity: High]
Does this bounds check leave an out-of-bounds write unpatched?

If a user issues an MPT3COMMAND ioctl with karg.data_sge_offset set such
that karg.data_sge_offset * 4 is slightly less than ioc->request_sz
(e.g., ioc->request_sz - 4), the updated validation still passes because
ioc->request_sz - 4 is not >=3D ioc->request_sz.

The SGE array pointer psge would then be set to point 4 bytes before the
end of the request frame. The SGE builder functions (ioc->build_sg, such
as _base_build_sg() or _base_build_zero_len_sge()) write a minimum of 8
to 32 bytes of scatter-gather elements to psge without further bounds
checking:

drivers/scsi/mpt3sas/mpt3sas_base.c:_base_build_sg() {
...
	if (!data_out_sz && !data_in_sz) {
		_base_build_zero_len_sge(ioc, psge);
		return;
	}
...
}

Since only 4 bytes remain in the frame, the SGE write overflows the request
buffer by at least 4 bytes. Because the request buffers are allocated
contiguously in a DMA pool array, does this overflow corrupt the adjacent
request frame?

>  		ret =3D -EINVAL;
>  		goto out;

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20261015-mpt3sas-sg=
e-offset-v1-1-9b91c265f2c1@xiaopeng.com?part=3D1
