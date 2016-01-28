From: Joao Pinto <Joao.Pinto@synopsys.com>
Subject: Re: [PATCH] add driver for DesignWare UFS Host Controller
Date: Thu, 28 Jan 2016 17:00:28 +0000
Message-ID: <56AA492C.80707@synopsys.com>
References: <c6de799a23c6626b95ccdcb89ba0b2341b441fa0.1450293353.git.jpinto@synopsys.com>
 <20160107094437.GA11038@infradead.org>
 <CAC5umyg=vhQ_5Nz60u8gsZFEOFP45cmXnSGny-v4ddk4qNeMHA@mail.gmail.com>
 <56969A3D.50701@synopsys.com>
 <CAC5umyjiTOzU9RCb4O-8aAHH35UWjMmE8fzWD4zUxQhwN9nUXg@mail.gmail.com>
 <5697715F.8060608@synopsys.com> <56A8F886.3010401@synopsys.com>
 <CAC5umyhHnAMqBfkPoJfZ7qhw89-0AqFQG70-XnyRzQk1Yxb=6Q@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from smtprelay4.synopsys.com ([198.182.47.9]:51527 "EHLO
	smtprelay.synopsys.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1161314AbcA1RAg (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Thu, 28 Jan 2016 12:00:36 -0500
In-Reply-To: <CAC5umyhHnAMqBfkPoJfZ7qhw89-0AqFQG70-XnyRzQk1Yxb=6Q@mail.gmail.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Akinobu Mita <akinobu.mita@gmail.com>, Joao Pinto <Joao.Pinto@synopsys.com>
Cc: Christoph Hellwig <hch@infradead.org>, Yaniv Gardi <ygardi@codeaurora.org>, Gilad Broner <gbroner@codeaurora.org>, Subhash Jadavani <subhashj@codeaurora.org>, "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>, CARLOS.PALMINHA@synopsys.com

Hi Akinobu,
Thanks for the tip!

Joao

On 1/28/2016 12:35 PM, Akinobu Mita wrote:
> Hi Joao,
> 
> 2016-01-28 2:04 GMT+09:00 Joao Pinto <Joao.Pinto@synopsys.com>:
>> - NOP_OUT is failing with OCS = 0x7
>>
>> The OCS value is calculated in ufshcd_get_tr_ocs() in ufshcd.c.
>> I made a dump of the UTRD pointer where we can check the status = 7 ([2]).
>>
>> UTRD at: 7007c3e0
>> @0000 [0]:21000000
>> @0004 [1]:93936a6a
>> @0008 [2]:00000007
>> @000c [3]:93936a6a
>> @0010 [4]:9f317400
>> @0014 [5]:00000000
>> @0018 [6]:00800080
>> @001c [7]:01006a6a
>>
>> Did anyone have the same problem? Any hints to overcome this issue?
> 
> I have seen similar problem when using UFS 2.0 controller.
> 
> The ufs driver currently doesn't set correct command type field in
> UTP transfer request descriptor (bit 31:28 in DW0) for UFS 2.0
> controller.  I checked that your DesignWare UFS driver handles it
> correctly, so please try with that change.
> 

