Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 83BAB439F89
	for <linux-scsi@vger.kernel.org>; Tue, 18 Aug 2026 18:11:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1787076667; cv=none; b=fF1k5J7pK93ZTlHPGZwMmUkd0XLmJgVnqKB7Ayz/IFWMoBHyQssLe9NIsAJNfkdzSwGibtcjcfRlrFSa93PP77rWv4rfq42LQuRgE6NuVb5aIY9cjoCO5DtCuXufqg2NrZO5u0MueGAD1CeqjR7AnzTFJZ+buvWaLw15tD3TdJs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1787076667; c=relaxed/simple;
	bh=hlnwOiZSzrOE5bAI9IVA8mZplGceE3cXyEVwQU7jjlA=;
	h=From:Subject:To:Cc:In-Reply-To:References:Content-Type:Date:
	 Message-Id; b=ekGkhFpd092hlrOmbU7T30DCrXZb+lLo5xahUxnxSFsjP/mOROQtY018vSxfiWxnJG9FFrm+ESg6+B0CnjCBufm7dSM3mGM7tj62C0Ac4p9Y8wqOXK8X+FAKU9Ipuuswy5J6kgoK7dIi4KreTO5xZr6s0vm4ofUJXRsaFqA7ZAo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=fRrE9QXg; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="fRrE9QXg"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 04AE11F000E9;
	Tue, 18 Aug 2026 18:11:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1787076666;
	bh=m7zMlD05oO8B6MPqSEE5LxA1sAQ8DF4EG4XgNm/wvKI=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=fRrE9QXgRGz+tU5f4Nn/wGf+mWIgx6AIXOcqwU9FEKpsl+kZF+me0fw/i5Ok4h9HQ
	 nLq0ijpVhjWJYg95QnLgQLlQWNSA0L27HD5qmoJ1xFj50NsjXu+Yz1BDkyXxVzLiMZ
	 ZrKV+2MXcjTvCahAp43WE+hiYJvhp5wAc9UyT3B7adIBmOav2/cgrZSxaZg9tRliDZ
	 PV0IHJJJ41pK21WQCCb+N7dYj6o46IN3g3VT77th69jKp2bdFqDdCzHnQGDpdh2E+m
	 /WUWlypk9i1QRV4eFi9eXwJae69cYHoqEyiIoLeZQq5xVXiQG7iFP+VrnBYm6FQHe5
	 PuqaiADJBmxhg==
From: sashiko-bot@kernel.org
Subject: Re: [PATCH 06/17] mpi3mr: Fix out-of-bounds reply frame access
Reply-To: sashiko-reviews@lists.linux.dev
To: "Chandrakanth Patil" <chandrakanth.patil@broadcom.com>
Cc: linux-scsi@vger.kernel.org
In-Reply-To: <20260818231426.58105-7-chandrakanth.patil@broadcom.com>
References: <20260818231426.58105-1-chandrakanth.patil@broadcom.com>
 <20260818231426.58105-7-chandrakanth.patil@broadcom.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Tue, 18 Aug 2026 18:11:05 +0000
Message-Id: <20260818181106.04AE11F000E9@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>

Thank you for your contribution! Sashiko AI review found 2 potential issue(=
s) to consider:

New issues:
- [Low] The newly added modulo operation `((phys_addr - mrioc->reply_buf_dm=
a) % mrioc->reply_sz)` implicitly performs a 64-bit division, causing a bui=
ld failure (linker error) on 32-bit platforms where `dma_addr_t` is 64-bit.

Pre-existing issues:
- [High] An integer overflow in the reply pool size calculation allows a ma=
licious or compromised device to trigger a massive out-of-bounds DMA write,=
 leading to host memory corruption.
--

--- Patch [6]: [PATCH 06/17] mpi3mr: Fix out-of-bounds reply frame access -=
--
commit 144f6c8866bb0bb9ede9699c897280faf1028d42
Author: Chandrakanth Patil <chandrakanth.patil@broadcom.com>

mpi3mr: Fix out-of-bounds reply frame access

This commit tightens the validation of reply frame addresses by requiring
the address to be frame-aligned and ensuring a whole frame fits within the
pool.

> diff --git a/drivers/scsi/mpi3mr/mpi3mr_fw.c b/drivers/scsi/mpi3mr/mpi3mr=
_fw.c
> index 681868716ebdb..5e61448d8dbc6 100644
> --- a/drivers/scsi/mpi3mr/mpi3mr_fw.c
> +++ b/drivers/scsi/mpi3mr/mpi3mr_fw.c
> @@ -128,7 +128,8 @@ void *mpi3mr_get_reply_virt_addr(struct mpi3mr_ioc *m=
rioc,
>  		return NULL;
> =20
>  	if ((phys_addr < mrioc->reply_buf_dma) ||
> -	    (phys_addr > mrioc->reply_buf_dma_max_address))
> +	    (phys_addr > mrioc->reply_buf_dma_max_address - mrioc->reply_sz) ||
> +	    ((phys_addr - mrioc->reply_buf_dma) % mrioc->reply_sz))

[Severity: Low]
Will this modulo operation cause a linker error on 32-bit platforms?

Since dma_addr_t can be 64-bit on 32-bit architectures (like x86 PAE), using
the modulo operator on it might implicitly perform a 64-bit division. This
typically results in an undefined reference to __umoddi3 during the build.

Could this be avoided by using explicit division macros like div64_u64_rem()
or similar?

>  		return NULL;
> =20
>  	return mrioc->reply_buf + (phys_addr - mrioc->reply_buf_dma);

[Severity: High]
This is a pre-existing issue, but does the reply pool size calculation in
mpi3mr_alloc_reply_sense_bufs() suffer from a 32-bit integer overflow?

If a device provides crafted values for maximum outstanding requests and
reply frame size, this multiplication might overflow:

drivers/scsi/mpi3mr/mpi3mr_fw.c:mpi3mr_alloc_reply_sense_bufs() {
    ...
    u32 sz;
    ...
    sz =3D mrioc->num_reply_bufs * mrioc->reply_sz;
    ...
}

If this overflows, an undersized DMA pool would be created. Later, in
mpimr_initialize_reply_sbuf_queues(), the driver loops over the expected
number of buffers and writes out-of-bounds DMA addresses to the hardware:

drivers/scsi/mpi3mr/mpi3mr_fw.c:mpimr_initialize_reply_sbuf_queues() {
    ...
    for (i =3D 0, phy_addr =3D mrioc->reply_buf_dma;
         i < mrioc->num_reply_bufs; i++, phy_addr +=3D mrioc->reply_sz)
        mrioc->reply_free_q[i] =3D cpu_to_le64(phy_addr);
    ...
}

Could this allow a malicious or compromised device to trigger out-of-bounds
DMA writes into host memory?

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20260818231426.5810=
5-1-chandrakanth.patil@broadcom.com?part=3D6
