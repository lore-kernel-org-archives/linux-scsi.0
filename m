From: Frank de Jong <frapex@xs4all.nl>
Subject: Re: PROBLEM: linux-2.6.25.3, aha152x'->init suspiciously
  returned 1, it should follow 0/-E convention
Date: Sat, 10 May 2008 19:58:39 +0200
Message-ID: <20080510175840.0E2D11D27F4D@mx.drokz.nl>
References: <20080510103040.C7E891D652BF@mx.drokz.nl>
 <1210426438.4002.1.camel@localhost.localdomain>
 <7.1.0.9.2.20080510194439.025745e0@xs4all.nl>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"; format=flowed
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from drokz.nl ([80.101.76.176]:50075 "EHLO mx.drokz.nl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752865AbYEJR7A (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Sat, 10 May 2008 13:59:00 -0400
In-Reply-To: <7.1.0.9.2.20080510194439.025745e0@xs4all.nl>
References: <20080510103040.C7E891D652BF@mx.drokz.nl>
 <1210426438.4002.1.camel@localhost.localdomain>
 <7.1.0.9.2.20080510194439.025745e0@xs4all.nl>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James Bottomley <James.Bottomley@HansenPartnership.com>
Cc: linux-scsi@vger.kernel.org, Juergen Fischer <fischer@norbit.de>

Hi James,

Small correction:
"....does not exist with linux-2.4.24....." should be "....does not 
exist with linux-2.6.24.....".

Regards,
Frank de Jong
The Netherlands

At 19:54 10-5-2008, Frank de Jong wrote:
>To: James Bottomley <James.Bottomley@HansenPartnership.com>
>From: Frank de Jong <frapex@xs4all.nl>
>Subject: Re: PROBLEM: linux-2.6.25.3, aha152x'->init suspiciously 
>returned 1, it should follow 0/-E convention
>Cc: linux-scsi@vger.kernel.org, Juergen Fischer <fischer@norbit.de>
>In-Reply-To: <1210426438.4002.1.camel@localhost.localdomain>
>References: <20080510103040.C7E891D652BF@mx.drokz.nl> 
><1210426438.4002.1.camel@localhost.localdomain>
>
>Hello James,
>
>Thank you for your quick solution. I implemented the solution and 
>the driver loads fine. Unloading the module gives me a kernel Oops.
>dmesg after loading the module:
>
>aha152x: BIOS test: passed, 1 controller(s) configured
>aha152x: resetting bus...
>aha152x2: vital data: rev=1, io=0x340 (0x340/0x340), irq=9, 
>scsiid=7, reconnect=enabled, parity=enabled, synchronous=enabled, 
>delay=1000, extended translation=disabled
>aha152x2: trying software interrupt, ok.
>scsi2 : Adaptec 152x SCSI driver; $Revision: 2.7 $
>(scsi2:6:0) message sent incompletely (2/6)
>(scsi2:6:0) Synchronous Data Transfer Request was rejected
>(scsi2:6:0) inbound message (MESSAGE REJECT)
>scsi 2:0:6:0: Direct-Access     IOMEGA   ZIP 100          J.02 PQ: 0 ANSI: 2
>sd 2:0:6:0: [sde] Attached SCSI removable disk
>sd 2:0:6:0: Attached scsi generic sg4 type 0
>
>after trying to unload the module:
>BUG: unable to handle kernel paging request at 00100100
>IP: [<fb9ff667>] :aha152x:aha152x_exit+0x47/0x6a
>*pde = 00000000
>Oops: 0000 [#1] PREEMPT SMP
>Modules linked in: aha152x(-) w83781d hwmon_vid tun ne 8390 bonding 
>usb_storage snd_usb_audio snd_usb_lib snd_rawmidi pwc snd_seq_device 
>compat_ioctl32 snd_hwdep videodev v4l1_compat 3c59x mii intel_agp 
>agpgart snd_pcm_oss snd_pcm snd_timer snd_page_alloc snd_mixer_oss snd
>
>Pid: 2837, comm: rmmod Not tainted (2.6.25.3 #1)
>EIP: 0060:[<fb9ff667>] EFLAGS: 00210212 CPU: 0
>EIP is at aha152x_exit+0x47/0x6a [aha152x]
>EAX: 00000001 EBX: 000ffdc4 ECX: f7c517a8 EDX: 00000001
>ESI: 00000000 EDI: 00000003 EBP: e7880000 ESP: e7881f58
>  DS: 007b ES: 007b FS: 00d8 GS: 0033 SS: 0068
>Process rmmod (pid: 2837, ti=e7880000 task=f27eb580 task.ti=e7880000)
>Stack: fba03700 c01419d2 31616861 00783235 e795ee70 c0157709 b7f24000 e79ae000
>        c0158271 ffffffff b7f25000 e79ae004 e795e370 b7f25000 
> e795e37c e795e370
>        009ae000 fba03700 00000880 e7881fa8 00000000 bf93ec20 
> bf93ec20 c0102faa
>Call Trace:
>  [<c01419d2>] sys_delete_module+0x112/0x1a0
>  [<c0157709>] remove_vma+0x39/0x50
>  [<c0158271>] do_munmap+0x181/0x1f0
>  [<c0102faa>] sysenter_past_esp+0x5f/0x85
>  [<c0490000>] rsc_parse+0x0/0x3c0
>  =======================
>Code: fb 08 36 a0 fb 74 36 8d b6 00 00 00 00 8d bc 27 00 00 00 00 8d 
>83 88 fd ff ff e8 a5 b2 ff ff 8b 9b 3c 03 00 00 81 eb 3c 03 00 00 
><8b> 83 3c 03 00 00 0f 1f 40 00 81 fb cc 32 a0 fb 75 d7 5b c3 0f
>EIP: [<fb9ff667>] aha152x_exit+0x47/0x6a [aha152x] SS:ESP 0068:e7881f58
>---[ end trace 97ac3c588c837e59 ]---
>
>Apparantly the driver still needs some fixing to support module 
>unloading. I can NOT confirm that this problem does not exist with 
>linux-2.4.24, as this is pretty much the first time I tried to 
>unload the driver.
>
>The "aha152x'->init suspiciously returned 1, it should follow 0/-E 
>convention" problem is solved though.
>
>Regards,
>Frank de Jong
>The Netherlands
>
>At 15:33 10-5-2008, you wrote:
>
>>On Sat, 2008-05-10 at 12:30 +0200, Frank de Jong wrote:
>> > Hello,
>> >
>> > Bug report follows.
>> >
>> > [1.] One line summary of the problem:
>> > linux-2.6.25.3, aha152x'->init suspiciously returned 1, it should
>> > follow 0/-E convention. The module / driver works okay. Unloading the
>> > module is impossible.
>>
>>The driver is apparently returning 0 on failure and 1 on success.
>>That's a bit unfortunate.  This should fix it.
>>
>>James
>>
>>---
>>
>>diff --git a/drivers/scsi/aha152x.c b/drivers/scsi/aha152x.c
>>index f5215fd..f0c4ffc 100644
>>--- a/drivers/scsi/aha152x.c
>>+++ b/drivers/scsi/aha152x.c
>>@@ -3830,7 +3830,7 @@ static int __init aha152x_init(void)
>>                         iounmap(p);
>>                 }
>>                 if (!ok && setup_count == 0)
>>-                       return 0;
>>+                       return -ENODEV;
>>
>>                 printk(KERN_INFO "aha152x: BIOS test: passed, ");
>>  #else
>>@@ -3909,7 +3909,7 @@ static int __init aha152x_init(void)
>>  #endif
>>         }
>>
>>-       return 1;
>>+       return 0;
>>  }
>>
>>  static void __exit aha152x_exit(void)

