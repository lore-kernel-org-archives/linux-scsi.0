From: "Vladimir G. Ivanovic" <vladimir@acm.org>
Subject: Re: [PATCH] fix sym2 negotiation
Date: Tue, 24 Aug 2004 13:48:55 -0700
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <200408242048.i7OKmtRQ002174@bach.leonora.org>
References: <20040824203914.GA25755@us.ibm.com>
Reply-To: "Vladimir G. Ivanovic" <vladimir@acm.org>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from dsl081-052-249.sfo1.dsl.speakeasy.net ([64.81.52.249]:48373
	"EHLO bach.leonora.org") by vger.kernel.org with ESMTP
	id S268303AbUHXUtW (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Tue, 24 Aug 2004 16:49:22 -0400
In-Reply-To: Your message of "Tue, 24 Aug 2004 13:39:14 PDT."
             <20040824203914.GA25755@us.ibm.com>
List-Id: linux-scsi@vger.kernel.org
To: Mike Anderson <andmike@us.ibm.com>
Cc: Olaf Hering <olh@suse.de>, James Bottomley <James.Bottomley@SteelEye.com>, willy@debian.org, SCSI Mailing List <linux-scsi@vger.kernel.org>, Anton Blanchard <anton@samba.org>

I don't know what an ACARD is, but I have similar issues when I boot my
SMP system (ASUS CUV4X-DLS).

   kernel: VFS: Mounted root (ext2 filesystem).
   kernel: SCSI subsystem initialized
   kernel: ACPI: PCI interrupt 0000:00:08.0[A] -> GSI 19 (level, low) -> IRQ 177
   kernel: sym0: <1010-33> rev 0x1 at pci 0000:00:08.0 irq 177
   kernel: sym0: using 64 bit DMA addressing
   kernel: sym0: Symbios NVRAM, ID 7, Fast-80, LVD, parity checking
   kernel: sym0: open drain IRQ line driver, using on-chip SRAM
   kernel: sym0: using LOAD/STORE-based firmware.
   kernel: sym0: handling phase mismatch from SCRIPTS.
   kernel: sym0: SCSI BUS has been reset.
   kernel: scsi0 : sym-2.1.18j
   kernel:   Vendor: QUANTUM   Model: ATLAS10K3_18_WLS  Rev: 020K
   kernel:   Type:   Direct-Access                      ANSI SCSI revision: 03
   kernel: sym0:6:0: tagged command queuing enabled, command queue depth 16.
   kernel: scsi(0:0:6:0): Beginning Domain Validation
   kernel: sym0:6: wide asynchronous.
   kernel: sym0:6: FAST-80 WIDE SCSI 160.0 MB/s DT (12.5 ns, offset 62)
   kernel: scsi(0:0:6:0): Ending Domain Validation
   kernel: SCSI device sda: 35916548 512-byte hdwr sectors (18389 MB)
   kernel: SCSI device sda: drive cache: write back
   kernel:  sda: sda1 sda2 sda3 sda4
   kernel: Attached scsi disk sda at scsi0, channel 0, id 6, lun 0
   kernel: ACPI: PCI interrupt 0000:00:08.1[B] -> GSI 16 (level, low) -> IRQ 185

-- 
Vladimir G. Ivanovic                        http://leonora.org/~vladimir
Palo Alto, CA 94306                                      +1 650 678 8014

>>>>> "ma" == Mike Anderson <andmike@us.ibm.com> writes:

    ma> 
    ma> Olaf Hering [olh@suse.de] wrote:
    >> On Sat, Aug 21, James Bottomley wrote:
    >> 
    >> > The problems with domain validation were just the tip of the iceberg in
    >> > the sym2 driver.  Most of its problems seem to come from an overly
    >> > complex set of negotiating rules, which I've swept away with this patch.
    >> 
    >> I see timeouts on the CDROM during boot with 2.6.8, they do not happen
    >> with our 2.6.5 based SLES9 kernel. This patch doesnt fix it, no idea if
    >> it was supposed to fix this sort of error.
    >> 
    >> PCI: Enabling device: (0003:61:01.0), cmd 143
    >> sym1: <875> rev 0x3 at pci 0003:61:01.0 irq 86
    >> sym1: No NVRAM, ID 7, Fast-20, SE, parity checking
    >> sym1: SCSI BUS has been reset.
    >> scsi1 : sym-2.1.18j
    >> sym1:5:0: ABORT operation started.
    >> sym1:5:0: ABORT operation timed-out.
    >> sym1:5:0: DEVICE RESET operation started.
    >> sym1:5:0: DEVICE RESET operation complete.
    >> sym1:5:control msgout: c.
    >> sym1: TARGET 5 has been reset.
    >> sym1:5:0: ABORT operation started.
    >> sym1:5:0: ABORT operation complete.
    >> sym1:5:0: BUS RESET operation started.
    >> sym1:5:0: BUS RESET operation complete.
    >> sym1: SCSI BUS reset detected.
    >> sym1: SCSI BUS has been reset.
    >> Vendor: IBM       Model: DROM00203         Rev: 7R41
    >> Type:   CD-ROM                             ANSI SCSI revision: 02
    >> scsi(1:0:5:0): Beginning Domain Validation
    >> sym1:5: wide asynchronous.
    >> sym1:5: FAST-20 WIDE SCSI 40.0 MB/s ST (50.0 ns, offset 14)
    >> scsi(1:0:5:0): Domain Validation skipping write tests
    >> scsi(1:0:5:0): Ending Domain Validation
    >> sr0: scsi3-mmc drive: 48x/48x cd/rw xa/form2 cdda tray
    >> Uniform CD-ROM driver Revision: 3.20
    >> Attached scsi CD-ROM sr0 at scsi1, channel 0, id 5, lun 0
    ma> 
    ma> I would guess this cdrom is behind a ACARD. We have had issues in
    ma> the past with negotiation / interaction between the ACARD and the sym. 
    ma> 
    ma> I currently do not have local access to a system with this config, but I
    ma> am asking around to see if I can get access to one.
    ma> 
    ma> -andmike
    ma> --
    ma> Michael Anderson
    ma> andmike@us.ibm.com
    ma> 
    ma> -
    ma> To unsubscribe from this list: send the line "unsubscribe linux-scsi" in
    ma> the body of a message to majordomo@vger.kernel.org
    ma> More majordomo info at  http://vger.kernel.org/majordomo-info.html
