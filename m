From: Dan Williams <dan.j.williams@intel.com>
Subject: [PATCH v8 00/13] libsas error handling + discovery v8
Date: Fri, 10 Feb 2012 00:44:39 -0800
Message-ID: <20120210084411.25701.94502.stgit@dwillia2-linux.jf.intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-ide-owner@vger.kernel.org>
Sender: linux-ide-owner@vger.kernel.org
To: linux-scsi@vger.kernel.org
Cc: linux-ide@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org

Changes since v7: http://marc.info/?l=linux-scsi&m=132739159230095&w=2

1/ Dropped "libsas: feed the scsi_block_when_processing_errors() meter"
   [1].  Patches 1-3 are just resends of the patches affected by that
   rebase.

2/ Fixed up the phy identify data that is exported to userspace.
   sas_phy/phyX/device_type and sas_phy/phyX/target_port_protocols are
   now populated more reliably.  Patches 4-5

3/ User-disabled ssp phys are now no longer inadvertantly re-enabled by
   error recovery (they need an explicit reset from userspace).  This
   enables scripted hotplug testing. Patches 6-8

4/ Fixed up the eh_strategy_handlers to prevent them being called from
   outside eh context, added an abort handler, and made sure all resets
   are notified to the lldd. Patches 9-12

5/ A small diet for sas_task to move slow path infrastructue out of the
   fast path use case. Patch 13

[1]: http://marc.info/?l=linux-scsi&m=132677728817896&w=2

---

[PATCH 01/13] libsas: close scsi_remove_target() vs libata-eh race
[PATCH 02/13] libsas: improve debug statements
[PATCH 03/13] libsas: async ata scanning
[PATCH 04/13] libsas: set attached device type and target protocols for local phys
[PATCH 05/13] libsas: fixup target_port_protocols for expanders that don't report sata
[PATCH 06/13] libsas: don't recover end devices attached to disabled phys
[PATCH 07/13] scsi_transport_sas: 'enable' phys on reset
[PATCH 08/13] libsas: libsas.force_hard_reset module parameter
[PATCH 09/13] libsas: enforce eh strategy handlers only in eh context
[PATCH 10/13] libsas: add sas_eh_abort_handler
[PATCH 11/13] libsas: use ->lldd_I_T_nexus_reset for ->eh_bus_reset_handler
[PATCH 12/13] isci: use sas eh strategy handlers
[PATCH 13/13] libsas: trim sas_task of slow path infrastructure

The following changes since commit d65b4e98d7ea3038b767b70fe8be959b2913f16d:

  Linux 3.3-rc3 (2012-02-08 19:21:53 -0800)

are available in the git repository at:
  git://git.kernel.org/pub/scm/linux/kernel/git/djbw/isci.git libsas-eh-reworks-v8

Dan Williams (58):
      libsas: remove unused ata_task_resp fields
      libsas: kill sas_slave_destroy
      libsas: fix domain_device leak
      libsas: fix leak of dev->sata_dev.identify_[packet_]device
      libsas: replace event locks with atomic bitops
      libsas: convert ha->state to flags
      libsas: introduce sas_drain_work()
      libsas: remove ata_port.lock management duties from lldds
      libsas: convert dev->gone to flags
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
      libsas: pre-clean commands that won the eh vs completion race
      libsas: mark all domain devices gone if root port disappears
      libsas: close scsi_remove_target() vs libata-eh race
      libsas: fix mixed topology recovery
      libsas: route local link resets through ata-eh
      libsas: fix sas_unregister_ports vs sas_drain_work
      libsas: improve debug statements
      libsas: fix sas port naming
      libsas: let libata recover links that fail to transmit initial sig-fis
      libsas: delete device on sas address changed
      libsas: restore scan order
      libsas: async ata scanning
      libsas: fix lifetime of SAS_HA_FROZEN
      libsas: revert ata srst
      libsas: set attached device type and target protocols for local phys
      libsas: fixup target_port_protocols for expanders that don't report sata
      libsas: don't recover end devices attached to disabled phys
      scsi_transport_sas: 'enable' phys on reset
      libsas: libsas.force_hard_reset module parameter
      libsas: enforce eh strategy handlers only in eh context
      libsas: add sas_eh_abort_handler
      libsas: use ->lldd_I_T_nexus_reset for ->eh_bus_reset_handler
      isci: use sas eh strategy handlers
      libsas: trim sas_task of slow path infrastructure

Jeff Skirvin (2):
      libsas: Remove redundant phy state notification calls.
      libsas: add mutex for SMP task execution

Maciej Trela (1):
      libsas: kill spurious sas_put_device

 Documentation/kernel-parameters.txt |    6 +
 Documentation/scsi/libsas.txt       |   15 -
 drivers/ata/libata-core.c           |   34 +-
 drivers/ata/libata-eh.c             |    1 +
 drivers/ata/libata-scsi.c           |   13 +
 drivers/ata/libata.h                |    2 +-
 drivers/scsi/aic94xx/aic94xx.h      |    2 +
 drivers/scsi/aic94xx/aic94xx_dev.c  |   38 +-
 drivers/scsi/aic94xx/aic94xx_init.c |    6 +-
 drivers/scsi/aic94xx/aic94xx_tmf.c  |   11 +-
 drivers/scsi/isci/host.c            |    8 +-
 drivers/scsi/isci/host.h            |   19 +-
 drivers/scsi/isci/init.c            |   17 +-
 drivers/scsi/isci/phy.c             |   18 +-
 drivers/scsi/isci/phy.h             |    1 -
 drivers/scsi/isci/port.c            |  217 +++++-----
 drivers/scsi/isci/port.h            |   11 +-
 drivers/scsi/isci/remote_device.c   |   32 +-
 drivers/scsi/isci/remote_device.h   |    7 +-
 drivers/scsi/isci/request.c         |  198 +--------
 drivers/scsi/isci/request.h         |    9 +-
 drivers/scsi/isci/task.c            |  158 ++------
 drivers/scsi/isci/task.h            |   40 --
 drivers/scsi/libsas/sas_ata.c       |  827 +++++++++++++++++------------------
 drivers/scsi/libsas/sas_discover.c  |  216 ++++++++--
 drivers/scsi/libsas/sas_event.c     |   96 ++++-
 drivers/scsi/libsas/sas_expander.c  |  360 ++++++++++------
 drivers/scsi/libsas/sas_host_smp.c  |   11 +-
 drivers/scsi/libsas/sas_init.c      |  243 +++++++++--
 drivers/scsi/libsas/sas_internal.h  |   97 +++--
 drivers/scsi/libsas/sas_phy.c       |   12 +-
 drivers/scsi/libsas/sas_port.c      |   32 +-
 drivers/scsi/libsas/sas_scsi_host.c |  421 +++++++++----------
 drivers/scsi/mvsas/mv_init.c        |    2 -
 drivers/scsi/mvsas/mv_sas.c         |   31 +-
 drivers/scsi/pm8001/pm8001_init.c   |    2 -
 drivers/scsi/pm8001/pm8001_sas.c    |   59 ++--
 drivers/scsi/scsi_transport_sas.c   |   60 +++-
 include/linux/libata.h              |    2 +
 include/scsi/libsas.h               |   86 +++--
 include/scsi/sas.h                  |    4 +-
 include/scsi/sas_ata.h              |   44 ++-
 include/scsi/scsi_transport_sas.h   |   12 +-
 43 files changed, 1859 insertions(+), 1621 deletions(-)
