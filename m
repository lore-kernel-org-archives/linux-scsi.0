From: Dan Williams <dan.j.williams@intel.com>
Subject: [GIT PATCH v3 00/14] libsas: eh reworks (ata-eh vs discovery, races,
 ...)
Date: Thu, 05 Jan 2012 16:59:00 -0800
Message-ID: <20120106005634.11464.64030.stgit@localhost6.localdomain6>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-ide-owner@vger.kernel.org>
Sender: linux-ide-owner@vger.kernel.org
To: linux-scsi@vger.kernel.org
Cc: linux-ide@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org

Note, the patches mailed with this update only include the libsas patches
that have been revised since v2, and the isci updates that were
dependent on these changes.

For the full set in proper order see the current state of the 'libsas'
branch in isci.git (commit c3766a3):

  git://git.kernel.org/pub/scm/linux/kernel/git/djbw/isci.git libsas

...full diffstat below.

Although hot-plug / error handling operation is improved with these
changes there are still problems (like the backtrace from the v2
message), the need to better handle the fail-to-transmit-fis case (as
noted by Jack), and more fallout from eh colliding with sdev end of life
issues.  However, those fixes are post 3.3-rc1 material.

Changes since v2: http://marc.info/?l=linux-scsi&m=132460922902788&w=2

1/ "libsas: introduce sas_drain_work()": changed sas_drain_work() to use
   mutex_lock_interruptible().  With the change to route user requested
   reset requests through the host workqueue userspace can end up waiting a
   long time for sysfs triggered resets to complete.  Certainly longer than
   120 seconds as each sata device being managed may take 50 seconds for
   ata-eh to give up.  So allow that wait to be interrupted, and prevent
   hung task timeouts from triggering.

2/ "libsas: remove ata_port.lock management duties from lldds": changed
   to disable interrupts while unlocking the ap->lock.  We should be
   able to enable interrupts in sas_ata_qc_issue, but save that for a later
   patch (need to first downgrade all callers of ->qc_issue from
   spin_lock_irqsave to spin_lock_irq).

3/ "libsas: prevent domain rediscovery competing with ata error
   handling" since eh across an entire domain can take a large amount
   of time it isn't practical to hold up the libsas thread for that
   duration.  Instead, just flush and disable domain revalidation during
   eh.  Explanation of why this is likely safe added to
   sas_ata_strategy_handler()

4/ minor rebase updates to the other libsas patches to account for the
   above reworks

5/ isci updates to leverage the functionality and guarantees offered by
   the new libsas.  Notably we defer all ata resets to be managed by libata
   and provide a lldd_ata_check_ready handler.

Changes since v1: http://marc.info/?l=linux-scsi&m=132408929808366&w=2

1/ The changes to kernel/workqueue.c (to track unchained work during a
   drain_workqueue() operation) have been dropped.  Instead this
   functionality has been pushed down into libsas.  "[PATCH v2 07/28]
   libsas: introduce sas_drain_work()"

2/ Extended "[PATCH v2 09/28] libsas: prevent domain rediscovery
   competing with ata error handling" to fix a deadlock encountered while
   removing a device.  Since device removal issues cache-flush i/o it
   causes libsas to be dependent on the completion of eh which in turn
   means that libsas must not hold eh_mutex over a removal event.

3/ New patch "[PATCH v2 27/28] libsas: fix sas_find_local_phy(), take
   phy references" addresses hitting the BUG_ON(!exphy) in this routine.
   Nothing prevents eh from still being in flight after libsas has removed a
   device from the domain, so the BUG_ON is bogus.

4/ A small collection of dev->gone related fixups, patch 25, 26, and 28.

5/ Picked up a few acked-by and reviewed-by's from Jack, but did not
   include his tested-by across the set given the changes since v1.

---
The following changes since commit 7061bba1da7acb837d6a982648a8306ddc9d7409:

  [SCSI] bfa: fix endian and bit field check bug (2011-12-12 23:48:08 +0400)

are available in the git repository at:
  git://git.kernel.org/pub/scm/linux/kernel/git/djbw/isci.git libsas

Dan Williams (33):
      libsas: remove unused ata_task_resp fields
      libsas: kill sas_slave_destroy
      libsas: fix domain_device leak
      libsas: fix leak of dev->sata_dev.identify_[packet_]device
      libsas: replace event locks with atomic bitops
      libsas: convert ha->state to flags
      libsas: introduce sas_drain_work()
      libsas: remove ata_port.lock management duties from lldds
      libsas: prevent domain rediscovery competing with ata error handling
      libsas: use ->set_dmamode to notify lldds of NCQ parameters
      libsas: kill invocation of scsi_eh_finish_cmd from sas_ata_task_done
      libsas: close error handling vs sas_ata_task_done() race
      libsas: prevent double completion of scmds from eh
      libsas: fix timeout vs completion race
      libsas: let libata handle command timeouts
      libsas: defer SAS_TASK_NEED_DEV_RESET commands to libata
      libsas: use libata-eh-reset for sata rediscovery fis transmit failures
      libsas: perform sas-transport resets in shost->workq context
      libsas: execute transport link resets with libata-eh via host workqueue
      libsas: sas_phy_enable via transport_sas_phy_reset
      libsas: async ata-eh
      libsas: poll for ata device readiness after reset
      libsas: don't mark expanders as gone when a child device is removed
      libsas: check for 'gone' expanders in smp_execute_task()
      libsas: fix sas_find_local_phy(), take phy references
      libsas: don't recover 'gone' devices in sas_ata_hard_reset()
      isci: kill iphy->isci_port lookups
      isci: kill isci_port->status
      isci: fix interpretation of "hard" reset
      isci: stop interpreting ->lldd_lu_reset() as an ata soft-reset
      isci: ->lldd_ata_check_ready handler
      isci: remove bus and reset handlers
      isci: remove IDEV_EH hack to disable "discovery-time" ata resets

Jeff Skirvin (2):
      libsas: Remove redundant phy state notification calls.
      libsas: add mutex for SMP task execution

 Documentation/scsi/libsas.txt       |   15 -
 drivers/ata/libata-eh.c             |    1 +
 drivers/ata/libata.h                |    1 -
 drivers/scsi/aic94xx/aic94xx.h      |    2 +
 drivers/scsi/aic94xx/aic94xx_dev.c  |   38 ++-
 drivers/scsi/aic94xx/aic94xx_init.c |    5 +-
 drivers/scsi/aic94xx/aic94xx_tmf.c  |    9 +-
 drivers/scsi/isci/host.c            |    8 +-
 drivers/scsi/isci/host.h            |   19 +-
 drivers/scsi/isci/init.c            |   13 +-
 drivers/scsi/isci/phy.c             |   18 +-
 drivers/scsi/isci/phy.h             |    1 -
 drivers/scsi/isci/port.c            |  220 ++++++------
 drivers/scsi/isci/port.h            |   11 +-
 drivers/scsi/isci/remote_device.c   |   32 +--
 drivers/scsi/isci/remote_device.h   |    7 +-
 drivers/scsi/isci/request.c         |  198 +----------
 drivers/scsi/isci/request.h         |    9 +-
 drivers/scsi/isci/task.c            |  158 ++-------
 drivers/scsi/isci/task.h            |   40 --
 drivers/scsi/libsas/sas_ata.c       |  685 +++++++++++++++--------------------
 drivers/scsi/libsas/sas_discover.c  |  151 +++++++--
 drivers/scsi/libsas/sas_event.c     |   89 +++++-
 drivers/scsi/libsas/sas_expander.c  |  107 ++++--
 drivers/scsi/libsas/sas_init.c      |  192 +++++++++-
 drivers/scsi/libsas/sas_internal.h  |   73 ++--
 drivers/scsi/libsas/sas_phy.c       |   12 +-
 drivers/scsi/libsas/sas_port.c      |   24 +-
 drivers/scsi/libsas/sas_scsi_host.c |  299 +++++++---------
 drivers/scsi/mvsas/mv_init.c        |    1 -
 drivers/scsi/mvsas/mv_sas.c         |   11 +-
 drivers/scsi/pm8001/pm8001_init.c   |    1 -
 drivers/scsi/pm8001/pm8001_sas.c    |   29 +-
 drivers/scsi/scsi_transport_sas.c   |   59 +++-
 include/linux/libata.h              |    1 +
 include/scsi/libsas.h               |   59 ++--
 include/scsi/sas_ata.h              |   26 +-
 include/scsi/scsi_transport_sas.h   |   12 +-
 38 files changed, 1292 insertions(+), 1344 deletions(-)
