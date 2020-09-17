Return-Path: <SRS0=qxeY=C2=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-11.3 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,NICE_REPLY_A,
	SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_SANE_1
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 7B9E2C433E2
	for <linux-scsi@archiver.kernel.org>; Thu, 17 Sep 2020 05:53:45 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 3D12720936
	for <linux-scsi@archiver.kernel.org>; Thu, 17 Sep 2020 05:53:45 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726152AbgIQFxo (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Thu, 17 Sep 2020 01:53:44 -0400
Received: from mx2.suse.de ([195.135.220.15]:42608 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725267AbgIQFxo (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
        Thu, 17 Sep 2020 01:53:44 -0400
X-Greylist: delayed 976 seconds by postgrey-1.27 at vger.kernel.org; Thu, 17 Sep 2020 01:53:43 EDT
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
Received: from relay2.suse.de (unknown [195.135.221.27])
        by mx2.suse.de (Postfix) with ESMTP id A2757B0BA;
        Thu, 17 Sep 2020 05:37:41 +0000 (UTC)
Subject: Re: [PATCH] lpfc: use NVMe error codes for LS request done callback
To:     James Smart <james.smart@broadcom.com>
Cc:     "Martin K. Petersen" <martin.petersen@oracle.com>,
        Christoph Hellwig <hch@lst.de>,
        James Bottomley <james.bottomley@hansenpartnership.com>,
        linux-scsi@vger.kernel.org
References: <20200916085059.27206-1-hare@suse.de>
 <97c2e517-6b7b-70f5-f8da-14145f00361c@broadcom.com>
From:   Hannes Reinecke <hare@suse.de>
Message-ID: <3fbfcab8-e6bc-a609-2162-d95ccb39501d@suse.de>
Date:   Thu, 17 Sep 2020 07:37:24 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.11.0
MIME-Version: 1.0
In-Reply-To: <97c2e517-6b7b-70f5-f8da-14145f00361c@broadcom.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On 9/16/20 11:23 PM, James Smart wrote:
> 
> 
> On 9/16/2020 1:50 AM, Hannes Reinecke wrote:
>> The LS request callback requires a 'status' argument, but that one
>> should be an NVMe error code, not a driver specific one which has
>> no meaning in the nvme layer.
>>
>> Signed-off-by: Hannes Reinecke <hare@suse.de>
>> ---
>>   drivers/scsi/lpfc/lpfc_nvme.c | 4 +++-
>>   1 file changed, 3 insertions(+), 1 deletion(-)
>>
>> diff --git a/drivers/scsi/lpfc/lpfc_nvme.c 
>> b/drivers/scsi/lpfc/lpfc_nvme.c
>> index e5be334d6a11..4b007a28014b 100644
>> --- a/drivers/scsi/lpfc/lpfc_nvme.c
>> +++ b/drivers/scsi/lpfc/lpfc_nvme.c
>> @@ -498,7 +498,9 @@ __lpfc_nvme_ls_req_cmp(struct lpfc_hba *phba,  
>> struct lpfc_vport *vport,
>>           cmdwqe->context3 = NULL;
>>       }
>>       if (pnvme_lsreq->done)
>> -        pnvme_lsreq->done(pnvme_lsreq, status);
>> +        pnvme_lsreq->done(pnvme_lsreq,
>> +                  status == IOSTAT_SUCCESS ?
>> +                  NVME_SC_SUCCESS : NVME_SC_INTERNAL);
>>       else
>>           lpfc_printf_vlog(vport, KERN_ERR, LOG_TRACE_EVENT,
>>                    "6046 NVMEx cmpl without done call back? "
> 
> No - it's not a nvme command, so doesn't need a nvme status code. It 
> should be a -Exxx  value or a 0 (success).  nvme_fc_send_ls_req() for 
> example calls __nvme_fc_send_ls_req(), which can return any number of 
> -Exxx values, and the routine returns the value returned by the done 
> call after waiting for it to complete - so they should all follow the 
> same form.
> 
Right. But returning IOSTAT definitions is still wrong :->

Will be updating the patch.

Cheers,

Hannes
-- 
Dr. Hannes Reinecke                Kernel Storage Architect
hare@suse.de                              +49 911 74053 688
SUSE Software Solutions GmbH, Maxfeldstr. 5, 90409 Nürnberg
HRB 36809 (AG Nürnberg), Geschäftsführer: Felix Imendörffer
