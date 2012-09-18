From: Giridhar Malavali <giridhar.malavali@qlogic.com>
Subject: Re: Fail to probe qla2xxx fiber channel card while doing pci hotplug
Date: Tue, 18 Sep 2012 16:49:12 -0700
Message-ID: <CC7E5668.20296%giridhar.malavali@qlogic.com>
References: <CAErSpo7WwwB3ZO9g4WjQZKcfXAP0tKuXWKn=UTw1mDGJyX6=vQ@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Return-path: <linux-pci-owner@vger.kernel.org>
In-Reply-To: <CAErSpo7WwwB3ZO9g4WjQZKcfXAP0tKuXWKn=UTw1mDGJyX6=vQ@mail.gmail.com>
Content-Language: en-US
Sender: linux-pci-owner@vger.kernel.org
To: Bjorn Helgaas <bhelgaas@google.com>, Yijing Wang <wangyijing@huawei.com>
Cc: Andrew Vasquez <andrew.vasquez@qlogic.com>, Dept-Eng Linux Driver <Linux-Driver@qlogic.com>, "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>, PCI <linux-pci@vger.kernel.org>, Saurav Kashyap <saurav.kashyap@qlogic.com>, Chad Dupuis <chad.dupuis@qlogic.com>
List-Id: linux-scsi@vger.kernel.org



On 9/18/12 10:54 AM, "Bjorn Helgaas" <bhelgaas@google.com> wrote:

>On Mon, Sep 17, 2012 at 6:06 AM, Yijing Wang <wangyijing@huawei.com>
>wrote:
>> On 2012/9/16 11:30, Bjorn Helgaas wrote:
>>> On Sat, Sep 15, 2012 at 4:22 AM, Yijing Wang <wangyijing@huawei.com>
>>>wrote:
>>>> Hi all,
>>>>    I encountered a very strange problem when I hot plug a fiber
>>>>channel card(using qla2xxx driver).
>>>> I did the hotplug in arch x86 machine, using pciehp driver for
>>>>hotplug, this platform supports pci hot-plug triggering from both
>>>> sysfs and attention button. If a hot-plug slot is empty when system
>>>>boot-up, then hotplug FC card in this slot is ok.
>>>> If a hot-plug slot has been embeded a FC card when system boot-up,
>>>>hot-remove this card is ok, but hot-add this card will fail.
>>>> I used
>>>> #modprobe qla2xxx ql2xextended_error_logging=0x7fffffff
>>>> to get all probe info. As bellow:
>>>>
>>>> Can anyone give me any suggestion for this problem?
>>>
>>> It sounds like you did this:
>>>
>>>   1) Power down system
>>>   2) Remove FC card from slot
>>>   3) Boot system
>>>   4) Hot-add FC card
>>>   5) Load qla2xxx driver
>>>   6) qla2xxx driver claims FC card
>>>   7) FC card works correctly
>>>
>>>   8) Power down system
>>>   9) Install FC card in slot
>>>  10) Boot system
>>>  11) Load qla2xxx driver
>>>  12) qla2xxx driver claims FC card
>>>  13) FC card works correctly
>> I rmmod qla2xxx driver here and modprobe qla2xxx
>>ql2xextended_error_logging=0x1e400000 again for get errors info
>> Also I modprobe pciehp pciehp_debug=1 for getting debug info
>>>  14) Hot-remove card
>>>  15) Hot-add card
>>>  16) qla2xxx driver claims FC card
>>>  17) FC card does not work
>>>
>>> and I assume the dmesg log you included is just from steps 15 and 16
>>> (correct me if I'm wrong).
>>>
>>> It would be useful to see the entire log showing all these events so
>>> we can compare the working cases with the non-working one.  If you use
>>> the pciehp_debug module parameter, we should also see some pciehp
>>> events that would help me understand that driver.
>>>
>>
>> Hi Bjorn,
>>    Thanks for your comments very much!
>>
>> My steps:
>> 1) power down system
>> 2) Install FC card in slot
>> 3) Boot system
>> 4) Load qla2xxx driver
>> 5) qla2xxx driver claims FC card
>> 6) FC card works correctly(at least probe return ok, I don't know
>>qla2xxx driver much..)
>> 7) rmmod qla2xxx
>> 8) modprobe qla2xxx ql2xextended_error_logging=0x1e400000(for get
>>errors info)
>> 9) modprobe pciehp pciehp_debug=1
>> 10) Hot-remove card
>> 11) Hot-add card
>> 12) qla2xxx driver claims FC card fail(probe return fail, setup chip
>>fail)
>> --------------------------------------so this is failed
>>situation----------
>>
>> --------------------------------------continue to hot-add fc card into
>>empty slot(also support pci hp)
>> 13) Install FC card in empty slot
>> 14) Hot-add card
>> 15) qla2xxx driver claims FC card ok (probe return ok)
>>
>> btw:
>> If fc card firmware version 4.03, everything is ok (hot-plug in any
>>slots(empty or not))
>> fc card firmware version is 4.04 or 5.04 , situation as same as
>>1)--->12)

That's good data pointer. Let me follow up with firmware team and get back
to you. 

-- Giri
>
>Thanks.  The FW change is a good clue.  If everything works with
>version 4.03, but it doesn't work with version 4.04, it's likely to be
>a FW problem, not a Linux PCI core problem.
>
>Here's what I see from your logs.  In slot 4 (bus 08), the card was
>present before boot, you removed it, re-added it, and it failed after
>being re-added.  Slot 3 (bus 06) was empty at boot, you hot-added a
>card, and it worked.  Here are the resources available on those two
>buses and the boot-time config of the first device in slot 4:
>
>      pci 0000:00:07.0: PCI bridge to [bus 06-07]
>      pci 0000:00:07.0:   bridge window [io  0xc000-0xcfff]
>      pci 0000:00:07.0:   bridge window [mem 0xf9000000-0xf9ffffff]
>      pci 0000:00:07.0:   bridge window [mem 0xf1000000-0xf1ffffff 64bit
>pref]
>      pci 0000:00:09.0: PCI bridge to [bus 08-09]
>      pci 0000:00:09.0:   bridge window [io  0xb000-0xbfff]
>      pci 0000:00:09.0:   bridge window [mem 0xf8000000-0xf8ffffff]
>      pci 0000:00:09.0:   bridge window [mem 0xf0000000-0xf0ffffff 64bit
>pref]
>      pci 0000:08:00.0: [1077:2532] type 00 class 0x0c0400
>      pci 0000:08:00.0: reg 10: [io  0xb100-0xb1ff]
>      pci 0000:08:00.0: reg 14: [mem 0xf8084000-0xf8087fff 64bit]
>      pci 0000:08:00.0: reg 30: [mem 0xf8040000-0xf807ffff pref]
>
>After you remove and re-add the card in slot 4, it starts with
>uninitialized BARs as expected, then we assign resources to it.  It's
>sort of interesting that the BIOS had originally put the ROM (reg 30)
>in the non-prefetchable window, while after the hot-add, Linux places
>it in the prefetchable window.  Either should work, and in fact the
>card you added in slot 3 *does* work with its ROM in the prefetchable
>window.
>
>      pci 0000:08:00.0: [1077:2532] type 00 class 0x0c0400
>      pci 0000:08:00.0: reg 10: [io  0x0000-0x00ff]
>      pci 0000:08:00.0: reg 14: [mem 0x00000000-0x00003fff 64bit]
>      pci 0000:08:00.0: reg 30: [mem 0x00000000-0x0003ffff pref]
>      pci 0000:08:00.0: BAR 0: assigned [io  0xb000-0xb0ff]
>      pci 0000:08:00.0: BAR 1: assigned [mem 0xf8000000-0xf8003fff 64bit]
>      pci 0000:08:00.0: BAR 6: assigned [mem 0xf0000000-0xf003ffff pref]
>      qla2xxx [0000:08:00.0]-0098:10: Failed to load segment 0 of
>firmware.
>      qla2xxx [0000:08:00.0]-d008:10: No buffer available for dump.
>      qla2xxx [0000:08:00.0]-008f:10: Failed to load segment 0 of
>firmware.
>      qla2xxx [0000:08:00.0]-00cf:10: Setup chip ****FAILED****.
>
>When you hot-add the card in slot 3, it starts with uninitialized BARs
>as expected, but again, we assign valid resources to it:
>
>      pci 0000:06:00.0: [1077:2532] type 00 class 0x0c0400
>      pci 0000:06:00.0: reg 10: [io  0x0000-0x00ff]
>      pci 0000:06:00.0: reg 14: [mem 0x00000000-0x00003fff 64bit]
>      pci 0000:06:00.0: reg 30: [mem 0x00000000-0x0003ffff pref]
>      pci 0000:06:00.0: BAR 0: assigned [io  0xc000-0xc0ff]
>      pci 0000:06:00.0: BAR 1: assigned [mem 0xf9000000-0xf9003fff 64bit]
>      pci 0000:06:00.0: BAR 6: assigned [mem 0xf1000000-0xf103ffff pref]
>
>I don't see anything wrong from a PCI perspective.  I suspect
>something strange in the card firmware.
>
>If you do figure out something wrong in PCI, let me know.
>
>Bjorn
>
