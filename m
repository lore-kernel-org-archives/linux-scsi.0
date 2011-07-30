From: James Bottomley <James.Bottomley@HansenPartnership.com>
Subject: [GIT PULL] Next round of SCSI updates for 3.0 merge window
Date: Sat, 30 Jul 2011 11:09:54 +0400
Message-ID: <1312009794.2888.3.camel@mulgrave>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner@vger.kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
To: Andrew Morton <akpm@linux-foundation.org>, Linus Torvalds <torvalds@linux-foundation.org>
Cc: linux-scsi <linux-scsi@vger.kernel.org>, linux-kernel <linux-kernel@vger.kernel.org>
List-Id: linux-scsi@vger.kernel.org

This contains further driver updates (lpfc, bnx2fc, megaraid_sas, bfa,
mvsas, qla2xx and fcoe) plus a couple of bug fixes in hpsa and pmc_raid
and a couple of minor infrastructure updates.

The patch is available here:

master.kernel.org:/pub/scm/linux/kernel/git/jejb/scsi-misc-2.6.git

The short changelog is:

Adam Radford (3):
      megaraid_sas Version to 5.40-rc1 and Changelog update
      megaraid_sas: Add .change_queue_depth support
      megaraid_sas: Fix FastPath I/O to work on degraded raid 1

Bhanu Prakash Gollapudi (12):
      bnx2fc: Update copyright and bump version to 1.0.4
      bnx2fc: Tx BDs cache in write tasks
      bnx2fc: Do not arm CQ when there are no CQEs
      bnx2fc: hold tgt lock when calling cmd_release
      bnx2fc: Enable support for sequence level error recovery
      bnx2fc: HSI changes for tape
      bnx2fc: Handle REC_TOV error code from firmware
      bnx2fc: REC/SRR link service request and response handling
      bnx2fc: Support 'sequence cleanup' task
      bnx2fc: Enable REC & CONF support for the session
      bnx2fc: Introduce interface structure for each vlan interface
      bnx2fc: Replace printks with KERN_ALERT to KERN_ERR/KERN_INFO

Chandra Seetharaman (2):
      dh_rdac: Associate HBA and storage in rdac_controller to support partition
      dh_rdac: Use WWID from C8 page instead of Subsystem id from C4 page to ide

Dan Rosenberg (1):
      pmcraid: reject negative request size

Hannes Reinecke (1):
      scsi_transport_spi: Export host width and HBA id

Hillf Danton (4):
      libfc: cleanup sending SRR request
      libfc: two minor changes in comments
      libfc: release exchg cache
      libfc: use FC_MAX_ERROR_CNT

James Smart (9):
      lpfc 8.3.25: Change driver version to 8.3.25
      lpfc 8.3.25: Add FCF priority failover functionality
      lpfc 8.3.25: Enhancements to Debug infrastructure
      lpfc 8.3.25: PCI and SR-IOV Fixes
      lpfc 8.3.25: Fabric and Target Discovery Fixes
      lpfc 8.3.25: Adapter Interface fixes and changes
      lpfc 8.3.25: Miscellaneous Bug fixes and code cleanup
      lpfc 8.3.25: T10 DIF Fixes
      scsi_lib: pause between error retries

Julia Lawall (1):
      ipr: reorder error handling code to include iounmap

Kashyap, Desai (2):
      mptfusion : Added check for SILI bit in READ_6 CDB for DATA UNDERRUN ERRAT
      mpt2sas: WarpDrive Infinite command retries due to wrong scsi command entr

Krishna Gudipati (15):
      bfa: Update the driver version to 3.0.2.2
      bfa: Added support to configure lunmasking
      bfa: Introduced initiator based lun masking feature.
      bfa: Add support to store driver configuration in flash.
      bfa: Add support to collect / reset fabric stats.
      bfa: Added support to configure QOS and collect stats.
      bfa: Add support to configure trunking on Brocade adapter ports.
      bfa: Add support to configure and query flash boot partition
      bfa: Added support to collect and reset fcport stats
      bfa: Add support for IO profiling.
      bfa: Extend BSG to support more user commands
      bfa: Check supported speed based on port mode
      bfa: Update RME interrupt handling.
      bfa: use negative error return values in all functions
      bfa: Add FC-transport based Asynchronous Event Notification support.

Luben Tuikov (1):
      libsas: remove expander from dev list on error

Neerav Parikh (1):
      libfc: Remove the reference to FCP packet from scsi_cmnd in case of error

Saurav Kashyap (3):
      qla2xxx: Cleanup of previous infrastructure.
      qla2xxx: Code changes to support new dynamic logging infrastructure.
      qla2xxx: Basic infrastructure for dynamic logging.

Stephen M. Cameron (2):
      hpsa: retry commands completing with status of UNSOLICITED_ABORT
      hpsa: do not attempt to read from a write-only register

Vasu Dev (4):
      fcoe: cleanup cpu selection for incoming requests
      fcoe: add fip retry to avoid missing critical keep alive
      libfc: fix warn on in lport retry
      libfc, fcoe: ignore rx frame with wrong xid info

Xiangliang Yu (9):
      mvsas: Add support for interrupt tasklet
      mvsas: update comments
      mvsas: misc improvements
      mvsas: Add new macros and functions
      mvsas: Remove unused macros, variables and functions
      mvsas: fix 94xx hotplug issue
      mvsas: Add driver version and interrupt coalescing to device attributes in
      mvsas: add support for 94xx phy tuning and multiple revisions
      mvsas: Add support for Non specific NCQ error interrupt

Yi Zou (1):
      fcoe: remove unused ptype field in fcoe_rcv_info

And the diffstat:

 Documentation/scsi/ChangeLog.megaraid_sas  |    8 +
 drivers/message/fusion/mptscsih.c          |    2 +-
 drivers/scsi/bfa/bfa.h                     |   51 +-
 drivers/scsi/bfa/bfa_core.c                |   60 +-
 drivers/scsi/bfa/bfa_defs.h                |  171 ++++
 drivers/scsi/bfa/bfa_defs_svc.h            |   99 ++
 drivers/scsi/bfa/bfa_fc.h                  |  155 +++
 drivers/scsi/bfa/bfa_fcpim.c               |  736 ++++++++++++++-
 drivers/scsi/bfa/bfa_fcpim.h               |   45 +-
 drivers/scsi/bfa/bfa_fcs.c                 |   26 +
 drivers/scsi/bfa/bfa_fcs.h                 |    1 +
 drivers/scsi/bfa/bfa_fcs_fcpim.c           |   37 +-
 drivers/scsi/bfa/bfa_fcs_lport.c           |   74 ++-
 drivers/scsi/bfa/bfa_fcs_rport.c           |   49 +-
 drivers/scsi/bfa/bfa_hw_cb.c               |   38 +-
 drivers/scsi/bfa/bfa_hw_ct.c               |   25 +-
 drivers/scsi/bfa/bfa_ioc.c                 |  569 +++++++++++-
 drivers/scsi/bfa/bfa_ioc.h                 |   48 +-
 drivers/scsi/bfa/bfa_modules.h             |    3 +
 drivers/scsi/bfa/bfa_svc.c                 |  249 ++++--
 drivers/scsi/bfa/bfa_svc.h                 |   29 +-
 drivers/scsi/bfa/bfad.c                    |    8 +-
 drivers/scsi/bfa/bfad_bsg.c                | 1084 ++++++++++++++++++++-
 drivers/scsi/bfa/bfad_bsg.h                |  237 +++++
 drivers/scsi/bfa/bfad_drv.h                |    6 +-
 drivers/scsi/bfa/bfad_im.c                 |   26 +
 drivers/scsi/bfa/bfad_im.h                 |   22 +
 drivers/scsi/bfa/bfi.h                     |   20 +
 drivers/scsi/bnx2fc/bnx2fc.h               |  107 ++-
 drivers/scsi/bnx2fc/bnx2fc_debug.h         |   16 +-
 drivers/scsi/bnx2fc/bnx2fc_els.c           |  434 ++++++++-
 drivers/scsi/bnx2fc/bnx2fc_fcoe.c          |  732 +++++++--------
 drivers/scsi/bnx2fc/bnx2fc_hwi.c           |  433 +++++++--
 drivers/scsi/bnx2fc/bnx2fc_io.c            |  194 +++-
 drivers/scsi/bnx2fc/bnx2fc_tgt.c           |   51 +-
 drivers/scsi/device_handler/scsi_dh_rdac.c |   82 +-
 drivers/scsi/fcoe/fcoe.c                   |   69 +-
 drivers/scsi/hpsa.c                        |    4 +-
 drivers/scsi/hpsa.h                        |    2 +-
 drivers/scsi/ipr.c                         |   12 +-
 drivers/scsi/libfc/fc_exch.c               |    9 +-
 drivers/scsi/libfc/fc_fcp.c                |    9 +-
 drivers/scsi/libfc/fc_lport.c              |    1 -
 drivers/scsi/libsas/sas_expander.c         |    3 +
 drivers/scsi/lpfc/lpfc.h                   |   15 +-
 drivers/scsi/lpfc/lpfc_attr.c              |  161 ++--
 drivers/scsi/lpfc/lpfc_bsg.c               |   89 ++-
 drivers/scsi/lpfc/lpfc_crtn.h              |   12 +
 drivers/scsi/lpfc/lpfc_debugfs.c           | 1456 ++++++++++++++++++++++++++--
 drivers/scsi/lpfc/lpfc_debugfs.h           |  125 +++-
 drivers/scsi/lpfc/lpfc_els.c               |  105 ++-
 drivers/scsi/lpfc/lpfc_hbadisc.c           |  222 ++++-
 drivers/scsi/lpfc/lpfc_hw.h                |    7 +-
 drivers/scsi/lpfc/lpfc_hw4.h               |   30 +-
 drivers/scsi/lpfc/lpfc_init.c              |   90 ++-
 drivers/scsi/lpfc/lpfc_mbox.c              |    2 +-
 drivers/scsi/lpfc/lpfc_scsi.c              |   97 +--
 drivers/scsi/lpfc/lpfc_sli.c               |  399 +++++++-
 drivers/scsi/lpfc/lpfc_sli4.h              |   29 +-
 drivers/scsi/lpfc/lpfc_version.h           |    2 +-
 drivers/scsi/megaraid/megaraid_sas.h       |    6 +-
 drivers/scsi/megaraid/megaraid_sas_base.c  |   18 +-
 drivers/scsi/megaraid/megaraid_sas_fp.c    |    1 -
 drivers/scsi/mpt2sas/mpt2sas_scsih.c       |    4 +
 drivers/scsi/mvsas/Kconfig                 |    9 +-
 drivers/scsi/mvsas/mv_64xx.c               |  101 ++-
 drivers/scsi/mvsas/mv_94xx.c               |  508 ++++++++--
 drivers/scsi/mvsas/mv_94xx.h               |   99 ++-
 drivers/scsi/mvsas/mv_chips.h              |   17 +-
 drivers/scsi/mvsas/mv_defs.h               |   11 +-
 drivers/scsi/mvsas/mv_init.c               |  187 +++-
 drivers/scsi/mvsas/mv_sas.c                |  422 ++++-----
 drivers/scsi/mvsas/mv_sas.h                |  105 ++-
 drivers/scsi/pmcraid.c                     |    3 +
 drivers/scsi/qla2xxx/qla_attr.c            |  183 ++--
 drivers/scsi/qla2xxx/qla_bsg.c             |  441 +++++----
 drivers/scsi/qla2xxx/qla_dbg.c             |  396 ++++++--
 drivers/scsi/qla2xxx/qla_dbg.h             |  187 +---
 drivers/scsi/qla2xxx/qla_dfs.c             |   16 +-
 drivers/scsi/qla2xxx/qla_gbl.h             |    8 +-
 drivers/scsi/qla2xxx/qla_gs.c              |  371 ++++----
 drivers/scsi/qla2xxx/qla_init.c            |  856 ++++++++--------
 drivers/scsi/qla2xxx/qla_inline.h          |    8 +-
 drivers/scsi/qla2xxx/qla_iocb.c            |  120 +--
 drivers/scsi/qla2xxx/qla_isr.c             |  663 +++++++-------
 drivers/scsi/qla2xxx/qla_mbx.c             | 1091 ++++++++++-----------
 drivers/scsi/qla2xxx/qla_mid.c             |  160 ++-
 drivers/scsi/qla2xxx/qla_nx.c              |  556 ++++++-----
 drivers/scsi/qla2xxx/qla_os.c              |  747 +++++++++------
 drivers/scsi/qla2xxx/qla_sup.c             |  275 +++---
 drivers/scsi/scsi_lib.c                    |    1 +
 drivers/scsi/scsi_transport_spi.c          |   24 +
 include/scsi/fc_frame.h                    |    1 -
 93 files changed, 11931 insertions(+), 4541 deletions(-)

James
