From: Tyrel Datwyler <turtle.in.the.kernel@gmail.com>
Subject: Re: [PATCH] ibmvscsi: add write memory barrier to CRQ processing
Date: Thu, 8 Dec 2016 18:52:34 -0800
Message-ID: <7be3f12a-3d21-9160-983b-d794c77a07ad@gmail.com>
References: <1481153486-5185-1-git-send-email-tyreld@linux.vnet.ibm.com>
 <272a1724-be64-9e5f-c5bb-3b71f389f029@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-qk0-f194.google.com ([209.85.220.194]:36489 "EHLO
        mail-qk0-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1750982AbcLICwi (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Thu, 8 Dec 2016 21:52:38 -0500
Received: by mail-qk0-f194.google.com with SMTP id h201so611131qke.3
        for <linux-scsi@vger.kernel.org>; Thu, 08 Dec 2016 18:52:38 -0800 (PST)
In-Reply-To: <272a1724-be64-9e5f-c5bb-3b71f389f029@redhat.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Paolo Bonzini <pbonzini@redhat.com>, Tyrel Datwyler <tyreld@linux.vnet.ibm.com>, james.bottomley@hansenpartnership.com
Cc: brking@linux.vnet.ibm.com, nfont@linux.vnet.ibm.com, linuxppc-dev@lists.ozlabs.org, linux-scsi@vger.kernel.org, martin.petersen@oracle.com

On 12/08/2016 03:29 PM, Paolo Bonzini wrote:
> 
> 
> On 08/12/2016 00:31, Tyrel Datwyler wrote:
>> The first byte of each CRQ entry is used to indicate whether an entry is
>> a valid response or free for the VIOS to use. After processing a
>> response the driver sets the valid byte to zero to indicate the entry is
>> now free to be reused. Add a memory barrier after this write to ensure
>> no other stores are reordered when updating the valid byte.
>>
>> Signed-off-by: Tyrel Datwyler <tyreld@linux.vnet.ibm.com>
>> ---
>>  drivers/scsi/ibmvscsi/ibmvscsi.c | 2 ++
>>  1 file changed, 2 insertions(+)
>>
>> diff --git a/drivers/scsi/ibmvscsi/ibmvscsi.c b/drivers/scsi/ibmvscsi/ibmvscsi.c
>> index d9534ee..2f5b07e 100644
>> --- a/drivers/scsi/ibmvscsi/ibmvscsi.c
>> +++ b/drivers/scsi/ibmvscsi/ibmvscsi.c
>> @@ -232,6 +232,7 @@ static void ibmvscsi_task(void *data)
>>  		while ((crq = crq_queue_next_crq(&hostdata->queue)) != NULL) {
>>  			ibmvscsi_handle_crq(crq, hostdata);
>>  			crq->valid = VIOSRP_CRQ_FREE;
>> +			wmb();
>>  		}
>>  
>>  		vio_enable_interrupts(vdev);
>> @@ -240,6 +241,7 @@ static void ibmvscsi_task(void *data)
>>  			vio_disable_interrupts(vdev);
>>  			ibmvscsi_handle_crq(crq, hostdata);
>>  			crq->valid = VIOSRP_CRQ_FREE;
>> +			wmb();
> 
> Should this driver use virt_wmb instead?

Both virt_wmb and wmb reduce to a lwsync instruction under PowerPC.

-Tyrel

> 
> Paolo
> 
>>  		} else {
>>  			done = 1;
>>  		}
>>

