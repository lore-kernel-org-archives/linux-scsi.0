From: Dan Williams <dan.j.williams@intel.com>
Subject: [libsas PATCH v10 0/9] libsas error handling + discovery v10
Date: Sat, 10 Mar 2012 20:38:56 -0800
Message-ID: <20120311043722.27797.97791.stgit@dwillia2-linux.jf.intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-ide-owner@vger.kernel.org>
Sender: linux-ide-owner@vger.kernel.org
To: linux-scsi@vger.kernel.org
Cc: linux-ide@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org

Changes since v9: http://marc.info/?l=linux-scsi&m=132890988918965&w=2

1/ PATCH 1: fix drain_workqueue implementation.  v9 was corrupting the
   ->entry list_head of in-flight works when it attempted to place them on
   the defer_q to wait for the last drain to complete.  'sas_work' provides
   a local list_head for this purpose.

2/ PATCH 2,3: cleanup host_eh_scheduled handling conflicts between
   libata and libsas.

3/ dropped "libsas: libsas.force_hard_reset module parameter"

4/ PATCH 4: replaced "libsas: enforce eh strategy handlers only in eh
   context" with a new version that achieves the same goal (prevent the
   ->eh_{bus|device}_reset handlers from triggering resets outside of eh
   context) while still allowing sg_reset.

5/ PATCH 6: fixed up "libsas: use ->lldd_I_T_nexus_reset for
   ->eh_bus_reset_handler" due to internal feedback from Jacek.

6/ PATCH 7: fixed up "libsas: trim sas_task of slow path infrastructure"
   due to feedback from Jack.

7/ PATCH 8,9: two new fixes from Jeff and Tom: "libsas: fix
   sas_find_bcast_phy() in the presence of 'vacant' phys" and "libsas:
   sas_rediscover_dev did not look at the SMP exec status."

8/ Picked up [SCSI] mvsas: remove unused variable in mvs_task_exec()
   (http://marc.info/?l=linux-scsi&m=133119166619140&w=2)

[libsas PATCH v10 1/9] libsas: introduce sas_work to fix sas_drain_work vs sas_queue_work
[libsas PATCH v10 2/9] libsas: cleanup spurious calls to scsi_schedule_eh
[libsas PATCH v10 3/9] libata, libsas: introduce sched_eh and end_eh port ops
[libsas PATCH v10 4/9] libsas: enforce eh strategy handlers only in eh context
[libsas PATCH v10 5/9] libsas: add sas_eh_abort_handler
[libsas PATCH v10 6/9] libsas: use ->lldd_I_T_nexus_reset for ->eh_bus_reset_handler
[libsas PATCH v10 7/9] libsas: trim sas_task of slow path infrastructure
[libsas PATCH v10 8/9] libsas: fix sas_find_bcast_phy() in the presence of 'vacant' phys
[libsas PATCH v10 9/9] libsas: sas_rediscover_dev did not look at the SMP exec status.

diffstat since v9:
 Documentation/kernel-parameters.txt |    6 --
 drivers/ata/libata-core.c           |    4 +
 drivers/ata/libata-eh.c             |   57 +++++++++++---
 drivers/scsi/libsas/sas_ata.c       |   63 ++++++++-------
 drivers/scsi/libsas/sas_discover.c  |   45 +++++++----
 drivers/scsi/libsas/sas_event.c     |   36 +++++----
 drivers/scsi/libsas/sas_expander.c  |   24 +++++--
 drivers/scsi/libsas/sas_init.c      |   33 ++++-----
 drivers/scsi/libsas/sas_internal.h  |    6 +-
 drivers/scsi/libsas/sas_phy.c       |   21 ++----
 drivers/scsi/libsas/sas_port.c      |   15 +---
 drivers/scsi/libsas/sas_scsi_host.c |  142 +++++++++++++++++++++++++++++++---
 drivers/scsi/mvsas/mv_sas.c         |    1 -
 drivers/scsi/pm8001/pm8001_sas.c    |    7 +-
 include/linux/libata.h              |    4 +
 include/scsi/libsas.h               |   54 ++++++++++++-
 include/scsi/sas_ata.h              |    9 +-
 17 files changed, 371 insertions(+), 156 deletions(-)
