From: Ondrej Zary <linux@rainbow-software.org>
Subject: 3.2.57 regression: isci driver broken: Unable to reset I T nexus?
Date: Mon, 28 Apr 2014 13:03:24 +0200
Message-ID: <201404281303.24977.linux@rainbow-software.org>
Mime-Version: 1.0
Content-Type: Text/Plain;
  charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
To: Intel SCU Linux support <intel-linux-scu@intel.com>
Cc: linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org

Hello,
just upgraded a server running 3.2.54-2 to 3.2.57-3 (Debian Wheezy) and it
does not boot anymore because of isci driver breakage.

A (partial) log transcription:
sas: DOING DISCOVERY on port 0, pid:5
sas: Enter sas_scsi_recover_host
ata1: sas eh calling libata port error handler
sas: sas_ata_hard_reset: Unable to reset I T nexus?
sas: sas_ata_hard_reset: Found ATA device.
sas: sas_ata_hard_reset: Unable to soft reset
sas: sas_ata_hard_reset: Found ATA device.
ata1: reset failed (errno=-11), retrying in 10 secs
sas: sas_ata_hard_reset: Unable to reset I T nexus?
sas: sas_ata_hard_reset: Found ATA device.
sas: sas_ata_hard_reset: Unable to soft reset
sas: sas_ata_hard_reset: Found ATA device.
ata1: reset failed (errno=-11), retrying in 35 secs
ata1: reset failed, giving up
sas: --- Exit sas_scsi_recover_host
sas: DONE DISCOVERY on port 0, pid: 5, result:0
sas: phy-0:1 added to port-0:1, phy_mask:0x2 (5fcfffff00000002)
sas: DOING DISCOVERY on port 1, pid:5
sas: Enter sas_scsi_recover_host
ata1: sas eh calling libata port error handler
sas: sas_ata_hard_reset: Unable to reset I T nexus?
sas: sas_ata_hard_reset: Found ATA device.
sas: sas_ata_hard_reset: Unable to soft reset
sas: sas_ata_hard_reset: Found ATA device.
ata2: reset failed (errno=-11), retrying in 10 secs
sas: sas_ata_hard_reset: Unable to reset I T nexus?
sas: sas_ata_hard_reset: Found ATA device.
sas: sas_ata_hard_reset: Unable to soft reset
sas: sas_ata_hard_reset: Found ATA device.
ata2: reset failed (errno=-11), retrying in 35 secs
ata2: reset failed, giving up


It should look like this (v3.2.54-2):
isci: Intel(R) C600 SAS Controller Driver - version 1.0.0
isci 0000:03:00.0: driver configured for rev: 6 silicon
isci 0000:03:00.0: firmware: agent loaded isci/isci_firmware.bin into memory
isci 0000:03:00.0: OEM SAS parameters (version: 1.3) loaded (firmware)
isci 0000:03:00.0: setting latency timer to 64
scsi0 : isci
scsi1 : isci
isci 0000:03:00.0: irq 81 for MSI/MSI-X
isci 0000:03:00.0: irq 82 for MSI/MSI-X
isci 0000:03:00.0: irq 83 for MSI/MSI-X
isci 0000:03:00.0: irq 84 for MSI/MSI-X
sas: phy-0:0 added to port-0:0, phy_mask:0x1 (5fcfffff00000001)
sas: DOING DISCOVERY on port 0, pid:5
sas: Enter sas_scsi_recover_host
ata1: sas eh calling libata port error handler
sas: sas_ata_hard_reset: Found ATA device.
ata1.00: ATA-8: ST9500620NS, CC02, max UDMA/133
ata1.00: 976773168 sectors, multi 0: LBA48 NCQ (depth 31/32)
ata1.00: configured for UDMA/133
sas: --- Exit sas_scsi_recover_host
scsi 0:0:0:0: Direct-Access     ATA      ST9500620NS      CC02 PQ: 0 ANSI: 5
sas: DONE DISCOVERY on port 0, pid:5, result:0
sas: phy-0:1 added to port-0:1, phy_mask:0x2 (5fcfffff00000002)
sas: DOING DISCOVERY on port 1, pid:5
sas: Enter sas_scsi_recover_host
ata1: sas eh calling libata port error handler
ata2: sas eh calling libata port error handler
sas: sas_ata_hard_reset: Found ATA device.
ata2.00: ATA-8: ST9500620NS, CC02, max UDMA/133
ata2.00: 976773168 sectors, multi 0: LBA48 NCQ (depth 31/32)
ata2.00: configured for UDMA/133
sas: --- Exit sas_scsi_recover_host
scsi 0:0:1:0: Direct-Access     ATA      ST9500620NS      CC02 PQ: 0 ANSI: 5
sas: DONE DISCOVERY on port 1, pid:5, result:0

-- 
Ondrej Zary
