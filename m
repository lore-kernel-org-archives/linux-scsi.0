From: Dan Williams <dan.j.williams@intel.com>
Subject: [libsas PATCH v11 0/2] libsas error handling + discovery v11
Date: Tue, 13 Mar 2012 23:30:13 -0700
Message-ID: <20120314062643.6772.79462.stgit@dwillia2-linux.jf.intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-ide-owner@vger.kernel.org>
Sender: linux-ide-owner@vger.kernel.org
To: linux-scsi@vger.kernel.org
Cc: linux-ide@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org

Changes since v10: http://marc.info/?l=linux-scsi&m=133143989626340&0w=2

Rebase the tree on the scsi-misc to drop the accepted patches and
resolve the conflicts in -next.  Only "libsas: enforce eh strategy
handlers only in eh context" had to be fixed up (collision in
sas_init_dev).

Add a new fix for a regression in sas_get_port_device().

 [libsas PATCH 1/2 v11] libsas: enforce eh strategy handlers only in eh context
 [libsas PATCH 2/2 v11] libsas: fix sas_get_port_device regression

The delta vs scsi-misc is now (cd8df93..libsas-eh-reworks-v11):

Dan Carpenter (1):
      mvsas: remove unused variable in mvs_task_exec()

Dan Williams (9):
      libsas: introduce sas_work to fix sas_drain_work vs sas_queue_work
      libsas: cleanup spurious calls to scsi_schedule_eh
      libata, libsas: introduce sched_eh and end_eh port ops
      libsas: enforce eh strategy handlers only in eh context
      libsas: add sas_eh_abort_handler
      libsas: use ->lldd_I_T_nexus_reset for ->eh_bus_reset_handler
      isci: use sas eh strategy handlers
      libsas: trim sas_task of slow path infrastructure
      libsas: fix sas_get_port_device regression

Jeff Skirvin (1):
      libsas: sas_rediscover_dev did not look at the SMP exec status.

Thomas Jackson (1):
      libsas: fix sas_find_bcast_phy() in the presence of 'vacant' phys

 drivers/ata/libata-core.c           |    4 +
 drivers/ata/libata-eh.c             |   57 ++++++++--
 drivers/scsi/isci/init.c            |    3 +
 drivers/scsi/libsas/sas_ata.c       |   63 ++++++-----
 drivers/scsi/libsas/sas_discover.c  |   54 ++++++----
 drivers/scsi/libsas/sas_event.c     |   36 ++++---
 drivers/scsi/libsas/sas_expander.c  |   44 +++++---
 drivers/scsi/libsas/sas_init.c      |   50 ++++++---
 drivers/scsi/libsas/sas_internal.h  |    6 +-
 drivers/scsi/libsas/sas_phy.c       |   21 ++---
 drivers/scsi/libsas/sas_port.c      |   15 +--
 drivers/scsi/libsas/sas_scsi_host.c |  199 ++++++++++++++++++++++++++++++-----
 drivers/scsi/mvsas/mv_sas.c         |   21 ++--
 drivers/scsi/pm8001/pm8001_sas.c    |   37 ++++---
 include/linux/libata.h              |    4 +
 include/scsi/libsas.h               |   69 ++++++++++--
 include/scsi/sas_ata.h              |    9 +-
 17 files changed, 487 insertions(+), 205 deletions(-)
