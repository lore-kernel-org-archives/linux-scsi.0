Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6C658494832
	for <linux-scsi@vger.kernel.org>; Thu,  6 Aug 2026 19:54:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1786046056; cv=none; b=sar60WWWJSDSUa/wXB94Ub26bvW0bRZtBE3T9L/HRCd0nES7ItT2qwmO5Txn2xGaBx2bfhTyVmiQuR8APKDA4jhzZN+jZIfZtUplZb0cw7x5Bz+zqPkFBUaST92cdww70G+3ml2atMj+o+qBNp7EOkpYllH/oTJNnfUG/QlPmw8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1786046056; c=relaxed/simple;
	bh=Ath06uOB8plfN29Gp++J+utEaTvI9Dhb378A20VAp+A=;
	h=From:Subject:To:Cc:In-Reply-To:References:Content-Type:Date:
	 Message-Id; b=Bl/Nmie0RRupQB00i03qdwhQ42hiojlBMd5caXubUh7QXfq/jmvobKsX4ZgiewILiU8CRmc+kyPZgmAXUkiufPWGwty0q9CxW2v0abYCoznwp8DbYw4Nksko/ZrdERDI4Lri2bvNhPjaz2gH+a77knkOU9Nyjm9E5ByiLnJsDWk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=ZxJu2LEc; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="ZxJu2LEc"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A98DD1F000E9;
	Thu,  6 Aug 2026 19:54:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1786046053;
	bh=HfnIxYY4JjaAB7924x6DzjJARqMDgHg8qKmEkWiyKog=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=ZxJu2LEcjuQfPO7Q8sXtbjLbFY4GvmmxVzvTHPgVOW5fUFYSKFkSK3eyBetw2oQP2
	 0EwV4NXAXEQN5xwKGhlpDpTslPuCwYr0haVD3lB7YLs4bMQrK47GgxCuVVx6LEw8Cy
	 fx0NtHCBA0qQjgw5G6IvUbD1SeXBVaKKFVqxgho1pQlo/EBb9RtE+bmiYRK7kgSb3E
	 4/gTpVCmv72skkEDRH8V/LfIPzKQq57+SLwK/U24vid+3OdGA++j5Wgq+RpCL9cmcj
	 /P0nCoiAHDuVvsSonfGDeoGH4Wvwsx5NeR7f3eikRT6fIvYcPQhsHTPiODEVbjwOgy
	 LvzmdlqLfQu7g==
From: sashiko-bot@kernel.org
Subject: Re: [PATCH 2/5] scsi: elx: efct: free the HIO when the WQE cannot
 be built
Reply-To: sashiko-reviews@lists.linux.dev
To: "Ali Ahmet Memis" <ali@iusegentoo.com>
Cc: linux-scsi@vger.kernel.org
In-Reply-To: <20260806192345.328621-3-ali@iusegentoo.com>
References: <20260806192345.328621-1-ali@iusegentoo.com>
 <20260806192345.328621-3-ali@iusegentoo.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Thu, 06 Aug 2026 19:54:13 +0000
Message-Id: <20260806195413.A98DD1F000E9@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>

Thank you for your contribution! Sashiko AI review found 3 potential issue(=
s) to consider:

Pre-existing issues:
- [Critical] `sli_xmit_sequence64_wqe()` treats the provided SGL array as a=
 direct payload buffer, leading to an out-of-bounds DMA read and transmitti=
ng kernel memory contents over Fibre Channel.
- [High] If asynchronous task scheduling fails due to memory pressure, the =
IO request is leaked and never completed to the upper layer.
- [High] Missing `efct_hw_reqtag_free` on error paths leaks WQ callback con=
text, eventually leading to exhaustion of the request tag pool.
--

--- Patch [2]: [PATCH 2/5] scsi: elx: efct: free the HIO when the WQE canno=
t be built ---
commit c236a09d90fd9d31b4fd7efd9ef66e408be03d17
Author: Ali Ahmet Memis <ali@iusegentoo.com>

scsi: elx: efct: free the HIO when the WQE cannot be built
   =20
efct_els_hw_srrs_send() and efct_hw_bls_send() allocate an HIO, ask sli4
to build a WQE into it, and give up when that fails without putting the
HIO back:

[ ... ]

> diff --git a/drivers/scsi/elx/efct/efct_hw.c b/drivers/scsi/elx/efct/efct=
_hw.c
> index 15c37ff1d52e4..6cc48fa3e656a 100644
> --- a/drivers/scsi/elx/efct/efct_hw.c
> +++ b/drivers/scsi/elx/efct/efct_hw.c

[ ... ]

> @@ -2820,24 +2821,27 @@ efct_els_hw_srrs_send(struct efc *efc, struct efc=
_disc_io *io)
>  		rc =3D -EIO;
>  	}
> =20
> -	if (rc =3D=3D 0) {
> -		hio->xbusy =3D true;
> +	if (rc) {
> +		efct_hw_io_free(hw, hio);
> +		return rc;
> +	}

[Severity: Critical]
This is a pre-existing issue, but does sli_xmit_sequence64_wqe() incorrectly
receive hio->sgl instead of the actual data buffer send?

In efct_els_hw_srrs_send() for EFC_DISC_IO_CT_RESP:

	if (sli_xmit_sequence64_wqe(&hw->sli, hio->wqe.wqebuf, hio->sgl,
				    &ct_params)){

If sli_xmit_sequence64_wqe() treats the provided SGL array as a direct
payload buffer:

libefc_sli/sli4.c:sli_xmit_sequence64_wqe() {
	...
	xmit->bde.bde_type_buflen =3D
		cpu_to_le32((SLI4_BDE_TYPE_VAL(64)) |
			(params->rsp_len & SLI4_BDE_LEN_MASK));
	xmit->bde.u.data.low  =3D
			cpu_to_le32(lower_32_bits(payload->phys));
	xmit->bde.u.data.high =3D
			cpu_to_le32(upper_32_bits(payload->phys));
	xmit->sequence_payload_len =3D cpu_to_le32(params->rsp_len);
	...
}

Could this lead to an out-of-bounds DMA read and transmit kernel memory
contents over Fibre Channel?

[ ... ]

[Severity: High]
This is a pre-existing issue, but does efct_hw_send_frame() leak the WQ
callback context on error paths?

drivers/scsi/elx/efct/efct_hw.c:efct_hw_send_frame() {
	...
	rc =3D sli_send_frame_wqe(&hw->sli, wqe->wqebuf,
				sof, eof, (u32 *)hdr, payload, payload->len,
				EFCT_HW_SEND_FRAME_TIMEOUT, xri,
				ctx->wqcb->instance_index);
	if (rc) {
		efc_log_err(hw->os, "sli_send_frame_wqe failed: %d\n", rc);
		return -EIO;
	}

	/* Write to WQ */
	rc =3D efct_hw_wq_write(wq, wqe);
	if (rc) {
		efc_log_err(hw->os, "efct_hw_wq_write failed: %d\n", rc);
		return -EIO;
	}
	...
}

If sli_send_frame_wqe() or efct_hw_wq_write() fail, the function returns -E=
IO,
but shouldn't it call efct_hw_reqtag_free() to avoid exhausting the request
tag pool?

[Severity: High]
This is a pre-existing issue, but do efct_scsi_dispatch_pending() and
efct_scsi_check_pending() leak the IO request if asynchronous task scheduli=
ng
fails?

drivers/scsi/elx/efct/efct_scsi.c:efct_scsi_dispatch_pending() {
	...
		if (efct_hw_async_call(&efct->hw,
				       efct_scsi_check_pending_async_cb, io)) {
			efc_log_debug(efct, "call hw async failed\n");
		}
	...
}

drivers/scsi/elx/efct/efct_scsi.c:efct_scsi_check_pending() {
	...
			if (efct_hw_async_call(&efct->hw,
					efct_scsi_check_pending_async_cb, io)) {
				efc_log_debug(efct, "hw async failed\n");
			}
	...
}

If efct_hw_async_call() fails due to memory pressure, it logs an error but
doesn't call the callback or return the IO to the pool. Will this silently =
drop
the SCSI IO request and cause a command timeout?

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20260806192345.3286=
21-1-ali@iusegentoo.com?part=3D2
