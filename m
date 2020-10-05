Return-Path: <SRS0=3mnS=DM=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-11.3 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,NICE_REPLY_A,
	SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_SANE_1
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 9F023C4727D
	for <linux-scsi@archiver.kernel.org>; Mon,  5 Oct 2020 09:04:39 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 7432720781
	for <linux-scsi@archiver.kernel.org>; Mon,  5 Oct 2020 09:04:39 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725917AbgJEJEi (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Mon, 5 Oct 2020 05:04:38 -0400
Received: from mx2.suse.de ([195.135.220.15]:56980 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725885AbgJEJEi (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
        Mon, 5 Oct 2020 05:04:38 -0400
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
Received: from relay2.suse.de (unknown [195.135.221.27])
        by mx2.suse.de (Postfix) with ESMTP id A8FCEB11F;
        Mon,  5 Oct 2020 09:04:37 +0000 (UTC)
Subject: Re: [PATCH 05/10] scsi: use rq_dma_dir in scsi_setup_cmnd
To:     Christoph Hellwig <hch@lst.de>,
        "Martin K. Petersen" <martin.petersen@oracle.com>
Cc:     linux-scsi@vger.kernel.org
References: <20201005084130.143273-1-hch@lst.de>
 <20201005084130.143273-6-hch@lst.de>
From:   Hannes Reinecke <hare@suse.de>
Message-ID: <2beee4a7-3c4d-7a56-200b-9af3c50c51c0@suse.de>
Date:   Mon, 5 Oct 2020 11:04:37 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.12.0
MIME-Version: 1.0
In-Reply-To: <20201005084130.143273-6-hch@lst.de>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On 10/5/20 10:41 AM, Christoph Hellwig wrote:
> Signed-off-by: Christoph Hellwig <hch@lst.de>
> ---
>   drivers/scsi/scsi_lib.c | 7 +------
>   1 file changed, 1 insertion(+), 6 deletions(-)
> 
> diff --git a/drivers/scsi/scsi_lib.c b/drivers/scsi/scsi_lib.c
> index 3c551f06ebe9be..670ad06812b419 100644
> --- a/drivers/scsi/scsi_lib.c
> +++ b/drivers/scsi/scsi_lib.c
> @@ -1200,12 +1200,7 @@ static blk_status_t scsi_setup_cmnd(struct scsi_device *sdev,
>   	struct scsi_cmnd *cmd = blk_mq_rq_to_pdu(req);
>   	blk_status_t ret;
>   
> -	if (!blk_rq_bytes(req))
> -		cmd->sc_data_direction = DMA_NONE;
> -	else if (rq_data_dir(req) == WRITE)
> -		cmd->sc_data_direction = DMA_TO_DEVICE;
> -	else
> -		cmd->sc_data_direction = DMA_FROM_DEVICE;
> +	cmd->sc_data_direction = rq_dma_dir(req);
>   
>   	if (blk_rq_is_scsi(req))
>   		ret = scsi_setup_scsi_cmnd(sdev, req);
> 
Makes me wonder if we can't kill sc_data_direction completely.
But maybe later.

Reviewed-by: Hannes Reinecke <hare@suse.de>

Cheers,

Hannes
-- 
Dr. Hannes Reinecke                Kernel Storage Architect
hare@suse.de                              +49 911 74053 688
SUSE Software Solutions GmbH, Maxfeldstr. 5, 90409 Nürnberg
HRB 36809 (AG Nürnberg), Geschäftsführer: Felix Imendörffer
