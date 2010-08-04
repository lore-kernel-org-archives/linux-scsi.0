From: James Bottomley <James.Bottomley@suse.de>
Subject: [GIT PULL] first round of SCSI updates for the 2.6.36 merge window
Date: Wed, 04 Aug 2010 00:13:16 -0400
Message-ID: <1280895197.11045.317.camel@mulgrave.site>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner@vger.kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
To: Andrew Morton <akpm@linux-foundation.org>, Linus Torvalds <torvalds@linux-foundation.org>
Cc: linux-scsi@vger.kernel.org, linux-kernel <linux-kernel@vger.kernel.org>
List-Id: linux-scsi@vger.kernel.org

This is the rather voluminous set of updates we've been accumulating for
the merge window.  Notable highlights are: qla2xxx and mptsas DIF
updates, various usual driver updates the new hpsa driver (replacing
cciss) USB autosuspend for storage and other assorted miscellenia.  We
have a postmerge tree and some unapplied driver updates, so there will
definitely be one or two more SCSI updates in the merge window.

The patch is available from

master.kernel.org:/pub/scm/linux/kernel/git/jejb/scsi-misc-2.6.git

The short changelog is:

Alan Stern (3):
      sd: add support for runtime PM
      implement runtime Power Management
      convert to the new PM framework

Andrew Vasquez (7):
      qla2xxx: Cleanup some dead-code and make some functions static.
      qla2xxx: Stop firmware before doing init firmware.
      qla2xxx: Correct extended sense-data handling.
      qla2xxx: For ISP 23xx, select user specified login timeout value if greater than minuimum value(4 secs).
      qla2xxx: Make the FC port capability mutual exclusive.
      qla2xxx: Correct async-srb issues.
      qla2xxx: Add portid to async-request messages.

Anil Ravindranath (1):
      pmcraid: MSI-X support and other changes

Arun Easi (2):
      qla2xxx: T10 DIF Type 2 support
      qla2xxx: T10 DIF enablement for 81XX

Bandan Das (1):
      mpt fusion: Cleanup some duplicate calls in mptbase.c

Bart Van Assche (1):
      fcoe: make it possible to verify fcoe with sparse

Bhanu Prakash Gollapudi (9):
      libfc: Add retry logic to lport state machine when receiving LS_RJT
      libfcoe: Check for order and missing critical descriptors for FIP ELS requests
      libfcoe: Host doesnt handle CVL to NPIV ports
      libfcoe: Handle duplicate critical descriptors
      libfc: Handle unsolicited PRLO request
      libfc: Honor LS_ACC response codes for PRLI
      libfc: Retry a rejected PRLI request
      libfcoe: No solicitation if adv is dropped
      libfcoe: Avoid hang when receiving non-critical descriptors

Brian King (7):
      ibmvscsi: Driver version 1.5.9
      ibmvscsi: Fix possible request_limit issue
      ibmvscsi: Fix error path deadlock
      ibmvscsi: Fix softlockup on resume
      ibmvfc: Driver version 1.0.8
      ibmvfc: Add support for fc_block_scsi_eh
      ibmvfc: Fix soft lockup on resume

Chad Dupuis (2):
      qla2xxx: Add qla2x00_free_fcports() function
      qla2xxx: Use GFF_ID to check FCP-SCSI FC4 type before logging into Nx_Ports

Christof Schmitt (11):
      zfcp: Trigger logging in the FCP channel on qdio error conditions
      zfcp: Enable data division support for FCP devices
      zfcp: Use correct width for timer_interval field
      zfcp: Remove SCSI device when removing unit
      zfcp: Use memdup_user and kstrdup
      zfcp: Fix retry after failed "open port" erp action
      zfcp: Fail erp after timeout
      zfcp: Use forced_reopen in terminate_rport_io callback
      zfcp: Register SCSI devices after successful fc_remote_port_add
      zfcp: Do not try "forced close" when port is already closed
      zfcp: Do not unblock rport from REOPEN_PORT_FORCED

Cyril Jayaprakash (1):
      pmcraid : Remove unnecessary casts for void * pointers

Dan Carpenter (3):
      dpt_i2o: move range check forward
      be2iscsi: fix null dereference on error path
      be2iscsi: fix memory leak on error path

Duane Grigsby (1):
      qla2xxx: Propogate transport disrupted status for cable pull conditions for faster failover.

Eddie Wai (6):
      bnx2i: Updated version from 2.1.1 to 2.1.2
      bnx2i: Fixed the TCP graceful termination initiation
      bnx2i: Fine tuned conn destroy and context destroy timeout values
      bnx2i: Optimized the bnx2i_stop connection clean up procedure
      bnx2i: Created an active linklist which holds bnx2i endpoints
      bnx2i: Separated the hardware's cleanup procedure from ep_disconnect

Eric Moore (2):
      mpt2sas: driver fails to recover from injected PCIe bus errors
      mpt2sas: DIF Type 2 Protection Support

FUJITA Tomonori (3):
      53c700: remove dma_is_consistent usage
      sg: fix bio leak with a detached device
      scsi_debug: fix map_region and unmap_region oops

Felix Beck (1):
      zfcp: Introduce experimental support for DIF/DIX

Giridhar Malavali (11):
      qla2xxx: Update copyright banner.
      qla2xxx: Rearranged and cleaned up the code for processing the pending commands.
      qla2xxx: Updates for ISP82xx.
      qla2xxx: Removed dependency for SRB structure for Marker processing
      qla2xxx: Updated version number to 8.03.03-k0.
      qla2xxx: Removed redundant check for ISP 84xx.
      qla2xxx: Enable CRB based doorbell posting for request queue as default for ISP 82xx.
      qla2xxx: Limit rport-flaps during link-disruptions.
      qla2xxx: Correct use-after-free oops seen during EH-abort.
      qla2xxx: Fix cpu-affinity usage for non-capable ISPs.
      qla2xxx: Clear drive active CRB register when not in use.

Harish Zunjarrao (3):
      qla2xxx: Do not allow ELS Passthru commands for ISP23xx adapters
      qla2xxx: Add CT passthru support for ISP23xx adapters
      qla2xxx: Support for loading Unified ROM Image (URI) format firmware file.

James Bottomley (3):
      Unify SAM_ and SAM_STAT_ macros
      arcmsr: fix up bin_attr functions
      enclosure: fix error path - actually return ERR_PTR() on error

James Smart (14):
      lpfc 8.3.15: Update driver version 8.3.15
      lpfc 8.3.15: Add target queue depth throttling
      lpfc 8.3.15: FCoE Related Fixes
      lpfc 8.3.15: BSG, Discovery, and Misc fixes
      lpfc 8.3.14: Update Driver version to 8.3.14
      lpfc 8.3.14: SCSI and SLI API fixes
      lpfc 8.3.14: FCoE Discovery Fixes
      lpfc 8.3.14: PCI fixes and enhancements
      lpfc 8.3.13: Update Driver Version to 8.3.13
      lpfc 8.3.13: Add TX Queue Support for SLI4 ELS commands.
      lpfc 8.3.13: Misc fixes
      lpfc 8.3.13: SCSI specific changes
      lpfc 8.3.13: Initialization code clean up and fixes.
      lpfc 8.3.13: FC Discovery Fixes and enhancements.

Jayamohan Kallickal (14):
      be2iscsi: The extended shift must be 16
      be2iscsi: Fix for premature buffer free
      be2iscsi: Remove debug print in IO path
      be2iscsi: Limit max_xmit_length
      be2iscsi: Maintain same ITT across login
      be2iscsi: Adding crashdump support
      be2iscsi: Free tags allocated
      be2iscsi: Fix to handle request_irq failure
      be2iscsi: No return value for hwi_enable_intr
      be2iscsi: Fix for freeing cid
      be2iscsi: pass the return from beiscsi_open_conn
      be2iscsi: Fixing the return type of functions
      be2iscsi: Fixing return values
      be2iscsi: Fix warnings from new checkpatch.pl

Jing Huang (24):
      bfa: add debugfs support
      bfa: update driver version string
      bfa: vport fixes
      bfa: fix wrong arg to callback
      bfa: add ioc state checking
      bfa: add description for module parameters
      bfa: update to support BOFM
      bfa: fix possible IO double completion
      bfa: fix link state structure
      bfa: add dynamic queue selection
      bfa: fix uf post and rport fcpim state machine
      bfa: fix chip and memory initialization
      bfa: update to support firmware configuation
      bfa: add PBC port disable handling
      bfa: fix prli retry issues
      bfa: fix rport speed setting
      bfa: fix interrupt coalescing setting
      bfa: use standards defined timeout for ELS/CT
      bfa: statistics and typo fix
      bfa: ioc attributes fix
      bfa: vport state machine fix
      bfa: PBC vport create
      bfa: enable basic PBC support
      bfa: enable new hardware

Jiri Slaby (1):
      mvsas: fix potential NULL dereference

Joe Eykholt (26):
      libfc: don't require a local exchange for incoming requests
      libfc: add interface to allocate a sequence for incoming requests
      libfc: add fc_fill_reply_hdr() and fc_fill_hdr()
      libfc: add fc_frame_sid() and fc_frame_did() functions
      libfc: eliminate rport LOGO state
      fcoe: config via separate create_vn2vn module parameter
      fcoe libfcoe: use correct FC-MAP for VN2VN mode
      libfcoe: Fix FIP ELS encapsulation details for FLOGI responses
      libfcoe: fcoe: fnic: add FIP VN2VN point-to-multipoint support
      libfcoe: add state change debugging
      libfcoe: add protocol description of FIP VN2VN mode
      libfc: track FIP exchanges
      libfc: add FLOGI state to rport for VN2VN
      libfc: Add local port point-to-multipoint flag
      libfcoe: fcoe: fnic: change fcoe_ctlr_init interface to specify mode
      libfc: add discovery-private pointer for LLD
      libfcoe: convert FIP to lock with mutex instead of spin lock
      libfc: provide space for LLD after remote port structure
      libfc: convert rport lookup to be RCU safe
      libfc: fix indefinite rport restart
      libfc: Fix remote port restart problem
      libfcoe: update FIP FCF D flag from advertisments
      libfcoe: Use fka_period as periodic timeouts to age out fcf if
      libfcoe: fix lenient aging of FCF advertisements
      fcoe: clean up TBD comments in FCoE prototype header
      libfcoe: FIP link keep-alive should continue while logged off

Julia Lawall (2):
      dpt_i2o: Use GFP_ATOMIC when a lock is held
      hptiop: Eliminate a NULL pointer dereference

Justin P. Mattock (1):
      scsi:hosts.c Fix warning: variable 'rval' set but not used

Karen Higgins (1):
      qla4xxx: wait for device_ready before device discovery

Karen Xie (1):
      cxgb3i: zero out reserved or un-used fields.

Kashyap, Desai (28):
      mptfusion: Bump version 03.04.17
      mptfusion: Extra debug prints added relavent to Device missing delay error handling
      mptfusion: Block Error handling for deleting devices or Device in DMD
      mptfusion: Bump version 03.04.16
      mptfusion: Added missing reset for ioc_reset_in_progress in SoftReset
      mptfusion: Added code for occationally SATA hotplug failure.
      mptfusion: schedule_target_reset from all Reset context
      mptfusion: Added sanity to check B_T mapping for device before adding to OS
      mptfusion: Corrected declaration of device_missing_delay
      mptfusion: Use DID_TRANSPORT_DISRUPTED instead of DID_BUS_BUSY
      mptfusion: Set fw_events_off to 1 at driver load time.
      mpt2sas: Bump version 06.100.00.00
      mpt2sas: Copy message frame before releasing to free pool to have a local reference.
      mpt2sas: Copy sense buffer instead of working on direct memory location
      mpt2sas: Adding additional message to error escalation callback
      mpt2sas: Add additional check for responding volumes after Host Reset
      mpt2sas: Added -ENOMEM return type when allocation fails
      mpt2sas: Redesign Raid devices event handling using pd_handles per HBA
      mpt2sas: Tie a log info message to a specific PHY.
      mpt2sas: print level KERN_DEBUG is replaced by KERN_INFO
      mpt2sas: Added sysfs support for trace buffer
      mpt2sas: MPI header version N is updated.
      mpt2sas: Added sysfs counter for ioc reset
      mpt2sas: Added expander phy control support
      mpt2sas: Added expander phy counter support
      mpt2sas: staged device discovery. disable_discovery module parameter is added.
      mpt2sas: Hold Controller reset when another reset is in progress
      mpt2sas: Fix to use sas device list instead of enclosure list for _transpor_get_enclosure_identifier.

Kei Tokunaga (2):
      mptfusion: print Doorbell register in a case of hard reset and timeout
      mptsas: fixed hot-removal processing

Lalit Chandivade (2):
      qla2xxx: Fix flash write failure on ISP82xx.
      qla2xxx: Do not enable VP in non fabric topology.

Madhuranath Iyengar (4):
      qla2xxx: Don't issue set or get port param MBC if remote port is not logged in
      qla2xxx: Check for golden firmware and show version if available
      qla2xxx: Appropriately log FCP priority data messages
      qla2xxx: Don't issue set or get port param MBC if invalid port loop id

Michael Chan (1):
      bnx2i: Added host param ISCSI_HOST_PARAM_IPADDRESS

Mike Christie (3):
      iscsi_transport: wait on session in error handler path
      Log msg when getting Unit Attention
      be2iscsi: fix disconnection cleanup

Nick Cheng (2):
      SCSI: Support Type C RAID controller
      arcmsr: Support 1024 scatter-gather list entries and improve AP while FW trapped and behaviors of EHs

Pekka Enberg (1):
      aic7xxx: Remove OS utility wrappers

Peter Huewe (1):
      ibmvstgt: add __init/__exit macros

Prasanna Mumbai (1):
      qla4xxx: Fix the freeing of the buffer allocated for DMA

Randy Dunlap (1):
      scsi: add Kconfig dependency on NET

Ravi Anand (1):
      qla4xxx: Handle one H/W Interrupt at a time

Roel Kluin (1):
      fnic: fnic_scsi.c: clean up

Rolf Eike Beer (1):
      aacraid: Do not set DMA mask to 32 bit first if adapter only supports 31

Ryan Kuester (1):
      mptsas: fix hangs caused by ATA pass-through

Santosh Vernekar (1):
      qla2xxx: Handle outstanding mbx cmds on hung f/w scenarios.

Sarang Radke (1):
      qla2xxx: Add internal loopback support for ISP81xx.

Stephen M. Cameron (33):
      hpsa: sanitize max commands
      hpsa: separate intx and msi/msix interrupt handlers
      hpsa: forbid hard reset of 640x boards
      hpsa: Fix hard reset code.
      hpsa: factor out the code to reset controllers on driver load
      hpsa: factor out hpsa_find_cfg_addrs.
      hpsa: make hpsa_find_memory_BAR not require the per HBA structure.
      hpsa: Make "hpsa_allow_any=1" boot param enable Compaq Smart Arrays.
      hpsa: add new controllers
      hpsa: add entry to MAINTAINERS
      hpsa: fix block fetch table problem.
      hpsa: expose controller firmware revision via /sys.
      hpsa: Add hpsa.txt to Documentation/scsi
      hpsa: remove unused firm_ver member of the per-hba structure
      hpsa: factor out hpsa_enter_performant_mode
      hpsa: remove unused variable trans_offset
      hpsa: factor out hpsa_wait_for_mode_change_ack
      hpsa: mark hpsa_mark_hpsa_put_ctlr_into_performant_mode as __devinit
      hpsa: clean up debug ifdefs
      hpsa: check that simple mode is supported
      hpsa: factor out hpsa_enter_simple_mode
      hpsa: factor out hpsa_p600_dma_prefetch_quirk
      hpsa: factor out hpsa_enable_scsi_prefetch
      hpsa: factor out hpsa-CISS-signature-present
      hpsa: hpsa factor out hpsa_find_board_params
      hpsa: fix leak of ioremapped memory in hpsa_pci_init error path.
      hpsa: factor out hpsa_find_cfgtables
      hpsa: factor out hpsa_wait_for_board_ready
      hpsa: factor out hpsa_find_memory_BAR
      hpsa: remove redundant board_id parameter from hpsa_interrupt_mode
      hpsa: factor out hpsa_board_disabled
      hpsa: factor out hpsa_lookup_board_id
      hpsa: save pdev pointer in per hba structure early to avoid passing it around so much.

Sven Schuetz (1):
      zfcp: Post events through FC transport class

Swen Schillig (3):
      zfcp: Prevent access on uninitialized memory.
      zfcp: Cleanup QDIO attachment and improve processing.
      zfcp: Cleanup function parameters for sbal value.

Tomas Henzl (1):
      mptfusion: release resources in error return path

Vasu Dev (5):
      fcoe: remove check for zero fabric name
      Revert "[SCSI] fcoe: Fix using VLAN ID in creating lport's WWWN/WWPN"
      fcoe: adds src and dest mac address checking for fcoe frames
      fcoe: cleans up fcoe_disable and fcoe_enable
      libfc: IO errors on link down due to cable unplug

Vikas Chaudhary (8):
      iscsi_transport: Modidify recovery_tmo from sysfs
      qla4xxx: Update driver version to 5.02.00-k2
      iscsi_transport: added new iscsi_param to display target alias in sysfs
      qla4xxx: replace all dev_info, dev_warn, dev_err with ql4_printk
      qla4xxx: Added support for ISP82XX
      qla4xxx: correct return status in function qla4xxx_fw_ready
      qla4xxx: unblock iscsi session after setting ddb state online.
      qla4xxx: set driver ddb state correctly in process_ddb_changed

Wayne Boyer (8):
      ipr: fix resource type update and add sdev and shost attributes
      ipr: fix transition to operational for new adapters
      ipr: change endian swap key to match hardware spec change
      ipr: add support for new Obsidian-E embedded adapter
      ipr: add MMIO write to perform BIST for 64 bit adapters
      ipr: move setting of the allow_restart flag for vsets and disks
      ipr: add writeq definition if needed
      ipr: add endian swap enablement for 64 bit adapters

Yanqing_Liu@Dell.com (1):
      scsi_dh_rdac: Add Dell MD36xxi controller into RDAC device list

Yi Zou (3):
      fcoe: fix offload feature flag change from netdev
      libfc: fix slowpath error from WARN_ON in fc_fcp_send_data
      libfc: lport state is enum not bit mask

and the diffstat:

 Documentation/scsi/hpsa.txt                      |  107 +
 MAINTAINERS                                      |    8 
 arch/s390/include/asm/qdio.h                     |    6 
 drivers/message/fusion/mptbase.c                 |   49 
 drivers/message/fusion/mptbase.h                 |   13 
 drivers/message/fusion/mptctl.c                  |   38 
 drivers/message/fusion/mptfc.c                   |    9 
 drivers/message/fusion/mptlan.c                  |    4 
 drivers/message/fusion/mptsas.c                  |  278 ++
 drivers/message/fusion/mptsas.h                  |    1 
 drivers/message/fusion/mptscsih.c                |   54 
 drivers/message/fusion/mptspi.c                  |    9 
 drivers/misc/enclosure.c                         |    7 
 drivers/s390/cio/qdio_setup.c                    |    2 
 drivers/s390/scsi/zfcp_aux.c                     |   10 
 drivers/s390/scsi/zfcp_cfdc.c                    |   12 
 drivers/s390/scsi/zfcp_dbf.c                     |    5 
 drivers/s390/scsi/zfcp_dbf.h                     |    1 
 drivers/s390/scsi/zfcp_def.h                     |    5 
 drivers/s390/scsi/zfcp_erp.c                     |   24 
 drivers/s390/scsi/zfcp_ext.h                     |   11 
 drivers/s390/scsi/zfcp_fc.c                      |   54 
 drivers/s390/scsi/zfcp_fc.h                      |   27 
 drivers/s390/scsi/zfcp_fsf.c                     |  169 +
 drivers/s390/scsi/zfcp_fsf.h                     |   34 
 drivers/s390/scsi/zfcp_qdio.c                    |  206 --
 drivers/s390/scsi/zfcp_qdio.h                    |   95 
 drivers/s390/scsi/zfcp_scsi.c                    |  103 -
 drivers/s390/scsi/zfcp_sysfs.c                   |   12 
 drivers/scsi/Kconfig                             |    4 
 drivers/scsi/Makefile                            |    1 
 drivers/scsi/aacraid/linit.c                     |   14 
 drivers/scsi/aic7xxx/aic7770.c                   |   12 
 drivers/scsi/aic7xxx/aic7770_osm.c               |    2 
 drivers/scsi/aic7xxx/aic79xx_core.c              |  624 +++---
 drivers/scsi/aic7xxx/aic79xx_osm.c               |  108 -
 drivers/scsi/aic7xxx/aic79xx_osm.h               |    7 
 drivers/scsi/aic7xxx/aic79xx_osm_pci.c           |    8 
 drivers/scsi/aic7xxx/aic79xx_pci.c               |   56 
 drivers/scsi/aic7xxx/aic79xx_proc.c              |   13 
 drivers/scsi/aic7xxx/aic7xxx_93cx6.c             |   10 
 drivers/scsi/aic7xxx/aic7xxx_core.c              |  430 ++--
 drivers/scsi/aic7xxx/aic7xxx_osm.c               |   76 
 drivers/scsi/aic7xxx/aic7xxx_osm.h               |    7 
 drivers/scsi/aic7xxx/aic7xxx_osm_pci.c           |    8 
 drivers/scsi/aic7xxx/aic7xxx_pci.c               |   74 
 drivers/scsi/aic7xxx/aic7xxx_proc.c              |   15 
 drivers/scsi/aic94xx/aic94xx_task.c              |    2 
 drivers/scsi/arcmsr/arcmsr.h                     |  315 ++-
 drivers/scsi/arcmsr/arcmsr_hba.c                 | 2309 +++++++++++++---------
 drivers/scsi/be2iscsi/Kconfig                    |    2 
 drivers/scsi/be2iscsi/be.h                       |    6 
 drivers/scsi/be2iscsi/be_cmds.c                  |  116 -
 drivers/scsi/be2iscsi/be_cmds.h                  |   27 
 drivers/scsi/be2iscsi/be_iscsi.c                 |  199 +
 drivers/scsi/be2iscsi/be_iscsi.h                 |    2 
 drivers/scsi/be2iscsi/be_main.c                  |  333 ++-
 drivers/scsi/be2iscsi/be_main.h                  |   29 
 drivers/scsi/be2iscsi/be_mgmt.c                  |   64 
 drivers/scsi/be2iscsi/be_mgmt.h                  |   19 
 drivers/scsi/bfa/Makefile                        |    2 
 drivers/scsi/bfa/bfa_cb_ioim_macros.h            |    7 
 drivers/scsi/bfa/bfa_core.c                      |    1 
 drivers/scsi/bfa/bfa_fcpim.c                     |   29 
 drivers/scsi/bfa/bfa_fcpim_priv.h                |    6 
 drivers/scsi/bfa/bfa_fcport.c                    |  139 +
 drivers/scsi/bfa/bfa_fcs.c                       |   10 
 drivers/scsi/bfa/bfa_fcs_lport.c                 |    3 
 drivers/scsi/bfa/bfa_fcxp.c                      |   14 
 drivers/scsi/bfa/bfa_fwimg_priv.h                |   25 
 drivers/scsi/bfa/bfa_hw_cb.c                     |    7 
 drivers/scsi/bfa/bfa_hw_ct.c                     |    7 
 drivers/scsi/bfa/bfa_intr.c                      |    1 
 drivers/scsi/bfa/bfa_ioc.c                       |  172 -
 drivers/scsi/bfa/bfa_ioc.h                       |   12 
 drivers/scsi/bfa/bfa_ioc_cb.c                    |   36 
 drivers/scsi/bfa/bfa_ioc_ct.c                    |   71 
 drivers/scsi/bfa/bfa_iocfc.c                     |  107 -
 drivers/scsi/bfa/bfa_iocfc.h                     |   19 
 drivers/scsi/bfa/bfa_ioim.c                      |   63 
 drivers/scsi/bfa/bfa_log_module.c                |   86 
 drivers/scsi/bfa/bfa_lps.c                       |    6 
 drivers/scsi/bfa/bfa_port.c                      |   31 
 drivers/scsi/bfa/bfa_port_priv.h                 |    7 
 drivers/scsi/bfa/bfa_priv.h                      |    3 
 drivers/scsi/bfa/bfa_rport.c                     |    5 
 drivers/scsi/bfa/bfa_sgpg.c                      |    5 
 drivers/scsi/bfa/bfa_uf.c                        |   10 
 drivers/scsi/bfa/bfad.c                          |  114 +
 drivers/scsi/bfa/bfad_attr.c                     |   46 
 drivers/scsi/bfa/bfad_debugfs.c                  |  547 +++++
 drivers/scsi/bfa/bfad_drv.h                      |   36 
 drivers/scsi/bfa/bfad_fwimg.c                    |   76 
 drivers/scsi/bfa/bfad_im.c                       |   33 
 drivers/scsi/bfa/bfad_im_compat.h                |   13 
 drivers/scsi/bfa/bfad_intr.c                     |    8 
 drivers/scsi/bfa/fabric.c                        |   44 
 drivers/scsi/bfa/fcpim.c                         |   32 
 drivers/scsi/bfa/fcs_fabric.h                    |    5 
 drivers/scsi/bfa/fcs_rport.h                     |    3 
 drivers/scsi/bfa/fcs_vport.h                     |    1 
 drivers/scsi/bfa/fdmi.c                          |    6 
 drivers/scsi/bfa/include/aen/bfa_aen_ioc.h       |    8 
 drivers/scsi/bfa/include/bfa.h                   |    4 
 drivers/scsi/bfa/include/bfa_fcpim.h             |   20 
 drivers/scsi/bfa/include/bfa_svc.h               |    1 
 drivers/scsi/bfa/include/bfi/bfi_ctreg.h         |    3 
 drivers/scsi/bfa/include/bfi/bfi_ioc.h           |   20 
 drivers/scsi/bfa/include/bfi/bfi_iocfc.h         |    2 
 drivers/scsi/bfa/include/bfi/bfi_pbc.h           |   62 
 drivers/scsi/bfa/include/cna/port/bfa_port.h     |    1 
 drivers/scsi/bfa/include/cs/bfa_debug.h          |    3 
 drivers/scsi/bfa/include/defs/bfa_defs_adapter.h |    3 
 drivers/scsi/bfa/include/defs/bfa_defs_auth.h    |    6 
 drivers/scsi/bfa/include/defs/bfa_defs_boot.h    |   10 
 drivers/scsi/bfa/include/defs/bfa_defs_driver.h  |    2 
 drivers/scsi/bfa/include/defs/bfa_defs_fcport.h  |   26 
 drivers/scsi/bfa/include/defs/bfa_defs_ioc.h     |    7 
 drivers/scsi/bfa/include/defs/bfa_defs_iocfc.h   |   12 
 drivers/scsi/bfa/include/defs/bfa_defs_itnim.h   |   10 
 drivers/scsi/bfa/include/defs/bfa_defs_mfg.h     |   41 
 drivers/scsi/bfa/include/defs/bfa_defs_pci.h     |   11 
 drivers/scsi/bfa/include/defs/bfa_defs_port.h    |   14 
 drivers/scsi/bfa/include/defs/bfa_defs_pport.h   |   29 
 drivers/scsi/bfa/include/defs/bfa_defs_status.h  |   46 
 drivers/scsi/bfa/include/fcb/bfa_fcb_vport.h     |    3 
 drivers/scsi/bfa/include/fcs/bfa_fcs.h           |    4 
 drivers/scsi/bfa/include/fcs/bfa_fcs_fcpim.h     |    1 
 drivers/scsi/bfa/include/fcs/bfa_fcs_rport.h     |    1 
 drivers/scsi/bfa/include/fcs/bfa_fcs_vport.h     |    4 
 drivers/scsi/bfa/include/log/bfa_log_linux.h     |    6 
 drivers/scsi/bfa/include/protocol/fc.h           |    1 
 drivers/scsi/bfa/lport_api.c                     |   30 
 drivers/scsi/bfa/ms.c                            |    9 
 drivers/scsi/bfa/ns.c                            |   14 
 drivers/scsi/bfa/rport.c                         |   88 
 drivers/scsi/bfa/rport_api.c                     |   11 
 drivers/scsi/bfa/rport_ftrs.c                    |   14 
 drivers/scsi/bfa/scn.c                           |    2 
 drivers/scsi/bfa/vport.c                         |   54 
 drivers/scsi/bnx2i/bnx2i.h                       |   14 
 drivers/scsi/bnx2i/bnx2i_hwi.c                   |    4 
 drivers/scsi/bnx2i/bnx2i_init.c                  |   37 
 drivers/scsi/bnx2i/bnx2i_iscsi.c                 |  236 +-
 drivers/scsi/cxgb3i/cxgb3i_ddp.c                 |    2 
 drivers/scsi/cxgb3i/cxgb3i_offload.c             |    5 
 drivers/scsi/device_handler/scsi_dh_rdac.c       |    1 
 drivers/scsi/dpt_i2o.c                           |   26 
 drivers/scsi/fcoe/fcoe.c                         |  147 -
 drivers/scsi/fcoe/libfcoe.c                      | 1519 +++++++++++++--
 drivers/scsi/fnic/fnic_main.c                    |   11 
 drivers/scsi/fnic/fnic_scsi.c                    |   22 
 drivers/scsi/hosts.c                             |   14 
 drivers/scsi/hpsa.c                              |  754 +++++--
 drivers/scsi/hpsa.h                              |    1 
 drivers/scsi/hpsa_cmd.h                          |    4 
 drivers/scsi/hptiop.c                            |    2 
 drivers/scsi/ibmvscsi/ibmvfc.c                   |   85 
 drivers/scsi/ibmvscsi/ibmvfc.h                   |    6 
 drivers/scsi/ibmvscsi/ibmvscsi.c                 |  157 +
 drivers/scsi/ibmvscsi/ibmvscsi.h                 |    4 
 drivers/scsi/ibmvscsi/ibmvstgt.c                 |    4 
 drivers/scsi/ibmvscsi/rpa_vscsi.c                |   16 
 drivers/scsi/ipr.c                               |  148 +
 drivers/scsi/ipr.h                               |   30 
 drivers/scsi/libfc/fc_disc.c                     |   39 
 drivers/scsi/libfc/fc_elsct.c                    |    2 
 drivers/scsi/libfc/fc_exch.c                     |  215 +-
 drivers/scsi/libfc/fc_fcp.c                      |   15 
 drivers/scsi/libfc/fc_libfc.c                    |   78 
 drivers/scsi/libfc/fc_libfc.h                    |    2 
 drivers/scsi/libfc/fc_lport.c                    |  210 --
 drivers/scsi/libfc/fc_rport.c                    |  707 ++++---
 drivers/scsi/libsas/sas_ata.c                    |   12 
 drivers/scsi/libsas/sas_expander.c               |    2 
 drivers/scsi/libsas/sas_scsi_host.c              |    4 
 drivers/scsi/libsas/sas_task.c                   |    6 
 drivers/scsi/lpfc/lpfc.h                         |   17 
 drivers/scsi/lpfc/lpfc_attr.c                    |   96 
 drivers/scsi/lpfc/lpfc_bsg.c                     |   36 
 drivers/scsi/lpfc/lpfc_crtn.h                    |   11 
 drivers/scsi/lpfc/lpfc_disc.h                    |    2 
 drivers/scsi/lpfc/lpfc_els.c                     |  112 -
 drivers/scsi/lpfc/lpfc_hbadisc.c                 |  220 +-
 drivers/scsi/lpfc/lpfc_hw.h                      |   17 
 drivers/scsi/lpfc/lpfc_init.c                    |  279 ++
 drivers/scsi/lpfc/lpfc_mbox.c                    |   23 
 drivers/scsi/lpfc/lpfc_nportdisc.c               |   31 
 drivers/scsi/lpfc/lpfc_scsi.c                    |   86 
 drivers/scsi/lpfc/lpfc_sli.c                     |  345 ++-
 drivers/scsi/lpfc/lpfc_sli.h                     |    2 
 drivers/scsi/lpfc/lpfc_sli4.h                    |    8 
 drivers/scsi/lpfc/lpfc_version.h                 |    2 
 drivers/scsi/lpfc/lpfc_vport.c                   |    2 
 drivers/scsi/mpt2sas/mpi/mpi2.h                  |   17 
 drivers/scsi/mpt2sas/mpi/mpi2_cnfg.h             |  193 +
 drivers/scsi/mpt2sas/mpi/mpi2_init.h             |   17 
 drivers/scsi/mpt2sas/mpi/mpi2_ioc.h              |  119 +
 drivers/scsi/mpt2sas/mpt2sas_base.c              |  172 +
 drivers/scsi/mpt2sas/mpt2sas_base.h              |   34 
 drivers/scsi/mpt2sas/mpt2sas_config.c            |    6 
 drivers/scsi/mpt2sas/mpt2sas_ctl.c               |  411 +++-
 drivers/scsi/mpt2sas/mpt2sas_scsih.c             |  744 +++++--
 drivers/scsi/mpt2sas/mpt2sas_transport.c         |  575 +++++
 drivers/scsi/mvsas/mv_sas.c                      |   20 
 drivers/scsi/pm8001/pm8001_hwi.c                 |   14 
 drivers/scsi/pm8001/pm8001_sas.c                 |    4 
 drivers/scsi/pmcraid.c                           |  893 ++++++--
 drivers/scsi/pmcraid.h                           |  305 +--
 drivers/scsi/qla2xxx/qla_attr.c                  |   33 
 drivers/scsi/qla2xxx/qla_bsg.c                   |  294 ++
 drivers/scsi/qla2xxx/qla_bsg.h                   |    9 
 drivers/scsi/qla2xxx/qla_dbg.c                   |    2 
 drivers/scsi/qla2xxx/qla_dbg.h                   |    2 
 drivers/scsi/qla2xxx/qla_def.h                   |   54 
 drivers/scsi/qla2xxx/qla_dfs.c                   |    2 
 drivers/scsi/qla2xxx/qla_fw.h                    |    2 
 drivers/scsi/qla2xxx/qla_gbl.h                   |   29 
 drivers/scsi/qla2xxx/qla_gs.c                    |   74 
 drivers/scsi/qla2xxx/qla_init.c                  |  178 -
 drivers/scsi/qla2xxx/qla_inline.h                |    2 
 drivers/scsi/qla2xxx/qla_iocb.c                  |  257 +-
 drivers/scsi/qla2xxx/qla_isr.c                   |  206 +-
 drivers/scsi/qla2xxx/qla_mbx.c                   |  158 +
 drivers/scsi/qla2xxx/qla_mid.c                   |   61 
 drivers/scsi/qla2xxx/qla_nx.c                    |  550 ++---
 drivers/scsi/qla2xxx/qla_nx.h                    |   43 
 drivers/scsi/qla2xxx/qla_os.c                    |  109 -
 drivers/scsi/qla2xxx/qla_settings.h              |    2 
 drivers/scsi/qla2xxx/qla_sup.c                   |   49 
 drivers/scsi/qla2xxx/qla_version.h               |    8 
 drivers/scsi/qla4xxx/Kconfig                     |    8 
 drivers/scsi/qla4xxx/Makefile                    |    2 
 drivers/scsi/qla4xxx/ql4_def.h                   |  143 +
 drivers/scsi/qla4xxx/ql4_fw.h                    |  139 +
 drivers/scsi/qla4xxx/ql4_glbl.h                  |  106 -
 drivers/scsi/qla4xxx/ql4_init.c                  |  240 +-
 drivers/scsi/qla4xxx/ql4_inline.h                |    2 
 drivers/scsi/qla4xxx/ql4_iocb.c                  |   73 
 drivers/scsi/qla4xxx/ql4_isr.c                   |  396 +++
 drivers/scsi/qla4xxx/ql4_mbx.c                   |  191 +
 drivers/scsi/qla4xxx/ql4_nvram.c                 |    2 
 drivers/scsi/qla4xxx/ql4_nvram.h                 |   10 
 drivers/scsi/qla4xxx/ql4_nx.c                    | 2321 +++++++++++++++++++++++
 drivers/scsi/qla4xxx/ql4_nx.h                    |  779 +++++++
 drivers/scsi/qla4xxx/ql4_os.c                    |  758 +++++--
 drivers/scsi/qla4xxx/ql4_version.h               |    2 
 drivers/scsi/scsi_debug.c                        |    6 
 drivers/scsi/scsi_error.c                        |   29 
 drivers/scsi/scsi_pm.c                           |  206 ++
 drivers/scsi/scsi_priv.h                         |   19 
 drivers/scsi/scsi_scan.c                         |   24 
 drivers/scsi/scsi_sysfs.c                        |   68 
 drivers/scsi/scsi_transport_iscsi.c              |   81 
 drivers/scsi/sd.c                                |   21 
 drivers/scsi/sg.c                                |   12 
 include/scsi/fc/fc_els.h                         |   11 
 include/scsi/fc/fc_fcoe.h                        |   15 
 include/scsi/fc/fc_fip.h                         |   46 
 include/scsi/fc/fc_ns.h                          |    7 
 include/scsi/fc_encode.h                         |    7 
 include/scsi/fc_frame.h                          |   52 
 include/scsi/iscsi_if.h                          |    2 
 include/scsi/libfc.h                             |   75 
 include/scsi/libfcoe.h                           |   72 
 include/scsi/libsas.h                            |   11 
 include/scsi/scsi_device.h                       |    8 
 include/scsi/scsi_transport_iscsi.h              |    2 
 268 files changed, 19599 insertions(+), 6501 deletions(-)

James
