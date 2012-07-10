From: Dan Williams <dan.j.williams@intel.com>
Subject: Re: [set4 resend PATCH 0/5] libsas, libata: suspend / resume and
 "reset once"
Date: Mon, 9 Jul 2012 20:34:10 -0700
Message-ID: <CAA9_cmfH8YT3U0mw_fQLYo_cBm=E=XtnsKV_RhdLLxvJsuaBYA@mail.gmail.com>
References: <20120710023241.26249.13718.stgit@dwillia2-linux.jf.intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Return-path: <linux-ide-owner@vger.kernel.org>
In-Reply-To: <20120710023241.26249.13718.stgit@dwillia2-linux.jf.intel.com>
Sender: linux-ide-owner@vger.kernel.org
To: jgarzik@pobox.com, JBottomley@parallels.com
Cc: linux-ide@vger.kernel.org, linux-scsi@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org

Sorry.  Sent the wrong cover letter with this patch set.

Should be:

Subject: [set5 PATCH v2 0/5] scsi, async: asynchronous probing rework

Changes since v1: http://marc.info/?l=linux-scsi&m=134034693629294&w=2
1/ rebased on scsi/for-next to pick up the scsi_wait_scan module deletion
2/ added Arjan's ack (spoke with Arjan offline)
3/ added Eldad's tested-by
4/ dropped the scsi async scan fix that was merged to scsi/misc

Original description:
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

---

Dan Williams (5):
      async: introduce 'async_domain' type
      async: make async_synchronize_full() flush all work regardless of domain
      scsi: queue async scan work to an async_schedule domain
      scsi: cleanup usages of scsi_complete_async_scans
      Revert "[SCSI] fix async probe regression"


 drivers/regulator/core.c      |    2 +
 drivers/scsi/libsas/sas_ata.c |    2 +
 drivers/scsi/scsi.c           |    4 ++
 drivers/scsi/scsi_priv.h      |    2 +
 drivers/scsi/scsi_scan.c      |   31 ++++-------------

 include/linux/async.h         |   36 +++++++++++++++++--
 include/scsi/scsi_scan.h      |   11 ------
 kernel/async.c                |   76 +++++++++++++++++++++++++++++++----------
 kernel/power/hibernate.c      |    8 ----
 kernel/power/user.c           |    2 -
 sound/soc/soc-dapm.c          |    2 +
 11 files changed, 104 insertions(+), 72 deletions(-)
 delete mode 100644 include/scsi/scsi_scan.h
