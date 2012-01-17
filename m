From: Dan Williams <dan.j.williams@intel.com>
Subject: [resend PATCH v4 00/10] libsas: eh reworks (ata-eh vs discovery, races,
 ...)
Date: Mon, 16 Jan 2012 21:11:01 -0800
Message-ID: <20120117050847.22344.4961.stgit@localhost6.localdomain6>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-ide-owner@vger.kernel.org>
Sender: linux-ide-owner@vger.kernel.org
To: linux-scsi@vger.kernel.org
Cc: linux-ide@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org

A resend of v4: http://marc.info/?l=linux-scsi&m=132618126007864&w=1

These are all the patches that were modified between v3 and v4.  Previously
only an incremental diff was provided.

---

Dan Williams (10):
      libsas: convert dev->gone to flags
      libsas: prevent domain rediscovery competing with ata error handling
      libsas: fix timeout vs completion race
      libsas: don't mark expanders as gone when a child device is removed
      libsas: check for 'gone' expanders in smp_execute_task()
      libsas: fix sas_find_local_phy(), take phy references
      libsas: don't recover 'gone' devices in sas_ata_hard_reset()
      isci: ->lldd_ata_check_ready handler
      libsas: pre-clean commands that won the eh vs completion race
      libsas: feed the scsi_block_when_processing_errors() meter

 drivers/ata/libata-eh.c             |    1 
 drivers/ata/libata.h                |    1 
 drivers/scsi/aic94xx/aic94xx.h      |    2 
 drivers/scsi/aic94xx/aic94xx_dev.c  |   38 +-
 drivers/scsi/aic94xx/aic94xx_init.c |    2 
 drivers/scsi/aic94xx/aic94xx_tmf.c  |    9 
 drivers/scsi/isci/host.h            |   19 -
 drivers/scsi/isci/init.c            |   12 -
 drivers/scsi/isci/phy.c             |   18 +
 drivers/scsi/isci/phy.h             |    1 
 drivers/scsi/isci/port.c            |  217 ++++++------
 drivers/scsi/isci/port.h            |   11 -
 drivers/scsi/isci/remote_device.c   |   32 --
 drivers/scsi/isci/remote_device.h   |    7 
 drivers/scsi/isci/request.c         |  195 ----------
 drivers/scsi/isci/request.h         |    9 
 drivers/scsi/isci/task.c            |  152 ++------
 drivers/scsi/isci/task.h            |    4 
 drivers/scsi/libsas/sas_ata.c       |  652 +++++++++++++++--------------------
 drivers/scsi/libsas/sas_discover.c  |   93 ++++-
 drivers/scsi/libsas/sas_event.c     |   28 +-
 drivers/scsi/libsas/sas_expander.c  |  103 ++++--
 drivers/scsi/libsas/sas_init.c      |  176 +++++++++
 drivers/scsi/libsas/sas_internal.h  |   22 +
 drivers/scsi/libsas/sas_port.c      |   11 -
 drivers/scsi/libsas/sas_scsi_host.c |  289 +++++++---------
 drivers/scsi/mvsas/mv_sas.c         |    3 
 drivers/scsi/pm8001/pm8001_sas.c    |   19 +
 drivers/scsi/scsi_transport_sas.c   |   59 +++
 include/linux/libata.h              |    1 
 include/scsi/libsas.h               |   48 ++-
 include/scsi/sas_ata.h              |   23 +
 include/scsi/scsi_transport_sas.h   |   12 +
 33 files changed, 1124 insertions(+), 1145 deletions(-)
