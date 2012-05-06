From: Dan Williams <dan.j.williams@intel.com>
Subject: [PATCH 00/18] libsas, sas_ata: update for 3.5
Date: Sun, 06 May 2012 11:17:57 -0700
Message-ID: <20120506181611.17912.3798.stgit@dwillia2-linux.jf.intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-ide-owner@vger.kernel.org>
Sender: linux-ide-owner@vger.kernel.org
To: linux-scsi@vger.kernel.org
Cc: linux-ide@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org

1/ libsas suspend/resume support

2/ finish off the conversion of the strategy handlers to enforce only
   invoking them in eh context (to meet libata's expectations).

3/ a collection of discovery fixes, error handling fixes, and
   miscellaneous cleanups

All of these patches, save for patch 18, are on their 2nd or 3rd resend.
These have been soaking in -next since before the 3.4 merge window
opened.

[PATCH 01/18] libsas: cleanup spurious calls to scsi_schedule_eh
[PATCH 02/18] libata, libsas: introduce sched_eh and end_eh port ops
[PATCH 03/18] scsi: fix eh wakeup (scsi_schedule_eh vs scsi_restart_operations)
[PATCH 04/18] scsi_transport_sas: fix delete vs scan race
[PATCH 05/18] libsas: enforce eh strategy handlers only in eh context
[PATCH 06/18] libsas: add sas_eh_abort_handler
[PATCH 07/18] libsas: use ->lldd_I_T_nexus_reset for ->eh_bus_reset_handler
[PATCH 08/18] isci: use sas eh strategy handlers
[PATCH 09/18] libsas: trim sas_task of slow path infrastructure
[PATCH 10/18] libsas: sas_rediscover_dev did not look at the SMP exec status.
[PATCH 11/18] mvsas: remove unused variable in mvs_task_exec()
[PATCH 12/18] libata: reset once
[PATCH 13/18] libsas: continue revalidation
[PATCH 14/18] libata: export ata_port suspend/resume infrastructure for sas
[PATCH 15/18] libsas: drop sata port multiplier infrastructure
[PATCH 16/18] scsi, sd: limit the scope of the async probe domain
[PATCH 17/18] libsas: suspend / resume support
[PATCH 18/18] scsi: cleanup setting task state in scsi_error_handler()

 Documentation/kernel-parameters.txt |    3 +
 drivers/ata/libata-core.c           |   63 +++++++++--
 drivers/ata/libata-eh.c             |   59 +++++++++--
 drivers/scsi/isci/init.c            |    3 +
 drivers/scsi/libsas/sas_ata.c       |  125 ++++++++++++++++++++++
 drivers/scsi/libsas/sas_discover.c  |   92 +++++++++++++----
 drivers/scsi/libsas/sas_dump.c      |    1 
 drivers/scsi/libsas/sas_event.c     |   16 +--
 drivers/scsi/libsas/sas_expander.c  |   35 ++++--
 drivers/scsi/libsas/sas_init.c      |  129 +++++++++++++++++++++--
 drivers/scsi/libsas/sas_internal.h  |    1 
 drivers/scsi/libsas/sas_phy.c       |   21 ++++
 drivers/scsi/libsas/sas_port.c      |   52 +++++++++
 drivers/scsi/libsas/sas_scsi_host.c |  195 +++++++++++++++++++++++++++++++----
 drivers/scsi/mvsas/mv_sas.c         |   21 ++--
 drivers/scsi/pm8001/pm8001_sas.c    |   37 +++----
 drivers/scsi/scsi.c                 |    4 +
 drivers/scsi/scsi_error.c           |   19 +++
 drivers/scsi/scsi_lib.c             |   10 +-
 drivers/scsi/scsi_pm.c              |    2 
 drivers/scsi/scsi_priv.h            |    2 
 drivers/scsi/scsi_transport_sas.c   |    6 +
 drivers/scsi/sd.c                   |    5 +
 include/linux/libata.h              |   16 +++
 include/scsi/libsas.h               |   50 +++++++--
 include/scsi/sas_ata.h              |   15 +++
 26 files changed, 827 insertions(+), 155 deletions(-)
