From: "Randy.Dunlap" <rddunlap@osdl.org>
Subject: Fw: 2.6.7 scsi regression
Date: Thu, 17 Jun 2004 11:39:08 -0700
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <20040617113908.0fa1f887.rddunlap@osdl.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from fw.osdl.org ([65.172.181.6]:61092 "EHLO mail.osdl.org")
	by vger.kernel.org with ESMTP id S261704AbUFQSlc (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Thu, 17 Jun 2004 14:41:32 -0400
List-Id: linux-scsi@vger.kernel.org
To: scsi <linux-scsi@vger.kernel.org>
Cc: kernel@linuxace.com



[should be on linux-scsi:]

Willy says the patch you want is probably:
http://linux-scsi.bkbits.net:8080/scsi-misc-2.6/gnupatch@40cf3658X57h5m24maf1efBL-aVHPw

~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
2.6.7 won't boot on a box with a sym53c896 scsi controller, but boots fine
on 2.6.6.  Dmesg output below.

2.6.6:

sym0: <896> rev 0x5 at pci 0000:00:0b.0 irq 17
sym0: using 64 bit DMA addressing
sym0: Symbios NVRAM, ID 7, Fast-40, LVD, parity checking
sym0: open drain IRQ line driver, using on-chip SRAM
sym0: using LOAD/STORE-based firmware.
sym0: handling phase mismatch from SCRIPTS.
sym0: SCSI BUS has been reset.
scsi0 : sym-2.1.18j
Using anticipatory io scheduler
  Vendor: IBM       Model: DDYS-T09170N      Rev: S80D
  Type:   Direct-Access                      ANSI SCSI revision: 03
sym0:0:0: tagged command queuing enabled, command queue depth 16.
scsi(0:0:0:0): Beginning Domain Validation
sym0:0: wide asynchronous.
sym0:0: FAST-40 WIDE SCSI 80.0 MB/s ST (25.0 ns, offset 31)
scsi(0:0:0:0): Domain Validation skipping write tests
scsi(0:0:0:0): Ending Domain Validation


2.6.7:

sym0: <896> rev 0x5 at pci 0000:00:0b.0 irq 17
sym0: using 64 bit DMA addressing
sym0: Symbios NVRAM, ID 7, Fast-40, LVD, parity checking
sym0: open drain IRQ line driver, using on-chip SRAM
sym0: using LOAD/STORE-based firmware.
sym0: handling phase mismatch from SCRIPTS.
sym0: SCSI BUS has been reset.
scsi0 : sym-2.1.18j
Using anticipatory io scheduler
  Vendor: IBM       Model: DDYS-T09170N      Rev: S80D
  Type:   Direct-Access                      ANSI SCSI revision: 03
sym0:0:0: tagged command queuing enabled, command queue depth 16.
scsi(0:0:0:0): Beginning Domain Validation
sym0:0: wide asynchronous.
sym0:0: FAST-40 WIDE SCSI 80.0 MB/s ST (25.0 ns, offset 31)
scsi(0:0:0:0): Echo buffer size 6552 is too big, trimming to 4096
scsi(0:0:0:0): Write Buffer failure 8000002
scsi(0:0:0:0): Domain Validation detected failure, dropping back
sym0:0: FAST-20 WIDE SCSI 40.0 MB/s ST (50.0 ns, offset 31)
scsi(0:0:0:0): Write Buffer failure 8000002
scsi(0:0:0:0): Domain Validation detected failure, dropping back
sym0:0: FAST-20 WIDE SCSI 38.5 MB/s ST (52.0 ns, offset 31)
scsi(0:0:0:0): Write Buffer failure 8000002
scsi(0:0:0:0): Domain Validation detected failure, dropping back
sym0:0: FAST-20 WIDE SCSI 26.3 MB/s ST (76.0 ns, offset 31)
scsi(0:0:0:0): Write Buffer failure 8000002
scsi(0:0:0:0): Domain Validation detected failure, dropping back
sym0:0: FAST-10 WIDE SCSI 17.9 MB/s ST (112.0 ns, offset 31)
scsi(0:0:0:0): Write Buffer failure 8000002
scsi(0:0:0:0): Domain Validation detected failure, dropping back
sym0:0: FAST-10 WIDE SCSI 11.9 MB/s ST (168.0 ns, offset 31)
scsi(0:0:0:0): Write Buffer failure 8000002
scsi(0:0:0:0): Domain Validation detected failure, dropping back
sym0:0: FAST-5 WIDE SCSI 7.9 MB/s ST (252.0 ns, offset 31)
scsi(0:0:0:0): Write Buffer failure 8000002
scsi(0:0:0:0): Domain Validation detected failure, dropping back
sym0:0: wide asynchronous.
sym0:0:0:M_REJECT to send for : 1-3-1-5e-1f.
scsi(0:0:0:0): Write Buffer failure 8000002
....

This goes on forever - goes through all different speeds, then starts over.

Difference seems to be in 2.6.6, it says:

scsi(0:0:0:0): Domain Validation skipping write tests

but does not skip these tests in 2.6.7.

Ideas?


Phil Oester

-
To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
Please read the FAQ at  http://www.tux.org/lkml/


--
~Randy
