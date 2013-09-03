From: James Bottomley <James.Bottomley@HansenPartnership.com>
Subject: [GIT PULL] First round of SCSI updates for the 3.11+ merge window
Date: Tue, 03 Sep 2013 07:53:27 -0700
Message-ID: <1378220007.2064.13.camel@dabdike.int.hansenpartnership.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="ISO-8859-15"
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner@vger.kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
To: Andrew Morton <akpm@linux-foundation.org>, Linus Torvalds <torvalds@linux-foundation.org>
Cc: linux-scsi <linux-scsi@vger.kernel.org>, linux-kernel <linux-kernel@vger.kernel.org>
List-Id: linux-scsi@vger.kernel.org

This patch set is a set of driver updates (ufs, zfcp, lpfc, mpt2/3sas,
qla4xxx, qla2xxx [adding support for ISP8044 + other things]) we also
have a new driver: esas2r which has a number of static checker problems,
but which I expect to resolve over the -rc course of 3.12 under the new
driver exception.  We also have the error return updates that were
discussed at LSF.

[Patch set has been recently partially rebased to drop a set of UFS
updates which also had static checker problems which require more time
to get the resolutions in and tested]

The patch is available here:

git://git.kernel.org/pub/scm/linux/kernel/git/jejb/scsi.git scsi-misc

The short changelog is:

Adheer Chandravanshi (12):
      libiscsi: Add missing prints for session and connection sysfs attrs
      libiscsi: Add a missing break statement
      qla4xxx: Update driver version to 5.03.00-k11
      qla4xxx: Export more firmware info in sysfs
      qla4xxx: Only BIOS boot target entries should be at index 0 and 1.
      qla4xxx: discovery_parent_idx can be shown without any check.
      qla4xxx: Set IPv6 traffic class if device type is IPv6.
      qla4xxx: Use discovery_parent_idx instead of discovery_parent_type
      qla4xxx: Allow removal of failed session using logout.
      qla4xxx: Exporting new attrs for iscsi session and connection in sysfs
      libiscsi: Exporting new attrs for iscsi session and connection in sysfs
      scsi_transport_iscsi: Exporting new attrs for iscsi session and connection in sysfs

Akinobu Mita (5):
      scsi_debug: fix logical block provisioning support when unmap_alignment != 0
      scsi_debug: fix endianness bug in sdebug_build_parts()
      ufs: don't stop controller before scsi_remove_host()
      ufs: don't disable_irq() if the IRQ can be shared among devices
      ufshcd-pci: release ioremapped region during removing driver

Anand Kumar Santhanam (1):
      pm80xx: Fix for 32 bit compilation warning

Andrew Vasquez (1):
      qla2xxx: Correct multiqueue offset calculations.

Andy Shevchenko (1):
      qla2xxx: print MAC via %pMR.

Armen Baloyan (12):
      qla2xxx: Set default critical temperature value in cases when ISPFX00 firmware doesn't provide it
      qla2xxx: QLAFX00 make over temperature AEN handling informational, add log for normal temperature AEN
      qla2xxx: Correct Interrupt Register offset for ISPFX00
      qla2xxx: Remove handling of Shutdown Requested AEN from qlafx00_process_aen().
      qla2xxx: Send all AENs for ISPFx00 to above layers.
      qla2xxx: Add changes in initialization for ISPFX00 cards with BIOS
      qla2xxx: Add changes to support extended IOs for ISPFX00
      qla2xxx: Add critical temperature handling for ISPFX00.
      qla2xxx: Notify ISPFX00 firmware when driver is unloaded or system is shut down.
      qla2xxx: Add ISPFX00 specific bus reset routine.
      qla2xxx: Perform warm reset every 2 minutes if firmware load fails for ISPFX00.
      qla2xxx: Set factory reset recovery timeout to 10 min. for ISPFX00.

Atul Deshmukh (1):
      qla2xxx: Add support for ISP8044.

Bradley Grove (1):
      esas2r: ATTO Technology ExpressSAS 6G SAS/SATA RAID Adapter Driver

Chad Dupuis (3):
      qla2xxx: Move queue depth ramp down message to i/o debug level.
      qla2xxx: Make log message that prints when a completion status requires a port down more readable.
      qla2xxx: Remove QL_DEBUG_LEVEL_17 defines from qla_nx.c.

Dan Carpenter (1):
      eata_pio: off by one in eata_pio_detect()

Dolev Raviv (1):
      ufs: Set fDeviceInit flag to initiate device initialization

Eddie Wai (2):
      MAINTAINERS: Add maintainer info for bnx2i
      bnx2i: Update version and copyright year 2013

Ewan D. Milne (1):
      Generate uevents on certain unit attention codes

Greg Kroah-Hartman (2):
      st: convert class code to use dev_groups
      sd: convert class code to use dev_groups

Hannes Reinecke (4):
      Return ENODATA on medium error
      return ENOSPC on thin provisioning failure
      Set hostbyte status in scsi_check_sense()
      Document enhanced error codes

James Smart (14):
      lpfc: Removed obsolete fcp_eq_count and fcp_wq_count driver attributes
      lpfc 8.3.41: Update lpfc version to driver version 8.3.41
      lpfc 8.3.41: Update copyrights for 8.3.41 modifications
      lpfc 8.3.41: Fixed the format of some log message fields
      lpfc 8.3.41: Add first burst support to driver
      lpfc 8.3.41: Fixed not able to perform PCI function reset when board was not in online mode
      lpfc 8.3.41: Fixed failure in setting SLI3 board mode
      lpfc 8.3.41: Fixed SLI3 failing FCP write on check-condition no-sense with residual zero
      lpfc 8.3.41: Fixed support for 128 byte WQEs
      lpfc 8.3.41: Ensure driver properly zeros unused fields in SLI4 mailbox commands
      lpfc 8.3.41: Fixed max value of lpfc_lun_queue_depth
      lpfc 8.3.41: Fixed Receive Queue varied frame size handling
      lpfc 8.3.41: Fix mailbox byteswap issue on PPC
      lpfc 8.3.41: Fixed freeing of iocb when internal loopback times out

Jan Vesely (2):
      mpt3sas: Remove phys on topology change
      mpt2sas: Remove phys on topology change.

Joe Carnuccio (6):
      qla2xxx: Correctly print out/in mailbox registers.
      qla2xxx: Select link initialization option bits from current operating mode.
      qla2xxx: Add missing FCP statistics to sysfs interface.
      qla2xxx: Reconfigure thermal temperature.
      qla2xxx: Add setting of driver version string for vendor application.
      qla2xxx: Fix incorrect test after list_for_each_entry() exits.

Joe Lawrence (2):
      mpt3sas: fix cleanup on controller resource mapping failure
      mpt2sas: fix cleanup on controller resource mapping failure

John Kacur (1):
      hpsa: fix warning with smp_processor_id() in preemptible

Martin Peschke (3):
      zfcp: dead code removal
      zfcp: cleanup use of obsolete strict_strto* functions
      zfcp: consistently use appropriate SBAL flag definitions

Nilesh Javali (1):
      qla4xxx: Implementation of ACB configuration during Loopback for ISP8042

Oleksandr Khoshaba (1):
      qla2xxx: Print some variables to hexadecimal string via %*phN format

Or Gerlitz (1):
      IB/iser: Add Discovery support

Rasesh Mody (1):
      bfa: firmware update to 3.2.1.1

Santosh Vernekar (3):
      qla2xxx: Add loopback IDC-TIME-EXTEND aen handling support.
      qla4xxx: Fix the minidump data collection check in for loop
      qla4xxx: Add pex-dma support for capturing minidump

Saurav Kashyap (3):
      qla2xxx: Update the driver version to 8.06.00.08-k.
      qla2xxx: Correction to message ids.
      qla2xxx: Fix sparse warnings in qlafx00_fxdisc_iocb function.

Sawan Chandak (1):
      qla2xxx: Add a new interface to update versions.

Sreekanth Reddy (9):
      mpt3sas: Added a driver module parameter max_msix_vectors
      mpt2sas: Bump driver version to v16.100.00.00
      mpt2sas: Fix for kernel panic when driver loads with HBA connected to non LUN 0 configured expander
      mpt2sas: when Async scanning is enabled then while scanning, devices are removed but their transport layer entries are not removed
      mpt2sas: Infinite loop can occur if MPI2_IOCSTATUS_CONFIG_INVALID_PAGE is not returned
      mpt2sas: The copyright in driver sources is updated for the year 2013
      mpt2sas: MPI2 Rev X (2.00.16) specifications
      mpt2sas: Change in MPI2_RAID_ACTION_SYSTEM_SHUTDOWN_INITIATED notification methodology
      mpt2sas: Null pointer deference possibility in mpt2sas_ctl_event_callback function

Steffen Maier (1):
      zfcp: enable FCP hardware data router by default

Sujit Reddy Thumma (3):
      ufs: Add runtime PM support for UFS host controller driver
      ufs: Add support for host assisted background operations
      ufs: Add support for sending NOP OUT UPIU

Tomas Henzl (2):
      hpsa: remove unneeded variable
      hpsa: fix a race in cmd_free/scsi_done

Vaughan Cao (4):
      sg: push file descriptor list locking down to per-device locking
      sg: checking sdp->detached isn't protected when open
      sg: no need sg_open_exclusive_lock
      sg: use rwsem to solve race during exclusive open

Vikas Chaudhary (7):
      qla4xxx: Update driver version to 5.04.00-k1
      qla4xxx: Return error if minidump data collection fails
      qla4xxx: Update driver version to 5.04.00-k0
      qla4xxx: Update Copyright header
      qla4xxx: Added support for ISP8042
      qla4xxx: Update driver version to 5.03.00-k10
      MAINTAINERS: Update for qla4xxx

Wei Yongjun (1):
      ufshcd-pltfrm: remove redundant dev_err call in ufshcd_pltfrm_probe()

Wolfram Sang (1):
      ufs: don't check resource with devm_ioremap_resource

Xinghai Yu (1):
      isci: Fix a infinite loop.

Yijing Wang (1):
      pm8001: clean up unnecessary MSI/MSI-X capability find

wenxiong@linux.vnet.ibm.com (1):
      ipr: Add sereral new CCIN definitions for new adapters support

and the diffstat:

 Documentation/scsi/LICENSE.qla4xxx           |    2 +-
 MAINTAINERS                                  |   15 +-
 block/blk-core.c                             |    6 +
 drivers/infiniband/ulp/iser/iscsi_iser.c     |    3 +-
 drivers/infiniband/ulp/iser/iser_initiator.c |   11 +-
 drivers/md/dm-mpath.c                        |   16 +-
 drivers/s390/scsi/zfcp_aux.c                 |    4 +-
 drivers/s390/scsi/zfcp_ext.h                 |    2 -
 drivers/s390/scsi/zfcp_fsf.c                 |   12 +-
 drivers/s390/scsi/zfcp_qdio.c                |    4 +-
 drivers/s390/scsi/zfcp_sysfs.c               |   12 +-
 drivers/scsi/Kconfig                         |    1 +
 drivers/scsi/Makefile                        |    1 +
 drivers/scsi/bfa/bfad.c                      |    6 +-
 drivers/scsi/bnx2i/57xx_iscsi_constants.h    |    2 +-
 drivers/scsi/bnx2i/57xx_iscsi_hsi.h          |    2 +-
 drivers/scsi/bnx2i/bnx2i.h                   |    2 +-
 drivers/scsi/bnx2i/bnx2i_hwi.c               |    2 +-
 drivers/scsi/bnx2i/bnx2i_init.c              |    6 +-
 drivers/scsi/bnx2i/bnx2i_iscsi.c             |    2 +-
 drivers/scsi/bnx2i/bnx2i_sysfs.c             |    2 +-
 drivers/scsi/eata_pio.c                      |    2 +-
 drivers/scsi/esas2r/Kconfig                  |    5 +
 drivers/scsi/esas2r/Makefile                 |    5 +
 drivers/scsi/esas2r/atioctl.h                | 1254 +++++++++
 drivers/scsi/esas2r/atvda.h                  | 1319 +++++++++
 drivers/scsi/esas2r/esas2r.h                 | 1441 ++++++++++
 drivers/scsi/esas2r/esas2r_disc.c            | 1189 ++++++++
 drivers/scsi/esas2r/esas2r_flash.c           | 1512 +++++++++++
 drivers/scsi/esas2r/esas2r_init.c            | 1773 ++++++++++++
 drivers/scsi/esas2r/esas2r_int.c             |  941 +++++++
 drivers/scsi/esas2r/esas2r_io.c              |  880 ++++++
 drivers/scsi/esas2r/esas2r_ioctl.c           | 2110 +++++++++++++++
 drivers/scsi/esas2r/esas2r_log.c             |  254 ++
 drivers/scsi/esas2r/esas2r_log.h             |  118 +
 drivers/scsi/esas2r/esas2r_main.c            | 2032 ++++++++++++++
 drivers/scsi/esas2r/esas2r_targdb.c          |  306 +++
 drivers/scsi/esas2r/esas2r_vda.c             |  521 ++++
 drivers/scsi/hpsa.c                          |    8 +-
 drivers/scsi/hpsa.h                          |    2 -
 drivers/scsi/ipr.c                           |   14 +
 drivers/scsi/ipr.h                           |    7 +
 drivers/scsi/isci/port_config.c              |    2 +-
 drivers/scsi/libiscsi.c                      |  109 +
 drivers/scsi/lpfc/lpfc.h                     |    3 +-
 drivers/scsi/lpfc/lpfc_attr.c                |   57 +-
 drivers/scsi/lpfc/lpfc_bsg.c                 |    8 +-
 drivers/scsi/lpfc/lpfc_ct.c                  |    2 +-
 drivers/scsi/lpfc/lpfc_disc.h                |    3 +-
 drivers/scsi/lpfc/lpfc_els.c                 |    2 +
 drivers/scsi/lpfc/lpfc_hw4.h                 |   13 +
 drivers/scsi/lpfc/lpfc_init.c                |   42 +-
 drivers/scsi/lpfc/lpfc_mbox.c                |    7 +-
 drivers/scsi/lpfc/lpfc_nportdisc.c           |   12 +-
 drivers/scsi/lpfc/lpfc_scsi.c                |   12 +-
 drivers/scsi/lpfc/lpfc_sli.c                 |  147 +-
 drivers/scsi/lpfc/lpfc_sli.h                 |    7 +-
 drivers/scsi/lpfc/lpfc_sli4.h                |    6 +
 drivers/scsi/lpfc/lpfc_version.h             |    2 +-
 drivers/scsi/lpfc/lpfc_vport.c               |    5 +-
 drivers/scsi/mpt2sas/mpi/mpi2.h              |    7 +-
 drivers/scsi/mpt2sas/mpi/mpi2_cnfg.h         |   10 +-
 drivers/scsi/mpt2sas/mpi/mpi2_init.h         |    2 +-
 drivers/scsi/mpt2sas/mpi/mpi2_ioc.h          |    2 +-
 drivers/scsi/mpt2sas/mpi/mpi2_raid.h         |    2 +-
 drivers/scsi/mpt2sas/mpi/mpi2_sas.h          |    2 +-
 drivers/scsi/mpt2sas/mpi/mpi2_tool.h         |    2 +-
 drivers/scsi/mpt2sas/mpi/mpi2_type.h         |    2 +-
 drivers/scsi/mpt2sas/mpt2sas_base.c          |   40 +-
 drivers/scsi/mpt2sas/mpt2sas_base.h          |   10 +-
 drivers/scsi/mpt2sas/mpt2sas_config.c        |    2 +-
 drivers/scsi/mpt2sas/mpt2sas_ctl.c           |   14 +-
 drivers/scsi/mpt2sas/mpt2sas_ctl.h           |    2 +-
 drivers/scsi/mpt2sas/mpt2sas_debug.h         |    2 +-
 drivers/scsi/mpt2sas/mpt2sas_scsih.c         |   82 +-
 drivers/scsi/mpt2sas/mpt2sas_transport.c     |    7 +-
 drivers/scsi/mpt3sas/mpt3sas_base.c          |   41 +-
 drivers/scsi/mpt3sas/mpt3sas_scsih.c         |    1 +
 drivers/scsi/mpt3sas/mpt3sas_transport.c     |    5 +-
 drivers/scsi/pm8001/pm8001_init.c            |    5 +-
 drivers/scsi/qla2xxx/Makefile                |    2 +-
 drivers/scsi/qla2xxx/qla_attr.c              |   81 +-
 drivers/scsi/qla2xxx/qla_bsg.c               |   43 +-
 drivers/scsi/qla2xxx/qla_dbg.c               |   58 +-
 drivers/scsi/qla2xxx/qla_def.h               |   39 +-
 drivers/scsi/qla2xxx/qla_fw.h                |    2 +
 drivers/scsi/qla2xxx/qla_gbl.h               |   74 +-
 drivers/scsi/qla2xxx/qla_gs.c                |   97 +-
 drivers/scsi/qla2xxx/qla_init.c              |   86 +-
 drivers/scsi/qla2xxx/qla_inline.h            |    2 +-
 drivers/scsi/qla2xxx/qla_iocb.c              |   17 +-
 drivers/scsi/qla2xxx/qla_isr.c               |   91 +-
 drivers/scsi/qla2xxx/qla_mbx.c               |  297 +-
 drivers/scsi/qla2xxx/qla_mid.c               |    2 +
 drivers/scsi/qla2xxx/qla_mr.c                |  164 +-
 drivers/scsi/qla2xxx/qla_mr.h                |   41 +-
 drivers/scsi/qla2xxx/qla_nx.c                |  117 +-
 drivers/scsi/qla2xxx/qla_nx.h                |   10 +
 drivers/scsi/qla2xxx/qla_nx2.c               | 3716 ++++++++++++++++++++++++++
 drivers/scsi/qla2xxx/qla_nx2.h               |  551 ++++
 drivers/scsi/qla2xxx/qla_os.c                |  213 +-
 drivers/scsi/qla2xxx/qla_sup.c               |  162 +-
 drivers/scsi/qla2xxx/qla_target.c            |   69 +-
 drivers/scsi/qla2xxx/qla_version.h           |    4 +-
 drivers/scsi/qla2xxx/tcm_qla2xxx.c           |   14 +-
 drivers/scsi/qla4xxx/ql4_83xx.c              |   12 +-
 drivers/scsi/qla4xxx/ql4_83xx.h              |   36 +-
 drivers/scsi/qla4xxx/ql4_attr.c              |   90 +-
 drivers/scsi/qla4xxx/ql4_bsg.c               |    2 +-
 drivers/scsi/qla4xxx/ql4_dbg.c               |   13 +-
 drivers/scsi/qla4xxx/ql4_def.h               |   29 +-
 drivers/scsi/qla4xxx/ql4_fw.h                |   10 +-
 drivers/scsi/qla4xxx/ql4_glbl.h              |   10 +-
 drivers/scsi/qla4xxx/ql4_init.c              |    6 +-
 drivers/scsi/qla4xxx/ql4_inline.h            |    2 +-
 drivers/scsi/qla4xxx/ql4_iocb.c              |    2 +-
 drivers/scsi/qla4xxx/ql4_isr.c               |   65 +-
 drivers/scsi/qla4xxx/ql4_mbx.c               |  171 +-
 drivers/scsi/qla4xxx/ql4_nvram.c             |    2 +-
 drivers/scsi/qla4xxx/ql4_nvram.h             |    2 +-
 drivers/scsi/qla4xxx/ql4_nx.c                |  297 +-
 drivers/scsi/qla4xxx/ql4_nx.h                |    2 +-
 drivers/scsi/qla4xxx/ql4_os.c                |  357 ++-
 drivers/scsi/qla4xxx/ql4_version.h           |    4 +-
 drivers/scsi/scsi_debug.c                    |   14 +-
 drivers/scsi/scsi_error.c                    |  128 +-
 drivers/scsi/scsi_lib.c                      |   48 +-
 drivers/scsi/scsi_sysfs.c                    |   10 +
 drivers/scsi/scsi_transport_iscsi.c          |  123 +-
 drivers/scsi/sd.c                            |  149 +-
 drivers/scsi/sg.c                            |  176 +-
 drivers/scsi/st.c                            |   27 +-
 drivers/scsi/ufs/ufs.h                       |  155 +-
 drivers/scsi/ufs/ufshcd-pci.c                |   99 +-
 drivers/scsi/ufs/ufshcd-pltfrm.c             |   57 +-
 drivers/scsi/ufs/ufshcd.c                    | 1170 +++++++-
 drivers/scsi/ufs/ufshcd.h                    |   59 +-
 drivers/scsi/ufs/ufshci.h                    |    2 +-
 include/scsi/iscsi_if.h                      |   32 +
 include/scsi/libiscsi.h                      |   31 +
 include/scsi/scsi.h                          |    3 +-
 include/scsi/scsi_device.h                   |   13 +-
 142 files changed, 24497 insertions(+), 1348 deletions(-)
 create mode 100644 drivers/scsi/esas2r/Kconfig
 create mode 100644 drivers/scsi/esas2r/Makefile
 create mode 100644 drivers/scsi/esas2r/atioctl.h
 create mode 100644 drivers/scsi/esas2r/atvda.h
 create mode 100644 drivers/scsi/esas2r/esas2r.h
 create mode 100644 drivers/scsi/esas2r/esas2r_disc.c
 create mode 100644 drivers/scsi/esas2r/esas2r_flash.c
 create mode 100644 drivers/scsi/esas2r/esas2r_init.c
 create mode 100644 drivers/scsi/esas2r/esas2r_int.c
 create mode 100644 drivers/scsi/esas2r/esas2r_io.c
 create mode 100644 drivers/scsi/esas2r/esas2r_ioctl.c
 create mode 100644 drivers/scsi/esas2r/esas2r_log.c
 create mode 100644 drivers/scsi/esas2r/esas2r_log.h
 create mode 100644 drivers/scsi/esas2r/esas2r_main.c
 create mode 100644 drivers/scsi/esas2r/esas2r_targdb.c
 create mode 100644 drivers/scsi/esas2r/esas2r_vda.c
 create mode 100644 drivers/scsi/qla2xxx/qla_nx2.c
 create mode 100644 drivers/scsi/qla2xxx/qla_nx2.h

James
