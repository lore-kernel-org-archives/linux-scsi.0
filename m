Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 60E443A9D82;
	Tue, 31 Mar 2026 23:05:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1774998312; cv=none; b=Fosvaz0hoqebZsLxNQ4jHfdhgFpptsJNRnU/7b/M88Y1mUSBdS/zGwVO2hNYqOl7/LVoSbc3ESJLVg8y/WxA/HYt7zrFUTWNZFigoFEvUk8Q4lF+JGzipFoTfLu29C63HPcEGYefLCeYGhNlRWe2stwaxhwg6cr/6ksvEG9MG4c=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1774998312; c=relaxed/simple;
	bh=UwYiDA20ckY/gmbMkJs4Byw4YtsJ+mtXyK8e5y6YHlA=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=k428e7MtOg+ruvhAJL1A6hWQVcNF82/pg0JBKdVftCngCaZhbIUhX3JIxlw4HpIKvgqrOk4lEptSIw3n/rIHnt9/sBXb+drahmjqXNkqCu2SnEi5jcCOlPVuCrQ5VcVFDLmslyK4x5oxIWKYTV41b+TeRilpohCYAVKdLiTg0Yk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=jJ40NO/G; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="jJ40NO/G"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8BABEC19423;
	Tue, 31 Mar 2026 23:05:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1774998311;
	bh=UwYiDA20ckY/gmbMkJs4Byw4YtsJ+mtXyK8e5y6YHlA=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=jJ40NO/GSDMfUAKCanWuIAHVgfQdCkTWBnijKX2BAMlmHScEVTB1cyS+cNJ2CvfhM
	 EYy72Wra2TLaXTfgG4x0aMdi/u3tvmyCuCFzHfX3IjaEhOQAQBgG6lqO34o8yUFVPe
	 dNZAERNMt/QnmyVjm7RLu6eVl3vtDVLpRnd/puIVQ0uvKQNleEb9EZSNZdRgRv+L0/
	 qfidy6XZdc6IzrViKBv3c1lx8n5jrmV7cZL4CczGSazTpZk5RI2h/sg41f8Opjlm/k
	 z6WqfinStVAj44jOSblbmpjjBBM80Yr6ZQguTCVDk2qglwMtz+Otq+3HablXIQ1ptC
	 GltAUjW/ZCUkQ==
Date: Tue, 31 Mar 2026 17:05:07 -0600
From: Keith Busch <kbusch@kernel.org>
To: Aaron Tomlin <atomlin@atomlin.com>
Cc: axboe@kernel.dk, hch@lst.de, sagi@grimberg.me, mst@redhat.com,
	aacraid@microsemi.com, James.Bottomley@hansenpartnership.com,
	martin.petersen@oracle.com, liyihang9@h-partners.com,
	kashyap.desai@broadcom.com, sumit.saxena@broadcom.com,
	shivasharan.srikanteshwara@broadcom.com,
	chandrakanth.patil@broadcom.com, sathya.prakash@broadcom.com,
	sreekanth.reddy@broadcom.com, suganath-prabu.subramani@broadcom.com,
	ranjan.kumar@broadcom.com, jinpu.wang@cloud.ionos.com,
	tglx@kernel.org, mingo@redhat.com, peterz@infradead.org,
	juri.lelli@redhat.com, vincent.guittot@linaro.org,
	akpm@linux-foundation.org, maz@kernel.org, ruanjinjie@huawei.com,
	bigeasy@linutronix.de, yphbchou0911@gmail.com, wagi@kernel.org,
	frederic@kernel.org, longman@redhat.com, chenridong@huawei.com,
	hare@suse.de, kch@nvidia.com, ming.lei@redhat.com, steve@abita.co,
	sean@ashe.io, chjohnst@gmail.com, neelx@suse.com, mproche@gmail.com,
	linux-block@vger.kernel.org, linux-kernel@vger.kernel.org,
	virtualization@lists.linux.dev, linux-nvme@lists.infradead.org,
	linux-scsi@vger.kernel.org, megaraidlinux.pdl@broadcom.com,
	mpi3mr-linuxdrv.pdl@broadcom.com, MPT-FusionLinux.pdl@broadcom.com
Subject: Re: [PATCH v9 10/13] blk-mq: use hk cpus only when isolcpus=io_queue
 is enabled
Message-ID: <acxTI2CJlq3npMVa@kbusch-mbp>
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

On Mon, Mar 30, 2026 at 06:10:44PM -0400, Aaron Tomlin wrote:
> +static bool blk_mq_validate(struct blk_mq_queue_map *qmap,
> +			    const struct cpumask *active_hctx)
> +{
> +	/*
> +	 * Verify if the mapping is usable when housekeeping
> +	 * configuration is enabled
> +	 */
> +
> +	for (int queue = 0; queue < qmap->nr_queues; queue++) {
> +		int cpu;
> +
> +		if (cpumask_test_cpu(queue, active_hctx)) {
> +			/*
> +			 * This htcx has at least one online CPU thus it

Typo, should say "hctx".

> +			 * is able to serve any assigned isolated CPU.
> +			 */
> +			continue;
> +		}
> +
> +		/*
> +		 * There is no housekeeping online CPU for this hctx, all
> +		 * good as long as all non houskeeping CPUs are also

Typo, "housekeeping".

...

>  void blk_mq_map_queues(struct blk_mq_queue_map *qmap)
>  {
> -	const struct cpumask *masks;
> +	struct cpumask *masks __free(kfree) = NULL;
> +	const struct cpumask *constraint;
>  	unsigned int queue, cpu, nr_masks;
> +	cpumask_var_t active_hctx;
>  
> -	masks = group_cpus_evenly(qmap->nr_queues, &nr_masks);
> -	if (!masks) {
> -		for_each_possible_cpu(cpu)
> -			qmap->mq_map[cpu] = qmap->queue_offset;
> -		return;
> -	}
> +	if (!zalloc_cpumask_var(&active_hctx, GFP_KERNEL))
> +		goto fallback;
> +
> +	if (housekeeping_enabled(HK_TYPE_IO_QUEUE))
> +		constraint = housekeeping_cpumask(HK_TYPE_IO_QUEUE);
> +	else
> +		constraint = cpu_possible_mask;
> +
> +	/* Map CPUs to the hardware contexts (hctx) */
> +	masks = group_mask_cpus_evenly(qmap->nr_queues, constraint, &nr_masks);
> +	if (!masks)
> +		goto free_fallback;
>  
>  	for (queue = 0; queue < qmap->nr_queues; queue++) {
> -		for_each_cpu(cpu, &masks[queue % nr_masks])
> -			qmap->mq_map[cpu] = qmap->queue_offset + queue;
> +		unsigned int idx = (qmap->queue_offset + queue) % nr_masks;
> +
> +		for_each_cpu(cpu, &masks[idx]) {
> +			qmap->mq_map[cpu] = idx;

I think there's something off with this when we have multiple queue maps. The
wrapping loses the offset when we've isolated CPUs, so I think the index would
end up incorrect.

Trying this series out when "nvme.poll_queues=2" with isolcpus set, I am
getting a kernel panic:

 nvme nvme0: 8/0/2 default/read/poll queues
 BUG: unable to handle page fault for address: ffff889101898da0
 #PF: supervisor read access in kernel mode
 #PF: error_code(0x0000) - not-present page
 PGD 4e01067 P4D 4e01067 PUD 0
 Oops: Oops: 0000 [#1] SMP PTI
 CPU: 11 UID: 0 PID: 201 Comm: kworker/u64:19 Not tainted 7.0.0-rc4-00222-g065cad526374 #1586 PREEMPT
 Hardware name: QEMU Standard PC (Q35 + ICH9, 2009), BIOS rel-1.17.0-0-gb52ca86e094d-prebuilt.qemu.org 04/01/2014
 Workqueue: async async_run_entry_fn
 RIP: 0010:nvme_init_hctx_common+0x6f/0x190 [nvme]
 Code: 85 78 01 00 00 0f 85 86 00 00 00 45 8b b5 88 01 00 00 4c 89 f0 4d 89 f1 48 c1 e0 04 49 89 c7 4c 8d 94 03 38 0b 00 00 49 01 df <49> 83 bf 40 0b 00 00 00 74 64 44 89 d0 49 81 fa 00 f0 ff ff 77 27
 RSP: 0018:ffffc9000083ba90 EFLAGS: 00010286
 RAX: 0000000ffffffff0 RBX: ffff888101898270 RCX: ffffffffa008bd40
 RDX: 0000000000000008 RSI: ffff888101898270 RDI: ffff888101900800
 RBP: ffffc9000083bac8 R08: 0000000000000060 R09: 00000000ffffffff
 R10: ffff889101898d98 R11: ffff888101ddf000 R12: ffff8881087f36c0
 R13: ffff888101900800 R14: 00000000ffffffff R15: ffff889101898260
 FS:  0000000000000000(0000) GS:ffff8890bb50a000(0000) knlGS:0000000000000000
 CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
 CR2: ffff889101898da0 CR3: 0000000101fe8001 CR4: 0000000000770ef0
 PKRU: 55555554
 Call Trace:
  <TASK>
  blk_mq_alloc_and_init_hctx+0x11e/0x3a0
  __blk_mq_realloc_hw_ctxs+0x185/0x220
  blk_mq_init_allocated_queue+0xeb/0x3b0
  ? percpu_ref_init+0x6a/0x130
  blk_mq_alloc_queue+0x7a/0xd0
  __blk_mq_alloc_disk+0x14/0x60
  nvme_alloc_ns+0xac/0xb30 [nvme_core]
  ? blk_mq_run_hw_queue+0x117/0x270
  nvme_scan_ns+0x279/0x350 [nvme_core]
  async_run_entry_fn+0x2e/0x130
  process_one_work+0x16c/0x3a0
  worker_thread+0x173/0x2e0
  ? __pfx_worker_thread+0x10/0x10
  kthread+0xe0/0x120
  ? __pfx_kthread+0x10/0x10
  ret_from_fork+0x207/0x270
  ? __pfx_kthread+0x10/0x10
  ret_from_fork_asm+0x1a/0x30
  </TASK>
