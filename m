Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0970D494829
	for <linux-scsi@vger.kernel.org>; Thu,  6 Aug 2026 19:41:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1786045306; cv=none; b=G47RF8pD8lbiyysIMa+Ujq+aOI6Prx37xbrySwo6D9Kv9RoVIT9CkJySN+FFThGKOgeF8B2vOlDTPPSYpHZu0oODL7bU6Tv6urnYWrBtdnsMcXIkdm1mio3MKj2oYF90OT0eziFh+z/ENIp7LNp/aVbvyBTYKmKhyE5pM6CS2mA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1786045306; c=relaxed/simple;
	bh=rxqZGWk3puWYbgM9MrWkSdVU3axm6O7hsP07lZNuXto=;
	h=From:Subject:To:Cc:In-Reply-To:References:Content-Type:Date:
	 Message-Id; b=OPFTzHgHhq/AIImrx1LSCRladGb2LeTWscpq3ponY0cVRH//hhJ5WB0dcc13bwskYkR4hwQGol/e6P2mnjaDmImQZLSQAtrNfIiDYJRLH7ZGj29HzryW6tI8noNzjsSigZMc9CqBgirq0FBHIh3uxad3pcGGlRTq6FAIehPtaq0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=OKSck9n+; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="OKSck9n+"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5A9661F000E9;
	Thu,  6 Aug 2026 19:41:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1786045304;
	bh=YQ9y+85Ftt5NvUg0MC1PuHF06CZ8VgRTO/e23nYuRB4=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=OKSck9n+UodB7F5VqyPbuEyWiqQf1u5QdQjNuUnV6R/nJgaJ0KP185Rrfy4h2sqy/
	 sB7CiuGeIdR10aZNT+UWfedG1RJK6s0BaO07yI9iCd6nCDGkOG7kyZo56D7HWEv8H1
	 IFOINJUy246DNhRTyyZzCjS8+szsd84EOZ7WQQ5rkXichyJ3vVKXOvk9AvydikWtGl
	 d1lEo9giSkBcO4S263xmRw9jgMzkv8sK8Rb7DQxzsKyAXZ6YR+8tUBqo5JL27+Zyb1
	 n283Nfvzi+gwk9+XPjBxd43Zwl5P2As2lTdvPMgfhwVLZAATwpa98mKlf44OWlkARb
	 SuJ3Zq8aoVecw==
From: sashiko-bot@kernel.org
Subject: Re: [PATCH 5/5] scsi: elx: efct: destroy the mailbox pools when
 setup fails
Reply-To: sashiko-reviews@lists.linux.dev
To: "Ali Ahmet Memis" <ali@iusegentoo.com>
Cc: linux-scsi@vger.kernel.org
In-Reply-To: <20260806192345.328621-6-ali@iusegentoo.com>
References: <20260806192345.328621-1-ali@iusegentoo.com>
 <20260806192345.328621-6-ali@iusegentoo.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Thu, 06 Aug 2026 19:41:43 +0000
Message-Id: <20260806194144.5A9661F000E9@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>

Thank you for your contribution! Sashiko AI review found 5 potential issue(=
s) to consider:

New issues:
- [Medium] The patch misses clearing `hw->hw_setup_called` on the first err=
or path, contradicting the commit message claims.

Pre-existing issues:
- [High] Failing to allocate `wqe_buffs` causes a memory leak of all `hw->i=
o[i]` objects.
- [High] The `sli_setup()` function leaks DMA memory and bitmaps on its int=
ernal error paths.
- [High] Probe failure paths in `efct_pci_probe()` fail to invoke `efct_hw_=
teardown()`, leaking hardware setup allocations.
- [Medium] `efct_hw_parse_filter()` leaks a dynamically allocated string wh=
en provided an empty string.
--

--- Patch [5]: [PATCH 5/5] scsi: elx: efct: destroy the mailbox pools when =
setup fails ---
commit fb169760590ca6bbaa661961e72dbf1d2bbfb5e8
Author: Ali Ahmet Memis <ali@iusegentoo.com>

scsi: elx: efct: destroy the mailbox pools when setup fails

This commit fixes a memory leak in the error paths of efct_hw_setup().
It ensures mempools are properly destroyed and hw_setup_called is cleared
if initialization fails.

> diff --git a/drivers/scsi/elx/efct/efct_hw.c b/drivers/scsi/elx/efct/efct=
_hw.c
> index d645ce256b8aa..efbf29d3386e9 100644
> --- a/drivers/scsi/elx/efct/efct_hw.c
> +++ b/drivers/scsi/elx/efct/efct_hw.c

[ ... ]

>  	/* Create mailbox command ctx pool */
>  	hw->cmd_ctx_pool =3D mempool_create_kmalloc_pool(EFCT_CMD_CTX_POOL_SZ,
>  					sizeof(struct efct_command_ctx));
>  	if (!hw->cmd_ctx_pool) {
>  		efc_log_err(hw->os, "failed to allocate mailbox buffer pool\n");
>  		return -EIO;

[Severity: Medium]
The commit message states that hw_setup_called is cleared on the way out
so that a later call does not take the early return. However, if this first
allocation fails, we return directly without clearing it.

Should this path also jump to a label that clears hw->hw_setup_called to
prevent handing the caller a half-configured hw structure on subsequent
calls?

>  	}
>=20
>  	/* Create mailbox request ctx pool for library callback */
>  	hw->mbox_rqst_pool =3D mempool_create_kmalloc_pool(EFCT_CMD_CTX_POOL_SZ,
>  					sizeof(struct efct_mbox_rqst_ctx));
>  	if (!hw->mbox_rqst_pool) {
>  		efc_log_err(hw->os, "failed to allocate mbox request pool\n");
> -		return -EIO;
> +		goto free_cmd_ctx_pool;
>  	}

[ ... ]

> +free_mbox_rqst_pool:
> +	mempool_destroy(hw->mbox_rqst_pool);
> +	hw->mbox_rqst_pool =3D NULL;
> +free_cmd_ctx_pool:
> +	mempool_destroy(hw->cmd_ctx_pool);
> +	hw->cmd_ctx_pool =3D NULL;
> +	hw->hw_setup_called =3D false;
> +
> +	return -EIO;
>  }

[Severity: High]
This is a pre-existing issue, but does efct_hw_setup_io() leak memory
if the wqe_buffs allocation fails?

drivers/scsi/elx/efct/efct_hw.c:efct_hw_setup_io() {
        ...
        if (!hw->wqe_buffs) {
                kfree(hw->io);
                return -ENOMEM;
        }
        ...
}

The error path frees the hw->io array but appears to fail to free the
individual objects pointed to by the array, leaking them permanently.
Could this be updated to clean up the inner objects?

[Severity: High]
This is a pre-existing issue, but does sli_setup() leak DMA memory on
its internal error paths?

drivers/scsi/elx/libefc_sli/sli4.c:sli_setup() {
        ...
        sli4->bmbx.virt =3D dma_alloc_coherent(&pdev->dev, sli4->bmbx.size,=
 ...);
        ...
        if (sli_request_features(sli4, &sli4->features, true))
                return -EIO;
        ...
}

When sli_setup() fails during subsequent initializations like
sli_request_features(), it returns directly without freeing the DMA memory
allocated earlier for sli4->bmbx.virt and sli4->vpd_data.virt. Since the ca=
ller
efct_hw_setup() has no way to clean up partial allocations, does this perma=
nently
leak DMA memory?

[Severity: High]
This is a pre-existing issue, but do the probe failure paths in
efct_pci_probe() leak the hardware setup allocations?

drivers/scsi/elx/efct/efct_driver.c:efct_pci_probe() {
        ...
attach_out:
        efct_teardown_msix(efct);
dma_mask_out:
        pci_set_drvdata(pdev, NULL);

        for (i =3D 0; i < EFCT_PCI_MAX_REGS; i++) {
                if (efct->reg[i])
                        iounmap(efct->reg[i]);
        }
        efct_device_free(efct);
}

The probe routine invokes efct_hw_setup() which allocates mempools and DMA
memory. If a subsequent step fails, the probe routine branches to attach_out
or dma_mask_out, which calls efct_device_free() but omits calling
efct_hw_teardown(). Does this result in all hardware allocations and
mempools being permanently leaked?

[Severity: Medium]
This is a pre-existing issue, but does efct_hw_parse_filter() leak a
dynamically allocated string when provided an empty string?

drivers/scsi/elx/efct/efct_hw.c:efct_hw_parse_filter() {
        ...
        p =3D kstrdup(value, GFP_KERNEL);
        if (!p || !*p) {
                efc_log_err(hw->os, "p is NULL\n");
                return -ENOMEM;
        }
        ...
}

If value is an empty string, kstrdup() allocates a 1-byte buffer containing
just a null terminator. The subsequent check !*p evaluates to true, and the
function returns -ENOMEM without freeing p. Should this call kfree(p) before
returning?

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20260806192345.3286=
21-1-ali@iusegentoo.com?part=3D5
