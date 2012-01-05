From: James Bottomley <James.Bottomley@HansenPartnership.com>
Subject: [GIT PULL] Next round of SCSI updates for 3.2 merge window
Date: Thu, 05 Jan 2012 14:19:04 -0800
Message-ID: <1325801944.2775.32.camel@dabdike.Larkspurhotels.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner@vger.kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
To: Andrew Morton <akpm@linux-foundation.org>, Linus Torvalds <torvalds@linux-foundation.org>
Cc: linux-scsi <linux-scsi@vger.kernel.org>, linux-kernel <linux-kernel@vger.kernel.org>
List-Id: linux-scsi@vger.kernel.org

Trying the signed tag approach for the first time

This patch contains the first tranche of SCSI updates including qla2xxx,
qla4xxx, mpt2sas, lpfc and device_handler

Before people start complaining, I have a lot of queued patches I didn't
get around to merging before the Christmas holidays, so I'll do that
now.

The patch is available here:

master.kernel.org:/pub/scm/linux/kernel/git/jejb/scsi-misc-2.6.git#scsi-misc

The short changelog is

Andrew Vasquez (3):
      qla2xxx: Ensure there's enough request-queue space for passthru IOCBs.
      qla2xxx: Limit excessive DPC cycles.
      qla2xxx: Only read requested mailbox registers.

Chad Dupuis (3):
      qla2xxx: Do not check for minidump when device state is QLA82XX_DEV_READY.
      qla2xxx: Move initialization of some variables before iospace_config.
      qla2xxx: Update to dynamic logging.

Chandrakala Chavva (1):
      mptsas: Add device ID for SAS1068_820XELP.

Dan Carpenter (1):
      be2iscsi: cleanup a min_t() call

Eddie Wai (1):
      bnx2i: Fixed kernel panic caused by unprotected task->sc->request deref

Ferenc Wagner (1):
      fusion: ensure NUL-termination of MptCallbacksName elements

Geert Uytterhoeven (1):
      mac_scsi: Remove obsolete IRQ_FLG_* users

Giridhar Malavali (8):
      qla2xxx: Consolidated IOCB processing routines.
      qla2xxx: Process marker IOCB request on request queue 0.
      qla2xxx: Added a new entry to ISP specific function pointers structure.
      qla2xxx: Corrected the display of firmware dump availability for ISP82xx.
      qla2xxx: Corrected the default setting of the help text of Minidump capture mask.
      qla2xxx: Correct report-id acquisition check
      qla2xxx: Fix to include FCE data as part of dump.
      qla2xxx: Proper cleanup of pass through commands when firmware returns error.

James Smart (7):
      lpfc 8.3.28: Update driver version to 8.3.28
      lpfc 8.3.28: Add Loopback support for SLI4 adapters
      lpfc 8.3.28: Critical Miscellaneous fixes
      Lpfc 8.3.28: FC and SCSI Discovery Fixes
      lpfc 8.3.28: Add support for ABTS failure handling
      lpfc 8.3.28: SLI fixes and added SLI4 support
      lpfc 8.3.28: Miscellaneous fixes in sysfs and mgmt interfaces

Jesper Juhl (1):
      qla2xxx: remove redundant semicolon

Jing Huang (2):
      bfa: fix endian and bit field check bug
      bfa: fix formating and checkpatch issues

Joe Carnuccio (1):
      qla2xxx: Corrections to returned sysfs error codes.

Joe Perches (2):
      qla2xxx: Make the logging functions verify their arguments and fixed the current broken uses as appropriate.
      qla2xxx: Use less stack to emit logging messages.

Mike Christie (1):
      iscsi class: export pid of process that created

Mike Hernandez (1):
      qla4xxx: Fix CPU lockups when ql4xdontresethba set

Moger, Babu (4):
      scsi_dh: code cleanup and remove the references to scsi_dev_info
      scsi_dh_rdac: Adding the match function for rdac device handler
      scsi_dh_hp_sw: Adding the match function for hp_sw device handler
      scsi_dh_emc: Add a match function for emc device handler

Nilesh Javali (1):
      qla4xxx: Fix the IDC locking mechanism

Roland Dreier (3):
      mpt2sas: Remove unused duplicate diag_buffer_enable param
      mpt2sas: Fix possible integer truncation of cpu_count
      mpt2sas: Fix leak on mpt2sas_base_attach() error path

Sarang Radke (2):
      qla4xxx: Don't recover adapter if device state is FAILED
      qla4xxx: fix call trace on rmmod with ql4xdontresethba=1

Saurav Kashyap (1):
      qla2xxx: Implement FCP priority tagging for 82xx adapters.

Shyam Sunder (1):
      qla4xxx: check for FW alive before calling chip_reset

Stephen M. Cameron (1):
      hpsa: Add IRQF_SHARED back in for the non-MSI(X) interrupt handler

Tomas Henzl (1):
      hpsa: add the Smart Array 5i to the kdump blacklist

Vikas Chaudhary (4):
      qla4xxx: Update driver version to 5.02.00-k10
      qla4xxx: Fix qla4xxx_dump_buffer to dump buffer correctly
      qla4xxx: Wait for disable_acb before doing set_acb
      qla4xxx: Perform context resets in case of context failures.

nagalakshmi.nandigama@lsi.com (16):
      mpt2sas: Removed redundant calling of _scsih_probe_devices() from _scsih_probe
      mpt2sas : Bump driver vesion to 12.100.00.00
      mpt2sas : Fix for memory allocation error for large host credits
      mpt2sas: Do not retry a timed out direct IO for warpdrive
      mpt2sas: Release spinlock for the raid device list before blocking it
      mpt2sas: MPI next revision header update
      mpt2sas: Added support for customer specific branding
      mpt2sas: Increase max transfer support from 4MB to 16MB
      mpt2sas: Support for greater than 2TB capacity WarpDrive
      mpt2sas: Bump driver version to 11.100.00.00
      mpt2sas: Rearrange the the code so that the completion queues are initialized prior to sending the request to controller firmware
      mpt2sas: Do not set sas_device->starget to NULL from the slave_destroy callback when all the LUNS have been deleted
      mpt2sas: MPI next revision header update
      mpt2sas: Adding support for customer specific branding
      mpt2sas: When IOs are terminated, update the result to DID_SOFT_ERROR to avoid infinite resets
      mpt2sas: Better handling DEAD IOC (PCI-E LInk down) error condition

And the diffstat:

 drivers/message/fusion/lsi/mpi_cnfg.h       |    1 +
 drivers/message/fusion/mptbase.c            |    7 +-
 drivers/message/fusion/mptbase.h            |    1 +
 drivers/message/fusion/mptsas.c             |    2 +
 drivers/scsi/be2iscsi/be_main.c             |    5 +-
 drivers/scsi/bfa/bfa_defs.h                 |    4 +-
 drivers/scsi/bfa/bfa_defs_svc.h             |  437 +++++++++--------
 drivers/scsi/bfa/bfa_ioc.c                  |    6 +-
 drivers/scsi/bfa/bfad_debugfs.c             |    3 +-
 drivers/scsi/bnx2i/bnx2i_hwi.c              |    5 +-
 drivers/scsi/device_handler/scsi_dh.c       |   58 ---
 drivers/scsi/device_handler/scsi_dh_emc.c   |   19 +
 drivers/scsi/device_handler/scsi_dh_hp_sw.c |   19 +
 drivers/scsi/device_handler/scsi_dh_rdac.c  |   19 +
 drivers/scsi/hpsa.c                         |    6 +-
 drivers/scsi/lpfc/lpfc.h                    |   14 -
 drivers/scsi/lpfc/lpfc_attr.c               |  436 ++++++-----------
 drivers/scsi/lpfc/lpfc_bsg.c                |  432 +++++++++++++----
 drivers/scsi/lpfc/lpfc_bsg.h                |    3 +-
 drivers/scsi/lpfc/lpfc_compat.h             |    5 +-
 drivers/scsi/lpfc/lpfc_crtn.h               |   13 +-
 drivers/scsi/lpfc/lpfc_debugfs.c            |  172 +++++---
 drivers/scsi/lpfc/lpfc_els.c                |  214 +++++----
 drivers/scsi/lpfc/lpfc_hbadisc.c            |  157 +++++--
 drivers/scsi/lpfc/lpfc_hw.h                 |   21 +-
 drivers/scsi/lpfc/lpfc_hw4.h                |   11 +-
 drivers/scsi/lpfc/lpfc_init.c               |  338 +++++++++-----
 drivers/scsi/lpfc/lpfc_mbox.c               |   25 +-
 drivers/scsi/lpfc/lpfc_mem.c                |    4 +-
 drivers/scsi/lpfc/lpfc_nportdisc.c          |   10 +-
 drivers/scsi/lpfc/lpfc_scsi.c               |   17 +-
 drivers/scsi/lpfc/lpfc_scsi.h               |    5 +-
 drivers/scsi/lpfc/lpfc_sli.c                |  704 +++++++++++++++++++--------
 drivers/scsi/lpfc/lpfc_sli4.h               |   11 +-
 drivers/scsi/lpfc/lpfc_version.h            |    2 +-
 drivers/scsi/lpfc/lpfc_vport.c              |    6 +-
 drivers/scsi/mac_scsi.c                     |    3 +-
 drivers/scsi/mpt2sas/mpi/mpi2.h             |   10 +-
 drivers/scsi/mpt2sas/mpi/mpi2_cnfg.h        |   28 +-
 drivers/scsi/mpt2sas/mpi/mpi2_ioc.h         |   49 ++-
 drivers/scsi/mpt2sas/mpi/mpi2_raid.h        |   67 +++-
 drivers/scsi/mpt2sas/mpi/mpi2_tool.h        |    9 +-
 drivers/scsi/mpt2sas/mpt2sas_base.c         |  205 +++++----
 drivers/scsi/mpt2sas/mpt2sas_base.h         |   26 +-
 drivers/scsi/mpt2sas/mpt2sas_ctl.c          |    8 +-
 drivers/scsi/mpt2sas/mpt2sas_scsih.c        |  168 ++++---
 drivers/scsi/mpt2sas/mpt2sas_transport.c    |    9 +-
 drivers/scsi/qla2xxx/qla_attr.c             |   10 +-
 drivers/scsi/qla2xxx/qla_bsg.c              |   20 +-
 drivers/scsi/qla2xxx/qla_dbg.c              |  310 ++++++------
 drivers/scsi/qla2xxx/qla_dbg.h              |   19 +-
 drivers/scsi/qla2xxx/qla_def.h              |    6 +-
 drivers/scsi/qla2xxx/qla_gbl.h              |    2 +-
 drivers/scsi/qla2xxx/qla_gs.c               |    2 +-
 drivers/scsi/qla2xxx/qla_init.c             |   95 ++--
 drivers/scsi/qla2xxx/qla_iocb.c             |  641 ++++++++++++++++++++----
 drivers/scsi/qla2xxx/qla_isr.c              |  253 ++++++----
 drivers/scsi/qla2xxx/qla_mbx.c              |    2 +-
 drivers/scsi/qla2xxx/qla_nx.c               |  512 +-------------------
 drivers/scsi/qla2xxx/qla_os.c               |  363 +++++++-------
 drivers/scsi/qla2xxx/qla_sup.c              |    5 +-
 drivers/scsi/qla4xxx/ql4_dbg.c              |    6 +-
 drivers/scsi/qla4xxx/ql4_def.h              |    1 +
 drivers/scsi/qla4xxx/ql4_isr.c              |   30 +-
 drivers/scsi/qla4xxx/ql4_nx.c               |   23 +-
 drivers/scsi/qla4xxx/ql4_os.c               |  127 ++++-
 drivers/scsi/qla4xxx/ql4_version.h          |    2 +-
 drivers/scsi/scsi_priv.h                    |    1 -
 drivers/scsi/scsi_transport_iscsi.c         |   21 +-
 include/scsi/scsi_device.h                  |    1 -
 include/scsi/scsi_transport_iscsi.h         |    5 +
 71 files changed, 3627 insertions(+), 2604 deletions(-)

James
