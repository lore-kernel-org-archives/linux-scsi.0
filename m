From: Jens Axboe <axboe@kernel.dk>
Subject: Re: [PATCH v2 01/12] blk-mq: Use all available hardware queues
Date: Tue, 07 Oct 2014 08:37:03 -0600
Message-ID: <5433FA8F.3050100@kernel.dk>
References: <5433E43D.3010107@acm.org> <5433E473.4020102@acm.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-pa0-f47.google.com ([209.85.220.47]:38770 "EHLO
	mail-pa0-f47.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753921AbaJGOhH (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Tue, 7 Oct 2014 10:37:07 -0400
Received: by mail-pa0-f47.google.com with SMTP id rd3so7312050pab.34
        for <linux-scsi@vger.kernel.org>; Tue, 07 Oct 2014 07:37:07 -0700 (PDT)
In-Reply-To: <5433E473.4020102@acm.org>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Bart Van Assche <bvanassche@acm.org>, Christoph Hellwig <hch@infradead.org>
Cc: Sagi Grimberg <sagig@mellanox.com>, Sebastian Parschauer <sebastian.riemer@profitbricks.com>, Robert Elliott <Elliott@hp.com>, Ming Lei <ming.lei@canonical.com>, "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>, linux-rdma <linux-rdma@vger.kernel.org>

On 10/07/2014 07:02 AM, Bart Van Assche wrote:
> Suppose that a system has two CPU sockets, three cores per socket,
> that it does not support hyperthreading and that four hardware
> queues are provided by a block driver. With the current algorithm
> this will lead to the following assignment of CPU cores to hardware
> queues:
> 
>   HWQ 0: 0 1
>   HWQ 1: 2 3
>   HWQ 2: 4 5
>   HWQ 3: (none)
> 
> This patch changes the queue assignment into:
> 
>   HWQ 0: 0 1
>   HWQ 1: 2
>   HWQ 2: 3 4
>   HWQ 3: 5
> 
> In other words, this patch has the following three effects:
> - All four hardware queues are used instead of only three.
> - CPU cores are spread more evenly over hardware queues. For the
>   above example the range of the number of CPU cores associated
>   with a single HWQ is reduced from [0..2] to [1..2].
> - If the number of HWQ's is a multiple of the number of CPU sockets
>   it is now guaranteed that all CPU cores associated with a single
>   HWQ reside on the same CPU socket.
> 
> Signed-off-by: Bart Van Assche <bvanassche@acm.org>
> Reviewed-by: Sagi Grimberg <sagig@mellanox.com>
> Cc: Jens Axboe <axboe@fb.com>
> Cc: Christoph Hellwig <hch@lst.de>
> Cc: Ming Lei <ming.lei@canonical.com>
> ---
>  block/blk-mq-cpumap.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/block/blk-mq-cpumap.c b/block/blk-mq-cpumap.c
> index 1065d7c..8e56455 100644
> --- a/block/blk-mq-cpumap.c
> +++ b/block/blk-mq-cpumap.c
> @@ -17,7 +17,7 @@
>  static int cpu_to_queue_index(unsigned int nr_cpus, unsigned int nr_queues,
>  			      const int cpu)
>  {
> -	return cpu / ((nr_cpus + nr_queues - 1) / nr_queues);
> +	return cpu * nr_queues / nr_cpus;
>  }
>  
>  static int get_first_sibling(unsigned int cpu)

Lets do this separate, as explained last time, it needs to be evaluated
on its own and doesn't really belong in this series of patches.

-- 
Jens Axboe

