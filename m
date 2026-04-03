Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9838E3033F7
	for <linux-scsi@vger.kernel.org>; Fri,  3 Apr 2026 02:31:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1775183464; cv=none; b=ueScX7A40FLzj+3WxHHv1vJClkacQyUqKNyruCtFRqBQjusgNgaMsASJaex8JTcb7/8kSXFtGxecfZHxFqlbx/w+Vyj9eQbjkmGfyCle7ddi3sFQiBWcnF45JoJfF0LSuHZOl+UeIDDKj1F09hboGCY4x7e4WPPp3w9pq4UmmdM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1775183464; c=relaxed/simple;
	bh=nYwV1LUq6KG6Ao2Tmp47YT7ArzKmyrKv2lE+QHJL8dw=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=FpCt3uYTulK5oXP8rmEeeSZJCj2yBX1EpFYM2sZFbU4R4g/nw4s8RL/ArUqUzmSUV+IDcmMVhG7F5HiZt457C+jFQpM9RhvDHmnouCBbZWE81Xd9lbuYo2fNEKCUHfG+zPt7OiF37ZLDZI0cAHsUzJx9Ogjt03qaN5TyssMv9nI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=jGRLT7V3; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="jGRLT7V3"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1775183461;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=Hk3l4sJZ8VQmwKxYtifv90rkgr2B19mqHbHCn7fohLk=;
	b=jGRLT7V3/NLR1GINb4nzQiCCKMQUBgnyCiurwMlZ7oi9fMs0LnJvymM8L0p8h9JC9po47A
	+50uNP383ilZQpOb04O+mk12YNXd4Y4qjA7HSvAKhYS4/xJ3KU5rey/tg97n1g/IR4g0zX
	s+3RPuwxqT1NiYmRZH0DULNHzWueMk0=
Received: from mx-prod-mc-06.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-35-165-154-97.us-west-2.compute.amazonaws.com [35.165.154.97]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-460-rCXx2cJTP-Klv46VrVi2tw-1; Thu,
 02 Apr 2026 22:30:59 -0400
X-MC-Unique: rCXx2cJTP-Klv46VrVi2tw-1
X-Mimecast-MFC-AGG-ID: rCXx2cJTP-Klv46VrVi2tw_1775183455
Received: from mx-prod-int-08.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-08.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.111])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-06.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id 752D518005B0;
	Fri,  3 Apr 2026 02:30:53 +0000 (UTC)
Received: from fedora (unknown [10.72.116.83])
	by mx-prod-int-08.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id 3908A1801A52;
	Fri,  3 Apr 2026 02:30:30 +0000 (UTC)
Date: Fri, 3 Apr 2026 10:30:26 +0800
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
Subject: Re: [PATCH v10 13/13] docs: add io_queue flag to isolcpus
Message-ID: <ac8l-w8ERG1YN2Wm@fedora>
References: <20260401222312.772334-1-atomlin@atomlin.com>
 <20260401222312.772334-14-atomlin@atomlin.com>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260401222312.772334-14-atomlin@atomlin.com>
X-Scanned-By: MIMEDefang 3.4.1 on 10.30.177.111

On Wed, Apr 01, 2026 at 06:23:12PM -0400, Aaron Tomlin wrote:
> From: Daniel Wagner <wagi@kernel.org>
> 
> The io_queue flag informs multiqueue device drivers where to place
> hardware queues. Document this new flag in the isolcpus
> command-line argument description.
> 
> Reviewed-by: Aaron Tomlin <atomlin@atomlin.com>
> Reviewed-by: Hannes Reinecke <hare@suse.de>
> Signed-off-by: Daniel Wagner <wagi@kernel.org>
> Signed-off-by: Aaron Tomlin <atomlin@atomlin.com>
> ---
>  .../admin-guide/kernel-parameters.txt         | 22 ++++++++++++++++++-
>  1 file changed, 21 insertions(+), 1 deletion(-)
> 
> diff --git a/Documentation/admin-guide/kernel-parameters.txt b/Documentation/admin-guide/kernel-parameters.txt
> index 03a550630644..9ed7c3ecd158 100644
> --- a/Documentation/admin-guide/kernel-parameters.txt
> +++ b/Documentation/admin-guide/kernel-parameters.txt
> @@ -2816,7 +2816,6 @@ Kernel parameters
>  			  "number of CPUs in system - 1".
>  
>  			managed_irq
> -
>  			  Isolate from being targeted by managed interrupts
>  			  which have an interrupt mask containing isolated
>  			  CPUs. The affinity of managed interrupts is
> @@ -2839,6 +2838,27 @@ Kernel parameters
>  			  housekeeping CPUs has no influence on those
>  			  queues.
>  
> +			io_queue
> +			  Isolate from I/O queue work caused by multiqueue
> +			  device drivers. Restrict the placement of
> +			  queues to housekeeping CPUs only, ensuring that
> +			  all I/O work is processed by a housekeeping CPU.

All these can be supported by `managed_irq` already, please document the thing
which `io_queue` solves, and `managed_irq` can't cover, so user can know
how to choose between the two command lines.

`Restrict the placement of queues to housekeeping CPUs only` looks totally
stale, please see patch 10, in which isolated CPUs are spread too.

> +
> +			  The io_queue configuration takes precedence
> +			  over managed_irq. When io_queue is used,
> +			  managed_irq placement constrains have no
> +			  effect.
> +
> +			  Note: Offlining housekeeping CPUS which serve
> +			  isolated CPUs will be rejected. Isolated CPUs
> +			  need to be offlined before offlining the
> +			  housekeeping CPUs.
> +
> +			  Note: When an isolated CPU issues an I/O request,
> +			  it is forwarded to a housekeeping CPU. This will
> +			  trigger a software interrupt on the completion
> +			  path.

`io_queue` doesn't touch io completion code path, which is more
implementation details, so not sure if the above Note is needed.


Thanks,
Ming

