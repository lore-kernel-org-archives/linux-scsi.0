Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6CEF72E739C
	for <linux-scsi@vger.kernel.org>; Fri, 12 Jun 2026 11:15:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1781262921; cv=none; b=GjoXZDrV8spkLLh+dQUlahcKV87W+XiHV/uOIr3vW9Z70g308+DiLBVGlnw55yEQBBShPtLkoTdn5WzX93O+17EbPqkswI7lzaucvG0eBm1WlvjW00QjBvLxRL+PnW1BowGRIV6xwQQfvmWB9T7QSUenkAUz9ov+MVy0x1lZZgA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1781262921; c=relaxed/simple;
	bh=JyUb7z8WhBPlKqcQxVyBNKBLn3whCjSRvM+3msVxXd4=;
	h=From:Subject:To:Cc:In-Reply-To:References:Content-Type:Date:
	 Message-Id; b=YeODj1kVu80+/v0E2Bz9Wxjt2/D62QTf5vut9B9W7ueIeWvBhJ1jw8XgsZPe36rb5ELkQrDW8VvPDo9DTgBEQh2iFqDPuPvAOkffGat25W88gF4g66emwlsdwINTkC72t0eazA7v43S4S3l1+6qQK9nz7ZB+Q1q4Pq64+lNF0jY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=IneTuHRU; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="IneTuHRU"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E69771F000E9;
	Fri, 12 Jun 2026 11:15:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1781262920;
	bh=KF3rCuDp5+S7V3YDCV3GbVw7CXXA6WkJQVB5iGli5BE=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=IneTuHRU9sScOlCzRQtPT6eeSvAG8zm8tp2nWdDmdfJ7QcthHAHr+a3uUBEYmfCjW
	 u2EAwGInGJ4OVYNqy4xATey1q/gYe44EEJJ9j19bKeGnmUI14UN5xKcSXdrZ2OqRZe
	 kqaL/rBOpKDgGDUwaw9TyTXMGJz6d+tUxzFcfdQzp9/cG3Rx/mttgh+knhaX5bar/3
	 0Cdz2XZ5hJe/KKcjqfBlVLCznmbm432DMw5Am9uoSkqFVag0U28hE3EReeI7D0Wv7h
	 AHi5ad7Gvi4jV6zDMeqhXye/a6thpR1H8lc6UIzeKEn9+0qzjIUYuyLmtbHFv0qOCL
	 JZUaLjp2NDPmw==
From: sashiko-bot@kernel.org
Subject: Re: [PATCH v2 36/60] scsi: qla2xxx: Add abort command handling for
 29xx series
Reply-To: sashiko-reviews@lists.linux.dev
To: "Nilesh Javali" <njavali@marvell.com>
Cc: linux-scsi@vger.kernel.org
In-Reply-To: <20260612095333.1666592-37-njavali@marvell.com>
References: <20260612095333.1666592-37-njavali@marvell.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Fri, 12 Jun 2026 11:15:19 +0000
Message-Id: <20260612111519.E69771F000E9@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>

Thank you for your contribution! Sashiko AI review found 1 potential issue(=
s) to consider:
- [Low] Type-bounds violation in memset() causes static analysis warnings.
--

commit 1b38e59bc3182cc17053adca01767c3b67880da0
Author: Nilesh Javali <njavali@marvell.com>

scsi: qla2xxx: Add abort command handling for 29xx series

This commit extends the abort-IOCB code path to support the 29xx extended
abort_entry_24xx_ext structure alongside the existing abort_entry_24xx.
It widens function signatures to accept void pointers and updates memset
operations to use the appropriate ring-slot size.

> diff --git a/drivers/scsi/qla2xxx/qla_iocb.c b/drivers/scsi/qla2xxx/qla_i=
ocb.c
> --- a/drivers/scsi/qla2xxx/qla_iocb.c
> +++ b/drivers/scsi/qla2xxx/qla_iocb.c
> @@ -3866,32 +3866,50 @@ qla82xx_start_scsi(srb_t *sp)
>  static void
> -qla24xx_abort_iocb(srb_t *sp, struct abort_entry_24xx *abt_iocb)
> +qla24xx_abort_iocb(srb_t *sp, void *pkt)
>  {
>  	struct srb_iocb *aio =3D &sp->u.iocb_cmd;
>  	scsi_qla_host_t *vha =3D sp->vha;
> +	struct qla_hw_data *ha =3D vha->hw;
>  	struct req_que *req =3D sp->qpair->req;
>  	srb_t *orig_sp =3D sp->cmd_sp;
> +	struct abort_entry_24xx *abt =3D pkt;
> =20
> -	memset(abt_iocb, 0, sizeof(struct abort_entry_24xx));
> +	/*
> +	 * abort_entry_24xx_ext overlays abort_entry_24xx through
> +	 * req_que_no (offsets 0-17).  After that the layouts diverge:
> +	 * the 24xx variant has 30 bytes of reserved_1 followed by
> +	 * port_id[3] and a u8 vp_index at offsets 48-51, while the
> +	 * ext variant places a __le16 vp_index at offset 18 and has
> +	 * no port_id field.  Common-header writes go through one
> +	 * struct abort_entry_24xx * view; only port_id / vp_index
> +	 * branch on stride.
> +	 */
> +	memset(abt, 0, qla_req_entry_size(ha));

[Severity: Low]
Does this memset cause static analysis or compiler warnings regarding buffer
overflows?

The abt pointer is statically typed as struct abort_entry_24xx which is 64
bytes, but qla_req_entry_size(ha) can return 128 bytes for 29xx hardware.

While the underlying memory from pkt is correctly sized at 128 bytes and
won't cause a runtime memory safety issue, writing past the static type
bounds of abt can trigger -Wstringop-overflow warnings. Would it be better
to use the untyped pkt pointer for the memset instead?

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20260612095333.1666=
592-1-njavali@marvell.com?part=3D36
