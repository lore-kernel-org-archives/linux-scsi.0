Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2B033198825
	for <linux-scsi@vger.kernel.org>; Fri,  9 Aug 2024 14:53:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1723215238; cv=none; b=RFK/brM/rEmIMebtxFnL/YsaAoX+Zjb403kCn3Ymz9q5WjLNC+M+t7IIelqsQM4l5oSJ4kJnRcIn8LKtwSrfceTouQEgsHgxoJvyL97Wzwbmjf29Xrc2MY8LJTo8XjqaYlVuOs4ssXkfjQH7YGzHGnu8faC3trBnKl0nfTWocZQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1723215238; c=relaxed/simple;
	bh=GSzMuwNbO0R/haLtymCCrn2VcacmkVi1sA+7fw+Ikp4=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=V6/bs6hc5m4UZsNUs76pSUZhByjo+39lA+7fMWuJFGmOFMsdyHpYafXtl9ptB4zDt8+M0gXzjxJmpLfgbrS/mN8BdEDXn3ohKcrMPGbIf97DYVTa1NI26XnVzZxhFT0yhPC6YWB0+fbfalX96uARgm157wJJ0MmHkKcJgKH00o8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=VcKR1BWz; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="VcKR1BWz"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1723215235;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=S3hmYgUok+ozXUThpLpe+47uXAQDhVMRnl+vdYpiArY=;
	b=VcKR1BWzF0FsBoNvtq+lA5s3/6h7v6paA2YmVNYVpUOwjxju9gEO2KMp1QJ/aFKu7q+J5m
	en1iT90qx/36IWBVvhURzP18cEn+ScSoQTB7PRP0UgmohfMT4Cfibkl6lABAKDC0u1ohDj
	S1FWdGs6gKSAQo/c1wfk+q8+F7QeJn4=
Received: from mx-prod-mc-05.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-54-186-198-63.us-west-2.compute.amazonaws.com [54.186.198.63]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-112-tLJEm6q_PmKvEMMDC9bkdg-1; Fri,
 09 Aug 2024 10:53:47 -0400
X-MC-Unique: tLJEm6q_PmKvEMMDC9bkdg-1
Received: from mx-prod-int-04.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-04.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.40])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-05.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id 5B25119560A2;
	Fri,  9 Aug 2024 14:53:42 +0000 (UTC)
Received: from fedora (unknown [10.72.116.16])
	by mx-prod-int-04.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id 0EEFF19560AA;
	Fri,  9 Aug 2024 14:53:22 +0000 (UTC)
Date: Fri, 9 Aug 2024 22:53:16 +0800
From: Ming Lei <ming.lei@redhat.com>
To: Daniel Wagner <dwagner@suse.de>
Cc: Jens Axboe <axboe@kernel.dk>, Keith Busch <kbusch@kernel.org>,
	Sagi Grimberg <sagi@grimberg.me>,
	Thomas Gleixner <tglx@linutronix.de>,
	Christoph Hellwig <hch@lst.de>,
	"Martin K. Petersen" <martin.petersen@oracle.com>,
	John Garry <john.g.garry@oracle.com>,
	"Michael S. Tsirkin" <mst@redhat.com>,
	Jason Wang <jasowang@redhat.com>,
	Kashyap Desai <kashyap.desai@broadcom.com>,
	Sumit Saxena <sumit.saxena@broadcom.com>,
	Shivasharan S <shivasharan.srikanteshwara@broadcom.com>,
	Chandrakanth patil <chandrakanth.patil@broadcom.com>,
	Sathya Prakash Veerichetty <sathya.prakash@broadcom.com>,
	Suganath Prabu Subramani <suganath-prabu.subramani@broadcom.com>,
	Nilesh Javali <njavali@marvell.com>,
	GR-QLogic-Storage-Upstream@marvell.com,
	Jonathan Corbet <corbet@lwn.net>,
	Frederic Weisbecker <frederic@kernel.org>,
	Mel Gorman <mgorman@suse.de>, Hannes Reinecke <hare@suse.de>,
	Sridhar Balaraman <sbalaraman@parallelwireless.com>,
	"brookxu.cn" <brookxu.cn@gmail.com>, linux-kernel@vger.kernel.org,
	linux-block@vger.kernel.org, linux-nvme@lists.infradead.org,
	linux-scsi@vger.kernel.org, virtualization@lists.linux.dev,
	megaraidlinux.pdl@broadcom.com, mpi3mr-linuxdrv.pdl@broadcom.com,
	MPT-FusionLinux.pdl@broadcom.com, storagedev@microchip.com,
	linux-doc@vger.kernel.org
Subject: Re: [PATCH v3 15/15] blk-mq: use hk cpus only when isolcpus=io_queue
 is enabled
Message-ID: <ZrYtXDrdPjn48r6k@fedora>
References: <20240806-isolcpus-io-queues-v3-0-da0eecfeaf8b@suse.de>
 <20240806-isolcpus-io-queues-v3-15-da0eecfeaf8b@suse.de>
 <ZrI5TcaAU82avPZn@fedora>
 <253ec223-98e1-4e7e-b138-0a83ea1a7b0e@flourine.local>
 <ZrRXEUko5EwKJaaP@fedora>
 <856091db-431f-48f5-9daa-38c292a6bbd2@flourine.local>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <856091db-431f-48f5-9daa-38c292a6bbd2@flourine.local>
X-Scanned-By: MIMEDefang 3.0 on 10.30.177.40

On Fri, Aug 09, 2024 at 09:22:11AM +0200, Daniel Wagner wrote:
> On Thu, Aug 08, 2024 at 01:26:41PM GMT, Ming Lei wrote:
> > Isolated CPUs are removed from queue mapping in this patchset, when someone
> > submit IOs from the isolated CPU, what is the correct hctx used for handling
> > these IOs?
> 
> No, every possible CPU gets a mapping. What this patch series does, is
> to limit/aligns the number of hardware context to the number of
> housekeeping CPUs. There is still a complete ctx-hctc mapping. So

OK, then I guess patch 1~7 aren't supposed to belong to this series,
cause you just want to reduce nr_hw_queues, meantime spread
house-keeping CPUs first for avoiding queues with all isolated cpu mask.

> whenever an user thread on an isolated CPU is issuing an IO a
> housekeeping CPU will also be involved (with the additional overhead,
> which seems to be okay for these users).
> 
> Without hardware queue on the isolated CPUs ensures we really never get
> any unexpected IO on those CPUs unless userspace does it own its own.
> It's a safety net.
> 
> Just to illustrate it, the non isolcpus configuration (default) map
> for an 8 CPU setup:
> 
> queue mapping for /dev/vda
>         hctx0: default 0
>         hctx1: default 1
>         hctx2: default 2
>         hctx3: default 3
>         hctx4: default 4
>         hctx5: default 5
>         hctx6: default 6
>         hctx7: default 7
> 
> and with isolcpus=io_queue,2-3,6-7
> 
> queue mapping for /dev/vda
>         hctx0: default 0 2
>         hctx1: default 1 3
>         hctx2: default 4 6
>         hctx3: default 5 7

OK, Looks I missed the point in patch 15 in which you added isolated cpu
into mapping manually, just wondering why not take the current two-stage
policy to cover both house-keeping and isolated CPUs in group_cpus_evenly()?

Such as spread house-keeping CPUs first, then isolated CPUs, just like
what we did for present & non-present cpus.

Then the whole patchset can be simplified a lot.

> 
> > From current implementation, it depends on implied zero filled
> > tag_set->map[type].mq_map[isolated_cpu], so hctx 0 is used.
> > 
> > During CPU offline, in blk_mq_hctx_notify_offline(),
> > blk_mq_hctx_has_online_cpu() returns true even though the last cpu in
> > hctx 0 is offline because isolated cpus join hctx 0 unexpectedly, so IOs in
> > hctx 0 won't be drained.
> > 
> > However managed irq core code still shutdowns the hw queue's irq because all
> > CPUs in this hctx are offline now. Then IO hang is triggered, isn't
> > it?
> 
> Thanks for the explanation. I was able to reproduce this scenario, that
> is a hardware context with two CPUs which go offline. Initially, I used
> fio for creating the workload but this never hit the hanger. Instead
> some background workload from systemd-journald is pretty reliable to
> trigger the hanger you describe.
> 
> Example:
> 
>   hctx2: default 4 6
> 
> CPU 0 stays online, CPU 1-5 are offline. CPU 6 is offlined:
> 
>   smpboot: CPU 5 is now offline
>   blk_mq_hctx_has_online_cpu:3537 hctx3 offline
>   blk_mq_hctx_has_online_cpu:3537 hctx2 offline
> 
> and there is no forward progress anymore, the cpuhotplug state machine
> is blocked and an IO is hanging:
> 
>   # grep busy /sys/kernel/debug/block/*/hctx*/tags | grep -v busy=0
>   /sys/kernel/debug/block/vda/hctx2/tags:busy=61
> 
> and blk_mq_hctx_notify_offline busy loops forever:
> 
>    task:cpuhp/6         state:D stack:0     pid:439   tgid:439   ppid:2      flags:0x00004000
>    Call Trace:
>     <TASK>
>     __schedule+0x79d/0x15c0
>     ? lockdep_hardirqs_on_prepare+0x152/0x210
>     ? kvm_sched_clock_read+0xd/0x20
>     ? local_clock_noinstr+0x28/0xb0
>     ? local_clock+0x11/0x30
>     ? lock_release+0x122/0x4a0
>     schedule+0x3d/0xb0
>     schedule_timeout+0x88/0xf0
>     ? __pfx_process_timeout+0x10/0x10d
>     msleep+0x28/0x40
>     blk_mq_hctx_notify_offline+0x1b5/0x200
>     ? cpuhp_thread_fun+0x41/0x1f0
>     cpuhp_invoke_callback+0x27e/0x780
>     ? __pfx_blk_mq_hctx_notify_offline+0x10/0x10
>     ? cpuhp_thread_fun+0x42/0x1f0
>     cpuhp_thread_fun+0x178/0x1f0
>     smpboot_thread_fn+0x12e/0x1c0
>     ? __pfx_smpboot_thread_fn+0x10/0x10
>     kthread+0xe8/0x110
>     ? __pfx_kthread+0x10/0x10
>     ret_from_fork+0x33/0x40
>     ? __pfx_kthread+0x10/0x10
>     ret_from_fork_asm+0x1a/0x30
>     </TASK>
> 
> I don't think this is a new problem this code introduces. This problem
> exists for any hardware context which has more than one CPU. As far I
> understand it, the problem is that there is no forward progress possible
> for the IO itself (I assume the corresponding resources for the CPU

When blk_mq_hctx_notify_offline() is running, the current CPU isn't
offline yet, and the hctx is active, same with the managed irq, so it is fine
to wait until all in-flight IOs originated from this hctx completed there.

The reason is why these requests can't be completed? And the forward
progress is provided by blk-mq. And these requests are very likely
allocated & submitted from CPU6.

Can you figure out what is effective mask for irq of hctx2?  It is
supposed to be cpu6. And block debugfs for vda should provide helpful
hint.

> going offline have already been shutdown, thus no progress?) and
> blk_mq_hctx_notifiy_offline isn't doing anything in this scenario.

RH has internal cpu hotplug stress test, but not see such report so far.

I will try to setup such kind of setting and see if it can be
reproduced.

> 
> Couldn't we do something like:

I usually won't thinking about any solution until root-cause is figured
out, :-)
 

Thanks, 
Ming

