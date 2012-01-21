From: Dan Williams <dan.j.williams@intel.com>
Subject: [PATCH v6 0/7] libsas error handling + discovery v6
Date: Fri, 20 Jan 2012 17:50:39 -0800
Message-ID: <20120121014910.24930.54011.stgit@localhost6.localdomain6>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-ide-owner@vger.kernel.org>
Sender: linux-ide-owner@vger.kernel.org
To: linux-scsi@vger.kernel.org
Cc: linux-ide@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org

Changes since v5: http://marc.info/?l=linux-scsi&m=132656475829637&w=2

1/ Reworked "libsas: let libata recover links that fail to transmit initial
   sig-fis" to better handle problematic expanders and slow to attach ata
   devices.  libsas will now validate linkrate and take 'device-type' into
   account when determining if a new device is attached.

2/ Added support for asynchronously scanning ata devices.

3/ Reworked "libsas: fix sas_unregister_ports vs sas_drain_work" as lockdep
   complained about the original.

4/ New patch "libsas: fix sas port naming" makes direct-attached device naming
   more predictable and consistent with expander attached device naming.

5/ Made scan order more predictable by ensuring that regardless of device type
   we always attach in discovery order.  Slow to link devices will still be
   scanned out of order, link needs to be in at least the 'stp pending' state
   before the device will be considered attached.

---

Dan Williams (7):
      libsas: fix sas_unregister_ports vs sas_drain_work
      libsas: improve ata debug statements
      libsas: fix sas port naming
      libsas: let libata recover links that fail to transmit initial sig-fis
      libsas: delete device on sas address changed
      libsas: restore scan order
      libsas: async ata scanning


 drivers/ata/libata-core.c           |   34 +++--
 drivers/ata/libata-scsi.c           |   13 ++
 drivers/ata/libata.h                |    1 
 drivers/scsi/aic94xx/aic94xx_init.c |    1 
 drivers/scsi/isci/init.c            |    1 
 drivers/scsi/libsas/sas_ata.c       |  187 +++++++++++++++++++++--------
 drivers/scsi/libsas/sas_discover.c  |   47 +++++--
 drivers/scsi/libsas/sas_event.c     |   19 ++-
 drivers/scsi/libsas/sas_expander.c  |  229 +++++++++++++++++++++--------------
 drivers/scsi/libsas/sas_init.c      |   18 ++-
 drivers/scsi/libsas/sas_internal.h  |   16 ++
 drivers/scsi/libsas/sas_port.c      |    2 
 drivers/scsi/libsas/sas_scsi_host.c |   18 ---
 drivers/scsi/mvsas/mv_init.c        |    1 
 drivers/scsi/pm8001/pm8001_init.c   |    1 
 include/linux/libata.h              |    1 
 include/scsi/libsas.h               |    1 
 include/scsi/sas.h                  |    4 -
 include/scsi/sas_ata.h              |   23 ++--
 19 files changed, 398 insertions(+), 219 deletions(-)


Full snapshot in git:  note that libsas-eh-reworks-v4..libsas-eh-reworks-v6 is
a fast-forward, but that will not always be the case.

The following changes since commit 76ffe8a3f766358a0ade543153625b3e4e66159d:

  [SCSI] libfc: remove redundant timer init for fcp (2012-01-16 12:47:18 +0400)

are available in the git repository at:
  git://git.kernel.org/pub/scm/linux/kernel/git/djbw/isci.git libsas-eh-reworks-v6

Dan Williams (47):
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
      libsas: feed the scsi_block_when_processing_errors() meter
      libsas: mark all domain devices gone if root port disappears
      libsas: close scsi_remove_target() vs libata-eh race
      libsas: fix mixed topology recovery
      libsas: route local link resets through ata-eh
      libsas: fix sas_unregister_ports vs sas_drain_work
      libsas: improve ata debug statements
      libsas: fix sas port naming
      libsas: let libata recover links that fail to transmit initial sig-fis
      libsas: delete device on sas address changed
      libsas: restore scan order
      libsas: async ata scanning

Jeff Skirvin (2):
      libsas: Remove redundant phy state notification calls.
      libsas: add mutex for SMP task execution

Maciej Trela (1):
      libsas: kill spurious sas_put_device

 Documentation/scsi/libsas.txt       |   15 -
 drivers/ata/libata-core.c           |   34 +-
 drivers/ata/libata-eh.c             |    1 +
 drivers/ata/libata-scsi.c           |   13 +
 drivers/ata/libata.h                |    2 +-
 drivers/scsi/aic94xx/aic94xx.h      |    2 +
 drivers/scsi/aic94xx/aic94xx_dev.c  |   38 +-
 drivers/scsi/aic94xx/aic94xx_init.c |    6 +-
 drivers/scsi/aic94xx/aic94xx_tmf.c  |    9 +-
 drivers/scsi/isci/host.c            |    8 +-
 drivers/scsi/isci/host.h            |   19 +-
 drivers/scsi/isci/init.c            |   14 +-
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
 drivers/scsi/libsas/sas_ata.c       |  818 +++++++++++++++++------------------
 drivers/scsi/libsas/sas_discover.c  |  204 +++++++--
 drivers/scsi/libsas/sas_event.c     |   96 ++++-
 drivers/scsi/libsas/sas_expander.c  |  304 +++++++++-----
 drivers/scsi/libsas/sas_host_smp.c  |   11 +-
 drivers/scsi/libsas/sas_init.c      |  211 ++++++++-
 drivers/scsi/libsas/sas_internal.h  |   80 +++--
 drivers/scsi/libsas/sas_phy.c       |   12 +-
 drivers/scsi/libsas/sas_port.c      |   30 +-
 drivers/scsi/libsas/sas_scsi_host.c |  354 +++++++---------
 drivers/scsi/mvsas/mv_init.c        |    2 -
 drivers/scsi/mvsas/mv_sas.c         |   11 +-
 drivers/scsi/pm8001/pm8001_init.c   |    2 -
 drivers/scsi/pm8001/pm8001_sas.c    |   29 +-
 drivers/scsi/scsi_transport_sas.c   |   59 +++-
 include/linux/libata.h              |    2 +
 include/scsi/libsas.h               |   70 ++--
 include/scsi/sas.h                  |    4 +-
 include/scsi/sas_ata.h              |   44 ++-
 include/scsi/scsi_transport_sas.h   |   12 +-
 42 files changed, 1686 insertions(+), 1521 deletions(-)
