Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 889ED379EFF
	for <linux-scsi@vger.kernel.org>; Tue, 14 Jul 2026 10:43:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784025841; cv=none; b=lop/5/eIi9pPJvc0YIPH0XP8LZRhAfW/mVY9DQzoPUC5aasD6zj2t6JUTA2m0EbKbj77T5nmvnpgOo3TOBBJTys+kgrr9BFmTVcJYSKUVW0rrN9WN36JRXRKqDkY9BI1gLcJcOxC07xCcmaFUzIpxdyHSF3ZUt86Dmpj7olT59o=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784025841; c=relaxed/simple;
	bh=oKe8arVsOSDs1GEkdUGFOj88bV8mRw7tzHdrdtY8pDs=;
	h=From:Subject:To:Cc:In-Reply-To:References:Content-Type:Date:
	 Message-Id; b=OhJae6RIdjQ9Y3zrCTZwV6wzMjmaeJy2yb4VMFEIKrsiBip4CErAfylCePgx5cxli72EnYICvoKHkxHohZ23awwH0xTChEa7bPLWvoktum5YQ4vHoOSeSiwIabNKYzjTP+FDHrubUfP/Cwub5mi9h/T4lMqYae64v102GnlyjnA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=k++aqu3T; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="k++aqu3T"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 209991F000E9;
	Tue, 14 Jul 2026 10:43:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1784025835;
	bh=cr7ATUlgm3BmIH67TiAsp//wHXyPnoesV/Ckxdieb5I=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=k++aqu3TNLAc3zE95B+8W03WBnlfWH3E96aeCYqm5PM4K0whfUbEZXcy23vsDzVFp
	 +B8x4zDCZ0XywoCGuCUPlveOFeLhsA4cLSvPIGrXAPhD7Gp38pmpMVpTW1SWS6nxSE
	 9Vf9gyDwZYucGy54aX/7U+Q7GSuYNPKW+978xyBK2XyWerfCy2JS7XZlyXjZDZISXU
	 ottvQysPTlAC3RLMlPICKbU7ry2sNyyt3U9mprfJLRySUC4+pdoefAH8thnf+tCshD
	 7xmOtdA3A3FYvBLe5aC/gP+BySSiAZ5Y4fmwui3YVFZ9eVby2LM8VIzHspvRjw8vtt
	 kQM6zol7ZATeQ==
From: sashiko-bot@kernel.org
Subject: Re: [PATCH v4 05/56] scsi: qla2xxx: Add FC operational firmware
 load for 29xx
Reply-To: sashiko-reviews@lists.linux.dev
To: "Nilesh Javali" <njavali@marvell.com>
Cc: linux-scsi@vger.kernel.org
In-Reply-To: <20260714095353.289460-6-njavali@marvell.com>
References: <20260714095353.289460-1-njavali@marvell.com>
 <20260714095353.289460-6-njavali@marvell.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Tue, 14 Jul 2026 10:43:54 +0000
Message-Id: <20260714104355.209991F000E9@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>

Thank you for your contribution! Sashiko AI review found 3 potential issue(=
s) to consider:
- [High] Missing `.start_scsi` function pointer in `qla29xx_isp_ops` leads =
to NULL pointer dereference.
- [Medium] Out-of-bounds read and missing minimum size check in `qla29xx_lo=
ad_fw_template()`.
- [Low] Wasteful use of `vmalloc()` for a small, short-lived 80-byte struct=
ure (`struct fcop_header`).
--

--- Patch [5]: [PATCH v4 05/56] scsi: qla2xxx: Add FC operational firmware =
load for 29xx ---
commit 9c9c2ed926e65df8d7c92e4c4efc603458f304c5
Author: Manish Rangankar <mrangankar@marvell.com>

scsi: qla2xxx: Add FC operational firmware load for 29xx

This commit adds support for loading 29xx FC operational firmware from the
filesystem. It implements the request_firmware and segment-load pattern
used by earlier adapters and sets up the firmware dump template.

> diff --git a/drivers/scsi/qla2xxx/qla_init.c b/drivers/scsi/qla2xxx/qla_i=
nit.c
> index f5d230fc3642d..f6a8bcbb2a037 100644
> --- a/drivers/scsi/qla2xxx/qla_init.c
> +++ b/drivers/scsi/qla2xxx/qla_init.c
[ ... ]
> @@ -9128,6 +9131,539 @@ qla81xx_load_risc(scsi_qla_host_t *vha, uint32_t =
*srisc_addr)
[ ... ]
> +static int
> +qla29xx_load_risc_blob(scsi_qla_host_t *vha, uint32_t *srisc_addr)
> +{
> +	int rval;
> +	struct fcop_header *header;
> +	uint32_t *dcode =3D NULL;
> +	struct fw_blob *blob;
> +	__be32 *fwcode, *array1_addr, *array3_addr;
> +	uint templates;
> +	uint32_t array_size, risc_attr =3D 0;
> +	ulong i;
> +	uint j;
> +	ulong dlen, array3_offset;
> +	size_t max_dwords;
> +	struct qla_hw_data *ha =3D vha->hw;
> +	struct fwdt *fwdt =3D ha->fwdt;
> +
> +	header =3D vmalloc(sizeof(*header));

[Severity: Low]
Is it necessary to use vmalloc() for this 80-byte fcop_header structure?
Allocating such a small structure with vmalloc consumes a full page and TLB
entries. Would it be better to allocate this on the stack or use kzalloc()=
=20
instead?

> +	if (!header)
> +		return QLA_FUNCTION_FAILED;
[ ... ]
> +static int
> +qla29xx_load_fw_template(scsi_qla_host_t *vha)
> +{
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
> +	ql_dump_buffer(ql_dbg_init, vha, 0x006b, fw_dump_tmplt,
> +		       min_t(uint32_t, ha->fw_dump_tmplt_len, 1024));
> +
> +	for (j =3D 0; j < templates; j++, fwdt++) {
> +		vfree(fwdt->template);
> +		fwdt->template =3D NULL;
> +		fwdt->length =3D 0;
> +
> +		template_size =3D le32_to_cpu(((__le32 *)fw_dump_tmplt)[2]);

[Severity: Medium]
Could this access out-of-bounds memory?

This reads the third 32-bit word of the fw_dump_tmplt buffer. If the
flash or firmware advertises a ha->fw_dump_tmplt_len that is smaller
than 12 bytes, this will read past the end of the allocation. Should
there be a minimum size check against fw_dump_tmplt_len before this
access?

> +
> +		ql_dbg(ql_dbg_init, vha, 0x0161,
> +		       "-> fwdt%u template array at %p (0x%x bytes)\n",
> +		       j, fw_dump_tmplt, template_size);
[ ... ]
> diff --git a/drivers/scsi/qla2xxx/qla_os.c b/drivers/scsi/qla2xxx/qla_os.c
> index c3eb941f71ad9..6560e58ad87c7 100644
> --- a/drivers/scsi/qla2xxx/qla_os.c
> +++ b/drivers/scsi/qla2xxx/qla_os.c
[ ... ]
> @@ -2640,6 +2640,45 @@ static struct isp_operations qla27xx_isp_ops =3D {
>  	.initialize_adapter	=3D qla2x00_initialize_adapter,
>  };
> =20
> +static struct isp_operations qla29xx_isp_ops =3D {
> +	.pci_config		=3D qla25xx_pci_config,
> +	.reset_chip		=3D qla24xx_reset_chip,
[ ... ]
> +	.get_flash_version	=3D qla24xx_get_flash_version,
> +	.start_scsi_mq		=3D qla2xxx_dif_start_scsi_mq,
> +	.abort_isp		=3D qla2x00_abort_isp,

[Severity: High]
Does this isp_operations struct need a .start_scsi callback?

In qla2xxx_queuecommand(), if multiqueue is disabled via module parameters
(ql2xmqsupport=3D0) or falls back because MSI-X allocation fails, the code
bypasses the MQ path and invokes:

    rval =3D ha->isp_ops->start_scsi(sp);

Since the .start_scsi pointer is omitted for 29xx, won't this result in a
NULL pointer dereference?

> +	.iospace_config		=3D qla83xx_iospace_config,
> +	.initialize_adapter	=3D qla2x00_initialize_adapter,
> +};

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20260714095353.2894=
60-1-njavali@marvell.com?part=3D5
