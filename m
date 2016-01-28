From: Joao Pinto <Joao.Pinto@synopsys.com>
Subject: Re: [PATCH] add driver for DesignWare UFS Host Controller
Date: Thu, 28 Jan 2016 18:21:42 +0000
Message-ID: <56AA5C36.5040407@synopsys.com>
References: <c6de799a23c6626b95ccdcb89ba0b2341b441fa0.1450293353.git.jpinto@synopsys.com>
 <20160107094437.GA11038@infradead.org>
 <CAC5umyg=vhQ_5Nz60u8gsZFEOFP45cmXnSGny-v4ddk4qNeMHA@mail.gmail.com>
 <56969A3D.50701@synopsys.com>
 <CAC5umyjiTOzU9RCb4O-8aAHH35UWjMmE8fzWD4zUxQhwN9nUXg@mail.gmail.com>
 <5697715F.8060608@synopsys.com> <56A8F886.3010401@synopsys.com>
 <CAC5umyhHnAMqBfkPoJfZ7qhw89-0AqFQG70-XnyRzQk1Yxb=6Q@mail.gmail.com>
 <56AA492C.80707@synopsys.com> <56AA58E8.7010908@synopsys.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from us01smtprelay-2.synopsys.com ([198.182.60.111]:44442 "EHLO
	smtprelay.synopsys.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S964807AbcA1SVr (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Thu, 28 Jan 2016 13:21:47 -0500
In-Reply-To: <56AA58E8.7010908@synopsys.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Akinobu Mita <akinobu.mita@gmail.com>, Joao Pinto <Joao.Pinto@synopsys.com>
Cc: Christoph Hellwig <hch@infradead.org>, Yaniv Gardi <ygardi@codeaurora.org>, Gilad Broner <gbroner@codeaurora.org>, Subhash Jadavani <subhashj@codeaurora.org>, "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>, CARLOS.PALMINHA@synopsys.com

HI,

Solved it.
else if (lrbp->command_type == UTP_CMD_TYPE_DEV_MANAGE || lrbp->command_type ==
DWC_UTRD_CMD_TYPE_UFS_STORAGE)
was also needed ufshcd_transfer_req_compl(). Step by step :)

Thanks.
Joao

On 1/28/2016 6:07 PM, Joao Pinto wrote:
> Hi Akinobu,
> 
> I managed to make the following replacement:
> "lrbp->command_type = UTP_CMD_TYPE_DEV_MANAGE;" for
> "lrbp->command_type = DWC_UTRD_CMD_TYPE_UFS_STORAGE;" being
> DWC_UTRD_CMD_TYPE_UFS_STORAGE = 0x11
> 
> Now I get OCS = 0 which is good:
> @0000 [0]:11000000
> @0004 [1]:93936a6a
> @0008 [2]:00000000
> @000c [3]:93936a6a
> @0010 [4]:9f317400
> @0014 [5]:00000000
> @0018 [6]:00800080
> @001c [7]:01006a6a
> 
> But now the command is not completed time left is 0 in ufshcd_wait_for_dev_cmd()
> and even after clearing the door bell the issue is not fixed. Did you ever have
> this problem?
> 
> Joao
> 
> On 1/28/2016 5:00 PM, Joao Pinto wrote:
>> Hi Akinobu,
>> Thanks for the tip!
>>
>> Joao
>>
>> On 1/28/2016 12:35 PM, Akinobu Mita wrote:
>>> Hi Joao,
>>>
>>> 2016-01-28 2:04 GMT+09:00 Joao Pinto <Joao.Pinto@synopsys.com>:
>>>> - NOP_OUT is failing with OCS = 0x7
>>>>
>>>> The OCS value is calculated in ufshcd_get_tr_ocs() in ufshcd.c.
>>>> I made a dump of the UTRD pointer where we can check the status = 7 ([2]).
>>>>
>>>> UTRD at: 7007c3e0
>>>> @0000 [0]:21000000
>>>> @0004 [1]:93936a6a
>>>> @0008 [2]:00000007
>>>> @000c [3]:93936a6a
>>>> @0010 [4]:9f317400
>>>> @0014 [5]:00000000
>>>> @0018 [6]:00800080
>>>> @001c [7]:01006a6a
>>>>
>>>> Did anyone have the same problem? Any hints to overcome this issue?
>>>
>>> I have seen similar problem when using UFS 2.0 controller.
>>>
>>> The ufs driver currently doesn't set correct command type field in
>>> UTP transfer request descriptor (bit 31:28 in DW0) for UFS 2.0
>>> controller.  I checked that your DesignWare UFS driver handles it
>>> correctly, so please try with that change.
>>>
>>
> 

