From: "Heinzmann, Robert" <Heinzmann@cc-dresden.de>
Subject: sym53c8xx module parameter passing not working (2.5.6)
Date: Thu, 30 Sep 2004 16:41:09 +0200
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <7AAD212492598A4A92463C3F5D34C54F194EA1@ccd3.CC.de>
Mime-Version: 1.0
Content-Type: text/plain;
	charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mxl.tiscali.de ([194.162.162.200]:18184 "EHLO mxl.tiscali.de")
	by vger.kernel.org with ESMTP id S268708AbUI3OlM convert rfc822-to-8bit
	(ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Thu, 30 Sep 2004 10:41:12 -0400
Received: from mail2.cc-dresden.de (port-212-202-119-51.static.qsc.de [212.202.119.51])
	by mxl.tiscali.de (Postfix) with ESMTP id 9A0C76392
	for <linux-scsi@vger.kernel.org>; Thu, 30 Sep 2004 16:41:11 +0200 (CEST)
Received: from ccd3.CC.de (localhost.localdomain [127.0.0.1])
	by mail2.cc-dresden.de (8.11.6/8.11.6) with ESMTP id i8UEfAK01994
	for <linux-scsi@vger.kernel.org>; Thu, 30 Sep 2004 16:41:10 +0200
Content-class: urn:content-classes:message
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org

Hello, 

we have a problem setting the "hostid:" parameter on the command line of
the sym53c8xx.

Problem: 

We have a shared SCSI cluster with sym53c8xx controllers. 
Machine 1 = ID 6 in NVRAM, Machine 2 = ID 7 in NVRAM.
In 2.4.X (19-21) we used the command line option "sym53c8xx=hostid:6"
for the sym53c8xx.o driver to set the ID on one node, because the driver
does not read the NVRAM right. 
In 2.6.5 we try to do the same with the sym53c8xx_2 driver, but the
controller always gets ID 7.  (see below)

I (tried!) to read the source code without suchess. It seems that
sym53c8xx_setup (which reads the command line etc.) is never called in
the new driver. In the old one it called: 

--> sym53c8xx_2/sym_glue.c
2749 #ifdef SYM_LINUX_BOOT_COMMAND_LINE_SUPPORT
2750 #ifdef MODULE
2751 if (sym53c8xx)
2752         sym53c8xx_setup(sym53c8xx);
2753 #endif

Also I have changed the MODULE_PARM to module_param, which is the new
code of 2.6.X. Some "printk" showed that the command line string is
passed correctly.

Can you give me a hint where the old sym53c8xx_setup has gone or how I
can set the hostid: parameter ? 

Thank you very much, 

Robert Heinzmann

--------- Machine description -----------
# uname -a
Linux cl380a 2.6.5-7.97-default #1 Fri Jul 2 14:21:59 UTC 2004 i686 i686
i386 GNU/Linux

Symbios driver version: sym-2.1.18i

# cat /proc/cpuinfo
processor       : 0
vendor_id       : GenuineIntel
cpu family      : 6
model           : 8
model name      : Pentium III (Coppermine)
stepping        : 6
cpu MHz         : 997.393
cache size      : 256 KB
fdiv_bug        : no
hlt_bug         : no
f00f_bug        : no
coma_bug        : no
fpu             : yes
fpu_exception   : yes
cpuid level     : 2
wp              : yes
flags           : fpu vme de pse tsc msr pae mce cx8 sep mtrr pge mca
cmov pat pse36 mmx fxsr sse
bogomips        : 1970.17

# cat /proc/scsi/scsi
Attached devices:
Host: scsi0 Channel: 00 Id: 02 Lun: 00
  Vendor: Compaq   Model: CR3500           Rev: x2q
  Type:   RAID                             ANSI SCSI revision: 02
Host: scsi0 Channel: 00 Id: 02 Lun: 01
  Vendor: Compaq   Model: CR3500           Rev: x2q
  Type:   Direct-Access                    ANSI SCSI revision: 02
Host: scsi0 Channel: 00 Id: 02 Lun: 02
  Vendor: Compaq   Model: CR3500           Rev: x2q
  Type:   Direct-Access                    ANSI SCSI revision: 02
Host: scsi0 Channel: 00 Id: 02 Lun: 03
  Vendor: Compaq   Model: CR3500           Rev: x2q
  Type:   Direct-Access                    ANSI SCSI revision: 02
Host: scsi0 Channel: 00 Id: 03 Lun: 00
  Vendor: Compaq   Model: CR3500           Rev: x2q
  Type:   RAID                             ANSI SCSI revision: 02

# cat /proc/scsi/sym53c8xx/0
Chip sym53c896, device id 0xb, revision id 0x7
At PCI address 0000:03:04.0, IRQ 10
Min. period factor 10, Wide SCSI BUS
Max. started commands 448, max. commands per LUN 64

# cat /proc/scsi/sym53c8xx/1
Chip sym53c896, device id 0xb, revision id 0x7
At PCI address 0000:03:04.1, IRQ 11
Min. period factor 10, Wide SCSI BUS
Max. started commands 448, max. commands per LUN 64

# insmod
/lib/modules/2.6.5-7.97-default/kernel/drivers/scsi/sym53c8xx_2/sym53c8x
x.ko sym53c8xx=hostid:6

# dmesg
sym0: <896> rev 0x7 at pci 0000:03:04.0 irq 10
sym0: using 64 bit DMA addressing
sym0: No NVRAM, ID 7, Fast-40, LVD, parity checking
sym0: SCSI BUS has been reset.
scsi2 : sym-2.1.18i
scsi: unknown device type 12
  Vendor: Compaq    Model: CR3500            Rev: x2q
  Type:   RAID                               ANSI SCSI revision: 02
sym0:2:0: tagged command queuing enabled, command queue depth 16.
Attached scsi generic sg0 at scsi2, channel 0, id 2, lun 0,  type 12
  Vendor: Compaq    Model: CR3500            Rev: x2q
  Type:   Direct-Access                      ANSI SCSI revision: 02
sym0:2:1: tagged command queuing enabled, command queue depth 16.
sym0:2: FAST-20 WIDE SCSI 40.0 MB/s ST (50.0 ns, offset 15)
SCSI device sda: 17762304 512-byte hdwr sectors (9094 MB)
SCSI device sda: drive cache: write through
 sda: sda1
Attached scsi disk sda at scsi2, channel 0, id 2, lun 1
Attached scsi generic sg1 at scsi2, channel 0, id 2, lun 1,  type 0
  Vendor: Compaq    Model: CR3500            Rev: x2q
  Type:   Direct-Access                      ANSI SCSI revision: 02
sym0:2:2: tagged command queuing enabled, command queue depth 16.
SCSI device sdb: 121634816 512-byte hdwr sectors (62277 MB)
SCSI device sdb: drive cache: write through
 sdb: sdb1
Attached scsi disk sdb at scsi2, channel 0, id 2, lun 2
Attached scsi generic sg2 at scsi2, channel 0, id 2, lun 2,  type 0
  Vendor: Compaq    Model: CR3500            Rev: x2q
  Type:   Direct-Access                      ANSI SCSI revision: 02
sym0:2:3: tagged command queuing enabled, command queue depth 16.
SCSI device sdc: 20617216 512-byte hdwr sectors (10556 MB)
SCSI device sdc: drive cache: write through
 sdc: sdc1
Attached scsi disk sdc at scsi2, channel 0, id 2, lun 3
Attached scsi generic sg3 at scsi2, channel 0, id 2, lun 3,  type 0
scsi: unknown device type 12
  Vendor: Compaq    Model: CR3500            Rev: x2q
  Type:   RAID                               ANSI SCSI revision: 02
sym0:3:0: tagged command queuing enabled, command queue depth 16.
Attached scsi generic sg4 at scsi2, channel 0, id 3, lun 0,  type 12
sym1: <896> rev 0x7 at pci 0000:03:04.1 irq 11
sym1: using 64 bit DMA addressing
sym1: No NVRAM, ID 7, Fast-40, LVD, parity checking
sym1: SCSI BUS has been reset.
scsi3 : sym-2.1.18i
