Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B2E1B1FECBA
	for <linux-scsi@vger.kernel.org>; Fri, 16 Oct 2026 06:29:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1792132174; cv=none; b=sIxntGKeI7g9M/djLbmFDrK5MSz+aiROPb98yVnLO8CD80e8schYjVa+ljzbWiIrHFubVbnlA8AOZe6Xc/kLbk/rCZqmJ/WpERgeEXRugM5ZG/QyQOp9Qa6yJ2Rgs481QZBOIqCGRnpEUfrsHrcowRqan7NarPltvRjKv7OTcwE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1792132174; c=relaxed/simple;
	bh=UJJkbyLSh+eCXNLJVdu9DmG8cwwtLP2aEsF/8Y12uM0=;
	h=Message-ID:From:Subject:To:Cc:In-Reply-To:References:Content-Type:
	 Date; b=bWqG2OvNCTkQypqFzo1f0skGE2MA8ObYKRv+idQ+2VqWxLjahlf8HgY2Mts8aiqf1Uaj89R8PyhSY3pszY8G9FhrUvCJVB6ffh6xESjwTgmbVwtuvNNcr0pfqvOEhhcDZa21sdt/W1gFHh4NrgRWj0f3yVbRUiUglTTWwrjmLzU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=nhdU+90x; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="nhdU+90x"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0B3211F000C4;
	Fri, 16 Oct 2026 06:29:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1792132173;
	bh=7TtfFyoSz8ppK1joXOfP30pwodvCOEDab3amneakt4s=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=nhdU+90xIgGP3DRksMqt8UmCADKxzaKFCIREtFQ0kdAed1GCtwMojIr53FMqa1kJs
	 M8cTbb69P6bE2jequGmX+mwJCilsRGF0WTGQMMvMi1q7yXrVQbcXZKdio+gd73N+no
	 wFf7pWIkUKfSyqVnaB5y7gjjZJ6bKcbEwXcvtGwLtaS5m8NynIQZK9DzVHnSRoykwf
	 jG29cep7u94ujOxCgsQCPQ4R+aIBNjKK7R5Or7Q6v+7m1W/B3Z/Sqf3qArShkHKnpY
	 JzNRa63Z36c6l9YvroxUx0Lzv+H6lTfFXcuRIpoG7ILGG84sKJlqaWRr3TmX1SqNlj
	 1WcZi8KxDAJRg==
Message-ID: <sashiko-outbox-173863@kernel.org>
From: sashiko-bot@kernel.org
Subject: Re: [PATCH] scsi: bfa: bound the RSCN event list by the received
 frame length
Reply-To: sashiko-reviews@lists.linux.dev
To: "Yehyeong Lee" <yhlee@isslab.korea.ac.kr>
Cc: linux-scsi@vger.kernel.org
In-Reply-To: <20261016061513.962742-1-yhlee@isslab.korea.ac.kr>
References: <20261016061513.962742-1-yhlee@isslab.korea.ac.kr>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Fri, 16 Oct 2026 06:29:32 +0000
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>

Thank you for your contribution! Sashiko AI review found 2 potential issue(=
s) to consider:
- [High] scsi: bfa: 32-bit integer underflow parses garbage RSCN events
- [High] scsi: bfa: OOB read in RSCN event parsing due to unhandled VFT hea=
der shift
--

commit bfea5cf5be4a300346bb75ad3d9d8a24a36aa0a4
Author: Yehyeong Lee <yhlee@isslab.korea.ac.kr>
Subject: scsi: bfa: bound the RSCN event list by the received frame length

This commit attempts to prevent an unbounded loop when processing RSCN
events by limiting the event list size to the received frame length and
the physical buffer capacity.

> diff --git a/drivers/scsi/bfa/bfa_fcs_lport.c b/drivers/scsi/bfa/bfa_fcs_=
lport.c
> index 8c9d423129c07..bb1a821716f38 100644
> --- a/drivers/scsi/bfa/bfa_fcs_lport.c
> +++ b/drivers/scsi/bfa/bfa_fcs_lport.c
[ ... ]
> @@ -5533,10 +5533,13 @@ bfa_fcs_lport_scn_process_rscn(struct bfa_fcs_lpo=
rt_s *port,
>  			struct fchs_s *fchs, u32 len)
>  {
>  	struct fc_rscn_pl_s *rscn =3D (struct fc_rscn_pl_s *) (fchs + 1);
> -	int             num_entries;
> +	int             num_entries, max_entries =3D 0;
>  	u32        rscn_pid;
>  	bfa_boolean_t   nsquery =3D BFA_FALSE, found;
>  	int             i =3D 0, j;
> +	u32        pl_off =3D sizeof(struct fchs_s) + sizeof(*rscn);
> +	int             buf_cap =3D (BFA_UF_BUFSZ - pl_off) /
> +				  sizeof(rscn->event[0]);

[Severity: High]
Does this buf_cap calculation overestimate the remaining buffer size?

In bfa_fcs_uf_recv(), if a VFT header is present, the fchs pointer is advan=
ced
by 8 bytes:

drivers/scsi/bfa/bfa_fcs.c:bfa_fcs_uf_recv() {
    ...
		/*
		 * skip vft header
		 */
		fchs =3D (struct fchs_s *) (vft + 1);
		len -=3D sizeof(struct fc_vft_s);
    ...
}

Because the pointer might be shifted 8 bytes into the DMA buffer, the remai=
ning
capacity from fchs to the end of the buffer is BFA_UF_BUFSZ - 8, not
BFA_UF_BUFSZ.

If a remote peer sends a crafted RSCN frame with a VFT header and a spoofed
payload length, buf_cap will be overestimated by 8 bytes. Parsing these ext=
ra
events could result in an 8-byte out-of-bounds read past the end of the buf=
fer.

> =20
>  	num_entries =3D
>  		(be16_to_cpu(rscn->payldlen) -

[Severity: High]
If a malformed network frame has payldlen < 4, does the subtraction underfl=
ow?

The calculation (be16_to_cpu(rscn->payldlen) - sizeof(u32)) promotes the
16-bit length to an unsigned size_t. On 32-bit architectures, this underflo=
ws
to a huge positive number. Divided by 4 (sizeof(rscn->event[0])), it yields
1073741823, which is then assigned to the 32-bit signed int num_entries.

> @@ -5544,6 +5547,21 @@ bfa_fcs_lport_scn_process_rscn(struct bfa_fcs_lpor=
t_s *port,
> =20
>  	bfa_trc(port->fcs, num_entries);
> =20
> +	/*
> +	 * the event list cannot run past the frame that was received, nor
> +	 * past what the unsolicited frame buffer physically holds
> +	 */
> +	if (len > pl_off)
> +		max_entries =3D (len - pl_off) / sizeof(rscn->event[0]);
> +
> +	if (max_entries > buf_cap)
> +		max_entries =3D buf_cap;
> +
> +	if (num_entries > max_entries)
> +		num_entries =3D max_entries;

[Severity: High]
By clamping the huge underflowed num_entries to max_entries without validat=
ing
that payldlen >=3D 4, does the loop now parse padding bytes or uninitialized
buffer data as legitimate network events?

If the received frame contains padding bytes (len > pl_off), max_entries wi=
ll
be greater than 0, causing the code to process garbage as valid RSCN events
instead of rejecting the invalid frame entirely.

> +
> +	bfa_trc(port->fcs, max_entries);
> +
>  	port->stats.num_rscn++;

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20261016061513.9627=
42-1-yhlee@isslab.korea.ac.kr?part=3D1
