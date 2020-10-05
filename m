Return-Path: <SRS0=3mnS=DM=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-11.3 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,NICE_REPLY_A,
	SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_SANE_1
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 550E1C4363A
	for <linux-scsi@archiver.kernel.org>; Mon,  5 Oct 2020 09:05:18 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 12A5A20674
	for <linux-scsi@archiver.kernel.org>; Mon,  5 Oct 2020 09:05:18 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725893AbgJEJFR (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Mon, 5 Oct 2020 05:05:17 -0400
Received: from mx2.suse.de ([195.135.220.15]:57542 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725885AbgJEJFR (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
        Mon, 5 Oct 2020 05:05:17 -0400
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
Received: from relay2.suse.de (unknown [195.135.221.27])
        by mx2.suse.de (Postfix) with ESMTP id A364BB134;
        Mon,  5 Oct 2020 09:05:16 +0000 (UTC)
Subject: Re: [PATCH 07/10] scsi: rename scsi_mq_prep_fn to scsi_prepare_cmd
To:     Christoph Hellwig <hch@lst.de>,
        "Martin K. Petersen" <martin.petersen@oracle.com>
Cc:     linux-scsi@vger.kernel.org
References: <20201005084130.143273-1-hch@lst.de>
 <20201005084130.143273-8-hch@lst.de>
From:   Hannes Reinecke <hare@suse.de>
Message-ID: <e09f34b1-2d42-ccb5-84a1-52219ce1a531@suse.de>
Date:   Mon, 5 Oct 2020 11:05:16 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.12.0
MIME-Version: 1.0
In-Reply-To: <20201005084130.143273-8-hch@lst.de>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On 10/5/20 10:41 AM, Christoph Hellwig wrote:
> The old name is rather confusing now that the the legacy prep_fn is gone.
> 
> Signed-off-by: Christoph Hellwig <hch@lst.de>
> ---
>   drivers/scsi/scsi_lib.c | 4 ++--
>   1 file changed, 2 insertions(+), 2 deletions(-)
> 
> diff --git a/drivers/scsi/scsi_lib.c b/drivers/scsi/scsi_lib.c
> index 3940641052f90b..8420e42d618bb0 100644
> --- a/drivers/scsi/scsi_lib.c
> +++ b/drivers/scsi/scsi_lib.c
> @@ -1562,7 +1562,7 @@ static unsigned int scsi_mq_inline_sgl_size(struct Scsi_Host *shost)
>   		sizeof(struct scatterlist);
>   }
>   
> -static blk_status_t scsi_mq_prep_fn(struct request *req)
> +static blk_status_t scsi_prepare_cmd(struct request *req)
>   {
>   	struct scsi_cmnd *cmd = blk_mq_rq_to_pdu(req);
>   	struct scsi_device *sdev = req->q->queuedata;
> @@ -1665,7 +1665,7 @@ static blk_status_t scsi_queue_rq(struct blk_mq_hw_ctx *hctx,
>   		goto out_dec_target_busy;
>   
>   	if (!(req->rq_flags & RQF_DONTPREP)) {
> -		ret = scsi_mq_prep_fn(req);
> +		ret = scsi_prepare_cmd(req);
>   		if (ret != BLK_STS_OK)
>   			goto out_dec_host_busy;
>   		req->rq_flags |= RQF_DONTPREP;
> 
Reviewed-by: Hannes Reinecke <hare@suse.de>

Cheers,

Hannes
-- 
Dr. Hannes Reinecke                Kernel Storage Architect
hare@suse.de                              +49 911 74053 688
SUSE Software Solutions GmbH, Maxfeldstr. 5, 90409 Nürnberg
HRB 36809 (AG Nürnberg), Geschäftsführer: Felix Imendörffer
