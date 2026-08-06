Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1709C490BFC
	for <linux-scsi@vger.kernel.org>; Thu,  6 Aug 2026 20:41:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1786048889; cv=none; b=P/txiYV7B8kKsPSdTEskzii/UPmKhE2uOpvAi9XYKLM0jnIYpTjgw6SosgNUpqv4gTn23Jvai7kzQJbmH2fI+wTF3a/lwdLaxEXcpgYXPsUgA+NXROfPgIZwAOjUsz6umHx5/Wp89XHlpeb7/fOgPDU0w49wiFu+e7FGU0UnKnQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1786048889; c=relaxed/simple;
	bh=sHFThvGIQ1GzCESQkzHLMceYrHuQQA/6jOHKvkMAqxY=;
	h=From:Subject:To:Cc:In-Reply-To:References:Content-Type:Date:
	 Message-Id; b=eIE/XIzz4A0+LDeuUPwcJPtkGCScVD3Yo5RZX0DE8phIL43+04n7Bzn/ZRUCgarZZYGkCSXOKzX7GF4/7sRlhbDWjOTGxUOjENGza8CSrlm0vGi/23RD69opsP/tHsxuuJGKfxiMkzhR33kfnH9Ai2WBIASSP1kQ3o13jdewJWQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=n9sFzKHY; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="n9sFzKHY"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B2EF21F000E9;
	Thu,  6 Aug 2026 20:41:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1786048887;
	bh=kMFQcKaL/a2SDMkchUWp0AJoStiv4Fsu4Fpu4/VlZ90=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=n9sFzKHYv+sMZaiXHoIj9nsW5UEu8eW2x8AzjG1UlWJkFytSFgwYNMzvkcaEtSDqr
	 U34/YoViYCIdT+6kkh+ZlXaqtlLMQWOLKyEJKqpHIdXMzYBG0LzSa8QAyrxcyhyLpg
	 nk441h1nYWJR7t4tp7cq3pOes6u7C2mw8cVt63WSB4W8BZUVCJOb4BUQ3+Vkp+5+Rw
	 jXsUA15OQYikRjfJR3TWvvNg3n9jv38Y0X16l4kzWA9SE7bMlqgWFs8NWRHMVGtSRa
	 9rez5t2IuCapiD2zTNwDlM6G06tyyPBohppFnvP5GL+2rW1PakOYvKDhGViRAlGVlI
	 OkEM+wqoMYPvA==
From: sashiko-bot@kernel.org
Subject: Re: [PATCH v2 3/5] scsi: elx: efct: free the request tag when the
 send frame WQE fails
Reply-To: sashiko-reviews@lists.linux.dev
To: "Ali Ahmet Memis" <ali@iusegentoo.com>
Cc: linux-scsi@vger.kernel.org
In-Reply-To: <20260806202205.345326-4-ali@iusegentoo.com>
References: <20260806192345.328621-1-ali@iusegentoo.com>
 <20260806202205.345326-4-ali@iusegentoo.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Thu, 06 Aug 2026 20:41:27 +0000
Message-Id: <20260806204127.B2EF21F000E9@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>

Thank you for your contribution! Sashiko AI review found 5 potential issue(=
s) to consider:

New issues:
- [Medium] The patch adds cleanup code to a mathematically unreachable erro=
r path, completely failing to address the actual root cause of the reqtag e=
xhaustion.

Pre-existing issues:
- [Critical] Unconditional freeing of a reused sequence buffer (`seq`) lead=
s to a catastrophic Use-After-Free, Double-Free, and hardware DMA corruptio=
n when sending a task set full/busy response.
- [High] Guaranteed NULL pointer dereference when sending a task set full/b=
usy response.
- [High] `efct_hw_reqtag_free()` detects a double-free but incorrectly proc=
eeds to corrupt the freelist.
- [High] `efct_hw_init()` fails to handle `efct_hw_io_alloc()` failure, lea=
ding to a NULL pointer dereference.
--

--- Patch [3]: [PATCH v2 3/5] scsi: elx: efct: free the request tag when th=
e send frame WQE fails ---
commit 415b71fb97ba10c30ffb204dfd40acdb37bb24d1
Author: Ali Ahmet Memis <ali@iusegentoo.com>

scsi: elx: efct: free the request tag when the send frame WQE fails

efct_hw_send_frame() takes a request tag from the pool and then builds the
WQE. When sli_send_frame_wqe() fails it returns without giving the tag
back.

> diff --git a/drivers/scsi/elx/efct/efct_hw.c b/drivers/scsi/elx/efct/efct=
_hw.c
> index 6cc48fa3e656a..db68516e80750 100644
> --- a/drivers/scsi/elx/efct/efct_hw.c
> +++ b/drivers/scsi/elx/efct/efct_hw.c
> @@ -3009,6 +3009,7 @@ efct_hw_send_frame(struct efct_hw *hw, struct fc_fr=
ame_header *hdr,
>  				ctx->wqcb->instance_index);
>  	if (rc) {
>  		efc_log_err(hw->os, "sli_send_frame_wqe failed: %d\n", rc);
> +		efct_hw_reqtag_free(hw, ctx->wqcb);
>  		return -EIO;
>  	}

[Severity: Medium]
Does this error path actually ever execute?

Looking at sli_send_frame_wqe(), it appears to unconditionally return 0:

libefc_sli/sli4.c:sli_send_frame_wqe() {
    ...
    return 0;
}

Since sli_send_frame_wqe() always returns 0, this error handling block seems
unreachable. Is there a different root cause for the reqtag exhaustion?


While reviewing this change, I also noticed a few other areas in the driver
that might need attention.

[Severity: Critical]
This isn't a bug introduced by this patch, but does efct_dispatch_frame()
unconditionally free a reused sequence buffer, causing a use-after-free?

When efct_scsi_io_alloc() fails, the driver sends a task set full/busy
response via efct_sframe_common_send(). It allocates the async transmission
context directly inside the incoming sequence's DMA buffer:

efct_unsol.c:efct_sframe_common_send() {
    ctx =3D (void *)(heap_virt_base + heap_offset);
    ...
    ctx->seq =3D seq;
}

However, efct_dispatch_frame() ignores the return value of
efct_dispatch_fcp_cmd() and unconditionally frees the sequence:

efct_unsol.c:efct_dispatch_frame() {
    kref_put(&node->ref, node->release);
    efct_hw_sequence_free(&efct->hw, seq);
    return 0;
}

When transmission completes, efct_sframe_common_send_cb() double-frees the
sequence:

efct_unsol.c:efct_sframe_common_send_cb() {
    /* Free sequence */
    efct_hw_sequence_free(hw, ctx->seq);
}

Could this cause memory corruption and hardware DMA issues if the buffer is
returned to the hardware receive ring before the async send completes?


[Severity: High]
This is a pre-existing issue, but does sending a task set full/busy response
result in a NULL pointer dereference?

In efct_sframe_common_send(), the context is zeroed out, leaving wqebuf as
NULL:

efct_unsol.c:efct_sframe_common_send() {
    memset(ctx, 0, sizeof(*ctx));
    ...
}

This uninitialized context is passed to efct_hw_send_frame(), which passes
the NULL wqe->wqebuf to sli_send_frame_wqe():

efct_hw.c:efct_hw_send_frame() {
    rc =3D sli_send_frame_wqe(&hw->sli, wqe->wqebuf, ...);
}

sli_send_frame_wqe() immediately calls memset() on this NULL buffer:

libefc_sli/sli4.c:sli_send_frame_wqe() {
    memset(buf, 0, sli->wqe_size);
}

Will this guarantee a kernel panic when triggered?


[Severity: High]
This isn't a bug introduced by this patch, but does efct_hw_reqtag_free()
corrupt the freelist if it detects a double-free?

If a tag is already freed, the function logs an error but doesn't return
early:

efct_hw.c:efct_hw_reqtag_free() {
    if (!wqcb->callback)
        efc_log_err(hw->os, "WQCB is already freed\n");

    spin_lock_irqsave(&reqtag_pool->lock, flags);
    wqcb->callback =3D NULL;
    ...
    INIT_LIST_HEAD(&wqcb->list_entry);
    list_add(&wqcb->list_entry, &hw->wq_reqtag_pool->freelist);
    spin_unlock_irqrestore(&reqtag_pool->lock, flags);
}

If the tag is already in the freelist, doesn't continuing with
INIT_LIST_HEAD() and list_add() completely corrupt the list pointers?


[Severity: High]
This is a pre-existing issue, but does an allocation failure in
efct_hw_init() lead to a NULL pointer dereference later?

If efct_hw_io_alloc() fails, it logs an error but returns success:

efct_hw.c:efct_hw_init() {
    hw->hw_wq[0]->send_frame_io =3D efct_hw_io_alloc(hw);
    if (!hw->hw_wq[0]->send_frame_io)
        efc_log_err(hw->os, "alloc for send_frame_io failed\n");

    /* Initialize send frame sequence id */
    atomic_set(&hw->send_frame_seq_id, 0);

    return 0;
}

Later, efct_hw_send_frame() unconditionally dereferences it:

efct_hw.c:efct_hw_send_frame() {
    xri =3D wq->send_frame_io->indicator;
}

Should efct_hw_init() return an error code instead of 0 when this
allocation fails?

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20260806192345.3286=
21-1-ali@iusegentoo.com?part=3D3
