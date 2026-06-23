Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AB8573D3008
	for <linux-scsi@vger.kernel.org>; Tue, 23 Jun 2026 11:41:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1782214888; cv=none; b=PFiC3CPQuGkNY7G+sg7gJdd50ScAYbFaFycW3NrdwM+ihKyhLRznXzqs6hDeU5tRIUj+s15oRh8BQEnybRDIlIoIwnzMv30/JxI6WykyDaRWCRampRiwvtr0CU7nwnD42wNSDUF+HWNFauTGB1tY5zzW3LFkJ0NcmxvHkI5vu6Q=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1782214888; c=relaxed/simple;
	bh=hECfgdRpsnxNq471sl56romowxoDY4Mdlmcp6ecisbg=;
	h=From:Subject:To:Cc:In-Reply-To:References:Content-Type:Date:
	 Message-Id; b=atm06h7cASVPDjPqzNIP66nJ+k7sxhEJuGG0PL0Yed+6NyrV89Rpz+3pgHBk9H4VGMWnNHll8wjIx4mtJQrtOz5wuykdyVlKWw7dtgnG3kZ5fNB1qb69VSqaRPpOz6EJ10b4BJS+u5M4e+sSyOCxt0v8GBWpWFOJTpRPPum+Kgo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=Pdnurj8J; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="Pdnurj8J"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 473111F000E9;
	Tue, 23 Jun 2026 11:41:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1782214887;
	bh=7zcZkbnDfVKQzQGn9hetdrJvMzAqTTiGe7rRyz9WPkI=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=Pdnurj8JGPGGH73/NCktgRX0lBMsB7CDm5d5VnI29+jG5ubGnuUO9SkYQpvR1Bzy9
	 pqM8P+b8AOxD1Ql9bWSHaUv7y3A6x1Rc0uVKYHL6lxAjFEnFSs2Fi/YEAZNcen6nvx
	 pNcXbsWiLifpKjXLzY6upZgZ8RD3Je/C3zQq5lP8ULQi3kx7lGcKHWjiGfbF+3a2mm
	 SDzXMfOWDVxpgOLKAwfqnvKZ1o+Uky3D7UEe/8zesi9Z3EU8Wa3WT8YyS6upbDzeuP
	 17km221tTOdK4wJZnafTIaNr2mNaKUVSl2veXI4epaDUjW8GUxQTJjfWnbxQgFE2qO
	 yOksOAa0b0sLw==
From: sashiko-bot@kernel.org
Subject: Re: [PATCH] scsi: bnx2fc: Use kmalloc_array() for array allocations
Reply-To: sashiko-reviews@lists.linux.dev
To: "Can Peng" <pengcan@kylinos.cn>
Cc: linux-scsi@vger.kernel.org
In-Reply-To: <20260623112428.98097-1-pengcan@kylinos.cn>
References: <20260623112428.98097-1-pengcan@kylinos.cn>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Tue, 23 Jun 2026 11:41:26 +0000
Message-Id: <20260623114127.473111F000E9@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>

Thank you for your contribution! Sashiko AI review found 3 potential issue(=
s) to consider:

Pre-existing issues:
- [Critical] Unchecked CQE frame length leads to integer underflow, small s=
kb allocation, and out-of-bounds memset.
- [High] If `kmalloc_array()` fails in `bnx2fc_process_unsol_compl`, the fu=
nction breaks out without updating the hardware receive queue (RQ) consumer=
 index or returning the consumed RQEs, permanently desynchronizing the RQ f=
rom the completion queue (CQ).
- [High] Calling `bnx2fc_return_rqe()` with `num_rq > 1` corrupts the produ=
cer index due to a strict equality wrap check.
--

commit d860000c312968cdacef28865412092a3af9d66c
Author: Can Peng <pengcan@kylinos.cn>

scsi: bnx2fc: Use kmalloc_array() for array allocations

Documentation/process/deprecated.rst discourages open-coded arithmetic
in allocator arguments and recommends using the 2-factor allocator forms.

The unsolicited completion path allocates num_rq buffers of
BNX2FC_RQ_BUF_SZ bytes, and task_ctx_dma is an array of task_ctx_arr_sz
dma_addr_t entries. Use kmalloc_array() for both allocations.

Signed-off-by: Can Peng <pengcan@kylinos.cn>

> diff --git a/drivers/scsi/bnx2fc/bnx2fc_hwi.c b/drivers/scsi/bnx2fc/bnx2f=
c_hwi.c
> --- a/drivers/scsi/bnx2fc/bnx2fc_hwi.c
> +++ b/drivers/scsi/bnx2fc/bnx2fc_hwi.c
> @@ -655,8 +655,8 @@ static void bnx2fc_process_unsol_compl(struct bnx2fc_=
rport *tgt, u16 wqe)
>  		if (rq_data) {
>  			buf =3D rq_data;
>  		} else {
> -			buf1 =3D buf =3D kmalloc((num_rq * BNX2FC_RQ_BUF_SZ),
> -					      GFP_ATOMIC);
> +			buf1 =3D buf =3D kmalloc_array(num_rq, BNX2FC_RQ_BUF_SZ,
> +						   GFP_ATOMIC);
> =20
>  			if (!buf1) {
>  				BNX2FC_TGT_DBG(tgt, "Memory alloc failure\n");
>  				break;
>  			}

[Severity: High]
This isn't a bug introduced by this patch, but I noticed that if=20
kmalloc_array fails here, the function breaks out of the loop without=20
updating the hardware receive queue consumer index or returning the=20
consumed RQEs.

Does this failure path permanently desynchronize the receive queue and the
completion queue? If the ring buffer wraps around and bnx2fc_get_next_rqe
returns NULL without advancing rq_cons_idx, breaking here seems to abandon
the completion queue entry while the outer loop advances cq_cons_idx.

[ ... ]

> 			for (i =3D 0; i < num_rq; i++) {
> 				spin_lock_bh(&tgt->tgt_lock);
> 				rq_data =3D (unsigned char *)
> 					   bnx2fc_get_next_rqe(tgt, 1);
> 				spin_unlock_bh(&tgt->tgt_lock);
> 				len =3D BNX2FC_RQ_BUF_SZ;
> 				memcpy(buf1, rq_data, len);
> 				buf1 +=3D len;
> 			}
> 		}
> 		bnx2fc_process_l2_frame_compl(tgt, buf, frame_len,
> 					      FC_XID_UNKNOWN);

[Severity: Critical]
This is a pre-existing issue, but I am concerned about an integer underflow
occurring when bnx2fc_process_l2_frame_compl is called with frame_len.

In bnx2fc_process_l2_frame_compl():
    payload_len =3D frame_len - sizeof(struct fc_frame_header);
    fp =3D fc_frame_alloc(lport, payload_len);

If a remote attacker sends a malformed frame with a length less than 24
bytes, won't payload_len underflow?

Since payload_len is eventually passed to fc_frame_alloc_fill, it appears
alloc_skb_fclone truncates it to a 32-bit size, allocating a small buffer.
Could the subsequent memset then write past the small allocation using the
huge underflowed length, causing remote out-of-bounds memory corruption?

> 		if (buf !=3D rq_data)
> 			kfree(buf);
> 		spin_lock_bh(&tgt->tgt_lock);
> 		bnx2fc_return_rqe(tgt, num_rq);

[Severity: High]
This is a pre-existing issue, but calling bnx2fc_return_rqe here with a
num_rq greater than 1 looks like it could corrupt the producer index.

In bnx2fc_return_rqe():
    if ((next_prod_idx & 0x7fff) =3D=3D BNX2FC_RQ_WQES_MAX) {
        /* Wrap around RQ */
        next_prod_idx +=3D 0x8000 - BNX2FC_RQ_WQES_MAX;
    }

If a frame spans multiple buffers, could incrementing by num_rq cause the
index to skip exactly over BNX2FC_RQ_WQES_MAX? If it does, the strict
equality check would fail to wrap the index, pushing it out of bounds and
writing an invalid index to the hardware doorbell.

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20260623112428.9809=
7-1-pengcan@kylinos.cn?part=3D1
