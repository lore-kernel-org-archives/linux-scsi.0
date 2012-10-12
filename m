From: James Bottomley <James.Bottomley@HansenPartnership.com>
Subject: [GIT PULL] Final round of SCSI updates for the 3.6+ merge window
Date: Fri, 12 Oct 2012 23:22:14 +0100
Message-ID: <1350080534.2496.102.camel@dabdike.int.hansenpartnership.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner@vger.kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
To: Andrew Morton <akpm@linux-foundation.org>, Linus Torvalds <torvalds@linux-foundation.org>
Cc: linux-scsi <linux-scsi@vger.kernel.org>, linux-kernel <linux-kernel@vger.kernel.org>
List-Id: linux-scsi@vger.kernel.org

This is an assorted set of stragglers into the merge window with driver
updates for megaraid_sas, lpfc, bfi and mvumi. It also includes some
fairly major fixes for virtio-scsi (scatterlist init), scsi_debug (off
by one error), storvsc (use after free) and qla2xxx (potential
deadlock).

The patch is available here:

git://git.kernel.org/pub/scm/linux/kernel/git/jejb/scsi.git scsi-misc

The short changelog is

Adam Radford (7):
      megaraid_sas: Version, Changelog, Copyright update
      megaraid_sas: Remove duplicate code
      megaraid_sas: Add SystemPD FastPath support
      megaraid_sas: Add array boundary check for SystemPD
      megaraid_sas: Load io_request DataLength in bytes
      megaraid_sas: Add module param for configurable MSI-X vector count
      megaraid_sas: Remove un-needed completion_lock spinlock calls

James Smart (16):
      lpfc 8.3.35: Update lpfc version for 8.3.35 driver release
      lpfc 8.3.35: Fixed not reporting logical link speed to SCSI midlayer when QoS not on
      lpfc 8.3.35: Fix error with fabric service parameters causing performance issues
      lpfc 8.3.35: Fixed SCSI host create showing wrong link speed on SLI3 HBA ports
      lpfc 8.3.35: Fixed not checking solicition in progress bit when verifying FCF record for use
      lpfc 8.3.35: Fixed messages for misconfigured port errors
      lpfc 8.3.35: Fixed kernel warning on spinlock usage on some distributions
      lpfc 8.3.35: Fixed PRLI not being retried if a LS_RJT with a reason
      lpfc 8.3.35: Correct request_firmware use that was increasing boot times
      lpfc 8.3.35: Fix FCP2 Retries for non-r/w commands.
      lpfc 8.3.35: Fixed Linux generic firmware download on SLI4 devices with longer module names
      lpfc 8.3.35: Expand I/O channel support for large systems
      lpfc 8.3.35: Correct missing queue destroy on function reset
      lpfc 8.3.35: Fix incorrect comment in T10 DIF attributes
      lpfc 8.3.35: Added checking BMBX register for RDY bit before writing the first address in
      lpfc 8.3.35: Fix interrupt delay multipler conversion for eq_create

Jiri Kosina (1):
      qla2xxx: fix potential deadlock on ha->hardware_lock

K. Y. Srinivasan (1):
      storvsc: Account for in-transit packets in the RESET path

Krishna Gudipati (15):
      bfa: Update the driver version to 3.1.2.1
      bfa: Firmware image naming convention update
      bfa: Add support to read/update the FRU data.
      bfa: Support Power on Hours display and diag temp sensor fixes
      bfa: Add support to configure min/max bandwidth for a pcifn
      bfa: Add support for IO throttling at port level
      bfa: Add support for user to configure bandwidth on QoS priorities
      bfa: Fabric Assigned Address implementation fix
      bfa: Add diagnostic port (D-Port) support
      bfa: Fix to handle firmware tskim abort request response
      bfa: Fix few attributes in the RHBA CT passthru command
      bfa: Add support to have mfg date as part of adapter attributes
      bfa: Flash Controller PLL initialization fixes
      bfa: IOCFC state machine enhancements
      bfa: Add support for FC Arbitrated Loop topology.

Li Zhong (1):
      Shorten the path length of scsi_cmd_to_driver()

Lukas Czerner (1):
      scsi_debug: Fix off-by-one bug when unmapping region

Neerav Parikh (1):
      fcoe: Fix write errors on NPIV ports

Paolo Bonzini (2):
      virtio-scsi: support online resizing of disks
      virtio-scsi: fix LUNs greater than 255

Richard W.M. Jones (1):
      virtio-scsi: initialize scatterlist structure

Robert Love (1):
      Documentation: Add lesb/ to path for LESB attributes in FCoE bus documentation

Shun Fu (1):
      mvumi: Add support for Marvell SAS/SATA RAID-on-Chip(ROC) 88RC9580

Yi Zou (1):
      libfc: fix lun reset failure bugs in fc_fcp_resp handling of FCP_RSP_INFO


And the diffstat

 Documentation/ABI/testing/sysfs-bus-fcoe    |   12 +-
 Documentation/scsi/ChangeLog.megaraid_sas   |   13 +
 drivers/scsi/bfa/bfa_core.c                 |   85 ++-
 drivers/scsi/bfa/bfa_defs.h                 |   61 +-
 drivers/scsi/bfa/bfa_defs_svc.h             |  119 ++-
 drivers/scsi/bfa/bfa_fc.h                   |    5 +
 drivers/scsi/bfa/bfa_fcbuild.c              |    4 +
 drivers/scsi/bfa/bfa_fcpim.c                |  123 ++-
 drivers/scsi/bfa/bfa_fcpim.h                |   13 +-
 drivers/scsi/bfa/bfa_fcs.c                  |   64 +-
 drivers/scsi/bfa/bfa_fcs.h                  |   23 +-
 drivers/scsi/bfa/bfa_fcs_lport.c            |  155 +++-
 drivers/scsi/bfa/bfa_fcs_rport.c            |  288 ++++++-
 drivers/scsi/bfa/bfa_ioc.c                  |  494 +++++++++++-
 drivers/scsi/bfa/bfa_ioc.h                  |   63 +-
 drivers/scsi/bfa/bfa_ioc_ct.c               |  236 +++---
 drivers/scsi/bfa/bfa_modules.h              |    1 +
 drivers/scsi/bfa/bfa_port.c                 |   32 +
 drivers/scsi/bfa/bfa_port.h                 |    3 +
 drivers/scsi/bfa/bfa_svc.c                  |  732 +++++++++++++++++-
 drivers/scsi/bfa/bfa_svc.h                  |   30 +-
 drivers/scsi/bfa/bfad.c                     |    6 +-
 drivers/scsi/bfa/bfad_bsg.c                 |  375 +++++++--
 drivers/scsi/bfa/bfad_bsg.h                 |   63 +-
 drivers/scsi/bfa/bfad_drv.h                 |    2 +-
 drivers/scsi/bfa/bfi.h                      |   72 +-
 drivers/scsi/bfa/bfi_ms.h                   |   14 +
 drivers/scsi/bfa/bfi_reg.h                  |    3 +
 drivers/scsi/fcoe/fcoe.c                    |   14 +-
 drivers/scsi/fcoe/fcoe.h                    |    2 +
 drivers/scsi/libfc/fc_fcp.c                 |    3 +-
 drivers/scsi/lpfc/lpfc.h                    |    2 +
 drivers/scsi/lpfc/lpfc_attr.c               |    8 +-
 drivers/scsi/lpfc/lpfc_crtn.h               |    1 +
 drivers/scsi/lpfc/lpfc_els.c                |    7 +-
 drivers/scsi/lpfc/lpfc_hbadisc.c            |   11 +-
 drivers/scsi/lpfc/lpfc_hw4.h                |   20 +-
 drivers/scsi/lpfc/lpfc_init.c               |  256 +++++--
 drivers/scsi/lpfc/lpfc_scsi.c               |   39 +-
 drivers/scsi/lpfc/lpfc_sli.c                |   96 ++-
 drivers/scsi/lpfc/lpfc_sli4.h               |    8 +-
 drivers/scsi/lpfc/lpfc_version.h            |    2 +-
 drivers/scsi/megaraid/megaraid_sas.h        |    8 +-
 drivers/scsi/megaraid/megaraid_sas_base.c   |   13 +-
 drivers/scsi/megaraid/megaraid_sas_fp.c     |    2 +-
 drivers/scsi/megaraid/megaraid_sas_fusion.c |   27 +-
 drivers/scsi/megaraid/megaraid_sas_fusion.h |    2 +-
 drivers/scsi/mvumi.c                        | 1093 ++++++++++++++++++++++-----
 drivers/scsi/mvumi.h                        |  235 ++++--
 drivers/scsi/qla2xxx/qla_init.c             |    5 +-
 drivers/scsi/scsi_debug.c                   |    2 +-
 drivers/scsi/scsi_error.c                   |    8 +-
 drivers/scsi/storvsc_drv.c                  |    5 +
 drivers/scsi/virtio_scsi.c                  |   39 +-
 include/linux/virtio_scsi.h                 |    2 +
 include/scsi/fc/fc_fcp.h                    |    6 +
 include/scsi/libfcoe.h                      |    2 -
 include/scsi/scsi_cmnd.h                    |   12 +-
 58 files changed, 4274 insertions(+), 747 deletions(-)

James
