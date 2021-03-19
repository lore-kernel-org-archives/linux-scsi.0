Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.3 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,NICE_REPLY_A,SPF_HELO_NONE,SPF_PASS,USER_AGENT_SANE_1
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B0113C433E0
	for <linux-scsi@archiver.kernel.org>; Fri, 19 Mar 2021 07:57:24 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 8A22064F68
	for <linux-scsi@archiver.kernel.org>; Fri, 19 Mar 2021 07:57:24 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234237AbhCSH4v (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Fri, 19 Mar 2021 03:56:51 -0400
Received: from mx2.suse.de ([195.135.220.15]:42176 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S234084AbhCSH4V (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
        Fri, 19 Mar 2021 03:56:21 -0400
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
Received: from relay2.suse.de (unknown [195.135.221.27])
        by mx2.suse.de (Postfix) with ESMTP id 820CCAC75;
        Fri, 19 Mar 2021 07:56:20 +0000 (UTC)
Subject: Re: [PATCH 2/3] scsi: only copy data to user when the whole result is
 good
To:     Jason Yan <yanaijie@huawei.com>, axboe@kernel.dk,
        ming.lei@redhat.com, hch@lst.de, keescook@chromium.org,
        kbusch@kernel.org, linux-block@vger.kernel.org,
        martin.petersen@oracle.com, jejb@linux.vnet.ibm.com
Cc:     linux-scsi@vger.kernel.org
References: <20210319030128.1345061-1-yanaijie@huawei.com>
 <20210319030128.1345061-3-yanaijie@huawei.com>
From:   Hannes Reinecke <hare@suse.de>
Message-ID: <7279b268-0b57-c78a-b189-75e1515c7166@suse.de>
Date:   Fri, 19 Mar 2021 08:56:19 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.7.0
MIME-Version: 1.0
In-Reply-To: <20210319030128.1345061-3-yanaijie@huawei.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On 3/19/21 4:01 AM, Jason Yan wrote:
> When the scsi device status is offline, mode sense command will return a
> result with only DID_NO_CONNECT set. Then in sg_scsi_ioctl(),
> only status byte of the result is checked, and because of
> bug [1], garbage data is copied to the userspace.
> 
> Only copy the buffer to userspace when the whole result is good.
> 
> [1] https://patchwork.kernel.org/project/linux-block/patch/20210318122621.330010-1-yanaijie@huawei.com/
> 
> Signed-off-by: Jason Yan <yanaijie@huawei.com>
> ---
>   block/scsi_ioctl.c | 2 +-
>   1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/block/scsi_ioctl.c b/block/scsi_ioctl.c
> index 6599bac0a78c..359bf0003af4 100644
> --- a/block/scsi_ioctl.c
> +++ b/block/scsi_ioctl.c
> @@ -503,7 +503,7 @@ int sg_scsi_ioctl(struct request_queue *q, struct gendisk *disk, fmode_t mode,
>   			if (copy_to_user(sic->data, req->sense, bytes))
>   				err = -EFAULT;
>   		}
> -	} else {
> +	} else if (scsi_result_is_good(req->result)) {
>   		if (copy_to_user(sic->data, buffer, out_len))
>   			err = -EFAULT;
>   	}
> 
Hmm. Not sure about this one.
The prime motivator behind sg is to get _precisely_ all flags of the 
command, and not do in-kernel error handling.
So one could argue that this behaviour is intentional, and would break 
existing use-cases.

Doug?

Cheers,

Hannes
-- 
Dr. Hannes Reinecke                Kernel Storage Architect
hare@suse.de                              +49 911 74053 688
SUSE Software Solutions GmbH, Maxfeldstr. 5, 90409 Nürnberg
HRB 36809 (AG Nürnberg), Geschäftsführer: Felix Imendörffer
