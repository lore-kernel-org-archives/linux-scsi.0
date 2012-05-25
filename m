From: Dan Williams <dan.j.williams@intel.com>
Subject: [RFT PATCH 0/4] fix / cleanup async scsi scanning
Date: Fri, 25 May 2012 00:50:22 -0700
Message-ID: <20120525074813.21933.91876.stgit@dwillia2-linux.jf.intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner@vger.kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
To: mroos@linux.ee
Cc: linux-kernel@vger.kernel.org, JBottomley@parallels.com, linux-scsi@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org

Commit a7a20d10 "[SCSI] sd: limit the scope of the async probe domain"
introduces a boot regression by moving sd probe work off of the global
async queue.  Using a local async domain hides the probe work from being
synchronized by wait_for_device_probe()->async_synchronize_full().

Fix this by teaching async_synchronize_full() to flush all async work
regardless of domain, and take the opportunity to convert scsi scanning
to async_schedule().  This enables wait_for_device_probe() to flush scsi
scanning work.

Lightly boot tested, Meelis does this fix your regression?

Thanks for your help.

--
Dan

---

Dan Williams (4):
      async: introduce 'async_domain' type
      async: make async_synchronize_full() flush all work regardless of domain
      scsi: queue async scan work to an async_schedule domain
      scsi: cleanup usages of scsi_complete_async_scans


 drivers/regulator/core.c      |    2 +-
 drivers/scsi/libsas/sas_ata.c |    2 +-
 drivers/scsi/scsi.c           |    3 ++-
 drivers/scsi/scsi_priv.h      |    3 ++-
 drivers/scsi/scsi_scan.c      |   24 ++++++------------------
 drivers/scsi/scsi_wait_scan.c |   15 +++++----------
 include/linux/async.h         |   20 ++++++++++++++++----
 include/scsi/scsi_scan.h      |   11 -----------
 kernel/async.c                |   36 ++++++++++++++++++++----------------
 kernel/power/hibernate.c      |    8 --------
 kernel/power/user.c           |    2 --
 11 files changed, 53 insertions(+), 73 deletions(-)
 delete mode 100644 include/scsi/scsi_scan.h
