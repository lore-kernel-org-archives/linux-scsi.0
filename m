Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794928670;
	b=OPP24kLM5dZWRF8O3Rd8eAtMYyq48/PEo4Knlt2HOyvR2IO2xMDeqFeACratydVuUslq
	 0XVIiOLzvhcZl0EkijYrgTnpXEnMHmhSDjv0ueuwDYzhOzhqCLTgPBr4NEKmYNt9JSW4O
	 PI/6a7cLIyDIhex/sLVw9Lpf27wgKtBMeHvE9kAQVzAyEBbaD9H3uvVPI/I1Z9Yz2P2Nu
	 5Kjw/L8qOVSqZEC6ipuOQi6FbH/6ofQg0deOlOjyLXOHuMVNC755TEUiwZsCB9EMogYn+
	 XLEY6zqRfpEyaay5f/wnfUYvu7is0E7AeTLFmkHmRP0IMSf1uLR7IpMUXSZ5bFgDAUw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794928670;
	h=Received:DKIM-Signature:Message-ID:From:Subject:Reply-To:To:Cc:
	 In-Reply-To:References:Content-Type:Content-Transfer-Encoding:Date;
	bh=9Qm/xbm+1KJSdmqL3Jy2uV6gQrtlDBa5IzgqtJP2udo=;
	b=Ma5Pwqss40GQZgcE/BmMD6ySr4o0d7tcDKrVHItV1j3hH9towZPrBGNaohB/T6tu6Cki
	 WgY3ixXjcsCwOFF0qbIUYs9JyqoBgFFaQx+twVYpebuahfNv4g8MFb+JrDP7TxM9yjV+h
	 jT4+Bzq1TDpyrepXNmK45ZShs8XseyDL1vzYPOkDd3PixOCTbNBRAvKImi1rNCd3J3zxQ
	 FHiNqK4luWsy0k4utaX/lqZbTQq98UxXYhcLOshRZ5eJGm2VkncO1FrxiTJieLzPJ2U4T
	 KGEAWn+vZg/5XE+NQBd+zD0Awu0biDHctOE8K9DK+i/Q9QbpFro5pf05UXrfe+vzyxw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=abvGwFS5;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4984F606A32A
	for <linux-scsi@vger.kernel.org>; Tue, 17 Nov 2026 15:17:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=abvGwFS5
Received: by smtp.kernel.org (Postfix) with ESMTPSA id F10841F000C6;
	Tue, 17 Nov 2026 15:17:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1794928670;
	bh=9Qm/xbm+1KJSdmqL3Jy2uV6gQrtlDBa5IzgqtJP2udo=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=abvGwFS5kgFAktunBL4po8J8udSxBB59+tK4HDt8SYSz7//icnPf+2jyd/peIZfzi
	 by7HnhwkO0Uyiv5j0GNLq06HGdtWdmR2S6KGF043gsfU1fJZKpYOOHkiyM61SYcfjA
	 JmAgNApQBDaJBCqmygP5FU7v4Wh0L0jJtYUgpxeEKBnybLLow1FrprfrNb/+iGtkTz
	 /9f8ZrUuKfggfToHycprPh9ZVZpyVOBS67saR2OHmHbd0y/nATwlmXkofuwCxWbDkW
	 jWjLigcEBDotdwn1PFm0oLHHIlAfeG7McZhvBuAmdAKxNiiUT4+s7MBq4E3LrWNX+q
	 eOatNizJwTCSQ==
Message-ID: <sashiko-outbox-219043@kernel.org>
From: sashiko-bot@kernel.org
Subject: Re: [PATCH] scsi: arcmsr: Fix potential DMA leaks on XOR allocation
 failure
Reply-To: sashiko-reviews@lists.linux.dev
To: "Guangshuo Li" <liguangshuo@mail.sdu.edu.cn>
Cc: linux-scsi@vger.kernel.org
In-Reply-To: <20261117-571e631490-scsi-arcmsr-0@mail.sdu.edu.cn>
References: <20261117-571e631490-scsi-arcmsr-0@mail.sdu.edu.cn>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Tue, 17 Nov 2026 15:17:49 +0000
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Post: <mailto:linux-scsi@vger.kernel.org>
List-Help: <mailto:linux-scsi+help@vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-scsi+owner@vger.kernel.org>
Precedence: list

Thank you for your contribution! Sashiko AI review found no new issues
in this patch, but noticed 1 related pre-existing issue it does not
introduce:
- [Critical] scsi: arcmsr: hardware-controlled pointer dereference in
  arcmsr_ccb_complete() [1]
--

commit 5ed92826e96263be26f2281fb2284bdbe1e52cb8
Author: Guangshuo Li <liguangshuo@mail.sdu.edu.cn>

scsi: arcmsr: Fix potential DMA leaks on XOR allocation failure

This commit checks for DMA allocation failure in arcmsr_alloc_xor_buffer()
and frees the CCB pool in arcmsr_alloc_ccb_pool() if XOR buffer allocation
fails.

> diff --git a/drivers/scsi/arcmsr/arcmsr_hba.c b/drivers/scsi/arcmsr/arcms=
r_hba.c
> index 8aa948f06cacf..52caa800397e3 100644
> --- a/drivers/scsi/arcmsr/arcmsr_hba.c
> +++ b/drivers/scsi/arcmsr/arcmsr_hba.c
[ ... ]
> @@ -895,8 +899,10 @@ static int arcmsr_alloc_ccb_pool(struct AdapterContr=
olBlock *acb)
>  		break;
>  	}
>  	if ((acb->firm_PicStatus >> 24) & 0x0f) {
> -		if (arcmsr_alloc_xor_buffer(acb))
> +		if (arcmsr_alloc_xor_buffer(acb)) {
> +			arcmsr_free_ccb_pool(acb);
>  			return -ENOMEM;
> +		}
>  	}
>  	return 0;
>  }

[Severity: Critical]
This problem wasn't introduced by this patch, but can a compromised or
malicious PCI device overwrite the kernel pointers embedded in struct
CommandControlBlock [1]?

arcmsr_alloc_ccb_pool() allocates the CommandControlBlock array in
DMA-coherent memory via dma_alloc_coherent(), and those structures hold
host pointers including ccb->acb, ccb->pcmd, and ccb->list:

drivers/scsi/arcmsr/arcmsr_hba.c:arcmsr_alloc_ccb_pool() {
	...
	dma_coherent =3D dma_alloc_coherent(&pdev->dev, acb->uncache_size, &dma_co=
herent_handle, GFP_KERNEL);
	...
	ccb_tmp =3D dma_coherent;
	...
	for(i =3D 0; i < acb->maxFreeCCB; i++){
		...
		ccb_tmp->acb =3D acb;
		...
		INIT_LIST_HEAD(&ccb_tmp->list);
	...
}

On I/O completion, arcmsr_ccb_complete() trusts those device-accessible
fields and passes them to atomic_dec(), scsi_dma_unmap(),
spin_lock_irqsave(), list_add_tail(), and scsi_done():

drivers/scsi/arcmsr/arcmsr_hba.c:arcmsr_ccb_complete() {
	struct AdapterControlBlock *acb =3D ccb->acb;
	struct scsi_cmnd *pcmd =3D ccb->pcmd;
	unsigned long flags;
	atomic_dec(&acb->ccboutstandingcount);
	scsi_dma_unmap(ccb->pcmd);
	ccb->startdone =3D ARCMSR_CCB_DONE;
	spin_lock_irqsave(&acb->ccblist_lock, flags);
	list_add_tail(&ccb->list, &acb->ccb_free_list);
	spin_unlock_irqrestore(&acb->ccblist_lock, flags);
	scsi_done(pcmd);
}

Overwriting these pointers via DMA allows arbitrary kernel memory writes
and control-flow hijacking.  Host-only metadata should be kept in regular
kernel memory rather than inside the DMA-coherent CCB buffer.

[1] https://sashiko.dev/#/bug/linux-a10df3d7-0d0e-4b31-a2dd-416f0ee6e806

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20261117-571e631490=
-scsi-arcmsr-0@mail.sdu.edu.cn?part=3D1
