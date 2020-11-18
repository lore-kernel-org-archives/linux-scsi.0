Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-13.7 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id CCEFBC2D0E4
	for <linux-scsi@archiver.kernel.org>; Wed, 18 Nov 2020 01:16:43 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 64C3A2467B
	for <linux-scsi@archiver.kernel.org>; Wed, 18 Nov 2020 01:16:43 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=mg.codeaurora.org header.i=@mg.codeaurora.org header.b="j4F62rz5"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727892AbgKRBQn (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Tue, 17 Nov 2020 20:16:43 -0500
Received: from z5.mailgun.us ([104.130.96.5]:60158 "EHLO z5.mailgun.us"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727799AbgKRBQm (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
        Tue, 17 Nov 2020 20:16:42 -0500
DKIM-Signature: a=rsa-sha256; v=1; c=relaxed/relaxed; d=mg.codeaurora.org; q=dns/txt;
 s=smtp; t=1605662202; h=Message-ID: References: In-Reply-To: Subject:
 Cc: To: From: Date: Content-Transfer-Encoding: Content-Type:
 MIME-Version: Sender; bh=S3OsnT7WBsOZw0pPhJfJFSWfJOugU3ON2U55HaDPeZw=;
 b=j4F62rz58a1KO7mbXRfzKiPPWiPoi2EEBA3kncCQvEGO3Kktv4hRLX9/uj3N+kZbGUWSI1Sc
 Mjpgp7jZo+eUDX9HD9kz6eUMpegRTK0FVIdG/rgh3iA05uMMVCDqy+/RSWlGCep+QMOOVRUI
 cX14EZJUktwa7e+a/Z4StqQAQTM=
X-Mailgun-Sending-Ip: 104.130.96.5
X-Mailgun-Sid: WyJlNmU5NiIsICJsaW51eC1zY3NpQHZnZXIua2VybmVsLm9yZyIsICJiZTllNGEiXQ==
Received: from smtp.codeaurora.org
 (ec2-35-166-182-171.us-west-2.compute.amazonaws.com [35.166.182.171]) by
 smtp-out-n09.prod.us-east-1.postgun.com with SMTP id
 5fb475d107fe4e8a18b37804 (version=TLS1.2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256); Wed, 18 Nov 2020 01:16:01
 GMT
Sender: cang=codeaurora.org@mg.codeaurora.org
Received: by smtp.codeaurora.org (Postfix, from userid 1001)
        id B6EBDC43465; Wed, 18 Nov 2020 01:15:59 +0000 (UTC)
Received: from mail.codeaurora.org (localhost.localdomain [127.0.0.1])
        (using TLSv1 with cipher ECDHE-RSA-AES256-SHA (256/256 bits))
        (No client certificate requested)
        (Authenticated sender: cang)
        by smtp.codeaurora.org (Postfix) with ESMTPSA id B70C0C433C6;
        Wed, 18 Nov 2020 01:15:58 +0000 (UTC)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII;
 format=flowed
Content-Transfer-Encoding: 7bit
Date:   Wed, 18 Nov 2020 09:15:58 +0800
From:   Can Guo <cang@codeaurora.org>
To:     Bart Van Assche <bvanassche@acm.org>
Cc:     "Martin K . Petersen" <martin.petersen@oracle.com>,
        "James E . J . Bottomley" <jejb@linux.vnet.ibm.com>,
        Jens Axboe <axboe@kernel.dk>, Christoph Hellwig <hch@lst.de>,
        linux-scsi@vger.kernel.org, linux-block@vger.kernel.org,
        Alan Stern <stern@rowland.harvard.edu>,
        Stanley Chu <stanley.chu@mediatek.com>,
        Ming Lei <ming.lei@redhat.com>,
        "Rafael J . Wysocki" <rafael.j.wysocki@intel.com>
Subject: Re: [PATCH v2 4/9] scsi: Rework scsi_mq_alloc_queue()
In-Reply-To: <20201116030459.13963-5-bvanassche@acm.org>
References: <20201116030459.13963-1-bvanassche@acm.org>
 <20201116030459.13963-5-bvanassche@acm.org>
Message-ID: <56f0d82c4a611176382bb434b366f30d@codeaurora.org>
X-Sender: cang@codeaurora.org
User-Agent: Roundcube Webmail/1.3.9
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On 2020-11-16 11:04, Bart Van Assche wrote:
> Do not modify sdev->request_queue. Remove the sdev->request_queue
> assignment. That assignment is superfluous because 
> scsi_mq_alloc_queue()
> only has one caller and that caller calls scsi_mq_alloc_queue() as 
> follows:
> 
> 	sdev->request_queue = scsi_mq_alloc_queue(sdev);
> 
> Cc: Martin K. Petersen <martin.petersen@oracle.com>
> Reviewed-by: Alan Stern <stern@rowland.harvard.edu>
> Cc: Can Guo <cang@codeaurora.org>
> Cc: Stanley Chu <stanley.chu@mediatek.com>
> Cc: Ming Lei <ming.lei@redhat.com>
> Cc: Rafael J. Wysocki <rafael.j.wysocki@intel.com>
> Signed-off-by: Bart Van Assche <bvanassche@acm.org>

Reviewed-by: Can Guo <cang@codeaurora.org>

> ---
>  drivers/scsi/scsi_lib.c | 13 +++++++------
>  1 file changed, 7 insertions(+), 6 deletions(-)
> 
> diff --git a/drivers/scsi/scsi_lib.c b/drivers/scsi/scsi_lib.c
> index e4f9ed355be6..ff480fa6261e 100644
> --- a/drivers/scsi/scsi_lib.c
> +++ b/drivers/scsi/scsi_lib.c
> @@ -1883,14 +1883,15 @@ static const struct blk_mq_ops scsi_mq_ops = {
> 
>  struct request_queue *scsi_mq_alloc_queue(struct scsi_device *sdev)
>  {
> -	sdev->request_queue = blk_mq_init_queue(&sdev->host->tag_set);
> -	if (IS_ERR(sdev->request_queue))
> +	struct request_queue *q = blk_mq_init_queue(&sdev->host->tag_set);
> +
> +	if (IS_ERR(q))
>  		return NULL;
> 
> -	sdev->request_queue->queuedata = sdev;
> -	__scsi_init_queue(sdev->host, sdev->request_queue);
> -	blk_queue_flag_set(QUEUE_FLAG_SCSI_PASSTHROUGH, sdev->request_queue);
> -	return sdev->request_queue;
> +	q->queuedata = sdev;
> +	__scsi_init_queue(sdev->host, q);
> +	blk_queue_flag_set(QUEUE_FLAG_SCSI_PASSTHROUGH, q);
> +	return q;
>  }
> 
>  int scsi_mq_setup_tags(struct Scsi_Host *shost)
