From: Mike Christie <michaelc@cs.wisc.edu>
Subject: Re: [PATCH 03/15] be2iscsi: Fix to use atomic operations for tag_state
Date: Sun, 20 Dec 2015 03:01:18 -0600
Message-ID: <56766E5E.1030605@cs.wisc.edu>
References: <1450194906-12925-1-git-send-email-jitendra.bhivare@avagotech.com> <1450194906-12925-4-git-send-email-jitendra.bhivare@avagotech.com> <56765C66.5080204@cs.wisc.edu>
Mime-Version: 1.0
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from sabe.cs.wisc.edu ([128.105.6.20]:42069 "EHLO sabe.cs.wisc.edu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754146AbbLTJB0 (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Sun, 20 Dec 2015 04:01:26 -0500
In-Reply-To: <56765C66.5080204@cs.wisc.edu>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Jitendra Bhivare <jitendra.bhivare@avagotech.com>, linux-scsi@vger.kernel.org

On 12/20/2015 01:44 AM, Mike Christie wrote:

>> diff --git a/drivers/scsi/be2iscsi/be_cmds.c b/drivers/scsi/be2iscsi/be_cmds.c
>> index 6fabded..21c806f 100644
>> --- a/drivers/scsi/be2iscsi/be_cmds.c
>> +++ b/drivers/scsi/be2iscsi/be_cmds.c
>> @@ -164,9 +164,8 @@ int beiscsi_mccq_compl(struct beiscsi_hba *phba,
>>  	}
>>  
>>  	/* Set MBX Tag state to Active */
>> -	mutex_lock(&phba->ctrl.mbox_lock);
>> -	phba->ctrl.ptag_state[tag].tag_state = MCC_TAG_STATE_RUNNING;
>> -	mutex_unlock(&phba->ctrl.mbox_lock);
>> +	atomic_set(&phba->ctrl.ptag_state[tag].tag_state,
>> +			MCC_TAG_STATE_RUNNING);
>>  


Is it possible for be_mcc_compl_process_isr to run before we have set
the state to MCC_TAG_STATE_RUNNING, so the
wait_event_interruptible_timeout call timesout?


>>  	/* wait for the mccq completion */
>>  	rc = wait_event_interruptible_timeout(
>> @@ -178,9 +177,8 @@ int beiscsi_mccq_compl(struct beiscsi_hba *phba,
>>  	if (rc <= 0) {
>>  		struct be_dma_mem *tag_mem;
>>  		/* Set MBX Tag state to timeout */
>> -		mutex_lock(&phba->ctrl.mbox_lock);
>> -		phba->ctrl.ptag_state[tag].tag_state = MCC_TAG_STATE_TIMEOUT;
>> -		mutex_unlock(&phba->ctrl.mbox_lock);
>> +		atomic_set(&phba->ctrl.ptag_state[tag].tag_state,
>> +				MCC_TAG_STATE_TIMEOUT);
>>  
>>  		/* Store resource addr to be freed later */
>>  		tag_mem = &phba->ctrl.ptag_state[tag].tag_mem_state;
>> @@ -199,9 +197,8 @@ int beiscsi_mccq_compl(struct beiscsi_hba *phba,
>>  	} else {
>>  		rc = 0;
>>  		/* Set MBX Tag state to completed */
>> -		mutex_lock(&phba->ctrl.mbox_lock);
>> -		phba->ctrl.ptag_state[tag].tag_state = MCC_TAG_STATE_COMPLETED;
>> -		mutex_unlock(&phba->ctrl.mbox_lock);
>> +		atomic_set(&phba->ctrl.ptag_state[tag].tag_state,
>> +				MCC_TAG_STATE_COMPLETED);
>>  	}
>>  
>>  	mcc_tag_response = phba->ctrl.mcc_numtag[tag];
>> @@ -373,9 +370,11 @@ int be_mcc_compl_process_isr(struct be_ctrl_info *ctrl,
>>  	ctrl->mcc_numtag[tag] |= (extd_status & 0x000000FF) << 8;
>>  	ctrl->mcc_numtag[tag] |= (compl_status & 0x000000FF);
>>  
>> -	if (ctrl->ptag_state[tag].tag_state == MCC_TAG_STATE_RUNNING) {
>> +	if (atomic_read(&ctrl->ptag_state[tag].tag_state) ==
>> +		MCC_TAG_STATE_RUNNING) {
>>  		wake_up_interruptible(&ctrl->mcc_wait[tag]);
>> -	} else if (ctrl->ptag_state[tag].tag_state == MCC_TAG_STATE_TIMEOUT) {
>> +	} else if (atomic_read(&ctrl->ptag_state[tag].tag_state) ==
>> +			MCC_TAG_STATE_TIMEOUT) {
>>  		struct be_dma_mem *tag_mem;
>>  		tag_mem = &ctrl->ptag_state[tag].tag_mem_state;
>>  
>> @@ -390,9 +389,8 @@ int be_mcc_compl_process_isr(struct be_ctrl_info *ctrl,
>>  					    tag_mem->va, tag_mem->dma);
>>  
>>  		/* Change tag state */
>> -		mutex_lock(&phba->ctrl.mbox_lock);
>> -		ctrl->ptag_state[tag].tag_state = MCC_TAG_STATE_COMPLETED;
>> -		mutex_unlock(&phba->ctrl.mbox_lock);
>> +		atomic_set(&ctrl->ptag_state[tag].tag_state,
>> +				MCC_TAG_STATE_COMPLETED);
>>  
>>  		/* Free MCC Tag */
>>  		free_mcc_tag(ctrl, tag);
>>
> 
> I think if you only need to get and set a u8 then you can just use a u8
> since the operation will be atomic. No need for a atomic_t.

I think you can ignore this. I think you would need some barriers in
there too and it might be more complicated for no gain.



