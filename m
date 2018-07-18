From: John Garry <john.garry@huawei.com>
Subject: [PATCH 0/9] hisi_sas: Some misc patches
Date: Wed, 18 Jul 2018 22:14:24 +0800
Message-ID: <1531923273-193768-1-git-send-email-john.garry@huawei.com>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <linux-kernel-owner@vger.kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
To: jejb@linux.vnet.ibm.com, martin.petersen@oracle.com
Cc: linux-scsi@vger.kernel.org, linuxarm@huawei.com, linux-kernel@vger.kernel.org, John Garry <john.garry@huawei.com>
List-Id: linux-scsi@vger.kernel.org

This patchset introduces some misc patches, generally more minor in
importance.

However there is a patch to add a CPU barrier to the delivery path for
each hw version. We only saw this issue on v3 hw in hip08 chipset, where
the host CPU exhibits a looser memory model than in predecessors, and
software must enforce SMP coherency.

John Garry (1):
  scsi: hisi_sas: Drop hisi_sas_slot_abort()

Xiang Chen (2):
  scsi: hisi_sas: Tidy hisi_sas_task_prep()
  scsi: hisi_sas: Add SATA FIS check for v3 hw

Xiaofei Tan (6):
  scsi: hisi_sas: tidy channel interrupt handler for v3 hw
  scsi: hisi_sas: Fix the failure of recovering PHY from STP link
    timeout
  scsi: hisi_sas: tidy host controller reset function a bit
  scsi: hisi_sas: relocate some common code for v3 hw
  scsi: hisi_sas: Implement handlers of PCIe FLR for v3 hw
  scsi: hisi_sas: add memory barrier in task delivery function

 drivers/scsi/hisi_sas/hisi_sas.h       |   4 +-
 drivers/scsi/hisi_sas/hisi_sas_main.c  | 113 ++++++--------
 drivers/scsi/hisi_sas/hisi_sas_v1_hw.c |  20 +--
 drivers/scsi/hisi_sas/hisi_sas_v2_hw.c |  18 ++-
 drivers/scsi/hisi_sas/hisi_sas_v3_hw.c | 274 ++++++++++++++++++++-------------
 5 files changed, 239 insertions(+), 190 deletions(-)

-- 
1.9.1
