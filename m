From: Hannes Reinecke <hare@suse.com>
Subject: Re: [PATCH 1/2] block: Implement global tagset
Date: Thu, 6 Apr 2017 10:49:34 +0200
Message-ID: <b80f5b80-4b4f-279f-379e-c1d74be7fc7c@suse.com>
References: <1491307665-47656-1-git-send-email-hare@suse.de>
 <1491307665-47656-2-git-send-email-hare@suse.de>
 <alpine.LRH.2.00.1704052257580.727@mvluser05.qlc.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 8bit
Return-path: <linux-block-owner@vger.kernel.org>
In-Reply-To: <alpine.LRH.2.00.1704052257580.727@mvluser05.qlc.com>
Sender: linux-block-owner@vger.kernel.org
To: Arun Easi <arun.easi@cavium.com>, Hannes Reinecke <hare@suse.de>
Cc: Jens Axboe <axboe@kernel.dk>, Omar Sandoval <osandov@fb.com>, "Martin K. Petersen" <martin.petersen@oracle.com>, James Bottomley <james.bottomley@hansenpartnership.com>, Christoph Hellwig <hch@lst.de>, Bart van Assche <bart.vanassche@sandisk.com>, linux-block@vger.kernel.org, linux-scsi@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org

On 04/06/2017 08:27 AM, Arun Easi wrote:
> Hi Hannes,
> 
> Thanks for taking a crack at the issue. My comments below..
> 
> On Tue, 4 Apr 2017, 5:07am, Hannes Reinecke wrote:
> 
>> Most legacy HBAs have a tagset per HBA, not per queue. To map
>> these devices onto block-mq this patch implements a new tagset
>> flag BLK_MQ_F_GLOBAL_TAGS, which will cause the tag allocator
>> to use just one tagset for all hardware queues.
>>
>> Signed-off-by: Hannes Reinecke <hare@suse.com>
>> ---
>>  block/blk-mq-tag.c     | 12 ++++++++----
>>  block/blk-mq.c         | 10 ++++++++--
>>  include/linux/blk-mq.h |  1 +
>>  3 files changed, 17 insertions(+), 6 deletions(-)
>>
>> diff --git a/block/blk-mq-tag.c b/block/blk-mq-tag.c
>> index e48bc2c..a14e76c 100644
>> --- a/block/blk-mq-tag.c
>> +++ b/block/blk-mq-tag.c
>> @@ -276,9 +276,11 @@ static void blk_mq_all_tag_busy_iter(struct blk_mq_tags *tags,
>>  void blk_mq_tagset_busy_iter(struct blk_mq_tag_set *tagset,
>>  		busy_tag_iter_fn *fn, void *priv)
>>  {
>> -	int i;
>> +	int i, lim = tagset->nr_hw_queues;
>>  
>> -	for (i = 0; i < tagset->nr_hw_queues; i++) {
>> +	if (tagset->flags & BLK_MQ_F_GLOBAL_TAGS)
>> +		lim = 1;
>> +	for (i = 0; i < lim; i++) {
>>  		if (tagset->tags && tagset->tags[i])
>>  			blk_mq_all_tag_busy_iter(tagset->tags[i], fn, priv);
>>  	}
>> @@ -287,12 +289,14 @@ void blk_mq_tagset_busy_iter(struct blk_mq_tag_set *tagset,
>>  
>>  int blk_mq_reinit_tagset(struct blk_mq_tag_set *set)
>>  {
>> -	int i, j, ret = 0;
>> +	int i, j, ret = 0, lim = set->nr_hw_queues;
>>  
>>  	if (!set->ops->reinit_request)
>>  		goto out;
>>  
>> -	for (i = 0; i < set->nr_hw_queues; i++) {
>> +	if (set->flags & BLK_MQ_F_GLOBAL_TAGS)
>> +		lim = 1;
>> +	for (i = 0; i < lim; i++) {
>>  		struct blk_mq_tags *tags = set->tags[i];
>>  
>>  		for (j = 0; j < tags->nr_tags; j++) {
>> diff --git a/block/blk-mq.c b/block/blk-mq.c
>> index 159187a..db96ed0 100644
>> --- a/block/blk-mq.c
>> +++ b/block/blk-mq.c
>> @@ -2061,6 +2061,10 @@ static bool __blk_mq_alloc_rq_map(struct blk_mq_tag_set *set, int hctx_idx)
>>  {
>>  	int ret = 0;
>>  
>> +	if ((set->flags & BLK_MQ_F_GLOBAL_TAGS) && hctx_idx != 0) {
>> +		set->tags[hctx_idx] = set->tags[0];
>> +		return true;
>> +	}
> 
> So, this effectively make all request allocations to the same NUMA node 
> locality of the hctx_idx 0, correct? Is the performance hit you were 
> talking about in the cover letter?
> 
Yes. It does make the request allocations local to NUMA node 0, but then
this will only affect LLDDs which are actually _using_ NUMA locality
when allocating the request nodes.
However, SCSI doesn't set a NUMA node locality to begin with, so this
doesn't affect us.

No, what I meant is this:
the 'sbitmap' allocator already splits up the bitmap into several words,
which then should provide a better NUMA locality per map.
When we're using a shared global map it's unclear whether the individual
words of the sbitmap can and will be moved to the various NUMA nodes, or
whether we suffer from non-locality.

My tests so far have been inconclusive; but then I'm not happy with the
testcase anyway (using null_blk I only get 250k/250k r/w IOPs, which I
found rather disappointing).

> Do you have any other alternatives in mind? Dynamic growing/shrinking 
> tags/request-pool in hctx with a fixed base as start?
> 
> One alternative that comes to my mind is to move the divvy up logic to 
> SCSI (instead of LLD doing it), IOW:
> 
> 1. Have SCSI set tag_set.queue_depth to can_queue/nr_hw_queues
> 2. Have blk_mq_unique_tag() (or a new i/f) returning "hwq * nr_hw_queue + 
>    rq->tag"
> 
> That would make the tags linear in the can_queue space, but could result 
> in poor use of LLD resource if a given hctx has used up all it's tags.
> 
Exactly. This is the method I used for implementing mq support for lpfc
and mpt3sas; however the complaint there indeed was that we might be
running into a tag starvation scenario with a large number of LUNs and
single-threaded I/O submission.

> On a related note, would not the current use of can_queue in SCSI lead to 
> poor resource utilization in MQ cases? Like, block layer allocating 
> nr_hw_queues * tags+request+driver_data.etc * can_queue, but SCSI limiting 
> the number of requests to can_queue.
> 
Yes, indeed. That's another problem which we should be looking at.
However, it's only ever relevant if we indeed implement some divvying
logic; if we move to the shared tags approach it should work as designed.

> BTW, if you would like me to try out this patch on my setup, please let me 
> know.
> 
Oh, yes. Please do.

Cheers,

Hannes
-- 
Dr. Hannes Reinecke		               zSeries & Storage
hare@suse.com			               +49 911 74053 688
SUSE LINUX GmbH, Maxfeldstr. 5, 90409 Nürnberg
GF: F. Imendörffer, J. Smithard, D. Upmanyu, G. Norton
HRB 21284 (AG Nürnberg)
