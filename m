From: Martin Steigerwald <martin@lichtvoll.de>
Subject: Re: [PATCH V7 0/6] block/scsi: safe SCSI quiescing
Date: Sat, 30 Sep 2017 11:47:10 +0200
Message-ID: <8017332.HWsC7yeG6s@merkaba>
References: <20170930061214.10622-1-ming.lei@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: 8BIT
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mondschein.lichtvoll.de ([194.150.191.11]:60915 "EHLO
        mail.lichtvoll.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1750991AbdI3JrM (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Sat, 30 Sep 2017 05:47:12 -0400
In-Reply-To: <20170930061214.10622-1-ming.lei@redhat.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Ming Lei <ming.lei@redhat.com>
Cc: Jens Axboe <axboe@fb.com>, linux-block@vger.kernel.org, Christoph Hellwig <hch@infradead.org>, linux-scsi@vger.kernel.org, "Martin K . Petersen" <martin.petersen@oracle.com>, "James E . J . Bottomley" <jejb@linux.vnet.ibm.com>, Bart Van Assche <bart.vanassche@sandisk.com>, Oleksandr Natalenko <oleksandr@natalenko.name>, Johannes Thumshirn <jthumshirn@suse.de>, Cathy Avery <cavery@redhat.com>, linux-kernel@vger.kernel.org, Hannes Reinecke <hare@suse.com>

Hi Ming.

Ming Lei - 30.09.17, 14:12:
> Please consider this patchset for V4.15, and it fixes one
> kind of long-term I/O hang issue in either block legacy path
> or blk-mq.
>
> The current SCSI quiesce isn't safe and easy to trigger I/O deadlock.

Isn´t that material for -stable as well?

I´d love to see this go into 4.14. Especially as its an LTS release.

Thanks,
Martin

> Once SCSI device is put into QUIESCE, no new request except for
> RQF_PREEMPT can be dispatched to SCSI successfully, and
> scsi_device_quiesce() just simply waits for completion of I/Os
> dispatched to SCSI stack. It isn't enough at all.
> 
> Because new request still can be comming, but all the allocated
> requests can't be dispatched successfully, so request pool can be
> consumed up easily.
> 
> Then request with RQF_PREEMPT can't be allocated and wait forever,
> then system hangs forever, such as during system suspend or
> sending SCSI domain alidation in case of transport_spi.
> 
> Both IO hang inside system suspend[1] or SCSI domain validation
> were reported before.
> 
> This patch introduces preempt only mode, and solves the issue
> by allowing RQF_PREEMP only during SCSI quiesce.
> 
> Both SCSI and SCSI_MQ have this IO deadlock issue, this patch fixes
> them all.
> 
> V7:
> 	- add Reviewed-by & Tested-by
> 	- one line change in patch 5 for checking preempt request
> 
> V6:
> 	- borrow Bart's idea of preempt only, with clean
> 	  implementation(patch 5/patch 6)
> 	- needn't any external driver's dependency, such as MD's
> 	change
> 
> V5:
> 	- fix one tiny race by introducing blk_queue_enter_preempt_freeze()
> 	given this change is small enough compared with V4, I added
> 	tested-by directly
> 
> V4:
> 	- reorganize patch order to make it more reasonable
> 	- support nested preempt freeze, as required by SCSI transport spi
> 	- check preempt freezing in slow path of of blk_queue_enter()
> 	- add "SCSI: transport_spi: resume a quiesced device"
> 	- wake up freeze queue in setting dying for both blk-mq and legacy
> 	- rename blk_mq_[freeze|unfreeze]_queue() in one patch
> 	- rename .mq_freeze_wq and .mq_freeze_depth
> 	- improve comment
> 
> V3:
> 	- introduce q->preempt_unfreezing to fix one bug of preempt freeze
> 	- call blk_queue_enter_live() only when queue is preempt frozen
> 	- cleanup a bit on the implementation of preempt freeze
> 	- only patch 6 and 7 are changed
> 
> V2:
> 	- drop the 1st patch in V1 because percpu_ref_is_dying() is
> 	enough as pointed by Tejun
> 	- introduce preempt version of blk_[freeze|unfreeze]_queue
> 	- sync between preempt freeze and normal freeze
> 	- fix warning from percpu-refcount as reported by Oleksandr
> 
> 
> [1] https://marc.info/?t=150340250100013&r=3&w=2
> 
> 
> Thanks,
> Ming
> 
> Ming Lei (6):
>   blk-mq: only run hw queues for blk-mq
>   block: tracking request allocation with q_usage_counter
>   block: pass flags to blk_queue_enter()
>   block: prepare for passing RQF_PREEMPT to request allocation
>   block: support PREEMPT_ONLY
>   SCSI: set block queue at preempt only when SCSI device is put into
>     quiesce
> 
>  block/blk-core.c        | 63
> +++++++++++++++++++++++++++++++++++++++---------- block/blk-mq.c          |
> 14 ++++-------
>  block/blk-timeout.c     |  2 +-
>  drivers/scsi/scsi_lib.c | 25 +++++++++++++++++---
>  fs/block_dev.c          |  4 ++--
>  include/linux/blk-mq.h  |  7 +++---
>  include/linux/blkdev.h  | 27 ++++++++++++++++++---
>  7 files changed, 107 insertions(+), 35 deletions(-)


-- 
Martin
