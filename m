Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4324F1A3164;
	Thu, 11 Jun 2026 02:58:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1781146689; cv=none; b=LRMKnpWVc7Agb9ilcj0PN78tG9Q6zwSzfWADU5B5jXyqfAMxCv5QBONlFXyDqMJscL4Jg8kdOuARWiUKElOwkmVCFsJTXzlJTrFPqcTbu7GKRVhN8GfTD/heTYvkKH9U+40ewdpIS/fn7nXgIBc1VPCHq0XaA6fssBjpM8IJ4OA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1781146689; c=relaxed/simple;
	bh=fiJT3IqK43i+0rspuzb1Ct8gVDxVGHqszBI60buK0fk=;
	h=From:Subject:To:Cc:In-Reply-To:References:Content-Type:Date:
	 Message-Id; b=eAk7MEKMiAQ72LqmMkVUeyxE87p6bcn1W26P01bSL2QizOgix1YdLNYYgjpvcRneVSmS4SzddfvYS9sB0ycXL1VCFoBov8UfDx8qZzBa5TULDUeXviTRN+3TdhgOidp6n1T8oL3n/EWx+dN8Uo7al/sLBVfQg21LF3sUiGNrADA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=ZIjQ7wlx; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="ZIjQ7wlx"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9FF511F00893;
	Thu, 11 Jun 2026 02:58:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1781146687;
	bh=rVRepx5j2jr7gykwdfGTBIVRdooHGGBSQKVdnnMos2M=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=ZIjQ7wlxMrFS1cdyjg+uxAaF/TZ3T9qt8xA2m4fMiCz4GlPwf9xr6Q7POZkha8uHa
	 tijUwwmYVLOujjLPKw5hF45pJSS6/YyoZto6sLfD4oDIusDV97ug3vKtOrq4MVNMOD
	 bAwMntKEUrNKYy4UMrcasJgd8/vfdtXC/QWZSD+rXw5s8fdayp6T9iefd3O0a7TfVu
	 opO0ACdmBSGOastcwU31T4m0Q9UMjSXof6Fmt4uyZUZPYpGwQjRRIre8IuAvOVuMrO
	 4ldrL28oUN44quJJE4HTRfvJUDHNJ3T5UEonDqZNUoFiPW41WaPnEcZGbKeyr2MTMZ
	 XgHNIp4RZbmAA==
From: sashiko-bot@kernel.org
Subject: Re: [PATCH v7 3/6] ata: libata-scsi: route non-zero LUN commands
 for multi-LUN ATAPI
Reply-To: sashiko-reviews@lists.linux.dev
To: "Phil Pemberton" <philpem@philpem.me.uk>
Cc: linux-ide@vger.kernel.org, dlemoal@kernel.org, linux-scsi@vger.kernel.org, cassel@kernel.org
In-Reply-To: <20260611024356.2769320-4-philpem@philpem.me.uk>
References: <20260611024356.2769320-4-philpem@philpem.me.uk>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Thu, 11 Jun 2026 02:58:07 +0000
Message-Id: <20260611025807.9FF511F00893@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>

Thank you for your contribution! Sashiko AI review found 3 potential issue(=
s) to consider:
- [High] LUN validation incorrectly checks the host's max_lun instead of th=
e device's LUN limit, breaking SAS HBAs and introducing a kernel panic vect=
or.
- [High] Unconditionally clearing bits 7:5 of CDB byte 1 destroys command-s=
pecific parameters for standard MMC commands, breaking Blu-ray decryption.
- [High] Error handling routines for ATAPI do not propagate the non-zero LU=
N, causing atapi_eh_request_sense() to incorrectly fetch sense data for LUN=
 0.
--

commit 0fa4117328a093e17803a117416e6ddc64dee46b
Author: Phil Pemberton <philpem@philpem.me.uk>

ata: libata-scsi: route non-zero LUN commands for multi-LUN ATAPI

This patch modifies __ata_scsi_find_dev() to allow non-zero LUNs for ATAPI
devices and updates atapi_xlat() to encode the LUN into CDB byte 1 as
expected by older SCSI-2 era devices.

> diff --git a/drivers/ata/libata-scsi.c b/drivers/ata/libata-scsi.c
> index b65358955cf17..2e3b5fd41d05f 100644
> --- a/drivers/ata/libata-scsi.c
> +++ b/drivers/ata/libata-scsi.c

[ ... ]

> @@ -2958,6 +2958,20 @@ static unsigned int atapi_xlat(struct ata_queued_c=
md *qc)
>  	memset(qc->cdb, 0, dev->cdb_len);
>  	memcpy(qc->cdb, scmd->cmnd, scmd->cmd_len);
> =20
> +	/*
> +	 * SCSI-2 CDB LUN encoding: bits 7:5 of byte 1 (3-bit field).
> +	 * Always clear those bits; only set them for non-zero LUNs.
> +	 */
> +	qc->cdb[1] =3D qc->cdb[1] & 0x1f;

[Severity: High]
Could this unconditional masking cause a regression by destroying
command-specific parameters for standard MMC commands?

Modern ATAPI/MMC devices reuse these bits for essential parameters since th=
ey
no longer rely on LUN addressing inside the CDB. For example, the REPORT KEY
command (0xA4) relies on bits 7:6 of byte 1 for the Key Class. Clearing
these bits forces the Key Class to 0 (DVD CSS), which breaks Blu-ray AACS
decryption tools for SATA/ATAPI optical drives.

> +	if (unlikely(scmd->device->lun)) {
> +		if (WARN_ON_ONCE(scmd->device->host->max_lun > ATAPI_MAX_LUN ||
> +				 scmd->device->lun >=3D scmd->device->host->max_lun)) {

[Severity: High]
Does this check incorrectly validate against the host max_lun instead of the
device LUN limit?

On SAS HBAs (like mpt3sas), host->max_lun is legitimately set to very large
values (e.g., 16895). Because 16895 > 8 (ATAPI_MAX_LUN), any command sent to
a non-zero LUN on an ATAPI device attached to such an HBA will trigger this
WARN_ON_ONCE and fail with DID_ERROR.=20

On systems with panic_on_warn enabled, this will cause a kernel panic when a
multi-LUN ATAPI device is scanned.

[Severity: High]
Is there a missing update for error handling routines to propagate the
non-zero LUN, leading to a regression in sense data retrieval?

While this patch routes non-zero LUN commands by mutating CDB byte 1 in
atapi_xlat(), it appears this routing is missing from error handling. When a
command fails, ata_eh_analyze_tf() calls atapi_eh_request_sense().

In drivers/ata/libata-eh.c:atapi_eh_request_sense():
    u8 cdb[ATAPI_CDB_LEN] =3D
        { REQUEST_SENSE, 0, 0, 0, SCSI_SENSE_BUFFERSIZE, 0 };

This constructs a hardcoded REQUEST_SENSE CDB with byte 1 explicitly set to
0. If an I/O error occurs on LUN 1, the kernel will fetch the sense data
for LUN 0 instead.=20

This could cause the SCSI midlayer to receive incorrect error status,
potentially masking legitimate I/O errors and leading to infinite retry
loops.

> +			scmd->result =3D DID_ERROR << 16;
> +			return 1;
> +		}
> +		qc->cdb[1] |=3D (u8)scmd->device->lun << 5;
> +	}
> +
>  	qc->complete_fn =3D atapi_qc_complete;

[ ... ]

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20260611024356.2769=
320-1-philpem@philpem.me.uk?part=3D3
