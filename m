From: Dan Williams <dan.j.williams@intel.com>
Subject: [set5 PATCH 0/6] scsi, async: asynchronous probing rework / fixes
Date: Thu, 21 Jun 2012 23:46:57 -0700
Message-ID: <20120622064657.21538.61711.stgit@dwillia2-linux.jf.intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner@vger.kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
To: linux-scsi@vger.kernel.org
Cc: linux-kernel@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org

Set5 of 5 patchsets to update scsi, libsas, and libata in
support of the isci driver.

Commit 43a8d39d "[SCSI] fix async probe regression" found that
async_synchronize_full() was missing async work that was scheduled to
its own domain.  This led James to note:

      "My theory is that this is an init problem: The assumption in a lot of
       our code is that async_synchronize_full() waits for everything ... even
       the domain specific async schedules, which isn't true."

...and this set aims to make that assumption true, but also with the
ability to opt-out for "private" async work.

The other async probe fix is in the area of unplug events that occur in
the scsi async scanning interval.  Essentially scsi_remove_target() can
now see semi-initialized scsi_targets that have yet to be added via
device_add().

If there are no objections I'll put these in -next.  But I expect at
least patch1 and patch2 will need an ack from Arjan before the set shows
up in scsi.git.

---

Dan Williams (6):
      async: introduce 'async_domain' type
      async: make async_synchronize_full() flush all work regardless of domain
      scsi: queue async scan work to an async_schedule domain
      scsi: cleanup usages of scsi_complete_async_scans
      Revert "[SCSI] fix async probe regression"
      scsi: fix hot unplug vs async scan race


 drivers/regulator/core.c      |    2 +
 drivers/scsi/libsas/sas_ata.c |    2 +
 drivers/scsi/scsi.c           |    4 ++
 drivers/scsi/scsi_priv.h      |    3 +-
 drivers/scsi/scsi_scan.c      |   34 ++++++------------
 drivers/scsi/scsi_sysfs.c     |   41 ++++++++++++++--------
 drivers/scsi/scsi_wait_scan.c |   15 +++-----
 include/linux/async.h         |   36 +++++++++++++++++--
 include/scsi/scsi_scan.h      |   11 ------
 kernel/async.c                |   76 +++++++++++++++++++++++++++++++----------
 kernel/power/hibernate.c      |    8 ----
 kernel/power/user.c           |    2 -
 12 files changed, 138 insertions(+), 96 deletions(-)
 delete mode 100644 include/scsi/scsi_scan.h
