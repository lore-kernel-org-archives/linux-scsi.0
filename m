Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C048D35BDA4
	for <linux-scsi@vger.kernel.org>; Tue,  7 Jul 2026 07:06:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1783407974; cv=none; b=F6rS8/nwVOrXFuPiqMRQlv1ykIRV5rbimqZbSdqwIChiXhu9F2VZ2KAYFmix9uVgnPvek9of3cSzXD1sowytOSbuTOBmTkOiZojjGPwCYUBhcbuX78Oxyj8r/BMG1BfJh5T94Eu4uwi9AWXmULGaRvzPs+7rQv4VIy88qEf6J38=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1783407974; c=relaxed/simple;
	bh=DX53sKnWlK5Y2P6C2k57HqWSyHLbaN2ygzxabVlqoRg=;
	h=From:Subject:To:Cc:In-Reply-To:References:Content-Type:Date:
	 Message-Id; b=uFGMRBaDO/PnT/CvRNYSmUlUPbADIO2Avo00io04pBk8P1CsEIsNnil4yybPV3Vwy8H9CsLMHA9k90ze5BkjqOReEiW1msHThgabpe9hJZb9Nf6P+5J/NxYuqv9bTUUDRxFIHUTy1ICY9IE9C2v1Zri5pxda+zXmEfjUDBqCnU4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=DUa4x379; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="DUa4x379"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 06C2B1F000E9;
	Tue,  7 Jul 2026 07:06:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1783407972;
	bh=ZIki8Vj6wRu605USRa4bp4e0F05a2Hz+rTVZu3A4j9E=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=DUa4x379Q5mOZpUdoUwBk2uZmDxha1cPLqx1KMMMmn8R5+NOk/ecdCmCIklySxfUP
	 aRVtYfLBWeVqk7nNVwXDkQQvffw6D8tdWzDAwu3jkXpyjYFeBD4CETyj4EWONP7Yl5
	 M32PTMYop8eb+HyDvFXiijowMgQcJBfLIw7souynLVmN5uT2DXzC56spHslJ4YkVrE
	 98qFek6KNPZKsGkF5p4iH9ofTDwTEnAwrX0MwwSQrO7QLbXFkWni0rpmMUockkb9G2
	 g8qFFdJlSZqy3mtPozGouJAAXf8IHpme56GdjOGTC5MlQKznX4XZz8PVA5oQeThoUh
	 4dHxKWPpL9Esg==
From: sashiko-bot@kernel.org
Subject: Re: [PATCH v3 53/88] scsi: qla2xxx: Zero dport diagnostics buffer
 to avoid info leak
Reply-To: sashiko-reviews@lists.linux.dev
To: "Nilesh Javali" <njavali@marvell.com>
Cc: linux-scsi@vger.kernel.org
In-Reply-To: <20260707055435.2680300-54-njavali@marvell.com>
References: <20260707055435.2680300-1-njavali@marvell.com>
 <20260707055435.2680300-54-njavali@marvell.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Tue, 07 Jul 2026 07:06:11 +0000
Message-Id: <20260707070612.06C2B1F000E9@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>

Thank you for your contribution! Sashiko AI review found 3 potential issue(=
s) to consider:

Pre-existing issues:
- [Critical] Uninitialized kernel stack memory leak and severe stack buffer=
 overflow in multiple BSG handlers.
- [High] Calling `memset()` on a buffer after `dma_map_single()` and using =
unaligned structs causes DMA cacheline sharing and data corruption.
- [High] Out-of-bounds heap read due to missing `bsg_job->request_len` vali=
dation.
--

--- Patch [53]: [PATCH v3 53/88] scsi: qla2xxx: Zero dport diagnostics buff=
er to avoid info leak ---
commit 4b26f2e53fe6f8ddd499850e1bc9b9280efa8bd9
Author: Nilesh Javali <njavali@marvell.com>

scsi: qla2xxx: Zero dport diagnostics buffer to avoid info leak

This commit fixes an information leak in qla2x00_do_dport_diagnostics().
It changes the allocation of the qla_dport_diag response buffer from
kmalloc_obj() to kzalloc_obj() to ensure the buffer is fully zeroed
before it is copied to user space.

> diff --git a/drivers/scsi/qla2xxx/qla_bsg.c b/drivers/scsi/qla2xxx/qla_bs=
g.c
> index fade3638d31cb..e7739cead967a 100644
> --- a/drivers/scsi/qla2xxx/qla_bsg.c
> +++ b/drivers/scsi/qla2xxx/qla_bsg.c
> @@ -2792,7 +2792,7 @@ qla2x00_do_dport_diagnostics(struct bsg_job *bsg_jo=
b)
>  	    !IS_QLA28XX(vha->hw) && !IS_QLA29XX(vha->hw))
>  		return -EPERM;
> =20
> -	dd =3D kmalloc_obj(*dd);
> +	dd =3D kzalloc_obj(*dd);
>  	if (!dd) {
>  		ql_log(ql_log_warn, vha, 0x70db,
>  		    "Failed to allocate memory for dport.\n");

[Severity: High]
This is a pre-existing issue, but does calling memset() on a buffer after
dma_map_single() corrupt the DMA data?

In drivers/scsi/qla2xxx/qla_mbx.c:qla26xx_dport_diagnostics(), the code doe=
s:

	dd_dma =3D dma_map_single(&vha->hw->pdev->dev,
	    dd_buf, size, DMA_FROM_DEVICE);
...
	memset(dd_buf, 0, size);

The dma_map_single() call invalidates the CPU cache for the buffer on
non-coherent architectures. The immediate memset() dirties the CPU cache li=
nes,
which could overwrite the diagnostic data written by the device via DMA if
they are evicted to main memory.

Additionally, the mapped buffer dd_buf starts at an offset that may not be
aligned to ARCH_DMA_MINALIGN. Mapping unaligned buffers can corrupt adjacent
struct fields sharing the same cache line. The same DMA cacheline sharing a=
nd
memset corruption pattern occurs in qla26xx_dport_diagnostics_v2().


[Severity: Critical]
This is a pre-existing issue, but is there a risk of an uninitialized kernel
stack memory leak and stack buffer overflow in multiple BSG handlers?

In drivers/scsi/qla2xxx/qla_bsg.c:qla2x00_read_i2c():

	uint8_t bsg[DMA_POOL_SIZE];
	struct qla_i2c_access *i2c =3D (void *)bsg;
...
	sg_copy_to_buffer(bsg_job->request_payload.sg_list,
	    bsg_job->request_payload.sg_cnt, i2c, sizeof(*i2c));

	rval =3D qla2x00_read_sfp(vha, sfp_dma, sfp,
		i2c->device, i2c->offset, i2c->length, i2c->option);
...
	memcpy(i2c->buffer, sfp, i2c->length);
	sg_copy_from_buffer(bsg_job->reply_payload.sg_list,
	    bsg_job->reply_payload.sg_cnt, i2c, sizeof(*i2c));

If the user provides a short payload, i2c->length remains uninitialized. It=
 is
then used as the size for memcpy() without bounds checking, which could cau=
se a
stack buffer overflow (writing past the bsg array) and a heap out-of-bounds
read from the sfp DMA pool buffer.

Passing this unbounded length to qla2x00_read_sfp() can also cause a DMA
buffer overflow into the kernel heap. Finally, the bsg buffer is copied back
to user space, potentially leaking uninitialized kernel stack memory. A sim=
ilar
leak pattern exists in qla2x00_read_fru_status().


[Severity: High]
This is a pre-existing issue, but does this code read out-of-bounds heap me=
mory
if the user provides a short request?

In drivers/scsi/qla2xxx/qla_bsg.c:qla84xx_mgmt_cmd(), the handler expects a
vendor-specific structure appended to the generic request:

	ql84_mgmt =3D (void *)bsg_request + sizeof(struct fc_bsg_request);
	switch (ql84_mgmt->mgmt.cmd) {

While the block layer validates that bsg_job->request_len covers the generic
struct fc_bsg_request, there does not appear to be validation that it covers
the appended qla_bsg_a84_mgmt structure.

If a user issues a BSG command with a request_len of exactly
sizeof(struct fc_bsg_request), this function will read out of bounds from t=
he
allocated heap buffer, which can cause a kernel panic if the read crosses a
page boundary. A similar out-of-bounds heap read exists in qla24xx_iidma() =
due
to a lack of request_len validation for the appended qla_port_param structu=
re.

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20260707055435.2680=
300-1-njavali@marvell.com?part=3D53
