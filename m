Return-Path: <SRS0=199q=EK=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-11.2 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,NICE_REPLY_A,
	SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_SANE_1
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 7699CC2D0A3
	for <linux-scsi@archiver.kernel.org>; Wed,  4 Nov 2020 14:22:42 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 18F54221F8
	for <linux-scsi@archiver.kernel.org>; Wed,  4 Nov 2020 14:22:42 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726746AbgKDOWl (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Wed, 4 Nov 2020 09:22:41 -0500
Received: from mx2.suse.de ([195.135.220.15]:50822 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726636AbgKDOWl (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
        Wed, 4 Nov 2020 09:22:41 -0500
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
Received: from relay2.suse.de (unknown [195.135.221.27])
        by mx2.suse.de (Postfix) with ESMTP id D564BAC3C;
        Wed,  4 Nov 2020 14:22:39 +0000 (UTC)
Subject: Re: [patch v5 2/5] scsi: Added a new error code in scsi.h
To:     Muneendra <muneendra.kumar@broadcom.com>,
        linux-scsi@vger.kernel.org, michael.christie@oracle.com
Cc:     jsmart2021@gmail.com, emilne@redhat.com, mkumar@redhat.com
References: <1604387712-19801-1-git-send-email-muneendra.kumar@broadcom.com>
 <1604387712-19801-3-git-send-email-muneendra.kumar@broadcom.com>
From:   Hannes Reinecke <hare@suse.de>
Message-ID: <7ad6b640-5571-92d2-daf2-35b0ba2cf1f5@suse.de>
Date:   Wed, 4 Nov 2020 15:22:41 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.12.0
MIME-Version: 1.0
In-Reply-To: <1604387712-19801-3-git-send-email-muneendra.kumar@broadcom.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On 11/3/20 8:15 AM, Muneendra wrote:
> Added a new error code DID_TRANSPORT_MARGINAL to handle marginal
> errors in scsi.h
> 
> Clearing the SCMD_NORETRIES_ABORT bit in state flag before
> blk_mq_start_request
> 
> Signed-off-by: Muneendra <muneendra.kumar@broadcom.com>
> 
> ---
> v5:
> No Change
> 
> v4:
> No change
> 
> v3:
> Rearranged the patch by merging second hunk of the previous(v2)
> patch3 to this patch
> 
> v2:
> Newpatch
> ---
>   drivers/scsi/scsi_lib.c | 1 +
>   include/scsi/scsi.h     | 1 +
>   2 files changed, 2 insertions(+)
> 
> diff --git a/drivers/scsi/scsi_lib.c b/drivers/scsi/scsi_lib.c
> index 1a2e9bab42ef..2b5dea07498e 100644
> --- a/drivers/scsi/scsi_lib.c
> +++ b/drivers/scsi/scsi_lib.c
> @@ -1660,6 +1660,7 @@ static blk_status_t scsi_queue_rq(struct blk_mq_hw_ctx *hctx,
>   		req->rq_flags |= RQF_DONTPREP;
>   	} else {
>   		clear_bit(SCMD_STATE_COMPLETE, &cmd->state);
> +		clear_bit(SCMD_NORETRIES_ABORT, &cmd->state);
>   	}
>   
>   	cmd->flags &= SCMD_PRESERVED_FLAGS;
> diff --git a/include/scsi/scsi.h b/include/scsi/scsi.h
> index 5339baadc082..5b287ad8b727 100644
> --- a/include/scsi/scsi.h
> +++ b/include/scsi/scsi.h
> @@ -159,6 +159,7 @@ static inline int scsi_is_wlun(u64 lun)
>   				 * paths might yield different results */
>   #define DID_ALLOC_FAILURE 0x12  /* Space allocation on the device failed */
>   #define DID_MEDIUM_ERROR  0x13  /* Medium error */
> +#define DID_TRANSPORT_MARGINAL 0x14 /* Transport marginal errors */
>   #define DRIVER_OK       0x00	/* Driver status                           */
>   
>   /*
> 
The first hunk should be moved to the patch defining 
SCMD_NORETRIES_ABORT, and the second hunk should be moved to the next patch.
This makes patch ordering and review more logical.

Cheers,

Hannes
-- 
Dr. Hannes Reinecke                Kernel Storage Architect
hare@suse.de                              +49 911 74053 688
SUSE Software Solutions GmbH, Maxfeldstr. 5, 90409 Nürnberg
HRB 36809 (AG Nürnberg), Geschäftsführer: Felix Imendörffer
