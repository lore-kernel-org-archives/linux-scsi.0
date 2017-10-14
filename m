From: Ming Lei <ming.lei@redhat.com>
Subject: Re: [PATCH V9 6/7] SCSI: allow to pass null rq to
 scsi_prep_state_check()
Date: Sat, 14 Oct 2017 16:06:05 +0800
Message-ID: <20171014080604.GA31736@ming.t460p>
References: <20171013180532.29304-1-ming.lei@redhat.com>
 <20171013180532.29304-7-ming.lei@redhat.com>
 <1507936571.13345.51.camel@wdc.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <1507936571.13345.51.camel@wdc.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Bart Van Assche <Bart.VanAssche@wdc.com>
Cc: "hch@infradead.org" <hch@infradead.org>, "linux-block@vger.kernel.org" <linux-block@vger.kernel.org>, "axboe@fb.com" <axboe@fb.com>, "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>, "tom81094@gmail.com" <tom81094@gmail.com>, "paolo.valente@linaro.org" <paolo.valente@linaro.org>, "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>, "oleksandr@natalenko.name" <oleksandr@natalenko.name>, "john.garry@huawei.com" <john.garry@huawei.com>, "osandov@fb.com" <osandov@fb.com>, "loberman@redhat.com" <loberman@redhat.com>
List-Id: linux-scsi@vger.kernel.org

On Fri, Oct 13, 2017 at 11:16:12PM +0000, Bart Van Assche wrote:
> On Sat, 2017-10-14 at 02:05 +0800, Ming Lei wrote:
> > In the following patch, we will implement scsi_get_budget()
> > which need to call scsi_prep_state_check() when rq isn't
> > dequeued yet.
> 
> My understanding is that this change is only needed because scsi_mq_get_budget()
> calls scsi_prep_state_check() with the req argument set to NULL. Since
> scsi_prep_state_check() tests for sdev states other than SDEV_RUNNING and since
> the purpose of this series is to optimize performance for the case SDEV_RUNNING
> I'm not sure it's a good idea to make scsi_mq_get_budget() call
> scsi_prep_state_check(). And if scsi_mq_get_budget() wouldn't call
> scsi_prep_state_check() then this patch is not necessary.

The purpose is that I don't want to change the current SCSI logic of
queuing request.

For example, if sdev state becomes OFFLINE or DEL, the current
logic is to fail the request immediately. If the state isn't checked
in scsi_mq_get_budget(), we have to try to obtain budget first,
if it isn't available in the state of OFFLINE of DEL, there might be
risk of I/O hang.

So I suggest to check the state in scsi_mq_get_budget(), just like
what the current scsi_queue_rq() does.

-- 
Ming
