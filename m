From: James Smart <James.Smart@Emulex.Com>
Subject: Re: New sparse warning in lpfc_sli.c
Date: Thu, 21 Feb 2008 08:47:10 -0500
Message-ID: <47BD80DE.4060308@emulex.com>
References: <1203579019.20345.8.camel@brick> <20080221124433.GC16995@parisc-linux.org>
Reply-To: James.Smart@Emulex.Com
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from emulex.emulex.com ([138.239.112.1]:47589 "EHLO
	emulex.emulex.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751121AbYBUNrV (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Thu, 21 Feb 2008 08:47:21 -0500
In-Reply-To: <20080221124433.GC16995@parisc-linux.org>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Matthew Wilcox <matthew@wil.cx>
Cc: Harvey Harrison <harvey.harrison@gmail.com>, James Bottomley <James.Bottomley@HansenPartnership.com>, linux-scsi <linux-scsi@vger.kernel.org>

Thanks Matt.

ACK

-- james s


Matthew Wilcox wrote:
> On Wed, Feb 20, 2008 at 11:30:19PM -0800, Harvey Harrison wrote:
>> James, somewhere between 2.6.25-rc1 and -rc2 this new warning appeared, care
>> to give the locking a quick once-over here?
>>
>> drivers/scsi/lpfc/lpfc_sli.c:645:1: warning: context imbalance in 'lpfc_sli_hbqbuf_fill_hbqs' - wrong count at exit
> 
> Easy enough to spot by hand:
> 
>         /* Check whether HBQ is still in use */
>         spin_lock_irqsave(&phba->hbalock, flags);
>         if (!phba->hbq_in_use) {
>                 spin_unlock_irqrestore(&phba->hbalock, flags);
>                 return 0;
>         }
> 
>         /* Populate HBQ entries */
>         for (i = start; i < end; i++) {
>                 hbq_buffer = (phba->hbqs[hbqno].hbq_alloc_buffer)(phba);
>                 if (!hbq_buffer)
> --->                    return 1;
> 
> Here's a patch:
> 
> lpfc: Balance locking
> 
> Commit 3163f725a5d071eea1830bbbfab78cfe3fc9baaf introduced locking in
> lpfc_sli_hbqbuf_fill_hbqs, but missed unlocking on one exit.
> 
> Reported-by: Harvey Harrison <harvey.harrison@gmail.com>
> Signed-off-by: Matthew Wilcox <willy@linux.intel.com>
> Cc: James Smart <james.smart@emulex.com>
> 
> diff --git a/drivers/scsi/lpfc/lpfc_sli.c b/drivers/scsi/lpfc/lpfc_sli.c
> index f532064..fc0d950 100644
> --- a/drivers/scsi/lpfc/lpfc_sli.c
> +++ b/drivers/scsi/lpfc/lpfc_sli.c
> @@ -648,28 +648,24 @@ lpfc_sli_hbqbuf_fill_hbqs(struct lpfc_hba *phba, uint32_t hbqno, uint32_t count)
>  	unsigned long flags;
>  	struct hbq_dmabuf *hbq_buffer;
>  
> -	if (!phba->hbqs[hbqno].hbq_alloc_buffer) {
> +	if (!phba->hbqs[hbqno].hbq_alloc_buffer)
>  		return 0;
> -	}
>  
>  	start = phba->hbqs[hbqno].buffer_count;
>  	end = count + start;
> -	if (end > lpfc_hbq_defs[hbqno]->entry_count) {
> +	if (end > lpfc_hbq_defs[hbqno]->entry_count)
>  		end = lpfc_hbq_defs[hbqno]->entry_count;
> -	}
>  
>  	/* Check whether HBQ is still in use */
>  	spin_lock_irqsave(&phba->hbalock, flags);
> -	if (!phba->hbq_in_use) {
> -		spin_unlock_irqrestore(&phba->hbalock, flags);
> -		return 0;
> -	}
> +	if (!phba->hbq_in_use)
> +		goto out;
>  
>  	/* Populate HBQ entries */
>  	for (i = start; i < end; i++) {
>  		hbq_buffer = (phba->hbqs[hbqno].hbq_alloc_buffer)(phba);
>  		if (!hbq_buffer)
> -			return 1;
> +			goto err;
>  		hbq_buffer->tag = (i | (hbqno << 16));
>  		if (lpfc_sli_hbq_to_firmware(phba, hbqno, hbq_buffer))
>  			phba->hbqs[hbqno].buffer_count++;
> @@ -677,8 +673,12 @@ lpfc_sli_hbqbuf_fill_hbqs(struct lpfc_hba *phba, uint32_t hbqno, uint32_t count)
>  			(phba->hbqs[hbqno].hbq_free_buffer)(phba, hbq_buffer);
>  	}
>  
> + out:
>  	spin_unlock_irqrestore(&phba->hbalock, flags);
>  	return 0;
> + err:
> +	spin_unlock_irqrestore(&phba->hbalock, flags);
> +	return 1;
>  }
>  
>  int
> 
