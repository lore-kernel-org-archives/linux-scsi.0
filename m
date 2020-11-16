Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.2 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,NICE_REPLY_A,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_SANE_1 autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A089EC5519F
	for <linux-scsi@archiver.kernel.org>; Mon, 16 Nov 2020 10:22:52 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 51DFE221F9
	for <linux-scsi@archiver.kernel.org>; Mon, 16 Nov 2020 10:22:52 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728566AbgKPJpr (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Mon, 16 Nov 2020 04:45:47 -0500
Received: from mx2.suse.de ([195.135.220.15]:37474 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726598AbgKPJpq (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
        Mon, 16 Nov 2020 04:45:46 -0500
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
Received: from relay2.suse.de (unknown [195.135.221.27])
        by mx2.suse.de (Postfix) with ESMTP id 38778ACE0;
        Mon, 16 Nov 2020 09:45:45 +0000 (UTC)
Subject: Re: [PATCH V4 08/12] blk-mq: return budget token from .get_budget
 callback
To:     Ming Lei <ming.lei@redhat.com>, Jens Axboe <axboe@kernel.dk>,
        linux-block@vger.kernel.org,
        "Martin K . Petersen" <martin.petersen@oracle.com>,
        linux-scsi@vger.kernel.org
Cc:     Omar Sandoval <osandov@fb.com>,
        Kashyap Desai <kashyap.desai@broadcom.com>,
        Sumanesh Samanta <sumanesh.samanta@broadcom.com>,
        "Ewan D . Milne" <emilne@redhat.com>
References: <20201116090737.50989-1-ming.lei@redhat.com>
 <20201116090737.50989-9-ming.lei@redhat.com>
From:   Hannes Reinecke <hare@suse.de>
Message-ID: <89637fa3-28dc-62e9-57aa-cc4632e37061@suse.de>
Date:   Mon, 16 Nov 2020 10:45:44 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.4.0
MIME-Version: 1.0
In-Reply-To: <20201116090737.50989-9-ming.lei@redhat.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On 11/16/20 10:07 AM, Ming Lei wrote:
> SCSI uses one global atomic variable to track queue depth for each
> LUN/request queue.
> 
> This way doesn't scale well when there is lots of CPU cores and the
> disk is very fast. It has been observed that IOPS is affected a lot
> by tracking queue depth via sdev->device_busy in IO path.
> 
> Return budget token from .get_budget callback, and the budget token
> can be passed to driver, so that we can replace the atomic variable
> with sbitmap_queue, then the scale issue can be fixed.
> 
> Cc: Omar Sandoval <osandov@fb.com>
> Cc: Kashyap Desai <kashyap.desai@broadcom.com>
> Cc: Sumanesh Samanta <sumanesh.samanta@broadcom.com>
> Cc: Ewan D. Milne <emilne@redhat.com>
> Cc: Hannes Reinecke <hare@suse.de>
> Tested-by: Sumanesh Samanta <sumanesh.samanta@broadcom.com>
> Signed-off-by: Ming Lei <ming.lei@redhat.com>
> ---
>   block/blk-mq-sched.c    | 17 +++++++++++++----
>   block/blk-mq.c          | 36 +++++++++++++++++++++++++-----------
>   block/blk-mq.h          | 25 +++++++++++++++++++++----
>   drivers/scsi/scsi_lib.c | 16 +++++++++++-----
>   include/linux/blk-mq.h  |  4 ++--
>   5 files changed, 72 insertions(+), 26 deletions(-)
> Reviewed-by: Hannes Reinecke <hare@suse.de

Cheers,

Hannes
-- 
Dr. Hannes Reinecke                Kernel Storage Architect
hare@suse.de                              +49 911 74053 688
SUSE Software Solutions GmbH, Maxfeldstr. 5, 90409 Nürnberg
HRB 36809 (AG Nürnberg), Geschäftsführer: Felix Imendörffer
