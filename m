Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 786A8C433EF
	for <linux-scsi@archiver.kernel.org>; Thu, 17 Feb 2022 07:45:11 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236235AbiBQHpY (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Thu, 17 Feb 2022 02:45:24 -0500
Received: from mxb-00190b01.gslb.pphosted.com ([23.128.96.19]:37420 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230237AbiBQHpX (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Thu, 17 Feb 2022 02:45:23 -0500
Received: from verein.lst.de (verein.lst.de [213.95.11.211])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3FE2823A1A8;
        Wed, 16 Feb 2022 23:45:09 -0800 (PST)
Received: by verein.lst.de (Postfix, from userid 2407)
        id BF89F68B05; Thu, 17 Feb 2022 08:45:03 +0100 (CET)
Date:   Thu, 17 Feb 2022 08:45:02 +0100
From:   Christoph Hellwig <hch@lst.de>
To:     Jens Axboe <axboe@kernel.dk>
Cc:     Christoph Hellwig <hch@lst.de>, Ming Lei <ming.lei@redhat.com>,
        "Martin K . Petersen" <martin.petersen@oracle.com>,
        linux-block@vger.kernel.org, linux-nvme@lists.infradead.org,
        linux-scsi@vger.kernel.org, Laibin Qiu <qiulaibin@huawei.com>,
        Ming Lei <ming.lei@rehdat.com>
Subject: Re: [PATCH V2 04/13] block/wbt: fix negative inflight counter when
 remove scsi device
Message-ID: <20220217074502.GA1333@lst.de>
References: <20220122111054.1126146-1-ming.lei@redhat.com> <20220122111054.1126146-5-ming.lei@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220122111054.1126146-5-ming.lei@redhat.com>
User-Agent: Mutt/1.5.17 (2007-11-01)
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

Jens, can you pick this up for the block-5.17 tree?

On Sat, Jan 22, 2022 at 07:10:45PM +0800, Ming Lei wrote:
> From: Laibin Qiu <qiulaibin@huawei.com>
> 
> Now that we disable wbt by set WBT_STATE_OFF_DEFAULT in
> wbt_disable_default() when switch elevator to bfq. And when
> we remove scsi device, wbt will be enabled by wbt_enable_default.
> If it become false positive between wbt_wait() and wbt_track()
> when submit write request.
> 
> The following is the scenario that triggered the problem.
> 
> T1                          T2                           T3
>                             elevator_switch_mq
>                             bfq_init_queue
>                             wbt_disable_default <= Set
>                             rwb->enable_state (OFF)
> Submit_bio
> blk_mq_make_request
> rq_qos_throttle
> <= rwb->enable_state (OFF)
>                                                          scsi_remove_device
>                                                          sd_remove
>                                                          del_gendisk
>                                                          blk_unregister_queue
>                                                          elv_unregister_queue
>                                                          wbt_enable_default
>                                                          <= Set rwb->enable_state (ON)
> q_qos_track
> <= rwb->enable_state (ON)
> ^^^^^^ this request will mark WBT_TRACKED without inflight add and will
> lead to drop rqw->inflight to -1 in wbt_done() which will trigger IO hung.
> 
> Fix this by move wbt_enable_default() from elv_unregister to
> bfq_exit_queue(). Only re-enable wbt when bfq exit.
> 
> Fixes: 76a8040817b4b ("blk-wbt: make sure throttle is enabled properly")
> 
> Remove oneline stale comment, and kill one oneshot local variable.
> 
> Signed-off-by: Ming Lei <ming.lei@rehdat.com>
> Reviewed-by: Christoph Hellwig <hch@lst.de>
> Link: https://lore.kernel.org/linux-block/20211214133103.551813-1-qiulaibin@huawei.com/
> Signed-off-by: Laibin Qiu <qiulaibin@huawei.com>
> ---
>  block/bfq-iosched.c | 2 ++
>  block/elevator.c    | 2 --
>  2 files changed, 2 insertions(+), 2 deletions(-)
> 
> diff --git a/block/bfq-iosched.c b/block/bfq-iosched.c
> index 0c612a911696..36a66e97e3c2 100644
> --- a/block/bfq-iosched.c
> +++ b/block/bfq-iosched.c
> @@ -7018,6 +7018,8 @@ static void bfq_exit_queue(struct elevator_queue *e)
>  	spin_unlock_irq(&bfqd->lock);
>  #endif
>  
> +	wbt_enable_default(bfqd->queue);
> +
>  	kfree(bfqd);
>  }
>  
> diff --git a/block/elevator.c b/block/elevator.c
> index ec98aed39c4f..482df2a350fc 100644
> --- a/block/elevator.c
> +++ b/block/elevator.c
> @@ -525,8 +525,6 @@ void elv_unregister_queue(struct request_queue *q)
>  		kobject_del(&e->kobj);
>  
>  		e->registered = 0;
> -		/* Re-enable throttling in case elevator disabled it */
> -		wbt_enable_default(q);
>  	}
>  }
>  
> -- 
> 2.31.1
---end quoted text---
