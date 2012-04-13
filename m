From: Dan Williams <dan.j.williams@intel.com>
Subject: [GIT PATCH 00/12] libsas fixes for 3.4
Date: Fri, 13 Apr 2012 16:36:51 -0700
Message-ID: <20120413233343.8025.18101.stgit@dwillia2-linux.jf.intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-ide-owner@vger.kernel.org>
Sender: linux-ide-owner@vger.kernel.org
To: JBottomley@parallels.com
Cc: linux-ide@vger.kernel.org, linux-scsi@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org

The following changes since commit cd8df932d894f3128c884e3ae1b2b484540513db:

  [SCSI] qla4xxx: Update driver version to 5.02.00-k15 (2012-02-29 17:03:03 -0600)

are available in the git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/djbw/isci.git tags/libsas-fixes

for you to fetch changes up to e81dcce46fdbb2c968d7314c2f19da3c2bba24d1:

  scsi_transport_sas: fix delete vs scan race (2012-04-10 19:15:23 -0700)

----------------------------------------------------------------
libsas-fixes for 3.4-rc4

Regression fixes to stabilize the new workqueue and ata asynchronous
error handling implementations that were merged for v3.4-rc1.

1/ fix sas_drain_work() which was stomping on 'work' entries while the
   workqueue was manipulating them.  user would see random crashes when
   trying to use scsi_transport_sas attributes for resets, or during
   discovery

2/ (2) longstanding bugs related to the fact that libata (inventor and
   primary host_eh_scheduled user) had built-in assumptions of 1:1
   Scsi_Host-to-ata_port relationship.  The libsas 1:N arrangement
   magnified these problems when it gained async eh and began scheduling
   eh in more scenarios (sas-transports resets) in 3.4-rc1.

3/ lifetime fixes for the rphy since code that has a domain_device
   reference expected to be able to de-reference rphy parameters.

4/ (3) fixes for expander discovery bugs, one a recent regression with
   ata-eh clobbering expander-phy data as it polled leading to system
   crashes, a long standing bug that caused libsas to be
   incompatible with expanders that advertised "PHY_VACANT" in low order
   phy indexes, and a quirk for expanders that sometimes fail to zero
   the sas address when no device is attached.

5/ fix for a long-standing bug whereby hotunplug events during initial
   host scan can cause a system crash

----------------------------------------------------------------

This is a reflow of the 26 patches in the libsas-eh-reworks-v15 branch
to separate out the 12 fixes from the other feature development.  These
patches, save for the new "scsi: fix eh wakeup (scsi_schedule_eh vs
scsi_restart_operations)", were all originally posted before the merge
window opened, and have also appeared in -next for the same timeframe.

There is a mix of pure regression fixes and fixes for long-standing bugs
in libsas.  Some of the long-standing bug fixes are made worse / easier
to trigger by the new async error handling scheme.

The largest patch in the series is "libata, libsas: introduce sched_eh
and end_eh port ops" wants an ack from the ata folks, it has been on the
list since March 10th.

Dan Williams (10):
      libsas: introduce sas_work to fix sas_drain_work vs sas_queue_work
      libata, libsas: introduce sched_eh and end_eh port ops
      libsas: fix sas_get_port_device regression
      libsas: unify domain_device sas_rphy lifetimes
      libsas: fix ata_eh clobbering ex_phys via smp_ata_check_ready
      libata: make ata_print_id atomic
      libsas, libata: fix start of life for a sas ata_port
      scsi: fix eh wakeup (scsi_schedule_eh vs scsi_restart_operations)
      libsas: fix false positive 'device attached' conditions
      scsi_transport_sas: fix delete vs scan race

Maciej Trela (1):
      libsas: cleanup spurious calls to scsi_schedule_eh

Thomas Jackson (1):
      libsas: fix sas_find_bcast_phy() in the presence of 'vacant' phys

 drivers/ata/libata-core.c           |    8 +++-
 drivers/ata/libata-eh.c             |   57 +++++++++++++++++++++------
 drivers/ata/libata-scsi.c           |   35 +++++++++--------
 drivers/ata/libata.h                |    2 +-
 drivers/scsi/ipr.c                  |    6 ++-
 drivers/scsi/libsas/sas_ata.c       |   72 +++++++++++++++++++++--------------
 drivers/scsi/libsas/sas_discover.c  |   67 ++++++++++++++++++--------------
 drivers/scsi/libsas/sas_event.c     |   36 +++++++++---------
 drivers/scsi/libsas/sas_expander.c  |   56 +++++++++++++++++++++------
 drivers/scsi/libsas/sas_init.c      |   25 ++++++------
 drivers/scsi/libsas/sas_internal.h  |    6 +--
 drivers/scsi/libsas/sas_phy.c       |   21 ++++------
 drivers/scsi/libsas/sas_port.c      |   15 +++-----
 drivers/scsi/libsas/sas_scsi_host.c |   28 ++++++++++----
 drivers/scsi/scsi_error.c           |   14 +++++++
 drivers/scsi/scsi_transport_sas.c   |    6 ++-
 include/linux/libata.h              |    7 +++-
 include/scsi/libsas.h               |   44 ++++++++++++++++++---
 include/scsi/sas_ata.h              |    9 ++++-
 19 files changed, 343 insertions(+), 171 deletions(-)
