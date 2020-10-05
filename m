Return-Path: <SRS0=3mnS=DM=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-11.3 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,NICE_REPLY_A,
	SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_SANE_1
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 83A87C4363A
	for <linux-scsi@archiver.kernel.org>; Mon,  5 Oct 2020 09:02:09 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 3B3E42078E
	for <linux-scsi@archiver.kernel.org>; Mon,  5 Oct 2020 09:02:09 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725895AbgJEJCI (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Mon, 5 Oct 2020 05:02:08 -0400
Received: from mx2.suse.de ([195.135.220.15]:53562 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725885AbgJEJCI (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
        Mon, 5 Oct 2020 05:02:08 -0400
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
Received: from relay2.suse.de (unknown [195.135.221.27])
        by mx2.suse.de (Postfix) with ESMTP id B4F4FABE3;
        Mon,  5 Oct 2020 09:02:07 +0000 (UTC)
Subject: Re: [PATCH 03/10] scsi: move command size detection out of the fast
 path
To:     Christoph Hellwig <hch@lst.de>,
        "Martin K. Petersen" <martin.petersen@oracle.com>
Cc:     linux-scsi@vger.kernel.org
References: <20201005084130.143273-1-hch@lst.de>
 <20201005084130.143273-4-hch@lst.de>
From:   Hannes Reinecke <hare@suse.de>
Message-ID: <b469ff7c-ac2e-c8e7-acef-fd299b5ebb11@suse.de>
Date:   Mon, 5 Oct 2020 11:02:07 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.12.0
MIME-Version: 1.0
In-Reply-To: <20201005084130.143273-4-hch@lst.de>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On 10/5/20 10:41 AM, Christoph Hellwig wrote:
> We only need to detect the command size for ioctl request from userspace,
> which is limited to the passthrough path.  Move the check there instead
> of doing it for all queuecommand invocations.
> 
> Signed-off-by: Christoph Hellwig <hch@lst.de>
> ---
>   drivers/scsi/scsi_lib.c | 4 ++--
>   1 file changed, 2 insertions(+), 2 deletions(-)
> 
> diff --git a/drivers/scsi/scsi_lib.c b/drivers/scsi/scsi_lib.c
> index 8a7ae46b5943da..3c551f06ebe9be 100644
> --- a/drivers/scsi/scsi_lib.c
> +++ b/drivers/scsi/scsi_lib.c
> @@ -1166,6 +1166,8 @@ static blk_status_t scsi_setup_scsi_cmnd(struct scsi_device *sdev,
>   	}
>   
>   	cmd->cmd_len = scsi_req(req)->cmd_len;
> +	if (cmd->cmd_len == 0)
> +		cmd->cmd_len = scsi_command_size(cmd->cmnd);
>   	cmd->cmnd = scsi_req(req)->cmd;
>   	cmd->transfersize = blk_rq_bytes(req);
>   	cmd->allowed = scsi_req(req)->retries;
> @@ -1685,8 +1687,6 @@ static blk_status_t scsi_queue_rq(struct blk_mq_hw_ctx *hctx,
>   
>   	scsi_set_resid(cmd, 0);
>   	memset(cmd->sense_buffer, 0, SCSI_SENSE_BUFFERSIZE);
> -	if (cmd->cmd_len == 0)
> -		cmd->cmd_len = scsi_command_size(cmd->cmnd);
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
