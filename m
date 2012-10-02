From: James Bottomley <James.Bottomley@HansenPartnership.com>
Subject: [GIT PULL] First round of SCSI updates for the 3.6+ merge window
Date: Tue, 02 Oct 2012 09:09:14 +0100
Message-ID: <1349165354.2406.10.camel@dabdike.int.hansenpartnership.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from bedivere.hansenpartnership.com ([66.63.167.143]:42811 "EHLO
	bedivere.hansenpartnership.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753717Ab2JBIJS (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Tue, 2 Oct 2012 04:09:18 -0400
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Andrew Morton <akpm@linux-foundation.org>, Linus Torvalds <torvalds@linux-foundation.org>
Cc: linux-scsi <linux-scsi@vger.kernel.org>, linux-kernel <linux-kernel@vger.kernel.org>

This is a large set of updates, mostly for drivers (qla2xxx [including
support for new 83xx based card], qla4xxx, mpt2sas, bfa, zfcp, hpsa,
be2iscsi, isci, lpfc, ipr, ibmvfc, ibmvscsi, megaraid_sas).  There's
also a rework for tape adding virtually unlimited numbers of tape drives
plus a set of dif fixes for sd and a fix for a live lock on hot remove
of SCSI devices.

This round includes a signed tag pull of isci-for-3.6

Because of the need to keep the tree stable for next testing, anything
submitted after last Saturday will be in the next round.

The patch is available here:

git://git.kernel.org/pub/scm/linux/kernel/git/jejb/scsi.git scsi-for-linus

The short changelog is

Adam Radford (3):
      megaraid_sas: Version and Changelog update
      megaraid_sas: Add resetwaittime module parameter
      megaraid_sas: Add throttlequeuedepth module parameter

Alexey Khoroshilov (1):
      mpt2sas: fix double mutex lock in NON_BLOCKING state

Andi Kleen (1):
      Fix incorrect memset in bnx2fc_parse_fcp_rsp

Andrew Vasquez (2):
      qla2xxx: Fail initialization if unable to load RISC code.
      qla2xxx: Ensure PLOGI is sent to Fabric Management-Server upon request.

Artur Wojcik (1):
      isci: implement suspend/resume support

Arun Easi (5):
      qla2xxx: Use the right field for container_of.
      qla2xxx: Fix incorrect status reporting on DIF errors.
      qla2xxx: T10 DIF - ISP83xx changes.
      qla2xxx: Use #defines instead of hardcoded values for intr status.
      qla2xxx: Fix for continuous rescan attempts in arbitrated loop topology.

Atul Deshmukh (1):
      qla2xxx: Wrong PCIe(2.5Gb/s x8) speed in the kerenel message for ISP82xx.

Bart Van Assche (1):
      scsi_dh_alua: Enable STPG for unavailable ports

Benjamin Herrenschmidt (2):
      ibmvscsi: Fix host config length field overflow
      ibmvscsi: Remove backend abstraction

Brian King (6):
      ibmvfc: Driver version 1.0.10
      ibmvfc: Ignore fabric RSCNs when link is dead
      ibmvfc: Fix double completion on abort timeout
      ipr: Driver version 2.5.4
      ipr: Reduce interrupt lock time
      ipr: Reduce queuecommand lock time

Chad Dupuis (12):
      qla2xxx: Update version number to 8.04.00.07-k.
      qla2xxx: Set Maximum Read Request Size to 4K.
      qla2xxx: Fix for handling some error conditions in loopback.
      qla2xxx: Fix description of qla2xmaxqdepth parameter.
      qla2xxx: Remove setting Scsi_host->this_id during adapter probe.
      qla2xxx: Implement beacon support for ISP83xx.
      qla2xxx: Only enable link up on the correct interrupt event.
      qla2xxx: Update the driver copyright.
      qla2xxx: Changes for ISP83xx loopback support.
      qla2xxx: Use bitmap to store loop_id's for fcports.
      qla2xxx: Add check in qla82xx_watchdog for failed hardware state.
      qla2xxx: Bind to ISP8031 devices.

Dan Carpenter (4):
      ipr: remove an unneeded check
      ipr: missing unlock before a return
      isci: add a couple __iomem annotations
      isci: make function declaration match implementation

Dan Williams (6):
      scsi_remove_target: fix softlockup regression on hot remove
      libsas, ipr: cleanup ata_host flags initialization via ata_host_init
      libsas: suspend / resume support
      libata: export ata_port suspend/resume infrastructure for sas
      libata: reset once
      isci: fix isci_pci_probe() generates warning on efi failure path

Dave Jiang (1):
      isci: Fix interrupt coalescing assumption of active TCs

Dave Maurer (1):
      isci: fix COMSAS negation timout workaround for WD SAS drives

Fengguang Wu (1):
      megaraid_sas: combine kmalloc+memset into kzalloc

Giridhar Malavali (4):
      qla2xxx: Allow MSI interrupt registration for ISP82xx.
      qla2xxx: Don't toggle RISC interrupt bits after IRQ lines are attached.
      qla2xxx: Fix for legacy interrupts for ISP83xx.
      qla2xxx: Don't register to legacy interrupt for ISP82xx.

Hanjun Guo (1):
      Fusion MPT: disable pci device when mpt map resoures failed

Hannes Reinecke (1):
      st: remove st_mutex

Harish Zunjarrao (1):
      qla2xxx: Add FW DUMP SIZE sysfs attribute.

James Smart (33):
      lpfc 8.3.34: Update lpfc version for 8.3.34 driver release
      lpfc 8.3.34: Fixed leaking memory from pci dma pool
      lpfc 8.3.34: Correct lock handling to eliminate reset escalation on I/O abort
      lpfc 8.3.34: Adjust IO Channels to 1 when INTx
      lpfc 8.3.34: Add XRI to abort handler timeout log message
      lpfc 8.3.34: Streamline fcp underrun message printing
      lpfc 8.3.34: Correct typecasts for snprintf messages
      lpfc 8.3.34: Simplify BlockGuard lpfc_printf_vlog messages
      lpfc 8.3.34: Fix parameter field in CQE to mask for LOCAL_REJECT status
      lpfc 8.3.34: Fix number of IO channels to match CPUs
      lpfc 8.3.34: Add SLI-4 V1 Capacity and Resource Descriptor support
      lpfc 8.3.34: Add LOGO support after ABTS compliance
      lpfc 8.3.33: Update lpfc version for 8.3.33 driver release
      lpfc 8.3.33: Fixed incomplete list of SLI4 commands with extended timeout value
      lpfc 8.3.33: Fixed debugfs queInfo to include queue stats
      lpfc 8.3.33: Add lpfc_fcp_look_ahead module parameter
      lpfc 8.3.33: Make I/O to hw queue distribution algorithm a module parameter
      lpfc 8.3.33: Change Naming convention for SLI4 Interrupt vector
      lpfc 8.3.33: Allow per-hba interrupt rate tuning
      lpfc 8.3.33: Tie parallel I/O queues into separate MSIX vectors
      lpfc 8.3.33: Add Interrupts per second stats via debugfs
      lpfc 8.3.33: Parallelize SLI-4 Q distribution
      lpfc 8.3.33: Misc changes to optimize critical path
      lpfc 8.3.33: Formally separate lpfc_sli_ring SLI-3 and SLI-4 variantions
      lpfc 8.3.33: Convert to no SCSI host lock in queuecommand
      lpfc 8.3.33: Add debugfs interface to display SLI queue information
      lpfc 8.3.33: Fix error when remote port switches address
      lpfc 8.3.33: Fix scsi_eh escalation panic by checking the proper return status
      lpfc 8.3.33: Check data transfer amount on write commands
      lpfc 8.3.33: Fix error of not reiniting mbx cmd before reissue
      lpfc 8.3.33: Fix bug with rrq_pool not being destroyed during driver removal.
      lpfc 8.3.33: Enable attachment to OCe14000 adapters
      lpfc 8.3.33: When doing loopback testing, set the diag valid bit

Jeff Mahoney (5):
      st: raise device limit
      st: clean up device file creation and removal
      st: get rid of scsi_tapes array
      st: clean up dev cleanup in st_probe
      st: Use static class attributes

Jeff Skirvin (1):
      isci: Allow SSP tasks into the task management path.

Jianpeng Ma (1):
      mvsas: Fix oops when ata commond timeout.

Joe Carnuccio (3):
      qla2xxx: Do PCI fundamental reset for ISP83xx
      qla2xxx: Add bit to identify adapters for thermal temp.
      qla2xxx: Add I2C BSG interface.

John Soni Jose (7):
      be2iscsi: Bump the driver version.
      be2iscsi: Fix a kernel panic because of TCP RST/FIN received.
      be2iscsi: Add support for configuring the VLAN on the adapter.
      be2iscsi: Format the MAC_ADDR with sysfs_format_mac.
      be2iscsi: Added Logging mechanism for the driver.
      be2iscsi: Issue MBX Cmd for login to boot target in crashdump mode
      be2iscsi: Removing the iscsi_data_pdu setting.

Julia Lawall (1):
      zfcp: remove invalid reference to list iterator variable

Kleber Sacilotto de Souza (1):
      ipr: trivial: fix small coding style issues

Krishna Gudipati (10):
      bfa: Update the driver version to v3.1.2.0.
      bfa: Update MAINTAINERS file for BFA driver.
      bfa: Add support for max target ports discovery
      bfa: Add support to register node symbolic name with name server
      bfa: Fix to process mbox interrupts only if interrupts are enabled in INTx mode.
      bfa: Add PowerPC support and enable PCIE AER handling.
      bfa: Add new hardware model info to sysfs model description routine.
      bfa: Make changes to FCXP resource management.
      bfa: FCS remote port enhancements.
      bfa: Support vport symbolic name change from sysfs.

Lalit Chandivade (1):
      qla4xxx: Properly handle SCSI underrun while processing status IOCBs.

Manish Dusane (2):
      qla4xxx: Fix double clearing of risc_intr for ISP83XX
      qla4xxx: Added new mbox cmd to pass driver version to FW

Manish Rangankar (2):
      qla4xxx: Fix multiple conn login event issue during session recovery.
      qla4xxx: Fix memory corruption issue in qla4xxx_ep_connect.

Martin K. Petersen (6):
      sd: Ensure we correctly disable devices with unknown protection type
      mpt2sas: Add a module parameter that permits overriding protection capabilities
      mpt2sas: Return the correct sense key for DIF errors
      Disable DIF on Hitachi Ultrastar 15K300
      sd: Allow protection_type to be overridden
      sd: Avoid remapping bad reference tags

Martin Peschke (1):
      zfcp: only access zfcp_scsi_dev for valid scsi_device

Martin Pitt (1):
      scsi_debug: Add "removable" parameter

Masanari Iida (1):
      qla2xxx: Fix typo in qla2xxx files

Mike Miller (1):
      hpsa: gen8plus Smart Array IDs

Moger, Babu (4):
      scsi_dh_rdac : minor return fix for rdac
      scsi_dh_rdac : Consolidate rdac strings together
      scsi_dh_rdac: Add a new netapp vendor/product string
      add DID_TARGET_FAILURE and DID_NEXUS_FAILURE to hostbyte_table in constants.c

Nilesh Javali (1):
      qla4xxx: IDC implementation for Loopback

Poornima Vonti (2):
      qla4xxx: Fail probe_adapter if IRQ allocation fails
      qla4xxx: Fix double IDC locking in qla4_8xxx_error_recovery

Rob Evers (1):
      iscsi_tcp: increase max_lun to ~0, don't care

Robert Jennings (1):
      ibmvscsi: Add maintainer for IBM virtual SCSI/FC drivers

Robert Love (1):
      fc-transport: Remove unnecessary include

Santosh Vernekar (2):
      qla2xxx: Perform ROM mbx cmd access only after ISP soft-reset during f/w recovery.
      qla2xxx: IDC implementation for ISP83xx.

Saurav Kashyap (10):
      qla2xxx: Restrict nic core reset to one function for mctp.
      qla2xxx: Enable fw attributes for ISP24xx and above.
      qla2xxx: Get fcal position map should not be called for p2p topology.
      qla2xxx: Enclose adapter related calls in adapter check in failed state handler.
      qla2xxx: set idc version if function is first one to come.
      qla2xxx: Do not restrict the number of NPIV ports for ISP83xx.
      qla2xxx: Dont call nic restart firmware if it is already active and running.
      qla2xxx: Implemetation of mctp.
      qla2xxx: Implementation of bidirectional.
      qla2xxx: Display mailbox failure by default.

Steffen Maier (6):
      zfcp: No automatic port_rescan on events
      zfcp: restore refcount check on port_remove
      zfcp: Do not wakeup while suspended
      zfcp: Bounds checking for deferred error trace
      zfcp: Make trace record tags unique
      zfcp: Adapt to new FC_PORTSPEED semantics

Stephen M. Cameron (3):
      hpsa: use ioremap_nocache instead of ioremap
      hpsa: fix incorrect abort diagnostic message
      hpsa: Use LUN reset instead of target reset

Tej Parkash (1):
      qla4xxx: Disable generating pause frames for ISP83XX

Vikas Chaudhary (26):
      qla4xxx: Update driver version to 5.03.00-k1
      qla4xxx: update copyrights in LICENSE.qla4xxx
      qla4xxx: Fix panic while rmmod
      qla4xxx: Prevent MSI/MSI-X falling back to INTx for ISP82XX
      qla4xxx: Update idc reg in case of PCI AER
      qla4xxx: Clear interrupt while unloading driver for ISP83XX
      qla4xxx: Print correct IDC version
      qla4xxx: Update driver version to 5.03.00-k0
      qla4xxx: Update Copyright header
      qla4xxx: Added support for ISP83XX
      qla4xxx: Added new function qla4_8xxx_get_minidump
      qla4xxx: Set IDC version in correct way
      qla4xxx: Replace all !is_qla8022() with is_qla40XX()
      qla4xxx: Added new functions in isp_ops
      qla4xxx: Clean-up and optimize macros
      qla4xxx: Rename 82XX macros
      qla4xxx: Update func name from ql4_ to qla4_
      qla4xxx: Update structure and variable names
      qla4xxx: Update function name from 8xxx to 82xx
      qla4xxx: Update driver version to 5.02.00-k20
      qla4xxx: Wait for cmd to complete before chip reset for ISP40XX
      qla4xxx: Clear interrupt while unloading driver.
      qla4xxx: Fix lockdep warning in qla4xxx_post_work()
      scsi_lib: Set the device state from transport-offline to running
      qla4xxx: Update driver version to 5.02.00-k19
      qla4xxx: Fix gcc warning for x86 system

sreekanth.reddy@lsi.com (8):
      mpt2sas: Bump driver vesion to 14.100.00.00
      mpt2sas: Fix for With post diag reset same set of device gets added, removed and then again gets added with new target ids
      mpt2sas: Fix for staged device discovery functionality of driver not working
      mpt2sas : MPI 2.0 Rev V(2.0.14) specification
      mpt2sas: Fix for max_sectors warning message is stating the incorrect range
      mpt2sas: Provide sysfs attribute to report Backup Rail Monitor Status
      mpt2sas: To include more Intel Branding
      mpt2sas: 2012 source code copyright

And the diffstat:

 Documentation/kernel-parameters.txt         |    3 +
 Documentation/scsi/ChangeLog.megaraid_sas   |   10 +
 Documentation/scsi/LICENSE.qla2xxx          |    2 +-
 Documentation/scsi/LICENSE.qla4xxx          |    2 +-
 Documentation/scsi/st.txt                   |    6 +-
 MAINTAINERS                                 |    8 +-
 drivers/ata/libata-core.c                   |   69 +-
 drivers/ata/libata-eh.c                     |    2 +
 drivers/message/fusion/mptbase.c            |   18 +-
 drivers/s390/scsi/zfcp_aux.c                |    1 +
 drivers/s390/scsi/zfcp_ccw.c                |   80 +-
 drivers/s390/scsi/zfcp_cfdc.c               |    2 +-
 drivers/s390/scsi/zfcp_dbf.c                |   22 +-
 drivers/s390/scsi/zfcp_dbf.h                |    1 +
 drivers/s390/scsi/zfcp_def.h                |    2 +
 drivers/s390/scsi/zfcp_erp.c                |    2 +-
 drivers/s390/scsi/zfcp_ext.h                |    4 +
 drivers/s390/scsi/zfcp_fc.c                 |   23 +-
 drivers/s390/scsi/zfcp_fsf.c                |   59 +-
 drivers/s390/scsi/zfcp_qdio.c               |   16 +-
 drivers/s390/scsi/zfcp_sysfs.c              |   18 +-
 drivers/s390/scsi/zfcp_unit.c               |   36 +-
 drivers/scsi/be2iscsi/be_cmds.c             |  160 ++-
 drivers/scsi/be2iscsi/be_cmds.h             |   27 +
 drivers/scsi/be2iscsi/be_iscsi.c            |  355 ++++--
 drivers/scsi/be2iscsi/be_main.c             |  890 +++++++++------
 drivers/scsi/be2iscsi/be_main.h             |   40 +-
 drivers/scsi/be2iscsi/be_mgmt.c             |  314 +++++-
 drivers/scsi/be2iscsi/be_mgmt.h             |   11 +
 drivers/scsi/bfa/bfa_core.c                 |   21 +-
 drivers/scsi/bfa/bfa_cs.h                   |    4 +-
 drivers/scsi/bfa/bfa_defs_fcs.h             |   18 +
 drivers/scsi/bfa/bfa_fc.h                   |   10 +
 drivers/scsi/bfa/bfa_fcbuild.c              |   21 +
 drivers/scsi/bfa/bfa_fcbuild.h              |    2 +
 drivers/scsi/bfa/bfa_fcpim.c                |   12 +-
 drivers/scsi/bfa/bfa_fcs.c                  |  182 ++-
 drivers/scsi/bfa/bfa_fcs.h                  |   66 +-
 drivers/scsi/bfa/bfa_fcs_fcpim.c            |  129 ++-
 drivers/scsi/bfa/bfa_fcs_lport.c            |  632 ++++++++++-
 drivers/scsi/bfa/bfa_fcs_rport.c            |  466 ++++++--
 drivers/scsi/bfa/bfa_ioc.c                  |   24 +-
 drivers/scsi/bfa/bfa_ioc.h                  |    2 +
 drivers/scsi/bfa/bfa_modules.h              |    1 +
 drivers/scsi/bfa/bfa_svc.c                  |   95 +-
 drivers/scsi/bfa/bfa_svc.h                  |   23 +-
 drivers/scsi/bfa/bfad.c                     |  236 +++-
 drivers/scsi/bfa/bfad_attr.c                |   46 +-
 drivers/scsi/bfa/bfad_bsg.c                 |   39 +-
 drivers/scsi/bfa/bfad_bsg.h                 |    2 +
 drivers/scsi/bfa/bfad_drv.h                 |    5 +-
 drivers/scsi/bfa/bfad_im.c                  |    9 +
 drivers/scsi/bnx2fc/bnx2fc_io.c             |    2 +-
 drivers/scsi/constants.c                    |    3 +-
 drivers/scsi/device_handler/scsi_dh_alua.c  |    3 +-
 drivers/scsi/device_handler/scsi_dh_rdac.c  |   26 +-
 drivers/scsi/hpsa.c                         |   39 +-
 drivers/scsi/ibmvscsi/Makefile              |    6 +-
 drivers/scsi/ibmvscsi/ibmvfc.c              |   36 +-
 drivers/scsi/ibmvscsi/ibmvfc.h              |    4 +-
 drivers/scsi/ibmvscsi/ibmvscsi.c            |  352 +++++-
 drivers/scsi/ibmvscsi/ibmvscsi.h            |   22 -
 drivers/scsi/ibmvscsi/rpa_vscsi.c           |  368 ------
 drivers/scsi/ipr.c                          |  234 ++--
 drivers/scsi/ipr.h                          |    5 +-
 drivers/scsi/isci/host.c                    |   24 +-
 drivers/scsi/isci/host.h                    |    2 +-
 drivers/scsi/isci/init.c                    |   59 +-
 drivers/scsi/isci/phy.c                     |    4 +-
 drivers/scsi/isci/probe_roms.c              |    1 -
 drivers/scsi/isci/remote_node_context.h     |    2 +-
 drivers/scsi/iscsi_tcp.c                    |    2 +-
 drivers/scsi/libsas/sas_ata.c               |   91 +-
 drivers/scsi/libsas/sas_discover.c          |   69 +-
 drivers/scsi/libsas/sas_dump.c              |    1 +
 drivers/scsi/libsas/sas_event.c             |    4 +-
 drivers/scsi/libsas/sas_init.c              |   90 +-
 drivers/scsi/libsas/sas_internal.h          |    1 +
 drivers/scsi/libsas/sas_phy.c               |   21 +
 drivers/scsi/libsas/sas_port.c              |   52 +-
 drivers/scsi/lpfc/lpfc.h                    |    6 +-
 drivers/scsi/lpfc/lpfc_attr.c               |   76 +-
 drivers/scsi/lpfc/lpfc_bsg.c                |    8 +-
 drivers/scsi/lpfc/lpfc_crtn.h               |    6 +-
 drivers/scsi/lpfc/lpfc_ct.c                 |   16 +-
 drivers/scsi/lpfc/lpfc_debugfs.c            |  494 ++++----
 drivers/scsi/lpfc/lpfc_debugfs.h            |   72 +-
 drivers/scsi/lpfc/lpfc_disc.h               |   10 +-
 drivers/scsi/lpfc/lpfc_els.c                |  186 +++-
 drivers/scsi/lpfc/lpfc_hbadisc.c            |   98 +-
 drivers/scsi/lpfc/lpfc_hw.h                 |   18 +-
 drivers/scsi/lpfc/lpfc_hw4.h                |   42 +-
 drivers/scsi/lpfc/lpfc_init.c               |  839 +++++++-------
 drivers/scsi/lpfc/lpfc_mbox.c               |   38 +-
 drivers/scsi/lpfc/lpfc_mem.c                |    6 +-
 drivers/scsi/lpfc/lpfc_nportdisc.c          |  127 +++
 drivers/scsi/lpfc/lpfc_scsi.c               |  144 ++-
 drivers/scsi/lpfc/lpfc_sli.c                |  621 ++++++-----
 drivers/scsi/lpfc/lpfc_sli.h                |   42 +-
 drivers/scsi/lpfc/lpfc_sli4.h               |   63 +-
 drivers/scsi/lpfc/lpfc_version.h            |    7 +-
 drivers/scsi/megaraid/megaraid_sas.h        |    8 +-
 drivers/scsi/megaraid/megaraid_sas_base.c   |   39 +-
 drivers/scsi/megaraid/megaraid_sas_fusion.c |   12 +-
 drivers/scsi/mpt2sas/Kconfig                |    2 +-
 drivers/scsi/mpt2sas/mpi/mpi2.h             |   14 +-
 drivers/scsi/mpt2sas/mpi/mpi2_init.h        |    9 +-
 drivers/scsi/mpt2sas/mpi/mpi2_ioc.h         |    8 +-
 drivers/scsi/mpt2sas/mpi/mpi2_raid.h        |    7 +-
 drivers/scsi/mpt2sas/mpt2sas_base.c         |    6 +-
 drivers/scsi/mpt2sas/mpt2sas_base.h         |   14 +-
 drivers/scsi/mpt2sas/mpt2sas_config.c       |   38 +-
 drivers/scsi/mpt2sas/mpt2sas_ctl.c          |   80 +-
 drivers/scsi/mpt2sas/mpt2sas_ctl.h          |    2 +-
 drivers/scsi/mpt2sas/mpt2sas_debug.h        |    2 +-
 drivers/scsi/mpt2sas/mpt2sas_scsih.c        |   59 +-
 drivers/scsi/mpt2sas/mpt2sas_transport.c    |    2 +-
 drivers/scsi/mvsas/mv_sas.c                 |    2 +-
 drivers/scsi/qla2xxx/qla_attr.c             |  147 ++-
 drivers/scsi/qla2xxx/qla_bsg.c              |  376 ++++++-
 drivers/scsi/qla2xxx/qla_bsg.h              |   30 +-
 drivers/scsi/qla2xxx/qla_dbg.c              |   29 +-
 drivers/scsi/qla2xxx/qla_dbg.h              |    2 +-
 drivers/scsi/qla2xxx/qla_def.h              |  166 ++-
 drivers/scsi/qla2xxx/qla_dfs.c              |    2 +-
 drivers/scsi/qla2xxx/qla_fw.h               |   49 +-
 drivers/scsi/qla2xxx/qla_gbl.h              |   39 +-
 drivers/scsi/qla2xxx/qla_gs.c               |    4 +-
 drivers/scsi/qla2xxx/qla_init.c             |  565 ++++++++--
 drivers/scsi/qla2xxx/qla_inline.h           |   28 +-
 drivers/scsi/qla2xxx/qla_iocb.c             |  261 ++++-
 drivers/scsi/qla2xxx/qla_isr.c              |  437 +++++++-
 drivers/scsi/qla2xxx/qla_mbx.c              |  224 +++-
 drivers/scsi/qla2xxx/qla_mid.c              |    5 +-
 drivers/scsi/qla2xxx/qla_nx.c               |  153 +--
 drivers/scsi/qla2xxx/qla_nx.h               |   17 +-
 drivers/scsi/qla2xxx/qla_os.c               |  770 ++++++++++++-
 drivers/scsi/qla2xxx/qla_settings.h         |    2 +-
 drivers/scsi/qla2xxx/qla_sup.c              |   67 +-
 drivers/scsi/qla2xxx/qla_version.h          |    6 +-
 drivers/scsi/qla4xxx/Kconfig                |    4 +-
 drivers/scsi/qla4xxx/Makefile               |    2 +-
 drivers/scsi/qla4xxx/ql4_83xx.c             | 1611 +++++++++++++++++++++++++++
 drivers/scsi/qla4xxx/ql4_83xx.h             |  283 +++++
 drivers/scsi/qla4xxx/ql4_attr.c             |   26 +-
 drivers/scsi/qla4xxx/ql4_dbg.c              |   32 +-
 drivers/scsi/qla4xxx/ql4_dbg.h              |    2 +-
 drivers/scsi/qla4xxx/ql4_def.h              |   65 +-
 drivers/scsi/qla4xxx/ql4_fw.h               |   59 +-
 drivers/scsi/qla4xxx/ql4_glbl.h             |   94 +-
 drivers/scsi/qla4xxx/ql4_init.c             |   23 +-
 drivers/scsi/qla4xxx/ql4_inline.h           |    2 +-
 drivers/scsi/qla4xxx/ql4_iocb.c             |   28 +-
 drivers/scsi/qla4xxx/ql4_isr.c              |  406 +++++--
 drivers/scsi/qla4xxx/ql4_mbx.c              |  186 ++--
 drivers/scsi/qla4xxx/ql4_nvram.c            |    2 +-
 drivers/scsi/qla4xxx/ql4_nvram.h            |    2 +-
 drivers/scsi/qla4xxx/ql4_nx.c               | 1432 ++++++++++++++++--------
 drivers/scsi/qla4xxx/ql4_nx.h               |  198 ++--
 drivers/scsi/qla4xxx/ql4_os.c               |  494 +++++---
 drivers/scsi/qla4xxx/ql4_version.h          |    4 +-
 drivers/scsi/scsi_debug.c                   |   30 +-
 drivers/scsi/scsi_devinfo.c                 |    1 +
 drivers/scsi/scsi_lib.c                     |    3 +-
 drivers/scsi/scsi_scan.c                    |    3 +
 drivers/scsi/scsi_sysfs.c                   |   30 +-
 drivers/scsi/sd.c                           |   80 +-
 drivers/scsi/sd.h                           |    2 +-
 drivers/scsi/sd_dif.c                       |   25 +-
 drivers/scsi/st.c                           |  416 +++----
 drivers/scsi/st.h                           |    5 +-
 include/linux/libata.h                      |   15 +-
 include/linux/pci_ids.h                     |    1 +
 include/scsi/libsas.h                       |   20 +-
 include/scsi/sas_ata.h                      |   10 +
 include/scsi/scsi_bsg_fc.h                  |    2 -
 include/scsi/scsi_device.h                  |    4 +
 include/scsi/scsi_devinfo.h                 |    1 +
 include/scsi/scsi_host.h                    |    6 +
 179 files changed, 13497 insertions(+), 4465 deletions(-)
 delete mode 100644 drivers/scsi/ibmvscsi/rpa_vscsi.c
 create mode 100644 drivers/scsi/qla4xxx/ql4_83xx.c
 create mode 100644 drivers/scsi/qla4xxx/ql4_83xx.h

James



