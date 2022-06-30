Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B9DC7C43334
	for <linux-scsi@archiver.kernel.org>; Thu, 30 Jun 2022 16:23:39 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235159AbiF3QXj (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Thu, 30 Jun 2022 12:23:39 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60578 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229756AbiF3QXi (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Thu, 30 Jun 2022 12:23:38 -0400
Received: from frasgout.his.huawei.com (frasgout.his.huawei.com [185.176.79.56])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 95E922ED7B
        for <linux-scsi@vger.kernel.org>; Thu, 30 Jun 2022 09:23:36 -0700 (PDT)
Received: from fraeml711-chm.china.huawei.com (unknown [172.18.147.207])
        by frasgout.his.huawei.com (SkyGuard) with ESMTP id 4LYkBs347wz681Yv;
        Fri,  1 Jul 2022 00:22:45 +0800 (CST)
Received: from lhreml724-chm.china.huawei.com (10.201.108.75) by
 fraeml711-chm.china.huawei.com (10.206.15.60) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.24; Thu, 30 Jun 2022 18:23:34 +0200
Received: from [10.126.174.156] (10.126.174.156) by
 lhreml724-chm.china.huawei.com (10.201.108.75) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.24; Thu, 30 Jun 2022 17:23:33 +0100
Message-ID: <82e30007-1ffc-92e4-38b5-eaf7dd2e316d@huawei.com>
Date:   Thu, 30 Jun 2022 17:23:36 +0100
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:91.0) Gecko/20100101
 Thunderbird/91.6.1
Subject: Re: [PATCH 3/3] scsi: sd: Rework asynchronous resume support
To:     Bart Van Assche <bvanassche@acm.org>,
        "Martin K . Petersen" <martin.petersen@oracle.com>
CC:     Jaegeuk Kim <jaegeuk@kernel.org>, <linux-scsi@vger.kernel.org>,
        Ming Lei <ming.lei@redhat.com>, Hannes Reinecke <hare@suse.de>,
        <ericspero@icloud.com>, <jason600.groome@gmail.com>
References: <20220628222131.14780-1-bvanassche@acm.org>
 <20220628222131.14780-4-bvanassche@acm.org>
From:   John Garry <john.garry@huawei.com>
In-Reply-To: <20220628222131.14780-4-bvanassche@acm.org>
Content-Type: text/plain; charset="UTF-8"; format=flowed
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.126.174.156]
X-ClientProxiedBy: lhreml727-chm.china.huawei.com (10.201.108.78) To
 lhreml724-chm.china.huawei.com (10.201.108.75)
X-CFilter-Loop: Reflected
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On 28/06/2022 23:21, Bart Van Assche wrote:
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
> +
> +	sd_print_result(sdkp, "Start/Stop Unit failed", res);
> +	if (res > 0 && scsi_normalize_sense(sdkp->start_sense_buffer,
> +					    sdkp->start_sense_len, &sshdr))
> +		sd_print_sense_hdr(sdkp, &sshdr);

nit: maybe you can reduce indentation, like:

	if (res < 0)
		return;

	if (scsi_normalize_sense(sdkp->start_sense_buffer,
			sdkp->start_sense_len, &sshdr)) {
		sd_print_sense_hdr(sdkp, &sshdr);
	}

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

If scmd->sense_len > SCSI_SENSE_BUFFERSIZE, do you really want to go on 
to copy at sdkp->start_sense_buffer (which is of size 
SCSI_SENSE_BUFFERSIZE)? Won't that cause a corruption?

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
> .

