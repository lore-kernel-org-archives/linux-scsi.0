From: Hannes Reinecke <hare@suse.de>
Subject: Re: [PATCH 04/47] aacraid: use aac_tmf_callback for reset fib
Date: Fri, 30 Jun 2017 09:19:15 +0200
Message-ID: <b7c224d1-59f9-403c-967f-9ed8e636193a@suse.de>
References: <1498638793-44672-1-git-send-email-hare@suse.de>
 <1498638793-44672-5-git-send-email-hare@suse.de>
 <4D8E82A446BF54499747901DBDEB737A81C2CC8E@avsrvexchmbx2.microsemi.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 8bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:54861 "EHLO mx1.suse.de"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1751565AbdF3HTT (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
        Fri, 30 Jun 2017 03:19:19 -0400
In-Reply-To: <4D8E82A446BF54499747901DBDEB737A81C2CC8E@avsrvexchmbx2.microsemi.net>
Content-Language: en-US
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Raghava Aditya Renukunta <RaghavaAditya.Renukunta@microsemi.com>, Christoph Hellwig <hch@lst.de>
Cc: "Martin K. Petersen" <martin.petersen@oracle.com>, James Bottomley <james.bottomley@hansenpartnership.com>, "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>, Hannes Reinecke <hare@suse.com>

On 06/29/2017 10:06 PM, Raghava Aditya Renukunta wrote:
> [.....]
>> @@ -879,8 +906,12 @@ static int aac_eh_dev_reset(struct scsi_cmnd *cmd)
> [......]
>>         bus = aac_logical_to_phys(scmd_channel(cmd));
>>         cid = scmd_id(cmd);
>> +       info = &aac->hba_map[bus][cid];
>>         if (bus >= AAC_MAX_BUSES || cid >= AAC_MAX_TARGETS ||
>> -           aac->hba_map[bus][cid].devtype != AAC_DEVTYPE_NATIVE_RAW)
>> +           info->devtype != AAC_DEVTYPE_NATIVE_RAW)
>> +               return FAILED;
>> +
>> +       if (info->reset_state > 0)
>>                 return FAILED;
> [......]
>  
>> @@ -932,8 +962,9 @@ static int aac_eh_target_reset(struct scsi_cmnd
>> *cmd)
>>
>>         bus = aac_logical_to_phys(scmd_channel(cmd));
>>         cid = scmd_id(cmd);
>> +       info = &aac->hba_map[bus][cid];
>>         if (bus >= AAC_MAX_BUSES || cid >= AAC_MAX_TARGETS ||
>> -           aac->hba_map[bus][cid].devtype != AAC_DEVTYPE_NATIVE_RAW)
>> +           info->devtype != AAC_DEVTYPE_NATIVE_RAW)
>>                 return FAILED;
> 
> Can we have a 
> 	If (info->reset_state > 0
> 		Return FAILED;
> here as well?
> 
Sure.

Thanks for the review.

Cheers

Hannes
-- 
Dr. Hannes Reinecke		   Teamlead Storage & Networking
hare@suse.de			               +49 911 74053 688
SUSE LINUX GmbH, Maxfeldstr. 5, 90409 Nürnberg
GF: F. Imendörffer, J. Smithard, J. Guild, D. Upmanyu, G. Norton
HRB 21284 (AG Nürnberg)
