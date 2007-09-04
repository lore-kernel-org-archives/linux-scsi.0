From: Kiyoshi Ueda <k-ueda@ct.jp.nec.com>
Subject: Re: [PATCH 1/7] blk_end_request: add new request
 completion interface
Date: Tue, 04 Sep 2007 18:23:31 -0400 (EDT)
Message-ID: <20070904.182331.88469348.k-ueda@ct.jp.nec.com>
References: <20070831.184112.45519768.k-ueda@ct.jp.nec.com>
	<20070903074545.GH4253@kernel.dk>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <20070903074545.GH4253@kernel.dk>
List-Unsubscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: jens.axboe@oracle.com
Cc: linux-scsi@vger.kernel.org, mike.miller@hp.com, linux-kernel@vger.kernel.org, grant.likely@secretlab.ca, linux-ide@vger.kernel.org, dm-devel@redhat.com
List-Id: linux-scsi@vger.kernel.org

Hi Jens,

Thank you for the comments.

On Mon, 3 Sep 2007 09:45:45 +0200, Jens Axboe <jens.axboe@oracle.com> wrote:
> > +extern int blk_end_request(struct request *rq, int uptodate, int nr_bytes);
> > +extern int __blk_end_request(struct request *rq, int uptodate, int nr_bytes);
> >  extern int end_that_request_first(struct request *, int, int);
> >  extern int end_that_request_chunk(struct request *, int, int);
> >  extern void end_that_request_last(struct request *, int);
> 
> We get in to way too many levels of underscores here. Please changes
> this to be blk_end_request() and blk_end_request_locked(), where the
> former grabs the queue lock but the latter assumes it's held. Then have
> the static __blk_end_request() where the lock MUST be held - do this in
> the caller, don't pass it as an argument!

It makes perfect sense but I have a reason I couldn't do it.

The goal of our patch set is to change the role of rq->end_io()
so that the request submitter can set its own procedure of
request completion (please see the patch 7/7).

So if the caller must hold the lock, we have to hold the lock
during the whole rq->end_io(), that includes end_that_request_first().
It would cause performance regression by making the lock held longer.
OTOH, the 'needlock' argument allows the completion handler to hold
the lock during the minimum piece of the code.

If you have any idea to fix the situation, I would appreciate it.


Below is the detailed explanation of the above.
I took your comment as below.
-----------------------------------------------------------------
static void __blk_end_request(rq, uptodate) {
	blk_queue_end_tag();
	blkdev_dequeue_request();
	end_that_request_last(rq, uptodate);
}
int blk_end_request_locked(rq, uptodate, nr_bytes) {
	if (end_that_request_first(rq, uptodate, nr_bytes))
		return 1;
	add_disk_randomness();
	__blk_end_request(rq, uptodate);
	return 0;
}
EXPORT_SYMBOL_GPL(blk_end_request_locked);
int blk_end_request(rq, uptodate, nr_bytes) {
	if (end_that_request_first(rq, uptodate, nr_bytes))
		return 1;
	add_disk_randomness();
	spin_lock_irqsave();
	__blk_end_request(rq, uptodate);
	spin_unlock_irqrestore();
	return 0;
}
EXPORT_SYMBOL_GPL(blk_end_request);
-----------------------------------------------------------------

It's quite reasonable on the patch 1/7.
But the goal of this patch-set is to allow to hook the whole request
completion procedures by a single rq->end_io() hook.
(Please see the patch 7/7 for details)
So the callee (funciton_to_be_set_in_rq_end_io() below) needs to know
whether it has the lock or not.
To prepare for the change of the patch 7/7 and avoid code duplication,
I chose passing the lock information as an argument.
-----------------------------------------------------------------
static int function_to_be_set_in_rq_end_io(rq, uptodate, nr_bytes, needlock) {
	if (end_that_request_first(rq, uptodate, nr_bytes))
		return 1;
	add_disk_randomness();
	if (needlock)
		spin_lock_irqsave();
	__blk_end_request(rq, uptodate);
	if (needlock)
		spin_unlock_irqrestore();
	return 0;
}
int blk_end_request_locked(rq, uptodate, nr_bytes) {
	if (rq->end_io)
		return rq->end_io(rq, uptodate, nr_bytes, 0);

	if (end_that_request_first(rq, uptodate, nr_bytes))
	....
}
int blk_end_request(rq, uptodate, nr_bytes) {
	if (rq->end_io)
		return rq->end_io(rq, uptodate, nr_bytes, 1);

	if (end_that_request_first(rq, uptodate, nr_bytes))
	....
}
-----------------------------------------------------------------

Thanks,
Kiyoshi Ueda
