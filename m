From: Sergey Kononenko <sergk@sergk.org.ua>
Subject: aic94xx: wrong order of SATA disks
Date: Tue, 12 Feb 2008 23:22:40 +0200
Message-ID: <20080212232240.3ffc9770@vingilot.sergknet>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mx1.hqhost.net ([88.214.192.192]:46368 "EHLO mail.hqhost.net"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1752608AbYBLWDp (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Tue, 12 Feb 2008 17:03:45 -0500
Received: from vingilot.sergknet (sergk@[80.77.82.87])
	(authenticated bits=0)
	by mail.hqhost.net (8.14.1/8.14.1/Debian-9) with ESMTP id m1CLIxHf024420
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=NOT)
	for <linux-scsi@vger.kernel.org>; Tue, 12 Feb 2008 21:19:03 GMT
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org

Hello,

I have server with motherboard Supermicro X7DBR-3 (AIC-9410 onboard).
And there are three SATA disks in following order:
1st drive bay: WD800AAJS-60
2nd drive bay: WD2500YS-01S
3rd drive bay: WD2500YS-01S
in BIOS they listed in the same order.

But after I've loaded linux (2.6.23.14 and 2.6.24 tested) I had
WD800AAJS-60 named as sdc, and two WD2500YS-01S as sda and sdb.
Moreover then i've booted second time with same kernel and settings
names for WD2500YS-01S swapped. Disk which had name sda become sdb and
vice versa. I've noticed that through disk's serial numbers, because
models are same.

When I checked all in dmesg related to aic94xx (compiled with debug
option) i've found this messages:

sas: phy1 added to port0, phy_mask:0x2
...............
sas: phy2 added to port1, phy_mask:0x4
sas: phy0 added to port2, phy_mask:0x1

and for second booting:

sas: phy2 added to port0, phy_mask:0x4
...............
sas: phy1 added to port1, phy_mask:0x2
sas: phy0 added to port2, phy_mask:0x1

I've repeated reboot several times. But have noticed only two
variants of disks order.
So phys assigned to ports not in right order. Also this order can be
changed randomly for disks with same model.
I've disabled and enabled HostRAID in controlled BIOS. There wasn't
effect from that. Also I tried to assign different SAS addresses to
phys, also this didn't help. CONFIG_SCSI_SCAN_ASYNC is unset in kernel
config.

I have another server with same motherboard there are two SAS disks
(Fujitsu MAX3147RC) and one SATA (WDC WD1600YS-01S). And there phys
assigned in right order:
sas: phy0 added to port0, phy_mask:0x1
....
sas: phy1 added to port1, phy_mask:0x2
sas: phy2 added to port2, phy_mask:0x4

I think it only related to cases there are more then one SATA disk
connected to controller. Probably this happened because SATA disks
replay to escb requests in wrong order.
I've included below fragments of dmesg that related to aic94xx from
first and second boot of my server. I think this may help to figure out
why disks assigned in such order.

first:
aic94xx: Adaptec aic94xx SAS/SATA driver version 1.0.3 loaded
ACPI: PCI Interrupt 0000:09:02.0[A] -> GSI 18 (level, low) -> IRQ 17
aic94xx: found Adaptec AIC-9410W SAS/SATA Host Adapter, device 0000:09:02.0
scsi2 : aic94xx
aic94xx: BIOS present (1,1), 1822
aic94xx: ue num:3, ue size:88
aic94xx: manuf sect SAS_ADDR 500304800022cd30
aic94xx: manuf sect PCBA SN ORG
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
aic94xx: ctrla: phy0: sas_addr: 500304800022cd30, sas rate:0x9-0x8, sata rate:0x0-0x0, flags:0x0
aic94xx: ctrla: phy1: sas_addr: 500304800022cd31, sas rate:0x9-0x8, sata rate:0x0-0x0, flags:0x0
aic94xx: ctrla: phy2: sas_addr: 500304800022cd32, sas rate:0x9-0x8, sata rate:0x0-0x0, flags:0x0
aic94xx: ctrla: phy3: sas_addr: 500304800022cd30, sas rate:0x9-0x8, sata rate:0x0-0x0, flags:0x0
aic94xx: ctrla: phy4: sas_addr: 500304800022cd30, sas rate:0x9-0x8, sata rate:0x0-0x0, flags:0x0
aic94xx: ctrla: phy5: sas_addr: 500304800022cd30, sas rate:0x9-0x8, sata rate:0x0-0x0, flags:0x0
aic94xx: ctrla: phy6: sas_addr: 500304800022cd30, sas rate:0x9-0x8, sata rate:0x0-0x0, flags:0x0
aic94xx: ctrla: phy7: sas_addr: 500304800022cd30, sas rate:0x9-0x8, sata rate:0x0-0x0, flags:0x0
aic94xx: max_scbs:512, max_ddbs:128
aic94xx: setting phy0 addr to 500304800022cd30
aic94xx: setting phy1 addr to 500304800022cd30
aic94xx: setting phy2 addr to 500304800022cd30
aic94xx: setting phy3 addr to 500304800022cd30
aic94xx: setting phy4 addr to 500304800022cd30
aic94xx: setting phy5 addr to 500304800022cd30
aic94xx: setting phy6 addr to 500304800022cd30
aic94xx: setting phy7 addr to 500304800022cd30
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
aic94xx: First SCB dma_handle: 0x37e92000
aic94xx: device 0000:09:02.0: SAS addr 500304800022cd30, PCBA SN ORG, 8 phys, 8 enabled phys, flash present, BIOS build 1822
aic94xx: posting 3 escbs
aic94xx: escbs posted
aic94xx: posting 8 control phy scbs
aic94xx: control_phy_tasklet_complete: phy0, lrate:0x8, proto:0xe
aic94xx: control_phy_tasklet_complete: phy1, lrate:0x8, proto:0xe
aic94xx: control_phy_tasklet_complete: phy2, lrate:0x8, proto:0xe
aic94xx: escb_tasklet_complete: phy1: BYTES_DMAED
aic94xx: STP proto device-to-host FIS:
aic94xx: 00: 34 00 50 01
aic94xx: 04: 01 00 00 a0
aic94xx: 08: 00 00 00 00
aic94xx: 0c: 01 00 00 00
aic94xx: 10: 00 00 00 00
aic94xx: asd_form_port: updating phy_mask 0x2 for phy1
sas: phy1 added to port0, phy_mask:0x2
aic94xx: escb_tasklet_complete: phy2: BYTES_DMAED
aic94xx: STP proto device-to-host FIS:
aic94xx: 00: 34 00 50 01
aic94xx: 04: 01 00 00 a0
aic94xx: 08: 00 00 00 00
aic94xx: 0c: 01 00 00 00
aic94xx: 10: 00 00 00 00
aic94xx: asd_form_port: updating phy_mask 0x4 for phy2
sas: DOING DISCOVERY on port 0, pid:1514
aic94xx: control_phy_tasklet_complete: phy3: no device present: oob_status:0x0
aic94xx: control_phy_tasklet_complete: phy4: no device present: oob_status:0x0
aic94xx: control_phy_tasklet_complete: phy5: no device present: oob_status:0x0
aic94xx: control_phy_tasklet_complete: phy6: no device present: oob_status:0x0
aic94xx: control_phy_tasklet_complete: phy7: no device present: oob_status:0x0
sas: sas_ata_phy_reset: Found ATA device.
aic94xx: escb_tasklet_complete: phy0: BYTES_DMAED
aic94xx: STP proto device-to-host FIS:
aic94xx: 00: 34 00 50 01
aic94xx: 04: 01 00 00 a0
aic94xx: 08: 00 00 00 00
aic94xx: 0c: 01 00 00 00
aic94xx: 10: 00 00 00 00
aic94xx: asd_form_port: updating phy_mask 0x1 for phy0
ata3.00: ata_hpa_resize 1: hpa sectors (1) is smaller than sectors (490234752)
ata3.00: ATA-7: WDC WD2500YS-01SHB1, 20.06C06, max UDMA/133
ata3.00: 490234752 sectors, multi 0: LBA48 NCQ (depth 31/32)
ata3.00: ata_hpa_resize 1: hpa sectors (1) is smaller than sectors (490234752)
ata3.00: configured for UDMA/133
scsi 2:0:0:0: Direct-Access     ATA      WDC WD2500YS-01S 20.0 PQ: 0 ANSI: 5
sd 2:0:0:0: [sda] 490234752 512-byte hardware sectors (251000 MB)
sd 2:0:0:0: [sda] Write Protect is off
sd 2:0:0:0: [sda] Mode Sense: 00 3a 00 00
sd 2:0:0:0: [sda] Write cache: enabled, read cache: enabled, doesn't support DPO or FUA
sd 2:0:0:0: [sda] 490234752 512-byte hardware sectors (251000 MB)
sd 2:0:0:0: [sda] Write Protect is off
sd 2:0:0:0: [sda] Mode Sense: 00 3a 00 00
sd 2:0:0:0: [sda] Write cache: enabled, read cache: enabled, doesn't support DPO or FUA
 sda: unknown partition table
sd 2:0:0:0: [sda] Attached SCSI disk
sd 2:0:0:0: Attached scsi generic sg1 type 0
sas: DONE DISCOVERY on port 0, pid:1514, result:0
sas: phy2 added to port1, phy_mask:0x4
sas: phy0 added to port2, phy_mask:0x1
sas: DOING DISCOVERY on port 1, pid:1514
sas: sas_ata_phy_reset: Found ATA device.
ata4.00: ata_hpa_resize 1: hpa sectors (1) is smaller than sectors (490234752)
ata4.00: ATA-7: WDC WD2500YS-01SHB1, 20.06C06, max UDMA/133
ata4.00: 490234752 sectors, multi 0: LBA48 NCQ (depth 31/32)
ata4.00: ata_hpa_resize 1: hpa sectors (1) is smaller than sectors (490234752)
ata4.00: configured for UDMA/133
scsi 2:0:1:0: Direct-Access     ATA      WDC WD2500YS-01S 20.0 PQ: 0 ANSI: 5
sd 2:0:1:0: [sdb] 490234752 512-byte hardware sectors (251000 MB)
sd 2:0:1:0: [sdb] Write Protect is off
sd 2:0:1:0: [sdb] Mode Sense: 00 3a 00 00
sd 2:0:1:0: [sdb] Write cache: enabled, read cache: enabled, doesn't support DPO or FUA
sd 2:0:1:0: [sdb] 490234752 512-byte hardware sectors (251000 MB)
sd 2:0:1:0: [sdb] Write Protect is off
sd 2:0:1:0: [sdb] Mode Sense: 00 3a 00 00
sd 2:0:1:0: [sdb] Write cache: enabled, read cache: enabled, doesn't support DPO or FUA
 sdb: unknown partition table
sd 2:0:1:0: [sdb] Attached SCSI disk
sd 2:0:1:0: Attached scsi generic sg2 type 0
sas: DONE DISCOVERY on port 1, pid:1514, result:0
sas: DOING DISCOVERY on port 2, pid:1514
sas: sas_ata_phy_reset: Found ATA device.
ata5.00: ATA-7: WDC WD800AAJS-60PSA0, 21.12M22, max UDMA/100
ata5.00: 156301488 sectors, multi 0: LBA48 NCQ (depth 31/32)
ata5.00: configured for UDMA/100
scsi 2:0:2:0: Direct-Access     ATA      WDC WD800AAJS-60 21.1 PQ: 0 ANSI: 5
sd 2:0:2:0: [sdc] 156301488 512-byte hardware sectors (80026 MB)
sd 2:0:2:0: [sdc] Write Protect is off
sd 2:0:2:0: [sdc] Mode Sense: 00 3a 00 00
sd 2:0:2:0: [sdc] Write cache: enabled, read cache: enabled, doesn't support DPO or FUA
sd 2:0:2:0: [sdc] 156301488 512-byte hardware sectors (80026 MB)
sd 2:0:2:0: [sdc] Write Protect is off
sd 2:0:2:0: [sdc] Mode Sense: 00 3a 00 00
sd 2:0:2:0: [sdc] Write cache: enabled, read cache: enabled, doesn't support DPO or FUA
 sdc: sdc1
sd 2:0:2:0: [sdc] Attached SCSI disk
sd 2:0:2:0: Attached scsi generic sg3 type 0
sas: DONE DISCOVERY on port 2, pid:1514, result:0

second:
aic94xx: found Adaptec AIC-9410W SAS/SATA Host Adapter, device 0000:09:02.0
scsi2 : aic94xx
aic94xx: BIOS present (1,1), 1822
aic94xx: ue num:3, ue size:88
aic94xx: manuf sect SAS_ADDR 500304800022cd30
aic94xx: manuf sect PCBA SN ORG
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
aic94xx: ctrla: phy0: sas_addr: 500304800022cd30, sas rate:0x9-0x8, sata rate:0x0-0x0, flags:0x0
aic94xx: ctrla: phy1: sas_addr: 500304800022cd31, sas rate:0x9-0x8, sata rate:0x0-0x0, flags:0x0
aic94xx: ctrla: phy2: sas_addr: 500304800022cd32, sas rate:0x9-0x8, sata rate:0x0-0x0, flags:0x0
aic94xx: ctrla: phy3: sas_addr: 500304800022cd30, sas rate:0x9-0x8, sata rate:0x0-0x0, flags:0x0
aic94xx: ctrla: phy4: sas_addr: 500304800022cd30, sas rate:0x9-0x8, sata rate:0x0-0x0, flags:0x0
aic94xx: ctrla: phy5: sas_addr: 500304800022cd30, sas rate:0x9-0x8, sata rate:0x0-0x0, flags:0x0
aic94xx: ctrla: phy6: sas_addr: 500304800022cd30, sas rate:0x9-0x8, sata rate:0x0-0x0, flags:0x0
aic94xx: ctrla: phy7: sas_addr: 500304800022cd30, sas rate:0x9-0x8, sata rate:0x0-0x0, flags:0x0
aic94xx: max_scbs:512, max_ddbs:128
aic94xx: setting phy0 addr to 500304800022cd30
aic94xx: setting phy1 addr to 500304800022cd30
aic94xx: setting phy2 addr to 500304800022cd30
aic94xx: setting phy3 addr to 500304800022cd30
aic94xx: setting phy4 addr to 500304800022cd30
aic94xx: setting phy5 addr to 500304800022cd30
aic94xx: setting phy6 addr to 500304800022cd30
aic94xx: setting phy7 addr to 500304800022cd30
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
aic94xx: First SCB dma_handle: 0x37dc9000
aic94xx: device 0000:09:02.0: SAS addr 500304800022cd30, PCBA SN ORG, 8 phys, 8 enabled phys, flash present, BIOS build 1822
aic94xx: posting 3 escbs
aic94xx: escbs posted
aic94xx: posting 8 control phy scbs
aic94xx: control_phy_tasklet_complete: phy0, lrate:0x8, proto:0xe
aic94xx: control_phy_tasklet_complete: phy1, lrate:0x8, proto:0xe
aic94xx: control_phy_tasklet_complete: phy2, lrate:0x8, proto:0xe
aic94xx: escb_tasklet_complete: phy2: BYTES_DMAED
aic94xx: STP proto device-to-host FIS:
aic94xx: 00: 34 00 50 01
aic94xx: 04: 01 00 00 a0
aic94xx: 08: 00 00 00 00
aic94xx: 0c: 01 00 00 00
aic94xx: 10: 00 00 00 00
aic94xx: asd_form_port: updating phy_mask 0x4 for phy2
sas: phy2 added to port0, phy_mask:0x4
sas: DOING DISCOVERY on port 0, pid:2258
aic94xx: escb_tasklet_complete: phy1: BYTES_DMAED
aic94xx: STP proto device-to-host FIS:
aic94xx: 00: 34 00 50 01
aic94xx: 04: 01 00 00 a0
aic94xx: 08: 00 00 00 00
aic94xx: 0c: 01 00 00 00
aic94xx: 10: 00 00 00 00
aic94xx: asd_form_port: updating phy_mask 0x2 for phy1
aic94xx: control_phy_tasklet_complete: phy3: no device present: oob_status:0x0
aic94xx: control_phy_tasklet_complete: phy4: no device present: oob_status:0x0
aic94xx: control_phy_tasklet_complete: phy5: no device present: oob_status:0x0
aic94xx: control_phy_tasklet_complete: phy6: no device present: oob_status:0x0
aic94xx: control_phy_tasklet_complete: phy7: no device present: oob_status:0x0
sas: sas_ata_phy_reset: Found ATA device.
aic94xx: escb_tasklet_complete: phy0: BYTES_DMAED
aic94xx: STP proto device-to-host FIS:
aic94xx: 00: 34 00 50 01
aic94xx: 04: 01 00 00 a0
aic94xx: 08: 00 00 00 00
aic94xx: 0c: 01 00 00 00
aic94xx: 10: 00 00 00 00
aic94xx: asd_form_port: updating phy_mask 0x1 for phy0
ata3.00: ata_hpa_resize 1: hpa sectors (1) is smaller than sectors (490234752)
ata3.00: ATA-7: WDC WD2500YS-01SHB1, 20.06C06, max UDMA/133
ata3.00: 490234752 sectors, multi 0: LBA48 NCQ (depth 31/32)
ata3.00: ata_hpa_resize 1: hpa sectors (1) is smaller than sectors (490234752)
ata3.00: configured for UDMA/133
scsi 2:0:0:0: Direct-Access     ATA      WDC WD2500YS-01S 20.0 PQ: 0 ANSI: 5
sd 2:0:0:0: [sda] 490234752 512-byte hardware sectors (251000 MB)
sd 2:0:0:0: [sda] Write Protect is off
sd 2:0:0:0: [sda] Mode Sense: 00 3a 00 00
sd 2:0:0:0: [sda] Write cache: enabled, read cache: enabled, doesn't support DPO or FUA
sd 2:0:0:0: [sda] 490234752 512-byte hardware sectors (251000 MB)
sd 2:0:0:0: [sda] Write Protect is off
sd 2:0:0:0: [sda] Mode Sense: 00 3a 00 00
sd 2:0:0:0: [sda] Write cache: enabled, read cache: enabled, doesn't support DPO or FUA
 sda: unknown partition table
sd 2:0:0:0: [sda] Attached SCSI disk
sd 2:0:0:0: Attached scsi generic sg1 type 0
sas: DONE DISCOVERY on port 0, pid:2258, result:0
sas: phy1 added to port1, phy_mask:0x2
sas: phy0 added to port2, phy_mask:0x1
sas: DOING DISCOVERY on port 1, pid:2258
sas: sas_ata_phy_reset: Found ATA device.
ata4.00: ata_hpa_resize 1: hpa sectors (1) is smaller than sectors (490234752)
ata4.00: ATA-7: WDC WD2500YS-01SHB1, 20.06C06, max UDMA/133
ata4.00: 490234752 sectors, multi 0: LBA48 NCQ (depth 31/32)
ata4.00: ata_hpa_resize 1: hpa sectors (1) is smaller than sectors (490234752)
ata4.00: configured for UDMA/133
scsi 2:0:1:0: Direct-Access     ATA      WDC WD2500YS-01S 20.0 PQ: 0 ANSI: 5
sd 2:0:1:0: [sdb] 490234752 512-byte hardware sectors (251000 MB)
sd 2:0:1:0: [sdb] Write Protect is off
sd 2:0:1:0: [sdb] Mode Sense: 00 3a 00 00
sd 2:0:1:0: [sdb] Write cache: enabled, read cache: enabled, doesn't support DPO or FUA
sd 2:0:1:0: [sdb] 490234752 512-byte hardware sectors (251000 MB)
sd 2:0:1:0: [sdb] Write Protect is off
sd 2:0:1:0: [sdb] Mode Sense: 00 3a 00 00
sd 2:0:1:0: [sdb] Write cache: enabled, read cache: enabled, doesn't support DPO or FUA
 sdb: unknown partition table
sd 2:0:1:0: [sdb] Attached SCSI disk
sd 2:0:1:0: Attached scsi generic sg2 type 0
sas: DONE DISCOVERY on port 1, pid:2258, result:0
sas: DOING DISCOVERY on port 2, pid:2258
sas: sas_ata_phy_reset: Found ATA device.
ata5.00: ATA-7: WDC WD800AAJS-60PSA0, 21.12M22, max UDMA/100
ata5.00: 156301488 sectors, multi 0: LBA48 NCQ (depth 31/32)
ata5.00: configured for UDMA/100
scsi 2:0:2:0: Direct-Access     ATA      WDC WD800AAJS-60 21.1 PQ: 0 ANSI: 5
sd 2:0:2:0: [sdc] 156301488 512-byte hardware sectors (80026 MB)
sd 2:0:2:0: [sdc] Write Protect is off
sd 2:0:2:0: [sdc] Mode Sense: 00 3a 00 00
sd 2:0:2:0: [sdc] Write cache: enabled, read cache: enabled, doesn't support DPO or FUA
sd 2:0:2:0: [sdc] 156301488 512-byte hardware sectors (80026 MB)
sd 2:0:2:0: [sdc] Write Protect is off
sd 2:0:2:0: [sdc] Mode Sense: 00 3a 00 00
sd 2:0:2:0: [sdc] Write cache: enabled, read cache: enabled, doesn't support DPO or FUA
 sdc: sdc1
sd 2:0:2:0: [sdc] Attached SCSI disk
sd 2:0:2:0: Attached scsi generic sg3 type 0
sas: DONE DISCOVERY on port 2, pid:2258, result:0

With best regards,
Sergey Kononenko.
