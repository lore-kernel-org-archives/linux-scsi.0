From: Bjarne Thomsen <bjarne.b.thomsen@gmail.com>
Subject: Re: AIC79XX PCI-X SCSI mystery
Date: Sat, 28 Jul 2007 19:02:22 +0200
Message-ID: <1185642142.4753.12.camel@tycho.astronomy.dk>
References: <1185523030.7330.24.camel@tycho.astronomy.dk>
	 <86802c440707272339r1b9f5451wee321b9e3fa70833@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from ug-out-1314.google.com ([66.249.92.172]:47992 "EHLO
	ug-out-1314.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751807AbXG1RDV (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Sat, 28 Jul 2007 13:03:21 -0400
Received: by ug-out-1314.google.com with SMTP id j3so849895ugf
        for <linux-scsi@vger.kernel.org>; Sat, 28 Jul 2007 10:03:19 -0700 (PDT)
In-Reply-To: <86802c440707272339r1b9f5451wee321b9e3fa70833@mail.gmail.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Yinghai Lu <yhlu.kernel@gmail.com>
Cc: "Salyzyn, Mark" <mark_salyzyn@adaptec.com>, linux-scsi <linux-scsi@vger.kernel.org>

On Fri, 2007-07-27 at 23:39 -0700, Yinghai Lu wrote:
> On 7/27/07, Bjarne Thomsen <bjarne.b.thomsen@gmail.com> wrote:
> > I have a dual Opteron Tyan MB (S2885) with 4 PCI-X slots.
> > The 2 first slots can work up to 100 MHz, the last 2 up to 66 MHz.
> >
> > I have 2 PCI-X Adaptec SCSI controllers: 29160 and 39320A.
> > A SCSI disk is connected to port A on the 39320A.
> >
> > When I mount the 39320A in any of the 4 slots the system hangs
> > after a few seconds (with no error messages in syslog) when I
> > copy a directory with many files to the SCIS disk.
> >
> > However, when I mount both controllers in either slots 1 and 2
> > or slots 3 and 4 I can copy 25GB of files without any hang-up.
> >
> > I need some help to figure this out. It is a mystery to me.
> >
> 
> Could it be FW in 29160 is more new than that in 39320A?
> and when two cards installed, only one FW is executed...
> 
> YH
I had installed the latest firmware (2003) from the Adaptec download
site. Maybe the SCSI dmesg with the verbose option for both drivers
turned on can help. Both controllers are inserted, and a SCSI disk
is connected to the 39320A controller:
SCSI subsystem initialized
libata version 2.21 loaded.
ACPI: PCI Interrupt 0000:03:06.0[A] -> GSI 29 (level, low) -> IRQ 29
ahc_pci:3:6:0: Reading SEEPROM...done.
ahc_pci:3:6:0: BIOS eeprom is present
ahc_pci:3:6:0: Secondary High byte termination Enabled
ahc_pci:3:6:0: Secondary Low byte termination Enabled
ahc_pci:3:6:0: Primary Low Byte termination Enabled
ahc_pci:3:6:0: Primary High Byte termination Enabled
ahc_pci:3:6:0: Downloading Sequencer Program... 423 instructions
downloaded
ahc_pci:3:6:0: Features 0x1def6, Bugs 0x40, Flags 0x28485560
scsi0 : Adaptec AIC7XXX EISA/VLB/PCI SCSI HBA DRIVER, Rev 7.0
        <Adaptec 29160 Ultra160 SCSI adapter>
        aic7892: Ultra160 Wide Channel A, SCSI Id=7, 32/253 SCBs

scsi0: Slave Alloc 0
scsi0: Selection Timeout on A:0. 0 SCBs aborted
.....
scsi0: Slave Alloc 15
scsi0: Selection Timeout on A:15. 0 SCBs aborted
ACPI: PCI Interrupt 0000:03:03.0[A] -> GSI 28 (level, low) -> IRQ 28
ahd_pci:3:3:0: Reading VPD from SEEPROM...ahd_pci:3:3:0: VPD parsing
successful
ahd_pci:3:3:0: Reading SEEPROM...done.
ahd_pci:3:3:0: STPWLEVEL is on
ahd_pci:3:3:0: Manual Primary Termination
ahd_pci:3:3:0: Manual Secondary Termination
ahd_pci:3:3:0: Primary High byte termination Disabled
ahd_pci:3:3:0: Primary Low byte termination Enabled
ahd_pci:3:3:0: Secondary High byte termination Disabled
ahd_pci:3:3:0: Secondary Low byte termination Disabled
ahd_pci:3:3:0: Downloading Sequencer Program... 688 instructions
downloaded
ahd_pci:3:3:0: Features 0x7c101, Bugs 0x700002, Flags 0x43f1
scsi1 : Adaptec AIC79XX PCI-X SCSI HBA DRIVER, Rev 3.0
        <Adaptec 39320A Ultra320 SCSI adapter>
        aic7902: Ultra320 Wide Channel A, SCSI Id=7, PCI 33 or 66Mhz,
512 SCBs
scsi1: Slave Alloc 0
scsi1: Selection Timeout on A:0. 0 SCBs aborted
........
scsi1: Slave Alloc 4
scsi 1:0:4:0: Direct-Access     HITACHI  HUS151436VL3600  S3C0 PQ: 0
ANSI: 3
scsi 1:0:4:0: Slave Configure
 target1:0:4: asynchronous
scsi1:A:4:0: Tagged Queuing enabled.  Depth 32
 target1:0:4: Beginning Domain Validation
(scsi1:A:4:0): Sending WDTR 1
(scsi1:A:4:0): Received WDTR 1 filtered to 1
 target1:0:4: FAST-5 WIDE SCSI 2.0 MB/s ST (1020 ns, offset 255)
scsi1: target 4 using 16bit transfers
(scsi1:A:4:0): Sending SDTR period 44, offset 0
(scsi1:A:4:0): Received SDTR period 44, offset 0
        Filtered to period 0, offset 0
 target1:0:4: wide asynchronous
scsi1: target 4 using asynchronous transfers
(scsi1:A:4:0): Sending PPR bus_width 1, period 8, offset fe, ppr_options
f7
(scsi1:A:4:0): Received PPR width 1, period 8, offset 7f,options f7
        Filtered to width 1, period 8, offset 7f, options f7
 target1:0:4: FAST-160 WIDE SCSI 320.0 MB/s DT IU QAS RDSTRM RTI WRFLOW
PCOMP (6.25 ns, offset 127)
scsi1: target 4 synchronous with period = 0x8, offset = 0x7f(RDSTRM|DT|
IU|RTI|QAS)
 target1:0:4: Ending Domain Validation
scsi1: Slave Alloc 5
scsi1: Selection Timeout on A:5. 0 SCBs aborted
scsi1: Slave Alloc 6
scsi1: Selection Timeout on A:6. 0 SCBs aborted
scsi1: Slave Alloc 8
scsi1: Selection Timeout on A:8. 0 SCBs aborted
scsi1: Invalid Sequencer interrupt occurred, resetting channel.
 target1:0:4: FAST-160 SCSI 160.0 MB/s DT IU QAS RDSTRM RTI WRFLOW PCOMP
(6.25 ns, offset 127)
scsi1: target 4 using 8bit transfers
 target1:0:4: asynchronous
scsi1: target 4 using asynchronous transfers
sd 1:0:4:0: [sda] 71687402 512-byte hardware sectors (36704 MB)
scsi1: Slave Alloc 9
(scsi1:A:4:0): Sending PPR bus_width 1, period 8, offset 7f, ppr_options
f7
(scsi1:A:4:0): Received PPR width 1, period 8, offset 7f,options f7
        Filtered to width 1, period 8, offset 7f, options f7
 target1:0:4: wide asynchronous
scsi1: target 4 using 16bit transfers
 target1:0:4: FAST-160 WIDE SCSI 320.0 MB/s DT IU QAS RDSTRM RTI WRFLOW
PCOMP (6.25 ns, offset 127)
scsi1: target 4 synchronous with period = 0x8, offset = 0x7f(RDSTRM|DT|
IU|RTI|QAS)
scsi1: Selection Timeout on A:9. 0 SCBs aborted
scsi1: Slave Alloc 10
scsi1: Selection Timeout on A:10. 0 SCBs aborted
scsi1: Slave Alloc 11
scsi1: Selection Timeout on A:11. 0 SCBs aborted
scsi1: Invalid Sequencer interrupt occurred, resetting channel.
 target1:0:4: FAST-160 SCSI 160.0 MB/s DT IU QAS RDSTRM RTI WRFLOW PCOMP
(6.25 ns, offset 127)
scsi1: target 4 using 8bit transfers
 target1:0:4: asynchronous
scsi1: target 4 using asynchronous transfers
sd 1:0:4:0: [sda] Write Protect is off
sd 1:0:4:0: [sda] Mode Sense: cb 00 10 08
scsi1: Slave Alloc 12
(scsi1:A:4:0): Sending PPR bus_width 1, period 8, offset 7f, ppr_options
f7
(scsi1:A:4:0): Received PPR width 1, period 8, offset 7f,options f7
        Filtered to width 1, period 8, offset 7f, options f7
 target1:0:4: wide asynchronous
scsi1: target 4 using 16bit transfers
 target1:0:4: FAST-160 WIDE SCSI 320.0 MB/s DT IU QAS RDSTRM RTI WRFLOW
PCOMP (6.25 ns, offset 127)
scsi1: target 4 synchronous with period = 0x8, offset = 0x7f(RDSTRM|DT|
IU|RTI|QAS)
scsi1: Selection Timeout on A:12. 0 SCBs aborted
scsi1: Slave Alloc 13
scsi1: Selection Timeout on A:13. 0 SCBs aborted
scsi1: Slave Alloc 14
scsi1: Selection Timeout on A:14. 0 SCBs aborted
scsi1: Invalid Sequencer interrupt occurred, resetting channel.
 target1:0:4: FAST-160 SCSI 160.0 MB/s DT IU QAS RDSTRM RTI WRFLOW PCOMP
(6.25 ns, offset 127)
scsi1: target 4 using 8bit transfers
 target1:0:4: asynchronous
scsi1: target 4 using asynchronous transfers
scsi1: Slave Alloc 15
(scsi1:A:4:0): Sending PPR bus_width 1, period 8, offset 7f, ppr_options
f7
(scsi1:A:4:0): Received PPR width 1, period 8, offset 7f,options f7
        Filtered to width 1, period 8, offset 7f, options f7
 target1:0:4: wide asynchronous
scsi1: target 4 using 16bit transfers
 target1:0:4: FAST-160 WIDE SCSI 320.0 MB/s DT IU QAS RDSTRM RTI WRFLOW
PCOMP (6.25 ns, offset 127)
scsi1: target 4 synchronous with period = 0x8, offset = 0x7f(RDSTRM|DT|
IU|RTI|QAS)
scsi1: Selection Timeout on A:15. 0 SCBs aborted
ACPI: PCI Interrupt 0000:03:03.1[B] -> GSI 29 (level, low) -> IRQ 29
sd 1:0:4:0: [sda] Write cache: enabled, read cache: enabled, supports
DPO and FUA
ahd_pci:3:3:1: Reading VPD from SEEPROM...<5>sd 1:0:4:0: [sda] 71687402
512-byte hardware sectors (36704 MB)
ahd_pci:3:3:1: VPD parsing successful
ahd_pci:3:3:1: Reading SEEPROM...<5>sd 1:0:4:0: [sda] Write Protect is
off
sd 1:0:4:0: [sda] Mode Sense: cb 00 10 08
done.
ahd_pci:3:3:1: STPWLEVEL is on
ahd_pci:3:3:1: Manual Primary Termination
ahd_pci:3:3:1: Manual Secondary Termination
ahd_pci:3:3:1: Primary High byte termination Disabled
ahd_pci:3:3:1: Primary Low byte termination Enabled
ahd_pci:3:3:1: Secondary High byte termination Disabled
ahd_pci:3:3:1: Secondary Low byte termination Disabled
sd 1:0:4:0: [sda] Write cache: enabled, read cache: enabled, supports
DPO and FUA
 sda: sda1
sd 1:0:4:0: [sda] Attached SCSI disk
ahd_pci:3:3:1: Downloading Sequencer Program... 688 instructions
downloaded
ahd_pci:3:3:1: Features 0x7c101, Bugs 0x700002, Flags 0x43f0
sd 1:0:4:0: Attached scsi generic sg0 type 0
scsi2 : Adaptec AIC79XX PCI-X SCSI HBA DRIVER, Rev 3.0
        <Adaptec 39320A Ultra320 SCSI adapter>
        aic7902: Ultra320 Wide Channel B, SCSI Id=7, PCI 33 or 66Mhz,
512 SCBs
scsi2: Slave Alloc 0
scsi2: Selection Timeout on A:0. 0 SCBs aborted
.......
scsi2: Slave Alloc 15
scsi2: Selection Timeout on A:15. 0 SCBs aborted

> -
> To unsubscribe from this list: send the line "unsubscribe linux-scsi" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html

