Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E992E2F7F1E
	for <linux-scsi@vger.kernel.org>; Tue, 14 Jul 2026 14:21:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784038919; cv=none; b=bhtjWYbwaamDB51kGMuN0O5lX88izpfQFSs2DnGEXqsXIPQ6opc1cLOLn7U2SvzdXpmTc71w9cxwMLmL7XuEjGgZzrcXpxPcilKbUieW5675yM2hEY9s6zzCj1BP7wL9fs8dXMf2OcgcB32HMrdS+IPhkjtWZJy+OG4jLhDha50=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784038919; c=relaxed/simple;
	bh=iO+UrgKFhct5hE/Diku9mMN4Wm3qk6iq5XmdS6F6FtM=;
	h=From:Subject:To:Cc:In-Reply-To:References:Content-Type:Date:
	 Message-Id; b=IvXXf/g3ycVxvqslYAXnjm/qM3rPB/SAWADPKX5yPfZRfjHBkXyAyXyd1wv1GehKKKKRen8UKv9TN8arSqOjCdfS5X8JA542H+JNgYDbl3HTKYQK1Cm/aQPsyD9U19UeuDgBs33GspzNuEShFOdQOFz2hB9ww7QD9Y0kfholJYI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=dz6PlF+i; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="dz6PlF+i"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 485C71F000E9;
	Tue, 14 Jul 2026 14:21:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1784038917;
	bh=+Cs1JAFMJm2qn9clBRGH9pX3HL5Ne8QdHTrRvMgDtlw=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=dz6PlF+ivvQ0ZHWGkRu5QLAzfd0dQJVRZ9Em4cA6f/4Y32mlmdyBlbn72Z+CsdlBq
	 HLuneSzmgMLd1S3eAWcOLZbziO+9gF6oFs55bRBirXi261vxZ1NsaPxQwomaMb+cQu
	 penU2zXbIolW7Dl96dKx7YjwQ6GCYv54UWJcq20cSAWzBuCWj0hpITbxQ5tXaqsS/E
	 ZGUPK6zZC1SxoSW46+leAVkTtmGpcVKyZT2TKunttaowXXA12lM5tiVwlv98eHokNx
	 B8X677Y5cfJPP/75mIBVsE0kLZe2dZBg4bVkrncLuPoqGC5/yG5WTMrIqkre8d616U
	 gMAQzDxHlY1DQ==
From: sashiko-bot@kernel.org
Subject: Re: [PATCH v4 26/56] scsi: qla2xxx: Update handling of status
 entries for 29xx series
Reply-To: sashiko-reviews@lists.linux.dev
To: "Nilesh Javali" <njavali@marvell.com>
Cc: linux-scsi@vger.kernel.org
In-Reply-To: <20260714095353.289460-27-njavali@marvell.com>
References: <20260714095353.289460-1-njavali@marvell.com>
 <20260714095353.289460-27-njavali@marvell.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Tue, 14 Jul 2026 14:21:56 +0000
Message-Id: <20260714142157.485C71F000E9@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>

Thank you for your contribution! Sashiko AI review found 1 potential issue(=
s) to consider:

Pre-existing issues:
- [High] Integer underflow in `par_sense_len` calculation allows an out-of-=
bounds read of the response queue memory into the SCSI command's sense buff=
er.
--

--- Patch [26]: [PATCH v4 26/56] scsi: qla2xxx: Update handling of status e=
ntries for 29xx series ---
commit e2f9d1fbc9c40b5adf48f40bcf83f40782a2ac76
Author: Nilesh Javali <njavali@marvell.com>

scsi: qla2xxx: Update handling of status entries for 29xx series

This commit updates the handling of status entries in the qla2xxx driver
to support the 29xx series. It updates function signatures to accept generic
pointers for status packets and differentiates between standard and
extended status entries.

> diff --git a/drivers/scsi/qla2xxx/qla_isr.c b/drivers/scsi/qla2xxx/qla_is=
r.c
> --- a/drivers/scsi/qla2xxx/qla_isr.c
> +++ b/drivers/scsi/qla2xxx/qla_isr.c
[ ... ]
> @@ -3429,20 +3454,20 @@ qla2x00_status_entry(scsi_qla_host_t *vha, struct=
 rsp_que *rsp, void *pkt)
>  	sense_len =3D par_sense_len =3D rsp_info_len =3D resid_len =3D
>  	    fw_resid_len =3D 0;
>  	if (IS_FWI2_CAPABLE(ha)) {
> +		qla_sts_fwi2_extract(ha, pkt, &sf);
>  		if (scsi_status & SS_SENSE_LEN_VALID)
> -			sense_len =3D le32_to_cpu(sts24->sense_len);
> +			sense_len =3D sf.sense_len;
>  		if (scsi_status & SS_RESPONSE_INFO_LEN_VALID)
> -			rsp_info_len =3D le32_to_cpu(sts24->rsp_data_len);
> +			rsp_info_len =3D sf.rsp_data_len;
>  		if (scsi_status & (SS_RESIDUAL_UNDER | SS_RESIDUAL_OVER))
> -			resid_len =3D le32_to_cpu(sts24->rsp_residual_count);
> +			resid_len =3D sf.rsp_residual_count;
>  		if (comp_status =3D=3D CS_DATA_UNDERRUN)
>  			fw_resid_len =3D le32_to_cpu(sts24->residual_len);
> -		rsp_info =3D sts24->data;
> -		sense_data =3D sts24->data;
> -		host_to_fcp_swap(sts24->data, sizeof(sts24->data));
> +		rsp_info =3D sf.data;
> +		sense_data =3D sf.data;
> +		par_sense_len =3D sf.data_sz;

[Severity: High]
This is a pre-existing issue, but could this par_sense_len calculation
lead to an integer underflow?

Further down in qla2x00_status_entry(), when checking for FCP transport
errors, the code adjusts these pointers:

    if (IS_FWI2_CAPABLE(ha)) {
        sense_data +=3D rsp_info_len;
        par_sense_len -=3D rsp_info_len;
    }

If a maliciously large rsp_info_len is received in the FCP_RSP frame,
par_sense_len could underflow since there is no validation checking if
rsp_info_len exceeds par_sense_len.

Later in qla2x00_handle_sense(), this bounds check wouldn't protect against
the underflowed par_sense_len:

    if (sense_len > par_sense_len)
        sense_len =3D par_sense_len;

    memcpy(cp->sense_buffer, sense_data, sense_len);

Can this result in an out-of-bounds read of the response queue memory into
the SCSI command's sense buffer?

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20260714095353.2894=
60-1-njavali@marvell.com?part=3D26
