From: Ming Lei <ming.lei@redhat.com>
Subject: Re: [PATCH V3 7/8] block: allow to allocate req with REQF_PREEMPT
 when queue is preempt frozen
Date: Mon, 4 Sep 2017 15:16:54 +0800
Message-ID: <20170904071653.GD7959@ming.t460p>
References: <20170902130840.24609-1-ming.lei@redhat.com>
 <20170902130840.24609-8-ming.lei@redhat.com>
 <20170902131208.GA10940@ming.t460p>
 <1504498405.10804.10.camel@wdc.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:43598 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1752624AbdIDHRM (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
        Mon, 4 Sep 2017 03:17:12 -0400
Content-Disposition: inline
In-Reply-To: <1504498405.10804.10.camel@wdc.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Bart Van Assche <Bart.VanAssche@wdc.com>
Cc: "linux-block@vger.kernel.org" <linux-block@vger.kernel.org>, "hch@infradead.org" <hch@infradead.org>, "martin.petersen@oracle.com" <martin.petersen@oracle.com>, "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>, "axboe@fb.com" <axboe@fb.com>, "jejb@linux.vnet.ibm.com" <jejb@linux.vnet.ibm.com>, "tj@kernel.org" <tj@kernel.org>, "jthumshirn@suse.de" <jthumshirn@suse.de>, "oleksandr@natalenko.name" <oleksandr@natalenko.name>

On Mon, Sep 04, 2017 at 04:13:26AM +0000, Bart Van Assche wrote:
> On Sat, 2017-09-02 at 21:12 +0800, Ming Lei wrote:
> > Please let us know if V3 addresses your previous concern about calling
> > blk_queue_enter_live() during preempt freezing.
> 
> Do you understand how request queue cleanup works? The algorithm used for
> request queue cleanup is as follows:
> * Set the DYING flag. This flag makes all later blk_get_request() calls
>   fail.

If you look at the __blk_freeze_queue_start(), you will see that preemp
freeze will fail after queue is dying, and blk_queue_enter_live() won't
be called at all if queue is dying, right?

> * Wait until all pending requests have finished.
> * Set the DEAD flag. For the traditional block layer, this flag causes
>   blk_run_queue() not to call .request_fn() anymore. For blk-mq it is
>   guaranteed in another way that .queue_rq() won't be called anymore after
>   this flag has been set.
> 
> Allowing blk_get_request() to succeed after the DYING flag has been set is
> completely wrong because that could result in a request being queued after

See above, this patch changes nothing about this fact, please look at
the patch carefully next time just before posting your long comment.

> the DEAD flag has been set, resulting in either a hanging request or a kernel
> crash. This is why it's completely wrong to add a blk_queue_enter_live() call
> in blk_old_get_request() or blk_mq_alloc_request(). Hence my NAK for any
> patch that adds a blk_queue_enter_live() call to any function called from
> blk_get_request(). That includes the patch at the start of this e-mail thread.
> 
> Bart.

-- 
Ming
