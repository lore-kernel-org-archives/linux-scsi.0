From: Dan Williams <dan.j.williams@intel.com>
Subject: Re: [GIT PATCH v3 00/14] libsas: eh reworks (ata-eh vs discovery,
 races, ...)
Date: Thu, 05 Jan 2012 17:46:40 -0800
Message-ID: <1325814402.17049.5.camel@ultramagnus.opencreations.com>
References: <20120106005634.11464.64030.stgit@localhost6.localdomain6>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-ide-owner@vger.kernel.org>
In-Reply-To: <20120106005634.11464.64030.stgit@localhost6.localdomain6>
Sender: linux-ide-owner@vger.kernel.org
To: linux-scsi@vger.kernel.org
Cc: linux-ide@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org

On Thu, 2012-01-05 at 16:59 -0800, Dan Williams wrote:
> Note, the patches mailed with this update only include the libsas patches
> that have been revised since v2, and the isci updates that were
> dependent on these changes.
> 
> For the full set in proper order see the current state of the 'libsas'
> branch in isci.git (commit c3766a3):

Just noticed that scsi-misc was rebased since last checked.   Patch kit
re-flowed (none of the contents changed).  'libsas' is now at commit
5c41dc3:

The following changes since commit 5c41dc3a79150e93e5d050871a10b761be8281a1:

  [SCSI] lpfc 8.3.28: Update driver version to 8.3.28 (2011-12-15 10:57:45 +0400)

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


