Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id F29F2C25B08
	for <linux-scsi@archiver.kernel.org>; Sat, 20 Aug 2022 15:39:03 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1346290AbiHTPhy (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Sat, 20 Aug 2022 11:37:54 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42518 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1345775AbiHTPhu (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Sat, 20 Aug 2022 11:37:50 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 861006716E
        for <linux-scsi@vger.kernel.org>; Sat, 20 Aug 2022 08:37:49 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1661009868;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=u0ZETOfVhPwpvTMjdqE3sYClqt3PiJAIyQUKFWGh82g=;
        b=KbuIdI1GQy8qPdbHeGjwKo/uKWZ9KV5T9HXj9JEPCe+ap52m3QBqNhYldflqcqaJ4fKxDN
        t0pxepLOd9r4mqIOxG5aWwHOKGb1D/UTG719YK+4bI7Qss8QMGn18pmB8/jLKoWLq3WYEY
        wraOKx2npWON3TsndfE0mRnsPpJBR/I=
Received: from mail-ed1-f71.google.com (mail-ed1-f71.google.com
 [209.85.208.71]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_128_GCM_SHA256) id
 us-mta-269-HRMwo15hOzGXH-G3ik9lww-1; Sat, 20 Aug 2022 11:37:47 -0400
X-MC-Unique: HRMwo15hOzGXH-G3ik9lww-1
Received: by mail-ed1-f71.google.com with SMTP id i5-20020a05640242c500b0043e50334109so4396132edc.1
        for <linux-scsi@vger.kernel.org>; Sat, 20 Aug 2022 08:37:47 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc;
        bh=u0ZETOfVhPwpvTMjdqE3sYClqt3PiJAIyQUKFWGh82g=;
        b=Gfp9r1MXL/57ecpY5XzVRePrs1k6lCw7EOllXXezSRp8JlXWZJkQgwYDg4wAeMsUZf
         8hkDngKleFH9J6g5PftG4xYuwqkxlFGAKN0pPAvPC4YgOZ6B08unrsR+E7uGyFYvFTN5
         Pn/RqM/JsUeLi6PVQ++yZvx2MPutjmTZlPY4aKeVeUbcp+x12xFN4pzwOzx9EeMWRjgA
         MVdHD7XvTVR5666YIJL4hjnnhInQ0zisI7B5QmuhfkaxUhsJnz5+kzd+00MXKxGKV2bp
         Sws6U8+FCIzhKsJVAt/nGDu5vAgwgvlRKi78bw3GHlIO7ZYb9B8n/oEDr91c9BAMKv7o
         mt6g==
X-Gm-Message-State: ACgBeo3VkRtt1GIokffDLBh2zclyCX1jOCIXi+rzwOdCyQR33sxkgFcy
        FvlLmKn5wVoGYvo/bBil7BwyxgZL2ZpbuvXw78yDPFwOssgXrYdgx6euFfKDMTy3MCf3DYlZ8pL
        0GG9EYtFuUUcFC9kLTZhM1A==
X-Received: by 2002:a17:907:7290:b0:731:3c0a:97f8 with SMTP id dt16-20020a170907729000b007313c0a97f8mr8100557ejc.127.1661009865553;
        Sat, 20 Aug 2022 08:37:45 -0700 (PDT)
X-Google-Smtp-Source: AA6agR7WrFZgHtbWk1Jtk5rHavDl0kSkHDsiecfWXMA75eu30VelLeSwOmrudELZQ51q0jkTRYDk8w==
X-Received: by 2002:a17:907:7290:b0:731:3c0a:97f8 with SMTP id dt16-20020a170907729000b007313c0a97f8mr8100544ejc.127.1661009865316;
        Sat, 20 Aug 2022 08:37:45 -0700 (PDT)
Received: from ?IPV6:2001:1c00:c1e:bf00:d69d:5353:dba5:ee81? (2001-1c00-0c1e-bf00-d69d-5353-dba5-ee81.cable.dynamic.v6.ziggo.nl. [2001:1c00:c1e:bf00:d69d:5353:dba5:ee81])
        by smtp.gmail.com with ESMTPSA id v17-20020a170906293100b0073075451398sm3803729ejd.17.2022.08.20.08.37.44
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Sat, 20 Aug 2022 08:37:44 -0700 (PDT)
Message-ID: <decc1ef4-ec85-d947-ec81-ebeaa982f53f@redhat.com>
Date:   Sat, 20 Aug 2022 17:37:44 +0200
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.12.0
Subject: Re: [PATCH] scsi: sd: Revert "Rework asynchronous resume support"
Content-Language: en-US
To:     Bart Van Assche <bvanassche@acm.org>,
        "Martin K . Petersen" <martin.petersen@oracle.com>
Cc:     linux-scsi@vger.kernel.org,
        Damien Le Moal <damien.lemoal@opensource.wdc.com>,
        Hannes Reinecke <hare@suse.de>,
        Geert Uytterhoeven <geert@linux-m68k.org>, gzhqyz@gmail.com,
        "James E.J. Bottomley" <jejb@linux.ibm.com>
References: <20220816172638.538734-1-bvanassche@acm.org>
From:   Hans de Goede <hdegoede@redhat.com>
In-Reply-To: <20220816172638.538734-1-bvanassche@acm.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

Hi,

On 8/16/22 19:26, Bart Van Assche wrote:
> Although patch "Rework asynchronous resume support" eliminates the delay
> for some ATA disks after resume, it causes resume of ATA disks to fail
> on other setups. See also:
> * "Resume process hangs for 5-6 seconds starting sometime in 5.16"
>   (https://bugzilla.kernel.org/show_bug.cgi?id=215880).
> * Geert's regression report
>   (https://lore.kernel.org/linux-scsi/alpine.DEB.2.22.394.2207191125130.1006766@ramsan.of.borg/).
> 
> This is what I understand about this issue:
> * During resume, ata_port_pm_resume() starts the SCSI error handler.
>   This changes the SCSI host state into SHOST_RECOVERY and causes
>   scsi_queue_rq() to return BLK_STS_RESOURCE.
> * sd_resume() calls sd_start_stop_device() for ATA devices. That
>   function in turn calls sd_submit_start() which tries to submit a START
>   STOP UNIT command. That command can only be submitted after the SCSI
>   error handler has changed the SCSI host state back to SHOST_RUNNING.
> * The SCSI error handler runs on its own thread and calls
>   schedule_work(&(ap->scsi_rescan_task)). That causes
>   ata_scsi_dev_rescan() to be called from the context of a kernel
>   workqueue. That call hangs in blk_mq_get_tag(). I'm not sure why -
>   maybe because all available tags have been allocated by
>   sd_submit_start() calls (this is a guess).
> 
> Cc: Damien Le Moal <damien.lemoal@opensource.wdc.com>
> Cc: Hannes Reinecke <hare@suse.de>
> Cc: Geert Uytterhoeven <geert@linux-m68k.org>
> Cc: gzhqyz@gmail.com
> Reported-by: Geert Uytterhoeven <geert@linux-m68k.org>
> Reported-by: gzhqyz@gmail.com
> Fixes: 88f1669019bd ("scsi: sd: Rework asynchronous resume support"; v6.0-rc1~114^2~68)
> Signed-off-by: Bart Van Assche <bvanassche@acm.org>

As reported here I've been seeing tasks block/hang on IO
to a sata disk on a system with / on a NVME (which keeps
the system alive except for the SATA disk acccessing tasks):

https://lore.kernel.org/regressions/dd6844e7-f338-a4e9-2dad-0960e25b2ca1@redhat.com/

I'm running 6.0-rc1 with this patch added now and so far
I've not seen the problem re-occur.

I was also seeing 6.0 suspend/resume issues on 2 laptops with
sata disks (rather then NVME) which I did not yet get around
to collecting logs from / reporting. I'm happy to report that
those suspend/resume issues are also fixed by this:

Tested-by: Hans de Goede <hdegoede@redhat.com>

Regards,

Hans




> ---
>  drivers/scsi/sd.c | 84 ++++++++++-------------------------------------
>  drivers/scsi/sd.h |  5 ---
>  2 files changed, 18 insertions(+), 71 deletions(-)
> 
> diff --git a/drivers/scsi/sd.c b/drivers/scsi/sd.c
> index 8f79fa6318fe..eb76ba055021 100644
> --- a/drivers/scsi/sd.c
> +++ b/drivers/scsi/sd.c
> @@ -103,7 +103,6 @@ static void sd_config_discard(struct scsi_disk *, unsigned int);
>  static void sd_config_write_same(struct scsi_disk *);
>  static int  sd_revalidate_disk(struct gendisk *);
>  static void sd_unlock_native_capacity(struct gendisk *disk);
> -static void sd_start_done_work(struct work_struct *work);
>  static int  sd_probe(struct device *);
>  static int  sd_remove(struct device *);
>  static void sd_shutdown(struct device *);
> @@ -3471,7 +3470,6 @@ static int sd_probe(struct device *dev)
>  	sdkp->max_retries = SD_MAX_RETRIES;
>  	atomic_set(&sdkp->openers, 0);
>  	atomic_set(&sdkp->device->ioerr_cnt, 0);
> -	INIT_WORK(&sdkp->start_done_work, sd_start_done_work);
>  
>  	if (!sdp->request_queue->rq_timeout) {
>  		if (sdp->type != TYPE_MOD)
> @@ -3594,69 +3592,12 @@ static void scsi_disk_release(struct device *dev)
>  	kfree(sdkp);
>  }
>  
> -/* Process sense data after a START command finished. */
> -static void sd_start_done_work(struct work_struct *work)
> -{
> -	struct scsi_disk *sdkp = container_of(work, typeof(*sdkp),
> -					      start_done_work);
> -	struct scsi_sense_hdr sshdr;
> -	int res = sdkp->start_result;
> -
> -	if (res == 0)
> -		return;
> -
> -	sd_print_result(sdkp, "Start/Stop Unit failed", res);
> -
> -	if (res < 0)
> -		return;
> -
> -	if (scsi_normalize_sense(sdkp->start_sense_buffer,
> -				 sdkp->start_sense_len, &sshdr))
> -		sd_print_sense_hdr(sdkp, &sshdr);
> -}
> -
> -/* A START command finished. May be called from interrupt context. */
> -static void sd_start_done(struct request *req, blk_status_t status)
> -{
> -	const struct scsi_cmnd *scmd = blk_mq_rq_to_pdu(req);
> -	struct scsi_disk *sdkp = scsi_disk(req->q->disk);
> -
> -	sdkp->start_result = scmd->result;
> -	WARN_ON_ONCE(scmd->sense_len > SCSI_SENSE_BUFFERSIZE);
> -	sdkp->start_sense_len = scmd->sense_len;
> -	memcpy(sdkp->start_sense_buffer, scmd->sense_buffer,
> -	       ARRAY_SIZE(sdkp->start_sense_buffer));
> -	WARN_ON_ONCE(!schedule_work(&sdkp->start_done_work));
> -}
> -
> -/* Submit a START command asynchronously. */
> -static int sd_submit_start(struct scsi_disk *sdkp, u8 cmd[], u8 cmd_len)
> -{
> -	struct scsi_device *sdev = sdkp->device;
> -	struct request_queue *q = sdev->request_queue;
> -	struct request *req;
> -	struct scsi_cmnd *scmd;
> -
> -	req = scsi_alloc_request(q, REQ_OP_DRV_IN, BLK_MQ_REQ_PM);
> -	if (IS_ERR(req))
> -		return PTR_ERR(req);
> -
> -	scmd = blk_mq_rq_to_pdu(req);
> -	scmd->cmd_len = cmd_len;
> -	memcpy(scmd->cmnd, cmd, cmd_len);
> -	scmd->allowed = sdkp->max_retries;
> -	req->timeout = SD_TIMEOUT;
> -	req->rq_flags |= RQF_PM | RQF_QUIET;
> -	req->end_io = sd_start_done;
> -	blk_execute_rq_nowait(req, /*at_head=*/true);
> -
> -	return 0;
> -}
> -
>  static int sd_start_stop_device(struct scsi_disk *sdkp, int start)
>  {
>  	unsigned char cmd[6] = { START_STOP };	/* START_VALID */
> +	struct scsi_sense_hdr sshdr;
>  	struct scsi_device *sdp = sdkp->device;
> +	int res;
>  
>  	if (start)
>  		cmd[4] |= 1;	/* START */
> @@ -3667,10 +3608,23 @@ static int sd_start_stop_device(struct scsi_disk *sdkp, int start)
>  	if (!scsi_device_online(sdp))
>  		return -ENODEV;
>  
> -	/* Wait until processing of sense data has finished. */
> -	flush_work(&sdkp->start_done_work);
> +	res = scsi_execute(sdp, cmd, DMA_NONE, NULL, 0, NULL, &sshdr,
> +			SD_TIMEOUT, sdkp->max_retries, 0, RQF_PM, NULL);
> +	if (res) {
> +		sd_print_result(sdkp, "Start/Stop Unit failed", res);
> +		if (res > 0 && scsi_sense_valid(&sshdr)) {
> +			sd_print_sense_hdr(sdkp, &sshdr);
> +			/* 0x3a is medium not present */
> +			if (sshdr.asc == 0x3a)
> +				res = 0;
> +		}
> +	}
>  
> -	return sd_submit_start(sdkp, cmd, sizeof(cmd));
> +	/* SCSI error codes must not go to the generic layer */
> +	if (res)
> +		return -EIO;
> +
> +	return 0;
>  }
>  
>  /*
> @@ -3697,8 +3651,6 @@ static void sd_shutdown(struct device *dev)
>  		sd_printk(KERN_NOTICE, sdkp, "Stopping disk\n");
>  		sd_start_stop_device(sdkp, 0);
>  	}
> -
> -	flush_work(&sdkp->start_done_work);
>  }
>  
>  static int sd_suspend_common(struct device *dev, bool ignore_stop_errors)
> diff --git a/drivers/scsi/sd.h b/drivers/scsi/sd.h
> index b89187761d61..5eea762f84d1 100644
> --- a/drivers/scsi/sd.h
> +++ b/drivers/scsi/sd.h
> @@ -150,11 +150,6 @@ struct scsi_disk {
>  	unsigned	urswrz : 1;
>  	unsigned	security : 1;
>  	unsigned	ignore_medium_access_errors : 1;
> -
> -	int		start_result;
> -	u32		start_sense_len;
> -	u8		start_sense_buffer[SCSI_SENSE_BUFFERSIZE];
> -	struct work_struct start_done_work;
>  };
>  #define to_scsi_disk(obj) container_of(obj, struct scsi_disk, disk_dev)
>  
> 

