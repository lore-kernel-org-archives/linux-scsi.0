From: Dan Williams <dan.j.williams@intel.com>
Subject: [PATCH 00/24] libsas: eh reworks (ata-eh vs discovery, races, ...)
Date: Fri, 16 Dec 2011 18:33:07 -0800
Message-ID: <20111217022912.15036.85808.stgit@localhost6.localdomain6>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-ide-owner@vger.kernel.org>
Sender: linux-ide-owner@vger.kernel.org
To: linux-scsi@vger.kernel.org
Cc: linux-ide@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org

Short overview:
1/ teach libsas to honor the reset recovery deadline specified by libata
2/ close command timeout vs normal completion races
3/ miscellaneous leak fixes and cleanups 

Currently libsas has problems coordinating ata device reset with
discovery [1].  A hard reset causes a link down event and depending on
when the link recovers the device could be removed or trigger
rediscovery and more resets.

In the direct-attached case the driver is able to debounce the link and
hide the signal-loss events from libsas.  In the expander-attached case
we need to poll the expander and check for device recovery before
processing the broadcast-change-notifications (resulting from the
reset).

Patches 1 - 3: drain_workqueue()
Because we want expander discovery to block on eh, we need to move ata
discovery to its own workqueue event.  That changes the chained work
queue depth from an lldd event from 2 to 3.  In order to ensure that
chain is flushed properly scsi_flush_work() is switched from
flush_workqueue() to drain_workqueue() (or otherwise open code 3-calls
to scsi_flush_work()).  Patch 2 fixes up drain_workqueue() so we can
continue to submit libsas events while draining.

Patches 4 - 8, 11: Miscellaneous cleanups
We seem to have been leaking struct domain_device objects for a while,
and the event locks in libsas are not required.

Patch 9: uplevel sas_ata ata lock management

Patches 12 - 17: completion races and libsas-eh vs libata-eh
Close races between eh completion and "late" completion by the lldd.
Where possible defer error handling to libata.  After these updates a
lldd can use sas_ata_schedule_reset() to ensure that the reset is
performed in libata context and not libsas-eh which has no link recovery
logic.

Patches 10, 18 - 24: libata link management
These patches aim to make sure all sources of reset of ata devices
occur in libata-eh context.  While libata-eh is active domain
rediscovery is held off.

  git://git.kernel.org/pub/scm/linux/kernel/git/djbw/isci.git libsas

[PATCH 01/24] workqueue: promote workqueue_lock to hard-irq safe
[PATCH 02/24] workqueue: defer work to a draining queue
[PATCH 03/24] scsi: use drain_workqueue
[PATCH 04/24] libsas: remove unused ata_task_resp fields
[PATCH 05/24] libsas: kill sas_slave_destroy
[PATCH 06/24] libsas: fix domain_device leak
[PATCH 07/24] libsas: fix leak of dev->sata_dev.identify_[packet_]device
[PATCH 08/24] libsas: replace event locks with atomic bitops
[PATCH 09/24] libsas: remove ata_port.lock management duties from lldds
[PATCH 10/24] libsas: prevent domain rediscovery competing with ata error handling
[PATCH 11/24] libsas: use ->set_dmamode to notify lldds of NCQ parameters
[PATCH 12/24] libsas: kill invocation of scsi_eh_finish_cmd from sas_ata_task_done
[PATCH 13/24] libsas: close error handling vs sas_ata_task_done() race
[PATCH 14/24] libsas: prevent double completion of scmds from eh
[PATCH 15/24] libsas: fix timeout vs completion race
[PATCH 16/24] libsas: let libata handle command timeouts
[PATCH 17/24] libsas: defer SAS_TASK_NEED_DEV_RESET commands to libata
[PATCH 18/24] libsas: use libata-eh-reset for sata rediscovery fis transmit failures
[PATCH 19/24] libsas: execute transport link resets with libata-eh via host workqueue
[PATCH 20/24] libsas: sas_phy_enable via transport_sas_phy_reset
[PATCH 21/24] libsas: Remove redundant phy state notification calls.
[PATCH 22/24] libsas: add mutex for SMP task execution
[PATCH 23/24] libsas: async ata-eh
[PATCH 24/24] libsas: poll for ata device readiness after reset

 Documentation/scsi/libsas.txt       |   15 -
 drivers/ata/libata-eh.c             |    1 
 drivers/ata/libata.h                |    1 
 drivers/scsi/aic94xx/aic94xx.h      |    2 
 drivers/scsi/aic94xx/aic94xx_dev.c  |   38 +-
 drivers/scsi/aic94xx/aic94xx_init.c |    3 
 drivers/scsi/hosts.c                |    8 
 drivers/scsi/isci/host.c            |    3 
 drivers/scsi/isci/init.c            |    1 
 drivers/scsi/isci/request.c         |    3 
 drivers/scsi/isci/task.c            |    6 
 drivers/scsi/isci/task.h            |   36 --
 drivers/scsi/libsas/sas_ata.c       |  666 ++++++++++++++---------------------
 drivers/scsi/libsas/sas_discover.c  |   73 +++-
 drivers/scsi/libsas/sas_event.c     |    8 
 drivers/scsi/libsas/sas_expander.c  |   98 ++++-
 drivers/scsi/libsas/sas_init.c      |   88 ++++-
 drivers/scsi/libsas/sas_internal.h  |   57 ++-
 drivers/scsi/libsas/sas_phy.c       |   12 -
 drivers/scsi/libsas/sas_port.c      |   16 -
 drivers/scsi/libsas/sas_scsi_host.c |  251 ++++++-------
 drivers/scsi/mvsas/mv_init.c        |    1 
 drivers/scsi/mvsas/mv_sas.c         |    6 
 drivers/scsi/pm8001/pm8001_init.c   |    1 
 drivers/scsi/pm8001/pm8001_sas.c    |    6 
 drivers/scsi/scsi_transport_sas.c   |   49 ++-
 include/linux/libata.h              |    1 
 include/linux/workqueue.h           |    3 
 include/scsi/libsas.h               |   43 +-
 include/scsi/sas_ata.h              |   26 +
 include/scsi/scsi_host.h            |    2 
 include/scsi/scsi_transport_sas.h   |    5 
 kernel/workqueue.c                  |  141 +++++--
 33 files changed, 836 insertions(+), 834 deletions(-)

[1]: http://marc.info/?l=linux-scsi&m=131941375221687&w=2
