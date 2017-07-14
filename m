From: Mike Snitzer <snitzer@redhat.com>
Subject: Re: [for-4.14 RFC PATCH 1/2] dm rq: avoid deadlock if dm-mq is
 stacked on old .request_fn device(s)
Date: Fri, 14 Jul 2017 10:19:29 -0400
Message-ID: <20170714141929.GB18245@redhat.com>
References: <20170713211217.52361-1-snitzer@redhat.com>
 <20170713211217.52361-2-snitzer@redhat.com>
 <20170714072250.GC17046@lst.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:43464 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1753968AbdGNOTd (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
        Fri, 14 Jul 2017 10:19:33 -0400
Content-Disposition: inline
In-Reply-To: <20170714072250.GC17046@lst.de>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Christoph Hellwig <hch@lst.de>
Cc: dm-devel@redhat.com, linux-block@vger.kernel.org, linux-scsi@vger.kernel.org

On Fri, Jul 14 2017 at  3:22am -0400,
Christoph Hellwig <hch@lst.de> wrote:

> The problem here is the following:
> 
> blk_finish_request must always be called with the queue lock held,
> it even has an assert.
> 
> Without blk-mq used by dm-rq, dm uses the block softirq to execute the
> completion, which means we always have a different execution context and
> can take the queue lock again without issuesi.
> 
> With blk-mq used by dm-rq, the the dm .complete handler that is the rough
> equivalent of the softirq handler is called either directly if were are
> on the same CPU, or using a IPI (hardirq) if not.  If this handler gets
> called from a legacy request function it will be called with the
> queue_lock held, but if it's called from a blk-mq driver or actually
> uses the IPI no lock will be held.

Yeap, very well explained!  I found exactly that yesterday when I
developed this patch.  I stopped short of getting into those details in
my header though, but as you know it comes down to dm_complete_request's
blk-mq-vs-not branching (blk_mq_complete_request vs blk_complete_request).

> When I did my blk-mq only for dm-mpath WIP patch my solution to that
> was that I removed the ->complete handler entirely and just ran the
> whole dm completion from the original hardirq context.  With that change
> I know that for blk-mq we'll never hold the queue_lock (and the blk-mq
> request free path doesn't care), and for legacy we always hold it,
> so __blk_put_request can always be used.

Do you see a benefit to extracting that portion of your WIP patch
(removing the ->complete handler entirely)?

Or leave well enough alone and just continue to disable dm-mq's ability
to stack on .request_fn paths?

Given SCSI's switch to scsi-mq by default I cannot see value in propping
up stacking on the old .request_fn devices.

But interested to get your thoughts, thanks.
