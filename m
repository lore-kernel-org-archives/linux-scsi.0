From: James Smart <James.Smart@Emulex.Com>
Subject: Re: [PATCH] lpfc: Read buffer overflow
Date: Tue, 4 Aug 2009 09:29:35 -0400
Message-ID: <4A7837BF.2090000@emulex.com>
References: <4A754999.90208@gmail.com> <4A76FC0D.7080005@emulex.com> <4A771B2A.9050307@cisco.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="ISO-8859-1"; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from emulex.emulex.com ([138.239.112.1]:64069 "EHLO
	emulex.emulex.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754540AbZHDOIb (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Tue, 4 Aug 2009 10:08:31 -0400
In-Reply-To: <4A771B2A.9050307@cisco.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Joe Eykholt <jeykholt@cisco.com>
Cc: Roel Kluin <roel.kluin@gmail.com>, "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>, Andrew Morton <akpm@linux-foundation.org>

Ok - it's good practice. But really, it's change for change sake, rather than 
fixing any problem.

-- james s

Joe Eykholt wrote:
> James Smart wrote:
>> NACK -  the vports array is created such that it is sized for 
>> phba->max_vports + 1.
> 
> It's not an off-by-one problem, it's a look-before-leaping problem.
> 
> 	Regards,
> 	Joe
> 
>> -- james s
>>
>> Roel Kluin wrote:
>>> Check whether index is within bounds before testing the element.
>>>
>>> Signed-off-by: Roel Kluin <roel.kluin@gmail.com>
>>> ---
>>> diff --git a/drivers/scsi/lpfc/lpfc_vport.c 
>>> b/drivers/scsi/lpfc/lpfc_vport.c
>>> index e0b4992..ade2df6 100644
>>> --- a/drivers/scsi/lpfc/lpfc_vport.c
>>> +++ b/drivers/scsi/lpfc/lpfc_vport.c
>>> @@ -762,7 +762,7 @@ lpfc_destroy_vport_work_array(struct lpfc_hba 
>>> *phba, struct lpfc_vport **vports)
>>>      int i;
>>>      if (vports == NULL)
>>>          return;
>>> -    for (i = 0; vports[i] != NULL && i <= phba->max_vports; i++)
>>> +    for (i = 0; i <= phba->max_vports && vports[i] != NULL; i++)
>>>          scsi_host_put(lpfc_shost_from_vport(vports[i]));
>>>      kfree(vports);
>>>  }
>>>
>>>   
>> -- 
>> To unsubscribe from this list: send the line "unsubscribe linux-scsi" in
>> the body of a message to majordomo@vger.kernel.org
>> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> 
> 
