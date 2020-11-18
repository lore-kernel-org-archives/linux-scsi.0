Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-13.7 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 5BC86C63697
	for <linux-scsi@archiver.kernel.org>; Wed, 18 Nov 2020 01:18:07 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 0A87E2468F
	for <linux-scsi@archiver.kernel.org>; Wed, 18 Nov 2020 01:18:06 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=mg.codeaurora.org header.i=@mg.codeaurora.org header.b="jKbGPKlD"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728173AbgKRBRs (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Tue, 17 Nov 2020 20:17:48 -0500
Received: from m42-4.mailgun.net ([69.72.42.4]:60191 "EHLO m42-4.mailgun.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728108AbgKRBRs (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
        Tue, 17 Nov 2020 20:17:48 -0500
DKIM-Signature: a=rsa-sha256; v=1; c=relaxed/relaxed; d=mg.codeaurora.org; q=dns/txt;
 s=smtp; t=1605662267; h=Message-ID: References: In-Reply-To: Subject:
 Cc: To: From: Date: Content-Transfer-Encoding: Content-Type:
 MIME-Version: Sender; bh=5XQByVUvlWUVycj5rik9R8cDN4tyCqm0E6x+H2Dx820=;
 b=jKbGPKlDPdpxT1iwSuhTXp2yGXHIEqRR2QnLXE9CiiOH1xSQ+boK8WasI3MXM0sS4TJ8sj7I
 J6OVps+XfN7elR/JHZaqEliUecP4WMvTv30BogROJ9I99SNUNXSDN9mKfCnIMhwic/4Y15QH
 FcR6sVeqTmX8nwwYESrbuV7OkeI=
X-Mailgun-Sending-Ip: 69.72.42.4
X-Mailgun-Sid: WyJlNmU5NiIsICJsaW51eC1zY3NpQHZnZXIua2VybmVsLm9yZyIsICJiZTllNGEiXQ==
Received: from smtp.codeaurora.org
 (ec2-35-166-182-171.us-west-2.compute.amazonaws.com [35.166.182.171]) by
 smtp-out-n06.prod.us-west-2.postgun.com with SMTP id
 5fb476028e090a888674134c (version=TLS1.2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256); Wed, 18 Nov 2020 01:16:50
 GMT
Sender: cang=codeaurora.org@mg.codeaurora.org
Received: by smtp.codeaurora.org (Postfix, from userid 1001)
        id 48B06C433C6; Wed, 18 Nov 2020 01:16:50 +0000 (UTC)
Received: from mail.codeaurora.org (localhost.localdomain [127.0.0.1])
        (using TLSv1 with cipher ECDHE-RSA-AES256-SHA (256/256 bits))
        (No client certificate requested)
        (Authenticated sender: cang)
        by smtp.codeaurora.org (Postfix) with ESMTPSA id 81801C433ED;
        Wed, 18 Nov 2020 01:16:48 +0000 (UTC)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII;
 format=flowed
Content-Transfer-Encoding: 7bit
Date:   Wed, 18 Nov 2020 09:16:48 +0800
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
Subject: Re: [PATCH v2 3/9] scsi: Pass a request queue pointer to
 __scsi_execute()
In-Reply-To: <20201116030459.13963-4-bvanassche@acm.org>
References: <20201116030459.13963-1-bvanassche@acm.org>
 <20201116030459.13963-4-bvanassche@acm.org>
Message-ID: <175c8fc78b6c3781ba17a9137eaf7dbc@codeaurora.org>
X-Sender: cang@codeaurora.org
User-Agent: Roundcube Webmail/1.3.9
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On 2020-11-16 11:04, Bart Van Assche wrote:
> This patch does not change any functionality but makes a later patch 
> easier
> to read.
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
>  drivers/scsi/scsi_lib.c    | 12 +++++-------
>  include/scsi/scsi_device.h |  8 ++++----
>  2 files changed, 9 insertions(+), 11 deletions(-)
> 
> diff --git a/drivers/scsi/scsi_lib.c b/drivers/scsi/scsi_lib.c
> index 855e48c7514f..e4f9ed355be6 100644
> --- a/drivers/scsi/scsi_lib.c
> +++ b/drivers/scsi/scsi_lib.c
> @@ -221,7 +221,7 @@ void scsi_queue_insert(struct scsi_cmnd *cmd, int 
> reason)
> 
>  /**
>   * __scsi_execute - insert request and wait for the result
> - * @sdev:	scsi device
> + * @q:		queue to insert the request into
>   * @cmd:	scsi command
>   * @data_direction: data direction
>   * @buffer:	data buffer
> @@ -237,7 +237,7 @@ void scsi_queue_insert(struct scsi_cmnd *cmd, int 
> reason)
>   * Returns the scsi_cmnd result field if a command was executed, or a 
> negative
>   * Linux error code if we didn't get that far.
>   */
> -int __scsi_execute(struct scsi_device *sdev, const unsigned char *cmd,
> +int __scsi_execute(struct request_queue *q, const unsigned char *cmd,
>  		 int data_direction, void *buffer, unsigned bufflen,
>  		 unsigned char *sense, struct scsi_sense_hdr *sshdr,
>  		 int timeout, int retries, u64 flags, req_flags_t rq_flags,
> @@ -247,15 +247,13 @@ int __scsi_execute(struct scsi_device *sdev,
> const unsigned char *cmd,
>  	struct scsi_request *rq;
>  	int ret = DRIVER_ERROR << 24;
> 
> -	req = blk_get_request(sdev->request_queue,
> -			data_direction == DMA_TO_DEVICE ?
> +	req = blk_get_request(q, data_direction == DMA_TO_DEVICE ?
>  			REQ_OP_SCSI_OUT : REQ_OP_SCSI_IN, BLK_MQ_REQ_PREEMPT);
>  	if (IS_ERR(req))
>  		return ret;
>  	rq = scsi_req(req);
> 
> -	if (bufflen &&	blk_rq_map_kern(sdev->request_queue, req,
> -					buffer, bufflen, GFP_NOIO))
> +	if (bufflen && blk_rq_map_kern(q, req, buffer, bufflen, GFP_NOIO))
>  		goto out;
> 
>  	rq->cmd_len = COMMAND_SIZE(cmd[0]);
> @@ -268,7 +266,7 @@ int __scsi_execute(struct scsi_device *sdev, const
> unsigned char *cmd,
>  	/*
>  	 * head injection *required* here otherwise quiesce won't work
>  	 */
> -	blk_execute_rq(req->q, NULL, req, 1);
> +	blk_execute_rq(q, NULL, req, 1);
> 
>  	/*
>  	 * Some devices (USB mass-storage in particular) may transfer
> diff --git a/include/scsi/scsi_device.h b/include/scsi/scsi_device.h
> index 1a5c9a3df6d6..f47fdf9cf788 100644
> --- a/include/scsi/scsi_device.h
> +++ b/include/scsi/scsi_device.h
> @@ -438,7 +438,7 @@ extern const char *scsi_device_state_name(enum
> scsi_device_state);
>  extern int scsi_is_sdev_device(const struct device *);
>  extern int scsi_is_target_device(const struct device *);
>  extern void scsi_sanitize_inquiry_string(unsigned char *s, int len);
> -extern int __scsi_execute(struct scsi_device *sdev, const unsigned 
> char *cmd,
> +extern int __scsi_execute(struct request_queue *q, const unsigned char 
> *cmd,
>  			int data_direction, void *buffer, unsigned bufflen,
>  			unsigned char *sense, struct scsi_sense_hdr *sshdr,
>  			int timeout, int retries, u64 flags,
> @@ -449,9 +449,9 @@ extern int __scsi_execute(struct scsi_device
> *sdev, const unsigned char *cmd,
>  ({									\
>  	BUILD_BUG_ON((sense) != NULL &&					\
>  		     sizeof(sense) != SCSI_SENSE_BUFFERSIZE);		\
> -	__scsi_execute(sdev, cmd, data_direction, buffer, bufflen,	\
> -		       sense, sshdr, timeout, retries, flags, rq_flags,	\
> -		       resid);						\
> +	__scsi_execute(sdev->request_queue, cmd, data_direction,	\
> +		       buffer, bufflen, sense, sshdr, timeout, retries,	\
> +		       flags, rq_flags, resid);				\
>  })
>  static inline int scsi_execute_req(struct scsi_device *sdev,
>  	const unsigned char *cmd, int data_direction, void *buffer,
