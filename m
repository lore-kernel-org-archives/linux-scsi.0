From: James Bottomley <James.Bottomley@HansenPartnership.com>
Subject: [GIT PULL] first round of SCSI updates for the 4.17+ merge window
Date: Sun, 10 Jun 2018 11:56:06 -0700
Message-ID: <1528656966.4064.3.camel@HansenPartnership.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner@vger.kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
To: Andrew Morton <akpm@linux-foundation.org>, Linus Torvalds <torvalds@linux-foundation.org>
Cc: linux-scsi <linux-scsi@vger.kernel.org>, linux-kernel <linux-kernel@vger.kernel.org>
List-Id: linux-scsi@vger.kernel.org

This is mostly updates to the usual drivers: ufs, qedf, mpt3sas, lpfc,
xfcp, hisi_sas, cxlflash, qla2xxx.  In the absence of Nic, we're also
taking target updates which are mostly minor except for the tcmu
refactor. The only real core change to worry about is the removal of
high page bouncing (in sas, storvsc and iscsi).  This has been well
tested and no problems have shown up so far.

There's a minor merge conflict in drivers/scsi/qedf.h where both we and
the net-next tree have added prototypes to the same part of the file,
but I'm sure you can sort it out.

The patch is available here:

git://git.kernel.org/pub/scm/linux/kernel/git/jejb/scsi.git scsi-misc

The short changelog is:

Alim Akhtar (4):
      scsi: ufs: make ufshcd_config_pwr_mode of non-static func
      scsi: ufs: add quirk to enable host controller without hce
      scsi: ufs: add quirk to disallow reset of interrupt aggregation
      scsi: ufs: add quirk to fix mishandling utrlclr/utmrlclr

Andrei Vagin (2):
      scsi: target: target/file: Add support of direct and async I/O
      scsi: qla2xxx: remove the unused tcm_qla2xxx_cmd_wq

Arnd Bergmann (2):
      scsi: ips: fix firmware timestamps for 32-bit
      scsi: esas2r: use ktime_get_real_seconds()

Bart Van Assche (2):
      scsi: sd_zbc: Let the SCSI core handle ILLEGAL REQUEST / ASC 0x21
      scsi: sd_zbc: Change the type of the ZBC fields into u32

Bjorn Andersson (2):
      scsi: ufs: Use freq table with devfreq
      scsi: ufs: Extract devfreq registration

Chad Dupuis (20):
      scsi: qedf: Update version number to 8.33.16.20
      scsi: qedf: Update copyright for 2018
      scsi: qedf: Add more defensive checks for concurrent error conditions
      scsi: qedf: Set the UNLOADING flag when removing a vport
      scsi: qedf: Add additional checks when restarting an rport due to ABTS timeout
      scsi: qedf: If qed fails to enable MSI-X fail PCI probe
      scsi: qedf: Honor default_prio module parameter even if DCBX does not converge
      scsi: qedf: Improve firmware debug dump handling
      scsi: qedf: Add task id to kref_get_unless_zero() debug messages when flushing requests
      scsi: qedf: Check if link is already up when receiving a link up event from qed
      scsi: qedf: Return request as DID_NO_CONNECT if MSI-X is not enabled
      scsi: qedf: Release RRQ reference correctly when RRQ command times out
      scsi: qedf: Honor priority from DCBX FCoE App tag
      scsi: qedf: Add dcbx_not_wait module parameter so we won't wait for DCBX convergence to start discovery
      scsi: qedf: Sanity check FCoE/FIP priority value to make sure it's between 0 and 7
      scsi: qedf: Add check for offload before flushing I/Os for target
      scsi: qedf: Fix VLAN display when printing sent FIP frames
      scsi: qedf: Add missing skb frees in error path
      scsi: qedf: Increase the number of default FIP VLAN request retries to 60
      scsi: qedf: Synchronize rport restarts when multiple ELS commands time out

Chaitra P B (14):
      scsi: mpt3sas: Update driver version "25.100.00.00"
      scsi: mpt3sas: fix possible memory leak.
      scsi: mpt3sas: For NVME device, issue a protocol level reset
      scsi: mpt3sas: Update MPI Headers
      scsi: mpt3sas: Report Firmware Package Version from HBA Driver.
      scsi: mpt3sas: Cache enclosure pages during enclosure add.
      scsi: mpt3sas: Allow processing of events during driver unload.
      scsi: mpt3sas: Increase event log buffer to support 24 port HBA's.
      scsi: mpt3sas: Added support for SAS Device Discovery Error Event.
      scsi: mpt3sas: Enhanced handling of Sense Buffer.
      scsi: mpt3sas: Optimize I/O memory consumption in driver.
      scsi: mpt3sas: Lockless access for chain buffers.
      scsi: mpt3sas: Pre-allocate RDPQ Array at driver boot time.
      scsi: mpt3sas: Bug fix for big endian systems.

Christoph Hellwig (3):
      scsi: scsi_transport_sas: don't bounce highmem pages for the smp handler
      scsi: storsvc: don't set a bounce limit
      scsi: iscsi_tcp: don't set a bounce limit

Christophe Jaillet (1):
      scsi: qlogicpti: Fix an error handling path in 'qpti_sbus_probe()'

Colin Ian King (12):
      scsi: target: fix spelling mistake "Uknown" -> "Unknown"
      scsi: pm80xx: fix spelling mistake "UNSORPORTED" -> "SUPPORTED"
      scsi: snic: fix a couple of spelling mistakes: "COMPLETE"
      scsi: esas2r: fix spelling mistake: "requestss" -> "requests"
      scsi: mptsas: fix spelling mistake: "matchs" -> "matches"
      scsi: lpfc: fix spelling mistakes: "mabilbox" and "maibox"
      scsi: mptfusion: fix spelling mistake: "initators" -> "initiators"
      scsi: mpt3sas: fix spelling mistake: "disbale" -> "disable"
      scsi: megaraid_sas: fix spelling mistake: "disbale" -> "disable"
      scsi: esas2r: fix spelling mistake: "asynchromous" -> "asynchronous"
      scsi: isci: remove redundant check on in_connection_align_insertion_frequency
      scsi: mptfc: fix spelling mistake in macro names

Dan Carpenter (1):
      scsi: megaraid: silence a static checker bug

Douglas Gilbert (1):
      scsi: core: sanitize++ in progress

Himanshu Jha (1):
      scsi: megaraid_sas: Use zeroing memory allocator than allocator/memset

James Smart (28):
      scsi: lpfc: update driver version to 12.0.0.4
      scsi: lpfc: Fix port initialization failure.
      scsi: lpfc: Fix 16gb hbas failing cq create.
      scsi: lpfc: Fix crash in blk_mq layer when executing modprobe -r lpfc
      scsi: lpfc: correct oversubscription of nvme io requests for an adapter
      scsi: lpfc: Fix MDS diagnostics failure (Rx < Tx)
      scsi: lpfc: Comment cleanup regarding Broadcom copyright header
      scsi: lpfc: update driver version to 12.0.0.3
      scsi: lpfc: Enhance log messages when reporting CQE errors
      scsi: lpfc: Fix up log messages and stats counters in IO submit code path
      scsi: lpfc: Driver NVME load fails when CPU cnt > WQ resource cnt
      scsi: lpfc: Handle new link fault code returned by adapter firmware.
      scsi: lpfc: Correct fw download error message
      scsi: lpfc: enhance LE data structure copies to hardware
      scsi: lpfc: Change IO submit return to EBUSY if remote port is recovering
      scsi: lpfc: update driver version to 12.0.0.2
      scsi: lpfc: Correct missing remoteport registration during link bounces
      scsi: lpfc: Fix NULL pointer reference when resetting adapter
      scsi: lpfc: Fix nvme remoteport registration race conditions
      scsi: lpfc: Fix driver not recovering NVME rports during target link faults
      scsi: lpfc: Fix WQ/CQ creation for older asic's.
      scsi: lpfc: Fix NULL pointer access in lpfc_nvme_info_show
      scsi: lpfc: Fix lingering lpfc_wq resource after driver unload
      scsi: lpfc: Fix Abort request WQ selection
      scsi: lpfc: Enlarge nvmet asynchronous receive buffer counts
      scsi: lpfc: Add per io channel NVME IO statistics
      scsi: lpfc: Correct target queue depth application changes
      scsi: lpfc: Fix multiple PRLI completion error path

Jason Yan (1):
      scsi: libsas: add transport class for ATA devices

Jens Remus (3):
      scsi: zfcp: enhance comments on fc_link_speed and supported_speed
      scsi: zfcp: add port speed capabilities
      scsi: zfcp: assert that the ERP lock is held when tracing a recovery trigger

Jia-Ju Bai (2):
      scsi: st: Replace GFP_ATOMIC with GFP_KERNEL in new_tape_buffer
      scsi: st: Replace GFP_ATOMIC with GFP_KERNEL in st_probe

John Garry (5):
      scsi: hisi_sas: Introduce hisi_sas_phy_set_linkrate()
      scsi: hisi_sas: add readl poll timeout helper wrappers
      scsi: hisi_sas: stop controller timer for reset
      scsi: hisi_sas: remove some unneeded structure members
      scsi: hisi_sas: print device id for errors

Kees Cook (3):
      scsi: dpt_i2o: Remove VLA usage
      scsi: ufs: ufshcd: Remove VLA usage
      scsi: libosd: Remove VLA usage

Lee Duncan (2):
      scsi: target: transport should handle st FM/EOM/ILI reads
      scsi: target: prefer dbroot of /etc/target over /var/target

Long Li (3):
      scsi: storvsc: Select channel based on available percentage of ring buffer to write
      scsi: netvsc: Use the vmbus function to calculate ring buffer percentage
      scsi: vmbus: Add function to report available ring buffer to write in total ring size percentage

Luc Van Oostenryck (1):
      scsi: mptlan: Fix mpt_lan_sdu_send()'s return type

Martin Wilck (6):
      scsi: devinfo: BLIST_RETRY_ASC_C1 for Fujitsu ETERNUS
      scsi: devinfo: add BLIST_RETRY_ITF for EMC Symmetrix
      scsi: devinfo: warn on undefined blist flags
      scsi: devinfo: change blist_flag_t to 64bit
      scsi: devinfo: use const_ilog2 for array indices
      scsi: ilog2: create truly constant version for sparse

Matthew R. Ochs (2):
      scsi: cxlflash: Use local mutex for AFU serialization
      scsi: cxlflash: Avoid clobbering context control register value

Maya Erez (1):
      scsi: ufs: fix exception event handling

Michael Kelley (1):
      scsi: storvsc: Avoid allocating memory for temp cpumasks

Michael Schmitz (1):
      scsi: zorro_esp: New driver for Amiga Zorro NCR53C9x boards

Quinn Tran (9):
      scsi: qla2xxx: Fix TMF and Multi-Queue config
      scsi: qla2xxx: Remove stale debug value for login_retry flag
      scsi: qla2xxx: Use predefined get_datalen_for_atio() inline function
      scsi: qla2xxx: Fix Inquiry command being dropped in Target mode
      scsi: qla2xxx: Move GPSC and GFPNID out of session management
      scsi: qla2xxx: Reduce redundant ADISC command for RSCNs
      scsi: qla2xxx: Delete session for nport id change
      scsi: qla2xxx: Fix Rport and session state getting out of sync
      scsi: qla2xxx: Fix sending ADISC command for login

Randy Dunlap (4):
      scsi: target: add driver-api document
      scsi: target: target_core_user.[ch]: convert comments into DOC:
      scsi: target: target_core_transport.c: enable+fix kernel-doc
      scsi: target: target_core_transport.c: fix kernel-doc warnings

Saurav Kashyap (1):
      scsi: qedf: Remove setting DCBX pending during soft context reset

Shivasharan S (2):
      scsi: megaraid_sas: driver version upgrade
      scsi: megaraid_sas: Increase timeout by 1 sec for non-RAID fastpath IOs

Souptick Joarder (2):
      scsi: target: Change return type to vm_fault_t
      scsi: sg: Change return type to vm_fault_t

Steffen Maier (22):
      scsi: zfcp: cleanup indentation for posting FC events
      scsi: zfcp: support SCSI_ADAPTER_RESET via scsi_host sysfs attribute host_reset
      scsi: zfcp: explicitly support initiator in scsi_host_template
      scsi: zfcp: remove unused return values of ERP trigger functions
      scsi: zfcp: zfcp_erp_action_exists() does only check for running
      scsi: zfcp: remove unused ERP enum values
      scsi: zfcp: consistently use function name space prefix
      scsi: zfcp: workqueue: set description for port work items with their WWPN as context
      scsi: zfcp: decouple our scsi_eh callbacks from scsi_cmnd
      scsi: zfcp: decouple TMFs from scsi_cmnd by using fc_block_rport
      scsi: zfcp: decouple SCSI setup of TMF from scsi_cmnd
      scsi: zfcp: decouple FSF request setup of TMF from scsi_cmnd
      scsi: zfcp: split FCP_CMND IU setup between SCSI I/O and TMF again
      scsi: zfcp: decouple TMF response handler from scsi_cmnd
      scsi: zfcp: decouple SCSI traces for scsi_eh / TMF from scsi_cmnd
      scsi: zfcp: fix missing REC trigger trace on enqueue without ERP thread
      scsi: zfcp: fix missing REC trigger trace for all objects in ERP_FAILED
      scsi: zfcp: fix missing REC trigger trace on terminate_rport_io for ERP_FAILED
      scsi: zfcp: fix missing REC trigger trace on terminate_rport_io early return
      scsi: zfcp: fix misleading REC trigger trace where erp_action setup failed
      scsi: zfcp: fix missing SCSI trace for retry of abort / scsi_eh TMF
      scsi: zfcp: fix missing SCSI trace for result of eh_host_reset_handler

Subhash Jadavani (3):
      scsi: ufs: ufs-qcom: remove broken hci version quirk
      scsi: ufs: add reference counting for scsi block requests
      scsi: ufs: ufshcd: fix possible unclocked register access

Tomohiro Kusumi (2):
      scsi: mpt3sas: fix header path in ioctl documentation
      scsi: mpt3sas: remove obsolete path "drivers/scsi/mpt2sas/" from MAINTAINERS

Uma Krishnan (46):
      scsi: cxlflash: Isolate external module dependencies
      scsi: cxlflash: Abstract hardware dependent assignments
      scsi: cxlflash: Add include guards to backend.h
      scsi: cxlflash: Acquire semaphore before invoking ioctl services
      scsi: cxlflash: Limit the debug logs in the IO path
      scsi: cxlflash: Yield to active send threads
      scsi: cxlflash: Handle spurious interrupts
      scsi: cxlflash: Remove commmands from pending list on timeout
      scsi: cxlflash: Synchronize reset and remove ops
      scsi: cxlflash: Enable OCXL operations
      scsi: cxlflash: Support AFU reset
      scsi: cxlflash: Register for translation errors
      scsi: cxlflash: Introduce OCXL context state machine
      scsi: cxlflash: Update synchronous interrupt status bits
      scsi: cxlflash: Setup LISNs for master contexts
      scsi: cxlflash: Setup LISNs for user contexts
      scsi: cxlflash: Introduce object handle fop
      scsi: cxlflash: Support file descriptor mapping
      scsi: cxlflash: Support adapter context mmap and release
      scsi: cxlflash: Support adapter context reading
      scsi: cxlflash: Support adapter context polling
      scsi: cxlflash: Support starting user contexts
      scsi: cxlflash: Support AFU interrupt mapping and registration
      scsi: cxlflash: Support AFU interrupt management
      scsi: cxlflash: Support process element lifecycle
      scsi: cxlflash: Setup OCXL transaction layer
      scsi: cxlflash: Setup function OCXL link
      scsi: cxlflash: Support reading adapter VPD data
      scsi: cxlflash: Support AFU state toggling
      scsi: cxlflash: Support process specific mappings
      scsi: cxlflash: Support starting an adapter context
      scsi: cxlflash: MMIO map the AFU
      scsi: cxlflash: Support image reload policy modification
      scsi: cxlflash: Support adapter context discovery
      scsi: cxlflash: Support adapter file descriptors for OCXL
      scsi: cxlflash: Use IDR to manage adapter contexts
      scsi: cxlflash: Adapter context support for OCXL
      scsi: cxlflash: Setup AFU PASID
      scsi: cxlflash: Setup AFU acTag range
      scsi: cxlflash: Read host AFU configuration
      scsi: cxlflash: Setup function acTag range
      scsi: cxlflash: Read host function configuration
      scsi: cxlflash: Hardware AFU for OCXL
      scsi: cxlflash: Introduce OCXL backend
      scsi: cxlflash: Add argument identifier names
      scsi: cxlflash: Preserve number of interrupts for master contexts

Venkat Gopalakrishnan (1):
      scsi: ufs: make sure all interrupts are processed

Vijay Viswanath (1):
      scsi: ufs: Add clock ungating to a separate workqueue

Wei Yongjun (1):
      scsi: hisi_sas: fix a typo in hisi_sas_task_prep()

Wen Xiong (1):
      scsi: ipr: new IOASC update

Wenwen Wang (2):
      scsi: 3w-xxxx: fix a missing-check bug
      scsi: 3w-9xxx: fix a missing-check bug

Xiang Chen (20):
      scsi: hisi_sas: Mark PHY as in reset for nexus reset
      scsi: hisi_sas: Create a scsi_host_template per HW module
      scsi: hisi_sas: Reset disks when discovered
      scsi: hisi_sas: Change common allocation mode of device id
      scsi: hisi_sas: change slot index allocation mode
      scsi: hisi_sas: Use device lock to protect slot alloc/free
      scsi: hisi_sas: Don't lock DQ for complete task sending
      scsi: hisi_sas: allocate slot buffer earlier
      scsi: hisi_sas: make return type of prep functions void
      scsi: hisi_sas: relocate smp sg map
      scsi: hisi_sas: config ATA de-reset as an constrained command for v3 hw
      scsi: hisi_sas: update PHY linkrate after a controller reset
      scsi: hisi_sas: check sas_dev gone earlier in hisi_sas_abort_task()
      scsi: hisi_sas: fix PI memory size
      scsi: hisi_sas: check host frozen before calling "done" function
      scsi: hisi_sas: Add some checks to avoid free'ing a sas_task twice
      scsi: hisi_sas: optimise the usage of DQ locking
      scsi: hisi_sas: use dma_zalloc_coherent()
      scsi: hisi_sas: delete timer when removing hisi_sas driver
      scsi: hisi_sas: make SAS address of SATA disks unique

Xiaofei Tan (13):
      scsi: hisi_sas: Fix return value when get_free_slot() failed
      scsi: hisi_sas: Terminate STP reject quickly for v2 hw
      scsi: hisi_sas: Add v2 hw force PHY function for internal ATA command
      scsi: hisi_sas: Include TMF elements in struct hisi_sas_slot
      scsi: hisi_sas: Try wait commands before before controller reset
      scsi: hisi_sas: Init disks after controller reset
      scsi: hisi_sas: Add LED feature for v3 hw
      scsi: hisi_sas: add check of device in hisi_sas_task_exec()
      scsi: hisi_sas: workaround a v3 hw hilink bug
      scsi: hisi_sas: remove redundant handling to event95 for v3
      scsi: hisi_sas: check IPTT is valid before using it for v3 hw
      scsi: hisi_sas: consolidate command check in hisi_sas_get_ata_protocol()
      scsi: hisi_sas: update RAS feature for later revision of v3 HW

Xose Vazquez Perez (2):
      scsi: scsi_dh: replace too broad "TP9" string with the exact models
      scsi: devinfo: delete duplicate "Generic"/"USB Storage-SMC" device

YueHaibing (4):
      scsi: a100u2w: Use module_pci_driver
      scsi: wd719x: Use module_pci_driver
      scsi: am53c974: Use module_pci_driver
      scsi: mvumi: Using module_pci_driver

Zhu Lingshan (6):
      scsi: tcmu: refactor nl wr_cache attr with new helpers
      scsi: tcmu: refactor nl dev_size attr with new helpers
      scsi: tcmu: refactor nl dev_cfg attr with new nl helpers
      scsi: tcmu: refactor rm_device cmd with new nl helpers
      scsi: tcmu: refactor add_device cmd with new nl helpers
      scsi: tcmu: add new netlink events helpers

himanshu.madhani@cavium.com (2):
      scsi: qla2xxx: Update driver version to 10.00.00.07-k
      scsi: qla2xxx: Prevent relogin loop by removing stale code

And the diffstat:

 Documentation/driver-api/index.rst          |    1 +
 Documentation/driver-api/scsi.rst           |    2 +-
 Documentation/driver-api/target.rst         |   64 ++
 Documentation/ioctl/ioctl-number.txt        |    2 +-
 MAINTAINERS                                 |    1 -
 drivers/ata/libata-scsi.c                   |   12 +
 drivers/hv/ring_buffer.c                    |    2 +
 drivers/message/fusion/lsi/mpi_cnfg.h       |    4 +-
 drivers/message/fusion/mptbase.c            |    2 +-
 drivers/message/fusion/mptfc.c              |    2 +-
 drivers/message/fusion/mptlan.c             |    2 +-
 drivers/message/fusion/mptsas.c             |    2 +-
 drivers/net/hyperv/hyperv_net.h             |    1 -
 drivers/net/hyperv/netvsc.c                 |   18 +-
 drivers/net/hyperv/netvsc_drv.c             |    3 -
 drivers/s390/scsi/zfcp_dbf.c                |   90 +-
 drivers/s390/scsi/zfcp_dbf.h                |   21 +-
 drivers/s390/scsi/zfcp_erp.c                |  194 ++--
 drivers/s390/scsi/zfcp_ext.h                |   16 +-
 drivers/s390/scsi/zfcp_fc.c                 |   11 +-
 drivers/s390/scsi/zfcp_fc.h                 |   22 +-
 drivers/s390/scsi/zfcp_fsf.c                |   61 +-
 drivers/s390/scsi/zfcp_fsf.h                |    6 +-
 drivers/s390/scsi/zfcp_scsi.c               |  141 ++-
 drivers/s390/scsi/zfcp_sysfs.c              |    5 +-
 drivers/scsi/3w-9xxx.c                      |    5 +
 drivers/scsi/3w-xxxx.c                      |    3 +
 drivers/scsi/Kconfig                        |   14 +
 drivers/scsi/Makefile                       |    3 +-
 drivers/scsi/a100u2w.c                      |   13 +-
 drivers/scsi/am53c974.c                     |   13 +-
 drivers/scsi/cxlflash/Kconfig               |    2 +-
 drivers/scsi/cxlflash/Makefile              |    4 +-
 drivers/scsi/cxlflash/backend.h             |   55 +-
 drivers/scsi/cxlflash/common.h              |   12 +-
 drivers/scsi/cxlflash/cxl_hw.c              |   13 +
 drivers/scsi/cxlflash/lunmgt.c              |    4 +-
 drivers/scsi/cxlflash/main.c                |   97 +-
 drivers/scsi/cxlflash/main.h                |   21 +
 drivers/scsi/cxlflash/ocxl_hw.c             | 1436 +++++++++++++++++++++++++++
 drivers/scsi/cxlflash/ocxl_hw.h             |   77 ++
 drivers/scsi/cxlflash/sislite.h             |   41 +-
 drivers/scsi/cxlflash/superpipe.c           |   23 +-
 drivers/scsi/cxlflash/vlun.c                |    3 +-
 drivers/scsi/dpt_i2o.c                      |   21 +-
 drivers/scsi/esas2r/esas2r_init.c           |    5 +-
 drivers/scsi/esas2r/esas2r_ioctl.c          |    2 +-
 drivers/scsi/esas2r/esas2r_main.c           |    2 +-
 drivers/scsi/hisi_sas/hisi_sas.h            |   52 +-
 drivers/scsi/hisi_sas/hisi_sas_main.c       |  638 ++++++++----
 drivers/scsi/hisi_sas/hisi_sas_v1_hw.c      |  164 ++-
 drivers/scsi/hisi_sas/hisi_sas_v2_hw.c      |  284 +++---
 drivers/scsi/hisi_sas/hisi_sas_v3_hw.c      |  452 ++++++---
 drivers/scsi/ipr.c                          |    2 +
 drivers/scsi/ips.c                          |   78 +-
 drivers/scsi/ips.h                          |   11 +-
 drivers/scsi/isci/init.c                    |    3 -
 drivers/scsi/iscsi_tcp.c                    |    1 -
 drivers/scsi/libsas/sas_ata.c               |    5 +
 drivers/scsi/libsas/sas_discover.c          |    1 +
 drivers/scsi/lpfc/lpfc.h                    |    9 +-
 drivers/scsi/lpfc/lpfc_attr.c               |  124 ++-
 drivers/scsi/lpfc/lpfc_bsg.c                |   20 +-
 drivers/scsi/lpfc/lpfc_ct.c                 |   10 +
 drivers/scsi/lpfc/lpfc_debugfs.c            |   98 +-
 drivers/scsi/lpfc/lpfc_els.c                |    1 -
 drivers/scsi/lpfc/lpfc_hbadisc.c            |    7 +-
 drivers/scsi/lpfc/lpfc_hw4.h                |    7 +-
 drivers/scsi/lpfc/lpfc_init.c               |  153 ++-
 drivers/scsi/lpfc/lpfc_nportdisc.c          |   35 +-
 drivers/scsi/lpfc/lpfc_nvme.c               |  238 +++--
 drivers/scsi/lpfc/lpfc_nvme.h               |   17 +-
 drivers/scsi/lpfc/lpfc_nvmet.h              |    6 +-
 drivers/scsi/lpfc/lpfc_scsi.c               |   33 +-
 drivers/scsi/lpfc/lpfc_scsi.h               |    2 +-
 drivers/scsi/lpfc/lpfc_sli.c                |  116 ++-
 drivers/scsi/lpfc/lpfc_version.h            |    4 +-
 drivers/scsi/megaraid.c                     |    3 +
 drivers/scsi/megaraid/megaraid_sas.h        |    4 +-
 drivers/scsi/megaraid/megaraid_sas_base.c   |   27 +-
 drivers/scsi/megaraid/megaraid_sas_fusion.c |    8 +-
 drivers/scsi/mpt3sas/mpi/mpi2.h             |    9 +-
 drivers/scsi/mpt3sas/mpi/mpi2_cnfg.h        |   30 +-
 drivers/scsi/mpt3sas/mpi/mpi2_init.h        |    2 +-
 drivers/scsi/mpt3sas/mpi/mpi2_ioc.h         |    7 +-
 drivers/scsi/mpt3sas/mpt3sas_base.c         |  477 ++++++---
 drivers/scsi/mpt3sas/mpt3sas_base.h         |   60 +-
 drivers/scsi/mpt3sas/mpt3sas_ctl.c          |   33 +-
 drivers/scsi/mpt3sas/mpt3sas_ctl.h          |    2 +-
 drivers/scsi/mpt3sas/mpt3sas_scsih.c        |  491 ++++++---
 drivers/scsi/mpt3sas/mpt3sas_warpdrive.c    |    3 +-
 drivers/scsi/mvumi.c                        |   20 +-
 drivers/scsi/osd/osd_initiator.c            |   16 +-
 drivers/scsi/pm8001/pm8001_hwi.c            |    2 +-
 drivers/scsi/qedf/drv_fcoe_fw_funcs.c       |    2 +-
 drivers/scsi/qedf/drv_fcoe_fw_funcs.h       |    2 +-
 drivers/scsi/qedf/drv_scsi_fw_funcs.c       |    2 +-
 drivers/scsi/qedf/drv_scsi_fw_funcs.h       |    2 +-
 drivers/scsi/qedf/qedf.h                    |    6 +-
 drivers/scsi/qedf/qedf_attr.c               |    2 +-
 drivers/scsi/qedf/qedf_dbg.c                |    4 +-
 drivers/scsi/qedf/qedf_dbg.h                |    2 +-
 drivers/scsi/qedf/qedf_debugfs.c            |    2 +-
 drivers/scsi/qedf/qedf_els.c                |   35 +-
 drivers/scsi/qedf/qedf_fip.c                |    5 +-
 drivers/scsi/qedf/qedf_hsi.h                |    2 +-
 drivers/scsi/qedf/qedf_io.c                 |   87 +-
 drivers/scsi/qedf/qedf_main.c               |  130 ++-
 drivers/scsi/qedf/qedf_version.h            |    6 +-
 drivers/scsi/qla2xxx/qla_def.h              |    4 +-
 drivers/scsi/qla2xxx/qla_gbl.h              |    3 +-
 drivers/scsi/qla2xxx/qla_gs.c               |   41 +-
 drivers/scsi/qla2xxx/qla_init.c             |  105 +-
 drivers/scsi/qla2xxx/qla_os.c               |    4 +
 drivers/scsi/qla2xxx/qla_target.c           |  192 +++-
 drivers/scsi/qla2xxx/qla_target.h           |    4 +-
 drivers/scsi/qla2xxx/qla_version.h          |    2 +-
 drivers/scsi/qla2xxx/tcm_qla2xxx.c          |   37 +-
 drivers/scsi/qlogicpti.c                    |    6 +-
 drivers/scsi/scsi_debugfs.c                 |    2 +-
 drivers/scsi/scsi_devinfo.c                 |   31 +-
 drivers/scsi/scsi_dh.c                      |    5 +-
 drivers/scsi/scsi_error.c                   |    7 +
 drivers/scsi/scsi_lib.c                     |    4 +
 drivers/scsi/scsi_sysfs.c                   |    2 +-
 drivers/scsi/scsi_transport_sas.c           |    4 -
 drivers/scsi/sd.h                           |   12 +-
 drivers/scsi/sd_zbc.c                       |   10 -
 drivers/scsi/sg.c                           |    2 +-
 drivers/scsi/snic/snic_scsi.c               |    6 +-
 drivers/scsi/st.c                           |    6 +-
 drivers/scsi/storvsc_drv.c                  |   85 +-
 drivers/scsi/ufs/ufs-qcom.c                 |    2 +-
 drivers/scsi/ufs/ufshcd.c                   |  308 +++++-
 drivers/scsi/ufs/ufshcd.h                   |   21 +
 drivers/scsi/wd719x.c                       |   13 +-
 drivers/scsi/zorro_esp.c                    | 1172 ++++++++++++++++++++++
 drivers/target/target_core_configfs.c       |   25 +
 drivers/target/target_core_file.c           |  137 ++-
 drivers/target/target_core_file.h           |    1 +
 drivers/target/target_core_internal.h       |    1 +
 drivers/target/target_core_pscsi.c          |   26 +-
 drivers/target/target_core_transport.c      |   64 +-
 drivers/target/target_core_user.c           |  160 ++-
 include/linux/hyperv.h                      |   12 +
 include/linux/libata.h                      |    2 +
 include/linux/log2.h                        |   35 +-
 include/scsi/scsi_device.h                  |    2 +-
 include/scsi/scsi_devinfo.h                 |   75 +-
 include/target/target_core_base.h           |    1 +
 include/uapi/linux/target_core_user.h       |   11 +-
 kernel/workqueue.c                          |    1 +
 152 files changed, 7234 insertions(+), 2017 deletions(-)
 create mode 100644 Documentation/driver-api/target.rst
 create mode 100644 drivers/scsi/cxlflash/ocxl_hw.c
 create mode 100644 drivers/scsi/cxlflash/ocxl_hw.h
 create mode 100644 drivers/scsi/zorro_esp.c

James
