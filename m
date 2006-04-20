From: Vinayak <vinayak.pane@gmail.com>
Subject: updated 2.6.16 qla2xxx driver doesn't work for qla2342 card
Date: Thu, 20 Apr 2006 16:27:55 +0530
Message-ID: <7ea3a06a0604200357j4a2bf1bw8be522ed8eb769c8@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from nz-out-0102.google.com ([64.233.162.205]:63028 "EHLO
	nz-out-0102.google.com") by vger.kernel.org with ESMTP
	id S1750811AbWDTK5z convert rfc822-to-8bit (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Thu, 20 Apr 2006 06:57:55 -0400
Received: by nz-out-0102.google.com with SMTP id 14so83253nzn
        for <linux-scsi@vger.kernel.org>; Thu, 20 Apr 2006 03:57:55 -0700 (PDT)
Content-Disposition: inline
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org

Hi,
My server is having one qla2342 card & one qla2300 card which I used
to connect to my RAID controller. It works properly with 2.6.12
drivers.

Now, when I upgraded my kernel to 2.6.16 it stopped working.
I compiled the kernel & qla sources again & again , but no success.

Actually, it fails where it tries to fetch the firmware image from card.
Exactly, it fails in "qla2x00_request_firmware" ---> request_firmware
--> _request_firmware ( in firmware_class.c file)

I enabled the debug levels also. The detailed log is as bellow I have
added some of my comments too.
If you have any clues, why this is happening then let me know about it.
Probably, qla2342 series doesn't support such request. Because I could
see that in  2.6.12 the firmware image is hard coded.

-vinayak

The detailed log is as below :

Apr 18 16:02:08 localhost kernel: [17180036.200000] QLogic Fibre
Channel HBA Driver
Apr 18 16:02:08 localhost kernel: [17180036.204000] ACPI: PCI
Interrupt 0000:02:09.0[A] -> GSI 21 (level, low) -> IRQ 20
Apr 18 16:02:08 localhost kernel: [17180036.204000] qla2xxx
0000:02:09.0: Found an ISP2300, irq 20, iobase 0xe00ee000
Apr 18 16:02:08 localhost kernel: [17180036.204000] qla2xxx
0000:02:09.0: Configuring PCI space...
Apr 18 16:02:08 localhost kernel: [17180036.204000] qla2xxx
0000:02:09.0: Configure NVRAM parameters...
Apr 18 16:02:08 localhost kernel: [17180036.300000] scsi(6): VP::
Contents of NVRAM
Apr 18 16:02:08 localhost kernel: [ 17180036.304000]  0   1   2   3  
4   5   6   7   8   9  Ah  Bh  Ch  Dh  Eh  Fh
Apr 18 16:02:08 localhost kernel: [17180036.304000]
------------------------------
--------------------------------
Apr 18 16:02:08 localhost kernel: [ 17180036.304000] 49  53  50  20 
01  00  01  00  06  a0  00  08  00  01  00  01
Apr 18 16:02:08 localhost kernel: [17180036.304000] 3c  01  21  00  00
 e0  8b  04  ff  75  00  00  00  00  00  00
Apr 18 16:02:08 localhost kernel: [ 17180036.304000] 00  00  00  00 
00  00  00  00  00  00  00  00  00  00  00  00
Apr 18 16:02:08 localhost kernel: [17180036.304000] 00  00  00  00  00
 00  00  00  00  00  00  00  00  00  00  00
Apr 18 16:02:08 localhost kernel: [ 17180036.304000] 00  00  00  00 
00  00  82  04  00  00  00  00  00  00  00  00
Apr 18 16:02:08 localhost kernel: [17180036.304000] 00  05  3c  00  08
 00  00  00  00  00  00  00  00  00  00  00
Apr 18 16:02:08 localhost kernel: [ 17180036.304000] 00  00  00  00 
00  00  00  00  00  00  00  00  00  00  00  00
Apr 18 16:02:08 localhost kernel: [17180036.304000] 09  01  00  0b  01
 00  18  00  00  00  00  00  03  00  03  10
Apr 18 16:02:08 localhost kernel: [ 17180036.304000] 00  00  00  00 
00  00  00  00  00  00  00  00  00  00  00  00
Apr 18 16:02:08 localhost last message repeated 4 times
Apr 18 16:02:08 localhost kernel: [17180036.308000] 00  00  00  00  00
 00  00  00  00  00  00  00  00  00  00  00
Apr 18 16:02:08 localhost kernel: [17180036.308000] 00  00  00  00  00
 00  00  00  00  00  00  00  00  00  00  00
Apr 18 16:02:08 localhost kernel: [17180036.308000] 00  00  00  00  00
 00  00  00  00  00  77  10  09  00  00  5e
Apr 18 16:02:08 localhost kernel: [17180036.308000] qla2xxx
0000:02:09.0: Verifying loaded RISC code...
Apr 18 16:02:08 localhost kernel: [17180036.308000] scsi(6): **** Load
RISC code ****
Apr 18 16:02:08 localhost kernel: [ 17180036.308000] scsi(6): Testing
device at e00ee000.
Apr 18 16:02:08 localhost kernel: [17180036.308000] scsi(6): Reset
register cleared by chip reset
Apr 18 16:02:08 localhost kernel: [17180036.308000] scsi(6): Checking
product ID of chip
Apr 18 16:02:08 localhost kernel: [17180036.308000] scsi(6): Checking mailboxes.
Apr 18 16:02:08 localhost kernel: [17180036.308000]
qla2x00_mbx_reg_test(6): entered.
Apr 18 16:02:08 localhost kernel: [17180036.308000  ]
qla2x00_mailbox_command(6): entered.
Apr 18 16:02:08 localhost kernel: [17180036.308000] scsi(6): prepare
to issue mbox cmd=0x6.
Apr 18 16:02:08 localhost kernel: [17180036.308000]
qla2x00_mailbox_command(6): Loaded MBX registers (displayed in bytes)
=
Apr 18 16:02:08 localhost kernel: [17180036.308000]  0   1   2   3   4
  5   6   7   8   9  Ah  Bh  Ch  Dh  Eh  Fh
Apr 18 16:02:08 localhost kernel: [17180036.308000]
--------------------------------------------------------------
Apr 18 16:02:08 localhost kernel: [17180036.308000] 06  00  aa  aa  55
 55  55  aa  aa  55  a5  a5  5a  5a  25  25
Apr 18 16:02:08 localhost kernel: [17180036.308000]
Apr 18 16:02:08 localhost kernel: [17180036.308000  ]  0   1   2   3  
4   5   6   7   8   9  Ah  Bh  Ch  Dh  Eh  Fh
Apr 18 16:02:08 localhost kernel: [17180036.308000]
--------------------------------------------------------------
Apr 18 16:02:08 localhost kernel: [ 17180036.308000] 31  38  30  30 
33  36  2e  33  30  38  30  30  30  5d  20  00
Apr 18 16:02:08 localhost kernel: [17180036.308000]
Apr 18 16:02:08 localhost kernel: [17180036.308000]  0   1   2   3   4
  5   6   7   8   9  Ah  Bh  Ch  Dh  Eh  Fh
Apr 18 16:02:08 localhost kernel: [17180036.308000]
--------------------------------------------------------------
Apr 18 16:02:08 localhost kernel: [17180036.308000] 26  09  3d  00  5c
 c1  8d  cd
Apr 18 16:02:08 localhost kernel: [ 17180036.308000]
Apr 18 16:02:08 localhost kernel: [17180036.308000]
qla2x00_mailbox_command(6): I/O address = e00ee080.
Apr 18 16:02:08 localhost kernel: [17180036.308000] Mailbox registers:
Apr 18 16:02:08 localhost kernel: [ 17180036.308000] scsi(6): mbox 0 0x0000
Apr 18 16:02:08 localhost kernel: [17180036.308000] scsi(6): mbox 1 0x4953
Apr 18 16:02:08 localhost kernel: [17180036.308000] scsi(6): mbox 2 0x5020
Apr 18 16:02:08 localhost kernel: [ 17180036.308000] scsi(6): mbox 3 0x2020
Apr 18 16:02:08 localhost kernel: [17180036.308000] scsi(6): mbox 4 0x0001
Apr 18 16:02:08 localhost kernel: [17180036.308000] scsi(6): mbox 5 0x0004
Apr 18 16:02:08 localhost kernel: [ 17180036.308000]
qla2x00_mailbox_command(6): going to unlock irq & waiting for
interrupt. jiffies=a335.
Apr 18 16:02:08 localhost kernel: [17180036.308000]
qla2x00_mailbox_command(6): cmd=6 POLLING MODE.
Apr 18 16:02:08 localhost kernel: [ 17180036.312000]
qla2x00_mbx_completion(6): Got mailbox completion. cmd=6.
Apr 18 16:02:08 localhost kernel: [17180036.312000]
qla2x00_mailbox_command(6): cmd 6 completed.
Apr 18 16:02:08 localhost kernel: [17180036.312000  ]
qla2x00_mailbox_command(6): checking for additional resp interrupt.
Apr 18 16:02:08 localhost kernel: [17180036.312000]
qla2x00_mailbox_command(6): done.
Apr 18 16:02:08 localhost kernel: [17180036.312000]
qla2x00_mbx_reg_test(6): done.
Apr 18 16:02:08 localhost kernel: [17180036.360000] scsi(6): VP::
Failed to load firmware image (ql2300_fw.bin).
Apr 18 16:02:08 localhost kernel: [17180036.360000] scsi(6): Setup
chip **** FAILED ****.
Apr 18 16:02:08 localhost kernel: [ 17180036.360000]
qla2x00_initialize_adapter(): **** FAILED ****
Apr 18 16:02:08 localhost kernel: [17180036.360000] qla2xxx
0000:02:09.0: Failed to initialize adapter
Apr 18 16:02:08 localhost kernel: [17180036.364000  ] scsi(6): Failed
to initialize adapter - Adapter flags 0.
Apr 18 16:02:08 localhost kernel: [17180036.364000] ACPI: PCI
interrupt for device 0000:02:09.0 disabled
Apr 18 16:02:08 localhost kernel: [17180036.364000 ] ACPI: PCI
interrupt for device 0000:02: 09.0 disabled
Apr 18 16:02:08 localhost kernel: [17180036.364000] ACPI: PCI
Interrupt 0000:02:0b.0[A] -> GSI 23 (level, low) -> IRQ 19
Apr 18 16:02:08 localhost kernel: [17180036.364000] qla2xxx
0000:02:0b.0: Found an ISP2312, irq 19, iobase 0xe00ee000
Apr 18 16:02:08 localhost kernel: [17180036.364000] qla2xxx
0000:02:0b.0: Configuring PCI space...
Apr 18 16:02:08 localhost kernel: [17180036.364000] qla2xxx
0000:02:0b.0: Configure NVRAM parameters...
