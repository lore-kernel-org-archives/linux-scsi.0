From: Chiaki <ishikawa@yk.rim.or.jp>
Subject: Re: TMSCSIM [2.6]
Date: Fri, 28 Nov 2003 04:13:29 +0900
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <3FC64CD9.8040505@yk.rim.or.jp>
References: <Pine.LNX.4.44.0311252311360.14624-100000@poirot.grange>
Mime-Version: 1.0
Content-Type: multipart/mixed;
 boundary="------------080900040304070002020708"
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from pl656.nas911.n-yokohama.nttpc.ne.jp ([210.139.39.144]:56522
	"EHLO standard.erephon") by vger.kernel.org with ESMTP
	id S264582AbTK0TOB (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Thu, 27 Nov 2003 14:14:01 -0500
Received: from (client is using the wrong hostname!) yk.rim.or.jp (really [127.0.0.1]) by yk.rim.or.jp
	via smail with esmtp
	id <m1APRa9-00393NC@standard.erephon> (Debian Smail3.2.0.115)
	for <linux-scsi@vger.kernel.org>; Fri, 28 Nov 2003 04:13:41 +0900 (JST)
In-Reply-To: <Pine.LNX.4.44.0311252311360.14624-100000@poirot.grange>
List-Id: linux-scsi@vger.kernel.org
To: Guennadi Liakhovetski <g.liakhovetski@gmx.de>
Cc: linux-scsi@vger.kernel.org

This is a multi-part message in MIME format.
--------------080900040304070002020708
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Transfer-Encoding: 7bit

Hi,

Here is the record of messages shown during boot using
serial console when the module loading of tmscsim fails
under 2.6.0-test10.
(Sorry, I am still using gcc 3.3. One step at a time.)

It seems that the system triggered a bug detection code in the
dma-mapping code.

LUN 1 connected to dc390 is now being scanned
as far as the message is correct, but maybe during the scan
and handling of CDROM, the system crashed?
The reason I suspect this is that I don't see the "lun 1"
message line, following the
"Type:	  CD-ROM			     ANSI SCSI revision: 02"
line in the log. For "lun 0",
"Attached scsi removable disk sdc at scsi1, channel 0, id 5, lun 0
Attached scsi generic sg2 at scsi1, channel 0, id 5, lun 0,  type 7"
followed immediately after the detection.

I wonder if anyone has SCSI CDROM driver as a module,
namely sr_mod, up and running under 2.6.0-testXX series.

 From the log, I excerpted interesting part and show it below here. The
full log is attached together with my config.

--- except from the log starts here
Loading modules...
     hpfs
warning: process `update' used the obsolete bdflush system call
Fix your initscripts?
     nls_cp437
     sg
Attached scsi generic sg0 at scsi0, channel 0, id 4, lun 0,  type 0
Attached scsi generic sg1 at scsi0, channel 0, id 6, lun 0,  type 0
     sr_mod
     tmscsim
PCI: Found IRQ 11 for device 0000:00:0d.0
PCI: Sharing IRQ 11 with 0000:00:0f.0
DC390: 1 adapters found
scsi1 : Tekram DC390/AM53C974 V2.0f 2000-12-20
DC390: Target 5: Sync transfer 5.0 MHz, Offset 8
   Vendor: MATSHITA  Model: PD-1 LF-1000	     Rev: A111
   Type:	  Optical Device		     ANSI SCSI revision: 02
Attached scsi removable disk sdc at scsi1, channel 0, id 5, lun 0
Attached scsi generic sg2 at scsi1, channel 0, id 5, lun 0,  type 7
   Vendor: MATSHITA  Model: PD-1 LF-1000	     Rev: A111
   Type:	  CD-ROM			     ANSI SCSI revision: 02
------------[ cut here ]------------
kernel BUG at include/asm/dma-mapping.h:40!
invalid operand: 0000 [#1]
CPU:	0
EIP:	0060:[<f09445c1>]    Not tainted
EFLAGS: 00010046
EIP is at dc390_pci_map+0xc1/0x140 [tmscsim]
eax: 00000000	ebx: 00000000	ecx: c0404e00	edx: 00000000
esi: ef62a2f0	edi: 00000001	ebp: c03a5e4c	esp: c03a5e3c
ds: 007b   es: 007b   ss: 0068
Process swapper (pid: 0, threadinfo=c03a4000 task=c0338680)
Stack: 00000000 ef62a2f0 efc61940 efc99380 c03a5e8c f09451d1 ef62a2f0 
ef62a2f0
        efc99380 efc99380 c03a5ea4 f09451d1 ef62a2f0 982b34e5 0000001e 
00000001
        cc000092 ef62a2f0 efc61940 ef62a208 c03a5ec4 f0946e36 ef62a208 
efc99380
Call Trace:
  [<f09451d1>] dc390_StartSCSI+0x41/0x330 [tmscsim]
  [<f09451d1>] dc390_StartSCSI+0x41/0x330 [tmscsim]
  [<f0946e36>] dc390_SRBdone+0x306/0x5b0 [tmscsim]
  [<f09472f3>] dc390_RequestSense+0x53/0x90 [tmscsim]
  [<f0946714>] dc390_Disconnect+0x104/0x160 [tmscsim]
  [<f094574d>] do_DC390_Interrupt+0x28d/0x350 [tmscsim]
  [<c0113f4c>] timer_interrupt+0x8c/0x260
  [<c025dc88>] scsi_softirq+0xe8/0x240
  [<c010da4b>] handle_IRQ_event+0x3b/0x70
  [<c010e060>] do_IRQ+0x140/0x390
  [<c0105000>] _stext+0x0/0xf0
  [<c010c0ec>] common_interrupt+0x18/0x20
  [<c0105000>] _stext+0x0/0xf0
  [<c0108ea6>] default_idle+0x26/0x30
  [<c0108f24>] cpu_idle+0x34/0x40
  [<c03a6797>] start_kernel+0x1e7/0x270
  [<c03a6480>] unknown_bootoption+0x0/0x100

Code: 0f 0b 28 00 77 9d 94 f0 eb c5 0f 0b 25 00 77 9d 94 f0 eb a8
  <0>Kernel panic: Fatal exception in interrupt
In interrupt handler - not syncing
  <6>SysRq : Emergency Sync
SysRq : Resetting
--- except from the log ends


dma_mapping_on:40 is the following line.

    31	static inline int
    32	dma_map_sg(struct device *dev, struct scatterlist *sg, int nents,
    33		   enum dma_data_direction direction)
    34	{
    35		int i;
    36	
    37		BUG_ON(direction == DMA_NONE);
    38	
    39		for (i = 0; i < nents; i++ ) {
=> 40			BUG_ON(!sg[i].page);
    41	
    42			sg[i].dma_address = page_to_phys(sg[i].page) + sg[i].offset;
    43		}
    44	
    45		flush_write_buffers();
    46		return nents;
    47	}


PS: Note on serial console setup with loadlin.

I studied the excellent guide posted to linux-kernel in August
regarding how to set up the serial console.

However, I am using LOADLIN and this boot utiltiy seems to
require a certain modification to the setup mentioned in the post.
(The post assumed "lilo").

--- quote from the post and my comment ---
 >      Your need a NULL modem serial cable available
 >      from any computer store.
 >
 >    Install uucp - I use on the HOST :
 >
 >    uucp-1.06.1-33.7.2.
 >
 >    Also , LILO is broken on some machines and ignores
 >    serial input so make sure you use at least
 >
 >    lilo-21.6-71
 >
 >    On the TARGET
 >
 >    1. Connect the serial ports together ( COM1->COM1 ) with
 >	the serial cable .
 >
 >    2. Modify LILO to use serial line on the TARGET
 >	add to lilo.conf:
 >	   append="console=ttyS0,9600n8  console=tty0 "
 >	   serial=0,9600N8
 >
 >	Run lilo

CI's comment starts here: I needed to change this part for loadlin
and kernel 2.4.22 as follows. [I tested the serial
console setup under 2.4.22 and it took me a long time to set this up.]

I needed to omit console=tty0 portion for testing the setup under 2.4.22.
If the second console= part is present, the initial portion shown
on the screen namely,

   BIOS-provided physical RAM map:
    BIOS-e820: 0000000000000000 - 000000000009fc00 (usable)
    ... omitted ..

disappeared somewhere and not seen on the CRT of the original PC
nor on the serial console screen. They simply disappeared and
so the setup was useless! (All I got was the login prompt: after a while.)

Under 2.4.22, if I remove the later command options, and use a command
line like this, (omitting console=tty0 serial=0,9600N8. serial=
... must be a command option to "lilo" itself.)

loadlin lin2422.ip6 root=/dev/sda6 ro vga=3 scsihosts=sym53c8xx:tmscsim 
console=ttyS0,9600n8

I DID get a partial portion of the messages originally shown on the
original PC on the serial console, but only partially.  ONLY the
messages AFTER `init' starts are shown on serial console.  So
"BIOS-provided ..." message lines and those many lines that follow
until `init' starts are not shown.  Why? I have no idea.

The second best solution for me then is to add
"kern.*[tab]/dev/console" and hope that syslogd will pickup kernel
messages and show it explicitly under /dev/console which is now turned
into /dev/ttyS0 in the step 4 below. (But this may not work well if
the system gets hung BEFORE `init' starts and syslogd is active.
Also, even if such messages like "BIOS -provided ..." are shown using
syslogd, then they are shown AFTER init starts and syslogd daemon
starts. So their position in the recorded message on the serial
console is a little strange.)

However, it turns out 2.6.0-test10 handles the kernel message
output to serial console in a slightly different manner, and
"BIOS-provided ..." messages and all lines that follow are dumped to serial
console immediately without any problem after
my setup [ step 4 below included ].
Again I have no idea why, but as you can see in
the attached log, the serial console for message dumping purposes
seems to work just fine with 2.6.0-test10.  (In any case,
/etc/syslog.conf DID have kern.* /dev/ttyS0 for the log.)

 >    3. Add to /etc/inittab on the HOST
 >
 >	   S0:s12345:respawn:/sbin/agetty 9600 ttyS0
 >
 >    4. To see ALL THE CONSOLE MESSAGES during boot on the TARGET
 >
 >	mv /dev/console /dev/console.org
 >	ln  /dev/ttyS0 /dev/console

CI's comment: This had to be done AFTER disabling devfs and rebooting
2.4.22 on my PC.
(for obvious reasons to those who use devfs. /dev directory
after devfsd is invoked is a "virtual directory" and mv and other
modifications are NOT allowed.)


 >    5. Start uucp on the HOST:
 >
 >	 cu -l /dev/ttyS0 -s 9600
 >

	My second PC is a window98 PC. I disabled the TTY ports
	on that PC long time ago, and so it took me a while
	to enable the tty ports, and configure it under win98.
	Hyperterminal happily tries to open non-functioning com1 and
	com2 ports and simply crashed under that platform and so
	it took me a while to figure out that the tty ports were not
	configured at all!

 >    6. Boot your target
 >
 >    ///
 >
 >    John Donnelly AT HP DOT com
--- end quote ---

Hope this helps.


Ishikawa, Chiaki

--------------080900040304070002020708
Content-Type: application/zip;
 name="bug-log.zip"
Content-Transfer-Encoding: base64
Content-Disposition: inline;
 filename="bug-log.zip"

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
--------------080900040304070002020708--

