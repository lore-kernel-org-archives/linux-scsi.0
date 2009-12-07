From: James Bottomley <James.Bottomley@suse.de>
Subject: [GIT PULL] first set of SCSI updates for the 2.6.33 merge window
Date: Mon, 07 Dec 2009 10:12:18 -0600
Message-ID: <1260202339.2834.6.camel@mulgrave.site>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from cantor.suse.de ([195.135.220.2]:43043 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932705AbZLGQMY (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Mon, 7 Dec 2009 11:12:24 -0500
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Andrew Morton <akpm@linux-foundation.org>, Linus Torvalds <torvalds@linux-foundation.org>
Cc: linux-scsi <linux-scsi@vger.kernel.org>, linux-kernel <linux-kernel@vger.kernel.org>

This is the first tranche of SCSI updates.  It's mainly a slew of driver
updates (all the usual suspects: qla, fcoe, lpfc etc) plus a new 3ware
SAS and VMware emulated SCSI).

The patch is available from

master.kernel.org:/pub/scm/linux/kernel/git/jejb/scsi-misc-2.6.git

It's been well tested and integrated in linux-next, so there should be
no merge surprises.

The short changelog is:

Abhijeet Joglekar (4):
      fnic: Allocate OS interrupt resources just before enabling interrupts
      fnic: Pad the unused bytes of CDB to 0s
      fnic: Set max_cmd_len to driver supported CDB length
      fnic: Process all cq entries per ISR

Adam Radford (1):
      3w-sas: Add new driver for LSI 3ware 9750

Alok Kataria (1):
      vmw_pvscsi: SCSI driver for VMware's virtual HBA.

Andrew Vasquez (5):
      qla2xxx: Properly re-register FC4/FDMI after physical and logical link disruptions.
      qla2xxx: Properly check FCP_RSP response-info field after TMF completion.
      qla2xxx: Retrieve firmware's maximum number of supported FCFs.
      qla2xxx: Display additional mailbox registers during AEN handling.
      qla2xxx: Add firmware-dump kobject uevent notification.

Boaz Harrosh (8):
      libosd: Error handling revamped
      libosd: Bugfix of error handling in attributes-list decoding
      libosd: bug in osd_req_decode_sense_full()
      libosd: osd_dev_info: Unique Identification of an OSD device
      osduld: Use device->release instead of internal kref
      osduld: Ref-counting bug fix
      libosd: osd_sense: OSD_CFO_PERMISSIONS
      libosd: osd_dev_is_ver1 - Minor API cleanup

Brian King (6):
      ibmvfc: Driver version 1.0.7
      ibmvfc: Add FC Passthru support
      ibmvfc: Fix adapter cancel flags for terminate_rport_io
      ibmvfc: Remove unnecessary parameter to ibmvfc_init_host
      ibmvfc: Fix locking in ibmvfc_remove
      ibmvfc: Fixup TMF response handling

Chandra Seetharaman (5):
      scsi_dh: create sysfs file, dh_state for all SCSI disk devices
      scsi_dh: Make alua hardware handler's activate() async
      scsi_dh: Make hp hardware handler's activate() async
      scsi_dh: Make rdac hardware handler's activate() async
      scsi_dh: Change the scsidh_activate interface to be asynchronous

Chris Leech (17):
      fcoe: allow SCSI-FCP to be processed directly in softirq context
      libfc, fcoe: fixes for highmem skb linearize panics
      fcoe: vport symbolic name support
      libfc: combine name server registration request functions
      libfc: combine name server registration response handlers
      libfc: Register Symbolic Port Name (RSPN_ID)
      libfc: Register Symbolic Node Name (RSNN_NN)
      libfc: RNN_ID may be required before RSNN_NN with some switches
      libfc: RPN_ID is obsolete and unnecessary
      fcoe: NPIV vport create/destroy
      fcoe: add a separate scsi transport template for NPIV vports
      libfcoe, fcoe: libfcoe NPIV support
      libfc, libfcoe: FDISC ELS for NPIV
      libfc: vport link handling and fc_vport state managment
      libfc: add some generic NPIV support routines to libfc
      libfc: changes to libfc_host_alloc to consolidate initialization with allocation
      libfc: fix memory corruption caused by double frees and bad error handling

Christof Schmitt (18):
      zfcp: Remove flag ZFCP_STATUS_FSFREQ_TMFUNCNOTSUPP
      zfcp: Activate fc4s attributes for zfcp in FC transport class
      zfcp: Block scsi_eh thread for rport state BLOCKED
      zfcp: Update FSF error reporting
      zfcp: Improve ELS ADISC handling
      zfcp: Simplify handling of ct and els requests
      zfcp: Remove ZFCP_DID_MASK
      zfcp: Move WKA port to zfcp FC code
      zfcp: Use common code definitions for FC CT structs
      zfcp: Use common code definitions for FC ELS structs
      zfcp: Update FCP protocol related code
      zfcp: Dont fail SCSI commands when transitioning to blocked fc_rport
      zfcp: Implement module unloading
      zfcp: Merge trace code for fsf requests in one function
      zfcp: Access ports and units with container_of in sysfs code
      libfc: Add target reset flag to FCP header file
      scsi_transport_fc: Introduce helper function for blocking scsi_eh
      zfcp: Adapt change_queue_depth for queue full tracking

Douglas Gilbert (1):
      scsi_debug: fix Thin provisioning support

Ed Lin (3):
      stex: update version to 4.6.0000.4
      stex: add support for reset request from firmware
      stex: add small dma buffer support

Giridhar Malavali (2):
      qla2xxx: Update version number to 8.03.01-k7
      qla2xxx: Set the size of the host buffer used to fetch DCBX and XGMAC parameters to 4K.

James Bottomley (1):
      scsi_lib_dma: fix bug with dma maps on nested scsi objects

James Smart (12):
      lpfc 8.3.6 : Update lpfc driver version to 8.3.6
      lpfc 8.3.6 : Hardware related fixes and changes
      lpfc 8.3.6 : Fix critical errors
      lpfc 8.3.6 : Fix AER issues
      lpfc 8.3.6 : FC Protocol Fixes
      lpfc 8.3.6 : FCoE Protocol Fixes
      lpfc 8.3.5: Update the lpfc driver version to 8.3.5
      lpfc 8.3.5: fix fcp command polling, add FIP mode, performance optimisations and devloss timout fixes
      lpfc 8.3.5: Add AER support
      lpfc 8.3.5: fix sysfs parameters, vport creation and other bugs and update logging
      lpfc 8.3.5: fix VPI registration, error clean up and add support for vlink events
      lpfc 8.3.5: fix reset path, ELS ordering and discovery issues

Jayamohan Kallickal (2):
      be2iscsi: Adding Ring Mode Wrb's V3
      be2iscsi: Adding msix and mcc_rings V3

Jing Huang (1):
      bfa: fixed checkpatch errors for bfad files

Jiri Slaby (1):
      scsi_lib: fix potential NULL dereference

Joe Eykholt (19):
      libfc fcoe: increase ELS and CT timeouts
      fnic: enable bsg pass-thru for fcping
      libfc: register FC4 features with the FC switch
      fnic: Add FIP support to the fnic driver
      libfcoe: fcoe: simplify receive FLOGI response
      libfc: add host number to lport link up/down messages.
      libfc: add set_fid function to libfc template
      libfc: fix fc_els_resp_type to correct display of CT responses
      libfc: fix symbolic name registrations smashing skb data
      libfc: fix RNN_ID smashing skb payload
      libfcoe: don't send ELS in FIP mode if no FCF selected
      libfcoe: FIP should report link to libfc whether selected or not
      libfcoe: fip: allow FIP receive to be called from IRQ.
      libfcoe: fip: use SCSI host number to identify debug messages.
      libfcoe: Allow FIP to be disabled by the driver
      libfc: fix free of fc_rport_priv with timer pending
      libfc: don't WARN_ON in lport_timeout for RESET state
      libfc: lport: fix minor documentation errors
      libfc: fix typo in retry check on received PRLI

Kashyap, Desai (23):
      mptfusion: Bump version to 3.04.13
      mptspi: Fix for incorrect data underrun errata
      mptctl : Remove printk which floods unnecessary messages to var/log/message
      mpt2sas: Bump version 03.100.03.00
      mpt2sas: No link rate change, do not call update links nor unblock device
      mpt2sas : Add support for RAID Action System Shutdown Initiated at OS shutdown
      mpt2sas: Freeze the sdev IO queue when firmware sends internal dev reset
      mpt2sas : PPC (power pc) endian bug fix's
      mpt2sas: mpt2sas_base_get_sense_buffer_dma should be returning little endian
      mpt2sas: Return DID_TRANSPORT_DISRUPTED in nexus loss,SCSI_MLQUEUE_DEVICE_BUSY if device is busy
      mpt2sas: Retrieve the ioc facts prior to putting the controller into READY state
      mpt2sas: Added new info messages for IR and Expander events.
      mpt2sas: Limit the max_depth to 32 for SATA devices which are not part of volume
      mpt2sas: Added support to set the TimeStamp when sending ioc_init
      mpt2sas: Add Extended Type for Diagnostic Buffer support
      mpt2sas: Added command line option diag_buffer_enable.
      mpt2sas: Fixed some of the comment
      mpt2sas: Support for stopping driver when Firmware encounters
      mpt2sas: Adding MPI Headers - revision L
      mpt2sas: New device SAS2208 support is added
      mpt2sas: Add support in the driver to check for valid response info
      mpt2sas: Expander remove fails when it is processing another expander add.
      mpt2sas: Driver will use sas address instead of handle as a lookup

Lalit Chandivade (2):
      qla2xxx: Properly handle UNDERRUN completion statuses.
      qla2xxx: Reread firmware versions information after an ISP abort.

Martin K. Petersen (2):
      scsi_debug: Thin provisioning support
      scsi: Add missing command definitions

Martin Michlmayr (1):
      osd_protocol.h: Add missing #include

Michael Reed (1):
      scsi_transport_fc: remove invalid BUG_ON

Mike Christie (15):
      libiscsi: hook into ramp up/down handling
      iser: set tgt and lu reset timeout
      iscsi class: modify handling of replacement timeout
      libiscsi: add warm target reset tmf support
      libiscsi: Check TMF state before sending PDU
      libiscsi: fix login/text checks in pdu injection code
      bnx2i: use common iscsi suspend queue
      add scsi target reset support to scsi ioctl
      fc class: fail fast bsg requests
      libfc: do not use DID_NO_CONNECT for pkt alloc failures.
      libfc: convert to scsi_track_queue_full
      scsi error: have scsi-ml call change_queue_depth to handle QUEUE_FULL
      modify change_queue_depth to take in reason why it is being called
      fcoe: initialize return value in fcoe_destroy
      fix propogation of integrity errors

Randy Dunlap (1):
      fix func names in kernel-doc

Robert Love (12):
      fcoe: Formatting cleanups and commenting
      libfcoe: formatting and comment cleanups
      libfc: Formatting cleanups across libfc
      libfc: Add routine to copy data from a buffer to a SG list
      libfc: Export FC headers
      libfc: Move libfc_init and libfc_exit to fc_libfc.c
      libfc: Add libfc/fc_libfc.[ch] for libfc internal routines
      libfc: Remove fc_fcp_complete
      libfc: Move non-common routines and prototypes out of libfc.h
      fcoe: Increase FCOE_MAX_LUN to 0xFFFF (65535)
      libfc: Remove unused fc_lport pointer from fc_fcp_pkt_abort
      libfc, fcoe: Don't EXPORT_SYMBOLS unnecessarily

Roel Kluin (2):
      st: fix test of value range in st_set_options()
      qlogicpti: add missing parentheses

Steve Ma (1):
      libfc, fcoe: Add FC passthrough support

Swen Schillig (6):
      zfcp: Assign scheduled work to driver queue
      zfcp: Remove STATUS_COMMON_REMOVE flag as it is not required anymore
      zfcp: Remove suspend callback
      zfcp: Remove global config_mutex
      zfcp: Replace local reference counting with common kref
      zfcp: Replace global config_lock with local list locks

Takahiro Yasui (1):
      scsi_devinfo: update Hitachi entries (v2)

Vasu Dev (10):
      libfc: fix an issue of pending exch/es after i/f destroyed or rmmod fcoe
      libfc: adds can_queue ramp up
      libfc: reduce can_queue for all FCP frame allocation failures
      fcoe, libfc: use single frame allocation API
      libfc: add queue_depth ramp up
      add queue_depth ramp up code
      fcoe, libfc: fix an libfc issue with queue ramp down in libfc
      libfc: removes unused disc_work and ex_list
      libfc: adds missing exch release for accepted RRQ
      libfc: removes initializing fc_cpu_order and fc_cpu_mask per lport

Yang, Bo (13):
      megaraid_sas: Update version number and documentation
      megaraid_sas: use the firmware boot timeout when waiting for commands
      megaraid_sas: fix 64 bit sense pointer truncation
      megaraid_sas: Add the support for updating the OS after adding/removing the devices from FW
      megaraid_sas: Fix the fix for fw hang caused by megaraid sas application
      megaraid_sas: add the IEEE SGE support to SAS2 controller
      megaraid_sas: allocate the application cmds to sas2 controller
      megaraid_sas: report system PDs to OS
      megaraid_sas: infrastructure to get PDs from FW
      megaraid_sas: Add new megaraid SAS 2 controller support to the driver
      megaraid_sas: add sysfs for AEN polling
      megaraid_sas: Add poll mechanism to megaraid sas driver
      megaraid_sas: tape drive support fix

Yi Zou (20):
      libfc: add support of receiving ELS_RLS
      fcoe, libfc: add get_lesb() to allow LLD to fill the link error status block (LESB)
      libfc: add fcoe_fc_els_lesb to fc_fcoe.h for FC-BB-5 LESB definitions
      libfcoe: add tracking FIP Missing Discovery Advertisement count
      libfcoe: add tracking FIP Virtual Link Failure count
      libfcoe: add checking disable flag in FIP_FKA_ADV
      libfc: add FC-BB-5 LESB counters to fcoe_dev_stats
      libfc: fix payload size passed to fc_frame_alloc() in fc_lport_els_request
      libfcoe: Do not pad FIP keep-alive to full frame size
      fcoe: Fix using VLAN ID in creating lport's WWWN/WWPN
      fcoe: Fix setting lport's WWNN/WWPN to use san mac address
      fcoe: Fix getting san mac for VLAN interface
      fcoe: Fix checking san mac address
      fcoe: remove extra function decalrations
      fcoe: Call ndo_fcoe_enable/disable to turn FCoE feature on/off in LLD
      libfc: Fix frags in frame exceeding SKB_MAX_FRAGS in fc_fcp_send_data
      fcoe: Use NETIF_F_FCOE_MTU flag to set up max frame size (lport->mfs)
      libfc: Fix wrong scsi return status under FC_DATA_UNDRUN
      fcoe: remove redundant checking of netdev->netdev_ops
      libfc: fix ddp in fc_fcp for 0 xid

jack wang (1):
      pm8001: add SAS/SATA HBA driver

jack_wang (3):
      pm8001: Fixes for tag alloc, error goto and code cleanup
      pm8001: enhance IOMB process modules
      pm8001: add reinitialize SPC parameters before phy start

john fastabend (1):
      fcoe: add check to fail gracefully in bonding mode

and the diffstat:

 Documentation/ABI/stable/sysfs-driver-qla2xxx |    8 
 Documentation/scsi/ChangeLog.megaraid_sas     |   62 
 MAINTAINERS                                   |   15 
 drivers/ata/libata-scsi.c                     |    7 
 drivers/ata/sata_nv.c                         |    2 
 drivers/infiniband/ulp/iser/iscsi_iser.c      |    1 
 drivers/md/dm-mpath.c                         |    8 
 drivers/message/fusion/mptbase.h              |    4 
 drivers/message/fusion/mptctl.c               |    5 
 drivers/message/fusion/mptscsih.c             |   95 
 drivers/message/fusion/mptscsih.h             |    3 
 drivers/s390/scsi/zfcp_aux.c                  |  388 +-
 drivers/s390/scsi/zfcp_ccw.c                  |  179 -
 drivers/s390/scsi/zfcp_cfdc.c                 |   26 
 drivers/s390/scsi/zfcp_dbf.c                  |  134 
 drivers/s390/scsi/zfcp_dbf.h                  |   10 
 drivers/s390/scsi/zfcp_def.h                  |  323 -
 drivers/s390/scsi/zfcp_erp.c                  |  138 
 drivers/s390/scsi/zfcp_ext.h                  |   38 
 drivers/s390/scsi/zfcp_fc.c                   |  677 +--
 drivers/s390/scsi/zfcp_fc.h                   |  260 +
 drivers/s390/scsi/zfcp_fsf.c                  |  367 --
 drivers/s390/scsi/zfcp_fsf.h                  |   53 
 drivers/s390/scsi/zfcp_scsi.c                 |  156 
 drivers/s390/scsi/zfcp_sysfs.c                |  250 -
 drivers/scsi/3w-9xxx.c                        |    6 
 drivers/scsi/3w-sas.c                         | 1924 +++++++++++
 drivers/scsi/3w-sas.h                         |  396 ++
 drivers/scsi/3w-xxxx.c                        |    6 
 drivers/scsi/53c700.c                         |    7 
 drivers/scsi/Kconfig                          |   29 
 drivers/scsi/Makefile                         |    3 
 drivers/scsi/aacraid/linit.c                  |    6 
 drivers/scsi/arcmsr/arcmsr_hba.c              |    5 
 drivers/scsi/be2iscsi/be.h                    |   24 
 drivers/scsi/be2iscsi/be_cmds.c               |  263 +
 drivers/scsi/be2iscsi/be_cmds.h               |   37 
 drivers/scsi/be2iscsi/be_iscsi.c              |   23 
 drivers/scsi/be2iscsi/be_main.c               | 1019 ++++-
 drivers/scsi/be2iscsi/be_main.h               |   49 
 drivers/scsi/be2iscsi/be_mgmt.c               |   69 
 drivers/scsi/be2iscsi/be_mgmt.h               |    8 
 drivers/scsi/bfa/bfa_cb_ioim_macros.h         |   10 
 drivers/scsi/bfa/bfa_cee.c                    |    2 
 drivers/scsi/bfa/bfa_csdebug.c                |    4 
 drivers/scsi/bfa/bfa_fcpim.c                  |    4 
 drivers/scsi/bfa/bfa_fcpim_priv.h             |    4 
 drivers/scsi/bfa/bfa_fcport.c                 |   59 
 drivers/scsi/bfa/bfa_fcs_lport.c              |   11 
 drivers/scsi/bfa/bfa_fcxp.c                   |    8 
 drivers/scsi/bfa/bfa_intr.c                   |    2 
 drivers/scsi/bfa/bfa_intr_priv.h              |   18 
 drivers/scsi/bfa/bfa_ioc.c                    |   10 
 drivers/scsi/bfa/bfa_ioc.h                    |   12 
 drivers/scsi/bfa/bfa_iocfc.c                  |    8 
 drivers/scsi/bfa/bfa_iocfc.h                  |    8 
 drivers/scsi/bfa/bfa_ioim.c                   |    4 
 drivers/scsi/bfa/bfa_itnim.c                  |    6 
 drivers/scsi/bfa/bfa_log.c                    |    4 
 drivers/scsi/bfa/bfa_port_priv.h              |    4 
 drivers/scsi/bfa/bfa_rport.c                  |    6 
 drivers/scsi/bfa/bfa_tskim.c                  |    9 
 drivers/scsi/bfa/bfa_uf.c                     |    2 
 drivers/scsi/bfa/bfad.c                       |    6 
 drivers/scsi/bfa/bfad_fwimg.c                 |    8 
 drivers/scsi/bfa/bfad_im.c                    |    2 
 drivers/scsi/bfa/bfad_im_compat.h             |    2 
 drivers/scsi/bfa/bfad_intr.c                  |    3 
 drivers/scsi/bfa/fabric.c                     |   18 
 drivers/scsi/bfa/fcbuild.c                    |  190 -
 drivers/scsi/bfa/fcbuild.h                    |    6 
 drivers/scsi/bfa/fcpim.c                      |    7 
 drivers/scsi/bfa/fcs.h                        |    2 
 drivers/scsi/bfa/fdmi.c                       |    8 
 drivers/scsi/bfa/include/aen/bfa_aen.h        |    2 
 drivers/scsi/bfa/include/bfa.h                |   10 
 drivers/scsi/bfa/include/bfa_svc.h            |    8 
 drivers/scsi/bfa/include/bfi/bfi.h            |   12 
 drivers/scsi/bfa/include/bfi/bfi_ioc.h        |    2 
 drivers/scsi/bfa/include/bfi/bfi_lps.h        |    4 
 drivers/scsi/bfa/include/bfi/bfi_rport.h      |    8 
 drivers/scsi/bfa/include/cs/bfa_checksum.h    |    6 
 drivers/scsi/bfa/include/cs/bfa_sm.h          |    6 
 drivers/scsi/bfa/include/cs/bfa_trc.h         |    2 
 drivers/scsi/bfa/include/fcs/bfa_fcs_fabric.h |    2 
 drivers/scsi/bfa/include/fcs/bfa_fcs_lport.h  |   17 
 drivers/scsi/bfa/include/protocol/ct.h        |   10 
 drivers/scsi/bfa/include/protocol/fc.h        |   22 
 drivers/scsi/bfa/loop.c                       |  233 -
 drivers/scsi/bfa/lport_api.c                  |   15 
 drivers/scsi/bfa/ns.c                         |    5 
 drivers/scsi/bfa/plog.c                       |    2 
 drivers/scsi/bfa/rport_ftrs.c                 |   28 
 drivers/scsi/bfa/vfapi.c                      |    2 
 drivers/scsi/bfa/vport.c                      |   20 
 drivers/scsi/bnx2i/bnx2i.h                    |    1 
 drivers/scsi/bnx2i/bnx2i_iscsi.c              |   10 
 drivers/scsi/constants.c                      |    1 
 drivers/scsi/cxgb3i/cxgb3i_iscsi.c            |    2 
 drivers/scsi/device_handler/scsi_dh.c         |   28 
 drivers/scsi/device_handler/scsi_dh_alua.c    |  139 
 drivers/scsi/device_handler/scsi_dh_emc.c     |    7 
 drivers/scsi/device_handler/scsi_dh_hp_sw.c   |   94 
 drivers/scsi/device_handler/scsi_dh_rdac.c    |  115 
 drivers/scsi/fcoe/fcoe.c                      | 1376 +++++---
 drivers/scsi/fcoe/fcoe.h                      |   82 
 drivers/scsi/fcoe/libfcoe.c                   |  433 +-
 drivers/scsi/fnic/fnic.h                      |   25 
 drivers/scsi/fnic/fnic_fcs.c                  |  499 +-
 drivers/scsi/fnic/fnic_isr.c                  |   18 
 drivers/scsi/fnic/fnic_main.c                 |  104 
 drivers/scsi/fnic/fnic_res.c                  |    5 
 drivers/scsi/fnic/fnic_res.h                  |   54 
 drivers/scsi/fnic/fnic_scsi.c                 |   96 
 drivers/scsi/fnic/vnic_scsi.h                 |    1 
 drivers/scsi/hosts.c                          |   13 
 drivers/scsi/hptiop.c                         |    5 
 drivers/scsi/ibmvscsi/ibmvfc.c                |  335 +
 drivers/scsi/ibmvscsi/ibmvfc.h                |   12 
 drivers/scsi/ibmvscsi/ibmvscsi.c              |    7 
 drivers/scsi/ipr.c                            |    7 
 drivers/scsi/iscsi_tcp.c                      |    2 
 drivers/scsi/libfc/Makefile                   |    4 
 drivers/scsi/libfc/fc_disc.c                  |   85 
 drivers/scsi/libfc/fc_elsct.c                 |   79 
 drivers/scsi/libfc/fc_exch.c                  |  932 +++--
 drivers/scsi/libfc/fc_fcp.c                   | 1044 +++---
 drivers/scsi/libfc/fc_frame.c                 |   13 
 drivers/scsi/libfc/fc_libfc.c                 |  134 
 drivers/scsi/libfc/fc_libfc.h                 |  112 
 drivers/scsi/libfc/fc_lport.c                 |  853 +++-
 drivers/scsi/libfc/fc_npiv.c                  |  161 
 drivers/scsi/libfc/fc_rport.c                 |  409 +-
 drivers/scsi/libiscsi.c                       |  389 +-
 drivers/scsi/libsas/sas_scsi_host.c           |    6 
 drivers/scsi/lpfc/lpfc.h                      |   17 
 drivers/scsi/lpfc/lpfc_attr.c                 |  262 +
 drivers/scsi/lpfc/lpfc_bsg.c                  |    5 
 drivers/scsi/lpfc/lpfc_crtn.h                 |   14 
 drivers/scsi/lpfc/lpfc_ct.c                   |   53 
 drivers/scsi/lpfc/lpfc_debugfs.c              |   10 
 drivers/scsi/lpfc/lpfc_disc.h                 |    4 
 drivers/scsi/lpfc/lpfc_els.c                  |   76 
 drivers/scsi/lpfc/lpfc_hbadisc.c              |  129 
 drivers/scsi/lpfc/lpfc_hw.h                   |   34 
 drivers/scsi/lpfc/lpfc_hw4.h                  |  131 
 drivers/scsi/lpfc/lpfc_init.c                 |  515 +--
 drivers/scsi/lpfc/lpfc_mbox.c                 |   35 
 drivers/scsi/lpfc/lpfc_nportdisc.c            |    7 
 drivers/scsi/lpfc/lpfc_scsi.c                 |  394 +-
 drivers/scsi/lpfc/lpfc_sli.c                  | 1240 ++++---
 drivers/scsi/lpfc/lpfc_sli.h                  |   27 
 drivers/scsi/lpfc/lpfc_sli4.h                 |   34 
 drivers/scsi/lpfc/lpfc_version.h              |    3 
 drivers/scsi/lpfc/lpfc_vport.c                |    4 
 drivers/scsi/megaraid/megaraid_mbox.c         |    7 
 drivers/scsi/megaraid/megaraid_sas.c          |  738 +++-
 drivers/scsi/megaraid/megaraid_sas.h          |  149 
 drivers/scsi/mpt2sas/mpi/mpi2.h               |    5 
 drivers/scsi/mpt2sas/mpi/mpi2_cnfg.h          |  274 +
 drivers/scsi/mpt2sas/mpi/mpi2_ioc.h           |   18 
 drivers/scsi/mpt2sas/mpi/mpi2_raid.h          |   14 
 drivers/scsi/mpt2sas/mpi/mpi2_tool.h          |   16 
 drivers/scsi/mpt2sas/mpt2sas_base.c           |  152 
 drivers/scsi/mpt2sas/mpt2sas_base.h           |   37 
 drivers/scsi/mpt2sas/mpt2sas_ctl.c            |  197 -
 drivers/scsi/mpt2sas/mpt2sas_ctl.h            |    4 
 drivers/scsi/mpt2sas/mpt2sas_scsih.c          |  819 +++-
 drivers/scsi/mpt2sas/mpt2sas_transport.c      |   86 
 drivers/scsi/osd/osd_initiator.c              |  121 
 drivers/scsi/osd/osd_uld.c                    |  260 +
 drivers/scsi/pm8001/Makefile                  |   12 
 drivers/scsi/pm8001/pm8001_chips.h            |   89 
 drivers/scsi/pm8001/pm8001_ctl.c              |  573 +++
 drivers/scsi/pm8001/pm8001_ctl.h              |   67 
 drivers/scsi/pm8001/pm8001_defs.h             |  112 
 drivers/scsi/pm8001/pm8001_hwi.c              | 4458 ++++++++++++++++++++++++++
 drivers/scsi/pm8001/pm8001_hwi.h              | 1030 ++++++
 drivers/scsi/pm8001/pm8001_init.c             |  891 +++++
 drivers/scsi/pm8001/pm8001_sas.c              | 1103 ++++++
 drivers/scsi/pm8001/pm8001_sas.h              |  481 ++
 drivers/scsi/pmcraid.c                        |    7 
 drivers/scsi/qla2xxx/qla_attr.c               |    3 
 drivers/scsi/qla2xxx/qla_dbg.c                |   78 
 drivers/scsi/qla2xxx/qla_def.h                |    9 
 drivers/scsi/qla2xxx/qla_gbl.h                |    3 
 drivers/scsi/qla2xxx/qla_init.c               |   12 
 drivers/scsi/qla2xxx/qla_isr.c                |  144 
 drivers/scsi/qla2xxx/qla_mbx.c                |   50 
 drivers/scsi/qla2xxx/qla_mid.c                |    2 
 drivers/scsi/qla2xxx/qla_os.c                 |   67 
 drivers/scsi/qla2xxx/qla_version.h            |    2 
 drivers/scsi/qlogicpti.h                      |    2 
 drivers/scsi/scsi.c                           |   10 
 drivers/scsi/scsi_debug.c                     |  351 ++
 drivers/scsi/scsi_devinfo.c                   |   13 
 drivers/scsi/scsi_error.c                     |   65 
 drivers/scsi/scsi_ioctl.c                     |    3 
 drivers/scsi/scsi_lib.c                       |   11 
 drivers/scsi/scsi_lib_dma.c                   |    4 
 drivers/scsi/scsi_scan.c                      |    3 
 drivers/scsi/scsi_sysfs.c                     |   44 
 drivers/scsi/scsi_transport_fc.c              |   99 
 drivers/scsi/scsi_transport_iscsi.c           |   13 
 drivers/scsi/st.c                             |    3 
 drivers/scsi/stex.c                           |  282 +
 drivers/scsi/vmw_pvscsi.c                     | 1407 ++++++++
 drivers/scsi/vmw_pvscsi.h                     |  397 ++
 include/linux/libata.h                        |    2 
 include/linux/pci_ids.h                       |    2 
 include/scsi/Kbuild                           |    1 
 include/scsi/fc/Kbuild                        |    4 
 include/scsi/fc/fc_els.h                      |    6 
 include/scsi/fc/fc_fcoe.h                     |   12 
 include/scsi/fc/fc_fcp.h                      |    8 
 include/scsi/fc/fc_fip.h                      |   12 
 include/scsi/fc/fc_fs.h                       |    2 
 include/scsi/fc/fc_gs.h                       |    2 
 include/scsi/fc/fc_ns.h                       |   35 
 include/scsi/fc_encode.h                      |   68 
 include/scsi/fc_frame.h                       |   22 
 include/scsi/iscsi_if.h                       |    3 
 include/scsi/iscsi_proto.h                    |    2 
 include/scsi/libfc.h                          | 1158 +++---
 include/scsi/libfcoe.h                        |   93 
 include/scsi/libiscsi.h                       |    4 
 include/scsi/libsas.h                         |    3 
 include/scsi/osd_initiator.h                  |   81 
 include/scsi/osd_protocol.h                   |    1 
 include/scsi/osd_sense.h                      |    3 
 include/scsi/scsi.h                           |    4 
 include/scsi/scsi_device.h                    |   12 
 include/scsi/scsi_dh.h                        |    6 
 include/scsi/scsi_host.h                      |   24 
 include/scsi/scsi_transport_fc.h              |    1 
 235 files changed, 27284 insertions(+), 7716 deletions(-)

James


