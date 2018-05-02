From: John Garry <john.garry@huawei.com>
Subject: [PATCH 00/11] hisi_sas: some misc patches
Date: Wed, 2 May 2018 23:56:23 +0800
Message-ID: <1525276594-92173-1-git-send-email-john.garry@huawei.com>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <linux-kernel-owner@vger.kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
To: jejb@linux.vnet.ibm.com, martin.petersen@oracle.com
Cc: linux-scsi@vger.kernel.org, linuxarm@huawei.com, linux-kernel@vger.kernel.org, John Garry <john.garry@huawei.com>
List-Id: linux-scsi@vger.kernel.org

This patchset introduces some misc changes for the
driver. These include:
- fixes for potential problems related to SCSI EH
  and device removal races
- fix protection info size for all hw versions
- some SoC bug workarounds
- minor optimisations
- other more minor things

John Garry (2):
  scsi: hisi_sas: stop controller timer for reset
  scsi: hisi_sas: add readl poll timeout helper wrappers

Xiang Chen (7):
  scsi: hisi_sas: optimise the usage of DQ locking
  scsi: hisi_sas: Add some checks to avoid free'ing a sas_task twice
  scsi: hisi_sas: check host frozen before calling "done" function
  scsi: hisi_sas: fix PI memory size
  scsi: hisi_sas: check sas_dev gone earlier in hisi_sas_abort_task()
  scsi: hisi_sas: update PHY linkrate after a controller reset
  scsi: hisi_sas: config ATA de-reset as an constrained command for v3
    hw

Xiaofei Tan (2):
  scsi: hisi_sas: remove redundant handling to event95 for v3
  scsi: hisi_sas: workaround a v3 hw hilink bug

 drivers/scsi/hisi_sas/hisi_sas.h       |   4 +-
 drivers/scsi/hisi_sas/hisi_sas_main.c  |  37 +++++++--
 drivers/scsi/hisi_sas/hisi_sas_v2_hw.c |  70 +++++++++-------
 drivers/scsi/hisi_sas/hisi_sas_v3_hw.c | 142 +++++++++++++++++++++------------
 4 files changed, 166 insertions(+), 87 deletions(-)

-- 
1.9.1
