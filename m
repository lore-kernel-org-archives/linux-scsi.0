Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 16CA52C68B
	for <linux-scsi@vger.kernel.org>; Thu,  4 Jan 2024 20:20:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="ZCphfXEi"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1704399626;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=bPYz1RfNie2nu/IYZC5wNr9bq3SZ+ONsUGdsTsRrBw8=;
	b=ZCphfXEiUV/MXLPCGwo0a7Xnvl+Q8o+5iWMggL33xvkFqHTqhkyyJzMSEFA3jsc4vSYc6x
	okQEgwRh6NURE3LRom+qV3Xg+YJiXLerl/m7qsscdEePTx6DRKLp13mTUtFm+2qjxyPzDs
	r1Dx9c7JiLE80ueOsRL407DUf2o/6Uo=
Received: from mimecast-mx02.redhat.com (mimecast-mx02.redhat.com
 [66.187.233.88]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-33-WVCyiUNoNluID5OP3_LeCg-1; Thu, 04 Jan 2024 15:20:22 -0500
X-MC-Unique: WVCyiUNoNluID5OP3_LeCg-1
Received: from smtp.corp.redhat.com (int-mx10.intmail.prod.int.rdu2.redhat.com [10.11.54.10])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 3FA3985A58A;
	Thu,  4 Jan 2024 20:20:22 +0000 (UTC)
Received: from rhel-developer-toolbox-latest (unknown [10.2.16.116])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id 84530492BE6;
	Thu,  4 Jan 2024 20:20:21 +0000 (UTC)
Date: Thu, 4 Jan 2024 12:20:19 -0800
From: Chris Leech <cleech@redhat.com>
To: Nilesh Javali <njavali@marvell.com>
Cc: martin.petersen@oracle.com, lduncan@suse.com,
	linux-scsi@vger.kernel.org, GR-QLogic-Storage-Upstream@marvell.com,
	jmeneghi@redhat.com
Subject: Re: [PATCH v2 1/3] uio: introduce UIO_MEM_DMA_COHERENT type
Message-ID: <ZZcTA6PPS4nfuTjk@rhel-developer-toolbox-latest>
References: <20240103091137.27142-1-njavali@marvell.com>
 <20240103091137.27142-2-njavali@marvell.com>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20240103091137.27142-2-njavali@marvell.com>
X-Scanned-By: MIMEDefang 3.4.1 on 10.11.54.10

On Wed, Jan 03, 2024 at 02:41:35PM +0530, Nilesh Javali wrote:
> From: Chris Leech <cleech@redhat.com>
> 
> Add a UIO memtype specifically for sharing dma_alloc_coherent
> memory with userspace, backed by dma_mmap_coherent.
> 
> Signed-off-by: Nilesh Javali <njavali@marvell.com>
> Signed-off-by: Chris Leech <cleech@redhat.com>
> ---
> v2:
> - expose only the dma_addr within uio_mem
> - Cleanup newly added unions comprising virtual_addr
>   and struct device

Nilesh, thanks for taking another look at these changes. If we're taking
another shot at getting uio changes accepted, Greg KH is going to have
to be part of that conversation.

Removing the unions looks good, but I do have some concerns with your
modifications.

On Wed, Jan 03, 2024 at 02:41:35PM +0530, Nilesh Javali wrote:

> +static int uio_mmap_dma_coherent(struct vm_area_struct *vma)
> +{
> +	struct uio_device *idev = vma->vm_private_data;
> +	struct uio_mem *mem;
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
> +	ret = dma_mmap_coherent(&idev->dev,
                                ~~~~~~~~~~
This doesn't seem right. You've plugged a struct device into the call,
but it's not the same device used when calling dma_alloc_coherent.  I
don't see a way around needing a way to access the correct device in
uio_mmap_dma_coherent, or a way to do that without attaching it to the
uio_device.

> +				vma,
> +				(void *)mem->addr,
> +				mem->dma_addr,
> +				vma->vm_end - vma->vm_start);
> +	vma->vm_pgoff = mi;
> +
> +	return ret;
> +}
> +

- Chris

