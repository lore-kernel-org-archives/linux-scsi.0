Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.3 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,NICE_REPLY_A,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,
	USER_AGENT_SANE_1 autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 96375C2D0E4
	for <linux-scsi@archiver.kernel.org>; Mon, 23 Nov 2020 06:47:21 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 537672078E
	for <linux-scsi@archiver.kernel.org>; Mon, 23 Nov 2020 06:47:21 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727245AbgKWGrU (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Mon, 23 Nov 2020 01:47:20 -0500
Received: from mx2.suse.de ([195.135.220.15]:36908 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725287AbgKWGrU (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
        Mon, 23 Nov 2020 01:47:20 -0500
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
Received: from relay2.suse.de (unknown [195.135.221.27])
        by mx2.suse.de (Postfix) with ESMTP id BC11BAC0C;
        Mon, 23 Nov 2020 06:47:18 +0000 (UTC)
Subject: Re: [PATCH v3 2/9] ide: Do not set the RQF_PREEMPT flag for sense
 requests
To:     Bart Van Assche <bvanassche@acm.org>,
        "Martin K . Petersen" <martin.petersen@oracle.com>
Cc:     "James E . J . Bottomley" <jejb@linux.vnet.ibm.com>,
        Jens Axboe <axboe@kernel.dk>, Christoph Hellwig <hch@lst.de>,
        Ming Lei <ming.lei@redhat.com>, linux-scsi@vger.kernel.org,
        linux-block@vger.kernel.org,
        "David S . Miller" <davem@davemloft.net>,
        Alan Stern <stern@rowland.harvard.edu>,
        Can Guo <cang@codeaurora.org>,
        Stanley Chu <stanley.chu@mediatek.com>,
        "Rafael J . Wysocki" <rafael.j.wysocki@intel.com>
References: <20201123031749.14912-1-bvanassche@acm.org>
 <20201123031749.14912-3-bvanassche@acm.org>
From:   Hannes Reinecke <hare@suse.de>
Message-ID: <36e00a46-9dfd-caf9-a399-b746bf30a275@suse.de>
Date:   Mon, 23 Nov 2020 07:47:16 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.4.0
MIME-Version: 1.0
In-Reply-To: <20201123031749.14912-3-bvanassche@acm.org>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On 11/23/20 4:17 AM, Bart Van Assche wrote:
> RQF_PREEMPT is used for two different purposes in the legacy IDE code:
> 1. To mark power management requests.
> 2. To mark requests that should preempt another request. An (old)
>     explanation of that feature is as follows:
>     "The IDE driver in the Linux kernel normally uses a series of busywait
>     delays during its initialization. When the driver executes these
>     busywaits, the kernel does nothing for the duration of the wait. The
>     time spent in these waits could be used for other initialization
>     activities, if they could be run concurrently with these waits.
> 
>     More specifically, busywait-style delays such as udelay() in module
>     init functions inhibit kernel preemption because the Big Kernel Lock
>     is held, while yielding APIs such as schedule_timeout() allow preemption.
>     This is true because the kernel handles the BKL specially and releases
>     and reacquires it across reschedules allowed by the current thread.
> 
>     This IDE-preempt specification requires that the driver eliminate these
>     busywaits and replace them with a mechanism that allows other work to
>     proceed while the IDE driver is initializing."
> 
> Since I haven't found an implementation of (2), do not set the PREEMPT
> flag for sense requests. This patch causes sense requests to be
> postponed while a drive is suspended instead of being submitted to
> ide_queue_rq().
> 
> If it would ever be necessary to restore the IDE PREEMPT functionality,
> that can be done by introducing a new flag in struct ide_request.
> 
> This patch is a first step towards removing the PREEMPT flag from the
> block layer.
> 
> Reviewed-by: Christoph Hellwig <hch@lst.de>
> Cc: David S. Miller <davem@davemloft.net>
> Cc: Alan Stern <stern@rowland.harvard.edu>
> Cc: Can Guo <cang@codeaurora.org>
> Cc: Stanley Chu <stanley.chu@mediatek.com>
> Cc: Ming Lei <ming.lei@redhat.com>
> Cc: Rafael J. Wysocki <rafael.j.wysocki@intel.com>
> Signed-off-by: Bart Van Assche <bvanassche@acm.org>
> ---
>   drivers/ide/ide-atapi.c | 1 -
>   1 file changed, 1 deletion(-)
> 
> diff --git a/drivers/ide/ide-atapi.c b/drivers/ide/ide-atapi.c
> index 2162bc80f09e..013ad33fbbc8 100644
> --- a/drivers/ide/ide-atapi.c
> +++ b/drivers/ide/ide-atapi.c
> @@ -223,7 +223,6 @@ void ide_prep_sense(ide_drive_t *drive, struct request *rq)
>   	sense_rq->rq_disk = rq->rq_disk;
>   	sense_rq->cmd_flags = REQ_OP_DRV_IN;
>   	ide_req(sense_rq)->type = ATA_PRIV_SENSE;
> -	sense_rq->rq_flags |= RQF_PREEMPT;
>   
>   	req->cmd[0] = GPCMD_REQUEST_SENSE;
>   	req->cmd[4] = cmd_len;
> 
Reviewed-by: Hannes Reinecke <hare@suse.de>

Cheers,

Hannes
-- 
Dr. Hannes Reinecke                Kernel Storage Architect
hare@suse.de                              +49 911 74053 688
SUSE Software Solutions GmbH, Maxfeldstr. 5, 90409 Nürnberg
HRB 36809 (AG Nürnberg), Geschäftsführer: Felix Imendörffer
