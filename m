Return-Path: <linux-scsi-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 25F24C41513
	for <linux-scsi@archiver.kernel.org>; Mon, 14 Aug 2023 12:37:02 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229541AbjHNMga (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Mon, 14 Aug 2023 08:36:30 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36796 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229809AbjHNMgO (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Mon, 14 Aug 2023 08:36:14 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7A381E4A;
        Mon, 14 Aug 2023 05:36:13 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature RSA-PSS (2048 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 17D08618D3;
        Mon, 14 Aug 2023 12:36:13 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4ADF7C433C7;
        Mon, 14 Aug 2023 12:36:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1692016572;
        bh=PewIxFzhI0QdMT3vsDdCq2tb8zokzi+f46xvK8cV81Q=;
        h=Date:Subject:To:Cc:References:From:In-Reply-To:From;
        b=Dw76zc61TMU++pLT2ibKtEDZAGKhuZN3CvOt/T8qnEMrkbc4fZXAYmWosqfdcXRD3
         29FxZLt9DKfJqAK5ExWANDw5sEYsDaJ35p/dfIwkXQu/sgN05AXD+463ml5eFuSB1e
         RJIYPL3r5cXByYFKtZTbRyy8Y8HG9iN1LkzVjmRfLQ5gyy3mPjWx+4qI5BEj+DUmFJ
         6GlDvg/aChBjgDWLhukRJFzOTUY2SwU2po6lmvQSOiPpioa5+MItb13nulIz5XgM3p
         +gn5wvLU4g5Lcyj6egVUVNzl01rJPWp8vsNDFfHTCUcK+igwfvirca8LwBth8G1/x/
         TRhn8CfZYHOng==
Message-ID: <7dd67537-1ad8-79ca-281c-540bade2cb83@kernel.org>
Date:   Mon, 14 Aug 2023 21:36:10 +0900
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.13.0
Subject: Re: [PATCH v8 5/9] scsi: core: Retry unaligned zoned writes
Content-Language: en-US
To:     Bart Van Assche <bvanassche@acm.org>, Jens Axboe <axboe@kernel.dk>
Cc:     linux-block@vger.kernel.org, linux-scsi@vger.kernel.org,
        "Martin K . Petersen" <martin.petersen@oracle.com>,
        Christoph Hellwig <hch@lst.de>, Ming Lei <ming.lei@redhat.com>,
        "James E.J. Bottomley" <jejb@linux.ibm.com>
References: <20230811213604.548235-1-bvanassche@acm.org>
 <20230811213604.548235-6-bvanassche@acm.org>
From:   Damien Le Moal <dlemoal@kernel.org>
Organization: Western Digital Research
In-Reply-To: <20230811213604.548235-6-bvanassche@acm.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On 8/12/23 06:35, Bart Van Assche wrote:
> If zoned writes (REQ_OP_WRITE) for a sequential write required zone have
> a starting LBA that differs from the write pointer, e.g. because zoned
> writes have been reordered, then the storage device will respond with an
> UNALIGNED WRITE COMMAND error. Send commands that failed with an
> unaligned write error to the SCSI error handler if zone write locking is
> disabled. Let the SCSI error handler sort SCSI commands per LBA before
> resubmitting these.
> 
> If zone write locking is disabled, increase the number of retries for
> write commands sent to a sequential zone to the maximum number of
> outstanding commands because in the worst case the number of times
> reordered zoned writes have to be retried is (number of outstanding
> writes per sequential zone) - 1.
> 
> Cc: Martin K. Petersen <martin.petersen@oracle.com>
> Cc: Damien Le Moal <dlemoal@kernel.org>
> Cc: Christoph Hellwig <hch@lst.de>
> Cc: Ming Lei <ming.lei@redhat.com>
> Signed-off-by: Bart Van Assche <bvanassche@acm.org>
> ---
>  drivers/scsi/scsi_error.c | 16 ++++++++++++++++
>  drivers/scsi/scsi_lib.c   |  1 +
>  drivers/scsi/sd.c         |  2 ++
>  include/scsi/scsi.h       |  1 +
>  4 files changed, 20 insertions(+)
> 
> diff --git a/drivers/scsi/scsi_error.c b/drivers/scsi/scsi_error.c
> index 0d7835bdc8af..7ae43fac07b7 100644
> --- a/drivers/scsi/scsi_error.c
> +++ b/drivers/scsi/scsi_error.c
> @@ -699,6 +699,22 @@ enum scsi_disposition scsi_check_sense(struct scsi_cmnd *scmd)
>  		fallthrough;
>  
>  	case ILLEGAL_REQUEST:
> +		/*
> +		 * Unaligned write command. This may indicate that zoned writes
> +		 * have been received by the device in the wrong order. If zone
> +		 * write locking is disabled, retry after all pending commands
> +		 * have completed.
> +		 */
> +		if (sshdr.asc == 0x21 && sshdr.ascq == 0x04 &&
> +		    !req->q->limits.use_zone_write_lock &&
> +		    blk_rq_is_seq_zoned_write(req)) {
> +			SCSI_LOG_ERROR_RECOVERY(3,
> +				sdev_printk(KERN_INFO, scmd->device,
> +					    "Retrying unaligned write at LBA %#llx.\n",
> +					    scsi_get_lba(scmd)));
> +			return NEEDS_DELAYED_RETRY;
> +		}
> +
>  		if (sshdr.asc == 0x20 || /* Invalid command operation code */
>  		    sshdr.asc == 0x21 || /* Logical block address out of range */
>  		    sshdr.asc == 0x22 || /* Invalid function */
> diff --git a/drivers/scsi/scsi_lib.c b/drivers/scsi/scsi_lib.c
> index 59176946ab56..69da8aee13df 100644
> --- a/drivers/scsi/scsi_lib.c
> +++ b/drivers/scsi/scsi_lib.c
> @@ -1443,6 +1443,7 @@ static void scsi_complete(struct request *rq)
>  	case ADD_TO_MLQUEUE:
>  		scsi_queue_insert(cmd, SCSI_MLQUEUE_DEVICE_BUSY);
>  		break;
> +	case NEEDS_DELAYED_RETRY:
>  	default:
>  		scsi_eh_scmd_add(cmd);
>  		break;
> diff --git a/drivers/scsi/sd.c b/drivers/scsi/sd.c
> index 4d9c6ad11cca..c8466c6c7387 100644
> --- a/drivers/scsi/sd.c
> +++ b/drivers/scsi/sd.c
> @@ -1238,6 +1238,8 @@ static blk_status_t sd_setup_read_write_cmnd(struct scsi_cmnd *cmd)
>  	cmd->transfersize = sdp->sector_size;
>  	cmd->underflow = nr_blocks << 9;
>  	cmd->allowed = sdkp->max_retries;
> +	if (!rq->q->limits.use_zone_write_lock && blk_rq_is_seq_zoned_write(rq))

This condition could be written as a little inline helper
blk_req_need_zone_write_lock(), which could be used in mq-dealine patch 2.

> +		cmd->allowed += rq->q->nr_requests;
>  	cmd->sdb.length = nr_blocks * sdp->sector_size;
>  
>  	SCSI_LOG_HLQUEUE(1,
> diff --git a/include/scsi/scsi.h b/include/scsi/scsi.h
> index ec093594ba53..6600db046227 100644
> --- a/include/scsi/scsi.h
> +++ b/include/scsi/scsi.h
> @@ -93,6 +93,7 @@ static inline int scsi_status_is_check_condition(int status)
>   * Internal return values.
>   */
>  enum scsi_disposition {
> +	NEEDS_DELAYED_RETRY	= 0x2000,
>  	NEEDS_RETRY		= 0x2001,
>  	SUCCESS			= 0x2002,
>  	FAILED			= 0x2003,

-- 
Damien Le Moal
Western Digital Research

