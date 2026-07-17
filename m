Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 473983AC0F4
	for <linux-scsi@vger.kernel.org>; Fri, 17 Jul 2026 16:14:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784304858; cv=none; b=i0y84xucbnLIrMh9Vy2wq661rwr1qetklfHkvgjM5vx0rMFKnxQhAQEeuiQJJoCjS/+BLcI+j+qhSPjdBfexMy23qp/vKllw1GS53pzv+aKIMu0tO9wqfWK82zrVO3SRRHsLlF4oE4vemg5DZ4t2RrPV5K4RFZZGxM4JjrMF3+Q=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784304858; c=relaxed/simple;
	bh=NRNo3Nk/J4+wyWOFfvnI0MKPJOcNQ6sKYdV3U5Mbh90=;
	h=From:Subject:To:Cc:In-Reply-To:References:Content-Type:Date:
	 Message-Id; b=lGXYBPwBRfMGAgEorYZoJIPxArB/nN3OruaBTBaOIQRBx3BbCK5K5p5uTRAYGqqbq3x4fii5H5EyuXqRgcVDYkJzJJvFBjpQr4+unPYjWTmiSNl3KP1fHp92gdKubHzXtWx7NMxm4UMGHLtatJLttp0Eip0xp9VGAwhvHY/qyHQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=IcGEN/D0; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="IcGEN/D0"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 05D961F000E9;
	Fri, 17 Jul 2026 16:14:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1784304849;
	bh=0X6XToWpxYsG5CQpdktpnA3EqR1YV9WNaD1IH31yreI=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=IcGEN/D022tRrx1jKLsSS/e4R9BJDeFxcuit2OmDJHyrRYkCrn+DEq7vqeJUEoUoz
	 nPqMfB67T1qLB5eXtzTknx29yz15eZZD7QC4QL38ME7GM/sJwR+WLJKnov7FSZ6s3g
	 rermpN71NSK7af8cGpojrI3zX9aO5tfCWZno17kazhrZIprRfLC1DyFWPfAtJLuXrL
	 WVNvNPZ/OPqp6BlS/GRd/2mJ8HmBZY5hfae9z96u/7BFHeDCcDPc51pzddQZ9/gw7J
	 uBf4kobCWby0ZQnucR3GEvrVUtixdb4LVBYDMX5n0dcawUHhW2JuETARB4DZgx92qq
	 6Ovq9N8YXEkwg==
From: sashiko-bot@kernel.org
Subject: Re: [PATCH v5 30/56] scsi: qla2xxx: Add size check for ELS status
 entry layout on 29xx
Reply-To: sashiko-reviews@lists.linux.dev
To: "Nilesh Javali" <njavali@marvell.com>
Cc: linux-scsi@vger.kernel.org
In-Reply-To: <20260717152904.3155730-31-njavali@marvell.com>
References: <20260717152904.3155730-1-njavali@marvell.com>
 <20260717152904.3155730-31-njavali@marvell.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Fri, 17 Jul 2026 16:14:08 +0000
Message-Id: <20260717161409.05D961F000E9@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>

Thank you for your contribution! Sashiko AI review found 1 potential issue(=
s) to consider:
- [High] Hardware descriptor bit-fields in `els_entry_24xx_ext`, `els_sts_e=
ntry_24xx_ext`, and other 29xx IOCBs are fundamentally broken on Big-Endian=
 (BE) architectures.
--

--- Patch [30]: [PATCH v5 30/56] scsi: qla2xxx: Add size check for ELS stat=
us entry layout on 29xx ---
commit e3db5f38021ae8b35506a27dde8324d79fd2361c
Author: Nilesh Javali <njavali@marvell.com>

scsi: qla2xxx: Add size check for ELS status entry layout on 29xx

This patch adds a build-time assertion to validate the size of the extended
29xx ELS status entry struct. It also adds documentation detailing how the
extended struct overlays the base 24xx layout, explaining why completion
handler reads are stride-agnostic.

> diff --git a/drivers/scsi/qla2xxx/qla_isr.c b/drivers/scsi/qla2xxx/qla_is=
r.c
> index 404dcb24b6887..14b774f25b97e 100644
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
Does this bit-packing break hardware descriptor layouts on Big-Endian
architectures?

Looking at the definitions for els_entry_24xx_ext and els_sts_entry_24xx_ext
in drivers/scsi/qla2xxx/qla_fw29.h, they use C bit-fields inside an __le16
type:

	__le16	vp_index : 9;		/* VP Index 9bits */
	__le16	reserved_1_sof : 3;
	__le16	sof_type : 4;

When the driver initializes an ELS pass-through IOCB on the issue path:

drivers/scsi/qla2xxx/qla_inline.h:qla_els_set_vp_sof() {
	struct els_entry_24xx_ext *ext =3D pkt;

	ext->vp_index =3D vp_idx;
	ext->sof_type =3D ELS_EXT_EST_SOFI3;
}

Because these are C bit-fields, the compiler will pack them LSB-to-MSB on
Little-Endian architectures (which matches firmware expectations), but
MSB-to-LSB on Big-Endian architectures.

Will this cause the driver to write garbled DMA descriptors to the firmware
when issuing ELS commands on Big-Endian platforms using a 29xx adapter? Sho=
uld
these hardware DMA bit-fields be wrapped in endianness checks or
accessed via explicit bitwise shifting to ensure portability?

> +	 * path -- we never read it here). All reads in this function are
> +	 * therefore stride-agnostic and go through a single struct
> +	 * els_sts_entry_24xx * view; the trailing reserved_4[] of the extended
> +	 * layout is irrelevant on completion.
> +	 *
> +	 * Likewise els_entry_24xx_ext overlays els_entry_24xx through
> +	 * control_flags (offset 30), so the SRB_ELS_CMD_HST_NOLOGIN ctl_flags
> +	 * read below also goes through the 24xx view.
> +	 */

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20260717152904.3155=
730-1-njavali@marvell.com?part=3D30
