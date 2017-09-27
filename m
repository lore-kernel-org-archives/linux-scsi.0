From: Ming Lei <ming.lei@redhat.com>
Subject: Re: [PATCH V6 6/6] SCSI: set block queue at preempt only when SCSI
 device is put into quiesce
Date: Wed, 27 Sep 2017 18:14:55 +0800
Message-ID: <20170927101447.GA1994@ming.t460p>
References: <20170927054853.6647-1-ming.lei@redhat.com>
 <20170927054853.6647-7-ming.lei@redhat.com>
 <1506506047.2654.3.camel@wdc.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:55938 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751808AbdI0KPN (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
        Wed, 27 Sep 2017 06:15:13 -0400
Content-Disposition: inline
In-Reply-To: <1506506047.2654.3.camel@wdc.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Bart Van Assche <Bart.VanAssche@wdc.com>
Cc: "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>, "hch@infradead.org" <hch@infradead.org>, "jejb@linux.vnet.ibm.com" <jejb@linux.vnet.ibm.com>, "linux-block@vger.kernel.org" <linux-block@vger.kernel.org>, "axboe@fb.com" <axboe@fb.com>, "martin.petersen@oracle.com" <martin.petersen@oracle.com>, "martin@lichtvoll.de" <martin@lichtvoll.de>, "jthumshirn@suse.de" <jthumshirn@suse.de>, "oleksandr@natalenko.name" <oleksandr@natalenko.name>, "cavery@redhat.com" <cavery@redhat.com>

On Wed, Sep 27, 2017 at 09:54:09AM +0000, Bart Van Assche wrote:
> On Wed, 2017-09-27 at 13:48 +0800, Ming Lei wrote:
> > @@ -2928,12 +2929,28 @@ scsi_device_quiesce(struct scsi_device *sdev)
> >  {
> >  	int err;
> >  
> > +	/*
> > +	 * Simply quiesing SCSI device isn't safe, it is easy
> > +	 * to use up requests because all these allocated requests
> > +	 * can't be dispatched when device is put in QIUESCE.
> > +	 * Then no request can be allocated and we may hang
> > +	 * somewhere, such as system suspend/resume.
> > +	 *
> > +	 * So we set block queue in preempt only first, no new
> > +	 * normal request can enter queue any more, and all pending
> > +	 * requests are drained once blk_set_preempt_only()
> > +	 * returns. Only RQF_PREEMPT is allowed in preempt only mode.
> > +	 */
> > +	blk_set_preempt_only(sdev->request_queue, true);
> > +
> >  	mutex_lock(&sdev->state_mutex);
> >  	err = scsi_device_set_state(sdev, SDEV_QUIESCE);
> >  	mutex_unlock(&sdev->state_mutex);
> >  
> > -	if (err)
> > +	if (err) {
> > +		blk_set_preempt_only(sdev->request_queue, false);
> >  		return err;
> > +	}
> >  
> >  	scsi_run_queue(sdev->request_queue);
> >  	while (atomic_read(&sdev->device_busy)) {
> > @@ -2964,6 +2981,8 @@ void scsi_device_resume(struct scsi_device *sdev)
> >  	    scsi_device_set_state(sdev, SDEV_RUNNING) == 0)
> >  		scsi_run_queue(sdev->request_queue);
> >  	mutex_unlock(&sdev->state_mutex);
> > +
> > +	blk_set_preempt_only(sdev->request_queue, false);
> 
> You should have realized yourself that this code is racy. If a request is
> allocated just before scsi_device_quiesce() is called and dispatched just
> after the device state has been changed into SDEV_QUIESCE then the loop that

That won't happen, any requests allocated before blk_set_preempt_only(true)
will be drained. Any normal requests are prevented from being entering
queue after blk_set_preempt_only(true) returns.

Please look at blk_set_preempt_only():

	+void blk_set_preempt_only(struct request_queue *q, bool preempt_only)
	+{
	+       blk_mq_freeze_queue(q);
	+       if (preempt_only)
	+               queue_flag_set_unlocked(QUEUE_FLAG_PREEMPT_ONLY, q);
	+       else
	+               queue_flag_clear_unlocked(QUEUE_FLAG_PREEMPT_ONLY, q);
	+       blk_mq_unfreeze_queue(q);
	+}
	+EXPORT_SYMBOL(blk_set_preempt_only);

blk_set_preempt_only(true) is called before scsi_device_set_state(sdev, SDEV_QUIESCE),
then any requests will be drained by blk_mq_freeze_queue() inside
blk_set_preempt_only(), meantime new normal requests are prevented from
being entering queue.

Once blk_set_preempt_only() returns, only RQF_PREEMPT is allowed to
enter queue.


-- 
Ming
