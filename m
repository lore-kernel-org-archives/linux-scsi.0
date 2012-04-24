From: edwin_rong <edwin_rong@realsil.com.cn>
Subject: Re: Is it possible for Realtek card reader driver to resideinSCSIsubsystem?
Date: Tue, 24 Apr 2012 09:10:06 +0800
Message-ID: <4F95FD6E.1010204@realsil.com.cn>
References: <4F94D132.7070109@realsil.com.cn> <1335166767.3051.4.camel@dabdike.lan> <4F950C0B.10804@realsil.com.cn> <1335168679.3051.9.camel@dabdike.lan> <4F9511D1.2030003@realsil.com.cn> <20120423154810.GC23990@kroah.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="GB2312"
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from rtits2.realtek.com ([60.250.210.242]:35274 "EHLO
	rtits2.realtek.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754018Ab2DXBKU (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Mon, 23 Apr 2012 21:10:20 -0400
In-Reply-To: <20120423154810.GC23990@kroah.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Greg KH <greg@kroah.com>
Cc: James Bottomley <James.Bottomley@HansenPartnership.com>, "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>, =?GB2312?B?zfXsvw==?= <wei_wang@realsil.com.cn>

On 04/23/2012 11:48 PM, Greg KH wrote:
> On Mon, Apr 23, 2012 at 04:24:49PM +0800, edwin_rong wrote:
>> On 04/23/2012 04:11 PM, James Bottomley wrote:
>>> [updated Greg to non-SUSE address]
>>> On Mon, 2012-04-23 at 16:00 +0800, edwin_rong wrote:
>>>> On 04/23/2012 03:39 PM, James Bottomley wrote:
>>>>> On Mon, 2012-04-23 at 11:49 +0800, edwin_rong wrote:
>>>>>> Dear James and all :
>>>>>>
>>>>>> Sorry to disturb you again!
>>>>>>
>>>>>> I'm an software engineer of Realtek corporation, responsible for writing
>>>>>> driver for Realtek Card Reader chips.
>>>>>>
>>>>>> Our device supports SD/MMC/MS/MSpro/xD series of cards, etc., which is
>>>>>> implemented as an SCSI device in our driver,
>>>>>> and now our driver rts_pstor is under staging folder of linux kernel, so
>>>>>> I want to know whether it is possible to move it out of staging folder,
>>>>>> and reside in SCSI subsystem?
>>>>>>
>>>>>> I also know that both "mmc" and "memstick" subsystem exist in kernel
>>>>>> now, but our device is a composition of these types of cards,
>>>>>> so it seems not suitable for keeping our driver there.
>>>>>>
>>>>>> All replies are appreciated.
>>>>> The general rule is that if the device itself speaks SCSI ... as in
>>>>> either the firmware or the underlying disk does, then you should be
>>>>> using SCSI (This doesn't mean you have to have an actual SCSI device
>>>>> anywhere ... lots of USB devices are some wierd flash or IDE device
>>>>> fronted by a chip that does SCSI<->whatever translation [usually
>>>>> badly]).  Conversely if you would be writing your SCSI command emulation
>>>>> in the driver, don't ... you should be using another subsystem.
>>>>>
>>>>> James
>>>>>
>>>> Dear James,
>>>>
>>>> Got it, thanks for your response, sincerely.
>>>>
>>>> As to my case, which subsystem do you think is fit for our driver to
>>>> stay, could you give me some suggestions?
>>> Well, you said it's a combination of mmc and memstick.  If it can be
>>> bound as two separate drivers, I'd say one in each.  If there's magic
>>> that has to be done in the binding (as in you need a single bind driver
>>> that activates each component), I'd say be guided by the maintainers of
>>> those components.  My instinct would be to put it in one and use the
>>> other via Kconfig, but whatever they find most appropriate.
>>>
>>> James
>>>
>>>
>> Gotcha!
>>
>> Thanks for your suggestion, James.
> Also, at the least, you have a lot of basic coding style issues to clean
> up in the drivers/staging/rts_pstor/ directory before your code can move
> out of there.  Please start working on that as soon as possible.
>
> thanks,
>
> greg k-h
Dear Greg,

Yes, it is.
Now we're working on the refactor of Realtek card reader driver to make
it support
all Realtek driver-based chips with USB or PCIe inferface, that is to
say, making all Realtek card reader driver in one,
and it will substitute currently existing "rts_pstro" and "rts5139"
under driver/staging directory in the future.

Thanks
Edwin




