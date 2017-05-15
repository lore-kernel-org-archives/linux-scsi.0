From: James Smart <jsmart2021@gmail.com>
Subject: Re: [PATCH 10/15] lpfc: Fix NVME I+T not registering NVME as a
 supported FC4 type
Date: Mon, 15 May 2017 14:57:47 -0700
Message-ID: <036bd64d-3971-f494-7b05-87bac5c1f26a@gmail.com>
References: <20170510190713.30171-1-jsmart2021@gmail.com>
 <20170510190713.30171-11-jsmart2021@gmail.com>
 <5adc07ff-c925-b59f-2cb3-b5758856303c@suse.de>
Reply-To: jsmart2021@gmail.com
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-wm0-f65.google.com ([74.125.82.65]:34341 "EHLO
        mail-wm0-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751278AbdEOV55 (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Mon, 15 May 2017 17:57:57 -0400
Received: by mail-wm0-f65.google.com with SMTP id d127so32064359wmf.1
        for <linux-scsi@vger.kernel.org>; Mon, 15 May 2017 14:57:51 -0700 (PDT)
In-Reply-To: <5adc07ff-c925-b59f-2cb3-b5758856303c@suse.de>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Hannes Reinecke <hare@suse.de>, linux-scsi@vger.kernel.org, linux-nvme@lists.infradead.org
Cc: Dick Kennedy <dick.kennedy@broadcom.com>, James Smart <james.smart@broadcom.com>

On 5/11/2017 12:35 AM, Hannes Reinecke wrote:
> On 05/10/2017 09:07 PM, James Smart wrote:
>> When the driver send the RPA command, it does not
>> send supported FC4 Type NVME to the management server.
>>
>> Encode NVME (type x28) in the AttribEntry in the
>> RPA command.
>>
>> Signed-off-by: Dick Kennedy <dick.kennedy@broadcom.com>
>> Signed-off-by: James Smart <james.smart@broadcom.com>
>> ---
>>  drivers/scsi/lpfc/lpfc_ct.c | 1 +
>>  1 file changed, 1 insertion(+)
>>
>> diff --git a/drivers/scsi/lpfc/lpfc_ct.c b/drivers/scsi/lpfc/lpfc_ct.c
>> index c7962dae4dab..f2cd19c6c2df 100644
>> --- a/drivers/scsi/lpfc/lpfc_ct.c
>> +++ b/drivers/scsi/lpfc/lpfc_ct.c
>> @@ -2092,6 +2092,7 @@ lpfc_fdmi_port_attr_fc4type(struct lpfc_vport *vport,
>>
>>  	ae->un.AttrTypes[3] = 0x02; /* Type 1 - ELS */
>>  	ae->un.AttrTypes[2] = 0x01; /* Type 8 - FCP */
>> +	ae->un.AttrTypes[6] = 0x01; /* Type 40 - NVME */
>>  	ae->un.AttrTypes[7] = 0x01; /* Type 32 - CT */
>>  	size = FOURBYTES + 32;
>>  	ad->AttrLen = cpu_to_be16(size);
>>
> Are you sure about the 'Type 40' ?
> I was under the impression that FC-4 Types is a bitmask of available
> types, so if bit6 really refer to Type 40, how can bit7 refer to
> type 32 ?

The code is actually correct.

Here's what's happening:
The RPA payload contains a bitmask with a bit per type bit.  In their 
infinite wisdom, FC decided that the bitmask was actually an array of 
32-bit words, with bits set within the words. But, as FC is a wire 
endianness of BE, it means the bytestream on the wire is W0B3, W0B2, 
W0B1, W0B0, W1B3, W1B2, W1B1, W1B0, and so on.  Ugly...  Because of this 
weird byte order due to BE words, FCP type, which is a lower bit number 
than ELS type, is actually in a higher byte. Same goes for NVME (0x28) 
vs CT (0x20).

I agree, it's really hard to follow this convolution. For now, please 
accept the change. I've assigned a task on our end to refactor the code 
so its understandable, and as it's common code, add the implementation 
to the general fc framework.

-- james
