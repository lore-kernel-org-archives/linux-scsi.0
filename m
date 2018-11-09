From: John Garry <john.garry@huawei.com>
Subject: [PATCH 0/5] hisi_sas: Interrupt aggregation support
Date: Fri, 9 Nov 2018 22:06:31 +0800
Message-ID: <1541772396-161814-1-git-send-email-john.garry@huawei.com>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <linux-kernel-owner@vger.kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
To: jejb@linux.vnet.ibm.com, martin.petersen@oracle.com
Cc: linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org, linuxarm@huawei.com, John Garry <john.garry@huawei.com>
List-Id: linux-scsi@vger.kernel.org

This patchset adds 2 forms of interrupt aggregation support to the
driver:
- Interrupt converge: Interrupts from all completion queues can be
		      reported through completion queue #0 interrupt only.
- Interrupt coalesce: Ability to set timeout period at which we report
		      completions on that queue (as an interrupt).
		      The HW report completion interrupt as either
		      happens:
		      - configurable threshold of completions occur
		      - a timeout, so we don't pend indefinitely until
			the threshold is reached

There is also 2 minor patches to fix some register setting and also
rearrange some code for proper condition checking.

Xiang Chen (5):
  scsi: hisi_sas: Create separate host attributes per HBA
  scsi: hisi_sas: Add support for interrupt converge for v3 hw
  scsi: hisi_sas: Add support for interrupt coalescing for v3 hw
  scsi: hisi_sas: Relocate some codes to avoid an unused check
  scsi: hisi_sas: change the time of SAS SSP connection

 drivers/scsi/hisi_sas/hisi_sas.h       |   3 +-
 drivers/scsi/hisi_sas/hisi_sas_main.c  |  50 ++++++------
 drivers/scsi/hisi_sas/hisi_sas_v1_hw.c |   7 +-
 drivers/scsi/hisi_sas/hisi_sas_v2_hw.c |   7 +-
 drivers/scsi/hisi_sas/hisi_sas_v3_hw.c | 138 +++++++++++++++++++++++++++++++--
 5 files changed, 168 insertions(+), 37 deletions(-)

-- 
1.9.1
