Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AC60B37E2F3;
	Thu,  3 Sep 2026 04:01:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788408070; cv=none; b=l2GSd67vhrS9yFa30jvSmYDNVFrFDY+fm2gaYsFLCRjMbJ3LNhbwVGkajf5VjzuS6Z0bbZ2MMBBQABbm9wea5mgeVu7iTxyHK6vwFTE38WMovp8ySfZWfRrfrmCSCabrfefgnJ1F/a2resw5fZIyLClEeXsV7cEv3q9gsepTdRM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788408070; c=relaxed/simple;
	bh=o+n1KMqJO9QkGYkfmw2F44pTEsmmWmVwEaCMNNJJZas=;
	h=From:Subject:To:Cc:In-Reply-To:References:Content-Type:Date:
	 Message-Id; b=i0VhbdDCNLaPip7i3EBBeoSFOxSMpio0ikhT2Qc1H4VQksNFpHfpVPQn4LLkHjdSIJqf9f5g0Zrtnx2vad9fzeilP5HD2b2V8TfnMU9xHyVun9MleW+CvxPcm1xz8TniCT2ZmZtZ+9h2jrOJEmOyvM5oNXmiAYVdm/zAnUujUAo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=ixyx2PWb; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="ixyx2PWb"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DF0FF1F00A3A;
	Thu,  3 Sep 2026 04:01:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1788408068;
	bh=q6nvphDd7U9dN/puQe9gMCe5alSFy1OXJMGbb5RVn+Y=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=ixyx2PWbSvDV/MFn+cxhJYu+BarI+OdAA8aCqiNIDXSW3qxf9RIdquAK+yW7oC9AV
	 JIsGIsGbFNUaGdK05R31chh0MBYxEDzOLaUy1NMZPSzyeWI6zAv2UXfVIfimNkvMeu
	 flRf9FWgaI6AxVTIEw1/hH7TWjPwTpd1l5KqWM7yod5ubyzx/IEJyvUaWqpav6nhDZ
	 yG2DuDuTuQEcxfTp1HVFMV2+lFKrePFl6rc66Cm/YSoFV5xRgBhylZqh8U4rIGfC0P
	 GJPgeHE3y0IRgL+l6XPinfsSIKKsTMzPFbJ1R0BLihfFFGtfJ7tz5AQzlCxxynKLP4
	 3FMUlzkzBpENg==
From: sashiko-bot@kernel.org
Subject: Re: [PATCH v2 22/40] scsi: myrX: use 16-bits defined sense codes
Reply-To: sashiko-reviews@lists.linux.dev
To: "Damien Le Moal" <dlemoal@kernel.org>
Cc: linux-s390@vger.kernel.org, linux-ide@vger.kernel.org, "Heiko Carstens" <hca@linux.ibm.com>, cassel@kernel.org, "Alexander
 Gordeev" <agordeev@linux.ibm.com>, "Vasily Gorbik" <gor@linux.ibm.com>, "Christian
 Borntraeger" <borntraeger@linux.ibm.com>, dlemoal@kernel.org, linux-scsi@vger.kernel.org
In-Reply-To: <20260903034201.112211-23-dlemoal@kernel.org>
References: <20260903034201.112211-1-dlemoal@kernel.org>
 <20260903034201.112211-23-dlemoal@kernel.org>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Thu, 03 Sep 2026 04:01:07 +0000
Message-Id: <20260903040107.DF0FF1F00A3A@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>

Thank you for your contribution! Sashiko AI review found 4 potential issue(=
s) to consider:

Pre-existing issues:
- [Critical] Data Corruption: Incorrect offset used for writing the SCSI mo=
de parameter block descriptor corrupts the 24-bit block length.
- [High] Command Timeout: The REQUEST_SENSE command in myrb_ldev_queuecomma=
nd returns without calling scsi_done(), leading to a hanging command.
- [High] Resource Leak: Returning SCSI_MLQUEUE_HOST_BUSY after a successful=
 scsi_dma_map() without unmapping causes a DMA mapping leak.
- [High] Memory Leak: DMA pool allocations are leaked on the SG mapping err=
or path in myrs_queuecommand.
--

commit 3eaecf993e28ec2a9d1c5ee8b1fc650d068a56f8
Author: Damien Le Moal <dlemoal@kernel.org>

scsi: myrX: use 16-bits defined sense codes

Refactor the Mylex RAID controller driver to use scsi_set_sense() and the
16-bits sense_code field of struct scsi_sense_hdr and replace all
hard-coded additional sense codes and additional sense code qualifiers
with the enum values defined in include/scsi/scsi_sense.h. This helps with
code clarity as the sense codes being processed are easier to test and
self-documented.

> diff --git a/drivers/scsi/myrb.c b/drivers/scsi/myrb.c
> index 3678b66310ed0..e7d796add9864 100644
> --- a/drivers/scsi/myrb.c
> +++ b/drivers/scsi/myrb.c
[ ... ]
> @@ -1398,7 +1400,7 @@ myrb_mode_sense(struct myrb_hba *cb, struct scsi_cm=
nd *scmd,
>  static void myrb_request_sense(struct myrb_hba *cb,
>  		struct scsi_cmnd *scmd)
>  {
> -	scsi_build_sense(scmd, 0, NO_SENSE, 0, 0);
> +	scsi_set_sense(scmd, 0, NO_SENSE, NO_ADDITIONAL_SENSE_INFORMATION);
>  	scsi_sg_copy_from_buffer(scmd, scmd->sense_buffer,
>  				 SCSI_SENSE_BUFFERSIZE);
>  }

[Severity: High]
This is a pre-existing issue, but looking at how myrb_request_sense() is us=
ed
in myrb_ldev_queuecommand() in drivers/scsi/myrb.c:

	case REQUEST_SENSE:
		myrb_request_sense(cb, scmd);
		scmd->result =3D (DID_OK << 16);
		return 0;

Because returning 0 indicates to the SCSI midlayer that the driver has
accepted the command and will complete it asynchronously, does failing to c=
all
scsi_done(scmd) here cause the command to hang indefinitely and eventually
trigger a SCSI timeout?

[ ... ]
> @@ -1461,8 +1463,8 @@ static enum scsi_qc_status myrb_ldev_queuecommand(s=
truct Scsi_Host *shost,
>  	case MODE_SENSE:
>  		if ((scmd->cmnd[2] & 0x3F) !=3D 0x3F &&
>  		    (scmd->cmnd[2] & 0x3F) !=3D 0x08) {
> -			/* Illegal request, invalid field in CDB */
> -			scsi_build_sense(scmd, 0, ILLEGAL_REQUEST, 0x24, 0);
> +			scsi_set_sense(scmd, 0, ILLEGAL_REQUEST,
> +				       INVALID_FIELD_IN_CDB);
>  		} else {
>  			myrb_mode_sense(cb, scmd, ldev_info);

[Severity: Critical]
This is a pre-existing issue, but I noticed myrb_mode_sense() in
drivers/scsi/myrb.c writes the block size to the mode page block descriptor
using put_unaligned_be32():

static void myrb_mode_sense(struct myrb_hba *cb, struct scsi_cmnd *scmd,
		struct myrb_ldev_info *ldev_info)
{
...
		put_unaligned_be32(cb->ldev_block_size, &block_desc[5]);

Since the block length in the descriptor is a 24-bit field located at offse=
ts
5, 6, and 7, won't writing a 32-bit value at offset 5 overflow the LSB into
offset 8 (the start of the mode page header)? For a typical 512 byte block
size, it seems this writes 2 instead of 512, completely corrupting capacity
reporting.

>  			scmd->result =3D (DID_OK << 16);
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

[Severity: High]
This is a pre-existing issue, but later in myrb_ldev_queuecommand() in
drivers/scsi/myrb.c, after the switch statement, the function maps DMA memo=
ry:

	nsge =3D scsi_dma_map(scmd);
    ...
	} else {
		struct myrb_sge *hw_sgl;
		dma_addr_t hw_sgl_addr;
		int i;

		hw_sgl =3D dma_pool_alloc(cb->sg_pool, GFP_ATOMIC, &hw_sgl_addr);
		if (!hw_sgl)
			return SCSI_MLQUEUE_HOST_BUSY;

Does returning SCSI_MLQUEUE_HOST_BUSY without calling scsi_dma_unmap() cause
a DMA mapping and IOMMU resource leak when the midlayer retries the command
and maps it again?

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
>  	case MODE_SENSE:
> @@ -1612,8 +1617,8 @@ static enum scsi_qc_status myrs_queuecommand(struct=
 Scsi_Host *shost,
> =20
>  			if ((scmd->cmnd[2] & 0x3F) !=3D 0x3F &&
>  			    (scmd->cmnd[2] & 0x3F) !=3D 0x08) {
> -				/* Illegal request, invalid field in CDB */
> -				scsi_build_sense(scmd, 0, ILLEGAL_REQUEST, 0x24, 0);
> +				scsi_set_sense(scmd, 0, ILLEGAL_REQUEST,
> +					       INVALID_FIELD_IN_CDB);
>  			} else {
>  				myrs_mode_sense(cs, scmd, ldev_info);

[Severity: Critical]
This is a pre-existing issue, but myrs_mode_sense() in drivers/scsi/myrs.c
has the identical bug as myrb_mode_sense() when writing the mode page block
descriptor:

static void myrs_mode_sense(struct myrs_hba *cs, struct scsi_cmnd *scmd,
		struct myrs_ldev_info *ldev_info)
{
...
		put_unaligned_be32(ldev_info->devsize_bytes, &block_desc[5]);

Does this similarly corrupt the 24-bit block length by writing a 32-bit val=
ue?

[Severity: High]
Additionally, this is another pre-existing issue in myrs_queuecommand() in
drivers/scsi/myrs.c. When processing commands with scatterlists, if
dma_pool_alloc() fails it returns SCSI_MLQUEUE_HOST_BUSY:

			hw_sgl =3D dma_pool_alloc(cs->sg_pool, GFP_ATOMIC,
						&hw_sgl_addr);
			if (WARN_ON(!hw_sgl)) {
				if (cmd_blk->dcdb) {
					dma_pool_free(cs->dcdb_pool,
						      cmd_blk->dcdb,
						      cmd_blk->dcdb_dma);
...
				return SCSI_MLQUEUE_HOST_BUSY;
			}

Since scsi_dma_map() was already called earlier in the function, does
returning here without calling scsi_dma_unmap() leak the DMA mapping?

[Severity: High]
Finally, in the same scatterlist loop in myrs_queuecommand(), there is a
sanity check on hw_sgl:

		scsi_for_each_sg(scmd, sgl, nsge, i) {
			if (WARN_ON(!hw_sgl)) {
				scsi_dma_unmap(scmd);
				scmd->result =3D (DID_ERROR << 16);
				scsi_done(scmd);
				return 0;
			}

When taking this error path, it calls scsi_done(scmd) but bypasses the norm=
al
completion routine myrs_handle_scsi(). Does this permanently leak the
dma_pool_alloc() blocks for cmd_blk->sense and cmd_blk->dcdb?

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20260903034201.1122=
11-1-dlemoal@kernel.org?part=3D22
