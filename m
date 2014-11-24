From: Jens Axboe <axboe@kernel.dk>
Subject: Re: Another (ESP?) scsi blk-mq problem on sparc64
Date: Mon, 24 Nov 2014 08:35:46 -0700
Message-ID: <54735052.7020807@kernel.dk>
References: <alpine.LRH.2.11.1411150829190.26813@adalberg.ut.ee> <546771B4.1010507@kernel.dk> <20141120060135.GA2862@infradead.org> <20141121.145600.2001813891553289235.davem@davemloft.net> <20141124082132.GA22971@infradead.org>
Mime-Version: 1.0
Content-Type: multipart/mixed;
 boundary="------------080403080705040603080104"
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-pd0-f178.google.com ([209.85.192.178]:49599 "EHLO
	mail-pd0-f178.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751758AbaKXPfs (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Mon, 24 Nov 2014 10:35:48 -0500
Received: by mail-pd0-f178.google.com with SMTP id g10so7728270pdj.37
        for <linux-scsi@vger.kernel.org>; Mon, 24 Nov 2014 07:35:48 -0800 (PST)
In-Reply-To: <20141124082132.GA22971@infradead.org>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Christoph Hellwig <hch@infradead.org>, David Miller <davem@davemloft.net>
Cc: mroos@linux.ee, linux-scsi@vger.kernel.org, sparclinux@vger.kernel.org, paulmck@linux.vnet.ibm.com

This is a multi-part message in MIME format.
--------------080403080705040603080104
Content-Type: text/plain; charset=windows-1252; format=flowed
Content-Transfer-Encoding: 7bit

On 11/24/2014 01:21 AM, Christoph Hellwig wrote:
> On Fri, Nov 21, 2014 at 02:56:00PM -0500, David Miller wrote:
>> I would suggest looking into the possibility that we allocate the memory
>> using the count of valid cpus, rather than the largest cpu number.
>>
>> That's a common error that runs into problems with discontiguous
>> cpu numbering like Sparc sometimes has.
>
> Yes, that does look like the case.  Do you have a good trick on how
> to allocate a map for the highest possible cpu number without first
> iterating the cpu map?  I couldn't find something that looks like a
> highest_possible_cpu() helper.

Honestly I think that num_posible_cpus() should return the max of number 
of CPUs (weigt), and the highest numbered CPU. It's a pain in the butt 
to handle this otherwise.

/* If cpus are offline, map them to first hctx */
map = kzalloc_node(sizeof(*map) * num_possible_cpus(), GFP_KERNEL,
                                 set->numa_node);

is where it goes wrong, assuming Meelis has NR_CPUS set to something < 
14, which was the highest numbered CPU, iirc. A construct like:

map = alloc(num_possible_cpus());
for_each_possible_cpu(i)
     map[i] = ...

seems like the obvious way to do things, yet it's broken. And not broken 
on x86 where we'd find the issue pretty quickly, but on sparc64 where 
it'll take a lot longer to run into. It just violates the principle of 
least surprise, which is bad for an API.

That said, if there was a helper like Christoph suggested, it'd be a bit 
better. And perhaps we can't just modify num_possible_cpus(), we'd need 
num_*_cpus() for the other bitmaps, too. That might be breaking other 
things...

Meelis, can you try the attached?

-- 
Jens Axboe


--------------080403080705040603080104
Content-Type: text/x-patch;
 name="cpu-pos-count.patch"
Content-Transfer-Encoding: 7bit
Content-Disposition: attachment;
 filename="cpu-pos-count.patch"

diff --git a/block/blk-mq-cpumap.c b/block/blk-mq-cpumap.c
index 1065d7c65fa1..15da9cc08f64 100644
--- a/block/blk-mq-cpumap.c
+++ b/block/blk-mq-cpumap.c
@@ -87,10 +87,14 @@ int blk_mq_update_queue_map(unsigned int *map, unsigned int nr_queues)
 
 unsigned int *blk_mq_make_queue_map(struct blk_mq_tag_set *set)
 {
+	unsigned int max_cpus;
 	unsigned int *map;
 
+	for_each_possible_cpu(max_cpus)
+		;
+
 	/* If cpus are offline, map them to first hctx */
-	map = kzalloc_node(sizeof(*map) * num_possible_cpus(), GFP_KERNEL,
+	map = kzalloc_node(sizeof(*map) * max_cpus, GFP_KERNEL,
 				set->numa_node);
 	if (!map)
 		return NULL;

--------------080403080705040603080104--
