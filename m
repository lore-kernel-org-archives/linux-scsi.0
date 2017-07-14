From: Christoph Hellwig <hch@lst.de>
Subject: Re: [for-4.14 RFC PATCH 1/2] dm rq: avoid deadlock if
	dm-mq is	stacked on old .request_fn device(s)
Date: Fri, 14 Jul 2017 09:22:50 +0200
Message-ID: <20170714072250.GC17046@lst.de>
References: <20170713211217.52361-1-snitzer@redhat.com>
	<20170713211217.52361-2-snitzer@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
Content-Disposition: inline
In-Reply-To: <20170713211217.52361-2-snitzer@redhat.com>
List-Unsubscribe: <https://www.redhat.com/mailman/options/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: Mike Snitzer <snitzer@redhat.com>
Cc: linux-block@vger.kernel.org, dm-devel@redhat.com, hch@lst.de, linux-scsi@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org

The problem here is the following:

blk_finish_request must always be called with the queue lock held,
it even has an assert.

Without blk-mq used by dm-rq, dm uses the block softirq to execute the
completion, which means we always have a different execution context and
can take the queue lock again without issuesi.

With blk-mq used by dm-rq, the the dm .complete handler that is the rough
equivalent of the softirq handler is called either directly if were are
on the same CPU, or using a IPI (hardirq) if not.  If this handler gets
called from a legacy request function it will be called with the
queue_lock held, but if it's called from a blk-mq driver or actually
uses the IPI no lock will be held.

When I did my blk-mq only for dm-mpath WIP patch my solution to that
was that I removed the ->complete handler entirely and just ran the
whole dm completion from the original hardirq context.  With that change
I know that for blk-mq we'll never hold the queue_lock (and the blk-mq
request free path doesn't care), and for legacy we always hold it,
so __blk_put_request can always be used.
