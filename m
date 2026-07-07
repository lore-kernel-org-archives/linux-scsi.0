Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BF6EE3A8746
	for <linux-scsi@vger.kernel.org>; Tue,  7 Jul 2026 06:35:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1783406150; cv=none; b=CnKqLREwj5lBbkqvE1D5pfWITDbCMOH6Cc6VMGIXsMFCs9MB0ULCsaDuXhG7DPHHqHkeLslrzvuIfyeV/mbv7/hR5xbOkDF4JnDCaV7YUPTRIAdjjq6Ih3iBAbpft41d9/RNn5YVbk94hdDcSoZ0LsmEAwKUuhPRno43YlIPW7E=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1783406150; c=relaxed/simple;
	bh=3mdNhTCV/plW7n425FlPkqFdnwOZC+2rxhAVInUBkq4=;
	h=From:Subject:To:Cc:In-Reply-To:References:Content-Type:Date:
	 Message-Id; b=Au0mnCzzQuqX73R+FlY/cLU3tpmV66koQJYLru2v/ceoGWR4ausIFIlYDfKF861hErF0umleDNIdwfenopXWeT3h7jy3Ony0EwD6DL+ZuL8YrbiUbWhkCszAplBR9AfC9sU4eYlDETChl3m41lGa5KaUNejoned3UU9+rg6N50Y=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=bZpwi6R/; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="bZpwi6R/"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3A2B61F00A3A;
	Tue,  7 Jul 2026 06:35:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1783406148;
	bh=qOPEfGql6D+f+dFlx6GsPv6CWQ9TtDnIx+MB2USN0j8=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=bZpwi6R/5a1sxaEbsLODraKNXxHAo4XqgxCXoxW/zBnRsbT1732yaczE5G4rtznEv
	 bkD/H9EXUCx4GoNClnTzqzrtUW2buG6Jn/qqYgbgUMe/xE+PoVwGOf8HbRVwIS+aPQ
	 U9UD5hhdWIj6VOJXbilGTlQSztIG9BO9WiJ/otBOMeY06VNuSKAXmb6qW4qhIKwp6B
	 TNauai7KkyfBqiFA6GjJfvfHSw866SmoUSh+f2+/Y7LmKgMQbjcYh0DTUYVmhlzbFn
	 Xpzo6xjz9twgJBGbPNy6O63HpWU+iRqWBa+wmYLtUs5ZZaeYgJ9TH5r8OHp6DSGY5Z
	 NGkf10nO9PCRQ==
From: sashiko-bot@kernel.org
Subject: Re: [PATCH v3 29/88] scsi: qla2xxx: Update handling of ELS IOCBs
 for 29xx series
Reply-To: sashiko-reviews@lists.linux.dev
To: "Nilesh Javali" <njavali@marvell.com>
Cc: linux-scsi@vger.kernel.org
In-Reply-To: <20260707055435.2680300-30-njavali@marvell.com>
References: <20260707055435.2680300-1-njavali@marvell.com>
 <20260707055435.2680300-30-njavali@marvell.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Tue, 07 Jul 2026 06:35:47 +0000
Message-Id: <20260707063548.3A2B61F00A3A@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>

Thank you for your contribution! Sashiko AI review found 3 potential issue(=
s) to consider:
- [High] Hardware-facing structures use C bitfields for little-endian 16-bi=
t integers, breaking on big-endian architectures.
- [High] The extended ABTS response IOCB leaves the upper 64 bytes of the r=
eused DMA buffer uninitialized, leaking stale hardware completion data.
- [High] Virtual Port index (vp_idx) >=3D 256 is truncated and corrupted du=
ring ABTS response processing on 29xx adapters due to an invalid struct cas=
t.
--

--- Patch [29]: [PATCH v3 29/88] scsi: qla2xxx: Update handling of ELS IOCB=
s for 29xx series ---
commit 75f1549af39bd863f96218c48272faaf14654107
Author: Nilesh Javali <njavali@marvell.com>

scsi: qla2xxx: Update handling of ELS IOCBs for 29xx series

Update ELS IOCB handling to support the extended 128-byte els_entry_24xx_ext
structure used by 29xx series adapters. Change the signatures of ELS issue
paths to accept a generic void pointer and introduce a helper
qla_els_set_vp_sof() for encoding vp_index and sof_type.

> diff --git a/drivers/scsi/qla2xxx/qla_inline.h b/drivers/scsi/qla2xxx/qla=
_inline.h
> index cc613bc98e926..695a5b7fc7946 100644
> --- a/drivers/scsi/qla2xxx/qla_inline.h
> +++ b/drivers/scsi/qla2xxx/qla_inline.h
> @@ -863,3 +863,31 @@ qla_sts_fwi2_extract(struct qla_hw_data *ha, void *p=
kt,
[ ... ]
> +static inline void
> +qla_els_set_vp_sof(struct scsi_qla_host *vha, void *pkt, u16 vp_idx)
> +{
> +	if (IS_QLA29XX(vha->hw)) {
> +		struct els_entry_24xx_ext *ext =3D pkt;
> +
> +		ext->vp_index =3D vp_idx;
> +		ext->sof_type =3D ELS_EXT_EST_SOFI3;

[Severity: High]
Are C bitfields being used for a hardware-facing structure here?

If els_entry_24xx_ext uses __le16 with bitfields for vp_index and sof_type,
the memory layout will be compiler- and endian-dependent. On big-endian
architectures, the bitfields will be packed in reverse order compared to
what the little-endian hardware expects, which could corrupt the virtual
port and SOF values.

> +	} else {
> +		struct els_entry_24xx *e =3D pkt;
> +
> +		e->vp_index =3D vp_idx;
> +		e->sof_type =3D EST_SOFI3;
> +	}
> +}
> diff --git a/drivers/scsi/qla2xxx/qla_isr.c b/drivers/scsi/qla2xxx/qla_is=
r.c
> index c4e2e62f924ff..e2653620e80be 100644
> --- a/drivers/scsi/qla2xxx/qla_isr.c
> +++ b/drivers/scsi/qla2xxx/qla_isr.c
> @@ -83,6 +83,8 @@ qla24xx_process_abts(struct scsi_qla_host *vha, struct =
purex_item *pkt)
[ ... ]
>  	/* send ABTS response */
> -	abts_rsp =3D (void *)rsp_els;
> +	abts_rsp =3D rsp_pkt;
>  	memset(abts_rsp, 0, sizeof(*abts_rsp));

[Severity: High]
Could this memset clear only 64 bytes instead of the full 128 bytes allocat=
ed
for 29xx adapters?

Since abts_rsp is a pointer to the 64-byte legacy struct abts_entry_24xx,
sizeof(*abts_rsp) is 64. If the buffer was populated during the ELS_IOCB_TY=
PE
command earlier in this function, could this leave stale hardware completion
data in the upper 64 bytes when the buffer is reused for the ABTS_RSP_TYPE
command?

[Severity: High]
Further down in this function, does this legacy cast corrupt the 9th bit of
the virtual port index for 29xx adapters?

    abts_rsp->vp_idx =3D abts->vp_idx;
    abts_rsp->sof_type =3D abts->sof_type & 0xf0;

Since the 29xx hardware packs these into a single 16-bit word, the 9th bit
of vp_idx resides in the lower nibble of the byte corresponding to the lega=
cy
8-bit sof_type. Masking with 0xf0 would erase the 9th bit of vp_idx,
potentially breaking I/O aborts on virtual ports with an ID >=3D 256.

>  	abts_rsp->entry_type =3D ABTS_RSP_TYPE;
>  	abts_rsp->entry_count =3D 1;

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20260707055435.2680=
300-1-njavali@marvell.com?part=3D29
