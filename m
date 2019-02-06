From: John Garry <john.garry@huawei.com>
Subject: [PATCH 0/6] hisi_sas: DIX support, performance optimisation, and misc patches
Date: Wed, 6 Feb 2019 18:52:50 +0800
Message-ID: <1549450376-114929-1-git-send-email-john.garry@huawei.com>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <linux-kernel-owner@vger.kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
To: jejb@linux.vnet.ibm.com, martin.petersen@oracle.com
Cc: linuxarm@huawei.com, linux-kernel@vger.kernel.org, linux-scsi@vger.kernel.org, John Garry <john.garry@huawei.com>
List-Id: linux-scsi@vger.kernel.org

This patchset introduces the following:
- DIX support for v3 hw

- Optimisation based on mapping CPUs to queues, much the same as other
  SCSI drivers do today, without exposing > 1 queue to upper layer.

  It is disabled by default and marked as experimental, due to ongoing
  discussion here:
  https://marc.info/?l=linux-scsi&m=154876335707751&w=2

  In addition, hopefully we can eventually expose > 1 queue to upper
  layer and remove the reply_map, if performance issue discussed here has
  a positive outcome:
  https://marc.info/?l=linux-scsi&m=154874776701343&w=2

- And some other minor tidying and a driver debugfs feature  

This series is based on Martin's 5.1 queue +
"scsi: hisi_sas: Set protection parameters prior to adding SCSI host"

John Garry (2):
  scsi: hisi_sas: Issue internal abort on all relevant queues
  scsi: hisi_sas: Do some more tidy-up

Luo Jiaxing (1):
  scsi: hisi_sas: Add manual trigger for debugfs dump

Xiang Chen (3):
  scsi: hisi_sas: Add support for DIX feature for v3 hw
  scsi: hisi_sas: change queue depth from 512 to 4096
  scsi: hisi_sas: Use pci_irq_get_affinity() for v3 hw as experimental

 drivers/scsi/hisi_sas/hisi_sas.h       |  48 +++--
 drivers/scsi/hisi_sas/hisi_sas_main.c  | 237 +++++++++++++++++++++----
 drivers/scsi/hisi_sas/hisi_sas_v1_hw.c |   2 +
 drivers/scsi/hisi_sas/hisi_sas_v2_hw.c |   3 +
 drivers/scsi/hisi_sas/hisi_sas_v3_hw.c | 157 +++++++++++++---
 5 files changed, 377 insertions(+), 70 deletions(-)

-- 
2.17.1
