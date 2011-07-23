From: James Bottomley <James.Bottomley@HansenPartnership.com>
Subject: [GIT PULL] First round of SCSI updates for 2.6.39 merge window
Date: Sat, 23 Jul 2011 21:17:32 +0400
Message-ID: <1311441452.23720.17.camel@mulgrave>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner@vger.kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
To: Andrew Morton <akpm@linux-foundation.org>, Linus Torvalds <torvalds@linux-foundation.org>
Cc: linux-scsi <linux-scsi@vger.kernel.org>, linux-kernel <linux-kernel@vger.kernel.org>
List-Id: linux-scsi@vger.kernel.org

This represents the usual round of driver updates (fcoe, bfa, mpt2sas,
iscsi, bnx2fc) plus a couple of fixes that didn't make 3.0 including the
USB force eject oops.

The patch is available here:

master.kernel.org:/pub/scm/linux/kernel/git/jejb/scsi-misc-2.6.git

The short changelog is:

Abhijeet Joglekar (2):
      fnic: Update Maintainers list for fnic.
      fnic: fix incorrect use of SLAB_CACHE_DMA flag

Andy Grover (1):
      iscsi: Use struct scsi_lun in iscsi structs instead of u8[8]

Bhanu Prakash Gollapudi (5):
      MAINTAINERS update for bnx2fc
      bnx2fc: Bumped version to 1.0.2
      bnx2fc: Fix kernel panic when deleting NPIV ports
      bnx2fc: scsi_dma_unmap() not invoked on IO completions
      bnx2fc: host stats show the link speed 'unknown' on NIC partitioned interfaces

Douglas Gilbert (1):
      ses: requesting a fault indication

Eddie Wai (4):
      bnx2i: Fixed kernel panic due to illegal usage of sc->request->cpu
      bnx2i: Updated copyright and bump version
      bnx2i: Modified to skip CNIC registration if iSCSI is not supported
      bnx2i: Added the use of kthreads to handle SCSI cmd completion

Geert Uytterhoeven (10):
      sun3: Remove commented out merge_contiguous_buffers
      sun3: Add various missing NDEBUG* definitions
      sun3: Check for NCR_TIMEOUT being defined instead of having a value
      sun3: Provide a dummy NCR5380_exit()
      sun3: sun3scsi_detect() and NCR5380_init() should be __init
      mac_scsi: Remove unused variable default_instance
      mac_scsi: macscsi_detect() should be __init
      atari_NCR5380: Provide a dummy NCR5380_exit()
      atari_NCR5380: Remove obsolete variable oldto
      sun3_NCR5380: Split NEXT() for lvalues/rvalues

James Bottomley (1):
      fix crash in scsi_dispatch_cmd()

Karen Xie (1):
      cxgb3i: fixed programing of the dma page sizes

Kashyap, Desai (7):
      mpt2sas: Bump version 09.100.00.00
      mpt2sas: Adding support for customer specific branding
      mpt2sas: Added DID_NO_CONNECT return when driver remove and avoid shutdown call
      mpt2sas: fix broadcast AEN and task management issue
      mpt2sas: Set max_sector count from module parameter
      mpt2sas MPI next revision header update
      mpt2sas: Fixed Big Indian Issues on 32 bit PPC

Kay Sievers (1):
      sr: check_events() ignore GET_EVENT when TUR says otherwise

Kiran Patil (6):
      tcm_fc: Fixing reference counting problem which was causing ft_sess to be deleted.
      libfc:Fix for exchange/seq loopup failure when FCoE stack is used as target and connected to windows initaitor
      fcoe: Amends previous patch, Round-robin based selection of CPU for post processing of incoming request for FCoE target
      fcoe: Round-robin based selection of CPU for post-processing of incoming commands
      fcoe: Unable to select the exchangeID from offload pool for storage targets
      libfc: Enhancement to RPORT state machine applicable only for VN2VN mode

Krishna Gudipati (27):
      bfa: Update the driver version to 3.0.2.1
      bfa: Driver and BSG enhancements.
      bfa: Added support to query PHY.
      bfa: Added HBA diagnostics support.
      bfa: Added support for flash configuration
      bfa: Added support to obtain SFP info.
      bfa: Added support for CEE info and stats query.
      bfa: Extend BSG interface.
      bfa: FCS bug fixes.
      bfa: DMA memory allocation enhancement.
      bfa: Brocade-1860 Fabric Adapter vHBA support.
      bfa: Brocade-1860 Fabric Adapter PLL init fixes.
      bfa: Added Fabric Assigned Address(FAA) support
      bfa: IOC bug fixes.
      bfa: Enable ASIC block configuration and query.
      bfa: Update the driver version to 3.0.2.0
      bfa: Add BSG interface to support ELS, CT and vendor commands.
      bfa: Driver initialization and model description fix
      bfa: Enhancement for fcpim and IO tag handling.
      bfa: FC credit recovery and misc bug fixes.
      bfa: Brocade-1860 Fabric Adapter 16Gbs support and flash controller fixes.
      bfa: IOC and PLL init changes for Brocade-1860 Fabric Adapter.
      bfa: Changes to support vport disable and enable operations.
      bfa: Brocade-1860 Fabric Adapter Hardware Enablement
      bfa: Add pbc port disable check and fix LPS message name
      bfa: Introduce IOC event notification mechanism.
      bfa: Introduced generic address len pair to represent DMA memory chunk.

Mike Christie (4):
      libiscsi_tcp: fix LLD data allocation
      iscsi_tcp: fix locking around iscsi sk user data
      iscsi_ibft, be2iscsi, iscsi_boot: fix boot kobj data lifetime management
      iscsi_boot_sysfs: have this module check for null on destruction

Neerav Parikh (1):
      fcoe: Rearrange fcoe port and NPIV port cleanup

Ondrej Zary (1):
      aha152x: add missing ISA PNP IDs

Stephen Boyd (1):
      lpfc: Silence DEBUG_STRICT_USER_COPY_CHECKS=y warning

Vasu Dev (1):
      libfc: post reset event on lport reset

Werner Fink (1):
      Blacklist Traxdata CDR4120 and IOMEGA Zip drive to avoid lock ups.

Yi Zou (2):
      fcoe: support ndo_fcoe_ddp_target() for DDP in FCoE targe
      libfc, tcm_fc: add ddp_targ() to libfc function template to supprot FCoE DDP in target mode

And the diffstat

 MAINTAINERS                               |    9 +-
 block/blk-core.c                          |    3 +
 block/blk-exec.c                          |    7 +
 drivers/firmware/iscsi_ibft.c             |   14 +-
 drivers/scsi/aha152x.c                    |   17 +-
 drivers/scsi/atari_NCR5380.c              |    6 +-
 drivers/scsi/atari_scsi.c                 |    1 +
 drivers/scsi/be2iscsi/be_main.c           |  199 +-
 drivers/scsi/bfa/Makefile                 |    2 +-
 drivers/scsi/bfa/bfa.h                    |  144 +-
 drivers/scsi/bfa/bfa_core.c               |  878 ++++++---
 drivers/scsi/bfa/bfa_defs.h               |  583 ++++++-
 drivers/scsi/bfa/bfa_defs_fcs.h           |   27 +-
 drivers/scsi/bfa/bfa_defs_svc.h           |  170 ++-
 drivers/scsi/bfa/bfa_fc.h                 |   11 +-
 drivers/scsi/bfa/bfa_fcbuild.c            |   49 +-
 drivers/scsi/bfa/bfa_fcbuild.h            |   16 +-
 drivers/scsi/bfa/bfa_fcpim.c              |  478 ++++-
 drivers/scsi/bfa/bfa_fcpim.h              |   89 +-
 drivers/scsi/bfa/bfa_fcs.c                |  153 ++-
 drivers/scsi/bfa/bfa_fcs.h                |   31 +-
 drivers/scsi/bfa/bfa_fcs_fcpim.c          |   10 +
 drivers/scsi/bfa/bfa_fcs_lport.c          |  329 +++-
 drivers/scsi/bfa/bfa_fcs_rport.c          |  121 +-
 drivers/scsi/bfa/bfa_hw_cb.c              |   94 +-
 drivers/scsi/bfa/bfa_hw_ct.c              |   89 +-
 drivers/scsi/bfa/bfa_ioc.c                | 2992 +++++++++++++++++++++++++++--
 drivers/scsi/bfa/bfa_ioc.h                |  609 ++++++-
 drivers/scsi/bfa/bfa_ioc_cb.c             |   69 +-
 drivers/scsi/bfa/bfa_ioc_ct.c             |  516 ++++-
 drivers/scsi/bfa/bfa_modules.h            |   27 +-
 drivers/scsi/bfa/bfa_port.c               |  428 ++++-
 drivers/scsi/bfa/bfa_port.h               |   62 +-
 drivers/scsi/bfa/bfa_svc.c                | 1136 ++++++++---
 drivers/scsi/bfa/bfa_svc.h                |  151 ++-
 drivers/scsi/bfa/bfad.c                   |  295 ++--
 drivers/scsi/bfa/bfad_attr.c              |   53 +-
 drivers/scsi/bfa/bfad_bsg.c               | 2163 +++++++++++++++++++++
 drivers/scsi/bfa/bfad_bsg.h               |  509 +++++
 drivers/scsi/bfa/bfad_debugfs.c           |   14 +-
 drivers/scsi/bfa/bfad_drv.h               |   26 +-
 drivers/scsi/bfa/bfad_im.c                |   32 +-
 drivers/scsi/bfa/bfad_im.h                |    3 +
 drivers/scsi/bfa/bfi.h                    |  637 ++++++-
 drivers/scsi/bfa/bfi_cbreg.h              |  305 ---
 drivers/scsi/bfa/bfi_ctreg.h              |  636 ------
 drivers/scsi/bfa/bfi_ms.h                 |  159 ++-
 drivers/scsi/bfa/bfi_reg.h                |  450 +++++
 drivers/scsi/bnx2fc/bnx2fc.h              |   10 +-
 drivers/scsi/bnx2fc/bnx2fc_fcoe.c         |   33 +-
 drivers/scsi/bnx2fc/bnx2fc_hwi.c          |   24 +-
 drivers/scsi/bnx2fc/bnx2fc_io.c           |    2 +-
 drivers/scsi/bnx2i/57xx_iscsi_constants.h |    2 +-
 drivers/scsi/bnx2i/57xx_iscsi_hsi.h       |    2 +-
 drivers/scsi/bnx2i/bnx2i.h                |   33 +-
 drivers/scsi/bnx2i/bnx2i_hwi.c            |  199 ++-
 drivers/scsi/bnx2i/bnx2i_init.c           |  153 ++-
 drivers/scsi/bnx2i/bnx2i_iscsi.c          |   38 +-
 drivers/scsi/bnx2i/bnx2i_sysfs.c          |    2 +-
 drivers/scsi/cxgbi/cxgb3i/cxgb3i.c        |    4 +-
 drivers/scsi/fcoe/fcoe.c                  |  174 ++-
 drivers/scsi/fnic/fnic.h                  |    2 +-
 drivers/scsi/fnic/fnic_main.c             |   21 +-
 drivers/scsi/fnic/fnic_scsi.c             |    2 +-
 drivers/scsi/iscsi_boot_sysfs.c           |   31 +-
 drivers/scsi/iscsi_tcp.c                  |   61 +-
 drivers/scsi/libfc/fc_exch.c              |   26 +-
 drivers/scsi/libfc/fc_lport.c             |    2 +
 drivers/scsi/libfc/fc_rport.c             |   14 +
 drivers/scsi/libiscsi.c                   |   14 +-
 drivers/scsi/libiscsi_tcp.c               |   14 +-
 drivers/scsi/lpfc/lpfc_debugfs.c          |    3 +-
 drivers/scsi/mac_scsi.c                   |   14 +-
 drivers/scsi/mpt2sas/mpi/mpi2.h           |   12 +-
 drivers/scsi/mpt2sas/mpi/mpi2_cnfg.h      |   74 +-
 drivers/scsi/mpt2sas/mpi/mpi2_init.h      |    6 +-
 drivers/scsi/mpt2sas/mpi/mpi2_ioc.h       |    4 +-
 drivers/scsi/mpt2sas/mpt2sas_base.c       |   84 +-
 drivers/scsi/mpt2sas/mpt2sas_base.h       |   77 +-
 drivers/scsi/mpt2sas/mpt2sas_ctl.c        |   12 +-
 drivers/scsi/mpt2sas/mpt2sas_debug.h      |    2 +-
 drivers/scsi/mpt2sas/mpt2sas_scsih.c      |  279 +++-
 drivers/scsi/mpt2sas/mpt2sas_transport.c  |   24 +-
 drivers/scsi/scsi_devinfo.c               |    2 +
 drivers/scsi/scsi_lib.c                   |    2 +
 drivers/scsi/ses.c                        |    6 +-
 drivers/scsi/sr.c                         |   46 +-
 drivers/scsi/sr.h                         |    7 +
 drivers/scsi/sun3_NCR5380.c               |   98 +-
 drivers/scsi/sun3_scsi.c                  |   11 +-
 drivers/scsi/sun3_scsi_vme.c              |   11 +-
 drivers/target/tcm_fc/tfc_cmd.c           |   26 +-
 include/linux/iscsi_boot_sysfs.h          |   16 +-
 include/scsi/iscsi_proto.h                |   18 +-
 include/scsi/libfc.h                      |    8 +
 include/scsi/libiscsi.h                   |    2 +-
 96 files changed, 13313 insertions(+), 3196 deletions(-)
 create mode 100644 drivers/scsi/bfa/bfad_bsg.c
 create mode 100644 drivers/scsi/bfa/bfad_bsg.h
 delete mode 100644 drivers/scsi/bfa/bfi_cbreg.h
 delete mode 100644 drivers/scsi/bfa/bfi_ctreg.h
 create mode 100644 drivers/scsi/bfa/bfi_reg.h

James
