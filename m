Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2F6DF374A0C
	for <linux-scsi@vger.kernel.org>; Tue,  7 Jul 2026 06:17:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1783405057; cv=none; b=tDlaeTrP7Bin5snQFnPfpVOadPyyRr31qCbAuiMpiaOoOYzyuDGXQ3ey8AL2J5NaFPbHnc0hOYI9OBHK6OwMb06Z7+roJASgx7KoAd7QHt9kmjQoc001HLK72PoBHoY9XzrJwXjsQjY5+ae/cSFopdhM0gSQ1L3juZv8xu2G34g=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1783405057; c=relaxed/simple;
	bh=GB8xTwUlkGj4X3CneGwaeSnu3YIRX8lsX58Wn3fgkoc=;
	h=From:Subject:To:Cc:In-Reply-To:References:Content-Type:Date:
	 Message-Id; b=J3nQHWHafILXH1htUC8BFztzsqeJvlxK4hmcSe+IONdxGKoL8iVBtfudncCoxxDFNb0E7AGdrm/DuIzpTzdkETYmQjaKkK6jA/l7F8I2rLv17nCJOChC+xhp8nSs9Jie6DhBsb1O8vaYbA5QVoLeUYydckz1L6MGeWfwRrXqzWw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=DDyp0ovh; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="DDyp0ovh"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C80641F000E9;
	Tue,  7 Jul 2026 06:17:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1783405056;
	bh=Lkt/LiPUuXIZAOstQbn9u1jsWGVudl8FO8qtDfuTIiA=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=DDyp0ovhF++j6vjzcMcQVBbrM5FdT/qJ7AUpJA/z5xmCGN48LaGaez21hzqwDjNwZ
	 cPewWQsm2tVxD3/0zOKxQUW6MuM1Pbf5u9Qlcy/axxr9gnnXB5zcelZSFE8AW7PIJD
	 FHhayG4O588h1T4EtASD008fJom6RzgQcoFuwe/g0W8ZMLeyhIAopB5RfhZc7YiWWC
	 RFjVT6uniJR2CnoRKW7psSNU7keTNqROJ4vVTVhNJhRCNqcxmEXA//xy+nt8CLz4Kq
	 18h5uQia4gUmmzaoPFR0bMLREqCqEGy74bkZX07FDDcYxPuwKtu/BaOsFVkb56qaza
	 gIYXeQgk6/wSA==
From: sashiko-bot@kernel.org
Subject: Re: [PATCH v3 05/88] scsi: qla2xxx: Add FC operational firmware
 load for 29xx
Reply-To: sashiko-reviews@lists.linux.dev
To: "Nilesh Javali" <njavali@marvell.com>
Cc: linux-scsi@vger.kernel.org
In-Reply-To: <20260707055435.2680300-6-njavali@marvell.com>
References: <20260707055435.2680300-1-njavali@marvell.com>
 <20260707055435.2680300-6-njavali@marvell.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Tue, 07 Jul 2026 06:17:35 +0000
Message-Id: <20260707061735.C80641F000E9@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>

Thank you for your contribution! Sashiko AI review found 4 potential issue(=
s) to consider:
- [High] Endianness bug in `qla29xx_process_rd_image` breaks firmware loadi=
ng on little-endian hosts.
- [High] `qla29xx_isp_ops` assigns incompatible legacy optrom callbacks, le=
ading to hardware address corruption.
- [Medium] Unvalidated template size leads to Slab Out-of-Bounds read.
- [Medium] Hardcoded dump size in `ql_dump_buffer` can cause a Slab Out-of-=
Bounds read.
--

--- Patch [5]: [PATCH v3 05/88] scsi: qla2xxx: Add FC operational firmware =
load for 29xx ---
commit 75f7a974c78a546ee01a4760d5cbc3099056329d
Author: Manish Rangankar <mrangankar@marvell.com>

scsi: qla2xxx: Add FC operational firmware load for 29xx

This commit adds support to load 29xx FC operational firmware from the
filesystem and to set up the corresponding firmware dump template. It
follows the same request_firmware and segment-load pattern used by earlier
adapters in the driver.

> diff --git a/drivers/scsi/qla2xxx/qla_init.c b/drivers/scsi/qla2xxx/qla_i=
nit.c
> --- a/drivers/scsi/qla2xxx/qla_init.c
> +++ b/drivers/scsi/qla2xxx/qla_init.c
[ ... ]
> @@ -9128,6 +9131,537 @@ qla81xx_load_risc(scsi_qla_host_t *vha, uint32_t =
*srisc_addr)
[ ... ]
> +				if (is_first_segment)
> +					opt |=3D BIT_3;
> +				if (is_last_segment)
> +					opt |=3D BIT_4;
> +
> +				memcpy((char *)dcode, (char *)fwcode, size);
> +
> +			ql_dbg(ql_dbg_init, vha, 0x0098,

[Severity: High]
Does this break the DMA endianness translation on little-endian hosts?
The TIM section correctly uses swab32() to convert the big-endian firmware
blob into CPU-endian 32-bit words, but here the ARR sections use a raw
memcpy() in qla29xx_process_rd_image(). On little-endian architectures,
this will preserve the big-endian byte order in memory, potentially causing
the adapter DMA to receive byte-swapped instructions and fail to load the
firmware.

[ ... ]
> +	buf =3D qla29xx_read_optrom_data(vha, FLT_REG_FW_DUMP_TMPLT, 0,
> +				       fw_dump_tmplt, 0,
> +				       ha->fw_dump_tmplt_len);
> +	if (!buf) {
> +		ql_log(ql_log_info, vha, 0x0013,
> +		       "Unable to read fw dump temp info.\n");
> +		goto free_fw_dump;
> +	}
> +
> +	ql_dump_buffer(ql_dbg_init, vha, 0x006b,
> +		       (char *)fw_dump_tmplt, 1024);
> +

[Severity: Medium]
Could this hardcoded 1024-byte size cause a slab out-of-bounds read?
The fw_dump_tmplt buffer is allocated dynamically based on
ha->fw_dump_tmplt_len in qla29xx_load_fw_template(). If the actual template
length returned by the hardware is less than 1024 bytes, this will read
past the end of the kzalloc allocation when logging.

> +	for (j =3D 0; j < templates; j++, fwdt++) {
> +		vfree(fwdt->template);
> +		fwdt->template =3D NULL;
> +		fwdt->length =3D 0;
> +
> +		template_size =3D le32_to_cpu(((__le32 *)fw_dump_tmplt)[2]);
> +
> +		ql_dbg(ql_dbg_init, vha, 0x0161,
> +		       "-> fwdt%u template array at %p (0x%x bytes)\n",
> +		       j, fw_dump_tmplt, template_size);
> +
> +		if (!template_size || !~template_size ||
> +		    template_size > ha->fw_dump_tmplt_len) {
> +			ql_dbg(ql_dbg_init, vha, 0x0162,
> +			       "-> fwdt%u failed to read array\n", j);
> +			goto failed;
> +		}
> +
> +		fwdt->template =3D vmalloc(template_size);
> +		if (!fwdt->template) {
> +			ql_log(ql_log_warn, vha, 0x0164,
> +			       "-> fwdt%u failed allocate template.\n", j);
> +			goto failed;
> +		}
> +
> +		dcode =3D fwdt->template;
> +		memcpy((char *)dcode, (char *)fw_dump_tmplt, template_size);
> +
> +		if (!qla27xx_fwdt_template_valid(dcode)) {

[Severity: Medium]
Is there a missing minimum size check for template_size here?
If the template_size read from the flash template buffer is extremely
small (for example, 4 bytes), the vmalloc allocation succeeds, but
qla27xx_fwdt_template_valid() will read past the end of the allocated
buffer while verifying the template header, which requires up to 32 bytes.

[ ... ]
> diff --git a/drivers/scsi/qla2xxx/qla_os.c b/drivers/scsi/qla2xxx/qla_os.c
> --- a/drivers/scsi/qla2xxx/qla_os.c
> +++ b/drivers/scsi/qla2xxx/qla_os.c
[ ... ]
> @@ -2640,6 +2640,45 @@ static struct isp_operations qla27xx_isp_ops =3D {
[ ... ]
> +	.beacon_blink		=3D qla83xx_beacon_blink,
> +	.read_optrom		=3D qla25xx_read_optrom_data,
> +	.write_optrom		=3D qla24xx_write_optrom_data,
> +	.get_flash_version	=3D qla24xx_get_flash_version,

[Severity: High]
Are these legacy optrom callbacks compatible with the 29xx initialization?
In qla2x00_probe_one(), the ha->flash_data_off for 29xx adapters is
initialized to ~0 (0xFFFFFFFF). If qla25xx_read_optrom_data calculates the
hardware flash address by evaluating ha->flash_data_off + offset, it will
wrap around to offset - 1. Could this lead to corrupted hardware address
reads if an unprivileged user reads the sysfs optrom node?

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20260707055435.2680=
300-1-njavali@marvell.com?part=3D5
