Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 51569C43334
	for <linux-scsi@archiver.kernel.org>; Wed, 29 Jun 2022 06:02:44 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229590AbiF2GCo (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Wed, 29 Jun 2022 02:02:44 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42592 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229462AbiF2GCn (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Wed, 29 Jun 2022 02:02:43 -0400
Received: from smtp-out2.suse.de (smtp-out2.suse.de [195.135.220.29])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0BF742A967
        for <linux-scsi@vger.kernel.org>; Tue, 28 Jun 2022 23:02:40 -0700 (PDT)
Received: from imap2.suse-dmz.suse.de (imap2.suse-dmz.suse.de [192.168.254.74])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature ECDSA (P-521) server-digest SHA512)
        (No client certificate requested)
        by smtp-out2.suse.de (Postfix) with ESMTPS id A9BDA1FE7B;
        Wed, 29 Jun 2022 06:02:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
        t=1656482558; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=BEpEiZKiVluj0Gb8tEkG7ZAv3ffV2dtryEYIy4y937U=;
        b=D/ONilLkftXecgDPpIrd6oik6wtMOKYSTD+ESMHPtf63UJHk83T8+FDy1N+eMfL5ll13et
        TV9b8NB9WwEZs4D6+lXWxjlvO/QUWpd8I5wfkQu7OWmTj6nCE7HGUi/N68epHE+1bWg0dn
        ELzwNOvYsX/IbXvKoInpz9ZBHreHohc=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
        s=susede2_ed25519; t=1656482558;
        h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=BEpEiZKiVluj0Gb8tEkG7ZAv3ffV2dtryEYIy4y937U=;
        b=Iw5ntBf6xw9q5E3sc0bx+OtkNZi/zxE74Jmw0fmkNl+nTUkD7IbVoSSXO7n+fe3t8NfRuc
        4ThMwfbrVKJomUAg==
Received: from imap2.suse-dmz.suse.de (imap2.suse-dmz.suse.de [192.168.254.74])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature ECDSA (P-521) server-digest SHA512)
        (No client certificate requested)
        by imap2.suse-dmz.suse.de (Postfix) with ESMTPS id 7DD84132C0;
        Wed, 29 Jun 2022 06:02:38 +0000 (UTC)
Received: from dovecot-director2.suse.de ([192.168.254.65])
        by imap2.suse-dmz.suse.de with ESMTPSA
        id VgxJHf7qu2KXLwAAMHmgww
        (envelope-from <hare@suse.de>); Wed, 29 Jun 2022 06:02:38 +0000
Message-ID: <64551444-39fd-2853-7ea8-053d023df75d@suse.de>
Date:   Wed, 29 Jun 2022 08:02:38 +0200
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.10.0
Subject: Re: [PATCH 3/3] scsi: sd: Rework asynchronous resume support
Content-Language: en-US
To:     Bart Van Assche <bvanassche@acm.org>,
        "Martin K . Petersen" <martin.petersen@oracle.com>
Cc:     Jaegeuk Kim <jaegeuk@kernel.org>, linux-scsi@vger.kernel.org,
        Ming Lei <ming.lei@redhat.com>,
        John Garry <john.garry@huawei.com>, ericspero@icloud.com,
        jason600.groome@gmail.com
References: <20220628222131.14780-1-bvanassche@acm.org>
 <20220628222131.14780-4-bvanassche@acm.org>
From:   Hannes Reinecke <hare@suse.de>
In-Reply-To: <20220628222131.14780-4-bvanassche@acm.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On 6/29/22 00:21, Bart Van Assche wrote:
> For some technologies, e.g. an ATA bus, resuming can take multiple
> seconds. Waiting for resume to finish can cause a very noticeable delay.
> Hence this patch that restores the behavior from before patch "scsi:
> core: pm: Rely on the device driver core for async power management" for
> most SCSI devices.
> 
> This patch introduces a behavior change: if the START command fails, do
> not consider this as a SCSI disk resume failure.
> 
> Cc: Ming Lei <ming.lei@redhat.com>
> Cc: Hannes Reinecke <hare@suse.de>
> Cc: John Garry <john.garry@huawei.com>
> Cc: ericspero@icloud.com
> Cc: jason600.groome@gmail.com
> Tested-by: jason600.groome@gmail.com
> Link: https://bugzilla.kernel.org/show_bug.cgi?id=215880
> Fixes: a19a93e4c6a9 ("scsi: core: pm: Rely on the device driver core for async power management")
> Signed-off-by: Bart Van Assche <bvanassche@acm.org>
> ---
>   drivers/scsi/sd.c | 79 ++++++++++++++++++++++++++++++++++++-----------
>   drivers/scsi/sd.h |  5 +++
>   2 files changed, 66 insertions(+), 18 deletions(-)
> 
> diff --git a/drivers/scsi/sd.c b/drivers/scsi/sd.c
> index 895b56c8f25e..06888b675e71 100644
> --- a/drivers/scsi/sd.c
> +++ b/drivers/scsi/sd.c
> @@ -103,6 +103,7 @@ static void sd_config_discard(struct scsi_disk *, unsigned int);
>   static void sd_config_write_same(struct scsi_disk *);
>   static int  sd_revalidate_disk(struct gendisk *);
>   static void sd_unlock_native_capacity(struct gendisk *disk);
> +static void sd_start_done_work(struct work_struct *work);
>   static int  sd_probe(struct device *);
>   static int  sd_remove(struct device *);
>   static void sd_shutdown(struct device *);
> @@ -3463,6 +3464,7 @@ static int sd_probe(struct device *dev)
>   	sdkp->max_retries = SD_MAX_RETRIES;
>   	atomic_set(&sdkp->openers, 0);
>   	atomic_set(&sdkp->device->ioerr_cnt, 0);
> +	INIT_WORK(&sdkp->start_done_work, sd_start_done_work);
>   
>   	if (!sdp->request_queue->rq_timeout) {
>   		if (sdp->type != TYPE_MOD)
> @@ -3585,12 +3587,64 @@ static void scsi_disk_release(struct device *dev)
>   	kfree(sdkp);
>   }
>   
> +/* Process sense data after a START command finished. */
> +static void sd_start_done_work(struct work_struct *work)
> +{
> +	struct scsi_disk *sdkp = container_of(work, typeof(*sdkp),
> +					      start_done_work);
> +	struct scsi_sense_hdr sshdr;
> +	int res = sdkp->start_result;
> +
> +	if (res == 0)
> +		return;
> + > +	sd_print_result(sdkp, "Start/Stop Unit failed", res);

Surely START/STOP unit can succeed, no?

> +	if (res > 0 && scsi_normalize_sense(sdkp->start_sense_buffer,
> +					    sdkp->start_sense_len, &sshdr))
> +		sd_print_sense_hdr(sdkp, &sshdr);
> +}
> +
> +/* A START command finished. May be called from interrupt context. */
> +static void sd_start_done(struct request *req, blk_status_t status)
> +{
> +	const struct scsi_cmnd *scmd = blk_mq_rq_to_pdu(req);
> +	struct scsi_disk *sdkp = scsi_disk(req->q->disk);
> +
> +	sdkp->start_result = scmd->result;
> +	WARN_ON_ONCE(scmd->sense_len > SCSI_SENSE_BUFFERSIZE);
> +	sdkp->start_sense_len = scmd->sense_len;
> +	memcpy(sdkp->start_sense_buffer, scmd->sense_buffer, scmd->sense_len);
> +	WARN_ON_ONCE(!schedule_work(&sdkp->start_done_work));
> +}
> +
> +/* Submit a START command asynchronously. */
> +static int sd_submit_start(struct scsi_disk *sdkp, u8 cmd[], u8 cmd_len)
> +{
> +	struct scsi_device *sdev = sdkp->device;
> +	struct request_queue *q = sdev->request_queue;
> +	struct request *req;
> +	struct scsi_cmnd *scmd;
> +
> +	req = scsi_alloc_request(q, REQ_OP_DRV_IN, BLK_MQ_REQ_PM);
> +	if (IS_ERR(req))
> +		return PTR_ERR(req);
> +
> +	scmd = blk_mq_rq_to_pdu(req);
> +	scmd->cmd_len = cmd_len;
> +	memcpy(scmd->cmnd, cmd, cmd_len);
> +	scmd->allowed = sdkp->max_retries;
> +	req->timeout = SD_TIMEOUT;
> +	req->rq_flags |= RQF_PM | RQF_QUIET;
> +	req->end_io = sd_start_done;
> +	blk_execute_rq_nowait(req, /*at_head=*/true);
> +
> +	return 0;
> +}
> +
>   static int sd_start_stop_device(struct scsi_disk *sdkp, int start)
>   {
>   	unsigned char cmd[6] = { START_STOP };	/* START_VALID */
> -	struct scsi_sense_hdr sshdr;
>   	struct scsi_device *sdp = sdkp->device;
> -	int res;
>   
>   	if (start)
>   		cmd[4] |= 1;	/* START */
> @@ -3601,23 +3655,10 @@ static int sd_start_stop_device(struct scsi_disk *sdkp, int start)
>   	if (!scsi_device_online(sdp))
>   		return -ENODEV;
>   
> -	res = scsi_execute(sdp, cmd, DMA_NONE, NULL, 0, NULL, &sshdr,
> -			SD_TIMEOUT, sdkp->max_retries, 0, RQF_PM, NULL);
> -	if (res) {
> -		sd_print_result(sdkp, "Start/Stop Unit failed", res);
> -		if (res > 0 && scsi_sense_valid(&sshdr)) {
> -			sd_print_sense_hdr(sdkp, &sshdr);
> -			/* 0x3a is medium not present */
> -			if (sshdr.asc == 0x3a)
> -				res = 0;
> -		}
> -	}
> +	/* Wait until processing of sense data has finished. */
> +	flush_work(&sdkp->start_done_work);
>   
> -	/* SCSI error codes must not go to the generic layer */
> -	if (res)
> -		return -EIO;
> -
> -	return 0;
> +	return sd_submit_start(sdkp, cmd, sizeof(cmd));
>   }
>   
>   /*
> @@ -3644,6 +3685,8 @@ static void sd_shutdown(struct device *dev)
>   		sd_printk(KERN_NOTICE, sdkp, "Stopping disk\n");
>   		sd_start_stop_device(sdkp, 0);
>   	}
> +
> +	flush_work(&sdkp->start_done_work);
>   }
>   
>   static int sd_suspend_common(struct device *dev, bool ignore_stop_errors)
> diff --git a/drivers/scsi/sd.h b/drivers/scsi/sd.h
> index 5eea762f84d1..b89187761d61 100644
> --- a/drivers/scsi/sd.h
> +++ b/drivers/scsi/sd.h
> @@ -150,6 +150,11 @@ struct scsi_disk {
>   	unsigned	urswrz : 1;
>   	unsigned	security : 1;
>   	unsigned	ignore_medium_access_errors : 1;
> +
> +	int		start_result;
> +	u32		start_sense_len;
> +	u8		start_sense_buffer[SCSI_SENSE_BUFFERSIZE];
> +	struct work_struct start_done_work;
>   };
>   #define to_scsi_disk(obj) container_of(obj, struct scsi_disk, disk_dev)
>   

Cheers,

Hannes
-- 
Dr. Hannes Reinecke                Kernel Storage Architect
hare@suse.de                              +49 911 74053 688
SUSE Software Solutions GmbH, Maxfeldstr. 5, 90409 Nürnberg
HRB 36809 (AG Nürnberg), Geschäftsführer: Ivo Totev, Andrew
Myers, Andrew McDonald, Martje Boudien Moerman
