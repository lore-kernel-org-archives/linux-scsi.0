From: "Alexander Stohr" <Alexander.Stohr@gmx.de>
Subject: [BUG] Sym. 53c895 fails accessing tape device - kernel 2.9.1-rc1-bk1 trough rc2-bk12
Date: Wed, 29 Sep 2004 17:47:50 +0200 (MEST)
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <13842.1096472870@www69.gmx.net>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from pop.gmx.de ([213.165.64.20]:653 "HELO mail.gmx.net")
	by vger.kernel.org with SMTP id S268664AbUI2Prv (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Wed, 29 Sep 2004 11:47:51 -0400
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org
Cc: matthew@wil.cx, akpm@digeo.com, James.Bottomley@HansenPartnership.com

Hello,

with latest update to a test kernel,
i was suddenly unable to access the data on my backup tapes.

the problem is not present for kernel 2.6.8.1
but it is verified from 2.9.1-rc1-bk1 till rc2-bk12
with some spaces and some variations in error.

in the beginning it merely looks like this:
  kernel: st0: Incorrect block size.

then it changed slightly to this:
  kernel: sym1:4:0:phase change 6-7 9@37d30f84 resid=6. 
  kernel: sym1:4:0:phase change 6-7 9@37d30f84 resid=6. 
  kernel: st0: Block limits 1 - 16777215 bytes. 
  kernel: sym1:4:0:phase change 6-7 9@37d30f84 resid=6. 
  kernel: sym1:4:0:phase change 6-7 9@37d30f84 resid=6. 
  kernel: st0: Incorrect block size. 
  kernel: sym1:4:0:phase change 6-7 9@37d30f84 resid=6.

for the latest revisions i only do get this:
  kernel: sym0:1:0:phase change 6-7 11@37d45f84 resid=6. 
  last message repeated 8 times
with variations of this:
  kernel: sym0:1:0:phase change 6-7 11@37d45f84 resid=6. 
  kernel: sym0:1:0:phase change 6-7 11@37d45f84 resid=6. 
  kernel: sym0:1:0:phase change 6-7 9@37d45f90 resid=6. 
  kernel: sym0:1:0:phase change 6-7 11@37d45f84 resid=6. 
  kernel: sym0:1:0:phase change 6-7 11@37d45f84 resid=6. 
  kernel: sym0:1:0:phase change 6-7 9@37d45f90 resid=6. 
  kernel: scsi(0:0:1:0): Domain Validation skipping write tests 
  kernel: scsi(0:0:1:0): Ending Domain Validation 
  kernel: sym0:1:0:phase change 6-7 11@37d45f84 resid=6. 
  kernel: ACPI: PCI interrupt 0000:00:0d.0[A] -> GSI 17 (level, low) -> IRQ
17 
  kernel: sym1: <810a> rev 0x12 at pci 0000:00:0d.0 irq 17 
  kernel: sym1: No NVRAM, ID 7, Fast-10, SE, parity checking 
  kernel: sym1: SCSI BUS has been reset. 
  kernel: scsi1 : sym-2.1.18j

i just tried commands like this:
  mt status
  mt rewind
  mt asf 0
  mt asf 1
  tar -tvf /dev/tape
the last three are the ones that do raise the misc problems.

i tested this by just replacing the scsi subdir for the 53c8xx
of a 2.6.9-rc2-bk12 kernel with the misc implementations.
Those sources are absolutely interchangeable as i spotted
neither kernel build errors nor did i have any problems
when using the files from 2.6.8.1 at this location.

thats the host adapter info from proc filesystem:
  Chip sym53c895, device id 0xc, revision id 0x1                            
     
  At PCI address 0000:00:0c.0, IRQ 16                                       
     
  Min. period factor 10, Wide SCSI BUS                                      
     
  Max. started commands 448, max. commands per LUN 32

and this is the bus information on devices:
Host: scsi0 Channel: 00 Id: 00 Lun: 00
  Vendor: IBM      Model: IC35L036UWPR15-0 Rev: S70H
  Type:   Direct-Access                    ANSI SCSI revision: 03
Host: scsi0 Channel: 00 Id: 01 Lun: 00
  Vendor: IBM-PSG  Model: DRHS36D       !# Rev: 0272
  Type:   Direct-Access                    ANSI SCSI revision: 03
Host: scsi1 Channel: 00 Id: 04 Lun: 00
  Vendor: SEAGATE  Model: DAT    9SP40-000 Rev: 910B
  Type:   Sequential-Access                ANSI SCSI revision: 03

The device is accessed via /dev/nst0, meaning the 
SCSI tape device without autmatic rewind.

I hope that is enough for you to understand whats
going odd in the recent versions of the kernel.
If you do need further information or do want me
to assist you in more advanced diagnostings
on that machine it should be feasible. I am able
to hack kernel code, but just the SCSI part is
an area where my understanding of the system
should get deepened somewhat, especially for that
changes you applied since the very last kernel release.

-Alex.

PS: please CC me on replys, i am not subscribed to the list.

-- 
GMX ProMail mit bestem Virenschutz http://www.gmx.net/de/go/mail
+++ Empfehlung der Redaktion +++ Internet Professionell 10/04 +++

