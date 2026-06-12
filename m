Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 37C3B37E31E
	for <linux-scsi@vger.kernel.org>; Fri, 12 Jun 2026 10:41:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1781260904; cv=none; b=Ygc7im+PDfCKtNVv8xOpvTNFgEmClDPoNTZzhlBRnzQ4QWoQLS0osSrCWokdxMpGquY4eGEQa0he38feCS4Q8laZNdzLxuSluUBygLvKqF5om2CYTAlSgkkraa1ppLaMoEb3NHwylADgpVMyqQTa88Ho1n8WB3GFF/7WTy0YHg4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1781260904; c=relaxed/simple;
	bh=3QGDBn0klYngpqul3Jsvl+4dG13Yn7DYOu9j0Gt+x9k=;
	h=From:Subject:To:Cc:In-Reply-To:References:Content-Type:Date:
	 Message-Id; b=hr8LkUPvjgu5l6qxhGjGyDkiuifAyaLJHin9/D7fkAXFDyShQgrSypyKLCFXDE8gdfKBNMJU9hbkNdzhehxtJv2xcxFwwBZx6cF04/nPPL3gnOgsi+2O08GQ+A49MGTWHFP5pyhwsEulsRbqEYdzdClHaBFDnyGPasM3QLWOssw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=JQLpO5br; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="JQLpO5br"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5BA041F000E9;
	Fri, 12 Jun 2026 10:41:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1781260901;
	bh=cmfBBxzmJSdvyiQagHVz7ztkx8bzxWkPKGvhwbI3G7E=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=JQLpO5brOhnQ0QnV3EO2xnafj3hKzSerlhS7TZmsVB24gP8dtvZEQIlm171ey3iiO
	 Cr0kpc+k1kYzbmZ9aJy7EJRAhEhL0PimRoa0dcgj16bzMFC/kyh7htOrqKF8tuC3W4
	 EAYn0c9YnMDUlilxO3o1lpOuZN5f/H0TFcrqAcrZ92cm0QgmZ1loGkHPhoLBqgzTSc
	 Z848Tt0YCJ3RfHycTTf/QhkBS3QStWI7Ty9q5XILImCkPS3+1+N4JgRdcU298aEeSu
	 odF/UqhZHKb+uU8PVweATXAfLe+MB65I4VTAH8sHv0Lo0WmArzR4+iRiT8dhIzHYdb
	 cdbUBwNYd+Mtw==
From: sashiko-bot@kernel.org
Subject: Re: [PATCH v2 25/60] scsi: qla2xxx: Use ring-slot helpers in
 __qla2x00_alloc_iocbs
Reply-To: sashiko-reviews@lists.linux.dev
To: "Nilesh Javali" <njavali@marvell.com>
Cc: linux-scsi@vger.kernel.org
In-Reply-To: <20260612095333.1666592-26-njavali@marvell.com>
References: <20260612095333.1666592-26-njavali@marvell.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Fri, 12 Jun 2026 10:41:40 +0000
Message-Id: <20260612104141.5BA041F000E9@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>

Thank you for your contribution! Sashiko AI review found 1 potential issue(=
s) to consider:

Pre-existing issues:
- [High] Standard `memset()` is used on an `__iomem` mapped request ring po=
inter for QLAFX00 adapters, which can cause unaligned access faults or bus =
errors on architectures like ARM64.
--

commit 9791936eaf3c9274e9174a4c671ecce5a7c3c126
Author: Nilesh Javali <njavali@marvell.com>

scsi: qla2xxx: Use ring-slot helpers in __qla2x00_alloc_iocbs

This commit refactors __qla2x00_alloc_iocbs() to use qla_req_ring_slot() and
qla_req_entry_size() helpers instead of open-coding the ring pointer select=
ion
and entry size based on the adapter type.

> diff --git a/drivers/scsi/qla2xxx/qla_iocb.c b/drivers/scsi/qla2xxx/qla_i=
ocb.c
> index d16570a6a0724..e2b64029a5743 100644
> --- a/drivers/scsi/qla2xxx/qla_iocb.c
> +++ b/drivers/scsi/qla2xxx/qla_iocb.c
[ ... ]
> @@ -2469,13 +2468,8 @@ __qla2x00_alloc_iocbs(struct qla_qpair *qpair, srb=
_t *sp)
>  	 * layout-compatible once we return the pkt as request_t *.
>  	 */
>  	req->cnt -=3D req_cnt;
> -	if (IS_QLA29XX(ha)) {
> -		pkt =3D (request_t *)req->ring_ext_ptr;
> -		memset(pkt, 0, REQUEST_ENTRY_SIZE_EXT);
> -	} else {
> -		pkt =3D req->ring_ptr;
> -		memset(pkt, 0, REQUEST_ENTRY_SIZE);
> -	}
> +	pkt =3D qla_req_ring_slot(ha, req);
> +	memset(pkt, 0, qla_req_entry_size(ha));
>  	if (IS_QLAFX00(ha)) {
>  		wrt_reg_byte((u8 __force __iomem *)&pkt->entry_count, req_cnt);

[Severity: High]
This is a pre-existing issue, but does using standard memset() on the reque=
st
ring slot pointer cause problems for QLAFX00 adapters?

For QLAFX00 adapters, req->ring is mapped I/O memory, which is why the
register-mapped writes below require __iomem casts. On architectures like
ARM64, calling standard memset() directly on device memory can utilize
unaligned or optimized instructions that are invalid for I/O memory, leading
to a synchronous external abort and a kernel panic.=20

Should this be using an I/O specific memset, or could the memset be
skipped entirely for QLAFX00 device memory?

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20260612095333.1666=
592-1-njavali@marvell.com?part=3D25
