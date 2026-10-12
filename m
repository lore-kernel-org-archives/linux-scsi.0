Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 70AF733B970
	for <linux-scsi@vger.kernel.org>; Mon, 12 Oct 2026 09:14:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791796458; cv=none; b=SWJ7cr36bhlNZVg2vS/BnbJB5mXaXfKQfvvXmbS/HyqHEDRyCCJ3o6aDgQZPqE44DL7a16amI+dvgOAR2kpJJLMPlWvVAGY+LFok8PgN8riFTgSp7TlnACdVSVVYM4kkY3I0TBDZs1Yd3Hf6FKyDCPyj2+gMijPoo0spSQk1OhU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791796458; c=relaxed/simple;
	bh=PH/t0e2f87RzlcHdDACJyqtRTZUcHgtgwv6i0uUuuxA=;
	h=Message-ID:From:Subject:To:Cc:In-Reply-To:References:Content-Type:
	 Date; b=JLkdGKFzQo8NIkqQOFJfiextlu8l2i+yhUSKioH6SAAkQFxaB1S7PjDnd+/CGMYZWbp01nNWY2RLjyKBKYYjfBp90HOsFtFnh9wdgtbqHwhvRjpEGTJArgTh0nTmO9v33vAuwWFqlAzNFTwdPlIs1pkSEP7tUqtyGxmlVIVKJtk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=fYAnL7ti; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="fYAnL7ti"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 081A31F0089B;
	Mon, 12 Oct 2026 09:14:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1791796457;
	bh=6jyCzqpYRzJZ1X7pmx3NMFQlAl8oKpy5CI6Vh4V79Nk=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=fYAnL7tiJJN2w4VXlVlUCT1/zxHSKPdjxpL/XRW10b/P04Q/E6jArufwuOcTSd570
	 8sP/yWmJ7tWFIfX6CuwBeKO6WU8xojhr/DP1sJnxHDPe7fHTZyPOjz8WaPLIH7MFuL
	 JuHF8yJI92rC9ZdFm+B2jfmhp9zBJ2Rqvd9rRRUM4CS6z3R3M5pgtz8j3FzXXRowbN
	 sH6/In68DaX7j7g/esilYUw5CH2J5OeayPBlw/0sjMa1EWNmYLXMdjVFYmC6RH8uZW
	 ZWDMe14oFykW32Cl+hY7IAe/FWYlKdjZIFhkUMVY1hhifWzuUfpUD5T6VRu0ZIzb4o
	 tcPIE6ZBU3AyQ==
Message-ID: <sashiko-outbox-167887@kernel.org>
From: sashiko-bot@kernel.org
Subject: Re: [PATCH v2 1/3] scsi: arcmsr: bound the firmware-supplied
 message length
Reply-To: sashiko-reviews@lists.linux.dev
To: "Yehyeong Lee" <yhlee@isslab.korea.ac.kr>
Cc: linux-scsi@vger.kernel.org
In-Reply-To: <adc1e1512a87ff16e99d066c2e96e18a1d28e610.1791792888.git.yhlee@isslab.korea.ac.kr>
References: <cover.1791792888.git.yhlee@isslab.korea.ac.kr>
 <adc1e1512a87ff16e99d066c2e96e18a1d28e610.1791792888.git.yhlee@isslab.korea.ac.kr>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Mon, 12 Oct 2026 09:14:16 +0000
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>

Thank you for your contribution! Sashiko AI review found 1 potential issue(=
s) to consider:
- [Medium] scsi: arcmsr: TOCTOU on prbuffer->data_len allows ring buffer co=
rruption
--

commit 16cde600ac48b31a8026c8b69bc4727180d6c13a
Author: Yehyeong Lee <yhlee@isslab.korea.ac.kr>

scsi: arcmsr: bound the firmware-supplied message length

This commit bounds the firmware-supplied message length to prevent out-of-b=
ounds
writes. It clamps the length of inbound messages to the 128-byte window size
during reads from the adapter. This fixes an issue where a malicious or
misbehaving firmware could specify an oversized data length and overrun the
allocated buffer.

>     The adapter hands the driver an inbound message through a fixed
>     128-byte window:
>    =20
>             struct QBUFFER {
>                     uint32_t        data_len;
>                     uint8_t         data[124];
>             };
>    =20
>     arcmsr_Read_iop_rqbuffer_in_DWORD() takes data_len from that window a=
nd
>     uses it as the copy length without comparing it against the window:

[ ... ]

>     Two of the three callers place no bound on the value at all:
>     arcmsr_iop_message_xfer() for ARCMSR_MESSAGE_READ_RQBUFFER and
>     arcmsr_sysfs_iop_message_read() both call straight into the reader on
>     ACB_F_IOPDATA_OVERFLOW.  The third, arcmsr_iop2drv_data_wrote_handle(=
),
>     compares data_len against the free space in acb->rqbuffer, which is up
>     to ARCMSR_MAX_QBUFFER - 1 and so still far larger than the 128-byte
>     staging buffer; it also reads data_len separately from the reader, so
>     the adapter can change it between the two reads.
>    =20
>     Clamp the length to the size of the window in both readers.  A
>     conforming adapter never reports more than sizeof(prbuffer->data), so
>     this does not drop any data it sends.

[ ... ]

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
This problem wasn't introduced by this patch, but as noted in the commit
message, the adapter can change data_len between reads. Can this still lead
to ring buffer corruption?

In drivers/scsi/arcmsr/arcmsr_hba.c:arcmsr_iop2drv_data_wrote_handle(),
the first fetch checks available space:

	if (buf_empty_len >=3D readl(&prbuffer->data_len)) {
		if (arcmsr_Read_iop_rqbuffer_data(acb, prbuffer) =3D=3D 0)

Then here in arcmsr_Read_iop_rqbuffer_in_DWORD() (and similarly in
arcmsr_Read_iop_rqbuffer_data()), data_len is fetched again directly from
MMIO.

If the firmware changes the value from a small size (e.g., 4) to 124 between
the two reads, it bypasses the buf_empty_len check. Even though this patch
clamps the length to sizeof(prbuffer->data), it can still write up to 124 b=
ytes
into a ring buffer that lacks sufficient space.

This advances acb->rqbuf_putIndex past acb->rqbuf_getIndex. Because the ring
buffer calculation relies on the difference between these pointers, does th=
is
wrap cause previously unread messages to be silently dropped and corrupt the
message stream to userspace?

Could the length be read once in arcmsr_iop2drv_data_wrote_handle() and pas=
sed
down to the read functions to avoid the double fetch?

>  	if (iop_len > 0) {
>  		buf1 =3D kmalloc(128, GFP_ATOMIC);
>  		buf2 =3D (uint32_t *)buf1;
> @@ -2319,6 +2321,8 @@ arcmsr_Read_iop_rqbuffer_data(struct AdapterControl=
Block *acb,
>  		return arcmsr_Read_iop_rqbuffer_in_DWORD(acb, prbuffer);
>  	iop_data =3D (uint8_t __iomem *)prbuffer->data;
>  	iop_len =3D readl(&prbuffer->data_len);
> +	if (iop_len > sizeof(prbuffer->data))
> +		iop_len =3D sizeof(prbuffer->data);
>  	while (iop_len > 0) {
>  		pQbuffer =3D &acb->rqbuffer[acb->rqbuf_putIndex];
>  		*pQbuffer =3D readb(iop_data);

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/cover.1791792888.gi=
t.yhlee@isslab.korea.ac.kr?part=3D1
