From: Douglas Gilbert <dougg@torque.net>
Subject: Re: [PATCH] instrument ide-scsi in 2.5.68
Date: Sat, 03 May 2003 19:03:47 +1000
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <3EB385F3.6010708@torque.net>
References: <3EB11AD3.2070503@torque.net>	<3EB22F09.7060906@torque.net> <20030502095536.76dba4dd.rddunlap@osdl.org>
Reply-To: dougg@torque.net
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from bunyip.cc.uq.edu.au ([130.102.2.1]:37391 "EHLO
	bunyip.cc.uq.edu.au") by vger.kernel.org with ESMTP id S263277AbTECIs4
	(ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Sat, 3 May 2003 04:48:56 -0400
In-Reply-To: <20030502095536.76dba4dd.rddunlap@osdl.org>
List-Id: linux-scsi@vger.kernel.org
To: "Randy.Dunlap" <rddunlap@osdl.org>
Cc: linux-scsi@vger.kernel.org, alan@lxorguk.ukuu.org.uk

Randy.Dunlap wrote:
> On Fri, 02 May 2003 18:40:41 +1000 Douglas Gilbert <dougg@torque.net> wrote:
> 
> | Douglas Gilbert wrote:
> | > <snip/>
> | >   - instrument driver with 2 parameters (as examples)
> | >       - ide-scsi.debug + ide-scsi.suppress_reset
> | >         [kernel load time]
> | >       - debug + suppress_reset [module load time]
> | >       - debug + suppress_reset [sysfs: read/write
> | >         in /sys/bus/ide/drivers/ide-scsi directory]
> | >   - downgrade (simple) tag queuing to no tag queuing
> | >     [set some other things to more conservative values]
> | >   - add scsi_host::release() method
> | >   - make provision for 16 byte SCSI commands
> | >   - cleanup printk()s
> |  > <snip/>
> | 
> | As Randy has found the setting of kernel boot time parameters
> | doesn't work. The problem seems to be that the ide subsystem
> | asserts ownership over all parameters that start with "ide".
> | I was unable to bend moduleparam.h to accept a leading underscore
> | so I went back to the old "__setup" method: the kernel boot time
> | parameters are now:
> |    - _ide_scsi_debug + _ide_scsi_suppress_reset
> 
> I'll confirm that those work.  I.e., I saw values 3 and 1 in
> /sys/bus/ide/drivers/ide-scsi/*.
> 
> | Module load time and sysfs parameters remain the same.
> | 
> | A new patch against lk 2.5.68 is attached.
> 
> Used that patch instead of v1 of it.  Got an oops in ide-scsi.

Randy,
Thanks for testing this. At this stage I have no
solution but can offer some analysis.

Firstly, it seems like Mandrake 9.0 has some
program like RedHat's "magicdev" that polls
cd/dvds every second or so. Nuke it please!
It won't fix the problem but will make it easier
to see the wood for the trees.

Over 50 commands were issued successfully to /dev/hdd
until the latter part of your capture file:

> ide-scsi: hdd: que 91, cmd = [ 5a 0 2a 0 0 0 0 0 2 0 ]
> 
> Mandrake Linux release 9.0 (dolphin) for i586
> Kernel 2.5.68 on a Dual-processor i686 / l
> 
> gargoyle.pdx.osdl.net login: hdd: lost interrupt
> ide-scsi: Reached idescsi_pc_intr interrupt handler
> ide-scsi: hdd: DMA complete
> ide-scsi: CoD != 0 in idescsi_pc_intr
> hdd: DMA disabled
> ide-scsi: abort ignored
> ide-scsi: device reset ignored
> ide-scsi: hdd: que 91, cmd = [ 0 0 0 0 0 0 ]
> hdd: ATAPI reset complete
> hdd: irq timeout: status=0x80 { Busy }
> hdd: ATAPI reset complete
> hdd: irq timeout: status=0x80 { Busy }
> hdd: ATAPI reset complete
> hdd: irq timeout: status=0x80 { Busy }
> ide-scsi: hdd: I/O error for 91
> ide-scsi: Reached idescsi_pc_intr interrupt handler
> Packet command completed, 0 bytes transferred
> ide-scsi: hdd: suc 1802201963
> Unable to handle kernel paging request at virtual address 6b6b6b8b
<oooops>

The issued command is a MODE SENSE (10 byte) for page 0x2a
and just the first 2 bytes (i.e. tell me the length you
will return). There must have been 10 of the exact same
commands executed successfully prior to this point.

"hdd: lost interrupt" seems to indicate a timeout (ide-scsi
sets its timeouts to max(10, whatever_app_wants) seconds).
Then it re-enters the ide-scsi driver in the
idescsi_pc_intr() routine and things look corrupted. It tries
to finish off a DMA transfer but that 2 byte data_in request
was not set up as DMA. It is all downhill from there.

Naturally I don't see any errors on my box. However I can
shorten the timeout so it will go off on a READ command.
The timeout log looks quite different from yours and
my driver continues in a healthy state.

ide-scsi: hdd: que 11417, cmd = [ 28 0 0 0 0 0 0 0 1 0 ]
hdd: irq timeout: status=0xd0 { Busy }
hdd: ATAPI reset complete
hdd: irq timeout: status=0xc0 { Busy }
hdd: ATAPI reset complete
hdd: irq timeout: status=0xc0 { Busy }
ide-scsi: hdd: I/O error for 11417


Does anyone have any suggestions for further testing?

I have cleaned up the logging messages a little but
that does not justify releasing a new version yet.


An additional observation concerning Randy's capture:
the failed command (MODE SENSE) has serial number 91.
After ide-scsi thinks it has cleared the timeout and
the DMA transfer it issues a TEST UNIT READY which
also get 91 as a serial number. This looks like a
bug in the mid level.

Doug Gilbert

