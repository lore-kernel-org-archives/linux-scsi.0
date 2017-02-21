From: James Bottomley <James.Bottomley@HansenPartnership.com>
Subject: [GIT PULL] first round of SCSI updates for the 4.10+ merge window
Date: Mon, 20 Feb 2017 17:25:17 -0800
Message-ID: <1487640317.2337.68.camel@HansenPartnership.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner@vger.kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
To: Andrew Morton <akpm@linux-foundation.org>, Linus Torvalds <torvalds@linux-foundation.org>
Cc: linux-scsi <linux-scsi@vger.kernel.org>, linux-kernel <linux-kernel@vger.kernel.org>
List-Id: linux-scsi@vger.kernel.org

This update includes the usual round of major driver updates (ncr5380,
ufs, lpfc, be2iscsi, hisi_sas, storvsc, cxlflash, aacraid,
megaraid_sas, ).  There's also an assortment of minor fixes and the
major update of switching another bunch of drivers to
pci_alloc_irq_vectors from Christoph.

The patch is available here:

git://git.kernel.org/pub/scm/linux/kernel/git/jejb/scsi.git scsi-misc

The short changelog is:

Arnd Bergmann (2):
      scsi: megaraid_sas: handle dma_addr_t right on 32-bit
      scsi: aacraid: avoid open-coded upper_32_bits

Cao jin (1):
      scsi: qla4xxx: comments correction

Chaitra P B (4):
      scsi: mpt3sas: Updating driver version to v15.100.00.00
      scsi: mpt3sas: Fix Firmware fault state 0x2100 during heavy 4K RR FIO stress test.
      scsi: mpt3sas: Fix for Crusader to achieve product targets with SAS devices.
      scsi: mpt3sas: Added print to notify cable running at a degraded speed.

Christoph Hellwig (11):
      scsi: snic: switch to pci_irq_alloc_vectors
      scsi: pm8001: switch to pci_irq_alloc_vectors
      scsi: remove tsk_mgmt_response and it_nexus_response transport methods
      scsi: remove eh_timed_out methods in the transport template
      scsi: libsas: remove sas_scsi_timed_out
      scsi: mvumi: remove fake transport template
      scsi: storvsc: remove bogus code to transfer struct scatterlist
      scsi: qla4xxx: remove two unused MSI-X related #defines
      scsi: vmw_pvscsi: switch to pci_alloc_irq_vectors
      scsi: pmcraid: switch to pci_alloc_irq_vectors
      scsi: bfa: remove bfa_fcs_mod_s

Colin Ian King (3):
      scsi: aacraid: rcode is unsigned and should be signed int
      scsi: qla2xxx: rename {vendor|hba}_indentifer to {vendor|hba}_identifer
      scsi: qedi: return via va_end to match corresponding va_start

Corentin Labbe (1):
      scsi: mptlan: Remove linux/miscdevice.h from mptlan.h

Dan Carpenter (2):
      scsi: megaraid_sas: array overflow in megasas_dump_frame()
      scsi: dpt_i2o: double free if adpt_i2o_online_hba() fails

Dolev Raviv (3):
      scsi: ufs: Improve fatal error logs
      scsi: ufs: fix multiple ufs spec violation
      scsi: ufs: dump debug info during failures

Don Brace (1):
      scsi: hpsa: remove coalescing settings for ioaccel2

Emese Revfy (1):
      scsi: esas2r: Fix format string type mistakes

Finn Thain (6):
      scsi: atari_scsi: Reset DMA during bus reset only under ST-DMA lock
      scsi: ncr5380: Improve target selection robustness
      scsi: ncr5380: Resolve various static checker warnings
      scsi: ncr5380: Reduce #include files
      scsi: ncr5380: Clean up dead code and redundant macro usage
      scsi: ncr5380: Shorten host info string by removing unused option macros

Gilad Broner (3):
      scsi: ufs: add host state prints in failure cases
      scsi: ufs: reduce printout for aborted requests
      scsi: ufs: skip request abort task when previous aborts failed

Hanjun Guo (1):
      scsi: remove useless acpi functions in the header file

James Smart (13):
      scsi: lpfc: Fix lpfc_wwn_set return code check
      scsi: lpfc: Reinstate lpfc_soft_wwn parameter
      scsi: lpfc: lpfc version change to 11.2.0.4
      scsi: lpfc: Add missing memory barrier
      scsi: lpfc: Correct oops on vport port resets
      scsi: lpfc: Deprecate lpfc_prot_sg_seg_cnt parameter
      scsi: lpfc: Fix Xlane dynamic LUN set for LUN priority.
      scsi: lpfc: FCoE VPort enable-disable does not bring up the VPort
      scsi: lpfc: Correct host name in symbolic_name field
      scsi: lpfc: Correct issue leading to oops during link reset
      scsi: lpfc: Deprecate lpfc_soft_wwn parameter
      scsi: lpfc: Correct error in setting OS Driver Version with FW
      scsi: lpfc: Clear the VendorVersion in the PLOGI/PLOGI ACC payload

Javier Martinez Canillas (1):
      scsi: ufs-qcom: Fix module autoload

Jitendra Bhivare (12):
      scsi: be2iscsi: Update driver version
      scsi: be2iscsi: Reinit SGL handle, CID tables after TPE
      scsi: be2iscsi: Add checks to validate CID alloc/free
      scsi: be2iscsi: Remove wq_name from beiscsi_hba
      scsi: be2iscsi: Remove unused struct members
      scsi: be2iscsi: Remove redundant receive buffers posting
      scsi: be2iscsi: Fix iSCSI cmd cleanup IOCTL
      scsi: be2iscsi: Add checks to validate completions
      scsi: be2iscsi: Set WRB invalid bit for SkyHawk
      scsi: be2iscsi: Take iscsi_task ref in abort handler
      scsi: be2iscsi: Fix for crash in beiscsi_eh_device_reset
      scsi: be2iscsi: Fix use of invalidate command table req

John Garry (5):
      scsi: hisi_sas: downgrade internal abort exit print
      scsi: hisi_sas: downgrade refclk message
      scsi: hisi_sas: lock sensitive region in hisi_sas_slot_abort()
      scsi: hisi_sas: lock sensitive regions when servicing CQ interrupt
      scsi: hisi_sas: service v2 hw CQ ISR with tasklet

John Pittman (1):
      scsi: sd: Cleaned up comment references to @sdp argument explanation.

K. Y. Srinivasan (3):
      scsi: storvsc: Enable multi-queue support
      scsi: storvsc: Remove the restriction on max segment size
      scsi: storvsc: Enable tracking of queue depth

Kees Cook (2):
      scsi: cciss: use designated initializers
      scsi: hpsa: use designated initializers

Ketan Mukadam (1):
      scsi: be2iscsi: Add warning message for unsupported adapter

Lee Susman (1):
      scsi: ufs: add trace event for ufs commands

Long Li (3):
      scsi: storvsc: properly set residual data length on errors
      scsi: storvsc: properly handle SRB_ERROR when sense message is present
      scsi: storvsc: use tagged SRB requests if supported by the device

Lukas Herbolt (1):
      scsi: scsi_debug: Add OPTIMAL TRANSFER LENGTH GRANULARITY option.

Matthew R. Ochs (3):
      scsi: cxlflash: Cleanup prints
      scsi: cxlflash: Support SQ Command Mode
      scsi: cxlflash: Refactor context reset to share reset logic

Nicolas Iooss (2):
      scsi: qla2xxx: make msix_entries const
      scsi: qla2xxx: silence -Wformat-security warning

Raghava Aditya Renukunta (24):
      scsi: aacraid: update version
      scsi: aacraid: Change Driver Version Prefix
      scsi: aacraid: Update copyrights
      scsi: aacraid: Retrieve HBA host information ioctl
      scsi: aacraid: Added ioctl to trigger IOP/IWBR reset
      scsi: aacraid: Added new IWBR reset
      scsi: aacraid: VPD 83 type3 support
      scsi: aacraid: Added support to abort cmd and reset lun
      scsi: aacraid: Add task management functionality
      scsi: aacraid: Include HBA direct interface
      scsi: aacraid: Added support for hotplug
      scsi: aacraid: Added support to set QD of attached drives
      scsi: aacraid: Retrieve Queue Depth from Adapter FW
      scsi: aacraid: Added support for periodic wellness sync
      scsi: aacraid: Reworked aac_command_thread
      scsi: aacraid: Added support for read medium error
      scsi: aacraid: Added support for response path
      scsi: aacraid: Process Error for response I/O
      scsi: aacraid: Reworked scsi command submission path
      scsi: aacraid: Retrieve and update the device types
      scsi: aacraid: Added sa firmware support
      scsi: aacraid: added support for init_struct_8
      scsi: aacraid: Added aacraid.h include guard
      scsi: aacraid: Remove duplicate irq management code

Sahitya Tummala (2):
      scsi: ufs: Add sysfs node to dynamically control clock scaling
      scsi: ufs: Add sysfs node to dynamically control clock gating

Sasikumar Chandrasekaran (11):
      scsi: megaraid_sas: driver version upgrade
      scsi: megaraid_sas: Implement the PD Map support for SAS3.5 Generic Megaraid Controllers
      scsi: megaraid_sas: ldio_outstanding variable is not decremented in completion path
      scsi: megaraid_sas: Enable or Disable Fast path based on the PCI Threshold Bandwidth
      scsi: megaraid_sas: Add the Support for SAS3.5 Generic Megaraid Controllers Capabilities
      scsi: megaraid_sas: Dynamic Raid Map Changes for SAS3.5 Generic Megaraid Controllers
      scsi: megaraid_sas: SAS3.5 Generic Megaraid Controllers Fast Path for RAID 1/10 Writes
      scsi: megaraid_sas: SAS3.5 Generic Megaraid Controllers Stream Detection and IO Coalescing
      scsi: megaraid_sas: EEDP Escape Mode Support for SAS3.5 Generic Megaraid Controllers
      scsi: megaraid_sas: 128 MSIX Support
      scsi: megaraid_sas: Add new pci device Ids for SAS3.5 Generic Megaraid Controllers

Shivasharan S (39):
      scsi: megaraid_sas: driver version upgrade
      scsi: megaraid_sas: Change RAID_1_10_RMW_CMDS to RAID_1_PEER_CMDS and set value to 2
      scsi: megaraid_sas: Indentation and smatch warning fixes
      scsi: megaraid_sas: Cleanup VD_EXT_DEBUG and SPAN_DEBUG related debug prints
      scsi: megaraid_sas: Increase internal command pool
      scsi: megaraid_sas: Use synchronize_irq to wait for IRQs to complete
      scsi: megaraid_sas: Bail out the driver load if ld_list_query fails
      scsi: megaraid_sas: Change build_mpt_mfi_pass_thru to return void
      scsi: megaraid_sas: During OCR, if get_ctrl_info fails do not continue with OCR
      scsi: megaraid_sas: Do not set fp_possible if TM capable for non-RW syspdIO, change fp_possible to bool
      scsi: megaraid_sas: Remove unused pd_index from megasas_build_ld_nonrw_fusion
      scsi: megaraid_sas: megasas_return_cmd does not memset IO frame to zero
      scsi: megaraid_sas: max_fw_cmds are decremented twice, remove duplicate
      scsi: megaraid_sas: update can_queue only if the new value is less
      scsi: megaraid_sas: Change max_cmd from u32 to u16 in all functions
      scsi: megaraid_sas: set pd_after_lb from MR_BuildRaidContext and initialize pDevHandle to MR_DEVHANDLE_INVALID
      scsi: megaraid_sas: latest controller OCR capability from FW before sending shutdown DCMD
      scsi: megaraid_sas: avoid unaligned access in ioctl path
      scsi: megaraid_sas: big endian support changes
      scsi: megaraid_sas: Big endian RDPQ mode fix
      scsi: megaraid_sas: MR_TargetIdToLdGet u8 to u16 and avoid invalid raid-map access
      scsi: megaraid_sas: In validate raid map, raid capability is not converted to cpu format for all lds
      scsi: megaraid_sas: reduce size of fusion_context and use vmalloc if kmalloc fails
      scsi: megaraid_sas: add print in device removal path
      scsi: megaraid_sas: enhance debug logs in OCR context
      scsi: megaraid_sas: set residual bytes count during IO completion
      scsi: megaraid_sas: raid 1 write performance for large io
      scsi: megaraid_sas: NVME fast path io support
      scsi: megaraid_sas: NVME interface target prop added
      scsi: megaraid_sas: NVME Interface detection and prop settings
      scsi: megaraid_sas: change issue_dcmd to return void from int
      scsi: megaraid_sas: megasas_get_request_descriptor always return valid desc
      scsi: megaraid_sas: Use DID_REQUEUE
      scsi: megaraid_sas: RAID map is accessed for SYS PDs when use_seqnum_jbod_fp is not set
      scsi: megaraid_sas: Refactor MEGASAS_IS_LOGICAL macro using sdev
      scsi: megaraid_sas: 32 bit descriptor fire cmd optimization
      scsi: megaraid_sas: raid 1 fast path code optimize
      scsi: megaraid_sas: cpu select rework.
      Revert "scsi: megaraid_sas: Enable or Disable Fast path based on the PCI Threshold Bandwidth"

Shyam Saini (1):
      scsi: lpfc: Replace BUG() with BUG_ON()

Subhash Jadavani (1):
      scsi: ufs: fix arguments order some trace calls

Tomas Winkler (4):
      scsi: ufs: refactor device descriptor reading
      scsi: ufs: ufshcd_get_max_icc_level fix endianity handling
      scsi: ufs: unexport descritpor reading functions
      scsi: ufs: ufshcd_query_descriptor_retry should be static

Uma Krishnan (1):
      scsi: cxlflash: Cancel scheduled workers before stopping AFU

Venkat Gopalakrishnan (2):
      scsi: ufs: dump hw regs on link failures
      scsi: ufs-qcom: dump additional testbus registers

Wei Yongjun (2):
      scsi: qedi: Fix possible memory leak in qedi_iscsi_update_conn()
      scsi: be2iscsi: Use GFP_ATOMIC under spin lock

Xiang Chen (5):
      scsi: hisi_sas: decrease running_req in hisi_sas_slot_task_free()
      scsi: hisi_sas: fix probe ordering problem
      scsi: hisi_sas: modify hard reset for directed-attached disk
      scsi: hisi_sas: modify some values of ITCT table
      scsi: hisi_sas: workaround v2 hw SATA IO timeout issue

subhashj@codeaurora.org (9):
      scsi: ufs: kick start clock scaling only after device detection
      scsi: ufs: don't suspend clock scaling during clock gating
      scsi: ufs: add load based scaling of UFS gear
      scsi: ufs: add time profiling support
      scsi: ufs: fix setting init power mode
      scsi: ufs: add capability to keep auto bkops always enabled
      scsi: ufs: set default UFS power management level
      scsi: ufs: provide sysfs attribute to select the PM level
      scsi: ufs: add tracing support

And the diffstat:

 drivers/ata/libata-eh.c                     |    1 +
 drivers/ata/libata-transport.c              |    1 -
 drivers/ata/libata.h                        |    1 -
 drivers/block/cciss.h                       |   30 +-
 drivers/infiniband/ulp/iser/iscsi_iser.c    |    1 +
 drivers/infiniband/ulp/srp/ib_srp.c         |    1 +
 drivers/message/fusion/mptfc.c              |    1 +
 drivers/message/fusion/mptlan.h             |    1 -
 drivers/message/fusion/mptsas.c             |    2 +-
 drivers/s390/scsi/zfcp_scsi.c               |    1 +
 drivers/scsi/NCR5380.c                      |   64 +-
 drivers/scsi/NCR5380.h                      |   17 +-
 drivers/scsi/aacraid/aachba.c               | 1288 ++++++++++++++++------
 drivers/scsi/aacraid/aacraid.h              |  644 +++++++++--
 drivers/scsi/aacraid/commctrl.c             |  342 ++++--
 drivers/scsi/aacraid/comminit.c             |  330 +++---
 drivers/scsi/aacraid/commsup.c              |  964 +++++++++++-----
 drivers/scsi/aacraid/dpcsup.c               |  159 ++-
 drivers/scsi/aacraid/linit.c                |  562 +++++++---
 drivers/scsi/aacraid/nark.c                 |    3 +-
 drivers/scsi/aacraid/rkt.c                  |    5 +-
 drivers/scsi/aacraid/rx.c                   |   17 +-
 drivers/scsi/aacraid/sa.c                   |    9 +-
 drivers/scsi/aacraid/src.c                  |  336 ++++--
 drivers/scsi/atari_scsi.c                   |   36 +-
 drivers/scsi/be2iscsi/be.h                  |    3 -
 drivers/scsi/be2iscsi/be_cmds.c             |   41 +-
 drivers/scsi/be2iscsi/be_cmds.h             |   17 +-
 drivers/scsi/be2iscsi/be_iscsi.c            |  165 +--
 drivers/scsi/be2iscsi/be_main.c             |  345 +++---
 drivers/scsi/be2iscsi/be_main.h             |   44 +-
 drivers/scsi/be2iscsi/be_mgmt.c             |  117 +-
 drivers/scsi/be2iscsi/be_mgmt.h             |   98 +-
 drivers/scsi/bfa/bfa_fcs.c                  |  181 +--
 drivers/scsi/bfa/bfa_fcs.h                  |    4 -
 drivers/scsi/bfa/bfad_im.c                  |    2 +
 drivers/scsi/bnx2fc/bnx2fc_fcoe.c           |    1 +
 drivers/scsi/bnx2i/bnx2i_iscsi.c            |    1 +
 drivers/scsi/csiostor/csio_scsi.c           |    2 +
 drivers/scsi/cxgbi/cxgb3i/cxgb3i.c          |    1 +
 drivers/scsi/cxgbi/cxgb4i/cxgb4i.c          |    1 +
 drivers/scsi/cxlflash/common.h              |   32 +-
 drivers/scsi/cxlflash/lunmgt.c              |   31 +-
 drivers/scsi/cxlflash/main.c                |  465 ++++----
 drivers/scsi/cxlflash/sislite.h             |   19 +-
 drivers/scsi/cxlflash/superpipe.c           |  183 ++--
 drivers/scsi/cxlflash/vlun.c                |  169 +--
 drivers/scsi/dpt_i2o.c                      |    8 +-
 drivers/scsi/esas2r/esas2r_init.c           |    2 +-
 drivers/scsi/esas2r/esas2r_ioctl.c          |    2 +-
 drivers/scsi/esas2r/esas2r_log.h            |    4 +-
 drivers/scsi/esas2r/esas2r_main.c           |    4 +-
 drivers/scsi/fcoe/fcoe.c                    |    1 +
 drivers/scsi/fnic/fnic_main.c               |    1 +
 drivers/scsi/g_NCR5380.c                    |   45 +-
 drivers/scsi/g_NCR5380.h                    |   56 -
 drivers/scsi/hisi_sas/hisi_sas.h            |    1 +
 drivers/scsi/hisi_sas/hisi_sas_main.c       |   23 +-
 drivers/scsi/hisi_sas/hisi_sas_v1_hw.c      |    2 +
 drivers/scsi/hisi_sas/hisi_sas_v2_hw.c      |  135 ++-
 drivers/scsi/hpsa.c                         |    8 +-
 drivers/scsi/hpsa.h                         |   40 +-
 drivers/scsi/ibmvscsi/ibmvfc.c              |    1 +
 drivers/scsi/ibmvscsi/ibmvscsi.c            |    1 +
 drivers/scsi/iscsi_tcp.c                    |    1 +
 drivers/scsi/libiscsi.c                     |    5 +-
 drivers/scsi/libsas/sas_init.c              |    1 -
 drivers/scsi/libsas/sas_internal.h          |    2 -
 drivers/scsi/libsas/sas_scsi_host.c         |    7 -
 drivers/scsi/lpfc/lpfc.h                    |    1 -
 drivers/scsi/lpfc/lpfc_attr.c               |   61 +-
 drivers/scsi/lpfc/lpfc_crtn.h               |    7 +-
 drivers/scsi/lpfc/lpfc_els.c                |    9 +-
 drivers/scsi/lpfc/lpfc_hw.h                 |    6 +
 drivers/scsi/lpfc/lpfc_scsi.c               |   20 +-
 drivers/scsi/lpfc/lpfc_sli.c                |   13 +-
 drivers/scsi/lpfc/lpfc_version.h            |    2 +-
 drivers/scsi/lpfc/lpfc_vport.c              |    8 +
 drivers/scsi/mac_scsi.c                     |    8 +-
 drivers/scsi/megaraid/megaraid_sas.h        |  199 +++-
 drivers/scsi/megaraid/megaraid_sas_base.c   |  648 ++++++++---
 drivers/scsi/megaraid/megaraid_sas_fp.c     |  468 ++++----
 drivers/scsi/megaraid/megaraid_sas_fusion.c | 1334 +++++++++++++++++-----
 drivers/scsi/megaraid/megaraid_sas_fusion.h |  412 ++++++-
 drivers/scsi/mpt3sas/mpi/mpi2_ioc.h         |    2 +
 drivers/scsi/mpt3sas/mpt3sas_base.c         |   20 +
 drivers/scsi/mpt3sas/mpt3sas_base.h         |    7 +-
 drivers/scsi/mpt3sas/mpt3sas_ctl.c          |    4 +-
 drivers/scsi/mpt3sas/mpt3sas_scsih.c        |   56 +-
 drivers/scsi/mvumi.c                        |    6 +-
 drivers/scsi/pm8001/pm8001_init.c           |   35 +-
 drivers/scsi/pm8001/pm8001_sas.h            |    2 -
 drivers/scsi/pmcraid.c                      |   92 +-
 drivers/scsi/pmcraid.h                      |    1 -
 drivers/scsi/qedi/qedi_dbg.c                |    9 +-
 drivers/scsi/qedi/qedi_iscsi.c              |    5 +-
 drivers/scsi/qla2xxx/qla_def.h              |    4 +-
 drivers/scsi/qla2xxx/qla_gs.c               |    6 +-
 drivers/scsi/qla2xxx/qla_isr.c              |   10 +-
 drivers/scsi/qla2xxx/qla_os.c               |    1 +
 drivers/scsi/qla4xxx/ql4_def.h              |    3 -
 drivers/scsi/qla4xxx/ql4_os.c               |    6 +-
 drivers/scsi/scsi_debug.c                   |   10 +-
 drivers/scsi/scsi_error.c                   |    4 +-
 drivers/scsi/scsi_transport_fc.c            |   26 +-
 drivers/scsi/scsi_transport_srp.c           |   21 +-
 drivers/scsi/sd.c                           |    4 +-
 drivers/scsi/snic/snic.h                    |    1 -
 drivers/scsi/snic/snic_isr.c                |   48 +-
 drivers/scsi/storvsc_drv.c                  |  160 ++-
 drivers/scsi/sun3_scsi.c                    |   83 +-
 drivers/scsi/sun3_scsi.h                    |  102 --
 drivers/scsi/ufs/ufs-qcom.c                 |   49 +-
 drivers/scsi/ufs/ufs-qcom.h                 |    1 +
 drivers/scsi/ufs/ufs.h                      |   12 +
 drivers/scsi/ufs/ufs_quirks.h               |   28 +-
 drivers/scsi/ufs/ufshcd.c                   | 1578 +++++++++++++++++++++++----
 drivers/scsi/ufs/ufshcd.h                   |  121 +-
 drivers/scsi/ufs/ufshci.h                   |    3 +
 drivers/scsi/vmw_pvscsi.c                   |  104 +-
 drivers/scsi/vmw_pvscsi.h                   |    5 -
 include/linux/libata.h                      |    2 +
 include/scsi/libiscsi.h                     |    1 +
 include/scsi/scsi.h                         |   10 -
 include/scsi/scsi_transport.h               |   23 -
 include/scsi/scsi_transport_fc.h            |    1 +
 include/scsi/scsi_transport_srp.h           |    8 +-
 include/trace/events/ufs.h                  |  263 +++++
 include/uapi/scsi/cxlflash_ioctl.h          |    1 +
 129 files changed, 9294 insertions(+), 3928 deletions(-)
 delete mode 100644 drivers/scsi/g_NCR5380.h
 delete mode 100644 drivers/scsi/sun3_scsi.h
 create mode 100644 include/trace/events/ufs.h

James
