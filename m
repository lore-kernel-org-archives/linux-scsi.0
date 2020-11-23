Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.3 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,NICE_REPLY_A,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,
	USER_AGENT_SANE_1 autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 2AA92C63777
	for <linux-scsi@archiver.kernel.org>; Mon, 23 Nov 2020 06:46:44 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id BEA4220773
	for <linux-scsi@archiver.kernel.org>; Mon, 23 Nov 2020 06:46:43 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726996AbgKWGqn (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Mon, 23 Nov 2020 01:46:43 -0500
Received: from mx2.suse.de ([195.135.220.15]:36788 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725287AbgKWGqn (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
        Mon, 23 Nov 2020 01:46:43 -0500
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
Received: from relay2.suse.de (unknown [195.135.221.27])
        by mx2.suse.de (Postfix) with ESMTP id 8F5EEABCE;
        Mon, 23 Nov 2020 06:46:41 +0000 (UTC)
Subject: Re: [PATCH v3 1/9] block: Fix a race in the runtime power management
 code
To:     Bart Van Assche <bvanassche@acm.org>,
        "Martin K . Petersen" <martin.petersen@oracle.com>
Cc:     "James E . J . Bottomley" <jejb@linux.vnet.ibm.com>,
        Jens Axboe <axboe@kernel.dk>, Christoph Hellwig <hch@lst.de>,
        Ming Lei <ming.lei@redhat.com>, linux-scsi@vger.kernel.org,
        linux-block@vger.kernel.org,
        Alan Stern <stern@rowland.harvard.edu>,
        Stanley Chu <stanley.chu@mediatek.com>,
        "Rafael J . Wysocki" <rafael.j.wysocki@intel.com>,
        stable <stable@vger.kernel.org>, Can Guo <cang@codeaurora.org>
References: <20201123031749.14912-1-bvanassche@acm.org>
 <20201123031749.14912-2-bvanassche@acm.org>
From:   Hannes Reinecke <hare@suse.de>
Message-ID: <adeb251b-bfda-e3c5-e098-4105c2835922@suse.de>
Date:   Mon, 23 Nov 2020 07:46:37 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.4.0
MIME-Version: 1.0
In-Reply-To: <20201123031749.14912-2-bvanassche@acm.org>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On 11/23/20 4:17 AM, Bart Van Assche wrote:
> With the current implementation the following race can happen:
> * blk_pre_runtime_suspend() calls blk_freeze_queue_start() and
>    blk_mq_unfreeze_queue().
> * blk_queue_enter() calls blk_queue_pm_only() and that function returns
>    true.
> * blk_queue_enter() calls blk_pm_request_resume() and that function does
>    not call pm_request_resume() because the queue runtime status is
>    RPM_ACTIVE.
> * blk_pre_runtime_suspend() changes the queue status into RPM_SUSPENDING.
> 
> Fix this race by changing the queue runtime status into RPM_SUSPENDING
> before switching q_usage_counter to atomic mode.
> 
> Acked-by: Alan Stern <stern@rowland.harvard.edu>
> Acked-by: Stanley Chu <stanley.chu@mediatek.com>
> Reviewed-by: Christoph Hellwig <hch@lst.de>
> Cc: Ming Lei <ming.lei@redhat.com>
> Cc: Rafael J. Wysocki <rafael.j.wysocki@intel.com>
> Cc: stable <stable@vger.kernel.org>
> Fixes: 986d413b7c15 ("blk-mq: Enable support for runtime power management")
> Signed-off-by: Can Guo <cang@codeaurora.org>
> Signed-off-by: Bart Van Assche <bvanassche@acm.org>
> ---
>   block/blk-pm.c | 15 +++++++++------
>   1 file changed, 9 insertions(+), 6 deletions(-)
> 
Reviewed-by: Hannes Reinecke <hare@suse.de>

Cheers,

Hannes
-- 
Dr. Hannes Reinecke                Kernel Storage Architect
hare@suse.de                              +49 911 74053 688
SUSE Software Solutions GmbH, Maxfeldstr. 5, 90409 Nürnberg
HRB 36809 (AG Nürnberg), Geschäftsführer: Felix Imendörffer
