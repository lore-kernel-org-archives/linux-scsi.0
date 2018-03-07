From: John Garry <john.garry@huawei.com>
Subject: [PATCH v4 0/10] hisi_sas: support x6000 board and some misc changes
Date: Wed, 7 Mar 2018 20:25:04 +0800
Message-ID: <1520425514-205565-1-git-send-email-john.garry@huawei.com>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <linux-kernel-owner@vger.kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
To: jejb@linux.vnet.ibm.com, martin.petersen@oracle.com, robh+dt@kernel.org, mark.rutland@arm.com, hare@suse.de
Cc: linux-scsi@vger.kernel.org, devicetree@vger.kernel.org, linux-kernel@vger.kernel.org, linuxarm@huawei.com, John Garry <john.garry@huawei.com>
List-Id: linux-scsi@vger.kernel.org

This patchset primarily adds support for the Huawei x6000 board,
which includes hip07 chipset. Unfortunately, due to some board
layout differences with our development board, we need to set
a PHY-related register differently for optimal signal quality. As
such, a signal attenuation property is added to describe the
differences in the boards and allow the PHY register to be set
appropriately.

In addition to this above features, some misc changes are added for:
- PHY linkrate sysfs interface
- linkrate set function
- internal abort timer timeout increase
- add module device id tabe for v3 hw
- register init setting changes

Differences to v3:
- address comments from Hannes on patch #8:
  https://marc.info/?l=linux-scsi&m=152033924615703&w=2
- add patch for module Id table and some register
  setting for v3 HW.

Differences to v2:
- rename dt binding property name to "hisilicon,signal-attenuation"

Differences to v1:
- rename dt binding property name to include "hisi-" prefix

Xiang Chen (3):
  scsi: hisi_sas: remove unused variable hisi_sas_devices.running_req
  scsi: hisi_sas: Code cleanup and minor bug fixes
  scsi: hisi_sas: add v3 hw MODULE_DEVICE_TABLE()

Xiaofei Tan (7):
  dt-bindings: scsi: hisi_sas: add an property of signal attenuation
  scsi: hisi_sas: support the property of signal attenuation for v2 hw
  scsi: hisi_sas: fix the issue of link rate inconsistency
  scsi: hisi_sas: fix the issue of setting linkrate register
  scsi: hisi_sas: increase timer expire of internal abort task
  scsi: hisi_sas: fix return value of hisi_sas_task_prep()
  scsi: hisi_sas: modify some register config for hip08

 .../devicetree/bindings/scsi/hisilicon-sas.txt     |  7 +++
 drivers/scsi/hisi_sas/hisi_sas.h                   |  1 -
 drivers/scsi/hisi_sas/hisi_sas_main.c              | 34 +++++-----
 drivers/scsi/hisi_sas/hisi_sas_v1_hw.c             | 13 ++--
 drivers/scsi/hisi_sas/hisi_sas_v2_hw.c             | 62 ++++++++++++++-----
 drivers/scsi/hisi_sas/hisi_sas_v3_hw.c             | 72 ++++++++++------------
 6 files changed, 109 insertions(+), 80 deletions(-)

-- 
1.9.1
