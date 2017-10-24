From: John Garry <john.garry@huawei.com>
Subject: [PATCH 00/19] hisi_sas: misc fixes, improvements, and new features
Date: Tue, 24 Oct 2017 23:51:30 +0800
Message-ID: <1508860309-212397-1-git-send-email-john.garry@huawei.com>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <linux-kernel-owner@vger.kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
To: jejb@linux.vnet.ibm.com, martin.petersen@oracle.com
Cc: linuxarm@huawei.com, linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org, zhangfei.gao@linaro.org, John Garry <john.garry@huawei.com>
List-Id: linux-scsi@vger.kernel.org

This patchset contains many misc fixes, improvements,
and a few new features.

Here is a list of the significant changes:
- more fixes for hisi_hba.locking
- v3 hw DFX feature
- random error handling bugfixes
- reporting v2 hw errors to userspace

Shiju Jose (3):
  scsi: hisi_sas: use array for v2 hw AXI errors
  scsi: hisi_sas: report ECC errors in v2 hw to userspace
  scsi: hisi_sas: report v2 hw AXI errors to userspace

Xiang Chen (6):
  scsi: hisi_sas: delete get_ncq_tag_v3_hw()
  scsi: hisi_sas: fix internal abort slot timeout bug
  scsi: hisi_sas: grab hisi_hba.lock when processing slots
  scsi: hisi_sas: fix SATA breakpoint memory size
  scsi: hisi_sas: us start_phy in PHY_FUNC_LINK_RESET
  scsi: hisi_sas: fix a bug when free device for v3 hw

Xiaofei Tan (10):
  scsi: hisi_sas: use spin_lock_irqsave() for hisi_hba.lock
  scsi: hisi_sas: fix NULL check in SMP abort task path
  scsi: hisi_sas: fix the risk of freeing slot twice
  scsi: hisi_sas: check PHY state in get_wideport_bitmap_v3_hw()
  scsi: hisi_sas: init connect cfg register for v3 hw
  scsi: hisi_sas: add v3 hw DFX feature
  scsi: hisi_sas: add hisi_hba.rst_work init for v3 hw
  scsi: hisi_sas: complete all tasklets prior to host reset
  scsi: hisi_sas: add v3 hw support for AXI fatal error
  scsi: hisi_sas: add v3 hw port AXI error handling

 drivers/scsi/hisi_sas/hisi_sas.h       |  22 +-
 drivers/scsi/hisi_sas/hisi_sas_main.c  |  44 +++-
 drivers/scsi/hisi_sas/hisi_sas_v1_hw.c |   2 +-
 drivers/scsi/hisi_sas/hisi_sas_v2_hw.c | 390 +++++++++++++++++++++------------
 drivers/scsi/hisi_sas/hisi_sas_v3_hw.c | 257 ++++++++++++++++++----
 5 files changed, 510 insertions(+), 205 deletions(-)

-- 
1.9.1
