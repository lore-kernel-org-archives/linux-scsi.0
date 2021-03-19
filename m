Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.3 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,NICE_REPLY_A,SPF_HELO_NONE,SPF_PASS,USER_AGENT_SANE_1
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E4D68C433E9
	for <linux-scsi@archiver.kernel.org>; Fri, 19 Mar 2021 07:57:24 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id B10BE64F70
	for <linux-scsi@archiver.kernel.org>; Fri, 19 Mar 2021 07:57:24 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234226AbhCSH4v (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Fri, 19 Mar 2021 03:56:51 -0400
Received: from mx2.suse.de ([195.135.220.15]:43674 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S233819AbhCSH4m (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
        Fri, 19 Mar 2021 03:56:42 -0400
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
Received: from relay2.suse.de (unknown [195.135.221.27])
        by mx2.suse.de (Postfix) with ESMTP id ECB08AFC4;
        Fri, 19 Mar 2021 07:56:40 +0000 (UTC)
Subject: Re: [PATCH 3/3] scsi: switch to use scsi_result_is_good() in
 scsi_result_to_blk_status()
To:     Jason Yan <yanaijie@huawei.com>, axboe@kernel.dk,
        ming.lei@redhat.com, hch@lst.de, keescook@chromium.org,
        kbusch@kernel.org, linux-block@vger.kernel.org,
        martin.petersen@oracle.com, jejb@linux.vnet.ibm.com
Cc:     linux-scsi@vger.kernel.org
References: <20210319030128.1345061-1-yanaijie@huawei.com>
 <20210319030128.1345061-4-yanaijie@huawei.com>
From:   Hannes Reinecke <hare@suse.de>
Message-ID: <021771c2-fff9-9e3c-7f30-6498b1e39462@suse.de>
Date:   Fri, 19 Mar 2021 08:56:38 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.7.0
MIME-Version: 1.0
In-Reply-To: <20210319030128.1345061-4-yanaijie@huawei.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On 3/19/21 4:01 AM, Jason Yan wrote:
> Use scsi_result_is_good() to simplify the code.
> 
> Signed-off-by: Jason Yan <yanaijie@huawei.com>
> ---
>   drivers/scsi/scsi_lib.c | 2 +-
>   1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/drivers/scsi/scsi_lib.c b/drivers/scsi/scsi_lib.c
> index 7d52a11e1b61..d1ec9f6a93f0 100644
> --- a/drivers/scsi/scsi_lib.c
> +++ b/drivers/scsi/scsi_lib.c
> @@ -626,7 +626,7 @@ static blk_status_t scsi_result_to_blk_status(struct scsi_cmnd *cmd, int result)
>   		 * to handle the case when a SCSI LLD sets result to
>   		 * DRIVER_SENSE << 24 without setting SAM_STAT_CHECK_CONDITION.
>   		 */
> -		if (scsi_status_is_good(result) && (result & ~0xff) == 0)
> +		if (scsi_result_is_good(result))
>   			return BLK_STS_OK;
>   		return BLK_STS_IOERR;
>   	case DID_TRANSPORT_FAILFAST:
> 
Reviewed-by: Hannes Reinecke <hare@suse.de>

Cheers,

Hannes
-- 
Dr. Hannes Reinecke                Kernel Storage Architect
hare@suse.de                              +49 911 74053 688
SUSE Software Solutions GmbH, Maxfeldstr. 5, 90409 Nürnberg
HRB 36809 (AG Nürnberg), Geschäftsführer: Felix Imendörffer
