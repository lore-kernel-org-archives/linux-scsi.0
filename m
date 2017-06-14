From: John Garry <john.garry@huawei.com>
Subject: [PATCH v6 00/22] hisi_sas: hip08 support
Date: Wed, 14 Jun 2017 23:33:10 +0800
Message-ID: <1497454412-91194-1-git-send-email-john.garry@huawei.com>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <linux-kernel-owner@vger.kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
To: jejb@linux.vnet.ibm.com, martin.petersen@oracle.com
Cc: linuxarm@huawei.com, linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org, arnd@arndb.de, hch@infradead.org, John Garry <john.garry@huawei.com>
List-Id: linux-scsi@vger.kernel.org

This patchset adds support for the HiSilicon SAS controller
in the hip08 chipset.

The key difference compared to earlier chipsets is that the
controller is an integrated PCI endpoint in hip08.
As such, the controller is a pci device (not a platform device,
like v2 hw in hip07).

The driver is refactored so it can support both platform and 
pci device-based controllers.

New hw layer file hisi_sas_v3_hw.c is added for v3 hw
support, which also includes pci device proving and
initialisation. 

Common functionality is still in hisi_sas_main.c, along with
platform device probing and initialization.

As for the patches, (ignoring #1-3) the first few
reorganise some functions from v2 hw.c into main.c, as they
are required for v3 hw. Then support is added for pci
device-based controller in subsequent patches.
And then hip08 support is added in the final patches.

Differences to v5 series:
- Fixed erroneous spinlock flag reuse
- Omit support ECC and AXI bus fatal error support

Difference to v4 series:
-report SAS_DATA_UNDERRUN to libsas for underflow

Differences to v3 series:
- Addressed Christoph's comments, including:
 - remove msi disable in probe, and improve irq
    registration and deregistration
 - remove hisi_sas_is_rw_cmd() to check underflow,
    and use scsi_cmnd underflow field instead

Differences to v2 series:
- Add patch to change hisi_sas_device.device_id size
- Add device dq pointer
- Remove hisi_sas_v3_hw prototype in v3 driver
- Add explicit comment in hisi_sas_get_fw_info()

Differences to v1 series:
- Addressed Arnd's comments, including:
 - read sas address from device node DSD under PCI host
    bridge
 - add comment in fatal axi error patch commit log regarding
    controller reset
 - eliminate hisi_sas_pci_init.c, and move functionality into
    hisi_sas_v3_hw.c, eliminating one layer of indirection

John Garry (5):
  scsi: hisi_sas: define hisi_sas_device.device_id as int
  scsi: hisi_sas: add pci_dev in hisi_hba struct
  scsi: hisi_sas: create hisi_sas_get_fw_info()
  scsi: hisi_sas: add skeleton v3 hw driver
  scsi: hisi_sas: add initialisation for v3 pci-based controller

Xiang Chen (17):
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
  scsi: hisi_sas: add v3 code to fill some more hw function pointers
  scsi: hisi_sas: modify internal abort dev flow for v3 hw

 drivers/scsi/hisi_sas/Kconfig          |   10 +-
 drivers/scsi/hisi_sas/Makefile         |    1 +
 drivers/scsi/hisi_sas/hisi_sas.h       |   42 +-
 drivers/scsi/hisi_sas/hisi_sas_main.c  |  363 +++++--
 drivers/scsi/hisi_sas/hisi_sas_v1_hw.c |   51 +-
 drivers/scsi/hisi_sas/hisi_sas_v2_hw.c |  179 +---
 drivers/scsi/hisi_sas/hisi_sas_v3_hw.c | 1846 ++++++++++++++++++++++++++++++++
 7 files changed, 2225 insertions(+), 267 deletions(-)
 create mode 100644 drivers/scsi/hisi_sas/hisi_sas_v3_hw.c

-- 
1.9.1
