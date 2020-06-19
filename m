Return-Path: <SRS0=E1i/=AA=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.2 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	URIBL_BLOCKED,USER_AGENT_SANE_1 autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E3648C433E0
	for <linux-scsi@archiver.kernel.org>; Fri, 19 Jun 2020 14:09:36 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id CE96521527
	for <linux-scsi@archiver.kernel.org>; Fri, 19 Jun 2020 14:09:36 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1733169AbgFSOJf (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Fri, 19 Jun 2020 10:09:35 -0400
Received: from mx2.suse.de ([195.135.220.15]:44360 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1733205AbgFSOJe (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
        Fri, 19 Jun 2020 10:09:34 -0400
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
Received: from relay2.suse.de (unknown [195.135.220.254])
        by mx2.suse.de (Postfix) with ESMTP id CACBEAD2A;
        Fri, 19 Jun 2020 14:09:31 +0000 (UTC)
Subject: Re: [PATCH 2/2] block: only return started requests from
 blk_mq_tag_to_rq()
To:     Jens Axboe <axboe@kernel.dk>
Cc:     Christoph Hellwig <hch@lst.de>,
        "Martin K. Petersen" <martin.petersen@oracle.com>,
        Keith Busch <keith.busch@wdc.com>,
        Sagi Grimberg <sagi@grimberg.me>,
        James Bottomley <james.bottomley@hansenpartnership.com>,
        linux-block@vger.kernel.org, linux-scsi@vger.kernel.org
References: <20200619140159.141905-1-hare@suse.de>
From:   Hannes Reinecke <hare@suse.de>
Message-ID: <60e34dce-aea4-311f-22da-4cb130c5ba88@suse.de>
Date:   Fri, 19 Jun 2020 16:09:29 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.8.0
MIME-Version: 1.0
In-Reply-To: <20200619140159.141905-1-hare@suse.de>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On 6/19/20 4:01 PM, Hannes Reinecke wrote:
> blk_mq_tag_to_rq() is used from within the driver to map a tag
> to a request. As such it should only return requests which are
> already started (ie passed to the driver); otherwise the driver
> might trip over requests which it has never seen and random
> crashes will occur.
> 
> Signed-off-by: Hannes Reinecke <hare@suse.de>
> ---
>   block/blk-mq.c | 6 +++++-
>   1 file changed, 5 insertions(+), 1 deletion(-)
> 
> diff --git a/block/blk-mq.c b/block/blk-mq.c
> index 4f57d27bfa73..f02d18113f9e 100644
> --- a/block/blk-mq.c
> +++ b/block/blk-mq.c
> @@ -815,9 +815,13 @@ EXPORT_SYMBOL(blk_mq_delay_kick_requeue_list);
>   
>   struct request *blk_mq_tag_to_rq(struct blk_mq_tags *tags, unsigned int tag)
>   {
> +	struct request *rq;
> +
>   	if (tag < tags->nr_tags) {
>   		prefetch(tags->rqs[tag]);
> -		return tags->rqs[tag];
> +		rq = tags->rqs[tag];
> +		if (blk_mq_request_started(rq))
> +			return rq;
>   	}
>   
>   	return NULL;
> 
This becomes particularly obnoxious for SCSI drivers using 
scsi_host_find_tag() for cleaning up stale commands (ie drivers like 
qla4xxx, fnic, and snic).
All other drivers use it from the completion routine, so one can expect 
a valid (and started) tag here. So for those it shouldn't matter.

But still, if there are objections I could look at fixing it within the 
SCSI stack; although that would most likely mean I'll have to implement 
the above patch as an additional function.

Cheers,

Hannes
-- 
Dr. Hannes Reinecke            Teamlead Storage & Networking
hare@suse.de                               +49 911 74053 688
SUSE Software Solutions GmbH, Maxfeldstr. 5, 90409 Nürnberg
HRB 36809 (AG Nürnberg), Geschäftsführer: Felix Imendörffer
