From: James Bottomley <James.Bottomley@HansenPartnership.com>
Subject: [GIT PULL] first round of SCSI updates for the 4.14+ merge window
Date: Wed, 31 Jan 2018 09:42:29 -0800
Message-ID: <1517420549.3937.67.camel@HansenPartnership.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8bit
Return-path: <linux-kernel-owner@vger.kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
To: Andrew Morton <akpm@linux-foundation.org>, Linus Torvalds <torvalds@linux-foundation.org>
Cc: linux-scsi <linux-scsi@vger.kernel.org>, linux-kernel <linux-kernel@vger.kernel.org>
List-Id: linux-scsi@vger.kernel.org

This is mostly updates of the usual driver suspects: arcmsr,
scsi_debug, mpt3sas, lpfc, cxlflash, qla2xxx, aacraid, megaraid_sas,
hisi_sas.  We also have a rework of the libsas hotplug handling to make
it more robust, a slew of 32 bit time conversions and fixes, and a host
of the usual minor updates and style changes.  The biggest potential
for regressions is the libsas hotplug changes, but so far they seem
stable under testing.

The patch is available here:

git://git.kernel.org/pub/scm/linux/kernel/git/jejb/scsi.git scsi-misc

The short changelog is:

Andy Shevchenko (3):
      scsi: mptfusion: Use snprintf() instead of open coded divisions
      scsi: hpsa: Use vsnprintf extension %phN
      scsi: libsas: remove private hex2bin() implementation

Anil Gurumurthy (1):
      scsi: qla2xxx: Add XCB counters to debugfs

Arnd Bergmann (16):
      scsi: arcmsr: avoid do_gettimeofday
      scsi: fas216: fix sense buffer initialization
      scsi: megaraid: use ktime_get_real for firmware time
      scsi: fnic: use 64-bit timestamps
      scsi: bfa: convert to strlcpy/strlcat
      scsi: scsi_debug: remove jiffies_to_timespec
      scsi: 3w-9xxx: rework lock timeouts
      scsi: 3ware: use 64-bit times for FW time sync
      scsi: 3ware: fix 32-bit time calculations
      scsi: bfa: use 64-bit times in bfa_aen_entry_s ABI
      scsi: bfa: try to sanitize vendor netlink events
      scsi: bfa: replace bfa_get_log_time() with ktime_get_real_seconds()
      scsi: bfa: document overflow of io_profile_start_time
      scsi: bfa: improve bfa_ioc_send_enable/disable data
      scsi: bfa: use proper time accessor for stats_reset_time
      scsi: bfa: use ktime_get_real_ts64 for firmware timestamp

Bart Van Assche (9):
      scsi: core: Change third __scsi_queue_insert() argument from int to bool
      scsi: qla2xxx: Suppress gcc 7 fall-through warnings
      scsi: scsi_debug: Add support for injecting SCSI_MLQUEUE_HOST_BUSY
      scsi: dh: Remove scsi_dh_remove_device()
      scsi: core: Unexport scsi_initialize_rq()
      scsi: core: Introduce scsi_devinfo_key enumeration type
      scsi: core: scsi_get_device_flags_keyed(): Always return device flags
      scsi: core: Convert a source code comment into a runtime check
      scsi: core: Ensure that the SCSI error handler gets woken up

Bryant G. Ly (1):
      scsi: ibmvscsis: add DRC indices to debug statements

Chaitra P B (1):
      scsi: mpt3sas: Proper handling of set/clear of "ATA command pending" flag.

Ching Huang (23):
      scsi: arcmsr: simplify arcmsr_request_device_map routine
      scsi: arcmsr: simplify all arcmsr_hbaX_get_config routine by call a new get_adapter_config function
      scsi: arcmsr: simplify arcmsr_hbaE_get_config function
      scsi: arcmsr: waiting for iop firmware ready before issue get_config command to iop
      scsi: arcmsr: simplify arcmsr_hbaC_get_config function
      scsi: arcmsr: Fix command result for CHECK_CONDITION
      scsi: arcmsr: Update driver version to v1.40.00.04-20171130
      scsi: arcmsr: Add driver module parameter msix_enable
      scsi: arcmsr: Add driver module parameter msi_enable
      scsi: arcmsr: Fix grammar
      scsi: arcmsr: Adjust whitespace
      scsi: arcmsr: Spin off duplicate code
      scsi: arcmsr: Fix clear doorbell queue on ACB_ADAPTER_TYPE_B
      scsi: arcmsr: Add a function to set date and time to firmware
      scsi: arcmsr: Add ACB_F_MSG_GET_CONFIG to acb->acb_flags
      scsi: arcmsr: Add driver option cmd_per_lun
      scsi: arcmsr: Replace constant ARCMSR_MAX_OUTSTANDING_CMD
      scsi: arcmsr: Add driver option host_can_queue
      scsi: arcmsr: replace constant ARCMSR_MAX_FREECCB_NUM
      scsi: arcmsr: Increase host controller command queue depth
      scsi: arcmsr: Add code for ACB_ADAPTER_TYPE_E
      scsi: arcmsr: simplify arcmsr_iop_init function
      scsi: arcmsr: Redefine ACB_ADAPTER_TYPE_A, _B, _C, _D

Christopher Díaz Riveros (1):
      scsi: ibmvfc: Remove unneeded semicolons

Colin Ian King (15):
      scsi: mptsas: remove duplicated assignment to pointer head
      scsi: mpt3sas: make function _get_st_from_smid static
      scsi: bfa: use ARRAY_SIZE for array sizing calculation on array __pciids
      scsi: qla2xxx: remove redundant assignment of d
      scsi: aacraid: remove redundant setting of variable c
      scsi: lpfc: fix a couple of minor indentation issues
      scsi: lpfc: don't dereference localport before it has been null checked
      scsi: arcmsr: remove redundant check for secs < 0
      scsi: fusion: clean up some indentations
      scsi: ipr: fix incorrect indentation of assignment statement
      scsi: csiostor: fix spelling mistake: "Couldnt" -> "Couldn't"
      scsi: bnx2fc: fix spelling mistake: "Couldnt" -> "Couldn't"
      scsi: wd719x: make card_types static const, shrinks object size
      scsi: bfa: remove unused pointer 'port'
      scsi: aacraid: remove unused variable managed_request_id

Dan Carpenter (2):
      scsi: storvsc: missing error code in storvsc_probe()
      scsi: hpsa: remove an unnecessary NULL check

Darren Trapp (1):
      scsi: qla2xxx: Fix queue ID for async abort with Multiqueue

Douglas Gilbert (7):
      scsi: scsi_debug: delay stress fix
      scsi: scsi_debug: add resp_write_scat function
      scsi: scsi_debug: ARRAY_SIZE and FF_MEDIA_IO
      scsi: scsi_debug: do_device_access add sg offset argument
      scsi: scsi_debug: fix group_number mask
      scsi: scsi_debug: tab, kstrto changes
      scsi: scsi_debug: add cdb_len parameter

Giridhar Malavali (3):
      scsi: qla2xxx: Don't call dma_free_coherent with IRQ disabled.
      scsi: qla2xxx: Remove aborting ELS IOCB call issued as part of timeout.
      scsi: qla2xxx: Defer processing of GS IOCB calls

Greg Kroah-Hartman (1):
      scsi: csiostor: remove unneeded DRIVER_LICENSE #define

Gustavo A. R. Silva (2):
      scsi: ppa: mark expected switch fall-throughs
      scsi: bnx2i: bnx2i_hwi: use swap macro in bnx2i_send_iscsi_nopout

Hannes Reinecke (12):
      scsi: core: Add VENDOR_SPECIFIC sense code definitions
      scsi: scsi_dh_alua: skip RTPG for devices only supporting active/optimized
      scsi: mpt3sas: simplify _wait_for_commands_to_complete()
      scsi: mpt3sas: simplify mpt3sas_scsi_issue_tm()
      scsi: mpt3sas: simplify task management functions
      scsi: mpt3sas: always use first reserved smid for ioctl passthrough
      scsi: mpt3sas: check command status before attempting abort
      scsi: mpt3sas: Introduce mpt3sas_get_st_from_smid()
      scsi: mpt3sas: open-code _scsih_scsi_lookup_get()
      scsi: mpt3sas: separate out _base_recovery_check()
      scsi: mpt3sas: use list_splice_init()
      scsi: mpt3sas: set default value for cb_idx

Himanshu Jha (6):
      scsi: qedi: Use zeroing allocator instead of allocator/memset
      scsi: bnx2fc: Use zeroing allocator rather than allocator/memset
      scsi: bnx2i: Use zeroing allocator rather than allocator/memset
      scsi: bfa: Use zeroing allocator rather than allocator/memset
      scsi: qla2xxx: Use zeroing allocator rather than allocator/memset
      scsi: qla4xxx: Use zeroing allocator rather than allocator/memset

Himanshu Madhani (2):
      scsi: qla2xxx: Fix logo flag for qlt_free_session_done()
      scsi: qla2xxx: Fix smatch warning in qla25xx_delete_{rsp|req}_que

James Smart (28):
      scsi: scsi_transport_fc: fix typos on 64/128 GBit define names
      scsi: lpfc: correct sg_seg_cnt attribute min vs default
      scsi: lpfc: update driver version to 11.4.0.6
      scsi: lpfc: Beef up stat counters for debug
      scsi: lpfc: Fix infinite wait when driver unregisters a remote NVME port.
      scsi: lpfc: Fix issues connecting with nvme initiator
      scsi: lpfc: Fix SCSI LUN discovery when SCSI and NVME enabled
      scsi: lpfc: Increase SCSI CQ and WQ sizes.
      scsi: lpfc: Fix receive PRLI handling
      scsi: lpfc: Fix -EOVERFLOW behavior for NVMET and defer_rcv
      scsi: lpfc: Fix random heartbeat timeouts during heavy IO
      scsi: lpfc: update driver version to 11.4.0.5
      scsi: lpfc: small sg cnt cleanup
      scsi: lpfc: Fix driver handling of nvme resources during unload
      scsi: lpfc: Fix crash during driver unload with running nvme traffic
      scsi: lpfc: Correct driver deregistrations with host nvme transport
      scsi: lpfc: correct port registrations with nvme_fc
      scsi: lpfc: Linux LPFC driver does not process all RSCNs
      scsi: lpfc: Fix ndlp ref count for pt2pt mode issue RSCN
      scsi: lpfc: Adjust default value of lpfc_nvmet_mrq
      scsi: lpfc: Fix display for debugfs queInfo
      scsi: lpfc: Driver fails to detect direct attach storage array
      scsi: lpfc: Raise maximum NVME sg list size for 256 elements
      scsi: lpfc: Fix NVME LS abort_xri
      scsi: lpfc: Fix crash after bad bar setup on driver attachment
      scsi: lpfc: Handle XRI_ABORTED_CQE in soft IRQ
      scsi: lpfc: Expand WQE capability of every NVME hardware queue
      scsi: lpfc: FLOGI failures are reported when connected to a private loop.

Jason Yan (9):
      scsi: libsas: notify event PORTE_BROADCAST_RCVD in sas_enable_revalidation()
      scsi: libsas: direct call probe and destruct
      scsi: libsas: use flush_workqueue to process disco events synchronously
      scsi: libsas: Use new workqueue to run sas event and disco event
      scsi: libsas: make the event threshold configurable
      scsi: libsas: shut down the PHY if events reached the threshold
      scsi: libsas: Use dynamic alloced work to avoid sas event lost
      scsi: libsas: fix error when getting phy events
      scsi: libsas: fix memory leak in sas_smp_get_phy_events()

Jia-Ju Bai (1):
      scsi: qedi: Fix a possible sleep-in-atomic bug in qedi_process_tmf_resp

Julia Lawall (1):
      scsi: hpsa: drop unneeded newline

Li Dongyang (1):
      scsi: ses: don't ask for diagnostic pages repeatedly during probe

Manish Rangankar (1):
      scsi: qedi: Drop cqe response during connection recovery

Matthew R. Ochs (3):
      scsi: cxlflash: Staging to support future accelerators
      scsi: cxlflash: Remove embedded CXL work structures
      scsi: cxlflash: Explicitly cache number of interrupts per context

Meelis Roos (1):
      scsi: aacraid: Fix driver oops with dead battery

Michał Mirosław (1):
      scsi: sd: add missing KERN_CONT for disk spin-up

Nicolas Iooss (1):
      scsi: fnic: add a space after %p in printf format

Niklas Cassel (1):
      scsi: pmcraid: use correct size unit when calling find_first_zero_bit()

Paul E. McKenney (1):
      rcu: Export init_rcu_head() and destroy_rcu_head() to GPL modules

Pravin Shedge (1):
      scsi: qla2xxx: remove duplicate includes

Quinn Tran (49):
      scsi: qla2xxx: Serialize session free in qlt_free_session_done
      scsi: qla2xxx: Serialize session deletion by using work_lock
      scsi: qla2xxx: Remove unused argument from qlt_schedule_sess_for_deletion()
      scsi: qla2xxx: Prevent relogin trigger from sending too many commands
      scsi: qla2xxx: Prevent multiple active discovery commands per session
      scsi: qla2xxx: Add retry limit for fabric scan logic
      scsi: qla2xxx: Delay loop id allocation at login
      scsi: qla2xxx: Increase verbosity of debug messages logged
      scsi: qla2xxx: Add ability to use GPNFT/GNNFT for RSCN handling
      scsi: qla2xxx: Properly extract ADISC error codes
      scsi: qla2xxx: Fix GPNFT/GNNFT error handling
      scsi: qla2xxx: Remove session creation redundant code
      scsi: qla2xxx: Migrate switch registration commands away from mailbox interface
      scsi: qla2xxx: Fix login state machine freeze
      scsi: qla2xxx: Reduce trace noise for Async Events
      scsi: qla2xxx: Reduce the use of terminate exchange
      scsi: qla2xxx: Add lock protection around host lookup
      scsi: qla2xxx: Add switch command to simplify fabric discovery
      scsi: qla2xxx: Fix session cleanup for N2N
      scsi: qla2xxx: Tweak resource count dump
      scsi: qla2xxx: Allow target mode to accept PRLI in dual mode
      scsi: qla2xxx: Add ability to send PRLO
      scsi: qla2xxx: Add option for use reserve exch for ELS
      scsi: qla2xxx: Use shadow register for ISP27XX
      scsi: qla2xxx: Enable ATIO interrupt handshake for ISP27XX
      scsi: qla2xxx: Move work element processing out of DPC thread
      scsi: qla2xxx: Replace GPDB with async ADISC command
      scsi: qla2xxx: Fix Firmware dump size for Extended login and Exchange Offload
      scsi: qla2xxx: Chip reset uses wrong lock during IO flush.
      scsi: qla2xxx: Add boundary checks for exchanges to be offloaded
      scsi: qla2xxx: Use chip reset to bring down laser on unload.
      scsi: qla2xxx: Use IOCB path to submit Control VP MBX command
      scsi: qla2xxx: Fix NULL pointer access for fcport structure
      scsi: qla2xxx: Fix system crash in qlt_plogi_ack_unref
      scsi: qla2xxx: Clear loop id after delete
      scsi: qla2xxx: Fix scan state field for fcport
      scsi: qla2xxx: Replace fcport alloc with qla2x00_alloc_fcport
      scsi: qla2xxx: Fix abort command deadlock due to spinlock
      scsi: qla2xxx: Fix PRLI state check
      scsi: qla2xxx: Fix Relogin being triggered too fast
      scsi: qla2xxx: Relogin to target port on a cable swap
      scsi: qla2xxx: Fix login state machine stuck at GPDB
      scsi: qla2xxx: Serialize GPNID for multiple RSCN
      scsi: qla2xxx: Retry switch command on time out
      scsi: qla2xxx: Fix re-login for Nport Handle in use
      scsi: qla2xxx: Skip IRQ affinity for Target QPairs
      scsi: qla2xxx: Move session delete to driver work queue
      scsi: qla2xxx: Fix gpnid error processing
      scsi: qla2xxx: Fix system crash for Notify ack timeout handling

Rafael David Tinoco (1):
      scsi: libiscsi: Allow sd_shutdown on bad transport

Raghava Aditya Renukunta (32):
      scsi: aacraid: Delay for rescan worker needs to be 10 seconds
      scsi: aacraid: Get correct lun count
      scsi: aacraid: Update driver version to 50877
      scsi: aacraid: Remove AAC_HIDE_DISK check in queue command
      scsi: aacraid: Remove unused rescan variable
      scsi: aacraid: Skip schedule rescan in case of kdump
      scsi: aacraid: Fix hang while scanning in eh recovery
      scsi: aacraid: Reschedule host scan in case of failure
      scsi: aacraid: Use hotplug handling function in place of scsi_scan_host
      scsi: aacraid: Block concurrent hotplug event handling
      scsi: aacraid: Merge adapter setup with resolve luns
      scsi: aacraid: Refactor resolve luns code and scsi functions
      scsi: aacraid: Added macros to help loop through known buses and targets
      scsi: aacraid: Process hba and container hot plug events in single function
      scsi: aacraid: Merge func to get container information
      scsi: aacraid: Add helper function to set queue depth
      scsi: aacraid: Save bmic phy information for each phy
      scsi: aacraid: Create helper functions to get lun info
      scsi: aacraid: Move function around to match existing code
      scsi: aacraid: Untangle targets setup from report phy luns
      scsi: aacraid: Add target setup helper function
      scsi: aacraid: Refactor and rename to make mirror existing changes
      scsi: aacraid: Change phy luns function to use common bmic function
      scsi: aacraid: Create bmic submission function from bmic identify
      scsi: aacraid: Move code to wait for IO completion to shutdown func
      scsi: aacraid: Refactor reset_host store function
      scsi: aacraid: Allow reset_host sysfs var to recover Panicked Fw
      scsi: aacraid: Fix ioctl reset hang
      scsi: aacraid: Do not remove offlined devices
      scsi: aacraid: Fix hang in kdump
      scsi: aacraid: Do not attempt abort when Fw panicked
      scsi: aacraid: Fix udev inquiry race condition

Randy Dunlap (5):
      scsi: doc: fix iscsi-related kernel-doc warnings
      scsi: documentation: add scsi_common.c to SCSI driver-api
      scsi: core: doc. fixes to scsi_common.c
      scsi: st: fix kernel-doc mismatch
      scsi: fix another I2O typo

Rasmus Villemoes (1):
      scsi: fnic: use kzalloc in fnic_fcoe_process_vlan_resp

Romain Perier (1):
      scsi: mpt3sas: Replace PCI pool old API

Sawan Chandak (1):
      scsi: qla2xxx: Fix NPIV host cleanup in target mode

Shivasharan S (14):
      scsi: megaraid_sas: NVMe passthrough command support
      scsi: megaraid_sas: driver version upgrade
      scsi: megaraid_sas: re-work DCMD refire code
      scsi: megaraid_sas: Expose fw_cmds_outstanding through sysfs
      scsi: megaraid_sas: Selectively apply stream detection based on IO type
      scsi: megaraid_sas: Update LD map after populating drv_map driver map copy
      scsi: megaraid_sas: Use megasas_wait_for_adapter_operational to detect controller state in IOCTL path
      scsi: megaraid_sas: Avoid firing DCMDs while OCR is in progress
      scsi: megaraid_sas: unload flag should be set after scsi_remove_host is called
      scsi: megaraid_sas: Error handling for invalid ldcount provided by firmware in RAID map
      scsi: megaraid_sas: Reset ldio_outstanding in megasas_resume
      scsi: megaraid_sas: Return the DCMD status from megasas_get_seq_num
      scsi: megaraid_sas: memset IOC INIT frame using correct size
      scsi: megaraid_sas: zero out IOC INIT and stream detection memory

Steffen Weber (1):
      scsi: smartpqi: allow static build ("built-in")

Suganath Prabu S (1):
      scsi: mpt3sas: Remove unused variable requeue_event

Suganath Prabu Subramani (1):
      scsi: mpt3sas: lockless command submission

Uma Krishnan (3):
      scsi: cxlflash: Adapter context init can return error
      scsi: cxlflash: Update cxl-specific arguments to generic cookie
      scsi: cxlflash: Reset command ioasc

Varun Prakash (1):
      scsi: libcxgbi: use GFP_ATOMIC in cxgbi_conn_alloc_pdu()

Vasyl Gomonovych (1):
      scsi: fnic: Fix coccinelle warnings

Wei Yongjun (2):
      scsi: qedf: Fix error return code in __qedf_probe()
      scsi: hisi_sas: make local symbol host_attrs static

Xiang Chen (9):
      scsi: hisi_sas: fix a bug in hisi_sas_dev_gone()
      scsi: hisi_sas: add v3 hw suspend and resume
      scsi: hisi_sas: re-add the lldd_port_deformed()
      scsi: hisi_sas: fix SAS_QUEUE_FULL problem while running IO
      scsi: hisi_sas: add some print to enhance debugging
      scsi: hisi_sas: change ncq process for v3 hw
      scsi: hisi_sas: modify hisi_sas_dev_gone() for reset
      scsi: hisi_sas: fix dma_unmap_sg() parameter
      scsi: hisi_sas: initialize dq spinlock before use

Xiaofei Tan (13):
      scsi: hisi_sas: directly attached disk LED feature for v2 hw
      scsi: hisi_sas: devicetree: bindings: add LED feature for v2 hw
      scsi: hisi_sas: add internal abort dev in some places
      scsi: hisi_sas: judge result of internal abort
      scsi: hisi_sas: do link reset for some CHL_INT2 ints
      scsi: hisi_sas: use an general way to delay PHY work
      scsi: hisi_sas: add v2 hw port AXI error handling support
      scsi: hisi_sas: improve int_chnl_int_v2_hw() consistency with v3 hw
      scsi: hisi_sas: add RAS feature for v3 hw
      scsi: hisi_sas: add an mechanism to do reset work synchronously
      scsi: hisi_sas: some optimizations of host controller reset
      scsi: hisi_sas: optimise port id refresh function
      scsi: hisi_sas: relocate clearing ITCT and freeing device

Xiongfeng Wang (1):
      scsi: mptfusion: use strlcpy() instead of strncpy()

Xose Vazquez Perez (5):
      scsi: devinfo: fix format of the device list
      scsi: devinfo: replace "Dell PV 650F" with "EMC CLARiiON"
      scsi: dh: add new rdac devices
      scsi: devinfo: apply to HP XP the same flags as Hitachi VSP
      scsi: devinfo: Apply to HP-rebranded the same flags as Hitachi

chenxiang (3):
      scsi: hisi_sas: Change frame type for SET MAX commands
      scsi: ata: enhance the definition of SET MAX feature field value
      scsi: libsas: initialize sas_phy status according to response of DISCOVER

    himanshu.madhani@cavium.com     (11):
      scsi: qla2xxx: Update driver version to 10.00.00.05-k
      scsi: qla2xxx: Fix warning for code intentation in __qla24xx_handle_gpdb_event()
      scsi: qla2xxx: Fix warning during port_name debug print
      scsi: qla2xxx: Fix warning in qla2x00_async_iocb_timeout()
      scsi: qla2xxx: Fix recursion while sending terminate exchange
      scsi: qla2xxx: Fix NULL pointer crash due to probe failure
      scsi: qla2xxx: Update driver version to 10.00.00.04-k
      scsi: qla2xxx: Allow relogin and session creation after reset
      scsi: qla2xxx: Use known NPort ID for Management Server login
      scsi: qla2xxx: Update driver version to 10.00.00.03-k
      scsi: qla2xxx: Fix memory leak in dual/target mode

    kwmad.kim@samsung.com     (1):
      scsi: ufs: add some definitions included in UFS HCI specification

And the diffstat:

 .../devicetree/bindings/scsi/hisilicon-sas.txt     |    5 +-
 Documentation/driver-api/scsi.rst                  |   10 +-
 drivers/message/fusion/mptbase.c                   |   59 +-
 drivers/message/fusion/mptctl.c                    |   25 +-
 drivers/message/fusion/mptsas.c                    |    1 -
 drivers/scsi/3w-9xxx.c                             |   26 +-
 drivers/scsi/3w-9xxx.h                             |    2 +-
 drivers/scsi/3w-sas.c                              |   15 +-
 drivers/scsi/aacraid/aachba.c                      |  473 +++++--
 drivers/scsi/aacraid/aacraid.h                     |   54 +-
 drivers/scsi/aacraid/commctrl.c                    |    6 +-
 drivers/scsi/aacraid/comminit.c                    |   49 +-
 drivers/scsi/aacraid/commsup.c                     |  220 +--
 drivers/scsi/aacraid/linit.c                       |   26 +-
 drivers/scsi/aacraid/sa.c                          |   32 +-
 drivers/scsi/arcmsr/arcmsr.h                       |  567 +++++---
 drivers/scsi/arcmsr/arcmsr_hba.c                   | 1318 ++++++++++-------
 drivers/scsi/arm/fas216.c                          |    2 +-
 drivers/scsi/bfa/bfa_core.c                        |    2 +-
 drivers/scsi/bfa/bfa_cs.h                          |    6 +-
 drivers/scsi/bfa/bfa_defs_svc.h                    |    3 +-
 drivers/scsi/bfa/bfa_fcbuild.c                     |    8 +-
 drivers/scsi/bfa/bfa_fcpim.c                       |    3 +-
 drivers/scsi/bfa/bfa_fcpim.h                       |    4 +-
 drivers/scsi/bfa/bfa_fcs.c                         |   78 +-
 drivers/scsi/bfa/bfa_fcs_lport.c                   |   62 +-
 drivers/scsi/bfa/bfa_ioc.c                         |   10 +-
 drivers/scsi/bfa/bfa_port.c                        |   15 +-
 drivers/scsi/bfa/bfa_port.h                        |    2 +-
 drivers/scsi/bfa/bfa_svc.c                         |   51 +-
 drivers/scsi/bfa/bfa_svc.h                         |    2 +-
 drivers/scsi/bfa/bfad.c                            |   23 +-
 drivers/scsi/bfa/bfad_attr.c                       |    5 +-
 drivers/scsi/bfa/bfad_bsg.c                        |   10 +-
 drivers/scsi/bfa/bfad_debugfs.c                    |    8 +-
 drivers/scsi/bfa/bfad_im.h                         |   32 +-
 drivers/scsi/bnx2fc/bnx2fc_fcoe.c                  |    4 +-
 drivers/scsi/bnx2fc/bnx2fc_hwi.c                   |   60 +-
 drivers/scsi/bnx2fc/bnx2fc_tgt.c                   |   51 +-
 drivers/scsi/bnx2i/bnx2i_hwi.c                     |   19 +-
 drivers/scsi/csiostor/csio_init.c                  |    2 +-
 drivers/scsi/csiostor/csio_init.h                  |    1 -
 drivers/scsi/csiostor/csio_mb.c                    |    6 +-
 drivers/scsi/cxgbi/libcxgbi.c                      |    2 +-
 drivers/scsi/cxlflash/Makefile                     |    2 +-
 drivers/scsi/cxlflash/backend.h                    |   41 +
 drivers/scsi/cxlflash/common.h                     |    8 +-
 drivers/scsi/cxlflash/cxl_hw.c                     |  168 +++
 drivers/scsi/cxlflash/main.c                       |  100 +-
 drivers/scsi/cxlflash/superpipe.c                  |   64 +-
 drivers/scsi/cxlflash/superpipe.h                  |    4 +-
 drivers/scsi/device_handler/scsi_dh_alua.c         |   37 +-
 drivers/scsi/fnic/fnic_debugfs.c                   |   22 +-
 drivers/scsi/fnic/fnic_fcs.c                       |    4 +-
 drivers/scsi/fnic/fnic_scsi.c                      |    2 +-
 drivers/scsi/fnic/fnic_stats.h                     |    4 +-
 drivers/scsi/fnic/fnic_trace.c                     |   58 +-
 drivers/scsi/hisi_sas/hisi_sas.h                   |   46 +-
 drivers/scsi/hisi_sas/hisi_sas_main.c              |  267 +++-
 drivers/scsi/hisi_sas/hisi_sas_v1_hw.c             |    6 +-
 drivers/scsi/hisi_sas/hisi_sas_v2_hw.c             |  194 ++-
 drivers/scsi/hisi_sas/hisi_sas_v3_hw.c             |  332 ++++-
 drivers/scsi/hosts.c                               |    6 +
 drivers/scsi/hpsa.c                                |   18 +-
 drivers/scsi/ibmvscsi/ibmvfc.c                     |   34 +-
 drivers/scsi/ibmvscsi_tgt/ibmvscsi_tgt.c           |  320 +++--
 drivers/scsi/ipr.c                                 |    4 +-
 drivers/scsi/iscsi_tcp.c                           |    2 +
 drivers/scsi/libiscsi.c                            |   28 +-
 drivers/scsi/libiscsi_tcp.c                        |    9 +-
 drivers/scsi/libsas/sas_ata.c                      |    1 -
 drivers/scsi/libsas/sas_discover.c                 |   34 +-
 drivers/scsi/libsas/sas_event.c                    |   86 +-
 drivers/scsi/libsas/sas_expander.c                 |   12 +-
 drivers/scsi/libsas/sas_init.c                     |  107 +-
 drivers/scsi/libsas/sas_internal.h                 |    7 +
 drivers/scsi/libsas/sas_phy.c                      |   69 +-
 drivers/scsi/libsas/sas_port.c                     |   25 +-
 drivers/scsi/libsas/sas_scsi_host.c                |   20 +-
 drivers/scsi/lpfc/lpfc.h                           |    6 +-
 drivers/scsi/lpfc/lpfc_attr.c                      |   59 +-
 drivers/scsi/lpfc/lpfc_crtn.h                      |    2 +
 drivers/scsi/lpfc/lpfc_ct.c                        |   20 +
 drivers/scsi/lpfc/lpfc_debugfs.c                   |   65 +-
 drivers/scsi/lpfc/lpfc_disc.h                      |    2 +
 drivers/scsi/lpfc/lpfc_els.c                       |  116 +-
 drivers/scsi/lpfc/lpfc_hbadisc.c                   |   29 +-
 drivers/scsi/lpfc/lpfc_hw4.h                       |    6 +-
 drivers/scsi/lpfc/lpfc_init.c                      |  294 ++--
 drivers/scsi/lpfc/lpfc_nportdisc.c                 |   88 +-
 drivers/scsi/lpfc/lpfc_nvme.c                      |  356 ++++-
 drivers/scsi/lpfc/lpfc_nvme.h                      |   17 +-
 drivers/scsi/lpfc/lpfc_nvmet.c                     |   71 +-
 drivers/scsi/lpfc/lpfc_nvmet.h                     |   10 +
 drivers/scsi/lpfc/lpfc_sli.c                       |  193 +--
 drivers/scsi/lpfc/lpfc_sli4.h                      |   14 +-
 drivers/scsi/lpfc/lpfc_version.h                   |    2 +-
 drivers/scsi/megaraid/megaraid_sas.h               |   37 +-
 drivers/scsi/megaraid/megaraid_sas_base.c          |  171 ++-
 drivers/scsi/megaraid/megaraid_sas_fp.c            |   28 +-
 drivers/scsi/megaraid/megaraid_sas_fusion.c        |   99 +-
 drivers/scsi/megaraid/megaraid_sas_fusion.h        |    6 +
 drivers/scsi/mpt3sas/mpt3sas_base.c                |  207 ++-
 drivers/scsi/mpt3sas/mpt3sas_base.h                |   29 +-
 drivers/scsi/mpt3sas/mpt3sas_ctl.c                 |   31 +-
 drivers/scsi/mpt3sas/mpt3sas_scsih.c               |  332 ++---
 drivers/scsi/mpt3sas/mpt3sas_warpdrive.c           |   33 +-
 drivers/scsi/pmcraid.c                             |    2 +-
 drivers/scsi/ppa.c                                 |    4 +
 drivers/scsi/qedf/qedf_main.c                      |    3 +
 drivers/scsi/qedi/qedi_fw.c                        |    2 +-
 drivers/scsi/qedi/qedi_main.c                      |   46 +-
 drivers/scsi/qla2xxx/qla_attr.c                    |    7 +-
 drivers/scsi/qla2xxx/qla_bsg.c                     |    9 +-
 drivers/scsi/qla2xxx/qla_def.h                     |  173 ++-
 drivers/scsi/qla2xxx/qla_dfs.c                     |   39 +-
 drivers/scsi/qla2xxx/qla_fw.h                      |    2 +-
 drivers/scsi/qla2xxx/qla_gbl.h                     |   32 +-
 drivers/scsi/qla2xxx/qla_gs.c                      | 1497 +++++++++++++++++---
 drivers/scsi/qla2xxx/qla_init.c                    | 1056 +++++++++-----
 drivers/scsi/qla2xxx/qla_inline.h                  |    1 +
 drivers/scsi/qla2xxx/qla_iocb.c                    |   65 +-
 drivers/scsi/qla2xxx/qla_isr.c                     |   56 +-
 drivers/scsi/qla2xxx/qla_mbx.c                     |  151 +-
 drivers/scsi/qla2xxx/qla_mid.c                     |  140 +-
 drivers/scsi/qla2xxx/qla_nx2.c                     |    2 -
 drivers/scsi/qla2xxx/qla_os.c                      |  528 ++++---
 drivers/scsi/qla2xxx/qla_sup.c                     |    1 +
 drivers/scsi/qla2xxx/qla_target.c                  |  761 +++++-----
 drivers/scsi/qla2xxx/qla_target.h                  |    4 +-
 drivers/scsi/qla2xxx/qla_tmpl.c                    |   40 +-
 drivers/scsi/qla2xxx/qla_version.h                 |    2 +-
 drivers/scsi/qla2xxx/tcm_qla2xxx.c                 |    5 +-
 drivers/scsi/qla4xxx/ql4_init.c                    |    5 +-
 drivers/scsi/qla4xxx/ql4_mbx.c                     |   21 +-
 drivers/scsi/qla4xxx/ql4_nx.c                      |    5 +-
 drivers/scsi/qla4xxx/ql4_os.c                      |   12 +-
 drivers/scsi/scsi_common.c                         |   14 +-
 drivers/scsi/scsi_debug.c                          |  724 +++++++---
 drivers/scsi/scsi_devinfo.c                        |   39 +-
 drivers/scsi/scsi_dh.c                             |    5 +-
 drivers/scsi/scsi_error.c                          |   21 +-
 drivers/scsi/scsi_lib.c                            |   50 +-
 drivers/scsi/scsi_priv.h                           |   15 +-
 drivers/scsi/scsi_sysfs.c                          |    3 -
 drivers/scsi/scsi_transport_fc.c                   |    4 +-
 drivers/scsi/sd.c                                  |    6 +-
 drivers/scsi/ses.c                                 |   11 +-
 drivers/scsi/smartpqi/Makefile                     |    2 +-
 drivers/scsi/st.c                                  |    2 +-
 drivers/scsi/storvsc_drv.c                         |    4 +-
 drivers/scsi/ufs/ufshci.h                          |   16 +
 drivers/scsi/wd719x.c                              |    4 +-
 include/linux/ata.h                                |    2 +
 include/scsi/libsas.h                              |   30 +-
 include/scsi/scsi_cmnd.h                           |    1 -
 include/scsi/scsi_host.h                           |    2 +
 include/scsi/scsi_proto.h                          |    1 +
 include/scsi/scsi_transport_fc.h                   |    4 +-
 include/scsi/scsi_transport_sas.h                  |    1 +
 kernel/rcu/update.c                                |    2 +
 161 files changed, 8932 insertions(+), 4525 deletions(-)
 create mode 100644 drivers/scsi/cxlflash/backend.h
 create mode 100644 drivers/scsi/cxlflash/cxl_hw.c

James
