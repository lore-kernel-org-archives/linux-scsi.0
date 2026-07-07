Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E20D8321420
	for <linux-scsi@vger.kernel.org>; Tue,  7 Jul 2026 06:46:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1783406764; cv=none; b=HlXkHMDhsGaNQosQWIC5d77Dt6GDbmF1CTC3RD9x59bBp3RE57Pv6jRIk22qXrjw8OmsHRGBFhVEGqmAYLW0u63JzHj7mYtfNKKFZK9bzqsb3/Kt+Fh2Gt9jn7OXkbHXLzftPFHSVFRNnMOge4CodKU16B9vtEKQ2DL3QYWmJuI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1783406764; c=relaxed/simple;
	bh=ww3NFXkP0LtPji49rBaABTq1gO9YPK4GgbeZtc0FDBc=;
	h=From:Subject:To:Cc:In-Reply-To:References:Content-Type:Date:
	 Message-Id; b=Ef6zDG1rdcyDCSDg0TDgbHCpOKVA+RmpVQ7JB+w4eMMV1MTGDcP+Jkzqclj7eseCjeX1Q2yD8RMjbMFnJTiCKVGxKZdNrE4cyWk3kL6xO0I7y4oRlNGJS10n3ijM1gl/jfe86kW66yIAW0UBqUA0GdzBCH0m4IdwLKD1Iz1KZ+I=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=jemkbbLk; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="jemkbbLk"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8CE8C1F00A3A;
	Tue,  7 Jul 2026 06:46:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1783406762;
	bh=CDA6u8xujY8ZommqWssZHC1jQtldKspYu4KZ0jvAwT4=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=jemkbbLkoLOJ/HkTJXGnLSryG+FIVVQ0cGl7FAdOZMtb5aFYyG7Y2ynJ3wYcXzq5E
	 wthMYrnBzYOwodVVHSv5+w8sedsm1ymg0GAm5mEESwKOuvodzxIBTp2fdRIBlWVpJp
	 bhwFfGuALuGwCU3ew9jv6qVnfGP0F5eCkyrYzmC+vzvJ/3JPsozLYGchMwgf2q66y1
	 pnw4bPz9QkO65qk0aLTJ7pkwz70TgfyaSKGBvvYV3IHkYdBHaol0Bo0Ay3dDVaVnbr
	 /6c9LTRyIe0h+MuhVi+jOc1CGv0WsrvqtbVRrJcQruyywhtpkX1Xiln4l5ceK0bHc3
	 g+FtINUmYRtpw==
From: sashiko-bot@kernel.org
Subject: Re: [PATCH v3 34/88] scsi: qla2xxx: Enhance ABTS processing for
 29xx series
Reply-To: sashiko-reviews@lists.linux.dev
To: "Nilesh Javali" <njavali@marvell.com>
Cc: linux-scsi@vger.kernel.org
In-Reply-To: <20260707055435.2680300-35-njavali@marvell.com>
References: <20260707055435.2680300-1-njavali@marvell.com>
 <20260707055435.2680300-35-njavali@marvell.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Tue, 07 Jul 2026 06:46:02 +0000
Message-Id: <20260707064602.8CE8C1F00A3A@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>

Thank you for your contribution! Sashiko AI review found 2 potential issue(=
s) to consider:

New issues:
- [High] Hardware DMA structure `struct abts_entry_24xx_ext` uses C bitfiel=
ds for `vp_idx` and `sof_type`, causing silent data corruption on big-endia=
n architectures.

Pre-existing issues:
- [High] DMA buffer use-after-free and memory corruption when exchange term=
ination IOCB times out.
--

--- Patch [34]: [PATCH v3 34/88] scsi: qla2xxx: Enhance ABTS processing for=
 29xx series ---
commit f8517ffc817e63944bb6e7bda5e281dcbfefa061
Author: Nilesh Javali <njavali@marvell.com>

scsi: qla2xxx: Enhance ABTS processing for 29xx series

Use extended ABTS entry structures for 29xx series adapters to properly han=
dle
the larger 128-byte IOCB format. Introduce type-generic macros that leverage
the shared field names between abts_entry_24xx and abts_entry_24xx_ext to
avoid code duplication. Add BUILD_BUG_ON size check for struct
abts_entry_24xx_ext.

> diff --git a/drivers/scsi/qla2xxx/qla_isr.c b/drivers/scsi/qla2xxx/qla_is=
r.c
> index dd4416a3bf3ae..774ccf6b2adc8 100644
> --- a/drivers/scsi/qla2xxx/qla_isr.c
> +++ b/drivers/scsi/qla2xxx/qla_isr.c
> @@ -72,15 +72,89 @@ static inline void display_Laser_info(scsi_qla_host_t=
 *vha,

[ ... ]

> +#define QLA_BUILD_ABTS_BA_ACC(rsp, src, sof_val, fctl) do {		\
> +	memset((rsp), 0, sizeof(*(rsp)));				\
> +	(rsp)->entry_type =3D ABTS_RSP_TYPE;				\
> +	(rsp)->entry_count =3D 1;						\
> +	(rsp)->nport_handle =3D (src)->nport_handle;			\
> +	(rsp)->vp_idx =3D (src)->vp_idx;					\
> +	(rsp)->sof_type =3D (sof_val);					\

[Severity: High]
Does this assignment in QLA_BUILD_ABTS_BA_ACC cause a regression via silent
data corruption on big-endian architectures?

Because vp_idx and sof_type are defined as C bitfields within
struct abts_entry_24xx_ext (e.g. __le16 vp_idx : 9; __le16 sof_type : 4;),
their memory layout is implementation-defined and endian-dependent.

On big-endian CPUs, the compiler packs the bitfield starting from the
most-significant bit, placing vp_idx at the top of the __le16, contradicting
the hardware's fixed expectation.=20

Could this cause the hardware to receive incorrect data, leading to dropped
exchanges or failed commands?

[ ... ]

> @@ -140,60 +212,27 @@ qla24xx_process_abts(struct scsi_qla_host *vha, str=
uct purex_item *pkt)
>  	}
> =20
>  	/* send ABTS response */
> -	abts_rsp =3D rsp_pkt;
> -	memset(abts_rsp, 0, sizeof(*abts_rsp));
> -	abts_rsp->entry_type =3D ABTS_RSP_TYPE;
> -	abts_rsp->entry_count =3D 1;
> -	abts_rsp->nport_handle =3D abts->nport_handle;
> -	abts_rsp->vp_idx =3D abts->vp_idx;
> -	abts_rsp->sof_type =3D abts->sof_type & 0xf0;
> -	abts_rsp->rx_xch_addr =3D abts->rx_xch_addr;
> -	abts_rsp->d_id[0] =3D abts->s_id[0];
> -	abts_rsp->d_id[1] =3D abts->s_id[1];
> -	abts_rsp->d_id[2] =3D abts->s_id[2];
> -	abts_rsp->r_ctl =3D FC_ROUTING_BLD | FC_R_CTL_BLD_BA_ACC;
> -	abts_rsp->s_id[0] =3D abts->d_id[0];
> -	abts_rsp->s_id[1] =3D abts->d_id[1];
> -	abts_rsp->s_id[2] =3D abts->d_id[2];
> -	abts_rsp->cs_ctl =3D abts->cs_ctl;
> -	/* include flipping bit23 in fctl */
> -	fctl =3D ~(abts->f_ctl[2] | 0x7F) << 16 |
> -	    FC_F_CTL_LAST_SEQ | FC_F_CTL_END_SEQ | FC_F_CTL_SEQ_INIT;
> -	abts_rsp->f_ctl[0] =3D fctl >> 0 & 0xff;
> -	abts_rsp->f_ctl[1] =3D fctl >> 8 & 0xff;
> -	abts_rsp->f_ctl[2] =3D fctl >> 16 & 0xff;
> -	abts_rsp->type =3D FC_TYPE_BLD;
> -	abts_rsp->rx_id =3D abts->rx_id;
> -	abts_rsp->ox_id =3D abts->ox_id;
> -	abts_rsp->payload.ba_acc.aborted_rx_id =3D abts->rx_id;
> -	abts_rsp->payload.ba_acc.aborted_ox_id =3D abts->ox_id;
> -	abts_rsp->payload.ba_acc.high_seq_cnt =3D cpu_to_le16(~0);
> -	abts_rsp->rx_xch_addr_to_abort =3D abts->rx_xch_addr_to_abort;
> -	ql_dbg(ql_dbg_init, vha, 0x028b,
> -	    "Sending BA ACC response to ABTS %#x...\n",
> -	    abts->rx_xch_addr_to_abort);
> -	ql_dbg(ql_dbg_init + ql_dbg_verbose, vha, 0x028b,
> -	    "-------- ELS RSP -------\n");
> -	ql_dump_buffer(ql_dbg_init + ql_dbg_verbose, vha, 0x028b,
> -	    (uint8_t *)abts_rsp, sizeof(*abts_rsp));
> -	rval =3D qla2x00_issue_iocb(vha, abts_rsp, dma, 0);
> -	if (rval) {
> -		ql_log(ql_log_warn, vha, 0x028c,
> -		    "%s: iocb failed to execute -> %x\n", __func__, rval);
> -	} else if (abts_rsp->comp_status) {
> -		ql_log(ql_log_warn, vha, 0x028d,
> -		    "%s: iocb failed to complete -> completion=3D%#x subcode=3D(%#x,%#=
x)\n",
> -		    __func__, abts_rsp->comp_status,
> -		    abts_rsp->payload.error.subcode1,
> -		    abts_rsp->payload.error.subcode2);
> +	if (IS_QLA29XX(ha)) {
> +		struct abts_entry_24xx_ext *rsp_ext =3D rsp_pkt;
> +
> +		QLA_BUILD_ABTS_BA_ACC(rsp_ext, abts_ext,
> +		    abts_ext->sof_type, fctl);
> +		QLA_LOG_ISSUE_ABTS_RSP(vha, rsp_ext, dma, rval);
>  	} else {
> -		ql_dbg(ql_dbg_init, vha, 0x028ea,
> -		    "%s: done.\n", __func__);
> +		struct abts_entry_24xx *abts_rsp =3D rsp_pkt;
> +
> +		QLA_BUILD_ABTS_BA_ACC(abts_rsp, abts,
> +		    abts->sof_type & 0xf0, fctl);
> +		QLA_LOG_ISSUE_ABTS_RSP(vha, abts_rsp, dma, rval);
>  	}
> =20
>  	dma_free_coherent(&ha->pdev->dev, rsp_sz, rsp_pkt, dma);
>  }

[Severity: High]
This is a pre-existing issue, but does qla24xx_process_abts() in
drivers/scsi/qla2xxx/qla_isr.c have a DMA buffer use-after-free or memory
corruption if the initial exchange termination IOCB times out?

If the initial qla2x00_issue_iocb() operation to terminate the exchange tim=
es
out, it returns an error, but the hardware may still be actively reading or
preparing to read from the DMA address.=20

The driver then continues execution here, overwrites this same rsp_pkt buff=
er
via memset() in QLA_BUILD_ABTS_BA_ACC, attempts to issue it a second time f=
or
the ABTS response, and finally calls dma_free_coherent().=20

If the firmware continues processing, could it read/write to freed memory or
interpret the ABTS response data as the original termination command?

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20260707055435.2680=
300-1-njavali@marvell.com?part=3D34
