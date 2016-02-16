From: John Garry <john.garry@huawei.com>
Subject: [PATCH 0/6] hisi_sas: add abort and retry feature
Date: Tue, 16 Feb 2016 20:22:25 +0800
Message-ID: <1455625351-165881-1-git-send-email-john.garry@huawei.com>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <linux-kernel-owner@vger.kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
To: JBottomley@odin.com, martin.petersen@oracle.com
Cc: linuxarm@huawei.com, zhangfei.gao@linaro.org, xuwei5@hisilicon.com, john.garry2@mail.dcu.ie, linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org, John Garry <john.garry@huawei.com>
List-Id: linux-scsi@vger.kernel.org

This patchset introduces support to abort
certain commands which have failed and retry.
Certain errors require that the command be
retried, like TRANS_TX_CREDIT_TIMEOUT_ERR in
v1 hw.
However, when these errors occur the IO may
still be active, so the IO must first be
aborted, and then retried. The HiSilicon
SAS controller has no FW to do this work, so
it needs to be done manually.

John Garry (6):
  hisi_sas: add TMF_RESP_FUNC_SUCC check
  hisi_sas: add hisi_sas_slot_abort()
  hisi_sas: use slot abort in v1 hw
  hisi_sas: use slot abort in v2 hw
  hisi_sas: add hisi_sas_slave_configure()
  hisi_sas: update driver version to 1.3

 drivers/scsi/hisi_sas/hisi_sas.h       |  3 +-
 drivers/scsi/hisi_sas/hisi_sas_main.c  | 66 ++++++++++++++++++++++++++++++++--
 drivers/scsi/hisi_sas/hisi_sas_v1_hw.c | 22 +++++++++---
 drivers/scsi/hisi_sas/hisi_sas_v2_hw.c | 19 ++++++++--
 4 files changed, 101 insertions(+), 9 deletions(-)

-- 
1.9.1
