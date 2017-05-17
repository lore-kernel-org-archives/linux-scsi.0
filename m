From: John Garry <john.garry@huawei.com>
Subject: [PATCH 00/22] hisi_sas: hip08 support
Date: Wed, 17 May 2017 18:49:35 +0800
Message-ID: <1495018197-120535-1-git-send-email-john.garry@huawei.com>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <linux-kernel-owner@vger.kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
To: jejb@linux.vnet.ibm.com, martin.petersen@oracle.com
Cc: john.garry2@mail.dcu.ie, linuxarm@huawei.com, linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org, arnd@arndb.de, John Garry <john.garry@huawei.com>
List-Id: linux-scsi@vger.kernel.org

This patchset adds support for the HiSilicon SAS controller
in the hip08 chipset.

The key difference compared to earlier chipsets is that the
controller is an integrated PCI endpoint in hip08.
As such, the controller is a pci device (not a platform device,
like v2 hw in hip07).

The driver is refactored so it can support both platform and 
pci device-based controllers.

File hisi_sas_pci_init.c is introduced for pci device probing
and initialization. Common functionality is still in
hisi_sas_main.c, along with platform device probing and
initialization.

New hw layer file hisi_sas_v3_hw.c is added for hip08
controller support. HW revisions v2 and v3 are very similar,
but it was decided to keep support in separate files for now.

As for the patches, (ignoring #1 and #2) the first few
reorganise some functions from v2 hw.c into main.c, as they
are required for v3 hw. Then support is added for pci
device-based controller in subsequent patches.
And then hip08 support is added in the final patches.

John Garry (4):
  scsi: hisi_sas: add pci_dev in hisi_hba struct
  scsi: hisi_sas: add the initialisation for pci-based controller
  scsi: hisi_sas: add bare v3 hw driver
  scsi: hisi_sas: retrieve SAS address for pci-based controller

Xiang Chen (18):
  scsi: hisi_sas: fix timeout check in hisi_sas_internal_task_abort()
  scsi: hisi_sas: optimise the usage of hisi_hba.lock
  scsi: hisi_sas: relocate get_ata_protocol()
  scsi: hisi_sas: relocate sata_done_v2_hw()
  scsi: hisi_sas: relocate get_ncq_tag_v2_hw()
  scsi: hisi_sas: add v3 hw init
  scsi: hisi_sas: add v3 hw PHY init
  scsi: hisi_sas: add phy up/down/bcast and channel ISR
  scsi: hisi_sas: add v3 cq interrupt handler
  scsi: hisi_sas: add v3 code to send SSP frame
  scsi: hisi_sas: add v3 code to send SMP frame
  scsi: hisi_sas: add v3 code to send ATA frame
  scsi: hisi_sas: add v3 code for itct setup and free
  scsi: hisi_sas: add v3 code to send internal abort command
  scsi: hisi_sas: add get_wideport_bitmap_v3_hw()
  scsi: hisi_sas: Add v3 code to support ECC and AXI bus fatal error
  scsi: hisi_sas: add v3 code to fill some more hw function pointers
  scsi: hisi_sas: modify internal abort dev flow for v3 hw

 drivers/scsi/hisi_sas/Kconfig             |   10 +-
 drivers/scsi/hisi_sas/Makefile            |    2 +
 drivers/scsi/hisi_sas/hisi_sas.h          |   42 +-
 drivers/scsi/hisi_sas/hisi_sas_main.c     |  280 +++-
 drivers/scsi/hisi_sas/hisi_sas_pci_init.c |  286 ++++
 drivers/scsi/hisi_sas/hisi_sas_v1_hw.c    |   51 +-
 drivers/scsi/hisi_sas/hisi_sas_v2_hw.c    |  175 +--
 drivers/scsi/hisi_sas/hisi_sas_v3_hw.c    | 2090 +++++++++++++++++++++++++++++
 8 files changed, 2714 insertions(+), 222 deletions(-)
 create mode 100644 drivers/scsi/hisi_sas/hisi_sas_pci_init.c
 create mode 100644 drivers/scsi/hisi_sas/hisi_sas_v3_hw.c

-- 
1.9.1
