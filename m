Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9BD683CEB8F
	for <linux-scsi@vger.kernel.org>; Tue, 14 Jul 2026 18:20:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784053250; cv=none; b=iIq6AvvVWayXpBJ2fzUDVVPxAAg3K7/3mXj5JVEhKFh4PrtCXOQn1d7mF9mMJPx9grVt/hiIxIzn6Umvv8+C4YAclHGiGoYUpHmGf+yxcCIlaU7gjDlJzx/lUUUdIOgfdf4g1zm7TLSqKZdZaM7pKsDqB8M2y1HKwiv9AIIOsTI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784053250; c=relaxed/simple;
	bh=1Qw4GwtPiQRK9uy1S+3wQ2B0JuVPjhCOGMYugTfN4BA=;
	h=From:Subject:To:Cc:In-Reply-To:References:Content-Type:Date:
	 Message-Id; b=TcNWYcE0pb03FJVTRO/9m5MT/0cMTfb1Ur4slCu6gT+fLFElVSk43Iajx9ohYN7xSe9mBLNQC6orw/Pp8fakN/BsLWqiF5mrnniAerg/ejCvZGuBrxQ1Egxu2UlKt/fqMDgFYE+ps32qbySgf5vOLOYN+jaF7OuPeB8FeDXaVdE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=iNw0pY9Y; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="iNw0pY9Y"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 065B11F000E9;
	Tue, 14 Jul 2026 18:20:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1784053247;
	bh=KDoz1ZIUBVQxVzdsJf5FCoGILR2aIkDeub5L3EmlsDY=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=iNw0pY9YHR0RmmypRDdW/ItBBxnuPHd1aVz90FS1AUUf2pov0yiSe4UHLSNVmoAh1
	 kqThNwz1M3JAJ0nHs59RZlRqko88kU+gBNbdEfgLyY+EK6WrakRxk/nrJGLQkf1l8s
	 0s3wMiheQuniH/RlkfC+SmNObzZcHpZYkyDVteh4Th1oGNcumO5YVSugaUnnEjykJ9
	 n6l//mWFocsJW9+6pJbGPghMIaXXP+b4D77kK23OBTixE94yZw5i7W9bpkVfYjLkd8
	 lf1Uu8xp46yTQl0YHUmeu0aGyia4WFxAf+FRpTUqvmWK9YyEliOmxoCFDYqQAxX48i
	 Jp/fPdoIJ7bvg==
From: sashiko-bot@kernel.org
Subject: Re: [PATCH v4 53/56] scsi: qla2xxx: Zero dport diagnostics buffer
 to avoid info leak
Reply-To: sashiko-reviews@lists.linux.dev
To: "Nilesh Javali" <njavali@marvell.com>
Cc: linux-scsi@vger.kernel.org
In-Reply-To: <20260714095353.289460-54-njavali@marvell.com>
References: <20260714095353.289460-1-njavali@marvell.com>
 <20260714095353.289460-54-njavali@marvell.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Tue, 14 Jul 2026 18:20:46 +0000
Message-Id: <20260714182047.065B11F000E9@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>

Thank you for your contribution! Sashiko AI review found 5 potential issue(=
s) to consider:

Pre-existing issues:
- [High] Modifying a DMA buffer via `memset()` on the CPU side after mappin=
g it with `DMA_FROM_DEVICE`.
- [High] The DMA buffer `dd->buf` is not cacheline aligned because it resid=
es within a `__packed` struct at an unaligned offset, violating DMA API req=
uirements.
- [High] Missing bounds checking on user-provided lengths and counts in BSG=
 vendor commands leads to severe stack buffer overflows and out-of-bounds m=
emory accesses.
- [Medium] Lockless read-modify-write of shared `dport_status` and `dport_d=
ata` fields causes data races and lost updates.
- [Medium] Uninitialized kernel stack memory is leaked to user space in the=
 error path of `qla2x00_do_dport_diagnostics_v2()`.
--

--- Patch [53]: [PATCH v4 53/56] scsi: qla2xxx: Zero dport diagnostics buff=
er to avoid info leak ---
commit 1e0dfc47857c60bc25a36c5d991d81db839c9245
Author: Nilesh Javali <njavali@marvell.com>

scsi: qla2xxx: Zero dport diagnostics buffer to avoid info leak

This commit replaces kmalloc_obj() with kzalloc_obj() in=20
qla2x00_do_dport_diagnostics() to prevent leaking uninitialized kernel heap
memory to user space. It ensures the options and unused fields of the
qla_dport_diag struct are zeroed out before being copied out via
sg_copy_from_buffer().

Fixes: ec89146215d1 ("qla2xxx: Add bsg interface to support D_Port Diagnost=
ics.")
Cc: stable@vger.kernel.org

> --- a/drivers/scsi/qla2xxx/qla_bsg.c
> +++ b/drivers/scsi/qla2xxx/qla_bsg.c
> @@ -2858,7 +2858,7 @@ qla2x00_do_dport_diagnostics(struct bsg_job *bsg_jo=
b)
>  	    !IS_QLA28XX(vha->hw) && !IS_QLA29XX(vha->hw))
>  		return -EPERM;
> =20
> -	dd =3D kmalloc_obj(*dd);
> +	dd =3D kzalloc_obj(*dd);

[Severity: High]
This isn't a bug introduced by this patch, but I noticed a potential DMA API
violation in the related diagnostic code.

In qla26xx_dport_diagnostics(), the buffer is mapped for device DMA:

    dd_dma =3D dma_map_single(&vha->hw->pdev->dev,
        dd_buf, size, DMA_FROM_DEVICE);

But then it appears to be modified via memset() on the CPU side:

    memset(dd_buf, 0, size);

Since the buffer is already mapped for device DMA, could this CPU-side
memset() bring cache lines into the CPU cache and mark them dirty? If the
CPU evicts these cache lines during or after the device performs its DMA
transfer, it might overwrite and corrupt the device's diagnostic results.
A similar pattern seems to occur in qla26xx_dport_diagnostics_v2().


[Severity: High]
This is a pre-existing issue, but I am curious about the alignment of the
dd->buf structure.

The struct qla_dport_diag is marked as __packed:

drivers/scsi/qla2xxx/qla_bsg.h:
    struct qla_dport_diag {
        uint16_t options;
        uint32_t buf[16];
        uint8_t  unused[62];
    } __packed;

This forces the buf array to a 2-byte offset. When this buffer is mapped
for DMA in qla26xx_dport_diagnostics() using dma_map_single(), would the
cache line invalidation on non-coherent architectures destroy adjacent
CPU-accessed fields like options, since the buffer is not cacheline aligned?


[Severity: High]
This is a pre-existing issue, but there might be some bounds checking
concerns in other BSG vendor commands.

In qla2x00_write_i2c(), i2c->length is used for memcpy() into a stack buffe=
r:

    memcpy(sfp, i2c->buffer, i2c->length);

Since i2c->length comes from the user without validation, is there a risk
this could overflow the 256-byte sfp stack buffer? Similar unvalidated
length usage appears in qla2x00_read_i2c() and qla2x00_update_fru_versions()
where it might cause out-of-bounds reads from the stack.


[Severity: Medium]
This isn't a bug introduced by this patch, but does the read-modify-write
of vha->dport_status have a race condition?

In qla2x00_do_dport_diagnostics_v2(), the status is modified locklessly:

    vha->dport_status |=3D  DPORT_DIAG_IN_PROGRESS;

Meanwhile, the interrupt handler in qla2x00_async_event() also modifies it:

    vha->dport_status &=3D ~DPORT_DIAG_IN_PROGRESS;

Could these concurrent non-atomic bitwise operations cause updates to be
lost, leaving the diagnostic state machine in an inconsistent state?


[Severity: Medium]
This is a pre-existing issue, but is there another info leak in the v2
diagnostic handler?

In qla2x00_do_dport_diagnostics_v2(), mcp->mb fields are assigned to dd on
the error path:

    dd->mbx1 =3D mcp->mb[0];
    dd->mbx2 =3D mcp->mb[1];

If qla26xx_dport_diagnostics_v2() fails early (for example, returning
QLA_MEMORY_ALLOC_FAILED due to a dma_map_single() failure), it returns
without initializing mcp->mb. Does this error path copy uninitialized kernel
stack memory into the reply payload, leaking it to user space?

>  	if (!dd) {
>  		ql_log(ql_log_warn, vha, 0x70db,
>  		    "Failed to allocate memory for dport.\n");

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20260714095353.2894=
60-1-njavali@marvell.com?part=3D53
