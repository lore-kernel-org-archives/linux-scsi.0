From: Dan Williams <dan.j.williams@intel.com>
Subject: [PATCH 0/3] libsas fixlets for 2.6.40
Date: Tue, 03 May 2011 11:36:17 -0700
Message-ID: <20110503183526.21471.84735.stgit@localhost6.localdomain6>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-ide-owner@vger.kernel.org>
Sender: linux-ide-owner@vger.kernel.org
To: james.bottomley@suse.de
Cc: linux-ide@vger.kernel.org, linux-scsi@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org

Cleanup hotplug handling (issuing i/o to 'gone' devices), and fix pre-mature
completion of the initial domain scan.

Checked out with the isci driver on 2.6.39-rc5.

---

Dan Williams (3):
      libsas: flush initial device discovery before completing ->scan_finished()
      libsas: fix/amend device gone notification in sas_deform_port()
      libsas: check dev->gone before submitting sata i/o


 drivers/scsi/aic94xx/aic94xx_init.c |    2 +-
 drivers/scsi/libsas/sas_expander.c  |   20 +++++++++++++++++---
 drivers/scsi/libsas/sas_internal.h  |    3 ++-
 drivers/scsi/libsas/sas_phy.c       |    4 ++--
 drivers/scsi/libsas/sas_port.c      |   21 ++++++++++++---------
 drivers/scsi/libsas/sas_scsi_host.c |   14 +++++++-------
 drivers/scsi/mvsas/mv_sas.c         |    2 +-
 drivers/scsi/pm8001/pm8001_sas.c    |    2 +-
 include/scsi/libsas.h               |   13 +++++++++++++
 9 files changed, 56 insertions(+), 25 deletions(-)
