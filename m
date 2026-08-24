Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EF51540B0E2
	for <linux-scsi@vger.kernel.org>; Mon, 24 Aug 2026 11:53:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1787572421; cv=none; b=tRqt5Lp4k/q3xT01Js+HkyST2k11G4yCOPsb1PkqmigdOdMLxedxG4YnNeOnqFuiZkpIsgkYz4dlUZyMFLa1KfWZ7DcJNgHL8EbBvv/dw4gBOXJUy0+MkaHBs1LazMAFOHyGuLvjAozjbgVmY9ZCGiYSgmtNxKF5ZE0fHVptSMA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1787572421; c=relaxed/simple;
	bh=bmIFPXzqPHF0KAx+yIoADW9/sWB9nlQto3GZIjNe/cs=;
	h=From:Subject:To:Cc:In-Reply-To:References:Content-Type:Date:
	 Message-Id; b=QKsd7tRHvdoVAycuyyMHf1C34ePai5tgXjh43ji8+wXin8xNXWu45DePpdyKwubQ2nTWcx2C9ter3ydlWu/1FFPZZVD5JwpKsbsjokXbKEo6EBQzrzooY45w6HU8f4CepEgYIfGh6qqhjCgmS4OGE2fYJK0Jv/ix5b8D2rCjDmY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=FqKdOlvn; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="FqKdOlvn"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 60FF61F000E9;
	Mon, 24 Aug 2026 11:53:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1787572419;
	bh=OwBASN7XpatS5PU76MDLHUvKnwv2jfc0q+nUU/2G1uU=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=FqKdOlvnJ9nYInJyTJzQjXQDOsDumLscyhXs0wq7hZrIcSCxL4NBesP5MVzdhlwpn
	 fwo/dzPnLOIWNjLWnsZG41mvhXQeC6vcFPRGhwMSMs+3msbXoQKqU58NxCDobn4wpy
	 Yldt1mg+jhHFOBVGKtSg8pQSNXusvEAUWphzZiYFuQ5aFkJmpuv17J3eajcfC67dee
	 xCtuc3kCDp7MX4Fa9bCkRmc0ljKcMfGlNHNc6tNKwwJdN0yYhKoNfZkKK2wGOY8/gQ
	 xzlBWMkp7ZKI3rgNyql6Zhe8ILSuIk+jTAYFujHk9rYTlnW4TG5MYG4GDp44yMcamg
	 xJkR5Ls+PoUVg==
From: sashiko-bot@kernel.org
Subject: Re: [PATCH] scsi: pm8001: use rollback index when freeing MSI-X
 vectors
Reply-To: sashiko-reviews@lists.linux.dev
To: "Runyu Xiao" <runyu.xiao@seu.edu.cn>
Cc: linux-scsi@vger.kernel.org
In-Reply-To: <20260824113618.2239100-1-runyu.xiao@seu.edu.cn>
References: <20260824113618.2239100-1-runyu.xiao@seu.edu.cn>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Mon, 24 Aug 2026 11:53:38 +0000
Message-Id: <20260824115339.60FF61F000E9@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>

Thank you for your contribution! Sashiko AI review found 4 potential issue(=
s) to consider:

Pre-existing issues:
- [High] Probe and allocation error paths fail to unregister IRQ handlers, =
kill tasklets, and free PCI IRQ vectors.
- [High] Incorrect error jump label in pm8001_pci_probe() bypasses all clea=
nup.
- [High] Broken fallback to legacy INT-X interrupts when MSI-X vector alloc=
ation fails.
- [Medium] Missing teardown of specific memory allocations (pm8001_ha->devi=
ces, sha->sas_phy, sha->sas_port) in probe error paths.
--

--- Patch [1]: [PATCH] scsi: pm8001: use rollback index when freeing MSI-X =
vectors ---
commit 961717b6ef49f9e3b852de4ab73c7119e69629df
Author: Runyu Xiao <runyu.xiao@seu.edu.cn>

scsi: pm8001: use rollback index when freeing MSI-X vectors

pm8001_request_msix() unwinds previously registered handlers with
free_irq() when request_irq() fails. The rollback loop uses the
failing index i for every iteration instead of the already
registered vector index j. This patch uses j for both
pci_irq_vector() and the matching irq_vector entry in the
rollback loop.

Cc: stable@vger.kernel.org

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
This isn't a bug introduced by this patch, but I noticed that probe and
allocation error paths fail to unregister IRQ handlers, kill tasklets, and
free PCI IRQ vectors.

Looking at pm8001_alloc() in drivers/scsi/pm8001/pm8001_init.c:

	rc =3D pm8001_request_irq(pm8001_ha);
	if (rc)
		goto err_out;
...
err_out:
	return 1;

Does the internal error path here return failure after pm8001_request_irq()
succeeded, bypassing IRQ teardown?

Additionally, the primary teardown function used in probe error paths does
not call pm8001_free_irq(), pm8001_kill_tasklet(), or
pci_free_irq_vectors():

static void pm8001_free(struct pm8001_hba_info *pm8001_ha)
{
...
	PM8001_CHIP_DISP->chip_iounmap(pm8001_ha);
	flush_workqueue(pm8001_wq);
	bitmap_free(pm8001_ha->rsvd_tags);
	kfree(pm8001_ha);
}

When probe error paths invoke pm8001_free() and kfree(sha):

err_out_ha_free:
	pm8001_free(pm8001_ha);
err_out_free:
	kfree(sha);

Doesn't this leave dangling IRQ handlers that still point to these freed
structures?

If probe fails after IRQs are requested, it appears the driver leaks the
IRQ handlers, tasklets, and MSI-X vectors. Furthermore, since the handler's
dev_id pointer (pm8001_ha) is freed by pm8001_free(), could a subsequent
interrupt on the shared line or an unmasked device interrupt cause a kernel
panic when the ISR dereferences pm8001_ha?

[Severity: High]
This is a pre-existing issue and was not introduced by the patch under
review, but I noticed the incorrect error jump label in pm8001_pci_probe()
bypasses all cleanup.

In pm8001_pci_probe():

	rc =3D pm8001_init_ccb_tag(pm8001_ha);
	if (rc)
		goto err_out_enable;
...
err_out_regions:
	pci_release_regions(pdev);
err_out_disable:
	pci_disable_device(pdev);
err_out_enable:
	return rc;

Does this failure path wrongly jump to the end of the function, bypassing
all preceding teardown labels?

If pm8001_init_ccb_tag() fails during probe, the code jumps directly to the
err_out_enable label. This skips all necessary rollback steps, leaking the
Scsi_Host, PCI regions, sas_ha_struct, and pm8001_ha structures, and
leaving the PCI device enabled.

[Severity: Medium]
This isn't a bug introduced by this patch, but there seems to be missing
teardown of specific memory allocations in probe error paths.

In pm8001_free():

static void pm8001_free(struct pm8001_hba_info *pm8001_ha)
{
...
	bitmap_free(pm8001_ha->rsvd_tags);
	kfree(pm8001_ha);
}

Does this function omit kfree(pm8001_ha->devices), unlike its counterpart
pm8001_pci_remove()?

Also, in the probe error path:

err_out_free:
	kfree(sha);

Is it safe for the probe error path to drop the sha structure without
freeing its embedded dynamically allocated arrays (sas_phy and sas_port)?

The structures allocated in pm8001_alloc() (pm8001_ha->devices) and
pm8001_prep_sas_ha_init() (sha->sas_phy and sha->sas_port) are properly
freed during device removal in pm8001_pci_remove(), but seem completely
ignored in the standard probe error paths. Can this lead to memory leaks
on cold paths when initialization fails?

[Severity: High]
This is a pre-existing issue, but I noticed a broken fallback to legacy
INT-X interrupts when MSI-X vector allocation fails.

Looking at pm8001_request_irq():

	if (pm8001_use_msix && pci_find_capability(pdev, PCI_CAP_ID_MSIX)) {
		rc =3D pm8001_setup_msix(pm8001_ha);
		if (rc) {
			pm8001_dbg(pm8001_ha, FAIL,
				   "pm8001_setup_irq failed [ret: %d]\n", rc);
			return rc;
		}

Does this exact block break the fallback logic by unconditionally returning
rather than branching to the use_intx label when allocation fails?

If pm8001_setup_msix() fails, the function immediately returns the error.
This entirely skips the intended fallback to legacy shared interrupts at
the use_intx label. Could this unnecessarily fail to initialize the device
on systems where MSI-X is unavailable?

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20260824113618.2239=
100-1-runyu.xiao@seu.edu.cn?part=3D1
