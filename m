From: Mark Haverkamp <markh@osdl.org>
Subject: Re: aic94xx panic on module load
Date: Wed, 29 Nov 2006 11:29:12 -0800
Message-ID: <1164828552.32583.8.camel@markh3.pdx.osdl.net>
References: <1164734233.21827.8.camel@markh3.pdx.osdl.net>
	 <456C7966.7080602@us.ibm.com>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from smtp.osdl.org ([65.172.181.25]:52875 "EHLO smtp.osdl.org")
	by vger.kernel.org with ESMTP id S967589AbWK2TaC (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Wed, 29 Nov 2006 14:30:02 -0500
In-Reply-To: <456C7966.7080602@us.ibm.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: "Darrick J. Wong" <djwong@us.ibm.com>
Cc: linux-scsi <linux-scsi@vger.kernel.org>, Douglas Gilbert <dougg@torque.net>

On Tue, 2006-11-28 at 10:01 -0800, Darrick J. Wong wrote:
> Mark Haverkamp wrote:
> > I got this panic when loading the aic94xx module.  The adapter is
> > connected to an HP MSA50 SAS enclosure with 3 72GB SAS disks.
> > 
> > Kernel 2.6.19-rc6-scsi-misc on an x86_64
> <snip>
> > sas: task finished with resp:0x0, stat:0x89
> > sas: sas_discover_sata() for device 500508b300a27a2c at 500508b300a27a2f:0xc returned 0xffffff06
> > kobject_add failed for port-2:0:12 with -EEXIST, don't try to register things with the same name in the same directory.
> 
> Your expander is reporting your SAS disks to aic94xx as SATA disks,
> which is why the sas_discover_sata fails.  I don't know why it would do
> that... flaky hardware?  I'm not really sure what to do when we're given
> bad information.
> 
> > Kernel BUG at drivers/scsi/libsas/sas_expander.c:603
> 
> I believe this BUG is fixed by a few patches in aic94xx-sas.  For sure
> you'll want the patch named "libsas: better error handling in
> sas_ex_discover_end_dev()" patch; see commit
> 82f6bc0849b6fce9a965dde11dd6f685adc7285e.
> 
> There are some dependencies:
> e384a0bdd9d3abb5ba2f6eac9ac4d0ac61e1c6a1 ->
> 1f8787b198c4ba058a0bfc06c2ca7f301168a5dd ->
> 82f6bc0849b6fce9a965dde11dd6f685adc7285e.


I tried out the aic94xx-sas-2.6 kernel on my system.  It didn't panic
and did find the disks.  It looks like those fixes that you mentioned
did it.  Do you know when they may be propagated towards one of the scsi
trees or the main kernel tree?

Thanks,
Mark.

Nov 29 11:29:10 odt2-003 kernel: aic94xx: Adaptec aic94xx SAS/SATA driver version 1.0.2 unloaded
Nov 29 11:29:19 odt2-003 kernel: aic94xx: Adaptec aic94xx SAS/SATA driver version 1.0.2 loaded
Nov 29 11:29:19 odt2-003 kernel: PCI: Enabling device 0000:08:01.0 (0110 -> 0113)
Nov 29 11:29:19 odt2-003 kernel: ACPI: PCI Interrupt 0000:08:01.0[A] -> GSI 28 (level, low) -> IRQ 28
Nov 29 11:29:19 odt2-003 kernel: aic94xx: found Adaptec AIC-9410W SAS/SATA Host Adapter, device 0000:08:01.0
Nov 29 11:29:19 odt2-003 kernel: scsi3 : aic94xx
Nov 29 11:29:19 odt2-003 kernel: aic94xx: BIOS present (1,2), 1673
Nov 29 11:29:19 odt2-003 kernel: aic94xx: ue num:3, ue size:88
Nov 29 11:29:19 odt2-003 kernel: aic94xx: manuf sect SAS_ADDR 50000d100045af00
Nov 29 11:29:19 odt2-003 kernel: aic94xx: manuf sect PCBA SN 0BD0C625005W
Nov 29 11:29:19 odt2-003 kernel: aic94xx: ms: num_phy_desc: 8
Nov 29 11:29:19 odt2-003 kernel: aic94xx: ms: phy0: ENEBLEABLE
Nov 29 11:29:19 odt2-003 kernel: aic94xx: ms: phy1: ENEBLEABLE
Nov 29 11:29:19 odt2-003 kernel: aic94xx: ms: phy2: ENEBLEABLE
Nov 29 11:29:19 odt2-003 kernel: aic94xx: ms: phy3: ENEBLEABLE
Nov 29 11:29:19 odt2-003 kernel: aic94xx: ms: phy4: ENEBLEABLE
Nov 29 11:29:19 odt2-003 kernel: aic94xx: ms: phy5: ENEBLEABLE
Nov 29 11:29:19 odt2-003 kernel: aic94xx: ms: phy6: ENEBLEABLE
Nov 29 11:29:19 odt2-003 kernel: aic94xx: ms: phy7: ENEBLEABLE
Nov 29 11:29:19 odt2-003 kernel: aic94xx: ms: max_phys:0x8, num_phys:0x8
Nov 29 11:29:19 odt2-003 kernel: aic94xx: ms: enabled_phys:0xff
Nov 29 11:29:19 odt2-003 kernel: aic94xx: ctrla: phy0: sas_addr: 50000d100045af00, sas rate:0x9-0x8, sata rate:0x0-0x0, flags:0x0
Nov 29 11:29:19 odt2-003 kernel: aic94xx: ctrla: phy1: sas_addr: 50000d100045af00, sas rate:0x9-0x8, sata rate:0x0-0x0, flags:0x0
Nov 29 11:29:19 odt2-003 kernel: aic94xx: ctrla: phy2: sas_addr: 50000d100045af00, sas rate:0x9-0x8, sata rate:0x0-0x0, flags:0x0
Nov 29 11:29:19 odt2-003 kernel: aic94xx: ctrla: phy3: sas_addr: 50000d100045af00, sas rate:0x9-0x8, sata rate:0x0-0x0, flags:0x0
Nov 29 11:29:19 odt2-003 kernel: aic94xx: ctrla: phy4: sas_addr: 50000d100045af00, sas rate:0x9-0x8, sata rate:0x0-0x0, flags:0x0
Nov 29 11:29:19 odt2-003 kernel: aic94xx: ctrla: phy5: sas_addr: 50000d100045af00, sas rate:0x9-0x8, sata rate:0x0-0x0, flags:0x0
Nov 29 11:29:19 odt2-003 kernel: aic94xx: ctrla: phy6: sas_addr: 50000d100045af00, sas rate:0x9-0x8, sata rate:0x0-0x0, flags:0x0
Nov 29 11:29:19 odt2-003 kernel: aic94xx: ctrla: phy7: sas_addr: 50000d100045af00, sas rate:0x9-0x8, sata rate:0x0-0x0, flags:0x0
Nov 29 11:29:19 odt2-003 kernel: aic94xx: max_scbs:512, max_ddbs:128
Nov 29 11:29:19 odt2-003 kernel: aic94xx: setting phy0 addr to 50000d100045af00
Nov 29 11:29:19 odt2-003 kernel: aic94xx: setting phy1 addr to 50000d100045af00
Nov 29 11:29:19 odt2-003 kernel: aic94xx: setting phy2 addr to 50000d100045af00
Nov 29 11:29:19 odt2-003 kernel: aic94xx: setting phy3 addr to 50000d100045af00
Nov 29 11:29:19 odt2-003 kernel: aic94xx: setting phy4 addr to 50000d100045af00
Nov 29 11:29:19 odt2-003 kernel: aic94xx: setting phy5 addr to 50000d100045af00
Nov 29 11:29:19 odt2-003 kernel: aic94xx: setting phy6 addr to 50000d100045af00
Nov 29 11:29:19 odt2-003 kernel: aic94xx: setting phy7 addr to 50000d100045af00
Nov 29 11:29:19 odt2-003 kernel: aic94xx: num_edbs:21
Nov 29 11:29:19 odt2-003 kernel: aic94xx: num_escbs:3
Nov 29 11:29:19 odt2-003 kernel: aic94xx: using sequencer V17/10c6
Nov 29 11:29:19 odt2-003 kernel: aic94xx: downloading CSEQ...
Nov 29 11:29:19 odt2-003 kernel: aic94xx: dma-ing 8192 bytes
Nov 29 11:29:19 odt2-003 kernel: aic94xx: verified 8192 bytes, passed
Nov 29 11:29:19 odt2-003 kernel: aic94xx: downloading LSEQs...
Nov 29 11:29:19 odt2-003 kernel: aic94xx: dma-ing 14336 bytes
Nov 29 11:29:19 odt2-003 kernel: aic94xx: LSEQ0 verified 14336 bytes, passed
Nov 29 11:29:19 odt2-003 kernel: aic94xx: LSEQ1 verified 14336 bytes, passed
Nov 29 11:29:19 odt2-003 kernel: aic94xx: LSEQ2 verified 14336 bytes, passed
Nov 29 11:29:19 odt2-003 kernel: aic94xx: LSEQ3 verified 14336 bytes, passed
Nov 29 11:29:19 odt2-003 kernel: aic94xx: LSEQ4 verified 14336 bytes, passed
Nov 29 11:29:19 odt2-003 kernel: aic94xx: LSEQ5 verified 14336 bytes, passed
Nov 29 11:29:19 odt2-003 kernel: aic94xx: LSEQ6 verified 14336 bytes, passed
Nov 29 11:29:19 odt2-003 kernel: aic94xx: LSEQ7 verified 14336 bytes, passed
Nov 29 11:29:19 odt2-003 kernel: aic94xx: max_scbs:446
Nov 29 11:29:19 odt2-003 kernel: aic94xx: first_scb_site_no:0x20
Nov 29 11:29:19 odt2-003 kernel: aic94xx: last_scb_site_no:0x1fe
Nov 29 11:29:19 odt2-003 kernel: aic94xx: First SCB dma_handle: 0x17a616000
Nov 29 11:29:19 odt2-003 kernel: aic94xx: device 0000:08:01.0: SAS addr 50000d100045af00, PCBA SN 0BD0C625005W, 8 phys, 8 enabled phys, flash present, BIOS build 1673
Nov 29 11:29:19 odt2-003 kernel: aic94xx: posting 3 escbs
Nov 29 11:29:19 odt2-003 kernel: aic94xx: escbs posted
Nov 29 11:29:19 odt2-003 kernel: aic94xx: posting 8 control phy scbs
Nov 29 11:29:19 odt2-003 kernel: aic94xx: enabled phys
Nov 29 11:29:19 odt2-003 kernel: aic94xx: control_phy_tasklet_complete: phy0, lrate:0x9, proto:0xe
Nov 29 11:29:19 odt2-003 kernel: aic94xx: control_phy_tasklet_complete: phy1, lrate:0x9, proto:0xe
Nov 29 11:29:19 odt2-003 kernel: aic94xx: escb_tasklet_complete: phy0: BYTES_DMAED
Nov 29 11:29:19 odt2-003 kernel: aic94xx: SAS proto IDENTIFY:
Nov 29 11:29:19 odt2-003 kernel: aic94xx: 00: 20 00 00 02
Nov 29 11:29:19 odt2-003 kernel: aic94xx: 04: 00 00 00 00
Nov 29 11:29:19 odt2-003 kernel: aic94xx: 08: 00 00 00 00
Nov 29 11:29:19 odt2-003 kernel: aic94xx: 0c: 50 05 08 b3
Nov 29 11:29:19 odt2-003 kernel: aic94xx: 10: 00 a2 7a 2f
Nov 29 11:29:19 odt2-003 kernel: aic94xx: 14: 07 00 00 00
Nov 29 11:29:19 odt2-003 kernel: aic94xx: 18: 00 00 00 00
Nov 29 11:29:19 odt2-003 kernel: aic94xx: control_phy_tasklet_complete: phy2, lrate:0x9, proto:0xe
Nov 29 11:29:19 odt2-003 kernel: aic94xx: escb_tasklet_complete: phy1: BYTES_DMAED
Nov 29 11:29:19 odt2-003 kernel: sas: phy0 added to port0, phy_mask:0x1
Nov 29 11:29:19 odt2-003 kernel: sas: DOING DISCOVERY on port 0, pid:4272
Nov 29 11:29:19 odt2-003 kernel: aic94xx: SAS proto IDENTIFY:
Nov 29 11:29:19 odt2-003 kernel: aic94xx: 00: 20 00 00 02
Nov 29 11:29:19 odt2-003 kernel: aic94xx: 04: 00 00 00 00
Nov 29 11:29:19 odt2-003 kernel: aic94xx: 08: 00 00 00 00
Nov 29 11:29:19 odt2-003 kernel: aic94xx: 0c: 50 05 08 b3
Nov 29 11:29:19 odt2-003 kernel: aic94xx: 10: 00 a2 7a 2f
Nov 29 11:29:19 odt2-003 kernel: aic94xx: 14: 06 00 00 00
Nov 29 11:29:19 odt2-003 kernel: aic94xx: 18: 00 00 00 00
Nov 29 11:29:19 odt2-003 kernel: aic94xx: control_phy_tasklet_complete: phy3, lrate:0x9, proto:0xe
Nov 29 11:29:19 odt2-003 kernel: aic94xx: escb_tasklet_complete: phy2: BYTES_DMAED
Nov 29 11:29:19 odt2-003 kernel: aic94xx: SAS proto IDENTIFY:
Nov 29 11:29:19 odt2-003 kernel: aic94xx: 00: 20 00 00 02
Nov 29 11:29:19 odt2-003 kernel: aic94xx: 04: 00 00 00 00
Nov 29 11:29:19 odt2-003 kernel: aic94xx: 08: 00 00 00 00
Nov 29 11:29:19 odt2-003 kernel: aic94xx: 0c: 50 05 08 b3
Nov 29 11:29:19 odt2-003 kernel: aic94xx: 10: 00 a2 7a 2f
Nov 29 11:29:19 odt2-003 kernel: aic94xx: 14: 05 00 00 00
Nov 29 11:29:19 odt2-003 kernel: aic94xx: 18: 00 00 00 00
Nov 29 11:29:19 odt2-003 kernel: aic94xx: escb_tasklet_complete: phy3: BYTES_DMAED
Nov 29 11:29:19 odt2-003 kernel: aic94xx: SAS proto IDENTIFY:
Nov 29 11:29:19 odt2-003 kernel: aic94xx: 00: 20 00 00 02
Nov 29 11:29:19 odt2-003 kernel: aic94xx: 04: 00 00 00 00
Nov 29 11:29:19 odt2-003 kernel: aic94xx: 08: 00 00 00 00
Nov 29 11:29:19 odt2-003 kernel: aic94xx: 0c: 50 05 08 b3
Nov 29 11:29:19 odt2-003 kernel: aic94xx: 10: 00 a2 7a 2f
Nov 29 11:29:19 odt2-003 kernel: aic94xx: 14: 04 00 00 00
Nov 29 11:29:19 odt2-003 kernel: aic94xx: 18: 00 00 00 00
Nov 29 11:29:19 odt2-003 kernel: aic94xx: control_phy_tasklet_complete: phy4: no device present: oob_status:0x0
Nov 29 11:29:19 odt2-003 kernel: aic94xx: control_phy_tasklet_complete: phy5: no device present: oob_status:0x0
Nov 29 11:29:19 odt2-003 kernel: aic94xx: control_phy_tasklet_complete: phy6: no device present: oob_status:0x0
Nov 29 11:29:19 odt2-003 kernel: aic94xx: control_phy_tasklet_complete: phy7: no device present: oob_status:0x0
Nov 29 11:29:19 odt2-003 kernel: sas: ex 500508b300a27a2f phy00:T attached: 500508b300a27a3f
Nov 29 11:29:19 odt2-003 kernel: sas: ex 500508b300a27a2f phy01:T attached: 500508b300a27a3f
Nov 29 11:29:19 odt2-003 kernel: sas: ex 500508b300a27a2f phy02:T attached: 0000000000000000
Nov 29 11:29:19 odt2-003 kernel: sas: ex 500508b300a27a2f phy03:T attached: 0000000000000000
Nov 29 11:29:19 odt2-003 kernel: sas: ex 500508b300a27a2f phy04:S attached: 50000d100045af00
Nov 29 11:29:19 odt2-003 kernel: sas: ex 500508b300a27a2f phy05:S attached: 50000d100045af00
Nov 29 11:29:19 odt2-003 kernel: sas: ex 500508b300a27a2f phy06:S attached: 50000d100045af00
Nov 29 11:29:19 odt2-003 kernel: sas: ex 500508b300a27a2f phy07:S attached: 50000d100045af00
Nov 29 11:29:20 odt2-003 kernel: sas: ex 500508b300a27a2f phy08:T attached: 0000000000000000
Nov 29 11:29:20 odt2-003 kernel: sas: ex 500508b300a27a2f phy09:T attached: 0000000000000000
Nov 29 11:29:20 odt2-003 kernel: sas: ex 500508b300a27a2f phy10:T attached: 0000000000000000
Nov 29 11:29:20 odt2-003 kernel: sas: ex 500508b300a27a2f phy11:T attached: 0000000000000000
Nov 29 11:29:20 odt2-003 kernel: sas: ex 500508b300a27a2f phy12:D attached: 500508b300a27a2c
Nov 29 11:29:20 odt2-003 kernel: sas: ex 500508b300a27a3f phy00:D attached: 5000c5000095f8b5
Nov 29 11:29:20 odt2-003 kernel: sas: ex 500508b300a27a3f phy01:D attached: 0000000000000000
Nov 29 11:29:20 odt2-003 kernel: sas: ex 500508b300a27a3f phy02:D attached: 5000c5000095d3b5
Nov 29 11:29:20 odt2-003 kernel: sas: ex 500508b300a27a3f phy03:D attached: 0000000000000000
Nov 29 11:29:20 odt2-003 kernel: sas: ex 500508b300a27a3f phy04:D attached: 5000c5000095c0b9
Nov 29 11:29:20 odt2-003 kernel: sas: ex 500508b300a27a3f phy05:D attached: 0000000000000000
Nov 29 11:29:20 odt2-003 kernel: sas: ex 500508b300a27a3f phy06:D attached: 0000000000000000
Nov 29 11:29:20 odt2-003 kernel: sas: ex 500508b300a27a3f phy07:D attached: 0000000000000000
Nov 29 11:29:20 odt2-003 kernel: sas: ex 500508b300a27a3f phy08:D attached: 0000000000000000
Nov 29 11:29:20 odt2-003 kernel: sas: ex 500508b300a27a3f phy09:D attached: 0000000000000000
Nov 29 11:29:20 odt2-003 kernel: sas: ex 500508b300a27a3f phy10:S attached: 500508b300a27a2f
Nov 29 11:29:20 odt2-003 kernel: sas: ex 500508b300a27a3f phy11:S attached: 500508b300a27a2f
Nov 29 11:29:20 odt2-003 kernel: sas: task finished with resp:0xffffffff, stat:0x87
Nov 29 11:29:20 odt2-003 kernel: sas: sas_discover_sata() for device 500508b300a27a2c at 500508b300a27a2f:0xc returned 0xffffff06
Nov 29 11:29:20 odt2-003 kernel: sas: task finished with resp:0xffffffff, stat:0x87
Nov 29 11:29:20 odt2-003 kernel: sas: sas_discover_sata() for device 500508b300a27a2c at 500508b300a27a2f:0xc returned 0xffffff06
Nov 29 11:29:20 odt2-003 kernel: scsi 3:0:0:0: Direct-Access     HP       DG072A8B54       HPD6 PQ: 0 ANSI: 5
Nov 29 11:29:20 odt2-003 kernel: SCSI device sdc: 143374738 512-byte hdwr sectors (73408 MB)
Nov 29 11:29:20 odt2-003 kernel: sdc: Write Protect is off
Nov 29 11:29:20 odt2-003 kernel: SCSI device sdc: drive cache: write through w/ FUA
Nov 29 11:29:20 odt2-003 kernel: SCSI device sdc: 143374738 512-byte hdwr sectors (73408 MB)
Nov 29 11:29:20 odt2-003 kernel: sdc: Write Protect is off
Nov 29 11:29:20 odt2-003 kernel: SCSI device sdc: drive cache: write through w/ FUA
Nov 29 11:29:20 odt2-003 kernel:  sdc: sdc1
Nov 29 11:29:20 odt2-003 kernel: sd 3:0:0:0: Attached scsi disk sdc
Nov 29 11:29:20 odt2-003 kernel: scsi 3:0:1:0: Direct-Access     HP       DG072A8B54       HPD6 PQ: 0 ANSI: 5
Nov 29 11:29:20 odt2-003 kernel: SCSI device sdd: 143374738 512-byte hdwr sectors (73408 MB)
Nov 29 11:29:20 odt2-003 kernel: sdd: Write Protect is off
Nov 29 11:29:20 odt2-003 kernel: SCSI device sdd: drive cache: write through w/ FUA
Nov 29 11:29:20 odt2-003 kernel: SCSI device sdd: 143374738 512-byte hdwr sectors (73408 MB)
Nov 29 11:29:20 odt2-003 kernel: sdd: Write Protect is off
Nov 29 11:29:20 odt2-003 kernel: SCSI device sdd: drive cache: write through w/ FUA
Nov 29 11:29:20 odt2-003 kernel:  sdd: sdd1
Nov 29 11:29:20 odt2-003 kernel: sd 3:0:1:0: Attached scsi disk sdd
Nov 29 11:29:20 odt2-003 kernel: scsi 3:0:2:0: Direct-Access     HP       DG072A8B54       HPD6 PQ: 0 ANSI: 5
Nov 29 11:29:20 odt2-003 kernel: SCSI device sde: 143374738 512-byte hdwr sectors (73408 MB)
Nov 29 11:29:20 odt2-003 kernel: sde: Write Protect is off
Nov 29 11:29:20 odt2-003 kernel: SCSI device sde: drive cache: write through w/ FUA
Nov 29 11:29:20 odt2-003 kernel: SCSI device sde: 143374738 512-byte hdwr sectors (73408 MB)
Nov 29 11:29:20 odt2-003 kernel: sde: Write Protect is off
Nov 29 11:29:20 odt2-003 kernel: SCSI device sde: drive cache: write through w/ FUA
Nov 29 11:29:20 odt2-003 kernel:  sde: sde1
Nov 29 11:29:20 odt2-003 kernel: sd 3:0:2:0: Attached scsi disk sde
Nov 29 11:29:20 odt2-003 kernel: sas: DONE DISCOVERY on port 0, pid:4272, result:0
Nov 29 11:29:20 odt2-003 kernel: sas: phy1 matched wide port0
Nov 29 11:29:20 odt2-003 kernel: sas: phy1 added to port0, phy_mask:0x3
Nov 29 11:29:20 odt2-003 kernel: sas: phy2 matched wide port0
Nov 29 11:29:20 odt2-003 kernel: sas: phy2 added to port0, phy_mask:0x7
Nov 29 11:29:20 odt2-003 kernel: sas: phy3 matched wide port0
Nov 29 11:29:20 odt2-003 kernel: sas: phy3 added to port0, phy_mask:0xf
Nov 29 11:29:30 odt2-003 scsi.agent[4412]: disk at /devices/pci0000:06/0000:06:02.0/0000:08:01.0/host3/port-3:0/expander-3:0/port-3:0:0/expander-3:1/port-3:1:0/end_device-3:1:0/target3:0:0/3:0:0:0
Nov 29 11:29:30 odt2-003 scsi.agent[4428]: disk at /devices/pci0000:06/0000:06:02.0/0000:08:01.0/host3/port-3:0/expander-3:0/port-3:0:0/expander-3:1/port-3:1:4/end_device-3:1:4/target3:0:2/3:0:2:0
Nov 29 11:29:30 odt2-003 scsi.agent[4429]: disk at /devices/pci0000:06/0000:06:02.0/0000:08:01.0/host3/port-3:0/expander-3:0/port-3:0:0/expander-3:1/port-3:1:2/end_device-3:1:2/target3:0:1/3:0:1:0


> 
> --D
-- 
Mark Haverkamp <markh@osdl.org>

