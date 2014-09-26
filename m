From: Ondrej Zary <linux@rainbow-software.org>
Subject: [PATCH 0/2] wd719x: Introduce Western Digital WD7193/7197/7296 PCI SCSI card driver
Date: Fri, 26 Sep 2014 20:56:46 +0200
Message-ID: <1411757808-12530-1-git-send-email-linux@rainbow-software.org>
Return-path: <linux-kernel-owner@vger.kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
To: linux-scsi@vger.kernel.org
Cc: Christoph Hellwig <hch@infradead.org>, Kernel development list <linux-kernel@vger.kernel.org>
List-Id: linux-scsi@vger.kernel.org


Hello,
this is a new driver for Western Digital WD7193, WD7197 and WD7296 PCI SCSI
controllers based on WD33C296A chip. These nice cards never worked good with
Linux.

It's based on old and ugly wd719x driver written back in 2.0 days, then hacked 
to 2.2 and finally to 2.4 kernels. Most of the code is rewritten: from ~4100 
lines to ~1200.

I've tested the driver on a WD7193 card with some hard drives and CD-ROMs:
QUANTUM  LP240S GM240S01X 4.6
IBM      0663L12          e g
IBM      DORS-32160       WA0A
SONY     CD-ROM CDU-55S   1.0t
SONY     CD-ROM CDU-415   1.1g

The card supports TCQ and linked commands (for cmd_per_lun > 1?) but I don't 
know how it should be implemented in a driver.

Device/bus/host resets seem to work fine when tested by sg_reset.
But don't know how to test command abort.

The card requires firmware that can be cut out of the Windows NT driver that 
can be downloaded from WD at: 
http://support.wdc.com/product/download.asp?groupid=801&sid=27&lang=en
There is no license anywhere in the file or on the page - so I guess that the 
firmware cannot be added to linux-firmware.

This script downloads and extracts the firmware:

#!/bin/sh
wget http://support.wdc.com/download/archive/pciscsi.exe
lha xi pciscsi.exe pci-scsi.exe
lha xi pci-scsi.exe nt/wd7296a.sys
rm pci-scsi.exe
dd if=wd7296a.sys of=wd719x-risc.bin bs=1 skip=5760 count=14336
dd if=wd7296a.sys of=wd719x-wcs.bin bs=1 skip=20096 count=514
rm wd7296a.sys

-- 
Ondrej Zary
