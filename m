From: James Bottomley <James.Bottomley@SteelEye.com>
Subject: Re: [PATCH] aic94xx: fix smartctl utility problem
Date: Sat, 15 Sep 2007 12:05:39 -0500
Message-ID: <1189875940.3339.12.camel@localhost.localdomain>
References: <1189792710.6030.3.camel@linux.site>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from hancock.steeleye.com ([71.30.118.248]:59617 "EHLO
	hancock.sc.steeleye.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751876AbXIORFm (ORCPT
	<rfc822;Linux-scsi@vger.kernel.org>); Sat, 15 Sep 2007 13:05:42 -0400
In-Reply-To: <1189792710.6030.3.camel@linux.site>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Gilbert Wu <Gilbert_Wu@adaptec.com>
Cc: Linux-scsi@vger.kernel.org

On Fri, 2007-09-14 at 10:58 -0700, Gilbert Wu wrote:
> Fixed the problem that "smartctl -a /dev/some_sata_disk -d ata"  does
> not work on SATA device. ( The smartctl v5.38 does need "-d ata"
> option.)
>   The aic94xx need to return ATA output register for all ATA commands
> except ATA Read/Write commands.
>   The aic94xx also mark out the DRQ bit from status register which is
> treated as AC_ERR_HSM (host state machine violation) error by top layer
> if it set to one.
>  The firmware of aic94xx chip handle all ATA handshaking, data transfer
> and return ATA output register which is sent by the device.  So the DRQ
> bit may not reflect the last state of device when the command finished
> and it is no meaning for the caller.
> 
> Signed-off-by: Gilbert Wu <gilbert_wu@adaptec.com>

I'm afraid this can't go in.  It has a bad effect on my expander remote
ATAPI device:

aic94xx: Adaptec aic94xx SAS/SATA driver version 1.0.3 loaded
modprobe used greatest stack depth: 5312 bytes left
ACPI: PCI Interrupt 0000:03:03.0[A] -> GSI 17 (level, low) -> IRQ 17
aic94xx: found Adaptec AIC-9410W SAS/SATA Host Adapter, device 0000:03:03.0
scsi2 : aic94xx
OCM is not initialized by BIOS,reinitialize it and ignore it, current IntrptStatusis 0x0
aic94xx: couldn't find BIOS_CHIM dir ent
aic94xx: couldn't read ocm(-2)
aic94xx: manuf sect SAS_ADDR 50000d100001cae0
aic94xx: manuf sect PCBA SN 
aic94xx: ms: num_phy_desc: 8
aic94xx: ms: phy0: ENABLED
aic94xx: ms: phy1: ENABLED
aic94xx: ms: phy2: ENABLED
aic94xx: ms: phy3: ENABLED
aic94xx: ms: phy4: ENABLED
aic94xx: ms: phy5: ENABLED
aic94xx: ms: phy6: ENABLED
aic94xx: ms: phy7: ENABLED
aic94xx: ms: max_phys:0x8, num_phys:0x8
aic94xx: ms: enabled_phys:0xff
aic94xx: ctrla: phy0: sas_addr: 50000d100001cae0, sas rate:0x9-0x8, sata rate:0x0-0x0, flags:0x0
aic94xx: ctrla: phy1: sas_addr: 50000d100001cae0, sas rate:0x9-0x8, sata rate:0x0-0x0, flags:0x0
aic94xx: ctrla: phy2: sas_addr: 50000d100001cae0, sas rate:0x9-0x8, sata rate:0x0-0x0, flags:0x0
aic94xx: ctrla: phy3: sas_addr: 50000d100001cae0, sas rate:0x9-0x8, sata rate:0x0-0x0, flags:0x0
aic94xx: ctrla: phy4: sas_addr: 50000d100001cae0, sas rate:0x9-0x8, sata rate:0x0-0x0, flags:0x0
aic94xx: ctrla: phy5: sas_addr: 50000d100001cae0, sas rate:0x9-0x8, sata rate:0x0-0x0, flags:0x0
aic94xx: ctrla: phy6: sas_addr: 50000d100001cae0, sas rate:0x9-0x8, sata rate:0x0-0x0, flags:0x0
aic94xx: ctrla: phy7: sas_addr: 50000d100001cae0, sas rate:0x9-0x8, sata rate:0x0-0x0, flags:0x0
aic94xx: max_scbs:512, max_ddbs:128
aic94xx: setting phy0 addr to 50000d100001cae0
aic94xx: setting phy1 addr to 50000d100001cae0
aic94xx: setting phy2 addr to 50000d100001cae0
aic94xx: setting phy3 addr to 50000d100001cae0
aic94xx: setting phy4 addr to 50000d100001cae0
aic94xx: setting phy5 addr to 50000d100001cae0
aic94xx: setting phy6 addr to 50000d100001cae0
aic94xx: setting phy7 addr to 50000d100001cae0
aic94xx: num_edbs:21
aic94xx: num_escbs:3
aic94xx: Found sequencer Firmware version 1.1 (V30)
aic94xx: downloading CSEQ...
aic94xx: dma-ing 8192 bytes
aic94xx: verified 8192 bytes, passed
aic94xx: downloading LSEQs...
aic94xx: dma-ing 14336 bytes
aic94xx: LSEQ0 verified 14336 bytes, passed
aic94xx: LSEQ1 verified 14336 bytes, passed
aic94xx: LSEQ2 verified 14336 bytes, passed
aic94xx: LSEQ3 verified 14336 bytes, passed
aic94xx: LSEQ4 verified 14336 bytes, passed
aic94xx: LSEQ5 verified 14336 bytes, passed
aic94xx: LSEQ6 verified 14336 bytes, passed
aic94xx: LSEQ7 verified 14336 bytes, passed
aic94xx: max_scbs:446
aic94xx: first_scb_site_no:0x20
aic94xx: last_scb_site_no:0x1fe
aic94xx: First SCB dma_handle: 0x37682000
aic94xx: device 0000:03:03.0: SAS addr 50000d100001cae0, PCBA SN , 8 phys, 8 enabled phys, flash present, BIOS not present0
aic94xx: posting 3 escbs
aic94xx: escbs posted
aic94xx: posting 8 control phy scbs
aic94xx: control_phy_tasklet_complete: phy5, lrate:0x8, proto:0xe
aic94xx: control_phy_tasklet_complete: phy2, lrate:0x9, proto:0xe
aic94xx: control_phy_tasklet_complete: phy3, lrate:0x9, proto:0xe
aic94xx: escb_tasklet_complete: phy2: BYTES_DMAED
aic94xx: SAS proto IDENTIFY:
aic94xx: 00: 20 00 00 02
aic94xx: 04: 00 00 00 00
aic94xx: 08: 00 00 00 00
aic94xx: 0c: 50 06 05 b0
aic94xx: 10: 00 00 14 50
aic94xx: 14: 01 00 00 00
aic94xx: 18: 00 00 00 00
aic94xx: asd_form_port: updating phy_mask 0x4 for phy2
aic94xx: escb_tasklet_complete: phy3: BYTES_DMAED
aic94xx: SAS proto IDENTIFY:
aic94xx: 00: 20 00 00 02
aic94xx: 04: 00 00 00 00
aic94xx: 08: 00 00 00 00
aic94xx: 0c: 50 06 05 b0
aic94xx: 10: 00 00 14 50
aic94xx: 14: 00 00 00 00
aic94xx: 18: 00 00 00 00
aic94xx: asd_form_port: updating phy_mask 0xc for phy3
aic94xx: control_phy_tasklet_complete: phy0: no device present: oob_status:0x0
aic94xx: control_phy_tasklet_complete: phy1: no device present: oob_status:0x0
aic94xx: control_phy_tasklet_complete: phy4: no device present: oob_status:0x0
aic94xx: control_phy_tasklet_complete: phy6: no device present: oob_status:0x0
aic94xx: control_phy_tasklet_complete: phy7: no device present: oob_status:0x0
sas: phy2 added to port0, phy_mask:0x4
sas: phy3 matched wide port0
sas: phy3 added to port0, phy_mask:0xc
sas: DOING DISCOVERY on port 0, pid:2047
sas: ex 500605b000001450 phy00:S attached: 50000d100001cae0
sas: ex 500605b000001450 phy01:S attached: 50000d100001cae0
sas: ex 500605b000001450 phy02:S attached: 0000000000000000
sas: ex 500605b000001450 phy03:S attached: 0000000000000000
sas: ex 500605b000001450 phy04:T attached: 0000000000000000
sas: ex 500605b000001450 phy05:T attached: 500605b000001455
sas: ex 500605b000001450 phy06:T attached: 0000000000000000
sas: ex 500605b000001450 phy07:T attached: 0000000000000000
sas: ex 500605b000001450 phy08:T attached: 500605b000001110
sas: ex 500605b000001450 phy09:T attached: 500605b000001110
sas: ex 500605b000001450 phy10:T attached: 0000000000000000
sas: ex 500605b000001450 phy11:T attached: 0000000000000000
sas: sas_ata_phy_reset: Found ATAPI device.
ata1.00: ATAPI: PLEXTOR DVDR   PX-755A, 1.03, max UDMA/66
ata1.00: configured for UDMA/66
scsi 2:0:0:0: CD-ROM            PLEXTOR  DVDR   PX-755A   1.03 PQ: 0 ANSI: 5
sr0: scsi3-mmc drive: 40x/40x writer cd/rw xa/form2 cdda tray
Uniform CD-ROM driver Revision: 3.20
sr 2:0:0:0: Attached scsi generic sg1 type 5
sas: ex 500605b000001110 phy00:S attached: 500605b000001450
sas: ex 500605b000001110 phy01:S attached: 500605b000001450
sas: ex 500605b000001110 phy02:S attached: 0000000000000000
sas: ex 500605b000001110 phy03:S attached: 0000000000000000
sas: ex 500605b000001110 phy04:T attached: 0000000000000000
sas: ex 500605b000001110 phy05:T attached: 0000000000000000
sas: ex 500605b000001110 phy06:T attached: 0000000000000000
sas: ex 500605b000001110 phy07:T attached: 0000000000000000
sas: ex 500605b000001110 phy08:T attached: 5000c50000202511
sas: ex 500605b000001110 phy09:T attached: 0000000000000000
sas: ex 500605b000001110 phy10:T attached: 0000000000000000
sas: ex 500605b000001110 phy11:T attached: 0000000000000000
scsi 2:0:1:0: Direct-Access     IBM-ESXS ST973401SS       B519 PQ: 0 ANSI: 5
sd 2:0:1:0: [sdb] 143374000 512-byte hardware sectors (73407 MB)
sd 2:0:1:0: [sdb] Write Protect is off
sd 2:0:1:0: [sdb] Write cache: disabled, read cache: enabled, supports DPO and FUA
sd 2:0:1:0: [sdb] 143374000 512-byte hardware sectors (73407 MB)
sd 2:0:1:0: [sdb] Write Protect is off
sd 2:0:1:0: [sdb] Write cache: disabled, read cache: enabled, supports DPO and FUA
 sdb: sdb1
sd 2:0:1:0: [sdb] Attached SCSI disk
sd 2:0:1:0: Attached scsi generic sg2 type 0
sas: DONE DISCOVERY on port 0, pid:2047, result:0
sas: command 0xde7c4648, task 0xf77cf6e0, timed out: EH_NOT_HANDLED
sas: Enter sas_scsi_recover_host
sas: trying to find task 0xf77cf6e0
sas: sas_scsi_find_task: aborting task 0xf77cf6e0
aic94xx: tmf tasklet complete
aic94xx: tmf came back
aic94xx: task 0xf77cf6e0 aborted, res: 0x4
sas: sas_scsi_find_task: querying task 0xf77cf6e0
sas: sas_scsi_find_task: aborting task 0xf77cf6e0
aic94xx: tmf tasklet complete
aic94xx: tmf came back
aic94xx: task 0xf77cf6e0 aborted, res: 0x4
sas: sas_scsi_find_task: querying task 0xf77cf6e0
sas: sas_scsi_find_task: aborting task 0xf77cf6e0
aic94xx: tmf tasklet complete
aic94xx: tmf came back
aic94xx: task 0xf77cf6e0 aborted, res: 0x4
sas: sas_scsi_find_task: querying task 0xf77cf6e0
sas: sas_scsi_find_task: aborting task 0xf77cf6e0
aic94xx: tmf tasklet complete
aic94xx: tmf came back
aic94xx: task 0xf77cf6e0 aborted, res: 0x4
sas: sas_scsi_find_task: querying task 0xf77cf6e0
sas: sas_scsi_find_task: aborting task 0xf77cf6e0
aic94xx: tmf tasklet complete
aic94xx: tmf came back
aic94xx: task 0xf77cf6e0 aborted, res: 0x4
sas: sas_scsi_find_task: querying task 0xf77cf6e0
sas: task 0xf77cf6e0 is not at LU: I_T recover
sas: I_T nexus reset for dev 500605b000001455
sas: clearing nexus for port:0
aic94xx: asd_clear_nexus_port: PRE
aic94xx: asd_clear_nexus_port: POST
aic94xx: asd_clear_nexus_port: clear nexus posted, waiting...
aic94xx: asd_clear_nexus_tasklet_complete: here
aic94xx: asd_clear_nexus_tasklet_complete: opcode: 0x0
sas: clear nexus port:0 succeeded
sas: --- Exit sas_scsi_recover_host
sas: command 0xde7c4648, task 0xf77cf6e0, timed out: EH_NOT_HANDLED
sas: Enter sas_scsi_recover_host
sas: trying to find task 0xf77cf6e0
sas: sas_scsi_find_task: aborting task 0xf77cf6e0
aic94xx: tmf tasklet complete
aic94xx: tmf came back
aic94xx: task 0xf77cf6e0 aborted, res: 0x4
sas: sas_scsi_find_task: querying task 0xf77cf6e0
sas: sas_scsi_find_task: aborting task 0xf77cf6e0
aic94xx: tmf tasklet complete
aic94xx: tmf came back
aic94xx: task 0xf77cf6e0 aborted, res: 0x4
sas: sas_scsi_find_task: querying task 0xf77cf6e0
sas: sas_scsi_find_task: aborting task 0xf77cf6e0
aic94xx: tmf tasklet complete
aic94xx: tmf came back
aic94xx: task 0xf77cf6e0 aborted, res: 0x4
sas: sas_scsi_find_task: querying task 0xf77cf6e0
sas: sas_scsi_find_task: aborting task 0xf77cf6e0
aic94xx: tmf tasklet complete
aic94xx: tmf came back
aic94xx: task 0xf77cf6e0 aborted, res: 0x4
sas: sas_scsi_find_task: querying task 0xf77cf6e0
sas: sas_scsi_find_task: aborting task 0xf77cf6e0
aic94xx: tmf tasklet complete
aic94xx: tmf came back
aic94xx: task 0xf77cf6e0 aborted, res: 0x4
sas: sas_scsi_find_task: querying task 0xf77cf6e0
sas: task 0xf77cf6e0 is not at LU: I_T recover
sas: I_T nexus reset for dev 500605b000001455
sas: clearing nexus for port:0
aic94xx: asd_clear_nexus_port: PRE
aic94xx: asd_clear_nexus_port: POST
aic94xx: asd_clear_nexus_port: clear nexus posted, waiting...
aic94xx: asd_clear_nexus_tasklet_complete: here
aic94xx: asd_clear_nexus_tasklet_complete: opcode: 0x0
sas: clear nexus port:0 succeeded
sas: --- Exit sas_scsi_recover_host
sas: command 0xde7c4648, task 0xf77cf6e0, timed out: EH_NOT_HANDLED
sas: Enter sas_scsi_recover_host
sas: trying to find task 0xf77cf6e0
sas: sas_scsi_find_task: aborting task 0xf77cf6e0
aic94xx: task 0xf77cf6e0 done with opcode 0x1e resp 0x0 stat 0x8d but aborted by upper layer!
aic94xx: tmf tasklet complete
aic94xx: tmf came back
aic94xx: asd_abort_task: task 0xf77cf6e0 done
aic94xx: task 0xf77cf6e0 aborted, res: 0x0
sas: sas_scsi_find_task: task 0xf77cf6e0 is done
sas: sas_eh_handle_sas_errors: task 0xf77cf6e0 is done
sas: sas_ata_task_done: SAS error 8d
sas: --- Exit sas_scsi_recover_host

And then the system hangs

James


