Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A1C681A6800
	for <linux-scsi@vger.kernel.org>; Sun,  9 Aug 2026 03:48:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1786247284; cv=none; b=n9e0VnJQnCb/hI5ZzeSowuh90pj2yo6ZU4ivH30r2XaNDeJnoqfzog9jjO6wVcjex3XOLFZcojccQ5dOCUIYUa1IktC9oumSOi4yLaWa3HLOqzxMmOzdtE8JvcY5f0uycnFNbhpSezfkfZ34WjkB+vkJjDucrlp5DUVUKGrYpi0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1786247284; c=relaxed/simple;
	bh=/Dv1MbBEVaRc0BBw/5KgrBfKG9hKeVVfVApyxIigQ34=;
	h=From:Subject:To:Cc:In-Reply-To:References:Content-Type:Date:
	 Message-Id; b=DAjgUEhTALjYjb54nUtAwa/lnl1nqh6v3hy8FHNgmYeMKKym5hTzxZkt8kTqvqnXfevlMYTrwXawAxLhFD0HC7PNx7yUPAg2N8XqJmVJUT3ZZe2uedZwkQuN2UTG2idwlDD2mLxmTath7gqiIpj/6+1D/McVi9F6LJdv8lNOlfc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=bp2qjJrJ; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="bp2qjJrJ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 058D01F000E9;
	Sun,  9 Aug 2026 03:48:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1786247283;
	bh=vTLur1bKGGjJ7RpzjxCmnc+UbcZquxFhnCxoduk/RbQ=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=bp2qjJrJ3/7odxZ/YrnFs87O9KP1tj5IvNYLDeG4IYCvtAB1kjdNZ719TBMk/yQjf
	 u/UkFd5tD2RfGtSdq3Jo7xgFkNHHc2x4KZCTDhkpJPq5d8oKsS8ccJpLLn4CogBSyD
	 ymeaEsNcrLyoqkXr57Dq9mYtkuJLPjGGnajey+nSLbROjl9wFeDHRa0roaryywcvxH
	 yOWnVtbj892z0fh/q7FIme5o7lgBoZWwIDCsNpnHGM9FZNW32Hqd2drXD8QDXw/u1z
	 iGN0Jz4VsvymdIviqxNO39Zp0Df2ufcc08tsHLWuVQthEQJX3QNWVbuYrNxosB8rEC
	 q4IDcwpOln2ZA==
From: sashiko-bot@kernel.org
Subject: Re: [PATCH] scsi: aacraid: fix DMA mapping leak in
 aac_send_raw_srb()
Reply-To: sashiko-reviews@lists.linux.dev
To: "Ivy Lopez" <skunkolee@gmail.com>
Cc: linux-scsi@vger.kernel.org
In-Reply-To: <20260809033449.286233-1-skunkolee@gmail.com>
References: <20260809033449.286233-1-skunkolee@gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Sun, 09 Aug 2026 03:48:02 +0000
Message-Id: <20260809034803.058D01F000E9@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>

Thank you for your contribution! Sashiko AI review found 7 potential issue(=
s) to consider:

New issues:
- [High] DMA buffers are read by the CPU before they are unmapped, causing =
stale data to be copied to user space on non-coherent architectures.
- [Medium] The driver uses 0 as a sentinel value to track unmapped DMA addr=
esses, permanently leaking valid mappings at address 0.

Pre-existing issues:
- [High] The driver does not check the return value of `dma_map_single()`, =
causing invalid error addresses to be improperly unmapped.
- [High] Permanent leak of heap memory and DMA mappings when the operation =
is interrupted by a signal.
- [High] Uninitialized stack variables are passed to `copy_to_user()` when =
`sg.count =3D=3D 0`.
- [High] The driver leaks uninitialized kernel heap memory to user space wh=
en the hardware transfers less data than requested.
- [High] Use-After-Free in sync_mode when `wait_for_completion_interruptibl=
e` is interrupted by a signal.
--

--- Patch [1]: [PATCH] scsi: aacraid: fix DMA mapping leak in aac_send_raw_=
srb() ---
commit 863e921c48579ca39e3e4f977e819659b4711e60
Author: Ivy Lopez <skunkolee@gmail.com>

scsi: aacraid: fix DMA mapping leak in aac_send_raw_srb()

aac_send_raw_srb() maps each scatter/gather entry for DMA via
dma_map_single() across five separate code paths, depending on the
adapter type and SG format. This commit introduces tracking for DMA
addresses in a new sg_addr[] array and unmaps them in the cleanup
path to prevent permanent resource exhaustion.

Link: https://bugzilla.kernel.org/show_bug.cgi?id=3D220504

> diff --git a/drivers/scsi/aacraid/commctrl.c b/drivers/scsi/aacraid/commc=
trl.c
> index bd82aeb679aed..d4dffd6f8af0b 100644
> --- a/drivers/scsi/aacraid/commctrl.c
> +++ b/drivers/scsi/aacraid/commctrl.c
> @@ -492,6 +492,7 @@ static int aac_send_raw_srb(struct aac_dev* dev, void=
 __user * arg)
>  	u32 data_dir;
>  	void __user *sg_user[HBA_MAX_SG_EMBEDDED];
>  	void *sg_list[HBA_MAX_SG_EMBEDDED];
> +	dma_addr_t sg_addr[HBA_MAX_SG_EMBEDDED];
>  	u32 sg_count[HBA_MAX_SG_EMBEDDED];
>  	u32 sg_indx =3D 0;
[ ... ]
> @@ -517,6 +518,7 @@ static int aac_send_raw_srb(struct aac_dev* dev, void=
 __user * arg)
>  	}
> =20
>  	memset(sg_list, 0, sizeof(sg_list)); /* cleanup may take issue */
> +	memset(sg_addr, 0, sizeof(sg_addr)); /* mark all entries unmapped */

[Severity: Medium]
Is it safe to use 0 as a sentinel value here?

On many platforms and IOMMUs, 0 is a valid DMA address. If dma_map_single()
successfully returns 0, the cleanup loop's check of if (sg_addr[i]) will
evaluate to false, skipping dma_unmap_single() and leaking that mapping.

>  	if(copy_from_user(&fibsize, &user_srb->count,sizeof(u32))){
[ ... ]
> @@ -690,6 +692,7 @@ static int aac_send_raw_srb(struct aac_dev* dev, void=
 __user * arg)
>  			}
>  			addr =3D dma_map_single(&dev->pdev->dev, p, sg_count[i],
>  					      data_dir);
> +			sg_addr[i] =3D addr;

[Severity: High]
This is a pre-existing issue, but does this code properly validate the DMA
mapping?

If dma_map_single() fails (e.g., due to IOMMU space exhaustion), it typical=
ly
returns an error address. Since this is never checked using
dma_mapping_error(), this non-zero error address is saved and later passed
directly to dma_unmap_single() during cleanup.

>  			hbacmd->sge[i].addr_hi =3D cpu_to_le32((u32)(addr>>32));
[ ... ]
> @@ -986,8 +989,12 @@ static int aac_send_raw_srb(struct aac_dev* dev, voi=
d __user * arg)

[Severity: High]
This is a pre-existing issue, but does aac_send_raw_srb() leak uninitialized
kernel heap memory to user space before reaching the cleanup path?

The scatter-gather buffers are allocated via kmalloc() without __GFP_ZERO.
These buffers may remain uninitialized if SRB_DataOut is not set. If the
hardware completes the command but transfers less data than requested, the
subsequent copy_to_user() will unconditionally copy the remaining
uninitialized bytes to user space.

[Severity: High]
This is also a pre-existing issue, but if sg.count is 0 and flags & SRB_Dat=
aIn
is set, does the copy loop read uninitialized stack memory?

When sg.count is 0, the buffer allocation loops are skipped, leaving sg_indx
as 0, and both the sg_user and sg_count arrays uninitialized. Because the
copy loop right before this cleanup block iterates with i <=3D sg_indx, it
executes once for i=3D0 and calls copy_to_user() with stack garbage.

>  cleanup:
>  	kfree(user_srbcmd);
>  	if (rcode !=3D -ERESTARTSYS) {

[Severity: High]
This is a pre-existing issue, but does skipping this block on -ERESTARTSYS
cause a permanent memory and DMA mapping leak?

Since sg_list and sg_addr are local stack variables, they are destroyed
when the function returns. If aac_fib_send() is interrupted by a signal,
the memory and mappings are left stranded with no way to free them when
the hardware eventually completes the command.

> -		for (i =3D 0; i <=3D sg_indx; i++)
> +		for (i =3D 0; i <=3D sg_indx; i++) {
> +			if (sg_addr[i])
> +				dma_unmap_single(&dev->pdev->dev, sg_addr[i],
> +						 sg_count[i], data_dir);

[Severity: High]
Can this result in stale data being copied to user space on non-coherent
architectures?

The CPU reads from the DMA buffers earlier during copy_to_user(). Because
dma_unmap_single() performs cache invalidation on non-coherent architecture=
s,
placing it here in the cleanup block means it executes after the CPU has
already read the data, returning stale data to user space.

>  			kfree(sg_list[i]);
> +		}
>  		aac_fib_complete(srbfib);
>  		aac_fib_free(srbfib);

[Severity: High]
This is a pre-existing issue, but is there a use-after-free risk here if
aac_fib_send() operates in sync_mode and is interrupted by a signal?

If wait_for_completion_interruptible() returns -EFAULT on a signal, rcode
won't equal -ERESTARTSYS, causing aac_fib_free() to run here. However,
dev->sync_fib might still point to this freed fib, which
aac_src_intr_message() could later attempt to access when the hardware
completes the synchronous command.

>  	}

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20260809033449.2862=
33-1-skunkolee@gmail.com?part=3D1
