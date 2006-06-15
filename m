From: "Randy.Dunlap" <rdunlap@xenotime.net>
Subject: Re: Kernel panic when re-inserting Adaptec PCMCIA card
Date: Thu, 15 Jun 2006 16:29:12 -0700
Message-ID: <20060615162912.744328ad.rdunlap@xenotime.net>
References: <20060614022139.21737.qmail@web50208.mail.yahoo.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from xenotime.net ([66.160.160.81]:2266 "HELO xenotime.net")
	by vger.kernel.org with SMTP id S1750764AbWFOX02 (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Thu, 15 Jun 2006 19:26:28 -0400
Received: from midway.site ([71.245.102.105]) by xenotime.net for <linux-scsi@vger.kernel.org>; Thu, 15 Jun 2006 16:26:25 -0700
In-Reply-To: <20060614022139.21737.qmail@web50208.mail.yahoo.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Alex Davis <alex14641@yahoo.com>, linux@dominikbrodowski.net
Cc: linux-scsi@vger.kernel.org, linux-pcmcia@lists.infradead.org


[changed linux-kernel to linux-pcmcia; kept linux-scsi]

On Tue, 13 Jun 2006 19:21:39 -0700 (PDT) Alex Davis wrote:
> 
> 
> --- Alex Davis <alex14641@yahoo.com> wrote:
> > 
> > The card is an Adaptec SlimSCSI 1460D Fast SCSI card.
> > I frequently get this panic when re-inserting the card:
> > 
> > Jun 13 17:53:29 siafu kernel: [4364313.475000] pccard: PCMCIA card inserted into slot 0
> > Jun 13 17:53:29 siafu kernel: [4364313.475000] pcmcia: registering new device pcmcia0.0
> > Jun 13 17:53:30 siafu kernel: [4364313.526000] aha152x: resetting bus...
> > Jun 13 17:53:30 siafu kernel: [4364313.882000] aha152x2: vital data: rev=1, io=0xd340
> > (0xd340/0xd340), irq=3, scsiid=7, reconnect=enabled, parity=enabled, synchronous=enabled,
> > delay=100, extended translation=disabled
> > Jun 13 17:53:30 siafu kernel: [4364313.882000] aha152x2: trying software interrupt, ok.
> > Jun 13 17:53:30 siafu kernel: [4364314.883000] scsi2 : Adaptec 152x SCSI driver; $Revision: 2.7
> > $
> > Jun 13 17:53:30 siafu kernel: [4364314.895000]
> > Jun 13 17:53:30 siafu kernel: [4364314.895000] aha152x0: bottom-half already running!?
> > Jun 13 17:53:30 siafu kernel: [4364314.895000]
> > Jun 13 17:53:30 siafu kernel: [4364314.895000] queue status:
> > Jun 13 17:53:30 siafu kernel: [4364314.895000] issue_SC:
> > Jun 13 17:53:30 siafu kernel: [4364314.895000] BUG: unable to handle kernel NULL pointer
> > dereference at virtual address 00000066
> > Jun 13 17:53:30 siafu kernel: [4364314.895000]  printing eip:
> > Jun 13 17:53:30 siafu kernel: [4364314.895000] e0a71e0c
> > Jun 13 17:53:30 siafu kernel: [4364314.895000] *pde = 00000000
> > Jun 13 17:53:30 siafu kernel: [4364314.895000] Oops: 0000 [#1]
> > Jun 13 17:53:30 siafu kernel: [4364314.895000] Modules linked in: ide_cd cdrom radeon drm
> [snip]
> 
> Same panic occurs in 2.6.17rc6:
> 
> Jun 13 17:50:36 siafu kernel: [4295220.230000] pccard: PCMCIA card inserted into slot 0
> Jun 13 17:50:36 siafu kernel: [4295220.230000] pcmcia: registering new device pcmcia0.0
> Jun 13 17:50:37 siafu kernel: [4295220.281000] aha152x: resetting bus...
> Jun 13 17:50:37 siafu kernel: [4295220.637000] aha152x13: vital data: rev=1, io=0xd340
> (0xd340/0xd340), irq=3, scsiid=7, reconnect=enabled,
>  parity=enabled, synchronous=enabled, delay=100, extended translation=disabled
> Jun 13 17:50:37 siafu kernel: [4295220.637000] aha152x13: trying software interrupt, ok.
> Jun 13 17:50:37 siafu kernel: [4295221.638000] scsi13 : Adaptec 152x SCSI driver; $Revision: 2.7 $
> Jun 13 17:50:37 siafu kernel: [4295221.650000]
> Jun 13 17:50:37 siafu kernel: [4295221.650000] aha152x22856: bottom-half already running!?
> Jun 13 17:50:37 siafu kernel: [4295221.650000]
> Jun 13 17:50:37 siafu kernel: [4295221.650000] queue status:
> Jun 13 17:50:37 siafu kernel: [4295221.650000] issue_SC:
> Jun 13 17:50:37 siafu kernel: [4295221.650000] current_SC:
> Jun 13 17:50:37 siafu kernel: [4295221.650000] BUG: unable to handle kernel paging request at
> virtual address 00020016
> Jun 13 17:50:37 siafu kernel: [4295221.650000]  printing eip:
> Jun 13 17:50:37 siafu kernel: [4295221.650000] e0a64e0c
> Jun 13 17:50:37 siafu kernel: [4295221.650000] *pde = 00000000
> Jun 13 17:50:37 siafu kernel: [4295221.650000] Oops: 0000 [#1]
> Jun 13 17:50:37 siafu kernel: [4295221.650000] Modules linked in: aha152x_cs ide_cd cdrom radeon
> drm scsi_transport_spi snd_pcm_oss snd_mix
> er_oss ohci_hcd usbhid intel_agp uhci_hcd generic snd_intel8x0 snd_ac97_codec snd_ac97_bus snd_pcm
> snd_timer snd soundcore snd_page_alloc 8
> 250_pci 8250 serial_core tg3 yenta_socket rsrc_nonstatic pcmcia firmware_class crc32 pcmcia_core
> nls_iso8859_1 ntfs usbkbd usbmouse agpgart
>  usb_storage sd_mod scsi_mod ehci_hcd
> Jun 13 17:50:37 siafu kernel: [4295221.650000] CPU:    0
> Jun 13 17:50:37 siafu kernel: [4295221.650000] EIP:    0060:[<e0a64e0c>]    Not tainted VLI
> Jun 13 17:50:37 siafu kernel: [4295221.650000] EFLAGS: 00010286   (2.6.17-rc6debug #1)
> Jun 13 17:50:37 siafu kernel: [4295221.650000] EIP is at show_command+0xc/0x1a0 [aha152x_cs]
> Jun 13 17:50:37 siafu kernel: [4295221.650000] eax: 00020012   ebx: 00020012   ecx: 00000000  
> edx: 00000000
> Jun 13 17:50:37 siafu kernel: [4295221.650000] esi: d77aa800   edi: 00000296   ebp: 00000000  
> esp: dff07eb4
> Jun 13 17:50:37 siafu kernel: [4295221.650000] ds: 007b   es: 007b   ss: 0068
> Jun 13 17:50:37 siafu kernel: [4295221.650000] Process events/0 (pid: 4, threadinfo=dff06000
> task=dff63a50)
> Jun 13 17:50:37 siafu kernel: [4295221.650000] Stack: 00000296 00000000 c011a947 00020012 00000000
> e0a65004 00020012 d77aa800
> Jun 13 17:50:37 siafu kernel: [4295221.650000]        d77aa800 dffa2700 e0a64c4f d77aa800 00005948
> e0a66aa7 00000286 e0a64c10
> Jun 13 17:50:37 siafu kernel: [4295221.650000]        d77aa800 e0a66aa7 c0294667 dff07f4c dff63a50
> 00000001 00000296 dffa2700
> Jun 13 17:50:37 siafu kernel: [4295221.650000] Call Trace:
> Jun 13 17:50:37 siafu kernel: [4295221.650000]  <c011a947> printk+0x17/0x20  <e0a65004>
> show_queues+0x64/0xc0 [aha152x_cs]
> Jun 13 17:50:37 siafu kernel: [4295221.650000]  <e0a64c4f> aha152x_error+0x2f/0x40 [aha152x_cs] 
> <e0a64c10> is_complete+0x280/0x290 [aha152x_cs]
> Jun 13 17:50:37 siafu kernel: [4295221.650000]  <c0294667> schedule+0x317/0x5d0  <e0a62619>
> run+0x19/0x30 [aha152x_cs]
> Jun 13 17:50:37 siafu kernel: [4295221.650000]  <c012926f> run_workqueue+0x6f/0xe0  <e0a62600>
> run+0x0/0x30 [aha152x_cs]
> Jun 13 17:50:37 siafu kernel: [4295221.650000]  <c012942b> worker_thread+0x14b/0x170  <c0116b60>
> default_wake_function+0x0/0x20
> Jun 13 17:50:37 siafu kernel: [4295221.650000]  <c0116b60> default_wake_function+0x0/0x20 
> <c01292e0> worker_thread+0x0/0x170
> Jun 13 17:50:37 siafu kernel: [4295221.650000]  <c012c7ea> kthread+0xba/0xc0  <c012c730>
> kthread+0x0/0xc0
> Jun 13 17:50:37 siafu kernel: [4295221.650000]  <c01013bd> kernel_thread_helper+0x5/0x18
> Jun 13 17:50:37 siafu kernel: [4295221.650000] Code: 6b df e9 bc fe ff ff c7 04 24 8f 6b a6 e0 e8
> 3c 5b 6b df e9 a2 fe ff ff 8d b4 26 00 00
>  00 00 53 83 ec 10 8b 5c 24 18 89 5c 24 0c <8b> 53 04 8d 82 34 01 00 00 89 44 24 08 8b 82 70 01 00
> 00 ba 09
> Jun 13 17:50:37 siafu kernel: [4295221.650000] EIP: [<e0a64e0c>] show_command+0xc/0x1a0
> [aha152x_cs] SS:ESP 0068:dff07eb4
> Jun 13 17:50:53 siafu kernel: [4295221.650000]  <3>(scsi13:0:0) cannot reuse command


So it oopses in show_command() because ISSUE_SC is NULL.
I guess that's easy enough to fix, but it was going to panic() next anyway
(in aha152x_error()).

It gets even worse for me.  Card ejection does not cause
aha152x_detach() to be called. but I don't see why not.
Dominik, can you give me a clue here, please?


[42949542.940000] pccard: PCMCIA card inserted into slot 0
[42949542.940000] cs: memory probe 0xdfc00000-0xdfcfffff: excluding 0xdfc00000-0xdfc0ffff 0xdfcf0000-0xdfcfffff
[42949542.940000] pcmcia: registering new device pcmcia0.0
[42949543.120000] aha152x: resetting bus...
[42949543.480000] aha152x2: vital data: rev=1, io=0x340 (0x340/0x340), irq=3, scsiid=7, reconnect=enabled, parity=enabled, synchronous=enabled, delay=100, extended translation=disabled
[42949543.480000] aha152x2: trying software interrupt, ok.
[42949544.480000] scsi2 : Adaptec 152x SCSI driver; $Revision: 2.7 $
[42949546.340000] pcmcia: Detected deprecated PCMCIA ioctl usage.
[42949546.340000] pcmcia: This interface will soon be removed from the kernel; please expect breakage unless you upgrade to new tools.
[42949546.340000] pcmcia: see http://www.kernel.org/pub/linux/utils/kernel/pcmcia/pcmcia.html for details.
[42949573.940000] pccard: card ejected from slot 0
[42949573.940000] pcmcia: driver aha152x_cs did not release config properly


This is followed by (just guessing) a pointer use-after-free:

[42949669.630000] Unable to handle kernel paging request at virtual address f8f0b822
[42949669.630000]  printing eip:
[42949669.630000] c01c3082
[42949669.630000] *pde = 37d0d067
[42949669.630000] *pte = 00000000
[42949669.630000] Oops: 0000 [#1]
[42949669.630000] SMP 
[42949669.630000] Modules linked in: snd_pcm_oss snd_mixer_oss snd_seq snd_seq_device pcmcia usbhid usbmouse ipw2200 ieee80211 ieee80211_crypt yenta_socket rsrc_nonstatic pcmcia_core snd_intel8x0 snd_ac97_codec snd_ac97_bus snd_pcm snd_timer snd soundcore snd_page_alloc
[42949669.630000] CPU:    0
[42949669.630000] EIP:    0060:[<c01c3082>]    Not tainted VLI
[42949669.630000] EFLAGS: 00010097   (2.6.16-rc6 #21) 
[42949669.630000] EIP is at vsnprintf+0x295/0x463
[42949669.630000] eax: f8f0b822   ebx: ffffffff   ecx: f8f0b822   edx: fffffffe
[42949669.630000] esi: f79b1086   edi: f6473f00   ebp: f6473ed0   esp: f6473ea8
[42949669.630000] ds: 007b   es: 007b   ss: 0068
[42949669.630000] Process xscreensaver (pid: 4542, threadinfo=f6472000 task=f7eb4560)
[42949669.630000] Stack: <0>009b1076 f6473edc f79b1fff 00000000 ffffffff ffffffff f6473f04 f69fc464 
[42949669.630000]        000000c0 f69fc464 f6473ef0 c0171d88 f79b1084 00000f7c c0309ba8 f6473f00 
[42949669.630000]        f6473f00 00000100 f6473f28 c0104c3d f69fc464 c0309ba5 f8f0b822 f69fc464 
[42949669.630000] Call Trace:
[42949669.630000]  [<c0103c64>] show_stack_log_lvl+0xaa/0xb5
[42949669.630000]  [<c0103dac>] show_registers+0x13d/0x1a9
[42949669.630000]  [<c01040a8>] die+0x152/0x1ca
[42949669.630000]  [<c02f4b13>] do_page_fault+0x391/0x53a
[42949669.630000]  [<c0103797>] error_code+0x4f/0x54
[42949669.630000]  [<c0171d88>] seq_printf+0x27/0x47
[42949669.630000]  [<c0104c3d>] show_interrupts+0x13e/0x295
[42949669.630000]  [<c01722c3>] seq_read+0x1a3/0x26a
[42949669.630000]  [<c015729b>] vfs_read+0x8d/0x12f
[42949669.630000]  [<c0157be1>] sys_read+0x3a/0x61
[42949669.630000]  [<c0102c17>] sysenter_past_esp+0x54/0x75
[42949669.630000] Code: 46 83 7d e8 00 7f ee 89 d7 e9 b8 01 00 00 8d 57 04 b8 0d ab 31 c0 89 55 f0 8b 55 ec 8b 0f 81 f9 ff 0f 00 00 0f 46 c8 89 c8 eb 06 <80> 38 00 74 07 40 4a 83 fa ff 75 f4 29 c8 f6 45 e4 10 89 c3 8b

and that is immediately followed by this warning:

[42949669.630000]  <3>Debug: sleeping function called from invalid context at include/linux/rwsem.h:43
[42949669.630000] in_atomic():0, irqs_disabled():1
[42949669.630000]  [<c0103e40>] show_trace+0x13/0x15
[42949669.630000]  [<c0103e58>] dump_stack+0x16/0x1a
[42949669.630000]  [<c0117945>] __might_sleep+0x85/0x8d
[42949669.630000]  [<c011eeb1>] profile_task_exit+0x15/0x46
[42949669.630000]  [<c0120149>] do_exit+0x1b/0x6c4
[42949669.630000]  [<c0104120>] do_simd_coprocessor_error+0x0/0x153
[42949669.630000]  [<c02f4b13>] do_page_fault+0x391/0x53a
[42949669.630000]  [<c0103797>] error_code+0x4f/0x54
[42949669.630000]  [<c0171d88>] seq_printf+0x27/0x47
[42949669.630000]  [<c0104c3d>] show_interrupts+0x13e/0x295
[42949669.630000]  [<c01722c3>] seq_read+0x1a3/0x26a
[42949669.630000]  [<c015729b>] vfs_read+0x8d/0x12f
[42949669.630000]  [<c0157be1>] sys_read+0x3a/0x61
[42949669.630000]  [<c0102c17>] sysenter_past_esp+0x54/0x75


---
~Randy
