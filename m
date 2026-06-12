Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1D294322B9F
	for <linux-scsi@vger.kernel.org>; Fri, 12 Jun 2026 10:44:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1781261074; cv=none; b=QkAP7EUDsmE5qc1Z1w1g3tnRFg6pNojPhRU87WSb1BmlVZhnx34wdvrKK9/CIAKYll7OwZa7LQUZHOHtI9nG9Hq39W/0bKeuion9fR2DQ0AFaAPmy88+Hgtx2c/mCOAQtHU7yWiP0enzUkb2fWEdB+//vl6Ift8sW0cnZmWTqnY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1781261074; c=relaxed/simple;
	bh=uP64NqoMZe5o5kDMHcyvwwurVpcsWoTVPEJ4xsQ7iZ0=;
	h=From:Subject:To:Cc:In-Reply-To:References:Content-Type:Date:
	 Message-Id; b=kYVyhDdCIBjhUtAru5h7IulfOLNy7zmsUxEHJXLVNgt4sF9ZcwcR348sjuY3qzGklb76MgCPKaRQUAsMKWgiMUDORGBCDkzZ+UFcZ1oPss/pe6loX/eg4PHBDSRaX9MMVuRmTnlfR3d+UWPWr2v1FT2MEyqTN8PPVMWQCc5jzGc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=hNRiAtqi; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="hNRiAtqi"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 840021F000E9;
	Fri, 12 Jun 2026 10:44:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1781261072;
	bh=Exm1YaEkozI/mU/O5VrAX6GyPrUHbGSdZ40opypmAwQ=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=hNRiAtqiUfBacTxCqMtC/c9YYUXm6pqAoKtsI2Y+a9cK6D9cedZQ5Qm8c/tGcqQ8v
	 JwEpl1rfjZDX+QMIfwlyrT10dE3ROotfODtaHm8TcIehKLmIGtCNS+wot69pB312Wh
	 EKYHYwZftDgrusLNxOZX0IyB1Sca8j4+2l+qh2XJp0RaRixdJipl6YLeHUMiyN+rSe
	 yIuNFNrrLkODMlB4QJRHT9evG+eAMrAwSh+4fPBVXmM5GflX7QO0NQmt/BsetBeb/v
	 V0sbVo0wqiF8vizWiKrwRWOr55PHOrkogloWd9NdJ+A22O0E/beLWPS4gySHaBwuwl
	 TUJzCnvIlcuxA==
From: sashiko-bot@kernel.org
Subject: Re: [PATCH v2 29/60] scsi: qla2xxx: Update handling of status
 entries for 29xx series
Reply-To: sashiko-reviews@lists.linux.dev
To: "Nilesh Javali" <njavali@marvell.com>
Cc: linux-scsi@vger.kernel.org
In-Reply-To: <20260612095333.1666592-30-njavali@marvell.com>
References: <20260612095333.1666592-30-njavali@marvell.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Fri, 12 Jun 2026 10:44:31 +0000
Message-Id: <20260612104432.840021F000E9@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>

Thank you for your contribution! Sashiko AI review found 1 potential issue(=
s) to consider:

Pre-existing issues:
- [High] An attacker-controlled target can cause an integer underflow in `p=
ar_sense_len` resulting in an out-of-bounds read of adjacent kernel heap/DM=
A ring memory, leaking it to user-space.
--

commit f656a1805f0e016da73a51f8736cdf5930510fd1
Author: Nilesh Javali <njavali@marvell.com>

scsi: qla2xxx: Update handling of status entries for 29xx series

This commit modifies the handling of status entries in the qla2xxx driver to
accommodate the extended structure for the 29xx series. It updates function
signatures to accept generic pointers and adjusts logic to differentiate
between standard and extended status entries.

> diff --git a/drivers/scsi/qla2xxx/qla_isr.c b/drivers/scsi/qla2xxx/qla_is=
r.c
> index c18ee2459f5bd..f81cf70a0542c 100644
> --- a/drivers/scsi/qla2xxx/qla_isr.c
> +++ b/drivers/scsi/qla2xxx/qla_isr.c

[ ... ]

> @@ -3480,20 +3505,20 @@ qla2x00_status_entry(scsi_qla_host_t *vha, struct=
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

[Severity: High]
This is a pre-existing issue, but can an attacker-controlled target cause an
integer underflow here?

If a compromised target provides an rsp_info_len (via sf.rsp_data_len)
larger than the actual data buffer size (par_sense_len, initialized to 28
or 60), the subtraction later in qla2x00_status_entry():

    if (IS_FWI2_CAPABLE(ha)) {
        sense_data +=3D rsp_info_len;
        par_sense_len -=3D rsp_info_len;
    }

will underflow par_sense_len to a massive positive value.

Subsequently, when qla2x00_handle_sense() is called, the length check:

    if (sense_len > par_sense_len)
        sense_len =3D par_sense_len;

fails to cap sense_len, allowing the following memcpy:

    memcpy(cp->sense_buffer, sense_data, sense_len);

to read out-of-bounds adjacent kernel heap or DMA ring memory, leaking it
into the SCSI command's sense buffer.

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

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20260612095333.1666=
592-1-njavali@marvell.com?part=3D29
