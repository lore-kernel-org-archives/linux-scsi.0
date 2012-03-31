From: James Bottomley <James.Bottomley@HansenPartnership.com>
Subject: [GIT PULL] Final round of SCSI updates for the 3.3+ merge window
Date: Sat, 31 Mar 2012 08:29:30 +0100
Message-ID: <1333178970.2994.14.camel@dabdike.sthat4.btopenzone.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner@vger.kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
To: Andrew Morton <akpm@linux-foundation.org>, Linus Torvalds <torvalds@linux-foundation.org>
Cc: linux-scsi <linux-scsi@vger.kernel.org>, linux-kernel <linux-kernel@vger.kernel.org>
List-Id: linux-scsi@vger.kernel.org

This is primarily another round of driver updates (lpfc, bfa, fcoe, ipr)
plus a new ufshcd driver.  There shouldn't be anything controversial in
here (The final deletion of scsi proc_ops which caused some build
breakage has been held over until the next merge window to give us more
time to stabilise it).

I'm afraid, with me moving continents at exactly the wrong time,
anything submitted after the merge window opened has been held over to
the next merge window.

The patch is available here:

git://git.kernel.org/pub/scm/linux/kernel/git/jejb/scsi-misc-2.6.git scsi-misc

The short changelog is

Arvind Kumar (1):
      vmw_pvscsi: Try setting host->max_id as suggested by the device.

Bhanu Prakash Gollapudi (2):
      libfcoe: Support extra MAC descriptor to be used as FCoE MAC
      libfcoe: Do not sends FDISCs before FLOGI during CVL

Brian King (6):
      ipr: Driver version 2.5.3
      ipr: Increase alignment boundary of command blocks
      ipr: Increase max concurrent oustanding commands
      ipr: Remove unnecessary memory barriers
      ipr: Remove unnecessary interrupt clearing on new adapters
      ipr: Fix target id allocation re-use problem

Eric Sandeen (1):
      scsi_debug: add LBPRZ support

James Smart (21):
      lpfc 8.3.30: Update lpfc to version 8.3.30
      lpfc 8.3.30: Revert fix for Link Pull Causes I/O Failures
      lpfc 8.3.30: Added more T10 DIF debugfs error injection
      lpfc 8.3.30: Update copyright date for files modified in 2012
      lpfc 8.3.30: Fix handling of REG_VFI and cable pull.
      lpfc 8.3.30: Enhancements for T10 DIF debugfs error injection
      lpfc 8.3.30: Change default DA_ID support from disabled to enabled
      lpfc 8.3.30: Flush reset register write
      lpfc 8.3.30: Update copyright date for files modified in 2012
      lpfc 8.3.30: Fixed panic with extents and small blocks
      lpfc 8.3.30: Add -Werror compilation flag
      lpfc 8.3.30: Fixed the system panic during EEH recovery
      lpfc 8.3.30: Fix resource leak when acc fails for received plogi
      lpfc 8.3.30: Fix SLI4 driver module load and unload
      lpfc 8.3.30: Fixed missing CVL event causing FCF failover
      lpfc 8.3.30: Fix deadlock during adapter offline request
      lpfc 8.3.30: Fix RPI registered multiple times after HBA reset
      lpfc 8.3.30: Fix driver handling of XRI Aborted CQE response
      lpfc 8.3.30: Fix port and system failure in SLI4 FC function reset
      lpfc 8.3.30: Fix lack of LOGO with vport delete.
      lpfc 8.3.30: Make BA_ACC work on a fully qualified exchange

Krishna Gudipati (9):
      bfa: Update the driver version to 3.0.23.0
      bfa: BSG and User interface fixes.
      bfa: Fix to avoid vport delete hang on request queue full scenario.
      bfa: Move service parameter programming logic into firmware.
      bfa: Revised Fabric Assigned Address(FAA) feature implementation.
      bfa: Flash controller IOC pll init fixes.
      bfa: Serialize the IOC hw semaphore unlock logic.
      bfa: Modify ISR to process pending completions
      bfa: Add fc host issue lip support

Lan Tianyu (1):
      sd: Add runtime pm in the sd_check_events()

Lee Duncan (1):
      st: expand ability to write immediate filemarks

Martin K. Petersen (1):
      scsi_debug: Fix incorrect page length in logical block provisioning VPD

Mike Christie (1):
      iscsi class: fix gfp use in ping compl and host event

Neil Horman (5):
      fcoe: reduce contention for fcoe_rx_list lock [v2]
      fcoe: remove frame dropping code from fcoe_percpu_clean
      bnx2fc: Remove bh disable in softirq context
      foce: remove bh disable from fcoe sw transport rcv function
      fcoe: Ensure fcoe_recv_frame is always called in process context

Petr Uzel (2):
      sd: make comment and printk string match code
      qla4xxx: Add missing spaces to error messages

Robert Love (1):
      fcoe: Drop the rtnl_mutex before calling fcoe_ctlr_link_up

Santosh Nayak (2):
      pm8001: Use spin_lock_irqsave() for task_state.
      bfa: Fix endian bug in bfad_iocmd_debug_fw_core().

Santosh Yaraganavi (1):
      ufshcd: UFS Host controller driver

Sathisha Nanjappa (1):
      mpt2sas: remove extraneous sas_log_info messages

Sergei Shtylyov (1):
      atp870u, mpt2sas, qla4xxx use pci_dev->revision

Steven Clark (1):
      libfc: fcoe_transport_create fails in single-CPU environment

Vasu Dev (1):
      libfc: update fc_host mfs along with updating lport->mfs

Vikas Chaudhary (4):
      qla4xxx: Update driver version to 5.02.00-k16
      qla4xxx: Removed packed attr from struct iscsi_chap_rec
      iscsi_transport: Added error status code for ping comp event
      qla4xxx: assign correct address for iscsi_cls_host

and the diffstat:

 Documentation/scsi/00-INDEX         |    2 +
 Documentation/scsi/st.txt           |    4 +
 Documentation/scsi/ufs.txt          |  133 +++
 drivers/scsi/Kconfig                |    1 +
 drivers/scsi/Makefile               |    1 +
 drivers/scsi/atp870u.c              |    4 +-
 drivers/scsi/bfa/bfa.h              |    9 +-
 drivers/scsi/bfa/bfa_core.c         |  693 ++++++++----
 drivers/scsi/bfa/bfa_defs_svc.h     |    2 +-
 drivers/scsi/bfa/bfa_fcs_lport.c    |    2 +
 drivers/scsi/bfa/bfa_fcs_rport.c    |    5 +-
 drivers/scsi/bfa/bfa_ioc.c          |  188 ++--
 drivers/scsi/bfa/bfa_ioc.h          |   17 +-
 drivers/scsi/bfa/bfa_ioc_ct.c       |  151 ++-
 drivers/scsi/bfa/bfa_svc.c          |   69 +-
 drivers/scsi/bfa/bfa_svc.h          |    4 -
 drivers/scsi/bfa/bfad_attr.c        |   47 +-
 drivers/scsi/bfa/bfad_bsg.c         |   62 +-
 drivers/scsi/bfa/bfad_bsg.h         |    2 -
 drivers/scsi/bfa/bfad_drv.h         |    2 +-
 drivers/scsi/bfa/bfi_ms.h           |   17 +-
 drivers/scsi/bfa/bfi_reg.h          |    6 +
 drivers/scsi/bnx2fc/bnx2fc_fcoe.c   |    4 +-
 drivers/scsi/fcoe/fcoe.c            |   83 +-
 drivers/scsi/fcoe/fcoe_ctlr.c       |   38 +-
 drivers/scsi/ipr.c                  |   73 +-
 drivers/scsi/ipr.h                  |   16 +-
 drivers/scsi/libfc/fc_exch.c        |   14 +-
 drivers/scsi/libfc/fc_lport.c       |   10 +-
 drivers/scsi/lpfc/Makefile          |    4 +-
 drivers/scsi/lpfc/lpfc.h            |    8 +-
 drivers/scsi/lpfc/lpfc_attr.c       |    4 +-
 drivers/scsi/lpfc/lpfc_debugfs.c    |   80 +-
 drivers/scsi/lpfc/lpfc_els.c        |   17 +-
 drivers/scsi/lpfc/lpfc_hbadisc.c    |   24 +-
 drivers/scsi/lpfc/lpfc_hw4.h        |    8 +-
 drivers/scsi/lpfc/lpfc_init.c       |   41 +-
 drivers/scsi/lpfc/lpfc_nportdisc.c  |   10 +-
 drivers/scsi/lpfc/lpfc_scsi.c       |  488 +++++----
 drivers/scsi/lpfc/lpfc_scsi.h       |   13 +-
 drivers/scsi/lpfc/lpfc_sli.c        |   62 +-
 drivers/scsi/lpfc/lpfc_version.h    |    4 +-
 drivers/scsi/mpt2sas/mpt2sas_base.c |    6 +-
 drivers/scsi/mpt2sas/mpt2sas_ctl.c  |    4 +-
 drivers/scsi/pm8001/pm8001_hwi.c    |   18 +-
 drivers/scsi/qla4xxx/ql4_isr.c      |    4 +-
 drivers/scsi/qla4xxx/ql4_os.c       |   14 +-
 drivers/scsi/qla4xxx/ql4_version.h  |    2 +-
 drivers/scsi/scsi_debug.c           |   27 +-
 drivers/scsi/scsi_transport_iscsi.c |    8 +-
 drivers/scsi/sd.c                   |   15 +-
 drivers/scsi/st.c                   |   21 +-
 drivers/scsi/st.h                   |    1 +
 drivers/scsi/ufs/Kconfig            |   49 +
 drivers/scsi/ufs/Makefile           |    2 +
 drivers/scsi/ufs/ufs.h              |  207 ++++
 drivers/scsi/ufs/ufshcd.c           | 1978 +++++++++++++++++++++++++++++++++++
 drivers/scsi/ufs/ufshci.h           |  376 +++++++
 drivers/scsi/vmw_pvscsi.c           |   65 +-
 drivers/scsi/vmw_pvscsi.h           |  109 +-
 include/linux/mtio.h                |    1 +
 include/scsi/iscsi_if.h             |   19 +-
 include/scsi/libfcoe.h              |    4 +-
 63 files changed, 4409 insertions(+), 943 deletions(-)
 create mode 100644 Documentation/scsi/ufs.txt
 create mode 100644 drivers/scsi/ufs/Kconfig
 create mode 100644 drivers/scsi/ufs/Makefile
 create mode 100644 drivers/scsi/ufs/ufs.h
 create mode 100644 drivers/scsi/ufs/ufshcd.c
 create mode 100644 drivers/scsi/ufs/ufshci.h

James
