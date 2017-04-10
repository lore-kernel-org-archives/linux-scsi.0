From: John Garry <john.garry@huawei.com>
Subject: [PATCH 0/6] hisi_sas: v2 hw SoC bug workarounds
Date: Mon, 10 Apr 2017 21:21:55 +0800
Message-ID: <1491830521-21437-1-git-send-email-john.garry@huawei.com>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <linux-kernel-owner@vger.kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
To: jejb@linux.vnet.ibm.com, martin.petersen@oracle.com
Cc: john.garry2@mail.dcu.ie, linuxarm@huawei.com, linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org, zhangfei.gao@linaro.org, John Garry <john.garry@huawei.com>
List-Id: linux-scsi@vger.kernel.org

This patchset introduces some v2 hw bug workarounds. Mostly
they are related to SATA devices, but there is also a
workaround for a scenario when internal abort command may
timeout.

The general rule for implementing workarounds was to do it
in the hw layer, as the next hw revision should not
include these bugs, so it is better not pollute the driver
main layer with workarounds

This patchset also includes 2 other patches, one for a
possible NULL pointer deference and another for resetting
the controller for fatal AXI/ECC errors.

John Garry (2):
  scsi: hisi_sas: add v2 hw internal abort timeout workaround
  scsi: hisi_sas: fix NULL deference when TMF timeouts

Xiang Chen (1):
  scsi: hisi_sas: controller reset for multi-bits ECC and AXI fatal
    errors

Xiaofei Tan (3):
  scsi: hisi_sas: workaround STP link SoC bug
  scsi: hisi_sas: workaround a SoC SATA IO processing bug
  scsi: hisi_sas: workaround SoC about abort timeout bug

 drivers/scsi/hisi_sas/hisi_sas.h       |   4 +
 drivers/scsi/hisi_sas/hisi_sas_main.c  |  62 ++---
 drivers/scsi/hisi_sas/hisi_sas_v2_hw.c | 413 ++++++++++++++++++++++++++++-----
 3 files changed, 396 insertions(+), 83 deletions(-)

-- 
1.9.1
