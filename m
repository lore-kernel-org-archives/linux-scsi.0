From: ygardi@codeaurora.org
Subject: Re: [PATCH v5 08/15] scsi: ufs: make error handling bit faster
Date: Tue, 1 Mar 2016 09:56:40 -0000
Message-ID: <187f423aa64d09d32c6c136e28c51fc2.squirrel@us.codeaurora.org>
References: <1456666367-11418-1-git-send-email-ygardi@codeaurora.org>
    <1456666367-11418-9-git-send-email-ygardi@codeaurora.org>
    <56D549CD.70104@suse.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-arm-msm-owner@vger.kernel.org>
In-Reply-To: <56D549CD.70104@suse.de>
Sender: linux-arm-msm-owner@vger.kernel.org
To: Hannes Reinecke <hare@suse.de>
Cc: Yaniv Gardi <ygardi@codeaurora.org>, james.bottomley@hansenpartnership.com, linux-kernel@vger.kernel.org, linux-scsi@vger.kernel.org, linux-arm-msm@vger.kernel.org, santoshsy@gmail.com, linux-scsi-owner@vger.kernel.org, Subhash Jadavani <subhashj@codeaurora.org>, Vinayak Holikatti <vinholikatti@gmail.com>, "James E.J. Bottomley" <jbottomley@odin.com>, "Martin K. Petersen" <martin.petersen@oracle.com>
List-Id: linux-scsi@vger.kernel.org

> On 02/28/2016 09:32 PM, Yaniv Gardi wrote:
>> UFS driver's error handler forcefully tries to clear all the pending
>> requests. For each pending request in the queue, it waits 1 sec for =
it
>> to get cleared. If we have multiple requests in the queue then it's
>> possible that we might end up waiting for those many seconds before
>> resetting the host. But note that resetting host would any way clear
>> all the pending requests from the hardware. Hence this change skips
>> the forceful clear of the pending requests if we are anyway going to
>> reset the host (for fatal errors).
>>
>> Signed-off-by: Subhash Jadavani <subhashj@codeaurora.org>
>> Signed-off-by: Yaniv Gardi <ygardi@codeaurora.org>
>>
>> ---
>>  drivers/scsi/ufs/ufshcd.c | 155
>> +++++++++++++++++++++++++++++++++-------------
>>  1 file changed, 112 insertions(+), 43 deletions(-)
>>
>> diff --git a/drivers/scsi/ufs/ufshcd.c b/drivers/scsi/ufs/ufshcd.c
>> index 987cf27..dc096f1 100644
>> --- a/drivers/scsi/ufs/ufshcd.c
>> +++ b/drivers/scsi/ufs/ufshcd.c
>> @@ -133,9 +133,11 @@ enum {
>>  /* UFSHCD UIC layer error flags */
>>  enum {
>>  	UFSHCD_UIC_DL_PA_INIT_ERROR =3D (1 << 0), /* Data link layer error=
 */
>> -	UFSHCD_UIC_NL_ERROR =3D (1 << 1), /* Network layer error */
>> -	UFSHCD_UIC_TL_ERROR =3D (1 << 2), /* Transport Layer error */
>> -	UFSHCD_UIC_DME_ERROR =3D (1 << 3), /* DME error */
>> +	UFSHCD_UIC_DL_NAC_RECEIVED_ERROR =3D (1 << 1), /* Data link layer =
error
>> */
>> +	UFSHCD_UIC_DL_TCx_REPLAY_ERROR =3D (1 << 2), /* Data link layer er=
ror */
>> +	UFSHCD_UIC_NL_ERROR =3D (1 << 3), /* Network layer error */
>> +	UFSHCD_UIC_TL_ERROR =3D (1 << 4), /* Transport Layer error */
>> +	UFSHCD_UIC_DME_ERROR =3D (1 << 5), /* DME error */
>>  };
>>
>>  /* Interrupt configuration options */
>> @@ -3465,31 +3467,18 @@ static void ufshcd_uic_cmd_compl(struct ufs_=
hba
>> *hba, u32 intr_status)
>>  }
>>
>>  /**
>> - * ufshcd_transfer_req_compl - handle SCSI and query command comple=
tion
>> + * __ufshcd_transfer_req_compl - handle SCSI and query command
>> completion
>>   * @hba: per adapter instance
>> + * @completed_reqs: requests to complete
>>   */
>> -static void ufshcd_transfer_req_compl(struct ufs_hba *hba)
>> +static void __ufshcd_transfer_req_compl(struct ufs_hba *hba,
>> +					unsigned long completed_reqs)
>>  {
>>  	struct ufshcd_lrb *lrbp;
>>  	struct scsi_cmnd *cmd;
>> -	unsigned long completed_reqs;
>> -	u32 tr_doorbell;
>>  	int result;
>>  	int index;
>>
>> -	/* Resetting interrupt aggregation counters first and reading the
>> -	 * DOOR_BELL afterward allows us to handle all the completed reque=
sts.
>> -	 * In order to prevent other interrupts starvation the DB is read =
once
>> -	 * after reset. The down side of this solution is the possibility =
of
>> -	 * false interrupt if device completes another request after reset=
ting
>> -	 * aggregation and before reading the DB.
>> -	 */
>> -	if (ufshcd_is_intr_aggr_allowed(hba))
>> -		ufshcd_reset_intr_aggr(hba);
>> -
>> -	tr_doorbell =3D ufshcd_readl(hba, REG_UTP_TRANSFER_REQ_DOOR_BELL);
>> -	completed_reqs =3D tr_doorbell ^ hba->outstanding_reqs;
>> -
>>  	for_each_set_bit(index, &completed_reqs, hba->nutrs) {
>>  		lrbp =3D &hba->lrb[index];
>>  		cmd =3D lrbp->cmd;
>> @@ -3519,6 +3508,31 @@ static void ufshcd_transfer_req_compl(struct
>> ufs_hba *hba)
>>  }
>>
>>  /**
>> + * ufshcd_transfer_req_compl - handle SCSI and query command comple=
tion
>> + * @hba: per adapter instance
>> + */
>> +static void ufshcd_transfer_req_compl(struct ufs_hba *hba)
>> +{
>> +	unsigned long completed_reqs;
>> +	u32 tr_doorbell;
>> +
>> +	/* Resetting interrupt aggregation counters first and reading the
>> +	 * DOOR_BELL afterward allows us to handle all the completed reque=
sts.
>> +	 * In order to prevent other interrupts starvation the DB is read =
once
>> +	 * after reset. The down side of this solution is the possibility =
of
>> +	 * false interrupt if device completes another request after reset=
ting
>> +	 * aggregation and before reading the DB.
>> +	 */
>> +	if (ufshcd_is_intr_aggr_allowed(hba))
>> +		ufshcd_reset_intr_aggr(hba);
>> +
>> +	tr_doorbell =3D ufshcd_readl(hba, REG_UTP_TRANSFER_REQ_DOOR_BELL);
>> +	completed_reqs =3D tr_doorbell ^ hba->outstanding_reqs;
>> +
>> +	__ufshcd_transfer_req_compl(hba, completed_reqs);
>> +}
>> +
>> +/**
>>   * ufshcd_disable_ee - disable exception event
>>   * @hba: per-adapter instance
>>   * @mask: exception event to disable
>> @@ -3773,6 +3787,13 @@ out:
>>  	return;
>>  }
>>
>> +/* Complete requests that have door-bell cleared */
>> +static void ufshcd_complete_requests(struct ufs_hba *hba)
>> +{
>> +	ufshcd_transfer_req_compl(hba);
>> +	ufshcd_tmc_handler(hba);
>> +}
>> +
>>  /**
>>   * ufshcd_err_handler - handle UFS errors that require s/w attentio=
n
>>   * @work: pointer to work structure
>> @@ -3785,6 +3806,7 @@ static void ufshcd_err_handler(struct work_str=
uct
>> *work)
>>  	u32 err_tm =3D 0;
>>  	int err =3D 0;
>>  	int tag;
>> +	bool needs_reset =3D false;
>>
>>  	hba =3D container_of(work, struct ufs_hba, eh_work);
>>
>> @@ -3792,40 +3814,75 @@ static void ufshcd_err_handler(struct
>> work_struct *work)
>>  	ufshcd_hold(hba, false);
>>
>>  	spin_lock_irqsave(hba->host->host_lock, flags);
>> -	if (hba->ufshcd_state =3D=3D UFSHCD_STATE_RESET) {
>> -		spin_unlock_irqrestore(hba->host->host_lock, flags);
>> +	if (hba->ufshcd_state =3D=3D UFSHCD_STATE_RESET)
>>  		goto out;
>> -	}
>>
>>  	hba->ufshcd_state =3D UFSHCD_STATE_RESET;
>>  	ufshcd_set_eh_in_progress(hba);
>>
>>  	/* Complete requests that have door-bell cleared by h/w */
>> -	ufshcd_transfer_req_compl(hba);
>> -	ufshcd_tmc_handler(hba);
>> -	spin_unlock_irqrestore(hba->host->host_lock, flags);
>> +	ufshcd_complete_requests(hba);
>> +	if ((hba->saved_err & INT_FATAL_ERRORS) ||
>> +	    ((hba->saved_err & UIC_ERROR) &&
>> +	    (hba->saved_uic_err & (UFSHCD_UIC_DL_PA_INIT_ERROR |
>> +				   UFSHCD_UIC_DL_NAC_RECEIVED_ERROR |
>> +				   UFSHCD_UIC_DL_TCx_REPLAY_ERROR))))
>> +		needs_reset =3D true;
>>
>> +	/*
>> +	 * if host reset is required then skip clearing the pending
>> +	 * transfers forcefully because they will automatically get
>> +	 * cleared after link startup.
>> +	 */
>> +	if (needs_reset)
>> +		goto skip_pending_xfer_clear;
>> +
>> +	/* release lock as clear command might sleep */
>> +	spin_unlock_irqrestore(hba->host->host_lock, flags);
>>  	/* Clear pending transfer requests */
>> -	for_each_set_bit(tag, &hba->outstanding_reqs, hba->nutrs)
>> -		if (ufshcd_clear_cmd(hba, tag))
>> -			err_xfer |=3D 1 << tag;
>> +	for_each_set_bit(tag, &hba->outstanding_reqs, hba->nutrs) {
>> +		if (ufshcd_clear_cmd(hba, tag)) {
>> +			err_xfer =3D true;
>> +			goto lock_skip_pending_xfer_clear;
>> +		}
>> +	}
>>
>>  	/* Clear pending task management requests */
>> -	for_each_set_bit(tag, &hba->outstanding_tasks, hba->nutmrs)
>> -		if (ufshcd_clear_tm_cmd(hba, tag))
>> -			err_tm |=3D 1 << tag;
>> +	for_each_set_bit(tag, &hba->outstanding_tasks, hba->nutmrs) {
>> +		if (ufshcd_clear_tm_cmd(hba, tag)) {
>> +			err_tm =3D true;
>> +			goto lock_skip_pending_xfer_clear;
>> +		}
>> +	}
>>
>> -	/* Complete the requests that are cleared by s/w */
>> +lock_skip_pending_xfer_clear:
>>  	spin_lock_irqsave(hba->host->host_lock, flags);
>> -	ufshcd_transfer_req_compl(hba);
>> -	ufshcd_tmc_handler(hba);
>> -	spin_unlock_irqrestore(hba->host->host_lock, flags);
>>
>> +	/* Complete the requests that are cleared by s/w */
>> +	ufshcd_complete_requests(hba);
>> +
>> +	if (err_xfer || err_tm)
>> +		needs_reset =3D true;
>> +
>> +skip_pending_xfer_clear:
>>  	/* Fatal errors need reset */
>> -	if (err_xfer || err_tm || (hba->saved_err & INT_FATAL_ERRORS) ||
>> -			((hba->saved_err & UIC_ERROR) &&
>> -			 (hba->saved_uic_err & UFSHCD_UIC_DL_PA_INIT_ERROR))) {
>> +	if (needs_reset) {
>> +		unsigned long max_doorbells =3D (1UL << hba->nutrs) - 1;
>> +
>> +		/*
>> +		 * ufshcd_reset_and_restore() does the link reinitialization
>> +		 * which will need atleast one empty doorbell slot to send the
>> +		 * device management commands (NOP and query commands).
>> +		 * If there is no slot empty at this moment then free up last
>> +		 * slot forcefully.
>> +		 */
>> +		if (hba->outstanding_reqs =3D=3D max_doorbells)
>> +			__ufshcd_transfer_req_compl(hba,
>> +						    (1UL << (hba->nutrs - 1)));
>> +
>> +		spin_unlock_irqrestore(hba->host->host_lock, flags);
>>  		err =3D ufshcd_reset_and_restore(hba);
>> +		spin_lock_irqsave(hba->host->host_lock, flags);
>>  		if (err) {
>>  			dev_err(hba->dev, "%s: reset and restore failed\n",
>>  					__func__);
> Why don't you reserve a command slot for this case (ie reduce the num=
ber
> of tags by one)?
> That way you would always have at least one slot free, wouldn't you?
>

Hello Hannes,

We are discussing here, a very-very rare scenario where 2 conditions mu=
st
co-exist:
1. a fatal error that requires the controller to be reset.
2. all slots are taken.

This 2 conditions, very rarely should happen together.
At that point, it would be better to free the last slot, than to save o=
ne
slot for this scenario.
Also, we should remember that reducing the queue-depth for the entire
usual operation, might be a performance hit at some point, where, for
example, a LUN has only 8 slots, will now have 7, which is a hit of 12.=
5%
of the potential parallelism. So, i would recommend to stick with the
above proposal that not only makes more sense when you estimate the
probability of the conditions to co-exist, but also was tested and prov=
en
to be safe with no performance hit.

Regards,
Yaniv




> Cheers,
>
> Hannes
> --
> Dr. Hannes Reinecke		      zSeries & Storage
> hare@suse.de			      +49 911 74053 688
> SUSE LINUX Products GmbH, Maxfeldstr. 5, 90409 N=FCrnberg
> GF: J. Hawn, J. Guild, F. Imend=F6rffer, HRB 16746 (AG N=FCrnberg)
> --
> To unsubscribe from this list: send the line "unsubscribe linux-scsi"=
 in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
>
