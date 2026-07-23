Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 27730284B2F
	for <linux-scsi@vger.kernel.org>; Thu, 23 Jul 2026 19:49:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784836201; cv=none; b=jX3ta18BgewGahQEMKIGJBLdMGYpZjYBz8b9hBT0sW8vFhUatoZP+dHV7cfjetD02T+Nt3LiZxdZr6GCjB8XbOjy+Dra4idJjaSGYi2u9epm/o0qCn6rF19ifNSe16HQiibEwkrTmcIIUcdo3HfvbmjdDDxMGydUbTjytARECA8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784836201; c=relaxed/simple;
	bh=BmoiXXIdR00+s614w6rtToJRbWWkPCxWFkY9T5ukB4E=;
	h=From:Subject:To:Cc:In-Reply-To:References:Content-Type:Date:
	 Message-Id; b=unoZGG++aGA75sji8/GmcKqUChIOXOezXlxnx+IIeRTHqMXLq0RxvITU6opwrNlHNkvsV8avqyOBAW0Cfm4NRequtq67mPAcg62GJ85KztILBrkpZI2firpQgcA/kZ5SAybTToLSwrEZFNxywBFuYRYNe+uR6s1aoAIxB/eM63Q=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=c6+nr9Wv; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="c6+nr9Wv"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9E7B01F000E9;
	Thu, 23 Jul 2026 19:49:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1784836197;
	bh=ImEr1LuhZYaDwDR08TdD6iliMj8QazrLspJMGlaQLu0=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=c6+nr9Wvx2GaRPbzHp2cErpzteAzO+nnpgCjiLojvhgZrMxHP2lPenRT2ogrOv0LN
	 KvXTHh4KSg2kDcBnDibKHP+PAGWO4CGdaVcX6YnSH1Xpw0UUt/rHJmfgUSNw6n4JiU
	 MkrHq0QR4632yCFoaAVs8PRvL7/RXw/786ecDTq5YDor6/Pb//Q/QQ/iMKnLO1tXQr
	 s1S8bayxsnkaumG4BJIc7fErFa8A7eW9mVlAC7mFby6+zvmcs1NQ1fgaXzX+sbSnyj
	 9v/BGM93bc+xolPi36vYDdL0ihtmnDRf2PS10gEpYspTCnZS2deIRaVMtAyAQFi6QV
	 i6q5kVbQDL5ug==
From: sashiko-bot@kernel.org
Subject: Re: [PATCH v6 53/56] scsi: qla2xxx: Zero dport diagnostics buffer
 to avoid info leak
Reply-To: sashiko-reviews@lists.linux.dev
To: "Nilesh Javali" <njavali@marvell.com>
Cc: linux-scsi@vger.kernel.org
In-Reply-To: <20260723050413.3897522-54-njavali@marvell.com>
References: <20260723050413.3897522-1-njavali@marvell.com>
 <20260723050413.3897522-54-njavali@marvell.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Thu, 23 Jul 2026 19:49:57 +0000
Message-Id: <20260723194957.9E7B01F000E9@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>

Thank you for your contribution! Sashiko AI review found 4 potential issue(=
s) to consider:

Pre-existing issues:
- [Critical] Multiple BSG handlers use uninitialized stack buffers for requ=
est/reply structures, causing kernel memory leaks, arbitrary hardware write=
s, and severe buffer overflows when users provide a short payload.
- [High] Modifying a DMA buffer with memset() after it has been mapped for =
DMA_FROM_DEVICE violates DMA ownership rules and causes cache coherency dat=
a corruption.
- [High] DMA mapping a misaligned buffer inside a __packed struct risks cac=
he line sharing corruption and hardware DMA faults.
- [Medium] Unvalidated reply_payload_rcv_len can trigger a kernel WARN_ON i=
n the block layer.
--

--- Patch [53]: [PATCH v6 53/56] scsi: qla2xxx: Zero dport diagnostics buff=
er to avoid info leak ---
commit b2d4e000f67ba62a27fd752863bb10d9c1b2ea09
Author: Nilesh Javali <njavali@marvell.com>

scsi: qla2xxx: Zero dport diagnostics buffer to avoid info leak

This patch changes the allocation of the qla_dport_diag response buffer
from kmalloc_obj() to kzalloc_obj() in qla2x00_do_dport_diagnostics().
The change ensures the buffer is zero-initialized, preventing kernel heap
contents from leaking to user space when copying the structure back.

> diff --git a/drivers/scsi/qla2xxx/qla_bsg.c b/drivers/scsi/qla2xxx/qla_bs=
g.c
> index f9f9687316b58..4a9cf8da67a6b 100644
> --- a/drivers/scsi/qla2xxx/qla_bsg.c
> +++ b/drivers/scsi/qla2xxx/qla_bsg.c
> @@ -2806,7 +2806,7 @@ qla2x00_do_dport_diagnostics(struct bsg_job *bsg_jo=
b)
>  	    !IS_QLA28XX(vha->hw) && !IS_QLA29XX(vha->hw))
>  		return -EPERM;
> =20
> -	dd =3D kmalloc_obj(*dd);
> +	dd =3D kzalloc_obj(*dd);

[Severity: High]
This is a pre-existing issue, but are we risking cache line sharing
corruption and hardware DMA faults by DMA mapping the misaligned buffer
inside this structure?

Looking at the structure definition:

drivers/scsi/qla2xxx/qla_bsg.h:struct qla_dport_diag {
	uint16_t options;
	uint32_t buf[16];
	uint8_t  unused[62];
} __packed;

Because the struct is __packed, the buf array is forced to an unaligned
2-byte offset.

When buf is subsequently mapped for DMA in qla26xx_dport_diagnostics():

drivers/scsi/qla2xxx/qla_mbx.c:qla26xx_dport_diagnostics() {
    ...
	dd_dma =3D dma_map_single(&vha->hw->pdev->dev, dd_buf, size,
				DMA_FROM_DEVICE);
    ...
}

Could unmapping or syncing this misaligned buffer on non-coherent
architectures invalidate the entire cache line, thereby corrupting the
adjacent options and unused fields? Furthermore, could providing a 2-byte
aligned address to the HBA cause hardware DMA faults?


[Severity: High]
This isn't a bug introduced by this patch, but does the memset() in the
diagnostics functions violate DMA ownership rules?

In qla26xx_dport_diagnostics():

drivers/scsi/qla2xxx/qla_mbx.c:qla26xx_dport_diagnostics() {
    ...
	dd_dma =3D dma_map_single(&vha->hw->pdev->dev, dd_buf, size,
				DMA_FROM_DEVICE);
    ...
	memset(dd_buf, 0, size);
    ...
}

A similar pattern exists in qla26xx_dport_diagnostics_v2().

The DMA API forbids the CPU from modifying a buffer while it is mapped for
device DMA. On non-cache-coherent architectures, does the CPU write bring
the cache line into the CPU cache and mark it as dirty, meaning that if it
is evicted to RAM after the device completes its DMA writes, the CPU's
zeroes might silently overwrite the device's diagnostic data?

Since the allocation in qla2x00_do_dport_diagnostics() is now using
kzalloc_obj(), is this memset() still necessary, or can it be removed?


[Severity: Medium]
This is a pre-existing issue, but does setting the reply length
unconditionally risk triggering a block layer WARN_ON if the user provides
a short payload?

Later in qla2x00_do_dport_diagnostics():

drivers/scsi/qla2xxx/qla_bsg.c:qla2x00_do_dport_diagnostics() {
    ...
	bsg_reply->reply_payload_rcv_len =3D sizeof(*dd);
    ...
}

If a user submits a BSG job with a reply payload smaller than sizeof(*dd),
will reply_payload_rcv_len exceed the allocated response length, triggering
a WARN_ON(job->reply_payload_rcv_len > rsp_len) in the block layer?


[Severity: Critical]
This is a pre-existing issue, but do other BSG handlers have similar
uninitialized stack buffer vulnerabilities?

Several handlers allocate structures on the stack without initializing them,
and sg_copy_to_buffer() only populates the bytes provided by the user
payload. If a user provides a short payload, variables might remain
uninitialized stack garbage.

For example, in qla2x00_write_i2c():

drivers/scsi/qla2xxx/qla_bsg.c:qla2x00_write_i2c() {
    ...
	memcpy(sfp, i2c->buffer, i2c->length);
    ...
}

Could an uninitialized i2c->length cause an out-of-bounds read from the
stack and an out-of-bounds write to the DMA pool allocation?

Similar issues appear to exist in:
- qla2x00_read_i2c() (memcpy overflowing the fixed-size stack array bsg)
- qla2x00_update_fru_versions() (uninitialized list->count dictating loop
  iterations)
- qla2x00_read_fru_status() (uninitialized stack buffer copied to user spac=
e)
- qla_edif_app_start() (uninitialized pad and reserved fields copied to
  user space)

Could a user issuing a BSG job with a truncated request payload trigger
these out-of-bounds accesses or memory leaks?

>  	if (!dd) {
>  		ql_log(ql_log_warn, vha, 0x70db,
>  		    "Failed to allocate memory for dport.\n");

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20260723050413.3897=
522-1-njavali@marvell.com?part=3D53
