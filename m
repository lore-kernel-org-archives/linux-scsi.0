From: Andrew Morton <akpm@osdl.org>
Subject: sym2 probs in current scsi bk
Date: Thu, 24 Jun 2004 19:33:11 -0700
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <20040624193311.6ea456c6.akpm@osdl.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from fw.osdl.org ([65.172.181.6]:43474 "EHLO mail.osdl.org")
	by vger.kernel.org with ESMTP id S266165AbUFYCeG (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Thu, 24 Jun 2004 22:34:06 -0400
Received: from bix (build.pdx.osdl.net [172.20.1.2])
	by mail.osdl.org (8.11.6/8.11.6) with SMTP id i5P2Y5Z08690
	for <linux-scsi@vger.kernel.org>; Thu, 24 Jun 2004 19:34:05 -0700
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org


One of my test boxes has sym2, and it is now hanging during boot.


sym0: <895> rev 0x2 at pci 0000:02:0c.0 irq 9
sym0: Symbios NVRAM, ID 7, Fast-40, SE, parity checking
sym0: SCSI BUS has been reset.
scsi0 : sym-2.1.18j
sym0:0:0: ABORT operation started.
sym0:0:0: ABORT operation timed-out.
sym0:0:0: DEVICE RESET operation started.
sym0:0:0: DEVICE RESET operation timed-out.
sym0:0:0: BUS RESET operation started.
sym0:0:0: BUS RESET operation timed-out.
sym0:0:0: HOST RESET operation started.
sym0: SCSI BUS has been reset.


(gdb) thread 1
[Switching to thread 1 (Thread 1)]#0  0xc0368341 in schedule () at kernel/sched.c:1075
(gdb) bt
#0  0xc0368341 in schedule () at kernel/sched.c:1075
#1  0xc0368406 in wait_for_completion (x=0xcff43bf4) at kernel/sched.c:2480
#2  0xc0273032 in scsi_wait_req (sreq=0xcff85800, cmnd=0xcff43c3c, buffer=0xc05d5e80, bufflen=36, timeout=5500, retries=0) at drivers/scsi/scsi_lib.c:262
#3  0xc0274bfb in scsi_probe_lun (sreq=0xcff85800, inq_result=0xc05d5e80 "", bflags=0xcff43c74) at drivers/scsi/scsi_scan.c:365
#4  0xc02751a5 in scsi_probe_and_add_lun (host=0xcff85c00, channel=0, id=3489159168, lun=3227344512, bflagsp=0xcff43ca8, sdevp=0xcff43cac, rescan=0) at drivers/scsi/scsi_scan.c:737
#5  0xc0275786 in scsi_scan_target (shost=0xcff85c00, channel=0, id=0, lun=0, rescan=0) at drivers/scsi/scsi_scan.c:1186
#6  0xc0275822 in scsi_scan_channel (shost=0xcff85c00, channel=0, id=0, lun=4294967295, rescan=0) at drivers/scsi/scsi_scan.c:1231
#7  0xc02758c0 in scsi_scan_host_selected (shost=0xcff85c00, channel=0, id=4294967295, lun=4294967295, rescan=0) at drivers/scsi/scsi_scan.c:1251
#8  0xc0275910 in scsi_scan_host (shost=0x0) at drivers/scsi/scsi_scan.c:1265
#9  0xc027b254 in sym2_probe (pdev=0xcfc70000, ent=0xc0459094) at drivers/scsi/sym53c8xx_2/sym_glue.c:2342
#10 0xc01e2919 in pci_device_probe_static (drv=0xc04591c0, pci_dev=0xcfc70000) at drivers/pci/pci-driver.c:241
#11 0xc01e2950 in __pci_device_probe (drv=0xc04591c0, pci_dev=0xcfc70000) at drivers/pci/pci-driver.c:261
#12 0xc01e2986 in pci_device_probe (dev=0x0) at drivers/pci/pci-driver.c:277
#13 0xc022620a in bus_match (dev=0xcfc70044, drv=0xc04591e4) at drivers/base/bus.c:272
#14 0xc02262f0 in driver_attach (drv=0xc04591e4) at drivers/base/bus.c:345
#15 0xc0226657 in bus_add_driver (drv=0xc04591e4) at drivers/base/bus.c:499
#16 0xc0226b2a in driver_register (drv=0x0) at drivers/base/driver.c:90
#17 0xc01e2b7c in pci_register_driver (drv=0xc04591c0) at drivers/pci/pci-driver.c:412
#18 0xc0591663 in sym2_init () at drivers/scsi/sym53c8xx_2/sym_glue.c:2540
#19 0xc057a904 in do_initcalls () at init/main.c:570
#20 0xc057a980 in do_basic_setup () at init/main.c:610
#21 0xc01004f2 in init (unused=0x0) at init/main.c:676
#22 0xc010428d in kernel_thread_helper () at arch/i386/kernel/process.c:251


Did someone change something which would cause this?
