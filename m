From: "Michael W. Shaffer" <mwshaffer@yahoo.com>
Subject: Re: No LUNs detected with 2.6.1-mm4 qla2xxx / qla2300
Date: Mon, 19 Jan 2004 00:24:50 -0800 (PST)
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <20040119082450.95456.qmail@web10409.mail.yahoo.com>
References: <20040119052701.GA16779@praka.local.home>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from web10409.mail.yahoo.com ([216.136.128.122]:9810 "HELO
	web10409.mail.yahoo.com") by vger.kernel.org with SMTP
	id S264453AbUASIYy (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Mon, 19 Jan 2004 03:24:54 -0500
In-Reply-To: <20040119052701.GA16779@praka.local.home>
List-Id: linux-scsi@vger.kernel.org
To: Andrew Vasquez <praka@users.sourceforge.net>
Cc: linux-scsi@vger.kernel.org

Well, I got through step 1 ok, enabling the debug options in
the source files you mentioned in the plain 2.6.1-mm4 source
and retesting. However, I have a problem building the kernel
when I apply the -mm4 patch and then apply your -b9 resync
patch as well. The patch applies just fine, and I went in to
turn on debugging, but for some reason the qla* modules just
refuse to build now. They don't have errors or anything, the
build process just appears to totally ignore the qla2xxx
directory. I tried running 'make mrproper', re-verifying
the config, and rebuilding, but still no luck, I just can't
get any of the qla* modules built or installed. Any idea
what I'm doing wrong?

Anyway, here is the relevant output from /var/log/messages
from loading the -b8 driver with debugging turned on. Not
knowing what I'm really looking for, the only thing that
appears to stick out is some sort of failed mailbox command.

/var/log/messages
----------------------------------------------------------
Jan 18 23:46:11 thing2 kernel: QLogic ISP2xxx PCI/PCI-X Fibre Channel HBA
Driver (f8a2c000)
Jan 18 23:46:18 thing2 kernel: qla2300 0000:01:02.0: Found an ISP2312, irq
25, iobase 0xf8893000
Jan 18 23:46:18 thing2 kernel: qla2300 0000:01:02.0: Configuring PCI
space...
Jan 18 23:46:18 thing2 kernel: qla2300 0000:01:02.0: Configure NVRAM
parameters...
Jan 18 23:46:18 thing2 kernel: qla2300 0000:01:02.0: Verifying loaded RISC
code...
Jan 18 23:46:18 thing2 kernel: scsi(2): **** Load RISC code ****
Jan 18 23:46:18 thing2 kernel: scsi(2): Verifying Checksum of loaded RISC
code.
Jan 18 23:46:18 thing2 kernel: scsi(2): Checksum OK, start firmware.
Jan 18 23:46:18 thing2 kernel: scsi(2): Issue init firmware.
Jan 18 23:46:19 thing2 kernel: scsi(2): Asynchronous LIP RESET (f8f7).
Jan 18 23:46:19 thing2 kernel: qla2300 0000:01:02.0: LIP reset occured
(f8f7).
Jan 18 23:46:19 thing2 kernel: qla2300 0000:01:02.0: Waiting for LIP to
complete...
Jan 18 23:46:19 thing2 kernel: scsi(2): LIP occured (f8f7).
Jan 18 23:46:19 thing2 kernel: qla2300 0000:01:02.0: LIP occured (f8f7).
Jan 18 23:46:19 thing2 kernel: scsi(2): Asynchronous LOOP UP (2 Gbps).
Jan 18 23:46:19 thing2 kernel: qla2300 0000:01:02.0: LOOP UP detected (2
Gbps).
Jan 18 23:46:19 thing2 kernel: scsi(2): Asynchronous PORT UPDATE.
Jan 18 23:46:19 thing2 kernel: scsi(2): Port database changed ffff 0006.
Jan 18 23:46:19 thing2 kernel: scsi(2): F/W Ready - OK 
Jan 18 23:46:20 thing2 kernel: scsi(2): fw_state=3 curr time=fffd7531.
Jan 18 23:46:20 thing2 kernel: qla2300 0000:01:02.0: Topology - (Loop), Host
Loop address 0x1
Jan 18 23:46:20 thing2 kernel: scsi(2): Configure loop -- dpc flags =0x80040
Jan 18 23:46:20 thing2 kernel: qla2x00_mailbox_command(2): **** FAILED.
mbx0=4006, mbx1=7e, mbx2=0, cmd=6a ****
Jan 18 23:46:20 thing2 kernel: qla2x00_get_port_name(2): failed=102.
Jan 18 23:46:20 thing2 kernel: scsi(2): MBC_GET_PORT_NAME Failed, No FL Port
Jan 18 23:46:20 thing2 kernel: scsi(2): LOOP READY
Jan 18 23:46:20 thing2 kernel: DEBUG: detect hba 2 at address = f6c8c1b8
Jan 18 23:46:20 thing2 kernel: scsi2 : qla2xxx
Jan 18 23:46:20 thing2 kernel: qla2300 0000:01:02.0: 
Jan 18 23:46:20 thing2 kernel:  QLogic ISP2xxx PCI/PCI-X Fibre Channel HBA
Driver: 8.00.00b8-debug
Jan 18 23:46:20 thing2 kernel:   QLogic QLA2340 - 
Jan 18 23:46:20 thing2 kernel:   ISP2312: PCI (66 MHz) @ 0000:01:02.0 hdma-,
host#=2, fw=3.02.18 TPX
Jan 18 23:46:20 thing2 kernel: qla2300 0000:01:03.0: Found an ISP2312, irq
25, iobase 0xf8895000
Jan 18 23:46:20 thing2 kernel: qla2300 0000:01:03.0: Configuring PCI
space...
Jan 18 23:46:20 thing2 kernel: qla2300 0000:01:03.0: Configure NVRAM
parameters...
Jan 18 23:46:21 thing2 kernel: qla2300 0000:01:03.0: Verifying loaded RISC
code...
Jan 18 23:46:21 thing2 kernel: scsi(3): **** Load RISC code ****
Jan 18 23:46:21 thing2 kernel: scsi(3): Verifying Checksum of loaded RISC
code.
Jan 18 23:46:21 thing2 kernel: scsi(3): Checksum OK, start firmware.
Jan 18 23:46:21 thing2 kernel: scsi(3): Issue init firmware.
Jan 18 23:46:21 thing2 kernel: scsi(3): Asynchronous LIP RESET (f8f7).
Jan 18 23:46:21 thing2 kernel: qla2300 0000:01:03.0: LIP reset occured
(f8f7).
Jan 18 23:46:21 thing2 kernel: qla2300 0000:01:03.0: Waiting for LIP to
complete...
Jan 18 23:46:22 thing2 kernel: scsi(3): LIP occured (f8f7).
Jan 18 23:46:22 thing2 kernel: qla2300 0000:01:03.0: LIP occured (f8f7).
Jan 18 23:46:22 thing2 kernel: scsi(3): Asynchronous LOOP UP (2 Gbps).
Jan 18 23:46:22 thing2 kernel: qla2300 0000:01:03.0: LOOP UP detected (2
Gbps).
Jan 18 23:46:22 thing2 kernel: scsi(3): F/W Ready - OK 
Jan 18 23:46:22 thing2 kernel: scsi(3): Asynchronous PORT UPDATE.
Jan 18 23:46:22 thing2 kernel: scsi(3): Port database changed ffff 0006.
Jan 18 23:46:22 thing2 kernel: scsi(3): fw_state=3 curr time=fffd7e28.
Jan 18 23:46:22 thing2 kernel: qla2300 0000:01:03.0: Topology - (Loop), Host
Loop address 0x1
Jan 18 23:46:22 thing2 kernel: scsi(3): Configure loop -- dpc flags =0x80040
Jan 18 23:46:22 thing2 kernel: qla2x00_mailbox_command(3): **** FAILED.
mbx0=4006, mbx1=7e, mbx2=0, cmd=6a ****
Jan 18 23:46:22 thing2 kernel: qla2x00_get_port_name(3): failed=102.
Jan 18 23:46:22 thing2 kernel: scsi(3): MBC_GET_PORT_NAME Failed, No FL Port
Jan 18 23:46:22 thing2 kernel: scsi(3): LOOP READY
Jan 18 23:46:22 thing2 kernel: DEBUG: detect hba 3 at address = f6c241b8
Jan 18 23:46:22 thing2 kernel: scsi3 : qla2xxx
Jan 18 23:46:22 thing2 kernel: qla2300 0000:01:03.0: 
Jan 18 23:46:22 thing2 kernel:  QLogic ISP2xxx PCI/PCI-X Fibre Channel HBA
Driver: 8.00.00b8-debug
Jan 18 23:46:22 thing2 kernel:   QLogic QLA2340 - 
Jan 18 23:46:22 thing2 kernel:   ISP2312: PCI (66 MHz) @ 0000:01:03.0 hdma-,
host#=3, fw=3.02.18 TPX
----------------------------------------------------------


__________________________________
Do you Yahoo!?
Yahoo! Hotjobs: Enter the "Signing Bonus" Sweepstakes
http://hotjobs.sweepstakes.yahoo.com/signingbonus
