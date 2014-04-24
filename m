From: Xiangliang Yu <yxlraid@gmail.com>
Subject: [PATCH 0/3] libsas: add support for port multiplier
Date: Thu, 24 Apr 2014 21:27:03 +0800
Message-ID: <1398346023-10225-1-git-send-email-yxlraid@gmail.com>
Return-path: <linux-kernel-owner@vger.kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
To: tj@kernel.org, JBottomley@parallels.com
Cc: dan.j.williams@intel.com, todd.e.brandt@intel.com, lukasz.dorau@intel.com, linux-ide@vger.kernel.org, linux-kernel@vger.kernel.org, linux-scsi@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org

This patch set will support SATA port multiplier(PM) in LIBSAS. 

LIBSAS is need to implement several key handling to support SATA PM:
First,low level driver notify libsas that SATA PM is attached to HBA port.
Then, LIBSAS will need to schedule SATA PMP error handler to scan SATA device
that is attached to PM, so we must implemet port softreset and PMP reset 
handling.
If find SATA devices, we should add the devices into SAS transport layer.
In order to find SAS domain device we must implemet device type transformation
: scsi device -> (port number) -> ata device -> domain device. Then, we can
execute IO operation.

In these patches, patch 1 is change SATA error handler.
And patch 2 will add SATA device into SAS layer and implement device type
transformation. Patch 3 implement SATA functional interface in mvsas.

 drivers/ata/libata-scsi.c           |   48 +++-
 drivers/scsi/libsas/sas_ata.c       |  584 ++++++++++++++++++++++++++++++++++-
 drivers/scsi/libsas/sas_discover.c  |   25 ++-
 drivers/scsi/libsas/sas_internal.h  |    7 +
 drivers/scsi/libsas/sas_phy.c       |    1 +
 drivers/scsi/libsas/sas_port.c      |   12 +
 drivers/scsi/libsas/sas_scsi_host.c |   12 +-
 drivers/scsi/mvsas/mv_64xx.c        |    2 +
 drivers/scsi/mvsas/mv_94xx.c        |   19 ++
 drivers/scsi/mvsas/mv_defs.h        |    1 +
 drivers/scsi/mvsas/mv_init.c        |    7 +
 drivers/scsi/mvsas/mv_sas.c         |  246 +++++++++++++++-
 drivers/scsi/mvsas/mv_sas.h         |    9 +
 include/scsi/libsas.h               |   19 +-
 include/scsi/sas_ata.h              |    5 +
 15 files changed, 970 insertions(+), 27 deletions(-)
