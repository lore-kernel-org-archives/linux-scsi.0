Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 405A03D3339
	for <linux-scsi@vger.kernel.org>; Tue,  7 Jul 2026 07:11:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1783408310; cv=none; b=WHPil9eakHGHNsg82Y/sWZyBm/sDr5emA65lCuVaziEdTlUDAL1f8gIiCyRa4MqdHTBLHzPkl5qF6fb/9Rb3klfqbSG5jooOmwyPS722oKQ6z2WAJ1XrI396m6bjooI2WjdudnXhGOZGi4ALymt2aufm9rVapARNF2pNr/JGQW4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1783408310; c=relaxed/simple;
	bh=cK5cYBVKEW+fpU7pjqUdjJvsqT0lX2MmqX2LAe9qrpA=;
	h=From:Subject:To:Cc:In-Reply-To:References:Content-Type:Date:
	 Message-Id; b=g22vG2RBO2vE8kJD7EagbX3qMPAzh5ObrDS5R5bXKneFgd7SavnHabOJ4WqH9rs8ynfX9rXx+ujb59bo9muByRaJFrN1E6YkWAKxd751Xd6w6p4wRzsKWjeBpTw30RiYSmakUiDV7BpnS4hlt+GBvf4wDgrYbGfXrupg/W3PsTw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=Cc9gq0/K; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="Cc9gq0/K"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 700841F000E9;
	Tue,  7 Jul 2026 07:11:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1783408306;
	bh=Vp6e77oOpNcZsRlRkXC7w5vHjyryCB7Bod5MWS3n5ZI=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=Cc9gq0/K1OBAUAMQ45PerOgbEX/h2GhlqKAMmxXXn7BxWbl4epnGVrkfm5zTfSAwi
	 aWu+WY64nTp649Yhj3VzDDuBXHY1XPREU//Kr8eHRifkvAwPtMP7JU/iYL7GYiQvJg
	 4968KnwaX3G2HsVV3OuRKKTjNdMDk9YmLaAvivEqGuux3Xk1xElgxbkiqgZJM2zsG6
	 dH1NQkBSYA2NMwfpCpmhU/hSZPwV7QtgNdVgwU0qfRwnCKDqp0xKSY+juObRWyR43p
	 NDwI/cvZcWJGIxx/6cNWB/2LvIcySzh5wV/x/olympw4ev4Hb+DfU8oFEC2UTS6iuc
	 O+0/H7Gh0Qtbw==
From: sashiko-bot@kernel.org
Subject: Re: [PATCH v3 61/88] scsi: qla2xxx: Fix cs84xx use-after-free on
 host teardown
Reply-To: sashiko-reviews@lists.linux.dev
To: "Nilesh Javali" <njavali@marvell.com>
Cc: linux-scsi@vger.kernel.org
In-Reply-To: <20260707055435.2680300-62-njavali@marvell.com>
References: <20260707055435.2680300-1-njavali@marvell.com>
 <20260707055435.2680300-62-njavali@marvell.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Tue, 07 Jul 2026 07:11:45 +0000
Message-Id: <20260707071145.700841F000E9@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>

Thank you for your contribution! Sashiko AI review found 3 potential issue(=
s) to consider:

Pre-existing issues:
- [High] Use-After-Free of `ha->cs84xx` in ISR during device teardown due t=
o dangling pointer.
- [High] Massive resource leaks and Use-After-Free of `ha` due to bypassed =
teardown logic when a PCI error occurs.
- [Medium] Reference count and memory leak of `ha->cs84xx` when `qla2x00_pr=
obe_one()` fails.
--

--- Patch [61]: [PATCH v3 61/88] scsi: qla2xxx: Fix cs84xx use-after-free o=
n host teardown ---
commit 38a63280418c73c296cf766449f8dec71bf6e908
Author: Nilesh Javali <njavali@marvell.com>

scsi: qla2xxx: Fix cs84xx use-after-free on host teardown
   =20
This commit moves qla84xx_put_chip() to after scsi_remove_host() in the
teardown paths to prevent a sysfs-triggered use-after-free on ha->cs84xx.
By doing this, it ensures that the host sysfs attributes are removed and
in-flight readers are drained before the cs84xx structure is freed.

> diff --git a/drivers/scsi/qla2xxx/qla_os.c b/drivers/scsi/qla2xxx/qla_os.c
> index 62c9bd0fe06df..4f485e4acf4a2 100644
> --- a/drivers/scsi/qla2xxx/qla_os.c
> +++ b/drivers/scsi/qla2xxx/qla_os.c
> @@ -4074,6 +4072,8 @@ qla2x00_remove_one(struct pci_dev *pdev)
> =20
>  	scsi_remove_host(base_vha->host);
> =20
> +	qla84xx_put_chip(base_vha);
> +

[Severity: High]
This is a pre-existing issue, but does freeing the cs84xx structure here
still leave a window for a use-after-free during an interrupt?

Looking at the teardown sequence, qla84xx_put_chip() drops the reference
and frees ha->cs84xx without setting the pointer to NULL.

Shortly after this, qla2x00_free_device() disables hardware interrupts
by calling ha->isp_ops->disable_intrs(ha).

Before those interrupts are disabled, could a concurrent MBA_ISP84XX_ALERT
event trigger the qla2x00_async_event() interrupt handler?

drivers/scsi/qla2xxx/qla_isr.c:qla2x00_async_event() {
    ...
    case MBA_ISP84XX_ALERT:
        ...
        spin_lock_irqsave(&ha->cs84xx->access_lock, flags);
    ...
}

Would this result in dereferencing the freed ha->cs84xx memory?

>  	qla2x00_free_device(base_vha);
> =20
>  	qla2x00_clear_drv_active(ha);

[ ... ]

> @@ -7014,6 +7012,8 @@ qla2x00_disable_board_on_pci_error(struct work_stru=
ct *work)
> =20
>  	scsi_remove_host(base_vha->host);
> =20
> +	qla84xx_put_chip(base_vha);
> +

[Severity: High]
This isn't a bug introduced by this patch, but does the PCI error handler
bypass teardown logic and leak resources?

In qla2x00_disable_board_on_pci_error(), the teardown skips destroying
the workqueue ha->wq and freeing DMA buffers like ha->exlogin_buf.

It then calls pci_disable_device(), which sets pdev->enable_cnt to 0.

When qla2x00_remove_one() later executes, it hits the early return path
because the count was cleared:

drivers/scsi/qla2xxx/qla_os.c:qla2x00_remove_one() {
    ...
    if (!atomic_read(&pdev->enable_cnt)) {
        dma_free_coherent(&ha->pdev->dev, base_vha->gnl.size,
            base_vha->gnl.l, base_vha->gnl.ldma);
        base_vha->gnl.l =3D NULL;
        scsi_host_put(base_vha->host);
        kfree(ha);
        pci_set_drvdata(pdev, NULL);
        return;
    }
    ...
}

This early return frees the ha structure while skipping the rest of the
teardown.

Since ha->wq is never destroyed, does this leak memory?

Also, if any background work items are still scheduled on ha->wq, will they
execute post-free and dereference the deallocated ha structure?

[Severity: Medium]
This is a pre-existing issue, but does the probe error path leak the
ha->cs84xx reference?

During initialization, qla2x00_initialize_adapter() acquires the chip:

drivers/scsi/qla2xxx/qla_init.c:qla2x00_initialize_adapter() {
    ...
    ha->cs84xx =3D qla84xx_get_chip(vha);
    ...
    if (qla_ini_mode_enabled(vha) || qla_dual_mode_enabled(vha))
        rval =3D qla2x00_init_rings(vha);

    if (rval !=3D QLA_SUCCESS)
        return rval;
    ...
}

If qla2x00_init_rings() fails, the function returns without dropping
the acquired reference.

Additionally, if qla2x00_initialize_adapter() succeeds but a later step
in qla2x00_probe_one() fails, the driver jumps to the probe_failed label.

The probe_failed path does not call qla84xx_put_chip() to release the
reference either.

Will this result in the allocated chip remaining stuck in qla_cs84xx_list
permanently?

>  	base_vha->flags.init_done =3D 0;
>  	qla25xx_delete_queues(base_vha);
>  	qla2x00_free_fcports(base_vha);

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20260707055435.2680=
300-1-njavali@marvell.com?part=3D61
