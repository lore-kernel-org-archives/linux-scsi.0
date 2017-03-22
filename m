From: John Garry <john.garry@huawei.com>
Subject: [PATCH 00/23] hisi_sas: error handling and other misc fixes and improvements
Date: Thu, 23 Mar 2017 01:25:16 +0800
Message-ID: <1490203539-228029-1-git-send-email-john.garry@huawei.com>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from szxga02-in.huawei.com ([45.249.212.188]:4366 "EHLO
        dggrg02-dlp.huawei.com" rhost-flags-OK-FAIL-OK-FAIL)
        by vger.kernel.org with ESMTP id S1760780AbdCVQ6F (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>);
        Wed, 22 Mar 2017 12:58:05 -0400
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: jejb@linux.vnet.ibm.com, martin.petersen@oracle.com
Cc: linuxarm@huawei.com, john.garry2@mail.dcu.ie, linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org, zhangfei.gao@linaro.org, John Garry <john.garry@huawei.com>

This patchset introduces a range of error handling
and other misc improvements for the HiSilicon SAS
controller, including:
- controller reset function
- softreset for SATA error handling
- fixes for slot free'ing
- v2 hw error handling improvements
- and other misc, more minor stuff

John Garry (14):
  scsi: hisi_sas: add to_hisi_sas_port()
  scsi: hisi_sas: move PHY init to hisi_sas_scan_start()
  scsi: hisi_sas: remove hisi_sas_port_deformed()
  scsi: hisi_sas: error hisi_sas_task_prep() when port down
  scsi: hisi_sas: only reset link for PHY_FUNC_LINK_RESET
  scsi: hisi_sas: modify hisi_sas_abort_task() for SSP
  scsi: hisi_sas: hardreset for SATA disk in LU reset
  scsi: hisi_sas: check for SAS_TASK_STATE_ABORTED in slot complete
  scsi: hisi_sas: fix some sas_task.task_state_lock locking
  scsi: hisi_sas: remove task free'ing for timeouts
  scsi: hisi_sas: some modifications to v2 hw reg init values
  scsi: hisi_sas: rename hisi_sas_link_timeout_{enable, disable}_link
  scsi: hisi_sas: add hisi_sas_clear_nexus_ha()
  scsi: hisi_sas: check hisi_sas_lu_reset() error message

Xiang Chen (7):
  scsi: hisi_sas: add controller reset
  scsi: hisi_sas: add softreset function for SATA disk
  scsi: hisi_sas: modify error handling for v2 hw
  scsi: hisi_sas: free slots after hardreset
  scsi: hisi_sas: process error codes according to their priority
  scsi: hisi_sas: release SMP slot in lldd_abort_task
  scsi: hisi_sas: use dev_is_sata to identify SATA or SAS disk

Xiaofei Tan (2):
  scsi: hisi_sas: handle PHY UP+DOWN simultaneous irq
  scsi: hisi_sas: add is_sata_phy_v2_hw()

 drivers/scsi/hisi_sas/Kconfig          |   2 +-
 drivers/scsi/hisi_sas/hisi_sas.h       |  15 +-
 drivers/scsi/hisi_sas/hisi_sas_main.c  | 436 +++++++++++++-----
 drivers/scsi/hisi_sas/hisi_sas_v1_hw.c |  19 +-
 drivers/scsi/hisi_sas/hisi_sas_v2_hw.c | 789 ++++++++++++++++++++++++---------
 5 files changed, 925 insertions(+), 336 deletions(-)

-- 
1.9.1
