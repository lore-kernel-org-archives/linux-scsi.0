From: Libo Chen <clbchenlibo.chen@huawei.com>
Subject: Re: [PATCH RESEND] scsi: megaraid: check kzalloc
Date: Thu, 30 May 2013 10:32:59 +0800
Message-ID: <51A6BA5B.4090008@huawei.com>
References: <519ECEF1.9060804@huawei.com> <519F3592.4090207@huawei.com> <51A618A4.2000302@redhat.com> <51A6AD92.2030903@huawei.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="ISO-8859-1"
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from szxga01-in.huawei.com ([119.145.14.64]:15584 "EHLO
	szxga01-in.huawei.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S965859Ab3E3Cdb (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Wed, 29 May 2013 22:33:31 -0400
In-Reply-To: <51A6AD92.2030903@huawei.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Tomas Henzl <thenzl@redhat.com>
Cc: megaraidlinux@lsi.com, JBottomley@parallels.com, linux-scsi@vger.kernel.org, LKML <linux-kernel@vger.kernel.org>, kashyap.desai@lsi.com, aradford@gmail.com, Li Zefan <lizefan@huawei.com>, Santosh Y <santoshsy@gmail.com>

On 2013/5/30 9:38, Libo Chen wrote:
> On 2013/5/29 23:03, Tomas Henzl wrote:
>> On 05/24/2013 11:40 AM, Libo Chen wrote:
>>> we should check kzalloc, avoid to hit oops
>>>
>>> Signed-off-by: Libo Chen <libo.chen@huawei.com>
>>> ---
>>>  drivers/scsi/megaraid.c |    4 ++++
>>>  1 files changed, 4 insertions(+), 0 deletions(-)
>>>
>>> instead of checking scmd->device, sdev is more appropriate.
>>>
>>> diff --git a/drivers/scsi/megaraid.c b/drivers/scsi/megaraid.c
>>> index 846f475..6b623cb 100644
>>> --- a/drivers/scsi/megaraid.c
>>> +++ b/drivers/scsi/megaraid.c
>>> @@ -4161,6 +4161,10 @@ mega_internal_command(adapter_t *adapter, megacmd_t *mc, mega_passthru *pthru)
>>>  	memset(scb, 0, sizeof(scb_t));
>>>
>>>  	sdev = kzalloc(sizeof(struct scsi_device), GFP_KERNEL);
>>> +	if (sdev) {
>>> +		scsi_free_command(GFP_KERNEL, scmd);
>>
>> I think, that a mutex_unlock(&adapter->int_mtx); is also needed
>> Maybe just setting a rval = -ENOMEM and a jump to to some point below?
>>
>> tomash
> 
> thanks for catching this.
> 
> when kzalloc broken, fist unlock and then return.  I will update later.
> 

I think we can put kzalloc outside of mutex_lock(&adapter->int_mtx) ?
phase:

   mutex_lock	   kzalloc
   kzalloc     ->  mutex_lock
   	

> 
> Libo
> 
>>
>>> +		return -ENOMEM;
>>> +	}
>>>  	scmd->device = sdev;
>>>
>>>  	memset(adapter->int_cdb, 0, sizeof(adapter->int_cdb));
>>
>>
>> .
>>
> 


