From: Tejun Heo <tj@kernel.org>
Subject: Re: 2.6.36: Dropped interrupts in ata_piix
Date: Tue, 26 Oct 2010 11:58:43 +0200
Message-ID: <4CC6A653.4070701@kernel.org>
References: <4CC5C8C4.8010602@google.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-ide-owner@vger.kernel.org>
In-Reply-To: <4CC5C8C4.8010602@google.com>
Sender: linux-ide-owner@vger.kernel.org
To: Mike Waychison <mikew@google.com>
Cc: Linux SCSI List <linux-scsi@vger.kernel.org>, "linux-ide@vger.kernel.org" <linux-ide@vger.kernel.org>
List-Id: linux-scsi@vger.kernel.org

(cc'ing linux-ide)

Hello,

On 10/25/2010 08:13 PM, Mike Waychison wrote:
> I'm having problems reliably booting 2.6.36 on one of my development
> systems whereby it looks like the ata_piix driver isn't
> acknowledging interrupts.

Why do you think ata_piix isn't ack'ing IRQs?

> I went through a bit of the recent history here, and it seems that
> things clear up for me if I revert the following two commits in my
> tree:
> 
> 1c5afdf7 "libata-sff: separate out BMDMA init"
> c3b28894 "libata-sff: separate out BMDMA irq handler"

Those commits look scary but they're code refactoring in nature and
unless I screwed up (definitely possible) things shouldn't break over
them.  Another thing is that they have been in mainline for quite some
time and even shipped with ubuntu 10.10 and this is the first report,
so I'm a bit skeptical they actually are the culprit.

> I usually don't get a trace, but I did get this blurted out once on
> the console:
>
> kinit: Mounted root (ext2 filesystem) readonly.
> INIT: version 2.78 booting
> [    5.419165] irq 20: nobody cared (try booting with the "irqpoll" option)
> [    5.420140] Pid: 0, comm: kworker/0:1 Not tainted 2.6.36-smp-mikew #5gca29cdd
> [    5.420140] Call Trace:
> [    5.420140]  <IRQ>  [<ffffffff810b207f>] __report_bad_irq+0x3d/0x8c
> [    5.420140]  [<ffffffff810b21e6>] note_interrupt+0x118/0x17e
> [    5.420140]  [<ffffffff810b29be>] handle_fasteoi_irq+0xa7/0xcc
> [    5.420140]  [<ffffffff81032da5>] handle_irq+0x24/0x2f
> [    5.420140]  [<ffffffff81453744>] do_IRQ+0x5c/0xc3
> [    5.420140]  [<ffffffff8144d853>] ret_from_intr+0x0/0xa
> [    5.420140]  <EOI>  [<ffffffff81037a64>] ? mwait_idle+0x93/0x9b
> [    5.420140]  [<ffffffff81037a0a>] ? mwait_idle+0x39/0x9b
> [    5.420140]  [<ffffffff8102faee>] cpu_idle+0x63/0xd5
> [    5.420140]  [<ffffffff8193d340>] start_secondary+0x192/0x196
> [    5.420140] handlers:
> [    5.420140] [<ffffffff812e26e6>] (ata_bmdma_interrupt+0x0/0x17)
> [    5.420140] Disabling IRQ #20
> [   34.720103] ata1: lost interrupt (Status 0x51)
> [   34.724569] ata1.00: exception Emask 0x0 SAct 0x0 SErr 0x0 action 0x6 frozen
> [   34.731612] ata1.00: BMDMA stat 0x26, BMDMA stat 0x0, BMDMA stat 0x0, BMDMA stat 0x0, BMDMA stat 0x0
> [   34.740750] ata1.00: failed command: READ DMA
> [   34.745115] ata1.00: cmd c8/00:a0:f7:78:09/00:00:00:00:00/e0 tag 0 dma 81920 in
> [   34.745116]          res 40/00:00:00:00:00/00:00:00:00:00/00 Emask 0x24 (host bus error)

Hmm... this is interesting.  The IRQ storm happened while a read
command was in progress.  BMDMA indicates that host bus error occurred
(the DMA controller experienced transfer failure on the PCI side while
trying to write to main memory).  It's curious why the interrupt
handler thought the IRQ wasn't its.  ata_bmdma_port_intr() should have
noticed ATA_DMA_INTR and the command should have been completed
immediately, weird.

> [   34.760490] ata1.00: status: { DRDY }
> [   34.764180] ata1: soft resetting link
> [   35.143059] ata1.00: configured for UDMA/133
> [   35.147332] ata1.00: device reported invalid CHS sector 0
> [   35.152730] ata1: EH complete
> 
> As you can see above, something looks to be wrong with ata_bmdma_interrupt.
> 
> Have you seen this problem before?

No, this is the first time and your hardware seems to be developing an
interesting issue.  I suggest trying a different PSU if you have one
available.  That said, it would still be useful to track down why the
error handling isn't working as expected.  How reliably can you
reproduce the problem?

Thanks.

-- 
tejun
