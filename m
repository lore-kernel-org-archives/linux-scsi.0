From: Jens Axboe <axboe@kernel.dk>
Subject: Re: Another (ESP?) scsi blk-mq problem on sparc64
Date: Fri, 14 Nov 2014 10:01:05 -0700
Message-ID: <54663551.8080500@kernel.dk>
References: <alpine.LRH.2.11.1411141302270.26966@adalberg.ut.ee> <20141114165804.GA14631@infradead.org>
Mime-Version: 1.0
Content-Type: multipart/mixed;
 boundary="------------090504000409080003030606"
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-pa0-f54.google.com ([209.85.220.54]:44661 "EHLO
	mail-pa0-f54.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933486AbaKNRBH (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Fri, 14 Nov 2014 12:01:07 -0500
Received: by mail-pa0-f54.google.com with SMTP id hz1so6750627pad.27
        for <linux-scsi@vger.kernel.org>; Fri, 14 Nov 2014 09:01:06 -0800 (PST)
In-Reply-To: <20141114165804.GA14631@infradead.org>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Christoph Hellwig <hch@infradead.org>, Meelis Roos <mroos@linux.ee>
Cc: linux-scsi@vger.kernel.org, sparclinux@vger.kernel.org, David Miller <davem@davemloft.net>, "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>

This is a multi-part message in MIME format.
--------------090504000409080003030606
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 7bit

On 11/14/2014 09:58 AM, Christoph Hellwig wrote:
> Paul, what's the best way to figure out these CPU stalls?
> 
> The second oops is in blk_mq_map_queue() which is a trivial
> two level cpu lookup.  I wonder if there's something odd about
> cpu numbers on these big old sparc systems?
> 
> Something like the debug patch below might shed some light on where the
> index goes wrong, but it'll be horribly verbose.
> 
> 
> diff --git a/block/blk-mq.c b/block/blk-mq.c
> index b5896d4..ef4b35b 100644
> --- a/block/blk-mq.c
> +++ b/block/blk-mq.c
> @@ -1270,7 +1270,12 @@ run_queue:
>   */
>  struct blk_mq_hw_ctx *blk_mq_map_queue(struct request_queue *q, const int cpu)
>  {
> -	return q->queue_hw_ctx[q->mq_map[cpu]];
> +	int idx;
> +
> +	printk("cpu: %d\n", cpu);
> +	idx = q->mq_map[cpu];
> +	printk("queue: %d\n", idx);
> +	return q->queue_hw_ctx[idx];
>  }
>  EXPORT_SYMBOL(blk_mq_map_queue);

It'd probably be better to shove this debug stuff into the map building
code instead, ala attached.

-- 
Jens Axboe


--------------090504000409080003030606
Content-Type: text/x-patch;
 name="mapdump.patch"
Content-Transfer-Encoding: 7bit
Content-Disposition: attachment;
 filename="mapdump.patch"

diff --git a/block/blk-mq-cpumap.c b/block/blk-mq-cpumap.c
index 1065d7c65fa1..9200e2aee746 100644
--- a/block/blk-mq-cpumap.c
+++ b/block/blk-mq-cpumap.c
@@ -81,6 +81,9 @@ int blk_mq_update_queue_map(unsigned int *map, unsigned int nr_queues)
 			map[i] = map[first_sibling];
 	}
 
+	for (i = 0; i < queue; i++)
+		printk(KERN_ERR "cpumap %d -> %d\n", i, map[i]);
+
 	free_cpumask_var(cpus);
 	return 0;
 }

--------------090504000409080003030606--
