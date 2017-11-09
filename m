From: Ming Lei <ming.lei@redhat.com>
Subject: Re: [PATCH] SCSI: don't get target/host busy_count in
 scsi_mq_get_budget()
Date: Thu, 9 Nov 2017 10:05:08 +0800
Message-ID: <20171109020506.GB14520@ming.t460p>
References: <20171104015534.32684-1-ming.lei@redhat.com>
 <adb7f6bd-bf0d-8176-808b-32a84ac4273a@kernel.dk>
 <1509997522.2409.58.camel@wdc.com>
 <20171107021125.GB15090@ming.t460p>
 <1510071607.2656.17.camel@wdc.com>
 <20171108003934.GB20599@ming.t460p>
 <26ee805b-883f-d588-5649-13700244b6e8@kernel.dk>
 <20171108025830.GA30129@ming.t460p>
 <1a153ff3-9d53-d347-cb16-b8480e690221@kernel.dk>
 <1510159293.24237.19.camel@wdc.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:48098 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751241AbdKICFZ (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
        Wed, 8 Nov 2017 21:05:25 -0500
Content-Disposition: inline
In-Reply-To: <1510159293.24237.19.camel@wdc.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Bart Van Assche <Bart.VanAssche@wdc.com>
Cc: "axboe@kernel.dk" <axboe@kernel.dk>, "linux-block@vger.kernel.org" <linux-block@vger.kernel.org>, "hch@infradead.org" <hch@infradead.org>, "martin.petersen@oracle.com" <martin.petersen@oracle.com>, "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>, "john.garry@huawei.com" <john.garry@huawei.com>, "osandov@fb.com" <osandov@fb.com>, "jejb@linux.vnet.ibm.com" <jejb@linux.vnet.ibm.com>, "loberman@redhat.com" <loberman@redhat.com>

On Wed, Nov 08, 2017 at 04:41:35PM +0000, Bart Van Assche wrote:
> On Tue, 2017-11-07 at 20:06 -0700, Jens Axboe wrote:
> > At this point, I have no idea what Bart's setup looks like. Bart, it
> > would be REALLY helpful if you could tell us how you are reproducing
> > your hang. I don't know why this has to be dragged out.
> 
> Hello Jens,
> 
> It is a disappointment to me that you have allowed Ming to evaluate other
> approaches than reverting "blk-mq: don't handle TAG_SHARED in restart". That

I have mentioned in another email to Jens, that I agree to revert that
patch because of TAG_WAITING's issue in Jens's test case.

> patch namely replaces an algorithm that is trusted by the community with an
> algorithm of which even Ming acknowledged that it is racy. A quote from [1]:
> "IO hang may be caused if all requests are completed just before the current
> SCSI device is added to shost->starved_list". I don't know of any way to fix
> that race other than serializing request submission and completion by adding
> locking around these actions, which is something we don't want. Hence my
> request to revert that patch.

That can't be the reason for this revert.

This issue[1] is fixed by '[PATCH] SCSI: don't get target/host busy_count in
scsi_mq_get_budget()', follows the idea:

	- we add sdev into shost->starved_list in scsi_target_queue_ready(),
	  and the return value of BLK_STS_RESOURCE is set

	- atomic_read(&sdev->device_busy) is checked to see if there is
	  pending request, queue will be run if it is zero, otherwise we
	  depend on scsi_end_request() from pending request to restart queue.

	- you may mention sdev->device_busy may become 0 just after the
	  check, then the completion still see the sdev in
	  shost->starved_list and do the restart, and no IO hang

If you think something above is wrong, please comment on it directly.
Without this patch, no need any out-of-tree patch, IO hang can be
triggered in test 01 of srp-test. After this patch is applied on
V4.14-rc4, no IO hang can be observed any more.

> 
> Regarding the test I run, here is a summary of what I mentioned in previous
> e-mails:
> * I modified the SRP initiator such that the SCSI target queue depth is
>   reduced to one by setting starget->can_queue to 1 from inside
>   scsi_host_template.target_alloc.
> * With that modified SRP initiator I run the srp-test software as follows
>   until something breaks:
>   while ./run_tests -f xfs -d -e deadline -r 60; do :; done
> 
> Today a system with at least one InfiniBand HCA is required to run that test.
> When I have the time I will post the SRP initiator and target patches on the
> linux-rdma mailing list that make it possible to run that test against the
> SoftRoCE driver (drivers/infiniband/sw/rxe). The only hardware required to
> use that driver is an Ethernet adapter.

The thing is that we still don't know the root cause for your issue, and
keeping the restart for TAG_SHARED can be thought as a workaround. Maybe
it is same with Jens, maybe others, we don't know, and even without any
log provided, such as sched_tags or tags.

It is easy to see > 20% IOPS drops with restart for TAG_SHARED in 8
luns scsi debug test.

-- 
Ming
