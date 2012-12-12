From: James Bottomley <James.Bottomley@HansenPartnership.com>
Subject: [GIT PULL] First round of SCSI updates for the 3.7+ merge window
Date: Wed, 12 Dec 2012 09:35:02 +0000
Message-ID: <1355304902.3270.32.camel@dabdike.int.hansenpartnership.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from bedivere.hansenpartnership.com ([66.63.167.143]:39495 "EHLO
	bedivere.hansenpartnership.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750989Ab2LLJfG (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Wed, 12 Dec 2012 04:35:06 -0500
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Andrew Morton <akpm@linux-foundation.org>, Linus Torvalds <torvalds@linux-foundation.org>
Cc: linux-scsi <linux-scsi@vger.kernel.org>, linux-kernel <linux-kernel@vger.kernel.org>

This patch set includes two large new drivers: mpt3sas (for the next gen
fusion SAS hardware) and csiostor a FCoE offload driver for the Chelsio
converged network cards (this includes some net changes which I've OK'd
with DaveM).

The rest of the patch is driver updates (qla2xxx, lpfc, hptiop,
be2iscsi) plus a few assorted updates and bug fixes.

We also have a Power Management rework in the Upper Layer Drivers
preparatory to doing ACPI zero power optical devices, but the actual
enabler is still being worked on.

Because of the need to keep the tree stable for next testing, anything
submitted after last Saturday (1 Dec)  will be in the next round.

The patch is available here:

git://git.kernel.org/pub/scm/linux/kernel/git/jejb/scsi.git scsi-misc

The short changelog is

Aaron Lu (5):
      sd: update sd to use the new pm callbacks
      scsi_pm: use callbacks from dev_pm_ops for scsi devices
      Revert "[SCSI] runtime resume parent for child's system-resume"
      Revert "[SCSI] scsi_pm: set device runtime state before parent suspended"
      sd: put to stopped power state when runtime suspend

Andrew Vasquez (2):
      qla2xxx: Use correct Request-Q-Out register during bidirectional request processing
      qla2xxx: Clear unsupported 'states' during Get-FW-State queries.

Armen Baloyan (2):
      qla2xxx: No fcport FC-4 type assignment in GA_NXT response.
      qla2xxx: Properly set result field of bsg_job reply structure for success and failure.

Boaz Harrosh (1):
      osd_uld: Add osdname & systemid sysfs at scsi_osd class

Chad Dupuis (3):
      qla2xxx: Update ql2xextended_error_logging parameter description with new option.
      qla2xxx: Move noisy Start scsi failed messages to verbose logging level.
      qla2xxx: Remove spurious taking of ha->vport_slock spinlock.

Dan Carpenter (1):
      csiostor: remove unneeded memset()

David Jeffery (1):
      qla2xxx: Test and clear FCPORT_UPDATE_NEEDED atomically.

Eddie Wai (1):
      bnx2i: removed the individual PCI DEVICE ID checking

Eric Northup (1):
      virtio_scsi: fix memory leak on full queue condition.

Giridhar Malavali (1):
      qla2xxx: Change in setting UNLOADING flag and FC vports logout sequence while unloading qla2xxx driver.

HighPoint Linux Team (1):
      hptiop: Support HighPoint RR4520/RR4522 HBA

James Smart (7):
      lpfc 8.3.36: Update lpfc version for 8.3.36 driver release
      lpfc 8.3.36: Correct mask error
      lpfc 8.3.36: Correct buffer length overrun
      lpfc 8.3.36: Fixed setting sequential delivery bit
      lpfc 8.3.36: Update DIF support for passthru/strip/insert
      lpfc 8.3.36: Fix bug with Target Resets and FCP2 devices
      lpfc 8.3.36: Fixed boot from san failure

Jason J. Herne (1):
      sd: Use SCSI read/write(16) with > 32-bit LBA drives

Joe Carnuccio (4):
      qla2xxx: Parameterize the link speed of hba rather than fcport.
      qla2xxx: Add 16Gb/s case to get port speed capability.
      qla2xxx: Move marking fcport online ahead of setting iiDMA speed.
      qla2xxx: Add acquiring of risc semaphore before doing ISP reset.

Joel D. Diaz (1):
      sd: Reshuffle init_sd to avoid crash

John Soni Jose (18):
      be2iscsi: Bump the driver version
      be2iscsi: Fix Unrecoverable Error Detection
      be2iscsi: Fix for MBX timeout issue
      be2iscsi: Update the copyright information
      be2iscsi: Fix issue of displaying adapter family.
      be2iscsi: Fix Task Completion Event handling
      be2iscsi: Fix session update context with V2 version.
      be2iscsi: Fix support for V2 version of WRB.
      be2iscsi: Fix support for handling CQ_CREATE V2 version.
      be2iscsi: Fix max EQ supported by the driver.
      be2iscsi: Fix driver support for Skyhawk-R adapter.
      be2iscsi: Fix return value and typo.
      be2iscsi: Fix kernel panic in blk_iopoll disable mode.
      be2iscsi: Issue an function level reset when driver is loaded
      be2iscsi: Display driver name and version in device attribute
      be2iscsi: Fix max supported EQ count to 8.
      be2iscsi: Fix memory leak in control path of driver
      be2iscsi: Display Completion Event string instead of Opcode

Mahesh Rajashekhara (1):
      aacraid: SCSI dma mapping failure case handling

Masanari Iida (1):
      qla2xxx: Fix typo in qla2xxx driver.

Minh Tran (1):
      be2iscsi: Fix the issue with soft reset.

Naresh Kumar Inna (3):
      csiostor: Fix sparse warnings.
      csiostor: Chelsio FCoE offload driver
      cxgb4/cxgb4vf: Chelsio FCoE offload driver submission (common header updates).

Sasha Levin (1):
      prevent stack buffer overflow in host_reset

Saurav Kashyap (9):
      qla2xxx: Display that driver is operating in legacy interrupt mode.
      qla2xxx: Dont clear drv active on iospace config failure.
      qla2xxx: Ignore driver ack bit if corresponding presence bit is not set.
      qla2xxx: Fix typo in qla83xx_fw_dump function.
      qla2xxx: Add Gen3 PCIe speed 8GT/s to the log message.
      qla2xxx: Fix coccinelle warnings in qla2x00_relogin.
      qla2xxx: Fix for warnings reported by sparse.
      qla2xxx: Honor status value of 2 for report-id acquisition.
      qla2xxx: Update the driver version to 8.04.00.08-k.

Sreekanth Reddy (3):
      mpt3sas: add new driver supporting 12GB SAS
      scsi_transport_sas: add 12GB definitions for mpt3sas
      miscdevice: Adding support for MPT3SAS_MINOR(222)

Steve Hodgson (1):
      qla2xxx: Free rsp_data even on error in qla2x00_process_loopback()

Xi Wang (1):
      mvsas: fix undefined bit shift

sreekanth.reddy@lsi.com (1):
      MAINTAINERS: update LSILOGIC MPT FUSION DRIVERS (FC/SAS/SPI) maintainers

And the diffstat:

 Documentation/scsi/hptiop.txt                   |   69 +-
 MAINTAINERS                                     |    5 +-
 drivers/net/ethernet/chelsio/cxgb4/cxgb4_main.c |   10 +-
 drivers/net/ethernet/chelsio/cxgb4/sge.c        |    6 +-
 drivers/net/ethernet/chelsio/cxgb4/t4_hw.c      |   20 +-
 drivers/net/ethernet/chelsio/cxgb4/t4_msg.h     |    1 +
 drivers/net/ethernet/chelsio/cxgb4/t4_regs.h    |   36 +-
 drivers/net/ethernet/chelsio/cxgb4/t4fw_api.h   |   41 +-
 drivers/net/ethernet/chelsio/cxgb4vf/sge.c      |    8 +-
 drivers/scsi/Kconfig                            |    2 +
 drivers/scsi/Makefile                           |    2 +
 drivers/scsi/aacraid/aachba.c                   |   87 +-
 drivers/scsi/aacraid/aacraid.h                  |    2 +-
 drivers/scsi/be2iscsi/be.h                      |    7 +-
 drivers/scsi/be2iscsi/be_cmds.c                 |  236 +-
 drivers/scsi/be2iscsi/be_cmds.h                 |   93 +-
 drivers/scsi/be2iscsi/be_iscsi.c                |  124 +-
 drivers/scsi/be2iscsi/be_iscsi.h                |    2 +-
 drivers/scsi/be2iscsi/be_main.c                 | 1059 ++-
 drivers/scsi/be2iscsi/be_main.h                 |  152 +-
 drivers/scsi/be2iscsi/be_mgmt.c                 |  424 +-
 drivers/scsi/be2iscsi/be_mgmt.h                 |   23 +-
 drivers/scsi/bnx2i/bnx2i.h                      |    2 +-
 drivers/scsi/bnx2i/bnx2i_init.c                 |   43 +-
 drivers/scsi/bnx2i/bnx2i_iscsi.c                |    2 +-
 drivers/scsi/csiostor/Kconfig                   |   19 +
 drivers/scsi/csiostor/Makefile                  |   11 +
 drivers/scsi/csiostor/csio_attr.c               |  796 +++
 drivers/scsi/csiostor/csio_defs.h               |  121 +
 drivers/scsi/csiostor/csio_hw.c                 | 4395 ++++++++++++
 drivers/scsi/csiostor/csio_hw.h                 |  665 ++
 drivers/scsi/csiostor/csio_init.c               | 1274 ++++
 drivers/scsi/csiostor/csio_init.h               |  158 +
 drivers/scsi/csiostor/csio_isr.c                |  624 ++
 drivers/scsi/csiostor/csio_lnode.c              | 2135 ++++++
 drivers/scsi/csiostor/csio_lnode.h              |  255 +
 drivers/scsi/csiostor/csio_mb.c                 | 1750 +++++
 drivers/scsi/csiostor/csio_mb.h                 |  278 +
 drivers/scsi/csiostor/csio_rnode.c              |  913 +++
 drivers/scsi/csiostor/csio_rnode.h              |  141 +
 drivers/scsi/csiostor/csio_scsi.c               | 2555 +++++++
 drivers/scsi/csiostor/csio_scsi.h               |  342 +
 drivers/scsi/csiostor/csio_wr.c                 | 1632 +++++
 drivers/scsi/csiostor/csio_wr.h                 |  512 ++
 drivers/scsi/csiostor/t4fw_api_stor.h           |  578 ++
 drivers/scsi/hptiop.c                           |  413 +-
 drivers/scsi/hptiop.h                           |   72 +-
 drivers/scsi/lpfc/lpfc.h                        |    2 +
 drivers/scsi/lpfc/lpfc_attr.c                   |   85 +
 drivers/scsi/lpfc/lpfc_crtn.h                   |    1 +
 drivers/scsi/lpfc/lpfc_ct.c                     |    2 +-
 drivers/scsi/lpfc/lpfc_els.c                    |    8 +-
 drivers/scsi/lpfc/lpfc_hw4.h                    |    3 +
 drivers/scsi/lpfc/lpfc_init.c                   |   57 +-
 drivers/scsi/lpfc/lpfc_scsi.c                   |   19 +-
 drivers/scsi/lpfc/lpfc_sli.c                    |   16 +-
 drivers/scsi/lpfc/lpfc_sli.h                    |    4 +-
 drivers/scsi/lpfc/lpfc_sli4.h                   |    3 +
 drivers/scsi/lpfc/lpfc_version.h                |    2 +-
 drivers/scsi/mpt3sas/Kconfig                    |   67 +
 drivers/scsi/mpt3sas/Makefile                   |    8 +
 drivers/scsi/mpt3sas/mpi/mpi2.h                 | 1164 ++++
 drivers/scsi/mpt3sas/mpi/mpi2_cnfg.h            | 3323 +++++++++
 drivers/scsi/mpt3sas/mpi/mpi2_init.h            |  560 ++
 drivers/scsi/mpt3sas/mpi/mpi2_ioc.h             | 1665 +++++
 drivers/scsi/mpt3sas/mpi/mpi2_raid.h            |  346 +
 drivers/scsi/mpt3sas/mpi/mpi2_sas.h             |  295 +
 drivers/scsi/mpt3sas/mpi/mpi2_tool.h            |  437 ++
 drivers/scsi/mpt3sas/mpi/mpi2_type.h            |   56 +
 drivers/scsi/mpt3sas/mpt3sas_base.c             | 4840 ++++++++++++++
 drivers/scsi/mpt3sas/mpt3sas_base.h             | 1139 ++++
 drivers/scsi/mpt3sas/mpt3sas_config.c           | 1650 +++++
 drivers/scsi/mpt3sas/mpt3sas_ctl.c              | 3297 +++++++++
 drivers/scsi/mpt3sas/mpt3sas_ctl.h              |  418 ++
 drivers/scsi/mpt3sas/mpt3sas_debug.h            |  219 +
 drivers/scsi/mpt3sas/mpt3sas_scsih.c            | 8167 +++++++++++++++++++++++
 drivers/scsi/mpt3sas/mpt3sas_transport.c        | 2128 ++++++
 drivers/scsi/mpt3sas/mpt3sas_trigger_diag.c     |  434 ++
 drivers/scsi/mpt3sas/mpt3sas_trigger_diag.h     |  193 +
 drivers/scsi/mvsas/mv_94xx.h                    |   14 +-
 drivers/scsi/mvsas/mv_sas.h                     |    2 +-
 drivers/scsi/osd/osd_uld.c                      |   28 +
 drivers/scsi/qla2xxx/qla_attr.c                 |    3 +-
 drivers/scsi/qla2xxx/qla_bsg.c                  |   72 +-
 drivers/scsi/qla2xxx/qla_dbg.c                  |    8 +-
 drivers/scsi/qla2xxx/qla_def.h                  |    4 +-
 drivers/scsi/qla2xxx/qla_fw.h                   |   21 +
 drivers/scsi/qla2xxx/qla_gbl.h                  |    3 +-
 drivers/scsi/qla2xxx/qla_gs.c                   |    6 +
 drivers/scsi/qla2xxx/qla_init.c                 |  153 +-
 drivers/scsi/qla2xxx/qla_iocb.c                 |   15 +-
 drivers/scsi/qla2xxx/qla_isr.c                  |   42 +-
 drivers/scsi/qla2xxx/qla_mbx.c                  |    6 +-
 drivers/scsi/qla2xxx/qla_nx.c                   |   83 +-
 drivers/scsi/qla2xxx/qla_os.c                   |   57 +-
 drivers/scsi/qla2xxx/qla_target.c               |    2 +-
 drivers/scsi/qla2xxx/qla_version.h              |    2 +-
 drivers/scsi/scsi_pm.c                          |   98 +-
 drivers/scsi/scsi_sysfs.c                       |   11 +-
 drivers/scsi/scsi_transport_sas.c               |    1 +
 drivers/scsi/sd.c                               |   35 +-
 drivers/scsi/virtio_scsi.c                      |    2 +
 include/linux/miscdevice.h                      |    1 +
 include/scsi/scsi_device.h                      |    1 +
 include/scsi/scsi_transport_sas.h               |    1 +
 105 files changed, 52361 insertions(+), 1013 deletions(-)
 create mode 100644 drivers/scsi/csiostor/Kconfig
 create mode 100644 drivers/scsi/csiostor/Makefile
 create mode 100644 drivers/scsi/csiostor/csio_attr.c
 create mode 100644 drivers/scsi/csiostor/csio_defs.h
 create mode 100644 drivers/scsi/csiostor/csio_hw.c
 create mode 100644 drivers/scsi/csiostor/csio_hw.h
 create mode 100644 drivers/scsi/csiostor/csio_init.c
 create mode 100644 drivers/scsi/csiostor/csio_init.h
 create mode 100644 drivers/scsi/csiostor/csio_isr.c
 create mode 100644 drivers/scsi/csiostor/csio_lnode.c
 create mode 100644 drivers/scsi/csiostor/csio_lnode.h
 create mode 100644 drivers/scsi/csiostor/csio_mb.c
 create mode 100644 drivers/scsi/csiostor/csio_mb.h
 create mode 100644 drivers/scsi/csiostor/csio_rnode.c
 create mode 100644 drivers/scsi/csiostor/csio_rnode.h
 create mode 100644 drivers/scsi/csiostor/csio_scsi.c
 create mode 100644 drivers/scsi/csiostor/csio_scsi.h
 create mode 100644 drivers/scsi/csiostor/csio_wr.c
 create mode 100644 drivers/scsi/csiostor/csio_wr.h
 create mode 100644 drivers/scsi/csiostor/t4fw_api_stor.h
 create mode 100644 drivers/scsi/mpt3sas/Kconfig
 create mode 100644 drivers/scsi/mpt3sas/Makefile
 create mode 100644 drivers/scsi/mpt3sas/mpi/mpi2.h
 create mode 100644 drivers/scsi/mpt3sas/mpi/mpi2_cnfg.h
 create mode 100644 drivers/scsi/mpt3sas/mpi/mpi2_init.h
 create mode 100644 drivers/scsi/mpt3sas/mpi/mpi2_ioc.h
 create mode 100644 drivers/scsi/mpt3sas/mpi/mpi2_raid.h
 create mode 100644 drivers/scsi/mpt3sas/mpi/mpi2_sas.h
 create mode 100644 drivers/scsi/mpt3sas/mpi/mpi2_tool.h
 create mode 100644 drivers/scsi/mpt3sas/mpi/mpi2_type.h
 create mode 100644 drivers/scsi/mpt3sas/mpt3sas_base.c
 create mode 100644 drivers/scsi/mpt3sas/mpt3sas_base.h
 create mode 100644 drivers/scsi/mpt3sas/mpt3sas_config.c
 create mode 100644 drivers/scsi/mpt3sas/mpt3sas_ctl.c
 create mode 100644 drivers/scsi/mpt3sas/mpt3sas_ctl.h
 create mode 100644 drivers/scsi/mpt3sas/mpt3sas_debug.h
 create mode 100644 drivers/scsi/mpt3sas/mpt3sas_scsih.c
 create mode 100644 drivers/scsi/mpt3sas/mpt3sas_transport.c
 create mode 100644 drivers/scsi/mpt3sas/mpt3sas_trigger_diag.c
 create mode 100644 drivers/scsi/mpt3sas/mpt3sas_trigger_diag.h

James


