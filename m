From: Finn Thain <fthain@telegraphics.com.au>
Subject: Re: mac_scsi boot crash, was Re: [PATCH] m68k link error and
 NCR5380_exit()
Date: Wed, 9 Mar 2005 02:16:45 +1100 (EST)
Message-ID: <Pine.LNX.4.61.0503090156380.1135@loopy.telegraphics.com.au>
References: <20050213040948.GA10198@orchestra.cs.caltech.edu>
 <Pine.LNX.4.61.0502131618470.25204@loopy.telegraphics.com.au>
 <20050213063225.GA17415@orchestra.cs.caltech.edu>
 <Pine.LNX.4.61.0502131736300.25553@loopy.telegraphics.com.au>
 <20050213075506.GA18622@orchestra.cs.caltech.edu>
 <Pine.LNX.4.61.0502212233290.15372@loopy.telegraphics.com.au>
 <Pine.LNX.4.61.0503071612290.27126@loopy.telegraphics.com.au>
 <20050307063719.GA12478@infradead.org> <Pine.LNX.4.61.0503072333310.27126@loopy.telegraphics.com.au>
 <20050307175322.GA12907@pants.nu> <20050307234233.GA6240@excalibur.research.wombat.ie>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Received: from loopy.telegraphics.com.au ([202.45.126.152]:40405 "EHLO
	loopy.telegraphics.com.au") by vger.kernel.org with ESMTP
	id S261447AbVCHPQv (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Tue, 8 Mar 2005 10:16:51 -0500
In-Reply-To: <20050307234233.GA6240@excalibur.research.wombat.ie>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Kenn Humborg <kenn@linux.ie>
Cc: Brad Boyer <flar@allandria.com>, linux scsi <linux-scsi@vger.kernel.org>, linux m68k <linux-m68k@vger.kernel.org>


On Mon, 7 Mar 2005, Kenn Humborg wrote:

> On Mon, Mar 07, 2005 at 09:53:22AM -0800, Brad Boyer wrote:

> > ...

> > Looks to me like the interrupt came in after the driver already 
> > decided to give up for some reason. I had a big problem with that 
> > while I was trying to fix the driver to use DMA on the IIfx. I never 
> > did get it to give me the interrupt for dma completion before the scsi 
> > mid layer timed out.
> 
> It broke in 2.6.9 for us Linux/VAX guys.
> 
> Try the NCR5380_set_timer() change from this patch:
> 
>    http://www.mail-archive.com/linux-scsi@vger.kernel.org/msg01499.html

That seems to have helped. It still crashes with the same bus error, but 
the preceding issue/disconnect/abort cycle is gone now. Log is below. 
Hopefully I'll get a chance to look at the bus error soon.

BTW, I found your patch is available here intact,

    http://article.gmane.org/gmane.linux.scsi/14617/raw

Thanks for your help.

-f


Linux version 2.6.10-m68k (fthain@nippy) (gcc version 3.4.3) #20 Wed Mar 9 01:42:11 EST 2005
Detected Macintosh model: 27
 Penguin bootinfo data:
 Video: addr 0x60b00000 row 0x280 depth 8 dimensions 640 x 480
 Videological 0xf0300000 phys. 0x60b00000, SCC at 0x50f04000
 Boottime: 0xe7c4e54a GMTBias: 0x0
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
Memory: 5788k/8192k available (1736k kernel code, 528k data, 116k init)
Calibrating delay loop... 6.11 BogoMIPS (lpj=30592)
Mount-cache hash table entries: 512 (order: 0, 4096 bytes)
NET: Registered protocol family 16
NuBus: Scanning NuBus slots.
SCSI subsystem initialized
audit: initializing netlink socket (disabled)
audit(0.860:0): initialized
VFS: Disk quotas dquot_6.5.1
Dquot-cache hash table entries: 1024 (order 0, 4096 bytes)
Initializing Cryptographic API
macfb: framebuffer at 0x60b00000, mapped to 0xd0000000, size 300k
macfb: mode is 640x480x8, linelength=640
macfb: scrolling: redraw
fbcon_startup: No VBL detected, using timer based cursor.
mac_delete_irq: tried to remove invalid irq
Console: switching to colour frame buffer device 80x30
fb0: Macintosh Sonora built-in frame buffer device
io scheduler noop registered
io scheduler anticipatory registered
io scheduler deadline registered
io scheduler cfq registered
RAMDISK driver initialized: 16 RAM disks of 4096K size 1024 blocksize
loop: loaded (max 8 devices)
Uniform Multi-Platform E-IDE driver Revision: 7.00alpha2
ide: Assuming 50MHz system bus speed for PIO modes; override with idebus=xx
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
SCSI device sda: drive cache: write through
SCSI device sda: 166200 512-byte hdwr sectors (85 MB)
SCSI device sda: drive cache: write through
 sda:Data read fault at 0x667a26b9 in Super Data (pc=0x114cec)
BAD KERNEL BUSERR
Oops: 00000000
Modules linked in:
PC: [<00114cec>] macscsi_intr+0x1a/0x74

SR: 2700  SP: 00239e74  a2: 001b34cc
d0: 00232100    d1: 00000100    d2: 00232100    d3: 00000000
d4: 00000001    d5: 00000013    a0: 667a2669    a1: 50f26000
Process swapper (pid: 0, stackpage=001b44cc)
Stack from 00239e74:
        00000100 00232100 00000000 00000001 00000013 667a2669 50f26000 001b34cc
        00232100 ffffffff 00000000 27000011 4cecb008 0eec0755 120049c1 667a26b9
        667a26b9 00002100 10280050 00114cf4 00114cf2 00114cf0 667a26ff 00500064
        000ff487 00000001 00000000 00003c18 00000000 80080000 667a26b9 00000000
        001f3208 00114ce8 00232200 00000013 00000013 00000013 001f32d0 00239f74
        00007d30 00000013 00114cd2 00239f74 0023a008 00000008 00001c13 00002000
Call Trace: [<00008eb8>] via2_irq+0x6e/0x96
 [<00186ad0>] __func__.1+0xe6f/0x21576
 [<00001000>] _stext+0x0/0x1000
 [<00177776>] schedule+0x0/0x4d2
 [<00003d90>] process_int+0x4c/0x62
 [<000024a0>] inthandler+0x2a/0x2c
 [<00186ad0>] __func__.1+0xe6f/0x21576
 [<00001000>] _stext+0x0/0x1000
 [<0000261c>] default_idle+0x0/0xe
 [<00186ad0>] __func__.1+0xe6f/0x21576
 [<00001000>] _stext+0x0/0x1000
 [<0000261c>] default_idle+0x0/0xe
 [<00002640>] cpu_idle+0x16/0x22
 [<0001c778>] printk+0x0/0x18
 [<00002022>] rest_init+0x1a/0x1c
 [<0021d03c>] start_kernel+0x1b8/0x1c4
 [<0021b3d2>] __start+0x3d2/0xa48

Kernel panic - not syncing: Aiee, killing interrupt handler!
