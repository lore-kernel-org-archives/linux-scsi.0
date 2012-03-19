From: James Bottomley <James.Bottomley@HansenPartnership.com>
Subject: [GIT PULL] First round of SCSI updates for the 3.3+ merge window
Date: Mon, 19 Mar 2012 11:21:44 +0000
Message-ID: <1332156104.3152.41.camel@dabdike>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner@vger.kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
To: Andrew Morton <akpm@linux-foundation.org>, Linus Torvalds <torvalds@linux-foundation.org>
Cc: linux-scsi <linux-scsi@vger.kernel.org>, linux-kernel <linux-kernel@vger.kernel.org>
List-Id: linux-scsi@vger.kernel.org

The patch contains the usual assortment of driver updates (lpfc,
qla2xxx, qla4xxx, bfa, bnx2fc, bnx2i, isci, fcoe, hpsa) plus a huge
amount of infrastructure work in the SAS library and transport class as
well as an iSCSI update.  There's also a new SCSI based virtio driver.

The patch is available here:

git://git.kernel.org/pub/scm/linux/kernel/git/jejb/scsi-misc-2.6.git scsi-misc

The short changelog is

Akinobu Mita (1):
      hpsa: use find_first_zero_bit

Andrew Morton (1):
      mpt2sas: spell "primitive" correctly in function prototype

Andrew Vasquez (6):
      qla2xxx: Cache swl during fabric discovery.
      qla2xxx: Reduce mbx-command timeout for Login/Logout requests.
      qla2xxx: Prep zero-length BSG data-transfer requests.
      qla2xxx: Perform implicit logout during rport tear-down.
      qla2xxx: Use consistent DL mask for ELS/CT passthru requests.
      qla2xxx: Use a valid enode-mac if none defined.

Andrzej Jakowski (1):
      isci: improvements in driver unloading routine

Arun Easi (8):
      qla2xxx: Avoid invalid request queue dereference for bad response packets.
      qla2xxx: Stop iteration after first failure in *_id functions.
      qla2xxx: Fix incorrect register access in qla2x00_start_iocbs().
      qla2xxx: Handle device mapping changes due to device logout.
      qla2xxx: Log messages to use correct vha.
      qla2xxx: Add new message when a new loopid is assigned.
      qla2xxx: Fix ql_dbg arguments.
      qla2xxx: Handle change notifications based on switch scan results.

Bhanu Prakash Gollapudi (6):
      libfc: Handle discovery failure during ctlr link down
      libfc: Fix panic in fc_exch_recv
      bnx2fc: Bumped version to 1.0.10
      bnx2fc: NPIV ports go offline when interface is brought down & up
      bnx2fc: Handle LOGO flooding from the target
      bnx2fc: fix panic in bnx2fc_post_io_req

Chad Dupuis (8):
      qla2xxx: Add ha->max_fibre_devices to keep track of the maximum number of targets.
      qla2xxx: Update LICENSE.qla2xxx.
      qla2xxx: Perform firmware dump procedure on mailbox command timeout.
      qla2xxx: Use ql_log* #define's in ql_log() and ql_log_pci().
      qla2xxx: Convert remaining printk's to ql_log format.
      qla2xxx: Print mailbox command opcode and return code when a command times out.
      qla2xxx: Handle failure cases during fabric_login
      qla2xxx: Increase speed of flash access in ISP82xx adapters to improve firmware load speed.

Dan Carpenter (1):
      qla2xxx: handle default case in qla2x00_request_firmware()

Dan Williams (54):
      isci: improve phy event warnings
      isci: debug, provide state-enum-to-string conversions
      scsi_transport_sas: 'enable' phys on reset
      libsas: don't recover end devices attached to disabled phys
      libsas: fixup target_port_protocols for expanders that don't report sata
      libsas: set attached device type and target protocols for local phys
      libsas: revert ata srst
      libsas: fix lifetime of SAS_HA_FROZEN
      libsas: async ata scanning
      libsas: restore scan order
      libsas: delete device on sas address changed
      libsas: let libata recover links that fail to transmit initial sig-fis
      libsas: fix sas port naming
      libsas: improve debug statements
      libsas: fix sas_unregister_ports vs sas_drain_work
      libsas: route local link resets through ata-eh
      libsas: fix mixed topology recovery
      libsas: close scsi_remove_target() vs libata-eh race
      libsas: mark all domain devices gone if root port disappears
      libsas: pre-clean commands that won the eh vs completion race
      isci: remove IDEV_EH hack to disable "discovery-time" ata resets
      isci: remove bus and reset handlers
      isci: ->lldd_ata_check_ready handler
      isci: stop interpreting ->lldd_lu_reset() as an ata soft-reset
      isci: fix interpretation of "hard" reset
      isci: kill isci_port->status
      isci: kill iphy->isci_port lookups
      libsas: don't recover 'gone' devices in sas_ata_hard_reset()
      libsas: fix sas_find_local_phy(), take phy references
      libsas: check for 'gone' expanders in smp_execute_task()
      libsas: don't mark expanders as gone when a child device is removed
      libsas: poll for ata device readiness after reset
      libsas: async ata-eh
      libsas: sas_phy_enable via transport_sas_phy_reset
      libsas: execute transport link resets with libata-eh via host workqueue
      libsas: perform sas-transport resets in shost->workq context
      libsas: use libata-eh-reset for sata rediscovery fis transmit failures
      libsas: defer SAS_TASK_NEED_DEV_RESET commands to libata
      libsas: let libata handle command timeouts
      libsas: fix timeout vs completion race
      libsas: prevent double completion of scmds from eh
      libsas: close error handling vs sas_ata_task_done() race
      libsas: kill invocation of scsi_eh_finish_cmd from sas_ata_task_done
      libsas: use ->set_dmamode to notify lldds of NCQ parameters
      libsas: prevent domain rediscovery competing with ata error handling
      libsas: convert dev->gone to flags
      libsas: remove ata_port.lock management duties from lldds
      libsas: introduce sas_drain_work()
      libsas: convert ha->state to flags
      libsas: replace event locks with atomic bitops
      libsas: fix leak of dev->sata_dev.identify_[packet_]device
      libsas: fix domain_device leak
      libsas: kill sas_slave_destroy
      libsas: remove unused ata_task_resp fields

Dave Jiang (1):
      isci: T10 DIF support

Douglas Gilbert (1):
      scsi_debug: GET LBA STATUS response length correction

Eddie Wai (1):
      bnx2i: Fixed the override of the error_mask module param

Eric Dumazet (1):
      bnx2i: use kthread_create_on_node()

Giridhar Malavali (4):
      qla2xxx: Change the log message when previous dump is available to retrieve for ISP82xx.
      qla2xxx: Consolidation of SRB processing.
      qla2xxx: Enhancements to support ISP83xx.
      qla2xxx: Enhanced the dump routines to capture multiple request and response queues.

James Smart (7):
      lpfc 8.3.29: Update driver version to 8.3.29
      lpfc 8.3.29: Remove GFP_KERNEL allocation while lock is held
      lpfc 8.3.29: Locking fix and Memory leak Fixes
      lpfc 8.3.29: FC Discovery state machine fixes
      lpfc 8.3.29: T10 Diff fixes and enhancements
      lpfc 8.3.29: SLI related fixes
      lpfc 8.3.29: BSG and User interface fixes

Jeff Skirvin (2):
      libsas: add mutex for SMP task execution
      libsas: Remove redundant phy state notification calls.

Jesper Juhl (1):
      bfa: don't leak mem in bfad_im_bsg_els_ct_request()

Jing Huang (1):
      bfa: add readme file

Joe Carnuccio (3):
      qla2xxx: Remove EDC sysfs interface.
      qla2xxx: Return blank sysfs string on initial get thermal failure.
      qla2xxx: Correct print format for edc ql_log() calls.

Lalit Chandivade (3):
      qla4xxx: Remove un-necessary print statment
      qla4xxx: Fix verify boot idx correctly
      qla4xxx: Fix un-necessary delay on invalid DDB

Maciej Trela (1):
      libsas: kill spurious sas_put_device

Mahesh Rajashekhara (1):
      aacraid: Added Sync.mode to support series 7/8/9 controllers

Manish Rangankar (2):
      qla4xxx: Add support for multiple session per host.
      qla4xxx: Modified debug log messages for boot info.

Marcin Tomczak (1):
      isci: enable clock gating

Mark Salyzyn (3):
      pm8001: deficient responses to IO_XFER_ERROR_BREAK and IO_XFER_OPEN_RETRY_TIMEOUT
      pm8001: Add FUNC_GET_EVENTS
      pm8001: fix lockup on phy_control hard reset.

Martin K. Petersen (3):
      Handle disk devices which can not process medium access commands
      sd: Make sure provisioning mode is reported correctly
      Ensure discard failure gets treated as a target problem

Mike Christie (5):
      qla4xxx: Export CHAP index as sysfs attribute
      scsi_transport: Export CHAP index as sysfs attribute
      libiscsi: fix cmd timeout/completion race
      libiscsi_tcp: fix max_r2t manipulation
      iscsi: fix setting of pid from netlink skb

Mike Snitzer (1):
      scsi_error: classify some ILLEGAL_REQUEST sense as a permanent TARGET_ERROR

Moger, Babu (2):
      fix the new host byte settings (DID_TARGET_FAILURE and DID_NEXUS_FAILURE)
      Correctly set the scsi host/msg/status bytes

Neerav Parikh (7):
      fcoe: Allow exposing FDMI attributes via sysfs
      fcoe: Allow exposing FDMI attributes via sysfs
      fcoe: Add support for FDMI in fcoe
      libfc: Add support for FDMI
      libfc: Make the libfc Common Transport(CT) code generic
      scsi_transport_fc: Getting FC Port Speed in sync with FC-GS
      scsi_transport_fc: Add FDMI host attributes

Nilesh Javali (2):
      qla4xxx: Add support to display CHAP list and delete CHAP entry
      iscsi_transport: Add support to display CHAP list and delete CHAP entry

Oliver Neukum (1):
      st: implement PM

Paolo Bonzini (1):
      virtio-scsi: SCSI driver for QEMU based virtual machines

Robert Love (4):
      fcoe: Remove reference counting on 'stuct fcoe_interface'
      fcoe: Do not switch context in vport_delete callback
      fcoe: Rename out_nomod label to out_putmod
      libfcoe: Don't KERN_ERR on netdev notification

Santosh Nayak (3):
      pm8001: fix endian issue with code optimization.
      pm8001: Fix possible racing condition.
      pm8001: Fix bogus interrupt state flag issue.

Sasha Levin (1):
      iscsi: don't hang in endless loop if no targets present

Scott Teel (3):
      hpsa: update device attributes when they change
      hpsa: improve naming on external target device functions
      hpsa: eliminate 8 external target limitation

Stephen M. Cameron (7):
      hpsa: refactor hpsa_figure_bus_target_lun
      hpsa: make target and lun match what SCSI REPORT LUNs returns
      hpsa: Fix problem with MSA2xxx devices
      hpsa: factor out driver name
      hpsa: combine hpsa_scsi_detect and hpsa_register_scsi
      hpsa: removed unneeded structure member max_sg_entries and fix badly named constant MAXSGENTRIES
      hpsa: fix per device memory leak on driver unload

Tomas Henzl (2):
      hpsa: add some older controllers to the kdump blacklist
      mpt2sas: add missing allocation check

Vikas Chaudhary (15):
      qla4xxx: Update driver version to 5.02.00-k15
      qla4xxx: trivial cleanup
      qla4xxx: Fix sparse warning
      qla4xxx: Update driver version to 5.02.00-k14
      qla4xxx: Added ping support
      iscsi_transport: Added Ping support
      qla4xxx: added support for host event
      scsi_transport_iscsi: added support for host event
      qla4xxx: Proper detection of firmware abort error code for ISP82xx
      qla4xxx: Remove unused code
      qla4xxx: Update driver version to 5.02.00-k13
      qla4xxx: Added support to show port_state and port_speed in sysfs
      scsi_transport_iscsi: Added support to show port_state and port_speed in sysfs
      qla4xxx: Added support to show targetalias in sysfs
      libiscsi: Added support to show targetalias in sysfs

Wayne Boyer (1):
      ipr: update PCI ID definitions for new adapters

and the diffstat:

 Documentation/scsi/LICENSE.qla2xxx      |   41 +-
 Documentation/scsi/bfa.txt              |   82 +++
 Documentation/scsi/libsas.txt           |   15 -
 drivers/ata/libata-core.c               |   34 +-
 drivers/ata/libata-eh.c                 |    1 +
 drivers/ata/libata-scsi.c               |   13 +
 drivers/ata/libata.h                    |    2 +-
 drivers/scsi/Kconfig                    |    8 +
 drivers/scsi/Makefile                   |    1 +
 drivers/scsi/aacraid/aachba.c           |    4 +
 drivers/scsi/aacraid/aacraid.h          |   27 +-
 drivers/scsi/aacraid/comminit.c         |   21 +-
 drivers/scsi/aacraid/commsup.c          |   26 +
 drivers/scsi/aacraid/linit.c            |   28 +-
 drivers/scsi/aacraid/rx.c               |    1 +
 drivers/scsi/aacraid/sa.c               |    1 +
 drivers/scsi/aacraid/src.c              |  293 ++++++--
 drivers/scsi/aic94xx/aic94xx.h          |    2 +
 drivers/scsi/aic94xx/aic94xx_dev.c      |   38 +-
 drivers/scsi/aic94xx/aic94xx_init.c     |    6 +-
 drivers/scsi/aic94xx/aic94xx_tmf.c      |   11 +-
 drivers/scsi/bfa/bfad_bsg.c             |    4 +-
 drivers/scsi/bnx2fc/bnx2fc.h            |    8 +-
 drivers/scsi/bnx2fc/bnx2fc_fcoe.c       |   20 +-
 drivers/scsi/bnx2i/bnx2i_hwi.c          |   12 +-
 drivers/scsi/bnx2i/bnx2i_init.c         |    9 +-
 drivers/scsi/cxgbi/libcxgbi.c           |   13 +-
 drivers/scsi/fcoe/fcoe.c                |  167 +++--
 drivers/scsi/fcoe/fcoe.h                |    3 -
 drivers/scsi/fcoe/fcoe_transport.c      |    4 +-
 drivers/scsi/hpsa.c                     |  344 ++++-----
 drivers/scsi/hpsa.h                     |    3 +-
 drivers/scsi/hpsa_cmd.h                 |    9 +-
 drivers/scsi/ipr.c                      |   14 +-
 drivers/scsi/ipr.h                      |    4 +-
 drivers/scsi/isci/host.c                |   17 +-
 drivers/scsi/isci/host.h                |   19 +-
 drivers/scsi/isci/init.c                |   24 +-
 drivers/scsi/isci/phy.c                 |  171 +++--
 drivers/scsi/isci/phy.h                 |  155 ++--
 drivers/scsi/isci/port.c                |  263 +++----
 drivers/scsi/isci/port.h                |  114 ++-
 drivers/scsi/isci/registers.h           |   27 +-
 drivers/scsi/isci/remote_device.c       |   82 +--
 drivers/scsi/isci/remote_device.h       |  212 +++---
 drivers/scsi/isci/remote_node_context.c |   19 +-
 drivers/scsi/isci/remote_node_context.h |   97 ++-
 drivers/scsi/isci/request.c             |  370 +++++-----
 drivers/scsi/isci/request.h             |  228 +++---
 drivers/scsi/isci/scu_task_context.h    |   55 +-
 drivers/scsi/isci/task.c                |  158 +----
 drivers/scsi/isci/task.h                |   40 --
 drivers/scsi/iscsi_tcp.c                |   13 +-
 drivers/scsi/libfc/fc_disc.c            |    7 +
 drivers/scsi/libfc/fc_elsct.c           |    3 +-
 drivers/scsi/libfc/fc_exch.c            |    7 +-
 drivers/scsi/libfc/fc_lport.c           |  227 +++++-
 drivers/scsi/libiscsi.c                 |   28 +-
 drivers/scsi/libiscsi_tcp.c             |   18 +
 drivers/scsi/libsas/sas_ata.c           |  828 +++++++++++-----------
 drivers/scsi/libsas/sas_discover.c      |  246 +++++--
 drivers/scsi/libsas/sas_event.c         |   96 ++-
 drivers/scsi/libsas/sas_expander.c      |  342 ++++++---
 drivers/scsi/libsas/sas_host_smp.c      |   11 +-
 drivers/scsi/libsas/sas_init.c          |  214 +++++-
 drivers/scsi/libsas/sas_internal.h      |   97 ++-
 drivers/scsi/libsas/sas_phy.c           |   12 +-
 drivers/scsi/libsas/sas_port.c          |   32 +-
 drivers/scsi/libsas/sas_scsi_host.c     |  364 ++++------
 drivers/scsi/lpfc/lpfc.h                |   13 +-
 drivers/scsi/lpfc/lpfc_attr.c           |   12 +-
 drivers/scsi/lpfc/lpfc_bsg.c            |   18 +-
 drivers/scsi/lpfc/lpfc_crtn.h           |    1 +
 drivers/scsi/lpfc/lpfc_ct.c             |    4 +-
 drivers/scsi/lpfc/lpfc_debugfs.c        |   19 +
 drivers/scsi/lpfc/lpfc_els.c            |    5 +-
 drivers/scsi/lpfc/lpfc_hbadisc.c        |   12 +-
 drivers/scsi/lpfc/lpfc_hw.h             |    5 +-
 drivers/scsi/lpfc/lpfc_hw4.h            |   49 +-
 drivers/scsi/lpfc/lpfc_init.c           |  137 +++-
 drivers/scsi/lpfc/lpfc_nportdisc.c      |   77 +-
 drivers/scsi/lpfc/lpfc_scsi.c           | 1178 ++++++++++++++++++++++++++-----
 drivers/scsi/lpfc/lpfc_sli.c            |  240 ++++---
 drivers/scsi/lpfc/lpfc_sli.h            |    1 +
 drivers/scsi/lpfc/lpfc_sli4.h           |    3 +-
 drivers/scsi/lpfc/lpfc_version.h        |    2 +-
 drivers/scsi/mpt2sas/mpt2sas_base.c     |    5 +
 drivers/scsi/mpt2sas/mpt2sas_scsih.c    |    6 +-
 drivers/scsi/mvsas/mv_init.c            |    2 -
 drivers/scsi/mvsas/mv_sas.c             |   11 +-
 drivers/scsi/pm8001/pm8001_chips.h      |    4 +-
 drivers/scsi/pm8001/pm8001_hwi.c        |  434 +++++++++---
 drivers/scsi/pm8001/pm8001_hwi.h        |    2 +-
 drivers/scsi/pm8001/pm8001_init.c       |    2 -
 drivers/scsi/pm8001/pm8001_sas.c        |  127 +++-
 drivers/scsi/pm8001/pm8001_sas.h        |    6 +
 drivers/scsi/qla2xxx/qla_attr.c         |  177 +----
 drivers/scsi/qla2xxx/qla_bsg.c          |  120 ++--
 drivers/scsi/qla2xxx/qla_dbg.c          |  630 ++++++++++++++++-
 drivers/scsi/qla2xxx/qla_dbg.h          |   63 ++
 drivers/scsi/qla2xxx/qla_def.h          |  117 +--
 drivers/scsi/qla2xxx/qla_dfs.c          |    2 +-
 drivers/scsi/qla2xxx/qla_fw.h           |   13 +
 drivers/scsi/qla2xxx/qla_gbl.h          |   22 +-
 drivers/scsi/qla2xxx/qla_gs.c           |   86 ++-
 drivers/scsi/qla2xxx/qla_init.c         |  540 ++++++--------
 drivers/scsi/qla2xxx/qla_inline.h       |   51 +-
 drivers/scsi/qla2xxx/qla_iocb.c         |  167 +++--
 drivers/scsi/qla2xxx/qla_isr.c          |  445 +++++-------
 drivers/scsi/qla2xxx/qla_mbx.c          |  410 ++++++++---
 drivers/scsi/qla2xxx/qla_mid.c          |    2 +-
 drivers/scsi/qla2xxx/qla_nx.c           |   90 +--
 drivers/scsi/qla2xxx/qla_nx.h           |    3 +-
 drivers/scsi/qla2xxx/qla_os.c           |  435 ++++++++----
 drivers/scsi/qla2xxx/qla_sup.c          |  148 +++-
 drivers/scsi/qla4xxx/ql4_def.h          |   45 +-
 drivers/scsi/qla4xxx/ql4_fw.h           |   24 +
 drivers/scsi/qla4xxx/ql4_glbl.h         |    9 +
 drivers/scsi/qla4xxx/ql4_init.c         |    5 +
 drivers/scsi/qla4xxx/ql4_iocb.c         |   92 +++
 drivers/scsi/qla4xxx/ql4_isr.c          |   78 ++
 drivers/scsi/qla4xxx/ql4_mbx.c          |   23 +-
 drivers/scsi/qla4xxx/ql4_nx.c           |   17 +-
 drivers/scsi/qla4xxx/ql4_nx.h           |    1 +
 drivers/scsi/qla4xxx/ql4_os.c           |  563 ++++++++++++++-
 drivers/scsi/qla4xxx/ql4_version.h      |    2 +-
 drivers/scsi/scsi.c                     |    6 -
 drivers/scsi/scsi_debug.c               |    6 +-
 drivers/scsi/scsi_error.c               |   24 +-
 drivers/scsi/scsi_lib.c                 |    5 +-
 drivers/scsi/scsi_transport_fc.c        |   30 +-
 drivers/scsi/scsi_transport_iscsi.c     |  268 ++++++-
 drivers/scsi/scsi_transport_sas.c       |   60 +-
 drivers/scsi/sd.c                       |   86 ++-
 drivers/scsi/sd.h                       |   35 +
 drivers/scsi/st.c                       |   11 +
 drivers/scsi/virtio_scsi.c              |  594 ++++++++++++++++
 include/linux/libata.h                  |    2 +
 include/linux/virtio_ids.h              |    1 +
 include/linux/virtio_scsi.h             |  114 +++
 include/scsi/fc/fc_ms.h                 |  213 ++++++
 include/scsi/fc_encode.h                |  363 +++++++++-
 include/scsi/iscsi_if.h                 |   79 +++
 include/scsi/libfc.h                    |   11 +
 include/scsi/libiscsi.h                 |    3 +-
 include/scsi/libiscsi_tcp.h             |    2 +-
 include/scsi/libsas.h                   |   71 +-
 include/scsi/sas.h                      |    4 +-
 include/scsi/sas_ata.h                  |   44 +-
 include/scsi/scsi_cmnd.h                |   12 +-
 include/scsi/scsi_driver.h              |    1 +
 include/scsi/scsi_transport_fc.h        |   32 +-
 include/scsi/scsi_transport_iscsi.h     |   22 +
 include/scsi/scsi_transport_sas.h       |   12 +-
 154 files changed, 10314 insertions(+), 4417 deletions(-)
 create mode 100644 Documentation/scsi/bfa.txt
 create mode 100644 drivers/scsi/virtio_scsi.c
 create mode 100644 include/linux/virtio_scsi.h
 create mode 100644 include/scsi/fc/fc_ms.h

James
