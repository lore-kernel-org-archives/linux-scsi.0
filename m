Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AB93D442B21
	for <linux-scsi@vger.kernel.org>; Fri, 28 Aug 2026 11:34:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1787916902; cv=none; b=H8HmGSakTuQn51u2EV37Xzl4FMKDocs6y4MwOsy65X63hw1vpQh1CJPv4+jwS2ng76eMCVm2I/qWTJ4+DrDyjYtvODx2xKsqPjCBVqdl0VYnSyDsLdv6NfbuJAoe7CI/OhX4jGh268+LwcAC3nN0Qo1et4fShs9rkk3PrbIxfjY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1787916902; c=relaxed/simple;
	bh=iJlolzmUukJn+APYXGJfOSkMcsawv3qMzkLvuQoVerI=;
	h=From:Subject:To:Cc:In-Reply-To:References:Content-Type:Date:
	 Message-Id; b=kRYcqxazR2jj/mjE2gCNcUJZeiKbLlXAIsP0dikh7WG+iqvlEQ1x+oMfsQbmf2tupK/aSbs8UzPx+/5knOZpOPc5y1RC0HVCojuppJqwo1eGU6vEtWT7Omc3SwWL/GfRSTiBjDKWJrXX9frVSyJzkaeoD88B61WaLFEV6Rg3+/8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=btvaDX8p; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="btvaDX8p"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 40F421F000E9;
	Fri, 28 Aug 2026 11:34:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1787916890;
	bh=BCgi4x1z9b5C88r8oyHi9+Bo/rYx+kUbei4FuMkRalo=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=btvaDX8pEirK8s2OZWCYi+4b0I+/eC7SjBxS7oH02ygUNG1b4aT8KuFPJv3h8EJei
	 o7cRjcsfuKWt6y9qmTc8M6nPUjw8Uyof4rZ0d7nAYUbC2nL5qPn1Imtc0jZI6d8K7+
	 URPFCmNX09hbMJJO8KNsRLzA+jhrRjAo+avCtQ4gieuxWBDbsmuqQGsHHNfz5KQl2D
	 4RysmJcx1/NJTR/T6Qbd7kccDF8Pit8ev8luPuDEmfvu7rVkTWLRBrlkkj5C1fYvE9
	 jEHbGO7C6Vd6Ks2jZrf4aJX18AtUdMlfubAh3rZxsNA41UA/quFYtrZ9k82+33xPmK
	 fkIxWIhBAz1Zw==
From: sashiko-bot@kernel.org
Subject: Re: [PATCH] scsi: pm8001: fix IRQ leak using wrong index in MSI-X
 error path
Reply-To: sashiko-reviews@lists.linux.dev
To: "Peng Hao" <flyingpenghao@gmail.com>
Cc: linux-scsi@vger.kernel.org
In-Reply-To: <20260828111729.58945-1-flyingpeng@tencent.com>
References: <20260828111729.58945-1-flyingpeng@tencent.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Fri, 28 Aug 2026 11:34:49 +0000
Message-Id: <20260828113450.40F421F000E9@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>

Thank you for your contribution! Sashiko AI review found 4 potential issue(=
s) to consider:

Pre-existing issues:
- [High] IRQ handlers are leaked and leave dangling pointers if initializat=
ion fails after IRQ allocation, leading to Use-After-Free.
- [High] Massive memory and resource leak in `pm8001_pci_probe()` when `pm8=
001_init_ccb_tag()` fails.
- [High] Memory leaks of CCB structures, DMA buffers, and `devices` array i=
n probe error paths.
- [Medium] MSI-X vectors leaked in `pm8001_request_irq()` if falling back t=
o INT-X.
--

commit 90250f8c5a096b2ef2642269b7762aa33f041c4c
Author: Peng Hao <flyingpenghao@gmail.com>

scsi: pm8001: fix IRQ leak using wrong index in MSI-X error path

This commit fixes an IRQ leak in pm8001_request_msix() by using the correct
loop index 'j' instead of 'i' when freeing IRQs on a request_irq() failure.
It ensures successfully requested IRQs are properly freed.

> diff --git a/drivers/scsi/pm8001/pm8001_init.c b/drivers/scsi/pm8001/pm80=
01_init.c
> index e93ea76b565e5..54b35893261a6 100644
> --- a/drivers/scsi/pm8001/pm8001_init.c
> +++ b/drivers/scsi/pm8001/pm8001_init.c
> @@ -1029,8 +1029,8 @@ static u32 pm8001_request_msix(struct pm8001_hba_in=
fo *pm8001_ha)
>  			&(pm8001_ha->irq_vector[i]));
>  		if (rc) {
>  			for (j =3D 0; j < i; j++) {
> -				free_irq(pci_irq_vector(pm8001_ha->pdev, i),
> -					&(pm8001_ha->irq_vector[i]));
> +				free_irq(pci_irq_vector(pm8001_ha->pdev, j),
> +					 &pm8001_ha->irq_vector[j]);
>  			}
>  			pci_free_irq_vectors(pm8001_ha->pdev);
>  			break;

[Severity: High]
This is a pre-existing issue, but does pm8001_alloc() leak IRQ handlers if
a subsequent allocation fails?

In pm8001_alloc(), pm8001_request_irq() successfully registers IRQs. If a
subsequent memory allocation fails, it returns an error:

drivers/scsi/pm8001/pm8001_init.c:pm8001_alloc() {
    ...
    err_out:
        return 1;
}

This prompts pm8001_pci_probe() to jump to failed_pci_alloc and call
pm8001_free():

drivers/scsi/pm8001/pm8001_init.c:pm8001_pci_probe() {
    ...
    err_out_ha_free:
        pm8001_free(pm8001_ha);
    err_out_free:
        kfree(sha);
    ...
}

However, pm8001_free() fails to call pm8001_free_irq():

drivers/scsi/pm8001/pm8001_init.c:pm8001_free() {
    ...
    bitmap_free(pm8001_ha->rsvd_tags);
    kfree(pm8001_ha);
}

Can this lead to a use-after-free if a shared interrupt triggers later and
pm8001_interrupt_handler_intx() dereferences the freed pm8001_ha and sha
structures?

[Severity: High]
This isn't a bug introduced by this patch, but does pm8001_pci_probe() bypa=
ss
cleanup labels when pm8001_init_ccb_tag() fails?

In pm8001_pci_probe(), if pm8001_init_ccb_tag() returns an error:

drivers/scsi/pm8001/pm8001_init.c:pm8001_pci_probe() {
    ...
    rc =3D pm8001_init_ccb_tag(pm8001_ha);
    if (rc)
        goto err_out_enable;
    ...
}

The code jumps directly to err_out_enable, which is below all proper cleanup
labels:

drivers/scsi/pm8001/pm8001_init.c:pm8001_pci_probe() {
    ...
    err_out_enable:
        return rc;
}

Does this cause a permanent resource leak of core driver structures like
pm8001_ha, shost, sha, and mapped PCI regions?

[Severity: High]
This is a pre-existing issue, but does pm8001_init_ccb_tag() leak CCB DMA
buffers on allocation failure?

If dma_alloc_coherent() fails for i > 0, it jumps to err_out:

drivers/scsi/pm8001/pm8001_init.c:pm8001_init_ccb_tag() {
    ...
    if (!pm8001_ha->ccb_info[i].buf_prd) {
        pm8001_dbg(pm8001_ha, FAIL,
                   "ccb prd memory allocation error\n");
        goto err_out;
    }
    ...
}

Will this leak previously allocated buffers since there is no loop to call
dma_free_coherent() on them?

Additionally, if pm8001_init_ccb_tag() succeeds but a later step in
pm8001_pci_probe() fails, the error path calls pm8001_free():

drivers/scsi/pm8001/pm8001_init.c:pm8001_free() {
    ...
    PM8001_CHIP_DISP->chip_iounmap(pm8001_ha);
    flush_workqueue(pm8001_wq);
    bitmap_free(pm8001_ha->rsvd_tags);
    kfree(pm8001_ha);
}

Does pm8001_free() permanently leak the devices array, ccb_info, and CCB DMA
buffers since it omits their teardown logic?

[Severity: Medium]
This isn't a bug introduced by this patch, but does pm8001_request_irq() le=
ak
MSI-X vectors when falling back to INT-X?

If pm8001_setup_msix() successfully allocates vectors, but the subsequent c=
heck
fails:

drivers/scsi/pm8001/pm8001_init.c:pm8001_request_irq() {
    ...
    if (!pdev->msix_cap || !pci_msi_enabled())
        goto use_intx;
    ...
}

Does jumping to use_intx leak the MSI-X setup by not calling
pci_free_irq_vectors() before requesting legacy INT-X interrupts?

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20260828111729.5894=
5-1-flyingpeng@tencent.com?part=3D1
