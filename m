Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B96BB415F2D
	for <linux-scsi@vger.kernel.org>; Thu,  6 Aug 2026 21:18:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1786051119; cv=none; b=jobEbaAfQja+ayIsqJ1N0g8wNHPlgZzMbKsdqyN/VSW5prfeN3r5MDVVnXx8k6nOBJX7jrNjvmGhrSGWN72708h7lO5dPHTCVUr4mdk9ryA7ZoEgMxNoigbee1mx5SrQQrmZFyQQNMu3Dsaj+UNduYVHFeN63EA5RCKclSkqCKU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1786051119; c=relaxed/simple;
	bh=ekOzcVVHcVslI8xxP2KlxTUONRiZbQI0/W2XgyCk8dY=;
	h=From:Subject:To:Cc:In-Reply-To:References:Content-Type:Date:
	 Message-Id; b=beeGSm2addJm0Mk/pqlKReh5KPFb/34bUB88MHqQZJLGWpYO/6qCUeKaU0tpybGTrmJwUdpiuXC+UT6RR7ZF1TXkDdQkuzXafsYxQIUzy15wGUZ4D89V62X4vVp2PFsiV71kIAPanuRfW+vhoOHfAskcNu4z3HS35IKOPw9qcJ0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=RgueohKE; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="RgueohKE"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4B1671F000E9;
	Thu,  6 Aug 2026 21:18:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1786051117;
	bh=2QSkCIrrInxVYZcQ6xI2xBgqD/5mBo/YboTvndo/n0c=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=RgueohKE8FOGI3y/b5ywGXfcv80INYbTMd+r6zhGo7leBG87njOLMy18PMguJBgl1
	 9LpK//kSkuu9VjqpMYax+Gvn0H2pZaEggJ/B/Gi/MDWk3srLUy0pRrBZ6DQDAmUwVE
	 r4GJiSyLoNIJnJ8N5p+uIf4EOBUY5W3kVIXJgwQPEIqoSQDqbyb5nsAQNi1wmiOTlq
	 JWsrHzS3znoZMWaLmjjCHofQgyi6jCT003DyF3GrxMHsqx3P9K47/SnTqPwrKowmjD
	 rcjG6n5M12oQEElK3Y1plAWNbqGctALKbBPosDjXtfcxuLuiAeB3Mk2VFPZYOVXgei
	 OSlbxtnWkrE1g==
From: sashiko-bot@kernel.org
Subject: Re: [PATCH v3 1/2] scsi: elx: efct: free the RQ buffers already
 allocated when one fails
Reply-To: sashiko-reviews@lists.linux.dev
To: "Ali Ahmet Memis" <ali@iusegentoo.com>
Cc: linux-scsi@vger.kernel.org
In-Reply-To: <20260806210631.357456-2-ali@iusegentoo.com>
References: <20260806210631.357456-1-ali@iusegentoo.com>
 <20260806210631.357456-2-ali@iusegentoo.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Thu, 06 Aug 2026 21:18:36 +0000
Message-Id: <20260806211837.4B1671F000E9@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>

Thank you for your contribution! Sashiko AI review found 3 potential issue(=
s) to consider:

Pre-existing issues:
- [High] Internal memory leak in `efct_hw_rx_allocate` on partial allocatio=
n failure.
- [High] Massive resource leaks on hardware setup and probe failure paths d=
ue to missing teardown.
- [Medium] Dangling pointer in `efct_hw_rx_post` error path after freeing `=
hw->seq_pool`.
--

--- Patch [1]: [PATCH v3 1/2] scsi: elx: efct: free the RQ buffers already =
allocated when one fails ---
commit 4b765f42513cfc306a047983d0027b54fc865497
Author: Ali Ahmet Memis <ali@iusegentoo.com>

scsi: elx: efct: free the RQ buffers already allocated when one fails

This commit fixes a memory leak in efct_hw_rx_buffer_alloc. When the DMA
allocation for an entry fails, the function now properly uses
efct_hw_rx_buffer_free to unmap previously allocated buffers and free the
array before returning NULL.

> diff --git a/drivers/scsi/elx/efct/efct_hw.c b/drivers/scsi/elx/efct/efct=
_hw.c
> index b79c6a7ea7912..cc600220168a6 100644
> --- a/drivers/scsi/elx/efct/efct_hw.c
> +++ b/drivers/scsi/elx/efct/efct_hw.c

[ ... ]

> @@ -1196,7 +1200,7 @@ efct_hw_rx_buffer_alloc(struct efct_hw *hw, u32 rqi=
ndex, u32 count,
>  						   GFP_KERNEL);
>  		if (!prq->dma.virt) {
>  			efc_log_err(hw->os, "DMA allocation failed\n");
> -			kfree(rq_buf);
> +			efct_hw_rx_buffer_free(hw, rq_buf, i);
>  			return NULL;
>  		}
>  	}

[Severity: High]
This is a pre-existing issue, but looking at how efct_hw_rx_buffer_alloc is
called, is there a similar leak in efct_hw_rx_allocate?

If efct_hw_rx_buffer_alloc fails when allocating rq->payload_buf:

drivers/scsi/elx/efct/efct_hw.c:efct_hw_rx_allocate() {
    ...
    if (!rq->payload_buf) {
        efc_log_err(efct, "rx_buffer_alloc fb_buf failed\n");
        rc =3D -EIO;
        break;
    }
    ...
}

Does this break out of the loop without freeing the rq->hdr_buf that was
successfully allocated in the same iteration, leaving it permanently leaked?

[Severity: High]
This is also a pre-existing issue, but does the hardware setup and probe
failure path leak resources by missing a teardown call?

For example, if efct_hw_init fails during IO allocation:

drivers/scsi/elx/efct/efct_hw.c:efct_hw_init() {
    ...
    rc =3D efct_hw_setup_io(hw);
    if (rc) {
        efc_log_err(hw->os, "IO allocation failure\n");
        return rc;
    }
    ...
}

Or if efct_hw_setup fails after allocating the command context pool:

drivers/scsi/elx/efct/efct_hw.c:efct_hw_setup() {
    ...
    hw->mbox_rqst_pool =3D mempool_create_kmalloc_pool(EFCT_CMD_CTX_POOL_SZ,
                                         sizeof(struct efct_mbox_rqst_ctx));
    if (!hw->mbox_rqst_pool) {
        efc_log_err(hw->os, "failed to allocate mbox request pool\n");
        return -EIO;
    }
    ...
}

And when efct_pci_probe handles failure, it jumps to attach_out:

drivers/scsi/elx/efct/efct_driver.c:efct_pci_probe() {
    ...
attach_out:
    efct_teardown_msix(efct);
dma_mask_out:
    ...
}

Do these error paths bypass unwinding local allocations and skip calling
efct_hw_teardown, resulting in a leak of the initialized hardware structure=
s?

[Severity: Medium]
This is another pre-existing issue, but could this lead to a dangling point=
er
risk in efct_hw_rx_post?

If sequence buffer posting fails, the sequence pool is freed:

drivers/scsi/elx/efct/efct_hw.c:efct_hw_rx_post() {
    ...
    if (rc && hw->seq_pool)
        kfree(hw->seq_pool);

    return rc;
}

Should hw->seq_pool be set to NULL here? While an immediate double-free mig=
ht
not occur if efct_hw_teardown is skipped on error paths, fixing the teardown
behavior could trigger a double-free when efct_hw_teardown unconditionally
calls kfree(hw->seq_pool) later.

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20260806210631.3574=
56-1-ali@iusegentoo.com?part=3D1
