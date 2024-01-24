Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1044039AC0
	for <linux-scsi@vger.kernel.org>; Wed, 24 Jan 2024 23:36:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1706139407; cv=none; b=SoyoI4SvBZrwdeIOG3Rlxgfe2vs6KKERsMQZxXOqM3BewzjSlsb1YseM6sr95xADjs1pq81JLXPwj6ZPY+p7fEhFCvB++OunFREDbsge6OHNL0/zd0JT63aBLhlqFrqH+nK1I2AML3rOK/g6JZURNbhNxgMflgSroFRIkGmBsoU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1706139407; c=relaxed/simple;
	bh=pe+XeTVfRhYU+++0JA3Qlbt9fe5wx3nGERgeIk5qwlU=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=T77dqjyBmUQ8BB8HWZg4AJn87/tuTzonh+KjtX0q/ddPjx7tIiMkwBGH2m1g1LQL9ovAdSfnptgwJhGBoFJYiG372mR/JZiCCAnmR+0kjSIdYT9a/z44XwaRpWR3oZlZWDdzFxta2Is/NXakZTHahKLE6iRSp9CofUp5pU6mx/w=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=SvFcWFNt; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="SvFcWFNt"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1706139403;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=lAE2dMCz9cVUOkDqof5Pc03ZnfQxnP+BsyHXfCZ2zaw=;
	b=SvFcWFNt8yQHd+Vr05M4bfoSZuOv18HOLQ92eYNiHVGRIx29tHEo+DvAIb0zkG84ZaoxU2
	anYFexLMVqAEj8wQnjky9KaVIehYr6WUzRqbji9Jiyjzq49fVq8+D/wHDqgXiJz9zEoU7l
	EtztMxsh6fx3I9bZPN9afIoe7TRnysY=
Received: from mimecast-mx02.redhat.com (mimecast-mx02.redhat.com
 [66.187.233.88]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-425-vBqxVIaBNi68tfdW7Sz1Yw-1; Wed, 24 Jan 2024 18:36:42 -0500
X-MC-Unique: vBqxVIaBNi68tfdW7Sz1Yw-1
Received: from smtp.corp.redhat.com (int-mx09.intmail.prod.int.rdu2.redhat.com [10.11.54.9])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id D8A9F800074;
	Wed, 24 Jan 2024 23:36:41 +0000 (UTC)
Received: from rhel-developer-toolbox-latest (unknown [10.2.16.47])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id 29A1D492BC6;
	Wed, 24 Jan 2024 23:36:41 +0000 (UTC)
Date: Wed, 24 Jan 2024 15:36:39 -0800
From: Chris Leech <cleech@redhat.com>
To: Nilesh Javali <njavali@marvell.com>
Cc: martin.petersen@oracle.com, lduncan@suse.com,
	linux-scsi@vger.kernel.org, GR-QLogic-Storage-Upstream@marvell.com,
	jmeneghi@redhat.com
Subject: Re: [PATCH v3 1/3] uio: introduce UIO_MEM_DMA_COHERENT type
Message-ID: <ZbGfB2tqASg5Jiaq@rhel-developer-toolbox-latest>
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
X-Scanned-By: MIMEDefang 3.4.1 on 10.11.54.9

Nilesh, 

On Tue, Jan 09, 2024 at 05:44:56PM +0530, Nilesh Javali wrote:
> +	ret = dma_mmap_coherent(&idev->dev,
> +				vma,
> +				addr,
> +				mem->dma_addr,
> +				vma->vm_end - vma->vm_start);

When I asked about the use of idev->dev here in the v2 posting, you
repled as follows.

> While the cnic loads, it registers the cnic_uio_dev->pdev->dev with
> uio and the uio attaches its device to cnic device as it's parent. So
> uio and cnic are attached to the same PCI device.

I still don't think the sysfs parent relationship is enough to get the
correct behavior out of the DMA APIs on all platforms, and
dma_mmap_coherent needs to be using the same device struct as
dma_alloc_coherent.

I had some testing done on an AMD system, where your v2 patch set was
failing with the iommu enabled, and my original changes were reported to
work.  And I believe these v3 patches are functionally the same.

- Chris

