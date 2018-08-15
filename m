From: James Bottomley <James.Bottomley@HansenPartnership.com>
Subject: [GIT PULL] first round of SCSI updates for the 4.18+ merge window
Date: Wed, 15 Aug 2018 11:58:18 -0700
Message-ID: <1534359498.4049.13.camel@HansenPartnership.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8bit
Return-path: <linux-kernel-owner@vger.kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
To: Andrew Morton <akpm@linux-foundation.org>, Linus Torvalds <torvalds@linux-foundation.org>
Cc: linux-scsi <linux-scsi@vger.kernel.org>, linux-kernel <linux-kernel@vger.kernel.org>
List-Id: linux-scsi@vger.kernel.org

This is mostly updates to the usual drivers: mpt3sas, lpfc, qla2xxx,
hisi_sas, smartpqi, megaraid_sas, arcmsr.  In addition, with the
continuing absence of Nic we have target updates for tcmu and target
core (all with reviews and acks).  The biggest observable change is
going to be that we're (again) trying to switch to mulitqueue as the
default (a user can still override the setting on the kernel command
line).  Other major core stuff is the removal of the remaining
Microchannel drivers, an update of the internal timers and some reworks
of completion and result handling.

There's a conflict between this patch and your tree (mostly around some
of the fixes we've already sent you).  I attach the proposed resolution
below, just in case you need it.

The patch is available here:

git://git.kernel.org/pub/scm/linux/kernel/git/jejb/scsi.git scsi-misc

The short changelog is:

Anton Vasilyev (1):
      scsi: 3ware: fix return 0 on the error path of probe

Arjun Vynipadath (1):
      scsi: csiostor: update csio_get_flash_params()

Arnd Bergmann (5):
      scsi: snic: fix printing time intervals
      scsi: target: sbitmap: add seq_file forward declaration
      scsi: lpfc: use monotonic timestamps for statistics
      scsi: scsi_transport_fc: use 64-bit timestamps consistently
      scsi: aacraid: stop using deprated get_seconds()

Bart Van Assche (37):
      scsi: core: Avoid that SCSI device removal through sysfs triggers a deadlock
      scsi: sysfs: Introduce sysfs_{un,}break_active_protection()
      Revert "scsi: target/iscsi: Reduce number of __iscsit_free_cmd() callers"
      scsi: libiscsi: Annotate fall-through
      scsi: libiscsi: Annotate locking assumptions
      scsi: target: Remove se_dev_entry.ua_count
      scsi: target: Fix handling of removed LUNs
      scsi: target: Send unit attention condition even if the sense buffer is too small
      scsi: target: Do not duplicate the code that marks that a command has sense data
      scsi: target/tcm_loop: Avoid that static checkers warn about dead code
      scsi: target: Remove second argument from fabric_make_tpg()
      scsi: target/iscsi: Make iscsit_ta_authentication() respect the output buffer size
      scsi: target/iscsi: Reduce number of __iscsit_free_cmd() callers
      scsi: target: Simplify the code for waiting for command completion
      scsi: target: Simplify transport_generic_free_cmd() (2/2)
      scsi: target: Simplify transport_generic_free_cmd() (1/2)
      scsi: target: Fold core_tmr_handle_tas_abort() into transport_cmd_finish_abort()
      scsi: target: Simplify core_tmr_handle_tas_abort()
      scsi: target: Document when CMD_T_STOP and CMD_T_COMPLETE are set
      scsi: target: Make the session shutdown code also wait for commands that are being aborted
      scsi: target: Introduce transport_init_session()
      scsi: target: Rename transport_init_session() into transport_alloc_session()
      scsi: target: Move a list_del_init() statement
      scsi: target: Avoid that EXTENDED COPY commands trigger lock inversion
      scsi: target: Use config_item_name() instead of open-coding it
      scsi: klist: Make it safe to use klists in atomic context
      scsi: sd_zbc: Remove an assignment from sd_zbc_setup_report_cmnd()
      scsi: sd: Remove a superfluous assignment
      scsi: qedi: Fix misleading indentation
      scsi: mpt3sas: Improve kernel-doc headers
      scsi: mpt3sas: Split _base_reset_handler(), mpt3sas_scsih_reset_handler() and mpt3sas_ctl_reset_handler()
      scsi: mpt3sas: Fix a race condition in mpt3sas_base_hard_reset_handler()
      scsi: mpt3sas: Fix _transport_smp_handler() error path
      scsi: mpt3sas: Introduce struct mpt3sas_nvme_cmd
      scsi: mpt3sas: Annotate switch/case fall-through
      scsi: mpt3sas: Remove set-but-not-used variables
      scsi: mpt3sas: Fix indentation

Breno Leitao (1):
      scsi: ibmvscsi: Improve strings handling

Chaitra P B (7):
      scsi: mpt3sas: Fix for regression caused by sparse cleanups
      scsi: mpt3sas: Update driver version "26.100.00.00"
      scsi: mpt3sas: As per MPI-spec, use combined reply queue for SAS3.5 controllers when HBA supports more than 16 MSI-x vectors.
      scsi: mpt3sas: Fix, False timeout prints for ioctl and other internal commands during controller reset.
      scsi: mpt3sas: Don't access the structure after decrementing it's instance reference count.
      scsi: mpt3sas: Incorrect command status was set/marked as not used.
      scsi: mpt3sas: Don't abort I/Os issued to NVMe drives while processing Async Broadcast primitive event.

Ching Huang (2):
      scsi: arcmsr: Update driver version to v1.40.00.09-20180709
      scsi: arcmsr: Fix error of resuming from hibernation for adapter type E

Colin Ian King (3):
      scsi: st: remove redundant pointer STbuffer
      scsi: sym53c8xx: remove some redundant variables
      scsi: lpfc: remove null check on nvmebuf

Dan Carpenter (2):
      scsi: aic94xx: fix an error code in aic94xx_init()
      scsi: qedi: tidy up a size calculation

Dominique Martinet (2):
      scsi: ibmvscsi: change strncpy+truncation to strlcpy
      scsi: mptctl: change strncpy+truncation to strlcpy

Don Brace (1):
      scsi: smartpqi: bump driver version to 1.1.4-130

Dongliang Mu (1):
      scsi: aacraid: Spelling fix in comment

Douglas Gilbert (9):
      scsi: scsi_debug: add cmd abort option to every_nth
      scsi: scsi_debug: skip long delays when ndelay small
      scsi: core: scsi_io_completion convert BUGs to WARNs
      scsi: core: scsi_io_completion hints on fastpath
      scsi: core: add scsi_io_completion_reprep helper
      scsi: core: add scsi_io_completion_action helper
      scsi: core: add scsi_io_completion_nz_result function
      scsi: core: scsi_io_completion: rename variables
      scsi: core: scsi_io_completion: comment on end_request return

Gustavo A. R. Silva (1):
      scsi: mptfusion: mark expected switch fall-throughs

Hannes Reinecke (6):
      scsi: fcoe: hold disc_mutex when traversing rport lists
      scsi: libfc: Add WARN_ON() when deleting rports
      scsi: libfc: hold disc_mutex in fc_disc_stop_rports()
      scsi: libfc: fixup lockdep annotations
      scsi: libfc: fixup 'sleeping function called from invalid context'
      scsi: libfc: Add lockdep annotations

Himanshu Madhani (3):
      scsi: qla2xxx: Update driver version to 10.00.00.08-k
      scsi: qla2xxx: Fix stalled relogin
      scsi: qla2xxx: Cleanup for N2N code

James Smart (18):
      scsi: lpfc: update driver version to 12.0.0.6
      scsi: lpfc: Remove lpfc_enable_pbde as module parameter
      scsi: lpfc: Correct LCB ACCept payload
      scsi: lpfc: Limit tracking of tgt queue depth in fast path
      scsi: lpfc: Fix driver crash when re-registering NVME rports.
      scsi: lpfc: Fix list corruption on the completion queue.
      scsi: lpfc: Fix sysfs Speed value on CNA ports
      scsi: lpfc: Fix ELS abort on SLI-3 adapters
      scsi: lpfc: Revise copyright for new company language
      scsi: lpfc: update driver version to 12.0.0.5
      scsi: lpfc: devloss timeout race condition caused null pointer reference
      scsi: lpfc: Fix NVME Target crash in defer rcv logic
      scsi: lpfc: Support duration field in Link Cable Beacon V1 command
      scsi: lpfc: Make PBDE optimizations configurable
      scsi: lpfc: Fix abort error path for NVMET
      scsi: lpfc: Fix panic if driver unloaded when port is offline
      scsi: lpfc: Fix driver not setting dpp bits correctly in doorbell word
      scsi: lpfc: Add Buffer overflow check, when nvme_info larger than PAGE_SIZE

Jason Yan (1):
      scsi: libsas: dynamically allocate and free ata host

Jeff Moyer (1):
      scsi: sg: clean up gfp_mask in sg_build_indirect

Jia-Ju Bai (3):
      scsi: atp870u: Replace mdelay() with msleep()
      scsi: a100u2w: Replace mdelay() with msleep()
      scsi: message: fusion: Replace GFP_ATOMIC with GFP_KERNEL

Jianchao Wang (1):
      scsi: core: use blk_mq_run_hw_queues in scsi_kick_queue

Jitendra Bhivare (1):
      scsi: be2iscsi: Include null char in SET_HOST_DATA

Johannes Thumshirn (10):
      scsi: remove NCR_Q720 driver
      scsi: remove NCR_D700 driver
      scsi: ncr53c8xx: remove ScsiResult macro
      scsi: lpfc: remove ScsiResult macro
      scsi: bfa: remove ScsiResult macro
      scsi: aacraid: remove AAC_STAT_GOOD define
      scsi: core: switch to scsi-mq by default
      scsi: don't add scsi command result bytes
      scsi: core: check for equality of result byte values
      scsi: core: remove Scsi_Cmnd typedef

John Garry (3):
      scsi: hisi_sas: Drop hisi_sas_slot_abort()
      scsi: hisi_sas: Update a couple of register settings for v3 hw
      scsi: hisi_sas: Add missing PHY spinlock init

Ketan Mukadam (1):
      scsi: be2iscsi: Update copyright

Kevin Barnett (4):
      scsi: smartpqi: fix critical ARM issue reading PQI index registers
      scsi: smartpqi: add inspur advantech ids
      scsi: smartpqi: improve error checking for sync requests
      scsi: smartpqi: improve handling for sync requests

Matthew Wilcox (3):
      scsi: Remove percpu_ida
      scsi: target: Convert target drivers to use sbitmap
      scsi: target: Abstract tag freeing

Mike Christie (24):
      scsi: target: loop, usb, vhost, xen: use target_remove_session
      scsi: tcm_fc: use target_remove_session
      scsi: target: srp, vscsi, sbp, qla: use target_remove_session
      scsi: target: add session removal function
      scsi: target: rename target_alloc_session
      scsi: target: make transport_init_session_tags static
      scsi: iscsi target: have iscsit_start_nopin_timer call __iscsit_start_nopin_timer
      scsi: target: fix __transport_register_session locking
      scsi: tcmu: use u64 for dev_size
      scsi: tcmu: use match_int for dev params
      scsi: tcmu: do not set max_blocks if data_bitmap has been setup
      scsi: tcmu: unmap if dev is configured
      scsi: tcmu: check if dev is configured before block/reset
      scsi: tcmu: use lio core se_device configuration helper
      scsi: target: add helper to check if dev is configured
      scsi: tcmu: initialize list head
      scsi: target_core_user: fix double unlock
      scsi: tcmu: Don't pass KERN_ERR to pr_err
      scsi: target: remove target_find_device
      scsi: tcmu: add module wide block/reset_netlink support
      scsi: tcmu: misc nl code cleanup
      scsi: tcmu: simplify nl interface
      scsi: tcmu: track nl commands
      scsi: tcmu: delete unused __wait

Ming Lei (3):
      scsi: core: fix scsi_host_queue_ready
      scsi: core: avoid host-wide host_busy counter for scsi_mq
      scsi: read host_busy via scsi_host_busy()

Ohad Sharabi (1):
      scsi: ufs: remove unnecessary query(DM) UPIU trace

Quinn Tran (14):
      scsi: qla2xxx: Fix issue reported by static checker for qla2x00_els_dcmd2_sp_done()
      scsi: qla2xxx: Migrate NVME N2N handling into state machine
      scsi: qla2xxx: Save frame payload size from ICB
      scsi: qla2xxx: Fix race between switch cmd completion and timeout
      scsi: qla2xxx: Fix Management Server NPort handle reservation logic
      scsi: qla2xxx: Flush mailbox commands on chip reset
      scsi: qla2xxx: Fix unintended Logout
      scsi: qla2xxx: Fix session state stuck in Get Port DB
      scsi: qla2xxx: Fix redundant fc_rport registration
      scsi: qla2xxx: Silent erroneous message
      scsi: qla2xxx: Prevent sysfs access when chip is down
      scsi: qla2xxx: Add longer window for chip reset
      scsi: qla2xxx: Fix login retry count
      scsi: qla2xxx: Fix N2N link re-connect

Sebastian Andrzej Siewior (2):
      scsi: qla2xxx: remove irq save in qla2x00_poll()
      scsi: libsas: remove irq save in sas_ata_qc_issue()

Shivasharan S (5):
      scsi: megaraid_sas: driver version upgrade
      scsi: megaraid_sas: Support FW provided TM timeout values
      scsi: megaraid_sas: Return immediately from wait_for_adapter_operational after kill adapter
      scsi: megaraid_sas: Update controller info during resume
      scsi: megaraid_sas: Do not do Kill adapter if GET_CTRL_INFO times out

Souptick Joarder (1):
      scsi: cxlflash: Change return type for fault handler

Sreekanth Reddy (1):
      scsi: mpt3sas: Fix calltrace observed while running IO & reset

Tomas Winkler (1):
      scsi: ufs: ufshcd_dump_regs to use memcpy_fromio

Varun Prakash (1):
      scsi: csiostor: update ingress pack and pad boundary value

Wen Xiong (1):
      scsi: ipr: Format HCAM overlay ID 0x41

Xiang Chen (4):
      scsi: hisi_sas: Add SATA FIS check for v3 hw
      scsi: hisi_sas: Tidy hisi_sas_task_prep()
      scsi: hisi_sas: Pre-allocate slot DMA buffers
      scsi: hisi_sas: Use dmam_alloc_coherent()

Xiaofei Tan (11):
      scsi: hisi_sas: add memory barrier in task delivery function
      scsi: hisi_sas: Implement handlers of PCIe FLR for v3 hw
      scsi: hisi_sas: relocate some common code for v3 hw
      scsi: hisi_sas: tidy host controller reset function a bit
      scsi: hisi_sas: Fix the failure of recovering PHY from STP link timeout
      scsi: hisi_sas: tidy channel interrupt handler for v3 hw
      scsi: hisi_sas: Release all remaining resources in clear nexus ha
      scsi: hisi_sas: Add a flag to filter PHY events during reset
      scsi: hisi_sas: Adjust task reject period during host reset
      scsi: hisi_sas: Fix the conflict between dev gone and host reset
      scsi: hisi_sas: Only process broadcast change in phy_bcast_v3_hw()

Xiubo Li (1):
      scsi: tcmu: remove useless code and clean up the code style.

Zhouyang Jia (1):
      scsi: bnx2i: add error handling for ioremap_nocache

liwei (4):
      scsi: arm64: defconfig: enable configs for Hisilicon ufs
      scsi: arm64: dts: add ufs dts node
      scsi: ufs: dt-bindings: add document for hisi-ufs
      scsi: ufs: add Hisilicon ufs driver code

And the diffstat:

 Documentation/devicetree/bindings/ufs/ufs-hisi.txt |  41 ++
 .../devicetree/bindings/ufs/ufshcd-pltfrm.txt      |  10 +-
 MAINTAINERS                                        |   6 -
 arch/arm64/boot/dts/hisilicon/hi3660.dtsi          |  18 +
 arch/arm64/configs/defconfig                       |   1 +
 drivers/ata/libata-core.c                          |   3 +
 drivers/ata/libata.h                               |   2 -
 drivers/infiniband/ulp/srpt/ib_srpt.c              |  11 +-
 drivers/message/fusion/mptbase.c                   |   5 +-
 drivers/message/fusion/mptctl.c                    |   4 +-
 drivers/message/fusion/mptfc.c                     |   2 +-
 drivers/message/fusion/mptsas.c                    |   1 +
 drivers/scsi/3w-9xxx.c                             |   6 +-
 drivers/scsi/3w-sas.c                              |   3 +
 drivers/scsi/3w-xxxx.c                             |   4 +-
 drivers/scsi/Kconfig                               |  33 +-
 drivers/scsi/Makefile                              |   3 -
 drivers/scsi/NCR_D700.c                            | 405 ------------
 drivers/scsi/NCR_D700.h                            |  30 -
 drivers/scsi/NCR_Q720.c                            | 376 -----------
 drivers/scsi/NCR_Q720.h                            |  29 -
 drivers/scsi/a100u2w.c                             |   4 +-
 drivers/scsi/aacraid/aachba.c                      |  41 +-
 drivers/scsi/aacraid/commsup.c                     |   2 +-
 drivers/scsi/aacraid/dpcsup.c                      |   2 +-
 drivers/scsi/aacraid/rx.c                          |   2 +-
 drivers/scsi/aacraid/sa.c                          |   2 +-
 drivers/scsi/aacraid/src.c                         |   6 +-
 drivers/scsi/advansys.c                            |  10 +-
 drivers/scsi/aha152x.c                             |  71 +-
 drivers/scsi/aha1740.c                             |   9 +-
 drivers/scsi/aha1740.h                             |   4 +-
 drivers/scsi/aic94xx/aic94xx_init.c                |   4 +-
 drivers/scsi/arcmsr/arcmsr.h                       |   2 +-
 drivers/scsi/arcmsr/arcmsr_hba.c                   |   7 +
 drivers/scsi/atp870u.c                             |  16 +-
 drivers/scsi/be2iscsi/be_cmds.c                    |   2 +-
 drivers/scsi/be2iscsi/be_iscsi.c                   |  15 +-
 drivers/scsi/be2iscsi/be_main.c                    |  23 +-
 drivers/scsi/be2iscsi/be_mgmt.c                    |  23 +-
 drivers/scsi/bfa/bfad_im.c                         |  19 +-
 drivers/scsi/bfa/bfad_im.h                         |   1 -
 drivers/scsi/bnx2i/bnx2i_hwi.c                     |   2 +
 drivers/scsi/ch.c                                  |   2 +-
 drivers/scsi/csiostor/csio_hw.c                    | 115 +++-
 drivers/scsi/csiostor/csio_wr.c                    |  84 ++-
 drivers/scsi/cxlflash/ocxl_hw.c                    |   5 +-
 drivers/scsi/cxlflash/superpipe.c                  |   6 +-
 drivers/scsi/dc395x.c                              |   5 +-
 drivers/scsi/fcoe/fcoe_ctlr.c                      |  12 +-
 drivers/scsi/gdth.c                                |  67 +-
 drivers/scsi/gdth.h                                |  10 +-
 drivers/scsi/gdth_proc.c                           |   2 +-
 drivers/scsi/hisi_sas/hisi_sas.h                   |  14 +-
 drivers/scsi/hisi_sas/hisi_sas_main.c              | 319 ++++-----
 drivers/scsi/hisi_sas/hisi_sas_v1_hw.c             |  23 +-
 drivers/scsi/hisi_sas/hisi_sas_v2_hw.c             |  21 +-
 drivers/scsi/hisi_sas/hisi_sas_v3_hw.c             | 290 ++++----
 drivers/scsi/hosts.c                               |  32 +
 drivers/scsi/ibmvscsi/ibmvfc.c                     |   2 +-
 drivers/scsi/ibmvscsi/ibmvscsi.c                   |  12 +-
 drivers/scsi/ibmvscsi_tgt/ibmvscsi_tgt.c           |   6 +-
 drivers/scsi/imm.c                                 |   2 +-
 drivers/scsi/ipr.c                                 |  25 +
 drivers/scsi/ipr.h                                 |   7 +
 drivers/scsi/libfc/fc_disc.c                       |  47 +-
 drivers/scsi/libfc/fc_lport.c                      | 108 ++-
 drivers/scsi/libfc/fc_rport.c                      | 100 ++-
 drivers/scsi/libiscsi.c                            |   2 +
 drivers/scsi/libiscsi_tcp.c                        |   2 +-
 drivers/scsi/libsas/sas_ata.c                      |  47 +-
 drivers/scsi/libsas/sas_discover.c                 |   2 +
 drivers/scsi/libsas/sas_scsi_host.c                |   4 +-
 drivers/scsi/lpfc/Makefile                         |   4 +-
 drivers/scsi/lpfc/lpfc.h                           |   5 +-
 drivers/scsi/lpfc/lpfc_attr.c                      | 462 +++++++------
 drivers/scsi/lpfc/lpfc_attr.h                      |   4 +-
 drivers/scsi/lpfc/lpfc_bsg.c                       |   2 +-
 drivers/scsi/lpfc/lpfc_bsg.h                       |   4 +-
 drivers/scsi/lpfc/lpfc_compat.h                    |   4 +-
 drivers/scsi/lpfc/lpfc_crtn.h                      |   3 +-
 drivers/scsi/lpfc/lpfc_ct.c                        |   2 +-
 drivers/scsi/lpfc/lpfc_debugfs.h                   |   2 +-
 drivers/scsi/lpfc/lpfc_disc.h                      |   7 +-
 drivers/scsi/lpfc/lpfc_els.c                       |  68 +-
 drivers/scsi/lpfc/lpfc_hbadisc.c                   |   2 +-
 drivers/scsi/lpfc/lpfc_hw.h                        |  20 +-
 drivers/scsi/lpfc/lpfc_hw4.h                       |  46 +-
 drivers/scsi/lpfc/lpfc_ids.h                       |   2 +-
 drivers/scsi/lpfc/lpfc_init.c                      |  28 +-
 drivers/scsi/lpfc/lpfc_logmsg.h                    |   4 +-
 drivers/scsi/lpfc/lpfc_mbox.c                      |   2 +-
 drivers/scsi/lpfc/lpfc_mem.c                       |   2 +-
 drivers/scsi/lpfc/lpfc_nl.h                        |   4 +-
 drivers/scsi/lpfc/lpfc_nportdisc.c                 |  11 +-
 drivers/scsi/lpfc/lpfc_nvme.c                      |  76 ++-
 drivers/scsi/lpfc/lpfc_nvme.h                      |   1 +
 drivers/scsi/lpfc/lpfc_nvmet.c                     |  60 +-
 drivers/scsi/lpfc/lpfc_nvmet.h                     |   2 +-
 drivers/scsi/lpfc/lpfc_scsi.c                      | 181 +++--
 drivers/scsi/lpfc/lpfc_scsi.h                      |   2 +
 drivers/scsi/lpfc/lpfc_sli.c                       |  50 +-
 drivers/scsi/lpfc/lpfc_sli.h                       |   6 +-
 drivers/scsi/lpfc/lpfc_sli4.h                      |   5 +-
 drivers/scsi/lpfc/lpfc_version.h                   |   6 +-
 drivers/scsi/lpfc/lpfc_vport.c                     |   4 +-
 drivers/scsi/lpfc/lpfc_vport.h                     |   4 +-
 drivers/scsi/megaraid.c                            |  29 +-
 drivers/scsi/megaraid.h                            |  14 +-
 drivers/scsi/megaraid/megaraid_sas.h               |  33 +-
 drivers/scsi/megaraid/megaraid_sas_base.c          |  61 +-
 drivers/scsi/megaraid/megaraid_sas_fusion.c        |  36 +-
 drivers/scsi/mesh.c                                |   4 +-
 drivers/scsi/mpt3sas/mpt3sas_base.c                | 450 ++++++-------
 drivers/scsi/mpt3sas/mpt3sas_base.h                |  30 +-
 drivers/scsi/mpt3sas/mpt3sas_config.c              |  81 ++-
 drivers/scsi/mpt3sas/mpt3sas_ctl.c                 | 395 ++++++-----
 drivers/scsi/mpt3sas/mpt3sas_scsih.c               | 461 +++++--------
 drivers/scsi/mpt3sas/mpt3sas_transport.c           |  62 +-
 drivers/scsi/mpt3sas/mpt3sas_trigger_diag.c        |  18 +-
 drivers/scsi/mpt3sas/mpt3sas_warpdrive.c           |   3 -
 drivers/scsi/ncr53c8xx.c                           |  10 +-
 drivers/scsi/nsp32_debug.c                         |   2 +-
 drivers/scsi/qedi/qedi_fw_api.c                    |  30 +-
 drivers/scsi/qedi/qedi_main.c                      |   2 +-
 drivers/scsi/qla2xxx/qla_attr.c                    |  33 +-
 drivers/scsi/qla2xxx/qla_dbg.c                     |   3 +
 drivers/scsi/qla2xxx/qla_def.h                     |  22 +-
 drivers/scsi/qla2xxx/qla_fw.h                      |   5 +
 drivers/scsi/qla2xxx/qla_gbl.h                     |   6 +-
 drivers/scsi/qla2xxx/qla_gs.c                      |  68 +-
 drivers/scsi/qla2xxx/qla_init.c                    | 729 +++++++++++++--------
 drivers/scsi/qla2xxx/qla_inline.h                  |  12 +-
 drivers/scsi/qla2xxx/qla_iocb.c                    | 154 +++--
 drivers/scsi/qla2xxx/qla_isr.c                     |   3 +-
 drivers/scsi/qla2xxx/qla_mbx.c                     | 155 +++--
 drivers/scsi/qla2xxx/qla_mid.c                     |   2 +-
 drivers/scsi/qla2xxx/qla_nvme.c                    |  15 +-
 drivers/scsi/qla2xxx/qla_nvme.h                    |   2 +-
 drivers/scsi/qla2xxx/qla_os.c                      | 133 ++--
 drivers/scsi/qla2xxx/qla_target.c                  |  29 +-
 drivers/scsi/qla2xxx/qla_tmpl.c                    |  13 +-
 drivers/scsi/qla2xxx/qla_version.h                 |   2 +-
 drivers/scsi/qla2xxx/tcm_qla2xxx.c                 |  20 +-
 drivers/scsi/qlogicpti.c                           |   2 +-
 drivers/scsi/scsi.c                                |   4 +-
 drivers/scsi/scsi.h                                |   3 -
 drivers/scsi/scsi_debug.c                          |  57 +-
 drivers/scsi/scsi_error.c                          |   6 +-
 drivers/scsi/scsi_ioctl.c                          |   4 +-
 drivers/scsi/scsi_lib.c                            | 405 +++++++-----
 drivers/scsi/scsi_scan.c                           |   2 +-
 drivers/scsi/scsi_sysfs.c                          |  22 +-
 drivers/scsi/scsi_transport_fc.c                   |   4 +-
 drivers/scsi/scsi_transport_spi.c                  |   2 +-
 drivers/scsi/scsi_typedefs.h                       |   2 -
 drivers/scsi/sd.c                                  |  15 +-
 drivers/scsi/sd_zbc.c                              |   6 -
 drivers/scsi/sg.c                                  |   7 +-
 drivers/scsi/smartpqi/smartpqi.h                   |  12 +-
 drivers/scsi/smartpqi/smartpqi_init.c              | 160 +++--
 drivers/scsi/snic/snic_debugfs.c                   |  10 +-
 drivers/scsi/snic/snic_trc.c                       |   6 +-
 drivers/scsi/st.c                                  |   3 -
 drivers/scsi/sym53c8xx_2/sym_fw.c                  |   4 -
 drivers/scsi/sym53c8xx_2/sym_glue.c                |   2 +-
 drivers/scsi/sym53c8xx_2/sym_glue.h                |   2 +-
 drivers/scsi/sym53c8xx_2/sym_hipd.c                |   3 +-
 drivers/scsi/ufs/Kconfig                           |   9 +
 drivers/scsi/ufs/Makefile                          |   1 +
 drivers/scsi/ufs/ufs-hisi.c                        | 619 +++++++++++++++++
 drivers/scsi/ufs/ufs-hisi.h                        | 115 ++++
 drivers/scsi/ufs/ufs-qcom.c                        |  21 +-
 drivers/scsi/ufs/ufshcd.c                          |  52 +-
 drivers/scsi/ufs/ufshcd.h                          |   3 +
 drivers/target/iscsi/iscsi_target_configfs.c       |   6 +-
 drivers/target/iscsi/iscsi_target_login.c          |   2 +-
 drivers/target/iscsi/iscsi_target_tpg.c            |   3 +-
 drivers/target/iscsi/iscsi_target_util.c           |  55 +-
 drivers/target/loopback/tcm_loop.c                 |  15 +-
 drivers/target/sbp/sbp_target.c                    |  18 +-
 drivers/target/target_core_configfs.c              |  12 +-
 drivers/target/target_core_device.c                |  53 +-
 drivers/target/target_core_fabric_configfs.c       |   5 +-
 drivers/target/target_core_internal.h              |   2 +-
 drivers/target/target_core_sbc.c                   |   7 +-
 drivers/target/target_core_tmr.c                   |  30 +-
 drivers/target/target_core_transport.c             | 285 ++++----
 drivers/target/target_core_ua.c                    |  43 +-
 drivers/target/target_core_ua.h                    |   3 +-
 drivers/target/target_core_user.c                  | 377 +++++++----
 drivers/target/target_core_xcopy.c                 |   5 +-
 drivers/target/tcm_fc/tfc_cmd.c                    |  10 +-
 drivers/target/tcm_fc/tfc_conf.c                   |   5 +-
 drivers/target/tcm_fc/tfc_sess.c                   |   5 +-
 drivers/usb/gadget/function/f_tcm.c                |  19 +-
 drivers/vhost/scsi.c                               |  16 +-
 drivers/xen/xen-scsiback.c                         |  17 +-
 fs/sysfs/file.c                                    |  44 ++
 include/linux/libata.h                             |   2 +
 include/linux/percpu_ida.h                         |  83 ---
 include/linux/sbitmap.h                            |   2 +
 include/linux/sysfs.h                              |  14 +
 include/scsi/libsas.h                              |   2 +-
 include/scsi/scsi_host.h                           |   1 +
 include/target/iscsi/iscsi_target_core.h           |   1 +
 include/target/target_core_backend.h               |   6 +-
 include/target/target_core_base.h                  |  16 +-
 include/target/target_core_fabric.h                |  10 +-
 lib/Makefile                                       |   2 +-
 lib/klist.c                                        |  10 +-
 lib/percpu_ida.c                                   | 370 -----------
 212 files changed, 5299 insertions(+), 4665 deletions(-)
 create mode 100644 Documentation/devicetree/bindings/ufs/ufs-hisi.txt
 delete mode 100644 drivers/scsi/NCR_D700.c
 delete mode 100644 drivers/scsi/NCR_D700.h
 delete mode 100644 drivers/scsi/NCR_Q720.c
 delete mode 100644 drivers/scsi/NCR_Q720.h
 delete mode 100644 drivers/scsi/scsi_typedefs.h
 create mode 100644 drivers/scsi/ufs/ufs-hisi.c
 create mode 100644 drivers/scsi/ufs/ufs-hisi.h
 delete mode 100644 include/linux/percpu_ida.h
 delete mode 100644 lib/percpu_ida.c

James

---

commit 8360ebc8cce888e883d2b274445eace901276237
Merge: 94710cac0ef4 51372570ac3c
Author: James Bottomley <James.Bottomley@HansenPartnership.com>
Date:   Wed Aug 15 10:29:51 2018 -0700

    Merge branch 'misc' into for-next

diff --cc MAINTAINERS
index 544cac829cf4,f3de5d37179a..eeb54037b62d
--- a/MAINTAINERS
+++ b/MAINTAINERS
@@@ -9751,17 -9750,6 +9751,11 @@@ F:	drivers/scsi/mac_scsi.
  F:	drivers/scsi/sun3_scsi.*
  F:	drivers/scsi/sun3_scsi_vme.c
  
- NCR DUAL 700 SCSI DRIVER (MICROCHANNEL)
- M:	"James E.J. Bottomley" <James.Bottomley@HansenPartnership.com>
- L:	linux-scsi@vger.kernel.org
- S:	Maintained
- F:	drivers/scsi/NCR_D700.*
- 
 +NCSI LIBRARY:
 +M:	Samuel Mendoza-Jonas <sam@mendozajonas.com>
 +S:	Maintained
 +F:	net/ncsi/
 +
  NCT6775 HARDWARE MONITOR DRIVER
  M:	Guenter Roeck <linux@roeck-us.net>
  L:	linux-hwmon@vger.kernel.org
diff --cc drivers/scsi/qla2xxx/qla_gbl.h
index 2660a48d918a,035ab18bd534..178974896b5c
--- a/drivers/scsi/qla2xxx/qla_gbl.h
+++ b/drivers/scsi/qla2xxx/qla_gbl.h
@@@ -212,9 -212,8 +212,9 @@@ extern int qla24xx_post_upd_fcport_work
  void qla2x00_handle_login_done_event(struct scsi_qla_host *, fc_port_t *,
  	uint16_t *);
  int qla24xx_post_gnl_work(struct scsi_qla_host *, fc_port_t *);
- int qla24xx_async_abort_cmd(srb_t *);
+ int qla24xx_async_abort_cmd(srb_t *, bool);
  int qla24xx_post_relogin_work(struct scsi_qla_host *vha);
 +void qla2x00_wait_for_sess_deletion(scsi_qla_host_t *);
  
  /*
   * Global Functions in qla_mid.c source file.
diff --cc drivers/scsi/qla2xxx/qla_gs.c
index 7a3744006419,407eb705f1be..a0038d879b9d
--- a/drivers/scsi/qla2xxx/qla_gs.c
+++ b/drivers/scsi/qla2xxx/qla_gs.c
@@@ -3394,19 -3383,40 +3391,40 @@@ int qla24xx_post_gpnid_work(struct scsi
  
  void qla24xx_sp_unmap(scsi_qla_host_t *vha, srb_t *sp)
  {
- 	if (sp->u.iocb_cmd.u.ctarg.req) {
- 		dma_free_coherent(&vha->hw->pdev->dev,
- 			sp->u.iocb_cmd.u.ctarg.req_allocated_size,
- 			sp->u.iocb_cmd.u.ctarg.req,
- 			sp->u.iocb_cmd.u.ctarg.req_dma);
- 		sp->u.iocb_cmd.u.ctarg.req = NULL;
- 	}
- 	if (sp->u.iocb_cmd.u.ctarg.rsp) {
- 		dma_free_coherent(&vha->hw->pdev->dev,
- 			sp->u.iocb_cmd.u.ctarg.rsp_allocated_size,
- 			sp->u.iocb_cmd.u.ctarg.rsp,
- 			sp->u.iocb_cmd.u.ctarg.rsp_dma);
- 		sp->u.iocb_cmd.u.ctarg.rsp = NULL;
+ 	struct srb_iocb *c = &sp->u.iocb_cmd;
+ 
+ 	switch (sp->type) {
+ 	case SRB_ELS_DCMD:
+ 		if (c->u.els_plogi.els_plogi_pyld)
+ 			dma_free_coherent(&vha->hw->pdev->dev,
+ 			    c->u.els_plogi.tx_size,
+ 			    c->u.els_plogi.els_plogi_pyld,
+ 			    c->u.els_plogi.els_plogi_pyld_dma);
+ 
+ 		if (c->u.els_plogi.els_resp_pyld)
+ 			dma_free_coherent(&vha->hw->pdev->dev,
+ 			    c->u.els_plogi.rx_size,
+ 			    c->u.els_plogi.els_resp_pyld,
+ 			    c->u.els_plogi.els_resp_pyld_dma);
+ 		break;
+ 	case SRB_CT_PTHRU_CMD:
+ 	default:
+ 		if (sp->u.iocb_cmd.u.ctarg.req) {
+ 			dma_free_coherent(&vha->hw->pdev->dev,
 -			    sizeof(struct ct_sns_pkt),
++			    sp->u.iocb_cmd.u.ctarg.req_allocated_size,
+ 			    sp->u.iocb_cmd.u.ctarg.req,
+ 			    sp->u.iocb_cmd.u.ctarg.req_dma);
+ 			sp->u.iocb_cmd.u.ctarg.req = NULL;
+ 		}
+ 
+ 		if (sp->u.iocb_cmd.u.ctarg.rsp) {
+ 			dma_free_coherent(&vha->hw->pdev->dev,
 -			    sizeof(struct ct_sns_pkt),
++			    sp->u.iocb_cmd.u.ctarg.rsp_allocated_size,
+ 			    sp->u.iocb_cmd.u.ctarg.rsp,
+ 			    sp->u.iocb_cmd.u.ctarg.rsp_dma);
+ 			sp->u.iocb_cmd.u.ctarg.rsp = NULL;
+ 		}
+ 		break;
  	}
  
  	sp->free(sp);
diff --cc drivers/scsi/qla2xxx/qla_init.c
index 1b19b954bbae,f52c68b4da44..c09e86f7fdb7
--- a/drivers/scsi/qla2xxx/qla_init.c
+++ b/drivers/scsi/qla2xxx/qla_init.c
@@@ -578,34 -693,76 +693,79 @@@ static void qla24xx_handle_gnl_done_eve
  	}
  
  	if (!found) {
- 		/* fw has no record of this port */
- 		for (i = 0; i < n; i++) {
- 			e = &vha->gnl.l[i];
- 			id.b.domain = e->port_id[0];
- 			id.b.area = e->port_id[1];
- 			id.b.al_pa = e->port_id[2];
- 			id.b.rsvd_1 = 0;
- 			loop_id = le16_to_cpu(e->nport_handle);
- 
- 			if (fcport->d_id.b24 == id.b24) {
- 				conflict_fcport =
- 					qla2x00_find_fcport_by_wwpn(vha,
- 					    e->port_name, 0);
- 				if (conflict_fcport) {
- 					qlt_schedule_sess_for_deletion
- 						(conflict_fcport);
- 					ql_dbg(ql_dbg_disc, vha, 0x20e6,
- 					    "%s %d %8phC post del sess\n",
- 					    __func__, __LINE__,
- 					    conflict_fcport->port_name);
+ 		switch (vha->hw->current_topology) {
+ 		case ISP_CFG_F:
+ 		case ISP_CFG_FL:
+ 			for (i = 0; i < n; i++) {
+ 				e = &vha->gnl.l[i];
+ 				id.b.domain = e->port_id[0];
+ 				id.b.area = e->port_id[1];
+ 				id.b.al_pa = e->port_id[2];
+ 				id.b.rsvd_1 = 0;
+ 				loop_id = le16_to_cpu(e->nport_handle);
+ 
+ 				if (fcport->d_id.b24 == id.b24) {
+ 					conflict_fcport =
+ 					    qla2x00_find_fcport_by_wwpn(vha,
+ 						e->port_name, 0);
 -					ql_dbg(ql_dbg_disc + ql_dbg_verbose,
 -					    vha, 0x20e5,
 -					    "%s %d %8phC post del sess\n",
 -					    __func__, __LINE__,
 -					    conflict_fcport->port_name);
 -					qlt_schedule_sess_for_deletion
 -						(conflict_fcport);
++					if (conflict_fcport) {
++						ql_dbg(ql_dbg_disc
++						       + ql_dbg_verbose,
++						       vha, 0x20e5,
++						       "%s %d %8phC post del sess\n",
++						       __func__, __LINE__,
++						       conflict_fcport->port_name);
++						qlt_schedule_sess_for_deletion
++							(conflict_fcport);
++					}
  				}
+ 				/*
+ 				 * FW already picked this loop id for
+ 				 * another fcport
+ 				 */
+ 				if (fcport->loop_id == loop_id)
+ 					fcport->loop_id = FC_NO_LOOP_ID;
  			}
- 
- 			/* FW already picked this loop id for another fcport */
- 			if (fcport->loop_id == loop_id)
- 				fcport->loop_id = FC_NO_LOOP_ID;
+ 			qla24xx_fcport_handle_login(vha, fcport);
+ 			break;
+ 		case ISP_CFG_N:
+ 			fcport->disc_state = DSC_DELETED;
+ 			if (time_after_eq(jiffies, fcport->dm_login_expire)) {
+ 				if (fcport->n2n_link_reset_cnt < 2) {
+ 					fcport->n2n_link_reset_cnt++;
+ 					/*
+ 					 * remote port is not sending PLOGI.
+ 					 * Reset link to kick start his state
+ 					 * machine
+ 					 */
+ 					set_bit(N2N_LINK_RESET,
+ 					    &vha->dpc_flags);
+ 				} else {
+ 					if (fcport->n2n_chip_reset < 1) {
+ 						ql_log(ql_log_info, vha, 0x705d,
+ 						    "Chip reset to bring laser down");
+ 						set_bit(ISP_ABORT_NEEDED,
+ 						    &vha->dpc_flags);
+ 						fcport->n2n_chip_reset++;
+ 					} else {
+ 						ql_log(ql_log_info, vha, 0x705d,
+ 						    "Remote port %8ph is not coming back\n",
+ 						    fcport->port_name);
+ 						fcport->scan_state = 0;
+ 					}
+ 				}
+ 				qla2xxx_wake_dpc(vha);
+ 			} else {
+ 				/*
+ 				 * report port suppose to do PLOGI. Give him
+ 				 * more time. FW will catch it.
+ 				 */
+ 				set_bit(RELOGIN_NEEDED, &vha->dpc_flags);
+ 			}
+ 			break;
+ 		default:
+ 			break;
  		}
- 		qla24xx_fcport_handle_login(vha, fcport);
  	}
  } /* gnl_event */
  
