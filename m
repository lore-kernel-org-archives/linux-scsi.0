Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8F81538F951
	for <linux-scsi@vger.kernel.org>; Fri, 12 Jun 2026 11:40:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1781264431; cv=none; b=Bj4oE280uIVSpUkoOOMn6veow/DG6+coqlx1WeZKMqE+tfZ+vDbYOcPEGxZT5DuMib0t2Xi6bWfvrs+WV6W4EX+cHd15Q9mMtc1JPQ+lyuXiqk2FthSQlxFF5gf0+liJ5IhjE34s81gi01d4xUojhWIMuhszdKUUIrY8PrPkcj4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1781264431; c=relaxed/simple;
	bh=I2CJEfV7fo7OxmeAy1rdyoAKsrlqttjxzB5/PCdDcqo=;
	h=From:Subject:To:Cc:In-Reply-To:References:Content-Type:Date:
	 Message-Id; b=V0LKR5GMuHHOYAqwUSOMvADITnCse++5gnRvRgXS3HoKTwsHOmBNDubpByos5b2o83Iytp6UKSu6WZvf3H/CgSCJkwLNTstYSpTPJkyFVfY+/3QY3j/CAY4WqUX9mFZju7Wc2Tye46rlpg7zAeWTHr6++fK6rTD2Dc2rsQxNFQY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=BcqDBA12; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="BcqDBA12"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0FD5D1F000E9;
	Fri, 12 Jun 2026 11:40:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1781264430;
	bh=KVZ1IOgOcpFiREFIZRI0pzZF0dUU+70z1HuBJeLrlV4=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=BcqDBA12XZ8GfLRO91HczOPBn5l+lRLen6Vxw09E5c7n0zjbARcbMm+pvbil0pRq9
	 Hp6Jolg+sYi7wGevyCIYopJGcu98z3KFRLe7rIFEKDKCnFRs1t7nkdKlIR1sYaILF6
	 S54FYy4T4fyc3FmtoKt3+/Msb5vWVrgmvobQfhejwQX1vEP9W8mlVgfXG7/4bS3du5
	 4zK2R5fRiQRnBzn+I/qe0BQitRyrGkJBJB4IuK7TTAiADKrxP+4IVNxf9UmtO+yzFf
	 OIdUWkJOwkAU6R5ZpdAwfossUIeBM435fow/dzaLvcFR0sqTICpXqfUC/13h/0A+Tz
	 J+QItKzjNA2OA==
From: sashiko-bot@kernel.org
Subject: Re: [PATCH v2 58/60] scsi: qla2xxx: Zero dport diagnostics buffer
 to avoid info leak
Reply-To: sashiko-reviews@lists.linux.dev
To: "Nilesh Javali" <njavali@marvell.com>
Cc: linux-scsi@vger.kernel.org
In-Reply-To: <20260612095333.1666592-59-njavali@marvell.com>
References: <20260612095333.1666592-59-njavali@marvell.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Fri, 12 Jun 2026 11:40:29 +0000
Message-Id: <20260612114030.0FD5D1F000E9@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>

Thank you for your contribution! Sashiko AI review found 3 potential issue(=
s) to consider:

Pre-existing issues:
- [High] Functions using a stack-allocated `bsg[DMA_POOL_SIZE]` buffer leak=
 uninitialized kernel stack memory to user space and the device hardware.
- [High] The CPU zero-initializes a DMA mapped buffer with `memset()` after=
 ownership has been transferred to the device via `dma_map_single()`, which=
 can silently overwrite device DMA data on non-coherent architectures.
- [High] The mapped DMA buffer `dd->buf` is embedded inside a `__packed` st=
ructure, forcing an unaligned address mapping that violates cacheline isola=
tion and risks DMA hardware errors.
--

commit db26a0928e61a1d01c807ef436263bd6ea60d8b1
Author: Nilesh Javali <njavali@marvell.com>

scsi: qla2xxx: Zero dport diagnostics buffer to avoid info leak

The qla2x00_do_dport_diagnostics function previously allocated the response
buffer without zeroing it. If the user request payload was short, the unused
fields would leak uninitialized kernel heap contents to user space. This pa=
tch
fixes the info leak by switching to kzalloc_obj.

> diff --git a/drivers/scsi/qla2xxx/qla_bsg.c b/drivers/scsi/qla2xxx/qla_bs=
g.c
> index 7f4558beee2c3..b57c55964f9e2 100644
> --- a/drivers/scsi/qla2xxx/qla_bsg.c
> +++ b/drivers/scsi/qla2xxx/qla_bsg.c
> @@ -2744,7 +2744,7 @@ qla2x00_do_dport_diagnostics(struct bsg_job *bsg_jo=
b)
>  	    !IS_QLA28XX(vha->hw) && !IS_QLA29XX(vha->hw))
>  		return -EPERM;
> =20
> -	dd =3D kmalloc_obj(*dd);
> +	dd =3D kzalloc_obj(*dd);

[Severity: High]
This isn't a bug introduced by this patch, but does allocating this __packed
structure lead to unaligned DMA mappings?

Looking at struct qla_dport_diag in drivers/scsi/qla2xxx/qla_bsg.h, the
__packed attribute forces the buf array to an unaligned 2-byte offset:

struct qla_dport_diag {
    uint16_t options;
    uint32_t buf[16];
    uint8_t  unused[62];
} __packed;

When dd->buf is later passed to dma_map_single() inside
qla26xx_dport_diagnostics(), wouldn't this violate the DMA API alignment
constraints and risk cacheline sharing or hardware DMA failures?

>  	if (!dd) {
>  		ql_log(ql_log_warn, vha, 0x70db,
>  		    "Failed to allocate memory for dport.\n");
>  		return -ENOMEM;
>  	}
> =20
>  	sg_copy_to_buffer(bsg_job->request_payload.sg_list,
>  	    bsg_job->request_payload.sg_cnt, dd, sizeof(*dd));
> =20
>  	rval =3D qla26xx_dport_diagnostics(
>  	    vha, dd->buf, sizeof(dd->buf), dd->options);

[Severity: High]
This is a pre-existing issue, but does the hardware diagnostics function
clobber its own DMA buffers?

Inside qla26xx_dport_diagnostics() in drivers/scsi/qla2xxx/qla_mbx.c, the c=
ode
does this:

qla26xx_dport_diagnostics(...) {
    ...
    dd_dma =3D dma_map_single(&vha->hw->pdev->dev, dd_buf, size, DMA_FROM_D=
EVICE);
    ...
    memset(dd_buf, 0, size);
    ...
}

Since ownership has already been transferred to the device via dma_map_sing=
le(),
could this memset() overwrite the hardware's DMA data on non-coherent
architectures when the CPU cache lines are evicted or written back?

[Severity: High]
This is a pre-existing issue, but do other functions in this file suffer fr=
om
a similar stack-based info leak?

Functions like qla2x00_read_fru_status() allocate an uninitialized stack
buffer:

qla2x00_read_fru_status(...) {
    uint8_t bsg[DMA_POOL_SIZE];
    struct qla_status_reg *sr =3D (void *)bsg;
    ...
    sg_copy_to_buffer(..., sr, sizeof(*sr));
    ...
    sg_copy_from_buffer(..., sr, sizeof(*sr));
}

If the user provides a payload smaller than the structure size,
sg_copy_to_buffer() leaves the remainder of the buffer uninitialized.

When sg_copy_from_buffer() copies the entire structure size back to the
user's reply payload, couldn't this leak uninitialized kernel stack memory
to user space, much like the heap leak fixed in this patch?

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20260612095333.1666=
592-1-njavali@marvell.com?part=3D58
