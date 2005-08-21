From: mikep <mikpolniak@adelphia.net>
Subject: Symbios failure at full speed with kernel-2.6.13.rc6-mm1
Date: Sun, 21 Aug 2005 16:01:12 -0400
Message-ID: <4308DD88.4030308@adelphia.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from zeus1.kernel.org ([204.152.191.4]:60105 "EHLO zeus1.kernel.org")
	by vger.kernel.org with ESMTP id S1751101AbVHUVMO (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Sun, 21 Aug 2005 17:12:14 -0400
Received: from mta13.adelphia.net (mta13.adelphia.net [68.168.78.44])
	by zeus1.kernel.org (8.13.1/8.13.1) with ESMTP id j7LK51d8004578
	for <linux-scsi@vger.kernel.org>; Sun, 21 Aug 2005 13:05:02 -0700
Received: from [192.168.0.8] (really [69.161.69.17]) by mta13.adelphia.net
          (InterMail vM.6.01.04.01 201-2131-118-101-20041129) with ESMTP
          id <20050821200111.SZDL14360.mta13.adelphia.net@[192.168.0.8]>
          for <linux-scsi@vger.kernel.org>; Sun, 21 Aug 2005 16:01:11 -0400
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org

I am using a LSIU160/Symbios 53c1010 Ultra3 scsi adapter and it works at 
full speed (75 MB/sec) with kernel-2.6.12. And dmesg shows:

kernel:  target0:0:0: Beginning Domain Validation
kernel:  target0:0:0: asynchronous.
kernel: WIDTH IS 1
kernel:  target0:0:0: wide asynchronous.
kernel:  target0:0:0: FAST-80 WIDE SCSI 160.0 MB/s DT (12.5 ns, offset 62)
kernel:  target0:0:0: Ending Domain Validation
kernel: sym1: <1010-33> rev 0x1 at pci 0000:01:07.1 irq 11
kernel: sym1: Symbios NVRAM, ID 7, Fast-80, SE, parity checking
kernel: sym1: open drain IRQ line driver
kernel: sym1: using LOAD/STORE-based firmware.
kernel: sym1: handling phase mismatch from SCRIPTS.
kernel: sym1: SCSI BUS has been reset.
kernel: scsi1 : sym-2.2.0
kernel: libata version 1.11 loaded.

With kernel-2.6.13-rc6-mm1 the speed drops back to 2.70 MB/sec because 
of validation failure and dmesg shows:

kernel:  target0:0:0: Beginning Domain Validation
kernel:  target0:0:0: asynchronous.
kernel:  target0:0:0: wide asynchronous.
kernel:  target0:0:0: FAST-80 WIDE SCSI 160.0 MB/s DT IU QAS (
kernel: sym0: unexpected disconnect
kernel:  target0:0:0: Write Buffer failure 700ff
kernel:  target0:0:0: Domain Validation Disabing Information units
kernel:  0:0:0:0: phase change 6-7 11@3fb3c3a8 resid=10.
kernel:  target0:0:0: asynchronous.
kernel: sym0: unexpected disconnect
target0:0:0: Write Buffer failure 700ff
target0:0:0: Domain Validation detected failure, dropping back
kernel:  target0:0:0: asynchronous.
target0:0:0: Ending Domain Validation
kernel: sym1: <1010-33> rev 0x1 at pci 0000:01:07.1 irq 11
kernel: sym1: Symbios NVRAM, ID 7, Fast-80, SE, parity checkingkernel: 
sym1:
open drain IRQ line driver, using on-chip SRAM
kernel: sym1: using LOAD/STORE-based firmware.
kernel: sym1: handling phase mismatch from SCRIPTS.
kernel: sym1: SCSI BUS has been reset.
kernel: scsi1 : sym-2.2.1
kernel: libata version 1.11 loaded.

The kernel config has:

CONFIG_SCSI_SYM53C8XX_2=y
CONFIG_SCSI_SYM53C8XX_DMA_ADDRESSING_MODE=1
CONFIG_SCSI_SYM53C8XX_DEFAULT_TAGS=16
CONFIG_SCSI_SYM53C8XX_MAX_TAGS=64
# CONFIG_SCSI_SYM53C8XX_IOMAPPED is not set

