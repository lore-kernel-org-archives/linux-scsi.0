From: John Garry <john.garry@huawei.com>
Subject: [PATCH 00/13] hisi_sas: Misc improvements, bugfixes, etc.
Date: Mon, 21 May 2018 18:09:12 +0800
Message-ID: <1526897365-228549-1-git-send-email-john.garry@huawei.com>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <linux-kernel-owner@vger.kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
To: jejb@linux.vnet.ibm.com, martin.petersen@oracle.com
Cc: linux-scsi@vger.kernel.org, linuxarm@huawei.com, linux-kernel@vger.kernel.org, John Garry <john.garry@huawei.com>
List-Id: linux-scsi@vger.kernel.org

This patchset introduces some misc improvements, bugfixes,
and SoC workarounds for the driver, including:
- workaround for v2 hw reset with SATA disks attached
- LED SGPIO support for v3 hw
- Fix for error path in task_prep function
- change slot and disk allocation method to avoid
  unknown SoC bugs
- fix potential problem of removing the driver when
  a disk is mounted
- other more minor stuff

John Garry (1):
  scsi: hisi_sas: Introduce hisi_sas_phy_set_linkrate()

Xiang Chen (5):
  scsi: hisi_sas: change slot index allocation mode
  scsi: hisi_sas: Change common allocation mode of device id
  scsi: hisi_sas: Reset disks when discovered
  scsi: hisi_sas: Create a scsi_host_template per HW module
  scsi: hisi_sas: Mark PHY as in reset for nexus reset

Xiaofei Tan (7):
  scsi: hisi_sas: Add LED feature for v3 hw
  scsi: hisi_sas: Init disks after controller reset
  scsi: hisi_sas: Try wait commands before before controller reset
  scsi: hisi_sas: Include TMF elements in struct hisi_sas_slot
  scsi: hisi_sas: Add v2 hw force PHY function for internal ATA command
  scsi: hisi_sas: Terminate STP reject quickly for v2 hw
  scsi: hisi_sas: Fix return value when get_free_slot() failed

 drivers/scsi/hisi_sas/hisi_sas.h       |  33 ++--
 drivers/scsi/hisi_sas/hisi_sas_main.c  | 294 +++++++++++++++++++++++++++------
 drivers/scsi/hisi_sas/hisi_sas_v1_hw.c |  78 ++++-----
 drivers/scsi/hisi_sas/hisi_sas_v2_hw.c |  99 ++++++++---
 drivers/scsi/hisi_sas/hisi_sas_v3_hw.c | 124 +++++++++++---
 5 files changed, 483 insertions(+), 145 deletions(-)

-- 
1.9.1
