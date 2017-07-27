From: Maurizio Lombardi <mlombard@redhat.com>
Subject: Re: [PATCH] lpfc: fix "integer constant too large" error on 32bit
 archs
Date: Thu, 27 Jul 2017 16:50:24 +0200
Message-ID: <29ddc2de-02f9-9dff-8231-52bc560de173@redhat.com>
References: <1501158782-29604-1-git-send-email-mlombard@redhat.com>
 <yq1eft2vxzk.fsf@oracle.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:12784 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751867AbdG0Ou1 (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
        Thu, 27 Jul 2017 10:50:27 -0400
In-Reply-To: <yq1eft2vxzk.fsf@oracle.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: "Martin K. Petersen" <martin.petersen@oracle.com>
Cc: james.smart@broadcom.com, dick.kennedy@broadcom.com, jejb@linux.vnet.ibm.com, linux-scsi@vger.kernel.org



Dne 27.7.2017 v 14:57 Martin K. Petersen napsal(a):
>> diff --git a/drivers/scsi/lpfc/lpfc_init.c b/drivers/scsi/lpfc/lpfc_init.c
>> index 491aa95..e992dc1 100644
>> --- a/drivers/scsi/lpfc/lpfc_init.c
>> +++ b/drivers/scsi/lpfc/lpfc_init.c
>> @@ -3710,8 +3710,8 @@
>>  	if (phba->sli_rev == LPFC_SLI_REV4)
>>  		return be64_to_cpu(wwn);
>>  	else
>> -		return (((wwn & 0xffffffff00000000) >> 32) |
>> -			((wwn & 0x00000000ffffffff) << 32));
>> +		return (((wwn & 0xffffffff00000000ULL) >> 32) |
>> +			((wwn & 0x00000000ffffffffULL) << 32));
> 
> rol64()?
> 

Right,

I will send a new version.
Maurizio
