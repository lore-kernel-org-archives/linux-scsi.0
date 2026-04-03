Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B63B9284672
	for <linux-scsi@vger.kernel.org>; Fri,  3 Apr 2026 01:43:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1775180632; cv=none; b=dc/V8gqb4pO+h8w6a6VkGJes1LzSnAvLfqvLAUXVZe6MnqW9W5X6Veui1aTeHAVPhZy51CugQA25uwM5+1888KAe7SovBvEoSmctl7PhDhO/8x5GmtFpAVQngl7HlU5Nxc59LWlOyVy+zbnfg/vrr9vC8POUNJhLw+XGRvxmBeo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1775180632; c=relaxed/simple;
	bh=cptnLguoepkn80w+bS1kDdZGcOzQ51qbRkmBk63cWN0=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=DO63xkU8b0rKePdR8LKnRy8GffFMQ1EmHDPaJ7oUkazlPGKEm2jYF0qwAM7e8pBL8neNJv/k21aTVzmfJ7RDjlcUqhLyWkjAeXVXYv/6iBAEoewIGwyyYCVV1dvAppBp3U1kFKoqzT7fPZCrmm0G3tcuMP0pQGac8wArsA4K2JY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=Hz/H8Cn8; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="Hz/H8Cn8"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1775180629;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=KlucbAEqwcNJwIj7lkZqI+Mpg+aVJI04l6WTdjinCag=;
	b=Hz/H8Cn8IkyAsH6oZ3rboGaiv0fRo/tmg2b3aP+o51i+XYpwyNES8lZH4k9qchnwFrzDc+
	+4JiWxfltVqR6ijA+1SuQHVLx4izA3ZdMujh2btSXam6SfWkl5k4TbBn6qj7467UlwEe0P
	R8oCn4/BaluKvDzkO+8krcj2Kok1ezQ=
Received: from mx-prod-mc-06.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-35-165-154-97.us-west-2.compute.amazonaws.com [35.165.154.97]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-480-7ZLuw8b1OkyBfyGgFcOEeg-1; Thu,
 02 Apr 2026 21:43:47 -0400
X-MC-Unique: 7ZLuw8b1OkyBfyGgFcOEeg-1
X-Mimecast-MFC-AGG-ID: 7ZLuw8b1OkyBfyGgFcOEeg_1775180623
Received: from mx-prod-int-05.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-05.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.17])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-06.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id F31A9180047F;
	Fri,  3 Apr 2026 01:43:40 +0000 (UTC)
Received: from fedora (unknown [10.72.116.83])
	by mx-prod-int-05.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id 74F381978D41;
	Fri,  3 Apr 2026 01:43:17 +0000 (UTC)
Date: Fri, 3 Apr 2026 09:43:12 +0800
From: Ming Lei <ming.lei@redhat.com>
To: Aaron Tomlin <atomlin@atomlin.com>
Cc: axboe@kernel.dk, kbusch@kernel.org, hch@lst.de, sagi@grimberg.me,
	mst@redhat.com, aacraid@microsemi.com,
	James.Bottomley@hansenpartnership.com, martin.petersen@oracle.com,
	liyihang9@h-partners.com, kashyap.desai@broadcom.com,
	sumit.saxena@broadcom.com, shivasharan.srikanteshwara@broadcom.com,
	chandrakanth.patil@broadcom.com, sathya.prakash@broadcom.com,
	sreekanth.reddy@broadcom.com, suganath-prabu.subramani@broadcom.com,
	ranjan.kumar@broadcom.com, jinpu.wang@cloud.ionos.com,
	tglx@kernel.org, mingo@redhat.com, peterz@infradead.org,
	juri.lelli@redhat.com, vincent.guittot@linaro.org,
	akpm@linux-foundation.org, maz@kernel.org, ruanjinjie@huawei.com,
	bigeasy@linutronix.de, yphbchou0911@gmail.com, wagi@kernel.org,
	frederic@kernel.org, longman@redhat.com, chenridong@huawei.com,
	hare@suse.de, kch@nvidia.com, steve@abita.co, sean@ashe.io,
	chjohnst@gmail.com, neelx@suse.com, mproche@gmail.com,
	linux-block@vger.kernel.org, linux-kernel@vger.kernel.org,
	virtualization@lists.linux.dev, linux-nvme@lists.infradead.org,
	linux-scsi@vger.kernel.org, megaraidlinux.pdl@broadcom.com,
	mpi3mr-linuxdrv.pdl@broadcom.com, MPT-FusionLinux.pdl@broadcom.com
Subject: Re: [PATCH v9 10/13] blk-mq: use hk cpus only when isolcpus=io_queue
 is enabled
Message-ID: <ac8bMOVqTbpg5Pq_@fedora>
References: <20260330221047.630206-1-atomlin@atomlin.com>
 <20260330221047.630206-11-atomlin@atomlin.com>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260330221047.630206-11-atomlin@atomlin.com>
X-Scanned-By: MIMEDefang 3.0 on 10.30.177.17

On Mon, Mar 30, 2026 at 06:10:44PM -0400, Aaron Tomlin wrote:
> From: Daniel Wagner <wagi@kernel.org>
> 
> Extend the capabilities of the generic CPU to hardware queue (hctx)
> mapping code, so it maps houskeeping CPUs and isolated CPUs to the
> hardware queues evenly.
> 
> A hctx is only operational when there is at least one online
> housekeeping CPU assigned (aka active_hctx). Thus, check the final
> mapping that there is no hctx which has only offline housekeeing CPU and
> online isolated CPUs.
> 
> Example mapping result:
> 
>   16 online CPUs
> 
>   isolcpus=io_queue,2-3,6-7,12-13
> 
> Queue mapping:
>         hctx0: default 0 2
>         hctx1: default 1 3
>         hctx2: default 4 6
>         hctx3: default 5 7
>         hctx4: default 8 12
>         hctx5: default 9 13
>         hctx6: default 10
>         hctx7: default 11
>         hctx8: default 14
>         hctx9: default 15
> 
> IRQ mapping:
>         irq 42 affinity 0 effective 0  nvme0q0
>         irq 43 affinity 0 effective 0  nvme0q1
>         irq 44 affinity 1 effective 1  nvme0q2
>         irq 45 affinity 4 effective 4  nvme0q3
>         irq 46 affinity 5 effective 5  nvme0q4
>         irq 47 affinity 8 effective 8  nvme0q5
>         irq 48 affinity 9 effective 9  nvme0q6
>         irq 49 affinity 10 effective 10  nvme0q7
>         irq 50 affinity 11 effective 11  nvme0q8
>         irq 51 affinity 14 effective 14  nvme0q9
>         irq 52 affinity 15 effective 15  nvme0q10
> 
> A corner case is when the number of online CPUs and present CPUs
> differ and the driver asks for less queues than online CPUs, e.g.
> 
>   8 online CPUs, 16 possible CPUs
> 
>   isolcpus=io_queue,2-3,6-7,12-13
>   virtio_blk.num_request_queues=2
> 
> Queue mapping:
>         hctx0: default 0 1 2 3 4 5 6 7 8 12 13
>         hctx1: default 9 10 11 14 15
> 
> IRQ mapping
>         irq 27 affinity 0 effective 0 virtio0-config
>         irq 28 affinity 0-1,4-5,8 effective 5 virtio0-req.0
>         irq 29 affinity 9-11,14-15 effective 0 virtio0-req.1
> 
> Noteworthy is that for the normal/default configuration (!isoclpus) the
> mapping will change for systems which have non hyperthreading CPUs. The
> main assignment loop will completely rely that group_mask_cpus_evenly to
> do the right thing. The old code would distribute the CPUs linearly over
> the hardware context:
> 
> queue mapping for /dev/nvme0n1
>         hctx0: default 0 8
>         hctx1: default 1 9
>         hctx2: default 2 10
>         hctx3: default 3 11
>         hctx4: default 4 12
>         hctx5: default 5 13
>         hctx6: default 6 14
>         hctx7: default 7 15
> 
> The assign each hardware context the map generated by the
> group_mask_cpus_evenly function:
> 
> queue mapping for /dev/nvme0n1
>         hctx0: default 0 1
>         hctx1: default 2 3
>         hctx2: default 4 5
>         hctx3: default 6 7
>         hctx4: default 8 9
>         hctx5: default 10 11
>         hctx6: default 12 13
>         hctx7: default 14 15
> 
> In case of hyperthreading CPUs, the resulting map stays the same.
> 
> Signed-off-by: Daniel Wagner <wagi@kernel.org>
> ---
>  block/blk-mq-cpumap.c | 177 +++++++++++++++++++++++++++++++++++++-----
>  1 file changed, 158 insertions(+), 19 deletions(-)
> 
> diff --git a/block/blk-mq-cpumap.c b/block/blk-mq-cpumap.c
> index 8244ecf87835..3b4fa3b291c9 100644
> --- a/block/blk-mq-cpumap.c
> +++ b/block/blk-mq-cpumap.c
> @@ -22,7 +22,18 @@ static unsigned int blk_mq_num_queues(const struct cpumask *mask,
>  {
>  	unsigned int num;
>  
> -	num = cpumask_weight(mask);
> +	if (housekeeping_enabled(HK_TYPE_IO_QUEUE)) {
> +		const struct cpumask *hk_mask;
> +		struct cpumask avail_mask;

This may overflow kernel stack.


Thanks,
Ming

