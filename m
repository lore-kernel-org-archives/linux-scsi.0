Return-Path: <linux-scsi-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E11CFC25B67
	for <linux-scsi@archiver.kernel.org>; Tue, 24 Oct 2023 00:13:40 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230477AbjJXANl (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Mon, 23 Oct 2023 20:13:41 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41618 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229552AbjJXANk (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Mon, 23 Oct 2023 20:13:40 -0400
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7B68210D;
        Mon, 23 Oct 2023 17:13:38 -0700 (PDT)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1636CC433C7;
        Tue, 24 Oct 2023 00:13:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1698106418;
        bh=QWzmZM2pZFi/m3lyTCNyxOJKR/TbL40gKGd7h1qWV+0=;
        h=Date:Subject:To:Cc:References:From:In-Reply-To:From;
        b=a+nG3m7FdJ7qXCP4Zvlfbs/I0kqrZVQHKMbpdV3lliVJtyr7Jsou+K0/hmPpI3EDT
         1oHmGPeZAsVZiriP9zOaDrCob/rC9uWSNSOBBKe0gBpvs4GapDyote0xpxX7QISQu4
         kEbMiGApSLGJ0BZJvNbguf26N9cSGPd4akU7wS4v3LGSTaiObT+RdC1J4CEGaJCjj0
         LjeexyV2ADgOFuWnhyED1PNxPhHV++nEJWf+BDP6SeGPP3Lvp17C+vISnz0NjL9UJZ
         5rrFD9nDwuToAYGtgqoU5ExidSZ1Njb3OYh/mYiNJWDZ24mzihbt2Ahjktvj/VuSQe
         Igijouoq6VOPA==
Message-ID: <249db38e-43c0-46d7-9e61-7788ee710f42@kernel.org>
Date:   Tue, 24 Oct 2023 09:13:36 +0900
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v14 10/19] scsi: core: Retry unaligned zoned writes
Content-Language: en-US
To:     Bart Van Assche <bvanassche@acm.org>, Jens Axboe <axboe@kernel.dk>
Cc:     linux-block@vger.kernel.org, linux-scsi@vger.kernel.org,
        "Martin K . Petersen" <martin.petersen@oracle.com>,
        Christoph Hellwig <hch@lst.de>, Ming Lei <ming.lei@redhat.com>,
        "James E.J. Bottomley" <jejb@linux.ibm.com>
References: <20231023215638.3405959-1-bvanassche@acm.org>
 <20231023215638.3405959-11-bvanassche@acm.org>
From:   Damien Le Moal <dlemoal@kernel.org>
Organization: Western Digital Research
In-Reply-To: <20231023215638.3405959-11-bvanassche@acm.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On 10/24/23 06:54, Bart Van Assche wrote:
> If zoned writes (REQ_OP_WRITE) for a sequential write required zone have
> a starting LBA that differs from the write pointer, e.g. because zoned
> writes have been reordered, then the storage device will respond with an
> UNALIGNED WRITE COMMAND error. Send commands that failed with an
> unaligned write error to the SCSI error handler if zone write locking is
> disabled. The SCSI error handler will sort SCSI commands per LBA before
> resubmitting these.
> 
> If zone write locking is disabled, increase the number of retries for
> write commands sent to a sequential zone to the maximum number of
> outstanding commands because in the worst case the number of times
> reordered zoned writes have to be retried is (number of outstanding
> writes per sequential zone) - 1.
> 
> Reviewed-by: Damien Le Moal <dlemoal@kernel.org>
> Cc: Martin K. Petersen <martin.petersen@oracle.com>
> Cc: Christoph Hellwig <hch@lst.de>
> Cc: Ming Lei <ming.lei@redhat.com>
> Signed-off-by: Bart Van Assche <bvanassche@acm.org>
> ---
>  drivers/scsi/scsi_error.c | 16 ++++++++++++++++
>  drivers/scsi/scsi_lib.c   |  1 +
>  drivers/scsi/sd.c         |  6 ++++++
>  include/scsi/scsi.h       |  1 +
>  4 files changed, 24 insertions(+)
> 
> diff --git a/drivers/scsi/scsi_error.c b/drivers/scsi/scsi_error.c
> index 8b1eb637ffa8..9a54856fa03b 100644
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
> +		    blk_rq_is_seq_zoned_write(req) &&
> +		    scmd->retries <= scmd->allowed) {
> +			sdev_printk(KERN_INFO, scmd->device,
> +				    "Retrying unaligned write at LBA %#llx.\n",
> +				    scsi_get_lba(scmd));

KERN_INFO ? Did you perhaps mean KERN_DEBUG ? An info message for this will be
way too noisy.

> +			return NEEDS_DELAYED_RETRY;
> +		}
> +
>  		if (sshdr.asc == 0x20 || /* Invalid command operation code */
>  		    sshdr.asc == 0x21 || /* Logical block address out of range */
>  		    sshdr.asc == 0x22 || /* Invalid function */
> diff --git a/drivers/scsi/scsi_lib.c b/drivers/scsi/scsi_lib.c
> index c2f647a7c1b0..33a34693c8a2 100644
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
> index 82abc721b543..4e6b77f5854f 100644
> --- a/drivers/scsi/sd.c
> +++ b/drivers/scsi/sd.c
> @@ -1197,6 +1197,12 @@ static blk_status_t sd_setup_read_write_cmnd(struct scsi_cmnd *cmd)
>  	cmd->transfersize = sdp->sector_size;
>  	cmd->underflow = nr_blocks << 9;
>  	cmd->allowed = sdkp->max_retries;
> +	/*
> +	 * Increase the number of allowed retries for zoned writes if zone
> +	 * write locking is disabled.
> +	 */
> +	if (!rq->q->limits.use_zone_write_lock && blk_rq_is_seq_zoned_write(rq))
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

