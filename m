From: Jens Axboe <axboe@kernel.dk>
Subject: Re: Another (ESP?) scsi blk-mq problem on sparc64
Date: Thu, 29 Jan 2015 08:37:51 -0800
Message-ID: <54CA61DF.30807@kernel.dk>
References: <20141124162249.GG5050@linux.vnet.ibm.com> <547367DF.5060706@kernel.dk> <alpine.LRH.2.11.1411250022470.31497@siim2.ut.ee> <20141124.172857.1186013178918344826.davem@davemloft.net> <alpine.LRH.2.11.1501290952340.25245@math.ut.ee>
Mime-Version: 1.0
Content-Type: multipart/mixed;
 boundary="------------090800070602080809090603"
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-ie0-f172.google.com ([209.85.223.172]:48037 "EHLO
	mail-ie0-f172.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752830AbbA2QiK (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Thu, 29 Jan 2015 11:38:10 -0500
Received: by mail-ie0-f172.google.com with SMTP id rd18so35470361iec.3
        for <linux-scsi@vger.kernel.org>; Thu, 29 Jan 2015 08:38:08 -0800 (PST)
In-Reply-To: <alpine.LRH.2.11.1501290952340.25245@math.ut.ee>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Meelis Roos <mroos@linux.ee>, David Miller <davem@davemloft.net>
Cc: paulmck@linux.vnet.ibm.com, hch@infradead.org, linux-scsi@vger.kernel.org, sparclinux@vger.kernel.org

This is a multi-part message in MIME format.
--------------090800070602080809090603
Content-Type: text/plain; charset=windows-1252; format=flowed
Content-Transfer-Encoding: 7bit

On 01/28/2015 11:53 PM, Meelis Roos wrote:
> On Mon, 24 Nov 2014, David Miller wrote:
>
>> From: mroos@linux.ee
>> Date: Tue, 25 Nov 2014 00:23:20 +0200 (EET)
>>
>>>>>>> Yes, that does look like the case.  Do you have a good trick on how
>>>>>>> to allocate a map for the highest possible cpu number without first
>>>>>>> iterating the cpu map?  I couldn't find something that looks like a
>>>>>>> highest_possible_cpu() helper.
>>>>>>
>>>>>> Honestly I think that num_posible_cpus() should return the max of
>>>>>> number of CPUs (weigt), and the highest numbered CPU. It's a pain in
>>>>>> the butt to handle this otherwise.
>>>>>
>>>>> Hear, hear!!!  That would make my life easier, and would make this sort
>>>>> of problem much less likely to occur!
>>>>
>>>> How about this one?
>>>
>>> It make the machine work.
>>
>> Thanks for testing!
>>
>
> What's the status of this fix? It is still not applied on yesterdays
> 3.19.0-rc6-00105-gc59c961 git...

Hmm, I thought commit a33c1ba29138 took care of it... Does the attached 
work?

-- 
Jens Axboe


--------------090800070602080809090603
Content-Type: text/x-patch;
 name="map-sz.patch"
Content-Transfer-Encoding: 7bit
Content-Disposition: attachment;
 filename="map-sz.patch"

diff --git a/block/blk-mq-cpumap.c b/block/blk-mq-cpumap.c
index 5f13f4d0bcce..527d315dc1a5 100644
--- a/block/blk-mq-cpumap.c
+++ b/block/blk-mq-cpumap.c
@@ -88,10 +88,11 @@ int blk_mq_update_queue_map(unsigned int *map, unsigned int nr_queues)
 unsigned int *blk_mq_make_queue_map(struct blk_mq_tag_set *set)
 {
 	unsigned int *map;
+	size_t sz;
 
 	/* If cpus are offline, map them to first hctx */
-	map = kzalloc_node(sizeof(*map) * nr_cpu_ids, GFP_KERNEL,
-				set->numa_node);
+	sz = max_t(unsigned int, nr_cpu_ids, num_possible_cpus());
+	map = kzalloc_node(sizeof(*map) * sz, GFP_KERNEL, set->numa_node);
 	if (!map)
 		return NULL;
 

--------------090800070602080809090603--
