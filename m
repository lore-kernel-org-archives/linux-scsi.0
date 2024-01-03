Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 85AF91B272
	for <linux-scsi@vger.kernel.org>; Wed,  3 Jan 2024 15:31:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="Wk8l0pUr"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1704295892;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=PjMM5OBHuWQPx+I0gjWQY6fIMxtHp/wJUqoWHgEbBdw=;
	b=Wk8l0pUryObMQgQW4I4bYo5etTg/yejjF5sYPehTb9FhAlF52b2A6exZICAnc08/fyQ8WH
	NmMZswzQpLiuD1PoAtajUOiEbBoTsoOtIPr/grpuGIdloQROaQXzRYw4oJHVXzs2/fgxYr
	LVLzMBLJrpwlxC2otP6aio//b2IA7UA=
Received: from mimecast-mx02.redhat.com (mx-ext.redhat.com [66.187.233.73])
 by relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-172-ctIBx3P_N1GBXcJVNmQ8wg-1; Wed,
 03 Jan 2024 10:31:29 -0500
X-MC-Unique: ctIBx3P_N1GBXcJVNmQ8wg-1
Received: from smtp.corp.redhat.com (int-mx03.intmail.prod.int.rdu2.redhat.com [10.11.54.3])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id B6C803811F30;
	Wed,  3 Jan 2024 15:31:28 +0000 (UTC)
Received: from [10.18.25.182] (unknown [10.18.25.182])
	by smtp.corp.redhat.com (Postfix) with ESMTP id 56B731121306;
	Wed,  3 Jan 2024 15:31:28 +0000 (UTC)
Message-ID: <a905fe13-93eb-4359-834a-9e80f7cca2e0@redhat.com>
Date: Wed, 3 Jan 2024 10:31:28 -0500
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v2 0/3] UIO_MEM_DMA_COHERENT for cnic/bnx2/bnx2x
Content-Language: en-US
To: Nilesh Javali <njavali@marvell.com>, martin.petersen@oracle.com,
 lduncan@suse.com, cleech@redhat.com
Cc: linux-scsi@vger.kernel.org, GR-QLogic-Storage-Upstream@marvell.com,
 gregkh@linuxfoundation.org, Hannes Reinecke <hare@suse.de>,
 Jerry Snitselaar <jsnitsel@redhat.com>, Ming Lei <ming.lei@redhat.com>,
 Ewan Milne <emilne@redhat.com>
References: <20240103091137.27142-1-njavali@marvell.com>
From: John Meneghini <jmeneghi@redhat.com>
Organization: RHEL Core Storge Team
In-Reply-To: <20240103091137.27142-1-njavali@marvell.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Scanned-By: MIMEDefang 3.4.1 on 10.11.54.3

Nilesh,

Please explain what has been done to test these patches on bnx2i. Was testing done with iommu enabled/disabled?  Was testing 
done on any/all platforms, or was only x86_64 tested?

Thanks,

/John

On 1/3/24 04:11, Nilesh Javali wrote:
> During bnx2i iSCSI testing we ran into page refcounting issues in the
> uio mmaps exported from cnic to the iscsiuio process, and bisected back
> to the removal of the __GFP_COMP flag from dma_alloc_coherent calls.
> 
> In order to fix these drivers to be able to mmap dma coherent memory via
> a uio device, without resorting to hacks and working with an iommu
> enabled, introduce a new uio mmap type backed by dma_mmap_coherent.
> 
> While converting the uio interface, I also noticed that not all of these
> allocations were PAGE_SIZE aligned. Particularly the bnx2/bnx2x status
> block mapping was much smaller than any architecture page size, and I
> was concerned that it could be unintentionally exposing kernel memory.
> 
> v2:
> - expose only the dma_addr within uio and cnic.
> - Cleanup newly added unions comprising virtual_addr
>    and struct device
> 
> Chris Leech (3):
>    uio: introduce UIO_MEM_DMA_COHERENT type
>    cnic,bnx2,bnx2x: use UIO_MEM_DMA_COHERENT
>    cnic,bnx2,bnx2x: page align uio mmap allocations
> 
>   drivers/net/ethernet/broadcom/bnx2.c          |  2 +
>   .../net/ethernet/broadcom/bnx2x/bnx2x_main.c  | 10 +++--
>   drivers/net/ethernet/broadcom/cnic.c          | 26 ++++++++-----
>   drivers/net/ethernet/broadcom/cnic.h          |  1 +
>   drivers/net/ethernet/broadcom/cnic_if.h       |  1 +
>   drivers/uio/uio.c                             | 38 +++++++++++++++++++
>   include/linux/uio_driver.h                    |  2 +
>   7 files changed, 67 insertions(+), 13 deletions(-)
> 

