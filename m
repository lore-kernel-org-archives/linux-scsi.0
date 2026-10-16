Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C54064CA78B
	for <linux-scsi@vger.kernel.org>; Fri, 16 Oct 2026 15:06:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1792163163; cv=none; b=BhQ+IN2V9J1BLKeGckoLpZD3oEjiyRZwYPmsf21FenDIo+IIF3JryUBk2Ko6izlSdTj8HmFeM1F5JIlWDyisJbteyj404S7qSJpDv1RwYl3YtFpRPNPOn63kB/ZABPAjMlW9UngjpEOZ0gl6Ajg5bFtUnGVTvraivlJiI6h1zU4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1792163163; c=relaxed/simple;
	bh=e+kqVaVslgNGnDjeAHvVLb9xZFPGLyqC+qhEUvHDVk4=;
	h=Message-ID:From:Subject:To:Cc:In-Reply-To:References:Content-Type:
	 Date; b=EvPsrN+kv/WH2R6ZreQKhNz1/xa6hDNYM1zwBmR0rQKKuF4pDlgiy5V+tpwUUbS/eh6HsSXjJ1Z7qBViGYDaa4hRgaC2R3BjLdUgMDyIotaiw0UTxfOLFG9FsL+iB3d2FLCDHpAuGMNRPmpzImoW1fNhEYGOQyiZKsYK6d7FJOg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=jFfAQ3WB; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="jFfAQ3WB"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3F7B01F000C5;
	Fri, 16 Oct 2026 15:06:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1792163162;
	bh=044C2z+LZwGScUBEhd+dnOhUBu6aaR4yNv3My/LpC6I=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=jFfAQ3WBop1BfGgQdJMVv9qFPT/X+jvzhqwOQMVgPm+LkNkeVEEzhaqyt1xWz3Yby
	 M0MhErjnEcm/TXapsKiLVJh9e21qmgnYYl1N/N/R/BIZEHWiUnA1gHIw8T02XoPlWk
	 ovkDMinUiPNuSkKFCY0XXauBjw769N56Y16EobqoiYKQGBw2B1zBVi8+4sLCxkith2
	 ButDfPw/hftTBXQPmrhQ5eULzplSDOfP52dbw/ip0KJITE2HIipsKGsXPtf6rkJiEp
	 CkpHdYbtLyPOyl7GIggecYXg5KS62a/kgZUAlvHYYxy2ZKhPjYYai8B8oxsNiT39p0
	 p6SbOnx6m/4gA==
Message-ID: <sashiko-outbox-174530@kernel.org>
From: sashiko-bot@kernel.org
Subject: Re: [PATCH] scsi: aacraid: fix dma_free_coherent() size
Reply-To: sashiko-reviews@lists.linux.dev
To: "Thomas Fourier" <fourier.thomas@gmail.com>
Cc: =?utf-8?b?b3BlbiBsaXN0OkFBQ1JBSUQgU0NTSSBSQUlEIERSSVZFUg==?= <linux-scsi@vger.kernel.org>
In-Reply-To: <20261016145420.50870-2-fourier.thomas@gmail.com>
References: <20261016145420.50870-2-fourier.thomas@gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Fri, 16 Oct 2026 15:06:01 +0000
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>

Thank you for your contribution! Sashiko AI review found 1 potential issue(=
s) to consider:
- [High] scsi: aacraid: DMA unmap size mismatch due to shrunken can_queue
--

commit 1e9d5fb7ed09ff94558efbd312a1809b83cd68c2
Author: Thomas Fourier <fourier.thomas@gmail.com>

scsi: aacraid: fix dma_free_coherent() size

This commit updates the DMA unmap size calculation in aac_fib_map_free()
to use dev->max_cmd_size instead of dev->max_fib_size. This is intended to
match the initial allocation size in fib_map_alloc() and prevent leaving
parts of the memory mapped.

> diff --git a/drivers/scsi/aacraid/commsup.c b/drivers/scsi/aacraid/commsu=
p.c
> index 0dba4406494a5..16cc4593a5c97 100644
> --- a/drivers/scsi/aacraid/commsup.c
> +++ b/drivers/scsi/aacraid/commsup.c
> @@ -81,7 +81,7 @@ void aac_fib_map_free(struct aac_dev *dev)
>  		return;
> =20
>  	num_fibs =3D dev->scsi_host_ptr->can_queue + AAC_NUM_MGT_FIB;
> -	fib_size =3D dev->max_fib_size + sizeof(struct aac_fib_xporthdr);
> +	fib_size =3D dev->max_cmd_size + sizeof(struct aac_fib_xporthdr);
>  	alloc_size =3D fib_size * num_fibs + ALIGN32 - 1;

[Severity: High]
Does this recalculation still result in a DMA unmap size mismatch?

While this update corrects the fib_size multiplier, the num_fibs multiplier
is based on dev->scsi_host_ptr->can_queue, which can be modified after the
initial allocation.

For example, fib_map_alloc() allocates memory based on the initial value of
can_queue:

drivers/scsi/aacraid/commsup.c:fib_map_alloc() {
    ...
	dev->hw_fib_va =3D dma_alloc_coherent(&dev->pdev->dev,
		(dev->max_cmd_size + sizeof(struct aac_fib_xporthdr))
		* (dev->scsi_host_ptr->can_queue + AAC_NUM_MGT_FIB) + (ALIGN32 - 1),
		&dev->hw_fib_pa, GFP_KERNEL);
    ...
}

However, for Rocket adapters, can_queue is shrunk after the allocation
successfully completes:

drivers/scsi/aacraid/rkt.c:aac_rkt_select_comm() {
    ...
			dev->scsi_host_ptr->can_queue =3D AAC_NUM_IO_FIB_RKT;
    ...
}

When aac_fib_map_free() is called, it recalculates the unmap size using the
newly shrunken can_queue, which causes a smaller size to be passed to
dma_free_coherent().=20

Will passing a mismatched smaller size to dma_free_coherent() violate the
DMA API contract and lead to leaked memory or corrupt allocator state?

> =20
>  	dma_free_coherent(&dev->pdev->dev, alloc_size, dev->hw_fib_va,
>  			  dev->hw_fib_pa);
> =20
>  	dev->hw_fib_va =3D NULL;
>  	dev->hw_fib_pa =3D 0;
>  }

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20261016145420.5087=
0-2-fourier.thomas@gmail.com?part=3D1
