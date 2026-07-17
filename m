Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5494B369D57
	for <linux-scsi@vger.kernel.org>; Fri, 17 Jul 2026 16:20:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784305247; cv=none; b=j57lqMGUioAqyOOZcqkabEMviNkDfIabJp+2mB7CnhFYUtkmUA40KYxKF+bdK8PCvXPcTdnNdFU2tp88VksTi2sVBmELl08CgX7OHRYnqVUtFMJkYCwBlc7/OfIA0vUjFpIJii6X99/kBIM0pzSc04x5osiuOOvsg9m0Gaewa0o=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784305247; c=relaxed/simple;
	bh=iA3nGgkvnCskDNCJ0Pf3lskTHDP6PCJ16IvetzAA4t4=;
	h=From:Subject:To:Cc:In-Reply-To:References:Content-Type:Date:
	 Message-Id; b=Kx54VAcvzLKmjTu+WByjJz7E9XKicfE8gWZ3lwkuueh8LK2Oon04KPfD/CGqbBR4hpAMoamJwiDMHDPDQNRrNviZW3ON5EHhIQ4g/CCdL/s/azntp7xNdqq8y8xN3+GVNBpRwlNl18pygh/wOOBokj4VhsyiKg0DjOsOegzjf9A=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=ec7KrJm8; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="ec7KrJm8"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CA1591F000E9;
	Fri, 17 Jul 2026 16:20:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1784305246;
	bh=5PM5qu9AX98+J9Su2PfukARRaR3pOCbj79PGhX58jww=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=ec7KrJm8xnYDHoRFBsYkO+R2jEMs8lQ4Lt0+MGTJxOIoxTkSrtqm3FGLf7aVg36nq
	 2RYnKD3rFF+TZehyWr8z8Gm75WtnsUUbEn9dSA+IipmV5u92fI1RgO3LwQZ4IgTJIT
	 7k5LBEU6lqVoE/57bApIYpzCGrCu03vHvmdGluzcsfQSoy/eySUgU6s/cy30UBHZZB
	 uXgkyUwNlj/6KH5MaUYq3rg1SbPshRyQccc/O97MRLN8WBaHiNxYEtMPlWVcNhFMlV
	 7sqPgsmH1daIPLReMbpfXt05lKH9kOGEIebLhveuZcCes0eg6vEFAQ+JNexbfoLZX9
	 7oc2EuSyGcDFg==
From: sashiko-bot@kernel.org
Subject: Re: [PATCH v5 26/56] scsi: qla2xxx: Update handling of status
 entries for 29xx series
Reply-To: sashiko-reviews@lists.linux.dev
To: "Nilesh Javali" <njavali@marvell.com>
Cc: linux-scsi@vger.kernel.org
In-Reply-To: <20260717152904.3155730-27-njavali@marvell.com>
References: <20260717152904.3155730-1-njavali@marvell.com>
 <20260717152904.3155730-27-njavali@marvell.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Fri, 17 Jul 2026 16:20:45 +0000
Message-Id: <20260717162045.CA1591F000E9@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>

Thank you for your contribution! Sashiko AI review found 1 potential issue(=
s) to consider:

Pre-existing issues:
- [High] Integer underflow when subtracting `rsp_info_len` from `par_sense_=
len` allows an out-of-bounds read of kernel memory into the SCSI sense buff=
er.
--

--- Patch [26]: [PATCH v5 26/56] scsi: qla2xxx: Update handling of status e=
ntries for 29xx series ---
commit a044d1392eb6caf2137f3007abf552f366a595c5
Author: Nilesh Javali <njavali@marvell.com>

scsi: qla2xxx: Update handling of status entries for 29xx series

This commit modifies the handling of status entries in the qla2xxx driver to
accommodate the extended structure for the 29xx series. It abstracts the
extraction of status fields via the qla_sts_fwi2_extract helper to handle
both standard and extended layouts.

> diff --git a/drivers/scsi/qla2xxx/qla_isr.c b/drivers/scsi/qla2xxx/qla_is=
r.c
> --- a/drivers/scsi/qla2xxx/qla_isr.c
> +++ b/drivers/scsi/qla2xxx/qla_isr.c
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

[Severity: High]
This is a pre-existing issue, but does this code allow an integer underflow
on par_sense_len?

A few lines further down in qla2x00_status_entry(), rsp_info_len is used to
advance sense_data and decrement par_sense_len:

	if (IS_FWI2_CAPABLE(ha)) {
		sense_data +=3D rsp_info_len;
		par_sense_len -=3D rsp_info_len;
	}

If a target sends a maliciously large rsp_info_len, par_sense_len will
underflow. This underflowed value is then passed into
qla2x00_handle_sense(), which uses it for bounds checking before calling
memcpy():

	if (sense_len > par_sense_len)
		sense_len =3D par_sense_len;

	memcpy(cp->sense_buffer, sense_data, sense_len);

Could this result in an out-of-bounds read of kernel memory into the SCSI
sense buffer, since rsp_info_len isn't validated against the initial size of
par_sense_len before the subtraction?

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
> +		sts_qual =3D sf.sts_qual;
>  		ox_id =3D le16_to_cpu(sts24->ox_id);
> -		par_sense_len =3D sizeof(sts24->data);
> -		sts_qual =3D le16_to_cpu(sts24->status_qualifier);
>  	} else {

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20260717152904.3155=
730-1-njavali@marvell.com?part=3D26
