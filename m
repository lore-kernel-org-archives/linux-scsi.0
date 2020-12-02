Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.2 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,NICE_REPLY_A,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,
	USER_AGENT_SANE_1 autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 100DCC64E7C
	for <linux-scsi@archiver.kernel.org>; Wed,  2 Dec 2020 07:06:54 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id A7AD122202
	for <linux-scsi@archiver.kernel.org>; Wed,  2 Dec 2020 07:06:53 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728743AbgLBHGx (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Wed, 2 Dec 2020 02:06:53 -0500
Received: from mx2.suse.de ([195.135.220.15]:60150 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725912AbgLBHGx (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
        Wed, 2 Dec 2020 02:06:53 -0500
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
Received: from relay2.suse.de (unknown [195.135.221.27])
        by mx2.suse.de (Postfix) with ESMTP id 4463FABD2;
        Wed,  2 Dec 2020 07:06:11 +0000 (UTC)
Subject: Re: [PATCH v4 5/9] scsi: Do not wait for a request in
 scsi_eh_lock_door()
To:     Bart Van Assche <bvanassche@acm.org>,
        "Martin K . Petersen" <martin.petersen@oracle.com>
Cc:     "James E . J . Bottomley" <jejb@linux.vnet.ibm.com>,
        Jens Axboe <axboe@kernel.dk>, Christoph Hellwig <hch@lst.de>,
        Ming Lei <ming.lei@redhat.com>, linux-scsi@vger.kernel.org,
        linux-block@vger.kernel.org,
        Alan Stern <stern@rowland.harvard.edu>,
        Can Guo <cang@codeaurora.org>,
        Stanley Chu <stanley.chu@mediatek.com>,
        "Rafael J . Wysocki" <rafael.j.wysocki@intel.com>
References: <20201130024615.29171-1-bvanassche@acm.org>
 <20201130024615.29171-6-bvanassche@acm.org>
From:   Hannes Reinecke <hare@suse.de>
Message-ID: <bdadfbcd-76c4-4658-0b36-b7666fa1dc7b@suse.de>
Date:   Wed, 2 Dec 2020 08:06:10 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.4.0
MIME-Version: 1.0
In-Reply-To: <20201130024615.29171-6-bvanassche@acm.org>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On 11/30/20 3:46 AM, Bart Van Assche wrote:
> scsi_eh_lock_door() is the only function in the SCSI error handler that
> calls blk_get_request(). It is not guaranteed that a request is available
> when scsi_eh_lock_door() is called. Hence pass the BLK_MQ_REQ_NOWAIT flag
> to blk_get_request().
> 
> Reviewed-by: Alan Stern <stern@rowland.harvard.edu>
> Reviewed-by: Christoph Hellwig <hch@lst.de>
> Cc: Can Guo <cang@codeaurora.org>
> Cc: Stanley Chu <stanley.chu@mediatek.com>
> Cc: Ming Lei <ming.lei@redhat.com>
> Cc: Rafael J. Wysocki <rafael.j.wysocki@intel.com>
> Signed-off-by: Bart Van Assche <bvanassche@acm.org>
> ---
>   drivers/scsi/scsi_error.c | 7 ++++++-
>   1 file changed, 6 insertions(+), 1 deletion(-)
> 
> diff --git a/drivers/scsi/scsi_error.c b/drivers/scsi/scsi_error.c
> index d94449188270..6de6e1bf3dcb 100644
> --- a/drivers/scsi/scsi_error.c
> +++ b/drivers/scsi/scsi_error.c
> @@ -1993,7 +1993,12 @@ static void scsi_eh_lock_door(struct scsi_device *sdev)
>   	struct request *req;
>   	struct scsi_request *rq;
>   
> -	req = blk_get_request(sdev->request_queue, REQ_OP_SCSI_IN, 0);
> +	/*
> +	 * It is not guaranteed that a request is available nor that
> +	 * sdev->request_queue is unfrozen. Hence the BLK_MQ_REQ_NOWAIT below.
> +	 */
> +	req = blk_get_request(sdev->request_queue, REQ_OP_SCSI_IN,
> +			      BLK_MQ_REQ_NOWAIT);
>   	if (IS_ERR(req))
>   		return;
>   	rq = scsi_req(req);
> 
Well ... had been thinking about that one, too.
The idea of this function is that prior to SCSI EH the device was locked
via scsi_set_medium_removal(). And during SCSI EH the device might have 
become unlocked, so we need to lock it again.
However, scsi_set_medium_removal() not only issues the 
PREVENT_ALLOW_MEDIUM_REMOVAL command, but also sets the 'locked' flag 
based on the result.
So if we fail to get a request here, shouldn't we unset the 'locked' 
flag, too?
And what does happen if we fail here? There is no return value, hence 
SCSI EH might run to completion, and the system will continue
with an unlocked door ...
Not sure if that's a good idea.

But anyway, at the very least unset the 'locked' flag upon failure such 
that the internal state is correctly updated.

_Actually_, the flag should be unset after each successful SCSI EH step, 
to mirror the actual state. But this is probably out of scope for this 
patch.

Cheers,

Hannes
-- 
Dr. Hannes Reinecke                Kernel Storage Architect
hare@suse.de                              +49 911 74053 688
SUSE Software Solutions GmbH, Maxfeldstr. 5, 90409 Nürnberg
HRB 36809 (AG Nürnberg), Geschäftsführer: Felix Imendörffer
