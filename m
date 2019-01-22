From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Subject: [PATCH 0/7] SCSI: cleanup debugfs usage
Date: Tue, 22 Jan 2019 16:08:59 +0100
Message-ID: <20190122150906.12470-1-gregkh@linuxfoundation.org>
Mime-Version: 1.0
Content-Transfer-Encoding: 8bit
Return-path: <linux-kernel-owner@vger.kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
To: James Bottomley <jejb@linux.ibm.com>, Martin Petersen <martin.petersen@oracle.com>
Cc: linux-kernel@vger.kernel.org, linux-scsi@vger.kernel.org, Greg Kroah-Hartman <gregkh@linuxfoundation.org>
List-Id: linux-scsi@vger.kernel.org

When calling debugfs code, there is no need to ever check the return
value of the call, as no logic should ever change if a call works
properly or not.  Fix up a bunch of x86-specific code to not care about
the results of debugfs.

Greg Kroah-Hartman (7):
  scsi: bfa: no need to check return value of debugfs_create functions
  scsi: csiostor: no need to check return value of debugfs_create
    functions
  scsi: fnic: no need to check return value of debugfs_create functions
  scsi: snic: no need to check return value of debugfs_create functions
  scsi: lpfc: no need to check return value of debugfs_create functions
  scsi: qlogic: no need to check return value of debugfs_create
    functions
  scsi: qla2xxx: no need to check return value of debugfs_create
    functions

 drivers/scsi/bfa/bfad_debugfs.c   |  17 ---
 drivers/scsi/csiostor/csio_init.c |   6 +-
 drivers/scsi/fnic/fnic_debugfs.c  |  88 +---------------
 drivers/scsi/fnic/fnic_main.c     |   7 +-
 drivers/scsi/fnic/fnic_stats.h    |   2 +-
 drivers/scsi/fnic/fnic_trace.c    |  17 +--
 drivers/scsi/fnic/fnic_trace.h    |   4 +-
 drivers/scsi/lpfc/lpfc_debugfs.c  | 170 ------------------------------
 drivers/scsi/qedf/qedf_debugfs.c  |  18 +---
 drivers/scsi/qedi/qedi_debugfs.c  |  17 +--
 drivers/scsi/qla2xxx/qla_dfs.c    |  43 +-------
 drivers/scsi/snic/snic_debugfs.c  | 133 +++++------------------
 drivers/scsi/snic/snic_main.c     |  14 +--
 drivers/scsi/snic/snic_stats.h    |   2 +-
 drivers/scsi/snic/snic_trc.c      |  12 +--
 drivers/scsi/snic/snic_trc.h      |   4 +-
 16 files changed, 48 insertions(+), 506 deletions(-)

-- 
2.20.1
