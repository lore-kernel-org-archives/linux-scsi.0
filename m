From: James Bottomley <James.Bottomley@HansenPartnership.com>
Subject: [GIT PULL] first round of SCSI updates for the 4.19+ merge window
Date: Wed, 24 Oct 2018 11:59:11 +0100
Message-ID: <1540378751.3008.59.camel@HansenPartnership.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner@vger.kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
To: Andrew Morton <akpm@linux-foundation.org>, Linus Torvalds <torvalds@linux-foundation.org>
Cc: linux-scsi <linux-scsi@vger.kernel.org>, linux-kernel <linux-kernel@vger.kernel.org>
List-Id: linux-scsi@vger.kernel.org

This is mostly updates of the usual drivers: UFS, esp_scsi, NCR5380,
qla2xxx, lpfc, libsas, hisi_sas.  In addition there's a set of mostly
small updates to the target subsystem a set of conversions to the
generic DMA API, which do have some potential for issues in the older
drivers but we'll handle those as case by case fixes. A new myrs for
the DAC960/mylex raid controllers to replace the block based DAC960
which is also being removed by Jens in this merge window. Plus the
usual slew of trivial changes.

The patch is available here:

git://git.kernel.org/pub/scm/linux/kernel/git/jejb/scsi.git scsi-misc

The short changelog is:

Arnd Bergmann (2):
      scsi: ufs: fix integer type usage in uapi header
      scsi: raid_attrs: fix unused variable warning

Avri Altman (6):
      scsi: ufs-bsg: Add support for uic commands in ufs_bsg_request()
      scsi: ufs-bsg: Add support for raw upiu in ufs_bsg_request()
      scsi: ufs: Add API to execute raw upiu commands
      scsi: ufs: Use data structure size in pointer arithmetic
      scsi: ufs: Add a bsg endpoint that supports UPIUs
      scsi: uapi: ufs: Make utp_upiu_req visible to user space

Bart Van Assche (6):
      scsi: target/core: Always call transport_complete_callback() upon failure
      scsi: target/core: Use sg_alloc_table() instead of open-coding it
      scsi: target/core: Use the SECTOR_SHIFT constant
      scsi: target/core: Remove the SCF_COMPARE_AND_WRITE_POST flag
      scsi: target/core: Remove an unused data member from struct xcopy_pt_cmd
      scsi: target/core: Fix spelling in two source code comments

Bryant G. Ly (1):
      scsi: ibmvscsi_tgt: Remove target_wait_for_sess_cmd()

Chengguang Xu (1):
      scsi: libfc: remove unnecessary condition check

Christoph Hellwig (42):
      scsi: mesh: switch to generic DMA API
      scsi: ips: switch to generic DMA API
      scsi: smartpqi: fully convert to the generic DMA API
      scsi: vmw_pscsi: switch to generic DMA API
      scsi: snic: switch to generic DMA API
      scsi: qla4xxx: fully convert to the generic DMA API
      scsi: qla2xxx: fully convert to the generic DMA API
      scsi: qla1280: switch to generic DMA API
      scsi: qedi: fully convert to the generic DMA API
      scsi: qedf: fully convert to the generic DMA API
      scsi: pm8001: switch to generic DMA API
      scsi: nsp32: switch to generic DMA API
      scsi: mvsas: fully convert to the generic DMA API
      scsi: mvumi: switch to generic DMA API
      scsi: mpt3sas: switch to generic DMA API
      scsi: megaraid_sas: switch to generic DMA API
      scsi: megaraid_mbox: switch to generic DMA API
      scsi: hpsa: switch to generic DMA API
      scsi: fnic: switch to generic DMA API
      scsi: csiostor: switch to generic DMA API
      scsi: be2iscsi: switch to generic DMA API
      scsi: atp870u: switch to generic DMA API
      scsi: a100u2w: switch to generic DMA API
      scsi: BusLogic: switch to generic DMA API
      scsi: 3w-sas: fully convert to the generic DMA API
      scsi: 3w-xxx: fully convert to the generic DMA API
      scsi: 3w-9xxx: fully convert to the generic DMA API
      scsi: aic94xx: fully convert to the generic DMA API
      scsi: dc395x: use generic DMA API
      scsi: dc395x: fix DMA API usage in sg_update_list
      scsi: dc395x: fix dma API usage in srb_done
      scsi: dc395x: simplify list handling
      scsi: esp_scsi: remove union in esp_cmd_priv
      scsi: esp_scsi: move dma mapping into the core code
      scsi: esp_scsi: remove the dev argument to scsi_esp_register
      scsi: esp_scsi: use strong typing for the dev field
      scsi: sun_esp: don't use GFP_ATOMIC for command block allocation
      scsi: am53c974: use the generic DMA API
      scsi: lpfc: remove a bogus pci_dma_sync_single_for_device call
      scsi: megaraid_mbox: remove bogus use of pci_dma_sync_sg_* APIs
      scsi: ufs: add a low-level __ufshcd_issue_tm_cmd helper
      scsi: ufs: cleanup struct utp_task_req_desc

Colin Ian King (11):
      scsi: be2iscsi: fix spelling mistake "Retreiving" -> "Retrieving"
      scsi: lpfc: fix spelling mistake "Resrouce" -> "Resource"
      scsi: arcmsr: clean up clang warning on extraneous parentheses
      scsi: qla4xxx: Remove redundant check on drvr_wait
      scsi: megaraid: fix spelling mistake "maibox" -> "mailbox"
      scsi: iscsi: target: fix spelling mistake "entires" -> "entries"
      scsi: message: fusion: fix a few trivial spelling mistakes
      scsi: qla2xxx: fix typo "CT-PASSTRHU" -> "CT-PASSTHRU"
      scsi: aic7xxx: remove unused redundant variable num_chip_names
      scsi: be2iscsi: remove unused variable dmsg
      scsi: aacraid: remove unused variables dev and cpu

Dan Carpenter (4):
      scsi: myrs: Fix the processor absent message in processor_show()
      scsi: myrs: Fix a logical vs bitwise bug
      scsi: qla2xxx: don't allow negative thresholds
      scsi: lpfc: remove an unnecessary NULL check

Darren Trapp (1):
      scsi: qla2xxx: Allow FC-NVMe underrun to be handled by transport

David Disseldorp (5):
      scsi: target: stash sess_err_stats on Data-Out timeout
      scsi: target: split out helper for cxn timeout error stashing
      scsi: target: log NOP ping timeouts as errors
      scsi: target: log Data-Out timeouts as errors
      scsi: target: use ISCSI_IQN_LEN in iscsi_target_stat

Deepak Ukey (4):
      scsi: pm80xx: Update driver version to 0.1.39
      scsi: pm80xx: Fixed system hang issue during kexec boot
      scsi: pm80xx: Corrected dma_unmap_sg() parameter
      scsi: pm80xx: Fix for phy enable/disable functionality

Evan Green (1):
      scsi: ufs: Schedule clk gating work on correct queue

Faisal Mehmood (1):
      scsi: 53c700: Fix spelling of 'NEGOTIATION'

Finn Thain (15):
      scsi: esp_scsi: Optimize PIO loops
      scsi: esp_scsi: De-duplicate PIO routines
      scsi: esp_scsi: Eliminate ESP_FLAG_DOING_SLOWCMD
      scsi: esp_scsi: Grant disconnect privilege for untagged commands
      scsi: esp_scsi: Track residual for PIO transfers
      scsi: zorro_esp: Limit DMA transfers to 65535 bytes
      scsi: NCR5380: Check for bus reset
      scsi: NCR5380: Handle BUS FREE during reselection
      scsi: NCR5380: Don't call dsprintk() following reselection interrupt
      scsi: NCR5380: Don't clear busy flag when abort fails
      scsi: NCR5380: Check for invalid reselection target
      scsi: NCR5380: Use DRIVER_SENSE to indicate valid sense data
      scsi: NCR5380: Withhold disconnect privilege for REQUEST SENSE
      scsi: NCR5380: Have NCR5380_select() return a bool
      scsi: NCR5380: Reduce goto statements in NCR5380_select()

Geert Uytterhoeven (1):
      scsi: arcmsr: Spelling s/rebulid/rebuild/

George Kennedy (1):
      scsi: sym53c8xx: fix NULL pointer dereference panic in sym_int_sir()

Giridhar Malavali (2):
      scsi: qla2xxx: Move log messages before issuing command to firmware
      scsi: qla2xxx: Fix for double free of SRB structure

Greg Edwards (1):
      scsi: target: iblock: split T10 PI SGL across command bios

Gustavo A. R. Silva (3):
      scsi: hisi_sas: Fix NULL pointer dereference
      scsi: aic94xx: mark expected switch fall-throughs
      scsi: ips: fix missing break in switch

Hannes Reinecke (5):
      scsi: myrs: Add Mylex RAID controller (SCSI interface)
      scsi: myrb: Add Mylex RAID controller (block interface)
      scsi: libfc: retry PRLI if we cannot analyse the payload
      scsi: core: Allow state transitions from OFFLINE to BLOCKED
      scsi: NCR5380: Clear all unissued commands on host reset

Himanshu Madhani (8):
      scsi: qla2xxx: Return switch command on a timeout
      scsi: qla2xxx: Fix driver hang when FC-NVMe LUNs are configured
      scsi: qla2xxx: Update driver version to 10.00.00.11-k
      scsi: qla2xxx: Update driver version to 10.00.00.10-k
      scsi: qla2xxx: Remove stale ADISC_DONE event
      scsi: qla2xxx: Remove ASYNC GIDPN switch command
      scsi: qla2xxx: Update driver to version 10.00.00.09-k
      scsi: qla2xxx: Fix incorrect port speed being set for FC adapters

Igor Stoppa (1):
      scsi: core: remove unnecessary unlikely()

James Bottomley (1):
      scsi: myrs: fix build failure on 32 bit

James Smart (11):
      scsi: lpfc: update driver version to 12.0.0.7
      scsi: lpfc: add support to retrieve firmware logs
      scsi: lpfc: reduce locking when updating statistics
      scsi: lpfc: Fix errors in log messages.
      scsi: lpfc: Correct invalid EQ doorbell write on if_type=6
      scsi: lpfc: Correct irq handling via locks when taking adapter offline
      scsi: lpfc: Correct soft lockup when running mds diagnostics
      scsi: lpfc: Correct race with abort on completion path
      scsi: lpfc: Raise nvme defaults to support a larger io and more connectivity
      scsi: lpfc: raise sg count for nvme to use available sg resources
      scsi: lpfc: Fix GFT_ID and PRLI logic for RSCN

Jason Yan (5):
      scsi: libsas: fix a race condition when smp task timeout
      scsi: libsas: check the ata device status by ata_dev_enabled()
      scsi: libsas: always unregister the old device if going to discover new
      scsi: libsas: make the lldd_port_deformed method optional
      scsi: libsas: delete dead code in scsi_transport_sas.c

Jens Axboe (3):
      scsi: fnic: replace gross legacy tag hack with blk-mq hack
      scsi: sg: remove bad blk_end_request_all() call
      scsi: osd: initiator should use mq variant of request ending

Joe Perches (7):
      scsi: mpt3sas: Remove unused macro MPT3SAS_FMT
      scsi: mpt3sas: Convert logging uses with MPT3SAS_FMT without logging levels
      scsi: mpt3sas: Remove KERN_WARNING from panic uses
      scsi: mpt3sas: Convert logging uses with MPT3SAS_FMT and reply_q_name to %s:
      scsi: mpt3sas: Convert mlsleading uses of pr_<level> with MPT3SAS_FMT
      scsi: mpt3sas: Convert uses of pr_<level> with MPT3SAS_FMT to ioc_<level>
      scsi: mpt3sas: Add ioc_<level> logging macros

John Garry (1):
      scsi: hisi_sas: Fix spin lock management in slot_index_alloc_quirk_v2_hw()

Lance Roy (1):
      scsi: snic: Replace spin_is_locked() with lockdep

Laurence Oberman (1):
      scsi: core: Remove scsi_block_when_processing_errors: message

Luo Jiaxing (2):
      scsi: hisi_sas: Move evaluation of hisi_hba in hisi_sas_task_prep()
      scsi: hisi_sas: Feed back linkrate(max/min) when re-attached

Masanari Iida (1):
      scsi: qla2xxx: Fix comment in MODULE_PARM_DESC in qla2xxx

Matthew R. Ochs (1):
      scsi: MAINTAINERS: Fix typo in cxlflash stanza

Nathan Chancellor (11):
      scsi: iscsi_tcp: Explicitly cast param in iscsi_sw_tcp_host_get_param
      scsi: bfa: Avoid implicit enum conversion in bfad_im_post_vendor_event
      scsi: isci: Change sci_controller_start_task's return type to sci_status
      scsi: isci: Use proper enumerated type in atapi_d2h_reg_frame_handler
      scsi: qla2xxx: Simplify conditional check
      scsi: bfa: Remove unused functions
      scsi: qla2xxx: Remove unnecessary self assignment
      scsi: mpt3sas: Remove unnecessary parentheses and simplify null checks
      scsi: mptfusion: Remove unnecessary parentheses
      scsi: FlashPoint: Remove unnecessary parentheses
      scsi: advansys: Remove unnecessary parentheses

Nicholas Bellinger (2):
      scsi: target: Fix target_wait_for_sess_cmds breakage with active signals
      scsi: sched/wait: Add wait_event_lock_irq_timeout for TASK_UNINTERRUPTIBLE usage

Quinn Tran (40):
      scsi: qla2xxx: Fix recursive mailbox timeout
      scsi: qla2xxx: Fix re-using LoopID when handle is in use
      scsi: qla2xxx: Fix duplicate switch database entries
      scsi: qla2xxx: Fix NVMe Target discovery
      scsi: qla2xxx: Fix NVMe session hang on unload
      scsi: qla2xxx: Fix double increment of switch scan retry count
      scsi: qla2xxx: Fix duplicate switch's Nport ID entries
      scsi: qla2xxx: Remove stale debug trace message from tcm_qla2xxx
      scsi: qla2xxx: Fix premature command free
      scsi: qla2xxx: Reject bsg request if chip is down.
      scsi: qla2xxx: shutdown chip if reset fail
      scsi: qla2xxx: Fix stuck session in PLOGI state
      scsi: qla2xxx: Fix early srb free on abort
      scsi: qla2xxx: Add mode control for each physical port
      scsi: qla2xxx: Fix race condition for resource cleanup
      scsi: qla2xxx: Fix dropped srb resource.
      scsi: qla2xxx: Fix port speed display on chip reset
      scsi: qla2xxx: Increase abort timeout value
      scsi: qla2xxx: Move ABTS code behind qpair
      scsi: qla2xxx: Fix Remote port registration
      scsi: qla2xxx: Reduce holding sess_lock to prevent CPU lock-up
      scsi: qla2xxx: Move {get|rel}_sp to base_qpair struct
      scsi: qla2xxx: Add support for ZIO6 interrupt threshold
      scsi: qla2xxx: Fix out of order Termination and ABTS response
      scsi: qla2xxx: Add logic to detect ABTS hang and response completion
      scsi: qla2xxx: Add appropriate debug info for invalid RX_ID
      scsi: qla2xxx: Fix deadlock between ATIO and HW lock
      scsi: qla2xxx: Serialize mailbox request
      scsi: qla2xxx: Terminate Plogi/PRLI if WWN is 0
      scsi: qla2xxx: Defer chip reset until target mode is enabled
      scsi: qla2xxx: Fix iIDMA error
      scsi: qla2xxx: Remove all rports if fabric scan retry fails
      scsi: qla2xxx: Force fw cleanup on ADISC error
      scsi: qla2xxx: Turn off IOCB timeout timer on IOCB completion
      scsi: qla2xxx: Decrement login retry count for only plogi
      scsi: qla2xxx: Move rport registration out of internal work_list
      scsi: qla2xxx: Remove redundant check for fcport deletion
      scsi: qla2xxx: Update rscn_rcvd field to more meaningful scan_needed
      scsi: qla2xxx: Use correct qpair for ABTS/CMD
      scsi: qla2xxx: Fix process response queue for ISP26XX and above

Sam Protsenko (1):
      scsi: aic7xxx: Fix build using bare-metal toolchain

Sawan Chandak (1):
      scsi: qla2xxx: Check for Register disconnect

Souptick Joarder (1):
      scsi: mpt3sas: Use dma_pool_zalloc

Thomas Abraham (1):
      scsi: libfc: check fc_frame_payload_get() return value for null

Varun Prakash (2):
      scsi: cxgb4i: add DCB support for iSCSI connections
      scsi: target: iscsi: cxgbit: fix csk leak

Venkat Gopalakrishnan (1):
      scsi: ufs: make UFS Tx lane1 clock optional for QCOM platforms

Vivek Gautam (1):
      scsi: ufshcd: Fix NULL pointer dereference for in ufshcd_init

Wenwen Wang (1):
      scsi: megaraid_sas: fix a missing-check bug

Xiang Chen (5):
      scsi: hisi_sas: Update v3 hw AIP_LIMIT and CFG_AGING_TIME register values
      scsi: hisi_sas: Use block layer tag instead for IPTT
      scsi: hisi_sas: unmask interrupts ent72 and ent74
      scsi: hisi_sas: Free slot later in slot_complete_vx_hw()
      scsi: hisi_sas: Fix the race between IO completion and timeout for SMP/internal IO

YueHaibing (13):
      scsi: advansys: remove unused variable 'srb_tag' in adv_isr_callback
      scsi: lpfc: Remove set but not used variables 'tgtp'
      scsi: lpfc: Remove set but not used variable 'psli'
      scsi: lpfc: Remove set but not used variables 'fc_hdr' and 'hw_page_size'
      scsi: megaraid_mbox: remove set but not used variables
      scsi: arcmsr: Remove set but not used variables 'id, lun'
      scsi: qla2xxx: Remove set but not used variable 'ptr_dma'
      scsi: lpfc: Remove set but not used variable 'sgl_size'
      scsi: bnx2fc: Remove set but not used variable 'oxid'
      scsi: aic7xxx: remove set but not used variable 'shared_scb_data'
      scsi: pm80xx: Remove set but not used variable 'page_code'
      scsi: pm80xx: Remove set but not used variable 'device_id'
      scsi: libfc: remove set but not used variable 'rpriv'

zhong jiang (1):
      scsi: hpsa: Use vmemdup_user to replace the open code
