Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AC8BA3AFD1E
	for <linux-scsi@vger.kernel.org>; Tue,  7 Jul 2026 07:38:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1783409900; cv=none; b=VS1iVwX6+OrONXpOZpCgWysq0t/agpxSW9xlu26Q7HdZiHY7pMuIEQ6f688C31FO2KgzjYHE9ptHVny0yibcGgGWIB38JEzjee/Y8xvHG9h8YJ+UK1GYI1g2n3SdHyGg/Y+JaxYaHG1sB/d/DteLgwJklFqsIMUydWyi5tEO9G0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1783409900; c=relaxed/simple;
	bh=WNEMkbFL0OGQA6gvul+JT717OUhszUKhmTJVDMa91BM=;
	h=From:Subject:To:Cc:In-Reply-To:References:Content-Type:Date:
	 Message-Id; b=jCETjqVI6IA9zPzrciBbuI4oA0jSHGkH8pMT3PudlaaTVJiZlIRPKC5ldc7Zv5QpkIz5Do4m0hIFQheywDqaZo4eKvmBLEhp8friA+czvp3ZjUiFJ+QoIqduJEJ5KeqOmXjqU0UZt60uxzpUJ2bOPllxBWy5+CtYY95fK3vEvWs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=d+1JkcLg; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="d+1JkcLg"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 32A691F000E9;
	Tue,  7 Jul 2026 07:38:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1783409899;
	bh=aM8c2Yv/wapCFYa00MtmndzyxpsuJWXLzAWkHkn/Nzs=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=d+1JkcLgteIj7exeE+b1FtdjHPzG5g6sR/HH1XAWs0V0S2tAdD9F08miYAsmXFs5p
	 hW1xy8cozrKFV3CWn8l3NJxd7oZ2emBBR3IKQHW4v7OovJc4oKwYycnxYooB3S6yB1
	 qc35Pdw4jxDzxhQD+IXf3hVENufTQABmK+/8axf2lfMK5bZOJVqGp3duJzM8G+ehWn
	 jSu3N+VxuD/5jX2zFm/Z0Gjrvt88yqH+EQ9BcCoPukPltdRmxl5Y7A2/M1UKhfB+45
	 /IiMc/pTKzywe5Vjulvazbt2dXhDrG5QDl0dIn/7vzMDf3Uq4anDY8FQHX53ADIhAK
	 UeiWKUx1cvlmQ==
From: sashiko-bot@kernel.org
Subject: Re: [PATCH v3 86/88] scsi: qla2xxx: Zero SFP DMA buffer in FRU/I2C
 bsg handlers
Reply-To: sashiko-reviews@lists.linux.dev
To: "Nilesh Javali" <njavali@marvell.com>
Cc: linux-scsi@vger.kernel.org
In-Reply-To: <20260707055435.2680300-87-njavali@marvell.com>
References: <20260707055435.2680300-1-njavali@marvell.com>
 <20260707055435.2680300-87-njavali@marvell.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Tue, 07 Jul 2026 07:38:18 +0000
Message-Id: <20260707073819.32A691F000E9@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>

Thank you for your contribution! Sashiko AI review found 1 potential issue(=
s) to consider:

Pre-existing issues:
- [High] Heap buffer overflow in qla_edif_process_els() due to unbounded us=
er payload lengths.
--

--- Patch [86]: [PATCH v3 86/88] scsi: qla2xxx: Zero SFP DMA buffer in FRU/=
I2C bsg handlers ---
commit 5b2a349a69efbe478558db07cf4b96e8fb11e62b
Author: Nilesh Javali <njavali@marvell.com>

scsi: qla2xxx: Zero SFP DMA buffer in FRU/I2C bsg handlers

The FRU and I2C bsg handlers stage their transfer in a DMA_POOL_SIZE
bounce buffer obtained from dma_pool_alloc(), which does not zero the
allocation. This commit changes these handlers to use dma_pool_zalloc()
to prevent writing stale heap memory to the device flash.

> diff --git a/drivers/scsi/qla2xxx/qla_bsg.c b/drivers/scsi/qla2xxx/qla_bs=
g.c
> index e671c3de8c058..51ab638b4fc09 100644
> --- a/drivers/scsi/qla2xxx/qla_bsg.c
> +++ b/drivers/scsi/qla2xxx/qla_bsg.c
> @@ -1994,7 +1994,7 @@ qla2x00_update_fru_versions(struct bsg_job *bsg_job)
>  	struct qla_image_version *image;
>  	uint32_t count;
>  	dma_addr_t sfp_dma;
> -	void *sfp =3D dma_pool_alloc(ha->s_dma_pool, GFP_KERNEL, &sfp_dma);
> +	void *sfp =3D dma_pool_zalloc(ha->s_dma_pool, GFP_KERNEL, &sfp_dma);
> =20
>  	if (!sfp) {
>  		bsg_reply->reply_data.vendor_reply.vendor_rsp[0] =3D

[ ... ]

[Severity: High]
This isn't a bug introduced by this patch, but while reviewing the DMA pool
usage in BSG handlers, I noticed a potential buffer overflow in
qla_edif_process_els() located in drivers/scsi/qla2xxx/qla_edif.c.

Does this code allow an unbounded copy into the fixed-size purex_dma_pool?

drivers/scsi/qla2xxx/qla_edif.c:qla_edif_process_els() {
        ...
        sp->remap.req.len =3D bsg_job->request_payload.payload_len;
        sp->remap.req.buf =3D dma_pool_alloc(ha->purex_dma_pool, GFP_KERNEL,
                                           &sp->remap.req.dma);
        ...
        sg_copy_to_buffer(bsg_job->request_payload.sg_list,
            bsg_job->request_payload.sg_cnt, sp->remap.req.buf,
            sp->remap.req.len);
        ...
        sp->remap.rsp.len =3D bsg_job->reply_payload.payload_len;
        sp->remap.rsp.buf =3D dma_pool_alloc(ha->purex_dma_pool, GFP_KERNEL,
                                           &sp->remap.rsp.dma);
        ...
}

Since purex_dma_pool has a fixed object size (2112 bytes), can a user submit
a BSG request with a request_payload.payload_len or
reply_payload.payload_len greater than 2112 bytes?

If so, could this cause an out-of-bounds write on the DMA pool memory during
the sg_copy_to_buffer() call or during the firmware DMA transfer?

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20260707055435.2680=
300-1-njavali@marvell.com?part=3D86
