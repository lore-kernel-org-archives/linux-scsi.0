Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 88E85C28D13
	for <linux-scsi@archiver.kernel.org>; Mon, 22 Aug 2022 20:55:32 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237805AbiHVUzc (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Mon, 22 Aug 2022 16:55:32 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51906 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235927AbiHVUzU (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Mon, 22 Aug 2022 16:55:20 -0400
Received: from smtp-out2.suse.de (smtp-out2.suse.de [195.135.220.29])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 33BA248CBB
        for <linux-scsi@vger.kernel.org>; Mon, 22 Aug 2022 13:55:19 -0700 (PDT)
Received: from imap2.suse-dmz.suse.de (imap2.suse-dmz.suse.de [192.168.254.74])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature ECDSA (P-521) server-digest SHA512)
        (No client certificate requested)
        by smtp-out2.suse.de (Postfix) with ESMTPS id BB1345CB1C;
        Mon, 22 Aug 2022 20:55:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
        t=1661201717; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=LJdRC5SMFOUj1Y7xZ0bXRO8O+t/Noh7uanF3FJkrpS4=;
        b=nh/Sl0F3TAJ8SeM8B8AckzNTOo7q9Qydf7I0XwQiJXGnY6oEJJ+K+1ufXP1Ue9ZJFQdddF
        FOaIR7hoomdnMpRMoCfFvF27l32dpxkD5PSlAMgFPPqZx/5WpcW0SWGY3xT5dQR0JPlGKW
        EWTMWvq1Ie9eI3pJHpLskefLxZ81UxA=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
        s=susede2_ed25519; t=1661201717;
        h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=LJdRC5SMFOUj1Y7xZ0bXRO8O+t/Noh7uanF3FJkrpS4=;
        b=zWfrVpAQqwpAmwhy7N7/5Wsh+WYkzN0OlPHEcJ2neU0EtKjNOHOA2dkHmkKSU7KJQ7mcTz
        4jXNwjwVy765hwBA==
Received: from imap2.suse-dmz.suse.de (imap2.suse-dmz.suse.de [192.168.254.74])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature ECDSA (P-521) server-digest SHA512)
        (No client certificate requested)
        by imap2.suse-dmz.suse.de (Postfix) with ESMTPS id 7AE1F13523;
        Mon, 22 Aug 2022 20:55:17 +0000 (UTC)
Received: from dovecot-director2.suse.de ([192.168.254.65])
        by imap2.suse-dmz.suse.de with ESMTPSA
        id jVbyHDXtA2PtBgAAMHmgww
        (envelope-from <vbabka@suse.cz>); Mon, 22 Aug 2022 20:55:17 +0000
Message-ID: <f7aad839-2116-ab85-8ad5-e8d2f7b10c43@suse.cz>
Date:   Mon, 22 Aug 2022 22:53:43 +0200
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.11.0
Subject: Re: [PATCH] scsi: sd: Revert "Rework asynchronous resume support"
Content-Language: en-US
From:   Vlastimil Babka <vbabka@suse.cz>
To:     Bart Van Assche <bvanassche@acm.org>,
        "Martin K . Petersen" <martin.petersen@oracle.com>,
        Linus Torvalds <torvalds@linux-foundation.org>
Cc:     linux-scsi@vger.kernel.org,
        Damien Le Moal <damien.lemoal@opensource.wdc.com>,
        Hannes Reinecke <hare@suse.de>,
        Geert Uytterhoeven <geert@linux-m68k.org>, gzhqyz@gmail.com,
        "James E.J. Bottomley" <jejb@linux.ibm.com>,
        regressions@lists.linux.dev,
        Thorsten Leemhuis <regressions@leemhuis.info>
References: <20220816172638.538734-1-bvanassche@acm.org>
 <06afc774-063d-1aba-f75c-9a4c80e2f836@suse.cz>
In-Reply-To: <06afc774-063d-1aba-f75c-9a4c80e2f836@suse.cz>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On 8/17/22 22:06, Vlastimil Babka wrote:
> On 8/16/22 19:26, Bart Van Assche wrote:
>> Although patch "Rework asynchronous resume support" eliminates the delay
>> for some ATA disks after resume, it causes resume of ATA disks to fail
>> on other setups. See also:
>> * "Resume process hangs for 5-6 seconds starting sometime in 5.16"
>>   (https://bugzilla.kernel.org/show_bug.cgi?id=215880).
>> * Geert's regression report
>>   (https://lore.kernel.org/linux-scsi/alpine.DEB.2.22.394.2207191125130.1006766@ramsan.of.borg/).
>>
>> This is what I understand about this issue:
>> * During resume, ata_port_pm_resume() starts the SCSI error handler.
>>   This changes the SCSI host state into SHOST_RECOVERY and causes
>>   scsi_queue_rq() to return BLK_STS_RESOURCE.
>> * sd_resume() calls sd_start_stop_device() for ATA devices. That
>>   function in turn calls sd_submit_start() which tries to submit a START
>>   STOP UNIT command. That command can only be submitted after the SCSI
>>   error handler has changed the SCSI host state back to SHOST_RUNNING.
>> * The SCSI error handler runs on its own thread and calls
>>   schedule_work(&(ap->scsi_rescan_task)). That causes
>>   ata_scsi_dev_rescan() to be called from the context of a kernel
>>   workqueue. That call hangs in blk_mq_get_tag(). I'm not sure why -
>>   maybe because all available tags have been allocated by
>>   sd_submit_start() calls (this is a guess).
>>
>> Cc: Damien Le Moal <damien.lemoal@opensource.wdc.com>
>> Cc: Hannes Reinecke <hare@suse.de>
>> Cc: Geert Uytterhoeven <geert@linux-m68k.org>
>> Cc: gzhqyz@gmail.com
>> Reported-by: Geert Uytterhoeven <geert@linux-m68k.org>
>> Reported-by: gzhqyz@gmail.com
>> Fixes: 88f1669019bd ("scsi: sd: Rework asynchronous resume support"; v6.0-rc1~114^2~68)
>> Signed-off-by: Bart Van Assche <bvanassche@acm.org>
> 
> Reported-and-tested-by: Vlastimil Babka <vbabka@suse.cz>

What's the hold up on this? Didn't make it to rc2 and the number of
people who independently spent time bisecting this seems to be only
increasing.

Thanks, Vlastimil

> 
>> ---
>>  drivers/scsi/sd.c | 84 ++++++++++-------------------------------------
>>  drivers/scsi/sd.h |  5 ---
>>  2 files changed, 18 insertions(+), 71 deletions(-)
>>
>> diff --git a/drivers/scsi/sd.c b/drivers/scsi/sd.c
>> index 8f79fa6318fe..eb76ba055021 100644
>> --- a/drivers/scsi/sd.c
>> +++ b/drivers/scsi/sd.c
>> @@ -103,7 +103,6 @@ static void sd_config_discard(struct scsi_disk *, unsigned int);
>>  static void sd_config_write_same(struct scsi_disk *);
>>  static int  sd_revalidate_disk(struct gendisk *);
>>  static void sd_unlock_native_capacity(struct gendisk *disk);
>> -static void sd_start_done_work(struct work_struct *work);
>>  static int  sd_probe(struct device *);
>>  static int  sd_remove(struct device *);
>>  static void sd_shutdown(struct device *);
>> @@ -3471,7 +3470,6 @@ static int sd_probe(struct device *dev)
>>  	sdkp->max_retries = SD_MAX_RETRIES;
>>  	atomic_set(&sdkp->openers, 0);
>>  	atomic_set(&sdkp->device->ioerr_cnt, 0);
>> -	INIT_WORK(&sdkp->start_done_work, sd_start_done_work);
>>  
>>  	if (!sdp->request_queue->rq_timeout) {
>>  		if (sdp->type != TYPE_MOD)
>> @@ -3594,69 +3592,12 @@ static void scsi_disk_release(struct device *dev)
>>  	kfree(sdkp);
>>  }
>>  
>> -/* Process sense data after a START command finished. */
>> -static void sd_start_done_work(struct work_struct *work)
>> -{
>> -	struct scsi_disk *sdkp = container_of(work, typeof(*sdkp),
>> -					      start_done_work);
>> -	struct scsi_sense_hdr sshdr;
>> -	int res = sdkp->start_result;
>> -
>> -	if (res == 0)
>> -		return;
>> -
>> -	sd_print_result(sdkp, "Start/Stop Unit failed", res);
>> -
>> -	if (res < 0)
>> -		return;
>> -
>> -	if (scsi_normalize_sense(sdkp->start_sense_buffer,
>> -				 sdkp->start_sense_len, &sshdr))
>> -		sd_print_sense_hdr(sdkp, &sshdr);
>> -}
>> -
>> -/* A START command finished. May be called from interrupt context. */
>> -static void sd_start_done(struct request *req, blk_status_t status)
>> -{
>> -	const struct scsi_cmnd *scmd = blk_mq_rq_to_pdu(req);
>> -	struct scsi_disk *sdkp = scsi_disk(req->q->disk);
>> -
>> -	sdkp->start_result = scmd->result;
>> -	WARN_ON_ONCE(scmd->sense_len > SCSI_SENSE_BUFFERSIZE);
>> -	sdkp->start_sense_len = scmd->sense_len;
>> -	memcpy(sdkp->start_sense_buffer, scmd->sense_buffer,
>> -	       ARRAY_SIZE(sdkp->start_sense_buffer));
>> -	WARN_ON_ONCE(!schedule_work(&sdkp->start_done_work));
>> -}
>> -
>> -/* Submit a START command asynchronously. */
>> -static int sd_submit_start(struct scsi_disk *sdkp, u8 cmd[], u8 cmd_len)
>> -{
>> -	struct scsi_device *sdev = sdkp->device;
>> -	struct request_queue *q = sdev->request_queue;
>> -	struct request *req;
>> -	struct scsi_cmnd *scmd;
>> -
>> -	req = scsi_alloc_request(q, REQ_OP_DRV_IN, BLK_MQ_REQ_PM);
>> -	if (IS_ERR(req))
>> -		return PTR_ERR(req);
>> -
>> -	scmd = blk_mq_rq_to_pdu(req);
>> -	scmd->cmd_len = cmd_len;
>> -	memcpy(scmd->cmnd, cmd, cmd_len);
>> -	scmd->allowed = sdkp->max_retries;
>> -	req->timeout = SD_TIMEOUT;
>> -	req->rq_flags |= RQF_PM | RQF_QUIET;
>> -	req->end_io = sd_start_done;
>> -	blk_execute_rq_nowait(req, /*at_head=*/true);
>> -
>> -	return 0;
>> -}
>> -
>>  static int sd_start_stop_device(struct scsi_disk *sdkp, int start)
>>  {
>>  	unsigned char cmd[6] = { START_STOP };	/* START_VALID */
>> +	struct scsi_sense_hdr sshdr;
>>  	struct scsi_device *sdp = sdkp->device;
>> +	int res;
>>  
>>  	if (start)
>>  		cmd[4] |= 1;	/* START */
>> @@ -3667,10 +3608,23 @@ static int sd_start_stop_device(struct scsi_disk *sdkp, int start)
>>  	if (!scsi_device_online(sdp))
>>  		return -ENODEV;
>>  
>> -	/* Wait until processing of sense data has finished. */
>> -	flush_work(&sdkp->start_done_work);
>> +	res = scsi_execute(sdp, cmd, DMA_NONE, NULL, 0, NULL, &sshdr,
>> +			SD_TIMEOUT, sdkp->max_retries, 0, RQF_PM, NULL);
>> +	if (res) {
>> +		sd_print_result(sdkp, "Start/Stop Unit failed", res);
>> +		if (res > 0 && scsi_sense_valid(&sshdr)) {
>> +			sd_print_sense_hdr(sdkp, &sshdr);
>> +			/* 0x3a is medium not present */
>> +			if (sshdr.asc == 0x3a)
>> +				res = 0;
>> +		}
>> +	}
>>  
>> -	return sd_submit_start(sdkp, cmd, sizeof(cmd));
>> +	/* SCSI error codes must not go to the generic layer */
>> +	if (res)
>> +		return -EIO;
>> +
>> +	return 0;
>>  }
>>  
>>  /*
>> @@ -3697,8 +3651,6 @@ static void sd_shutdown(struct device *dev)
>>  		sd_printk(KERN_NOTICE, sdkp, "Stopping disk\n");
>>  		sd_start_stop_device(sdkp, 0);
>>  	}
>> -
>> -	flush_work(&sdkp->start_done_work);
>>  }
>>  
>>  static int sd_suspend_common(struct device *dev, bool ignore_stop_errors)
>> diff --git a/drivers/scsi/sd.h b/drivers/scsi/sd.h
>> index b89187761d61..5eea762f84d1 100644
>> --- a/drivers/scsi/sd.h
>> +++ b/drivers/scsi/sd.h
>> @@ -150,11 +150,6 @@ struct scsi_disk {
>>  	unsigned	urswrz : 1;
>>  	unsigned	security : 1;
>>  	unsigned	ignore_medium_access_errors : 1;
>> -
>> -	int		start_result;
>> -	u32		start_sense_len;
>> -	u8		start_sense_buffer[SCSI_SENSE_BUFFERSIZE];
>> -	struct work_struct start_done_work;
>>  };
>>  #define to_scsi_disk(obj) container_of(obj, struct scsi_disk, disk_dev)
>>  
> 

