Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A5F743B4EA4
	for <linux-scsi@vger.kernel.org>; Tue,  7 Jul 2026 07:26:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1783409187; cv=none; b=UYEkEvnCfWzVaRNyu/Fvl7q1jXSWjAOxlyS/y5VYuvh96D918wWncvAOdi1BntcQT0d/QbOl7JAQH/RrQ6eseY5kA8nFl3yhhzb8hyQUtU9uFW2g7xBQGxPNC7whhjkPQK3FaEzmeFFOivIxjn3Uw69mGJDOVFVSUFjfS9m9o7A=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1783409187; c=relaxed/simple;
	bh=HFhc7UHaNYEmJ9BZxnxOh4uOBdHmm/+1AWPDouhniqI=;
	h=From:Subject:To:Cc:In-Reply-To:References:Content-Type:Date:
	 Message-Id; b=jrlvTVplno5zTTWPYBMaDnMtkarHMM/T+s/vuGRurn3+ERHRSiST1ik+dyHWL+xnYnUDEopV3hmeOM/MXuRxkAmftXa6fkOHks+092nbMFWrPy9tpMVOgyb6jpo4+LxvQzFfnzqancuX9XXNTC/WRsJmBuG6ZAo/tF60IVoi98A=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=gFVPE8rR; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="gFVPE8rR"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A08B41F000E9;
	Tue,  7 Jul 2026 07:26:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1783409178;
	bh=WQ0il7fhm16ipsB+WZRIstvspzWpjq0k2yc+Aj4Eglc=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=gFVPE8rRezbarlHwHgqNWMyjJ27w0bkeuoYjLZtzbPxQkJJ3WZ9Q7zaxTP6o9317b
	 gbGp0Nm09EMh2+dvfEHDMO5toGKgnN7m4LRGsInTakTh8Sv+58xqtuBdWvHPOr60EW
	 bIIpkNXEdJ5MUywtYDOGGnRL24Nt1iENsz3H+w07BbKA8h+oNdCYn55lODnKNHN95T
	 vIB1j2cdIPbFs4v26CpeLwn+2yQALuPIgyMxRNvlNnmrAP+CXwzHR8xpKjKuabPNmA
	 GC9pylelgWPb+558BkY4WNH2nABo+6NVes0q73XhALPCrXMZL10vzM8q7g6yOr+OdX
	 TuUOx5eLMADKA==
From: sashiko-bot@kernel.org
Subject: Re: [PATCH v3 66/88] scsi: qla2xxx: Use memset_io() to clear
 QLAFX00 request ring slot
Reply-To: sashiko-reviews@lists.linux.dev
To: "Nilesh Javali" <njavali@marvell.com>
Cc: linux-scsi@vger.kernel.org
In-Reply-To: <20260707055435.2680300-67-njavali@marvell.com>
References: <20260707055435.2680300-1-njavali@marvell.com>
 <20260707055435.2680300-67-njavali@marvell.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Tue, 07 Jul 2026 07:26:18 +0000
Message-Id: <20260707072618.A08B41F000E9@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>

Thank you for your contribution! Sashiko AI review found 2 potential issue(=
s) to consider:

New issues:
- [Medium] The new wrt_reg_byte() and wrt_reg_dword() calls in __qla2x00_al=
loc_iocbs() introduce an endianness accessor violation and are dead code, a=
s they are completely overwritten by QLAFX00 IOCB builder functions.

Pre-existing issues:
- [High] The patch replaces memset() with memset_io() for QLAFX00 request r=
ings to prevent ARM64 synchronous external aborts, but fails to replace ide=
ntical memcpy() calls in QLAFX00 IOCB builder functions that write to the s=
ame I/O memory ring.
--

--- Patch [66]: [PATCH v3 66/88] scsi: qla2xxx: Use memset_io() to clear QL=
AFX00 request ring slot ---
commit 9fcba115efaf36871216e19534a66706185340b3
Author: Nilesh Javali <njavali@marvell.com>

scsi: qla2xxx: Use memset_io() to clear QLAFX00 request ring slot

For QLAFX00 the request ring is ioremapped device I/O memory
(ha->iobase + req_que_off), not DMA-coherent RAM, which is why the rest
of the FX00 path accesses it through memcpy_toio() and the wrt_reg_*
helpers. __qla2x00_alloc_iocbs() however zeroed the producer slot with a
plain memset(). On architectures such as ARM64 a regular memset() may
emit unaligned or block-zeroing instructions (e.g. DC ZVA) that are
invalid on Device memory, leading to a synchronous external abort.

Use memset_io() to clear the slot for QLAFX00, matching the I/O
accessors used elsewhere on this ring. Other adapters keep the plain
memset() on their DMA-coherent rings. The zero-fill is retained for FX00
because its IOCB builders (e.g. qlafx00_fxdisc_iocb()) copy only part of
the entry and rely on the unused tail being pre-zeroed.

> The zero-fill is retained for FX00 because its IOCB builders (e.g.
> qlafx00_fxdisc_iocb()) copy only part of the entry and rely on the
> unused tail being pre-zeroed.

[Severity: Medium]
Is this description accurate?

Looking at qlafx00_fxdisc_iocb(), it appears to copy the entire 64-byte
struct using memcpy_toio(), rather than only part of the entry:

drivers/scsi/qla2xxx/qla_mr.c:qlafx00_fxdisc_iocb() {
    ...
    memcpy_toio((void __iomem *)pfxiocb, &fx_iocb, sizeof(fx_iocb));
    ...
}

Will this overwrite the handle and entry_count fields written by the new
wrt_reg_* calls in __qla2x00_alloc_iocbs()?

> diff --git a/drivers/scsi/qla2xxx/qla_iocb.c b/drivers/scsi/qla2xxx/qla_i=
ocb.c
> index 22f2d81e20099..c81df5a96014a 100644
> --- a/drivers/scsi/qla2xxx/qla_iocb.c
> +++ b/drivers/scsi/qla2xxx/qla_iocb.c
> @@ -2454,11 +2454,13 @@ __qla2x00_alloc_iocbs(struct qla_qpair *qpair, sr=
b_t *sp)
>  	 */
>  	req->cnt -=3D req_cnt;
>  	pkt =3D qla_req_ring_slot(ha, req);
> -	memset(pkt, 0, qla_req_entry_size(ha));
>  	if (IS_QLAFX00(ha)) {
> +		memset_io((void __iomem __force *)pkt, 0,
> +			  qla_req_entry_size(ha));
> +		wrt_reg_byte((u8 __force __iomem *)&pkt->entry_count, req_cnt);
> +		wrt_reg_dword((__le32 __force __iomem *)&pkt->handle, handle);

[Severity: Medium]
Do these wrt_reg_* calls introduce an endianness violation by mixing=20
byteswapping register accessors with stream copies?=20

wrt_reg_dword() performs CPU-to-little-endian byte swapping, but=20
subsequent builders like qlafx00_fxdisc_iocb() write to this same I/O
memory ring using memcpy_toio(), which preserves host endianness.

[Severity: High]
This isn't a bug introduced by this patch, but does the same ARM64
synchronous external abort issue exist in other QLAFX00 builders?

While this patch addresses memset() in __qla2x00_alloc_iocbs(), functions
like qlafx00_tm_iocb() and qlafx00_abort_iocb() in=20
drivers/scsi/qla2xxx/qla_mr.c still appear to use plain memcpy() to copy
structs directly to the I/O memory ring slot instead of memcpy_toio():

drivers/scsi/qla2xxx/qla_mr.c:qlafx00_tm_iocb() {
    ...
    memcpy(ptm_iocb, &tm_iocb,
           sizeof(struct tsk_mgmt_entry_fx00));
    ...
}

drivers/scsi/qla2xxx/qla_mr.c:qlafx00_abort_iocb() {
    ...
    memcpy(pabt_iocb, &abt_iocb,
           sizeof(struct abort_iocb_entry_fx00));
    ...
}

Can these plain memcpy() calls also emit unaligned or block-copying
instructions that crash the system on Device memory?

>  	} else {
> +		memset(pkt, 0, qla_req_entry_size(ha));
>  		pkt->entry_count =3D req_cnt;
>  		pkt->handle =3D handle;
>  	}

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20260707055435.2680=
300-1-njavali@marvell.com?part=3D66
