Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C566B7A714
	for <linux-scsi@vger.kernel.org>; Wed, 24 Jan 2024 23:14:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1706138101; cv=none; b=N5mKfAKnrEyVN1/2RYkdlD9+U1ZDj3WiglG3lGNtz5hiOiO7pSlsPaSPhnU01soqTdtuIyNFgGwzG0Nk2FbhHKuBiZ3wc8QVItGM8luuO1ouvQhyWYwa1vYmeemyWM30HEK2J45Z1fSkAFqw8OwkzoWNOJEqtRez/uXn7PyWli4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1706138101; c=relaxed/simple;
	bh=+cye9ABl35DBOqmTvmlFwmSUAVDa38qvq8evWZdmSAg=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=Zbn9lSWzUwSld1ZkvSHxst8++JuTxcSMqzqWSzfuW6DMg4Z86visRGrh6BgKa1VDEkK16+7ovuLp8BFty098wQjqbpGxPqId9cgW/lGRL4a0oHXd7czf20Lr5B3MtzQ164Tjx121TkBBDVyJ9cZFILLfhUyI+V0KTNmfc4dJh9Y=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=FA2il2w1; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="FA2il2w1"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1706138098;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=AK7k2sBsoUsbcpdUnFGCVHnF8i5P4gSrxdfQJ6swu8o=;
	b=FA2il2w1FNxDvOW7I8jRVdqN3ErWkOpiw+Cj37Wp5aJpQJTEHsKgqFk8yos8ypR4W/jACn
	1nqxSjN+7U99iEcMLdtcsPO/3aX/yX2kACgpFqcRPi4BSHzGlNXCW45IzkKqMPjq5hGHBH
	j3NMjJ1l+V9hOjnu9y0O6QF2DBoFtgc=
Received: from mimecast-mx02.redhat.com (mimecast-mx02.redhat.com
 [66.187.233.88]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-658-SjROWMWJNmizAUoyckUMLw-1; Wed, 24 Jan 2024 18:14:55 -0500
X-MC-Unique: SjROWMWJNmizAUoyckUMLw-1
Received: from smtp.corp.redhat.com (int-mx02.intmail.prod.int.rdu2.redhat.com [10.11.54.2])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id A4B2185A58B;
	Wed, 24 Jan 2024 23:14:54 +0000 (UTC)
Received: from rhel-developer-toolbox-latest (unknown [10.2.16.47])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id C304840C1430;
	Wed, 24 Jan 2024 23:14:53 +0000 (UTC)
Date: Wed, 24 Jan 2024 15:14:51 -0800
From: Chris Leech <cleech@redhat.com>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	Nilesh Javali <njavali@marvell.com>
Cc: martin.petersen@oracle.com, lduncan@suse.com,
	linux-scsi@vger.kernel.org, GR-QLogic-Storage-Upstream@marvell.com,
	jmeneghi@redhat.com, Christoph Hellwig <hch@infradead.org>
Subject: Re: [PATCH v3 1/3] uio: introduce UIO_MEM_DMA_COHERENT type
Message-ID: <ZbGZ6zQDRqi5Bu_7@rhel-developer-toolbox-latest>
References: <20240109121458.26475-1-njavali@marvell.com>
 <20240109121458.26475-2-njavali@marvell.com>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20240109121458.26475-2-njavali@marvell.com>
X-Scanned-By: MIMEDefang 3.4.1 on 10.11.54.2

Hi Greg, I'd like to ask you to reconsider accepting UIO API changes for
mapping DMA coherent allocations.

The bnx2i iSCSI driver is currently broken due to incorrect (but
previously functioning) uio use in the "cnic" module.  I believe that
the most direct way to fix it is to specifically handle DMA coherent
allocations in the UIO API backed by dma_mmap_coherent.

After my original posting of these patches[1], Nilesh Javali had made an
attempt to change the cnic allocations[2]. Those were rejected, and
Nilesh has returned to cleaning up the UIO_MEM_DMA_COHERENT patches.

[1] https://lore.kernel.org/all/20230929170023.1020032-1-cleech@redhat.com/
[2] https://lore.kernel.org/linux-scsi/20231219055514.12324-1-njavali@marvell.com/

While I understand the complaints about how these drivers have been
structured, I also don't like letting support bitrot when there's a
reasonable alternative to re-architecting an existing driver.

There are two other uio drivers which are mmaping dma_alloc_coherent
memory as UIO_MEM_PHYS, uio_dmem_genirq and uio_pruss. While a
conversion to use dma_mmap_coherent might be more correct for these as
well, I have no way of testing them and assume that this just hasn't
been an issue for the platforms in question.

Nilesh has kindly removed the unions I had in the original posting, and
done additional testing on the changes.

Although I do believe that we need to go back to somehow storing the
device struct associated with the PCI device, and not using idev->dev
here.

> +	ret = dma_mmap_coherent(&idev->dev,
> +				vma,
> +				addr,
> +				mem->dma_addr,
> +				vma->vm_end - vma->vm_start);

Thank you,
- Chris Leech

On Tue, Jan 09, 2024 at 05:44:56PM +0530, Nilesh Javali wrote:
> From: Chris Leech <cleech@redhat.com>
> 
> Add a UIO memtype specifically for sharing dma_alloc_coherent
> memory with userspace, backed by dma_mmap_coherent.
> 
> Reported-by: kernel test robot <lkp@intel.com>
> Closes: https://lore.kernel.org/oe-kbuild-all/202401042222.J9GOUiYL-lkp@intel.com/
> Signed-off-by: Nilesh Javali <njavali@marvell.com>
> Signed-off-by: Chris Leech <cleech@redhat.com>
> ---
> v3:
> - fix warnings reported by kernel test robot
> v2:
> - expose only the dma_addr within uio_mem
> - Cleanup newly added unions comprising virtual_addr
>   and struct device
>  drivers/uio/uio.c          | 40 ++++++++++++++++++++++++++++++++++++++
>  include/linux/uio_driver.h |  2 ++
>  2 files changed, 42 insertions(+)
> 
> diff --git a/drivers/uio/uio.c b/drivers/uio/uio.c
> index 62082d64ece0..01d83728b513 100644
> --- a/drivers/uio/uio.c
> +++ b/drivers/uio/uio.c
> @@ -24,6 +24,7 @@
>  #include <linux/kobject.h>
>  #include <linux/cdev.h>
>  #include <linux/uio_driver.h>
> +#include <linux/dma-mapping.h>
>  
>  #define UIO_MAX_DEVICES		(1U << MINORBITS)
>  
> @@ -759,6 +760,42 @@ static int uio_mmap_physical(struct vm_area_struct *vma)
>  			       vma->vm_page_prot);
>  }
>  
> +static int uio_mmap_dma_coherent(struct vm_area_struct *vma)
> +{
> +	struct uio_device *idev = vma->vm_private_data;
> +	struct uio_mem *mem;
> +	void *addr;
> +	int ret = 0;
> +	int mi;
> +
> +	mi = uio_find_mem_index(vma);
> +	if (mi < 0)
> +		return -EINVAL;
> +
> +	mem = idev->info->mem + mi;
> +
> +	if (mem->dma_addr & ~PAGE_MASK)
> +		return -ENODEV;
> +	if (vma->vm_end - vma->vm_start > mem->size)
> +		return -EINVAL;
> +
> +	/*
> +	 * UIO uses offset to index into the maps for a device.
> +	 * We need to clear vm_pgoff for dma_mmap_coherent.
> +	 */
> +	vma->vm_pgoff = 0;
> +
> +	addr = (void *)mem->addr;
> +	ret = dma_mmap_coherent(&idev->dev,
> +				vma,
> +				addr,
> +				mem->dma_addr,
> +				vma->vm_end - vma->vm_start);
> +	vma->vm_pgoff = mi;
> +
> +	return ret;
> +}
> +
>  static int uio_mmap(struct file *filep, struct vm_area_struct *vma)
>  {
>  	struct uio_listener *listener = filep->private_data;
> @@ -806,6 +843,9 @@ static int uio_mmap(struct file *filep, struct vm_area_struct *vma)
>  	case UIO_MEM_VIRTUAL:
>  		ret = uio_mmap_logical(vma);
>  		break;
> +	case UIO_MEM_DMA_COHERENT:
> +		ret = uio_mmap_dma_coherent(vma);
> +		break;
>  	default:
>  		ret = -EINVAL;
>  	}
> diff --git a/include/linux/uio_driver.h b/include/linux/uio_driver.h
> index 47c5962b876b..7efa81497183 100644
> --- a/include/linux/uio_driver.h
> +++ b/include/linux/uio_driver.h
> @@ -37,6 +37,7 @@ struct uio_map;
>  struct uio_mem {
>  	const char		*name;
>  	phys_addr_t		addr;
> +	dma_addr_t		dma_addr;
>  	unsigned long		offs;
>  	resource_size_t		size;
>  	int			memtype;
> @@ -158,6 +159,7 @@ extern int __must_check
>  #define UIO_MEM_LOGICAL	2
>  #define UIO_MEM_VIRTUAL 3
>  #define UIO_MEM_IOVA	4
> +#define UIO_MEM_DMA_COHERENT	5
>  
>  /* defines for uio_port->porttype */
>  #define UIO_PORT_NONE	0
> -- 
> 2.23.1
> 

