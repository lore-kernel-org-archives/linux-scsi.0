From: James Bottomley <James.Bottomley@HansenPartnership.com>
Subject: [GIT PULL] final round of SCSI updates for the 4.10+ merge window
Date: Fri, 03 Mar 2017 16:53:53 -0800
Message-ID: <1488588833.2345.5.camel@HansenPartnership.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner@vger.kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
To: Andrew Morton <akpm@linux-foundation.org>, Linus Torvalds <torvalds@linux-foundation.org>
Cc: linux-scsi <linux-scsi@vger.kernel.org>, linux-kernel <linux-kernel@vger.kernel.org>
List-Id: linux-scsi@vger.kernel.org

This is the set of stuff that didn't quite make the initial pull and a
set of fixes for stuff which did.  The new stuff is basically lpfc
(nvme), qedi and aacraid.  The fixes cover a lot of previously
submitted stuff, the most important of which probably covers some of
the failing irq vectors allocation and other fallout from having the
SCSI command allocated as part of the block allocation functions.

The patch is available here:

git://git.kernel.org/pub/scm/linux/kernel/git/jejb/scsi.git scsi-misc

The short changelog is:

Arnd Bergmann (3):
      scsi: lpfc: use proper format string for dma_addr_t
      scsi: lpfc: use div_u64 for 64-bit division
      scsi: smartpqi: fix time handling

Christoph Hellwig (7):
      scsi: remove scsi_execute_req_flags
      scsi: merge __scsi_execute into scsi_execute
      scsi: simplify scsi_execute_req_flags
      scsi: make the sense header argument to scsi_test_unit_ready mandatory
      scsi: sd: improve TUR handling in sd_check_events
      scsi: always zero sshdr in scsi_normalize_sense
      scsi: lpfc: use pci_irq_alloc_vectors and pci_irq_free_vectors

Colin Ian King (3):
      scsi: aacraid: remove redundant zero check on ret
      scsi: qla2xxx: fix spelling mistake: "seperator" -> "separator"
      scsi: fix memory leak of sdpk on when gd fails to allocate

Dan Carpenter (1):
      scsi: scsi_dh_emc: return success in clariion_std_inquiry()

Don Brace (1):
      scsi: cciss: correct check map error.

Dupuis, Chad (3):
      scsi: qedi: Fix memory leak in tmf response processing.
      scsi: qedf: fixup compilation warning about atomic_t usage
      scsi: qedf: Add QLogic FastLinQ offload FCoE driver framework.

Finn Thain (1):
      scsi: mac_scsi: Fix MAC_SCSI=m option when SCSI=m

Hannes Reinecke (2):
      scsi: mpt3sas: switch to pci_alloc_irq_vectors
      scsi: use 'scsi_device_from_queue()' for scsi_dh

James Smart (16):
      scsi: lpfc: add missing Kconfig NVME dependencies
      scsi: lpfc: Update lpfc version to 11.2.0.7
      scsi: lpfc: Update copyrights
      scsi: lpfc: NVME Target: Add debugfs support
      scsi: lpfc: NVME Target: bind to nvmet_fc api
      scsi: lpfc: NVME Target: Merge into FC discovery
      scsi: lpfc: NVME Target: Receive buffer updates
      scsi: lpfc: NVME Target: Base modifications
      scsi: lpfc: NVME Initiator: Add debugfs support
      scsi: lpfc: NVME Initiator: bind to nvme_fc api
      scsi: lpfc: NVME Initiator: Merge into FC discovery
      scsi: lpfc: NVME Initiator: Base modifications
      scsi: lpfc: refactor debugfs queue dump routines
      scsi: lpfc: refactor debugfs queue prints
      scsi: lpfc: minor code cleanups
      scsi: lpfc: Correct WQ creation for pagesize

Matthew R. Ochs (1):
      scsi: cxlflash: Enable PCI device ID for future IBM CXL Flash AFU

Michael Hernandez (3):
      scsi: qla2xxx: Fix Regression introduced by pci_alloc_irq_vectors_affinity call.
      scsi: qla2xxx: Fix response queue count for Target mode.
      scsi: qla2xxx: Cleaned up queue configuration code.

Raghava Aditya Renukunta (16):
      scsi: aacraid: Fixed expander hotplug for SMART family
      scsi: aacraid: Update driver version
      scsi: aacraid: Fix a potential spinlock double unlock bug
      scsi: aacraid: Save adapter fib log before an IOP reset
      scsi: aacraid: Reorder Adapter status check
      scsi: aacraid: Skip IOP reset on controller panic(SMART Family)
      scsi: aacraid: Decrease adapter health check interval
      scsi: aacraid: Reload offlined drives after controller reset
      scsi: aacraid: Skip wellness sync on controller failure
      scsi: aacraid: Fix sync fibs time out on controller reset
      scsi: aacraid: Added sysfs for driver version
      scsi: aacraid: Fix memory leak in fib init path
      scsi: aacraid: Prevent E3 lockup when deleting units
      scsi: aacraid: Fix for excessive prints on EEH
      scsi: aacraid: Use correct channel number for raw srb
      scsi: aacraid: Fix camel case

Subhash Jadavani (1):
      scsi: ufs-qcom: remove redundant condition check

Wei Yongjun (1):
      scsi: sd: make sd_devt_release() static

And the diffstat

 MAINTAINERS                                 |    6 +
 drivers/ata/libata-scsi.c                   |   12 +-
 drivers/block/cciss.c                       |   32 +-
 drivers/scsi/Kconfig                        |    4 +-
 drivers/scsi/Makefile                       |    1 +
 drivers/scsi/aacraid/aachba.c               |   59 +-
 drivers/scsi/aacraid/aacraid.h              |  107 +-
 drivers/scsi/aacraid/commctrl.c             |    2 +-
 drivers/scsi/aacraid/comminit.c             |    2 +-
 drivers/scsi/aacraid/commsup.c              |  118 +-
 drivers/scsi/aacraid/linit.c                |   47 +-
 drivers/scsi/aacraid/rx.c                   |    2 +-
 drivers/scsi/aacraid/src.c                  |   48 +-
 drivers/scsi/cxlflash/main.c                |    4 +
 drivers/scsi/cxlflash/main.h                |    1 +
 drivers/scsi/cxlflash/superpipe.c           |    8 +-
 drivers/scsi/cxlflash/vlun.c                |    4 +-
 drivers/scsi/device_handler/scsi_dh_alua.c  |   16 +-
 drivers/scsi/device_handler/scsi_dh_emc.c   |    9 +-
 drivers/scsi/device_handler/scsi_dh_hp_sw.c |   10 +-
 drivers/scsi/device_handler/scsi_dh_rdac.c  |    7 +-
 drivers/scsi/lpfc/Makefile                  |   11 +-
 drivers/scsi/lpfc/lpfc.h                    |  162 +-
 drivers/scsi/lpfc/lpfc_attr.c               |  570 ++++-
 drivers/scsi/lpfc/lpfc_attr.h               |    4 +-
 drivers/scsi/lpfc/lpfc_bsg.c                |   33 +-
 drivers/scsi/lpfc/lpfc_bsg.h                |    6 +-
 drivers/scsi/lpfc/lpfc_compat.h             |    4 +-
 drivers/scsi/lpfc/lpfc_crtn.h               |   68 +-
 drivers/scsi/lpfc/lpfc_ct.c                 |  388 +++-
 drivers/scsi/lpfc/lpfc_debugfs.c            | 2300 +++++++++++++-----
 drivers/scsi/lpfc/lpfc_debugfs.h            |  291 +--
 drivers/scsi/lpfc/lpfc_disc.h               |   24 +-
 drivers/scsi/lpfc/lpfc_els.c                |  366 ++-
 drivers/scsi/lpfc/lpfc_hbadisc.c            |  363 ++-
 drivers/scsi/lpfc/lpfc_hw.h                 |   86 +-
 drivers/scsi/lpfc/lpfc_hw4.h                |  506 +++-
 drivers/scsi/lpfc/lpfc_ids.h                |    4 +-
 drivers/scsi/lpfc/lpfc_init.c               | 2889 +++++++++++++----------
 drivers/scsi/lpfc/lpfc_logmsg.h             |    8 +-
 drivers/scsi/lpfc/lpfc_mbox.c               |  114 +-
 drivers/scsi/lpfc/lpfc_mem.c                |  278 ++-
 drivers/scsi/lpfc/lpfc_nl.h                 |    4 +-
 drivers/scsi/lpfc/lpfc_nportdisc.c          |  257 ++-
 drivers/scsi/lpfc/lpfc_nvme.c               | 2464 ++++++++++++++++++++
 drivers/scsi/lpfc/lpfc_nvme.h               |  103 +
 drivers/scsi/lpfc/lpfc_nvmet.c              | 1986 ++++++++++++++++
 drivers/scsi/lpfc/lpfc_nvmet.h              |  116 +
 drivers/scsi/lpfc/lpfc_scsi.c               |  111 +-
 drivers/scsi/lpfc/lpfc_scsi.h               |   22 +-
 drivers/scsi/lpfc/lpfc_sli.c                | 2195 ++++++++++++++----
 drivers/scsi/lpfc/lpfc_sli.h                |   42 +-
 drivers/scsi/lpfc/lpfc_sli4.h               |   98 +-
 drivers/scsi/lpfc/lpfc_version.h            |   10 +-
 drivers/scsi/lpfc/lpfc_vport.c              |   21 +-
 drivers/scsi/lpfc/lpfc_vport.h              |    4 +-
 drivers/scsi/mpt3sas/mpt3sas_base.c         |  105 +-
 drivers/scsi/mpt3sas/mpt3sas_base.h         |    2 -
 drivers/scsi/osd/osd_uld.c                  |    3 +-
 drivers/scsi/qedf/Kconfig                   |   11 +
 drivers/scsi/qedf/Makefile                  |    5 +
 drivers/scsi/qedf/qedf.h                    |  545 +++++
 drivers/scsi/qedf/qedf_attr.c               |  165 ++
 drivers/scsi/qedf/qedf_dbg.c                |  195 ++
 drivers/scsi/qedf/qedf_dbg.h                |  154 ++
 drivers/scsi/qedf/qedf_debugfs.c            |  460 ++++
 drivers/scsi/qedf/qedf_els.c                |  949 ++++++++
 drivers/scsi/qedf/qedf_fip.c                |  269 +++
 drivers/scsi/qedf/qedf_hsi.h                |  422 ++++
 drivers/scsi/qedf/qedf_io.c                 | 2282 ++++++++++++++++++
 drivers/scsi/qedf/qedf_main.c               | 3336 +++++++++++++++++++++++++++
 drivers/scsi/qedf/qedf_version.h            |   15 +
 drivers/scsi/qedi/qedi_fw.c                 |    5 +-
 drivers/scsi/qla2xxx/qla_isr.c              |    7 +-
 drivers/scsi/qla2xxx/qla_os.c               |   16 +-
 drivers/scsi/qla2xxx/tcm_qla2xxx.c          |    2 +-
 drivers/scsi/scsi_common.c                  |    4 +-
 drivers/scsi/scsi_dh.c                      |   22 +-
 drivers/scsi/scsi_ioctl.c                   |    3 +-
 drivers/scsi/scsi_lib.c                     |  113 +-
 drivers/scsi/scsi_transport_spi.c           |   24 +-
 drivers/scsi/sd.c                           |   40 +-
 drivers/scsi/smartpqi/smartpqi_init.c       |    8 +-
 drivers/scsi/sr_ioctl.c                     |   19 +-
 drivers/scsi/ufs/ufs-qcom.c                 |   12 -
 drivers/scsi/ufs/ufshcd.c                   |   10 +-
 include/scsi/scsi_device.h                  |   14 +-
 87 files changed, 22404 insertions(+), 3220 deletions(-)
 create mode 100644 drivers/scsi/lpfc/lpfc_nvme.c
 create mode 100644 drivers/scsi/lpfc/lpfc_nvme.h
 create mode 100644 drivers/scsi/lpfc/lpfc_nvmet.c
 create mode 100644 drivers/scsi/lpfc/lpfc_nvmet.h
 create mode 100644 drivers/scsi/qedf/Kconfig
 create mode 100644 drivers/scsi/qedf/Makefile
 create mode 100644 drivers/scsi/qedf/qedf.h
 create mode 100644 drivers/scsi/qedf/qedf_attr.c
 create mode 100644 drivers/scsi/qedf/qedf_dbg.c
 create mode 100644 drivers/scsi/qedf/qedf_dbg.h
 create mode 100644 drivers/scsi/qedf/qedf_debugfs.c
 create mode 100644 drivers/scsi/qedf/qedf_els.c
 create mode 100644 drivers/scsi/qedf/qedf_fip.c
 create mode 100644 drivers/scsi/qedf/qedf_hsi.h
 create mode 100644 drivers/scsi/qedf/qedf_io.c
 create mode 100644 drivers/scsi/qedf/qedf_main.c
 create mode 100644 drivers/scsi/qedf/qedf_version.h

James
