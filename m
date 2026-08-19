Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 611B535E925
	for <linux-scsi@vger.kernel.org>; Wed, 19 Aug 2026 01:25:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1787102757; cv=none; b=rgEIbPdXePjcHQjmDZZdeqY0lOAeAYpXSuQx89K3lF/Fc/vSoT86gctUjH8hi3D9jRU0y9mbXvBVyfVGPQcui+ZF64KFhYh8uttL0lRE5Rcm+gGHzM1eCiPEmewviWJSPtuNcM90+UGj7NNry/3qPEsq+2BD+dKk+BlHSYPqUYw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1787102757; c=relaxed/simple;
	bh=m/jG6d/ko8sYIMA7zN9czjC3Dw/zu+L32zSNmxzGghs=;
	h=From:Subject:To:Cc:In-Reply-To:References:Content-Type:Date:
	 Message-Id; b=kcKxqpkSX1m/Zl80IkttxJ53MIePBeAT9D31IMifSLiD8bOKpbbSQ6giOIm5tOnWsg4+50XtIlOivNdzPZO3UPSXZkgyFj02MYDsDiCh0h5BJqf4qDO8OG8OtqLBLTmPZ7csLBCNldzv2oPJ41EGnRqPu4qznu86SHq/Fil+MY8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=W6aYaImy; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="W6aYaImy"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 245851F000E9;
	Wed, 19 Aug 2026 01:25:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1787102755;
	bh=WH4ErY0sIYnoE4K6cRgt03FHDkwKs7M0SF7PMS4qbIM=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=W6aYaImypIuXiGw+ddfd1cwG0kJNFm05uqtibN4QGVwLVk1zIPO+IqflMlZp12C3X
	 OblUv7RQht7Jz6a5uT6v26O74vLmXsn27yYf+sh1PlircPzpvTwXVDc5mM21j2DNC+
	 noCKshNRGrAIH9xB/Sargj2xdPHkXJnhwgr++6w5LqZy4qSmzYi3utyXpE1lWZMdFG
	 4Btv3zqFC9+8UT/tOME7HO1HfCweRhUPDdB1sQsvRUyE044c344Tfaj4H6L6HhFBSj
	 l3V81yku2N55lFouAdqEIxKfa6YwZNLjXsHvPYj6aBJJTr5k5KMp63eKVRV6r7e4Km
	 Ie8spFgeskUpw==
From: sashiko-bot@kernel.org
Subject: Re: [PATCH] scsi: megaraid_sas: kill tasklet after free_irq in
 teardown paths
Reply-To: sashiko-reviews@lists.linux.dev
To: "Fan Wu" <fanwu01@zju.edu.cn>
Cc: linux-scsi@vger.kernel.org
In-Reply-To: <20260819005043.439436-1-fanwu01@zju.edu.cn>
References: <20260819005043.439436-1-fanwu01@zju.edu.cn>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Wed, 19 Aug 2026 01:25:54 +0000
Message-Id: <20260819012555.245851F000E9@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>

Thank you for your contribution! Sashiko AI review found 5 potential issue(=
s) to consider:

Pre-existing issues:
- [Critical] Unprotected concurrent access to the global `megasas_mgmt_info=
` array during device probe and detach causes out-of-bounds writes.
- [High] The error paths in `megasas_resume` fail to disable/destroy IRQs, =
kill the tasklet, and free PCI IRQ vectors, causing a use-after-free.
- [High] Legacy INTx IRQ vectors are systematically leaked in teardown and =
error paths.
- [High] Incomplete tasklet cleanup in initialization error paths allows a =
pending tasklet to execute after the `instance` is freed.
- [High] The asynchronous work item `instance->work_init` is never cancelle=
d during driver teardown, suspend, or probe error paths.
--

--- Patch [1]: [PATCH] scsi: megaraid_sas: kill tasklet after free_irq in t=
eardown paths ---
commit 8d9eb16b77703617161e881af92f251c7fb898af
Author: Fan Wu <fanwu01@zju.edu.cn>

scsi: megaraid_sas: kill tasklet after free_irq in teardown paths

On MFI-series adapters the interrupt handler arms instance->isr_tasklet
for as long as the interrupt is registered, so the tasklet can be armed
again after tasklet_kill() has returned.  This patch moves tasklet_kill()
after megasas_destroy_irqs() to ensure tasklets are stopped after
the handler is drained.

Cc: stable@vger.kernel.org

> diff --git a/drivers/scsi/megaraid/megaraid_sas_base.c b/drivers/scsi/meg=
araid/megaraid_sas_base.c
> index f0152b043e18c..e72009a587567 100644
> --- a/drivers/scsi/megaraid/megaraid_sas_base.c
> +++ b/drivers/scsi/megaraid/megaraid_sas_base.c
> @@ -6536,6 +6536,7 @@ static int megasas_init_fw(struct megasas_instance =
*instance)
>  fail_get_ld_pd_list:
>  	instance->instancet->disable_intr(instance);
>  	megasas_destroy_irqs(instance);
> +	tasklet_kill(&instance->isr_tasklet);
>  fail_init_adapter:

[Severity: High]
This isn't a bug introduced by this patch, but does the jump to
fail_init_adapter leave the tasklet pending if IRQ setup fails?

If megasas_setup_irqs_msix() partially succeeds but fails on a
subsequent vector, it returns an error and the code jumps to
fail_init_adapter, bypassing the tasklet_kill() added here.

Since the rollback loop in megasas_setup_irqs_msix() calls free_irq()
which doesn't kill scheduled tasklets, can the pending tasklet
execute and dereference the freed instance memory?

>  	if (instance->msix_vectors)
>  		pci_free_irq_vectors(instance->pdev);

[Severity: High]
This is a pre-existing issue, but does this conditional check leak
legacy INTx IRQ vectors?

When MSI-X is unavailable, the driver falls back to allocating a
legacy INTx interrupt, but instance->msix_vectors remains 0.
By wrapping pci_free_irq_vectors() in this condition across the
teardown and error paths, it appears the cleanup is skipped for
INTx vectors.

Does this permanently leak IRQ resources in the error paths?

[ ... ]

> @@ -7618,6 +7619,7 @@ static int megasas_probe_one(struct pci_dev *pdev,
> =20
>  	instance->instancet->disable_intr(instance);
>  	megasas_destroy_irqs(instance);
> +	tasklet_kill(&instance->isr_tasklet);

[Severity: High]
This is a pre-existing issue, but do the error paths in megasas_probe_one()
properly clean up interrupts and tasklets before freeing the instance?

If a late step in the probe fails, such as megasas_fusion_start_watchdog(),
the code jumps to fail_init_mfi.  At this point, IRQs have already been
requested and the tasklet initialized.

However, the fail_init_mfi path skips disable_intr, megasas_destroy_irqs,
and tasklet_kill, but proceeds to free the coherent DMA buffers and the
host structure.

Can an active ISR or scheduled tasklet execute after these are freed,
resulting in a use-after-free?

[ ... ]

> @@ -8010,8 +8011,6 @@ static void megasas_detach_one(struct pci_dev *pdev)
>  	/* cancel all wait events */
>  	wake_up_all(&instance->int_cmd_wait_q);
> =20

[Severity: High]
This is a pre-existing issue, but is the asynchronous work item
instance->work_init properly cancelled during detach?

The driver schedules instance->work_init on the global system
workqueue to handle firmware state changes and online controller
resets.  Neither the detach path nor the suspend and probe error
handlers appear to call cancel_work_sync(&instance->work_init).

If a controller fault triggers the work right before teardown,
will the asynchronous work dereference the freed instance memory?

> -	tasklet_kill(&instance->isr_tasklet);
> -
>  	/*
>  	 * Take the instance off the instance array. Note that we will not
>  	 * decrement the max_index. We let this array be sparse array

[Severity: Critical]
This is a pre-existing issue, but does this sparse array management
allow unbounded growth and out-of-bounds writes?

Because megasas_detach_one() intentionally does not decrement
max_index, repeated unbind and bind cycles via sysfs or hotplugs
will cause max_index to grow continuously.

Since there is no bounds checking in megasas_probe_one() when
inserting new instances:

megasas_probe_one() {
        ...
        megasas_mgmt_info.count++;
        megasas_mgmt_info.instance[megasas_mgmt_info.max_index] =3D instanc=
e;
        megasas_mgmt_info.max_index++;
        ...
}

Will max_index eventually exceed MAX_MGMT_ADAPTERS and overwrite
adjacent kernel memory?

> @@ -8028,6 +8027,7 @@ static void megasas_detach_one(struct pci_dev *pdev)
>  	instance->instancet->disable_intr(instance);
> =20
>  	megasas_destroy_irqs(instance);
> +	tasklet_kill(&instance->isr_tasklet);
> =20
>  	if (instance->msix_vectors)
>  		pci_free_irq_vectors(instance->pdev);

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20260819005043.4394=
36-1-fanwu01@zju.edu.cn?part=3D1
