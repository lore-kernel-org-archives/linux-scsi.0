Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F355115B971
	for <linux-scsi@vger.kernel.org>; Fri, 12 Jun 2026 10:15:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1781259302; cv=none; b=VPo7VVG1kuYyZdpJYhhgPzA6HOz6sOIHEhZGNlzL95CNvN5/CR7V8eq4zpvjt6POZFVn69W5Av0BuVuDLjmEoAnmCP8+V6XUqTZniqnHDkOQKw5euzV+iRpHEANioA4eBqWDLJMGiKajtryqXBjkbz8sVniGKMnhM4uSGcq6mAM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1781259302; c=relaxed/simple;
	bh=FnpXh4nMhZc45/ve8Kxs08IifmgadZvtiTOx9fLeDL8=;
	h=From:Subject:To:Cc:In-Reply-To:References:Content-Type:Date:
	 Message-Id; b=aX4m8o0tLLEEi8oYDXj+4bVxJj0z1m39BLpWv2FIyFL3MVa6PyT5sG9BT5mh+ha8wKGX52ovTq+4HKlfFvDT8xT6JeDw1t/jrloMRL1evPmdnZNtxu8+DJnTuMuZb5LoK2IYydQcko/Egi31in5OtXzo00TsBCbQUkuoK4ERaqs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=HQvcU7Un; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="HQvcU7Un"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6CBD21F000E9;
	Fri, 12 Jun 2026 10:15:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1781259300;
	bh=37Xu6cvOBZx1zOZ/cMJeZwgzDg9Fd/EIl/KyAX3AI50=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=HQvcU7UnI2wxJy2U6WLR0ujo0BF/HR8jb/aqemzwpMi/TbUpxEQqTIiL8i3+jeDQQ
	 Br65SlBoHIhaXMJztQJDOhH9Ykn23otNEd+UFJWG1L4vI9sYDK1tU6YDsmh9qr43ba
	 J4q27naD9blBTDmrlvIwxZKP9dwtWeRW/sPSKbkmPGQzOF7B8x/w63EfG3TaDA2BAW
	 isFld44LlUAE2YOqpLNzv/kspxCvwYXChEJyUQQVOhykoKV0To8GdLeNJjW3ZqC3dA
	 QYZz/QoEBfPDNXDDHPGdtVUUR9bXJSqXzzb9RXAQGOKnYSp0JOQlWeaxMGbjq4JXeL
	 8QGtQYbxvl+bQ==
From: sashiko-bot@kernel.org
Subject: Re: [PATCH v2 08/60] scsi: qla2xxx: Add BSG MPI firmware load/dump
 for 29xx
Reply-To: sashiko-reviews@lists.linux.dev
To: "Nilesh Javali" <njavali@marvell.com>
Cc: linux-scsi@vger.kernel.org
In-Reply-To: <20260612095333.1666592-9-njavali@marvell.com>
References: <20260612095333.1666592-9-njavali@marvell.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Fri, 12 Jun 2026 10:14:59 +0000
Message-Id: <20260612101500.6CBD21F000E9@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>

Thank you for your contribution! Sashiko AI review found 3 potential issue(=
s) to consider:
- [High] The implementations of LOAD and DUMP MPI commands are semantically=
 reversed, leading to firmware data corruption.
- [High] Incorrect address scaling in `qla29xx_mpi_optrom_data()` mixes byt=
e offsets with word counts during burst transfers, causing corrupted memory=
 chunks.
- [Medium] Applying Option ROM (Flash) bounds to MPI RAM addresses causes s=
purious rejections and truncated transfers.
--

commit b9c1c98154245d3fd8c709eb1527874ff55f8c3a
Author: Manish Rangankar <mrangankar@marvell.com>

scsi: qla2xxx: Add BSG MPI firmware load/dump for 29xx

Add BSG vendor commands for loading and dumping MPI firmware on
29xx adapters. This extends the existing BSG infrastructure with
the necessary mailbox wrappers and flash helpers for MPI
operations.

> diff --git a/drivers/scsi/qla2xxx/qla_bsg.c b/drivers/scsi/qla2xxx/qla_bs=
g.c
> index 0baf486e8fb89..92a0bc6dc7bcd 100644
> --- a/drivers/scsi/qla2xxx/qla_bsg.c
> +++ b/drivers/scsi/qla2xxx/qla_bsg.c
> @@ -1756,6 +1756,153 @@ static int qla29xx_bsg_flash_block_write(struct b=
sg_job *bsg_job)
>  	return 0;
>  }
> =20
> +static int qla2900_bsg_dump_mpi(struct bsg_job *bsg_job)
> +{
[ ... ]
> +	mutex_lock(&ha->optrom_mutex);
> +	rval =3D qla2x00_optrom_setup(bsg_job, vha, dmcmd->mpi_address, 1);

[Severity: Medium]
Will this correctly validate the MPI RAM boundaries? It looks like
qla2x00_optrom_setup() validates the start parameter against ha->optrom_siz=
e,
which is the physical size of the flash chip, not the MPI RAM size. Could
this falsely reject or truncate valid MPI RAM addresses if they exceed the
flash size limits?

> +	if (rval) {
> +		mutex_unlock(&ha->optrom_mutex);
> +		return rval;
> +	}
> +
> +	sg_copy_to_buffer(bsg_job->request_payload.sg_list,
> +			  bsg_job->request_payload.sg_cnt, ha->optrom_buffer,
> +			  ha->optrom_region_size);
[ ... ]
> +	rval =3D qla29xx_mpi_optrom_data(vha, opts, ha->optrom_buffer,
> +				       ha->optrom_region_start,
> +				       ha->optrom_region_size,
> +				       QLA29XX_MPI_OP_DUMP);

[Severity: High]
Are the semantics of DUMP and LOAD reversed here? The function is named
qla2900_bsg_dump_mpi(), but it copies data from the user's request_payload
and passes QLA29XX_MPI_OP_DUMP, which acts as a Write operation to the
device. Usually, dumping firmware implies reading it from the device into a
buffer.

[ ... ]
> +static int qla2900_bsg_load_mpi(struct bsg_job *bsg_job)
> +{
[ ... ]
> +	mutex_lock(&ha->optrom_mutex);
> +	rval =3D qla2x00_optrom_setup(bsg_job, vha, lmcmd->mpi_address, 0);

[Severity: Medium]
Similar to qla2900_bsg_dump_mpi(), this passes lmcmd->mpi_address to
qla2x00_optrom_setup(). Could this result in the transfer being silently
truncated if the requested MPI RAM address space differs from the flash
size constraints?

> +	if (rval) {
[ ... ]
> +	rval =3D qla29xx_mpi_optrom_data(vha, opts, ha->optrom_buffer,
> +				       ha->optrom_region_start,
> +				       ha->optrom_region_size,
> +				       QLA29XX_MPI_OP_LOAD);
[ ... ]
> +	sg_copy_from_buffer(bsg_job->reply_payload.sg_list,
> +			    bsg_job->reply_payload.sg_cnt,
> +			    ha->optrom_buffer,
> +			    ha->optrom_region_size);

[Severity: High]
This function is named qla2900_bsg_load_mpi(), but it appears to be reading
data from the device into the reply_payload (a Read operation). Standard
firmware conventions typically define LOAD as sending data to the device.
Could invoking these commands overwrite the adapter's MPI RAM with
uninitialized data due to the reversed directions?

> diff --git a/drivers/scsi/qla2xxx/qla_sup.c b/drivers/scsi/qla2xxx/qla_su=
p.c
> index 1d5ea5e432edc..af7509083910d 100644
> --- a/drivers/scsi/qla2xxx/qla_sup.c
> +++ b/drivers/scsi/qla2xxx/qla_sup.c
> @@ -527,6 +527,123 @@ qla29xx_read_optrom_data(struct scsi_qla_host *vha,=
 uint16_t reg_code,
[ ... ]
> +int
> +qla29xx_mpi_optrom_data(struct scsi_qla_host *vha, uint16_t opts, void *=
buf,
> +		       uint32_t offset, uint32_t length, enum qla29xx_mpi_optrom_op op)
> +{
[ ... ]
> +	mpi_addr =3D offset;
> +	dcode =3D (uint32_t *)optrom;
> +	memset(dcode, 0, OPTROM_BURST_SIZE);
> +
> +	fwcode =3D (uint32_t *)buf;
> +	mpi_size =3D length >> 2;
> +	burst =3D OPTROM_BURST_SIZE >> 2;
> +	total_chunks =3D (mpi_size + burst - 1) / burst;
> +
> +	while (mpi_size > 0) {
[ ... ]
> +		chunk_count++;
> +		fwcode +=3D burst;
> +		mpi_addr +=3D burst;
> +		mpi_size -=3D burst;
> +	}

[Severity: High]
Does this loop mix byte offsets with word counts? It looks like mpi_addr is
initialized to offset (a byte address from the user parameter), but it is
advanced by burst. Since burst is calculated as OPTROM_BURST_SIZE >> 2
(a count of 32-bit words), mpi_addr will only advance by a quarter of the
intended byte distance each iteration. Will this cause successive transfers
to heavily overlap and corrupt the firmware load or dump?

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20260612095333.1666=
592-1-njavali@marvell.com?part=3D8
