Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-13.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=unavailable
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 493A5C56201
	for <linux-scsi@archiver.kernel.org>; Tue, 24 Nov 2020 09:49:58 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id E09CC20782
	for <linux-scsi@archiver.kernel.org>; Tue, 24 Nov 2020 09:49:57 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=mg.codeaurora.org header.i=@mg.codeaurora.org header.b="uQkDXIHR"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731501AbgKXJt5 (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Tue, 24 Nov 2020 04:49:57 -0500
Received: from z5.mailgun.us ([104.130.96.5]:49738 "EHLO z5.mailgun.us"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1731107AbgKXJty (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
        Tue, 24 Nov 2020 04:49:54 -0500
DKIM-Signature: a=rsa-sha256; v=1; c=relaxed/relaxed; d=mg.codeaurora.org; q=dns/txt;
 s=smtp; t=1606211394; h=Message-ID: References: In-Reply-To: Subject:
 Cc: To: From: Date: Content-Transfer-Encoding: Content-Type:
 MIME-Version: Sender; bh=regJnaMuaNUgXY6ADtm563Pj/Q0R60a6laUtEhUk5E8=;
 b=uQkDXIHRfH/RYszhlQHoQUz9G1bgxnS4jR4pLUZcZmhd/kDyrddnX+4zp+hB54hf++Q3u7b9
 ocjgg/LWX01P3w1s5VRXjLRP/DMU8g6TdxdHuDkZjt56UlkRYZ2JraDLsftwgI61pSgnEhHA
 wGo1gfkte7e19O/2hHGOdY4dWSY=
X-Mailgun-Sending-Ip: 104.130.96.5
X-Mailgun-Sid: WyJlNmU5NiIsICJsaW51eC1zY3NpQHZnZXIua2VybmVsLm9yZyIsICJiZTllNGEiXQ==
Received: from smtp.codeaurora.org
 (ec2-35-166-182-171.us-west-2.compute.amazonaws.com [35.166.182.171]) by
 smtp-out-n03.prod.us-east-1.postgun.com with SMTP id
 5fbcd73d7f0cfa6a16a8507d (version=TLS1.2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256); Tue, 24 Nov 2020 09:49:49
 GMT
Sender: cang=codeaurora.org@mg.codeaurora.org
Received: by smtp.codeaurora.org (Postfix, from userid 1001)
        id BB039C43462; Tue, 24 Nov 2020 09:49:48 +0000 (UTC)
Received: from mail.codeaurora.org (localhost.localdomain [127.0.0.1])
        (using TLSv1 with cipher ECDHE-RSA-AES256-SHA (256/256 bits))
        (No client certificate requested)
        (Authenticated sender: cang)
        by smtp.codeaurora.org (Postfix) with ESMTPSA id 469C9C433C6;
        Tue, 24 Nov 2020 09:49:47 +0000 (UTC)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII;
 format=flowed
Content-Transfer-Encoding: 7bit
Date:   Tue, 24 Nov 2020 17:49:47 +0800
From:   Can Guo <cang@codeaurora.org>
To:     Bart Van Assche <bvanassche@acm.org>
Cc:     "Martin K . Petersen" <martin.petersen@oracle.com>,
        "James E . J . Bottomley" <jejb@linux.vnet.ibm.com>,
        Jens Axboe <axboe@kernel.dk>, Christoph Hellwig <hch@lst.de>,
        Ming Lei <ming.lei@redhat.com>, linux-scsi@vger.kernel.org,
        linux-block@vger.kernel.org,
        Alan Stern <stern@rowland.harvard.edu>,
        Stanley Chu <stanley.chu@mediatek.com>,
        "Rafael J . Wysocki" <rafael.j.wysocki@intel.com>
Subject: Re: [PATCH v3 4/9] scsi: Inline scsi_mq_alloc_queue()
In-Reply-To: <20201123031749.14912-5-bvanassche@acm.org>
References: <20201123031749.14912-1-bvanassche@acm.org>
 <20201123031749.14912-5-bvanassche@acm.org>
Message-ID: <4c1b1cf7d3f2a5fa3e479735303b9c59@codeaurora.org>
X-Sender: cang@codeaurora.org
User-Agent: Roundcube Webmail/1.3.9
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On 2020-11-23 11:17, Bart Van Assche wrote:
> Since scsi_mq_alloc_queue() only has one caller, inline it. This change
> was suggested by Christoph Hellwig.
> 
> Cc: Christoph Hellwig <hch@lst.de>
> Cc: Alan Stern <stern@rowland.harvard.edu>
> Cc: Can Guo <cang@codeaurora.org>
> Cc: Stanley Chu <stanley.chu@mediatek.com>
> Cc: Ming Lei <ming.lei@redhat.com>
> Cc: Rafael J. Wysocki <rafael.j.wysocki@intel.com>
> Signed-off-by: Bart Van Assche <bvanassche@acm.org>

Reviewed-by: Can Guo <cang@codeaurora.org>

> ---
>  drivers/scsi/scsi_lib.c  | 12 ------------
>  drivers/scsi/scsi_priv.h |  1 -
>  drivers/scsi/scsi_scan.c | 12 ++++++++----
>  3 files changed, 8 insertions(+), 17 deletions(-)
> 
> diff --git a/drivers/scsi/scsi_lib.c b/drivers/scsi/scsi_lib.c
> index a7252df74c7b..b5449efc7283 100644
> --- a/drivers/scsi/scsi_lib.c
> +++ b/drivers/scsi/scsi_lib.c
> @@ -1881,18 +1881,6 @@ static const struct blk_mq_ops scsi_mq_ops = {
>  	.map_queues	= scsi_map_queues,
>  };
> 
> -struct request_queue *scsi_mq_alloc_queue(struct scsi_device *sdev)
> -{
> -	sdev->request_queue = blk_mq_init_queue(&sdev->host->tag_set);
> -	if (IS_ERR(sdev->request_queue))
> -		return NULL;
> -
> -	sdev->request_queue->queuedata = sdev;
> -	__scsi_init_queue(sdev->host, sdev->request_queue);
> -	blk_queue_flag_set(QUEUE_FLAG_SCSI_PASSTHROUGH, sdev->request_queue);
> -	return sdev->request_queue;
> -}
> -
>  int scsi_mq_setup_tags(struct Scsi_Host *shost)
>  {
>  	unsigned int cmd_size, sgl_size;
> diff --git a/drivers/scsi/scsi_priv.h b/drivers/scsi/scsi_priv.h
> index 180636d54982..e34755986b47 100644
> --- a/drivers/scsi/scsi_priv.h
> +++ b/drivers/scsi/scsi_priv.h
> @@ -90,7 +90,6 @@ extern void scsi_queue_insert(struct scsi_cmnd *cmd,
> int reason);
>  extern void scsi_io_completion(struct scsi_cmnd *, unsigned int);
>  extern void scsi_run_host_queues(struct Scsi_Host *shost);
>  extern void scsi_requeue_run_queue(struct work_struct *work);
> -extern struct request_queue *scsi_mq_alloc_queue(struct scsi_device 
> *sdev);
>  extern void scsi_start_queue(struct scsi_device *sdev);
>  extern int scsi_mq_setup_tags(struct Scsi_Host *shost);
>  extern void scsi_mq_destroy_tags(struct Scsi_Host *shost);
> diff --git a/drivers/scsi/scsi_scan.c b/drivers/scsi/scsi_scan.c
> index f2437a7570ce..43416e7259a7 100644
> --- a/drivers/scsi/scsi_scan.c
> +++ b/drivers/scsi/scsi_scan.c
> @@ -216,6 +216,7 @@ static struct scsi_device *scsi_alloc_sdev(struct
> scsi_target *starget,
>  					   u64 lun, void *hostdata)
>  {
>  	struct scsi_device *sdev;
> +	struct request_queue *q;
>  	int display_failure_msg = 1, ret;
>  	struct Scsi_Host *shost = dev_to_shost(starget->dev.parent);
> 
> @@ -265,16 +266,19 @@ static struct scsi_device
> *scsi_alloc_sdev(struct scsi_target *starget,
>  	 */
>  	sdev->borken = 1;
> 
> -	sdev->request_queue = scsi_mq_alloc_queue(sdev);
> -	if (!sdev->request_queue) {
> +	q = blk_mq_init_queue(&sdev->host->tag_set);
> +	if (IS_ERR(q)) {
>  		/* release fn is set up in scsi_sysfs_device_initialise, so
>  		 * have to free and put manually here */
>  		put_device(&starget->dev);
>  		kfree(sdev);
>  		goto out;
>  	}
> -	WARN_ON_ONCE(!blk_get_queue(sdev->request_queue));
> -	sdev->request_queue->queuedata = sdev;
> +	sdev->request_queue = q;
> +	q->queuedata = sdev;
> +	__scsi_init_queue(sdev->host, q);
> +	blk_queue_flag_set(QUEUE_FLAG_SCSI_PASSTHROUGH, q);
> +	WARN_ON_ONCE(!blk_get_queue(q));
> 
>  	scsi_change_queue_depth(sdev, sdev->host->cmd_per_lun ?
>  					sdev->host->cmd_per_lun : 1);
