Return-Path: <SRS0=FF5A=DH=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-11.5 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,NICE_REPLY_A,
	SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_SANE_1
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 3E171C4727F
	for <linux-scsi@archiver.kernel.org>; Wed, 30 Sep 2020 09:19:06 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id F20FA20754
	for <linux-scsi@archiver.kernel.org>; Wed, 30 Sep 2020 09:19:05 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728149AbgI3JTF (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Wed, 30 Sep 2020 05:19:05 -0400
Received: from mx2.suse.de ([195.135.220.15]:54128 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725776AbgI3JTF (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
        Wed, 30 Sep 2020 05:19:05 -0400
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
Received: from relay2.suse.de (unknown [195.135.221.27])
        by mx2.suse.de (Postfix) with ESMTP id 7B8D0B016;
        Wed, 30 Sep 2020 09:19:04 +0000 (UTC)
Subject: Re: [PATCH v2 3/8] scsi: Clear state bit SCMD_NORETRIES_ABORT of
 scsi_cmd before start request
To:     Muneendra <muneendra.kumar@broadcom.com>,
        linux-scsi@vger.kernel.org
Cc:     jsmart2021@gmail.com, emilne@redhat.com, mkumar@redhat.com
References: <1601268657-940-1-git-send-email-muneendra.kumar@broadcom.com>
 <1601268657-940-4-git-send-email-muneendra.kumar@broadcom.com>
From:   Hannes Reinecke <hare@suse.de>
Message-ID: <75ff05b1-be57-038a-427c-dd0a8719e20d@suse.de>
Date:   Wed, 30 Sep 2020 11:19:04 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.12.0
MIME-Version: 1.0
In-Reply-To: <1601268657-940-4-git-send-email-muneendra.kumar@broadcom.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On 9/28/20 6:50 AM, Muneendra wrote:
> Clearing the SCMD_NORETRIES_ABORT bit in state flag before
> blk_mq_start_request.
> 
> Added a code in scsi_result_to_blk_status to translate
> a new error DID_TRANSPORT_MARGINAL to the corresponding blk_status_t
> i.e BLK_STS_TRANSPORT
> 
> Signed-off-by: Muneendra <muneendra.kumar@broadcom.com>
> 
> ---
> v2:
> Made changes in scsi_result_to_blk_status to support DID_TRANSPORT_MARGINAL
> ---
>   drivers/scsi/scsi_lib.c | 2 ++
>   1 file changed, 2 insertions(+)
> 
> diff --git a/drivers/scsi/scsi_lib.c b/drivers/scsi/scsi_lib.c
> index f0ee11dc07e4..da95ae8b572f 100644
> --- a/drivers/scsi/scsi_lib.c
> +++ b/drivers/scsi/scsi_lib.c
> @@ -643,6 +643,7 @@ static blk_status_t scsi_result_to_blk_status(struct scsi_cmnd *cmd, int result)
>   			return BLK_STS_OK;
>   		return BLK_STS_IOERR;
>   	case DID_TRANSPORT_FAILFAST:
> +	case DID_TRANSPORT_MARGINAL:
>   		return BLK_STS_TRANSPORT;
>   	case DID_TARGET_FAILURE:
>   		set_host_byte(cmd, DID_OK);
> @@ -1689,6 +1690,7 @@ static blk_status_t scsi_queue_rq(struct blk_mq_hw_ctx *hctx,
>   		req->rq_flags |= RQF_DONTPREP;
>   	} else {
>   		clear_bit(SCMD_STATE_COMPLETE, &cmd->state);
> +		clear_bit(SCMD_NORETRIES_ABORT, &cmd->state);
>   		blk_mq_start_request(req);
>   	}
>   
> 
Please split off this patch and merge the first part with the next 
patch, and the second hunk with the previous one.

Cheers,

Hannes
-- 
Dr. Hannes Reinecke		           Kernel Storage Architect
hare@suse.de			                  +49 911 74053 688
SUSE Software Solutions Germany GmbH, Maxfeldstr. 5, 90409 Nürnberg
HRB 36809 (AG Nürnberg), GF: Felix Imendörffer
