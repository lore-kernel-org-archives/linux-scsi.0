Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1F2F938E11C
	for <linux-scsi@vger.kernel.org>; Tue, 14 Jul 2026 12:10:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784031002; cv=none; b=Kpvr1VyOP+Hj/gcThxeJSA2EGuRcivA6FhWFwgTuJA2HM3WYlEbKlm80rHK4a65sIyVvuQYQwP1vZzUEuQMsSMXs/elaT+cYQCjB8PMOiiE8GRtC/3s5hFvOe0scip+6Iag6oNZY8W5t3LTIPFx8bSP0Bls0CLr1o8//6Oj5Nlk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784031002; c=relaxed/simple;
	bh=7bFbaczagJtrDz4IATOqlYloHNFcCg0GXxNt8Fgeq1E=;
	h=From:Subject:To:Cc:In-Reply-To:References:Content-Type:Date:
	 Message-Id; b=smwHu0qMRDgJNpn887rVJv5oLTqjwaayAEdqqRkXbXm8qyq+/ZZljlnSpRt5re3GXuxn70JryJCquoUdD50Ce5CRqrKMQVU7EXGDYi6CFBsIzk4ZuVcLKUqKh8reU5zVcrDp845XW4qE0xHDRTXK0Ck6tSF7jxw27G0w902bDTk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=chHTYbYz; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="chHTYbYz"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A15CE1F000E9;
	Tue, 14 Jul 2026 12:10:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1784031000;
	bh=zu2wbbzidYknglGXux1pEdIs433MLZCDpclbHx3qvVg=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=chHTYbYzaL+vgkW+GDv5STHgvEf09Gz0Eg7PyV29c6ld602dbw464WzVfxLqbZZXh
	 8zsE0mgWquraQTaNx/YjiHU+Vb0kbSxeJIZ4Y5R4iPinMCDu5fV+WbOTr/NepiZpn4
	 Cbetzp9TtPDF0seSkFG8N0/s7SmlbaJTm7dehtYnRYqpvssHNyJY6YLGq82F1F2oEU
	 nMl7MUYTCyZCCKnE7BFMS5GcBu0//E879hVzwve9rANucMWu+KjGsMDgGgDojF41ET
	 zlBPQdhf/pAmbcGasbgwE8hv5L3FeLl9iFZgERLTPRIxHmYughC/HIlxsaHQDx0L+f
	 LgcdPs3py60Hw==
From: sashiko-bot@kernel.org
Subject: Re: [PATCH v4 14/56] scsi: qla2xxx: Enable get_fw_version mailbox
 for 29xx
Reply-To: sashiko-reviews@lists.linux.dev
To: "Nilesh Javali" <njavali@marvell.com>
Cc: linux-scsi@vger.kernel.org
In-Reply-To: <20260714095353.289460-15-njavali@marvell.com>
References: <20260714095353.289460-1-njavali@marvell.com>
 <20260714095353.289460-15-njavali@marvell.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Tue, 14 Jul 2026 12:10:00 +0000
Message-Id: <20260714121000.A15CE1F000E9@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>

Thank you for your contribution! Sashiko AI review found 4 potential issue(=
s) to consider:

New issues:
- [High] Missing QLA29XX hardware state initialization in `qla2x00_execute_=
fw()` results in dead code and missing features.
- [High] Missing macro and memory allocation updates for QLA29XX EDIF suppo=
rt lead to unallocated memory pools.
- [Medium] The patch populates `mpi_version` and `pep_version` capability f=
ields for 29XX adapters but fails to expose them to userspace due to missin=
g sysfs updates.

Pre-existing issues:
- [Critical] Incorrect mempool_free on a DMA pool allocation in the error p=
ath.
--

--- Patch [14]: [PATCH v4 14/56] scsi: qla2xxx: Enable get_fw_version mailb=
ox for 29xx ---
commit 7ec86c4145546172d16b2ee833700898350294f6
Author: Nilesh Javali <njavali@marvell.com>
Subject: scsi: qla2xxx: Enable get_fw_version mailbox for 29xx

This patch populates the serdes_version and several firmware capability fie=
lds
for 29xx adapters by including them in the get_fw_version mailbox path. It
adds IS_QLA29XX() checks to the relevant conditionals so that firmware vers=
ion,
EDIF, and serdes information are retrieved correctly.

> diff --git a/drivers/scsi/qla2xxx/qla_attr.c b/drivers/scsi/qla2xxx/qla_a=
ttr.c
> --- a/drivers/scsi/qla2xxx/qla_attr.c
> +++ b/drivers/scsi/qla2xxx/qla_attr.c
> @@ -1526,7 +1526,7 @@ qla2x00_serdes_version_show(struct device *dev, str=
uct device_attribute *attr,
>  	scsi_qla_host_t *vha =3D shost_priv(class_to_shost(dev));
>  	struct qla_hw_data *ha =3D vha->hw;
> =20
> -	if (!IS_QLA27XX(ha) && !IS_QLA28XX(ha))
> +	if (!IS_QLA27XX(ha) && !IS_QLA28XX(ha) && !IS_QLA29XX(ha))
>  		return scnprintf(buf, PAGE_SIZE, "\n");

[Severity: Medium]
Since we are exposing the serdes_version for 29xx here, should we also
update qla2x00_mpi_version_show() and qla2x00_pep_version_show() in this
same file?

The patch populates ha->mpi_version and ha->pep_version in
qla2x00_get_fw_version() for 29xx, but the sysfs show functions still
restrict output to older models. This causes them to return an empty line,
hiding the newly available data.

[ ... ]

> diff --git a/drivers/scsi/qla2xxx/qla_mbx.c b/drivers/scsi/qla2xxx/qla_mb=
x.c
> --- a/drivers/scsi/qla2xxx/qla_mbx.c
> +++ b/drivers/scsi/qla2xxx/qla_mbx.c
> @@ -1212,7 +1212,7 @@ qla2x00_get_fw_version(scsi_qla_host_t *vha)
>  			vha->flags.nvme2_enabled =3D 1;
>  		}
> =20
> -		if (IS_QLA28XX(ha) && ha->flags.edif_hw && ql2xsecenable &&
> +		if ((IS_QLA28XX(ha) || IS_QLA29XX(ha)) && ha->flags.edif_hw && ql2xsec=
enable &&
>  		    (ha->fw_attributes_ext[0] & FW_ATTR_EXT0_EDIF)) {
>  			ha->flags.edif_enabled =3D 1;

[Severity: High]
Will ha->flags.edif_hw ever actually be set for 29xx adapters?

Looking at qla2x00_execute_fw() in qla_mbx.c, the initialization seems to be
missing the IS_QLA29XX check:

qla_mbx.c:qla2x00_execute_fw()
    if (IS_QLA28XX(ha) && (mcp->mb[5] & EDIF_HW_SUPPORT)) {
        ha->flags.edif_hw =3D 1;

If ha->flags.edif_hw remains 0, won't this new check in get_fw_version() act
as dead code for 29xx?

Additionally, qla2x00_execute_fw() appears to be missing 29xx checks for
NVME_ENABLE_FLAG and for initializing ha->max_supported_speed.

[Severity: High]
If EDIF is enabled on a 29xx adapter, will this lead to unallocated memory
pools?

The EDIF_CAP macro in qla_edif.h only checks IS_QLA28XX. Furthermore, in
qla_os.c:qla2x00_mem_alloc(), the memory pools are allocated like this:

qla_os.c:qla2x00_mem_alloc()
    if (ql2xenabledif || (IS_QLA28XX(ha) && ql2xsecenable)) {
        ha->ctx_mempool =3D mempool_create_slab_pool(...)

Without IS_QLA29XX here, ha->ctx_mempool and ha->dl_dma_pool won't be
allocated when ql2xsecenable=3D1 on a 29xx adapter. Could this cause null
pointer dereferences when the driver attempts to use EDIF paths?

[Severity: Critical]
This is a pre-existing issue, but I noticed a potential memory corruption
hazard in the error handling paths for type 6 SCSI commands.

In qla_iocb.c:qla_start_scsi_type6() and qla2xxx_dif_start_scsi_mq(),
sp->u.scmd.crc_ctx is allocated from a DMA pool:

    sp->u.scmd.crc_ctx =3D dma_pool_zalloc(ha->dl_dma_pool, GFP_ATOMIC, ...=
);

However, if an error occurs later (e.g., mapping fails or resources run
out), the error path frees it using a different mempool:

    mempool_free(sp->u.scmd.crc_ctx, ha->ctx_mempool);

Since ha->ctx_mempool is a slab-backed mempool (meant for struct ct6_dsd)
and not a DMA pool, doesn't freeing a DMA-backed address to this slab pool
corrupt memory?

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20260714095353.2894=
60-1-njavali@marvell.com?part=3D14
