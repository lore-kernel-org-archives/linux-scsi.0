Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E95933812DD
	for <linux-scsi@vger.kernel.org>; Fri, 12 Jun 2026 10:14:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1781259261; cv=none; b=r04/FMni5UV9ctvg/NUgCkg5eY3nr1jOFfb+YFArv4Qn65bPb0FYIwdfPPU6cxLHSfsDml155Oj85cAHkFni/3ioyZmplkAPA74RgNiDU3/AaF9f0JSSpb9X2mFeVBiWnvvTyIThNk0A0oPogcfZj20evLpKCUUpxUDWxi/CLp0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1781259261; c=relaxed/simple;
	bh=uywKf7RuwHy6EjRs51dQU+UbPyp+3VMlmQBp2ReMqrA=;
	h=From:Subject:To:Cc:In-Reply-To:References:Content-Type:Date:
	 Message-Id; b=AxjgfA3zSbP/sWSUPWbg7tzwi7odAxGGcoFtGU0Tv/9mUs9yaTja0/4FtnajvqIUVw4IOHjYo3fuBziw+2L27VIOVQZUsgKPOTDNpNQhzKpnTVMJzSTuIemICHA23xUH1EVQJ4vb3tnUJxlOs4enKqioH+16sAWtYobXtSm9tQw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=boziwzNq; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="boziwzNq"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 69D491F00A3A;
	Fri, 12 Jun 2026 10:14:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1781259259;
	bh=aIOE2ecCMF5Q3GAar2Hf+BY9earTpgP1SuSfNnvCg1o=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=boziwzNqIACwHYiyqNY6o2Sq1cssj3dnBRSOB81JFtM4i4Viug9R2iJkvTUk0c45R
	 UynphipDOn+7ffmXeSxWR9xx9wgLuHwHygBbeb0D5CgOaM7ejOqXurSS6zfPqoyvuC
	 lH9qs9648hKjYASbodJkISSA6hzhe9u9Xm+hU8aH35jgjPph5RcougUYdaTUFiEaJd
	 r2w/L0cMA1YhBm3ifZMIdDO5AvQJMTkkZB3gs5JmC0iOXF8RdIaDA1lLwvJG6m3lx8
	 ngUJO++mCahAe88GHOo4k0/bqeLnDDK4hb//QXpmfP96jCo5R+GsfWd+FsgzqXHmum
	 W6ICD9zvyyY6A==
From: sashiko-bot@kernel.org
Subject: Re: [PATCH v2 06/60] scsi: qla2xxx: Add FC operational firmware
 load for 29xx
Reply-To: sashiko-reviews@lists.linux.dev
To: "Nilesh Javali" <njavali@marvell.com>
Cc: linux-scsi@vger.kernel.org
In-Reply-To: <20260612095333.1666592-7-njavali@marvell.com>
References: <20260612095333.1666592-7-njavali@marvell.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Fri, 12 Jun 2026 10:14:19 +0000
Message-Id: <20260612101419.69D491F00A3A@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>

Thank you for your contribution! Sashiko AI review found 5 potential issue(=
s) to consider:
- [High] Unconditional byte-swapping of `risc_attr` using `swab32()` instea=
d of `be32_to_cpu()` causes endianness corruption.
- [High] Heap out-of-bounds read in `qla29xx_load_fw_template()` due to mis=
sing bounds check on `template_size`.
- [High] Out-of-bounds read in `qla29xx_load_risc_blob()` due to missing bo=
unds checks on `array3_addr` dereferences.
- [High] Logic Error: Missing `BIT_1` (last chunk) flag due to flawed `is_l=
ast_chunk` calculation.
- [High] Integer overflow of firmware section offsets and lengths bypasses =
bounds checks on 32-bit systems.
--

commit 010601e8a1ad75507948f2ba92e178c2b94266b2
Author: Manish Rangankar <mrangankar@marvell.com>
scsi: qla2xxx: Add FC operational firmware load for 29xx

This commit adds support to load the 29xx FC operational firmware from the
filesystem and sets up the corresponding firmware dump template.

> diff --git a/drivers/scsi/qla2xxx/qla_init.c b/drivers/scsi/qla2xxx/qla_i=
nit.c
> --- a/drivers/scsi/qla2xxx/qla_init.c
> +++ b/drivers/scsi/qla2xxx/qla_init.c

[ ... ]

> +static int qla29xx_process_rd_image(struct scsi_qla_host *vha,

[ ... ]

> +				is_last_chunk =3D
> +					(chunk =3D=3D (chunks_per_segment - 1) ||
> +					 size_remainder < CHUNK_SIZE);

[Severity: High]
Does this logic accurately capture the final chunk when the remaining size =
is
exactly a multiple of the chunk size?

If the final segment's remaining size is exactly CHUNK_SIZE, size_remainder=
 <
CHUNK_SIZE evaluates to false. Because it is a partial segment, the chunk
index will also be less than chunks_per_segment - 1. Since both conditions
are false, is_last_chunk becomes false. Could this cause the final chunk to
be sent without the BIT_1 flag, potentially hanging the firmware load?

[ ... ]

> +static int
> +qla29xx_load_risc_blob(scsi_qla_host_t *vha, uint32_t *srisc_addr)
> +{

[ ... ]

> +	header->header_length <<=3D 2;
> +	header->tim_length <<=3D 2;
> +	header->array1_length <<=3D 2;
> +	header->array2_length <<=3D 2;
> +	header->array3_length <<=3D 2;
> +	header->array4_length <<=3D 2;
> +
> +	if (!header->segment_size) {

[Severity: High]
Could these shifts result in integer overflow on 32-bit systems?

The firmware section lengths are multiplied by 4 without verifying if the
multiplication overflows.

[ ... ]

> +		/* Array 1 */
> +		offset +=3D header->tim_length;
> +		if (offset + header->array1_length > fw_size) {
> +			ql_log(ql_log_fatal, vha, 0x0098,

If a crafted firmware image provides large section lengths (for instance,
0xFFFFFFFC), adding the offset could wrap around to a small value on 32-bit
architectures. Would this bypass the bounds check and cause the inner copy
loop in qla29xx_process_rd_image() to read past the end of the firmware
buffer?

[ ... ]

> +		/* Array 3: FW_DUMP template */
> +		if (offset + 10 * sizeof(__be32) > fw_size) {
> +			ql_log(ql_log_fatal, vha, 0x0098,
> +			       "FW image too small for risc_attr.\n");
> +			goto img_corrupt;
> +		}
> +		array1_addr =3D (__be32 *)((char *)fwcode +
> +				header->header_length +
> +				header->tim_length);
> +		risc_attr =3D swab32(array1_addr[9]);

[Severity: High]
Does using swab32() here cause endianness issues on big-endian architecture=
s?

Since array1_addr is defined as an array of __be32, the data is already bei=
ng
read in native memory order. Converting this to CPU endianness typically
requires be32_to_cpu(). Using an unconditional byte swap produces the corre=
ct
result on little-endian machines, but might corrupt the value on big-endian
systems, which could break the template count logic.

[ ... ]

> +	array3_addr =3D (__be32 *)(((char *)fwcode) + array3_offset);
> +	for (j =3D 0; j < templates; j++, fwdt++) {
> +		vfree(fwdt->template);
> +		fwdt->template =3D NULL;
> +		fwdt->length =3D 0;
> +
> +		array_size =3D be32_to_cpu(array3_addr[2]);

[Severity: High]
Is there a bounds check ensuring array3_addr has enough capacity before
dereferencing it?

While there is a check earlier to ensure array3_offset does not exceed the
total firmware size, that check allows the offset to sit exactly at the
end of the file. Dereferencing array3_addr[2] here might read past the end
of the buffer if the remaining size is less than 12 bytes.

[ ... ]

> +		fwdt->length =3D dlen;
> +		ql_dbg(ql_dbg_init, vha, 0x0168,
> +		       "-> fwdt%u loaded template ok\n", j);
> +
> +		array3_addr +=3D array_size + 1;
> +	}

Additionally, if the loop continues for another template, array3_addr is
advanced and immediately dereferenced at the start of the next iteration
without validating if the new address remains within the firmware blob.
Could this also lead to an out-of-bounds read?

[ ... ]

> +static int
> +qla29xx_load_fw_template(scsi_qla_host_t *vha)
> +{

[ ... ]

> +	for (j =3D 0; j < templates; j++, fwdt++) {
> +		vfree(fwdt->template);
> +		fwdt->template =3D NULL;
> +		fwdt->length =3D 0;
> +
> +		template_size =3D le32_to_cpu(((__le32 *)fw_dump_tmplt)[2]);

[ ... ]

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
Does template_size need to be validated against the actual size of the
fw_dump_tmplt allocation?

The template_size is read directly from the flash buffer data. Without
checking if template_size is less than or equal to ha->fw_dump_tmplt_len,
a malformed flash image specifying an excessively large template_size might
cause memcpy() to read out of bounds from the fw_dump_tmplt heap allocation.

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20260612095333.1666=
592-1-njavali@marvell.com?part=3D6
