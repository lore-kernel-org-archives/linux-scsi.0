Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E73753BE165
	for <linux-scsi@vger.kernel.org>; Tue,  7 Jul 2026 06:53:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1783407226; cv=none; b=lSfcCUtyDLUcun+U68wGCVqtRoxzRGZL9JM1o/wZ6nVNMhSJ940+Mmay+FWDcFgklYVuIPXMIT7inzu7cxuzanqbYQyiB8hBK1BduRKL6M7OdXOKGJvfEihm/DgXAp1JbUex+KpoZeKyiKNOmDbvhvh19UmPxeYcMPGXJJjJmRs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1783407226; c=relaxed/simple;
	bh=da1zUxUkyYEo4WgR5ZZ5p3++BHToXZK32JL4akbnnBA=;
	h=From:Subject:To:Cc:In-Reply-To:References:Content-Type:Date:
	 Message-Id; b=p1+1/uRJgCnJDQYORrO6OyeEEtlFuTCADQAdDRpd09C/oQsCLNIvZEoKgogfEkqM8eTXTZjBbFRs3lrE+l6bfTj4VFDmvo/PgK/TTFjWD4SYsPPG/NPQQVgjm4JiQihCq1FHDF0U3HQXawCN9RD4+58hyRoRRPbIu1IxU7aLgFk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=PQpVecrw; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="PQpVecrw"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9E4581F000E9;
	Tue,  7 Jul 2026 06:53:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1783407221;
	bh=ak0tYH3E3lUxeTqZo2vpjKiZuCwK8wPWB7E9etdJVuQ=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=PQpVecrwhQppv7doeY7rQkTEaVL9p96dnYArWRufHGNXbOHWXfAXx5HKZ7y/ZaFfO
	 Icg8wNdnIXhlA+LbRyk+QxpWmKwnzjiXJIRhJ1nyAlm8T05OGrSBxCG/Mf6JLjKD2H
	 o8mqMPtAn+F6vGR+HO0TAFlPlNLBUAPG02eqpUw9yihARwv7rlwLYTFbPbXGNp/UjR
	 5XGznXxtiZU/CA3EmkAAAFQMoZ+XOOs0uj5cRrXoVwwgmHCC3HSHtvVnBTBiPe6Tsh
	 FZC2lKG+8c91TGPlstFQmchs2DxAXtYMg3/mJrwgh/BpCgOHWXYxu5xlh7qrocCS0c
	 5rlJ1R+zbD6WA==
From: sashiko-bot@kernel.org
Subject: Re: [PATCH v3 47/88] scsi: qla2xxx: Fix Name Server logout
 detection on FWI2 adapters
Reply-To: sashiko-reviews@lists.linux.dev
To: "Nilesh Javali" <njavali@marvell.com>
Cc: linux-scsi@vger.kernel.org
In-Reply-To: <20260707055435.2680300-48-njavali@marvell.com>
References: <20260707055435.2680300-1-njavali@marvell.com>
 <20260707055435.2680300-48-njavali@marvell.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Tue, 07 Jul 2026 06:53:41 +0000
Message-Id: <20260707065341.9E4581F000E9@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>

Thank you for your contribution! Sashiko AI review found 1 potential issue(=
s) to consider:

Pre-existing issues:
- [High] Incorrect check for Name Server logout on legacy adapters without =
extended IDs (ISP2100/ISP2200).
--

--- Patch [47]: [PATCH v3 47/88] scsi: qla2xxx: Fix Name Server logout dete=
ction on FWI2 adapters ---
commit afcd1252a5a5629b694324167fa2faf1b7a9ef47
Author: Nilesh Javali <njavali@marvell.com>

scsi: qla2xxx: Fix Name Server logout detection on FWI2 adapters

This commit fixes Name Server logout detection on FWI2 and later adapters by
reading the correct nport_handle field instead of incorrectly aliasing the
comp_status field.

> diff --git a/drivers/scsi/qla2xxx/qla_gs.c b/drivers/scsi/qla2xxx/qla_gs.c
> --- a/drivers/scsi/qla2xxx/qla_gs.c
> +++ b/drivers/scsi/qla2xxx/qla_gs.c

[ ... ]

> @@ -192,8 +192,8 @@ qla2x00_chk_ms_status(scsi_qla_host_t *vha, ms_iocb_e=
ntry_t *ms_pkt,
>  			break;
>  		case CS_PORT_LOGGED_OUT:
>  			if (IS_FWI2_CAPABLE(ha)) {
> -				if (le16_to_cpu(ms_pkt->loop_id.extended) =3D=3D
> -				    NPH_SNS)
> +				if (le16_to_cpu(((struct ct_entry_24xx *)
> +				    ms_pkt)->nport_handle) =3D=3D NPH_SNS)
>  					lid_is_sns =3D true;
>  			} else {
>  				if (le16_to_cpu(ms_pkt->loop_id.extended) =3D=3D
>  				    SIMPLE_NAME_SERVER)

[Severity: High]
This isn't a bug introduced by this patch, but does the legacy adapter
path have a similar issue for older adapters without extended IDs?

For older adapters (like ISP2100/2200) where extended IDs are not supported,
the 8-bit loop ID is stored in the id.standard field (byte 1) of the
target_id_t union rather than as a 16-bit little-endian value in extended.

If the 8-bit ID is read using le16_to_cpu(ms_pkt->loop_id.extended) in
qla2x00_chk_ms_status(), could it evaluate to 0x8000 instead of 0x80
(SIMPLE_NAME_SERVER)?

This would cause the check to unconditionally fail, meaning legacy adapters
might also fail to recognize a Name Server logout in the exact same way
that FWI2 adapters were failing.

>  					lid_is_sns =3D true;
>  			}

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20260707055435.2680=
300-1-njavali@marvell.com?part=3D47
