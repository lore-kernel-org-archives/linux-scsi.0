From: Jens Axboe <axboe@suse.de>
Subject: Re: possible use-after-free in 2.5.44 scsi changes
Date: Sun, 27 Oct 2002 22:54:33 +0100
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <20021027215433.GA30429@suse.de>
References: <20021027212035.GM3966@suse.de> <200210272137.g9RLbW413689@localhost.localdomain>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <200210272137.g9RLbW413689@localhost.localdomain>
List-Id: linux-scsi@vger.kernel.org
To: James Bottomley <James.Bottomley@steeleye.com>
Cc: Badari Pulavarty <pbadari@us.ibm.com>, Andrew Morton <akpm@digeo.com>, "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>, "Martin J. Bligh" <Martin.Bligh@us.ibm.com>, Doug Ledford <dledford@redhat.com>

On Sun, Oct 27 2002, James Bottomley wrote:
> axboe@suse.de said:
> > Sure that would suffice, but lets just move to the prep approach right
> > away. First just the global one, later we can do one per device type. 
> 
> OK, will do.  SCSI currently needs the ability to bail on a request 
> preparation in such a way that the request will get re-queued for preparation 
> (out of command blocks or other resource shortage), which I believe you're 
> working on.

Oh sorry, just forgot to send that out. The change needed for this is
very small. Basically, in blkdev.h, add these types:

#define BLKPREP_OK              0       /* serve it */
#define BLKPREP_KILL            1       /* fatal error, kill */
#define BLKPREP_DEFER           2       /* leave on queue */

I've attached the elv_next_request(), sorry about this format but my
tree is just severly crowded with changes in the block area right now so
it's hard to diff.

Now you can just return BLKPREP_DEFER from the prep function, and it
should do what you want. We might need a bit more logic in there, mainly
to cover the case where we deferred the only request on the queue (your
usual plugging thing). Or I might leave that to the driver, dunno. But
at least this small change should make it possible for you to test.

> The per device type is more tricky because SCSI can have more than one
> upper level driver driving the device queue.

I was thinking more of doing device-type things, such as making the
sector into lba, rejecting write command on ro media, copy actual scsi
command, etc. But that might just fit into a generic function. And it
means we can basically kill the ->init_command() functions.

struct request *elv_next_request(request_queue_t *q)
{
	struct request *rq;
	int ret;

	while ((rq = __elv_next_request(q))) {
		/*
		 * just mark as started even if we don't start it, a request
		 * that has been delayed should not be passed by new incoming
		 * requests
		 */
		rq->flags |= REQ_STARTED;

		if (&rq->queuelist == q->last_merge)
			q->last_merge = NULL;

		if ((rq->flags & REQ_DONTPREP) || !q->prep_rq_fn)
			break;

		ret = q->prep_rq_fn(q, rq);
		if (ret == BLKPREP_OK) {
			break;
		} else if (ret == BLKPREP_DEFER) {
			rq = NULL;
			break;
		} else if (ret == BLKPREP_KILL) {
			blkdev_dequeue_request(rq);
			rq->flags |= REQ_QUIET;
			while (end_that_request_first(rq, 0, rq->nr_sectors))
				;
			end_that_request_last(rq);
		} else {
			printk("%s: bad return=%d\n", __FUNCTION__, ret);
			break;
		}
	}

	return rq;
}

-- 
Jens Axboe

