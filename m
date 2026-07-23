Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CA01A37A83F
	for <linux-scsi@vger.kernel.org>; Thu, 23 Jul 2026 10:56:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784804204; cv=none; b=cYrkC2ynZP6/i4k/I8jURUmj71twDLb+qEcc/tmNUQnvhubnwkgjm0vO4YrHbUiZ8aLYBLkj5hSpznJypwToxnoLguX5EiZxVrsExwWvoHxd0oqt0obGWlt3JXMHp/HfFaDl9CtaWJwaL7bpnvGAvzVCDroKrHuSKZXzfFb1fxo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784804204; c=relaxed/simple;
	bh=ujlhax+AUCKw9An+seaeJCxIvZzDw/vY1hE2lrbiGdU=;
	h=From:Subject:To:Cc:In-Reply-To:References:Content-Type:Date:
	 Message-Id; b=Trj/cK28ZHkJcQQfWhxcNGi+RVExCrPx9SATnxchlz3C9HOV9urYihQyp9m47vKt4lftp0qYhR4bfVg3UhcQlWRBr/6xaeQ2MCoPWBBb/r1nQDyoY39r+VUbgDzGlsDt2/2xXxkeEOpsH54JFiMwVKv1Rg5OYXu1ro3rc5duqXI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=WNZBWiKp; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="WNZBWiKp"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9F09C1F000E9;
	Thu, 23 Jul 2026 10:56:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1784804188;
	bh=JoJID1N+4htTPxJASuK/Uwng5tp2ZHT2b38kSUSbAbQ=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=WNZBWiKpmTTNWOR3e1kMenwE6JGU3fY+hZPnQwcnXxZjBntk7Rpq4aLmfkIXcPBF6
	 PfWG9HXsYeZUkZIp89+1BZVQSWoBK1OVOkm6Wy9KTW7Z6bH27m3jukdEX2+m/iHauq
	 KrYCi19o9lJyEmQ42bXYvu07csbPciEz4czNeZKAwBY0SSA2KRPZpI1U4qpyQDECeG
	 3U0yb0UmgZFt8+VD6sDdFnz19zD5ilTCCCpSdsTA2oJjN+yZmbWfCC9s3WEA0dZvF5
	 JKQwVQm9pjInw8VcdELpaWwtUdUpGfILMT6gUK2iR8M1ACMmxA1TsrhpTbhVOApLXG
	 8JNXmJmQHTt3g==
From: sashiko-bot@kernel.org
Subject: Re: [PATCH v6 24/56] scsi: qla2xxx: Add support for QLA29XX in
 memory allocation
Reply-To: sashiko-reviews@lists.linux.dev
To: "Nilesh Javali" <njavali@marvell.com>
Cc: linux-scsi@vger.kernel.org
In-Reply-To: <20260723050413.3897522-25-njavali@marvell.com>
References: <20260723050413.3897522-1-njavali@marvell.com>
 <20260723050413.3897522-25-njavali@marvell.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Thu, 23 Jul 2026 10:56:28 +0000
Message-Id: <20260723105628.9F09C1F000E9@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>

Thank you for your contribution! Sashiko AI review found 2 potential issue(=
s) to consider:

New issues:
- [High] Missing `IS_QLA29XX` support in the `EDIF_CAP` macro causes `vp_ma=
p` allocation failure for QLA29XX when EDIF is enabled, leading to a `BUG_O=
N` kernel panic.

Pre-existing issues:
- [High] The IO error paths for `qla82xx_start_scsi` and `qla_start_scsi_ty=
pe6` erroneously free a DMA pool allocation into a slab-backed mempool, cau=
sing SLUB corruption and kernel panics.
--

--- Patch [24]: [PATCH v6 24/56] scsi: qla2xxx: Add support for QLA29XX in =
memory allocation ---
commit 1fa851dd2c23362f8090c4cdabea1624fe07304b
Author: Nilesh Javali <njavali@marvell.com>

scsi: qla2xxx: Add support for QLA29XX in memory allocation

Enhance the qla2x00_mem_alloc function to include checks for
QLA29XX adapters.  This modification updates the conditions for
memory allocation and cleanup, ensuring proper handling of the
new adapter series alongside existing QLA27XX and QLA28XX checks.

> diff --git a/drivers/scsi/qla2xxx/qla_os.c b/drivers/scsi/qla2xxx/qla_os.c
> index 5450c40259bf9..3be59179a0245 100644
> --- a/drivers/scsi/qla2xxx/qla_os.c
> +++ b/drivers/scsi/qla2xxx/qla_os.c
> @@ -4285,7 +4285,8 @@ qla2x00_mem_alloc(struct qla_hw_data *ha, uint16_t =
req_len, uint16_t rsp_len,
>  	if (!ha->srb_mempool)
>  		goto fail_free_gid_list;
> =20
> -	if (IS_P3P_TYPE(ha) || IS_QLA27XX(ha) || (ql2xsecenable && IS_QLA28XX(h=
a))) {
> +	if (IS_P3P_TYPE(ha) || IS_QLA27XX(ha) ||
> +	    (ql2xsecenable && (IS_QLA28XX(ha) || IS_QLA29XX(ha)))) {
>  		/* Allocate cache for CT6 Ctx. */
>  		if (!ctx_cachep) {
>  			ctx_cachep =3D kmem_cache_create("qla2xxx_ctx",

[Severity: High]
This is a pre-existing issue, but do the IO error paths for qla82xx_start_s=
csi=20
and qla_start_scsi_type6 incorrectly free a DMA pool allocation into a=20
slab-backed mempool?

The crc_ctx object is allocated from dl_dma_pool via dma_pool_zalloc(), e.g=
.=20
in qla24xx_build_scsi_crc_2_iocbs(), but the error paths in=20
qla82xx_start_scsi() and qla_start_scsi_type6() do this:

drivers/scsi/qla2xxx/qla_iocb.c:qla82xx_start_scsi() {
    ...
    if (sp->u.scmd.crc_ctx) {
        mempool_free(sp->u.scmd.crc_ctx, ha->ctx_mempool);
        sp->u.scmd.crc_ctx =3D NULL;
    }
}

Since ctx_mempool is created here as a slab pool, freeing DMA-coherent memo=
ry=20
back into it causes SLUB corruption or kernel panics when queueing fails un=
der=20
load.

> @@ -4319,7 +4320,8 @@ qla2x00_mem_alloc(struct qla_hw_data *ha, uint16_t =
req_len, uint16_t rsp_len,
>  	    "init_cb=3D%p gid_list=3D%p, srb_mempool=3D%p s_dma_pool=3D%p.\n",
>  	    ha->init_cb, ha->gid_list, ha->srb_mempool, ha->s_dma_pool);
> =20
> -	if (IS_P3P_TYPE(ha) || ql2xenabledif || (IS_QLA28XX(ha) && ql2xsecenabl=
e)) {
> +	if (IS_P3P_TYPE(ha) || ql2xenabledif ||
> +	    ((IS_QLA28XX(ha) || IS_QLA29XX(ha)) && ql2xsecenable)) {

[Severity: High]
By adding QLA29XX to the ql2xsecenable condition here, we enable EDIF=20
allocations for the new adapters. However, does this miss updating the=20
EDIF_CAP macro?

The EDIF_CAP macro in drivers/scsi/qla2xxx/qla_edif.h remains hardcoded to=
=20
IS_QLA28XX:

drivers/scsi/qla2xxx/qla_edif.h:
#define EDIF_CAP(_ha) (ql2xsecenable && IS_QLA28XX(_ha))

Earlier in qla2x00_mem_alloc(), vp_map is conditionally allocated using=20
this macro:

drivers/scsi/qla2xxx/qla_os.c:qla2x00_mem_alloc() {
    if (QLA_TGT_MODE_ENABLED() || EDIF_CAP(ha)) {
        ha->vp_map =3D kzalloc_objs(struct qla_vp_map, MAX_MULTI_ID_FABRIC);
    }
}

If QLA29XX adapters operate in initiator mode with EDIF enabled, vp_map=20
will be NULL. When EDIF receives ELS/Auth packets, it routes through=20
target-mode infrastructure and calls qla_find_host_by_vp_idx(), which=20
will trigger a BUG_ON(ha->vp_map =3D=3D NULL) panic.

[ ... ]

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20260723050413.3897=
522-1-njavali@marvell.com?part=3D24
