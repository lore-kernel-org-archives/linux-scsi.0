From: Finn Thain <fthain@telegraphics.com.au>
Subject: Re: [PATCH] m68k link error and NCR5380_exit()
Date: Tue, 8 Mar 2005 00:45:28 +1100 (EST)
Message-ID: <Pine.LNX.4.61.0503072333310.27126@loopy.telegraphics.com.au>
References: <Pine.LNX.4.61.0502121539440.20941@loopy.telegraphics.com.au>
 <20050212075645.GA30669@pants.nu> <Pine.LNX.4.61.0502122135230.21876@loopy.telegraphics.com.au>
 <20050213040948.GA10198@orchestra.cs.caltech.edu>
 <Pine.LNX.4.61.0502131618470.25204@loopy.telegraphics.com.au>
 <20050213063225.GA17415@orchestra.cs.caltech.edu>
 <Pine.LNX.4.61.0502131736300.25553@loopy.telegraphics.com.au>
 <20050213075506.GA18622@orchestra.cs.caltech.edu>
 <Pine.LNX.4.61.0502212233290.15372@loopy.telegraphics.com.au>
 <Pine.LNX.4.61.0503071612290.27126@loopy.telegraphics.com.au>
 <20050307063719.GA12478@infradead.org>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Received: from loopy.telegraphics.com.au ([202.45.126.152]:46802 "EHLO
	loopy.telegraphics.com.au") by vger.kernel.org with ESMTP
	id S261164AbVCGNpl (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Mon, 7 Mar 2005 08:45:41 -0500
In-Reply-To: <20050307063719.GA12478@infradead.org>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Christoph Hellwig <hch@infradead.org>
Cc: James.Bottomley@SteelEye.com, linux scsi <linux-scsi@vger.kernel.org>, Geert Uytterhoeven <geert@linux-m68k.org>, Noah Misch <noah@cs.caltech.edu>, linux m68k <linux-m68k@vger.kernel.org>



On Mon, 7 Mar 2005, Christoph Hellwig wrote:

> >  	.detect				= macscsi_detect,
> > -	.release			= macscsi_release,
> > +	.release			= __exit_p(macscsi_release),
> 
> Please get rid of your ->detect/->release useage instead.  Allocate the 
> host struct directly with scsi_host_alloc and add it when setup using 
> scsi_add_host/scsi_scan_host in your init routine and call 
> scsi_remove_host/ scsi_host_put in the module exit routine.

Fair enough, I just noticed that scsi_module.c is deprecated. My patch is 
flogging a dead horse.

I guess that those who require the legacy NCR5380 drivers (being 
mac_scsi.c, dtc.c, t128.c, pas16.c and g_NCR5380.c) can use CONFIG_HOTPLUG 
to avoid the problem.

> see qla1280.c for an example that does this for the 2.6 case and to ease 
> your porting also has the 2.4 code ifdefed so you have the direct 
> comparism.

Having qla1280.c as a guide will help, thanks. My next question is, what 
does a NuBus architecture do in place of pci_(un)register_driver?

My main reservation about embarking on this is that I don't think mac_scsi 
ever actually worked under 2.6 (or 2.5?) kernels. I'm not competent enough 
to submit a good, untested patch for a broken driver. Maybe the best thing 
is to make it work before worrying about style. At least then I can test 
my work.

To that end, I've included a boot log below. Maybe someone familiar with 
the NCR5380 driver can make some sense of the failure?

-f


Linux version 2.6.10-m68k (fthain@nippy) (gcc version 3.4.3) #6 Fri Mar 11 09:10:02 EST 2005
Detected Macintosh model: 27
 Penguin bootinfo data:
 Video: addr 0x60b00000 row 0x280 depth 8 dimensions 640 x 480
 Videological 0xf0300000 phys. 0x60b00000, SCC at 0x50f04000
 Boottime: 0xe7bb738f GMTBias: 0x0
 Machine ID: 27 CPUid: 0x1 memory size: 0x8
VIA1 at 50f00000 is a 6522 or clone
VIA2 at 50f26000 is an RBV
Apple Macintosh LC III
On node 0 totalpages: 2048
  DMA zone: 2048 pages, LIFO batch:1
  Normal zone: 0 pages, LIFO batch:1
  HighMem zone: 0 pages, LIFO batch:1
Built 1 zonelists
Kernel command line: ro root=/dev/sdb4 init=/boot.sh debug debug=ser console=tty0
Killing onboard sonic... Done.
PID hash table entries: 64 (order: 6, 1024 bytes)
Console: colour dummy device 80x25
Dentry cache hash table entries: 2048 (order: 1, 8192 bytes)
Inode-cache hash table entries: 1024 (order: 0, 4096 bytes)
Memory: 5452k/8192k available (2028k kernel code, 568k data, 120k init)
Calibrating delay loop... 6.11 BogoMIPS (lpj=30592)
Mount-cache hash table entries: 512 (order: 0, 4096 bytes)
NET: Registered protocol family 16
NuBus: Scanning NuBus slots.
SCSI subsystem initialized
audit: initializing netlink socket (disabled)
audit(0.860:0): initialized
macfb: framebuffer at 0x60b00000, mapped to 0xd0000000, size 300k
macfb: mode is 640x480x8, linelength=640
macfb: scrolling: redraw
fbcon_startup: No VBL detected, using timer based cursor.
mac_delete_irq: tried to remove invalid irq
Console: switching to colour frame buffer device 80x30
fb0: Macintosh Sonora built-in frame buffer device
io scheduler noop registered
io scheduler anticipatory registered
RAMDISK driver initialized: 16 RAM disks of 4096K size 1024 blocksize
loop: loaded (max 8 devices)
Uniform Multi-Platform E-IDE driver Revision: 7.00alpha2
ide: Assuming 50MHz system bus speed for PIO modes; override with
idebus=xx
Macintosh SCSI: resetting the SCSI bus...<6> done
scsi0: generic 5380 at port 50F10000 irq<6> 19<6> options CAN_QUEUE=16 CMD_PER_LUN=2 release=2<6>
scsi0: generic options AUTOSENSE PSEUDO DMA USLEEP, USLEEP_POLL=20 USLEEP_SLEEP=2 generic release=7
scsi0 :
elevator: using anticipatory as default io scheduler
blk_queue_max_hw_segments: set to minimum 1
  Vendor: QUANTUM   Model: CTS80S            Rev: 4.2
  Type:   Direct-Access                      ANSI SCSI revision: 02
blk_queue_max_hw_segments: set to minimum 1
blk_queue_max_hw_segments: set to minimum 1
blk_queue_max_hw_segments: set to minimum 1
blk_queue_max_hw_segments: set to minimum 1
blk_queue_max_hw_segments: set to minimum 1
  Vendor: CONNER    Model: CP30540  SUN0535  Rev: B0CD
  Type:   Direct-Access                      ANSI SCSI revision: 02
blk_queue_max_hw_segments: set to minimum 1
SCSI device sda: 166200 512-byte hdwr sectors (85 MB)
scsi0 : aborting command
scsi0 : destination target 0, lun 0
        command = Mode Sense 00 08 00 20 00

NCR5380 core release=7.
Base Addr: 0x00000    io_port: 50f10000      IRQ: 19.
scsi0 : destination target 0, lun 0
        command = 26 (0x1a)00 08 00 20 00
scsi0: issue_queue
scsi0: disconnected_queue

scsi0 : aborting command
scsi0 : destination target 0, lun 0
        command = Mode Sense 00 08 00 20 00

NCR5380 core release=7.
Base Addr: 0x00000    io_port: 50f10000      IRQ: 19.
scsi0 : destination target 0, lun 0
        command = 26 (0x1a)00 08 00 20 00
scsi0: issue_queue
scsi0: disconnected_queue


NCR5380 core release=7.
Base Addr: 0x00000    io_port: 50f10000      IRQ: 19.
scsi0 : destination target 0, lun 0
        command = 26 (0x1a)00 08 00 20 00
scsi0: issue_queue
scsi0: disconnected_queue

Data read fault at 0x667a26b9 in Super Data (pc=0x149b6a)
BAD KERNEL BUSERR
Oops: 00000000
Modules linked in:
PC: [<00149b6a>] macscsi_intr+0x1a/0x74

SR: 2700  SP: 003c1e4c  a2: 0031c420
d0: 00002000    d1: 00000000    d2: 00002000    d3: 00000000
d4: 00000001    d5: 00000013    a0: 667a2669    a1: 50f26000
Process scsi_eh_0 (pid: 11, stackpage=0031d420)
Stack from 003c1e4c:
        00000000 00002000 00000000 00000001 00000013 667a2669 50f26000 0031c420
        00002000 ffffffff 00000000 27000014 9b6ab008 1eec0755 120049c1 667a26b9
        667a26b9 00002000 10280050 00149b72 00149b70 00149b6e 667a26ff 00500064
        000ff487 00000001 50f00000 00003c18 00000000 80080000 667a26b9 00000000
        00000040 00149b66 00002200 00000013 00000013 00000013 00242164 003c1f4c
        00007d30 00000013 00149b50 003c1f4c 00002008 00000008 00001c13 003bdc90
Call Trace: [<00008f00>] via2_irq+0x6e/0x96
 [<00002000>] _start+0x0/0x8
 [<00141372>] __scsi_iterate_devices+0x0/0x5e
 [<00001000>] _stext+0x0/0x1000
 [<00003d90>] process_int+0x4c/0x62
 [<000024a0>] inthandler+0x2a/0x2c
 [<0001a36f>] sys_sched_rr_get_interval+0xb/0xa6
 [<00002000>] _start+0x0/0x8
 [<00141372>] __scsi_iterate_devices+0x0/0x5e
 [<00001000>] _stext+0x0/0x1000
 [<00007780>] parse_booter+0x188/0x58a
 [<0014aa12>] macscsi_bus_reset+0x1a/0x26
 [<00143a4e>] scsi_try_bus_reset+0x44/0xb2
 [<001442fc>] scsi_error_handler+0x77c/0x844
 [<00186ad0>] tcp_write_timer+0x6a/0x5f2
 [<00001000>] _stext+0x0/0x1000
 [<00143b80>] scsi_error_handler+0x0/0x844
 [<00002762>] kernel_thread+0x3c/0x50

Kernel panic - not syncing: Aiee, killing interrupt handler!

