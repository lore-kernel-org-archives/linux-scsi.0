From: Jens Axboe <axboe@kernel.dk>
Subject: Re: Another (ESP?) scsi blk-mq problem on sparc64
Date: Fri, 14 Nov 2014 16:29:39 -0700
Message-ID: <54669063.6050307@kernel.dk>
References: <alpine.LRH.2.11.1411141302270.26966@adalberg.ut.ee> <20141114165804.GA14631@infradead.org> <alpine.LRH.2.11.1411142114200.26813@adalberg.ut.ee> <54665B30.4070708@kernel.dk> <alpine.LRH.2.11.1411150033400.26813@adalberg.ut.ee>
Mime-Version: 1.0
Content-Type: multipart/mixed;
 boundary="------------090808060601010900080603"
Return-path: <sparclinux-owner@vger.kernel.org>
In-Reply-To: <alpine.LRH.2.11.1411150033400.26813@adalberg.ut.ee>
Sender: sparclinux-owner@vger.kernel.org
To: Meelis Roos <mroos@linux.ee>
Cc: Christoph Hellwig <hch@infradead.org>, linux-scsi@vger.kernel.org, sparclinux@vger.kernel.org, David Miller <davem@davemloft.net>, "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
List-Id: linux-scsi@vger.kernel.org

This is a multi-part message in MIME format.
--------------090808060601010900080603
Content-Type: text/plain; charset=windows-1252; format=flowed
Content-Transfer-Encoding: 7bit

On 2014-11-14 15:59, Meelis Roos wrote:
>>>> The second oops is in blk_mq_map_queue() which is a trivial
>>>> two level cpu lookup.  I wonder if there's something odd about
>>>> cpu numbers on these big old sparc systems?
>>>
>>> CPU numbers are sparse - they are determined by hardware slot number and
>>> some models only fill every other mainboard slot, and first slots can be
>>> free. I have first board offline and currently have CPUs numbered
>>> 10,11,14,15 online.
>>>
>>> Here is debug with Jens's patch:
>>
>>> [  133.971050] CPU 11: synchronized TICK with master CPU (last diff -1 cycles, maxerr 516 cycles)
>>> [  133.975491] CPU 14: synchronized TICK with master CPU (last diff -3 cycles, maxerr 531 cycles)
>>> [  133.979943] CPU 15: synchronized TICK with master CPU (last diff -3 cycles, maxerr 531 cycles)
>>> [  133.980146] Brought up 4 CPUs
>>
>> So this looks like this might be the issue. On a scsi-mq disabled boot,
>> you have 4 CPUs, but how are they numbered?
>
> The numbers are always the same.

I would hope so, my question was really on what CPU numbers you see. But 
I guess that 10, 11, 14, and 15?

> But everything seems to be mapped to queue 0?

As it should, scsi-mq only supports a single hw queue for now.

>> We might need Christophs debug patch on top this to fully know...
>
> Applied it too, dmesg is below. Yes it does spam the log a lot, and over
> 9600bps console its' somewhat slow :)
>
> There is another detail to note  -this server contains a faulty disk as
> sdc that times out spinup. I left it in the server because it helped to
> pinpoint and fix a previous error in esp scsi driver. This can be a
> factor here too - the error handling details.

It could be. So we have tons of mappings from CPU10 to queue 0, but then 
we see this:

> [  256.236742] cpu: 10
> [  256.236749] queue: 809119744

and it turns to crap. This is pretty weird. Try with this debug patch - 
get rid of the other ones first. It should reduce your noise level too.

-- 
Jens Axboe


--------------090808060601010900080603
Content-Type: text/x-patch;
 name="debug.patch"
Content-Transfer-Encoding: 7bit
Content-Disposition: attachment;
 filename="debug.patch"

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
diff --git a/block/blk-mq.c b/block/blk-mq.c
index 68929bad9a6a..1678da3505ea 100644
--- a/block/blk-mq.c
+++ b/block/blk-mq.c
@@ -1265,12 +1265,25 @@ run_queue:
 	blk_mq_put_ctx(data.ctx);
 }
 
+static int did_warn;
+
 /*
  * Default mapping to a software queue, since we use one per CPU.
  */
 struct blk_mq_hw_ctx *blk_mq_map_queue(struct request_queue *q, const int cpu)
 {
-	return q->queue_hw_ctx[q->mq_map[cpu]];
+	int i;
+
+	i = q->mq_map[cpu];
+	if (!i || did_warn)
+		return q->queue_hw_ctx[0];
+
+	printk(KERN_ERR "blk-mq: cpu %u got queue %u\n", cpu, i);
+	for_each_online_cpu(i)
+		printk(KERN_ERR "  cpu%d -> queue index %u\n", i, q->mq_map[i]);
+
+	did_warn = 1;
+	return q->queue_hw_ctx[0];
 }
 EXPORT_SYMBOL(blk_mq_map_queue);
 

--------------090808060601010900080603--
