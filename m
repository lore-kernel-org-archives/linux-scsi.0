From: Mike Waychison <mikew@google.com>
Subject: Re: 2.6.36: Dropped interrupts in ata_piix
Date: Tue, 26 Oct 2010 19:33:57 -0700
Message-ID: <4CC78F95.4050107@google.com>
References: <4CC5C8C4.8010602@google.com> <4CC6A653.4070701@kernel.org> <4CC7190A.8080500@google.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-ide-owner@vger.kernel.org>
In-Reply-To: <4CC7190A.8080500@google.com>
Sender: linux-ide-owner@vger.kernel.org
To: Tejun Heo <tj@kernel.org>
Cc: Linux SCSI List <linux-scsi@vger.kernel.org>, "linux-ide@vger.kernel.org" <linux-ide@vger.kernel.org>
List-Id: linux-scsi@vger.kernel.org

Mike Waychison wrote:
> Tejun Heo wrote:
>> (cc'ing linux-ide)
>>
>> Hello,
>>
>> On 10/25/2010 08:13 PM, Mike Waychison wrote:
>>> I'm having problems reliably booting 2.6.36 on one of my development
>>> systems whereby it looks like the ata_piix driver isn't
>>> acknowledging interrupts.
>>
>> Why do you think ata_piix isn't ack'ing IRQs?
> 
> Well, it's the only thing in the logs marked up as using IRQ 20.
> 
>>
>>> I went through a bit of the recent history here, and it seems that
>>> things clear up for me if I revert the following two commits in my
>>> tree:
>>>
>>> 1c5afdf7 "libata-sff: separate out BMDMA init"
>>> c3b28894 "libata-sff: separate out BMDMA irq handler"
>>
>> Those commits look scary but they're code refactoring in nature and
>> unless I screwed up (definitely possible) things shouldn't break over
>> them.  Another thing is that they have been in mainline for quite some
>> time and even shipped with ubuntu 10.10 and this is the first report,
>> so I'm a bit skeptical they actually are the culprit.
> 
> Ya, I don't see how they change anything either, but I can't pretend to 
> really understand what is going on in this code either :(
> 
>>
>>> I usually don't get a trace, but I did get this blurted out once on
>>> the console:
>>>
>>> kinit: Mounted root (ext2 filesystem) readonly.
>>> INIT: version 2.78 booting
>>> [    5.419165] irq 20: nobody cared (try booting with the "irqpoll" 
>>> option)
>>> [    5.420140] Pid: 0, comm: kworker/0:1 Not tainted 2.6.36-smp-mikew 
>>> #5gca29cdd
>>> [    5.420140] Call Trace:
>>> [    5.420140]  <IRQ>  [<ffffffff810b207f>] __report_bad_irq+0x3d/0x8c
>>> [    5.420140]  [<ffffffff810b21e6>] note_interrupt+0x118/0x17e
>>> [    5.420140]  [<ffffffff810b29be>] handle_fasteoi_irq+0xa7/0xcc
>>> [    5.420140]  [<ffffffff81032da5>] handle_irq+0x24/0x2f
>>> [    5.420140]  [<ffffffff81453744>] do_IRQ+0x5c/0xc3
>>> [    5.420140]  [<ffffffff8144d853>] ret_from_intr+0x0/0xa
>>> [    5.420140]  <EOI>  [<ffffffff81037a64>] ? mwait_idle+0x93/0x9b
>>> [    5.420140]  [<ffffffff81037a0a>] ? mwait_idle+0x39/0x9b
>>> [    5.420140]  [<ffffffff8102faee>] cpu_idle+0x63/0xd5
>>> [    5.420140]  [<ffffffff8193d340>] start_secondary+0x192/0x196
>>> [    5.420140] handlers:
>>> [    5.420140] [<ffffffff812e26e6>] (ata_bmdma_interrupt+0x0/0x17)
>>> [    5.420140] Disabling IRQ #20
>>> [   34.720103] ata1: lost interrupt (Status 0x51)
>>> [   34.724569] ata1.00: exception Emask 0x0 SAct 0x0 SErr 0x0 action 
>>> 0x6 frozen
>>> [   34.731612] ata1.00: BMDMA stat 0x26, BMDMA stat 0x0, BMDMA stat 
>>> 0x0, BMDMA stat 0x0, BMDMA stat 0x0
>>> [   34.740750] ata1.00: failed command: READ DMA
>>> [   34.745115] ata1.00: cmd c8/00:a0:f7:78:09/00:00:00:00:00/e0 tag 0 
>>> dma 81920 in
>>> [   34.745116]          res 40/00:00:00:00:00/00:00:00:00:00/00 Emask 
>>> 0x24 (host bus error)
>>
>> Hmm... this is interesting.  The IRQ storm happened while a read
>> command was in progress.  BMDMA indicates that host bus error occurred
>> (the DMA controller experienced transfer failure on the PCI side while
>> trying to write to main memory).  It's curious why the interrupt
>> handler thought the IRQ wasn't its.  ata_bmdma_port_intr() should have
>> noticed ATA_DMA_INTR and the command should have been completed
>> immediately, weird.
> 
> To be clear, usually all I see on the console when hanging is:
> 
> [   15.411337] Disabling IRQ #20
> 
> I've only ever had the above call trace make it out to console once.
> 
> Sometimes this happens while mounting the root filesystem, mounting the 
> second filesystem (on the same disk) or while loading modules.  I don't 
> think the failure is tied to any particular sector.
> 
> I don't have any trouble with previous kernels (2.6.34 was fine), and 
> backing out the above two commits makes the symptom go away.
> 
>>
>>> [   34.760490] ata1.00: status: { DRDY }
>>> [   34.764180] ata1: soft resetting link
>>> [   35.143059] ata1.00: configured for UDMA/133
>>> [   35.147332] ata1.00: device reported invalid CHS sector 0
>>> [   35.152730] ata1: EH complete
>>>
>>> As you can see above, something looks to be wrong with 
>>> ata_bmdma_interrupt.
>>>
>>> Have you seen this problem before?
>>
>> No, this is the first time and your hardware seems to be developing an
>> interesting issue.  I suggest trying a different PSU if you have one
>> available.  That said, it would still be useful to track down why the
>> error handling isn't working as expected.  How reliably can you
>> reproduce the problem?
> 
> 
> I can reproduce very reliably on this machine in particular.  I have 
> other machines of similar type that seem to be fine (though I need to 
> dig into the test result database to be sure).  I'd be happy to try any 
> suggestions on this machine.


FWIW, with those two commits reverted, things seem usable, though I just 
noticed these in my logs.  As far as I can tell, the error handling is 
working in this case, while with v2.6.36 it doesn't.



Oct 26 19:14:28 lpw36 kernel: [   42.858479] ata1.00: exception Emask 
0x0 SAct 0x0 SErr 0x0 action 0x6
Oct 26 19:14:28 lpw36 kernel: [   42.858483] ata1.00: BMDMA stat 0x26
Oct 26 19:14:28 lpw36 kernel: [   42.858487] ata1.00: failed command: 
READ DMA
Oct 26 19:14:28 lpw36 kernel: [   42.858493] ata1.00: cmd 
c8/00:60:d3:9c:55/00:00:00:00:00/e5 tag 0 dma 49152 in
Oct 26 19:14:28 lpw36 kernel: [   42.858495]          res 
51/84:60:d3:9c:55/84:00:00:00:00/e5 Emask 0x30 (host bus error)
Oct 26 19:14:28 lpw36 kernel: [   42.858498] ata1.00: status: { DRDY ERR }
Oct 26 19:14:28 lpw36 kernel: [   42.858500] ata1.00: error: { ICRC ABRT }
Oct 26 19:14:28 lpw36 kernel: [   42.858512] ata1: soft resetting link
Oct 26 19:14:28 lpw36 kernel: [   43.134269] ata1.00: configured for 
UDMA/133
Oct 26 19:14:28 lpw36 kernel: [   43.134286] ata1: EH complete


Oct 26 19:14:35 lpw36 kernel: [   50.123746] ata1.00: limiting speed to 
UDMA/100:PIO4
Oct 26 19:14:35 lpw36 kernel: [   50.123751] ata1.00: exception Emask 
0x0 SAct 0x0 SErr 0x0 action 0x6
Oct 26 19:14:35 lpw36 kernel: [   50.123754] ata1.00: BMDMA stat 0x26
Oct 26 19:14:35 lpw36 kernel: [   50.123757] ata1.00: failed command: 
READ DMA
Oct 26 19:14:35 lpw36 kernel: [   50.123763] ata1.00: cmd 
c8/00:a0:47:96:14/00:00:00:00:00/e0 tag 0 dma 81920 in
Oct 26 19:14:35 lpw36 kernel: [   50.123764]          res 
51/84:a0:47:96:14/84:00:00:00:00/e0 Emask 0x30 (host bus error)
Oct 26 19:14:35 lpw36 kernel: [   50.123767] ata1.00: status: { DRDY ERR }
Oct 26 19:14:35 lpw36 kernel: [   50.123768] ata1.00: error: { ICRC ABRT }
Oct 26 19:14:35 lpw36 kernel: [   50.123784] ata1: soft resetting link
Oct 26 19:14:36 lpw36 kernel: [   50.391355] ata1.00: configured for 
UDMA/100
Oct 26 19:14:36 lpw36 kernel: [   50.391364] ata1: EH complete
Oct 26 19:14:41 lpw36 kernel: [   55.600153] ata1.00: exception Emask 
0x0 SAct 0x0 SErr 0x0 action 0x6
Oct 26 19:14:41 lpw36 kernel: [   55.600156] ata1.00: BMDMA stat 0x26
Oct 26 19:14:41 lpw36 kernel: [   55.600160] ata1.00: failed command: 
READ DMA
Oct 26 19:14:41 lpw36 kernel: [   55.600165] ata1.00: cmd 
c8/00:60:ff:88:10/00:00:00:00:00/e0 tag 0 dma 49152 in
Oct 26 19:14:41 lpw36 kernel: [   55.600167]          res 
51/84:60:ff:88:10/00:00:00:00:00/e0 Emask 0x30 (host bus error)
Oct 26 19:14:41 lpw36 kernel: [   55.600169] ata1.00: status: { DRDY ERR }
Oct 26 19:14:41 lpw36 kernel: [   55.600171] ata1.00: error: { ICRC ABRT }
Oct 26 19:14:41 lpw36 kernel: [   55.600187] ata1: soft resetting link
Oct 26 19:14:41 lpw36 kernel: [   55.867655] ata1.00: configured for 
UDMA/100
Oct 26 19:14:41 lpw36 kernel: [   55.867668] ata1: EH complete
Oct 26 19:14:45 lpw36 kernel: [   59.808362] ata1.00: exception Emask 
0x0 SAct 0x0 SErr 0x0 action 0x6
Oct 26 19:14:45 lpw36 kernel: [   59.808365] ata1.00: BMDMA stat 0x26
Oct 26 19:14:45 lpw36 kernel: [   59.808369] ata1.00: failed command: 
READ DMA
Oct 26 19:14:45 lpw36 kernel: [   59.808376] ata1.00: cmd 
c8/00:00:5f:90:1c/00:00:00:00:00/e0 tag 0 dma 131072 in
Oct 26 19:14:45 lpw36 kernel: [   59.808377]          res 
51/84:00:5f:90:1c/00:00:00:00:00/e0 Emask 0x30 (host bus error)
Oct 26 19:14:45 lpw36 kernel: [   59.808380] ata1.00: status: { DRDY ERR }
Oct 26 19:14:45 lpw36 kernel: [   59.808382] ata1.00: error: { ICRC ABRT }
Oct 26 19:14:45 lpw36 kernel: [   59.808395] ata1: soft resetting link
Oct 26 19:14:45 lpw36 kernel: [   60.084257] ata1.00: configured for 
UDMA/100
Oct 26 19:14:45 lpw36 kernel: [   60.084270] ata1: EH complete
Oct 26 19:14:53 lpw36 kernel: [   67.423809] ata1.00: exception Emask 
0x0 SAct 0x0 SErr 0x0 action 0x6
Oct 26 19:14:53 lpw36 kernel: [   67.423813] ata1.00: BMDMA stat 0x26
Oct 26 19:14:53 lpw36 kernel: [   67.423818] ata1.00: failed command: 
READ DMA
Oct 26 19:14:53 lpw36 kernel: [   67.423824] ata1.00: cmd 
c8/00:60:cf:50:1c/00:00:00:00:00/e0 tag 0 dma 49152 in
Oct 26 19:14:53 lpw36 kernel: [   67.423825]          res 
51/84:60:cf:50:1c/00:00:00:00:00/e0 Emask 0x30 (host bus error)
Oct 26 19:14:53 lpw36 kernel: [   67.423828] ata1.00: status: { DRDY ERR }
Oct 26 19:14:53 lpw36 kernel: [   67.423831] ata1.00: error: { ICRC ABRT }
Oct 26 19:14:53 lpw36 kernel: [   67.423843] ata1: soft resetting link
Oct 26 19:14:53 lpw36 kernel: [   67.691312] ata1.00: configured for 
UDMA/100
Oct 26 19:14:53 lpw36 kernel: [   67.691329] ata1: EH complete
Oct 26 19:14:58 lpw36 kernel: [   73.017686] ata1.00: limiting speed to 
UDMA/33:PIO4
Oct 26 19:14:58 lpw36 kernel: [   73.017692] ata1.00: exception Emask 
0x0 SAct 0x0 SErr 0x0 action 0x6
Oct 26 19:14:58 lpw36 kernel: [   73.017694] ata1.00: BMDMA stat 0x26
Oct 26 19:14:58 lpw36 kernel: [   73.017698] ata1.00: failed command: 
READ DMA
Oct 26 19:14:58 lpw36 kernel: [   73.017705] ata1.00: cmd 
c8/00:08:bf:e8:05/00:00:00:00:00/e0 tag 0 dma 4096 in
Oct 26 19:14:58 lpw36 kernel: [   73.017706]          res 
51/84:00:c6:e8:05/00:00:00:00:00/e0 Emask 0x30 (host bus error)
Oct 26 19:14:58 lpw36 kernel: [   73.017709] ata1.00: status: { DRDY ERR }
Oct 26 19:14:58 lpw36 kernel: [   73.017711] ata1.00: error: { ICRC ABRT }
Oct 26 19:14:58 lpw36 kernel: [   73.017734] ata1: soft resetting link
Oct 26 19:14:59 lpw36 kernel: [   73.285426] ata1.00: configured for UDMA/33
Oct 26 19:14:59 lpw36 kernel: [   73.285447] ata1: EH complete
Oct 26 19:15:00 lpw36 kernel: [   74.535362] ata1.00: exception Emask 
0x0 SAct 0x0 SErr 0x0 action 0x6
Oct 26 19:15:00 lpw36 kernel: [   74.535366] ata1.00: BMDMA stat 0x26
Oct 26 19:15:00 lpw36 kernel: [   74.535370] ata1.00: failed command: 
READ DMA
Oct 26 19:15:00 lpw36 kernel: [   74.535376] ata1.00: cmd 
c8/00:00:97:53:0f/00:00:00:00:00/e0 tag 0 dma 131072 in
Oct 26 19:15:00 lpw36 kernel: [   74.535378]          res 
51/84:00:97:53:0f/00:00:00:00:00/e0 Emask 0x30 (host bus error)
Oct 26 19:15:00 lpw36 kernel: [   74.535381] ata1.00: status: { DRDY ERR }
Oct 26 19:15:00 lpw36 kernel: [   74.535383] ata1.00: error: { ICRC ABRT }
Oct 26 19:15:00 lpw36 kernel: [   74.535395] ata1: soft resetting link
Oct 26 19:15:00 lpw36 kernel: [   74.803082] ata1.00: configured for UDMA/33
Oct 26 19:15:00 lpw36 kernel: [   74.803099] ata1: EH complete
Oct 26 19:15:02 lpw36 kernel: [   76.177935] ata1.00: exception Emask 
0x0 SAct 0x0 SErr 0x0 action 0x6
Oct 26 19:15:02 lpw36 kernel: [   76.177940] ata1.00: BMDMA stat 0x26
Oct 26 19:15:02 lpw36 kernel: [   76.177944] ata1.00: failed command: 
READ DMA
Oct 26 19:15:02 lpw36 kernel: [   76.177950] ata1.00: cmd 
c8/00:00:7f:39:11/00:00:00:00:00/e0 tag 0 dma 131072 in
Oct 26 19:15:02 lpw36 kernel: [   76.177952]          res 
51/84:00:7f:39:11/00:00:00:00:00/e0 Emask 0x30 (host bus error)
Oct 26 19:15:02 lpw36 kernel: [   76.177955] ata1.00: status: { DRDY ERR }
Oct 26 19:15:02 lpw36 kernel: [   76.177957] ata1.00: error: { ICRC ABRT }
Oct 26 19:15:02 lpw36 kernel: [   76.177969] ata1: soft resetting link
Oct 26 19:15:02 lpw36 kernel: [   76.453953] ata1.00: configured for UDMA/33
Oct 26 19:15:02 lpw36 kernel: [   76.453970] ata1: EH complete
Oct 26 19:15:04 lpw36 kernel: [   78.453813] ata1.00: exception Emask 
0x0 SAct 0x0 SErr 0x0 action 0x6
Oct 26 19:15:04 lpw36 kernel: [   78.453817] ata1.00: BMDMA stat 0x26
Oct 26 19:15:04 lpw36 kernel: [   78.453821] ata1.00: failed command: 
READ DMA
Oct 26 19:15:04 lpw36 kernel: [   78.453827] ata1.00: cmd 
c8/00:00:8f:0d:09/00:00:00:00:00/e0 tag 0 dma 131072 in
Oct 26 19:15:04 lpw36 kernel: [   78.453828]          res 
51/84:00:8f:0d:09/00:00:00:00:00/e0 Emask 0x30 (host bus error)
Oct 26 19:15:04 lpw36 kernel: [   78.453831] ata1.00: status: { DRDY ERR }
Oct 26 19:15:04 lpw36 kernel: [   78.453833] ata1.00: error: { ICRC ABRT }
Oct 26 19:15:04 lpw36 kernel: [   78.453844] ata1: soft resetting link
Oct 26 19:15:04 lpw36 kernel: [   78.721461] ata1.00: configured for UDMA/33
Oct 26 19:15:04 lpw36 kernel: [   78.721473] ata1: EH complete



