From: John Garry <john.garry@huawei.com>
Subject: [PATCH v3 0/3]  hisi_sas: DIF support
Date: Mon, 3 Dec 2018 20:09:50 +0800
Message-ID: <1543838994-30028-1-git-send-email-john.garry@huawei.com>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <linux-kernel-owner@vger.kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
To: jejb@linux.vnet.ibm.com, martin.petersen@oracle.com
Cc: linuxarm@huawei.com, linux-kernel@vger.kernel.org, linux-scsi@vger.kernel.org, John Garry <john.garry@huawei.com>
List-Id: linux-scsi@vger.kernel.org


This patchset introduces support to the driver for DIF (or PI -protection
information).

We are dropping DIX support for now, based on issues discussed in the
following:
https://marc.info/?l=linux-scsi&m=154357719329297&w=4

We will only support PI in v3 hw at the moment, even though previous hw
versions also support it.

The series is broken down as follows:
- Fix pre-existing sparse warnings
- Tidy sg table size config
- Some tidy-up to accept PI support
- Add components for PI support for main and v3 driver

Difference v1->v2:
- drop scsi_prot_op_normal()

v2->v3:
- fix sparse warnings
- drop DIX support

John Garry (1):
  scsi: hisi_sas: Fix warnings detected by sparse

Xiang Chen (3):
  scsi: hisi_sas: Relocate some code to reduce complexity
  scsi: hisi_sas: Make sg_tablesize consistent value
  scsi: hisi_sas: Add support for DIF feature for v3 hw

 drivers/scsi/hisi_sas/hisi_sas.h       |  20 ++-
 drivers/scsi/hisi_sas/hisi_sas_main.c  | 248 +++++++++++++++++++++++----------
 drivers/scsi/hisi_sas/hisi_sas_v1_hw.c |  17 +--
 drivers/scsi/hisi_sas/hisi_sas_v2_hw.c |  68 +++++----
 drivers/scsi/hisi_sas/hisi_sas_v3_hw.c | 227 +++++++++++++++++++++++++++---
 5 files changed, 448 insertions(+), 132 deletions(-)

-- 
1.9.1
