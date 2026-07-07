Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A43A82F12A5
	for <linux-scsi@vger.kernel.org>; Tue,  7 Jul 2026 06:31:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1783405900; cv=none; b=RcMhRNHtnX+P0oNepp+WVb8hlh0Nz1AttL0Kv6Xsu1SZzLziqKQmcVmh6LliE5cezhrKw9K/C6qSMLnI7JL/EueStnan7eWJn94VvLivz65P0cXfLfWMbQAOuLJPj7lEQflq/4bPmUxVYw0/krTJgaoA97PTLZCVN5rMIA7uriM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1783405900; c=relaxed/simple;
	bh=3lTMA9Vgt6ZROG+IO34vuZxFajRhCpLoNYfwWKKJOiE=;
	h=From:Subject:To:Cc:In-Reply-To:References:Content-Type:Date:
	 Message-Id; b=l/Y08kZBMl8TMvZOmtAXjsDU2I75Z5PAXUZlmHiXzSr4OeJdAK8QhLoaGjM0iFObYkZOSsxxQddAjhvQhAAByqefmsXITsMPYXLZTcIiZxXt1DOQAKZZoOMuXt7cXCC4p2KKsGpOyk5nGk9lTKUBZmvxCm6w2Sr/Rk4dbphA6Fo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=EYBYQg3C; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="EYBYQg3C"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5DF101F00ACA;
	Tue,  7 Jul 2026 06:31:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1783405899;
	bh=cHi/dHTZ7AHoDWgItcNIe+pzc1wxRyVaaj2pI1/jKYk=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=EYBYQg3CW8wwUIA+bfrCXI8xcWumQSJzafCXx3Va0zjR3LUOOWIJfFMTkyegGbwMG
	 6RTROBDG/zJRZbSnXFNnmmzcCftMnTBh5MOV5JOeKMnWExzFJkm63kmtGfP8gJlSdq
	 WY+B2bRTQyMfDbXxpXaQ85GGEiXHh+cGlHGNC84Li2KEOekztFvEVgqu+9FnXJcE+K
	 IeKjvhV4JO3h9NQVURpSorUDS1La9DKsNlTH+eNEagWLM/dXmajemVrDqRUfphLtMn
	 EeoTh4Jos6YBwdb1K1Fp76IVeaTE5zEErgmBkWtj0MEUI9Ud9zBo45jtIx5BErzCNy
	 f7qpkvciRQv/w==
From: sashiko-bot@kernel.org
Subject: Re: [PATCH v3 30/88] scsi: qla2xxx: Add size check for ELS status
 entry layout on 29xx
Reply-To: sashiko-reviews@lists.linux.dev
To: "Nilesh Javali" <njavali@marvell.com>
Cc: linux-scsi@vger.kernel.org
In-Reply-To: <20260707055435.2680300-31-njavali@marvell.com>
References: <20260707055435.2680300-1-njavali@marvell.com>
 <20260707055435.2680300-31-njavali@marvell.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Tue, 07 Jul 2026 06:31:38 +0000
Message-Id: <20260707063139.5DF101F00ACA@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>

Thank you for your contribution! Sashiko AI review found 1 potential issue(=
s) to consider:
- [High] Hardware DMA structures use C bit-fields which break cross-archite=
cture endianness safety.
--

--- Patch [30]: [PATCH v3 30/88] scsi: qla2xxx: Add size check for ELS stat=
us entry layout on 29xx ---
commit be1adf44a1c5565c9a85fa67802469ba04fa81af
Author: Nilesh Javali <njavali@marvell.com>

scsi: qla2xxx: Add size check for ELS status entry layout on 29xx

Add a BUILD_BUG_ON in qla2x00_module_init() to validate that struct
els_sts_entry_24xx_ext is 128 bytes, matching the 29xx firmware IOCB
size. It also documents the overlay layout in qla24xx_els_ct_entry().

> diff --git a/drivers/scsi/qla2xxx/qla_isr.c b/drivers/scsi/qla2xxx/qla_is=
r.c
> index e2653620e80be..c286465ae013d 100644
> --- a/drivers/scsi/qla2xxx/qla_isr.c
> +++ b/drivers/scsi/qla2xxx/qla_isr.c
> @@ -2359,6 +2359,22 @@ static void
>  qla24xx_els_ct_entry(scsi_qla_host_t *v, struct req_que *req,
>  		     void *pkt, int iocb_type)
>  {
> +	/*
> +	 * els_sts_entry_24xx_ext (29xx) overlays els_sts_entry_24xx for every
> +	 * field touched in this completion handler: comp_status (offset 8),
> +	 * total_byte_count (32), error_subcode_1 (36), error_subcode_2 (40),
> +	 * d_id[]/s_id[] (24..29), control_flags (30) all sit at byte-identical
> +	 * offsets in both layouts (only vp_index/sof_type at offset 14-15 are
> +	 * bit-packed differently, and that field is write-only on the issue

[Severity: High]
Does this bit-packing break cross-architecture endianness safety for the
hardware DMA structures?

The documentation mentions that vp_index/sof_type are bit-packed, and
looking at the struct definition for els_entry_24xx_ext:

drivers/scsi/qla2xxx/qla_fw29.h:
	__le16	vp_index : 9;		/* VP Index 9bits */
	__le16	reserved_1_sof : 3;
	__le16	sof_type : 4;

And how it is written to the structure:

drivers/scsi/qla2xxx/qla_inline.h:qla_els_set_vp_sof() {
	struct els_entry_24xx_ext *ext =3D pkt;

	ext->vp_index =3D vp_idx;
	ext->sof_type =3D ELS_EXT_EST_SOFI3;
}

Since C standard bit-field layout depends on the compiler's ABI and
endianness, won't this result in garbled values being sent to the 29xx
hardware on big-endian systems?

Could this be updated to use an integer type like __le16 with explicit
bitwise shifts and masks instead of C bit-fields?

> +	 * path -- we never read it here). All reads in this function are
> +	 * therefore stride-agnostic and go through a single struct

[ ... ]

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20260707055435.2680=
300-1-njavali@marvell.com?part=3D30
