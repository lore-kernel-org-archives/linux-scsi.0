From: Zack Weinberg <zack@codesourcery.com>
Subject: Qlogic isp1040 with 2.4.21-rc1 (x86): driver won't load
Date: Sun, 04 May 2003 11:49:17 -0700
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <871xzeeedu.fsf@egil.codesourcery.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from egil.codesourcery.com ([66.92.14.122]:28032 "EHLO
	egil.codesourcery.com") by vger.kernel.org with ESMTP
	id S261591AbTEDSgt (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Sun, 4 May 2003 14:36:49 -0400
Received: from zack by egil.codesourcery.com with local (Exim 3.36 #1 (Debian))
	id 19COY1-00009n-00
	for <linux-scsi@vger.kernel.org>; Sun, 04 May 2003 11:49:17 -0700
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org


I am trying to use a Qlogic isp1040 board with 2.4.21-rc1 (x86).
lspci says:

00:09.0 SCSI storage controller: QLogic Corp. ISP1020 Fast-wide SCSI (rev 05)
        Control: I/O+ Mem+ BusMaster+ SpecCycle- MemWINV+ VGASnoop-
                 ParErr- Stepping- SERR- FastB2B-
        Status: Cap- 66Mhz- UDF- FastB2B- ParErr- DEVSEL=medium
                >TAbort+ <TAbort- <MAbort- >SERR- <PERR-
        Latency: 32, cache line size 08
        Interrupt: pin A routed to IRQ 5
        Region 0: I/O ports at b800 [size=256]
        Region 1: Memory at e0000000 (32-bit, non-prefetchable) [size=4K]
        Expansion ROM at <unassigned> [disabled] [size=64K]

I believe that qlogicisp.o is the correct driver for this board.  When
I try to load it, most of the time I get these error messages:

isp1020 : entering isp1020_detect()
PCI: Found IRQ 5 for device 00:09.0
isp1020 : entering isp1020_init()
qlogicisp : new isp1020 revision ID (5)
isp1020 : leaving isp1020_init()
isp1020 : entering isp1020_reset_hardware()
qlogicisp : mbox 0 0x0004 
qlogicisp : mbox 1 0x4953 
qlogicisp : mbox 2 0x5020 
qlogicisp : mbox 3 0x2020 
qlogicisp : mbox 4 0x0001 
qlogicisp : mbox 5 0x0005 
qlogicisp : loading risc ram
qlogicisp : verifying checksum
qlogicisp : executing firmware
qlogicisp : about firmware failure [4001]
isp1020 : leaving isp1020_detect()

This is with RELOAD_FIRMWARE, DEBUG_ISP1020, and DEBUG_ISP1020_SETUP
set to 1 in qlogicisp.c, and additionally with the "about firmware
failure" printk augmented to print the error code.  Code 4001 is
INVALID_COMMAND according to the list of mailbox status codes, which
seems decidedly odd.

Sometimes I get a different failure mode instead:

isp1020 : entering isp1020_detect()
PCI: Found IRQ 5 for device 00:09.0
isp1020 : entering isp1020_init()
qlogicisp : new isp1020 revision ID (5)
isp1020 : leaving isp1020_init()
isp1020 : entering isp1020_reset_hardware()
qlogicisp : mbox 0 0x0004 
qlogicisp : mbox 1 0x4953 
qlogicisp : mbox 2 0x5020 
qlogicisp : mbox 3 0x2020 
qlogicisp : mbox 4 0x0001 
qlogicisp : mbox 5 0x0005 
qlogicisp : loading risc ram
qlogicisp : verifying checksum
qlogicisp : executing firmware
qlogicisp : firmware major revision 2
qlogicisp : firmware minor revision 26
isp1020 : leaving isp1020_reset_hardware()
isp1020 : entering isp1020_set_defaults()
isp1020 : leaving isp1020_set_defaults()
isp1020 : entering isp1020_load_parameters()
isp1020 : leaving isp1020_load_parameters()
isp1020 : leaving isp1020_detect()
isp1020 : entering isp1020_info()
isp1020 : leaving isp1020_info()
scsi0 : QLogic ISP1020 SCSI on PCI bus 00 device 48 irq 5 MEM base 0xe091f000
isp1020 : entering isp1020_queuecommand()
qlogicisp : target = 0x00, lun = 0x00, cmd_len = 0x06
qlogicisp : command = 0x12 0x00 0x00 0x00 0xff 0x00 
qlogicisp : request queue depth 62
isp1020 : leaving isp1020_queuecommand()
scsi : aborting command due to timeout : pid 0, scsi0, channel 0, id 0, lun 0 In
quiry 00 00 00 ff 00 
isp1020 : entering isp1020_abort()
isp1020 : leaving isp1020_abort()
scsi : aborting command due to timeout : pid 0, scsi0, channel 0, id 0, lun 0 In
quiry 00 00 00 ff 00 
isp1020 : entering isp1020_abort()
qlogicisp : scsi abort failure: 4005
SCSI host 0 abort (pid 0) timed out - resetting
SCSI bus is being reset for host 0 channel 0.
isp1020 : entering isp1020_reset()
qlogicisp : scsi bus reset failure: 4005
isp1020 : leaving isp1020_reset()
SCSI host 0 channel 0 reset (pid 0) timed out - trying harder
SCSI bus is being reset for host 0 channel 0.

[repeat until machine rebooted]

Code 4005 is COMMAND_ERROR.  I am not sure what conditions trigger
this second failure mode; it *might* be "there's a powered-up device
other than the HBA on the SCSI bus."

Other information: The card is detected by the system BIOS, and the
adapter BIOS configuration utility (Fast!somethingorother) works.
When I've got the only other device on the bus (a DLT drive) turned
on, a bus scan from the adapter BIOS sees it.  However, the DOS-based
flash update utility I downloaded from Qlogic's web site insists that
there are no isp1xxx cards installed in the computer.

Any advice would be helpful.  Please cc: me on replies.

zw
