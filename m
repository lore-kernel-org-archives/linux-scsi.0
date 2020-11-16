Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-11.2 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,NICE_REPLY_A,
	SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_SANE_1
	autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 164DEC4742C
	for <linux-scsi@archiver.kernel.org>; Mon, 16 Nov 2020 10:21:51 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id CA4CA2137B
	for <linux-scsi@archiver.kernel.org>; Mon, 16 Nov 2020 10:21:50 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728639AbgKPJpF (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Mon, 16 Nov 2020 04:45:05 -0500
Received: from mx2.suse.de ([195.135.220.15]:37152 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726598AbgKPJpF (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
        Mon, 16 Nov 2020 04:45:05 -0500
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
Received: from relay2.suse.de (unknown [195.135.221.27])
        by mx2.suse.de (Postfix) with ESMTP id 5A9B5ACF1;
        Mon, 16 Nov 2020 09:44:55 +0000 (UTC)
Subject: Re: [PATCH V4 11/12] scsi: make sure sdev->queue_depth is <=
 max(shost->can_queue, 1024)
To:     Ming Lei <ming.lei@redhat.com>, Jens Axboe <axboe@kernel.dk>,
        linux-block@vger.kernel.org,
        "Martin K . Petersen" <martin.petersen@oracle.com>,
        linux-scsi@vger.kernel.org
Cc:     Omar Sandoval <osandov@fb.com>,
        Kashyap Desai <kashyap.desai@broadcom.com>,
        Sumanesh Samanta <sumanesh.samanta@broadcom.com>,
        "Ewan D . Milne" <emilne@redhat.com>
References: <20201116090737.50989-1-ming.lei@redhat.com>
 <20201116090737.50989-12-ming.lei@redhat.com>
From:   Hannes Reinecke <hare@suse.de>
Message-ID: <4479fc11-5c4f-e575-a253-e08c841c5cb2@suse.de>
Date:   Mon, 16 Nov 2020 10:44:54 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.4.0
MIME-Version: 1.0
In-Reply-To: <20201116090737.50989-12-ming.lei@redhat.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On 11/16/20 10:07 AM, Ming Lei wrote:
> Limit scsi device's queue depth is less than max(host->can_queue, 1024)
> in scsi_change_queue_depth(), and 1024 is big enough for saturating
> current fast SCSI LUN(SSD, or raid volume on multiple SSDs).
> 
> We need this patch for replacing sdev->device_busy with sbitmap which
> has to be pre-allocated with reasonable max depth.
> 
> Cc: Omar Sandoval <osandov@fb.com>
> Cc: Kashyap Desai <kashyap.desai@broadcom.com>
> Cc: Sumanesh Samanta <sumanesh.samanta@broadcom.com>
> Cc: Ewan D. Milne <emilne@redhat.com>
> Tested-by: Sumanesh Samanta <sumanesh.samanta@broadcom.com>
> Signed-off-by: Ming Lei <ming.lei@redhat.com>
> ---
>   drivers/scsi/scsi.c | 11 +++++++++++
>   1 file changed, 11 insertions(+)
> 
> diff --git a/drivers/scsi/scsi.c b/drivers/scsi/scsi.c
> index 24619c3bebd5..a28d48c850cf 100644
> --- a/drivers/scsi/scsi.c
> +++ b/drivers/scsi/scsi.c
> @@ -214,6 +214,15 @@ void scsi_finish_command(struct scsi_cmnd *cmd)
>   	scsi_io_completion(cmd, good_bytes);
>   }
>   
> +
> +/*
> + * 1024 is big enough for saturating the fast scsi LUN now
> + */
> +static int scsi_device_max_queue_depth(struct scsi_device *sdev)
> +{
> +	return max_t(int, sdev->host->can_queue, 1024);
> +}
> +

Shouldn't this rather be initialized with scsi_host->can_queue?
These 'should be enough' settings inevitable turn out to be not enough 
in the long run ...

>   /**
>    * scsi_change_queue_depth - change a device's queue depth
>    * @sdev: SCSI Device in question
> @@ -223,6 +232,8 @@ void scsi_finish_command(struct scsi_cmnd *cmd)
>    */
>   int scsi_change_queue_depth(struct scsi_device *sdev, int depth)
>   {
> +	depth = min_t(int, depth, scsi_device_max_queue_depth(sdev));
> +
>   	if (depth > 0) {
>   		sdev->queue_depth = depth;
>   		wmb();
> 

Cheers,

Hannes
-- 
Dr. Hannes Reinecke                Kernel Storage Architect
hare@suse.de                              +49 911 74053 688
SUSE Software Solutions GmbH, Maxfeldstr. 5, 90409 Nürnberg
HRB 36809 (AG Nürnberg), Geschäftsführer: Felix Imendörffer
