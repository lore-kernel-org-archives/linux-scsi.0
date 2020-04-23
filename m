Return-Path: <SRS0=QYJt=6H=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.2 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	URIBL_BLOCKED,USER_AGENT_SANE_1 autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id EA518C2BA19
	for <linux-scsi@archiver.kernel.org>; Thu, 23 Apr 2020 05:41:40 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id D0FD6206B9
	for <linux-scsi@archiver.kernel.org>; Thu, 23 Apr 2020 05:41:40 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726196AbgDWFlk (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Thu, 23 Apr 2020 01:41:40 -0400
Received: from mx2.suse.de ([195.135.220.15]:40454 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725867AbgDWFlk (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
        Thu, 23 Apr 2020 01:41:40 -0400
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
Received: from relay2.suse.de (unknown [195.135.220.254])
        by mx2.suse.de (Postfix) with ESMTP id DE4E8AA55;
        Thu, 23 Apr 2020 05:41:37 +0000 (UTC)
Subject: Re: [PATCH V2] scsi: avoid to run synchronize_rcu for each device in
 scsi_host_block
To:     Ming Lei <ming.lei@redhat.com>,
        James Bottomley <James.Bottomley@HansenPartnership.com>,
        linux-scsi@vger.kernel.org,
        "Martin K . Petersen" <martin.petersen@oracle.com>
Cc:     Steffen Maier <maier@linux.ibm.com>,
        Bart Van Assche <bvanassche@acm.org>,
        Christoph Hellwig <hch@lst.de>,
        Dexuan Cui <decui@microsoft.com>
References: <20200423020713.332743-1-ming.lei@redhat.com>
From:   Hannes Reinecke <hare@suse.de>
Message-ID: <8f917488-5186-4aa2-e20c-b0af2d91397d@suse.de>
Date:   Thu, 23 Apr 2020 07:41:35 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.7.0
MIME-Version: 1.0
In-Reply-To: <20200423020713.332743-1-ming.lei@redhat.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On 4/23/20 4:07 AM, Ming Lei wrote:
> scsi_host_block() calls scsi_internal_device_block() for each
> scsi_device, and scsi_internal_device_block() calls
> blk_mq_quiesce_queue() for each LUN. However synchronize_rcu is
> run from blk_mq_quiesce_queue().
> 
> This way may become unnecessary slow in case of lots of LUNs.
> 
> Use scsi_internal_device_block_nowait() to implement scsi_host_block(),
> so it is enough to run synchronize_rcu() once since scsi never
> supports blk-mq's BLK_MQ_F_BLOCKING.
> 
> Cc: Steffen Maier <maier@linux.ibm.com>
> Cc: Bart Van Assche <bvanassche@acm.org>
> Cc: Christoph Hellwig <hch@lst.de>
> Cc: Dexuan Cui <decui@microsoft.com>
> Cc: Hannes Reinecke <hare@suse.de>
> Signed-off-by: Ming Lei <ming.lei@redhat.com>
> ---
> V2:
> 	- fix commit log as pointed by Steffen
> 	- add comment on BLK_MQ_F_BLOCKING as suggested by Bart
> 
>   drivers/scsi/scsi_lib.c | 17 ++++++++++++++++-
>   1 file changed, 16 insertions(+), 1 deletion(-)
> 
> diff --git a/drivers/scsi/scsi_lib.c b/drivers/scsi/scsi_lib.c
> index 47835c4b4ee0..86007a523145 100644
> --- a/drivers/scsi/scsi_lib.c
> +++ b/drivers/scsi/scsi_lib.c
> @@ -2841,11 +2841,26 @@ scsi_host_block(struct Scsi_Host *shost)
>   	struct scsi_device *sdev;
>   	int ret = 0;
>   
> +	/*
> +	 * Call scsi_internal_device_block_nowait then we can avoid to
> +	 * run synchronize_rcu() for each LUN
> +	 */
>   	shost_for_each_device(sdev, shost) {
> -		ret = scsi_internal_device_block(sdev);
> +		mutex_lock(&sdev->state_mutex);
> +		ret = scsi_internal_device_block_nowait(sdev);
> +		mutex_unlock(&sdev->state_mutex);
>   		if (ret)
>   			break;
>   	}
> +
> +	/*
> +	 * SCSI never enables blk-mq's BLK_MQ_F_BLOCKING, so run
> +	 * synchronize_rcu() once is enough
> +	 */
> +	WARN_ON_ONCE(shost->tag_set.flags & BLK_MQ_F_BLOCKING);
> +
> +	if (!ret)
> +		synchronize_rcu();
>   	return ret;
>   }
>   EXPORT_SYMBOL_GPL(scsi_host_block);
> 
Looks good.

Reviewed-by: Hannes Reinecke <hare@suse.de>

Cheers,

Hannes
-- 
Dr. Hannes Reinecke            Teamlead Storage & Networking
hare@suse.de                               +49 911 74053 688
SUSE Software Solutions GmbH, Maxfeldstr. 5, 90409 Nürnberg
HRB 36809 (AG Nürnberg), Geschäftsführer: Felix Imendörffer
