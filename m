From: Tomas Henzl <thenzl@redhat.com>
Subject: Re: [PATCH 02/21] lpfc: Add Lancer Temperature Event support to the
 lpfc driver
Date: Tue, 17 Feb 2015 14:01:03 +0100
Message-ID: <54E33B8F.4060403@redhat.com>
References: <1423164194.7917.26.camel@myfc17> <54D4B0A0.2050602@redhat.com> <54E2167F.3070500@emulex.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:59126 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754853AbbBQNBH (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Tue, 17 Feb 2015 08:01:07 -0500
In-Reply-To: <54E2167F.3070500@emulex.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: james.smart@emulex.com
Cc: linux-scsi@vger.kernel.org

On 02/16/2015 05:10 PM, James Smart wrote:
> On 2/6/2015 7:16 AM, Tomas Henzl wrote:
>> On 02/05/2015 08:23 PM, James Smart wrote:
>>> ---
>>>   drivers/scsi/lpfc/lpfc_hw4.h  |   1 +
>>>   drivers/scsi/lpfc/lpfc_init.c | 179 +++++++++++++++++++++++++++++-------------
>>>   2 files changed, 125 insertions(+), 55 deletions(-)
>>>
>>> diff --git a/drivers/scsi/lpfc/lpfc_hw4.h b/drivers/scsi/lpfc/lpfc_hw4.h
>>> index f432ec1..3121ec4 100644
>>> --- a/drivers/scsi/lpfc/lpfc_hw4.h
>>> +++ b/drivers/scsi/lpfc/lpfc_hw4.h
>>> @@ -3244,6 +3244,7 @@ struct lpfc_acqe_sli {
>>>   #define LPFC_SLI_EVENT_TYPE_NVLOG_POST		0x4
>>>   #define LPFC_SLI_EVENT_TYPE_DIAG_DUMP		0x5
>>>   #define LPFC_SLI_EVENT_TYPE_MISCONFIGURED	0x9
>>> +#define LPFC_SLI_EVENT_TYPE_REMOTE_DPORT	0xA
>>>   };
>>>   
>>>   /*
>>> diff --git a/drivers/scsi/lpfc/lpfc_init.c b/drivers/scsi/lpfc/lpfc_init.c
>>> index 2b5b910..4ba91af 100644
>>> --- a/drivers/scsi/lpfc/lpfc_init.c
>>> +++ b/drivers/scsi/lpfc/lpfc_init.c
>>> @@ -1330,13 +1330,14 @@ lpfc_offline_eratt(struct lpfc_hba *phba)
>>>   void
>>>   lpfc_sli4_offline_eratt(struct lpfc_hba *phba)
>>>   {
>>> +	spin_lock_irq(&phba->hbalock);
>>> +	phba->link_state = LPFC_HBA_ERROR;
>>> +	spin_unlock_irq(&phba->hbalock);
>> Hi James,
>> please explain why is the spinlock^ needed?
>> There seems to be lot of other places where link_state is not protected,
>> for example it is evaluated in lpfc_sli4_handle_received_buffer with no lock.
>>
>> Could you please also add some more description to the of the body your mails,
>> sometimes  a subject only is not enough.
>>
>> Thanks,
>> Tomas
> Well - good question - access should be under lock, and it wouldn't 
> surprise me if there are some cases, especially read checks, where it 
> isn't. In most cases, this bad behavior works, as the variable doesn't 
> change often, and even when it does, there's very long time delays 
> before something would reference the change. Not trying to say it 
> shouldn't be fixed, but rather why it hasn't been an issue. This one 
> will take a little bit to clean up - it reached this point historically 
> over many successive changes.

OK, makes sense, I have found at least one place where is a spinlock used,
his is a start for an longer process - I'm fine with the explanation.
and also with your response in 7/21+10/21.

>
> Yes, I'll add a little meat to future patches.

Thanks.

tomash

>
> -- james s
>
>
>
> --
> To unsubscribe from this list: send the line "unsubscribe linux-scsi" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html

