From: Tomas Henzl <thenzl@redhat.com>
Subject: Re: Backport of a fix for HPSA (Disabling a disabled device problem
 during kdump) driver
Date: Mon, 27 Apr 2015 14:17:32 +0200
Message-ID: <553E28DC.1040100@redhat.com>
References: <CANcb+4va2cYPtfTwd-Mv2X=cG5vTy=pz_wE3S+-d1-5Z9qSFoA@mail.gmail.com> <54AC0A17.8020405@redhat.com> <20150128001837.GE17677@kroah.com> <CAHTgTXU1GV8JszqJojk9ML7f1yEtERHY0VjrnjX+OMh4Z_=t0g@mail.gmail.com> <552BC234.4020000@redhat.com> <20150426092719.GA1460@kroah.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:36567 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932673AbbD0MRn (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Mon, 27 Apr 2015 08:17:43 -0400
In-Reply-To: <20150426092719.GA1460@kroah.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Greg KH <greg@kroah.com>
Cc: Vinson Lee <vlee@twopensource.com>, Masoud Sharbiani <msharbiani@twopensource.com>, stable@vger.kernel.org, Don Brace <Don.Brace@pmcs.com>, JBottomley@parallels.com, linux-scsi@vger.kernel.org

On 04/26/2015 11:27 AM, Greg KH wrote:
> On Mon, Apr 13, 2015 at 03:18:44PM +0200, Tomas Henzl wrote:
>> On 04/11/2015 12:45 AM, Vinson Lee wrote:
>>> On Tue, Jan 27, 2015 at 4:18 PM, Greg KH <greg@kroah.com> wrote:
>>>> On Tue, Jan 06, 2015 at 05:15:19PM +0100, Tomas Henzl wrote:
>>>>> On 01/05/2015 07:41 PM, Masoud Sharbiani wrote:
>>>>>> Dear stable maintainers,
>>>>>> Can you please backport commitid 132aa220b45d60e9b20def1e9d8be9422eed9616
>>>>>>  (hpsa: refine the pci enable/disable handling) to 3.10 stable (and
>>>>>> earlier, if applicable)?
>>>>> Please do not apply this patch isolated from his friend, the
>>>>> 859c75aba20264d87dd026bab0d0ca3bff385955 hpsa: add missing pci_set_master in kdump path
>>>>> needs to be applied together with the 132aa220b45d60e9b20def1e9d8be9422eed9616 .
>>>>>
>>>>> In addition to that, after the original issue goes away you may notice sometimes
>>>>> an unhandled irq 16 message, to fix this a patch is posted
>>>>> here http://www.spinics.net/lists/linux-scsi/msg80316.html
>>>>> This patch still awaits a maintainers review though.
>>>>>
>>>>> Probably the best idea is to wait until the issue is solved completely.
>>>> I'll wait, when it all gets worked out, please let stable@ know what
>>>> patches to apply where.
>>>>
>>>> thanks,
>>>>
>>>> greg k-h
>>>> --
>>>> To unsubscribe from this list: send the line "unsubscribe stable" in
>>>> the body of a message to majordomo@vger.kernel.org
>>>> More majordomo info at  http://vger.kernel.org/majordomo-info.html
>>> Hi, Thomas.
>>>
>>> The unhandled irq 16 issue seems to be fixed by 4.0-rc1 commit "hpsa:
>>> turn off interrupts when kdump starts".
>>>
>>> Are the following patches suitable for stable now?
>> Yes, I believe they are, just note that 
>> 03741d9 hpsa: fix memory leak in kdump hard reset
>> is not a part of that group we discussed before, but it may be added
>> to stable too.
>>
>> Cheers,
>> Tomas
>>
>>> 3b74729 hpsa: turn off interrupts when kdump starts
>>> 03741d9 hpsa: fix memory leak in kdump hard reset
>>> 859c75a hpsa: add missing pci_set_master in kdump path
>>> 132aa22 hpsa: refine the pci enable/disable handling
> So what order, and to what stable tree(s) do you want these applied to?
> They seem to span a number of kernel versions, so I'm not quite sure
> what you are wanting me to do.

Please add it in this order
1. 132aa220b4 hpsa: refine the pci enable/disable handling
2. 859c75aba2 hpsa: add missing pci_set_master in kdump path
   The first two patches create the fix Masoud has asked for originally to port to stable.
3. 3b74729878 hpsa: turn off interrupts when kdump starts
   The third should be added too, it fixes an issue made visible by the first patch

The fourth patch
03741d956e hpsa: fix memory leak in kdump hard reset
is completely unrelated to the first group, so it may be added after or before
or in the same sequence as it is in the mainline - that is before the third patch.
This patch is tiny error path fix - not sure if important enough for stable.

Regards,
Tomas


>
> thanks,
>
> greg k-h

