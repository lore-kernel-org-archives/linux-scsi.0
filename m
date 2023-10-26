Return-Path: <linux-scsi-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 60CB8C25B67
	for <linux-scsi@archiver.kernel.org>; Thu, 26 Oct 2023 12:39:50 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230505AbjJZMju (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Thu, 26 Oct 2023 08:39:50 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34010 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230507AbjJZMjt (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Thu, 26 Oct 2023 08:39:49 -0400
Received: from smtp-out2.suse.de (smtp-out2.suse.de [195.135.220.29])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BEC5AC0
        for <linux-scsi@vger.kernel.org>; Thu, 26 Oct 2023 05:39:46 -0700 (PDT)
Received: from imap2.suse-dmz.suse.de (imap2.suse-dmz.suse.de [192.168.254.74])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature ECDSA (P-521) server-digest SHA512)
        (No client certificate requested)
        by smtp-out2.suse.de (Postfix) with ESMTPS id 643AB1FE49;
        Thu, 26 Oct 2023 12:39:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
        t=1698323985; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=U1Hyrz5ZjAXFiDJgcvFN3gMb83bZqoLRGCW0sNLbDDo=;
        b=xsIsrBZ+6Hh837h2D+tFMEi48k/FpYuY5W+K5iiKLN5bgJrYOcmRxpwvBSFDIQ7Km2MNfh
        dbF/+OyANX6/J1fF0DUZ4FvLiBWMfliAeLIVkyL+f6RYXw3x1sf3qA18ro0YdPpkYmWD5R
        D06QvE1VYIkdMgiZohdh1dPheHuJmZI=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
        s=susede2_ed25519; t=1698323985;
        h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=U1Hyrz5ZjAXFiDJgcvFN3gMb83bZqoLRGCW0sNLbDDo=;
        b=w6JkhvT9tebCUtsjkYVJ831doEdbHAyuYUzwa5b3BdSLM+cMWO04RPGtdiQN5u83JAMKUZ
        O9upng1p+IltvjAQ==
Received: from imap2.suse-dmz.suse.de (imap2.suse-dmz.suse.de [192.168.254.74])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature ECDSA (P-521) server-digest SHA512)
        (No client certificate requested)
        by imap2.suse-dmz.suse.de (Postfix) with ESMTPS id B03771358F;
        Thu, 26 Oct 2023 12:39:44 +0000 (UTC)
Received: from dovecot-director2.suse.de ([192.168.254.65])
        by imap2.suse-dmz.suse.de with ESMTPSA
        id y0ldJxBeOmXqGgAAMHmgww
        (envelope-from <hare@suse.de>); Thu, 26 Oct 2023 12:39:44 +0000
Message-ID: <97271b99-e3a1-407d-a14e-14dccca58eb7@suse.de>
Date:   Thu, 26 Oct 2023 14:39:43 +0200
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 04/10] scsi: Use scsi_device as argument to
 eh_device_reset_handler()
Content-Language: en-US
To:     Benjamin Block <bblock@linux.ibm.com>
Cc:     "Martin K. Petersen" <martin.petersen@oracle.com>,
        Christoph Hellwig <hch@lst.de>,
        James Bottomley <james.bottomley@hansenpartnership.com>,
        linux-scsi@vger.kernel.org,
        Johannes Thumshirn <johannes.thumshirn@wdc.com>
References: <20231023092837.33786-1-hare@suse.de>
 <20231023092837.33786-5-hare@suse.de>
 <20231026122438.GI1917450@p1gen4-pw042f0m.boeblingen.de.ibm.com>
From:   Hannes Reinecke <hare@suse.de>
In-Reply-To: <20231026122438.GI1917450@p1gen4-pw042f0m.boeblingen.de.ibm.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On 10/26/23 14:24, Benjamin Block wrote:
> On Mon, Oct 23, 2023 at 11:28:31AM +0200, Hannes Reinecke wrote:
>> diff --git a/drivers/scsi/a100u2w.c b/drivers/scsi/a100u2w.c
>> index 5c062fb35cf6..dc562da7b2b9 100644
>> --- a/drivers/scsi/a100u2w.c
>> +++ b/drivers/scsi/a100u2w.c
>> @@ -944,16 +944,15 @@ static int inia100_bus_reset(struct Scsi_Host * shost, unsigned int channel)
>>   /*****************************************************************************
>>    Function name  : inia100_device_reset
>>    Description    : Reset the device
>> - Input          : host  -       Pointer to host adapter structure
>> + Input          : dev  -       Pointer to scsi device structure
>>    Output         : None.
>>    Return         : pSRB  -       Pointer to SCSI request block.
>>   *****************************************************************************/
>> -static int inia100_device_reset(struct scsi_cmnd * cmd)
>> +static int inia100_device_reset(struct scsi_device * dev)
>>   {				/* I need Host Control Block Information */
>>   	struct orc_host *host;
>> -	host = (struct orc_host *) cmd->device->host->hostdata;
>> -	return orc_device_reset(host, cmd->device);
>> -
>> +	host = (struct orc_host *) dev->host->hostdata;
> 
> Nitpick: you could use `shost_priv()` here.
> 
Yes, can do.

>> diff --git a/drivers/scsi/mpi3mr/mpi3mr_os.c b/drivers/scsi/mpi3mr/mpi3mr_os.c
>> index 63d95aa8a5f3..289269140e4e 100644
>> --- a/drivers/scsi/mpi3mr/mpi3mr_os.c
>> +++ b/drivers/scsi/mpi3mr/mpi3mr_os.c
>> @@ -4141,30 +4141,28 @@ static int mpi3mr_eh_target_reset(struct scsi_target *starget)
>> -static int mpi3mr_eh_dev_reset(struct scsi_cmnd *scmd)
>> +static int mpi3mr_eh_dev_reset(struct scsi_device *sdev)
>>   {
>> -	struct mpi3mr_ioc *mrioc = shost_priv(scmd->device->host);
>> +	struct mpi3mr_ioc *mrioc = shost_priv(sdev->host);
>>   	struct mpi3mr_stgt_priv_data *stgt_priv_data;
>>   	struct mpi3mr_sdev_priv_data *sdev_priv_data;
>>   	u16 dev_handle;
>>   	u8 resp_code = 0;
>>   	int retval = FAILED, ret = 0;
>>   
>> -	sdev_printk(KERN_INFO, scmd->device,
>> -	    "Attempting Device(lun) Reset! scmd(%p)\n", scmd);
>> -	scsi_print_command(scmd);
>> +	sdev_printk(KERN_INFO, sdev,
> 
> Nitpick: you can remove the line-break after `sdev,`
> 
See my comments to the previous patches. I'd rather do this in a 
separate patch.

>> +	    "Attempting Device(lun) Reset!\n");
>>   
>> -	sdev_priv_data = scmd->device->hostdata;
>> +	sdev_priv_data = sdev->hostdata;
>>   	if (!sdev_priv_data || !sdev_priv_data->tgt_priv_data) {
>> -		sdev_printk(KERN_INFO, scmd->device,
>> +		sdev_printk(KERN_INFO, sdev,
>>   		    "SCSI device is not available\n");
>>   		retval = SUCCESS;
>>   		goto out;
>> diff --git a/drivers/scsi/mpt3sas/mpt3sas_scsih.c b/drivers/scsi/mpt3sas/mpt3sas_scsih.c
>> index 1f3ce2aafed6..e1da6a811dac 100644
>> --- a/drivers/scsi/mpt3sas/mpt3sas_scsih.c
>> +++ b/drivers/scsi/mpt3sas/mpt3sas_scsih.c
>> @@ -3376,20 +3376,17 @@ scsih_dev_reset(struct scsi_cmnd *scmd)
>>   	u8	tr_timeout = 30;
>>   	int r;
>>   
>> -	struct scsi_target *starget = scmd->device->sdev_target;
>> +	struct scsi_target *starget = sdev->sdev_target;
>>   	struct MPT3SAS_TARGET *target_priv_data = starget->hostdata;
>>   
>> -	sdev_printk(KERN_INFO, scmd->device,
>> -	    "attempting device reset! scmd(0x%p)\n", scmd);
>> -	_scsih_tm_display_info(ioc, scmd);
>> +	sdev_printk(KERN_INFO, sdev,
> 
> ...
> 
>> +	    "attempting device reset!\n");
>>   
>> -	sas_device_priv_data = scmd->device->hostdata;
>> +	sas_device_priv_data = sdev->hostdata;
>> diff --git a/drivers/scsi/pcmcia/nsp_cs.h b/drivers/scsi/pcmcia/nsp_cs.h
>> index 01c0d571de90..0d03b361ed72 100644
>> --- a/drivers/scsi/pcmcia/nsp_cs.h
>> +++ b/drivers/scsi/pcmcia/nsp_cs.h
>> @@ -297,8 +297,6 @@ static        int        nsp_show_info  (struct seq_file *m,
>>   static int nsp_queuecommand(struct Scsi_Host *h, struct scsi_cmnd *SCpnt);
>>   
>>   /* Error handler */
>> -/*static int nsp_eh_abort       (struct scsi_cmnd *SCpnt);*/
>> -/*static int nsp_eh_device_reset(struct scsi_cmnd *SCpnt);*/
> 
> Hmm, this is a bit off-topic; is it? You don't change anything else in this
> header. Hmm, maybe because it's the old device-reset handler that still has
> `scsi_cmnd` as arg.
> 
Yes. They've been commented out for ages, and will just serve to confuse 
users if they remain in the code.
But I can drop this bit if you insist.

>>   static int nsp_eh_bus_reset    (struct Scsi_Host *host, unsigned int channel);
>>   static int nsp_eh_host_reset   (struct Scsi_Host *host);
>>   static int nsp_bus_reset       (nsp_hw_data *data);
>> diff --git a/drivers/scsi/qla1280.c b/drivers/scsi/qla1280.c
>> index 626bc28d20e2..9bd330610d58 100644
>> --- a/drivers/scsi/qla1280.c
>> +++ b/drivers/scsi/qla1280.c
>> @@ -797,18 +797,18 @@ qla1280_wait_for_pending_commands(struct scsi_qla_host *ha, int bus, int target)
>>    *    wait for the results (or time out).
>>    *
>>    * Input:
>> + *      sdev = Linux SCSI device
>>    *      cmd = Linux SCSI command packet of the command that cause the
>>    *            bus reset.
>> - *      action = error action to take (see action_t)
>>    *
>>    * Returns:
>>    *      SUCCESS or FAILED
>>    *
>>    **************************************************************************/
>>   static int
>> -qla1280_error_action(struct scsi_cmnd *cmd, enum action action)
>> +qla1280_error_action(struct scsi_device *sdev, struct scsi_cmnd *cmd)
>>   {
>> -	struct scsi_qla_host *ha;
>> +	struct scsi_qla_host *ha = shost_priv(sdev->host);
>>   	int bus, target, lun;
>>   	struct srb *sp;
>>   	int i, found;
>> @@ -816,14 +816,14 @@ qla1280_error_action(struct scsi_cmnd *cmd, enum action action)
>>   	int wait_for_bus=-1;
>>   	int wait_for_target = -1;
>>   	DECLARE_COMPLETION_ONSTACK(wait);
>> +	enum action action = cmd ? ABORT_COMMAND : DEVICE_RESET;
>>   
>>   	ENTER("qla1280_error_action");
>>   
>> -	ha = (struct scsi_qla_host *)(CMD_HOST(cmd)->hostdata);
>>   	sp = scsi_cmd_priv(cmd);
> 
> That is wrong now that `cmd` can be `NULL`. In that case this will return
> something near address 0 and the rest of the function will fall apart.
> 
> 	static inline void *scsi_cmd_priv(struct scsi_cmnd *cmd)
> 	{
> 		return cmd + 1;
> 	}
> 
Aw. Indeed. will be fixing it.

>> -	bus = SCSI_BUS_32(cmd);
>> -	target = SCSI_TCN_32(cmd);
>> -	lun = SCSI_LUN_32(cmd);
>> +	bus = sdev->channel;
>> +	target = sdev->id;
>> +	lun = sdev->lun;
>>   
>>   	dprintk(4, "error_action %i, istatus 0x%04x\n", action,
>>   		RD_REG_WORD(&ha->iobase->istatus));
>> diff --git a/drivers/scsi/snic/snic_scsi.c b/drivers/scsi/snic/snic_scsi.c
>> index 36298dbadb14..e1f6004dcd6b 100644
>> --- a/drivers/scsi/snic/snic_scsi.c
>> +++ b/drivers/scsi/snic/snic_scsi.c
>> @@ -2099,6 +2098,7 @@ snic_device_reset(struct scsi_cmnd *sc)
>>   	int start_time = jiffies;
>>   	int ret = FAILED;
>>   	int dr_supp = 0;
>> +	struct scsi_cmnd tmf_sc, *sc = &tmf_sc;
> 
> No quite sure why you need that `tmf_sc` and it's address in `sc`? `sc` is
> first used here:
> 
>      sc = blk_mq_rq_to_pdu(req);
> 
> which overwrites the value, and `tmf_sc` is not used at all. Or am I missing
> something?
> 
I'll be checking. Thanks for the review.

Cheers,

Hannes
-- 
Dr. Hannes Reinecke                Kernel Storage Architect
hare@suse.de                              +49 911 74053 688
SUSE Software Solutions GmbH, Maxfeldstr. 5, 90409 Nürnberg
HRB 36809 (AG Nürnberg), Geschäftsführer: Ivo Totev, Andrew
Myers, Andrew McDonald, Martje Boudien Moerman

