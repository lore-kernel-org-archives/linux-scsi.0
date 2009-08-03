From: Joe Eykholt <jeykholt@cisco.com>
Subject: Re: [PATCH] lpfc: Read buffer overflow
Date: Mon, 03 Aug 2009 10:15:22 -0700
Message-ID: <4A771B2A.9050307@cisco.com>
References: <4A754999.90208@gmail.com> <4A76FC0D.7080005@emulex.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from sj-iport-2.cisco.com ([171.71.176.71]:20296 "EHLO
	sj-iport-2.cisco.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751307AbZHCRPY (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Mon, 3 Aug 2009 13:15:24 -0400
In-Reply-To: <4A76FC0D.7080005@emulex.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James Smart <James.Smart@Emulex.Com>
Cc: Roel Kluin <roel.kluin@gmail.com>, "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>, Andrew Morton <akpm@linux-foundation.org>

James Smart wrote:
> NACK -  the vports array is created such that it is sized for 
> phba->max_vports + 1.

It's not an off-by-one problem, it's a look-before-leaping problem.

	Regards,
	Joe

> 
> -- james s
> 
> Roel Kluin wrote:
>> Check whether index is within bounds before testing the element.
>>
>> Signed-off-by: Roel Kluin <roel.kluin@gmail.com>
>> ---
>> diff --git a/drivers/scsi/lpfc/lpfc_vport.c 
>> b/drivers/scsi/lpfc/lpfc_vport.c
>> index e0b4992..ade2df6 100644
>> --- a/drivers/scsi/lpfc/lpfc_vport.c
>> +++ b/drivers/scsi/lpfc/lpfc_vport.c
>> @@ -762,7 +762,7 @@ lpfc_destroy_vport_work_array(struct lpfc_hba 
>> *phba, struct lpfc_vport **vports)
>>      int i;
>>      if (vports == NULL)
>>          return;
>> -    for (i = 0; vports[i] != NULL && i <= phba->max_vports; i++)
>> +    for (i = 0; i <= phba->max_vports && vports[i] != NULL; i++)
>>          scsi_host_put(lpfc_shost_from_vport(vports[i]));
>>      kfree(vports);
>>  }
>>
>>   
> -- 
> To unsubscribe from this list: send the line "unsubscribe linux-scsi" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html

