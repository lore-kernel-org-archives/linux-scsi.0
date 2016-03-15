From: James Bottomley <James.Bottomley@HansenPartnership.com>
Subject: [GIT PULL] first round of SCSI updates for the 4.5+ merge window
Date: Tue, 15 Mar 2016 15:36:11 -0700
Message-ID: <1458081371.2375.109.camel@HansenPartnership.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner@vger.kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
To: Andrew Morton <akpm@linux-foundation.org>, Linus Torvalds <torvalds@linux-foundation.org>
Cc: linux-scsi <linux-scsi@vger.kernel.org>, linux-kernel <linux-kernel@vger.kernel.org>
List-Id: linux-scsi@vger.kernel.org

This pull includes driver updates from the usual suspects (stex, hpsa,
ncr5380, scsi_dh, qla2xxx, be2iscsi, hisi_sas, cxlflash, aacraid,
mp3sas, megaraid_sas, ibmvscsi, ufs) plus an assortment of
miscellaneous fixes.  The major user visible change of this pull is
that we've moved from monotonically increasing host number to an ida
allocated one (meaning the numbers get re-used) because someone managed
to wrap the count in an iscsi system.  We don't believe there will be
any adverse consequences of this.

The patch is available here:

git://git.kernel.org/pub/scm/linux/kernel/git/jejb/scsi.git scsi-misc

The short changelog is:

Alan (3):
      lpfc: fix missing zero termination in debugfs
      esas2r: Fix array overrun
      aic7xxx: Fix queue depth handling

Alexey Khoroshilov (1):
      be2iscsi: add checks for dma mapping errors

Alison Schofield (1):
      gdth: replace struct timeval with ktime_get_real_seconds()

Amitoj Kaur Chawla (1):
      qlogicpti: Return correct error code

Arnd Bergmann (8):
      scsi: mvumi: use __maybe_unused to hide pm functions
      scsi_dh: force modular build if SCSI is a module
      scsi: aha1542: avoid uninitialized variable warnings
      scsi: qla4xxx: shut up warning for rd_reg_indirect
      scsi: fas216: avoid fas216_log_setup for loadable module
      scsi: acornscsi: mark calc_sync_xfer as __maybe_unused
      mptfusion: hide unused seq_mpt_print_ioc_summary function
      scsi: fdomain: drop fdomain_pci_tbl when built-in

Chad Dupuis (2):
      qla2xxx: Set relogin flag when we fail to queue login requests.
      qla2xxx: Remove unneeded link offline message.

Charles (3):
      stex: Add S3/S4 support
      stex: Add hotplug support
      stex: Support to Pegasus series.

Colin Ian King (1):
      snic: correctly check for array overrun on overly long version number

Dan Carpenter (1):
      bfa: use strncpy() instead of memcpy()

Denys Vlasenko (1):
      bfa: deinline __bfa_trc() and __bfa_trc32()

Don Brace (9):
      hpsa: update MAINTAINERS with new e-mail
      hpsa: update copyright information
      hpsa: remove function definition for sanitize_inquiry_string
      hpsa: check for a null phys_disk pointer in ioaccel2 path
      hpsa: correct abort tmf for hba devices
      hpsa: correct lun data caching bitmap definition
      hpsa: add SMR drive support
      hpsa: do not get enclosure info for external devices
      scsi: Export function scsi_scan.c:sanitize_inquiry_string

Douglas Gilbert (1):
      sg: fix dxferp in from_to case

Ewan D. Milne (1):
      mptbase: fixup error handling paths in mpt_attach()

Finn Thain (6):
      ncr5380: Call scsi_eh_prep_cmnd() and scsi_eh_restore_cmnd() as and when appropriate
      ncr5380: Fix NCR5380_select() EH checks and result handling
      ncr5380: Forget aborted commands
      ncr5380: Dont re-enter NCR5380_select()
      ncr5380: Dont release lock for PIO transfer
      ncr5380: Correctly clear command pointers and lists after bus reset

Gabriel Krisman Bertazi (1):
      ipr: Fix regression when loading firmware

Hannes Reinecke (27):
      scsi_sysfs: call 'device_add' after attaching device handler
      scsi_dh_emc: update 'access_state' field
      scsi_dh_rdac: update 'access_state' field
      scsi_dh_alua: update 'access_state' field
      scsi_dh_alua: use common definitions for ALUA state
      scsi: Add 'access_state' and 'preferred_path' attribute
      scsi_sysfs: add 'is_bin_visible' callback
      scsi_dh_alua: Update version to 2.0
      scsi_dh: add 'rescan' callback
      scsi_dh_alua: Send TEST UNIT READY to poll for transitioning
      scsi_dh_alua: update all port states
      scsi_dh_alua: Recheck state on unit attention
      scsi_dh_alua: Add new blacklist flag 'BLIST_SYNC_ALUA'
      scsi_dh_alua: Allow workqueue to run synchronously
      scsi_dh_alua: Use workqueue for RTPG
      scsi_dh_alua: remove 'rel_port' from alua_dh_data structure
      scsi_dh_alua: move optimize_stpg evaluation
      revert commit a8e5a2d593cb (" scsi_dh_alua: ALUA handler attach should succeed while TPG is transitioning")
      scsi_dh_alua: simplify alua_initialize()
      scsi_dh_alua: use unique device id
      scsi_dh_alua: Use separate alua_port_group structure
      scsi_dh_alua: allocate RTPG buffer separately
      scsi_dh_alua: switch to scsi_execute_req_flags()
      scsi_dh_alua: call alua_rtpg() if stpg fails
      scsi_dh_alua: Make stpg synchronous
      scsi_dh_alua: separate out alua_stpg()
      scsi_dh_alua: Pass buffer as function argument

Harish Zunjarrao (2):
      qla2xxx: Provide mbx info in BBCR data after mbx failure
      qla2xxx: Add support for Private link statistics counters.

Himanshu Madhani (3):
      qla2xxx: Update driver version to 8.07.00.33-k
      qla2xxx: Enable T10-DIF for ISP27XX
      qla2xxx: Allow fw to hold status before sending ABTS response.

James Bottomley (1):
      MAINTAINERS: use new email address for James Bottomley

Jitendra Bhivare (29):
      be2iscsi: Add lock to protect WRB alloc and free
      be2iscsi: _bh for io_sgl_lock and mgmt_sgl_lock
      be2iscsi: Fix ExpStatSn in management tasks
      be2iscsi: Couple MCC tag and WRB alloc and free
      be2iscsi: Fix MCC WRB leak in open_connection
      be2iscsi: Cleanup processing of BMBX completion
      be2iscsi: Fix be_mcc_compl_poll to use tag_state
      be2iscsi: Remove be_mbox_notify_wait function
      be2iscsi: Rename MCC and BMBX processing functions
      be2iscsi: Remove redundant MCC processing code
      be2iscsi: Use macros for MCC WRB and CQE fields
      be2iscsi: Remove unused mcc_cq_lock
      be2iscsi: Update the driver version
      be2iscsi: Fix WRB leak in login/logout path
      be2iscsi: Fix async link event processing
      be2iscsi: Fix to process 25G link speed info from FW
      scsi_transport_iscsi: Add 25G and 40G speed definition
      be2iscsi: Fix IOPOLL implementation
      be2iscsi: Fix return value for MCC completion
      be2iscsi: Add FW config validation
      be2iscsi: Fix to handle misconfigured optics events
      be2iscsi: Fix VLAN support for IPv6 network
      be2iscsi: Fix to remove shutdown entry point
      be2iscsi: Added return value check for mgmt_get_all_if_id
      be2iscsi: Set mbox timeout to 30s
      be2iscsi: Fix to synchronize tag allocation using spin_lock
      be2iscsi: Fix to use atomic bit operations for tag_state
      be2iscsi: Fix mbox synchronization replacing spinlock with mutex
      be2iscsi: Fix soft lockup in mgmt_get_all_if_id path using bmbx

Joe Carnuccio (2):
      qla2xxx: Avoid side effects when using endianizer macros.
      qla2xxx: Seed init-cb login timeout from nvram exclusively.

Johannes Thumshirn (2):
      lpfc: Add lockdep assertions
      lpfc: Remove redundant code block in lpfc_scsi_cmd_iocb_cmpl

John Garry (32):
      hisi_sas: update driver version to 1.3
      hisi_sas: add hisi_sas_slave_configure()
      hisi_sas: use slot abort in v2 hw
      hisi_sas: use slot abort in v1 hw
      hisi_sas: add hisi_sas_slot_abort()
      hisi_sas: change tmf func complete check
      hisi_sas: update driver version to 1.2
      hisi_sas: add v1 hw ACPI support
      hisi_sas: use Unified Device Properties API
      hisi_sas: update driver version to 1.1
      hisi_sas: add v2 tmf functions
      hisi_sas: add v2 slot error handler
      hisi_sas: add v2 path to send ATA command
      hisi_sas: add v2 code for itct setup and free
      hisi_sas: add v2 code to send smp command
      hisi_sas: add v2 path to send ssp frame
      hisi_sas: add v2 cq interrupt handler
      hisi_sas: add v2 SATA interrupt handler
      hisi_sas: add v2 channel interrupt handler
      hisi_sas: add v2 phy down handler
      hisi_sas: add v2 int init and phy up handler
      hisi_sas: add v2 phy init code
      hisi_sas: add init_id_frame_v2_hw()
      hisi_sas: add v2 hw init
      hisi_sas: add v2 register definitions
      hisi_sas: add bare v2 hw driver
      hisi_sas: rename some fields in hisi_sas_itct
      hisi_sas: add hisi_sas_err_record_v1
      hisi_sas: reduce max itct entries
      hisi_sas: set max commands as configurable
      hisi_sas: relocate DEV_IS_EXPANDER
      devicetree: bindings: hisi_sas: add v2 HW bindings

Jose Castillo (1):
      bnx2fc: Show information about log levels in 'modinfo'

K. Y. Srinivasan (1):
      scsi: storvsc: Fix a build issue reported by kbuild test robot

Kai Makisara (1):
      st: Fix MTMKPART to work with newer drives

Lars-Peter Clausen (2):
      mpt3sas: Remove unnecessary synchronize_irq() before free_irq()
      be2iscsi: Remove unnecessary synchronize_irq() before free_irq()

Lee Duncan (1):
      scsi: Use ida for host number management

Manoj N. Kumar (3):
      cxlflash: Increase cmd_per_lun for better throughput
      cxlflash: Fix to avoid unnecessary scan with internal LUNs
      cxlflash: Simplify PCI registration

Martin K. Petersen (1):
      sd: Fix discard granularity when LBPRZ=1

Matthew R. Ochs (2):
      cxlflash: Simplify attach path error cleanup
      cxlflash: Split out context initialization

Maurizio Lombardi (4):
      be2iscsi: set the boot_kset pointer to NULL in case of failure
      be2iscsi: Fix memory leak in beiscsi_alloc_mem()
      megaraid: fix null pointer check in megasas_detach_one().
      bnx2fc: bnx2fc_eh_abort(): fix wrong return code.

Mike Snitzer (1):
      dm: fix dm_rq_target_io leak on faults with .request_fn DM w/ blk-mq paths

Nicholas Krause (1):
      be2iscsi:Add missing error check in beiscsi_eeh_resume

Raghava Aditya Renukunta (10):
      aacraid: Update driver version
      aacraid: Fix character device re-initialization
      aacraid: Fix AIF triggered IOP_RESET
      aacraid: Created new mutex for ioctl path
      aacraid: Fundamental reset support for Series 7
      aacraid: Set correct msix count for EEH recovery
      aacraid: Fix memory leak in aac_fib_map_free
      aacraid: Added EEH support
      aacraid: Fix RRQ overload
      aacraid: SCSI blk tag support

Sawan Chandak (2):
      qla2xxx: Add support for buffer to buffer credit value for ISP27XX.
      qla2xxx: Add support for online flash update for ISP27XX.

Sudip Mukherjee (5):
      osd: remove deadcode
      imm: check parport_claim
      dpt_i2o: fix build warning
      scsi: ppa: use new parport device model
      scsi: sim710: fix build warning

Suganath Prabu Subramani (1):
      mpt3sas: Added smp_affinity_enable module parameter.

Suganath prabu Subramani (12):
      SCSI: Updating maintainers list for MPT FUSION DRIVERS.
      mpt3sas: Free memory pools before retrying to allocate with different value.
      mpt3sas: Remove cpumask_clear for zalloc_cpumask_var and don't free free_cpu_mask_var before reply_q
      mpt3sas: Updating mpt3sas driver version to 12.100.00.00
      mpt3sas: Fix for Asynchronous completion of timedout IO and task abort of timedout IO.
      mpt3sas: Updated MPI Header to 2.00.42
      mpt3sas: Add support for configurable Chain Frame Size
      mpt3sas: Make use of additional HighPriority credit message frames for sending SCSI IO's
      mpt3sas: Never block the Enclosure device
      mpt3sas: Fix static analyzer(coverity) tool identified defects
      mpt3sas: Used IEEE SGL instead of MPI SGL while framing a SMP Passthrough request message.
      mpt3sas: Added support for high port count HBA variants.

Sumit Saxena (17):
      megaraid_sas: Fix SMAP issue
      megaraid_sas: Fix for IO failing post OCR in SRIOV environment
      megaraid_sas: driver version upgrade
      megaraid_sas: SPERC OCR changes
      megaraid_sas: Introduce module parameter for SCSI command timeout
      megaraid_sas: MFI adapter OCR changes
      megaraid_sas: Make adprecovery variable atomic
      megaraid_sas: IO throttling support
      megaraid_sas: Dual queue depth support
      megaraid_sas: Code optimization build_and_issue_cmd return-type
      megaraid_sas: Reply Descriptor Post Queue (RDPQ) support
      megaraid_sas: Fastpath region lock bypass
      megaraid_sas: Update device queue depth based on interface type
      megaraid_sas: Task management support
      megaraid_sas: Syncing request flags macro names with firmware
      megaraid_sas: MFI IO timeout handling
      megaraid_sas: Do not allow PCI access during OCR

Tomas Henzl (1):
      megaraid_sas: Add an i/o barrier

Tomas Winkler (2):
      scsi: ufs: fix typo in comment
      ufs: fix typo: MAZ to MAX

Tony Lindgren (1):
      mmc: omap_hsmmc: Fix PM regression with deferred probe for pm_runtime_reinit

Tyrel Datwyler (8):
      ibmvfc: byteswap scsi_id, wwpn, and node_name prior to logging
      ibmvscsi: use H_CLOSED instead of magic number
      ibmvscsi: Add endian conversions to sysfs attribute show functions
      ibmvscsi: Remove unsupported host config MAD
      ibmvscsi: Use of_root to access OF device tree root node
      ibmvscsi: Replace magic values in set_adpater_info() with defines
      ibmvscsi: Add and use enums for valid CRQ header values
      ibmvscsi: Correct values for several viosrp_crq_format enums

Uma Krishnan (2):
      cxlflash: Reorder user context initialization
      cxlflash: Unmap problem state area before detaching master context

Usha Ketineni (1):
      fcoe: fix reset of fip selection time.

Vitaly Kuznetsov (1):
      scsi: storvsc: fix SRB_STATUS_ABORTED handling

Yaniv Gardi (14):
      scsi: ufs: add wrapper for retrying sending query attribute
      scsi: ufs: commit descriptors before setting the doorbell
      scsi: ufs: add missing memory barriers
      scsi: ufs: reduce the interrupts for power mode change requests
      scsi: ufs: retry failed query flag requests
      scsi: ufs: fix error recovery after the hibern8 exit failure
      scsi: ufs: add retries for hibern8 enter
      scsi: ufs: add retries to dme_peer get and set attribute
      scsi: ufs: avoid exception event handler racing with PM callbacks
      scsi: ufs: increase fDeviceInit query response timeout
      scsi: ufs: clear outstanding_request bit in case query timeout
      scsi: ufs: verify command tag validity
      scsi: ufs: clear fields UTRD, UPIU req and rsp before new transfers
      scsi: ufs: clear UTRD, UPIU req and rsp before new transfers

jiangyiwen (1):
      SCSI: Free resources when we return BLKPREP_INVALID

And the diffstat:

 .../devicetree/bindings/scsi/hisilicon-sas.txt     |   21 +-
 Documentation/scsi/st.txt                          |   15 +-
 MAINTAINERS                                        |   17 +-
 drivers/md/dm.c                                    |    2 +
 drivers/message/fusion/mptbase.c                   |   42 +-
 drivers/mmc/host/omap_hsmmc.c                      |    2 +
 drivers/scsi/Kconfig                               |    1 +
 drivers/scsi/NCR5380.c                             |  133 +-
 drivers/scsi/aacraid/aachba.c                      |   27 +-
 drivers/scsi/aacraid/aacraid.h                     |   14 +-
 drivers/scsi/aacraid/commctrl.c                    |   13 +-
 drivers/scsi/aacraid/comminit.c                    |    6 +-
 drivers/scsi/aacraid/commsup.c                     |   69 +-
 drivers/scsi/aacraid/dpcsup.c                      |    2 -
 drivers/scsi/aacraid/linit.c                       |  199 +-
 drivers/scsi/aacraid/src.c                         |   30 +-
 drivers/scsi/aha1542.c                             |    3 +
 drivers/scsi/aic7xxx/aic7xxx_osm.c                 |    1 +
 drivers/scsi/arm/acornscsi.c                       |    3 +-
 drivers/scsi/arm/fas216.c                          |    2 +
 drivers/scsi/atari_NCR5380.c                       |  133 +-
 drivers/scsi/be2iscsi/be.h                         |   20 +-
 drivers/scsi/be2iscsi/be_cmds.c                    |  867 ++++----
 drivers/scsi/be2iscsi/be_cmds.h                    |  148 +-
 drivers/scsi/be2iscsi/be_iscsi.c                   |   62 +-
 drivers/scsi/be2iscsi/be_main.c                    |  313 +--
 drivers/scsi/be2iscsi/be_main.h                    |   25 +-
 drivers/scsi/be2iscsi/be_mgmt.c                    |  573 ++---
 drivers/scsi/be2iscsi/be_mgmt.h                    |    2 +
 drivers/scsi/bfa/bfa_core.c                        |   19 +
 drivers/scsi/bfa/bfa_cs.h                          |   41 +-
 drivers/scsi/bfa/bfa_ioc.c                         |    2 +-
 drivers/scsi/bnx2fc/bnx2fc_fcoe.c                  |    9 +
 drivers/scsi/bnx2fc/bnx2fc_io.c                    |    5 +-
 drivers/scsi/cxlflash/common.h                     |    8 +-
 drivers/scsi/cxlflash/main.c                       |   72 +-
 drivers/scsi/cxlflash/superpipe.c                  |  195 +-
 drivers/scsi/cxlflash/superpipe.h                  |    1 +
 drivers/scsi/device_handler/Kconfig                |    8 +-
 drivers/scsi/device_handler/scsi_dh_alua.c         |  979 ++++++---
 drivers/scsi/device_handler/scsi_dh_emc.c          |    7 +-
 drivers/scsi/device_handler/scsi_dh_rdac.c         |   38 +-
 drivers/scsi/dpt_i2o.c                             |    3 +
 drivers/scsi/esas2r/esas2r_ioctl.c                 |    5 +-
 drivers/scsi/fcoe/fcoe_ctlr.c                      |    3 +-
 drivers/scsi/fdomain.c                             |    2 +-
 drivers/scsi/gdth.c                                |    7 +-
 drivers/scsi/gdth_proc.c                           |   11 +-
 drivers/scsi/hisi_sas/Makefile                     |    2 +-
 drivers/scsi/hisi_sas/hisi_sas.h                   |   43 +-
 drivers/scsi/hisi_sas/hisi_sas_main.c              |  136 +-
 drivers/scsi/hisi_sas/hisi_sas_v1_hw.c             |  100 +-
 drivers/scsi/hisi_sas/hisi_sas_v2_hw.c             | 2214 ++++++++++++++++++++
 drivers/scsi/hosts.c                               |   22 +-
 drivers/scsi/hpsa.c                                |   52 +-
 drivers/scsi/hpsa.h                                |    3 +-
 drivers/scsi/hpsa_cmd.h                            |    5 +-
 drivers/scsi/ibmvscsi/ibmvfc.c                     |    3 +-
 drivers/scsi/ibmvscsi/ibmvscsi.c                   |  122 +-
 drivers/scsi/ibmvscsi/viosrp.h                     |   26 +-
 drivers/scsi/imm.c                                 |    7 +-
 drivers/scsi/ipr.c                                 |    5 +
 drivers/scsi/lpfc/lpfc_debugfs.c                   |    4 +-
 drivers/scsi/lpfc/lpfc_hbadisc.c                   |    5 +
 drivers/scsi/lpfc/lpfc_scsi.c                      |   17 -
 drivers/scsi/lpfc/lpfc_sli.c                       |   43 +
 drivers/scsi/megaraid/megaraid_sas.h               |  351 +++-
 drivers/scsi/megaraid/megaraid_sas_base.c          | 1064 ++++++----
 drivers/scsi/megaraid/megaraid_sas_fp.c            |    2 +
 drivers/scsi/megaraid/megaraid_sas_fusion.c        | 1287 +++++++++---
 drivers/scsi/megaraid/megaraid_sas_fusion.h        |  136 +-
 drivers/scsi/mpt3sas/mpi/mpi2.h                    |   82 +-
 drivers/scsi/mpt3sas/mpi/mpi2_cnfg.h               |  127 +-
 drivers/scsi/mpt3sas/mpi/mpi2_init.h               |   22 +-
 drivers/scsi/mpt3sas/mpi/mpi2_ioc.h                |  117 +-
 drivers/scsi/mpt3sas/mpi/mpi2_raid.h               |    5 +-
 drivers/scsi/mpt3sas/mpi/mpi2_sas.h                |   10 +-
 drivers/scsi/mpt3sas/mpi/mpi2_tool.h               |    5 +-
 drivers/scsi/mpt3sas/mpi/mpi2_type.h               |    5 +-
 drivers/scsi/mpt3sas/mpt3sas_base.c                |  153 +-
 drivers/scsi/mpt3sas/mpt3sas_base.h                |   47 +-
 drivers/scsi/mpt3sas/mpt3sas_ctl.c                 |   37 +-
 drivers/scsi/mpt3sas/mpt3sas_scsih.c               |  272 ++-
 drivers/scsi/mpt3sas/mpt3sas_transport.c           |   25 +-
 drivers/scsi/mvumi.c                               |    4 +-
 drivers/scsi/osd/osd_initiator.c                   |    3 +-
 drivers/scsi/ppa.c                                 |   46 +-
 drivers/scsi/qla2xxx/qla_attr.c                    |   22 +-
 drivers/scsi/qla2xxx/qla_bsg.c                     |  201 ++
 drivers/scsi/qla2xxx/qla_bsg.h                     |   34 +
 drivers/scsi/qla2xxx/qla_dbg.c                     |  146 +-
 drivers/scsi/qla2xxx/qla_def.h                     |   56 +-
 drivers/scsi/qla2xxx/qla_fw.h                      |   14 +-
 drivers/scsi/qla2xxx/qla_gbl.h                     |    2 +
 drivers/scsi/qla2xxx/qla_init.c                    |  119 +-
 drivers/scsi/qla2xxx/qla_inline.h                  |    4 +-
 drivers/scsi/qla2xxx/qla_isr.c                     |    4 -
 drivers/scsi/qla2xxx/qla_mbx.c                     |   27 +-
 drivers/scsi/qla2xxx/qla_os.c                      |   10 +
 drivers/scsi/qla2xxx/qla_sup.c                     |   70 +-
 drivers/scsi/qla2xxx/qla_version.h                 |    2 +-
 drivers/scsi/qla4xxx/ql4_83xx.c                    |    6 +-
 drivers/scsi/qlogicpti.c                           |    4 +-
 drivers/scsi/scsi_devinfo.c                        |    2 +
 drivers/scsi/scsi_lib.c                            |    2 +
 drivers/scsi/scsi_scan.c                           |   23 +-
 drivers/scsi/scsi_sysfs.c                          |  106 +-
 drivers/scsi/scsi_transport_iscsi.c                |    2 +
 drivers/scsi/sd.c                                  |    2 +-
 drivers/scsi/sg.c                                  |    3 +-
 drivers/scsi/sim710.c                              |    3 +-
 drivers/scsi/snic/snic_ctl.c                       |    2 +-
 drivers/scsi/st.c                                  |  122 +-
 drivers/scsi/stex.c                                |  153 +-
 drivers/scsi/storvsc_drv.c                         |    5 +-
 drivers/scsi/ufs/ufs.h                             |    2 +-
 drivers/scsi/ufs/ufshcd.c                          |  397 +++-
 drivers/scsi/ufs/ufshcd.h                          |    6 +-
 include/scsi/iscsi_if.h                            |    2 +
 include/scsi/scsi_device.h                         |    3 +
 include/scsi/scsi_devinfo.h                        |    1 +
 include/scsi/scsi_dh.h                             |    2 +
 include/scsi/scsi_proto.h                          |   12 +
 123 files changed, 9181 insertions(+), 3159 deletions(-)
 create mode 100644 drivers/scsi/hisi_sas/hisi_sas_v2_hw.c

James
