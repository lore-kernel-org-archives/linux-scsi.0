Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7EE6339DBCF
	for <linux-scsi@vger.kernel.org>; Fri,  9 Oct 2026 04:05:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791518741; cv=none; b=GKZ+5JBkwbJChZf/bVe7/72UpgPG9gQsi/FSc+huiC7imxKZwzjmRPP8hjZGaB7tg+ofAHP0kB6QNrRAIYIf7PBRgn46l0HNtj4GieDtb8vLtbpHmWiT6Ufce/bXcTSHtU8FEH3ITwQ7LNzcY8pZMNlDwz/Dj8iSkXxwfTHsg0Q=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791518741; c=relaxed/simple;
	bh=ajWcB/USzDv6O28svNw3EMJrRl8FU0/fF1stsDafDqc=;
	h=Message-ID:From:Subject:To:Cc:In-Reply-To:References:Content-Type:
	 Date; b=ffZUCGo+IhtogtEC3S08yq+TW5SqUyTZQlwOdbPSDjDwKw644zO8hzUQZw3iE+l9oofaMyp5zRGgypv0spwKCuq3Ef6idOKQbH8V6/3OMFDuKsX3NAMEWEXSmzaE9oGYHYXhKbnJ43RJLLiNabd8fdq5gzzixMONK60DNQUuHd0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=bQfrSGFT; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="bQfrSGFT"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AE1441F000FF;
	Fri,  9 Oct 2026 04:05:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1791518728;
	bh=Yw3SRfVkuLCkpwMOCDZzfyBenrcYGdW0XxTG2fV2Ul8=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=bQfrSGFTYwRn6LbE0aIp8bTmQydBxxvxWN2sKi+nzrsWIwdzKxn/IHBpek3ezrzhu
	 icRL4FyID0RarkMUBmZVe6XbXoWmYlJkd1dAxwPYrbGka8nAYbwIYwmc4vcIdCbf3w
	 L6QgeSkPPoEw1aDJgYQuTOu7ho6OKxI7cKuPzP00Wozs4nXh9AwOMmQV1FP5Qc/gGq
	 YA4WGizQLlSfXIuA5Qvg0hXNgUCoeccZr7XNw5uDrIAJR45bBiLphDmLPQFkVFB2qa
	 tanwy5Buv5V7BIjRtry9GjfmmlbfKmJLBeOYq1U21MmkPbSGyFSQtWS2lD5VewBYRa
	 BVn9xA8a0yCrA==
Message-ID: <sashiko-outbox-164810@kernel.org>
From: sashiko-bot@kernel.org
Subject: Re: [PATCH v3 1/4] scsi: libsas: Fix out-of-bounds memcpy in
 sas_ssp_task_response()
Reply-To: sashiko-reviews@lists.linux.dev
To: "Xingui Yang" <yangxingui@huawei.com>
Cc: linux-scsi@vger.kernel.org
In-Reply-To: <20261009033238.1076098-2-yangxingui@huawei.com>
References: <20261009033238.1076098-1-yangxingui@huawei.com>
 <20261009033238.1076098-2-yangxingui@huawei.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Fri, 09 Oct 2026 04:05:28 +0000
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>

Thank you for your contribution! Sashiko AI review found 2 potential issue(=
s) to consider:
- [High] scsi: libsas: OOB read in sas_ssp_task_response due to LLDD buffer=
 sizing
- [Medium] scsi: mvsas: info leak in mvs_fill_ssp_resp_iu() due to missing =
cpu_to_be32
--

commit ff340fa9f4f2ad2be27ec82fd5912bea06443c68
Author: Xingui Yang <yangxingui@huawei.com>

scsi: libsas: Fix out-of-bounds memcpy in sas_ssp_task_response()

This commit changes the min_t clamp of sense_data_len in
sas_ssp_task_response() from int to u32. This prevents negative lengths
from causing out-of-bounds reads and writes during memcpy when the
device provides a value greater than or equal to 0x80000000.

> diff --git a/drivers/scsi/libsas/sas_task.c b/drivers/scsi/libsas/sas_tas=
k.c
> index e9d291007817b..2080e5836179b 100644
> --- a/drivers/scsi/libsas/sas_task.c
> +++ b/drivers/scsi/libsas/sas_task.c
> @@ -25,7 +25,7 @@ void sas_ssp_task_response(struct device *dev, struct s=
as_task *task,
>  	case SAS_DATAPRES_SENSE_DATA:
>  		tstat->stat =3D SAS_SAM_STAT_CHECK_CONDITION;
>  		tstat->buf_valid_size =3D
> -			min_t(int, SAS_STATUS_BUF_SIZE,
> +			min_t(u32, SAS_STATUS_BUF_SIZE,
>  			      be32_to_cpu(iu->sense_data_len));

[Severity: Medium]
Does this change inadvertently expose an information leak on little-endian
architectures?

In drivers/scsi/mvsas/mv_sas.c:mvs_fill_ssp_resp_iu(), the driver assigns
the native integer 17 to the __be32 field iu->sense_data_len:

mvs_fill_ssp_resp_iu() {
	...
	iu->sense_data_len =3D 17;
	...
}

On little-endian architectures, be32_to_cpu() evaluates this as 285212672.
The min_t clamp then evaluates to 96 bytes. Because mvs_set_sense() only
initializes the first 17 bytes, the subsequent memcpy() copies an
additional 79 bytes of uninitialized DMA memory into the task status
buffer.

This uninitialized memory is then copied into the SCSI sense buffer in
drivers/scsi/libsas/sas_scsi_host.c:sas_end_task():

sas_end_task() {
	...
	memcpy(sc->sense_buffer, ts->buf,
	       min(SCSI_SENSE_BUFFERSIZE, ts->buf_valid_size));
	...
}

Could this expose the leaked DMA memory to upper layers and potentially
userspace via the SG_IO ioctl?

>  		memcpy(tstat->buf, iu->sense_data, tstat->buf_valid_size);

[Severity: High]
Can this memcpy read out-of-bounds from the underlying LLDD DMA buffer?

The function clamps the copy length to SAS_STATUS_BUF_SIZE (96 bytes),
but it does not verify if the LLDD actually provided 96 bytes of
physically backed space for iu->sense_data.

For example, in drivers/scsi/pm8001/pm8001_hwi.c:mpi_ssp_completion(),
the ssp_response_iu is embedded in an iomb queue element which is
physically only 64 bytes (or 128 bytes for SPCV). Inside the 64-byte
iomb, the sense_data field starts at offset 44, leaving only 20 bytes
of available space.

If a malicious or malfunctioning SAS target provides a sense_data_len
of 96 or greater, reading 96 bytes here forces an out-of-bounds read
past the end of the iomb queue element.

Could this copy sensitive data from adjacent DMA completion ring
elements (like command tags, statuses, and memory addresses) into the
task status buffer, leading to a kernel memory information leak?

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20261009033238.1076=
098-1-yangxingui@huawei.com?part=3D1
