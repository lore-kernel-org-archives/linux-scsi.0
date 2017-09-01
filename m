From: Ming Lei <ming.lei@redhat.com>
Subject: Re: [PATCH 1/9] percpu-refcount: introduce percpu_ref_is_dead()
Date: Fri, 1 Sep 2017 11:49:42 +0800
Message-ID: <20170901034941.GE16525@ming.t460p>
References: <20170831172728.15817-1-ming.lei@redhat.com>
 <20170831172728.15817-2-ming.lei@redhat.com>
 <1504220849.31872.78.camel@wdc.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:50654 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751086AbdIADt5 (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
        Thu, 31 Aug 2017 23:49:57 -0400
Content-Disposition: inline
In-Reply-To: <1504220849.31872.78.camel@wdc.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Bart Van Assche <Bart.VanAssche@wdc.com>
Cc: "linux-block@vger.kernel.org" <linux-block@vger.kernel.org>, "hch@infradead.org" <hch@infradead.org>, "martin.petersen@oracle.com" <martin.petersen@oracle.com>, "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>, "axboe@fb.com" <axboe@fb.com>, "jejb@linux.vnet.ibm.com" <jejb@linux.vnet.ibm.com>, "tj@kernel.org" <tj@kernel.org>, "oleksandr@natalenko.name" <oleksandr@natalenko.name>

On Thu, Aug 31, 2017 at 11:07:30PM +0000, Bart Van Assche wrote:
> On Fri, 2017-09-01 at 01:27 +0800, Ming Lei wrote:
> > Inside block layer, we need to support to allocate request with
> > RQF_PREEMPT even though queue is frozen.
> 
> Hello Ming,
> 
> Can patch 8/9 be reworked such that it doesn't need the new
> percpu_ref_is_dead() helper function, e.g. by checking q->mq_freeze_depth
> to check whether or not request processing has been frozen? Have you noticed
> that several blk-mq code paths already check q->mq_freeze_depth to check
> whether or not a queue is frozen?

Strictly speaking, that way is wrong, or at least one lock is required
to check the counter, because the percpu-refcount isn't killed yet after
the atomic counter is increased by 1.

So I prefer to use this new helper.

-- 
Ming
