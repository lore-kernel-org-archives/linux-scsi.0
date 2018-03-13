From: Arthur Marsh <arthur.marsh@internode.on.net>
Subject: Re: [PATCH] scsi: eata: drop VLA in reorder()
Date: Tue, 13 Mar 2018 11:14:52 +1030
Message-ID: <52aee09d-ba14-666b-8482-a4e7b6ef8889@internode.on.net>
References: <1520802418-17284-1-git-send-email-s.mesoraca16@gmail.com>
 <20180312030834.GC8631@eros>
 <CA+55aFww=otC4Wv40enadF+9NAyWG4Hotzjvv2EKb+_wGFui-w@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <CA+55aFww=otC4Wv40enadF+9NAyWG4Hotzjvv2EKb+_wGFui-w@mail.gmail.com>
Content-Language: en-AU
Sender: linux-kernel-owner@vger.kernel.org
To: Linus Torvalds <torvalds@linux-foundation.org>, "Tobin C. Harding" <tobin@apporbit.com>
Cc: Salvatore Mesoraca <s.mesoraca16@gmail.com>, Linux Kernel Mailing List <linux-kernel@vger.kernel.org>, Kernel Hardening <kernel-hardening@lists.openwall.com>, Linux SCSI List <linux-scsi@vger.kernel.org>, "James E.J. Bottomley" <jejb@linux.vnet.ibm.com>, "Martin K. Petersen" <martin.petersen@oracle.com>, Dario Ballabio <ballabio_dario@emc.com>, Kees Cook <keescook@chromium.org>, kernelnewbies@kernelnewbies.org
List-Id: linux-scsi@vger.kernel.org



Linus Torvalds wrote on 13/03/18 05:15:
> On Sun, Mar 11, 2018 at 8:08 PM, Tobin C. Harding <tobin@apporbit.com> wrote:
>>
>> I think we are going to see a recurring theme here.  MAX_MAILBOXES==64
>> so this patch adds 1536 bytes to the stack on a 64 bit machine or 768
>> bytes on a 32 bit machine.
> 
> Yeah, that's a bit excessive. It probably works, but one or two of
> those allocations will make the kernel stack really tight, so in
> general I really would suggest using kmalloc() instead, or figuring
> out some way to simply shrink the data structures.
> 
> That said, I wonder if the solution to this particular driver is
> "delete it". Because the hardware is truly ancient and nobody sane
> would use it any more.
> 
> The last patch that seemed to come from an actual _user_ finding a
> problem was in 2008 (commit 20c09df7eb9c: "[SCSI] eata: fix the data
> buffer accessors conversion regression"). And even then it apparently
> took a year for people to have noticed the breakage.
> 
> But because the person who reported that problem is still around, I'll
> just add him to the cc, just in case.
> 
> Arthur Marsh, you have the dubious honor and distinction of being the
> only person to have apparently used that driver in the last ten years.
> Do you still have hardware using that? Because maybe it's really time
> to retire that driver.
> 
>                     Linus
> 

Hi Linus and maintainers, thanks for the courtesy email and all the help 
with the driver.

I am unable to make use of the driver any more due to failed hardware.

The DPT2044W SCSI controller and the IBM disk from May 1998 last 
officially ran on 7 August 2017. I was had previously been able to get 
the data off it and disconnected the controller and disk following 
recurring problems with booting.

Aug  7 16:40:24 localhost kernel: [  105.098705] sd 0:0:6:0: [sda] 
Synchronizing SCSI cache
Aug  7 16:40:24 localhost kernel: [  105.233166] EATA0: IRQ 11 mapped to 
IO-APIC IRQ 18.
Aug  7 16:40:24 localhost kernel: [  105.233475] EATA/DMA 2.0x: 
Copyright (C) 1994-2003 Dario Ballabio.
Aug  7 16:40:24 localhost kernel: [  105.233485] EATA config options -> 
tm:1, lc:y, mq:16, rs:y, et:n, ip:n, ep:n, pp:y.
Aug  7 16:40:24 localhost kernel: [  105.233492] EATA0: 2.0C, PCI 
0x9010, IRQ 18, BMST, SG 122, MB 64.
Aug  7 16:40:24 localhost kernel: [  105.233499] EATA0: wide SCSI 
support enabled, max_id 16, max_lun 8.
Aug  7 16:40:24 localhost kernel: [  105.233505] EATA0: SCSI channel 0 
enabled, host target ID 7.
Aug  7 16:40:24 localhost kernel: [  105.233521] scsi host0: EATA/DMA 
2.0x rev. 8.10.00

Arthur Marsh.
