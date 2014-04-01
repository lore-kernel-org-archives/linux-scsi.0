From: Sagi Grimberg <sagig@dev.mellanox.co.il>
Subject: Re: [PATCH 1/4] target/core: T10-Dif: check HW support capabilities
Date: Tue, 01 Apr 2014 10:59:37 +0300
Message-ID: <533A71E9.90308@dev.mellanox.co.il>
References: <1396047927-14189-1-git-send-email-quinn.tran@qlogic.com>	 <1396047927-14189-2-git-send-email-quinn.tran@qlogic.com>	 <53360E54.5060004@mellanox.com>	 <504EB66DAC8D234EB8E8560985C2D7AD46CE87D7@avmb2.qlogic.org>	 <533620C0.9060903@mellanox.com>	 <504EB66DAC8D234EB8E8560985C2D7AD46CE9B32@avmb2.qlogic.org> <1396315146.22665.82.camel@haakon3.risingtidesystems.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-we0-f174.google.com ([74.125.82.174]:36740 "EHLO
	mail-we0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751098AbaDAH7k (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Tue, 1 Apr 2014 03:59:40 -0400
Received: by mail-we0-f174.google.com with SMTP id t60so5915187wes.33
        for <linux-scsi@vger.kernel.org>; Tue, 01 Apr 2014 00:59:39 -0700 (PDT)
In-Reply-To: <1396315146.22665.82.camel@haakon3.risingtidesystems.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: "Nicholas A. Bellinger" <nab@linux-iscsi.org>, Quinn Tran <quinn.tran@qlogic.com>
Cc: sagi grimberg <sagig@mellanox.com>, "target-devel@vger.kernel.org" <target-devel@vger.kernel.org>, linux-scsi <linux-scsi@vger.kernel.org>, Giridhar Malavali <giridhar.malavali@qlogic.com>, Saurav Kashyap <saurav.kashyap@qlogic.com>, Andrew Vasquez <andrew.vasquez@qlogic.com>

On 4/1/2014 4:19 AM, Nicholas A. Bellinger wrote:
> On Mon, 2014-03-31 at 17:53 +0000, Quinn Tran wrote:
>> On 3/28/14 6:24 PM, "sagi grimberg" <sagig@mellanox.com> wrote:
>>
>>> On 3/29/2014 3:53 AM, Quinn Tran wrote:
> <SNIP>
>
>>>>>> +            }
>>>>>> +    }
>>>>>> +
>>>>>>        if (lun->lun_se_dev !=  NULL) {
>>>>>>                pr_err("Port Symlink already exists\n");
>>>>>>                return -EEXIST;
>>>>>> diff --git a/drivers/target/target_core_tpg.c
>>>>>> b/drivers/target/target_core_tpg.c
>>>>>> index c036595..9279971 100644
>>>>>> --- a/drivers/target/target_core_tpg.c
>>>>>> +++ b/drivers/target/target_core_tpg.c
>>>>>> @@ -632,6 +632,15 @@ int core_tpg_set_initiator_node_tag(
>>>>>>     }
>>>>>>     EXPORT_SYMBOL(core_tpg_set_initiator_node_tag);
>>>>>>
>>>>>> +void core_tpg_set_fabric_t10dif(
>>>>>> +    struct se_portal_group *tpg,
>>>>>> +    uint32_t fabric_t10dif_force_on)
>>>>>> +{
>>>>>> +    tpg->fabric_t10dif_force_on = fabric_t10dif_force_on;
>>>>>> +}
>>>>>> +EXPORT_SYMBOL(core_tpg_set_fabric_t10dif);
>>>>>> +
>>>>> Is there a user for this function in this patch?
>>>> QT> I'm on the fence with this piece.  Just thinking of a case where DIX
>>>> is not available for initiator side, but user wants to turn on
>>>> protection
>>>> at the link layer.  Our test folks would like to cover this case in the
>>>> future.
>>> Not sure I understand. Initiator will send the target data+protection
>>> (DIX disabled HBA does INSERT), why does this help?
>>> Why should the target fabric care who generated the protection (OS or
>>> HBA)?
>> QT> Sorry for the confusion.  The case I'm trying to get at is "Data In
>> Insert" and "Data out strip".    In this case, the protection starts from
>> front end target adapter to the back end storage.  In revisit your
>> previous patch, this case is not covered.
>>
>>
> <nod>
>
> So for the TARGET_PROT_DIN_INSERT + TARGET_PROT_DOUT_STRIP cases, the
> target will need to expose INQUIRY PROTECT=1 + other PI related control
> bits when the fabric supports these modes, regardless of what PI is
> supported on the backend device.
>
> Keeping this configuration in mind as well while coding up the
> aforementioned series.  ;)

Well, I don't know if adding this support just so we can test it is good 
enough of a justification...

I originally wrote the code to support that. But it got left behind 
since I figured it is not an interesting use-case.
If your beckend doesn't support T10-PI why should the target publish it 
support it and ask the device to strip/insert it?
I suppose it is to allow the initiator to protect half-way, but I don't 
know how interesting it is if the data is not stored with protection...

The only interesting case I thought of was to allow (initiator side) 
performance tests for NULL devices. In this case you probably need
the DOUT_STRIP/DIN_INSERT. But seems to me it is debug code rather then 
production.

Sagi.
