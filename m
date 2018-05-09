From: John Garry <john.garry@huawei.com>
Subject: [PATCH 0/6] hisi_sas: improve DQ locking
Date: Wed, 9 May 2018 23:10:44 +0800
Message-ID: <1525878650-213087-1-git-send-email-john.garry@huawei.com>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <linux-kernel-owner@vger.kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
To: jejb@linux.vnet.ibm.com, martin.petersen@oracle.com
Cc: linux-scsi@vger.kernel.org, linuxarm@huawei.com, linux-kernel@vger.kernel.org, John Garry <john.garry@huawei.com>
List-Id: linux-scsi@vger.kernel.org

This patchset introduces some patches to much
improve DQ lockout for sending commands to the
HW.

Currently we lockout the complete DQ when building
and sending a task to the HW.

The reason we did this was because once we allocate
a slot in the DQ to use, if we fail the send the
slot then the slot must be reused. We cannot simply
forget about the slot and allow subsequent slots
in the DQ to be used.

To improve this and reduce this DQ lockout, we change
the order in which we allocate and build a slot.

We must now do any steps *which may fail* before
allocating the slot. So this means that once we
allocate the slot we cannot fail to send it.

By doing this we can greatly reduce the periods
in which we lock the DQ for building and sending
a slot, allowing more parallelism in sending
commands to HW.

Overall this DQ locking improvement has shown to
improve performance, and also will make MQ perform
better if ever turned on.

Xiang Chen (5):
  scsi: hisi_sas: relocate smp sg map
  scsi: hisi_sas: make return type of prep functions void
  scsi: hisi_sas: allocate slot buffer earlier
  scsi: hisi_sas: Don't lock DQ for complete task sending
  scsi: hisi_sas: Use device lock to protect slot alloc/free

Xiaofei Tan (1):
  scsi: hisi_sas: add check of device in hisi_sas_task_exec()

 drivers/scsi/hisi_sas/hisi_sas.h       |  12 +-
 drivers/scsi/hisi_sas/hisi_sas_main.c  | 264 ++++++++++++++++++---------------
 drivers/scsi/hisi_sas/hisi_sas_v1_hw.c |  88 ++++-------
 drivers/scsi/hisi_sas/hisi_sas_v2_hw.c | 109 +++++---------
 drivers/scsi/hisi_sas/hisi_sas_v3_hw.c | 107 +++++--------
 5 files changed, 248 insertions(+), 332 deletions(-)

-- 
1.9.1
