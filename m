Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1FD9332860F
	for <linux-scsi@vger.kernel.org>; Fri, 12 Jun 2026 10:11:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1781259121; cv=none; b=elnh5TlOGOuAYxdEt1muSU1H0LzlhzPwlDuTFIVWVbp3AmWzZjmDoNvAgVyxbcItpGv8ziKIhpkLyKCSv16EvCpNE9IhqagtyUg0qyYvrNBjxDxV/X+b58Rz0wStjlqxfFkZvvyyjWVWzH6uHR1w12RuV1nLT0H7Rz8/DAeM6VQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1781259121; c=relaxed/simple;
	bh=M8EO0aQNjF0IC33rZk0u/2GZouFz5ArAvkUVnJMMa9Y=;
	h=From:Subject:To:Cc:In-Reply-To:References:Content-Type:Date:
	 Message-Id; b=sy48EKNRRWloESN9amhcytIIqhYgL2iKEP9EIvJFmyAqcX1+TAu1eXeKDvb/+bXXShoVVuF88cSDscJGzU6ijJbIUYJm2LwsA1P6ppaw0MKY8JE4Q0OEutf35EQN/xDqsUKW3qhnyB1VpGBGIYij9RWpjq3GZOtTdN1K0I1WWlM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=D5DQzmVY; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="D5DQzmVY"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 82BE31F000E9;
	Fri, 12 Jun 2026 10:11:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1781259119;
	bh=n0eMIJNRSqRk8OceouO6DTPe8OeG4nLgQIczoxGtUyk=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=D5DQzmVYrE+6n7zaOibU4X75VI2FHHslcz6Kz11qwd3eQ9jwoeQnik5PJDjEHneMQ
	 mFypJKNjdnGQw90VADrBG2o/VkR2TiEzOJUQjMK/obb23KaJulr6Gn6lmUmaupVd0E
	 2lLp6vjXPAcl3QT7bmaMAQ5jHk+0RGj95kA6iCa1KSlA7yseFxAkwRznbcqOteC0Yf
	 pdLedfFHPIFRHhbGjmXKdGEBVioIXfh5oQl8MlgH+dVKmg7qUM8kZLEJG+3wtua7Ro
	 j1FIx8MVWcSCkRvfVZcoNItWIDqfhgbv5Y9miaboRiGA7ZVv9/mE3CuiO2319HigU+
	 ojzBXmXw+oq3Q==
From: sashiko-bot@kernel.org
Subject: Re: [PATCH v2 07/60] scsi: qla2xxx: Add flash block read/write BSG
 support for 29xx
Reply-To: sashiko-reviews@lists.linux.dev
To: "Nilesh Javali" <njavali@marvell.com>
Cc: linux-scsi@vger.kernel.org
In-Reply-To: <20260612095333.1666592-8-njavali@marvell.com>
References: <20260612095333.1666592-8-njavali@marvell.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Fri, 12 Jun 2026 10:11:58 +0000
Message-Id: <20260612101159.82BE31F000E9@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>

Thank you for your contribution! Sashiko AI review found 1 potential issue(=
s) to consider:
- [Medium] Silent truncation of the 32-bit `region` parameter to 16 bits in=
 BSG flash read/write handlers.
--

commit 42123b5c17ee809c301462b168b534861a97e40d
Author: Manish Rangankar <mrangankar@marvell.com>

scsi: qla2xxx: Add flash block read/write BSG support for 29xx

Introduce QL_VND_READ_FLASH_BLOCK and QL_VND_WRITE_FLASH_BLOCK
BSG vendor commands so that userspace tools can perform flash
block-level operations on 29xx adapters via the isp_ops interface.

> diff --git a/drivers/scsi/qla2xxx/qla_bsg.c b/drivers/scsi/qla2xxx/qla_bs=
g.c
> index 5e910b5ca670d..0baf486e8fb89 100644
> --- a/drivers/scsi/qla2xxx/qla_bsg.c
> +++ b/drivers/scsi/qla2xxx/qla_bsg.c
[ ... ]
> +static int qla29xx_bsg_flash_block_read(struct bsg_job *bsg_job)
> +{
[ ... ]
> +	buf =3D ha->isp_ops->read_optrom_region(vha, brcmd->region, opts,
> +				ha->optrom_buffer, ha->optrom_region_start,
> +				ha->optrom_region_size);

[Severity: Medium]
Does this code silently truncate brcmd->region?=20

The qla_block_rw structure defines region as a uint32_t, but the
read_optrom_region() function pointer takes a uint16_t for the reg_code
parameter.

If userspace passes a region ID greater than 0xFFFF, this will silently
truncate the ID instead of returning -EINVAL. Could this lead to accidental
firmware corruption if an invalid region ID wraps around to a valid one?

[ ... ]
> +static int qla29xx_bsg_flash_block_write(struct bsg_job *bsg_job)
> +{
[ ... ]
> +	rval =3D ha->isp_ops->write_optrom_region(vha, bwcmd->region, opts,
> +				ha->optrom_buffer, ha->optrom_region_start,
> +				ha->optrom_region_size);

[Severity: Medium]
Similarly, does this silently truncate bwcmd->region from uint32_t to
uint16_t when passing it to write_optrom_region()?

> diff --git a/drivers/scsi/qla2xxx/qla_bsg.h b/drivers/scsi/qla2xxx/qla_bs=
g.h
> index a920c8e482bc6..ca0d83986b57f 100644
> --- a/drivers/scsi/qla2xxx/qla_bsg.h
> +++ b/drivers/scsi/qla2xxx/qla_bsg.h
[ ... ]
> +struct qla_block_rw {
> +	uint32_t region;
> +	uint32_t rw_length;
> +	uint32_t options;
> +	uint32_t region_offset;
> +	uint32_t chunk_length;
> +	uint8_t  reserved[44];
> +} __packed;

> diff --git a/drivers/scsi/qla2xxx/qla_def.h b/drivers/scsi/qla2xxx/qla_de=
f.h
> index 1ec7ee578e0c3..719b6a1f9123a 100644
> --- a/drivers/scsi/qla2xxx/qla_def.h
> +++ b/drivers/scsi/qla2xxx/qla_def.h
> @@ -3534,6 +3534,13 @@ struct isp_operations {
>  	int (*write_optrom)(struct scsi_qla_host *, void *, uint32_t,
>  		uint32_t);
> =20
> +	void *(*read_optrom_region)(struct scsi_qla_host *vha,
> +		uint16_t reg_code, uint16_t opts, void *buf,
> +		uint32_t offset, uint32_t length);
> +	int (*write_optrom_region)(struct scsi_qla_host *vha,
> +		uint16_t reg_code, uint16_t opts, void *buf,
> +		uint32_t offset, uint32_t length);
> +

The function pointers use uint16_t for reg_code, but the caller above
provides a uint32_t.

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20260612095333.1666=
592-1-njavali@marvell.com?part=3D7
