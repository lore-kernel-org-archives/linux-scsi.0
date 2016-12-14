From: James Bottomley <James.Bottomley@HansenPartnership.com>
Subject: [GIT PULL] first round of SCSI updates for the 4.9+ merge window
Date: Tue, 13 Dec 2016 16:35:17 -0800
Message-ID: <1481675717.2473.92.camel@HansenPartnership.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner@vger.kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
To: Andrew Morton <akpm@linux-foundation.org>, Linus Torvalds <torvalds@linux-foundation.org>
Cc: linux-scsi <linux-scsi@vger.kernel.org>, linux-kernel <linux-kernel@vger.kernel.org>
List-Id: linux-scsi@vger.kernel.org

This update includes the usual round of major driver updates (ncr5380,
lpfc, hisi_sas, megaraid_sas, ufs, ibmvscsis, mpt3sas).  There's also
an assortment of minor fixes, mostly in error legs or other not very
user visible stuff.  The major change is the pci_alloc_irq_vectors
replacement for the old pci_msix_.. calls; this effectively makes IRQ
mapping generic for the drivers and allows blk_mq to use the
information.

The patch is available here:

git://git.kernel.org/pub/scm/linux/kernel/git/jejb/scsi.git scsi-misc

The short changelog is:

Andy Shevchenko (5):
      scsi: cciss: replace custom function to hexdump
      scsi: replace custom approach to hexdump small buffers
      scsi: ips: don't use custom hex_asc_upper[] table
      scsi: fusion: print lan address via %pMR
      scsi: fnic: use kernel's '%pM' format option to print MAC

Arnd Bergmann (6):
      scsi: isci: avoid array subscript warning
      scsi: bfa: turn bfa_mem_{kva,dma}_setup into inline functions
      scsi: mvsas: fix command_active typo
      scsi: advansys: fix build warning for PCI=n
      scsi: g_NCR5380: add HAS_IOPORT_MAP dependency
      scsi: lpfc: Use %zd format string for size_t

Bart Van Assche (3):
      scsi: scsi_dh_alua: Fix RCU annotations
      scsi: srp_transport: Move queuecommand() wait code to SCSI core
      scsi: scsi_transport_fc: Hold queue lock while calling blk_run_queue_async()

Benjamin Herrenschmidt (1):
      scsi: ipr: Fix runaway IRQs when falling back from MSI to LSI

Bjorn Andersson (1):
      scsi: ufs: qcom: Properly clear hba priv on failure

Cathy Avery (1):
      scsi: storvsc: Payload buffer incorrectly sized for 32 bit kernels.

Chad Dupuis (2):
      scsi: fcoe: Harden CVL handling when we have not logged into the fabric.
      scsi: libfc: Do not take rdata->rp_mutex when processing a -FC_EX_CLOSED ELS response.

Chanwoo Choi (1):
      scsi: ufs: Use the resource-managed function to add devfreq device

Chris Leech (1):
      scsi: libfc: Don't have fc_exch_find log errors on a new exchange

Christoph Hellwig (9):
      scsi: qla4xxx: switch to pci_alloc_irq_vectors
      scsi: isci: switch to pci_alloc_irq_vectors
      scsi: hpsa: use pci_alloc_irq_vectors and automatic irq affinity
      scsi: smartpqi: switch to pci_alloc_irq_vectors
      scsi: allow LLDDs to expose the queue mapping to blk-mq
      blk-mq: export blk_mq_map_queues
      scsi: mptscsih: Remove bogus interpretation of request->ioprio
      scsi: ipr: Use pci_irq_allocate_vectors
      scsi: arcmsr: Use pci_alloc_irq_vectors

Colin Ian King (6):
      scsi: hpsa: free irq on q indexed by h->intr_mode and not i
      scsi: isci: fix typo in deg_dbg message
      scsi: isci: fix spelling mistakes in dev_warn messages
      scsi: megaraid_sas: add in missing white spaces in error messages text
      scsi: fix spelling mistake in error message
      scsi: mpt3sas: fix some spelling mistakes in message and comments

Dan Carpenter (3):
      scsi: dpt_i2o: double free on error path
      scsi: hisi_sas: shift vs compare typos
      scsi: libfc: Remove an unneeded condition

Deepa Dinamani (1):
      scsi: fnic: Use time64_t to represent trace timestamps

Dolev Raviv (2):
      scsi: ufs: handle errors from PHY_ADAPTER_ERROR register
      scsi: ufs: add queries retry mechanism

Don Brace (1):
      scsi: hpsa: correct logical resets

Dov Levenglick (1):
      scsi: ufs: fail ufshcd_probe_hba() if power configuration fails

Finn Thain (11):
      scsi: ncr5380: Suppress unhelpful "interrupt without IRQ bit" message
      scsi: ncr5380: Use correct types for DMA routines
      scsi: ncr5380: Expedite register polling
      scsi: ncr5380: Pass hostdata pointer to register polling routines
      scsi: ncr5380: Use correct types for device register accessors
      scsi: ncr5380: Store IO ports and addresses in host private data
      scsi: ncr5380: Improve hostdata struct member alignment and cache-ability
      scsi: ncr5380: Increase register polling limit
      scsi: ncr5380: Simplify register polling limit
      scsi: atari_scsi: Make device register accessors re-entrant
      scsi: cumana_1: Remove unused cumanascsi_setup() function

Geliang Tang (1):
      scsi: dmx3191d: use module_pci_driver

Gilad Broner (3):
      scsi: ufs: suspend clock scaling for failed runtime_resume
      scsi: ufs: fix sense buffer size to 18 bytes
      scsi: ufs: commit descriptors before setting the doorbell

Hannes Reinecke (55):
      scsi: megaraid_sas: switch to pci_alloc_irq_vectors
      scsi: hpsa: fallback to use legacy REPORT PHYS command
      scsi: hpsa: add 'ctlr_num' sysfs attribute
      scsi: hpsa: use correct DID_NO_CONNECT hostbyte
      scsi: aacraid: switch to pci_alloc_irq_vectors
      scsi: libfc: Replace ->seq_release callback with function call
      scsi: libfc: Replace ->seq_assign callback with function call
      scsi: libfc: Replace ->seq_set_resp callback with direct function call
      scsi: libfc: Replace ->seq_start_next callback with function call
      scsi: libfc: Replace ->exch_done callback with function call
      scsi: libfc: Replace ->seq_exch_abort callback with function call
      scsi: libfc: Replace ->seq_send callback with function call
      scsi: libfc: Remove fc_rport_init()
      scsi: libfc: Replace ->rport_flush_queue callback with function call
      scsi: libfc: Replace ->rport_recv_req callback with function call
      scsi: libfc: Replace ->rport_logoff callback with function call
      scsi: libfc: Replace ->rport_login callback with function call
      scsi: libfc: Replace ->rport_create callback with function call
      scsi: scsi_transport_fc: rename 'fc_rport_create' to 'fc_remote_port_create'
      scsi: libfc: Replace ->rport_lookup callback with function call
      scsi: libfc: Replace ->rport_destroy callback with function call
      scsi: libfc: Replace ->exch_seq_send callback with function call
      scsi: libfc: Replace ->lport_recv with function call
      scsi: libfc: Replace ->lport_reset callback with function call
      scsi: libfc: Replace ->seq_els_rsp_send callback with function call
      scsi: fcoe: Fixup missing initialisation in fcoe_dcb_create()
      scsi: fcoe: filter out frames from invalid vlans
      scsi: fcoe: correct sending FIP VLAN packets on VLAN 0
      scsi: fcoe: FIP debugging
      scsi: fcoe: catch invalid values for the 'enabled' attribute
      scsi: fcoe: set default TC priority
      scsi: libfc: Check xid when looking up REC exchanges
      scsi: libfc: wait for E_D_TOV when out-of-order sequence is received
      scsi: libfc: reset timeout on queue full
      scsi: libfc: Do not drop out-of-order frames
      scsi: libfc: don't fail sequence abort for completed exchanges
      scsi: libfc: quarantine timed out xids
      scsi: libfc: safeguard against invalid exchange index
      scsi: libfc: Clarify ramp-down messages
      scsi: libfc: Return LS_RJT_BUSY for PRLI in status PLOGI
      scsi: libfc: Rework PRLI handling
      scsi: libfc: Implement RTV responder
      scsi: libfc: use error code for fc_rport_error()
      scsi: libfc: do not overwrite DID_TIME_OUT status
      scsi: fcoe: make R_A_TOV and E_D_TOV configurable
      scsi: libfc: sanitize E_D_TOV and R_A_TOV setting
      scsi: libfc: use configured rport E_D_TOV
      scsi: libfc: use configured lport R_A_TOV
      scsi: libfc: spurious I/O error under high load
      scsi: libfc: additional debugging messages
      scsi: libfc: don't advance state machine for incoming FLOGI
      scsi: libfc: Do not login if the port is already started
      scsi: libfc: Do not drop down to FLOGI for fc_rport_login()
      scsi: libfc: Fixup disc_mutex handling
      scsi: libfc: Revisit kref handling

Helge Deller (1):
      scsi: mptfusion: Fix printk continuations

James Smart (17):
      MAINTAINERS: Revise lpfc maintainers to reflect Broadcom
      scsi: lpfc: lpfc version changed to 11.2.0.2
      scsi: lpfc: Fix fw download on SLI-4 FC adapters
      scsi: lpfc: Synchronize link speed with boot driver
      scsi: lpfc: Correct panics with eh_timeout and eh_deadline
      scsi: lpfc: Fix lost target in pt-to-pt connect
      scsi: lpfc: Revise strings with full lpfc parameter name
      scsi: lpfc: Code cleanup for lpfc_sriov_nr_virtfn parameter
      scsi: lpfc: Code cleanup for lpfc_max_scsicmpl_time parameter
      scsi: lpfc: Code cleanup for lpfc_topology parameter
      scsi: lpfc: Code cleanup for lpfc_aer_support parameter
      scsi: lpfc: Code cleanup for lpfc_enable_rrq parameter
      scsi: lpfc: Code clean up for lpfc_iocb_cnt parameter
      scsi: lpfc: Make lpfc_prot_xxx params per hba parameters
      scsi: lpfc: Set driver environment data on adapter
      scsi: lpfc: Fix sg_reset on SCSI device causing kernel crash
      scsi: lpfc: Correct embedded io wq element size

Javier Martinez Canillas (2):
      MAINTAINERS: Remove defunct iss storage mailing list
      scsi: hpsa: Remove unneeded void pointer cast

Joao Pinto (1):
      MAINTAINERS: Changing maintainer for ufs DWC.

Johannes Thumshirn (14):
      scsi: fc: move FC transport's bsg code to bsg-lib
      block: add bsg_job_put() and bsg_job_get()
      scsi: fc: use bsg_job_done
      scsi: fc: use bsg_softirq_done
      scsi: fc: Use bsg_destroy_job
      scsi: change FC drivers to use 'struct bsg_job'
      block: add reference counting for struct bsg_job
      scsi: fc: implement kref backed reference counting
      scsi: libfc: don't set FC_RQST_STATE_DONE before calling fc_bsg_jobdone()
      scsi: fc: provide fc_bsg_to_rport() helper
      scsi: fc: provide fc_bsg_to_shost() helper
      scsi: fc: Export fc_bsg_jobdone and use it in FC drivers
      scsi: don't use fc_bsg_job::request and fc_bsg_job::reply directly
      scsi: Get rid of struct fc_bsg_buffer

John Garry (5):
      scsi: hisi_sas: support deferred probe for v2 hw
      scsi: hisi_sas: use atomic64_t for hisi_sas_device.running_req
      scsi: hisi_sas: Add v2 hw support for different refclk
      scsi: hisi_sas: Add device tree support for hip07
      scsi: devicetree: bindings: hisi_sas: add hip07 support

Kashyap Desai (7):
      scsi: megaraid_sas: driver version upgrade
      scsi: megaraid_sas: Do not set MPI2_TYPE_CUDA for JBOD FP path for FW which does not support JBOD sequence map
      MAINTAINERS: Update megaraid maintainers list
      scsi: megaraid_sas: Send SYNCHRONIZE_CACHE for VD to firmware
      scsi: megaraid_sas: Do not fire DCMDs during PCI shutdown/detach
      scsi: megaraid_sas: Send correct PhysArm to FW for R1 VD downgrade
      scsi: megaraid_sas: For SRIOV enabled firmware, ensure VF driver waits for 30secs before reset

Kiwoong Kim (4):
      scsi: ufs: introduce UFSHCD_QUIRK_PRDT_BYTE_GRAN quirk
      scsi: ufs: introduce hibern8_notify callback
      scsi: ufs: introduce setup_task_mgmt
      scsi: ufs: introduce setup_xfer_req callback

Martin K. Petersen (1):
      scsi: libfc: Revert " libfc: use offload EM instance again instead jumping to next EM"

Matthew R. Ochs (10):
      scsi: cxlflash: Migrate scsi command pointer to AFU command
      scsi: cxlflash: Migrate IOARRIN specific routines to function pointers
      scsi: cxlflash: Cleanup queuecommand()
      scsi: cxlflash: Cleanup send_tmf()
      scsi: cxlflash: Remove AFU command lock
      scsi: cxlflash: Wait for active AFU commands to timeout upon tear down
      scsi: cxlflash: Remove private command pool
      scsi: cxlflash: Use cmd_size for private commands
      scsi: cxlflash: Allocate memory instead of using command pool for AFU sync
      scsi: cxlflash: Remove unused buffer from AFU command

Michael Cyr (6):
      scsi: ibmvscsis: Issues from Dan Carpenter/Smatch
      scsi: ibmvscsis: Return correct partition name/# to client
      scsi: ibmvscsis: Clean up properly if target_submit_cmd/tmr fails
      scsi: ibmvscsis: Synchronize cmds at remove time
      scsi: ibmvscsis: Synchronize cmds at tpg_enable_store time
      scsi: ibmvscsis: Rearrange functions for future patches

Milan P. Gandhi (1):
      scsi: lpfc: Fix few small typos in lpfc_scsi.c

Oleksandr Khoshaba (1):
      scsi: qla4xxx: print MAC and SID via %p[mM][R]

Ondrej Zary (2):
      scsi: g_NCR5380: Fix release_region in error handling
      scsi: g_NCR5380: Merge g_NCR5380 and g_NCR5380_mmio drivers

Pan Bian (2):
      scsi: be2iscsi: set errno on error path
      scsi: be2iscsi: set errno on error path

Quentin Lambert (5):
      scsi: cxgb4i: Add a missing call to neigh_release
      scsi: dpt_i2o: Add a missing call to kfree
      scsi: isci: Add a missing call to pci_unmap_biosrom
      scsi: aic94xx: Add a missing call to kfree
      scsi: pmcraid: Add missing resource releases

Rasmus Villemoes (1):
      scsi: hpsa: use %phN for short hex dumps

Santosh Y (1):
      scsi: ufs: Add missing UFS_MASK macro definition

Satish Kharat (2):
      scsi: fnic: Correcting rport check location in fnic_queuecommand_lck
      MAINTAINERS: Updating maintainers list for Cisco FNI and SNIC drivers

Souptick Joarder (1):
      scsi: lpfc: Replace pci_pool_alloc by pci_pool_zalloc

Subhash Jadavani (5):
      scsi: ufs: change device rails hpm mode ramp up sequence
      scsi: ufs: suspend clock scaling at the start of suspend
      scsi: ufshcd: release resources if probe fails
      scsi: ufs: fix race between clock gating and devfreq scaling work
      scsi: ufshcd: Fix possible unclocked register access

Suganath Prabu Subramani (11):
      scsi: mpt3sas: Bump driver version as "14.101.00.00"
      scsi: mpt3sas: Fix for Endianness issue.
      scsi: mpt3sas: Use the new MPI 2.6 32-bit Atomic Request Descriptors for SAS35 devices.
      scsi: mpt3sas: set EEDP-escape-flags for SAS35 devices.
      scsi: mpt3sas: Increased/Additional MSIX support for SAS35 devices.
      scsi: mpt3sas: Added Device ID's for SAS35 devices and updated MPI header.
      scsi: mpt3sas: Bump driver version as "14.100.00.00"
      scsi: mpt3sas: Remove unused macro "MPT_DEVICE_TLR_ON"
      scsi: mpt3sas: Implement device_remove_in_progress check in IOCTL path
      scsi: mpt3sas: Fix for incorrect numbers for MSIX vectors enabled when non RDPQ card is enumerated first.
      scsi: mpt3sas: Fix for improper info displayed in var log, while blocking or unblocking the device.

Tomas Henzl (1):
      scsi: megaraid-sas: request irqs later

Uma Krishnan (4):
      scsi: cxlflash: Avoid command room violation
      scsi: cxlflash: Improve context_reset() logic
      scsi: cxlflash: Fix crash in cxlflash_restore_luntable()
      scsi: cxlflash: Set sg_tablesize to 1 instead of SG_NONE

Venkat Gopalakrishnan (2):
      scsi: ufs: optimize clock gate work
      scsi: ufshcd: Fix race between clk scaling and ungate work

Vivek Gautam (12):
      scsi: ufs: qcom: Don't free resource-managed kmalloc element
      scsi: ufs: qcom: Add phy_exit call in hcd exit path
      phy: qcom-ufs: Remove common layer phy exit callback
      scsi: ufs-qcom: phy/hcd: Refactoring phy clock handling
      phy: qcom-ufs-qmp-xx: Move clock and regulator init out of phy init
      phy: qcom-ufs: Remove unnecessary function declarations
      phy: qcom-ufs-qmp-xx: Discard remove callback for drivers.
      phy: qcom-ufs: Skip obtaining rx/tx_iface_clk for msm8996 based phy
      phy: qcom-ufs-14nm: Add new compatible for msm8996 based phy
      phy: qcom-ufs: Cleanup clock and regulator initialization
      phy: qcom-ufs: Use devm sibling of kstrdup for regulator names
      phy: qcom-ufs: Remove unnecessary BUG_ON

Xiang Chen (10):
      scsi: hisi_sas: add PHY set linkrate support for v1 and v2 hw
      scsi: hisi_sas: check SATA FIS when directly attaching SATA device
      scsi: hisi_sas: modify some values in get_ata_protocol()
      scsi: hisi_sas: delete repeated configuration in free_device_v2_hw()
      scsi: hisi_sas: modify return value of hisi_sas_query_task()
      scsi: hisi_sas: replace WARN_ON() with dev_warn() for internal abort
      scsi: hisi_sas: fix port form bug in hisi_sas_port_notify_formed()
      scsi: hisi_sas: only process broadcast change in phy_bcast_v2_hw()
      scsi: hisi_sas: alloc queue id of slot according to device id
      scsi: hisi_sas: add v2 hw support for ECC and AXI bus fatal error

Xiaofei Tan (1):
      scsi: hisi_sas: fix free'ing in probe and remove

Xose Vazquez Perez (1):
      scsi: scsi_devinfo: remove synchronous ALUA for NETAPP devices

Yaniv Gardi (4):
      scsi: ufs: fix condition in which DME command failure msg is printed out
      scsi: ufs: update device descriptor maximum size
      scsi: ufs: add index details to query error messages
      scsi: ufs: fix bugs related to null pointer access and array size

Zang Leigang (1):
      scsi: ufs: introduce a new ufshcd_statea UFSHCD_STATE_EH_SCHEDULED

subhashj@codeaurora.org (6):
      scsi: ufs: fix default power mode to FAST/SLOW
      scsi: ufs: optimize system suspend handling
      scsi: ufs: issue link starup 2 times if device isn't active
      scsi: ufs: ensure that host pa_tactivate is higher than device
      scsi: ufs: increase the scsi query response timeout
      scsi: ufs: fix failure to read the string descriptor

And the diffstat:

.../devicetree/bindings/scsi/hisilicon-sas.txt     |    1 +
 Documentation/devicetree/bindings/ufs/ufs-qcom.txt |    7 +-
 MAINTAINERS                                        |   32 +-
 block/blk-mq-cpumap.c                              |    1 +
 block/blk-mq.h                                     |    1 -
 block/bsg-lib.c                                    |   23 +-
 drivers/block/cciss_scsi.c                         |   72 +-
 drivers/message/fusion/mptbase.c                   |   28 +-
 drivers/message/fusion/mptscsih.c                  |   11 +-
 drivers/phy/phy-qcom-ufs-i.h                       |    7 +-
 drivers/phy/phy-qcom-ufs-qmp-14nm.c                |   72 +-
 drivers/phy/phy-qcom-ufs-qmp-20nm.c                |   65 +-
 drivers/phy/phy-qcom-ufs.c                         |  273 +++--
 drivers/s390/scsi/zfcp_ext.h                       |    4 +-
 drivers/s390/scsi/zfcp_fc.c                        |   36 +-
 drivers/scsi/Kconfig                               |   35 +-
 drivers/scsi/Makefile                              |    1 -
 drivers/scsi/NCR5380.c                             |  137 +--
 drivers/scsi/NCR5380.h                             |   87 +-
 drivers/scsi/aacraid/aacraid.h                     |    1 -
 drivers/scsi/aacraid/comminit.c                    |   10 +-
 drivers/scsi/aacraid/commsup.c                     |   25 +-
 drivers/scsi/aacraid/linit.c                       |   20 +-
 drivers/scsi/advansys.c                            |    3 +
 drivers/scsi/aic94xx/aic94xx_hwi.c                 |    5 +-
 drivers/scsi/arcmsr/arcmsr.h                       |    5 +-
 drivers/scsi/arcmsr/arcmsr_hba.c                   |   82 +-
 drivers/scsi/arm/cumana_1.c                        |   98 +-
 drivers/scsi/arm/oak.c                             |   34 +-
 drivers/scsi/atari_scsi.c                          |   77 +-
 drivers/scsi/be2iscsi/be_main.c                    |    8 +-
 drivers/scsi/bfa/bfa_ioc.h                         |   30 +-
 drivers/scsi/bfa/bfad_bsg.c                        |   62 +-
 drivers/scsi/bfa/bfad_im.h                         |    4 +-
 drivers/scsi/bnx2fc/bnx2fc_fcoe.c                  |    1 -
 drivers/scsi/bnx2fc/bnx2fc_tgt.c                   |    3 +-
 drivers/scsi/cxgbi/cxgb4i/cxgb4i.c                 |    2 +-
 drivers/scsi/cxlflash/common.h                     |   39 +-
 drivers/scsi/cxlflash/lunmgt.c                     |    6 +
 drivers/scsi/cxlflash/main.c                       |  410 ++------
 drivers/scsi/cxlflash/sislite.h                    |    2 +-
 drivers/scsi/device_handler/scsi_dh_alua.c         |   16 +-
 drivers/scsi/dmx3191d.c                            |   33 +-
 drivers/scsi/dpt_i2o.c                             |    7 +-
 drivers/scsi/fcoe/fcoe.c                           |   25 +-
 drivers/scsi/fcoe/fcoe_ctlr.c                      |  157 ++-
 drivers/scsi/fcoe/fcoe_sysfs.c                     |   83 +-
 drivers/scsi/fnic/fnic_scsi.c                      |   30 +-
 drivers/scsi/fnic/fnic_trace.c                     |    4 +-
 drivers/scsi/fnic/fnic_trace.h                     |    2 +-
 drivers/scsi/fnic/vnic_dev.c                       |   10 +-
 drivers/scsi/g_NCR5380.c                           |  296 +++---
 drivers/scsi/g_NCR5380.h                           |   32 +-
 drivers/scsi/g_NCR5380_mmio.c                      |   10 -
 drivers/scsi/hisi_sas/hisi_sas.h                   |   11 +-
 drivers/scsi/hisi_sas/hisi_sas_main.c              |   67 +-
 drivers/scsi/hisi_sas/hisi_sas_v1_hw.c             |   79 +-
 drivers/scsi/hisi_sas/hisi_sas_v2_hw.c             |  556 +++++++++-
 drivers/scsi/hpsa.c                                |  252 ++---
 drivers/scsi/hpsa.h                                |    6 +-
 drivers/scsi/ibmvscsi/ibmvfc.c                     |   40 +-
 drivers/scsi/ibmvscsi_tgt/ibmvscsi_tgt.c           | 1096 +++++++++-----------
 drivers/scsi/ibmvscsi_tgt/ibmvscsi_tgt.h           |    5 +-
 drivers/scsi/ipr.c                                 |  174 +---
 drivers/scsi/ipr.h                                 |    7 +-
 drivers/scsi/ips.c                                 |   13 +-
 drivers/scsi/isci/host.h                           |    1 -
 drivers/scsi/isci/init.c                           |   23 +-
 drivers/scsi/isci/probe_roms.c                     |    1 +
 drivers/scsi/isci/remote_node_context.c            |    7 +-
 drivers/scsi/isci/request.c                        |    2 +-
 drivers/scsi/libfc/fc_disc.c                       |   61 +-
 drivers/scsi/libfc/fc_elsct.c                      |    2 +-
 drivers/scsi/libfc/fc_exch.c                       |  256 +++--
 drivers/scsi/libfc/fc_fcp.c                        |  235 +++--
 drivers/scsi/libfc/fc_libfc.c                      |    2 +-
 drivers/scsi/libfc/fc_lport.c                      |  126 +--
 drivers/scsi/libfc/fc_rport.c                      |  561 ++++++----
 drivers/scsi/lpfc/lpfc.h                           |    6 +
 drivers/scsi/lpfc/lpfc_attr.c                      |  160 +--
 drivers/scsi/lpfc/lpfc_bsg.c                       |  422 +++++---
 drivers/scsi/lpfc/lpfc_bsg.h                       |   10 +
 drivers/scsi/lpfc/lpfc_crtn.h                      |    6 +-
 drivers/scsi/lpfc/lpfc_els.c                       |    2 +-
 drivers/scsi/lpfc/lpfc_hw4.h                       |   18 +-
 drivers/scsi/lpfc/lpfc_init.c                      |  116 ++-
 drivers/scsi/lpfc/lpfc_scsi.c                      |   56 +-
 drivers/scsi/lpfc/lpfc_sli.c                       |   41 +-
 drivers/scsi/lpfc/lpfc_version.h                   |    2 +-
 drivers/scsi/mac_scsi.c                            |   83 +-
 drivers/scsi/megaraid/megaraid_sas.h               |    8 +-
 drivers/scsi/megaraid/megaraid_sas_base.c          |  136 ++-
 drivers/scsi/megaraid/megaraid_sas_fp.c            |    6 +-
 drivers/scsi/megaraid/megaraid_sas_fusion.c        |   23 +-
 drivers/scsi/mpt3sas/mpi/mpi2_cnfg.h               |    7 +
 drivers/scsi/mpt3sas/mpt3sas_base.c                |  186 +++-
 drivers/scsi/mpt3sas/mpt3sas_base.h                |   39 +-
 drivers/scsi/mpt3sas/mpt3sas_config.c              |    2 +-
 drivers/scsi/mpt3sas/mpt3sas_ctl.c                 |   69 +-
 drivers/scsi/mpt3sas/mpt3sas_ctl.h                 |    1 +
 drivers/scsi/mpt3sas/mpt3sas_scsih.c               |  129 ++-
 drivers/scsi/mpt3sas/mpt3sas_transport.c           |    8 +-
 drivers/scsi/mvsas/mv_94xx.c                       |    2 +-
 drivers/scsi/pmcraid.c                             |   10 +-
 drivers/scsi/qla2xxx/qla_bsg.c                     |  449 ++++----
 drivers/scsi/qla2xxx/qla_def.h                     |    2 +-
 drivers/scsi/qla2xxx/qla_gbl.h                     |    4 +-
 drivers/scsi/qla2xxx/qla_iocb.c                    |   13 +-
 drivers/scsi/qla2xxx/qla_isr.c                     |   52 +-
 drivers/scsi/qla2xxx/qla_mr.c                      |   15 +-
 drivers/scsi/qla4xxx/ql4_def.h                     |   18 +-
 drivers/scsi/qla4xxx/ql4_glbl.h                    |    1 -
 drivers/scsi/qla4xxx/ql4_isr.c                     |   27 +-
 drivers/scsi/qla4xxx/ql4_mbx.c                     |    5 +-
 drivers/scsi/qla4xxx/ql4_nx.c                      |   97 +-
 drivers/scsi/qla4xxx/ql4_os.c                      |   15 +-
 drivers/scsi/scsi_devinfo.c                        |    2 -
 drivers/scsi/scsi_lib.c                            |   51 +-
 drivers/scsi/scsi_transport_fc.c                   |  455 ++------
 drivers/scsi/scsi_transport_srp.c                  |   52 +-
 drivers/scsi/sd.c                                  |    4 +-
 drivers/scsi/smartpqi/smartpqi.h                   |    2 -
 drivers/scsi/smartpqi/smartpqi_init.c              |  102 +-
 drivers/scsi/storvsc_drv.c                         |    4 +-
 drivers/scsi/sun3_scsi.c                           |   80 +-
 drivers/scsi/ufs/ufs-qcom.c                        |   39 +-
 drivers/scsi/ufs/ufs.h                             |    5 +-
 drivers/scsi/ufs/ufs_quirks.h                      |    9 +
 drivers/scsi/ufs/ufshcd-pci.c                      |    2 +
 drivers/scsi/ufs/ufshcd-pltfrm.c                   |    5 +-
 drivers/scsi/ufs/ufshcd.c                          |  482 +++++++--
 drivers/scsi/ufs/ufshcd.h                          |   46 +-
 drivers/scsi/ufs/ufshci.h                          |    3 +
 drivers/scsi/ufs/unipro.h                          |    4 +
 drivers/target/tcm_fc/tfc_cmd.c                    |   20 +-
 drivers/target/tcm_fc/tfc_io.c                     |    4 +-
 include/linux/blk-mq.h                             |    1 +
 include/linux/bsg-lib.h                            |    4 +
 include/linux/phy/phy-qcom-ufs.h                   |   18 -
 include/scsi/libfc.h                               |  206 +---
 include/scsi/scsi_host.h                           |    8 +
 include/scsi/scsi_transport_fc.h                   |   62 +-
 142 files changed, 5456 insertions(+), 4568 deletions(-)
 delete mode 100644 drivers/scsi/g_NCR5380_mmio.c

James
