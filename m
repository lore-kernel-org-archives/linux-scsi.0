Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 360F6377EAC
	for <linux-scsi@vger.kernel.org>; Fri, 16 Oct 2026 08:41:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1792140063; cv=none; b=m4wG82FXGixwxfAykPV1qPv/K4nkcPkO4zuBjo/fi73GdZkzAgEYCL1XrL4KNzGSI7ASkYPT8BKwITIxijQsJPKUYgudyzmfmVDWpXuSgF6FZMNLx13KOVGH65A+u22s+a8q+YwzA2SBRCTu+BmGZcxr1/yvvAM070U22NMJRNM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1792140063; c=relaxed/simple;
	bh=nmT3P/UmNkQk+YAix56KVIPi4+PThX//iGf8/eyGnBw=;
	h=Message-ID:From:Subject:To:Cc:In-Reply-To:References:Content-Type:
	 Date; b=KmElXI7myrc7op9RwM5hijYoFdEEav0/fake8/FtKhx9NgiJrzOYTDhQfrdlyI3HbgbvTNpV1KkjGu+tFhBoLZLj+FrIe84ul0uOdGw6WUYEAsASfbOuQ/VK2x8IVLC6J31pfMbGbFmTFiMlc1ktIO8zl9rMB5EcamJMFjBBQEY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=abLNo87z; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="abLNo87z"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AC9AD1F000C4;
	Fri, 16 Oct 2026 08:41:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1792140061;
	bh=9+pZB/8FqhlzF2RpF0hM6SQUqvXSy7N7e2rKBv7VErc=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=abLNo87zCWX5wZPeOYsQ4G3PLZeywlwA2qTgXsCtFu6i9z7KbD6XAhmmTIZLB3De0
	 XXIz0Cwqx2fu2H5AEB8r2dEilZ0HfbBnLWgoVJ4Tco2jge5YOsNshsN1l39oz0yjTI
	 wmuqdEoT/0kJOAkG1OLFdMbURMbFaX6g9oZDK00X2yDdeW+9Tr107yDCitUdhUmETM
	 ncIamLEI3Tw9R+6xePG/V9VhrgIBwThKg9An/6hXFao7QCdPwzvANH9oHHRQwwqfVU
	 6MX4iAmlpHKJ5ao7KI9oWH027cJBMkWAAqJNFNGXgRj2xwk8Ls81S9H5DkvvPCfd0p
	 YwqIb5l63DgtQ==
Message-ID: <sashiko-outbox-174028@kernel.org>
From: sashiko-bot@kernel.org
Subject: Re: [PATCH v4 1/3] scsi: bfa: clamp the received unsolicited frame
 length to the buffer
Reply-To: sashiko-reviews@lists.linux.dev
To: "Yehyeong Lee" <yhlee@isslab.korea.ac.kr>
Cc: linux-scsi@vger.kernel.org
In-Reply-To: <20261016082818.1237059-2-yhlee@isslab.korea.ac.kr>
References: <20261016082818.1237059-1-yhlee@isslab.korea.ac.kr>
 <20261016082818.1237059-2-yhlee@isslab.korea.ac.kr>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Fri, 16 Oct 2026 08:41:01 +0000
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>

Thank you for your contribution! Sashiko AI review found 2 potential issue(=
s) to consider:
- [High] scsi: bfa: integer underflow causes massive OOB DMA read in bfa_fc=
s_lport_echo
- [High] scsi: bfa: missing bounds check on firmware-supplied buf_tag in uf=
_recv()
--

commit 4545309c07b7ce26f9ea539ffa38c0ea8612717f
Author: Yehyeong Lee <yhlee@isslab.korea.ac.kr>

scsi: bfa: clamp the received unsolicited frame length to the buffer

The commit addresses an issue where uf_recv() blindly accepts the
unsolicited frame length from the firmware. By capping uf->data_len to
the size of the posted buffer, it prevents out-of-bounds writes in
downstream consumers.

> diff --git a/drivers/scsi/bfa/bfa_svc.c b/drivers/scsi/bfa/bfa_svc.c
> index df33afaaa6735..1ccf2e994a671 100644
> --- a/drivers/scsi/bfa/bfa_svc.c
> +++ b/drivers/scsi/bfa/bfa_svc.c
> @@ -5453,7 +5453,7 @@ uf_recv(struct bfa_s *bfa, struct bfi_uf_frm_rcvd_s=
 *m)

[Severity: High]
Since this patch addresses untrusted firmware input by clamping m->xfr_len,
is it safe to use m->buf_tag as a direct array index?

Earlier in this same function:

drivers/scsi/bfa/bfa_svc.c:uf_recv() {
    ...
	u16 uf_tag =3D m->buf_tag;
	struct bfa_uf_s *uf =3D &ufm->uf_list[uf_tag];
    ...
	uf_buf =3D (struct bfa_uf_buf_s *)
			bfa_mem_get_dmabuf_kva(ufm, uf_tag, uf->pb_len);
    ...
}

If a buggy or malicious firmware provides an out-of-bounds buf_tag, won't t=
his
lead to out-of-bounds array accesses to ufm->uf_list and out-of-bounds DMA
segment calculations?

>  	list_del(&uf->qe);	/* dequeue from posted queue */
> =20
>  	uf->data_ptr =3D buf;
> -	uf->data_len =3D m->xfr_len;
> +	uf->data_len =3D min_t(u16, m->xfr_len, sizeof(struct bfa_uf_buf_s));
> =20
>  	WARN_ON(uf->data_len < sizeof(struct fchs_s));
> =20

[Severity: High]
If the received frame is truncated and m->xfr_len is smaller than
sizeof(struct fchs_s) (24 bytes), this warns but still processes the frame.

Will this lead to an integer underflow later? In bfa_fcs_lport_echo(),
pyld_len is calculated as:

drivers/scsi/bfa/bfa_fcs_lport.c:bfa_fcs_lport_echo() {
    ...
    pyld_len =3D rx_len - sizeof(struct fchs_s);
    ...
}

If rx_len is less than 24, pyld_len underflows. Since pyld_len is an int,
this evaluates to a negative number, bypassing the subsequent check:

    if (pyld_len > len)

The negative pyld_len is then passed to bfa_fcxp_send(), which takes a u32
reqlen. Does this implicit cast to a massive length (~4.29GB) result in a h=
uge
out-of-bounds DMA read when submitted to the firmware?

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20261016082818.1237=
059-1-yhlee@isslab.korea.ac.kr?part=3D1
