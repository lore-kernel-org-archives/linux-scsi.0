From: Andrew Morton <akpm@osdl.org>
Subject: Fw: [Bugme-new] [Bug 4005] New: qla1280: Doesn't actually work for
 QLogic ISP1020 behind DEC 1050 PCI-PCI bridge
Date: Fri, 7 Jan 2005 15:47:56 -0800
Message-ID: <20050107154756.3d628769.akpm@osdl.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from fw.osdl.org ([65.172.181.6]:20972 "EHLO mail.osdl.org")
	by vger.kernel.org with ESMTP id S261700AbVAGXnU (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Fri, 7 Jan 2005 18:43:20 -0500
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org
Cc: theos@unforgettable.com



Begin forwarded message:

Date: Fri, 7 Jan 2005 15:26:24 -0800
From: bugme-daemon@osdl.org
To: bugme-new@lists.osdl.org
Subject: [Bugme-new] [Bug 4005] New: qla1280: Doesn't actually work for QLogic ISP1020 behind DEC 1050 PCI-PCI bridge


http://bugme.osdl.org/show_bug.cgi?id=4005

           Summary: qla1280: Doesn't actually work for QLogic ISP1020 behind
                    DEC 1050 PCI-PCI bridge
    Kernel Version: 2.6.10
            Status: NEW
          Severity: blocking
             Owner: andmike@us.ibm.com
         Submitter: theos@unforgettable.com


Distribution: Gentoo Linux 2004.x

Hardware Environment:
CPU: DEC 21164 EV5 at 266Mhz
System: DEC 21171 Alcor
Digital KZPSM SCSI and Ethernet card
PCI to PCI bridge: DEC 21050
RAM: 1GB

Software Environment:
Linus 2.6.10, / on SCSI drive, qla1280 drive enabled with support for ISP1020/1040.

Problem Description:
No happy booting and using the ISP1020. Instead, I get:
qla1280: QLA1040 found on PCI bus 1, dev 1
qla1280: Failed mbox check
qla1280_mailbox_command: Command failed, mailbox0 = 0x0007, 
mailbox_out0 = 0x4003, istatus = 0x0000
m0 4003, m1 aaaa, m2 0000, m3 aa55
m4 55aa, m5 a5a5, m6 a5a5, m7 a5a5
scsi(0): Failed checksum
scsi(0): initialize: pci probe failed!
qla1x160: Failed to initialize adapter
qla1280: QLA1040 found on PCI bus 1, dev 2
qla1280: Failed mbox check
qla1280_mailbox_command: Command failed, mailbox0 = 0x0007, 
mailbox_out0 = 0x4003, istatus = 0x0000
m0 4003, m1 aaaa, m2 0000, m3 aa55
m4 55aa, m5 a5a5, m6 a5a5, m7 a5a5
scsi(0): Failed checksum
scsi(0): initialize: pci probe failed!
qla1x160: Failed to initialize adapter

According to lspci, I have:
0000:00:08.0 PCI bridge: Digital Equipment Corporation DECchip 21050 (rev 02)
0000:01:00.0 Ethernet controller: Digital Equipment Corporation DECchip 21040 [Tulip] (rev 23)
0000:01:01.0 SCSI storage controller: QLogic Corp. ISP1020 Fast-wide SCSI (rev 01)
0000:01:02.0 SCSI storage controller: QLogic Corp. ISP1020 Fast-wide SCSI (rev 01)
Numerically:
0000:00:08.0 Class 0604: 1011:0001 (rev 02)
0000:01:00.0 Class 0200: 1011:0002 (rev 23)
0000:01:01.0 Class 0100: 1077:1020 (rev 01)
0000:01:02.0 Class 0100: 1077:1020 (rev 01)

I have no idea whether the problem is with the ISP1020 or the DEC 21050. According to the FreeBSD 
documentation, the 21050 "does not allow I/O port mapping, therefore  all devices behind it must use 
memory mapping." At least the Ethernet part works.

Steps to reproduce:
Get something with an ISP1020, preferably AlphaStation 600 because that's what I have.
Boot it with Linux 2.6.10, qla1280 driver, ISP1020/1040 support.
See error messages go. See error messages go off the screen if you're enabling support for trivial things 
like the EISA bus.

------- You are receiving this mail because: -------
You are on the CC list for the bug, or are watching someone who is.
