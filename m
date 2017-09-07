From: James Bottomley <James.Bottomley@HansenPartnership.com>
Subject: [GIT PULL] first round of SCSI updates for the 4.13+ merge window
Date: Thu, 07 Sep 2017 14:58:27 -0700
Message-ID: <1504821507.3053.69.camel@HansenPartnership.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8bit
Return-path: <linux-kernel-owner@vger.kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
To: Andrew Morton <akpm@linux-foundation.org>, Linus Torvalds <torvalds@linux-foundation.org>
Cc: linux-scsi <linux-scsi@vger.kernel.org>, linux-kernel <linux-kernel@vger.kernel.org>
List-Id: linux-scsi@vger.kernel.org

This is mostly updates of the usual suspects: lpfc, qla2xxx, hisi_sas,
megaraid_sas, zfcp and a host of minor updates.

The major driver change here is the elimination of the block based
cciss driver in favour of the SCSI based hpsa driver (which now drives
all the legacy cases cciss used to be required for).  Plus a reset
handler clean up and the redo of the SAS SMP handler to use bsg lib.

Note there's a conflict with this and some of the staging updates for
the vishorba driver which are fairly trivial to resolve.

The patch is available here:

git://git.kernel.org/pub/scm/linux/kernel/git/jejb/scsi.git scsi-misc

The short changelog is:

Arnd Bergmann (8):
      scsi: lpfc: avoid false-positive gcc-8 warning
      scsi: lpfc: avoid an unused function warning
      scsi: fusion: fix string overflow warning
      scsi: gdth: increase the procfs event buffer size
      scsi: fnic: fix format string overflow warning
      scsi: gdth: avoid buffer overflow warning
      scsi: mpt3sas: fix format overflow warning
      scsi: megaraid: fix format-overflow warning

Arvind Yadav (4):
      scsi: ibmvfc: ibmvscsi: ibmvscsi_tgt: constify vio_device_id
      scsi: aha1542: constify pnp_device_id
      scsi: ncr5380: constify pnp_device_id
      scsi: esas2r: constify pci_device_id.

Bart Van Assche (24):
      scsi: scsi-mq: Always unprepare before requeuing a request
      scsi: Show .retries and .jiffies_at_alloc in debugfs
      scsi: Improve requeuing behavior
      scsi: Call scsi_initialize_rq() for filesystem requests
      scsi: Rework handling of scsi_device.vpd_pg8[03]
      scsi: Rework the code for caching Vital Product Data (VPD)
      scsi: rcu: Introduce rcu_swap_protected()
      scsi: iscsi_tcp: Remove a set-but-not-used variable
      scsi: scsi_debug: Remove a set-but-not-used variable
      scsi: scsi_transport_srp: Suppress a W=1 compiler warning
      scsi: scsi_transport_sas: Check kzalloc() return value
      scsi: libsas: Annotate fall-through in a switch statement
      scsi: libsas: Remove a set-but-not-used variable
      scsi: libiscsi: Fix indentation
      scsi: sg: Fix type of last blk_trace_setup() argument
      scsi: sd: Remove a useless comparison
      scsi: sd: Fix indentation
      scsi: sd: sr: Convert two assignments into warning statements
      scsi: Use blk_mq_rq_to_pdu() to convert a request to a SCSI command pointer
      scsi: Document which queue type a function is intended for
      scsi: Convert a strncmp() call into a strcmp() call
      scsi: Suppress gcc 7 fall-through warnings reported with W=1
      scsi: Avoid sign extension of scsi_device.type
      scsi: Remove an obsolete function declaration

Benjamin Block (3):
      scsi: zfcp: add handling for FCP_RESID_OVER to the fcp ingress path
      scsi: zfcp: convert bool-definitions to use 'true' instead of '1'
      MAINTAINERS: Add myself to S390 ZFCP DRIVER as a co-maintainer

Bhumika Goyal (2):
      scsi: make device_type const
      arcmsr: add const to bin_attribute structures

Bodo Stroesser (1):
      scsi: st: fix blk_get_queue usage

Brian King (4):
      scsi: aacraid: Fix command send race condition
      scsi: ipr: Set no_report_opcodes for RAID arrays
      scsi: ses: Fix wrong page error
      scsi: ipr: Fix scsi-mq lockdep issue

Calvin Owens (1):
      scsi: ses: Fix racy cleanup of /sys in remove_dev()

Chad Dupuis (6):
      scsi: qedf: Update driver version to 8.20.5.0.
      scsi: qedf: Fix up modinfo parameter name for 'debug' in modinfo output.
      scsi: qedf: Covert single-threaded workqueues to regular workqueues.
      scsi: qedf: Corrent VLAN tag insertion in fallback VLAN case.
      scsi: qedf: Use granted MAC from the FCF for the FCoE source address if it is available.
      scsi: qedf: Set WWNN and WWPN based on values from qed.

Christoph Hellwig (5):
      scsi: scsi_transport_sas: switch to bsg-lib for SMP passthrough
      scsi: smartpqi: remove the smp_handler stub
      scsi: hpsa: remove the smp_handler stub
      scsi: bsg-lib: pass the release callback through bsg_setup_queue
      Revert "scsi: default to scsi-mq"

Christophe JAILLET (3):
      scsi: cxlflash: Fix an error handling path in 'cxlflash_disk_attach()'
      scsi: qedf: Fix a potential NULL pointer dereference
      scsi: mpt3sas: Fix memory allocation failure test in 'mpt3sas_base_attach()'

Colin Ian King (4):
      scsi: qla2xxx: fix spelling mistake of variable sfp_additonal_info
      scsi: osst: add missing indent on a for loop statement
      scsi: mpt3sas: fix pr_info message continuation
      scsi: dpt_i2o: remove redundant null check on array device

Corentin Labbe (1):
      scsi: zfcp: Remove unneeded linux/miscdevice.h include

Damien Le Moal (1):
      scsi: sd_zbc: Write unlock zone from sd_uninit_cmnd()

Dan Carpenter (6):
      scsi: qla2xxx: Fix an integer overflow in sysfs code
      scsi: qedi: off by one in qedi_get_cmd_from_tid()
      scsi: hpsa: fix the device_id in hpsa_update_device_info()
      scsi: osst: silence underflow warning in osst_verify_frame()
      scsi: sg: off by one in sg_ioctl()
      scsi: aacraid: reading out of bounds

Darren Trap (2):
      scsi: qla2xxx: Clear fc4f_nvme flag
      scsi: qla2xxx: Fix WWPN/WWNN in debug message

Dick Kennedy (17):
      scsi: lpfc: lpfc version bump 11.4.0.3
      scsi: lpfc: Fix bad sgl reposting after 2nd adapter reset
      scsi: lpfc: Fix nvme target failure after 2nd adapter reset
      scsi: lpfc: Fix relative offset error on large nvmet target ios
      scsi: lpfc: Fix MRQ > 1 context list handling
      scsi: lpfc: Limit amount of work processed in IRQ
      scsi: lpfc: Correct issues with FAWWN and FDISCs
      scsi: lpfc: Fix NVME PRLI handling during RSCN
      scsi: lpfc: Fix crash in lpfc nvmet when fc port is reset
      scsi: lpfc: Fix duplicate NVME rport entries and namespaces.
      scsi: lpfc: Fix handling of FCP and NVME FC4 types in Pt2Pt topology
      scsi: lpfc: Correct return error codes to align with nvme_fc transport
      scsi: lpfc: convert info messages to standard messages
      scsi: lpfc: Fix oops when NVME Target is discovered in a nonNVME environment
      scsi: lpfc: Fix rediscovery on switch blade pull
      scsi: lpfc: Fix loop mode target discovery
      scsi: lpfc: Fix plogi collision that causes illegal state transition

Duane Grigsby (3):
      scsi: qla2xxx: Fix system panic due to pointer access problem
      scsi: qla2xxx: Add command completion for error path
      scsi: qla2xxx: Added change to enable ZIO for FC-NVMe devices

Finn Thain (7):
      scsi: esp_scsi: Always clear msg_out_len after MESSAGE OUT phase
      scsi: esp_scsi: Avoid sending ABORT TASK SET messages
      scsi: esp_scsi: Clean up control flow and dead code
      scsi: mac_esp: Fix PIO transfers for MESSAGE IN phase
      scsi: mac_esp: Avoid type warning from sparse
      scsi: g_NCR5380: Use unambiguous terminology for PDMA send and receive
      scsi: g_NCR5380: Cleanup comments and whitespace

Giridhar Malavali (1):
      scsi: qla2xxx: Ability to process multiple SGEs in Command SGL for CT passthrough commands.

Greg Kroah-Hartman (1):
      scsi: remove DRIVER_ATTR() usage

Gustavo A. R. Silva (2):
      scsi: lpfc: remove useless code in lpfc_sli4_bsg_link_diag_test
      scsi: pmcraid: fix duplicated code for different branches

Hannes Reinecke (47):
      scsi: qlogicpti: fixup qlogicpti_reset() definition
      scsi: mptsas: Fixup device hotplug for VMWare ESXi
      scsi: eata: remove 'arg_done' from eata2x_eh_host_reset()
      scsi: visorhba: sanitze private device data allocation
      scsi: megaraid_mbox: drop duplicate bus reset and device reset function
      scsi: bnx2fc: remove obsolete bnx2fc_eh_host_reset() definition
      scsi: 53c700: move bus reset to host reset
      scsi: aha152x: drop host reset
      scsi: nsp32: drop bus reset
      scsi: qedf: drop bus reset handler
      scsi: ppa: drop duplicate bus_reset handler
      scsi: imm: drop duplicate bus_reset handler
      scsi: qlogicfas: move bus_reset to host_reset
      scsi: NCR5380: Move bus reset to host reset
      scsi: acornscsi: move bus reset to host reset
      scsi: qlogicpti: move bus reset to host reset
      scsi: rtsx: drop bus reset function
      scsi: drop bus reset for wd33c93-compatible boards
      scsi: fdomain: move bus reset to host reset
      scsi: hptiop: Simplify reset handling
      scsi: bfa: move bus reset to target reset
      scsi: libsas: move bus_reset_handler() to target_reset_handler()
      scsi: uas: move eh_bus_reset_handler to eh_device_reset_handler
      scsi: fnic: do not call host reset from command abort
      scsi: fc_fcp: do not call fc_block_scsi_eh() from host reset
      scsi: ibmvfc: Do not call fc_block_scsi_eh() on host reset
      scsi: mptfc: Do not call fc_block_scsi_eh() on host reset
      scsi: fix comment in scsi_device_set_state()
      scsi: ch: add refcounting
      scsi: ses: make page2 support optional
      scsi: ses: Fixup error message 'failed to get diagnostic page 0xffffffea'
      scsi: ses: check return code from ses_recv_diag()
      scsi: hpsa: Remove 'hpsa_allow_any' module option
      scsi: cciss: Drop obsolete driver
      scsi: hpsa: do not print errors for unsupported report luns format
      scsi: hpsa: Ignore errors for unsupported LV_DEVICE_ID VPD page
      scsi: hpsa: disable volume status check for legacy boards
      scsi: hpsa: add support for legacy boards
      scsi: make 'state' device attribute pollable
      scsi: scsi_lib: rework scsi_internal_device_unblock_nowait()
      scsi: aacraid: complete all commands during bus reset
      scsi: aacraid: add fib flag to mark scsi command callback
      scsi: aacraid: enable sending of TMFs from aac_hba_send()
      scsi: aacraid: use aac_tmf_callback for reset fib
      scsi: aacraid: split off device, target, and bus reset
      scsi: aacraid: split off host reset
      scsi: aacraid: split off functions to generate reset FIB

Helge Deller (1):
      scsi: sym53c8xx: Avoid undefined behaviour

James Smart (2):
      scsi: lpfc: Add Buffer to Buffer credit recovery support
      scsi: lpfc: remove console log clutter

Joe Carnuccio (10):
      scsi: qla2xxx: Skip zero queue count entry during FW dump capture
      scsi: qla2xxx: Add LR distance support from nvram bit
      scsi: qla2xxx: Remove potential macro parameter side-effect in ql_dump_regs()
      scsi: qla2xxx: Print correct mailbox registers in failed summary
      scsi: qla2xxx: Allow SNS fabric login to be retried
      scsi: qla2xxx: Add timeout ability to wait_for_sess_deletion().
      scsi: qla2xxx: Move logging default mask to execute once only.
      scsi: qla2xxx: Use sp->free instead of hard coded call.
      scsi: qla2xxx: Prevent sp->free null/uninitialized pointer dereference.
      scsi: qla2xxx: Correction to vha->vref_count timeout

Johannes Thumshirn (2):
      scsi: qla2xxx: add missing includes for qla_isr
      scsi: sg: only check for dxfer_len greater than 256M

John Garry (4):
      scsi: hisi_sas: remove driver versioning
      scsi: hisi_sas: replace kfree with scsi_host_put
      scsi: hisi_sas: remove phy_down_v3_hw() res variable
      scsi: hisi_sas: use array for v2 hw ECC errors

Jonathan Corbet (1):
      scsi: Fix the kerneldoc for scsi_initialize_rq()

Kevin Barnett (7):
      scsi: smartpqi: change driver version to 1.1.2-125
      scsi: smartpqi: add in new controller ids
      scsi: smartpqi: update kexec and power down support
      scsi: smartpqi: cleanup doorbell register usage.
      scsi: smartpqi: update pqi passthru ioctl
      scsi: smartpqi: enhance BMIC cache flush
      scsi: smartpqi: add pqi reset quiesce support

LABBE Corentin (1):
      scsi: zfcp: replace zfcp_qdio_sbale_count by sg_nents

Long Li (1):
      scsi: storvsc: fix memory leak on ring buffer busy

Lukáš Korenčik (1):
      scsi: zfcp: use setup_timer instead of init_timer

Manish Rangankar (1):
      scsi: qedi: Limit number for CQ queues.

Martin Peschke (4):
      scsi: zfcp: early returns for traces disabled via level
      scsi: zfcp: clean up unnecessary module_param_named() with no_auto_port_rescan
      scsi: zfcp: clean up a member of struct zfcp_qdio that was assigned but never used
      scsi: zfcp: clean up redundant code with fall through in link down SRB switch case

Matthew R. Ochs (2):
      scsi: cxlflash: Avoid double mutex unlock
      scsi: cxlflash: Remove unnecessary existence check

Maurizio Lombardi (1):
      scsi: lpfc: fix "integer constant too large" error on 32bit archs

Michael Hernandez (3):
      scsi: qla2xxx: Increase ql2xmaxqdepth to 64
      scsi: qla2xxx: Fix target multiqueue configuration
      scsi: qla2xxx: Fix system crash while triggering FW dump

Michał Mirosław (3):
      scsi: aic7xxx: regenerate firmware files
      scsi: aic7xxx: fix firmware build deps
      scsi: aic7xxx: remove empty function

Nikola Pajkovsky (3):
      scsi: aacraid: report -ENOMEM to upper layer from aac_convert_sgraw2()
      scsi: aacraid: get rid of one level of indentation
      scsi: aacraid: fix indentation errors

Ondrej Zary (4):
      scsi: g_NCR5380: Two DTC436 PDMA workarounds
      scsi: g_NCR5380: Re-work PDMA loops
      scsi: g_NCR5380: End PDMA transfer correctly on target disconnection
      scsi: g_NCR5380: Fix PDMA transfer size

Pan Bian (3):
      scsi: qla2xxx: use dma_mapping_error to check map errors
      scsi: mvsas: replace kfree with scsi_host_put
      scsi: pm8001: fix double free in pm8001_pci_probe

Prabu Thangamuthu (1):
      scsi: ufs: changing maintainer

Quinn Tran (10):
      scsi: qla2xxx: Reset the logo flag, after target re-login.
      scsi: qla2xxx: Fix slow mem alloc behind lock
      scsi: qla2xxx: Recheck session state after RSCN
      scsi: qla2xxx: Cleanup NPIV host in target mode during config teardown
      scsi: qla2xxx: Fix task mgmt handling for NPIV
      scsi: qla2xxx: Add ability to autodetect SFP type
      scsi: qla2xxx: Use fabric name for Get Port Speed command
      scsi: qla2xxx: Change ha->wq max_active value to default
      scsi: qla2xxx: Remove extra register read
      scsi: qla2xxx: Fix NPIV host enable after chip reset

Raghava Aditya Renukunta (1):
      scsi: aacraid: Fix out of bounds in aac_get_name_resp

Richard W.M. Jones (2):
      scsi: virtio: virtio_scsi: Set can_queue to the length of the virtqueue.
      scsi: virtio: Reduce BUG if total_sg > virtqueue size to WARN.

Rob Herring (1):
      scsi: Convert to using %pOF instead of full_name

Romain Perier (7):
      scsi: pmcraid: Replace PCI pool old API
      scsi: mvsas: Replace PCI pool old API
      scsi: mpt3sas: Replace PCI pool old API
      scsi: megaraid: Replace PCI pool old API
      scsi: lpfc: Replace PCI pool old API
      scsi: csiostor: Replace PCI pool old API
      scsi: be2iscsi: Replace PCI pool old API

Sawan Chandak (4):
      scsi: qla2xxx: Do not call abort handler function during chip reset
      scsi: qla2xxx: Add support for minimum link speed
      scsi: qla2xxx: Use BIT_6 to acquire FAWWPN from switch
      scsi: qla2xxx: Handle PCIe error for driver

Shivasharan S (14):
      scsi: megaraid_sas: driver version upgrade
      scsi: megaraid_sas: call megasas_dump_frame with correct IO frame size
      scsi: megaraid_sas: modified few prints in OCR and IOC INIT path
      scsi: megaraid_sas: replace internal FALSE/TRUE definitions with false/true
      scsi: megaraid_sas: Return pended IOCTLs with cmd_status MFI_STAT_WRONG_STATE in case adapter is dead
      scsi: megaraid_sas: use vmalloc for crash dump buffers and driver's local RAID map
      scsi: megaraid_sas: Use SMID for Task abort case only
      scsi: megaraid_sas: Check valid aen class range to avoid kernel panic
      scsi: megaraid_sas: Fix endianness issues in DCMD handling
      scsi: megaraid_sas: Do not re-fire shutdown DCMD after OCR
      scsi: megaraid_sas: Call megasas_complete_cmd_dpc_fusion every 1 second while there are pending commands
      scsi: megaraid_sas: Use synchronize_irq in target reset case
      scsi: megaraid_sas: set minimum value of resetwaittime to be 1 secs
      scsi: megaraid_sas: mismatch of allocated MFI frame size and length exposed in MFI MPT pass through command

Steffen Maier (14):
      scsi: zfcp: clean up no longer existent prototype from zfcp API header
      scsi: zfcp: fix kernel doc comment typos for struct zfcp_dbf_scsi
      scsi: zfcp: use endianness conversions with common FC(P) struct fields
      scsi: zfcp: use common code fcp_cmnd and fcp_resp with union in fsf_qtcb_bottom_io
      scsi: zfcp: clarify that we don't need "link" test on failed open port
      scsi: zfcp: more fitting constant for fc_ct_hdr.ct_reason on port scan response
      scsi: zfcp: trace high part of "new" 64 bit SCSI LUN
      scsi: zfcp: trace HBA FSF response by default on dismiss or timedout late response
      scsi: zfcp: fix payload with full FCP_RSP IU in SCSI trace records
      scsi: zfcp: fix missing trace records for early returns in TMF eh handlers
      scsi: zfcp: fix passing fsf_req to SCSI trace on TMF to correlate with HBA
      scsi: zfcp: fix capping of unsuccessful GPN_FT SAN response trace records
      scsi: zfcp: fix queuecommand for scsi_eh commands when DIX enabled
      scsi: fc: start decoupling fc_block_scsi_eh from scsi_cmnd

Thomas Bogendoerfer (1):
      scsi: qedf: Limit number of CQs

Thomas Gleixner (5):
      scsi: bnx2i: Simplify cpu hotplug code
      scsi: bnx2fc: Simplify CPU hotplug code
      scsi: bnx2i: Prevent recursive cpuhotplug locking
      scsi: bnx2fc: Prevent recursive cpuhotplug locking
      scsi: bnx2fc: Plug CPU hotplug race

Todd Poynor (2):
      scsi: sg: protect against races between mmap() and SG_SET_RESERVED_SIZE
      scsi: sg: recheck MMAP_IO request length with lock held

Uma Krishnan (1):
      scsi: cxlflash: Fix vlun resize failure in the shrink path

Varun Prakash (3):
      scsi: cxgb4i: call neigh_event_send() to update MAC address
      scsi: csiostor: fail probe if fw does not support FCoE
      scsi: libcxgbi: use ndev->ifindex to find route

Xiang Chen (12):
      scsi: hisi_sas: add phy_set_linkrate_v3_hw()
      scsi: hisi_sas: update some v3 register init settings
      scsi: hisi_sas: add reset handler for v3 hw
      scsi: hisi_sas: kill tasklet when destroying irq in v3 hw
      scsi: hisi_sas: fix v3 hw channel interrupt processing
      scsi: hisi_sas: Modify v3 hw STP_LINK_TIMER setting
      scsi: hisi_sas: add status and command buffer for internal abort
      scsi: hisi_sas: service interrupt ITCT_CLR interrupt in v2 hw
      scsi: hisi_sas: add irq and tasklet cleanup in v2 hw
      scsi: hisi_sas: remove repeated device config in v2 hw
      scsi: hisi_sas: fix v2 hw underflow residual value
      scsi: hisi_sas: avoid potential v2 hw interrupt issue

Xiaofei Tan (3):
      scsi: hisi_sas: support zone management commands
      scsi: hisi_sas: add v2 hw DFX feature
      scsi: hisi_sas: fix reset and port ID refresh issues

Zang Leigang (1):
      scsi: ufs: reqs and tasks were put in the wrong order

himanshu.madhani@cavium.com (7):
      scsi: qla2xxx: Update driver version to 10.00.00.01-k
      scsi: qla2xxx: Enable Async TMF processing
      scsi: qla2xxx: Update fw_started flags at qpair creation.
      scsi: qla2xxx: Fix remoteport disconnect for FC-NVMe
      scsi: qla2xxx: Simpify unregistration of FC-NVMe local/remote ports
      scsi: qla2xxx: Move function prototype to correct header
      scsi: qla2xxx: Cleanup FC-NVMe code

weiping (1):
      scsi: megaraid_sas: fix allocate instance->pd_info twice

weiping zhang (3):
      scsi: sd: remove duplicated setting of gd->minors
      scsi: scsi-sysfs: Adjust error returned for adapter reset request
      scsi: megaraid_sas: fix error handle in megasas_probe_one

And the diffstat:

 Documentation/blockdev/cciss.txt                 |  194 -
 MAINTAINERS                                      |   14 +-
 block/bsg-lib.c                                  |    7 +-
 drivers/block/Kconfig                            |   27 -
 drivers/block/Makefile                           |    1 -
 drivers/block/cciss.c                            | 5415 ----------------------
 drivers/block/cciss.h                            |  433 --
 drivers/block/cciss_cmd.h                        |  269 --
 drivers/block/cciss_scsi.c                       | 1653 -------
 drivers/block/cciss_scsi.h                       |   79 -
 drivers/message/fusion/mptbase.c                 |    8 +-
 drivers/message/fusion/mptfc.c                   |   10 +-
 drivers/message/fusion/mptsas.c                  |   86 +-
 drivers/s390/scsi/zfcp_aux.c                     |    1 -
 drivers/s390/scsi/zfcp_dbf.c                     |   95 +-
 drivers/s390/scsi/zfcp_dbf.h                     |   25 +-
 drivers/s390/scsi/zfcp_erp.c                     |    5 +-
 drivers/s390/scsi/zfcp_ext.h                     |    1 -
 drivers/s390/scsi/zfcp_fc.c                      |   52 +-
 drivers/s390/scsi/zfcp_fc.h                      |   25 +-
 drivers/s390/scsi/zfcp_fsf.c                     |   35 +-
 drivers/s390/scsi/zfcp_fsf.h                     |   12 +-
 drivers/s390/scsi/zfcp_qdio.c                    |    2 +-
 drivers/s390/scsi/zfcp_qdio.h                    |   17 -
 drivers/s390/scsi/zfcp_scsi.c                    |   18 +-
 drivers/scsi/53c700.c                            |   23 +-
 drivers/scsi/Kconfig                             |   11 +
 drivers/scsi/NCR5380.c                           |    4 +-
 drivers/scsi/a2091.c                             |   17 -
 drivers/scsi/a3000.c                             |   17 -
 drivers/scsi/aacraid/aachba.c                    |  341 +-
 drivers/scsi/aacraid/aacraid.h                   |    3 +-
 drivers/scsi/aacraid/comminit.c                  |    6 +-
 drivers/scsi/aacraid/commsup.c                   |    3 +-
 drivers/scsi/aacraid/linit.c                     |  320 +-
 drivers/scsi/aha152x.c                           |   13 +-
 drivers/scsi/aha1542.c                           |    2 +-
 drivers/scsi/aic7xxx/Makefile                    |    6 +-
 drivers/scsi/aic7xxx/aic79xx_reg.h_shipped       | 1469 ++----
 drivers/scsi/aic7xxx/aic79xx_reg_print.c_shipped |   34 +-
 drivers/scsi/aic7xxx/aic7xxx_core.c              |    1 -
 drivers/scsi/aic7xxx/aic7xxx_osm.c               |    5 -
 drivers/scsi/aic7xxx/aic7xxx_osm.h               |    1 -
 drivers/scsi/aic7xxx/aic7xxx_reg.h_shipped       |   44 +-
 drivers/scsi/aic94xx/aic94xx_init.c              |    6 +-
 drivers/scsi/arcmsr/arcmsr_attr.c                |    6 +-
 drivers/scsi/arm/acornscsi.c                     |   11 +-
 drivers/scsi/arm/cumana_1.c                      |    2 +-
 drivers/scsi/arm/oak.c                           |    2 +-
 drivers/scsi/atari_scsi.c                        |    6 +-
 drivers/scsi/be2iscsi/be_iscsi.c                 |    6 +-
 drivers/scsi/be2iscsi/be_main.c                  |    6 +-
 drivers/scsi/be2iscsi/be_main.h                  |    2 +-
 drivers/scsi/bfa/bfad_im.c                       |   37 +-
 drivers/scsi/bnx2fc/bnx2fc.h                     |    1 -
 drivers/scsi/bnx2fc/bnx2fc_fcoe.c                |   68 +-
 drivers/scsi/bnx2fc/bnx2fc_hwi.c                 |   45 +-
 drivers/scsi/bnx2i/bnx2i_init.c                  |   64 +-
 drivers/scsi/ch.c                                |   22 +-
 drivers/scsi/csiostor/csio_hw.c                  |    4 +-
 drivers/scsi/csiostor/csio_hw.h                  |    2 +-
 drivers/scsi/csiostor/csio_init.c                |   23 +-
 drivers/scsi/csiostor/csio_scsi.c                |    6 +-
 drivers/scsi/cxgbi/cxgb4i/cxgb4i.c               |    3 +
 drivers/scsi/cxgbi/libcxgbi.c                    |   27 +-
 drivers/scsi/cxlflash/main.c                     |    3 +-
 drivers/scsi/cxlflash/superpipe.c                |   14 +-
 drivers/scsi/cxlflash/vlun.c                     |    6 +-
 drivers/scsi/dmx3191d.c                          |    2 +-
 drivers/scsi/dpt_i2o.c                           |    5 -
 drivers/scsi/eata.c                              |    9 +-
 drivers/scsi/esas2r/esas2r_main.c                |    2 +-
 drivers/scsi/esp_scsi.c                          |   53 +-
 drivers/scsi/esp_scsi.h                          |    1 -
 drivers/scsi/fcoe/fcoe_sysfs.c                   |    4 +-
 drivers/scsi/fdomain.c                           |    6 +-
 drivers/scsi/fdomain.h                           |    2 +-
 drivers/scsi/fnic/fnic.h                         |    2 +-
 drivers/scsi/fnic/fnic_scsi.c                    |    4 -
 drivers/scsi/g_NCR5380.c                         |  283 +-
 drivers/scsi/gdth.c                              |    2 +-
 drivers/scsi/gdth_proc.c                         |    2 +-
 drivers/scsi/gvp11.c                             |   18 -
 drivers/scsi/hisi_sas/hisi_sas.h                 |   18 +-
 drivers/scsi/hisi_sas/hisi_sas_main.c            |  198 +-
 drivers/scsi/hisi_sas/hisi_sas_v2_hw.c           |  605 +--
 drivers/scsi/hisi_sas/hisi_sas_v3_hw.c           |  237 +-
 drivers/scsi/hpsa.c                              |  117 +-
 drivers/scsi/hpsa.h                              |   81 +-
 drivers/scsi/hptiop.c                            |   11 +-
 drivers/scsi/ibmvscsi/ibmvfc.c                   |    8 +-
 drivers/scsi/ibmvscsi/ibmvscsi.c                 |    2 +-
 drivers/scsi/ibmvscsi_tgt/ibmvscsi_tgt.c         |    2 +-
 drivers/scsi/imm.c                               |    1 -
 drivers/scsi/ipr.c                               |   34 +-
 drivers/scsi/ipr.h                               |    2 +
 drivers/scsi/isci/init.c                         |    2 +-
 drivers/scsi/iscsi_tcp.c                         |    2 -
 drivers/scsi/libfc/fc_fcp.c                      |    2 -
 drivers/scsi/libiscsi.c                          |    2 +-
 drivers/scsi/libsas/Kconfig                      |    1 +
 drivers/scsi/libsas/sas_ata.c                    |    1 +
 drivers/scsi/libsas/sas_expander.c               |   70 +-
 drivers/scsi/libsas/sas_host_smp.c               |  106 +-
 drivers/scsi/libsas/sas_internal.h               |   12 +-
 drivers/scsi/libsas/sas_scsi_host.c              |   15 +-
 drivers/scsi/lpfc/lpfc.h                         |   19 +-
 drivers/scsi/lpfc/lpfc_attr.c                    |   52 +-
 drivers/scsi/lpfc/lpfc_attr.h                    |   10 +
 drivers/scsi/lpfc/lpfc_bsg.c                     |    9 +-
 drivers/scsi/lpfc/lpfc_crtn.h                    |    5 +-
 drivers/scsi/lpfc/lpfc_ct.c                      |    4 +-
 drivers/scsi/lpfc/lpfc_debugfs.c                 |   11 +-
 drivers/scsi/lpfc/lpfc_debugfs.h                 |    6 +-
 drivers/scsi/lpfc/lpfc_disc.h                    |    1 +
 drivers/scsi/lpfc/lpfc_els.c                     |   93 +-
 drivers/scsi/lpfc/lpfc_hbadisc.c                 |   12 +-
 drivers/scsi/lpfc/lpfc_hw.h                      |   18 +-
 drivers/scsi/lpfc/lpfc_hw4.h                     |   23 +-
 drivers/scsi/lpfc/lpfc_init.c                    |   73 +-
 drivers/scsi/lpfc/lpfc_mbox.c                    |   35 +-
 drivers/scsi/lpfc/lpfc_mem.c                     |   90 +-
 drivers/scsi/lpfc/lpfc_nportdisc.c               |   25 +-
 drivers/scsi/lpfc/lpfc_nvme.c                    |   31 +-
 drivers/scsi/lpfc/lpfc_nvmet.c                   |  279 +-
 drivers/scsi/lpfc/lpfc_nvmet.h                   |   14 +
 drivers/scsi/lpfc/lpfc_scsi.c                    |   12 +-
 drivers/scsi/lpfc/lpfc_sli.c                     |   62 +-
 drivers/scsi/lpfc/lpfc_sli4.h                    |   23 +-
 drivers/scsi/lpfc/lpfc_version.h                 |    2 +-
 drivers/scsi/mac53c94.c                          |   13 +-
 drivers/scsi/mac_esp.c                           |   37 +-
 drivers/scsi/mac_scsi.c                          |    4 +-
 drivers/scsi/megaraid.c                          |    6 +-
 drivers/scsi/megaraid/megaraid_mbox.c            |   32 +-
 drivers/scsi/megaraid/megaraid_mm.c              |   29 +-
 drivers/scsi/megaraid/megaraid_sas.h             |    5 +-
 drivers/scsi/megaraid/megaraid_sas_base.c        |  112 +-
 drivers/scsi/megaraid/megaraid_sas_fp.c          |   40 +-
 drivers/scsi/megaraid/megaraid_sas_fusion.c      |  216 +-
 drivers/scsi/mpt3sas/mpt3sas_base.c              |   85 +-
 drivers/scsi/mpt3sas/mpt3sas_base.h              |    2 +-
 drivers/scsi/mpt3sas/mpt3sas_transport.c         |  230 +-
 drivers/scsi/mvme147.c                           |   16 -
 drivers/scsi/mvsas/mv_init.c                     |   12 +-
 drivers/scsi/mvsas/mv_sas.c                      |    6 +-
 drivers/scsi/nsp32.c                             |   22 +-
 drivers/scsi/osst.c                              |    8 +-
 drivers/scsi/pcmcia/fdomain_stub.c               |    2 +-
 drivers/scsi/pcmcia/qlogic_stub.c                |    4 +-
 drivers/scsi/pm8001/pm8001_init.c                |    7 +-
 drivers/scsi/pmcraid.c                           |   17 +-
 drivers/scsi/pmcraid.h                           |    2 +-
 drivers/scsi/ppa.c                               |    1 -
 drivers/scsi/qedf/qedf.h                         |    5 +-
 drivers/scsi/qedf/qedf_els.c                     |   14 +-
 drivers/scsi/qedf/qedf_fip.c                     |   35 +-
 drivers/scsi/qedf/qedf_main.c                    |  133 +-
 drivers/scsi/qedf/qedf_version.h                 |    6 +-
 drivers/scsi/qedi/qedi.h                         |    5 +-
 drivers/scsi/qedi/qedi_iscsi.c                   |    2 +-
 drivers/scsi/qedi/qedi_main.c                    |   12 +-
 drivers/scsi/qla2xxx/qla_attr.c                  |   86 +-
 drivers/scsi/qla2xxx/qla_dbg.c                   |   10 +-
 drivers/scsi/qla2xxx/qla_def.h                   |  118 +-
 drivers/scsi/qla2xxx/qla_fw.h                    |   28 +-
 drivers/scsi/qla2xxx/qla_gbl.h                   |   22 +-
 drivers/scsi/qla2xxx/qla_gs.c                    |   18 +-
 drivers/scsi/qla2xxx/qla_init.c                  |  183 +-
 drivers/scsi/qla2xxx/qla_iocb.c                  |   55 +-
 drivers/scsi/qla2xxx/qla_isr.c                   |   78 +-
 drivers/scsi/qla2xxx/qla_mbx.c                   |  263 +-
 drivers/scsi/qla2xxx/qla_mid.c                   |   14 +-
 drivers/scsi/qla2xxx/qla_mr.c                    |    7 +-
 drivers/scsi/qla2xxx/qla_nvme.c                  |  161 +-
 drivers/scsi/qla2xxx/qla_nvme.h                  |   17 +
 drivers/scsi/qla2xxx/qla_os.c                    |  155 +-
 drivers/scsi/qla2xxx/qla_target.c                |   29 +-
 drivers/scsi/qla2xxx/qla_target.h                |    2 +
 drivers/scsi/qla2xxx/qla_tmpl.c                  |   31 +-
 drivers/scsi/qla2xxx/qla_version.h               |    2 +-
 drivers/scsi/qlogicfas.c                         |    2 +-
 drivers/scsi/qlogicfas408.c                      |    6 +-
 drivers/scsi/qlogicfas408.h                      |    2 +-
 drivers/scsi/qlogicpti.c                         |    2 +-
 drivers/scsi/scsi.c                              |  144 +-
 drivers/scsi/scsi_debug.c                        |    3 +-
 drivers/scsi/scsi_debugfs.c                      |    4 +-
 drivers/scsi/scsi_error.c                        |   10 +-
 drivers/scsi/scsi_ioctl.c                        |    4 +-
 drivers/scsi/scsi_lib.c                          |  131 +-
 drivers/scsi/scsi_priv.h                         |    2 +-
 drivers/scsi/scsi_scan.c                         |    2 +-
 drivers/scsi/scsi_sysfs.c                        |   33 +-
 drivers/scsi/scsi_transport_fc.c                 |   37 +-
 drivers/scsi/scsi_transport_iscsi.c              |    6 +-
 drivers/scsi/scsi_transport_sas.c                |  121 +-
 drivers/scsi/scsi_transport_srp.c                |    7 +-
 drivers/scsi/sd.c                                |   10 +-
 drivers/scsi/sd_zbc.c                            |    9 +-
 drivers/scsi/ses.c                               |   64 +-
 drivers/scsi/sg.c                                |   55 +-
 drivers/scsi/sgiwd93.c                           |   15 -
 drivers/scsi/smartpqi/smartpqi.h                 |   44 +-
 drivers/scsi/smartpqi/smartpqi_init.c            |  145 +-
 drivers/scsi/smartpqi/smartpqi_sas_transport.c   |    9 -
 drivers/scsi/smartpqi/smartpqi_sis.c             |  111 +-
 drivers/scsi/smartpqi/smartpqi_sis.h             |    4 +-
 drivers/scsi/sr.c                                |    2 +-
 drivers/scsi/st.c                                |    4 +-
 drivers/scsi/storvsc_drv.c                       |    2 +
 drivers/scsi/sun3_scsi.c                         |    4 +-
 drivers/scsi/sym53c8xx_2/sym_hipd.c              |    2 +-
 drivers/scsi/ufs/ufshcd.c                        |    2 +-
 drivers/scsi/virtio_scsi.c                       |    4 +-
 drivers/scsi/wd33c93.c                           |    2 +
 drivers/staging/rts5208/rtsx.c                   |   11 -
 drivers/staging/unisys/visorhba/visorhba_main.c  |  123 +-
 drivers/usb/storage/uas.c                        |    4 +-
 drivers/virtio/virtio_ring.c                     |    5 +-
 include/linux/bsg-lib.h                          |    5 +-
 include/linux/cpuhotplug.h                       |    2 -
 include/linux/rcupdate.h                         |   16 +
 include/scsi/libsas.h                            |    5 +-
 include/scsi/scsi_cmnd.h                         |    5 +-
 include/scsi/scsi_device.h                       |   20 +-
 include/scsi/scsi_tcq.h                          |    2 +-
 include/scsi/scsi_transport_fc.h                 |    1 +
 include/scsi/scsi_transport_sas.h                |    4 +-
 include/scsi/scsi_transport_srp.h                |    2 +-
 230 files changed, 5059 insertions(+), 12558 deletions(-)
 delete mode 100644 Documentation/blockdev/cciss.txt
 delete mode 100644 drivers/block/cciss.c
 delete mode 100644 drivers/block/cciss.h
 delete mode 100644 drivers/block/cciss_cmd.h
 delete mode 100644 drivers/block/cciss_scsi.c
 delete mode 100644 drivers/block/cciss_scsi.h

James
