From: Bart Van Assche <bart.vanassche@sandisk.com>
Subject: Re: [PATCH v3 0/11] Fix race conditions related to stopping block
 layer queues
Date: Wed, 19 Oct 2016 16:51:18 -0700
Message-ID: <25418d7a-7e66-3b99-7532-669f7ebd58a6@sandisk.com>
References: <b39eb0e7-1007-eb63-8e7f-9a7f08508379@sandisk.com>
 <20161019222454.GA1215@localhost.localdomain>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-block-owner@vger.kernel.org>
In-Reply-To: <20161019222454.GA1215@localhost.localdomain>
Sender: linux-block-owner@vger.kernel.org
To: Keith Busch <keith.busch@intel.com>
Cc: Jens Axboe <axboe@fb.com>, Christoph Hellwig <hch@lst.de>, James Bottomley <jejb@linux.vnet.ibm.com>, "Martin K. Petersen" <martin.petersen@oracle.com>, Mike Snitzer <snitzer@redhat.com>, Doug Ledford <dledford@redhat.com>, Ming Lin <ming.l@ssi.samsung.com>, Laurence Oberman <loberman@redhat.com>, "linux-block@vger.kernel.org" <linux-block@vger.kernel.org>, "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>, "linux-rdma@vger.kernel.org" <linux-rdma@vger.kernel.org>, "linux-nvme@lists.infradead.org" <linux-nvme@lists.infradead.org>
List-Id: linux-scsi@vger.kernel.org

On 10/19/2016 03:14 PM, Keith Busch wrote:
> I'm running linux 4.9-rc1 + linux-block/for-linus, and alternating tests
> with and without this series.
>
> Without this, I'm not seeing any problems in a link-down test while
> running fio after ~30 runs.
>
> With this series, I only see the test pass infrequently. Most of the
> time I observe one of several failures. In all cases, it looks like the
> rq->queuelist is in an unexpected state.
>
> I think I've almost got this tracked down, but I have to leave for the
> day soon. Rather than having a more useful suggestion, I've put the two
> failures below.
>
 > First failure:
 >
> [  214.782098] kernel BUG at block/blk-mq.c:498!

Hello Keith,

Thank you for having taken the time to test this patch series. Since I 
think that the second and third failures are consequences of the first, 
I will focus on the first failure triggered by your tests.

I assume that line 498 in blk-mq.c corresponds to 
BUG_ON(blk_queued_rq(rq))? Anyway, it seems to me like this is a bug in 
the NVMe code and also that this bug is completely unrelated to my patch 
series. In nvme_complete_rq() I see that blk_mq_requeue_request() is 
called. I don't think this is allowed from the context of 
nvme_cancel_request() because blk_mq_requeue_request() assumes that a 
request has already been removed from the request list. However, neither 
blk_mq_tagset_busy_iter() nor nvme_cancel_request() remove a request 
from the request list before nvme_complete_rq() is called. I think this 
is what triggers the BUG_ON() statement in blk_mq_requeue_request(). 
Have you noticed that e.g. the scsi-mq code only calls 
blk_mq_requeue_request() after __blk_mq_end_request() has finished? Have 
you considered to follow the same approach in nvme_cancel_request()?

Thanks,

Bart.
