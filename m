Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D39E4494801
	for <linux-scsi@vger.kernel.org>; Thu,  6 Aug 2026 19:50:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1786045849; cv=none; b=Rumj8naxgJBEDTKu2a//SI0mz/fkSPX99SWBW/4niE3oLhlCwgr7ZVgeUk5V60YzjVcnm0mxSqVngaP/1YYqsu9osCcc32OKXbk5hMi30sXpUcnV5yTDRx9jxw8wKtiSLiS/BUZEy9i7sFSIt1qgU0YyszhDW+Cijikwi/gmzu4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1786045849; c=relaxed/simple;
	bh=tdbpexdk3k5y3VwhkGRLrTDW1Bc3aCZOasMcL6QYBnk=;
	h=From:Subject:To:Cc:In-Reply-To:References:Content-Type:Date:
	 Message-Id; b=qj9vWDJJ8mlcBvLLmN2aM5hewo82M+e9Z3T/p4DIDcregoBCoIQm7ub9hs917r56FUQrMFDWJh5bWd0Sh/TKocTqs4Orlx+sAdKr2/8a+bR41T07sePVjHqGOHDTCS7fVWQeuJi4HYsdAkdmtNjQyoKZIlnZBEkw4RiyFK62pqI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=GmLiOHB+; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="GmLiOHB+"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0E9FE1F000E9;
	Thu,  6 Aug 2026 19:50:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1786045839;
	bh=1WEzz+jJkaZm8naQjqrTz5/KUojFReVczFMc0sbpP/I=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=GmLiOHB+P05YdWYy3Namf8kCAzrsl4lx/IaOLDNYeYA0r+us6XJNwQGTipTGIOLc4
	 MrG6vIuo8i6xik9/vwEwWqITDSrl9w8q2HsDLDux8LEPMcDNv33BcEuRKziCpJq3J7
	 W/nGfzoyCp+mJ4+GKJyMBUqBG8e6xnBzl/Xsm7TyD7u+4K4RDkkYH2iwwFxmVWm+Tb
	 4W7mhFNNjZWPahL+7Dn7RdWOocVJqU7LbKTodq3TPhanCQQYLApJ+3WCpblFsYipeL
	 U2pGu42DGgYfwblYO3BtQ+g6gC+GkszvOBNSPfYPbJS1tBKmSKtBLAS2xRuBDLldMb
	 tBeeXJfCjqaUA==
From: sashiko-bot@kernel.org
Subject: Re: [PATCH 3/5] scsi: elx: efct: free the request tag when the send
 frame WQE fails
Reply-To: sashiko-reviews@lists.linux.dev
To: "Ali Ahmet Memis" <ali@iusegentoo.com>
Cc: linux-scsi@vger.kernel.org
In-Reply-To: <20260806192345.328621-4-ali@iusegentoo.com>
References: <20260806192345.328621-1-ali@iusegentoo.com>
 <20260806192345.328621-4-ali@iusegentoo.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Thu, 06 Aug 2026 19:50:38 +0000
Message-Id: <20260806195039.0E9FE1F000E9@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>

Thank you for your contribution! Sashiko AI review found 5 potential issue(=
s) to consider:

Pre-existing issues:
- [Critical] Use-After-Free and Double-Free of receive sequence buffer duri=
ng task set full/busy response.
- [Critical] Deterministic NULL pointer dereference passing uninitialized `=
wqebuf` to `sli_send_frame_wqe()`.
- [High] NULL pointer dereference in `efct_hw_send_frame()` if `send_frame_=
io` allocation fails.
- [High] Missing `dma_rmb()` memory barrier after checking the valid bit of=
 the EQE and CQE.
- [High] Incorrect byte swapping of the FC frame header on Big-Endian archi=
tectures.
--

--- Patch [3]: [PATCH 3/5] scsi: elx: efct: free the request tag when the s=
end frame WQE fails ---
commit 66a0b41398fa81e3a9b1b1edf2e7a32743d6bf86
Author: Ali Ahmet Memis <ali@iusegentoo.com>

scsi: elx: efct: free the request tag when the send frame WQE fails
   =20
efct_hw_send_frame() takes a request tag from the pool and then builds the
WQE. When sli_send_frame_wqe() fails it returns without giving the tag
back:

[ ... ]

> diff --git a/drivers/scsi/elx/efct/efct_hw.c b/drivers/scsi/elx/efct/efct=
_hw.c
> index 6cc48fa3e656a..db68516e80750 100644
> --- a/drivers/scsi/elx/efct/efct_hw.c
> +++ b/drivers/scsi/elx/efct/efct_hw.c
> @@ -3009,6 +3009,7 @@ efct_hw_send_frame(struct efct_hw *hw, struct fc_fr=
ame_header *hdr,

[Severity: High]
This is a pre-existing issue, but can this lead to a NULL pointer dereferen=
ce=20
if send_frame_io allocation fails?

During driver initialization, if efct_hw_io_alloc() fails, it logs an error=
=20
but completes successfully:

drivers/scsi/elx/efct/efct_hw.c:efct_hw_init() {
    ...
    hw->hw_wq[0]->send_frame_io =3D efct_hw_io_alloc(hw);
    if (!hw->hw_wq[0]->send_frame_io)
        efc_log_err(hw->os, "alloc for send_frame_io failed\n");

    /* Initialize send frame sequence id */
    atomic_set(&hw->send_frame_seq_id, 0);

    return 0;
}

Later, efct_hw_send_frame() directly dereferences it without checking for N=
ULL=20
just before creating the WQE:

drivers/scsi/elx/efct/efct_hw.c:efct_hw_send_frame() {
    ...
    /* Set XRI and RX_ID in the header based on which WQ, and which
     * send_frame_io we are using
     */
    xri =3D wq->send_frame_io->indicator;
    ...
}

Should initialization fail if this allocation fails?

[Severity: Critical]
This is a pre-existing issue, but does this lead to a NULL pointer derefere=
nce=20
when attempting to send a task set full or busy response?

In efct_sframe_common_send(), the context is zero-initialized:

drivers/scsi/elx/efct/efct_unsol.c:efct_sframe_common_send() {
    ...
    memset(ctx, 0, sizeof(*ctx));
    /* Save sequence */
    ctx->seq =3D seq;
    ...
}

This leaves the embedded ctx->wqe.wqebuf pointer as NULL. When=20
efct_hw_send_frame() is called, it passes this uninitialized wqebuf to=20
sli_send_frame_wqe():

drivers/scsi/elx/efct/efct_hw.c:efct_hw_send_frame() {
    ...
    rc =3D sli_send_frame_wqe(&hw->sli, wqe->wqebuf,
                            sof, eof, (u32 *)hdr, payload, payload->len,
    ...
}

Then sli_send_frame_wqe() immediately attempts to memset the buffer:

drivers/scsi/elx/libefc_sli/sli4.c:sli_send_frame_wqe() {
    ...
    struct sli4_send_frame_wqe *sf =3D buf;

    memset(buf, 0, sli->wqe_size);
    ...
}

Will this cause a guaranteed kernel panic on command flooding when IO conte=
xts=20
are exhausted?

[Severity: Critical]
This is a pre-existing issue, but can this sequence lead to a use-after-fre=
e=20
and double-free of the receive sequence buffer?

When efct_scsi_io_alloc() fails, it rejects the command via=20
efct_sframe_send_task_set_full_or_busy(). This uses the receive sequence's=
=20
payload buffer to build the transmission payload and context:

drivers/scsi/elx/efct/efct_unsol.c:efct_sframe_common_send() {
    ...
    ctx =3D (void *)(heap_virt_base + heap_offset);
    ...
    ctx->seq =3D seq;
    ...
}

After queuing the transmit with efct_hw_send_frame(), control returns to=20
efct_dispatch_frame() which unconditionally frees the sequence, returning i=
t to=20
the hardware receive ring:

drivers/scsi/elx/efct/efct_unsol.c:efct_dispatch_frame() {
    ...
    kref_put(&node->ref, node->release);
    efct_hw_sequence_free(&efct->hw, seq);
    return 0;
}

This appears to return the buffer to the hardware receive queue while the=20
hardware is simultaneously trying to DMA transmit from it.=20

Furthermore, when the asynchronous transmit completes, it frees the exact s=
ame=20
sequence a second time:

drivers/scsi/elx/efct/efct_unsol.c:efct_sframe_common_send_cb() {
    ...
    /* Free sequence */
    efct_hw_sequence_free(hw, ctx->seq);
}

Is it safe to free the sequence in efct_dispatch_frame() when it has been=20
repurposed for transmission?

[Severity: High]
This is a pre-existing issue, but does this incorrectly byte-swap the FC fr=
ame=20
header on Big-Endian architectures?

In sli_send_frame_wqe(), the frame header bytes are cast to u32 and swapped:

drivers/scsi/elx/libefc_sli/sli4.c:sli_send_frame_wqe() {
    ...
    /* Copy FC header */
    sf->fc_header_0_1[0] =3D cpu_to_le32(hdr[0]);
    sf->fc_header_0_1[1] =3D cpu_to_le32(hdr[1]);
    sf->fc_header_2_5[0] =3D cpu_to_le32(hdr[2]);
    sf->fc_header_2_5[1] =3D cpu_to_le32(hdr[3]);
    sf->fc_header_2_5[2] =3D cpu_to_le32(hdr[4]);
    sf->fc_header_2_5[3] =3D cpu_to_le32(hdr[5]);
    ...
}

On Big-Endian architectures, reading a byte array via a 32-bit load reverse=
s=20
the 4 bytes, and cpu_to_le32() applies a second swap. When stored to memory=
,=20
the Big-Endian store behavior reverses it again. Will this result in the=20
hardware receiving a byte-reversed FC frame header?

[Severity: High]
This is a pre-existing issue, but is a read memory barrier required after=20
checking the valid bit of the DMA-coherent queue entry?

In sli_eq_read(), the valid bit is checked and then the entry is copied:

drivers/scsi/elx/libefc_sli/sli4.c:sli_eq_read() {
    ...
    wflags =3D le16_to_cpu(((struct sli4_eqe *)qe)->dw0w0_flags);

    if ((wflags & SLI4_EQE_VALID) !=3D q->phase) {
        spin_unlock_irqrestore(&q->lock, flags);
        return -EIO;
    }
    ...
    memcpy(entry, qe, q->size);
    ...
}

A similar pattern exists in sli_cq_read():

drivers/scsi/elx/libefc_sli/sli4.c:sli_cq_read() {
    ...
    dwflags =3D le32_to_cpu(((struct sli4_mcqe *)qe)->dw3_flags);
    valid_bit_set =3D (dwflags & SLI4_MCQE_VALID) !=3D 0;

    if (valid_bit_set !=3D q->phase) {
        spin_unlock_irqrestore(&q->lock, flags);
        return -EIO;
    }
    ...
    memcpy(entry, qe, q->size);
    ...
}

On weakly ordered architectures, could the CPU speculatively read the entry=
's=20
body before the valid bit check completes over the bus, leading to the=20
processing of stale or corrupted DMA descriptor data? Does this require a=20
dma_rmb() before the memcpy()?

>  				ctx->wqcb->instance_index);
>  	if (rc) {
>  		efc_log_err(hw->os, "sli_send_frame_wqe failed: %d\n", rc);
> +		efct_hw_reqtag_free(hw, ctx->wqcb);
>  		return -EIO;
>  	}

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20260806192345.3286=
21-1-ali@iusegentoo.com?part=3D3
