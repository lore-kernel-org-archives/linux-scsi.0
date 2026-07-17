Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9296D367B8C
	for <linux-scsi@vger.kernel.org>; Fri, 17 Jul 2026 15:53:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784303602; cv=none; b=EPBVM/QIQs3MjEfcm7t58Gtg479drHPmY+MyEYDjTplOm8Z05BDIvudJsHjgwMG9ezmWbiB1L/FU7k6qNzrYmVKudXbIGAVE/mu18jjQ4hR3OSxTmTA6hZtrf6ZU8ijQxkPG6g7vljsOcAvtt259gM7pxNOf0W8zSR7BnefaNlI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784303602; c=relaxed/simple;
	bh=AWy5mkqyzNH+lq9Qe5ziBU+nyGagNWCgiBwak427kmo=;
	h=From:Subject:To:Cc:In-Reply-To:References:Content-Type:Date:
	 Message-Id; b=bgSBwxZZIAM7m3jLgBNTmeXSoPBwakYTNxepTn2435pDMYGDi8LlFF7UG/9wj/+wlRvqbsOANbXp9iz3+6AAVG6hTizh1ZH0BMr4Fq2tT1wWnB60QEiHhbRsK/KDld6vrsMiDCo92e86Vw5v6GMBbiCYYcY5nf62MklOx903TcA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=NQxbz0jD; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="NQxbz0jD"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 56AB61F00A3A;
	Fri, 17 Jul 2026 15:53:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1784303601;
	bh=GA0y42EuII1E4hRQZxIDprTdZy184YnICtZ3GBC+Sk4=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=NQxbz0jDxcnm90k4wmh4WUv8+CVGzfwRrF5OYXH+MYM+gcjrwzZH7g9+EtUOkqQxp
	 lA7d7B53xOz57OKd2vXSmWYdkk6DwxbQf7st9OzXmGo5GE/OmQQ19npizLLKQo8tx3
	 LGUUARhUdv4nKW9nxbLA8KNBRc5iI5HnallBB7+Ope82yDG38HtMlMKuhfEf6FcZSv
	 CX+n7zcyJj6xmF8bpU3Q/LU89QLXHhSra73BMqORoiHwtPh8eHCrpqn/REydmDh/l0
	 L0LpgHDLdfy1WDkXua1uqEoFpGsp1jNpmcoTH00D2ej1bLOZ8ojsEGNfzkoe7w3tLM
	 LZMq8CJi1luNg==
From: sashiko-bot@kernel.org
Subject: Re: [PATCH v5 05/56] scsi: qla2xxx: Add FC operational firmware
 load for 29xx
Reply-To: sashiko-reviews@lists.linux.dev
To: "Nilesh Javali" <njavali@marvell.com>
Cc: linux-scsi@vger.kernel.org
In-Reply-To: <20260717152904.3155730-6-njavali@marvell.com>
References: <20260717152904.3155730-1-njavali@marvell.com>
 <20260717152904.3155730-6-njavali@marvell.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Fri, 17 Jul 2026 15:53:20 +0000
Message-Id: <20260717155321.56AB61F00A3A@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>

Thank you for your contribution! Sashiko AI review found 4 potential issue(=
s) to consider:
- [Critical] The `qla29xx_isp_ops` structure is missing the `.start_scsi` f=
unction pointer, leading to a NULL pointer dereference.
- [High] `qla29xx_load_fw_template` misinterprets the template size, trunca=
ting the buffer, and incorrectly copies the flash wrapper header.
- [Medium] Missing bounds check on `ha->fw_dump_tmplt_len` before parsing t=
emplate size in `qla29xx_load_fw_template`.
- [Medium] Flawed bounds check when reading `risc_attr` from Array 1 in `ql=
a29xx_load_risc_blob()`.
--

--- Patch [5]: [PATCH v5 05/56] scsi: qla2xxx: Add FC operational firmware =
load for 29xx ---
commit 1d779103e29201d2b067488fba6b287ea9f225e4
Author: Manish Rangankar <mrangankar@marvell.com>
scsi: qla2xxx: Add FC operational firmware load for 29xx

This commit adds support for loading 29xx FC operational firmware from the
filesystem. It also sets up the corresponding firmware dump template follow=
ing
the request_firmware and segment-load pattern used by earlier adapters.

> diff --git a/drivers/scsi/qla2xxx/qla_init.c b/drivers/scsi/qla2xxx/qla_i=
nit.c
> index c6e928f11758c..5b0dc9b0a679c 100644
> --- a/drivers/scsi/qla2xxx/qla_init.c
> +++ b/drivers/scsi/qla2xxx/qla_init.c
[ ... ]
> @@ -9128,6 +9131,539 @@ qla81xx_load_risc(scsi_qla_host_t *vha, uint32_t =
*srisc_addr)
> +static int
> +qla29xx_load_risc_blob(scsi_qla_host_t *vha, uint32_t *srisc_addr)
> +{
[ ... ]
> +		/* Array 2 */
> +		offset +=3D header->array1_length;
> +		if (offset + header->array2_length > fw_size) {
> +			ql_log(ql_log_fatal, vha, 0x0098,
> +			       "FW image too small for Arr2 (%#zx > %#zx).\n",
> +			       offset + header->array2_length, fw_size);
> +			goto img_corrupt;
> +		}
> +		rval =3D qla29xx_process_rd_image(vha, header,
> +			(__be32 *)((char *)fwcode + offset),
> +			ARR2, header->array2_destination_addr,
> +			header->array2_length);
> +		if (rval) {
> +			ql_log(ql_log_fatal, vha, 0x0098,
> +			       "-> Failed load Arr2\n");
> +			goto img_corrupt;
> +		}
> +
> +		/* Array 3: FW_DUMP template */
> +		if (offset + 10 * sizeof(__be32) > fw_size) {
> +			ql_log(ql_log_fatal, vha, 0x0098,
> +			       "FW image too small for risc_attr.\n");
> +			goto img_corrupt;
> +		}
> +		array1_addr =3D (__be32 *)((char *)fwcode +
> +				header->header_length +
> +				header->tim_length);
> +		risc_attr =3D be32_to_cpu(array1_addr[9]);

[Severity: Medium]
Does this bounds check correctly protect the read from array1_addr?=20

At this point, offset has already been advanced to the start of Array 2.
This checks if there are 40 bytes available after Array 2, but doesn't
verify if Array 1 itself is at least 40 bytes long. If Array 1 is
undersized, array1_addr[9] will erroneously read into Array 2 data.

[ ... ]
> +static int
> +qla29xx_load_fw_template(scsi_qla_host_t *vha)
> +{
> +	struct qla_hw_data *ha =3D vha->hw;
> +	struct fwdt *fwdt =3D ha->fwdt;
> +	uint templates =3D 1;
[ ... ]
> +	for (j =3D 0; j < templates; j++, fwdt++) {
> +		vfree(fwdt->template);
> +		fwdt->template =3D NULL;
> +		fwdt->length =3D 0;
> +
> +		template_size =3D le32_to_cpu(((__le32 *)fw_dump_tmplt)[2]);

[Severity: Medium]
Could ha->fw_dump_tmplt_len be less than 12 bytes here? If the flash layout
defines a length smaller than 12, this array index will read out of bounds
of the kzalloc buffer.

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

[Severity: High]
Is template_size stored in dwords in the flash region? If so,
vmalloc(template_size) allocates 1/4th of the required memory.

Also, does the memcpy() need to skip the 7-dword flash wrapper header? As
written, it copies the header into fwdt->template, which will cause
qla27xx_fwdt_template_valid() to fail.

Furthermore, the loop hardcodes templates =3D 1 and doesn't advance
fw_dump_tmplt, which ignores any secondary MPI firmware dump template.

> +
> +		if (!qla27xx_fwdt_template_valid(dcode)) {
> +			ql_log(ql_log_warn, vha, 0x0165,
> +			       "-> fwdt%u failed template validate (rval %x)\n",
> +			       j, rval);
> +			goto failed;
> +		}
[ ... ]
> diff --git a/drivers/scsi/qla2xxx/qla_os.c b/drivers/scsi/qla2xxx/qla_os.c
> index c3eb941f71ad9..6560e58ad87c7 100644
> --- a/drivers/scsi/qla2xxx/qla_os.c
> +++ b/drivers/scsi/qla2xxx/qla_os.c
> @@ -2640,6 +2640,45 @@ static struct isp_operations qla27xx_isp_ops =3D {
>  	.initialize_adapter	=3D qla2x00_initialize_adapter,
>  };
> =20
> +static struct isp_operations qla29xx_isp_ops =3D {
> +	.pci_config		=3D qla25xx_pci_config,
> +	.reset_chip		=3D qla24xx_reset_chip,
> +	.chip_diag		=3D qla24xx_chip_diag,
> +	.config_rings		=3D qla24xx_config_rings,
> +	.reset_adapter		=3D qla24xx_reset_adapter,
> +	.nvram_config		=3D qla81xx_nvram_config,
> +	.update_fw_options	=3D qla24xx_update_fw_options,
> +	.load_risc		=3D qla29xx_load_risc,
> +	.pci_info_str		=3D qla24xx_pci_info_str,
> +	.fw_version_str		=3D qla24xx_fw_version_str,
> +	.intr_handler		=3D qla24xx_intr_handler,
> +	.enable_intrs		=3D qla24xx_enable_intrs,
> +	.disable_intrs		=3D qla24xx_disable_intrs,
> +	.abort_command		=3D qla24xx_abort_command,
> +	.target_reset		=3D qla24xx_abort_target,
> +	.lun_reset		=3D qla24xx_lun_reset,
> +	.fabric_login		=3D qla24xx_login_fabric,
> +	.fabric_logout		=3D qla24xx_fabric_logout,
> +	.calc_req_entries	=3D NULL,
> +	.build_iocbs		=3D NULL,
> +	.prep_ms_iocb		=3D qla24xx_prep_ms_iocb,
> +	.prep_ms_fdmi_iocb	=3D qla24xx_prep_ms_fdmi_iocb,
> +	.read_nvram		=3D NULL,
> +	.write_nvram		=3D NULL,
> +	.fw_dump		=3D qla27xx_fwdump,
> +	.mpi_fw_dump		=3D qla27xx_mpi_fwdump,
> +	.beacon_on		=3D qla24xx_beacon_on,
> +	.beacon_off		=3D qla24xx_beacon_off,
> +	.beacon_blink		=3D qla83xx_beacon_blink,
> +	.read_optrom		=3D qla25xx_read_optrom_data,
> +	.write_optrom		=3D qla24xx_write_optrom_data,
> +	.get_flash_version	=3D qla24xx_get_flash_version,
> +	.start_scsi_mq		=3D qla2xxx_dif_start_scsi_mq,
> +	.abort_isp		=3D qla2x00_abort_isp,
> +	.iospace_config		=3D qla83xx_iospace_config,
> +	.initialize_adapter	=3D qla2x00_initialize_adapter,
> +};

[Severity: Critical]
Is the missing .start_scsi pointer here intentional?=20

If ha->mqenable is false or the designated qpair is NULL (e.g., due to a=20
queue mapping failure or fallback to single-queue mode),=20
qla2xxx_queuecommand() falls back to the legacy single-queue path by calling
ha->isp_ops->start_scsi(sp).=20

Since this pointer is omitted, it defaults to NULL and will result in a NULL
pointer dereference.

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20260717152904.3155=
730-1-njavali@marvell.com?part=3D5
