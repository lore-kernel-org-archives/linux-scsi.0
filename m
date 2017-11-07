From: Ming Lei <ming.lei@redhat.com>
Subject: Re: [PATCH] SCSI: don't get target/host busy_count in
 scsi_mq_get_budget()
Date: Tue, 7 Nov 2017 10:19:30 +0800
Message-ID: <20171107021929.GC15090@ming.t460p>
References: <20171104015534.32684-1-ming.lei@redhat.com>
 <1509991480.2409.54.camel@wdc.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-block-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <1509991480.2409.54.camel@wdc.com>
Sender: linux-block-owner@vger.kernel.org
To: Bart Van Assche <Bart.VanAssche@wdc.com>
Cc: "hch@infradead.org" <hch@infradead.org>, "linux-block@vger.kernel.org" <linux-block@vger.kernel.org>, "axboe@fb.com" <axboe@fb.com>, "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>, "osandov@fb.com" <osandov@fb.com>, "john.garry@huawei.com" <john.garry@huawei.com>, "loberman@redhat.com" <loberman@redhat.com>
List-Id: linux-scsi@vger.kernel.org

On Mon, Nov 06, 2017 at 06:04:42PM +0000, Bart Van Assche wrote:
> On Sat, 2017-11-04 at 09:55 +0800, Ming Lei wrote:
> > It is very expensive to atomic_inc/atomic_dec the host wide counter of
> > host->busy_count, and it should have been avoided via blk-mq's mechanism
> > of getting driver tag, which uses the more efficient way of sbitmap queue.
> 
> Did you perhaps mean the host->host_busy counter? Unrelated to this patch:
> I think that commit 64d513ac31bd ("scsi: use host wide tags by default") made
> that counter superfluous.

But this counter is still inc/dec in .get_budget(), so my patch moves
after get driver tag, which will be much efficient.

> 
> > Also we don't check atomic_read(&sdev->device_busy) in scsi_mq_get_budget()
> > and don't run queue if the counter becomes zero, so IO hang may be caused
> > if all requests are completed just before the current SCSI device
> > is added to shost->starved_list.
> 
> What is the relationship between the above description and the code changes
> below? The above description does not explain whether the scsi_mq_get/put_budget()
> changes below prevent that all outstanding SCSI requests complete before
> another queue is added to the starved list.
> 
> Is this perhaps an attempt to move the code that can add a request queue to
> "starved_list" from inside scsi_mq_get_budget() into scsi_queue_rq()? Does
> this patch more than reducing the probability that the race is encountered
> that a queue is added to "starved_list" after all requests have finished?

This patch moves scsi_target_queue_ready() and scsi_host_queue_ready()
into scsi_queue_rq(), so if any one of them returns busy, we will check
if the queue is idle via the following:

              if (atomic_read(&sdev->device_busy) == 0 &&
                    !scsi_device_blocked(sdev))
                        blk_mq_delay_run_hw_queue(hctx, SCSI_QUEUE_DELAY);

Then the added sdev in 'starved_list' will be visible in scsi_end_request().

I am pretty sure this patch fixes the issue in my test.

> 
> > Fixes: 0df21c86bdbf(scsi: implement .get_budget and .put_budget for blk-mq)
> > Reported-by: Bart Van Assche <bart.vanassche@wdc.com>
> > Signed-off-by: Ming Lei <ming.lei@redhat.com>
> 
> Since this is a SCSI patch the SCSI maintainer, Martin Petersen, should have
> been Cc-ed for this patch. Additionally, I think that this patch should not
> have been queued by Jens before Martin had approved this patch.

This patch has been CCed to SCSI list.

> 
> > diff --git a/drivers/scsi/scsi_lib.c b/drivers/scsi/scsi_lib.c
> > index a098af3070a1..7f218ef61900 100644
> > --- a/drivers/scsi/scsi_lib.c
> > +++ b/drivers/scsi/scsi_lib.c
> > @@ -1944,11 +1944,7 @@ static void scsi_mq_put_budget(struct blk_mq_hw_ctx *hctx)
> >  {
> >  	struct request_queue *q = hctx->queue;
> >  	struct scsi_device *sdev = q->queuedata;
> > -	struct Scsi_Host *shost = sdev->host;
> >  
> > -	atomic_dec(&shost->host_busy);
> > -	if (scsi_target(sdev)->can_queue > 0)
> > -		atomic_dec(&scsi_target(sdev)->target_busy);
> >  	atomic_dec(&sdev->device_busy);
> >  	put_device(&sdev->sdev_gendev);
> >  }
> 
> scsi_mq_get/put_budget() were introduced to improve sequential I/O
> performance. Does removing the SCSI target busy check have a negative
> performance on sequential I/O for e.g. the iSER initiator driver? The iSCSI
> over TCP initiator driver is not appropriate for testing performance
> regressions because it limits the iSCSI parameter MaxOutstandingR2T to one.

At least in my test, it doesn't. If you have some report, please let me
know, and we still can improve the case.

-- 
Ming
