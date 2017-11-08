From: Ming Lei <ming.lei@redhat.com>
Subject: Re: [PATCH] SCSI: don't get target/host busy_count in
 scsi_mq_get_budget()
Date: Wed, 8 Nov 2017 08:50:27 +0800
Message-ID: <20171108005022.GC20599@ming.t460p>
References: <20171104015534.32684-1-ming.lei@redhat.com>
 <adb7f6bd-bf0d-8176-808b-32a84ac4273a@kernel.dk>
 <1509997522.2409.58.camel@wdc.com>
 <20171107021125.GB15090@ming.t460p>
 <1510071607.2656.17.camel@wdc.com>
 <74925156-b425-de0e-de39-0a166ef5c5f3@kernel.dk>
 <49b5c202-0303-85f7-102a-fcc013e7256e@kernel.dk>
 <292e3f7d-cfe3-840a-5a5e-d00e01239152@kernel.dk>
 <a6a505f5-d374-2878-6c55-116255795346@kernel.dk>
 <1510094074.2656.39.camel@wdc.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:51526 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1759032AbdKHAum (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
        Tue, 7 Nov 2017 19:50:42 -0500
Content-Disposition: inline
In-Reply-To: <1510094074.2656.39.camel@wdc.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Bart Van Assche <Bart.VanAssche@wdc.com>
Cc: "axboe@kernel.dk" <axboe@kernel.dk>, "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>, "hch@infradead.org" <hch@infradead.org>, "linux-block@vger.kernel.org" <linux-block@vger.kernel.org>, "osandov@fb.com" <osandov@fb.com>, "john.garry@huawei.com" <john.garry@huawei.com>, "loberman@redhat.com" <loberman@redhat.com>

On Tue, Nov 07, 2017 at 10:34:35PM +0000, Bart Van Assche wrote:
> On Tue, 2017-11-07 at 15:06 -0700, Jens Axboe wrote:
> > Just to keep everyone in the loop, this bug is not new to
> > for-4.15/block, nor is it new to the current 4.41-rc or 4.13. So it's
> > probably different to what Bart is hitting, but it's a bug none the
> > less...
> 
> Hello Jens,
> 
> There are several reasons why I think that patch "blk-mq: don't handle
> TAG_SHARED in restart" really should be reverted:
> * That patch is based on the assumption that only the SCSI driver uses shared
>   tags. That assumption is not correct. null_blk and nvme also use shared tags.

No, both null_blk and nvme should be handled by BLK_MQ_S_TAG_WAITING, not need
to waste CPU to check all shared tags.

> * As my tests have shown, the algorithm for restarting queues based on the

Your test doesn't show it is related with RESTART since there isn't
pending request in output of 'tags'.

>   SCSI starved list is flawed. So using that mechanism instead of the blk-mq
>   shared queue restarting algorithm is wrong.

The algorithm based on starved list has been used for dozens of years
for SCSI, I don't think it is flawed enough.

> * We are close to the merge window. It is too late for trying to fix the
>   "blk-mq: don't handle TAG_SHARED in restart" patch.

If you can provide us the reproduction approach, the time is enough to fix it
before V4.15 release.

> 
> My proposal is to make sure that what will be sent to Linus during the v4.15
> merge window works reliably. That means using the v4.13/v4.14 algorithm for
> queue restarting which is an algorithm that is trusted by the community. If
> Roman Penyaev's patch could get applied that would be even better.

Frankly speaking, the algorithm for blk-mq's restarting won't be used by SCSI at
all because scsi_end_request() restarts the queue before the restart for TAG_SHARED.

For NVMe and null_blk, it is basically same since we cover that via BLK_MQ_S_TAG_WAITING.

So Nak your proposal.

-- 
Ming
