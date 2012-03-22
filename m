From: Dan Williams <dan.j.williams@intel.com>
Subject: [libsas PATCH v12 00/11] libsas eh, discovery, suspend, and fixes
Date: Wed, 21 Mar 2012 23:31:54 -0700
Message-ID: <20120322063127.22036.23206.stgit@dwillia2-linux.jf.intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-ide-owner@vger.kernel.org>
Sender: linux-ide-owner@vger.kernel.org
To: linux-scsi@vger.kernel.org
Cc: linux-ide@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org

Changes since v11: http://marc.info/?l=linux-scsi&m=133170574921314&w=2

This is primarily a collection of fixes to the libsas functionality that
has gone upstream in the initial scsi push for 3.3, but also includes a
revised suspend/resume implementation that was initially posted before
the merge window opened.

1/ PATCH 1: Maciej noticed that the original version of "libsas: cleanup
   spurious calls to scsi_schedule_eh" went too far when it deleted
   sas_ata_task_abort.

2/ PATCH 3: Hot plug testing incurs 1 minute timeouts, across 3 reset
   attempts, for ATA unplugs so provide an option to cut that down to
   one reset with a 10 second timeout.

3/ PATCH 4-5: Address long standing kernel panics when hotplugs occur
   during the initial scan.

4/ PATCH 6-9: Address corner cases and regressions in device discovery

5/ PATCH 10-11: Revised suspend implementation with a cleaner fix for
   the sd-probing vs PM-resume deadlock.

[libsas PATCH v12 01/11] libsas: cleanup spurious calls to scsi_schedule_eh
[libsas PATCH v12 02/11] libsas: trim sas_task of slow path infrastructure
[libsas PATCH v12 03/11] libata: reset once
[libsas PATCH v12 04/11] sysfs: handle 'parent deleted before child added'
[libsas PATCH v12 05/11] scsi_transport_sas: fix delete vs scan race
[libsas PATCH v12 06/11] libsas: unify domain_device sas_rphy lifetimes
[libsas PATCH v12 07/11] libsas: fix false positive 'device attached' conditions
[libsas PATCH v12 08/11] libsas: fix ata_eh clobbering ex_phys via smp_ata_check_ready
[libsas PATCH v12 09/11] libsas, libata: fix start of life for a sas ata_port
[libsas PATCH v12 10/11] scsi, sd: limit the scope of the async probe domain
[libsas PATCH v12 11/11] libsas: suspend / resume support

Note, I rebased the isci branch to move all scsi, libsas and libata
patches to this 'libsas' branch.

The following changes since commit cd8df932d894f3128c884e3ae1b2b484540513db:

  [SCSI] qla4xxx: Update driver version to 5.02.00-k15 (2012-02-29 17:03:03 -0600)

are available in the git repository at:
  git://git.kernel.org/pub/scm/linux/kernel/git/djbw/isci.git libsas-eh-reworks-v12

Dan Carpenter (1):
      mvsas: remove unused variable in mvs_task_exec()

Dan Williams (21):
      libsas: introduce sas_work to fix sas_drain_work vs sas_queue_work
      libata, libsas: introduce sched_eh and end_eh port ops
      libsas: enforce eh strategy handlers only in eh context
      libsas: add sas_eh_abort_handler
      libsas: use ->lldd_I_T_nexus_reset for ->eh_bus_reset_handler
      isci: use sas eh strategy handlers
      libsas: trim sas_task of slow path infrastructure
      libsas: fix sas_get_port_device regression
      libata: reset once
      sysfs: handle 'parent deleted before child added'
      scsi_transport_sas: fix delete vs scan race
      libsas: unify domain_device sas_rphy lifetimes
      libsas: fix false positive 'device attached' conditions
      libsas: fix ata_eh clobbering ex_phys via smp_ata_check_ready
      libata: make ata_print_id atomic
      libsas: continue revalidation
      libsas, libata: fix start of life for a sas ata_port
      libata: export ata_port suspend/resume infrastructure for sas
      libsas: drop sata port multiplier infrastructure
      scsi, sd: limit the scope of the async probe domain
      libsas: suspend / resume support

Jeff Skirvin (1):
      libsas: sas_rediscover_dev did not look at the SMP exec status.

Maciej Trela (1):
      libsas: cleanup spurious calls to scsi_schedule_eh

Thomas Jackson (1):
      libsas: fix sas_find_bcast_phy() in the presence of 'vacant' phys

 Documentation/kernel-parameters.txt |    3 +
 drivers/ata/libata-core.c           |   67 ++++++++++---
 drivers/ata/libata-eh.c             |   59 +++++++++--
 drivers/ata/libata-scsi.c           |   35 ++++---
 drivers/ata/libata.h                |    2 +-
 drivers/scsi/ipr.c                  |    6 +-
 drivers/scsi/isci/init.c            |    3 +
 drivers/scsi/libsas/sas_ata.c       |  158 +++++++++++++++++++++++-----
 drivers/scsi/libsas/sas_discover.c  |  153 +++++++++++++++++++--------
 drivers/scsi/libsas/sas_dump.c      |    1 +
 drivers/scsi/libsas/sas_event.c     |   40 ++++----
 drivers/scsi/libsas/sas_expander.c  |   91 ++++++++++++-----
 drivers/scsi/libsas/sas_init.c      |  140 ++++++++++++++++++++++---
 drivers/scsi/libsas/sas_internal.h  |    7 +-
 drivers/scsi/libsas/sas_phy.c       |   42 +++++---
 drivers/scsi/libsas/sas_port.c      |   67 ++++++++++--
 drivers/scsi/libsas/sas_scsi_host.c |  195 ++++++++++++++++++++++++++++++----
 drivers/scsi/mvsas/mv_sas.c         |   21 ++--
 drivers/scsi/pm8001/pm8001_sas.c    |   37 ++++---
 drivers/scsi/scsi.c                 |    6 +
 drivers/scsi/scsi_lib.c             |   10 ++-
 drivers/scsi/scsi_pm.c              |    2 +-
 drivers/scsi/scsi_transport_sas.c   |    6 +-
 drivers/scsi/sd.c                   |    4 +-
 fs/sysfs/dir.c                      |    3 +
 include/linux/libata.h              |   19 +++-
 include/scsi/libsas.h               |   90 +++++++++++++---
 include/scsi/sas_ata.h              |   19 +++-
 include/scsi/scsi_device.h          |    4 +
 lib/kobject.c                       |    7 +-
 30 files changed, 1012 insertions(+), 285 deletions(-)
