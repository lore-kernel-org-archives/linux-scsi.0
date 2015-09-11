From: James Bottomley <James.Bottomley@HansenPartnership.com>
Subject: [GIT PULL] final round of SCSI updates for the 4.2+ merge window
Date: Fri, 11 Sep 2015 12:47:06 -0700
Message-ID: <1442000826.9498.0.camel@HansenPartnership.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner@vger.kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
To: Andrew Morton <akpm@linux-foundation.org>, Linus Torvalds <torvalds@linux-foundation.org>
Cc: linux-scsi <linux-scsi@vger.kernel.org>, linux-kernel <linux-kernel@vger.kernel.org>
List-Id: linux-scsi@vger.kernel.org

There's one late arriving patch here (added today), fixing a build issue
which the scsi_dh patch set in here uncovered.  Other than that,
everything has been incubated in -next and the checkers for a week.

The major pieces of this patch are a set patches facilitating better
integration between scsi and scsi_dh (the device handling layer used by
multi-path; all the dm parts are acked by Mike Snitzer).  It also
includes driver updates for mp3sas, scsi_debug and an assortment of bug
fixes.

The patch is available here:

git://git.kernel.org/pub/scm/linux/kernel/git/jejb/scsi.git scsi-misc

The Short Changelog is:

Anil Gurumurthy (2):
      bfa: Fix incorrect de-reference of pointer
      bfa: Fix indentation

Calvin Owens (2):
      mpt2sas: Refcount fw_events and fix unsafe list usage
      mpt2sas: Refcount sas_device objects and fix unsafe list usage

Christoph Hellwig (9):
      scsi_dh: fix randconfig build error
      scsi_dh: don't allow to detach device handlers at runtime
      scsi_dh: add a common helper to get a scsi_device from a request_queue
      scsi_dh: kill struct scsi_dh_data
      scsi_dh: move device matching to the core code
      scsi_dh: integrate into the core SCSI code
      scsi_dh: move to drivers/scsi
      dm-mpath, scsi_dh: request scsi_dh modules in scsi_dh, not dm-mpath
      dm-mpath, scsi_dh: don't let dm detach device handlers

Gabriel Krisman Bertazi (2):
      ipr: Enable SIS pipe commands for SIS-32 devices.
      ipr: Inhibit underlength data check for AFDASD in raw mode.

Hannes Reinecke (2):
      scsi_dh: return SCSI_DH_NOTCONN in scsi_dh_activate()
      aic94xx: Skip reading user settings if flash is not found

Johannes Thumshirn (2):
      pm80xx: Don't override ts->stat on IO_OPEN_CNX_ERROR_HW_RESOURCE_BUSY
      lpfc: Fix possible use-after-free and double free in lpfc_mbx_cmpl_rdp_page_a2()

Jordan Hargrave (1):
      scsi_transport_sas: Remove check for SAS expander when querying bay/enclosure IDs.

Michal Hocko (1):
      scsi: fix scsi_error_handler vs. scsi_host_dev_release race

Nagarajkumar Narayanan (1):
      mpt2sas: setpci reset kernel oops fix

Sreekanth Reddy (20):
      mpt3sas : Bump mpt3sas driver version to 9.100.00.00
      mpt3sas: When device is blocked followed by unblock fails, unfreeze the I/Os
      mpt3sas: Call dma_mapping_error() API after mapping an address with dma_map_single() API
      mpt3sas: Use alloc_ordered_workqueue() API instead of create_singlethread_workqueue() API
      mpt3sas: Added support for customer specific branding
      mpt3sas: Return host busy error status to SML when DMA mapping of scatter gather list fails for a SCSI command
      mpt3sas: Complete the SCSI command with DID_RESET status for log_info value 0x0x32010081
      mpt3sas: MPI 2.5 Rev K (2.5.6) specifications
      mpt3sas: Bump mpt3sas driver version to v6.100.00.00
      mpt3sas: Add branding string support for OEM custom HBA
      mpt3sas: Add branding string support for OEM's HBA
      mpt3sas: MPI 2.5 Rev J (2.5.5) specification and 2.00.34 header files
      mpt3sas: Update MPI2 strings to MPI2.5
      mpt3sas: Bump mpt3sas Driver version to v5.100.00.00
      mpt3sas: Provides the physical location of sas drives
      mpt3sas: MPI 2.5 Rev I (2.5.4) specifications.
      mpt3sas: Remove redundancy code while freeing the controller resources.
      mpt3sas: Don't block the drive when drive addition under the control of SML
      mpt3sas: Get IOC_FACTS information using handshake protocol only after HBA card gets into READY or Operational state.
      mpt3sas: Added Combined Reply Queue feature to extend up-to 96 MSIX vector support

Tomas Winkler (7):
      scsi_debug: resp_request: remove unused variable
      scsi_debug: fix REPORT LUNS Well Known LU
      scsi_debug: schedule_resp fix input variable check
      scsi_debug: make dump_sector static
      scsi_debug: vfree is null safe so drop the check
      scsi_debug: use SCSI_W_LUN_REPORT_LUNS instead of SAM2_WLUN_REPORT_LUNS;
      scsi_debug: define pr_fmt() for consistent logging

Vaishali Thakkar (1):
      fcoe: Convert use of __constant_htons to htons

And the diffstat:

 drivers/md/Kconfig                          |   2 +-
 drivers/md/dm-mpath.c                       |  27 +-
 drivers/scsi/Makefile                       |   1 +
 drivers/scsi/aic94xx/aic94xx_sds.c          |   5 +-
 drivers/scsi/bfa/bfa_ioc.c                  |  24 +-
 drivers/scsi/device_handler/Kconfig         |   2 +-
 drivers/scsi/device_handler/Makefile        |   1 -
 drivers/scsi/device_handler/scsi_dh.c       | 621 ----------------------------
 drivers/scsi/device_handler/scsi_dh_alua.c  |  31 +-
 drivers/scsi/device_handler/scsi_dh_emc.c   |  58 +--
 drivers/scsi/device_handler/scsi_dh_hp_sw.c |  55 +--
 drivers/scsi/device_handler/scsi_dh_rdac.c  |  80 +---
 drivers/scsi/fcoe/fcoe.c                    |   2 +-
 drivers/scsi/ipr.c                          |   8 +-
 drivers/scsi/lpfc/lpfc_mbox.c               |   7 +-
 drivers/scsi/mpt2sas/mpt2sas_base.c         |   6 +
 drivers/scsi/mpt2sas/mpt2sas_base.h         |  41 +-
 drivers/scsi/mpt2sas/mpt2sas_ctl.c          |  38 +-
 drivers/scsi/mpt2sas/mpt2sas_scsih.c        | 605 +++++++++++++++++++--------
 drivers/scsi/mpt2sas/mpt2sas_transport.c    |  12 +-
 drivers/scsi/mpt3sas/mpi/mpi2.h             |   8 +-
 drivers/scsi/mpt3sas/mpi/mpi2_cnfg.h        |  52 ++-
 drivers/scsi/mpt3sas/mpi/mpi2_ioc.h         |   4 +-
 drivers/scsi/mpt3sas/mpi/mpi2_tool.h        |   4 +-
 drivers/scsi/mpt3sas/mpt3sas_base.c         | 310 ++++++++++++--
 drivers/scsi/mpt3sas/mpt3sas_base.h         |  57 ++-
 drivers/scsi/mpt3sas/mpt3sas_scsih.c        | 343 ++++++++++++---
 drivers/scsi/mpt3sas/mpt3sas_transport.c    |  22 +-
 drivers/scsi/pm8001/pm8001_hwi.c            |   1 +
 drivers/scsi/pm8001/pm80xx_hwi.c            |   1 +
 drivers/scsi/scsi_debug.c                   | 158 ++++---
 drivers/scsi/scsi_dh.c                      | 437 ++++++++++++++++++++
 drivers/scsi/scsi_error.c                   |  17 +-
 drivers/scsi/scsi_lib.c                     |   6 +-
 drivers/scsi/scsi_priv.h                    |   9 +
 drivers/scsi/scsi_sysfs.c                   |  10 +
 drivers/scsi/scsi_transport_sas.c           |  10 -
 include/scsi/scsi_device.h                  |  27 +-
 include/scsi/scsi_dh.h                      |  29 +-
 39 files changed, 1860 insertions(+), 1271 deletions(-)
 delete mode 100644 drivers/scsi/device_handler/scsi_dh.c
 create mode 100644 drivers/scsi/scsi_dh.c

James
