From: James Bottomley <James.Bottomley@HansenPartnership.com>
Subject: [GIT PULL] First round of SCSI updates for the 3.10+ merge window
Date: Tue, 02 Jul 2013 07:49:12 -0700
Message-ID: <1372776552.2821.14.camel@dabdike>
Mime-Version: 1.0
Content-Type: text/plain; charset="ISO-8859-15"
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner@vger.kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
To: Andrew Morton <akpm@linux-foundation.org>, Linus Torvalds <torvalds@linux-foundation.org>
Cc: linux-scsi <linux-scsi@vger.kernel.org>, linux-kernel <linux-kernel@vger.kernel.org>
List-Id: linux-scsi@vger.kernel.org

The patch set is mostly driver updates (usf, zfcp, lpfc, mpt2sas,
megaraid_sas, bfa, ipr) and a few bug fixes.  Also of note is that the
Buslogic driver has been rewritten to a better coding style and 64 bit
support added.  We also removed the libsas limitation on 16 bytes for
the command size (currently no drivers make use of this).

The patch is available here:

git://git.kernel.org/pub/scm/linux/kernel/git/jejb/scsi.git scsi-misc

The short changelog is:

Akinobu Mita (3):
      ufshcd-pltfrm: remove unnecessary dma_set_coherent_mask() call
      ufs: fix register address in UIC error interrupt handling
      ufshcd-pltfrm: add missing empty slot in ufs_of_match[]

Ben Hutchings (1):
      sd: Fix parsing of 'temporary ' cache mode prefix

Dan Carpenter (2):
      fnic: potential dead lock in fnic_is_abts_pending()
      pm80xx: remove unneeded NULL check

Daniel Hansel (1):
      zfcp: fix adapter (re)open recovery while link to SAN is down

Eddie Wai (1):
      libiscsi: Added new boot entries in the session sysfs

Geert Uytterhoeven (1):
      ufs: SCSI_UFSHCD should depend on SCSI_DMA

Hannes Reinecke (1):
      sd: avoid deadlocks when running under multipath

Jakob Normark (1):
      bfa: Fixes for 0-terminated strncpy and possible null pointer dereference

James Bottomley (1):
      libsas: implement > 16 byte CDB support

James Georgas (1):
      megaraid: minor cut and paste error fixed.

James Smart (17):
      lpfc 8.3.40: Update lpfc version to driver version 8.3.40
      lpfc 8.3.40: Update Copyrights to 2013 for 8.3.38, 8.3.39, and 8.3.40 modifications
      lpfc 8.3.40: Fixed a race condition between SLI host and port failed FCF rediscovery
      lpfc 8.3.40: Fixed issue mailbox wait routine failed to issue dump memory mbox command
      lpfc 8.3.40: Fixed system panic due to unsafe walking and deleting linked list
      lpfc 8.3.40: Fixed FCoE connection list vlan identifier and add FCF list debug
      lpfc 8.3.40: Clarified the behavior of the lpfc_max_luns module parameter
      lpfc 8.3.40: Fix to allow OCM to report FEC status
      lpfc 8.3.40: Fixed a missing return code in a logging message
      lpfc 8.3.40: Fixed some logging message fields
      lpfc 8.3.40: Fixed list corruption when lpfc_drain_tx runs.
      lpfc 8.3.40: Fix starting reference tag when calculating BG error
      lpfc 8.3.40: Fix inconsistent list removal causes crash.
      lpfc 8.3.40: Fixed system panic during handling unsolicited receive buffer error condition
      lpfc 8.3.40: Fix BlockGuard error checking
      lpfc 8.3.40: Fixed crash during FCoE failover testing.
      lpfc 8.3.40: Fix lpfc_used_cpu to be more dynamic

K. Y. Srinivasan (2):
      storvsc: Update the storage protocol to win8 level
      storvsc: Increase the value of scsi timeout for storvsc devices

Karen Xie (1):
      cxgb4i: add support for T5 adapter

Khalid Aziz (3):
      MAINTAINERS: Add myself as the maintainer for BusLogic SCSI driver
      BusLogic: Port driver to 64-bit.
      BusLogic: Fix style issues

Mahesh Rajashekhara (1):
      aacraid: Fix for arrays are going offline in the system. System hangs

Martin K. Petersen (4):
      sd: Update WRITE SAME heuristics
      3w-xxxx: Create sense buffer for unsupported commands
      Workaround for disks that report bad optimal transfer length
      Allow error handling timeout to be specified

Martin Peschke (1):
      zfcp: remove access control tables interface

Naresh Kumar Inna (1):
      csiostor: Retain default adapter configuration in absence of config file.

Reddy, Sreekanth (2):
      mpt2sas: fix for unused variable 'event_data' warning
      mpt2sas: Fix for issue Missing delay not getting set during system bootup

Sachin Kamat (1):
      ufs: Remove redundant platform_set_drvdata()

Sebastian Ott (4):
      zfcp: remove unused device_unregister wrapper
      zfcp: cleanup unit sysfs attribute usage
      zfcp: cleanup port sysfs attribute usage
      zfcp: cfdc fops add owner

Sergei Shtylyov (1):
      ipr: qc_fill_rtf() method should not store alternate status register

Seungwon Jeon (5):
      ufs: use devres functions for ufshcd
      ufs: rework link start-up process
      ufs: remove version check before IS reg clear
      ufs: amend interrupt configuration
      ufs: wrap the i/o access operations

Sreekanth Reddy (6):
      mpt2sas: Bump driver vesion to v15.100.00.00
      mpt2sas: Calulate the Reply post queue depth calculation as per the MPI spec
      mpt2sas: fix firmware failure with wrong task attribute
      mpt2sas: Fix for device scan following host reset could get stuck in a infinite loop
      mpt2sas: Update the timing requirements for issuing a Hard Reset
      mpt2sas: MPI2 Rev W (2.00.15) specification

Steffen Maier (3):
      zfcp: status read buffers on first adapter open with link down
      zfcp: module parameter dbflevel for early debugging
      zfcp: block queue limits with data router

Sujit Reddy Thumma (2):
      ufs: Fix the response UPIU length setting
      Documentation/devicetree: Add DT bindings for UFS host controller

Sumit.Saxena@lsi.com (12):
      megaraid_sas: Changelog and driver version update
      megaraid_sas: Add support to differentiate between iMR vs MR Firmware
      megaraid_sas: Add support for Uneven Span PRL11
      megaraid_sas: Add support for Extended MSI-x vectors for 12Gb/s controller
      megaraid_sas: Set IoFlags to enable Fast Path for JBODs for 12 Gb/s controllers
      megaraid_sas: Add support to display Customer branding details in syslog
      megaraid_sas: Add support for MegaRAID Fury (device ID-0x005f) 12Gb/s controllers
      megaraid_sas: Set IO request timeout value provided by OS timeout for Tape devices
      megaraid_sas: Free event detail memory without device ID check
      megaraid_sas: Update balance count in driver to be in sync of firmware
      megaraid_sas: Fix the interrupt mask for Gen2 controller
      megaraid_sas: Return DID_ERROR for SCSI IO, when controller is in critical h/w error

Vijay Mohan Guvva (2):
      bfa: fix for FC Direct Attach LUN discovery failure
      bfa: fix faulty handling of events in lps sm

Vijaya Mohan Guvva (17):
      bfa: Update the driver version to 3.2.21.1
      bfa: dis-associate bfa path_tov with dev_loss_tmo
      bfa: Support for chinook-quad port card
      bfa: fix endianess issue for firmware stats
      bfa: Fix bug_on condition in RPSC rsp handling
      bfa: Allow rsp queue process during ioc disable
      bfa: firmware statistics update
      bfa: fru vpd date update changes
      bfa: driver compatibility with 32bit libs
      bfa: kdump fix on 815 and 825 adapters
      bfa: Fix FDISC timeout handling
      bfa: Fix 1860 port initialize when ATC is enabled
      bfa: FDMI enhancements
      bfa: Fix WARN_ON condition check
      bfa: Add dynamic diagnostic port support
      bfa: Forward Error Correction status query
      bfa: Support for FC BB credit recovery

wenxiong@linux.vnet.ibm.com (3):
      ipr: IOA Status Code(IOASC) update
      ipr: possible irq lock inversion dependency detected
      ipr: Avoid target_destroy accessing memory after it was freed

and the diffstat:

 .../devicetree/bindings/ufs/ufshcd-pltfrm.txt      |   16 +
 Documentation/scsi/ChangeLog.megaraid_sas          |   22 +
 MAINTAINERS                                        |    7 +
 drivers/s390/scsi/Makefile                         |    2 +-
 drivers/s390/scsi/zfcp_aux.c                       |   36 +-
 drivers/s390/scsi/zfcp_ccw.c                       |   13 +-
 drivers/s390/scsi/zfcp_cfdc.c                      |  446 --
 drivers/s390/scsi/zfcp_dbf.c                       |   11 +-
 drivers/s390/scsi/zfcp_def.h                       |    4 -
 drivers/s390/scsi/zfcp_erp.c                       |    3 +-
 drivers/s390/scsi/zfcp_ext.h                       |   20 +-
 drivers/s390/scsi/zfcp_fc.c                        |    2 +-
 drivers/s390/scsi/zfcp_fsf.c                       |  154 +-
 drivers/s390/scsi/zfcp_fsf.h                       |   26 -
 drivers/s390/scsi/zfcp_scsi.c                      |   10 +-
 drivers/s390/scsi/zfcp_sysfs.c                     |   27 +-
 drivers/s390/scsi/zfcp_unit.c                      |    9 +-
 drivers/scsi/3w-xxxx.c                             |    4 +-
 drivers/scsi/BusLogic.c                            | 4452 +++++++++++---------
 drivers/scsi/BusLogic.h                            | 1487 ++++---
 drivers/scsi/FlashPoint.c                          |  626 ++-
 drivers/scsi/Kconfig                               |    2 +-
 drivers/scsi/aacraid/src.c                         |    3 +
 drivers/scsi/aic94xx/aic94xx_task.c                |    3 +-
 drivers/scsi/bfa/bfa_core.c                        |    3 +-
 drivers/scsi/bfa/bfa_defs.h                        |  103 +-
 drivers/scsi/bfa/bfa_defs_svc.h                    |   77 +-
 drivers/scsi/bfa/bfa_fc.h                          |   15 +
 drivers/scsi/bfa/bfa_fcpim.c                       |    2 +-
 drivers/scsi/bfa/bfa_fcs.c                         |   62 +-
 drivers/scsi/bfa/bfa_fcs.h                         |   34 +-
 drivers/scsi/bfa/bfa_fcs_lport.c                   |  209 +-
 drivers/scsi/bfa/bfa_fcs_rport.c                   |   11 +-
 drivers/scsi/bfa/bfa_ioc.c                         |   74 +-
 drivers/scsi/bfa/bfa_ioc.h                         |    9 +-
 drivers/scsi/bfa/bfa_ioc_cb.c                      |   86 +-
 drivers/scsi/bfa/bfa_ioc_ct.c                      |   46 +
 drivers/scsi/bfa/bfa_svc.c                         |  700 ++-
 drivers/scsi/bfa/bfa_svc.h                         |   34 +-
 drivers/scsi/bfa/bfad.c                            |   14 +-
 drivers/scsi/bfa/bfad_attr.c                       |   33 +-
 drivers/scsi/bfa/bfad_bsg.c                        |  137 +-
 drivers/scsi/bfa/bfad_bsg.h                        |   52 +-
 drivers/scsi/bfa/bfad_drv.h                        |    2 +-
 drivers/scsi/bfa/bfad_im.c                         |   10 +-
 drivers/scsi/bfa/bfi.h                             |   78 +-
 drivers/scsi/bfa/bfi_ms.h                          |    5 +-
 drivers/scsi/csiostor/csio_hw.c                    |   91 -
 drivers/scsi/csiostor/csio_hw.h                    |   11 -
 drivers/scsi/csiostor/csio_mb.c                    |   77 -
 drivers/scsi/csiostor/csio_mb.h                    |   11 -
 drivers/scsi/csiostor/csio_scsi.c                  |    4 +-
 drivers/scsi/cxgbi/cxgb4i/cxgb4i.c                 |  159 +-
 drivers/scsi/fnic/fnic_scsi.c                      |    6 +-
 drivers/scsi/ipr.c                                 |   74 +-
 drivers/scsi/ipr.h                                 |    6 +-
 drivers/scsi/isci/request.c                        |    4 +-
 drivers/scsi/libiscsi.c                            |   18 +
 drivers/scsi/libsas/sas_scsi_host.c                |    2 +-
 drivers/scsi/lpfc/lpfc.h                           |    2 +-
 drivers/scsi/lpfc/lpfc_attr.c                      |   23 +-
 drivers/scsi/lpfc/lpfc_bsg.c                       |    4 +-
 drivers/scsi/lpfc/lpfc_crtn.h                      |    2 +-
 drivers/scsi/lpfc/lpfc_ct.c                        |    2 +-
 drivers/scsi/lpfc/lpfc_els.c                       |    2 +-
 drivers/scsi/lpfc/lpfc_hbadisc.c                   |   38 +-
 drivers/scsi/lpfc/lpfc_hw.h                        |    2 +-
 drivers/scsi/lpfc/lpfc_hw4.h                       |    2 +-
 drivers/scsi/lpfc/lpfc_init.c                      |  129 +-
 drivers/scsi/lpfc/lpfc_mbox.c                      |    2 +-
 drivers/scsi/lpfc/lpfc_nportdisc.c                 |    2 +-
 drivers/scsi/lpfc/lpfc_scsi.c                      |  125 +-
 drivers/scsi/lpfc/lpfc_scsi.h                      |    2 +-
 drivers/scsi/lpfc/lpfc_sli.c                       |   52 +-
 drivers/scsi/lpfc/lpfc_sli4.h                      |    3 +-
 drivers/scsi/lpfc/lpfc_version.h                   |    6 +-
 drivers/scsi/megaraid/megaraid_sas.h               |  186 +-
 drivers/scsi/megaraid/megaraid_sas_base.c          |  226 +-
 drivers/scsi/megaraid/megaraid_sas_fp.c            |  784 +++-
 drivers/scsi/megaraid/megaraid_sas_fusion.c        |  148 +-
 drivers/scsi/megaraid/megaraid_sas_fusion.h        |   35 +-
 drivers/scsi/mpt2sas/mpi/mpi2.h                    |    6 +-
 drivers/scsi/mpt2sas/mpi/mpi2_init.h               |    4 +-
 drivers/scsi/mpt2sas/mpi/mpi2_ioc.h                |    8 +-
 drivers/scsi/mpt2sas/mpi/mpi2_raid.h               |    9 +-
 drivers/scsi/mpt2sas/mpi/mpi2_tool.h               |   10 +-
 drivers/scsi/mpt2sas/mpt2sas_base.c                |   59 +-
 drivers/scsi/mpt2sas/mpt2sas_base.h                |    7 +-
 drivers/scsi/mpt2sas/mpt2sas_scsih.c               |  143 +-
 drivers/scsi/mvsas/mv_sas.c                        |    3 +-
 drivers/scsi/pm8001/pm8001_hwi.c                   |    5 +-
 drivers/scsi/pm8001/pm80xx_hwi.c                   |   21 +-
 drivers/scsi/scsi.c                                |    8 +-
 drivers/scsi/scsi_devinfo.c                        |    1 +
 drivers/scsi/scsi_error.c                          |    7 +-
 drivers/scsi/scsi_scan.c                           |    5 +
 drivers/scsi/scsi_sysfs.c                          |   30 +
 drivers/scsi/scsi_transport_iscsi.c                |   12 +
 drivers/scsi/sd.c                                  |   77 +-
 drivers/scsi/sd.h                                  |    1 +
 drivers/scsi/storvsc_drv.c                         |  210 +-
 drivers/scsi/ufs/Kconfig                           |    2 +-
 drivers/scsi/ufs/ufshcd-pci.c                      |    1 -
 drivers/scsi/ufs/ufshcd-pltfrm.c                   |   76 +-
 drivers/scsi/ufs/ufshcd.c                          |  537 ++-
 drivers/scsi/ufs/ufshcd.h                          |   21 +-
 drivers/scsi/ufs/ufshci.h                          |    5 +-
 include/scsi/iscsi_if.h                            |    5 +
 include/scsi/libiscsi.h                            |    4 +
 include/scsi/libsas.h                              |    2 +-
 include/scsi/scsi.h                                |    5 +
 include/scsi/scsi_device.h                         |    1 +
 include/scsi/scsi_devinfo.h                        |    1 +
 113 files changed, 7532 insertions(+), 5175 deletions(-)
 create mode 100644 Documentation/devicetree/bindings/ufs/ufshcd-pltfrm.txt
 delete mode 100644 drivers/s390/scsi/zfcp_cfdc.c

James
