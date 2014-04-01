From: James Bottomley <James.Bottomley@HansenPartnership.com>
Subject: [GIT PULL] First round of SCSI updates for the 3.14+ merge window
Date: Tue, 01 Apr 2014 06:53:29 -0700
Message-ID: <1396360409.2187.10.camel@dabdike.int.hansenpartnership.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="ISO-8859-15"
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from bedivere.hansenpartnership.com ([66.63.167.143]:55962 "EHLO
	bedivere.hansenpartnership.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751289AbaDANxb (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Tue, 1 Apr 2014 09:53:31 -0400
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Andrew Morton <akpm@linux-foundation.org>, Linus Torvalds <torvalds@linux-foundation.org>
Cc: linux-scsi <linux-scsi@vger.kernel.org>, linux-kernel <linux-kernel@vger.kernel.org>

This patch consists of the usual driver updates (megaraid_sas,
scsi_debug, qla2xxx, qla4xxx, lpfc, bnx2fc, be2iscsi, hpsa, ipr) plus an
assortment of minor fixes and the first precursors of SCSI-MQ (the code
path simplifications) and the bug fix for the USB oops on remove (which
involves an infrastructure change, so is sent via the main tree with a
delayed backport after a cycle in which it is shown to introduce no new
bugs).

The patch is available here:

git://git.kernel.org/pub/scm/linux/kernel/git/jejb/scsi.git scsi-misc

The short changelog is:

Adam Radford (5):
      megaraid_sas: Version and Changelog update
      megaraid_sas: Add Dell PowerEdge VRTX SR-IOV VF support
      megaraid_sas: Return leaked MPT frames to MPT frame pool
      megaraid_sas: Fix megasas_ioc_init_fusion
      megaraid_sas: Load correct raid context timeout

Akinobu Mita (7):
      scsi_debug: add ability to enable clustering
      scsi_debug: protect device access with atomic_rw lock
      scsi_debug: prepare to enable clustering
      scsi_debug: fix resp_xdwriteread() return value when running out of memory
      scsi_debug: fix duplicate dif_errors increment
      scsi_debug: make pseudo_primary static
      scsi_debug: fix false positive logical block reference tag check fail

Alan Stern (1):
      sd: don't fail if the device doesn't recognize SYNCHRONIZE CACHE

Alexander Gordeev (2):
      ipr: Use pci_enable_msi_range() and pci_enable_msix_range()
      ipr: Get rid of superfluous call to pci_disbale_msi/msix()

Anil Gurumurthy (1):
      bfa: Updating Maintainers email ids

Armen Baloyan (6):
      qla2xxx: Add IOCB Abort command asynchronous handling.
      qla2xxx: Fix Task Management command asynchronous handling
      qla2xxx: Add changes in the IOCB structures to adjust driver source codes to ISPFX00 firmware spec.
      qla2xxx: Remove Marker type IOCB logic for ISPFX00.
      qla2xxx: Replace constant value for IOCTL IOCB abort execution status with a macro for ISPFX00.
      qla2xxx: Add handling for boot indication progress AENs for ISPFX00.

Arvind Kumar (2):
      vmw_pvscsi: Some improvements in pvscsi driver.
      vmw_pvscsi: Fix pvscsi_abort() function.

Atul Deshmukh (2):
      qla2xxx: Remove ISP_ABORT_NEEDED and ISP_ABORT_RETRY checks from watchdog function for ISP8044.
      qla2xxx: Use proper message for Non owner reset ACK Timeout.

Bart Van Assche (2):
      remove a useless get/put_device pair in scsi_next_command
      remove a useless get/put_device pair in scsi_request_fn

Ben Hutchings (1):
      bfa: Replace large udelay() with mdelay()

Bradley Grove (2):
      pm80xx: Enable BAR shift to avoid BIOS conflict with MPI space for ATTO pm8001 based HBAs.
      pm80xx: Read saved WWN from NVMD for ATTO pm8001 based HBAs.

Brian King (1):
      ipr: Handle early EEH

Chad Dupuis (7):
      qla2xxx: Fix build errors related to invalid print fields on some architectures.
      qla2xxx: Fixup looking for a space in the outstanding_cmds array in qla2x00_alloc_iocbs().
      qla2xxx: Read capture firmware dump on mailbox timeout for ISP8044 and ISP82XX.
      qla2xxx: Add support for ISP2071.
      scsi_transport_fc: Add 32Gbps speed definition.
      qla2xxx: Set host can_queue value based on available resources.
      qla2xxx: Add mutex around optrom calls to serialize accesses.

Christoph Hellwig (7):
      add support for per-host cmd pools
      simplify command allocation and freeing a bit
      megaraid: simplify internal command handling
      remove a useless get/put_device pair in scsi_requeue_command
      do not manipulate device reference counts in scsi_get/put_command
      avoid taking host_lock in scsi_run_queue unless nessecary
      avoid useless free_list lock roundtrips

Daeseok Youn (1):
      lpfc: use NULL instead of 0 for pointer

Dan Carpenter (3):
      arcmsr: upper 32 of dma address lost
      megaraid: missing bounds check in mimd_to_kioc()
      qla2xxx: fix error handling of qla2x00_mem_alloc()

Dan Williams (2):
      isci: fix needless ata reset escalations
      libsas: introduce scmd_dbg() to quiet false positive "timeout" messages

Eddie Wai (3):
      bnx2fc: Updated version to 2.4.2
      bnx2fc: Fixed the handling for the SCSI retry delay
      bnx2fc: Fixed scsi_remove_target soft lockup when rmmod bnx2x

Eiichi Tsukata (1):
      Add timeout to avoid infinite command retry

Ethan Zhao (1):
      iscsi_boot_sysfs: Fix a memory leak in iscsi_boot_destroy_kset()

Hannes Reinecke (10):
      ses: Use vpd information from scsi_device
      Add EVPD page 0x83 and 0x80 to sysfs
      Return VPD page length in scsi_vpd_inquiry()
      scsi_sysfs: Implement 'is_visible' callback
      megaraid_sas: check return value for megasas_get_pd_list()
      megaraid_sas_fusion: Return correct error value in megasas_get_ld_map_info()
      megaraid_sas_fusion: correctly pass queue info pointer
      bfa: set correct command return code
      hpsa: fixup MSI-X registration
      scsi_error: disable eh_deadline if no host_reset_handler is set

James Bottomley (2):
      dual scan thread bug fix
      fix our current target reap infrastructure

James Smart (16):
      lpfc: remove self-assignments
      lpfc 8.3.45: Update lpfc version to driver version 8.3.45
      lpfc 8.3.45: Fixed crash during driver unload.
      lpfc 8.3.45: Fixed driver error messages after firmware download
      lpfc 8.3.45: Fixed missing initialization for task management IOCBs
      lpfc 8.3.45: Fix sysfs buffer overrun in read of lpfc_fcp_cpu_map for 128 CPUs.
      lpfc 8.3.45: Incorporate changes to use reason in change_queue_depth function.
      lpfc 8.3.45: Incorporated support of a low-latency io path
      lpfc 8.3.45: Added dport mailbox pass through support.
      lpfc 8.3.44: Update lpfc version to driver version 8.3.44
      lpfc 8.3.44: Fixed unassigned variable in ELS timeout message
      lpfc 8.3.44: Fixed incorrect allocation of iDiags directories/files in debugfs
      lpfc 8.3.44: Fix kernel panics from corrupted ndlp list
      lpfc 8.3.44: Fix Crash in lpfc_els_timeout_handler
      lpfc 8.3.44: Fixed stopped FCF discovery on failed FCF record read
      lpfc 8.3.44: Fixed IO hang when in msi mode.

Jayamohan Kallickal (7):
      be2iscsi : Bump the driver version
      be2iscsi : Fix DMA Out of SW-IOMMU space error
      be2iscsi: Fix scsi_cmnd leakage in driver.
      be2iscsi: Fix the session cleanup when reboot/shutdown happens
      be2iscsi: Fix doorbell format for EQ/CQ/RQ s per SLI spec.
      be2iscsi: Fix port speed typo in driver.
      be2iscsi: Fix handling timed out MBX completion from FW

Joe Carnuccio (1):
      qla2xxx: Enable the Flash Access Control (FAC) mailbox command.

Karen Xie (1):
      cxgb4i: Use cxgb4_select_ntuple to correctly calculate ntuple fields

Kees Cook (1):
      esas2r: fix potential format string flaw

Lukasz Dorau (1):
      isci: update version to 1.2

Mahesh Rajashekhara (1):
      aacraid: kdump fix

Martin K. Petersen (1):
      sd: Quiesce mode sense error messages

Matt Gates (3):
      hpsa: add support for 'fastpath' i/o
      hpsa: mark last scatter gather element as the last
      hpsa: use extended report luns command for HP SSD SmartPath

Maurizio Lombardi (1):
      st: fix corruption of the st_modedef structures in st_set_options()

Michael Opdenacker (1):
      remove deprecated IRQF_DISABLED from SCSI

Mike Christie (2):
      iscsi_tcp: check for valid session before accessing
      libiscsi: remove unneeded queue work when max_cmdsn is increased

Mike MIller (1):
      hpsa: get physical device handles for io accel mode 2 as well as mode 1

Mike Miller (1):
      hpsa: add ioaccel mode 2 structure definitions

Nilesh Javali (5):
      qla4xxx: Handle IPv6 AEN notifications
      qla4xxx: Clear DDB index map upon connection close failure
      qla4xxx: Rename ACB_STATE macros with IP_ADDRSTATE macros
      qla4xxx: Improve loopback failure messages
      qla4xxx: ISP8xxx: Correct retry of adapter initialization

Rishi Mehta (1):
      vmw_pvscsi: Add support for I/O requests coalescing.

Saurav Kashyap (8):
      qla2xxx: Correct the port no assignment for ISP82XX.
      qla2xxx: Update the driver version to 8.07.00.02-k.
      qla2xxx: Correctly set the read_optrom pointer for ISP8044.
      qla2xxx: Simplify the ISPFX00 interrupt handler code for ISPFX00.
      qla2xxx: Avoid poisoning in the response queue for ISPFX00.
      qla2xxx: Properly handle 32 bit mailbox register for ISPFX00.
      qla2xxx: Select correct request queue for error type IOCB for ISPFX00.
      qla2xxx: Remove init control block related dead code for ISPFX00.

Scott Teel (12):
      hpsa: add controller base data-at-rest encryption compatibility ioaccel2
      hpsa: update source file copyrights
      hpsa: retry certain ioaccel error cases on the RAID path
      hpsa: rescan devices on ioaccel2 error
      hpsa: allow user to disable accelerated i/o path
      hpsa: complete the ioaccel raidmap code
      hpsa: add task management for ioaccel mode 2
      hpsa: teach hpsa_device_reset to do either target or lun reset
      hpsa: get ioaccel mode 2 i/o working
      hpsa: complain if physical or logical aborts are not supported
      hpsa: add hp_ssd_smart_path_enabled sysfs attribute
      hpsa: fix task management for mode-1 ioaccell path

Shlomo Pongratz (2):
      libiscsi: Reduce locking contention in fast path
      libiscsi: Restructure iscsi_tcp r2t response logic

Stephen M. Cameron (24):
      hpsa: update driver version to 3.4.4-1
      hpsa: fix bad endif placement in RAID 5 mapper code
      hpsa: Do not zero fields of ioaccel2 command structure twice
      hpsa: Add hba mode to the hpsa driver
      hpsa: remove unused struct request from CommandList
      hpsa: bring format-in-progress drives online when ready
      hpsa: remove unused kthread.h header
      hpsa: Add support for a few HP Storage controllers
      hpsa: add HP/3PAR vendor id to pci_ids.h
      hpsa add sysfs debug switch for raid map debugging messages
      hpsa: improve error messages for driver initiated commands
      hpsa: only do device rescan for certain events
      hpsa: when switching out of accel mode await only accel command completions
      hpsa: do not inquire for unsupported ioaccel status vpd page
      hpsa: allow VPD page zero to be queried
      hpsa: make device update copy the raid map also
      hpsa: initialize controller to perform io accelerator mode 2
      hpsa: do ioaccel mode 2 resource allocations
      hpsa: Acknowledge controller events in ioaccell mode 2 as well as mode 1
      hpsa: do not rescan controllers known to be locked up
      hpsa: poll controller to detect device change event
      hpsa: update raid offload status on device rescan
      hpsa: add ioaccell mode 1 RAID offload support.
      hpsa: only allow REQ_TYPE_FS to use fast path

Steven J. Magnani (1):
      qla2xxx: Re-sync module parameter descriptions with the code

Sumit.Saxena@lsi.com (4):
      megaraid_sas: Performance boost fixes
      megaraid_sas: Set 32-bit DMA mask
      megaraid_sas: Big endian code related fixes
      megaraid_sas: Don't wait forever for non-IOCTL DCMDs

Suresh Thiagarajan (1):
      pm80xx: Spinlock fix

Tej Parkash (4):
      qla4xxx: Driver not able to collect minidump for ISP84xx
      qla4xxx: Fix pending IO completion in reset path before initiating chip reset
      qla4xxx: Fix processing response queue during probe
      qla4xxx: Fixed AER reset sequence for ISP83xx/ISP84xx

Tomas Henzl (1):
      hpsa: increase the probability of a reported success after a device reset

Vaughan Cao (1):
      iscsi: fix wrong order of opcode and itt in iscsi_handle_reject prompt

Vijaya Mohan Guvva (1):
      bfa: Fix smatch warnings

Vikas Chaudhary (15):
      qla4xxx: Update driver version to 5.04.00-k4
      qla4xxx: Fix sparse warnings
      qla4xxx: Update print statements in func qla4xxx_do_dpc()
      qla4xxx: Update print statements in func qla4xxx_eh_abort()
      qla4xxx: Update print statements in qla4xxx_mailbox_command()
      qla4xxx: Updated print for device login, logout path
      qla4xxx: Remove unused code from qla4xxx_set_ifcb()
      qla4xxx: Fix failure of mbox 0x31
      qla4xxx: Reduce rom-lock contention during reset recovery.
      qla4xxx: Fix failure of IDC Time Extend mailbox command
      qla4xxx: Return correct error status from func qla4xxx_request_irqs()
      qla4xxx: Correctly handle msleep_interruptible
      qla4xxx: Use IDC_CTRL bit1 directly instead of AF_83XX_NO_FWDUMP flag.
      qla4xxx: Fix comments in code
      qla4xxx: Print WARN_ONCE() if iSCSI function presence bit removed

Viswas G (2):
      pm80xx: Fixed return value issue
      pm80xx: Removing redundant code snippets

Wei Yongjun (1):
      bfa: fix missing unlock on error in bfad_iocmd_cfg_trunk()

Wendy Xiong (4):
      ipr: Add new CCIN definition for Grand Canyon support
      ipr: Format HCAM overlay ID 0x21
      ipr: Add new CCIN definition for new hardware support
      ipr: Remove extended delay bit on GSCSI reads/writes ops

XinHong Zhu (2):
      pm80xx: fix problem of pm8001_work_fn reseting incorrect phy device
      pm80xx: no need for tag allocation when issuing the command of unregistering device

and the diffstat

 Documentation/ABI/testing/sysfs-class-scsi_host |   16 +
 Documentation/scsi/ChangeLog.megaraid_sas       |   13 +
 MAINTAINERS                                     |    4 +-
 drivers/scsi/NCR5380.c                          |    2 +-
 drivers/scsi/aacraid/aacraid.h                  |    2 +-
 drivers/scsi/aacraid/rx.c                       |    9 +-
 drivers/scsi/aacraid/sa.c                       |    3 +-
 drivers/scsi/aacraid/src.c                      |    4 +-
 drivers/scsi/aha152x.c                          |    4 +-
 drivers/scsi/aic7xxx/aicasm/aicasm_insformat.h  |    1 -
 drivers/scsi/arcmsr/arcmsr_hba.c                |    7 +-
 drivers/scsi/arm/acornscsi.c                    |    2 +-
 drivers/scsi/arm/cumana_1.c                     |    2 +-
 drivers/scsi/arm/cumana_2.c                     |    2 +-
 drivers/scsi/arm/powertec.c                     |    2 +-
 drivers/scsi/be2iscsi/be.h                      |   11 +
 drivers/scsi/be2iscsi/be_cmds.c                 |  121 +-
 drivers/scsi/be2iscsi/be_cmds.h                 |   10 +-
 drivers/scsi/be2iscsi/be_iscsi.c                |   13 +-
 drivers/scsi/be2iscsi/be_main.c                 |  105 +-
 drivers/scsi/be2iscsi/be_main.h                 |   23 +-
 drivers/scsi/be2iscsi/be_mgmt.c                 |   22 +-
 drivers/scsi/bfa/bfa_ioc.c                      |   11 +-
 drivers/scsi/bfa/bfad_bsg.c                     |    4 +-
 drivers/scsi/bfa/bfad_im.c                      |    7 +-
 drivers/scsi/bnx2fc/bnx2fc.h                    |    3 +-
 drivers/scsi/bnx2fc/bnx2fc_fcoe.c               |    8 +-
 drivers/scsi/bnx2fc/bnx2fc_io.c                 |   19 +-
 drivers/scsi/bnx2fc/bnx2fc_tgt.c                |    1 +
 drivers/scsi/bnx2i/bnx2i_hwi.c                  |   46 +-
 drivers/scsi/bnx2i/bnx2i_iscsi.c                |    8 +-
 drivers/scsi/cxgbi/cxgb4i/cxgb4i.c              |   59 +-
 drivers/scsi/dtc.c                              |    2 +-
 drivers/scsi/eata.c                             |    2 +-
 drivers/scsi/eata_pio.c                         |    4 +-
 drivers/scsi/esas2r/esas2r_init.c               |    2 +-
 drivers/scsi/esas2r/esas2r_log.c                |    8 +-
 drivers/scsi/g_NCR5380.c                        |    2 +-
 drivers/scsi/gdth.c                             |    6 +-
 drivers/scsi/hosts.c                            |    2 +-
 drivers/scsi/hpsa.c                             | 2686 +++++++++++++++++++++--
 drivers/scsi/hpsa.h                             |  171 +-
 drivers/scsi/hpsa_cmd.h                         |  270 ++-
 drivers/scsi/ibmvscsi/ibmvstgt.c                |    2 +-
 drivers/scsi/in2000.c                           |    2 +-
 drivers/scsi/initio.c                           |    2 +-
 drivers/scsi/ipr.c                              |  367 +++-
 drivers/scsi/ipr.h                              |   22 +
 drivers/scsi/isci/init.c                        |    2 +-
 drivers/scsi/isci/request.c                     |    8 +-
 drivers/scsi/iscsi_boot_sysfs.c                 |    1 +
 drivers/scsi/iscsi_tcp.c                        |   25 +-
 drivers/scsi/libiscsi.c                         |  232 +-
 drivers/scsi/libiscsi_tcp.c                     |   71 +-
 drivers/scsi/libsas/sas_scsi_host.c             |    2 +-
 drivers/scsi/lpfc/lpfc.h                        |   22 +-
 drivers/scsi/lpfc/lpfc_attr.c                   |  628 +++++-
 drivers/scsi/lpfc/lpfc_bsg.c                    |    3 +
 drivers/scsi/lpfc/lpfc_bsg.h                    |    2 +
 drivers/scsi/lpfc/lpfc_crtn.h                   |   24 +-
 drivers/scsi/lpfc/lpfc_debugfs.c                |  108 +
 drivers/scsi/lpfc/lpfc_disc.h                   |    2 +-
 drivers/scsi/lpfc/lpfc_els.c                    |  200 +-
 drivers/scsi/lpfc/lpfc_hbadisc.c                |   39 +-
 drivers/scsi/lpfc/lpfc_hw.h                     |    1 +
 drivers/scsi/lpfc/lpfc_hw4.h                    |    6 +
 drivers/scsi/lpfc/lpfc_init.c                   |  277 ++-
 drivers/scsi/lpfc/lpfc_mem.c                    |   47 +
 drivers/scsi/lpfc/lpfc_nportdisc.c              |   56 +-
 drivers/scsi/lpfc/lpfc_scsi.c                   |  552 ++++-
 drivers/scsi/lpfc/lpfc_scsi.h                   |   18 +
 drivers/scsi/lpfc/lpfc_sli.c                    |  267 ++-
 drivers/scsi/lpfc/lpfc_sli.h                    |    2 +
 drivers/scsi/lpfc/lpfc_sli4.h                   |   21 +-
 drivers/scsi/lpfc/lpfc_version.h                |    2 +-
 drivers/scsi/megaraid.c                         |  120 +-
 drivers/scsi/megaraid.h                         |    3 +-
 drivers/scsi/megaraid/megaraid_mm.c             |    2 +
 drivers/scsi/megaraid/megaraid_sas.h            |  114 +-
 drivers/scsi/megaraid/megaraid_sas_base.c       |  815 +++++--
 drivers/scsi/megaraid/megaraid_sas_fp.c         |   11 +-
 drivers/scsi/megaraid/megaraid_sas_fusion.c     |  272 ++-
 drivers/scsi/megaraid/megaraid_sas_fusion.h     |    3 +
 drivers/scsi/pas16.c                            |    2 +-
 drivers/scsi/pm8001/pm8001_ctl.c                |   38 +-
 drivers/scsi/pm8001/pm8001_hwi.c                |  105 +-
 drivers/scsi/pm8001/pm8001_init.c               |   12 +-
 drivers/scsi/pm8001/pm8001_sas.c                |    3 +-
 drivers/scsi/pm8001/pm8001_sas.h                |   12 +
 drivers/scsi/pm8001/pm80xx_hwi.c                |   97 +-
 drivers/scsi/qla2xxx/Makefile                   |    2 +-
 drivers/scsi/qla2xxx/qla_attr.c                 |  193 +-
 drivers/scsi/qla2xxx/qla_bsg.c                  |   12 +-
 drivers/scsi/qla2xxx/qla_dbg.c                  |  134 +-
 drivers/scsi/qla2xxx/qla_dbg.h                  |    7 +
 drivers/scsi/qla2xxx/qla_def.h                  |   65 +-
 drivers/scsi/qla2xxx/qla_dfs.c                  |    3 +-
 drivers/scsi/qla2xxx/qla_fw.h                   |    4 +
 drivers/scsi/qla2xxx/qla_gbl.h                  |   12 +-
 drivers/scsi/qla2xxx/qla_gs.c                   |   11 +
 drivers/scsi/qla2xxx/qla_init.c                 |  426 +++-
 drivers/scsi/qla2xxx/qla_iocb.c                 |   44 +-
 drivers/scsi/qla2xxx/qla_isr.c                  |   93 +-
 drivers/scsi/qla2xxx/qla_mbx.c                  |   50 +-
 drivers/scsi/qla2xxx/qla_mid.c                  |    4 +-
 drivers/scsi/qla2xxx/qla_mr.c                   |  252 +--
 drivers/scsi/qla2xxx/qla_mr.h                   |   57 +-
 drivers/scsi/qla2xxx/qla_nx.c                   |   21 +-
 drivers/scsi/qla2xxx/qla_nx2.c                  |   22 +-
 drivers/scsi/qla2xxx/qla_os.c                   |  171 +-
 drivers/scsi/qla2xxx/qla_sup.c                  |   65 +-
 drivers/scsi/qla2xxx/qla_tmpl.c                 |  909 ++++++++
 drivers/scsi/qla2xxx/qla_tmpl.h                 |  205 ++
 drivers/scsi/qla2xxx/qla_version.h              |    4 +-
 drivers/scsi/qla4xxx/ql4_83xx.c                 |   36 +-
 drivers/scsi/qla4xxx/ql4_bsg.c                  |    4 +-
 drivers/scsi/qla4xxx/ql4_def.h                  |   17 +-
 drivers/scsi/qla4xxx/ql4_fw.h                   |   31 +-
 drivers/scsi/qla4xxx/ql4_glbl.h                 |    2 +
 drivers/scsi/qla4xxx/ql4_init.c                 |    7 +-
 drivers/scsi/qla4xxx/ql4_isr.c                  |   69 +-
 drivers/scsi/qla4xxx/ql4_mbx.c                  |   25 +-
 drivers/scsi/qla4xxx/ql4_nx.c                   |   89 +-
 drivers/scsi/qla4xxx/ql4_os.c                   |  232 +-
 drivers/scsi/qla4xxx/ql4_version.h              |    2 +-
 drivers/scsi/scsi.c                             |  373 ++--
 drivers/scsi/scsi_debug.c                       |  141 +-
 drivers/scsi/scsi_error.c                       |    6 +
 drivers/scsi/scsi_lib.c                         |  112 +-
 drivers/scsi/scsi_scan.c                        |  115 +-
 drivers/scsi/scsi_sysfs.c                       |  242 +-
 drivers/scsi/scsi_tgt_lib.c                     |    3 +-
 drivers/scsi/scsi_transport_fc.c                |    1 +
 drivers/scsi/sd.c                               |   42 +-
 drivers/scsi/sd.h                               |    6 +
 drivers/scsi/ses.c                              |   38 +-
 drivers/scsi/st.c                               |   11 +-
 drivers/scsi/t128.c                             |    2 +-
 drivers/scsi/u14-34f.c                          |    2 +-
 drivers/scsi/vmw_pvscsi.c                       |  242 +-
 drivers/scsi/vmw_pvscsi.h                       |   19 +-
 drivers/scsi/wd7000.c                           |    2 +-
 include/linux/pci_ids.h                         |    1 +
 include/scsi/libiscsi.h                         |   17 +-
 include/scsi/libiscsi_tcp.h                     |    2 +
 include/scsi/scsi_cmnd.h                        |    6 +-
 include/scsi/scsi_device.h                      |   22 +-
 include/scsi/scsi_host.h                        |    7 +
 include/scsi/scsi_transport_fc.h                |    1 +
 149 files changed, 10318 insertions(+), 2696 deletions(-)
 create mode 100644 drivers/scsi/qla2xxx/qla_tmpl.c
 create mode 100644 drivers/scsi/qla2xxx/qla_tmpl.h


