Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8EAC91FE45A
	for <linux-scsi@vger.kernel.org>; Fri, 17 Jan 2025 11:57:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1737115028; cv=none; b=raUUqT5k4VTk7+xZQSZSeubprMU3U8iCTkhtmYbnXBvt2qWNOMdt6w9FowhfofSdG+ijOaI2pJiJ/4ifq9YB1pdynUQ88ngmrOvmSGSRsn0dcSH3NJLZtv/cJXKXC4tNGbJP5y1X5GL40LOd4bpmoEjC3H+0We7PVl+LWV5D26E=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1737115028; c=relaxed/simple;
	bh=PdsR6eDtPLGU0UCT2ZWFhbGcZ1xhlz6rKWTWzAO6NWg=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=rr0svubonyj4ER3x6as/oXOpdNyDuz0+l+8es/FcGG9oKEvGfZ3ZsvieujSWBFZ6zWLusQWCS/+kuu33vSl0LtsAn2olLZqocBqAfmuesGv1g84jBaiIGtyUnF9tsBpigQ9u8ZCu8uoOuW3SWKcbsJ9N0MxUH4uNjUjbj6qjCVg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=ZKdY4jtv; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="ZKdY4jtv"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1737115025;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=pQeV0O+jL1G/DFyqYGy9184NT6E7z1zePUvfpKkhxQI=;
	b=ZKdY4jtvWMN3MUhSBM45GYN3q0HIiLvq42cv2sVsOaruWoUdAIA2SsmE3y3wgDPl+XR+eI
	BQZuWC0l2wqn7jTJ3Ir01uGeV+zDxq70YPLGA3HWbV4wWtTyN40QJM+pUQpqGV+Yojnlgs
	OLFn6g3xMCGD8VWzt4NoS32pFvQpsr4=
Received: from mx-prod-mc-04.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-54-186-198-63.us-west-2.compute.amazonaws.com [54.186.198.63]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-517-X-QMKzuZMpylKLq_glYHgA-1; Fri,
 17 Jan 2025 06:57:02 -0500
X-MC-Unique: X-QMKzuZMpylKLq_glYHgA-1
X-Mimecast-MFC-AGG-ID: X-QMKzuZMpylKLq_glYHgA
Received: from mx-prod-int-05.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-05.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.17])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-04.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id 7363919560BB;
	Fri, 17 Jan 2025 11:57:00 +0000 (UTC)
Received: from fedora (unknown [10.72.116.68])
	by mx-prod-int-05.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id 9CA3F1955F10;
	Fri, 17 Jan 2025 11:56:53 +0000 (UTC)
Date: Fri, 17 Jan 2025 19:56:48 +0800
From: Ming Lei <ming.lei@redhat.com>
To: Christoph Hellwig <hch@lst.de>
Cc: Jens Axboe <axboe@kernel.dk>, linux-block@vger.kernel.org,
	nbd@other.debian.org, ceph-devel@vger.kernel.org,
	virtualization@lists.linux.dev, linux-mtd@lists.infradead.org,
	linux-nvme@lists.infradead.org, linux-scsi@vger.kernel.org
Subject: Re: [PATCH 1/2] loop: force GFP_NOIO for underlying file systems
 allocations
Message-ID: <Z4pFgIqB50gz-ODi@fedora>
References: <20250117074442.256705-1-hch@lst.de>
 <20250117074442.256705-2-hch@lst.de>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20250117074442.256705-2-hch@lst.de>
X-Scanned-By: MIMEDefang 3.0 on 10.30.177.17

On Fri, Jan 17, 2025 at 08:44:07AM +0100, Christoph Hellwig wrote:
> File systems can and often do allocate memory in the read-write path.
> If these allocations are done with __GFP_IO or __GFP_FS set they can
> recurse into the file system or swap device on top of the loop device
> and cause deadlocks.  Prevent this by forcing a noio scope over the
> calls into the file system.
> 
> Signed-off-by: Christoph Hellwig <hch@lst.de>
> ---
>  drivers/block/loop.c | 10 ++++++++++
>  1 file changed, 10 insertions(+)
> 
> diff --git a/drivers/block/loop.c b/drivers/block/loop.c
> index 1ec7417c7f00..71eccc5cfffb 100644
> --- a/drivers/block/loop.c
> +++ b/drivers/block/loop.c
> @@ -1905,6 +1905,15 @@ static void loop_handle_cmd(struct loop_cmd *cmd)
>  	int ret = 0;
>  	struct mem_cgroup *old_memcg = NULL;
>  	const bool use_aio = cmd->use_aio;
> +	unsigned int memflags;
> +
> +	/*
> +	 * We're calling into file system which could do be doing memory
> +	 * allocations.  Ensure the memory reclaim does not cause I/O,
> +	 * because that could end up in the user of this loop devices again and
> +	 * deadlock.
> +	 */
> +	memflags = memalloc_noio_save();

If we call memalloc_noio_save() here, setting PF_MEMALLOC_NOIO can be removed
from loop_process_work().


Thanks,
Ming

