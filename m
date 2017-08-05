From: James Smart <james.smart@broadcom.com>
Subject: Re: [PATCH 01/21] lpfc: Fix opps when ExpressLane is enabled
Date: Fri, 4 Aug 2017 17:36:18 -0700
Message-ID: <d7b7e8f2-4967-4f47-a34e-6f535c4ec88d@broadcom.com>
References: <20170802233648.4573-1-jsmart2021@gmail.com>
 <20170802233648.4573-2-jsmart2021@gmail.com> <87bmnxgce1.fsf@suse.cz>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-pf0-f170.google.com ([209.85.192.170]:36427 "EHLO
        mail-pf0-f170.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751323AbdHEAgV (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Fri, 4 Aug 2017 20:36:21 -0400
Received: by mail-pf0-f170.google.com with SMTP id c28so12762290pfe.3
        for <linux-scsi@vger.kernel.org>; Fri, 04 Aug 2017 17:36:21 -0700 (PDT)
In-Reply-To: <87bmnxgce1.fsf@suse.cz>
Content-Language: en-US
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Nikola Pajkovsky <npajkovsky@suse.cz>, James Smart <jsmart2021@gmail.com>
Cc: linux-scsi@vger.kernel.org, Dick Kennedy <dick.kennedy@broadcom.com>

On 8/3/2017 3:43 AM, Nikola Pajkovsky wrote:
> James Smart <jsmart2021@gmail.com> writes:
>
>> From: Dick Kennedy <dick.kennedy@broadcom.com>
>>
>> Null pointer dereference in lpfc_sli4_fof_intr_handler
>>
>> The driver does not set up cq->assoc_qp for sli4_hba->oas_cq
>>
>> Initialize cq->assoc_qp before accessing it
>>
>> Signed-off-by: Dick Kennedy <dick.kennedy@broadcom.com>
>> Signed-off-by: James Smart <james.smart@broadcom.com>
>> ---
>>   drivers/scsi/lpfc/lpfc_sli.c | 3 +++
>>   1 file changed, 3 insertions(+)
>>
>> diff --git a/drivers/scsi/lpfc/lpfc_sli.c b/drivers/scsi/lpfc/lpfc_sli.c
>> index e948ea05fd33..0615bf9def23 100644
>> --- a/drivers/scsi/lpfc/lpfc_sli.c
>> +++ b/drivers/scsi/lpfc/lpfc_sli.c
>> @@ -13557,6 +13557,9 @@ lpfc_sli4_fof_handle_eqe(struct lpfc_hba *phba, struct lpfc_eqe *eqe)
>>   	/* Save EQ associated with this CQ */
>>   	cq->assoc_qp = phba->sli4_hba.fof_eq;
>>   
>> +	/* Save EQ associated with this CQ */
>> +	cq->assoc_qp = phba->sli4_hba.fof_eq;
>> +
> Copy & paste error? Above lines are similar.
>
yeah - a pretty stupid error. I believe we merged the same patch twice 
at different time points. surprised git am allowed it.

Thanks. patch will be removed.

-- james
