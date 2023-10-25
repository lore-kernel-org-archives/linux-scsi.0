Return-Path: <linux-scsi-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 501F2C0032E
	for <linux-scsi@archiver.kernel.org>; Wed, 25 Oct 2023 15:38:01 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232042AbjJYPiB (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Wed, 25 Oct 2023 11:38:01 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40266 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235048AbjJYPf6 (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Wed, 25 Oct 2023 11:35:58 -0400
Received: from smtp-out2.suse.de (smtp-out2.suse.de [IPv6:2001:67c:2178:6::1d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 67417136
        for <linux-scsi@vger.kernel.org>; Wed, 25 Oct 2023 08:35:55 -0700 (PDT)
Received: from imap2.suse-dmz.suse.de (imap2.suse-dmz.suse.de [192.168.254.74])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature ECDSA (P-521) server-digest SHA512)
        (No client certificate requested)
        by smtp-out2.suse.de (Postfix) with ESMTPS id 11A561FF7B;
        Wed, 25 Oct 2023 15:35:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
        t=1698248154; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=1wO34fDcNH1brWPt3hSxzXbwpn4cQWaC/WSUt7ahWWk=;
        b=P8DtFXmLEgzc/53GhPJGYiZz/cxvRF3RDhZuGq+sEujYbwbgiddZ084ryL1DSyRE/GMwqA
        OO/M3yfpHPKjUj6PFN9QKYZcKzoIJb/ZoeDAKDpGpAOsCrB2UDKtoUiitpz8im8eqUw8+5
        ztAg+E7Ba24Eo5FRyHLUPiyZHVrN0qY=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
        s=susede2_ed25519; t=1698248154;
        h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=1wO34fDcNH1brWPt3hSxzXbwpn4cQWaC/WSUt7ahWWk=;
        b=/+a431iBSol9JIS9ZfkUilJjWFDfcRDVRXjIOU2ZojDNFJj3LfI9XhrhxpPpFcIoYhbHEl
        354ydgnTOFSsQoAQ==
Received: from imap2.suse-dmz.suse.de (imap2.suse-dmz.suse.de [192.168.254.74])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature ECDSA (P-521) server-digest SHA512)
        (No client certificate requested)
        by imap2.suse-dmz.suse.de (Postfix) with ESMTPS id D8F8E13524;
        Wed, 25 Oct 2023 15:35:53 +0000 (UTC)
Received: from dovecot-director2.suse.de ([192.168.254.65])
        by imap2.suse-dmz.suse.de with ESMTPSA
        id cRgoNNk1OWWwPAAAMHmgww
        (envelope-from <hare@suse.de>); Wed, 25 Oct 2023 15:35:53 +0000
Message-ID: <c8eda29e-05ad-4292-b694-8349fb8cb995@suse.de>
Date:   Wed, 25 Oct 2023 17:35:53 +0200
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 03/10] scsi: Use scsi_target as argument for
 eh_target_reset_handler()
Content-Language: en-US
To:     Benjamin Block <bblock@linux.ibm.com>
Cc:     "Martin K. Petersen" <martin.petersen@oracle.com>,
        Christoph Hellwig <hch@lst.de>,
        James Bottomley <james.bottomley@hansenpartnership.com>,
        linux-scsi@vger.kernel.org,
        Johannes Thumshirn <johannes.thumshirn@wdc.com>
References: <20231023092837.33786-1-hare@suse.de>
 <20231023092837.33786-4-hare@suse.de>
 <20231025151111.GF1917450@p1gen4-pw042f0m.boeblingen.de.ibm.com>
From:   Hannes Reinecke <hare@suse.de>
In-Reply-To: <20231025151111.GF1917450@p1gen4-pw042f0m.boeblingen.de.ibm.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
Authentication-Results: smtp-out2.suse.de;
        none
X-Spamd-Result: default: False [-7.09 / 50.00];
         ARC_NA(0.00)[];
         RCVD_VIA_SMTP_AUTH(0.00)[];
         XM_UA_NO_VERSION(0.01)[];
         FROM_HAS_DN(0.00)[];
         TO_DN_SOME(0.00)[];
         TO_MATCH_ENVRCPT_ALL(0.00)[];
         BAYES_HAM(-3.00)[100.00%];
         MIME_GOOD(-0.10)[text/plain];
         NEURAL_HAM_LONG(-3.00)[-1.000];
         RCPT_COUNT_FIVE(0.00)[6];
         DKIM_SIGNED(0.00)[suse.de:s=susede2_rsa,suse.de:s=susede2_ed25519];
         NEURAL_HAM_SHORT(-1.00)[-1.000];
         FROM_EQ_ENVFROM(0.00)[];
         MIME_TRACE(0.00)[0:+];
         RCVD_COUNT_TWO(0.00)[2];
         RCVD_TLS_ALL(0.00)[];
         MID_RHS_MATCH_FROM(0.00)[]
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On 10/25/23 17:11, Benjamin Block wrote:
> On Mon, Oct 23, 2023 at 11:28:30AM +0200, Hannes Reinecke wrote:
>> diff --git a/Documentation/scsi/scsi_eh.rst b/Documentation/scsi/scsi_eh.rst
>> index 553aff3062d5..cfaf841317ed 100644
>> --- a/Documentation/scsi/scsi_eh.rst
>> +++ b/Documentation/scsi/scsi_eh.rst
>> @@ -411,6 +412,14 @@ scmd->allowed.
>>   	    resetting clears all scmds on the sdev, there is no need
>>   	    to choose error-completed scmds.
>>   
>> +	2. If !list_empty(&eh_work_q), invoke scsi_eh_target_reset().
>> +
>> +	``scsi_eh_target_reset``
>> +
>> +	    hostt->eh_target_reset_handler() is invoked for each target.
> 
> It's only invoked for targets that have commands on the work-q, not each. We
> could have 16 rports open, but only one of them has a command that timed out,
> and is in EH.
> 
> At least that is what I thought it does.
> 
Oh, yes. It is invoked for every target for which a scmd is on the 
work_q. Will be updating the patch.

>> +	    If target reset succeeds, all failed scmds on all ready or
>> +	    offline sdevs on the target are EH-finished.
>> +
>>   	3. If !list_empty(&eh_work_q), invoke scsi_eh_bus_reset()
>>   
>>   	``scsi_eh_bus_reset``
>> diff --git a/Documentation/scsi/scsi_mid_low_api.rst b/Documentation/scsi/scsi_mid_low_api.rst
>> index 43083efc554b..8a075da5641b 100644
>> --- a/Documentation/scsi/scsi_mid_low_api.rst
>> +++ b/Documentation/scsi/scsi_mid_low_api.rst
>> @@ -758,6 +758,24 @@ Details::
>>   	int eh_bus_reset_handler(struct Scsi_Host * host, unsigned int channel)
>>   
>>   
>> +    /**
>> +    *      eh_target_reset_handler - issue SCSI target reset
>> +    *      @starget: identifies SCSI target to be reset
>> +    *
>> +    *      Returns SUCCESS if command aborted else FAILED
> 
> Same as in Patch 1. Or in a later patch, if you prefer.
> 
Yes, I do :-)

>> +    *
>> +    *      Locks: None held
>> +    *
>> +    *      Calling context: kernel thread
>> +    *
>> +    *      Notes: Invoked from scsi_eh thread. No other commands will be
>> +    *      queued on current host during eh.
>> +    *
>> +    *      Optionally defined in: LLD
>> +    **/
>> +	int eh_target_reset_handler(struct scsi_target * starget)
>> +
>> +
>>       /**
>>       *      eh_device_reset_handler - issue SCSI device reset
>>       *      @scp: identifies SCSI device to be reset
>> diff --git a/drivers/message/fusion/mptsas.c b/drivers/message/fusion/mptsas.c
>> index 300f8e955a53..a9d274cabb37 100644
>> --- a/drivers/message/fusion/mptsas.c
>> +++ b/drivers/message/fusion/mptsas.c
>> @@ -2012,7 +2020,7 @@ static const struct scsi_host_template mptsas_driver_template = {
>>   	.change_queue_depth 		= mptscsih_change_queue_depth,
>>   	.eh_timed_out			= mptsas_eh_timed_out,
>>   	.eh_abort_handler		= mptscsih_abort,
>> -	.eh_device_reset_handler	= mptscsih_dev_reset,
>> +	.eh_target_reset_handler	= mptsas_eh_target_reset,
> 
> Huh, it that correct? Replace the device reset handler with the target
> handler? That seems odd.
> 
Please check drivers/message/fusion/mptscsih.c

mptscsih_dev_reset _is_ a target reset.

>>   	.eh_host_reset_handler		= mptscsih_host_reset,
>>   	.bios_param			= mptscsih_bios_param,
>>   	.can_queue			= MPT_SAS_CAN_QUEUE,
>> diff --git a/drivers/message/fusion/mptspi.c b/drivers/message/fusion/mptspi.c
>> index 6c5920db1e9d..d379dea7074c 100644
>> --- a/drivers/message/fusion/mptspi.c
>> +++ b/drivers/message/fusion/mptspi.c
>> @@ -834,7 +840,7 @@ static const struct scsi_host_template mptspi_driver_template = {
>>   	.slave_destroy			= mptspi_slave_destroy,
>>   	.change_queue_depth 		= mptscsih_change_queue_depth,
>>   	.eh_abort_handler		= mptscsih_abort,
>> -	.eh_device_reset_handler	= mptscsih_dev_reset,
>> +	.eh_target_reset_handler	= mptspi_eh_target_reset,
> 
> ...
> 
>>   	.eh_bus_reset_handler		= mptscsih_bus_reset,
>>   	.eh_host_reset_handler		= mptscsih_host_reset,
>>   	.bios_param			= mptscsih_bios_param,
>> diff --git a/drivers/s390/scsi/zfcp_scsi.c b/drivers/s390/scsi/zfcp_scsi.c
>> index 76c136d39bf1..5c9a7c9f9a98 100644
>> --- a/drivers/s390/scsi/zfcp_scsi.c
>> +++ b/drivers/s390/scsi/zfcp_scsi.c
>> @@ -340,9 +340,12 @@ static int zfcp_scsi_eh_device_reset_handler(struct scsi_cmnd *scpnt)
>>   	return zfcp_scsi_task_mgmt_function(sdev, FCP_TMF_LUN_RESET);
>>   }
>>   
>> -static int zfcp_scsi_eh_target_reset_handler(struct scsi_cmnd *scpnt)
>> +/*
>> + * Note: We need to select a LUN as the storage array doesn't
>> + * necessarily supports LUN 0 and might refuse the target reset.
> 
> That might be true, I don't really know, but it's not the reason why we added
> this "search a sdev" logic to the function. The firmware for FCP channels
> needs a valid "LUN handle" for each FCP request we send, otherwise it's
> rejected. So we have to find a valid handle. This is an artifact from
> HBA virtualisation before NPIV on Z.
> 
> There is more details in
> 674595d8519f ("scsi: zfcp: decouple our scsi_eh callbacks from scsi_cmnd")
> 
>  From my perspective you can just remove the comment, or change it to match
> the part about `zfcp_scsi_eh_target_reset_handler()` in what Steffen wrote in
> the commit.
> 
Okay, will be doing so.

>> + */
>> +static int zfcp_scsi_eh_target_reset_handler(struct scsi_target *starget)
>>   {
>> -	struct scsi_target *starget = scsi_target(scpnt->device);
>>   	struct fc_rport *rport = starget_to_rport(starget);
>>   	struct Scsi_Host *shost = rport_to_shost(rport);
>>   	struct scsi_device *sdev = NULL, *tmp_sdev;
>> diff --git a/drivers/scsi/lpfc/lpfc_scsi.c b/drivers/scsi/lpfc/lpfc_scsi.c
>> index 98aa17a6448a..244b7a6f8616 100644
>> --- a/drivers/scsi/lpfc/lpfc_scsi.c
>> +++ b/drivers/scsi/lpfc/lpfc_scsi.c
>> @@ -6045,15 +6045,15 @@ lpfc_device_reset_handler(struct scsi_cmnd *cmnd)
>>    *  0x2002 - Success
>>    **/
>>   static int
>> -lpfc_target_reset_handler(struct scsi_cmnd *cmnd)
>> +lpfc_target_reset_handler(struct scsi_target *starget)
>>   {
>> -	struct Scsi_Host  *shost = cmnd->device->host;
>> -	struct fc_rport *rport = starget_to_rport(scsi_target(cmnd->device));
>> +	struct fc_rport *rport = starget_to_rport(starget);
>> +	struct Scsi_Host  *shost = rport_to_shost(rport);
>>   	struct lpfc_vport *vport = (struct lpfc_vport *) shost->hostdata;
>>   	struct lpfc_rport_data *rdata;
>>   	struct lpfc_nodelist *pnode;
>> -	unsigned tgt_id = cmnd->device->id;
>> -	uint64_t lun_id = cmnd->device->lun;
>> +	unsigned tgt_id = starget->id;
>> +	uint64_t lun_id = 0;
> 
> Well, hopefully storage targets for LPFC can deal with LUN 0 :)
> 
Sad to say, but it's only with zfcp where I've seen the 'WLUN' thingie 
being deployed. But alright, I'll check if I can grab a valid LUN ID.

>>   	struct lpfc_scsi_event_header scsi_event;
>>   	int status;
>>   	u32 logit = LOG_FCP;
>> diff --git a/drivers/scsi/megaraid/megaraid_sas_fusion.c b/drivers/scsi/megaraid/megaraid_sas_fusion.c
>> index c60014e07b44..bee950f11576 100644
>> --- a/drivers/scsi/megaraid/megaraid_sas_fusion.c
>> +++ b/drivers/scsi/megaraid/megaraid_sas_fusion.c
>> @@ -4804,21 +4804,25 @@ int megasas_task_abort_fusion(struct scsi_cmnd *scmd)
>>   
>>   /*
>>    * megasas_reset_target_fusion : target reset function for fusion adapters
>> - * scmd: SCSI command pointer
>> + * @shost: SCSI host pointer
>> + * @starget: SCSI target pointer
>>    *
>>    * Returns SUCCESS if all commands associated with target aborted else FAILED
>>    */
>>   
>> -int megasas_reset_target_fusion(struct scsi_cmnd *scmd)
>> +int megasas_reset_target_fusion(struct Scsi_Host *shost,
>> +				struct scsi_target *starget)
>>   {
>>   
>>   	struct megasas_instance *instance;
>> +	struct scsi_device *sdev;
>>   	int ret = FAILED;
>> -	u16 devhandle;
>> -	struct MR_PRIV_DEVICE *mr_device_priv_data;
>> -	mr_device_priv_data = scmd->device->hostdata;
>> +	u16 devhandle = USHRT_MAX;
>> +	struct MR_PRIV_DEVICE *mr_device_priv_data = NULL;
>>   
>> -	instance = (struct megasas_instance *)scmd->device->host->hostdata;
>> +	instance = (struct megasas_instance *)shost->hostdata;
> 
> `shost_priv()`? And you can move that to the top as well I think.
> 
Ok, will be doing that.

>> +	starget_printk(KERN_INFO, starget,
>> +		    "target reset called\n");
>>   
>>   	if (atomic_read(&instance->adprecovery) != MEGASAS_HBA_OPERATIONAL) {
>>   		dev_err(&instance->pdev->dev, "Controller is not OPERATIONAL,"
>> diff --git a/drivers/scsi/mpi3mr/mpi3mr_os.c b/drivers/scsi/mpi3mr/mpi3mr_os.c
>> index 381e07f2b718..63d95aa8a5f3 100644
>> --- a/drivers/scsi/mpi3mr/mpi3mr_os.c
>> +++ b/drivers/scsi/mpi3mr/mpi3mr_os.c
>> @@ -4090,54 +4090,41 @@ static int mpi3mr_eh_bus_reset(struct Scsi_Host *shost, unsigned int channel)
>>    * Return: SUCCESS of successful termination of the scmd else
>>    *         FAILED
>>    */
>> -static int mpi3mr_eh_target_reset(struct scsi_cmnd *scmd)
>> +static int mpi3mr_eh_target_reset(struct scsi_target *starget)
>>   {
>> -	struct mpi3mr_ioc *mrioc = shost_priv(scmd->device->host);
>> +	struct Scsi_Host *shost = dev_to_shost(&starget->dev);
>> +	struct mpi3mr_ioc *mrioc = shost_priv(shost);
>>   	struct mpi3mr_stgt_priv_data *stgt_priv_data;
>> -	struct mpi3mr_sdev_priv_data *sdev_priv_data;
>>   	u16 dev_handle;
>>   	u8 resp_code = 0;
>>   	int retval = FAILED, ret = 0;
>>   
>> -	sdev_printk(KERN_INFO, scmd->device,
>> -	    "Attempting Target Reset! scmd(%p)\n", scmd);
>> -	scsi_print_command(scmd);
>> -
>> -	sdev_priv_data = scmd->device->hostdata;
>> -	if (!sdev_priv_data || !sdev_priv_data->tgt_priv_data) {
>> -		sdev_printk(KERN_INFO, scmd->device,
>> -		    "SCSI device is not available\n");
>> -		retval = SUCCESS;
>> -		goto out;
>> -	}
>> +	starget_printk(KERN_INFO, starget,
>> +	    "Attempting Target Reset!\n");
> 
> Nitpick: you can remove the line-break.
> 
Yes, and no. I had been debating with me whether I really wanted
to do that. Linebreaks are in nearly all of the debugging messages
in this driver, so once I start removing them here questions will
be asked why I removed it _just_ here, or, why I removed it at all.

I'd prefer doing that in a separate patch.

>>   
>> -	stgt_priv_data = sdev_priv_data->tgt_priv_data;
>> +	stgt_priv_data = starget->hostdata;
>>   	dev_handle = stgt_priv_data->dev_handle;
>>   	if (stgt_priv_data->dev_removed) {
>> diff --git a/drivers/scsi/scsi_error.c b/drivers/scsi/scsi_error.c
>> index f82551783feb..fc0510cd367c 100644
>> --- a/drivers/scsi/scsi_error.c
>> +++ b/drivers/scsi/scsi_error.c
>> @@ -1662,7 +1664,8 @@ static int scsi_eh_target_reset(struct Scsi_Host *shost,
>>   					     " target: %d\n",
>>   					     current->comm, id));
>>   		list_for_each_entry_safe(scmd, next, &tmp_list, eh_entry) {
>> -			if (scmd_id(scmd) != id)
>> +			if (scmd_channel(scmd) != channel ||
>> +			    scmd_id(scmd) != id)
> 
> Hmm, interesting. So this was broken before as well?
> 
> Tbh., this seems like a fix that could go to stable? Should we have a separate
> patch for it?
> 
Technically, yes. In practise it'll be hard to trigger, so no-one has 
seen this issue so far.

But good point, I'll be splitting it out into a separate patch.

Cheers,

Hannes
-- 
Dr. Hannes Reinecke                Kernel Storage Architect
hare@suse.de                              +49 911 74053 688
SUSE Software Solutions GmbH, Maxfeldstr. 5, 90409 Nürnberg
HRB 36809 (AG Nürnberg), Geschäftsführer: Ivo Totev, Andrew
Myers, Andrew McDonald, Martje Boudien Moerman

