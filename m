From: James Bottomley <James.Bottomley@HansenPartnership.com>
Subject: [GIT PULL] first round of SCSI updates for the 5.0+ merge window
Date: Wed, 06 Mar 2019 22:29:46 -0800
Message-ID: <1551940186.8289.60.camel@HansenPartnership.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner@vger.kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
To: Andrew Morton <akpm@linux-foundation.org>, Linus Torvalds <torvalds@linux-foundation.org>
Cc: linux-scsi <linux-scsi@vger.kernel.org>, linux-kernel <linux-kernel@vger.kernel.org>
List-Id: linux-scsi@vger.kernel.org

This is mostly update of the usual drivers: arcmsr, qla2xxx, lpfc,
hisi_sas, target/iscsi and target/core.  Additionally Christoph
refactored gdth as part of the dma changes.  The major mid-layer change
this time is the removal of bidi commands and with them the whole of
the osd/exofs driver and filesystem.  This is a major simplification
for block and mq in particular.

Additionally, there are four existing and one potential conflict:

- The unpulled block tree updates the removed osd driver

- 750afb08ca71 cross-tree: phase out dma_zalloc_coherent() conflicts
with the arcmsr update.  The fix is simple: go with our version

The remaining conflicts are internal between updates we supplied in our
fixes branches and changes made to the misc branch:

- hisi_sas_v3_hw.c: This is the nastiest: the fix to move the
protection parameters (7bb25a89aad2) conflicts with the DIX feature
addition (b3cce125cb1e).  The resolution is to make sure the DIX
enablement follows the move of the prot_mask check in
hisi_sas_v3_probe().

- lpfc_nvme.c: the fix to avoid hang/use after free (7961cba6f7d8)
conflicts with moving the stats to HW queue structures (4c47efc140fa). 
The resolution a simple combination of both patches.

- qla_init.c: The fix for the panic after free (388a49959ee4) conflicts
with move marker behind QPair (9eb9c6dc3ab0).  The fix is a straight
combination plus the transformation of sp->fcport->loop_id to fcport-
>loop_id to preserve the panic fix.

I've put the resolution in the linus-resolved branch of the scsi tree
for you to see and also attached the --cc diff below.

The patch is available here:

git://git.kernel.org/pub/scm/linux/kernel/git/jejb/scsi.git scsi-misc

The short changelog is:

Anil Gurumurthy (1):
      scsi: qla2xxx: Add support for setting port speed

Avri Altman (4):
      scsi: ufs-bsg: Allow reading descriptors
      scsi: ufs: Allow reading descriptor via raw upiu
      scsi: ufs-bsg: Change the calling convention for write descriptor
      scsi: clean obsolete return values of eh_timed_out

Bart Van Assche (27):
      scsi: core: Move resid from scsi_data_buffer to scsi_cmnd
      scsi: sd: Remove superfluous residual assignments
      scsi: uas: Use scsi_[gs]et_resid() where appropriate
      scsi: scsi_debug: Use scsi_[gs]et_resid() where appropriate
      scsi: libiscsi: Use scsi_[gs]et_resid() where appropriate
      scsi: scsi_debug: Fix a recently introduced regression
      scsi: target/iscsi: Simplify iscsit_handle_text_cmd()
      scsi: target/iscsi: Simplify iscsit_dump_data_payload()
      scsi: target/iscsi: Avoid iscsit_release_commands_from_conn() deadlock
      scsi: target/iscsi: Rename a function and a function pointer
      scsi: target/iscsi: Fix spelling of "unsolicited"
      scsi: target/iscsi: Convert comments about locking into runtime checks
      scsi: target/iscsi: Remove an incorrect comment
      scsi: RDMA/srpt: Fix a credit leak for aborted commands
      scsi: RDMA/srpt: Rework I/O context allocation
      scsi: RDMA/srpt: Fix handling of TMF submission failure
      scsi: RDMA/srpt: Fix handling of command / TMF submission failure
      scsi: target/core: Add target_send_busy()
      scsi: target/core: Inline transport_lun_remove_cmd()
      scsi: target/core: Simplify the LUN RESET implementation
      scsi: target/core: Remove several state tests from the TMF code
      scsi: target/core: Remove the write_pending_status() callback function
      scsi: sd: Protect against READ(6) or WRITE(6) with zero block transfer length
      scsi: libsas: Remove scsi_to_u32()
      scsi: core: Remove an atomic instruction from the hot path
      scsi: sd: Rename 'SCpnt' into 'cmd'
      scsi: sd: Remove a local variable

Benjamin Block (1):
      scsi: core: replace GFP_ATOMIC with GFP_KERNEL in scsi_scan.c

Bill Kuzeja (1):
      scsi: qla2xxx: Move debug messages before sending srb preventing panic

Chengguang Xu (1):
      scsi: ufs: fix a typo in comment

Ching Huang (15):
      scsi: arcmsr: Update driver version to v1.40.00.10-20190116
      scsi: arcmsr: Fix suspend/resume of ACB_ADAPTER_TYPE_B part 2
      scsi: arcmsr: Use dma_alloc_coherent to replace dma_zalloc_coherent
      scsi: arcmsr: Update driver version to v1.40.00.10-20181217
      scsi: arcmsr: Fix suspend/resume of ACB_ADAPTER_TYPE_B
      scsi: arcmsr: Separate 'set dma mask' as a function
      scsi: arcmsr: Add an option of set dma_mask_64 for ACB_ADAPTER_TYPE_A
      scsi: arcmsr: Update ACB_ADAPTER_TYPE_D for >4GB ccb addressing
      scsi: arcmsr: Update ACB_ADAPTER_TYPE_C for >4GB ccb addressing
      scsi: arcmsr: Update ACB_ADAPTER_TYPE_B for >4GB ccb addressing
      scsi: arcmsr: Update ACB_ADAPTER_TYPE_A for >4GB ccb addressing
      scsi: arcmsr: Update arcmsr_alloc_ccb_pool for ccb buffer address above 4GB
      scsi: arcmsr: Merge arcmsr_alloc_io_queue to arcmsr_alloc_ccb_pool
      scsi: arcmsr: Rename arcmsr_free_mu to arcmsr_free_io_queue
      scsi: arcmsr: Rename acb structure member roundup_ccbsize to ioqueue_size

Christoph Hellwig (18):
      scsi: block: remove bidi support
      scsi: block: remove req->special
      scsi: stop setting up request->special
      scsi: remove bidirectional command support
      scsi: remove the SCSI OSD library
      scsi: fs: remove exofs
      scsi: bsg-lib: handle bidi requests without block layer help
      scsi: bsg: refactor bsg_ioctl
      scsi: gdth: use generic DMA API
      scsi: gdth: remove interrupt coalescing support
      scsi: gdth: remove dead code under #ifdef GDTH_IOCTL_PROC
      scsi: gdth: remove dead dma statistics code
      scsi: gdth: remove dead rtc code
      scsi: gdth: remove direct serial port access
      scsi: gdth: remove ISA and EISA support
      scsi: gdth: remove gdth_{alloc,free}_ioctl
      scsi: gdth: reuse dma coherent allocation in gdth_show_info
      scsi: gdth: refactor ioc_general

Colin Ian King (5):
      scsi: qla2xxx: remove redundant null check on pointer sess
      scsi: lpfc: fix a handful of indentation issues
      scsi: aacraid: clean up some indentation and formatting issues
      scsi: hpsa: clean up two indentation issues
      scsi: bnx2i: fix indentation issue, remove a tab

Damien Le Moal (1):
      scsi: sd: Improve sd_print_capacity()

Dan Carpenter (1):
      scsi: lpfc: Fix error code if kcalloc() fails

Darren Trapp (1):
      scsi: qla2xxx: Add First Burst support for FC-NVMe devices

Dietmar Hahn (1):
      scsi: sd: Fix typo in sd_first_printk()

Douglas Anderson (1):
      scsi: dt-bindings: ufs: Fix the compatible string definition

Evan Green (1):
      scsi: ufs: Remove select of phy-qcom-ufs from ufs-qcom

Giridhar Malavali (4):
      scsi: qla2xxx: Avoid PCI IRQ affinity mapping when multiqueue is not supported
      scsi: qla2xxx: Fix SRB allocation flag to avoid sleeping in IRQ context
      scsi: qla2xxx: Add new FC-NVMe enable BIT to enable FC-NVMe feature
      scsi: qla2xxx: Fix DMA error when the DIF sg buffer crosses 4GB boundary

Greg Kroah-Hartman (9):
      scsi: qla2xxx: no need to check return value of debugfs_create functions
      scsi: qedf: no need to check return value of debugfs_create functions
      scsi: lpfc: no need to check return value of debugfs_create functions
      scsi: snic: no need to check return value of debugfs_create functions
      scsi: fnic: no need to check return value of debugfs_create functions
      scsi: csiostor: no need to check return value of debugfs_create functions
      scsi: bfa: no need to check return value of debugfs_create functions
      scsi: fcoe: remove unneeded fcoe_ctlr_destroy_store export
      scsi: fcoe: convert to use BUS_ATTR_WO

Gustavo A. R. Silva (9):
      scsi: mpt3sas: Add missing breaks in switch statements
      scsi: aacraid: Fix missing break in switch statement
      scsi: aic7xxx: aic79xx: mark expected switch fall-through
      scsi: bfa: bfa_ioc: Mark expected switch fall-throughs
      scsi: bfa: bfa_fcs_rport: Mark expected switch fall-throughs
      scsi: bfa: bfa_fcs_lport: Mark expected switch fall-throughs
      scsi: esas2r: esas2r_init: mark expected switch fall-throughs
      scsi: st: mark expected switch fall-throughs
      scsi: qla4xxx: ql4_os: mark expected switch fall-through

Hannes Reinecke (4):
      scsi: kill command serial number
      scsi: csiostor: drop serial_number usage
      scsi: mvumi: use request tag instead of serial_number
      scsi: dpt_i2o: remove serial number usage

Himanshu Madhani (7):
      scsi: qla2xxx: Update driver version to 10.00.00.14-k
      scsi: qla2xxx: Fix code indentation for qla27xx_fwdt_entry
      scsi: qla2xxx: Check for FW started flag before aborting
      scsi: qla2xxx: Fix unload when NVMe devices are configured
      scsi: qla2xxx: Fix LUN discovery if loop id is not assigned yet by firmware
      scsi: qla2xxx: Update driver version to 10.00.00.13-k
      scsi: qla2xxx: Fix N2N target discovery with Local loop

Iustin Pop (1):
      scsi: st: osst: Remove negative constant left-shifts

James Smart (26):
      scsi: lpfc: Update lpfc version to 12.2.0.0
      scsi: lpfc: Update 12.2.0.0 file copyrights to 2019
      scsi: lpfc: Fix nvmet issues when link bounce under IO load
      scsi: lpfc: Correct upcalling nvmet_fc transport during io done downcall
      scsi: lpfc: Fix default driver parameter collision for allowing NPIV support
      scsi: lpfc: Rework locking on SCSI io completion
      scsi: lpfc: Enable SCSI and NVME fc4s by default
      scsi: lpfc: Resize cpu maps structures based on possible cpus
      scsi: lpfc: Utilize new IRQ API when allocating MSI-X vectors
      scsi: lpfc: Rework EQ/CQ processing to address interrupt coalescing
      scsi: lpfc: cleanup: convert eq_delay to usdelay
      scsi: lpfc: Support non-uniform allocation of MSIX vectors to hardware queues
      scsi: lpfc: Fix setting affinity hints to correlate with hardware queues
      scsi: lpfc: Allow override of hardware queue selection policies
      scsi: lpfc: Adapt partitioned XRI lists to efficient sharing
      scsi: lpfc: Synchronize hardware queues with SCSI MQ interface
      scsi: lpfc: Convert ring number to hardware queue for nvme wqe posting.
      scsi: lpfc: Move SCSI and NVME Stats to hardware queue structures
      scsi: lpfc: Adapt cpucheck debugfs logic to Hardware Queues
      scsi: lpfc: cleanup: Remove unused FCP_XRI_ABORT_EVENT slowpath event
      scsi: lpfc: Partition XRI buffer list across Hardware Queues
      scsi: lpfc: Replace io_channels for nvme and fcp with general hdw_queues per cpu
      scsi: lpfc: Remove extra vector and SLI4 queue for Expresslane
      scsi: lpfc: Implement common IO buffers between NVME and SCSI
      scsi: lpfc: cleanup: Remove excess check on NVME io submit code path
      scsi: lpfc: cleanup: remove nrport from nvme command structure

Jason Yan (1):
      scsi: megaraid_sas: return error when create DMA pool failed

Joao Pinto (1):
      scsi: MAINTAINERS: Update dwc driver maintainer to Pedro Sousa

Joe Carnuccio (1):
      scsi: qla2xxx: Add new FW dump template entry types

Johannes Thumshirn (1):
      scsi: MAINTAINERS: Move FCoE to Hannes Reinecke

John Garry (11):
      scsi: hisi_sas: Do some more tidy-up
      scsi: hisi_sas: Issue internal abort on all relevant queues
      scsi: hisi_sas: Add missing seq_printf() call in hisi_sas_show_row_32()
      scsi: hisi_sas: Fix to only call scsi_get_prot_op() for non-NULL scsi_cmnd
      scsi: hisi_sas: Some misc tidy-up
      scsi: hisi_sas: Fix type casting and missing static qualifier in debugfs code
      scsi: hisi_sas: No need to check return value of debugfs_create functions
      scsi: libsas: Support SATA PHY connection rate unmatch fixing during discovery
      scsi: libsas: Check SMP PHY control function result
      scsi: libsas: Fix some indentation in libsas.h
      scsi: sd: Make protection lookup tables static and relocate functions

Luo Jiaxing (12):
      scsi: hisi_sas: Add manual trigger for debugfs dump
      scsi: hisi_sas: Correct memory allocation size for DQ debugfs
      scsi: hisi_sas: Reject setting programmed minimum linkrate > 1.5G
      scsi: hisi_sas: Add debugfs ITCT file and add file operations
      scsi: hisi_sas: Add debugfs IOST file and add file operations
      scsi: hisi_sas: Add debugfs DQ file and add file operations
      scsi: hisi_sas: Add debugfs CQ file and add file operations
      scsi: hisi_sas: Add debugfs for port registers
      scsi: hisi_sas: Debugfs global register create file and add file operations
      scsi: hisi_sas: Take debugfs snapshot for all regs
      scsi: hisi_sas: Alloc debugfs snapshot buffer memory for all registers
      scsi: hisi_sas: Create root and device debugfs directories

Manivannan Sadhasivam (2):
      scsi: ufs: Add HI3670 SoC UFS driver support
      scsi: dt-bindings: ufs: Add HI3670 UFS controller binding

Marc Gonzalez (3):
      scsi: ufs: Remove unused device quirks
      Revert "scsi: ufs: disable vccq if it's not needed by UFS device"
      scsi: MAINTAINERS: Add reviewers for UFS patches

Martin K. Petersen (8):
      scsi: sd: Optimal I/O size should be a multiple of physical block size
      scsi: MAINTAINERS: SCSI initiator and target tweaks
      scsi: scsi_debug: Implement support for write protect
      scsi: sd: Clean up sd_setup_read_write_cmnd()
      scsi: sd: Create helper functions for read/write commands
      scsi: sd: Simplify misaligned I/O check
      scsi: sd: Be consistent about blocks vs. sectors
      scsi: qla2xxx: Add protection mask module parameters

Masahiro Yamada (2):
      scsi: prefix header search paths with $(srctree)/
      scsi: remove unneeded header search paths

Nathan Chancellor (3):
      scsi: ata: Use unsigned int for cmd's type in ioctls in scsi_host_template
      scsi: pcmcia: nsp_cs: Remove unnecessary parentheses
      scsi: nsp32: Remove unnecessary self assignment in nsp32_set_sync_entry

Otto Sabart (1):
      scsi: doc: remove reference to tmscsim.txt file

Quinn Tran (12):
      scsi: qla2xxx: Move marker request behind QPair
      scsi: qla2xxx: Prevent SysFS access when chip is down
      scsi: qla2xxx: Prevent multiple ADISC commands per session
      scsi: qla2xxx: Use complete switch scan for RSCN events
      scsi: qla2xxx: Fix fw options handle eh_bus_reset()
      scsi: qla2xxx: Prevent memory leak for CT req/rsp allocation
      scsi: qla2xxx: allow session delete to finish before create.
      scsi: qla2xxx: fix fcport null pointer access.
      scsi: qla2xxx: flush IO on chip reset or sess delete
      scsi: qla2xxx: Fix session cleanup hang
      scsi: qla2xxx: Change default ZIO threshold.
      scsi: qla2xxx: Add pci function reset support.

Rob Herring (1):
      scsi: qlogicpti: Use of_node_name_eq for node name comparisons

Satish Kharat (16):
      scsi: fnic: Update fnic driver version to 1.6.0.47
      scsi: fnic: Enable fnic devcmd2 interface
      scsi: fnic: Adding devcmd2 init and posting interfaces
      scsi: fnic: Add devcmd2 initialization helpers
      scsi: fnic: fnic devcmd2 controller definitions
      scsi: fnic: fnic devcmd2 interface definitions
      scsi: fnic: Impose upper limit on max. # of CQs processed per intr
      scsi: fnic: RQ enable and then post descriptors
      scsi: fnic: delaying vnic dev enable till after req intr
      scsi: fnic: Warn when calling done for IO not issued to fw
      scsi: fnic: fnic stats for max CQs processed and ISR time
      scsi: fnic: Add port speed stat to fnic debug stats
      scsi: fnic: use fnic_lock to guard fnic->state_flags
      scsi: fnic: vnic_rq_clean change BUG_ON to WARN_ON
      scsi: fnic: change fnic queue depth to 256
      scsi: fnic: support to display 20G port speed

Sawan Chandak (1):
      scsi: qla2xxx: Restore FAWWPN of Physical Port only for loop down

Sedat Dilek (1):
      scsi: fcoe: make use of fip_mode enum complete

Shivasharan S (5):
      scsi: megaraid_sas: driver version update
      scsi: megaraid_sas: Update structures for HOST_DEVICE_LIST DCMD
      scsi: megaraid_sas: Add support for DEVICE_LIST DCMD in driver
      scsi: megaraid_sas: Rework device add code in AEN path
      scsi: megaraid_sas: Rework code to get PD and LD list

Stanley Chu (1):
      scsi: ufs: Print uic error history in time order

Suganath Prabu S (4):
      scsi: mpt3sas: Update driver version to 27.102.00.00
      scsi: mpt3sas: Add support for ATLAS PCIe switch
      scsi: mpt3sas: Add support for NVMe Switch Adapter
      scsi: mpt3sas: Rename mpi endpoint device ID macro.

Varun Prakash (2):
      scsi: cxgb4i: validate tcp sequence number only if chip version <= T5
      scsi: cxgb4i: get pf number from lldi->pf

Xiang Chen (7):
      scsi: hisi_sas: Use pci_irq_get_affinity() for v3 hw as experimental
      scsi: hisi_sas: change queue depth from 512 to 4096
      scsi: hisi_sas: Add support for DIX feature for v3 hw
      scsi: hisi_sas: Remove unused parameter of function hisi_sas_alloc()
      scsi: hisi_sas: remove the check of sas_dev status in hisi_sas_I_T_nexus_reset()
      scsi: hisi_sas: shutdown axi bus to avoid exception CQ returned
      scsi: hisi_sas: send primitive NOTIFY to SSP situation only

Xiaofei Tan (1):
      scsi: hisi_sas: Fix losing directly attached disk when hot-plug

YueHaibing (4):
      scsi: megaraid_sas: Remove a bunch of set but not used variables
      scsi: lpfc: Remove set but not used variable 'phys_id'
      scsi: csiostor: Remove set but not used variable 'pln'
      scsi: fnic: Remove set but not used variable 'vdev'

And the diffstat:

 Documentation/devicetree/bindings/ufs/ufs-hisi.txt |    5 +-
 .../devicetree/bindings/ufs/ufshcd-pltfrm.txt      |   13 +-
 Documentation/filesystems/exofs.txt                |  185 --
 Documentation/scsi/osd.txt                         |  197 --
 Documentation/scsi/ufs.txt                         |   11 +
 Documentation/target/tcm_mod_builder.py            |    8 -
 MAINTAINERS                                        |   40 +-
 block/blk-mq-debugfs.c                             |    1 -
 block/blk-mq.c                                     |    4 -
 block/bsg-lib.c                                    |   44 +-
 block/bsg.c                                        |  190 +-
 drivers/ata/libata-scsi.c                          |    5 +-
 drivers/infiniband/ulp/isert/ib_isert.c            |    2 +-
 drivers/infiniband/ulp/srpt/ib_srpt.c              |   80 +-
 drivers/infiniband/ulp/srpt/ib_srpt.h              |    4 -
 drivers/scsi/Kconfig                               |    6 +-
 drivers/scsi/Makefile                              |    1 -
 drivers/scsi/aacraid/Makefile                      |    2 -
 drivers/scsi/aacraid/aachba.c                      |    2 +-
 drivers/scsi/aacraid/aacraid.h                     |    4 +-
 drivers/scsi/aacraid/commctrl.c                    |    2 +-
 drivers/scsi/aacraid/commsup.c                     |   30 +-
 drivers/scsi/aacraid/linit.c                       |    9 +-
 drivers/scsi/aacraid/src.c                         |    2 +-
 drivers/scsi/aic7xxx/Makefile                      |    1 -
 drivers/scsi/aic7xxx/aic79xx_core.c                |   14 +-
 drivers/scsi/arcmsr/arcmsr.h                       |   13 +-
 drivers/scsi/arcmsr/arcmsr_hba.c                   |  336 ++-
 drivers/scsi/bfa/bfa_fcs_lport.c                   |    8 +-
 drivers/scsi/bfa/bfa_fcs_rport.c                   |   19 +-
 drivers/scsi/bfa/bfa_ioc.c                         |    9 +-
 drivers/scsi/bfa/bfad_debugfs.c                    |   18 -
 drivers/scsi/bnx2fc/bnx2fc_fcoe.c                  |    2 +-
 drivers/scsi/bnx2i/bnx2i_iscsi.c                   |    2 +-
 drivers/scsi/csiostor/csio_attr.c                  |    3 -
 drivers/scsi/csiostor/csio_init.c                  |    6 +-
 drivers/scsi/csiostor/csio_scsi.c                  |    8 +-
 drivers/scsi/cxgbi/Makefile                        |    2 +-
 drivers/scsi/cxgbi/cxgb4i/cxgb4i.c                 |    6 +-
 drivers/scsi/cxgbi/libcxgbi.c                      |   13 +-
 drivers/scsi/cxlflash/common.h                     |    3 +-
 drivers/scsi/cxlflash/main.c                       |    2 +-
 drivers/scsi/cxlflash/superpipe.c                  |   12 +-
 drivers/scsi/dpt_i2o.c                             |   73 +-
 drivers/scsi/esas2r/esas2r.h                       |    4 +-
 drivers/scsi/esas2r/esas2r_init.c                  |    3 +-
 drivers/scsi/esas2r/esas2r_ioctl.c                 |   16 +-
 drivers/scsi/esas2r/esas2r_main.c                  |    2 +-
 drivers/scsi/fcoe/fcoe.c                           |    2 +-
 drivers/scsi/fcoe/fcoe_ctlr.c                      |    7 +-
 drivers/scsi/fcoe/fcoe_sysfs.c                     |   15 +-
 drivers/scsi/fcoe/fcoe_transport.c                 |    3 +-
 drivers/scsi/fnic/fnic.h                           |    6 +-
 drivers/scsi/fnic/fnic_debugfs.c                   |   88 +-
 drivers/scsi/fnic/fnic_fcs.c                       |   10 +
 drivers/scsi/fnic/fnic_io.h                        |    3 +-
 drivers/scsi/fnic/fnic_isr.c                       |    6 +-
 drivers/scsi/fnic/fnic_main.c                      |   37 +-
 drivers/scsi/fnic/fnic_scsi.c                      |   40 +-
 drivers/scsi/fnic/fnic_stats.h                     |    6 +-
 drivers/scsi/fnic/fnic_trace.c                     |   28 +-
 drivers/scsi/fnic/fnic_trace.h                     |    4 +-
 drivers/scsi/fnic/vnic_dev.c                       |  270 ++-
 drivers/scsi/fnic/vnic_dev.h                       |    2 +
 drivers/scsi/fnic/vnic_devcmd.h                    |  160 +-
 drivers/scsi/fnic/vnic_resource.h                  |    7 +
 drivers/scsi/fnic/vnic_rq.c                        |    5 +-
 drivers/scsi/fnic/vnic_wq.c                        |   69 +-
 drivers/scsi/fnic/vnic_wq.h                        |    8 +
 drivers/scsi/gdth.c                                | 1286 ++---------
 drivers/scsi/gdth.h                                |   30 -
 drivers/scsi/gdth_ioctl.h                          |   89 -
 drivers/scsi/gdth_proc.c                           |  113 +-
 drivers/scsi/gdth_proc.h                           |    3 -
 drivers/scsi/hisi_sas/hisi_sas.h                   |  110 +-
 drivers/scsi/hisi_sas/hisi_sas_main.c              |  838 ++++++-
 drivers/scsi/hisi_sas/hisi_sas_v1_hw.c             |    6 +-
 drivers/scsi/hisi_sas/hisi_sas_v2_hw.c             |   25 +-
 drivers/scsi/hisi_sas/hisi_sas_v3_hw.c             |  379 +++-
 drivers/scsi/hpsa.c                                |   19 +-
 drivers/scsi/ibmvscsi_tgt/ibmvscsi_tgt.c           |    6 -
 drivers/scsi/ipr.c                                 |    3 +-
 drivers/scsi/iscsi_tcp.c                           |    9 +-
 drivers/scsi/libiscsi.c                            |   64 +-
 drivers/scsi/libiscsi_tcp.c                        |    8 +-
 drivers/scsi/libsas/sas_expander.c                 |   38 +-
 drivers/scsi/libsas/sas_scsi_host.c                |    2 +-
 drivers/scsi/lpfc/lpfc.h                           |   97 +-
 drivers/scsi/lpfc/lpfc_attr.c                      |  469 ++--
 drivers/scsi/lpfc/lpfc_bsg.c                       |    4 +-
 drivers/scsi/lpfc/lpfc_crtn.h                      |   36 +-
 drivers/scsi/lpfc/lpfc_ct.c                        |   18 +-
 drivers/scsi/lpfc/lpfc_debugfs.c                   | 1227 ++++++----
 drivers/scsi/lpfc/lpfc_debugfs.h                   |   73 +-
 drivers/scsi/lpfc/lpfc_els.c                       |    6 +-
 drivers/scsi/lpfc/lpfc_hbadisc.c                   |   40 +-
 drivers/scsi/lpfc/lpfc_hw4.h                       |   16 +-
 drivers/scsi/lpfc/lpfc_init.c                      | 2274 ++++++++++---------
 drivers/scsi/lpfc/lpfc_mbox.c                      |    4 +-
 drivers/scsi/lpfc/lpfc_nportdisc.c                 |   10 +-
 drivers/scsi/lpfc/lpfc_nvme.c                      |  746 ++----
 drivers/scsi/lpfc/lpfc_nvme.h                      |   66 +-
 drivers/scsi/lpfc/lpfc_nvmet.c                     |  448 ++--
 drivers/scsi/lpfc/lpfc_nvmet.h                     |    4 +-
 drivers/scsi/lpfc/lpfc_scsi.c                      |  894 +++-----
 drivers/scsi/lpfc/lpfc_scsi.h                      |   63 +-
 drivers/scsi/lpfc/lpfc_sli.c                       | 2379 +++++++++++++-------
 drivers/scsi/lpfc/lpfc_sli.h                       |   89 +-
 drivers/scsi/lpfc/lpfc_sli4.h                      |  304 ++-
 drivers/scsi/lpfc/lpfc_version.h                   |    4 +-
 drivers/scsi/lpfc/lpfc_vport.c                     |   27 +-
 drivers/scsi/megaraid/megaraid_sas.h               |   54 +-
 drivers/scsi/megaraid/megaraid_sas_base.c          |  404 +++-
 drivers/scsi/megaraid/megaraid_sas_fusion.c        |   27 +-
 drivers/scsi/megaraid/megaraid_sas_fusion.h        |    1 +
 drivers/scsi/mpt3sas/mpi/mpi2_cnfg.h               |    3 +-
 drivers/scsi/mpt3sas/mpt3sas_base.c                |    4 +
 drivers/scsi/mpt3sas/mpt3sas_base.h                |    7 +-
 drivers/scsi/mpt3sas/mpt3sas_scsih.c               |   16 +-
 drivers/scsi/mvumi.c                               |    5 +-
 drivers/scsi/nsp32.c                               |    1 -
 drivers/scsi/osd/Kbuild                            |   20 -
 drivers/scsi/osd/Kconfig                           |   49 -
 drivers/scsi/osd/osd_debug.h                       |   30 -
 drivers/scsi/osd/osd_initiator.c                   | 2076 -----------------
 drivers/scsi/osd/osd_uld.c                         |  571 -----
 drivers/scsi/osst.c                                |    2 +-
 drivers/scsi/pcmcia/Makefile                       |    2 +-
 drivers/scsi/pcmcia/nsp_cs.c                       |    3 +-
 drivers/scsi/qedf/qedf_debugfs.c                   |   18 +-
 drivers/scsi/qedf/qedf_io.c                        |    6 -
 drivers/scsi/qedf/qedf_main.c                      |    2 +-
 drivers/scsi/qedi/qedi_debugfs.c                   |   17 +-
 drivers/scsi/qedi/qedi_fw.c                        |    7 -
 drivers/scsi/qla2xxx/qla_attr.c                    |  113 +-
 drivers/scsi/qla2xxx/qla_def.h                     |   43 +-
 drivers/scsi/qla2xxx/qla_dfs.c                     |   43 +-
 drivers/scsi/qla2xxx/qla_gbl.h                     |    8 +-
 drivers/scsi/qla2xxx/qla_gs.c                      |   77 +-
 drivers/scsi/qla2xxx/qla_init.c                    |  198 +-
 drivers/scsi/qla2xxx/qla_iocb.c                    |  395 +++-
 drivers/scsi/qla2xxx/qla_isr.c                     |   25 +-
 drivers/scsi/qla2xxx/qla_mbx.c                     |   96 +-
 drivers/scsi/qla2xxx/qla_nvme.c                    |   47 +-
 drivers/scsi/qla2xxx/qla_nvme.h                    |    2 +-
 drivers/scsi/qla2xxx/qla_os.c                      |  277 ++-
 drivers/scsi/qla2xxx/qla_target.c                  |   28 +-
 drivers/scsi/qla2xxx/qla_target.h                  |    2 +
 drivers/scsi/qla2xxx/qla_tmpl.c                    |  237 +-
 drivers/scsi/qla2xxx/qla_tmpl.h                    |   26 +-
 drivers/scsi/qla2xxx/qla_version.h                 |    2 +-
 drivers/scsi/qla2xxx/tcm_qla2xxx.c                 |   31 -
 drivers/scsi/qla4xxx/ql4_os.c                      |    2 +-
 drivers/scsi/qlogicpti.c                           |    3 +-
 drivers/scsi/qlogicpti.h                           |    3 +-
 drivers/scsi/scsi.c                                |   16 -
 drivers/scsi/scsi_debug.c                          |  186 +-
 drivers/scsi/scsi_error.c                          |    3 -
 drivers/scsi/scsi_lib.c                            |   67 +-
 drivers/scsi/scsi_scan.c                           |    6 +-
 drivers/scsi/scsi_transport_sas.c                  |    1 -
 drivers/scsi/sd.c                                  |  526 +++--
 drivers/scsi/sd.h                                  |   64 +-
 drivers/scsi/smartpqi/Makefile                     |    1 -
 drivers/scsi/smartpqi/smartpqi_init.c              |    3 +-
 drivers/scsi/snic/snic_debugfs.c                   |  133 +-
 drivers/scsi/snic/snic_main.c                      |   14 +-
 drivers/scsi/snic/snic_stats.h                     |    2 +-
 drivers/scsi/snic/snic_trc.c                       |   12 +-
 drivers/scsi/snic/snic_trc.h                       |    4 +-
 drivers/scsi/sr.c                                  |    1 -
 drivers/scsi/st.c                                  |    6 +-
 drivers/scsi/ufs/Kconfig                           |    1 -
 drivers/scsi/ufs/ufs-hisi.c                        |  127 +-
 drivers/scsi/ufs/ufs-hisi.h                        |    4 +
 drivers/scsi/ufs/ufs.h                             |    1 -
 drivers/scsi/ufs/ufs_bsg.c                         |   63 +-
 drivers/scsi/ufs/ufs_quirks.h                      |   29 -
 drivers/scsi/ufs/ufshcd-dwc.c                      |    4 +-
 drivers/scsi/ufs/ufshcd.c                          |   90 +-
 drivers/scsi/virtio_scsi.c                         |   14 +-
 drivers/target/iscsi/cxgbit/cxgbit.h               |    2 +-
 drivers/target/iscsi/cxgbit/cxgbit_ddp.c           |    2 +-
 drivers/target/iscsi/cxgbit/cxgbit_main.c          |    2 +-
 drivers/target/iscsi/cxgbit/cxgbit_target.c        |    2 +-
 drivers/target/iscsi/iscsi_target.c                |   47 +-
 drivers/target/iscsi/iscsi_target.h                |    2 +-
 drivers/target/iscsi/iscsi_target_configfs.c       |   13 -
 drivers/target/iscsi/iscsi_target_erl0.c           |    5 +-
 drivers/target/iscsi/iscsi_target_erl1.c           |   59 +-
 drivers/target/iscsi/iscsi_target_util.c           |   23 +-
 drivers/target/loopback/tcm_loop.c                 |   21 -
 drivers/target/sbp/sbp_target.c                    |    6 -
 drivers/target/target_core_alua.c                  |    5 +-
 drivers/target/target_core_configfs.c              |    4 -
 drivers/target/target_core_device.c                |    6 +-
 drivers/target/target_core_pr.c                    |   15 +-
 drivers/target/target_core_tmr.c                   |   39 +-
 drivers/target/target_core_transport.c             |   49 +-
 drivers/target/target_core_xcopy.c                 |    6 -
 drivers/target/tcm_fc/tcm_fc.h                     |    1 -
 drivers/target/tcm_fc/tfc_cmd.c                    |    7 -
 drivers/target/tcm_fc/tfc_conf.c                   |    1 -
 drivers/usb/gadget/function/f_tcm.c                |    9 -
 drivers/usb/storage/uas.c                          |   15 +-
 drivers/vhost/scsi.c                               |    6 -
 drivers/xen/xen-scsiback.c                         |    6 -
 fs/Kconfig                                         |    3 -
 fs/Makefile                                        |    1 -
 fs/exofs/BUGS                                      |    3 -
 fs/exofs/Kbuild                                    |   20 -
 fs/exofs/Kconfig                                   |   13 -
 fs/exofs/Kconfig.ore                               |   14 -
 fs/exofs/common.h                                  |  262 ---
 fs/exofs/dir.c                                     |  661 ------
 fs/exofs/exofs.h                                   |  240 --
 fs/exofs/file.c                                    |   83 -
 fs/exofs/inode.c                                   | 1514 -------------
 fs/exofs/namei.c                                   |  323 ---
 fs/exofs/ore.c                                     | 1178 ----------
 fs/exofs/ore_raid.c                                |  756 -------
 fs/exofs/ore_raid.h                                |   62 -
 fs/exofs/super.c                                   | 1071 ---------
 fs/exofs/sys.c                                     |  205 --
 include/linux/blkdev.h                             |    8 -
 include/linux/bsg-lib.h                            |    4 +
 include/linux/libata.h                             |    5 +-
 include/scsi/libfcoe.h                             |    4 +-
 include/scsi/libsas.h                              |   59 +-
 include/scsi/osd_initiator.h                       |  511 -----
 include/scsi/osd_ore.h                             |  201 --
 include/scsi/scsi.h                                |    6 -
 include/scsi/scsi_cmnd.h                           |   34 +-
 include/scsi/scsi_eh.h                             |    1 -
 include/scsi/scsi_host.h                           |   20 +-
 include/target/iscsi/iscsi_transport.h             |    4 +-
 include/target/target_core_base.h                  |    1 -
 include/target/target_core_fabric.h                |    2 +-
 238 files changed, 10087 insertions(+), 18420 deletions(-)
 delete mode 100644 Documentation/filesystems/exofs.txt
 delete mode 100644 Documentation/scsi/osd.txt
 delete mode 100644 drivers/scsi/osd/Kbuild
 delete mode 100644 drivers/scsi/osd/Kconfig
 delete mode 100644 drivers/scsi/osd/osd_debug.h
 delete mode 100644 drivers/scsi/osd/osd_initiator.c
 delete mode 100644 drivers/scsi/osd/osd_uld.c
 delete mode 100644 fs/exofs/BUGS
 delete mode 100644 fs/exofs/Kbuild
 delete mode 100644 fs/exofs/Kconfig
 delete mode 100644 fs/exofs/Kconfig.ore
 delete mode 100644 fs/exofs/common.h
 delete mode 100644 fs/exofs/dir.c
 delete mode 100644 fs/exofs/exofs.h
 delete mode 100644 fs/exofs/file.c
 delete mode 100644 fs/exofs/inode.c
 delete mode 100644 fs/exofs/namei.c
 delete mode 100644 fs/exofs/ore.c
 delete mode 100644 fs/exofs/ore_raid.c
 delete mode 100644 fs/exofs/ore_raid.h
 delete mode 100644 fs/exofs/super.c
 delete mode 100644 fs/exofs/sys.c
 delete mode 100644 include/scsi/osd_initiator.h
 delete mode 100644 include/scsi/osd_ore.h

James

---

diff --cc drivers/scsi/hisi_sas/hisi_sas_v3_hw.c
index e0570fd8466e,00738d0673fe..9ec8848ec541
--- a/drivers/scsi/hisi_sas/hisi_sas_v3_hw.c
+++ b/drivers/scsi/hisi_sas/hisi_sas_v3_hw.c
@@@ -2509,12 -2802,9 +2804,18 @@@ hisi_sas_v3_probe(struct pci_dev *pdev
  		sha->sas_port[i] = &hisi_hba->port[i].sas_port;
  	}
  
 +	if (hisi_hba->prot_mask) {
 +		dev_info(dev, "Registering for DIF/DIX prot_mask=0x%x\n",
 +			 prot_mask);
 +		scsi_host_set_prot(hisi_hba->shost, prot_mask);
++		if (hisi_hba->prot_mask & HISI_SAS_DIX_PROT_MASK)
++			scsi_host_set_guard(hisi_hba->shost,
++					    SHOST_DIX_GUARD_CRC);
 +	}
 +
+ 	if (hisi_sas_debugfs_enable)
+ 		hisi_sas_debugfs_init(hisi_hba);
+ 
  	rc = scsi_add_host(shost, dev);
  	if (rc)
  		goto err_out_ha;
diff --cc drivers/scsi/lpfc/lpfc_nvme.c
index 8c9f79042228,e73895674f39..55ab9d3ee4ba
--- a/drivers/scsi/lpfc/lpfc_nvme.c
+++ b/drivers/scsi/lpfc/lpfc_nvme.c
@@@ -2591,16 -2178,14 +2179,14 @@@ lpfc_nvme_destroy_localport(struct lpfc
  #if (IS_ENABLED(CONFIG_NVME_FC))
  	struct nvme_fc_local_port *localport;
  	struct lpfc_nvme_lport *lport;
- 	struct lpfc_nvme_ctrl_stat *cstat;
  	int ret;
 +	DECLARE_COMPLETION_ONSTACK(lport_unreg_cmp);
  
  	if (vport->nvmei_support == 0)
  		return;
  
  	localport = vport->localport;
 -	vport->localport = NULL;
  	lport = (struct lpfc_nvme_lport *)localport->private;
- 	cstat = lport->cstat;
  
  	lpfc_printf_vlog(vport, KERN_INFO, LOG_NVME,
  			 "6011 Destroying NVME localport %p\n",
@@@ -2615,9 -2200,7 +2201,8 @@@
  	/* Wait for completion.  This either blocks
  	 * indefinitely or succeeds
  	 */
 -	lpfc_nvme_lport_unreg_wait(vport, lport);
 +	lpfc_nvme_lport_unreg_wait(vport, lport, &lport_unreg_cmp);
 +	vport->localport = NULL;
- 	kfree(cstat);
  
  	/* Regardless of the unregister upcall response, clear
  	 * nvmei_support.  All rports are unregistered and the
diff --cc drivers/scsi/qla2xxx/qla_init.c
index 8d1acc802a67,a2c2ca4c0fa8..420045155ba0
--- a/drivers/scsi/qla2xxx/qla_init.c
+++ b/drivers/scsi/qla2xxx/qla_init.c
@@@ -1784,8 -1705,8 +1705,8 @@@ qla2x00_async_tm_cmd(fc_port_t *fcport
  		lun = (uint16_t)tm_iocb->u.tmf.lun;
  
  		/* Issue Marker IOCB */
- 		qla2x00_marker(vha, vha->hw->req_q_map[0],
- 		    vha->hw->rsp_q_map[0], fcport->loop_id, lun,
+ 		qla2x00_marker(vha, vha->hw->base_qpair,
 -		    sp->fcport->loop_id, lun,
++		    fcport->loop_id, lun,
  		    flags == TCF_LUN_RESET ? MK_SYNC_ID_LUN : MK_SYNC_ID);
  	}
  
