Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6F3103B19A9
	for <linux-scsi@vger.kernel.org>; Fri,  7 Aug 2026 19:09:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1786129747; cv=none; b=Cs1Q6LOmyIU7mpC6tFIilreNuuCuXOWqcfWrlvLXioiVfZ2La1byys3Dgia7dYmf9/ZOk3rFsucfdMhLvoRsufTNYvC1RrWoND6FniDpjrLNz6plCc/JPo83L/ebiNefZOctEx0BL8vrgCSAoY3DR3cbMbR9sVW1mMftm3c7rLo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1786129747; c=relaxed/simple;
	bh=SxUpSNVgLykssMt98HPn9kMK1EQjc99tG0gLarPfIAQ=;
	h=From:Subject:To:Cc:In-Reply-To:References:Content-Type:Date:
	 Message-Id; b=uYgIg6tcu1bvuBVeTsWpbjLcizFvpwtrCTdBMkIzCizC081M1X/zZmuGDFpuHyZsfxB0tCIeQvxnH/6U+4qHDftXgbG2qY7M3Oit+Ezn9T7v/KNRon2tILHqVmaVZBBekHfYt2fDJgbF8zK9IA1C5vnsqvuACRh1D4o1p7VxlI0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=L7oOO6O1; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="L7oOO6O1"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D352D1F000E9;
	Fri,  7 Aug 2026 19:09:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1786129746;
	bh=2IDP2PAmKOXJfGYKKnZLpVF2sdaFfra6YpbTtWzmduk=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=L7oOO6O16OUEQr/TuBXOGfuu+62TV0pnaseAnen1OERhwBthiy3JEvObVYs/bdMaj
	 1pM7lHnXawpdYfOVdm/w3hCpbhuUBEhsnW6tUDBIP/EC2m9TC3q1uGNkyvXc/MnGN5
	 egCBbMA9NJ5pa+1ciWP1NPnkAAnh5XA/bPeN+i+U7Xf4SjLeFYj77L4CHhei/vMBYY
	 a1k5sEkOQLHTQFTZSWmXSD2guzamJndHMauIpl8G8SvRnxCUNmEr9LOQi6wTocHPwc
	 j84oaWmKSF6WDWRJIBTvjzRjHGpDSi2T7edqPUwBINlwAg572vVCnrGAuSWRcQIkYL
	 N5D5W7e97ALfQ==
From: sashiko-bot@kernel.org
Subject: Re: [PATCH] scsi: arcmsr: fix DMA memory and IO queue leak on
 arcmsr_alloc_ccb_pool() failure
Reply-To: sashiko-reviews@lists.linux.dev
To: "Ivy Lopez" <skunkolee@gmail.com>
Cc: linux-scsi@vger.kernel.org
In-Reply-To: <20260807185018.80661-1-skunkolee@gmail.com>
References: <20260807185018.80661-1-skunkolee@gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Fri, 07 Aug 2026 19:09:05 +0000
Message-Id: <20260807190905.D352D1F000E9@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>

Thank you for your contribution! Sashiko AI review found 2 potential issue(=
s) to consider:

New issues:
- [High] The patch introduces a kernel panic (NULL pointer dereference) in =
`arcmsr_free_ccb_pool()` when cleaning up after an XOR buffer allocation fa=
ilure.

Pre-existing issues:
- [High] A race condition during device removal and probe error teardown le=
aves work queued on the system workqueue after the adapter struct has been =
freed, causing a use-after-free.
--

--- Patch [1]: [PATCH] scsi: arcmsr: fix DMA memory and IO queue leak on ar=
cmsr_alloc_ccb_pool() failure ---
commit 54e963f4d0ddf2b670ba41920062308c1b96d75e
Author: Ivy Lopez <skunkolee@gmail.com>

scsi: arcmsr: fix DMA memory and IO queue leak on arcmsr_alloc_ccb_pool() f=
ailure

This commit fixes a DMA memory and IO queue leak that occurs when
arcmsr_alloc_ccb_pool() fails. It routes the error path through the
free_ccb_pool label and explicitly frees the IO queue for type F adapters.

> diff --git a/drivers/scsi/arcmsr/arcmsr_hba.c b/drivers/scsi/arcmsr/arcms=
r_hba.c
> index 8aa948f06cacf..3ffd160a6a550 100644
> --- a/drivers/scsi/arcmsr/arcmsr_hba.c
> +++ b/drivers/scsi/arcmsr/arcmsr_hba.c
> @@ -1144,7 +1144,9 @@ static int arcmsr_probe(struct pci_dev *pdev, const=
 struct pci_device_id *id)
>  		arcmsr_free_io_queue(acb);
>  	error =3D arcmsr_alloc_ccb_pool(acb);
>  	if(error){
> -		goto unmap_pci_region;
> +		if (acb->adapter_type =3D=3D ACB_ADAPTER_TYPE_F)
> +			arcmsr_free_io_queue(acb);
> +		goto free_ccb_pool;

[Severity: High]
Does this routing of the error path to free_ccb_pool introduce a kernel
panic if arcmsr_alloc_ccb_pool() fails during XOR buffer allocation?

If arcmsr_alloc_xor_buffer() fails, acb->xor_mega is already set to a
non-zero value, but acb->xorVirt might be NULL.

When arcmsr_free_ccb_pool() is called from this new error path, it checks
acb->xor_mega and proceeds to calculate a pointer using the NULL
acb->xorVirt:

drivers/scsi/arcmsr/arcmsr_hba.c:arcmsr_free_ccb_pool() {
    ...
    if (acb->xor_mega) {
        struct Xor_sg *pXorPhys;
        ...
        pXorPhys =3D (struct Xor_sg *)(acb->xorVirt + sizeof(struct HostRam=
Buf));
        ...
        if (pXorPhys->xorPhys) {
    ...
}

Will this unconditionally dereference the invalid pXorPhys pointer
(address 16) and cause a panic?

[Severity: High]
This is a pre-existing issue, but does the error teardown sequence leave a
window for a use-after-free?

In the arcmsr_probe() error path, flush_work() is called before the hardware
interrupt is freed:

drivers/scsi/arcmsr/arcmsr_hba.c:arcmsr_probe() {
out_free_sysfs:
    ...
    flush_work(&acb->arcmsr_do_message_isr_bh);
    arcmsr_stop_adapter_bgrb(acb);
    arcmsr_flush_adapter_cache(acb);
    arcmsr_free_irq(pdev, acb);
    ...
}

Because the interrupt is still active, could it fire and re-queue
arcmsr_do_message_isr_bh after the flush? When scsi_host_put() subsequently
frees the acb structure, would the system workqueue then dereference the
freed memory?

>  	}
>  	error =3D scsi_add_host(host, &pdev->dev);
>  	if(error){

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20260807185018.8066=
1-1-skunkolee@gmail.com?part=3D1
