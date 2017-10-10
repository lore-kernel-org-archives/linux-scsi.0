From: Omar Sandoval <osandov@osandov.com>
Subject: Re: [PATCH V6 5/5] blk-mq-sched: don't dequeue request until all in
 ->dispatch are flushed
Date: Tue, 10 Oct 2017 11:26:48 -0700
Message-ID: <20171010182648.GE30738@vader.DHCP.thefacebook.com>
References: <20171009112424.30524-1-ming.lei@redhat.com>
 <20171009112424.30524-6-ming.lei@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20171009112424.30524-6-ming.lei@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Ming Lei <ming.lei@redhat.com>
Cc: Jens Axboe <axboe@fb.com>, linux-block@vger.kernel.org, Christoph Hellwig <hch@infradead.org>, Mike Snitzer <snitzer@redhat.com>, dm-devel@redhat.com, Bart Van Assche <bart.vanassche@sandisk.com>, Laurence Oberman <loberman@redhat.com>, Paolo Valente <paolo.valente@linaro.org>, Oleksandr Natalenko <oleksandr@natalenko.name>, Tom Nguyen <tom81094@gmail.com>, linux-kernel@vger.kernel.org, linux-scsi@vger.kernel.org, Omar Sandoval <osandov@fb.com>
List-Id: linux-scsi@vger.kernel.org

On Mon, Oct 09, 2017 at 07:24:24PM +0800, Ming Lei wrote:
> During dispatching, we moved all requests from hctx->dispatch to
> one temporary list, then dispatch them one by one from this list.
> Unfortunately during this period, run queue from other contexts
> may think the queue is idle, then start to dequeue from sw/scheduler
> queue and still try to dispatch because ->dispatch is empty. This way
> hurts sequential I/O performance because requests are dequeued when
> lld queue is busy.
> 
> This patch introduces the state of BLK_MQ_S_DISPATCH_BUSY to
> make sure that request isn't dequeued until ->dispatch is
> flushed.
> 
> Reviewed-by: Bart Van Assche <bart.vanassche@wdc.com>
> Reviewed-by: Christoph Hellwig <hch@lst.de>

I think this will do for now.

Reviewed-by: Omar Sandoval <osandov@fb.com>

> Signed-off-by: Ming Lei <ming.lei@redhat.com>
> ---
>  block/blk-mq-debugfs.c |  1 +
>  block/blk-mq-sched.c   | 38 ++++++++++++++++++++++++++++++++------
>  block/blk-mq.c         |  5 +++++
>  include/linux/blk-mq.h |  1 +
>  4 files changed, 39 insertions(+), 6 deletions(-)
