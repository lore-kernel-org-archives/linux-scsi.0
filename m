Return-Path: <SRS0=3mnS=DM=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-11.3 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,NICE_REPLY_A,
	SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,USER_AGENT_SANE_1 autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id CE927C4363A
	for <linux-scsi@archiver.kernel.org>; Mon,  5 Oct 2020 09:01:40 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 8B8F520674
	for <linux-scsi@archiver.kernel.org>; Mon,  5 Oct 2020 09:01:40 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725893AbgJEJBk (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Mon, 5 Oct 2020 05:01:40 -0400
Received: from mx2.suse.de ([195.135.220.15]:53192 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725885AbgJEJBk (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
        Mon, 5 Oct 2020 05:01:40 -0400
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
Received: from relay2.suse.de (unknown [195.135.221.27])
        by mx2.suse.de (Postfix) with ESMTP id 3CAE1AD19;
        Mon,  5 Oct 2020 09:01:38 +0000 (UTC)
Subject: Re: [PATCH 02/10] scsi: remove scsi_init_cmd_errh
To:     Christoph Hellwig <hch@lst.de>,
        "Martin K. Petersen" <martin.petersen@oracle.com>
Cc:     linux-scsi@vger.kernel.org
References: <20201005084130.143273-1-hch@lst.de>
 <20201005084130.143273-3-hch@lst.de>
From:   Hannes Reinecke <hare@suse.de>
Message-ID: <04d88915-e9c0-5603-d3cd-b4216881d988@suse.de>
Date:   Mon, 5 Oct 2020 11:01:37 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.12.0
MIME-Version: 1.0
In-Reply-To: <20201005084130.143273-3-hch@lst.de>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On 10/5/20 10:41 AM, Christoph Hellwig wrote:
> There is no good reason to keep this functionality as a separate
> function, just merge it into the only caller.
> 
> Signed-off-by: Christoph Hellwig <hch@lst.de>
> ---
>   drivers/scsi/scsi_lib.c | 20 ++++----------------
>   1 file changed, 4 insertions(+), 16 deletions(-)
> 
> diff --git a/drivers/scsi/scsi_lib.c b/drivers/scsi/scsi_lib.c
> index b95e00ff346b09..8a7ae46b5943da 100644
> --- a/drivers/scsi/scsi_lib.c
> +++ b/drivers/scsi/scsi_lib.c
> @@ -293,21 +293,6 @@ int __scsi_execute(struct scsi_device *sdev, const unsigned char *cmd,
>   }
>   EXPORT_SYMBOL(__scsi_execute);
>   
> -/**
> - * scsi_init_cmd_errh - Initialize cmd fields related to error handling.
> - * @cmd:  command that is ready to be queued.
> - *
> - * This function has the job of initializing a number of fields related to error
> - * handling. Typically this will be called once for each command, as required.
> - */
> -static void scsi_init_cmd_errh(struct scsi_cmnd *cmd)
> -{
> -	scsi_set_resid(cmd, 0);
> -	memset(cmd->sense_buffer, 0, SCSI_SENSE_BUFFERSIZE);
> -	if (cmd->cmd_len == 0)
> -		cmd->cmd_len = scsi_command_size(cmd->cmnd);
> -}
> -
>   /*
>    * Wake up the error handler if necessary. Avoid as follows that the error
>    * handler is not woken up if host in-flight requests number ==
> @@ -1698,7 +1683,10 @@ static blk_status_t scsi_queue_rq(struct blk_mq_hw_ctx *hctx,
>   	if (bd->last)
>   		cmd->flags |= SCMD_LAST;
>   
> -	scsi_init_cmd_errh(cmd);
> +	scsi_set_resid(cmd, 0);
> +	memset(cmd->sense_buffer, 0, SCSI_SENSE_BUFFERSIZE);
> +	if (cmd->cmd_len == 0)
> +		cmd->cmd_len = scsi_command_size(cmd->cmnd);
>   	cmd->scsi_done = scsi_mq_done;
>   
>   	reason = scsi_dispatch_cmd(cmd);
> 
Reviewed-by: Hannes Reinecke <hare@suse.de>

Cheers,

Hannes
-- 
Dr. Hannes Reinecke                Kernel Storage Architect
hare@suse.de                              +49 911 74053 688
SUSE Software Solutions GmbH, Maxfeldstr. 5, 90409 Nürnberg
HRB 36809 (AG Nürnberg), Geschäftsführer: Felix Imendörffer
