Return-Path: <SRS0=QZQu=BU=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-11.5 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,NICE_REPLY_A,
	SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_SANE_1
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 5B100C433E0
	for <linux-scsi@archiver.kernel.org>; Mon, 10 Aug 2020 06:11:51 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 38F1D2073A
	for <linux-scsi@archiver.kernel.org>; Mon, 10 Aug 2020 06:11:51 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726334AbgHJGLu (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Mon, 10 Aug 2020 02:11:50 -0400
Received: from mx2.suse.de ([195.135.220.15]:36754 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725849AbgHJGLu (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
        Mon, 10 Aug 2020 02:11:50 -0400
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
Received: from relay2.suse.de (unknown [195.135.221.27])
        by mx2.suse.de (Postfix) with ESMTP id D5AE2B1B1;
        Mon, 10 Aug 2020 06:12:08 +0000 (UTC)
Subject: Re: [PATCH 2/5] scsi: Clear state bit SCMD_NORETRIES_ABORT of
 scsi_cmd before start request
To:     Muneendra <muneendra.kumar@broadcom.com>,
        linux-scsi@vger.kernel.org
Cc:     jsmart2021@gmail.com, emilne@redhat.com, mkumar@redhat.com
References: <1596595862-11075-1-git-send-email-muneendra.kumar@broadcom.com>
 <1596595862-11075-3-git-send-email-muneendra.kumar@broadcom.com>
From:   Hannes Reinecke <hare@suse.de>
Message-ID: <9b1a4ea5-b793-f0c4-869d-8b95f1c18b80@suse.de>
Date:   Mon, 10 Aug 2020 08:11:47 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.10.0
MIME-Version: 1.0
In-Reply-To: <1596595862-11075-3-git-send-email-muneendra.kumar@broadcom.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On 8/5/20 4:50 AM, Muneendra wrote:
> Clearing the SCMD_NORETRIES_ABORT bit in state flag of scsi_cmd if the
> block layer didn't complete the request due to a timeout injection so that
> the timeout handler will see it needs to escalate its own error recovery.
> Also clearing the SCMD_NORETRIES_ABORT bit in state flag before
> blk_mq_start_request.
> 
> Signed-off-by: Muneendra <muneendra.kumar@broadcom.com>
> ---
>   drivers/scsi/scsi_lib.c | 8 ++++++--
>   1 file changed, 6 insertions(+), 2 deletions(-)
> 
> diff --git a/drivers/scsi/scsi_lib.c b/drivers/scsi/scsi_lib.c
> index 27b52fc..3da6402 100644
> --- a/drivers/scsi/scsi_lib.c
> +++ b/drivers/scsi/scsi_lib.c
> @@ -1594,12 +1594,15 @@ static void scsi_mq_done(struct scsi_cmnd *cmd)
>   
>   	/*
>   	 * If the block layer didn't complete the request due to a timeout
> -	 * injection, scsi must clear its internal completed state so that the
> +	 * injection, scsi must clear its internal completed state and
> +	 * SCMD_NORETRIES_ABORT bit in state field  so that the
>   	 * timeout handler will see it needs to escalate its own error
>   	 * recovery.
>   	 */
> -	if (unlikely(!blk_mq_complete_request(cmd->request)))
> +	if (unlikely(!blk_mq_complete_request(cmd->request))) {
>   		clear_bit(SCMD_STATE_COMPLETE, &cmd->state);
> +		clear_bit(SCMD_NORETRIES_ABORT, &cmd->state);
> +	}
>   }
>   
>   static void scsi_mq_put_budget(struct blk_mq_hw_ctx *hctx)
> @@ -1652,6 +1655,7 @@ static blk_status_t scsi_queue_rq(struct blk_mq_hw_ctx *hctx,
>   		req->rq_flags |= RQF_DONTPREP;
>   	} else {
>   		clear_bit(SCMD_STATE_COMPLETE, &cmd->state);
> +		clear_bit(SCMD_NORETRIES_ABORT, &cmd->state);
>   		blk_mq_start_request(req);
>   	}
>   
> 
Reviewed-by: Hannes Reinecke <hare@suse.de>

Cheers,

Hannes
-- 
Dr. Hannes Reinecke            Teamlead Storage & Networking
hare@suse.de                               +49 911 74053 688
SUSE Software Solutions GmbH, Maxfeldstr. 5, 90409 Nürnberg
HRB 36809 (AG Nürnberg), Geschäftsführer: Felix Imendörffer
