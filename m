From: James Bottomley <James.Bottomley@suse.de>
Subject: [GIT PULL] First round of SCSI updates for the 2.6.32 merge window
Date: Sat, 12 Sep 2009 13:36:30 -0500
Message-ID: <1252780590.4238.227.camel@mulgrave.site>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from cantor.suse.de ([195.135.220.2]:44797 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754845AbZILShM (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Sat, 12 Sep 2009 14:37:12 -0400
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Andrew Morton <akpm@linux-foundation.org>, Linus Torvalds <torvalds@linux-foundation.org>
Cc: linux-scsi <linux-scsi@vger.kernel.org>, linux-kernel <linux-kernel@vger.kernel.org>

This is basically a slew of updates to the usual suspects (including a
huge update to the fcoe driver) plus a new driver: pmcraid.  This has
all been through a linux-next cycle for a few rounds and a couple of
problem patches detected either fixed or removed for later submission.

The patch is available here:

master.kernel.org:/pub/scm/linux/kernel/git/jejb/scsi-misc-2.6.git

The short changelog is:

Andrew Vasquez (8):
      qla2xxx: Properly delete rports attached to a vport.
      qla2xxx: Correct various NPIV issues.
      qla2xxx: Further limit device-table (qla_devtbl) lookup to non-24xx.
      qla2xxx: Add asynchronous-login support.
      qla2xxx: Generalize srb structure usage.
      qla2xxx: Correct display of vp_count in debug printk.
      qla2xxx: ISP21xx/22xx do not support FDMI registrations.
      qla2xxx: Correctly handle 'global port-unavailable' AEN.

Anil Ravindranath (1):
      pmcraid: PMC-Sierra MaxRAID driver to support 6Gb/s SAS RAID controller

Anil Veerabhadrappa (6):
      bnx2i : Fix "cid #n not valid" issue
      bnx2i : Fix command session number jump issue seen during cable pull test
      bnx2i: register given device with cnic if shost != NULL in ep_connect()
      bnx2i: convert bnx2i_dev_lock to mutex
      bnx2i: bug fixes in bnx2i_init_one to handle error conditions
      bnx2i: remove global variable bnx2i_reg_devices

Anirban Chakraborty (2):
      qla2xxx: Fix to ensure driver works in sinlge queue mode if multiqueue fails
      qla2xxx: Fix a bug that clears the interrupt status register for the base queue

Bart Van Assche (1):
      libsrp: fix memory leak in srp_ring_free()

Brian King (1):
      ipr: fix buffer overflow

Chandra Seetharaman (5):
      scsi_dh: add two SUN devices to the list of devices supported by default
      scsi_dh: Use scsi_dh_set_params() in multipath.
      scsi_dh: Provide set_params interface in emc device handler
      scsi_dh: add the interface scsi_dh_set_params()
      scsi_dh: Reference count scsi_dh_attach

Charlie Brady (1):
      scsi_dh_rdac: Add support for Sun StorageTek ST2500, ST2510 and ST2530

Chris Leech (15):
      fcoe: use rtnl mutex in place of hostlist lock
      fcoe: Fix module ref count bug by adding NETDEV UNREGISTER handling
      fcoe: move the host-list add/remove to keep out VN_Ports
      fcoe: add mutex to protect create and destroy
      fcoe: split out per interface setup
      fcoe: fcoe_interface create, destroy and refcounting
      fcoe: remove fcoe_interface->priv pointer
      fcoe: move offload exchange manager pointer from fcoe_port to fcoe_interface
      fcoe: move FIP controller from fcoe_port to fcoe_interface
      fcoe: move packet handlers from fcoe_port to fcoe_interface
      fcoe: move netdev to fcoe_interface
      fcoe: Introduce and allocate fcoe_interface structure, 1:1 with net_device
      fcoe: interface changes to fcoe_if_create and fcoe_if_destroy
      fcoe: fix missing error check in call to fcoe_if_init
      libfcoe: fcoe_ctlr_destroy use cancel_work_sync instead of flush_work

Christof Schmitt (13):
      zfcp: Remove duplicated code for debug timestamps
      zfcp: Handle failures during device allocation correctly
      zfcp: Replace config semaphore with mutex
      zfcp: Defer resource allocation to first ccw_set_online call
      zfcp: Simplify and update ct/gs and els timeout handling
      zfcp: Use kthread API for zfcp erp thread
      zfcp: Decouple gid_pn requests from erp
      zfcp: Implicitly close all wka ports
      zfcp: Only issue one test link command per port
      zfcp: Remove useless assignment
      zfcp: Only collect FSF/HBA debug data for matching trace levels
      zfcp: Only collect SCSI debug data for matching trace levels
      zfcp: Move debug data from zfcp_data to own data structure

Dave Jones (1):
      qla2xxx: Fix __LITTLE_ENDIAN definition warnings

Davidlohr Bueso A (1):
      ch: Check NULL for kmalloc() return

Douglas Gilbert (1):
      update scsi/constants.c

Ed Lin (1):
      stex: Add reset code for st_yel (v2)

Giridhar Malavali (2):
      qla2xxx: Update version number to 8.03.01-k6.
      qla2xxx: Update version number to 8.03.01-k5

Hannes Reinecke (1):
      iscsi_tcp: Evaluate socket state in data_ready()

Heiko Carstens (1):
      zfcp: optimize zfcp_qdio_account

James Bottomley (7):
      fix oops during scsi scanning
      update MAINTAINERS with new email
      fix bugs in scsi_vpd_inquiry()
      ses: update enclosure data on hot add
      ses: add support for enclosure component hot removal
      ses: fix hotplug with multiple devices and expanders
      scsi_transport_sas: fix incorrect duplicate setup of max_phys

James Smart (9):
      fc_transport: Correct max fc_host attribute count
      lpfc 8.3.4: Update driver version to 8.3.4
      lpfc 8.3.4: Remove spaces before newlines in several log messages
      lpfc 8.3.4: Add bsg (SGIOv4) support for ELS/CT support
      lpfc 8.3.4: NPIV vport fixes
      lpfc 8.3.4: Fix a pair of FCoE issues
      lpfc 8.3.4: Various SLI3 fixes
      lpfc 8.3.4: Consistently Implement persistent port disable
      lpfc 8.3.4: Various SLI4 fixes

Jiri Slaby (2):
      nsp_cs: fix buf overflow
      lpfc: don't dereference NULL

Joe Eykholt (51):
      fcoe: flush per-cpu thread work when destroying interface
      libfc: don't swap OX_ID and RX_ID when sending BA_RJT
      libfc: send GPN_ID in reaction to single-port RSCNs.
      libfc: fix handling of incoming Discover Address (ADISC) requests
      libfc: use ADISC to verify rport login state
      libfc: LOGO response code had extraeous enter_rtv
      libfc: re-login to remote ports that send us LOGO
      libfc: fix rport error handling for login-required and invalid ops
      libfc: correctly handle incoming PLOGI request.
      libfc: improve debug messages for ELS response handlers
      libfc: fix: rport_recv_req needs disc_mutex when calling rport_lookup
      libfc: move remote port lookup for ELS requests into fc_rport.c.
      libfc: don't do discovery before callback is set
      libfc: clean up point-to-point discovery code.
      libfc: discovery gpn_ft parse bug
      libfc: discovery retry should clear pending first.
      libfc: fix: empty zone causes endless discovery retries.
      libfc: handle discovery failure more correctly.
      libfc: rearrange code in fc_disc_gpn_ft_resp()
      libfc: discovery restart sequence error fix
      libfc: do not log off rports before or after discovery
      libfc: move rport_lookup into fc_rport.c
      libfc: change to make remote port callback optional
      libfc: have rport_create do a lookup for pre-existing rports first
      libfc: make rport module maintain the rport list
      libfc: simplify fc_lport_rport_callback
      libfc: rport debug messages were printing pointer values
      libfc: remove unused disc->delay element
      libfc: eliminate disc->event
      libfc: fix rport event race between READY and LOGO
      libfc: don't create dummy (rogue) remote ports
      libfc: rename rport event CREATED to READY
      libfc: rearrange code in fc_rport_work
      libfc: make rport structure optional
      libfc: change elsct to use FC_ID instead of rdata
      libfc: make fc_rport_priv the primary rport interface.
      libfc: fix RPORT_TO_PRIV and PRIV_TO_RPORT() macros.
      libfc: change interface for rport_create
      libfc: prepare to split off struct fc_rport_priv from fc_rport_libfc_priv
      fcoe: remove unnecessary list and lock initializations.
      fcoe: libfcoe: extra semicolon in CHECK_LOGGING macros causes compile error
      libfc: fix: cancel rport retry timer
      libfc: fc_rport_logoff should not drop the lock
      libfc: rename rport state "NONE" to "DELETE".
      libfc: fix WARNING from fc_seq_start_next on closed exchanges
      libfc: in fc_lport_destroy, flush rports after turning off link
      libfc: stop login after fabric logoff
      libfc: rename lport NONE state to DISABLED
      fcoe: stop delivery of received frames before doing lport_destroy()
      libfc: change debug messages to give host number.
      libfc: remove extra semicolons from debug macros

Johannes Berg (1):
      fcoe: convert to %pM

Kashyap, Desai (20):
      mptsas : Bump version to 3.04.12
      mptsas : FW event thread and scsi mid layer deadlock in SYNCHRONIZE CACHE command
      mptsas : Send DID_NO_CONNECT for pending IOs of removed device
      mptsas : PAE Kernel more than 4 GB kernel panic
      mptsas : NULL pointer on big endian systems causing Expander not to tear off
      mptsas : Sanity check for phyinfo is added
      mpt2sas: Bump driver version 01.100.06.00
      mpt2sas: cleanup interrupt routine and config_request optimization
      mpt2sas: Raid 10 Volume is showing as Raid 1E in dmesg
      mpt2sas: setting SDEV into RUNNING state from Interrupt context
      mpt2sas: Removed wrapper funtions _scsih_link_change.
      mpt2sas: Prevent sending command to FW while Host Reset
      mpt2sas : Rescan topology from Interrupt context instead of work thread
      mptsas : Bump version to 3.04.11
      mptsas : Code cleanup of host page alloc and diag reset.
      mptsas : set max_id to infinite value.
      mptsas : Change config request timeout value to 30 seconds.
      mptsas : Handle INSUFFICIENT resources status as similar to IOC BUSY status
      mptsas : Removed mptscsih_timer_expired.
      mptsas : Change DEFINED value of can queue for FC and SAS devices.

Lalit Chandivade (2):
      qla2xxx: Correct qla2x00_eh_wait_on_command() to wait correctly.
      qla2xxx: Process DPC requests within valid Fabric topologies.

Martin K. Petersen (1):
      Print failed commands

Michael Reed (1):
      reservation conflict after timeout causes device to be taken offline

Michal Schmidt (1):
      sg: fix oops in the error path in sg_build_indirect()

Mike Christie (9):
      libiscsi, bnx2i: make bound ep check common
      libiscsi: add completion function for drivers that do not need pdu processing
      libiscsi, iscsi_tcp: check suspend bit before each call to xmit_task
      iscsi_tcp: add new conn error to indicate tcp conn closed
      iscsi class: Add logging to scsi_transport_iscsi.c
      qla4xxx: Removed residual from overrun debug print
      libiscsi: handle immediate command rejections
      libiscsi: don't increment cmdsn if cmd is not sent
      ALUA: send STPG if explicit and implicit is supported

Moger, Babu (3):
      scsi_dh_rdac: changes for rdac debug logging
      scsi_dh_rdac: changes to collect the rdac debug information during the initialization
      scsi_dh_rdac: move the init code from rdac_activate to rdac_bus_attach

Randy Dunlap (1):
      scsi_transport_fc: fix kernel-doc param name

Ravi Anand (1):
      qla2xxx: Pass the command's data residual to upper-layer callers.

Robert Love (5):
      libfc: Always reset remote port roles when receiving PRLI
      libfc: Initialize fc_rport_identifiers inside fc_rport_create
      libfc: Fix misleading debug statement
      fcoe: Add format spacing to FCOE_NETDEV_DBG debug macro
      libfc: Remove the FC_EM_DBG macro

Sage Weil (1):
      ibmvscsi: avoid unnecessary use of kzalloc_pool

Santosh Vernekar (4):
      qla2xxx: Correctly set FCF_TAPE_PRESENT flag based on scsi-device.
      qla2xxx: Handle RSCN's per master/slave vn-port basis.
      qla2xxx: Mark all devices lost on loss of fc port.
      qla2xxx: Skip RSCN processing on vha if event is global.

Sebastian Ott (1):
      zfcp: proper use of device register

Shyam Sundar (1):
      qla2xxx: Pad IOCB structure for size requirements.

Swen Schillig (12):
      zfcp: resolve false usage of dd_data in fc_rport
      zfcp: Apply common naming conventions to zfcp_fc
      zfcp: introduce _setup, _destroy for qdio and FC
      zfcp: Update dbf calls
      zfcp: Move qdio related data out of zfcp_adapter
      zfcp: Separate qdio attributes from zfcp_fsf_req
      zfcp: Move workqueue to adapter struct
      zfcp: Remove the useless ZFCP_REQ_AUTO_CLEANUP flag
      zfcp: Improve request allocation through mempools
      zfcp: Replace fsf_req wait_queue with completion
      zfcp: fix layering oddities between zfcp_fsf and zfcp_qdio
      zfcp: invalid usage after free of port resources

Vasu Dev (7):
      fcoe, libfc: fully makes use of per cpu exch pool and then removes em_lock
      fcoe, libfc: adds per cpu exch pool within exchange manager(EM)
      fcoe: removes phys_dev and renames real_dev to netdev.
      fcoe, libfc: adds offload EM per eth device with only single xid range per EM
      fcoe: modifies fcoe_hostlist_lock uses as prep work to add shared offload EM
      fcoe, fnic, libfc: modifies current code paths to use EM anchor list
      fcoe, libfc: adds exchange manager(EM) anchor list per lport and related APIs

Yanqing_Liu@Dell.com (1):
      scsi_dh_rdac: add support for next generation of Dell PV array

Yi Zou (7):
      fcoe: Add sysfs parameter to fcoe for minimum DDP read I/O size
      libfc: Remove page flags check for sglist
      libfc: Remove FC_FRAME_SG_LEN in fc_fcp_send_data
      fcoe: Remove ifdef for NETIF_F_FCOE_CRC and NETIF_F_FSO
      fcoe: Call dev_ethtool_get_settings() in fcoe_link_ok
      libfcoe: Set fip_flags according to fcf and lport's capability of SPMA support
      fcoe: Fix validation of mac address when checking for spma support

And the diffstat:

 MAINTAINERS                                |   10 
 arch/s390/include/asm/timex.h              |    8 
 arch/s390/kernel/debug.c                   |    8 
 arch/s390/kernel/time.c                    |    1 
 drivers/md/dm-mpath.c                      |   42 
 drivers/message/fusion/mptbase.c           |   94 
 drivers/message/fusion/mptbase.h           |   21 
 drivers/message/fusion/mptfc.c             |   19 
 drivers/message/fusion/mptsas.c            |   62 
 drivers/message/fusion/mptscsih.c          |   67 
 drivers/message/fusion/mptscsih.h          |    1 
 drivers/message/fusion/mptspi.c            |   21 
 drivers/misc/enclosure.c                   |   69 
 drivers/s390/scsi/zfcp_aux.c               |  288 -
 drivers/s390/scsi/zfcp_ccw.c               |   94 
 drivers/s390/scsi/zfcp_dbf.c               |  544 +-
 drivers/s390/scsi/zfcp_dbf.h               |  175 
 drivers/s390/scsi/zfcp_def.h               |  183 
 drivers/s390/scsi/zfcp_erp.c               |  155 
 drivers/s390/scsi/zfcp_ext.h               |  102 
 drivers/s390/scsi/zfcp_fc.c                |  176 
 drivers/s390/scsi/zfcp_fsf.c               |  635 +--
 drivers/s390/scsi/zfcp_fsf.h               |    3 
 drivers/s390/scsi/zfcp_qdio.c              |  369 -
 drivers/s390/scsi/zfcp_scsi.c              |   73 
 drivers/s390/scsi/zfcp_sysfs.c             |   34 
 drivers/scsi/Kconfig                       |    6 
 drivers/scsi/Makefile                      |    1 
 drivers/scsi/bnx2i/bnx2i_init.c            |  100 
 drivers/scsi/bnx2i/bnx2i_iscsi.c           |   13 
 drivers/scsi/ch.c                          |    6 
 drivers/scsi/constants.c                   |   95 
 drivers/scsi/device_handler/scsi_dh.c      |   56 
 drivers/scsi/device_handler/scsi_dh_alua.c |    2 
 drivers/scsi/device_handler/scsi_dh_emc.c  |   59 
 drivers/scsi/device_handler/scsi_dh_rdac.c |  116 
 drivers/scsi/fcoe/fcoe.c                   | 1078 +++--
 drivers/scsi/fcoe/fcoe.h                   |   36 
 drivers/scsi/fcoe/libfcoe.c                |   30 
 drivers/scsi/fnic/fnic_fcs.c               |    2 
 drivers/scsi/fnic/fnic_main.c              |   20 
 drivers/scsi/ibmvscsi/ibmvfc.c             |    2 
 drivers/scsi/ipr.h                         |    2 
 drivers/scsi/iscsi_tcp.c                   |   31 
 drivers/scsi/libfc/fc_disc.c               |  523 +-
 drivers/scsi/libfc/fc_elsct.c              |   49 
 drivers/scsi/libfc/fc_exch.c               |  515 +-
 drivers/scsi/libfc/fc_fcp.c                |   31 
 drivers/scsi/libfc/fc_lport.c              |  283 -
 drivers/scsi/libfc/fc_rport.c              | 1144 +++--
 drivers/scsi/libiscsi.c                    |  201 -
 drivers/scsi/libsrp.c                      |    1 
 drivers/scsi/lpfc/Makefile                 |    2 
 drivers/scsi/lpfc/lpfc.h                   |   19 
 drivers/scsi/lpfc/lpfc_attr.c              |   10 
 drivers/scsi/lpfc/lpfc_bsg.c               |  904 ++++
 drivers/scsi/lpfc/lpfc_crtn.h              |   18 
 drivers/scsi/lpfc/lpfc_ct.c                |    2 
 drivers/scsi/lpfc/lpfc_els.c               |    2 
 drivers/scsi/lpfc/lpfc_hbadisc.c           |  259 +
 drivers/scsi/lpfc/lpfc_hw.h                |    4 
 drivers/scsi/lpfc/lpfc_hw4.h               |   74 
 drivers/scsi/lpfc/lpfc_init.c              |  134 
 drivers/scsi/lpfc/lpfc_mbox.c              |   93 
 drivers/scsi/lpfc/lpfc_mem.c               |   41 
 drivers/scsi/lpfc/lpfc_nl.h                |   20 
 drivers/scsi/lpfc/lpfc_scsi.c              |    7 
 drivers/scsi/lpfc/lpfc_sli.c               |  263 +
 drivers/scsi/lpfc/lpfc_sli4.h              |    5 
 drivers/scsi/lpfc/lpfc_version.h           |    2 
 drivers/scsi/lpfc/lpfc_vport.c             |   53 
 drivers/scsi/mpt2sas/mpt2sas_base.c        |   96 
 drivers/scsi/mpt2sas/mpt2sas_base.h        |   51 
 drivers/scsi/mpt2sas/mpt2sas_config.c      |  904 +---
 drivers/scsi/mpt2sas/mpt2sas_ctl.c         |   16 
 drivers/scsi/mpt2sas/mpt2sas_scsih.c       |  252 -
 drivers/scsi/mpt2sas/mpt2sas_transport.c   |   33 
 drivers/scsi/pcmcia/nsp_cs.c               |    2 
 drivers/scsi/pmcraid.c                     | 5604 +++++++++++++++++++++++++++++
 drivers/scsi/pmcraid.h                     | 1029 +++++
 drivers/scsi/qla2xxx/qla_attr.c            |    9 
 drivers/scsi/qla2xxx/qla_def.h             |   39 
 drivers/scsi/qla2xxx/qla_fw.h              |    2 
 drivers/scsi/qla2xxx/qla_gbl.h             |   20 
 drivers/scsi/qla2xxx/qla_gs.c              |    4 
 drivers/scsi/qla2xxx/qla_init.c            |  239 +
 drivers/scsi/qla2xxx/qla_iocb.c            |  206 +
 drivers/scsi/qla2xxx/qla_isr.c             |  309 +
 drivers/scsi/qla2xxx/qla_mbx.c             |    7 
 drivers/scsi/qla2xxx/qla_mid.c             |   27 
 drivers/scsi/qla2xxx/qla_os.c              |  141 
 drivers/scsi/qla2xxx/qla_version.h         |    2 
 drivers/scsi/qla4xxx/ql4_isr.c             |    8 
 drivers/scsi/scsi.c                        |   13 
 drivers/scsi/scsi_error.c                  |    6 
 drivers/scsi/scsi_lib.c                    |    1 
 drivers/scsi/scsi_transport_fc.c           |    4 
 drivers/scsi/scsi_transport_iscsi.c        |   73 
 drivers/scsi/scsi_transport_sas.c          |    4 
 drivers/scsi/sd.c                          |    2 
 drivers/scsi/ses.c                         |  209 -
 drivers/scsi/sg.c                          |    2 
 drivers/scsi/stex.c                        |   33 
 include/linux/enclosure.h                  |    5 
 include/scsi/fc/fc_gs.h                    |    1 
 include/scsi/fc_encode.h                   |   60 
 include/scsi/fc_frame.h                    |    7 
 include/scsi/iscsi_if.h                    |    1 
 include/scsi/libfc.h                       |  244 -
 include/scsi/libiscsi.h                    |    3 
 include/scsi/scsi_device.h                 |    3 
 include/scsi/scsi_dh.h                     |    5 
 112 files changed, 14377 insertions(+), 4867 deletions(-)

James


