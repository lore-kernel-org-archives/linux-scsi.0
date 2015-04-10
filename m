From: Vinson Lee <vlee@twopensource.com>
Subject: Re: Backport of a fix for HPSA (Disabling a disabled device problem
 during kdump) driver
Date: Fri, 10 Apr 2015 15:45:40 -0700
Message-ID: <CAHTgTXU1GV8JszqJojk9ML7f1yEtERHY0VjrnjX+OMh4Z_=t0g@mail.gmail.com>
References: <CANcb+4va2cYPtfTwd-Mv2X=cG5vTy=pz_wE3S+-d1-5Z9qSFoA@mail.gmail.com>
	<54AC0A17.8020405@redhat.com>
	<20150128001837.GE17677@kroah.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Return-path: <stable-owner@vger.kernel.org>
In-Reply-To: <20150128001837.GE17677@kroah.com>
Sender: stable-owner@vger.kernel.org
To: Tomas Henzl <thenzl@redhat.com>
Cc: Greg KH <greg@kroah.com>, Masoud Sharbiani <msharbiani@twopensource.com>, stable@vger.kernel.org, Don Brace <Don.Brace@pmcs.com>, JBottomley@parallels.com, linux-scsi@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org

On Tue, Jan 27, 2015 at 4:18 PM, Greg KH <greg@kroah.com> wrote:
> On Tue, Jan 06, 2015 at 05:15:19PM +0100, Tomas Henzl wrote:
>> On 01/05/2015 07:41 PM, Masoud Sharbiani wrote:
>> > Dear stable maintainers,
>> > Can you please backport commitid 132aa220b45d60e9b20def1e9d8be9422eed9616
>> >  (hpsa: refine the pci enable/disable handling) to 3.10 stable (and
>> > earlier, if applicable)?
>>
>> Please do not apply this patch isolated from his friend, the
>> 859c75aba20264d87dd026bab0d0ca3bff385955 hpsa: add missing pci_set_master in kdump path
>> needs to be applied together with the 132aa220b45d60e9b20def1e9d8be9422eed9616 .
>>
>> In addition to that, after the original issue goes away you may notice sometimes
>> an unhandled irq 16 message, to fix this a patch is posted
>> here http://www.spinics.net/lists/linux-scsi/msg80316.html
>> This patch still awaits a maintainers review though.
>>
>> Probably the best idea is to wait until the issue is solved completely.
>
> I'll wait, when it all gets worked out, please let stable@ know what
> patches to apply where.
>
> thanks,
>
> greg k-h
> --
> To unsubscribe from this list: send the line "unsubscribe stable" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html


Hi, Thomas.

The unhandled irq 16 issue seems to be fixed by 4.0-rc1 commit "hpsa:
turn off interrupts when kdump starts".

Are the following patches suitable for stable now?

3b74729 hpsa: turn off interrupts when kdump starts
03741d9 hpsa: fix memory leak in kdump hard reset
859c75a hpsa: add missing pci_set_master in kdump path
132aa22 hpsa: refine the pci enable/disable handling

Cheers,
Vinson
