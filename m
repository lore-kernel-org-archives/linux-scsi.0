From: Mike Waychison <mikew@google.com>
Subject: 2.6.36: Dropped interrupts in ata_piix
Date: Mon, 25 Oct 2010 11:13:24 -0700
Message-ID: <4CC5C8C4.8010602@google.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from smtp-out.google.com ([74.125.121.35]:42103 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759267Ab0JYSNa (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Mon, 25 Oct 2010 14:13:30 -0400
Received: from wpaz24.hot.corp.google.com (wpaz24.hot.corp.google.com [172.24.198.88])
	by smtp-out.google.com with ESMTP id o9PIDS3Z022734
	for <linux-scsi@vger.kernel.org>; Mon, 25 Oct 2010 11:13:29 -0700
Received: from iwn1 (iwn1.prod.google.com [10.241.68.65])
	by wpaz24.hot.corp.google.com with ESMTP id o9PICl9H024419
	for <linux-scsi@vger.kernel.org>; Mon, 25 Oct 2010 11:13:27 -0700
Received: by iwn1 with SMTP id 1so5806829iwn.37
        for <linux-scsi@vger.kernel.org>; Mon, 25 Oct 2010 11:13:27 -0700 (PDT)
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Tejun Heo <tj@kernel.org>
Cc: Linux SCSI List <linux-scsi@vger.kernel.org>

Hi Tejun,

I'm having problems reliably booting 2.6.36 on one of my development 
systems whereby it looks like the ata_piix driver isn't acknowledging 
interrupts.  I went through a bit of the recent history here, and it 
seems that things clear up for me if I revert the following two commits 
in my tree:

1c5afdf7 "libata-sff: separate out BMDMA init"
c3b28894 "libata-sff: separate out BMDMA irq handler"

I usually don't get a trace, but I did get this blurted out once on the 
console:


kinit: Mounted root (ext2 filesystem) readonly.
INIT: version 2.78 booting
[    5.419165] irq 20: nobody cared (try booting with the "irqpoll" option)
[    5.420140] Pid: 0, comm: kworker/0:1 Not tainted 2.6.36-smp-mikew 
#5gca29cdd
[    5.420140] Call Trace:
[    5.420140]  <IRQ>  [<ffffffff810b207f>] __report_bad_irq+0x3d/0x8c
[    5.420140]  [<ffffffff810b21e6>] note_interrupt+0x118/0x17e
[    5.420140]  [<ffffffff810b29be>] handle_fasteoi_irq+0xa7/0xcc
[    5.420140]  [<ffffffff81032da5>] handle_irq+0x24/0x2f
[    5.420140]  [<ffffffff81453744>] do_IRQ+0x5c/0xc3
[    5.420140]  [<ffffffff8144d853>] ret_from_intr+0x0/0xa
[    5.420140]  <EOI>  [<ffffffff81037a64>] ? mwait_idle+0x93/0x9b
[    5.420140]  [<ffffffff81037a0a>] ? mwait_idle+0x39/0x9b
[    5.420140]  [<ffffffff8102faee>] cpu_idle+0x63/0xd5
[    5.420140]  [<ffffffff8193d340>] start_secondary+0x192/0x196
[    5.420140] handlers:
[    5.420140] [<ffffffff812e26e6>] (ata_bmdma_interrupt+0x0/0x17)
[    5.420140] Disabling IRQ #20
[   34.720103] ata1: lost interrupt (Status 0x51)
[   34.724569] ata1.00: exception Emask 0x0 SAct 0x0 SErr 0x0 action 0x6 
frozen
[   34.731612] ata1.00: BMDMA stat 0x26, BMDMA stat 0x0, BMDMA stat 0x0, 
BMDMA stat 0x0, BMDMA stat 0x0
[   34.740750] ata1.00: failed command: READ DMA
[   34.745115] ata1.00: cmd c8/00:a0:f7:78:09/00:00:00:00:00/e0 tag 0 
dma 81920 in
[   34.745116]          res 40/00:00:00:00:00/00:00:00:00:00/00 Emask 
0x24 (host bus error)
[   34.760490] ata1.00: status: { DRDY }
[   34.764180] ata1: soft resetting link
[   35.143059] ata1.00: configured for UDMA/133
[   35.147332] ata1.00: device reported invalid CHS sector 0
[   35.152730] ata1: EH complete

As you can see above, something looks to be wrong with ata_bmdma_interrupt.

Have you seen this problem before?

Thanks,

Mike Waychison
