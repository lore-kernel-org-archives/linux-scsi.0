Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D5B053911A9
	for <linux-scsi@vger.kernel.org>; Thu, 23 Jul 2026 06:44:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784789054; cv=none; b=n6cwE+04gC37j4iWZtB4yZGozRrE0lm7Xc5w46vvVm6+hkuHNDK8nYex27JebpVbEqxi1NfboqfmIq3kqi3DPKVnVUJmiW0ESVjNWcsubIldS6gJOt3LY7P5rVo4Q+paldXA0pCcmDJhhYoZ4DHeVxwTLZfp41rL9RQ6nh96+nI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784789054; c=relaxed/simple;
	bh=P5xCRp+XX6QKLyj5p1Lt5Rmep3nGBZCA30WZMe5W94c=;
	h=From:Subject:To:Cc:In-Reply-To:References:Content-Type:Date:
	 Message-Id; b=JdjdO8OSf8SzQaqkvSDyRaSRl7T3jGE/s8Z/scIi71Usrim/CuYmlRyDyH6JBHEDxD/mOQWdYHtbffYbZ11SsLPgLH/VDqI5BJ2qLusTI0n/1rk7dYDZqCdvfgYFnJbVDacq2A+b8Yi5vmNPn4sj7Z4WcpZdiGsS8BHNGBkhSQ0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9BADD1F000E9;
	Thu, 23 Jul 2026 06:44:10 +0000 (UTC)
From: sashiko-bot@kernel.org
Subject: Re: [PATCH v6 05/56] scsi: qla2xxx: Add FC operational firmware
 load for 29xx
Reply-To: sashiko-reviews@lists.linux.dev
To: "Nilesh Javali" <njavali@marvell.com>
Cc: linux-scsi@vger.kernel.org
In-Reply-To: <20260723050413.3897522-6-njavali@marvell.com>
References: <20260723050413.3897522-1-njavali@marvell.com>
 <20260723050413.3897522-6-njavali@marvell.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Thu, 23 Jul 2026 06:44:10 +0000
Message-Id: <20260723064410.9BADD1F000E9@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>

Thank you for your contribution! Sashiko AI review found 6 potential issue(=
s) to consider:

New issues:
- [High] The `.start_scsi` function pointer is missing from the `qla29xx_is=
p_ops` structure.
- [High] The `.read_optrom` and `.write_optrom` callbacks in `qla29xx_isp_o=
ps` incorrectly use legacy handlers that trigger invalid flash accesses.
- [High] `qla29xx_load_fw_template()` misinterprets the firmware dump templ=
ate size as bytes instead of dwords, leading to severe memory under-allocat=
ion.
- [High] `qla29xx_load_fw_template()` fails to skip the flash region header=
 when extracting the firmware dump template, breaking validation.
- [High] Firmware dump template validation failures in 29xx load paths inco=
rrectly abort the entire adapter initialization.

Pre-existing issues:
- [High] Use-After-Free in `ha->mpi_fw_dump` pointer when firmware dump buf=
fer is reallocated.
--

--- Patch [5]: [PATCH v6 05/56] scsi: qla2xxx: Add FC operational firmware =
load for 29xx ---
commit ed0a0bf5b60c5fe925e18499926faba91b6ac03a
Author: Manish Rangankar <mrangankar@marvell.com>

scsi: qla2xxx: Add FC operational firmware load for 29xx

This commit adds support to load the 29xx FC operational firmware from the
filesystem and to set up the corresponding firmware dump template. It
follows the same request_firmware and segment load pattern used by earlier
adapters.

> diff --git a/drivers/scsi/qla2xxx/qla_init.c b/drivers/scsi/qla2xxx/qla_i=
nit.c
> --- a/drivers/scsi/qla2xxx/qla_init.c
> +++ b/drivers/scsi/qla2xxx/qla_init.c
> @@ -3937,7 +3937,8 @@ qla2x00_alloc_fw_dump(scsi_qla_host_t *vha)
>  				    "Allocated (%d KB) for firmware dump.\n",
>  				    dump_size / 1024);
> =20
> -				if (IS_QLA27XX(ha) || IS_QLA28XX(ha)) {
> +				if (IS_QLA27XX(ha) || IS_QLA28XX(ha) ||
> +				    IS_QLA29XX(ha)) {
>  					ha->mpi_fw_dump =3D (char *)fw_dump +
>  						ha->fwdt[1].dump_size;
>  					mutex_unlock(&ha->optrom_mutex);

[Severity: High]
This is a pre-existing issue, but does adding 29xx to this path expose a
use-after-free when the firmware dump buffer is reallocated?

Earlier in qla2x00_alloc_fw_dump(), when ha->fw_dumped is true, the old
buffer is freed via vfree(ha->fw_dump) and reallocated. However, the
ha->mpi_fw_dump pointer is not updated to point into the new buffer. It
seems it will remain pointing to the freed memory, and a subsequent MPI
firmware dump would corrupt memory.

[ ... ]
> +static int
> +qla29xx_load_risc_blob(scsi_qla_host_t *vha, uint32_t *srisc_addr)
> +{
[ ... ]
> +failed:
> +	vfree(fwdt->template);
> +	fwdt->template =3D NULL;
> +	fwdt->length =3D 0;
> +img_corrupt:
> +	vfree(header);
> +	return QLA_FUNCTION_FAILED;
> +}

[Severity: High]
Should template validation failures in the 29xx load paths abort the entire
adapter initialization?

In previous hardware generations, firmware dump template failures are
treated as non-fatal and return QLA_SUCCESS, allowing the driver to operate
without firmware dump capabilities. Returning QLA_FUNCTION_FAILED here
propagates up and makes the adapter completely unusable if the optional
template validation fails.

[ ... ]
> +static int
> +qla29xx_load_fw_template(scsi_qla_host_t *vha)
> +{
[ ... ]
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

[Severity: High]
Does this misinterpret the firmware dump template size as bytes instead of
dwords?

The template_size is read from the flash header which typically stores the
size in dwords. Passing this directly to vmalloc() and memcpy() would
allocate and copy only 25 percent of the needed memory, and guarantee that
the subsequent size verification (len > template_size) fails.

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

[Severity: High]
Does this copy fail to skip the 7-dword flash region header?

Other firmware load functions skip the header before extracting the
template. Copying directly from offset 0 means the dcode buffer points to
the flash header instead of the template header, which would cause
qla27xx_fwdt_template_valid() to unconditionally fail.

[ ... ]
> +free_fw_dump:
> +	kfree(fw_dump_tmplt);
> +	return QLA_FUNCTION_FAILED;
> +}

[Severity: High]
As mentioned above, should this optional firmware dump template failure
abort the entire adapter initialization? Returning QLA_FUNCTION_FAILED here
will fail the probe.

[ ... ]
> diff --git a/drivers/scsi/qla2xxx/qla_os.c b/drivers/scsi/qla2xxx/qla_os.c
> --- a/drivers/scsi/qla2xxx/qla_os.c
> +++ b/drivers/scsi/qla2xxx/qla_os.c
> @@ -2640,6 +2640,45 @@ static struct isp_operations qla27xx_isp_ops =3D {
>  	.initialize_adapter	=3D qla2x00_initialize_adapter,
>  };
> =20
> +static struct isp_operations qla29xx_isp_ops =3D {
> +	.pci_config		=3D qla25xx_pci_config,

[Severity: High]
The start_scsi function pointer appears to be missing from the
qla29xx_isp_ops structure.

In qla2xxx_queuecommand(), if ha->mqenable evaluates to 0 (which happens if
MSI-X allocation fails or is disabled by user), the driver falls back to
single-queue mode and explicitly calls ha->isp_ops->start_scsi(). Does this
missing callback cause a fatal NULL pointer dereference on the first
submitted SCSI I/O?

[ ... ]
> +	.beacon_on		=3D qla24xx_beacon_on,
> +	.beacon_off		=3D qla24xx_beacon_off,
> +	.beacon_blink		=3D qla83xx_beacon_blink,
> +	.read_optrom		=3D qla25xx_read_optrom_data,
> +	.write_optrom		=3D qla24xx_write_optrom_data,

[Severity: High]
Are these legacy flash I/O functions compatible with the 29xx adapter?

These functions compute flash addresses using flash_data_addr(), which adds
ha->flash_data_off to the offset. For 29xx, ha->flash_data_off is
initialized to ~0 (0xFFFFFFFF). This appears to cause invalid flash reads
and writes.

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20260723050413.3897=
522-1-njavali@marvell.com?part=3D5
