From: James Bottomley <James.Bottomley@HansenPartnership.com>
Subject: [GIT PULL] Final round of SCSI updates for 2.6.39 merge window
Date: Fri, 27 May 2011 18:14:04 -0500
Message-ID: <1306538045.12244.16.camel@mulgrave.site>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner@vger.kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
To: Andrew Morton <akpm@linux-foundation.org>, Linus Torvalds <torvalds@linux-foundation.org>
Cc: linux-scsi <linux-scsi@vger.kernel.org>, linux-kernel <linux-kernel@vger.kernel.org>
List-Id: linux-scsi@vger.kernel.org

This contains further driver updates (lpfc, mpt2sas, megaraid_sas, bnx2i
and fcoe) plus an assortment of bug fixes

The patch is available here:

master.kernel.org:/pub/scm/linux/kernel/git/jejb/scsi-misc-2.6.git

The short changelog is:

Adam Radford (8):
      megaraid_sas: Version and Changelog update
      megaraid_sas: Add 1078 OCR support
      megaraid_sas: Convert 6,10,12 byte CDB's for FastPath IO
      megaraid_sas: Fix bug where AENs could be lost in probe() and resume()
      megaraid_sas: Disable interrupts/free_irq() in megasas_shutdown()
      megaraid_sas: Check MFI_REG_STATE.fault.resetAdapter
      megaraid_sas: Remove un-used function
      megaraid_sas: Remove MSI-X black list, use MFI_REG_STATE instead

Andrew Morton (1):
      osst: fix warning

Bhanu Prakash Gollapudi (1):
      libfcoe: Incorrect CVL handling for NPIV ports

Dan Williams (2):
      libsas: check dev->gone before submitting sata i/o
      libsas: fix/amend device gone notification in sas_deform_port()

Dave Jiang (1):
      libsas: Add option for SATA soft reset

David Jeffery (1):
      Reduce error recovery time by reducing use of TURs

Eddie Wai (3):
      bnx2i: Optimized the iSCSI offload performance
      bnx2i: Updated the connection shutdown/cleanup timeout
      bnx2i: Fixed packet error created when the sq_size is set to 16

Harish Zunjarrao (1):
      qla4xxx: Added vendor specific sysfs attributes

Hillf Danton (1):
      libfc: fix mm leak in handling incoming request for target discovery

James Bottomley (1):
      MAINTAINERS update for SCSI (new email address)

James Smart (6):
      lpfc 8.3.24: Extend BSG infrastructure and add link diagnostics
      lpfc 8.3.24: Add resource extent support
      lpfc 8.3.24: Add request-firmware support
      lpfc 8.3.24: Add SR-IOV control
      lpfc 8.3.24: Extended hardware support and support dump images
      lpfc 8.3.24: Miscellaneous Fixes and Corrections

Jing Huang (1):
      bfa: kdump fix

Kashyap, Desai (2):
      mpt2sas: Driver version upgrade 08.100.00.02
      mpt2sas: move even handling of MPT2SAS_TURN_ON_FAULT_LED into process context

Lalit Chandivade (1):
      qla4xxx: Remove AF_DPC_SCHEDULED flag from ha.

Luben Tuikov (1):
      Retrieve the Caching mode page (version 2)

Martin K. Petersen (3):
      scsi_trace: Decode UNMAP bit in WRITE SAME(10)
      mpt2sas: Fix missing reference tag seed with Type 2 devices
      sd: Unmap discard alignment needs to be converted to bytes

Neerav Parikh (1):
      fcoe: Prevent creation of an NPIV port with duplicate WWPN

Nicholas Bellinger (7):
      MAINTAINERS: Add drivers/target/ entry
      target: Convert TASK_ATTR to scsi_tcq.h definitions
      target: Convert REPORT_LUNs to use int_to_scsilun
      target: Fix task->task_execute_queue=1 clear bug + LUN_RESET OOPs
      target: Fix bug with task_sg chained transport_free_dev_tasks release
      target: Fix interrupt context bug with stats_lock and core_tmr_alloc_req
      target: Fix multi task->task_sg[] chaining logic bug

Prasanna Mumbai (2):
      qla4xxx: Complete the cmd if sense_len is zero
      qla4xxx: update function qla4xxx_isr_decode_mailbox()

Robert Love (1):
      libfcoe: Remove unnecessary module state checks

Roel Kluin (1):
      osst: wrong index used in inner loop

Samuel Thibault (1):
      Fix Ultrastor asm snippet

Vasiliy Kulikov (1):
      aic94xx: world-writable sysfs update_bios file

Vasu Dev (2):
      libfc: fix race in SRR response
      libfc: don't call resp handler after FC_EX_TIMEOUT

Vikas Chaudhary (6):
      qla4xxx: Update driver version to 5.02.00-k7
      qla4xxx: Remove host_lock in queuecommand function
      qla4xxx: Don't check FW alive if ISP82XX reset is in progress
      qla4xxx: Don't process mbx interrupt unconditionally
      qla4xxx: Dump HW/FW reg to figure out what caused FW to be hung for ISP82XX
      qla4xxx: Updated the reset sequence for ISP82xx

Wayne Boyer (1):
      ipr: fix possible false positive detection of stuck interrupt

Xiangliang Yu (1):
      libsas: fix SATA NCQ error

Yi Zou (2):
      libfc: do not immediately retry the cmd when seq_send fails in fc_fcp_send_data
      libfc: release DDP context if frame_send() fails


and the diffstat

 Documentation/scsi/ChangeLog.megaraid_sas   |   14 +
 MAINTAINERS                                 |   13 +-
 drivers/scsi/aic94xx/aic94xx_init.c         |    2 +-
 drivers/scsi/bfa/bfa_ioc.c                  |    4 +-
 drivers/scsi/bfa/bfa_ioc.h                  |    1 +
 drivers/scsi/bfa/bfa_ioc_cb.c               |   11 +
 drivers/scsi/bfa/bfa_ioc_ct.c               |   26 +
 drivers/scsi/bnx2i/bnx2i.h                  |   16 +-
 drivers/scsi/bnx2i/bnx2i_hwi.c              |   27 +-
 drivers/scsi/bnx2i/bnx2i_init.c             |    2 +-
 drivers/scsi/bnx2i/bnx2i_iscsi.c            |   13 +-
 drivers/scsi/fcoe/fcoe.c                    |   58 +
 drivers/scsi/fcoe/fcoe.h                    |   10 +
 drivers/scsi/fcoe/fcoe_ctlr.c               |  133 +-
 drivers/scsi/fcoe/fcoe_transport.c          |   40 -
 drivers/scsi/ipr.c                          |   12 +-
 drivers/scsi/libfc/fc_disc.c                |    1 +
 drivers/scsi/libfc/fc_exch.c                |    2 +
 drivers/scsi/libfc/fc_fcp.c                 |   16 +-
 drivers/scsi/libfc/fc_libfc.h               |    1 +
 drivers/scsi/libsas/sas_ata.c               |   60 +-
 drivers/scsi/libsas/sas_internal.h          |    2 +-
 drivers/scsi/libsas/sas_phy.c               |    4 +-
 drivers/scsi/libsas/sas_port.c              |   21 +-
 drivers/scsi/libsas/sas_scsi_host.c         |   14 +-
 drivers/scsi/lpfc/lpfc.h                    |   43 +-
 drivers/scsi/lpfc/lpfc_attr.c               |  312 +++-
 drivers/scsi/lpfc/lpfc_bsg.c                | 3605 ++++++++++++++++++---------
 drivers/scsi/lpfc/lpfc_bsg.h                |   87 +-
 drivers/scsi/lpfc/lpfc_crtn.h               |   10 +
 drivers/scsi/lpfc/lpfc_ct.c                 |    2 +
 drivers/scsi/lpfc/lpfc_debugfs.c            |   10 +-
 drivers/scsi/lpfc/lpfc_els.c                |   28 +-
 drivers/scsi/lpfc/lpfc_hbadisc.c            |   54 +-
 drivers/scsi/lpfc/lpfc_hw.h                 |    8 +-
 drivers/scsi/lpfc/lpfc_hw4.h                |  501 ++++-
 drivers/scsi/lpfc/lpfc_init.c               |  545 ++++-
 drivers/scsi/lpfc/lpfc_mbox.c               |  166 +-
 drivers/scsi/lpfc/lpfc_mem.c                |   13 -
 drivers/scsi/lpfc/lpfc_nportdisc.c          |   28 +-
 drivers/scsi/lpfc/lpfc_scsi.c               |   56 +-
 drivers/scsi/lpfc/lpfc_sli.c                | 1921 +++++++++++++--
 drivers/scsi/lpfc/lpfc_sli.h                |    1 +
 drivers/scsi/lpfc/lpfc_sli4.h               |   33 +-
 drivers/scsi/lpfc/lpfc_vport.c              |    2 +-
 drivers/scsi/megaraid/megaraid_sas.h        |   10 +-
 drivers/scsi/megaraid/megaraid_sas_base.c   |   93 +-
 drivers/scsi/megaraid/megaraid_sas_fusion.c |   83 +-
 drivers/scsi/mpt2sas/mpt2sas_base.h         |    4 +-
 drivers/scsi/mpt2sas/mpt2sas_scsih.c        |  102 +-
 drivers/scsi/osst.c                         |    6 +-
 drivers/scsi/qla4xxx/Makefile               |    2 +-
 drivers/scsi/qla4xxx/ql4_attr.c             |   69 +
 drivers/scsi/qla4xxx/ql4_def.h              |   11 +-
 drivers/scsi/qla4xxx/ql4_fw.h               |   23 +
 drivers/scsi/qla4xxx/ql4_glbl.h             |    3 +-
 drivers/scsi/qla4xxx/ql4_init.c             |    2 +-
 drivers/scsi/qla4xxx/ql4_isr.c              |   22 +-
 drivers/scsi/qla4xxx/ql4_mbx.c              |   77 +-
 drivers/scsi/qla4xxx/ql4_nx.c               |   19 +-
 drivers/scsi/qla4xxx/ql4_os.c               |   68 +-
 drivers/scsi/qla4xxx/ql4_version.h          |    2 +-
 drivers/scsi/scsi_error.c                   |   87 +-
 drivers/scsi/scsi_trace.c                   |    4 +
 drivers/scsi/sd.c                           |   82 +-
 drivers/scsi/ultrastor.c                    |    2 +-
 drivers/target/loopback/tcm_loop.c          |   25 +-
 drivers/target/target_core_configfs.c       |    4 -
 drivers/target/target_core_device.c         |   29 +-
 drivers/target/target_core_pscsi.c          |    4 +-
 drivers/target/target_core_tmr.c            |    7 +-
 drivers/target/target_core_transport.c      |   68 +-
 drivers/target/tcm_fc/tfc_cmd.c             |   20 +-
 drivers/target/tcm_fc/tfc_conf.c            |    8 -
 include/scsi/libsas.h                       |    1 +
 include/scsi/scsi_tcq.h                     |    1 +
 include/target/target_core_base.h           |    1 +
 include/target/target_core_fabric_ops.h     |    1 -
 include/target/target_core_transport.h      |    1 +
 79 files changed, 6766 insertions(+), 2103 deletions(-)
 create mode 100644 drivers/scsi/qla4xxx/ql4_attr.c

James
