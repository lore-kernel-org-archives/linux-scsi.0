From: James Bottomley <James.Bottomley@HansenPartnership.com>
Subject: [GIT PULL] first round of SCSI updates for the 4.12+ merge window
Date: Tue, 04 Jul 2017 08:24:01 -0700
Message-ID: <1499181841.2770.7.camel@HansenPartnership.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from bedivere.hansenpartnership.com ([66.63.167.143]:35360 "EHLO
        bedivere.hansenpartnership.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1752540AbdGDPYF (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Tue, 4 Jul 2017 11:24:05 -0400
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Andrew Morton <akpm@linux-foundation.org>, Linus Torvalds <torvalds@linux-foundation.org>
Cc: linux-scsi <linux-scsi@vger.kernel.org>, linux-kernel <linux-kernel@vger.kernel.org>

This is mostly updates of the usual suspects: lpfc, qla2xxx, bnx2fc,
qedf, hpsa, hisi_sas, smartpqi, cxlflash, aacraid, csiostor along with
a host of minor and miscellaneous changes.

The major problem with this merge is a conflict with the block tree.
 It's actually only an API rename in block, but we've changed and
consolidated the code where the rename occurred in scsi_lib.c.  I've
attached my proposed resolution below.

The patch is available here:

git://git.kernel.org/pub/scm/linux/kernel/git/jejb/scsi.git scsi-misc

The short changelog is:

Adrian Hunter (2):
      scsi: ufshcd-pci: Add Intel CNL support
      scsi: ufshcd-pci: Fix PM config

Arnd Bergmann (2):
      scsi: qla2xxx: avoid unused-function warning
      scsi: smartpqi: mark PM functions as __maybe_unused

Arvind Yadav (2):
      scsi: ibmvfc: constify dev_pm_ops structures.
      scsi: ibmvscsi: constify dev_pm_ops structures.

Bart Van Assche (14):
      scsi: Remove the definition of VLC_SA_RECEIVE_CREDENTIAL
      scsi: xen-scsifront: Remove code that zeroes driver-private command data
      scsi: virtio_scsi: Remove code that zeroes driver-private command data
      scsi: snic: Remove code that zeroes driver-private command data
      scsi: Make scsi_mq_prep_fn() call scsi_init_command()
      scsi: Introduce scsi_mq_sgl_size()
      scsi: Only add commands to the device command list if required by the LLD
      scsi: Make __scsi_remove_device go straight from BLOCKED to DEL
      scsi: Introduce scsi_start_queue()
      scsi: Protect SCSI device state changes with a mutex
      scsi: Create two versions of scsi_internal_device_unblock()
      scsi: Split scsi_internal_device_block()
      scsi: Avoid that scsi_exit_rq() triggers a use-after-free
      scsi: qla2xxx: Remove an unused structure member

Binoy Jayan (2):
      scsi: esas2r: Replace semaphore fs_api_semaphore with mutex
      scsi: esas2r: Replace semaphore fm_api_semaphore with mutex

Chad Dupuis (22):
      scsi: bnx2fc: Update version number to 2.11.8.
      scsi: bnx2fc: Make rport_terminate_io callback a NOOP.
      scsi: bnx2fc: If IO is still in cleanup then do not return to SCSI layer.
      scsi: bnx2fc: Adjust bnx2fc_npiv_create_vports for WWNNs from NVRAM that are zero.
      scsi: bnx2fc: Update copyright for 2017.
      scsi: bnx2fc: Check for connection offload before sending RRQ.
      scsi: bnx2fc: Add filters to the non-offload FCoE receive path.
      scsi: qedf: Update version number to 8.18.22.0.
      scsi: qedf: Add change_queue_depth member to scsi_host_template().
      scsi: qedf: Change cmd_per_lun in scsi_host_template to 32 to increase performance.
      scsi: qedf: Move some prints to a debug level so they do not print when no debugging is enabled.
      scsi: qedf: Fixup unnecessary parantheses around test_bit operations.
      scsi: qedf: Add non-offload receive filters.
      scsi: qedf: Add bus_reset No-op.
      scsi: qedf: Use same logic for SCSI host reset and FC lip_reset.
      scsi: qedf: Set qed logging level to QED_LEVEL_NOTICE.
      scsi: qedf: Add fka_period SCSI host attribute to show fip keep alive period.
      scsi: qedf: Check that fcport is offloaded before dereferencing pointers in initiate_abts|cleanup.
      scsi: qedf: Look at all descriptors when processing a clear virtual link.
      scsi: qedf: Honor qed_ops->common->set_fp_int() return code.
      scsi: qedf: Update copyright to 2017.
      scsi: qedf: Enable basic FDMI information.

Christoph Hellwig (5):
      scsi: default to scsi-mq
      scsi: sgiwd93: switch to dma_alloc_attrs
      scsi: 53c700: switch to dma_alloc_attrs
      scsi: scsi_dh_alua: remove synchronous STPG support
      scsi: remove various unused blist flags

Christophe JAILLET (3):
      scsi: qedf: Merge a few quoted strings split across lines
      scsi: qedf: Use 'dma_zalloc_coherent' to reduce code verbosity.
      scsi: qedf: Fix a return value in case of error in 'qedf_alloc_global_queues'

Christos Gkekas (1):
      scsi: qedi: Remove comparison of u16 idx with zero.

Colin Ian King (8):
      scsi: snic: fix a couple of spelling mistakes/typos
      scsi: qla2xxx: fix a bunch of typos and spelling mistakes
      scsi: hpsa: fix spelling mistake: "encrypytion" -> "encryption"
      scsi: hptiop: make function hptiop_iop_request_callback_itl static
      scsi: aacraid: fix leak of data from stack back to userspace
      scsi: qla2xxx: remove redundant null check on tgt
      scsi: lpfc: make a couple of functions static
      scsi: lpfc: fix spelling mistake "entrys" -> "entries"

Corentin Labbe (2):
      scsi: qla2xxx: remove writeq/readq function definitions
      scsi: smartpqi: remove writeq/readq function definitions

Dan Carpenter (3):
      scsi: lpfc: don't double count abort errors
      scsi: lpfc: spin_lock_irq() is not nestable
      scsi: bnx2i: missing error code in bnx2i_ep_connect()

Don Brace (11):
      scsi: hpsa: bump driver version
      scsi: hpsa: remove abort handler
      scsi: hpsa: send ioaccel requests with 0 length down raid path
      scsi: hpsa: correct queue depth for externals
      scsi: hpsa: cleanup reset handler
      scsi: hpsa: correct resets on retried commands
      scsi: hpsa: rescan later if reset in progress
      scsi: hpsa: do not reset enclosures
      scsi: hpsa: update reset handler
      scsi: hpsa: do not get enclosure info for external devices
      scsi: hpsa: update identify physical device structure

Duane Grigsby (5):
      scsi: qla2xxx: Use FC-NVMe FC4 type for FDMI registration
      scsi: qla2xxx: Send FC4 type NVMe to the management server
      scsi: qla2xxx: Add FC-NVMe F/W initialization and transport registration
      scsi: qla2xxx: Add FC-NVMe command handling
      scsi: qla2xxx: Add FC-NVMe port discovery and PRLI handling

Dupuis, Chad (1):
      scsi: qedf: Check if sense buffer has been allocated during completion

Ewan D. Milne (1):
      scsi: Add STARGET_CREATED_REMOVE state to scsi_target_state

Gustavo A. R. Silva (1):
      scsi: hisi_sas: add null check before indirect pointer dereference

Himanshu Madhani (3):
      qla2xxx: Fix NVMe entry_type for iocb packet on BE system
      scsi: qla2xxx: Update Driver version to 10.00.00.00-k
      scsi: qla2xxx: Fix compile warning

James Smart (30):
      scsi: lpfc: fix refcount error on node list
      scsi: lpfc: Fix nvme io stoppage after link bounce
      scsi: lpfc: update to revision to 11.4.0.1
      scsi: lpfc: Driver responds LS_RJT to Beacon Off ELS - Linux
      scsi: lpfc: Fix crash in lpfc_sli_ringtxcmpl_put when nvmet gets an abort request.
      scsi: lpfc: Fix crash doing IO with resets
      scsi: lpfc: Fix crash after firmware flash when IO is running.
      scsi: lpfc: Fix SLI3 drivers attempting NVME ELS commands.
      scsi: lpfc: Break up IO ctx list into a separate get and put list
      scsi: lpfc: Reduce time spent in IRQ for received NVME commands
      scsi: lpfc: Vport creation is failing with "Link Down" error
      scsi: lpfc: Fix nvme_info sysfs output to be consistent
      scsi: lpfc: Fix system panic when express lane enabled.
      scsi: lpfc: update to revision to 11.4.0.0
      scsi: lpfc: Add auto EQ delay logic
      scsi: lpfc: Fix defects reported by Coverity Scan
      scsi: lpfc: Fix vports not logging into target
      scsi: lpfc: Fix PRLI retry handling when target rejects it.
      scsi: lpfc: Null pointer dereference when log_verbose is set to 0xffffffff
      scsi: lpfc: Fix System panic after loading the driver
      scsi: lpfc: Fix crash on powering off BFS VM with passthrough device
      scsi: lpfc: Fix return value of board_mode store routine in case of online failure
      scsi: lpfc: Fix counters so outstandng NVME IO count is accurate
      scsi: lpfc: Fix Port going offline after multiple resets.
      scsi: lpfc: Fix nvmet node ref count handling
      scsi: lpfc: Fix Lun Priority level shown as NA
      scsi: lpfc: Add changes to assist in NVMET debugging
      scsi: lpfc: Fix nvme port role handling in sysfs and debugfs handlers.
      scsi: lpfc: Fix transition nvme-i rport handling to nport only.
      scsi: lpfc: Add nvme initiator devloss support

Jia-Ju Bai (1):
      scsi: megaraid: Fix a sleep-in-atomic bug

Joe Carnuccio (1):
      scsi: qla2xxx: Retain loop test for fwdump length exceeding buffer length

Johan Hovold (1):
      scsi: sun_esp: fix device reference leaks

Johannes Berg (1):
      scsi: qla2xxx: don't include <generated/utsrelease.h>

Johannes Thumshirn (2):
      scsi: qla2xxx: Protect access to qpair members with qpair->qp_lock
      scsi: sas: scsi_queue_work can fail, so make callers aware

John Garry (6):
      scsi: hisi_sas: redefine hisi_sas_phy.phy_type as u32
      scsi: hisi_sas: add initialisation for v3 pci-based controller
      scsi: hisi_sas: add skeleton v3 hw driver
      scsi: hisi_sas: create hisi_sas_get_fw_info()
      scsi: hisi_sas: add pci_dev in hisi_hba struct
      scsi: hisi_sas: define hisi_sas_device.device_id as int

Kees Cook (1):
      scsi: csiostor: Avoid content leaks and casts

Kefeng Wang (1):
      scsi: fc: drop residual tsk_mgmt_response and it_nexus_response

Kevin Barnett (35):
      scsi: smartpqi: bump driver version
      scsi: smartpqi: add module parameters
      scsi: smartpqi: cleanup list initialization
      scsi: smartpqi: add raid level show
      scsi: smartpqi: make ioaccel references consistent
      scsi: smartpqi: enhance device add and remove messages
      scsi: smartpqi: update timeout on admin commands
      scsi: smartpqi: map more raid errors to SCSI errors
      scsi: smartpqi: cleanup controller branding
      scsi: smartpqi: update rescan worker
      scsi: smartpqi: update device offline
      scsi: smartpqi: correct aio error path
      scsi: smartpqi: add lockup action
      scsi: smartpqi: remove qdepth calculations for logical volumes
      scsi: smartpqi: enhance kdump
      scsi: smartpqi: change return value for LUN reset operations
      scsi: smartpqi: add ptraid support
      scsi: smartpqi: update copyright
      scsi: smartpqi: cleanup messages
      scsi: smartpqi: add new PCI device IDs
      scsi: smartpqi: minor driver cleanup
      scsi: smartpqi: correct BMIC identify physical drive
      scsi: smartpqi: eliminate redundant error messages
      scsi: smartpqi: make pdev pointer names consistent
      scsi: smartpqi: add pqi_wait_for_completion_io
      scsi: smartpqi: correct bdma hw bug
      scsi: smartpqi: add heartbeat check
      scsi: smartpqi: add suspend and resume support
      scsi: smartpqi: enhance resets
      scsi: smartpqi: add supporting events
      scsi: smartpqi: ensure controller is in SIS mode at init
      scsi: smartpqi: add in controller checkpoint for controller lockups.
      scsi: smartpqi: set pci completion timeout
      scsi: smartpqi: cleanup interrupt management
      scsi: smartpqi: correct remove scsi devices

Kyle Fortin (1):
      scsi: libiscsi: use kvzalloc for iscsi_pool_init

Long Li (1):
      scsi: storvsc: use default I/O timeout handler for FC devices

Martin K. Petersen (1):
      scsi: sd: Use sysfs_match_string()

Matthew R. Ochs (11):
      scsi: cxlflash: Update debug prints in reset handlers
      scsi: cxlflash: Update send_tmf() parameters
      scsi: cxlflash: Avoid double free of character device
      scsi: cxlflash: Update TMF command processing
      scsi: cxlflash: Remove zeroing of private command data
      scsi: cxlflash: Support WS16 unmap
      scsi: cxlflash: Support AFU debug
      scsi: cxlflash: Support LUN provisioning
      scsi: cxlflash: Refactor AFU capability checking
      scsi: cxlflash: Introduce host ioctl support
      scsi: cxlflash: Separate AFU internal command handling from AFU sync specifics

Maurizio Lombardi (1):
      scsi: ses: do not add a device to an enclosure if enclosure_add_links() fails.

Michael Schmitz (1):
      scsi: atari_scsi: Use m68k_realnum_memory for FastRAM test

Milan P. Gandhi (2):
      scsi: fcoe: Remove an extra out label in _fcoe_create function
      scsi: fcoe: Fix few small typos in fcoe.c

Paolo Bonzini (1):
      scsi: virtio_scsi: let host do exception handling

Quinn Tran (26):
      scsi: qla2xxx: Include Exchange offload/Extended Login into FW dump
      scsi: qla2xxx: Move target stat counters from vha to qpair.
      scsi: qla2xxx: Remove datasegs_per_cmd and datasegs_per_cont field
      scsi: qla2xxx: Remove unused tgt_enable_64bit_addr flag
      scsi: qla2xxx: Add debug logging routine for qpair
      scsi: qla2xxx: Add function call to qpair for door bell
      scsi: qla2xxx: use shadow register for ISP27XX
      scsi: qla2xxx: move fields from qla_hw_data to qla_qpair
      scsi: qla2xxx: Add fw_started flags to qpair
      scsi: qla2xxx: Add debug knob for user control workload
      scsi: qla2xxx: Enable Target Multi Queue
      scsi: qla2xxx: Preparation for Target MQ.
      scsi: qla2xxx: Combine Active command arrays.
      scsi: qla2xxx: Remove extra register read
      scsi: qla2xxx: Remove unused irq_cmd_count field.
      scsi: qla2xxx: Accelerate SCSI BUSY status generation in target mode
      scsi: qla2xxx: Remove redundant wait when target is stopped.
      scsi: qla2xxx: Add ql2xiniexchg parameter
      scsi: qla2xxx: Turn on FW option for exchange check
      scsi: qla2xxx: Cleanup debug message IDs
      scsi: qla2xxx: Fix name server relogin
      scsi: qla2xxx: Convert 32-bit LUN usage to 64-bit
      scsi: tcm_qla2xxx: Do not allow aborted cmd to advance.
      scsi: qla2xxx: Fix path recovery
      scsi: qla2xxx: Replace usage of spin_lock with spin_lock_irqsave
      scsi: qla2xxx: Allow ABTS, PURX, RIDA on ATIOQ for ISP83XX/27XX

Raghava Aditya Renukunta (19):
      scsi: aacraid: Update driver version to 50834
      scsi: aacraid: Remove reference to Series-9
      scsi: aacraid: Add reset debugging statements
      scsi: aacraid: Enable ctrl reset for both hba and arc
      scsi: aacraid: Make sure ioctl returns on controller reset
      scsi: aacraid: Use correct function to get ctrl health
      scsi: aacraid: Rework aac_src_restart
      scsi: aacraid: Rework SOFT reset code
      scsi: aacraid: Add periodic checks to see IOP reset status
      scsi: aacraid: Rework IOP reset
      scsi: aacraid: Using single reset mask for IOP reset
      scsi: aacraid: Print ctrl status before eh reset
      scsi: aacraid: Log count info of scsi cmds before reset
      scsi: aacraid: Change wait time for fib completion
      scsi: aacraid: Remove reset support from check_health
      scsi: aacraid: Set correct Queue Depth for HBA1000 RAW disks
      scsi: aacraid: Added 32 and 64 queue depth for arc natives
      scsi: aacraid: Fix DMAR issues with iommu=pt
      scsi: aacraid: Remove __GFP_DMA for raw srb memory

Satish Kharat (4):
      scsi: fnic: changing queue command to return result DID_IMM_RETRY when rport is init
      scsi: fnic: correct speed display and add support for 25,40 and 100G
      scsi: fnic: added timestamp reporting in fnic debug stats
      scsi: fnic: Zero io_cmpl_skip on fw reset completion

Sawan Chandak (2):
      scsi: qla2xxx: Fix mailbox failure while deleting Queue pairs
      scsi: qla2xxx: Use flag PFLG_DISCONNECTED.

Scott Teel (1):
      scsi: hpsa: separate monitor events from rescan worker

Seth Forshee (1):
      scsi: aacraid: Don't copy uninitialized stack memory to userspace

Stephen Hemminger (2):
      scsi: storvsc: remove unnecessary channel inbound lock
      scsi: storvsc: use in place iterator function

Szymon Mielczarek (1):
      scsi: ufs: Tidy clocks list head usage

Tyrel Datwyler (1):
      scsi: fix typos and grammar in comments of scsi_transport_fc.c

Uma Krishnan (9):
      scsi: cxlflash: Create character device to provide host management interface
      scsi: cxlflash: Add scsi command abort handler
      scsi: cxlflash: Flush pending commands in cleanup path
      scsi: cxlflash: Track pending scsi commands in each hardware queue
      scsi: cxlflash: Handle AFU sync failures
      scsi: cxlflash: Schedule asynchronous reset of the host
      scsi: cxlflash: Reset hardware queue context via specified register
      scsi: cxlflash: Update cxlflash_afu_sync() to return errno
      scsi: cxlflash: Combine the send queue locks

Varun Prakash (4):
      scsi: cxgb4i: assign rxqs in round robin mode
      scsi: csiostor: update module version
      scsi: csiostor: add check for supported fw version
      scsi: csiostor: add support for Chelsio T6 adapters

Xiang Chen (17):
      scsi: hisi_sas: modify internal abort dev flow for v3 hw
      scsi: hisi_sas: add v3 code to fill some more hw function pointers
      scsi: hisi_sas: add get_wideport_bitmap_v3_hw()
      scsi: hisi_sas: add v3 code to send internal abort command
      scsi: hisi_sas: add v3 code for itct setup and free
      scsi: hisi_sas: add v3 code to send ATA frame
      scsi: hisi_sas: add v3 code to send SMP frame
      scsi: hisi_sas: add v3 code to send SSP frame
      scsi: hisi_sas: add v3 cq interrupt handler
      scsi: hisi_sas: add phy up/down/bcast and channel ISR
      scsi: hisi_sas: add v3 hw PHY init
      scsi: hisi_sas: add v3 hw init
      scsi: hisi_sas: relocate get_ncq_tag_v2_hw()
      scsi: hisi_sas: relocate sata_done_v2_hw()
      scsi: hisi_sas: relocate get_ata_protocol()
      scsi: hisi_sas: optimise the usage of hisi_hba.lock
      scsi: hisi_sas: fix timeout check in hisi_sas_internal_task_abort()

Xiaofei Tan (1):
      scsi: hisi_sas: optimise DMA slot memory

Zang Leigang (1):
      scsi: ufs: flush eh_work when eh_work scheduled.

himanshu.madhani@cavium.com (1):
      scsi: qla2xxx: Update driver version to 9.01.00.00-k

With the diffstat:

 Documentation/ioctl/ioctl-number.txt           |    2 +-
 Documentation/powerpc/cxlflash.txt             |   76 +-
 drivers/hv/channel_mgmt.c                      |    1 -
 drivers/misc/enclosure.c                       |   14 +-
 drivers/scsi/53c700.c                          |    8 +-
 drivers/scsi/Kconfig                           |   11 -
 drivers/scsi/aacraid/aachba.c                  |   17 +-
 drivers/scsi/aacraid/aacraid.h                 |   22 +-
 drivers/scsi/aacraid/commctrl.c                |   19 +-
 drivers/scsi/aacraid/comminit.c                |   18 +-
 drivers/scsi/aacraid/commsup.c                 |   78 +-
 drivers/scsi/aacraid/linit.c                   |  232 ++-
 drivers/scsi/aacraid/src.c                     |  136 +-
 drivers/scsi/atari_scsi.c                      |    2 +-
 drivers/scsi/bnx2fc/57xx_hsi_bnx2fc.h          |    3 +-
 drivers/scsi/bnx2fc/bnx2fc.h                   |    5 +-
 drivers/scsi/bnx2fc/bnx2fc_constants.h         |    3 +-
 drivers/scsi/bnx2fc/bnx2fc_debug.c             |    3 +-
 drivers/scsi/bnx2fc/bnx2fc_debug.h             |    3 +-
 drivers/scsi/bnx2fc/bnx2fc_els.c               |   16 +-
 drivers/scsi/bnx2fc/bnx2fc_fcoe.c              |   62 +-
 drivers/scsi/bnx2fc/bnx2fc_hwi.c               |    3 +-
 drivers/scsi/bnx2fc/bnx2fc_io.c                |   14 +-
 drivers/scsi/bnx2fc/bnx2fc_tgt.c               |    3 +-
 drivers/scsi/bnx2i/bnx2i_iscsi.c               |    3 +-
 drivers/scsi/csiostor/csio_hw.c                |   98 +-
 drivers/scsi/csiostor/csio_hw.h                |    1 +
 drivers/scsi/csiostor/csio_hw_chip.h           |   14 +
 drivers/scsi/csiostor/csio_hw_t5.c             |   29 +-
 drivers/scsi/csiostor/csio_init.c              |    6 +-
 drivers/scsi/csiostor/csio_init.h              |    2 +-
 drivers/scsi/csiostor/csio_lnode.c             |   43 +-
 drivers/scsi/csiostor/csio_wr.c                |    4 +-
 drivers/scsi/cxgbi/cxgb4i/cxgb4i.c             |    5 +-
 drivers/scsi/cxgbi/libcxgbi.h                  |    1 +
 drivers/scsi/cxlflash/common.h                 |   48 +-
 drivers/scsi/cxlflash/main.c                   | 1048 ++++++++--
 drivers/scsi/cxlflash/main.h                   |    7 +
 drivers/scsi/cxlflash/sislite.h                |   27 +-
 drivers/scsi/cxlflash/superpipe.c              |   34 +-
 drivers/scsi/cxlflash/vlun.c                   |   89 +-
 drivers/scsi/device_handler/scsi_dh_alua.c     |   27 +-
 drivers/scsi/esas2r/esas2r.h                   |    4 +-
 drivers/scsi/esas2r/esas2r_init.c              |    4 +-
 drivers/scsi/esas2r/esas2r_ioctl.c             |   10 +-
 drivers/scsi/fcoe/fcoe.c                       |   12 +-
 drivers/scsi/fnic/fnic_debugfs.c               |    1 +
 drivers/scsi/fnic/fnic_fcs.c                   |   24 +
 drivers/scsi/fnic/fnic_io.h                    |    9 +
 drivers/scsi/fnic/fnic_main.c                  |   14 +-
 drivers/scsi/fnic/fnic_scsi.c                  |   17 +-
 drivers/scsi/fnic/fnic_stats.h                 |    7 +
 drivers/scsi/fnic/fnic_trace.c                 |   24 +
 drivers/scsi/hisi_sas/Kconfig                  |   10 +-
 drivers/scsi/hisi_sas/Makefile                 |    1 +
 drivers/scsi/hisi_sas/hisi_sas.h               |   91 +-
 drivers/scsi/hisi_sas/hisi_sas_main.c          |  436 +++--
 drivers/scsi/hisi_sas/hisi_sas_v1_hw.c         |   82 +-
 drivers/scsi/hisi_sas/hisi_sas_v2_hw.c         |  216 +--
 drivers/scsi/hisi_sas/hisi_sas_v3_hw.c         | 1846 ++++++++++++++++++
 drivers/scsi/hpsa.c                            |  851 ++-------
 drivers/scsi/hpsa.h                            |    4 +-
 drivers/scsi/hpsa_cmd.h                        |   20 +-
 drivers/scsi/hptiop.c                          |    2 +-
 drivers/scsi/ibmvscsi/ibmvfc.c                 |    2 +-
 drivers/scsi/ibmvscsi/ibmvscsi.c               |    2 +-
 drivers/scsi/libiscsi.c                        |    4 +-
 drivers/scsi/libsas/sas_event.c                |   36 +-
 drivers/scsi/libsas/sas_internal.h             |    4 +-
 drivers/scsi/lpfc/lpfc.h                       |   23 +-
 drivers/scsi/lpfc/lpfc_attr.c                  |  101 +-
 drivers/scsi/lpfc/lpfc_ct.c                    |   31 +-
 drivers/scsi/lpfc/lpfc_debugfs.c               |   83 +-
 drivers/scsi/lpfc/lpfc_els.c                   |   55 +-
 drivers/scsi/lpfc/lpfc_hbadisc.c               |   17 +-
 drivers/scsi/lpfc/lpfc_hw4.h                   |   14 +
 drivers/scsi/lpfc/lpfc_init.c                  |  163 +-
 drivers/scsi/lpfc/lpfc_nvme.c                  |  211 +--
 drivers/scsi/lpfc/lpfc_nvme.h                  |    2 -
 drivers/scsi/lpfc/lpfc_nvmet.c                 |  308 ++-
 drivers/scsi/lpfc/lpfc_nvmet.h                 |   14 +-
 drivers/scsi/lpfc/lpfc_scsi.c                  |   19 +-
 drivers/scsi/lpfc/lpfc_sli.c                   |  106 +-
 drivers/scsi/lpfc/lpfc_sli.h                   |    1 +
 drivers/scsi/lpfc/lpfc_sli4.h                  |   21 +-
 drivers/scsi/lpfc/lpfc_version.h               |    2 +-
 drivers/scsi/megaraid/megaraid_mm.c            |    2 +-
 drivers/scsi/mpt3sas/mpt3sas_scsih.c           |    8 +-
 drivers/scsi/qedf/drv_fcoe_fw_funcs.c          |    2 +-
 drivers/scsi/qedf/drv_fcoe_fw_funcs.h          |    2 +-
 drivers/scsi/qedf/drv_scsi_fw_funcs.c          |    2 +-
 drivers/scsi/qedf/drv_scsi_fw_funcs.h          |    2 +-
 drivers/scsi/qedf/qedf.h                       |    2 +-
 drivers/scsi/qedf/qedf_attr.c                  |   59 +-
 drivers/scsi/qedf/qedf_dbg.h                   |    2 +-
 drivers/scsi/qedf/qedf_debugfs.c               |    2 +-
 drivers/scsi/qedf/qedf_els.c                   |    8 +-
 drivers/scsi/qedf/qedf_fip.c                   |   22 +-
 drivers/scsi/qedf/qedf_hsi.h                   |    2 +-
 drivers/scsi/qedf/qedf_io.c                    |   37 +-
 drivers/scsi/qedf/qedf_main.c                  |  203 +-
 drivers/scsi/qedf/qedf_version.h               |    8 +-
 drivers/scsi/qedi/qedi_fw.c                    |    4 +-
 drivers/scsi/qla2xxx/Kconfig                   |    1 +
 drivers/scsi/qla2xxx/Makefile                  |    2 +-
 drivers/scsi/qla2xxx/qla_attr.c                |    8 +-
 drivers/scsi/qla2xxx/qla_bsg.c                 |    4 +-
 drivers/scsi/qla2xxx/qla_dbg.c                 |  161 +-
 drivers/scsi/qla2xxx/qla_dbg.h                 |   17 +
 drivers/scsi/qla2xxx/qla_def.h                 |  182 +-
 drivers/scsi/qla2xxx/qla_dfs.c                 |  145 +-
 drivers/scsi/qla2xxx/qla_fw.h                  |   35 +-
 drivers/scsi/qla2xxx/qla_gbl.h                 |   40 +-
 drivers/scsi/qla2xxx/qla_gs.c                  |  275 ++-
 drivers/scsi/qla2xxx/qla_init.c                |  606 ++++--
 drivers/scsi/qla2xxx/qla_inline.h              |   60 +
 drivers/scsi/qla2xxx/qla_iocb.c                |  116 +-
 drivers/scsi/qla2xxx/qla_isr.c                 |  229 ++-
 drivers/scsi/qla2xxx/qla_mbx.c                 |  125 +-
 drivers/scsi/qla2xxx/qla_mid.c                 |   44 +-
 drivers/scsi/qla2xxx/qla_nvme.c                |  761 ++++++++
 drivers/scsi/qla2xxx/qla_nvme.h                |  132 ++
 drivers/scsi/qla2xxx/qla_nx.c                  |    4 +-
 drivers/scsi/qla2xxx/qla_nx.h                  |   17 +-
 drivers/scsi/qla2xxx/qla_nx2.c                 |    2 +-
 drivers/scsi/qla2xxx/qla_os.c                  |  368 +++-
 drivers/scsi/qla2xxx/qla_target.c              | 1438 +++++++-------
 drivers/scsi/qla2xxx/qla_target.h              |   58 +-
 drivers/scsi/qla2xxx/qla_tmpl.c                |   16 +-
 drivers/scsi/qla2xxx/qla_version.h             |    4 +-
 drivers/scsi/qla2xxx/tcm_qla2xxx.c             |   36 +-
 drivers/scsi/scsi.c                            |   13 +-
 drivers/scsi/scsi_error.c                      |    8 +-
 drivers/scsi/scsi_lib.c                        |  306 +--
 drivers/scsi/scsi_priv.h                       |    3 +
 drivers/scsi/scsi_scan.c                       |   46 +-
 drivers/scsi/scsi_sysfs.c                      |   42 +-
 drivers/scsi/scsi_transport_fc.c               |   12 +-
 drivers/scsi/scsi_transport_srp.c              |    7 +-
 drivers/scsi/sd.c                              |   78 +-
 drivers/scsi/sgiwd93.c                         |   10 +-
 drivers/scsi/smartpqi/smartpqi.h               |  194 +-
 drivers/scsi/smartpqi/smartpqi_init.c          | 2419 ++++++++++++++++++------
 drivers/scsi/smartpqi/smartpqi_sas_transport.c |    2 +-
 drivers/scsi/smartpqi/smartpqi_sis.c           |  100 +-
 drivers/scsi/smartpqi/smartpqi_sis.h           |    7 +-
 drivers/scsi/snic/snic_isr.c                   |    4 +-
 drivers/scsi/snic/snic_scsi.c                  |    4 +-
 drivers/scsi/storvsc_drv.c                     |   56 +-
 drivers/scsi/sun_esp.c                         |    9 +-
 drivers/scsi/ufs/tc-dwc-g210-pci.c             |    2 -
 drivers/scsi/ufs/ufshcd-pci.c                  |   60 +-
 drivers/scsi/ufs/ufshcd-pltfrm.c               |    2 -
 drivers/scsi/ufs/ufshcd.c                      |   15 +-
 drivers/scsi/virtio_scsi.c                     |   13 +-
 drivers/scsi/xen-scsifront.c                   |    1 -
 include/linux/hyperv.h                         |    1 -
 include/scsi/libsas.h                          |    6 +-
 include/scsi/scsi_cmnd.h                       |    1 +
 include/scsi/scsi_device.h                     |    9 +-
 include/scsi/scsi_devinfo.h                    |    9 -
 include/scsi/scsi_proto.h                      |    3 -
 include/scsi/scsi_transport_fc.h               |    4 -
 include/uapi/scsi/cxlflash_ioctl.h             |   85 +-
 164 files changed, 11494 insertions(+), 4431 deletions(-)
 create mode 100644 drivers/scsi/hisi_sas/hisi_sas_v3_hw.c
 create mode 100644 drivers/scsi/qla2xxx/qla_nvme.c
 create mode 100644 drivers/scsi/qla2xxx/qla_nvme.h

James

---

diff --cc drivers/scsi/scsi_lib.c
index 550e29f903b7,41c19c75dab4..f6097b89d5d3
--- a/drivers/scsi/scsi_lib.c
+++ b/drivers/scsi/scsi_lib.c
@@@ -1116,20 -1124,35 +1106,49 @@@ err_exit
  }
  EXPORT_SYMBOL(scsi_init_io);
  
 +/**
 + * scsi_initialize_rq - initialize struct scsi_cmnd.req
 + *
 + * Called from inside blk_get_request().
 + */
 +void scsi_initialize_rq(struct request *rq)
 +{
 +	struct scsi_cmnd *cmd = blk_mq_rq_to_pdu(rq);
 +
 +	scsi_req_init(&cmd->req);
 +}
 +EXPORT_SYMBOL(scsi_initialize_rq);
 +
+ /* Add a command to the list used by the aacraid and dpt_i2o drivers */
+ void scsi_add_cmd_to_list(struct scsi_cmnd *cmd)
+ {
+ 	struct scsi_device *sdev = cmd->device;
+ 	struct Scsi_Host *shost = sdev->host;
+ 	unsigned long flags;
+ 
+ 	if (shost->use_cmd_list) {
+ 		spin_lock_irqsave(&sdev->list_lock, flags);
+ 		list_add_tail(&cmd->list, &sdev->cmd_list);
+ 		spin_unlock_irqrestore(&sdev->list_lock, flags);
+ 	}
+ }
+ 
+ /* Remove a command from the list used by the aacraid and dpt_i2o drivers */
+ void scsi_del_cmd_from_list(struct scsi_cmnd *cmd)
+ {
+ 	struct scsi_device *sdev = cmd->device;
+ 	struct Scsi_Host *shost = sdev->host;
+ 	unsigned long flags;
+ 
+ 	if (shost->use_cmd_list) {
+ 		spin_lock_irqsave(&sdev->list_lock, flags);
+ 		BUG_ON(list_empty(&cmd->list));
+ 		list_del_init(&cmd->list);
+ 		spin_unlock_irqrestore(&sdev->list_lock, flags);
+ 	}
+ }
+ 
 +/* Called after a request has been started. */
  void scsi_init_command(struct scsi_device *dev, struct scsi_cmnd *cmd)
  {
  	void *buf = cmd->sense_buffer;
@@@ -2974,10 -2989,7 +2989,7 @@@ int scsi_internal_device_block_nowait(s
  	 * request queue. 
  	 */
  	if (q->mq_ops) {
- 		if (wait)
- 			blk_mq_quiesce_queue(q);
- 		else
- 			blk_mq_quiesce_queue_nowait(q);
 -		blk_mq_stop_hw_queues(q);
++		blk_mq_quiesce_queue_nowait(q);
  	} else {
  		spin_lock_irqsave(q->queue_lock, flags);
  		blk_stop_queue(q);
@@@ -2988,31 -2998,77 +2998,77 @@@
  
  	return 0;
  }
- EXPORT_SYMBOL_GPL(scsi_internal_device_block);
-  
+ EXPORT_SYMBOL_GPL(scsi_internal_device_block_nowait);
+ 
  /**
-  * scsi_internal_device_unblock - resume a device after a block request
-  * @sdev:	device to resume
-  * @new_state:	state to set devices to after unblocking
+  * scsi_internal_device_block - try to transition to the SDEV_BLOCK state
+  * @sdev: device to block
+  *
+  * Pause SCSI command processing on the specified device and wait until all
+  * ongoing scsi_request_fn() / scsi_queue_rq() calls have finished. May sleep.
   *
-  * Called by scsi lld's or the midlayer to restart the device queue
-  * for the previously suspended scsi device.  Called from interrupt or
-  * normal process context.
+  * Returns zero if successful or a negative error code upon failure.
   *
-  * Returns zero if successful or error if not.
+  * Note:
+  * This routine transitions the device to the SDEV_BLOCK state (which must be
+  * a legal transition). When the device is in this state, command processing
+  * is paused until the device leaves the SDEV_BLOCK state. See also
+  * scsi_internal_device_unblock().
   *
-  * Notes:       
-  *	This routine transitions the device to the SDEV_RUNNING state
-  *	or to one of the offline states (which must be a legal transition)
-  *	allowing the midlayer to goose the queue for this device.
+  * To do: avoid that scsi_send_eh_cmnd() calls queuecommand() after
+  * scsi_internal_device_block() has blocked a SCSI device and also
+  * remove the rport mutex lock and unlock calls from srp_queuecommand().
   */
- int
- scsi_internal_device_unblock(struct scsi_device *sdev,
- 			     enum scsi_device_state new_state)
+ static int scsi_internal_device_block(struct scsi_device *sdev)
  {
- 	struct request_queue *q = sdev->request_queue; 
+ 	struct request_queue *q = sdev->request_queue;
+ 	int err;
+ 
+ 	mutex_lock(&sdev->state_mutex);
+ 	err = scsi_internal_device_block_nowait(sdev);
+ 	if (err == 0) {
+ 		if (q->mq_ops)
+ 			blk_mq_quiesce_queue(q);
+ 		else
+ 			scsi_wait_for_queuecommand(sdev);
+ 	}
+ 	mutex_unlock(&sdev->state_mutex);
+ 
+ 	return err;
+ }
+  
+ void scsi_start_queue(struct scsi_device *sdev)
+ {
+ 	struct request_queue *q = sdev->request_queue;
  	unsigned long flags;
  
+ 	if (q->mq_ops) {
 -		blk_mq_start_stopped_hw_queues(q, false);
++		blk_mq_unquiesce_queue(q);
+ 	} else {
+ 		spin_lock_irqsave(q->queue_lock, flags);
+ 		blk_start_queue(q);
+ 		spin_unlock_irqrestore(q->queue_lock, flags);
+ 	}
+ }
+ 
+ /**
+  * scsi_internal_device_unblock_nowait - resume a device after a block request
+  * @sdev:	device to resume
+  * @new_state:	state to set the device to after unblocking
+  *
+  * Restart the device queue for a previously suspended SCSI device. Does not
+  * sleep.
+  *
+  * Returns zero if successful or a negative error code upon failure.
+  *
+  * Notes:
+  * This routine transitions the device to the SDEV_RUNNING state or to one of
+  * the offline states (which must be a legal transition) allowing the midlayer
+  * to goose the queue for this device.
+  */
+ int scsi_internal_device_unblock_nowait(struct scsi_device *sdev,
+ 					enum scsi_device_state new_state)
+ {
  	/*
  	 * Try to transition the scsi device to SDEV_RUNNING or one of the
  	 * offlined states and goose the device queue if successful.
