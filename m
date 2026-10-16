Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9C97F4C6D
	for <linux-scsi@vger.kernel.org>; Fri, 16 Oct 2026 08:44:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1792140246; cv=none; b=ks6ZFXNfp3kwr0oIRqo7+8FScop9/KkRYGZC4vVAXJ9z0dPjWjGT0ihFquFpsgm493BtHXVCqSVTW4MkXEW/UIE8y1/xZnEoSHIv5fwgjiFubxIayjPsBXE06fQyNYndaUTjXRL3EdeKp70gPh+pXfLLWGgpBxXJklg4PG1pOsQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1792140246; c=relaxed/simple;
	bh=W6YSX3GaugpXQZw+eqQkAU3APUPvTEKGSRCT+bQMiyw=;
	h=Message-ID:From:Subject:To:Cc:In-Reply-To:References:Content-Type:
	 Date; b=oi/SvNlBn893Q/DPEnKUQKccjObZpaEt/NIGEH1Kf3iYVhDzzW1PhD5MrxaD82DI4FU58GR5/E7bWMBURhGfz2Q/UsPUN5g/vJktH9BScyfoZjSUylAnDXNQHY1f/T/Or/Ar+DyoKHVi4f+TeHmmKBSZoVUqe/wFvM6XFhhnnn0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=d9HAtMvv; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="d9HAtMvv"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D25591F000C5;
	Fri, 16 Oct 2026 08:44:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1792140244;
	bh=wLOKjqkBVvjtqZPNs3DOnbnnXbw+xwCqP6NnOkGEOF0=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=d9HAtMvvUpnU7Gh2l+/MiUJORjmlI7pfIk/XyA9HhKrUkqkJDjaYKl4XNn2+uPE3l
	 ZPdej5vrjiMPWYoVHMwTX6pHVEh1FdiIICHrJjuDp4FcV8JF5KPXvMH4B6uGEL9WxE
	 h51g4NnOgZva0tYUjaK/DqoO+aStDiE4x10ejGw5GeWO9NCJMueElM2ZGQcW3VSlBm
	 h61I6nO0shWGLVN9lKh+tIxQ/NJtToP7U2+HeGjEHMx6FoDDPfKaDJwIkmFW3e5DSn
	 Fd/oe1dzZ88osgIe4BjSUG7RgIJdZARc6+MLEZHecMvMc5Rsf7rdPRlaXJETX0xnyM
	 US0YcsP/TSa+g==
Message-ID: <sashiko-outbox-174029@kernel.org>
From: sashiko-bot@kernel.org
Subject: Re: [PATCH v4 2/3] scsi: bfa: drop unsolicited frames shorter than
 their VFT header
Reply-To: sashiko-reviews@lists.linux.dev
To: "Yehyeong Lee" <yhlee@isslab.korea.ac.kr>
Cc: linux-scsi@vger.kernel.org
In-Reply-To: <20261016082818.1237059-3-yhlee@isslab.korea.ac.kr>
References: <20261016082818.1237059-1-yhlee@isslab.korea.ac.kr>
 <20261016082818.1237059-3-yhlee@isslab.korea.ac.kr>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Fri, 16 Oct 2026 08:44:03 +0000
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>

Thank you for your contribution! Sashiko AI review found 1 potential issue(=
s) to consider:
- [High] scsi: bfa: Incomplete bounds checking in bfa_fcs_uf_recv leads to =
out-of-bounds reads
--

commit 5c4d11be4a4f404e42897f255d18569a1acd5b93
Author: Yehyeong Lee <yhlee@isslab.korea.ac.kr>

scsi: bfa: drop unsolicited frames shorter than their VFT header

This patch fixes an integer underflow by checking that the received frame
length is at least the size of the virtual fabric tagging (VFT) header
before attempting to step over it in bfa_fcs_uf_recv().

> diff --git a/drivers/scsi/bfa/bfa_fcs.c b/drivers/scsi/bfa/bfa_fcs.c
> index 9b57312f43f50..711d2ed83a7aa 100644
> --- a/drivers/scsi/bfa/bfa_fcs.c
> +++ b/drivers/scsi/bfa/bfa_fcs.c
> @@ -1552,6 +1552,11 @@ bfa_fcs_uf_recv(void *cbarg, struct bfa_uf_s *uf)
>  		/*
>  		 * skip vft header
>  		 */
> +		if (len < sizeof(struct fc_vft_s)) {
> +			bfa_uf_free(uf);
> +			return;
> +		}
> +

[Severity: High]
Does this check occur too late to prevent out-of-bounds reads?

Before reaching this new bounds check, the function already accesses fields
from the frame buffer to check for the VFT header:

	if (fchs->routing =3D=3D FC_RTG_EXT_HDR &&
	    fchs->cat_info =3D=3D FC_CAT_VFT_HDR) {
		bfa_stats(fcs, uf.tagged);
		vft =3D bfa_uf_get_frmbuf(uf);
		if (fcs->port_vfid =3D=3D vft->vf_id)

If the frame is shorter than 8 bytes, could these accesses read uninitializ=
ed
or stale DMA memory?

>  		fchs =3D (struct fchs_s *) (vft + 1);
>  		len -=3D sizeof(struct fc_vft_s);
> =20

Does this code need to verify that the remaining frame length can hold the
mandatory 24-byte inner fchs_s header?

Without checking that the remaining len is at least sizeof(struct fchs_s),
truncated frames are passed to downstream handlers. For example, in
bfa_fcs_fabric_uf_recv(), the pointer is unconditionally cast and accessed:

	u32 pid =3D fchs->d_id;
	struct fc_els_cmd_s *els_cmd =3D (struct fc_els_cmd_s *) (fchs + 1);

Could this process stale ghost data as valid protocol commands and confuse =
the
state machine?

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20261016082818.1237=
059-1-yhlee@isslab.korea.ac.kr?part=3D2
