Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E89463B442B;
	Tue,  8 Sep 2026 20:42:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788900179; cv=none; b=GQyGA16kwBnu7qv00ZDN29IdhiS3q6a7TXdNZfAvQ8QsaKeY33xmCwFWe5W1RV8QSAX0epP7Pnan/HwI+7kWipghLZ8eLT2yxnPHxfL+J6OAjOmQbSyGtZNy9RK39BKQZx68bY21v52CbBZVuGKD1ZmG4tifbtNyOkzMFWr8KXU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788900179; c=relaxed/simple;
	bh=n1qN3fLYK6tRX6BMPMCX0E3dV3IlpHk5VkgE41RQgOA=;
	h=From:Subject:To:Cc:In-Reply-To:References:Content-Type:Date:
	 Message-Id; b=OWkKe7dURAFp5w+E3c5V8QPQqve3cAGJf07PltoIokgXTtjD1MWuLgDBouI1gg9ZtQSKS2hacGIHA2SjpqTLVwG4HoskpsFvBDY7HHi2RsmsW1NSxmrz8uvU8SvNXhHKVwv9c8I4SscZNO0znynkleoIKKBX6hMO3qUCE85l1Mk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=KG/nwEdF; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="KG/nwEdF"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0E8581F00A3D;
	Tue,  8 Sep 2026 20:42:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1788900177;
	bh=rP/dflhRN42vIKtpYVeS+eqA9Sa9OCScAS9/8HGR7og=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=KG/nwEdFOZrcFIr/wHdjSU8FKYsxuhVwpami3OCw03aJ3QxER9IIVozz2zx2D3kle
	 8lIEkmT+dt1DB7dNJJnz7rkqggtYjrsXTNslf0XaLSQddCUqEqmGXReaYTGJr/F14M
	 yHENbbOGiSnBm10oa637dBqciVKuheZxOziZ5bsFqJ84J3wOwdgKCo8UyMOUWGrcoQ
	 LnXiyJMzvve1lVhQVx7A9SDrQxgq7WblSD14+b89/38cIvPy9bJbIhfFBQArYEbiu7
	 y+c7gBDdwGxvDPEYihj5aSx6iPIH/Nbj6RtPqjD0eYkXLwWErUI6e+JwDsKJXw/zxx
	 yIOD9w6Qhs+8Q==
From: sashiko-bot@kernel.org
Subject: Re: [PATCH 10/39] infiniband: update hfi1 to use
 remap_vmalloc_range()
Reply-To: sashiko-reviews@lists.linux.dev
To: =?utf-8?b?TG9yZW56byBTdG9ha2VzIChBUk0p?= <ljs@kernel.org>
Cc: "Vasily Gorbik" <gor@linux.ibm.com>, "Alexander Gordeev" <agordeev@linux.ibm.com>, selinux@vger.kernel.org, "Christian
 Borntraeger" <borntraeger@linux.ibm.com>, bpf@vger.kernel.org, kvm@vger.kernel.org, kvmarm@lists.linux.dev, linux-s390@vger.kernel.org, "Marc
 Zyngier" <maz@kernel.org>, linux-perf-users@vger.kernel.org, linux-trace-kernel@vger.kernel.org, "Heiko
 Carstens" <hca@linux.ibm.com>, "Oliver Upton" <oupton@kernel.org>, linux-scsi@vger.kernel.org, dri-devel@lists.freedesktop.org
In-Reply-To: <20260908-b4-mmap-prepare-vma-flag-sanify-v1-10-dacf19cce22b@kernel.org>
References: <20260908-b4-mmap-prepare-vma-flag-sanify-v1-0-dacf19cce22b@kernel.org>
 <20260908-b4-mmap-prepare-vma-flag-sanify-v1-10-dacf19cce22b@kernel.org>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Tue, 08 Sep 2026 20:42:56 +0000
Message-Id: <20260908204257.0E8581F00A3D@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>

Thank you for your contribution! Sashiko AI review found 2 potential issue(=
s) to consider:

New issues:
- [Medium] RTAIL mmap command loses VM_DONTEXPAND when mapped via dma_mmap_=
coherent() on IOMMU-DMA paths.

Pre-existing issues:
- [High] Incomplete restriction of memory mapping permissions allows uninte=
nded read or write access.
--

commit 0ae54391480b6bdd96d1db0cbfbacb99d957dcc1
Author: Lorenzo Stoakes (ARM) <ljs@kernel.org>

infiniband: update hfi1 to use remap_vmalloc_range()

This patch converts the hfi1 infiniband driver to use remap_vmalloc_range()
for mapping chip memory from vmalloc'd ranges instead of using a custom fau=
lt
handler. It also updates flag handling and sets the virtual kernel address
for various mapping types.

> diff --git a/drivers/infiniband/hw/hfi1/file_ops.c b/drivers/infiniband/h=
w/hfi1/file_ops.c
> --- a/drivers/infiniband/hw/hfi1/file_ops.c
> +++ b/drivers/infiniband/hw/hfi1/file_ops.c
[ ... ]
> @@ -366,7 +361,7 @@ static int hfi1_file_mmap(struct file *fp, struct vm_=
area_struct *vma)
>  		 */
>  		memlen =3D PAGE_ALIGN(uctxt->sc->credits * PIO_BLOCK_SIZE);
>  		flags &=3D ~VM_MAYREAD;
> -		flags |=3D VM_DONTCOPY | VM_DONTEXPAND;
> +		flags |=3D VM_DONTCOPY;

[Severity: High]
This is a pre-existing issue, but does this incomplete restriction of memory
permissions in hfi1_file_mmap() allow unintended read access to PIO buffers?

When a user calls mmap() on PIO_BUFS requesting PROT_READ, the driver clears
VM_MAYREAD from the flags but fails to check and reject the call if VM_READ
is already set. Because vma->vm_page_prot is computed before this callback
based on the initial VM_READ flag, the PTEs will be populated with read
permissions. This potentially allows reading of sensitive data written by
other subcontexts.

[ ... ]
>  	case RTAIL:
[ ... ]
>  		memlen =3D PAGE_SIZE;
>  		memvirt =3D (void *)hfi1_rcvhdrtail_kvaddr(uctxt);
>  		memdma =3D uctxt->rcvhdrqtailaddr_dma;
>  		flags &=3D ~VM_MAYWRITE;
>  		break;

[Severity: Medium]
Is it intentional that the VM_DONTEXPAND flag was removed from the RTAIL
path here?

The RTAIL path was converted to rely on dma_mmap_coherent(), but the
VM_DONTEXPAND flag was dropped. When a user maps the RTAIL buffer and then
calls mremap() to expand the VMA, the expansion could succeed incorrectly
because dma_mmap_coherent() does not set VM_DONTEXPAND on IOMMU-DMA paths.
When expanded on an IOMMU-DMA path, the new PTEs will not be populated,
leading to a SIGBUS or page fault on access.

Note that the commit message explicitly documented retaining VM_DONTEXPAND
for PIO_CRED because of this exact dma_mmap_coherent() behavior, but it
appears it was not retained for RTAIL.

[ ... ]
>  	case SUBCTXT_EGRBUF:
> -		memaddr =3D (u64)uctxt->subctxt_rcvegrbuf;
> +		memvirt =3D uctxt->subctxt_rcvegrbuf;
>  		memlen =3D uctxt->egrbufs.size * uctxt->subctxt_cnt;
> -		flags |=3D VM_IO | VM_DONTEXPAND;
>  		flags &=3D ~VM_MAYWRITE;
> -		vmf =3D 1;
> +		is_vmalloc =3D 1;
>  		break;

[Severity: High]
This is a pre-existing issue, but does this incomplete restriction of memory
permissions in hfi1_file_mmap() allow unintended write access to the shared
subcontext eager receive buffers?

Similar to the PIO_BUFS case above, when a user calls mmap() on
SUBCTXT_EGRBUF requesting PROT_WRITE, the driver clears VM_MAYWRITE from the
flags but fails to check and reject the call if VM_WRITE is already set.

Because vma->vm_page_prot is computed before this callback based on the
initial VM_WRITE flag, the PTEs will be populated with write permissions.
Write access to read-only eager buffers allows a process to corrupt or spoof
incoming network packets for other subcontexts sharing the hardware context.

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20260908-b4-mmap-pr=
epare-vma-flag-sanify-v1-0-dacf19cce22b@kernel.org?part=3D10
