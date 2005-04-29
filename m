From: Kumba <kumba@gentoo.org>
Subject: qla1280 and SGI Octane (IP30)
Date: Fri, 29 Apr 2005 00:04:11 -0400
Message-ID: <4271B23B.3030006@gentoo.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from sccrmhc11.comcast.net ([204.127.202.55]:49325 "EHLO
	sccrmhc11.comcast.net") by vger.kernel.org with ESMTP
	id S262324AbVD2ECZ (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Fri, 29 Apr 2005 00:02:25 -0400
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org


Hi all,

Since it looks like qlogicisp will soon be going to that great null device in 
the sky, I thought I'd poke around at getting the qla1280 driver to work on 
SGI Octane.  Now I'm not much of a hacker -- more of a tinkerer, so while I 
haven't had alot of luck actually getting the thing to work, I have managed to 
extract what may be useful information that someone on this list can use to 
point out the specific bug(s) or offer advice on what may be messing up on 
this system.

The Octane (IP30) is very similar in design (internals atleast) to the Origin 
(IP27).  It's got an IOC3, uses Qlogic 1040 chips, has XTalk and a Router chip 
(XBow).  To make matters more fun, qlogicisp on Octane slaps a few limitations 
on; number 1 being you can only use a single disk on the internal bus.  Adding 
another disk won't neccessarily kill the system -- things like mke2fs and dd 
will happily write the second or third disk quite fine.  But try copying data 
from disk 1 to disk 2, and things start to go very bad very quickly.  Namely, 
Cmnd == NULL, and death results soon after (this is in 
isp1020_intr_handler()).  The other discovered oddity, is the external bus 
will not recognize scsi disks attached to it.  It'll see and use an external 
scsi cdrom, but just ignores disks.  Not determined why this is.

I found some mentions of the first problem on google that's happened 
throughout the years (i.e., on alpha), but no bonafide solutions were 
discovered that seemed applicable to Octane itself.  About the only real 
solution suggessted was to migrate to qla1280, which apparently worked 
out-of-the-box for most people that switched to it.  Thing is, from what I've 
read, qla1280 won't work correctly on Origin equipment, and given the 
similarities between the two systems, I'll wager that whatever problems plague 
Origin also apply to Octane.

To start, I poked around the qlogicisp driver to look at the changes Octane's 
patch [1], and have definitely noticed that qla1280 is a much better designed 
driver.  Where Octane needed several #ifdef hacks to qlogicisp, it needed only 
one to qla1280:

--- 1   2005-04-28 23:35:02.221760792 -0400
+++ 2   2005-04-28 23:36:19.172062568 -0400
@@ -433,7 +433,11 @@
  #endif

  #ifdef QLA_64BIT_PTR
-#define pci_dma_hi32(a)                        ((a >> 16) >> 16)
+# ifdef CONFIG_SGI_IP30
+#  define pci_dma_hi32(a)                      (((a >> 16) >> 16) | 0x88000000);
+# else
+#  define pci_dma_hi32(a)                      ((a >> 16) >> 16)
+# endif
  #else
  #define pci_dma_hi32(a)                        0
  #endif


With this applied, the driver can see the 1040 chip in Octane (otherwise it 
sees nothing), but that's really about it.  It appears to not be able to 
actually talk to the disks and retrieve their partition data:

qla1280: QLA1040 found on PCI bus 0, dev 0
PCI: Enabling device 0000:00:00.0 (0006 -> 0007)
scsi(0:0): Resetting SCSI BUS
scsi0 : QLogic QLA1040 PCI to SCSI Host Adapter
        Firmware version:  7.65.00, Driver version 3.25
   Vendor: FUJITSU   Model: MAA3182SCX        Rev: 2411
   Type:   Direct-Access                      ANSI SCSI revision: 02
scsi(0:0:1:0): Sync: period 10, offset 12, Wide, Tagged queuing: depth 255
   Vendor: SEAGATE   Model: SX150176LC        Rev: BA08
   Type:   Direct-Access                      ANSI SCSI revision: 02
scsi(0:0:2:0): Sync: period 10, offset 12, Wide, Tagged queuing: depth 255
qla1280: QLA1040 found on PCI bus 0, dev 1
PCI: Enabling device 0000:00:01.0 (0006 -> 0007)
scsi(1:0): Resetting SCSI BUS
scsi1 : QLogic QLA1040 PCI to SCSI Host Adapter
        Firmware version:  7.65.00, Driver version 3.25
scsi(0): Resetting Cmnd=0xa8000000207a2d00, Handle=0x0000000000000001, action=0x0
scsi(0): Resetting Cmnd=0xa8000000207a2d00, Handle=0x0000000000000001, action=0x0
scsi(0): Resetting Cmnd=0xa8000000207a2d00, Handle=0x0000000000000202, action=0x2
scsi(0:0:1:0): Queueing device reset command.
scsi(0): Resetting Cmnd=0xa8000000207a2d00, Handle=0x0000000000000001, action=0x0
scsi(0): Resetting Cmnd=0xa8000000207a2d00, Handle=0x0000000000000202, action=0x3
qla1280(0:0): Issuing BUS DEVICE RESET
scsi(0:1): Resetting SCSI BUS
scsi(0): Resetting Cmnd=0xa8000000207a2d00, Handle=0x0000000000000202, action=0x4
scsi(0): Issued ADAPTER RESET
scsi(0): I/O processing will continue automatically
scsi(0): dequeuing outstanding commands
scsi(0:0): Resetting SCSI BUS
scsi: Device offlined - not ready after error recovery: host 0 channel 0 id 1 
lun 0
scsi0 (1:0): rejecting I/O to offline device
scsi0 (1:0): rejecting I/O to offline device
scsi0 (1:0): rejecting I/O to offline device

I haven't really gotten beyond this point.  I've tried many things, including 
turning on verbose debug and digging up lots of random patches to qla1280:

1) States Origin PCI Subsystem can't do MMIO
http://ente.limmat.ch/ftp/pub/alpha/2.6.8-kernel-patch-qlogic/qlogic_ext3.patch

2) Merges qla1280_queuecommand and qla1280_{32,64}bit_start_scsi together
http://www.trained-monkey.org/jes/linux/2.6.5-rc2-mm3-qla1280-2.diff

3) Has a new revision of 1040 firmware (7.65.06)
http://parisc-linux.org/~jejb/scsi_diffs/scsi-misc-2.6.diff



None really made any difference, so I suspect the problem is in one of two places:

A) Origin/Octane PCI code just not working correctly and thus not letting the 
driver talk properly.

B) Bug in the driver that doesn't account for some quirk in Origin/Octane in a 
manner that lets it talk after discovering devices.

If anyone here has ideas, patches, pointers, shots in the dark; I'm all ears 
and up for trying anything.  With qlogicisp marked as BROKEN now, I figure 
it'll get pulled around 2.6.13 or 2.6.14, so there's not alot of time to get 
the qla1280 driver working on these two systems.  Plus I'd like to use more 
than one disk for once :)


Regards,


--Kumba

[1]: http://skylark.cs.put.poznan.pl/ip30/


-- 
"Such is oft the course of deeds that move the wheels of the world: small 
hands do them because they must, while the eyes of the great are elsewhere." 
--Elrond
