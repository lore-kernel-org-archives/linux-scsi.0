From: lance dillon <ldillon@sk-tech.com>
Subject: cpqfc
Date: Thu, 01 Dec 2005 09:03:17 -0600
Message-ID: <1133449397.28116.20.camel@think.jsc.nasa.gov>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from joy.jsc.nasa.gov ([139.169.137.12]:31995 "EHLO joy.jsc.nasa.gov")
	by vger.kernel.org with ESMTP id S932264AbVLAPDS (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Thu, 1 Dec 2005 10:03:18 -0500
Received: from think.jsc.nasa.gov (think.jsc.nasa.gov [139.169.132.64])
	by joy.jsc.nasa.gov (8.11.7/8.11.3) with ESMTP id jB1F4kr15122
	for <linux-scsi@vger.kernel.org>; Thu, 1 Dec 2005 09:04:46 -0600 (CST)
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org

I have an old compaq proliant server (dual 733) with the Compaq
FibreChannel HBA Tachyon Chip/Board Ver??: WWN 5002CE4E44556677 (that is
what the kernel messages say).  This is for my church, which has a very
limited budget, so they really can't just buy a new machine with regular
ide drives (this machine was donated to them).  It also has a fibre
channel array attached to it.

kernel 2.6.14.3

Of course the driver is broken, so I'm trying to fix it.

I changed cpqfcTSworker.c so that it allocates space with kmalloc()
instead of on the stack (as per the messages seen by google: cpqfc too
much stack).

I modified a few lines that reference struct scsi_cmd member timeout,
which doesn't seem to exist anymore.  I replaced it with
timeout_per_command, but I'm not sure if that is correct.  Does anybody
have any more information on this for me?

I also had to modify the driver so it sees a0ec, rather than a0fc.

But, I'm getting the problem at all the resources seem to be already
allocated:

cat /proc/pci:

Bus  3, device   5, function 00:
  Class 0280: PCI device 0e11:a0ec (rev 3).
    IRQ 201.
    Master Capable.  Latency=64
    I/O at 0x4000 [0x40ff].
    I/O at 0x4400 [0x44ff].
    Non-prefetchable 32 bit memory at 0xc6fffe00 [0xc6ffffff].

in cpqfcTSinit.c, function Cpqfc_initHBAdata(), it sets IOBaseL and
IOBaseU from PciDev->resource[1].start and PciDev->resource[2].start.
It almost appears that it should be 0 and 1 instead.


I enable DEBUG_PCI in the source...

The kernel messages say that:
HostAdapter->PciDev->irq = 201
PciDev->baseaddress[0]= 4000
PciDev->baseaddress[1]= 4400
PciDev->baseaddress[2]= c6fffe00
PciDev->baseaddress[3]= 0
PciDev->baseaddress[4]= 0
PciDev->baseaddress[5]= 0

So it appears that Cpqfc_initHBAdata() should call request_region() on
4000 and 4400 (IOBaseL and IOBaseU), but since IOBaseL gets set to 4400
and IOBaseU gets set to c6fffe00.

I tried changing the code to set IOBaseL to PciDev->resource[0].start
and IOBaseU to PciDev->resource[1].start, and MemBase to
PciDev->resource[2].start, but the entire system froze when I did
modprobe cpqfc.

This is the error message I get when it is unmodified:

cpqfcHBAdata->fcChip.Registers.:
  IOBaseL = 4400
  IOBaseU = c6fffe00
  SFQconsumerIndex.address = f887e058
  ERQproducerIndex.address = f887e008
  TYconfig.address = f887e184
  FMconfig.address = f887e1c0
  FMcontrol.address = f887e1c4
cpqfc: address in use: c6fffe00
ACPI: PCI interrupt for device 000:03:05.0 disabled

This is when it tries to request_region() IOBaseU, which seems to be
incorrectly set to c6fffe00

However, when I change it so it request 4400 and 4000, it still says the
address is in use.

Would anybody have any ideas, or perhaps be able to point me in the
right direction?

Thanks...



