From: Ming Lei <ming.lei@redhat.com>
Subject: Re: [PATCH v4 6/6] dm rq: Avoid that request processing stalls
 sporadically
Date: Wed, 12 Apr 2017 11:42:35 +0800
Message-ID: <20170412034229.GA8835@ming.t460p>
References: <20170407181654.27836-1-bart.vanassche@sandisk.com>
 <20170407181654.27836-7-bart.vanassche@sandisk.com>
 <20170411160958.GA19222@redhat.com>
 <1491928005.2654.6.camel@sandisk.com>
 <20170411174739.GA19620@redhat.com>
 <1491933092.2654.10.camel@sandisk.com>
 <20170411180358.GA19660@redhat.com>
 <1491934715.2654.14.camel@sandisk.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Transfer-Encoding: 8bit
Return-path: <linux-block-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <1491934715.2654.14.camel@sandisk.com>
Sender: linux-block-owner@vger.kernel.org
To: Bart Van Assche <Bart.VanAssche@sandisk.com>
Cc: "snitzer@redhat.com" <snitzer@redhat.com>, "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>, "dm-devel@redhat.com" <dm-devel@redhat.com>, "linux-block@vger.kernel.org" <linux-block@vger.kernel.org>, "axboe@kernel.dk" <axboe@kernel.dk>
List-Id: linux-scsi@vger.kernel.org

On Tue, Apr 11, 2017 at 06:18:36PM +0000, Bart Van Assche wrote:
> On Tue, 2017-04-11 at 14:03 -0400, Mike Snitzer wrote:
> > Rather than working so hard to use DM code against me, your argument
> > should be: "blk-mq drivers X, Y and Z rerun the hw queue; this is a well
> > established pattern"
> > 
> > I see drivers/nvme/host/fc.c:nvme_fc_start_fcp_op() does.  But that is
> > only one other driver out of ~20 BLK_MQ_RQ_QUEUE_BUSY returns
> > tree-wide.
> > 
> > Could be there are some others, but hardly a well-established pattern.
> 
> Hello Mike,
> 
> Several blk-mq drivers that can return BLK_MQ_RQ_QUEUE_BUSY from their
> .queue_rq() implementation stop the request queue (blk_mq_stop_hw_queue())
> before returning "busy" and restart the queue after the busy condition has
> been cleared (blk_mq_start_stopped_hw_queues()). Examples are virtio_blk and
> xen-blkfront. However, this approach is not appropriate for the dm-mq core
> nor for the scsi core since both drivers already use the "stopped" state for
> another purpose than tracking whether or not a hardware queue is busy. Hence
> the blk_mq_delay_run_hw_queue() and blk_mq_run_hw_queue() calls in these last
> two drivers to rerun a hardware queue after the busy state has been cleared.

But looks this patch just reruns the hw queue after 100ms, which isn't
that after the busy state has been cleared, right?

Actually if BLK_MQ_RQ_QUEUE_BUSY is returned from .queue_rq(), blk-mq
will buffer this request into hctx->dispatch and run the hw queue again,
so looks blk_mq_delay_run_hw_queue() in this situation shouldn't have been
needed at my 1st impression. Or maybe Bart has more stories about this usage,
better to comments it?

Thanks,
Ming
