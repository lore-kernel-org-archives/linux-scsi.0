From: "Nicholas A. Bellinger" <nab@linux-iscsi.org>
Subject: Re: [PATCH RESEND 0/1] AHCI: Optimize interrupt processing
Date: Thu, 15 Aug 2013 19:19:29 -0700
Message-ID: <1376619569.5171.217.camel@haakon3.risingtidesystems.com>
References: <1374193399.7397.973.camel@haakon3.risingtidesystems.com>
	 <20130719003034.GG28005@kernel.dk>
	 <1374195825.7397.997.camel@haakon3.risingtidesystems.com>
	 <1374215660.7397.1041.camel@haakon3.risingtidesystems.com>
	 <1374248000.2266.20.camel@dabdike>
	 <1374267684.7397.1058.camel@haakon3.risingtidesystems.com>
	 <1374296162.7397.1098.camel@haakon3.risingtidesystems.com>
	 <51EAA33C.9010405@fusionio.com>
	 <20130809191542.GD25306@dhcp-26-207.brq.redhat.com>
	 <1376079457.5171.172.camel@haakon3.risingtidesystems.com>
	 <20130815162316.GA27882@dhcp-26-207.brq.redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-ide-owner@vger.kernel.org>
In-Reply-To: <20130815162316.GA27882@dhcp-26-207.brq.redhat.com>
Sender: linux-ide-owner@vger.kernel.org
To: Alexander Gordeev <agordeev@redhat.com>
Cc: Mike Christie <mchristie@fusionio.com>, James Bottomley <James.Bottomley@HansenPartnership.com>, Jens Axboe <axboe@kernel.dk>, Tejun Heo <tj@kernel.org>, linux-kernel@vger.kernel.org, linux-ide@vger.kernel.org, Jeff Garzik <jgarzik@pobox.com>, linux-scsi <linux-scsi@vger.kernel.org>
List-Id: linux-scsi@vger.kernel.org

On Thu, 2013-08-15 at 18:23 +0200, Alexander Gordeev wrote:
> On Fri, Aug 09, 2013 at 01:17:37PM -0700, Nicholas A. Bellinger wrote:
> > On Fri, 2013-08-09 at 21:15 +0200, Alexander Gordeev wrote:
> > Mmmm, I'm able to reproduce over here with ahci + scsi-mq, and it
> > appears to be a bug related with using sdev->sdev_md_req.queue_depth=1,
> > that ends up causing the blkdev_issue_flush() to wait forever because
> > blk_mq_wait_for_tags() never ends up getting the single tag back for the
> > WRITE_FLUSH bio -> SYNCHRONIZE_CACHE cdb.
> 
> It turns out this way - blkdev_issue_flush() claims the only tag, submits
> the bio and waits for the completion. But because blk_mq_make_request()
> does not mark any context in blk_mq_hw_ctx::ctx_map (nor enslists the request
> into blk_mq_ctx::rq_list) it never gets processed from blk_mq_work_fn->
> __blk_mq_run_hw_queue() and blkdev_issue_flush() waits endlessly. All other
> requests are just waiting for the tag availability as result.
> 

Ok, here's a bit better idea of what is going on now..

The problem is that blkdev_issue_flush() -> blk_mq_make_request() ->
__blk_mq_alloc_request() allocates the first tag, which calls
blk_insert_flush() -> blk_flush_complete_seq() -> blk_flush_kick() ->
mq_flush_work() -> blk_mq_alloc_request() to allocate a second tag for
the struct request that actually gets dispatched into scsi-mq as a
SYCHRONIZE_CACHE command..

I'm not exactly sure why this double tag usage of struct request is
occurring, but AFAICT it does happen for every flush, and is not
specific to the blkdev_issue_flush() codepath..  I'm sure that Jens can
fill us in on that bit.  ;)

So, assuming that this double tag usage is necessary and not a bug,
perhaps using a reserved tag for the first tag (eg: the one that's not
dispatched into scsi_mq_queue_rq) makes sense..?

I'm playing with a patch to do this, but am currently getting hung-up on
what appear to be some separate blk-mq reserved_tags > 0 bugs, the first
of which is passing queue_depth=1 + reserved_tags=1 is broken, and
results in tags->nr_free = 0.

Here's the quick fix:

diff --git a/block/blk-mq-tag.c b/block/blk-mq-tag.c
index 6718007..ffdf686 100644
--- a/block/blk-mq-tag.c
+++ b/block/blk-mq-tag.c
@@ -470,7 +470,7 @@ struct blk_mq_tags *blk_mq_init_tags(unsigned int nr_tags,
 	 * Rest of the tags start at the queue list
 	 */
 	tags->nr_free = 0;
-	while (nr_tags - tags->nr_reserved) {
+	while (nr_tags) {
 		tags->freelist[tags->nr_free] = tags->nr_free +
 							tags->nr_reserved;
 		nr_tags--;

Anyways, before digging further into reserved tags logic, Jens, what are
your thoughts for addressing this special queue_depth=1 case for libata
+ the like..?

--nab

