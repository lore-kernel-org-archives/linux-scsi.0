From: John Garry <john.garry@huawei.com>
Subject: [PATCH 0/7] hisi_sas: Misc bugfixes and an optimisation patch
Date: Mon, 24 Sep 2018 23:06:27 +0800
Message-ID: <1537801594-207139-1-git-send-email-john.garry@huawei.com>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <linux-kernel-owner@vger.kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
To: jejb@linux.vnet.ibm.com, martin.petersen@oracle.com
Cc: linuxarm@huawei.com, linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org, John Garry <john.garry@huawei.com>
List-Id: linux-scsi@vger.kernel.org

This patchset introduces mostly more minor/obscure bugfixes for the
driver.

Also included is an optimisation to use the block layer tag for the IPTT
indexing. This quite a nice optimisation as it means we don't have to
evaluate this in the driver - it was a bit of a bottle-neck.

However it does block us in future from enabling SCSI MQ in the driver.
This is because the IPTT index must be a unique value per HBA. However,
if we switched to SCSI MQ, the block layer tag becomes unique per queue,
and not per HBA.

Having said this, testing has shown that performance is better by using
this block layer tag instead of enabling SCSI MQ in the driver.

Luo Jiaxing (2):
  scsi: hisi_sas: Feed back linkrate(max/min) when re-attached
  scsi: hisi_sas: Move evaluation of hisi_hba in hisi_sas_task_prep()

Xiang Chen (5):
  scsi: hisi_sas: Fix the race between IO completion and timeout for
    SMP/internal IO
  scsi: hisi_sas: Free slot later in slot_complete_vx_hw()
  scsi: hisi_sas: unmask interrupts ent72 and ent74
  scsi: hisi_sas: Use block layer tag instead for IPTT
  scsi: hisi_sas: Update v3 hw AIP_LIMIT and CFG_AGING_TIME register
    values

 drivers/scsi/hisi_sas/hisi_sas.h       |   3 +-
 drivers/scsi/hisi_sas/hisi_sas_main.c  | 154 ++++++++++++++++++++++++---------
 drivers/scsi/hisi_sas/hisi_sas_v1_hw.c |   1 -
 drivers/scsi/hisi_sas/hisi_sas_v2_hw.c |  11 +--
 drivers/scsi/hisi_sas/hisi_sas_v3_hw.c |  15 ++--
 5 files changed, 130 insertions(+), 54 deletions(-)

-- 
1.9.1
