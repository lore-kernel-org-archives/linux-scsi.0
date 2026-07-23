Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1DE8533C18B
	for <linux-scsi@vger.kernel.org>; Thu, 23 Jul 2026 14:25:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784816760; cv=none; b=PsEmarfNNxntxAgJzz8NrKNKQ8v5oeb4Qduisw9AExjn2+2UQ1yuNkzgefQb5NF/p5x4VaBFmsdnPceh8uKt5CAPrCPNRPhjBHQ2VGWDxllH59FRa6S9qRHQlinZPVDEqRrrwzb8TWHff8hXxmETk6HE9QAbLS1Fc9dOkkBK3Fk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784816760; c=relaxed/simple;
	bh=1qgByQWE3ZxOSVCQF7FOa8M5o4f6XYZjkip/WY5/Clw=;
	h=From:Subject:To:Cc:In-Reply-To:References:Content-Type:Date:
	 Message-Id; b=jME4IOm1Mw5xlfz98VQ7vf3yNJ74CzjAhCRnO5XSmWUCWOIf4fp4ZG4OZ5AmhfBmKkXK0vvGEtJYOJxGAa7+gXIwjeXQC6D54eu3WraRCBVYPvStoXBQvo5RvG3Ub0KqEKTjuHoV3IhpDx0T3vGf5lfYRTccQLboe9CHsz6L7a4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=DQzvd5L+; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="DQzvd5L+"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id F3FF71F000E9;
	Thu, 23 Jul 2026 14:25:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1784816758;
	bh=sYLBWuUVeNEpKh3JVpnBTepXFZnr9yN6Ej7RuY1kY18=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=DQzvd5L+/rq3sXvB3Ey7blmDP2cX/9UtoAy5Gl1SEkW6d+14UrXLlZvn6G3//1frr
	 TPnCvM2iXYl/Yaa9y7xvdBHkJPRXxJo6IQOrtXYXAulLIeXoaMSvMuhhQ6RxEK5F/a
	 TOyUL0gDERPL/qMsrQk4dlIaH8I4u9xwmyAKHx2OzcfauvX2I4JfcjzSckPz5V63cy
	 Un6yEASuBFb5RFr8I6B73NZ+AmuPubtgjzRH+tm6Pe3AKTyeAedjIkezNIBMkBW/kk
	 1cTniXhs0XZKr88pZ1g8/uPW219iNlanEBSkdfaPQu8NhmQthfoHyROdFoubXH1e96
	 NM/O0M6VXgvSA==
From: sashiko-bot@kernel.org
Subject: Re: [PATCH v6 29/56] scsi: qla2xxx: Update handling of ELS IOCBs
 for 29xx series
Reply-To: sashiko-reviews@lists.linux.dev
To: "Nilesh Javali" <njavali@marvell.com>
Cc: linux-scsi@vger.kernel.org
In-Reply-To: <20260723050413.3897522-30-njavali@marvell.com>
References: <20260723050413.3897522-1-njavali@marvell.com>
 <20260723050413.3897522-30-njavali@marvell.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Thu, 23 Jul 2026 14:25:50 +0000
Message-Id: <20260723142557.F3FF71F000E9@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>

Thank you for your contribution! Sashiko AI review found 3 potential issue(=
s) to consider:
- [Critical] The `els_entry_24xx_ext` structure uses C bitfields for `vp_in=
dex` and `sof_type` over an `__le16` type, which violates kernel hardware i=
nterface standards and causes endianness corruption.
- [High] In `qla24xx_process_abts()`, the driver formats the ABTS response =
for 29xx adapters using the legacy 64-byte `abts_entry_24xx` layout, which =
truncates the 9-bit `vp_idx` to 8 bits.
- [High] The intermediate `struct qla_els_pt_arg` defines `vp_idx` as a `u8=
`, which truncates the new 9-bit virtual port indices on 29xx adapters.
--

--- Patch [29]: [PATCH v6 29/56] scsi: qla2xxx: Update handling of ELS IOCB=
s for 29xx series ---
commit d16d36ca3053582bede2c0cc15922ffd29809f7f
Author: Nilesh Javali <njavali@marvell.com>

scsi: qla2xxx: Update handling of ELS IOCBs for 29xx series

Update ELS IOCB handling to support the extended 128-byte
els_entry_24xx_ext structure used by 29xx series adapters.

> diff --git a/drivers/scsi/qla2xxx/qla_inline.h b/drivers/scsi/qla2xxx/qla=
_inline.h
> index 49b858e7cf2a1..2ade5e8522516 100644
> --- a/drivers/scsi/qla2xxx/qla_inline.h
> +++ b/drivers/scsi/qla2xxx/qla_inline.h
[ ... ]
> @@ -863,3 +863,31 @@ qla_sts_fwi2_extract(struct qla_hw_data *ha, void *p=
kt,
> +static inline void
> +qla_els_set_vp_sof(struct scsi_qla_host *vha, void *pkt, u16 vp_idx)
> +{
> +	if (IS_QLA29XX(vha->hw)) {
> +		struct els_entry_24xx_ext *ext =3D pkt;
> +
> +		ext->vp_index =3D vp_idx;
> +		ext->sof_type =3D ELS_EXT_EST_SOFI3;

[Severity: Critical]
Will this cause endianness corruption on big-endian architectures?

Hardware descriptors sent to the device should generally avoid C bitfields
like vp_index and sof_type over an __le16 type, as memory layout is
compiler- and endian-dependent. A native assignment here might generate
host-endian accesses instead of proper little-endian hardware writes, which
could cause the adapter to read garbled virtual port indices and SOF types.

> +	} else {
> +		struct els_entry_24xx *e =3D pkt;
> +
> +		e->vp_index =3D vp_idx;
> +		e->sof_type =3D EST_SOFI3;
> +	}
> +}

> diff --git a/drivers/scsi/qla2xxx/qla_iocb.c b/drivers/scsi/qla2xxx/qla_i=
ocb.c
> index 7315bc4df00e4..ab4f5f1ec73fc 100644
> --- a/drivers/scsi/qla2xxx/qla_iocb.c
> +++ b/drivers/scsi/qla2xxx/qla_iocb.c
[ ... ]
> @@ -3322,9 +3323,10 @@ qla24xx_els_dcmd2_iocb(scsi_qla_host_t *vha, int e=
ls_opcode,
> =20
>  /* it is assume qpair lock is held */
>  void qla_els_pt_iocb(struct scsi_qla_host *vha,
> -	struct els_entry_24xx *els_iocb,
> -	struct qla_els_pt_arg *a)
> +	void *pkt, struct qla_els_pt_arg *a)
>  {
> +	struct els_entry_24xx *els_iocb =3D pkt;
> +
[ ... ]
> -	els_iocb->vp_index =3D a->vp_idx;
> -	els_iocb->sof_type =3D EST_SOFI3;
>  	els_iocb->rx_dsd_count =3D cpu_to_le16(0);
>  	els_iocb->opcode =3D a->els_opcode;
> =20
> +	qla_els_set_vp_sof(vha, pkt, a->vp_idx);

[Severity: High]
Could this pass a truncated virtual port index for 29xx adapters?

In qla_def.h, struct qla_els_pt_arg defines vp_idx as a u8. Since 29xx
adapters use a 9-bit virtual port index, will assigning a->vp_idx
truncate values >=3D 256 before they are passed to qla_els_set_vp_sof()?

This might cause ELS passthrough commands to execute on the wrong virtual
port.

> diff --git a/drivers/scsi/qla2xxx/qla_isr.c b/drivers/scsi/qla2xxx/qla_is=
r.c
> index 75ce09933afc1..404dcb24b6887 100644
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
>  	abts_rsp->entry_type =3D ABTS_RSP_TYPE;
>  	abts_rsp->entry_count =3D 1;

[Severity: High]
Does this code still format the ABTS response for 29xx adapters using the
legacy 64-byte abts_entry_24xx layout?

If abts_rsp casts rsp_pkt to struct abts_entry_24xx, reading and writing the
8-bit abts->vp_idx later in this function might discard the 9th bit. Would
this cause virtual port indices > 255 to be modulo-256 truncated, routing
ABTS responses to the wrong tenant's virtual port?

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20260723050413.3897=
522-1-njavali@marvell.com?part=3D29
