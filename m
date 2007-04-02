From: "Duane Cox" <dcox@conxxus.com>
Subject: RE: [PATCH] aacraid: Panics during init time reset (Was: [PATCH] aacraid: [Fastboot] Panics for AACRAID driver during 'insmod' for kexec test)
Date: Mon, 2 Apr 2007 15:04:54 -0500
Message-ID: <6B78FD05EF2B0C46AB4CBE68D7923A3B0AB4A8@mantle.conxxus.com>
References: <20070402194358.GE2364@shell0.pdx.osdl.net> <AE4F746F2AECFC4DA4AADD66A1DFEF017AA143@otce2k301.adaptec.com> <6B78FD05EF2B0C46AB4CBE68D7923A3B0AB4A7@mantle.conxxus.com>
Mime-Version: 1.0
Content-Type: text/plain;
	charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from conxxus-gw.pxtnil.ntwk.conxxus.net ([63.252.228.142]:63377 "EHLO
	exchange.conxxus.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S2992716AbXDDILl convert rfc822-to-8bit (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Wed, 4 Apr 2007 04:11:41 -0400
In-Reply-To: <6B78FD05EF2B0C46AB4CBE68D7923A3B0AB4A7@mantle.conxxus.com>
Content-class: urn:content-classes:message
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Duane Cox <dcox@conxxus.com>, "Salyzyn, Mark" <mark_salyzyn@adaptec.com>, Judith Lebzelter <judith@linux-foundation.org>
Cc: James Bottomley <James.Bottomley@SteelEye.com>, linux-scsi@vger.kernel.org

By bad... 'interrpt' typo

-----Original Message-----
From: Duane Cox 
Sent: Monday, April 02, 2007 3:04 PM
To: 'Salyzyn, Mark'; Judith Lebzelter
Cc: James Bottomley; linux-scsi@vger.kernel.org
Subject: RE: [PATCH] aacraid: Panics during init time reset (Was:
[PATCH] aacraid: [Fastboot] Panics for AACRAID driver during 'insmod'
for kexec test)

Attempted to compile 2.6.20.3 kernel results in...

   CC      drivers/scsi/aacraid/rx.o
drivers/scsi/aacraid/rx.c: In function '_aac_rx_init':
drivers/scsi/aacraid/rx.c:869: error: 'aac_rx_disable_interrpt'
undeclared (first use in this function)
drivers/scsi/aacraid/rx.c:869: error: (Each undeclared identifier is
reported only once
drivers/scsi/aacraid/rx.c:869: error: for each function it appears in.)
make[3]: *** [drivers/scsi/aacraid/rx.o] Error 1
make[2]: *** [drivers/scsi/aacraid] Error 2
make[1]: *** [drivers/scsi] Error 2
make: *** [drivers] Error 2

-----Original Message-----
From: Salyzyn, Mark [mailto:mark_salyzyn@adaptec.com]
Sent: Monday, April 02, 2007 2:57 PM
To: Judith Lebzelter
Cc: James Bottomley; linux-scsi@vger.kernel.org; Duane Cox
Subject: RE: [PATCH] aacraid: Panics during init time reset (Was:
[PATCH] aacraid: [Fastboot] Panics for AACRAID driver during 'insmod'
for kexec test)

Judith, another layer on this onion also discovered by Duane, the
interrupt enable handler also needed to be set ... The interrupt enable
was called from within the synchronous command handler.

My private email with the fix was sent a whole 5 minutes ahead of yours
;-> Here is the jist of it for the observers:

    /* Failure to reset here is an option ... */
    dev->a_ops.adapter_sync_cmd = rx_sync_cmd;
+   dev->a_ops.adapter_enable_int = aac_rx_disable_interrupt;
    dev->OIMR = status = rx_readb (dev, MUnit.OIMR);

Yes, the disable interrupt method patched into the enable int platform
function. Later init code will reset it accordingly.

Sincerely -- Mark Salyzyn


> -----Original Message-----
> From: Judith Lebzelter [mailto:judith@linux-foundation.org]
> Sent: Monday, April 02, 2007 3:44 PM
> To: Salyzyn, Mark
> Cc: Judith Lebzelter; James Bottomley; linux-scsi@vger.kernel.org; 
> Duane Cox
> Subject: Re: [PATCH] aacraid: Panics during init time reset
> (Was: [PATCH] aacraid: [Fastboot] Panics for AACRAID driver during 
> 'insmod' for kexec test)
> 
> 
> On Mon, Apr 02, 2007 at 02:34:36PM -0400, Salyzyn, Mark wrote:
> > Duane discovered in the scsi-misc-2.6 code that the reset
> handler could
> > be called without the sync command handler set up resulting
> in a panic.
> > Judith discovered this issue within minutes and has
> recently reported
> > it. Here is a fix.
> 
> Mark,
> 
> I applied this patch and ran a kexec test again and I still got a
> panic:
> 
> Loading aacraid.Adaptec aacraid driver (1.1-5[2437]-mh4)^M ko module^M
> ACPI: PCI Interrupt 0000:03:0e.0[A] -> Link [LNKC] -> GSI 3 (level,
> low) -> IRQ 3^M Unable to handle kernel NULL pointer dereference at 
> 0000000000000000 RIP: ^M  [<0000000000000000>]^M PGD 4791067 PUD
> 473c067 PMD 0 ^M
> Oops: 0010 [1] ^M
> CPU 0 ^M
> Modules linked in: aacraid^M
> Pid: 977, comm: insmod Not tainted 2.6.21-rc3-kdump #1^M
> RIP: 0010:[<0000000000000000>]  [<0000000000000000>]^M
> RSP: 0000:ffff81000474dbf0  EFLAGS: 00010246^M
> RAX: ffffc20000010000 RBX: ffff810004fe4cd8 RCX: 000000005b540e96^M
> RDX: ffffc20000010000 RSI: ffff81000443cf40 RDI: ffff810004fe4cd8^M
> RBP: 00000000fffee138 R08: ffffffff81001c20 R09: ffffffff8143593e^M
> R10: ffff810004c537a0 R11: 0000000000000000 R12: ffff81000474dc7c^M
> R13: 0000000000000000 R14: 0000000000000000 R15: 0000000000000000^M
> FS:  000000000057b850(0063) GS:ffffffff814d6000(0000) 
> knlGS:0000000000000000^M
> CS:  0010 DS: 0000 ES: 0000 CR0: 000000008005003b^M
> CR2: 0000000000000000 CR3: 0000000004745000 CR4: 00000000000006e0^M 
> Process insmod (pid: 977, threadinfo ffff81000474c000, task 
> ffff81000443cf40)^M
> Stack:  ffffffff88008e82 00003e00fc1f0000 0000000000000000 
> ffff810004fe4cd8^M  ffff810004fe4800 0000000000000000 ffffffff8800a6dd

> 0000000000000032^M  ffffffff88008c3b 0000000000000000 ffffffff00000000

> ffff81000474dc7c^M Call Trace:^M  [<ffffffff88008e82>] 
> :aacraid:rx_sync_cmd+0x15c/0x16a^M
>  [<ffffffff88008c3b>] :aacraid:aac_rx_restart_adapter+0x7e/0x169^M
>  [<ffffffff88009121>] :aacraid:_aac_rx_init+0x7b/0x2fc^M
>  [<ffffffff88002b1f>] :aacraid:aac_probe_one+0x1a2/0x457^M
>  [<ffffffff8112be3d>] pci_device_probe+0x4c/0x75^M 
> [<ffffffff8117d41e>] really_probe+0xc4/0x148^M  [<ffffffff8117d64f>] 
> __driver_attach+0x6d/0xab^M  [<ffffffff8117d5e2>] 
> __driver_attach+0x0/0xab^M  [<ffffffff8117d5e2>] 
> __driver_attach+0x0/0xab^M  [<ffffffff8117c8f6>] 
> bus_for_each_dev+0x43/0x6e^M  [<ffffffff8117cc38>] 
> bus_add_driver+0x6b/0x18d^M  [<ffffffff8112bfdb>] 
> __pci_register_driver+0x72/0xa7^M  [<ffffffff8801203a>] 
> :aacraid:aac_init+0x3a/0x75^M  [<ffffffff8103bbcc>] 
> sys_init_module+0x1195/0x12e6^M  [<ffffffff8100913e>] 
> system_call+0x7e/0x83^M ^M ^M
> Code:  Bad RIP value.^M
> RIP  [<0000000000000000>]^M
>  RSP <ffff81000474dbf0>^M
> CR2: 0000000000000000^M
> 
> There is an extra line in the call trace for the 'rx_sync_cmd'.
> 
> Judith
> 
> > 
> > IMHO, this needs to be applied immediately regardless of
> the status of
> > the kexec patch as this issue is present in the
> scsi-misc-2.6 driver for
> > all existing init-time recovery actions. This patch in
> principal would
> > not be different w/o the kexec patch.
> > 
> > ObligatoryDisclaimer: Please accept my condolences
> regarding Outlook's
> > handling of patches.
> > 
> > This attached patch is against current scsi-misc-2.6
> >  
> > Signed-off-by: Mark Salyzyn <aacraid@adaptec.com>
> > 
> > ---
> > 
> > Sincerely -- Mark Salyzyn
> 
> 
> 
