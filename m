Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3B27313AF2;
	Fri,  4 Sep 2026 01:53:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788486800; cv=none; b=IRVlyjq/Y7PDPxS+Z6uk21utd75t/Arvcdkp3wXcMCP5ERnzskOiv+3CRsP7FODEyK6s5UKsiGDrwxbGTj1UOHiW96HS0GuFldZGwfEFamvzNha/YICztD4Zi4jxhv3E/QJBFJa3fgn/Xe1+6An7B4Sy85lDZoVyaxd7tdiujPE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788486800; c=relaxed/simple;
	bh=SYkh6TeT4tQvb2dTjcAXnvQuzVrVXtpN0AUbotRCtt0=;
	h=From:Subject:To:Cc:In-Reply-To:References:Content-Type:Date:
	 Message-Id; b=t6DTYE7tclzRJZ0TiU6qVn/gAI4wCVIxn1MPGz1oUWY58qbULxaXh8ZtIiNTG4dY/BbaA4PQMJITZAEyRdKgjKQjqcnO8moq0NJUgX/thpeCtU3Ls+U/HH5c16i+PH8L9+9ZQfXbIa+OXn9/bA7YcvJqwQtEKmD3lv2hmx7pLIw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=JLj2ht23; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="JLj2ht23"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5A6431F000E9;
	Fri,  4 Sep 2026 01:53:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1788486798;
	bh=5eM79uyIUemG5VfzAPw6o54e4G8/uYlJomRdtZ2dfP4=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=JLj2ht23/QgBB4Ktb5k2R8TPpEoP3dpXNQDdvdVfkfFqOPdYOwLY7BtuSUlUmiEz/
	 ZrEM38qGW8nLFeqI7MRDzswZvCGgMxhgsdqPklN87eztI4QKF0wlaSe10Wmoun5/jK
	 nEIOf4e7UiKh+rv8X61uWtIA8+7uWriZZRQBWMktl+x1+SOK0m0s37lPBBOB7kBfZc
	 PILQE1U24n/5phu680BIus9A+NYLsYjT00Dto8FdOm0zrCxGwv4mNaHcwQXWxSQj7g
	 XNXmimMFXFdk5iIWdTXtWu2wNtbE2y4eiZ6V5CHvIei/pMKxGwcav1i/XwBZGyckFO
	 FBBQkPL2ljNkw==
From: sashiko-bot@kernel.org
Subject: Re: [PATCH v3 22/40] scsi: myrX: use 16-bits defined sense codes
Reply-To: sashiko-reviews@lists.linux.dev
To: "Damien Le Moal" <dlemoal@kernel.org>
Cc: cassel@kernel.org, "Alexander Gordeev" <agordeev@linux.ibm.com>, linux-s390@vger.kernel.org, "Heiko
 Carstens" <hca@linux.ibm.com>, "Christian Borntraeger" <borntraeger@linux.ibm.com>, "Vasily
 Gorbik" <gor@linux.ibm.com>, dlemoal@kernel.org, linux-ide@vger.kernel.org, linux-scsi@vger.kernel.org
In-Reply-To: <20260904002644.157668-23-dlemoal@kernel.org>
References: <20260904002644.157668-1-dlemoal@kernel.org>
 <20260904002644.157668-23-dlemoal@kernel.org>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Fri, 04 Sep 2026 01:53:17 +0000
Message-Id: <20260904015318.5A6431F000E9@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>

Thank you for your contribution! Sashiko AI review found 3 potential issue(=
s) to consider:

Pre-existing issues:
- [Critical] Missing error check for negative return value from scsi_dma_ma=
p(), leading to corrupted command submission.
- [High] DMA mapping resource leak on memory allocation failure.
- [High] The REQUEST_SENSE command handler fails to call scsi_done(), leadi=
ng to a command timeout hang.
--

commit 3f2ef162e5ea4ec979ec96283f2b6fa4f8798741
Author: Damien Le Moal <dlemoal@kernel.org>
Subject: scsi: myrX: use 16-bits defined sense codes

This commit refactors the Mylex RAID controller driver to use
scsi_set_sense() and 16-bit sense codes from include/scsi/scsi_sense.h
instead of hard-coded values. This improves code clarity without any
intended functional changes.

> diff --git a/drivers/scsi/myrb.c b/drivers/scsi/myrb.c
> index 3678b66310ed0..e7d796add9864 100644
> --- a/drivers/scsi/myrb.c
> +++ b/drivers/scsi/myrb.c
[ ... ]
> @@ -1472,15 +1474,15 @@ static enum scsi_qc_status myrb_ldev_queuecommand=
(struct Scsi_Host *shost,
>  	case READ_CAPACITY:
>  		if ((scmd->cmnd[1] & 1) ||
>  		    (scmd->cmnd[8] & 1)) {
> -			/* Illegal request, invalid field in CDB */
> -			scsi_build_sense(scmd, 0, ILLEGAL_REQUEST, 0x24, 0);
> +			scsi_set_sense(scmd, 0, ILLEGAL_REQUEST,
> +				       INVALID_FIELD_IN_CDB);
>  			scsi_done(scmd);
>  			return 0;
>  		}

[Severity: High]
This isn't a bug introduced by this patch, but does the REQUEST_SENSE comma=
nd
handler fail to call scsi_done() here?

In myrb_ldev_queuecommand():
	case REQUEST_SENSE:
		myrb_request_sense(cb, scmd);
		scmd->result =3D (DID_OK << 16);
		return 0;

It seems this returns success to the block layer without invoking the
scsi_done() completion callback. Any explicit REQUEST_SENSE command sent to
the device could hang indefinitely until the block layer timeout triggers
SCSI error recovery.

[ ... ]
> @@ -1544,8 +1546,8 @@ static enum scsi_qc_status myrb_ldev_queuecommand(s=
truct Scsi_Host *shost,
>  		block_cnt =3D get_unaligned_be32(&scmd->cmnd[6]);
>  		break;
>  	default:
> -		/* Illegal request, invalid opcode */
> -		scsi_build_sense(scmd, 0, ILLEGAL_REQUEST, 0x20, 0);
> +		scsi_set_sense(scmd, 0, ILLEGAL_REQUEST,
> +			       INVALID_COMMAND_OP_CODE);
>  		scsi_done(scmd);
>  		return 0;
>  	}

[Severity: Critical]
This is a pre-existing issue, but is there a missing error check for a
negative return value from scsi_dma_map()?

Later in myrb_ldev_queuecommand():
	nsge =3D scsi_dma_map(scmd);
	if (nsge =3D=3D 1) {
		...
	} else {
		struct myrb_sge *hw_sgl;
		...

If scsi_dma_map() fails and returns a negative error code (e.g. -ENOMEM),
the return value is stored in nsge. Since nsge < 0, the driver falls
through to the else block (as nsge !=3D 1). The negative value is used as t=
he
sg_count in hardware submission (which is an 8-bit unsigned integer,
converting to 244). The loop to initialize the hardware SG list is skipped,
and the command is submitted to the controller with an uninitialized or
partially initialized DMA mapping and a large sg_count. Can this cause the
hardware to read random garbage from memory and perform DMA transfers to
arbitrary physical addresses, leading to memory corruption or IOMMU faults?

[Severity: High]
This is also a pre-existing issue, but does this code leak the DMA mapping
if the memory allocation fails?

A few lines down in the same else block:
	} else {
		struct myrb_sge *hw_sgl;
		dma_addr_t hw_sgl_addr;
		int i;

		hw_sgl =3D dma_pool_alloc(cb->sg_pool, GFP_ATOMIC, &hw_sgl_addr);
		if (!hw_sgl)
			return SCSI_MLQUEUE_HOST_BUSY;

If dma_pool_alloc() fails, it returns SCSI_MLQUEUE_HOST_BUSY to have the
midlayer retry the command, but it seems to return without calling
scsi_dma_unmap(scmd). Under memory pressure, could this leak DMA mappings
repeatedly until the system hangs or crashes from IOMMU/bounce buffer
exhaustion?

> diff --git a/drivers/scsi/myrs.c b/drivers/scsi/myrs.c
> index afd68225221a6..1192b01fab8ec 100644
> --- a/drivers/scsi/myrs.c
> +++ b/drivers/scsi/myrs.c
[ ... ]
> @@ -1603,7 +1607,8 @@ static enum scsi_qc_status myrs_queuecommand(struct=
 Scsi_Host *shost,
> =20
>  	switch (scmd->cmnd[0]) {
>  	case REPORT_LUNS:
> -		scsi_build_sense(scmd, 0, ILLEGAL_REQUEST, 0x20, 0x0);
> +		scsi_set_sense(scmd, 0, ILLEGAL_REQUEST,
> +			       INVALID_COMMAND_OP_CODE);
>  		scsi_done(scmd);
>  		return 0;

[Severity: Critical]
This is a pre-existing issue, but is there a missing error check for a
negative return value from scsi_dma_map() here as well?

Later in myrs_queuecommand():
	nsge =3D scsi_dma_map(scmd);
	if (nsge =3D=3D 1) {
		...
	} else {
		struct myrs_sge *hw_sgl;
		...

If scsi_dma_map() fails and returns a negative error code (like -ENOMEM),
nsge < 0 falls through to the else block. The negative value is used
as the sg_count in hardware submission, and the command is submitted
with an uninitialized or partially initialized DMA mapping. Can this cause
memory corruption or IOMMU faults?

[Severity: High]
This is a pre-existing issue, but does this code leak the DMA mapping
if the memory allocation fails?

Further down in myrs_queuecommand():
		if (nsge > 2) {
			hw_sgl =3D dma_pool_alloc(cs->sg_pool, GFP_ATOMIC,
						&hw_sgl_addr);
			if (WARN_ON(!hw_sgl)) {
				if (cmd_blk->dcdb) {
					dma_pool_free(cs->dcdb_pool,
						      cmd_blk->dcdb,
						      cmd_blk->dcdb_dma);
					cmd_blk->dcdb =3D NULL;
					cmd_blk->dcdb_dma =3D 0;
				}
				dma_pool_free(cs->sense_pool,
					      cmd_blk->sense,
					      cmd_blk->sense_addr);
				cmd_blk->sense =3D NULL;
				cmd_blk->sense_addr =3D 0;
				return SCSI_MLQUEUE_HOST_BUSY;
			}

When dma_pool_alloc() fails, it cleans up some allocations and returns
SCSI_MLQUEUE_HOST_BUSY. However, it seems to return without calling
scsi_dma_unmap(scmd) to unmap the memory mapped a few lines above.
Under memory pressure, could this leak DMA mappings repeatedly until
the system hangs or crashes from IOMMU/bounce buffer exhaustion?

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20260904002644.1576=
68-1-dlemoal@kernel.org?part=3D22
