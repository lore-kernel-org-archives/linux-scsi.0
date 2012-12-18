From: Tomas Henzl <thenzl@redhat.com>
Subject: Re: [PATCH] [SCSI] mpt2sas: fix for driver fails EEH recovery from
 injected pci bus error
Date: Tue, 18 Dec 2012 14:36:47 +0100
Message-ID: <50D0716F.3030300@redhat.com>
References: <20121217215818.GA12490@lsi.com> <50CF1A55.9030304@redhat.com> <DCD177647606E9419ED923E0C8C4AA7223E761D1C8@inbmail02.lsi.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:42952 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754716Ab2LRNhC (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Tue, 18 Dec 2012 08:37:02 -0500
In-Reply-To: <DCD177647606E9419ED923E0C8C4AA7223E761D1C8@inbmail02.lsi.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: "Reddy, Sreekanth" <Sreekanth.Reddy@lsi.com>
Cc: "jejb@kernel.org" <jejb@kernel.org>, "Nandigama, Nagalakshmi" <Nagalakshmi.Nandigama@lsi.com>, "JBottomley@Parallels.com" <JBottomley@Parallels.com>, "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>, "Prakash, Sathya" <Sathya.Prakash@lsi.com>

On 12/18/2012 06:07 AM, Reddy, Sreekanth wrote:
> Yes Thomas, we need to reset the non_operational_loop to zero after the transient event.

OK, so let me repost a V2 of the whole patch. 

>
> Thanks,
> Sreekanth.
>
> -----Original Message-----
> From: Tomas Henzl [mailto:thenzl@redhat.com] 
> Sent: Monday, December 17, 2012 6:43 PM
> To: Reddy, Sreekanth
> Cc: jejb@kernel.org; Nandigama, Nagalakshmi; JBottomley@Parallels.com; linux-scsi@vger.kernel.org; Prakash, Sathya
> Subject: Re: [PATCH] [SCSI] mpt2sas: fix for driver fails EEH recovery from injected pci bus error
>
> On 12/17/2012 10:58 PM, Sreekanth Reddy wrote:
>> This patch stops the driver to invoke kthread (which remove the dead 
>> ioc) for some time while EEH recovery has started.
> Thank you for posting this, the issue we have seen is resolved now.
> Shouldn't be an additional initialization added?
> So after a transient event the non_operational_loop is reset again?
>
> Tomas
>  
> diff --git a/drivers/scsi/mpt2sas/mpt2sas_base.c b/drivers/scsi/mpt2sas/mpt2sas_base.c
> index fd3b3d7..480111c 100644
> --- a/drivers/scsi/mpt2sas/mpt2sas_base.c
> +++ b/drivers/scsi/mpt2sas/mpt2sas_base.c
> @@ -208,6 +208,8 @@ _base_fault_reset_work(struct work_struct *work)
>  		return; /* don't rearm timer */
>  	}
>  
> +	ioc->non_operational_loop = 0;
> +
>  	if ((doorbell & MPI2_IOC_STATE_MASK) == MPI2_IOC_STATE_FAULT) {
>  		rc = mpt2sas_base_hard_reset_handler(ioc, CAN_SLEEP,
>  		    FORCE_BIG_HAMMER);
>
>
>
>> Signed-off-by: Sreekanth Reddy <Sreekanth.Reddy@lsi.com>
>> ---
>>
>> diff --git a/drivers/scsi/mpt2sas/mpt2sas_base.c 
>> b/drivers/scsi/mpt2sas/mpt2sas_base.c
>> index ffd85c5..2349531 100755
>> --- a/drivers/scsi/mpt2sas/mpt2sas_base.c
>> +++ b/drivers/scsi/mpt2sas/mpt2sas_base.c
>> @@ -155,7 +155,7 @@ _base_fault_reset_work(struct work_struct *work)
>>  	struct task_struct *p;
>>  
>>  	spin_lock_irqsave(&ioc->ioc_reset_in_progress_lock, flags);
>> -	if (ioc->shost_recovery)
>> +	if (ioc->shost_recovery || ioc->pci_error_recovery)
>>  		goto rearm_timer;
>>  	spin_unlock_irqrestore(&ioc->ioc_reset_in_progress_lock, flags);
>>  
>> @@ -164,6 +164,20 @@ _base_fault_reset_work(struct work_struct *work)
>>  		printk(MPT2SAS_INFO_FMT "%s : SAS host is non-operational !!!!\n",
>>  			ioc->name, __func__);
>>  
>> +		/* It may be possible that EEH recovery can resolve some of
>> +		 * pci bus failure issues rather removing the dead ioc function
>> +		 * by considering controller is in a non-operational state. So
>> +		 * here priority is given to the EEH recovery. If it doesn't
>> +		 * not resolve this issue, mpt2sas driver will consider this
>> +		 * controller to non-operational state and remove the dead ioc
>> +		 * function.
>> +		 */
>> +		if (ioc->non_operational_loop++ < 5) {
>> +			spin_lock_irqsave(&ioc->ioc_reset_in_progress_lock,
>> +							 flags);
>> +			goto rearm_timer;
>> +		}
>> +
>>  		/*
>>  		 * Call _scsih_flush_pending_cmds callback so that we flush all
>>  		 * pending commands back to OS. This call is required to aovid @@ 
>> -4386,6 +4400,7 @@ mpt2sas_base_attach(struct MPT2SAS_ADAPTER *ioc)
>>  	if (missing_delay[0] != -1 && missing_delay[1] != -1)
>>  		_base_update_missing_delay(ioc, missing_delay[0],
>>  		    missing_delay[1]);
>> +	ioc->non_operational_loop = 0;
>>  
>>  	return 0;
>>  
>> diff --git a/drivers/scsi/mpt2sas/mpt2sas_base.h 
>> b/drivers/scsi/mpt2sas/mpt2sas_base.h
>> index 543d8d6..c6ee7aa 100755
>> --- a/drivers/scsi/mpt2sas/mpt2sas_base.h
>> +++ b/drivers/scsi/mpt2sas/mpt2sas_base.h
>> @@ -835,6 +835,7 @@ struct MPT2SAS_ADAPTER {
>>  	u16		cpu_msix_table_sz;
>>  	u32		ioc_reset_count;
>>  	MPT2SAS_FLUSH_RUNNING_CMDS schedule_dead_ioc_flush_running_cmds;
>> +	u32             non_operational_loop;
>>  
>>  	/* internal commands, callback index */
>>  	u8		scsi_io_cb_idx;
>> --
>> To unsubscribe from this list: send the line "unsubscribe linux-scsi" 
>> in the body of a message to majordomo@vger.kernel.org More majordomo 
>> info at  http://vger.kernel.org/majordomo-info.html
> --
> To unsubscribe from this list: send the line "unsubscribe linux-scsi" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html

