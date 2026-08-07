Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 226A3314B9A
	for <linux-scsi@vger.kernel.org>; Fri,  7 Aug 2026 05:50:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1786081858; cv=none; b=b4+0fLQKt96eQlYjklQnHujcCowdXlJ6AdLEbzH67RK62ufMYsF4v8+5z7fn083Ubeywj7i+mQfgkwohqON83g202sLi/nEP366OFLeHiLJmI9OEwll57DKWr66uoyKo5Bl5CAIMEfQtcqEYmwG80VPOFWoOsiE24SLYc19Jxw0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1786081858; c=relaxed/simple;
	bh=CTQP0kgdR0I2/+kmokVmx3I4/IDOT6/ZH2SPuGC9uYw=;
	h=From:Subject:To:Cc:In-Reply-To:References:Content-Type:Date:
	 Message-Id; b=jCEtirle6QUJWwmqQE2TLjsGjNkxwyiWxfNHJuirt91MemNpJt3RuiqiwFXNnxK4WkRIDm3v5pre0qj+cnLNMZsaOHJQk0/EJsqDSET4ey+OLbGcvOJPoc72kpuYyXCJOHSTau+4y/d34omMS5cf0raOuHaYMnzY0eNwEvmpOtw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=T7Aw7OBS; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="T7Aw7OBS"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9F05F1F000E9;
	Fri,  7 Aug 2026 05:50:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1786081856;
	bh=+MSOD/A4wS+afgJyC+nLP/kIYv0XjGeQhcSdW9ZVUI8=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=T7Aw7OBSQJTmz9Tv8XlpN5Iu43uVUe+ac/pT359utS8UR2XWnpsCijMv8Q70oTXRk
	 pFEojDCORzgdfQ07ZGJZxLZDz+lGzRcLFfkfEBJyfWNDiJCUwyFlqP8SsMc/yoTGd8
	 sWY6HkyQ8k6HHlkSvFSU2EbL2B/a5KzJccbjBMOE4I5icRW10V9BK7z5ftTRSXKJae
	 M84/P+uFKRbnKyJLab2p+91L3rUKTlbUFjR24ul1iH6EypbeDThvgAqqQjro+Pxi/Q
	 t5/jofVWmpcv305pl9qRcMi+oTqPsG+ZAZTXjO6U67qEH2zOSjsch0BWLbNIXEe6Bh
	 D/sBixIwgHAMA==
From: sashiko-bot@kernel.org
Subject: Re: [PATCH] scsi: arcmsr: fix NULL deref on dma_alloc_coherent()
 failure in arcmsr_alloc_xor_buffer()
Reply-To: sashiko-reviews@lists.linux.dev
To: "Ivy Lopez" <skunkolee@gmail.com>
Cc: linux-scsi@vger.kernel.org
In-Reply-To: <20260807052543.62545-1-skunkolee@gmail.com>
References: <20260807052543.62545-1-skunkolee@gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Fri, 07 Aug 2026 05:50:56 +0000
Message-Id: <20260807055056.9F05F1F000E9@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>

Thank you for your contribution! Sashiko AI review found 2 potential issue(=
s) to consider:

New issues:
- [Medium] The commit message contains a false claim about secondary NULL p=
ointer dereferences, leading to dead code logic (`acb->xor_mega =3D 0;`).

Pre-existing issues:
- [High] Pre-existing massive memory leak of the main CCB pool and IO queue=
s on `arcmsr_alloc_xor_buffer()` failure.
--

--- Patch [1]: [PATCH] scsi: arcmsr: fix NULL deref on dma_alloc_coherent()=
 failure in arcmsr_alloc_xor_buffer() ---
commit afa04c2998e47d9ff0b55725d2cfb10245105508
Author: Ivy Lopez <skunkolee@gmail.com>

scsi: arcmsr: fix NULL deref on dma_alloc_coherent() failure in arcmsr_allo=
c_xor_buffer()

This patch checks the return value of dma_alloc_coherent() in
arcmsr_alloc_xor_buffer() to prevent a NULL pointer dereference. On failure,
it resets acb->xor_mega to 0 and returns -ENOMEM to fail gracefully.

> Additionally, acb->xor_mega is set unconditionally before the
> allocation attempt, based only on firmware status bits. If the
> allocation fails, acb->xor_mega remains nonzero, so the later
> cleanup path in arcmsr_free_ccb_pool() and the message-config code
> in arcmsr_iop_confirm() will still enter their "if (acb->xor_mega)"
> branches and dereference the never-set acb->xorVirt/acb->xorPhys,
> a second NULL pointer dereference on the allocation failure path.

[Severity: Medium]
Is this analysis of the failure path accurate?

If this allocation fails, arcmsr_alloc_ccb_pool() propagates the -ENOMEM
up to arcmsr_probe(). In arcmsr_probe(), an error from arcmsr_alloc_ccb_poo=
l()
triggers a jump to the unmap_pci_region label, which completely bypasses the
free_ccb_pool label.

Because of this bypass, arcmsr_free_ccb_pool() and arcmsr_iop_confirm()
are never reached on this failure path, meaning those secondary NULL pointer
dereferences are structurally impossible.

> diff --git a/drivers/scsi/arcmsr/arcmsr_hba.c b/drivers/scsi/arcmsr/arcms=
r_hba.c
> index 8aa948f06cacf..40407b2818396 100644
> --- a/drivers/scsi/arcmsr/arcmsr_hba.c
> +++ b/drivers/scsi/arcmsr/arcmsr_hba.c
> @@ -771,6 +771,12 @@ static int arcmsr_alloc_xor_buffer(struct AdapterCon=
trolBlock *acb)
>  		(sizeof(struct XorHandle) * acb->xor_mega);
>  	dma_coherent =3D dma_alloc_coherent(&pdev->dev, acb->init2cfg_size,
>  		&dma_coherent_handle, GFP_KERNEL);
> +	if (!dma_coherent) {
> +		pr_info("arcmsr%d: alloc init2cfg buffer failed\n",
> +			acb->host->host_no);
> +		acb->xor_mega =3D 0;

[Severity: Medium]
Since arcmsr_probe() jumps to unmap_pci_region and skips arcmsr_free_ccb_po=
ol()
on failure, is this assignment dead logic? The cleanup path where this flag
would matter cannot be reached on this error path.

> +		return -ENOMEM;

[Severity: High]
This is a pre-existing issue, but does returning here cause a massive DMA
memory leak?

When this returns -ENOMEM, the caller arcmsr_alloc_ccb_pool() propagates
the error to arcmsr_probe() without cleaning up the earlier massive DMA
allocation for acb->dma_coherent (the CCB pool).

arcmsr_probe() then jumps directly to unmap_pci_region:

arcmsr_probe() {
    ...
    error =3D arcmsr_alloc_ccb_pool(acb);
    if(error){
        goto unmap_pci_region;
    }
    ...
}

This bypasses the free_ccb_pool label entirely, so arcmsr_free_ccb_pool()
is never called, leaking up to 12MB of DMA coherent memory.

> +	}
>  	acb->xorVirt =3D dma_coherent;
>  	acb->xorPhys =3D dma_coherent_handle;
>  	pXorPhys =3D (struct Xor_sg *)((unsigned long)dma_coherent +

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20260807052543.6254=
5-1-skunkolee@gmail.com?part=3D1
