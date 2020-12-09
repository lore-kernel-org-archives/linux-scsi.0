Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.2 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,NICE_REPLY_A,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,
	USER_AGENT_SANE_1 autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 8ACF5C19425
	for <linux-scsi@archiver.kernel.org>; Wed,  9 Dec 2020 07:37:10 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 3BF32239E5
	for <linux-scsi@archiver.kernel.org>; Wed,  9 Dec 2020 07:37:10 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727422AbgLIHhJ (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Wed, 9 Dec 2020 02:37:09 -0500
Received: from mx2.suse.de ([195.135.220.15]:38234 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725829AbgLIHhJ (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
        Wed, 9 Dec 2020 02:37:09 -0500
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
Received: from relay2.suse.de (unknown [195.135.221.27])
        by mx2.suse.de (Postfix) with ESMTP id 53CF2ACC6;
        Wed,  9 Dec 2020 07:36:27 +0000 (UTC)
Subject: Re: [PATCH v5 8/8] block: Do not accept any requests while suspended
To:     Bart Van Assche <bvanassche@acm.org>,
        "Martin K . Petersen" <martin.petersen@oracle.com>
Cc:     "James E . J . Bottomley" <jejb@linux.vnet.ibm.com>,
        Jens Axboe <axboe@kernel.dk>, Christoph Hellwig <hch@lst.de>,
        Ming Lei <ming.lei@redhat.com>, linux-scsi@vger.kernel.org,
        linux-block@vger.kernel.org,
        Alan Stern <stern@rowland.harvard.edu>,
        Can Guo <cang@codeaurora.org>,
        Stanley Chu <stanley.chu@mediatek.com>,
        "Rafael J . Wysocki" <rafael.j.wysocki@intel.com>,
        Martin Kepplinger <martin.kepplinger@puri.sm>
References: <20201209052951.16136-1-bvanassche@acm.org>
 <20201209052951.16136-9-bvanassche@acm.org>
From:   Hannes Reinecke <hare@suse.de>
Message-ID: <b257a342-0066-60a6-0bd1-801f502b6d96@suse.de>
Date:   Wed, 9 Dec 2020 08:36:26 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.4.0
MIME-Version: 1.0
In-Reply-To: <20201209052951.16136-9-bvanassche@acm.org>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On 12/9/20 6:29 AM, Bart Van Assche wrote:
> From: Alan Stern <stern@rowland.harvard.edu>
> 
> blk_queue_enter() accepts BLK_MQ_REQ_PM requests independent of the runtime
> power management state. Now that SCSI domain validation no longer depends
> on this behavior, modify the behavior of blk_queue_enter() as follows:
> - Do not accept any requests while suspended.
> - Only process power management requests while suspending or resuming.
> 
> Submitting BLK_MQ_REQ_PM requests to a device that is runtime suspended
> causes runtime-suspended devices not to resume as they should. The request
> which should cause a runtime resume instead gets issued directly, without
> resuming the device first. Of course the device can't handle it properly,
> the I/O fails, and the device remains suspended.
> 
> The problem is fixed by checking that the queue's runtime-PM status
> isn't RPM_SUSPENDED before allowing a request to be issued, and
> queuing a runtime-resume request if it is.  In particular, the inline
> blk_pm_request_resume() routine is renamed blk_pm_resume_queue() and
> the code is unified by merging the surrounding checks into the
> routine.  If the queue isn't set up for runtime PM, or there currently
> is no restriction on allowed requests, the request is allowed.
> Likewise if the BLK_MQ_REQ_PM flag is set and the status isn't
> RPM_SUSPENDED.  Otherwise a runtime resume is queued and the request
> is blocked until conditions are more suitable.
> 
> Cc: Jens Axboe <axboe@kernel.dk>
> Cc: Christoph Hellwig <hch@lst.de>
> Cc: Hannes Reinecke <hare@suse.de>
> Cc: Can Guo <cang@codeaurora.org>
> Cc: Stanley Chu <stanley.chu@mediatek.com>
> Cc: Ming Lei <ming.lei@redhat.com>
> Cc: Rafael J. Wysocki <rafael.j.wysocki@intel.com>
> Reported-and-tested-by: Martin Kepplinger <martin.kepplinger@puri.sm>
> Signed-off-by: Alan Stern <stern@rowland.harvard.edu>
> Signed-off-by: Bart Van Assche <bvanassche@acm.org>
> [ bvanassche: modified commit message and removed Cc: stable because without
>    the previous patches from this series this patch would break parallel SCSI
>    domain validation + introduced queue_rpm_status() ]
> ---
>   block/blk-core.c       |  7 ++++---
>   block/blk-pm.h         | 14 +++++++++-----
>   include/linux/blkdev.h | 12 ++++++++++++
>   3 files changed, 25 insertions(+), 8 deletions(-)
> 
Reviewed-by: Hannes Reinecke <hare@suse.de>

Cheers,

Hannes
-- 
Dr. Hannes Reinecke                Kernel Storage Architect
hare@suse.de                              +49 911 74053 688
SUSE Software Solutions GmbH, Maxfeldstr. 5, 90409 Nürnberg
HRB 36809 (AG Nürnberg), Geschäftsführer: Felix Imendörffer
