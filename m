Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D31D1175A6C
	for <linux-scsi@vger.kernel.org>; Fri, 17 Jul 2026 16:17:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784305046; cv=none; b=jc+O6HaMvVsOcqPOL/lhUCQesXZ1qbgFfjQYiFmM7IguWj2LGTPcdaSaf45UUhxxRjzQewMIXf5L08Zxmy6JB/MAuFBeMR+jGS7/JjqP6/S4nkunikPT/j0zzkulPC9/GcBR0dTZMAjRypL38oSLnBgA5X+nXleqO1/aON8KJjw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784305046; c=relaxed/simple;
	bh=cnw7qhtpolP22LSijNUg13axWLqd+RrIkKtLDRjnEAU=;
	h=From:Subject:To:Cc:In-Reply-To:References:Content-Type:Date:
	 Message-Id; b=VlWY5I0jxmziVA8OfUZB8923lJVNI9StB/3+MJw66IXsk08ljNlQwns5hhnMrxVGHdotTIguNRDe9PWnhdGMpv12wGezEjnMgM6kSg2yy2hsi05QIrj29i4ZAJC6NnOBHOL0MeEd2oZVXC4StCKGOYm3cLxiFM7mxdyOusuDUsE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=FDNBHkox; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="FDNBHkox"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 596F81F000E9;
	Fri, 17 Jul 2026 16:17:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1784305044;
	bh=FmjGciNexN1ZhEOrl0+A8zF5nilOjW4hdK0ifSIpIuU=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=FDNBHkoxr7liSEalvyuRDjwMZqwK0sD2gCGlRhXUU/vHnzTOQjxWiuIFVj/ov3JIE
	 LCTWADLrFBNJNcKqBRRxq5ga4z5BnQv9w53nLSzWH3UZ1rBR8KYdYrCZRnVCvSDp/0
	 CFMzMmNm2Kw3u7b0JuG3mrbOFOBv+cH80lJkHOnb7PDRocaFDar8qACYp86vi62Z+e
	 JRRAUuRCaut8aR9BvSq55jchnROYI0oxcYieIx8n6iy/OqFjrUpf8m1NieH3u7VXSZ
	 5ozZD6NCuJWUFUOYtvMvBaSLmDV8qBYJaDYVy6ACHJyD2W2H1hXhC6e7aatrJuS5A9
	 9l5y2+KQWjbZQ==
From: sashiko-bot@kernel.org
Subject: Re: [PATCH v5 29/56] scsi: qla2xxx: Update handling of ELS IOCBs
 for 29xx series
Reply-To: sashiko-reviews@lists.linux.dev
To: "Nilesh Javali" <njavali@marvell.com>
Cc: linux-scsi@vger.kernel.org
In-Reply-To: <20260717152904.3155730-30-njavali@marvell.com>
References: <20260717152904.3155730-1-njavali@marvell.com>
 <20260717152904.3155730-30-njavali@marvell.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Fri, 17 Jul 2026 16:17:23 +0000
Message-Id: <20260717161724.596F81F000E9@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>

Thank you for your contribution! Sashiko AI review found 3 potential issue(=
s) to consider:
- [High] Endianness portability bug in `qla_els_set_vp_sof()` due to native=
 C bitfield assignments on a `__le16` hardware struct field.
- [High] Incomplete 29xx hardware support in `qla24xx_process_abts()` uses =
the legacy 24xx struct layout for the ABTS response, truncating the virtual=
 port index and corrupting the descriptor.
- [Medium] Partial zeroing of the reused DMA buffer in `qla24xx_process_abt=
s()` leaves upper 64 bytes uninitialized for 29xx adapters.
--

--- Patch [29]: [PATCH v5 29/56] scsi: qla2xxx: Update handling of ELS IOCB=
s for 29xx series ---
commit 0508a9076a015bdb2b8eca42fabd1c2776bb924b
Author: Nilesh Javali <njavali@marvell.com>

scsi: qla2xxx: Update handling of ELS IOCBs for 29xx series

This commit updates ELS IOCB handling to support the extended 128-byte
els_entry_24xx_ext structure for 29xx series adapters. It modifies several
functions to take generic void pointers and introduces a helper to handle
24xx vs 29xx bitfield encoding.

> diff --git a/drivers/scsi/qla2xxx/qla_inline.h b/drivers/scsi/qla2xxx/qla=
_inline.h
> --- a/drivers/scsi/qla2xxx/qla_inline.h
> +++ b/drivers/scsi/qla2xxx/qla_inline.h
[ ... ]
> @@ -863,3 +863,31 @@ qla_sts_fwi2_extract(struct qla_hw_data *ha, void *p=
kt,
>  		host_to_fcp_swap(s->data, sizeof(s->data));
>  	}
>  }
> +
> +/*
> + * qla_els_set_vp_sof() - write the vp_index / sof_type pair into an ELS
> + *    pass-through IOCB (els_entry_24xx{,_ext}).
> + *
> + * Both layouts have the same 16-bit slot at offset 14, but it is encoded
> + * differently:
> + *   - 24xx: separate u8 vp_index + u8 sof_type with EST_SOFI3 (1 << 4)
> + *   - 29xx: __le16 with bitfields { vp_index:9, reserved_1_sof:3,
> + *           sof_type:4 } and ELS_EXT_EST_SOFI3
> + * so this is the single point in the driver that knows about that
> + * encoding split.
> + */
> +static inline void
> +qla_els_set_vp_sof(struct scsi_qla_host *vha, void *pkt, u16 vp_idx)
> +{
> +	if (IS_QLA29XX(vha->hw)) {
> +		struct els_entry_24xx_ext *ext =3D pkt;
> +
> +		ext->vp_index =3D vp_idx;
> +		ext->sof_type =3D ELS_EXT_EST_SOFI3;

[Severity: High]
Does this code introduce an endianness bug on big-endian architectures?

The 29xx extended ELS struct defines these fields as C bitfields inside a
__le16 type. On big-endian architectures like s390x or PowerPC, the compiler
will place these bitfields in the most significant bits of the 16-bit word,
reversing the layout expected by the little-endian hardware.

Could this corrupt the descriptor DMA'd to the firmware, causing ELS
commands to be rejected or misrouted?

> +	} else {
> +		struct els_entry_24xx *e =3D pkt;
> +
> +		e->vp_index =3D vp_idx;
> +		e->sof_type =3D EST_SOFI3;
> +	}
> +}
[ ... ]
> diff --git a/drivers/scsi/qla2xxx/qla_isr.c b/drivers/scsi/qla2xxx/qla_is=
r.c
> --- a/drivers/scsi/qla2xxx/qla_isr.c
> +++ b/drivers/scsi/qla2xxx/qla_isr.c
[ ... ]
> @@ -131,7 +140,7 @@ qla24xx_process_abts(struct scsi_qla_host *vha, struc=
t purex_item *pkt)
>  	}
> =20
>  	/* send ABTS response */
> -	abts_rsp =3D (void *)rsp_els;
> +	abts_rsp =3D rsp_pkt;
>  	memset(abts_rsp, 0, sizeof(*abts_rsp));

[Severity: Medium]
Will this memset only clear the first 64 bytes of the newly allocated
128-byte buffer on 29xx hardware?

Since abts_rsp is cast to the legacy 64-byte struct abts_entry_24xx,
sizeof(*abts_rsp) evaluates to 64. The remaining 64 bytes of the 128-byte
buffer may contain stale data from the prior firmware interaction, which
could then be sent back to the hardware.

[Severity: High]
Is the 29xx hardware fully supported by the ABTS response logic here?

While the buffer is allocated dynamically for 128 bytes, the struct parsing
and formatting logic casts the buffer to the legacy struct abts_entry_24xx.
For 29xx hardware, vp_idx and sof_type are packed into a 16-bit field, but
the legacy struct uses two 8-bit fields.

Writing to the 8-bit sof_type and masking it:

abts_rsp->vp_idx =3D abts->vp_idx;
abts_rsp->sof_type =3D abts->sof_type & 0xf0;

will overwrite the 9th bit of vp_index, silently truncating it to 8 bits.

Could this cause NPIV port traffic for virtual ports with an index > 255 to
be misrouted or dropped?

>  	abts_rsp->entry_type =3D ABTS_RSP_TYPE;
>  	abts_rsp->entry_count =3D 1;

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20260717152904.3155=
730-1-njavali@marvell.com?part=3D29
