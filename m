Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D033F49551A;
	Mon, 14 Sep 2026 17:39:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789407591; cv=none; b=Ec4hohnVdfp9QMwhtOjfFOMOR5gpdX2E6kJ/Rl3Bvq9BH6vx+gt3vI8gLlfs5KHTmUszngEC57SpTPKjOrc+/NeVHyLZkeGDkIsUdqVMoJsP+DDEpK5EogjC4VQu3H5gXaBMgXXl7p2Lg//y/0kp842+4kw5uqpYpDOzjbErOP0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789407591; c=relaxed/simple;
	bh=xowSs5X6y2jpvt1cr188yyhw9cv4PZ7/Udl8A89c+Ow=;
	h=From:Subject:To:Cc:In-Reply-To:References:Content-Type:Date:
	 Message-Id; b=iYCCJfSkDTlZDWMDtLSYirWF3HhhjCzRqOGoLrUYr7nwQAU7JRjYBidvBzhgbzTs+kwG+yq6xeOtEeJxuN+JoCvqFYGfV/qihfE/+601E7Z2yss5QTXWItnOOotyjSASfXK9UgUItA/DqoTYsPcwWeZNN86xKZcZOf2vik3xE9E=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=Fq7P+Vba; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="Fq7P+Vba"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 55DB21F000FF;
	Mon, 14 Sep 2026 17:39:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1789407589;
	bh=kGvsKbS+uUAsgVL9R+R9s8xtSlNDiXgGCZNSCC3UYxQ=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=Fq7P+Vbaq+FUxkcYSDw+Br/lIyPdPsmBCkByCCCRnhL/a3rq2mASd5EWlFUDGvd4Q
	 i4AxVMWt0Z9ROq260lRmw+9rttdDcGvg/9ktBTkIkX7tcu6/V6HXVOzYv3LsM9zV9c
	 wMUcuABISg5aJZCsKF4T274WDnCg5coFpxq4D5pLD3hZ7WmDsVHQQ1EuTWfvzhCEdh
	 hQyK8WhJ85Ryfxfa4VEJF3BDALbmafxqo2PLBzz+iyVXlgDbqhbwUr5fRA4AGfG5Iv
	 b+/yhQXU1P8SQzW2s7gQ3BBJ7yNqApeASQPBgJWUs4pg8DhjgBdAJdxweGeXmvjUCZ
	 vydiavCxwVxgQ==
From: sashiko-bot@kernel.org
Subject: Re: [PATCH v2 11/40] infiniband: update hfi1 to use
 remap_vmalloc_range()
Reply-To: sashiko-reviews@lists.linux.dev
To: =?utf-8?b?TG9yZW56byBTdG9ha2VzIChBUk0p?= <ljs@kernel.org>
Cc: "Vasily Gorbik" <gor@linux.ibm.com>, dri-devel@lists.freedesktop.org, "Oliver
 Upton" <oupton@kernel.org>, "Heiko Carstens" <hca@linux.ibm.com>, "Marc
 Zyngier" <maz@kernel.org>, linux-s390@vger.kernel.org, kvm@vger.kernel.org, bpf@vger.kernel.org, "Christian
 Borntraeger" <borntraeger@linux.ibm.com>, linux-rdma@vger.kernel.org, selinux@vger.kernel.org, kvmarm@lists.linux.dev, linux-trace-kernel@vger.kernel.org, linux-scsi@vger.kernel.org, linux-perf-users@vger.kernel.org, "Alexander
 Gordeev" <agordeev@linux.ibm.com>
In-Reply-To: <20260914-b4-mmap-prepare-vma-flag-sanify-v2-11-7d9781ed5361@kernel.org>
References: <20260914-b4-mmap-prepare-vma-flag-sanify-v2-0-7d9781ed5361@kernel.org>
 <20260914-b4-mmap-prepare-vma-flag-sanify-v2-11-7d9781ed5361@kernel.org>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Mon, 14 Sep 2026 17:39:47 +0000
Message-Id: <20260914173948.55DB21F000FF@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>

Thank you for your contribution! Sashiko AI review found 1 potential issue(=
s) to consider:
- [High] The patch breaks mmap for the EVENTS region for all dynamic contex=
ts because remap_vmalloc_range() strictly requires the base address of the =
vmalloc allocation, but the patch passes a pointer with an offset.
--

commit b52cc1703a348bc2ace5ff6752750d7fd8d2282e
Author: Lorenzo Stoakes (ARM) <ljs@kernel.org>

infiniband: update hfi1 to use remap_vmalloc_range()

This commit updates the hfi1 infiniband driver to use remap_vmalloc_range()
for mapping chip memory from vmalloc'd ranges instead of using a custom
fault handler. It aims to prevent exposing kernel virtual addresses and
cleans up VM flags.

> diff --git a/drivers/infiniband/hw/hfi1/file_ops.c b/drivers/infiniband/h=
w/hfi1/file_ops.c
> --- a/drivers/infiniband/hw/hfi1/file_ops.c
> +++ b/drivers/infiniband/hw/hfi1/file_ops.c
> @@ -476,15 +472,10 @@ static int hfi1_file_mmap(struct file *fp, struct v=
m_area_struct *vma)
>  		 * Use the page where this context's flags are. User level
>  		 * knows where it's own bitmap is within the page.
>  		 */
> -		memaddr =3D (unsigned long)
> -			(dd->events + uctxt_offset(uctxt)) & PAGE_MASK;
> +		memvirt =3D dd->events + uctxt_offset(uctxt);
> +		memvirt =3D (void *)(((uintptr_t)memvirt) & PAGE_MASK);
>  		memlen =3D PAGE_SIZE;
> -		/*
> -		 * v3.7 removes VM_RESERVED but the effect is kept by
> -		 * using VM_IO.
> -		 */
> -		flags |=3D VM_IO | VM_DONTEXPAND;
> -		vmf =3D 1;
> +		is_vmalloc =3D 1;
>  		break;
>  	case STATUS:

[ ... ]

> @@ -559,12 +546,10 @@ static int hfi1_file_mmap(struct file *fp, struct v=
m_area_struct *vma)
>  	}
> =20
>  	vm_flags_reset(vma, flags);
> -	mmap_cdbg(ctxt, subctxt, type, mapio, vmf, memaddr, memvirt, memdma,=20
> +	mmap_cdbg(ctxt, subctxt, type, mapio, is_vmalloc, memaddr, memvirt, mem=
dma,
>  		  memlen, vma);
> -	if (vmf) {
> -		vma->vm_pgoff =3D PFN_DOWN(memaddr);
> -		vma->vm_ops =3D &vm_ops;
> -		ret =3D 0;
> +	if (is_vmalloc) {
> +		ret =3D remap_vmalloc_range(vma, memvirt, 0);

[Severity: High]
Will this fail for secondary contexts where uctxt_offset(uctxt) > 0?

When mapping the EVENTS region for any context > 0, memvirt is calculated as
an offset from the vmalloc base address (dd->events). However,
remap_vmalloc_range() strictly requires the exact base address of the
vmalloc allocation.=20

Because remap_vmalloc_range() expects the provided address to exactly match
the area base address, won't it unconditionally return -EINVAL when passed
this interior pointer?=20

If so, does this mean userspace applications attempting to mmap the EVENTS
page for any dynamic context will receive an unexpected -EINVAL error,
breaking core functionality for secondary contexts?

>  	} else if (memdma) {
>  		ret =3D dma_mmap_coherent(&dd->pcidev->dev, vma,
>  					memvirt, memdma, memlen);

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20260914-b4-mmap-pr=
epare-vma-flag-sanify-v2-0-7d9781ed5361@kernel.org?part=3D11
