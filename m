Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5DAE938D3F2
	for <linux-scsi@vger.kernel.org>; Mon, 12 Oct 2026 11:54:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791806092; cv=none; b=QmWmHOR2niDMb9CwzOurd6ELNK1Z5yfmOjeKeF0zgOYK69YHyzY/15f8hVpEImdV2iJRTevQmseWbZ2C9vVtedVjyTjBD44ZcgorETni9+Zxxglh1WhfAbyfqmfuqZm7Xh5ceJstTCCHiBCUBpTU9A/KQHQl53kFO7DWL8RIZxM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791806092; c=relaxed/simple;
	bh=3fpyikwiivvpInFwuximPiqiRO+8TKnP0/gvgHnaH8A=;
	h=Message-ID:From:Subject:To:Cc:In-Reply-To:References:Content-Type:
	 Date; b=bQLO6zaXk5YKtpzFyfbBGeIDR4AHd97u6ZMfn9zj5OnlmubIIGW18haGfTgIOMe/n5cfAxckbL+MlXskWJb4Tr+b/UmwPPM87tuULH1VkVZH+afWj3R1B6KBi5x5do07fRkVrmgJF95PUCCb4PDGY/q8riT+qRXt3F4xI7PZ2LA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=Kl58Wqpr; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="Kl58Wqpr"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D4FD01F0089B;
	Mon, 12 Oct 2026 11:54:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1791806091;
	bh=G4AI4cFFuQ2+V63g8BabCtAGeNoDeYAKrqJUkniHuUA=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=Kl58WqprP2l5HfsfATVB0x4bsz/5BhEeDivzFY77ptjklbjDmQhVRkn4NoVy0f4r+
	 5TTG6TTp9PHpmQIprCiQjGfDRSjKfEnCiPfchXsKIas/x+A59m2WgG32prx+UmyCFX
	 OKJ+7jcLT3hdJH/2OuuCqLPBbZYmn2UH9dGl+jJSjQOEnhv4fmIo0ExUekyaizLUdu
	 mmmJ81tmsiDPprCoVQ8aiCngydxdsx1lDRTpyV0YAAdLb97xTKcm8/emSVg8r0s1BU
	 aNxwgyu3j8HafgrtuKxVSKIklqdA/HWObaRnxQlJO1w1050bQi9v0jIHSIa9TmDMWV
	 XsvoPbhiFcImw==
Message-ID: <sashiko-outbox-168035@kernel.org>
From: sashiko-bot@kernel.org
Subject: Re: [PATCH v3 1/3] scsi: arcmsr: bound the firmware-supplied
 message length
Reply-To: sashiko-reviews@lists.linux.dev
To: "Yehyeong Lee" <yhlee@isslab.korea.ac.kr>
Cc: linux-scsi@vger.kernel.org
In-Reply-To: <adc1e1512a87ff16e99d066c2e96e18a1d28e610.1791803953.git.yhlee@isslab.korea.ac.kr>
References: <cover.1791803953.git.yhlee@isslab.korea.ac.kr>
 <adc1e1512a87ff16e99d066c2e96e18a1d28e610.1791803953.git.yhlee@isslab.korea.ac.kr>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Mon, 12 Oct 2026 11:54:50 +0000
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>

Thank you for your contribution! Sashiko AI review found 1 potential issue(=
s) to consider:
- [Medium] scsi: arcmsr: TOCTOU double fetch causes circular buffer corrupt=
ion
--

commit c1b87442346f4c23552402e5fce0db15b1252056
Author: Yehyeong Lee <yhlee@isslab.korea.ac.kr>

scsi: arcmsr: bound the firmware-supplied message length

This commit addresses an out-of-bounds write where an unbounded data_len
from the MMIO register could walk past the 128-byte staging buffer. It
clamps the length to the size of the window (124 bytes) in both reader
functions.

> diff --git a/drivers/scsi/arcmsr/arcmsr_hba.c b/drivers/scsi/arcmsr/arcms=
r_hba.c
> index 8aa948f06cacf..255f1d898079f 100644
> --- a/drivers/scsi/arcmsr/arcmsr_hba.c
> +++ b/drivers/scsi/arcmsr/arcmsr_hba.c
> @@ -2277,6 +2277,8 @@ arcmsr_Read_iop_rqbuffer_in_DWORD(struct AdapterCon=
trolBlock *acb,
> =20
>  	iop_data =3D (uint32_t __iomem *)prbuffer->data;
>  	iop_len =3D readl(&prbuffer->data_len);
> +	if (iop_len > sizeof(prbuffer->data))
> +		iop_len =3D sizeof(prbuffer->data);

[Severity: Medium]
The commit message notes that the adapter can change data_len between the t=
wo
reads. While clamping iop_len to sizeof(prbuffer->data) prevents the staging
buffer overflow, does this still leave a TOCTOU (time-of-check to time-of-u=
se)
vulnerability that can corrupt the circular buffer?

arcmsr_iop2drv_data_wrote_handle() validates the first fetch against
buf_empty_len:

drivers/scsi/arcmsr/arcmsr_hba.c:arcmsr_iop2drv_data_wrote_handle() {
	...
	if (buf_empty_len >=3D readl(&prbuffer->data_len)) {
		if (arcmsr_Read_iop_rqbuffer_data(acb, prbuffer) =3D=3D 0)
			...
}

If buf_empty_len is small (e.g., 10 bytes), the first fetch could be 10, pa=
ssing
the check. If the second fetch here sees an increased data_len from the MMIO
register (e.g., 124 bytes), the while loop below will write more bytes than
buf_empty_len.

Could this cause rqbuf_putIndex to overtake rqbuf_getIndex and corrupt the
driver's internal ring buffer state?

>  	if (iop_len > 0) {
>  		buf1 =3D kmalloc(128, GFP_ATOMIC);
>  		buf2 =3D (uint32_t *)buf1;

[ ... ]

> @@ -2319,6 +2321,8 @@ arcmsr_Read_iop_rqbuffer_data(struct AdapterControl=
Block *acb,
>  		return arcmsr_Read_iop_rqbuffer_in_DWORD(acb, prbuffer);
>  	iop_data =3D (uint8_t __iomem *)prbuffer->data;
>  	iop_len =3D readl(&prbuffer->data_len);
> +	if (iop_len > sizeof(prbuffer->data))
> +		iop_len =3D sizeof(prbuffer->data);

[Severity: Medium]
This second fetch in the byte-wise reader shares the same vulnerability when
called from arcmsr_iop2drv_data_wrote_handle().

Would passing the validated length down from the caller prevent the hardware
from bypassing the buf_empty_len check entirely?

>  	while (iop_len > 0) {
>  		pQbuffer =3D &acb->rqbuffer[acb->rqbuf_putIndex];
>  		*pQbuffer =3D readb(iop_data);

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/cover.1791803953.gi=
t.yhlee@isslab.korea.ac.kr?part=3D1
