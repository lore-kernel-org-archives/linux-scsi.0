From: James Bottomley <James.Bottomley@suse.de>
Subject: [GIT PATCH] First round of SCSI updates for the 2.6.33-34 merge
 window
Date: Fri, 26 Feb 2010 16:08:16 +0530
Message-ID: <1267180696.2902.293.camel@mulgrave.site>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner@vger.kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
To: Andrew Morton <akpm@linux-foundation.org>, Linus Torvalds <torvalds@linux-foundation.org>
Cc: linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org

This is the first set of SCSI updates.  Basically, it's just a large set
of driver updates (all of which have been thoroughly incubated in
linux-next).

The patch is available here:

master.kernel.org:/pub/scm/linux/kernel/git/jejb/scsi-misc-2.6.git

The short changelog is:

Alan Stern (3):
      fix duplicate removal on error path in scsi_sysfs_add_sdev
      fix refcounting bug in scsi_get_host_dev
      fix memory leak in scsi_report_lun_scan

Andrew Vasquez (4):
      qla2xxx: Add firmware ETS burst support.
      qla2xxx: Correct loop-resync issues during SNS scans.
      qla2xxx: Correct use-after-free issue in terminate_rport_io callback.
      qla2xxx: Correct EH bus-reset handling.

Bart Van Assche (3):
      libsrp: fix bug in ADDITIONAL CDB LENGTH interpretation
      ibmvscsi: fix a typo in a source code comment
      libsrp: fix typo -- replace RDAM by RDMA

Ben Hutchings (1):
      qla1280: Drop host_lock while requesting firmware

Bhanu Prakash Gollapudi (1):
      libfcoe: Send port LKA every FIP_VN_KA_PERIOD secs.

Brian King (1):
      scsi_dh_alua: Add IBM Power Virtual SCSI ALUA device to dev list

Christof Schmitt (11):
      zfcp: Introduce header file for qdio structs and inline functions
      zfcp: Replace FC4 constants with information from exchange port
      zfcp: Move scsi result tracing decision to zfcp_dbf.h
      zfcp: Rename sysfs_device attribute to dev in zfcp_unit and zfcp_port
      zfcp: Remove duplicate assignment of req_seq_no
      zfcp: Dont use 0 to indicate invalid LUN in rec trace
      zfcp: Fix warnings from smatch
      zfcp: Remove unused payload field from zfcp_dbf_san_record
      zfcp: Remove two FIXME comments
      zfcp: Move FSF request tracking code to new file
      zfcp: Remove function zfcp_reqlist_find_safe

Dan Carpenter (1):
      FlashPoint: fix off by one tests

Dave Jones (1):
      gdth: Convert to use regular kernel types.

Dmitry Torokhov (1):
      vmw_pvscsi: fix signedness warning with newer compilers

Don Brace (1):
      hpsa: Allow multiple command completions per interrupt.

Douglas Gilbert (1):
      skip sense logging for some ATA PASS-THROUGH cdbs

Erik Ekman (1):
      fusion: fix warning when not using procfs

Finn Thain (1):
      mac_esp: fix PIO mode, take 2

George Kadianakis (1):
      lpfc: restore MSI-X/MSI support

Giridhar Malavali (5):
      qla2xxx: Update version number to 8.03.02-k1.
      qla2xxx: Proper clean-up of BSG requests when request times out.
      qla2xxx: Update version number to 8.03.02-k0.
      qla2xxx: Remove firmware hint for 81xx parts.
      qla2xxx: Add BSG support for FC ELS/CT passthrough and vendor commands.

Hannes Reinecke (1):
      scsi_transport_fc: Remove capping from dev_loss_tmo

Hugh Daschbach (2):
      libfc: Don't assume response request present.
      libfc: Fix e_d_tov ns -> ms scaling factor in PLOGI response.

James Bottomley (2):
      scsi_transport_sas: add support for transport layer retries (TLR)
      eliminate potential kmalloc failure in scsi_get_vpd_page()

James Smart (15):
      lpfc: correct PPC build failure
      lpfc 8.3.9: Update Driver version to 8.3.9
      lpfc 8.3.9: Fix locking and memory issues
      lpfc 8.3.9: Changes to sysfs interface for the lpfc driver.
      lpfc 8.3.9: SLI enhancments to support new hardware.
      lpfc 8.3.9: Discovery changes to the lpfc driver.
      lpfc 8.3.9: PCI Changes to lpfc driver
      lpfc 8.3.8: Update Driver version to 8.3.8
      lpfc 8.3.8: (BSG4) Add new vendor specific BSG Commands
      lpfc 8.3.8: (BSG3) Modify BSG commands to operate asynchronously
      lpfc 8.3.8: (BSG2) Create lpfc_bsg.h
      lpfc 8.3.8: (BSG1) Update BSG infrastructure
      lpfc 8.3.8: Add code to display logical link speed
      lpfc 8.3.8: BugFixes: Discovery relates changes
      lpfc 8.3.8: BugFixes: SLI relates changes

Jayamohan Kallickal (24):
      be2iscsi: Adding support for BE3
      be2iscsi: correction in the claculation for num_cxn_wrb
      be2iscsi: changing the chip opcode for TEXT
      be2iscsi: Ensure clean reuse of wrb
      be2iscsi: correcting the return
      be2iscsi: Proper checking of state
      be2iscsi: Fix for first_burst
      be2iscsi: changing copyright to 2010
      be2iscsi: Remove Ring mode from driver
      be2iscsi: Fix to allow driver to load when the FW allows more cids
      be2iscsi: Fixing the number of SGE's
      be2iscsi: Fixing Bug for multiple SGEs
      be2iscsi: Enable TEXT req resp
      be2iscsi: Fixing initialization of can_queue
      be2iscsi: The session failure only when Link Goes down
      be2iscsi: Enable async mode for mcc rings
      be2iscsi: No requirement for endianess change for data_count
      be2iscsi: decide which requests need completion
      be2iscsi: Use of opcode in beiscsi_alloc_pdu
      be2iscsi:moved pci_set_drvdata to inside beiscsi_hba_alloc
      be2iscsi: Added opcode for LOGOUT_RSP, TEXT_RESP, TMFUNC_RSP
      be2iscsi: Link Wrb with next Wrb
      be2iscsi: Move freeing of resources to stop_conn
      be2iscsi: Use start cid and number of cid and icd from FW

Jiri Slaby (1):
      cxgbi3: remove unnecessary NULL test

Joe Carnuccio (1):
      qla2xxx: Enhance EEH support and enable AER support.

Joe Perches (1):
      cxgb3i, bnx2i: remove uses of nipquad use %pi4

Julia Lawall (1):
      pm8001: Use kzalloc for allocating only one thing

Kashyap, Desai (17):
      raid_class: add raid1e
      mpt2sas: Do not call sas_is_tlr_enabled for RAID volumes.
      mpt2sas: Bump version 04.100.01.00
      mpt2sas: Enable TLR for SSP TAPE drives (Added SAS Transport APIs)
      mpt2sas: Update driver header to latest MPI Spec.
      mpt2sas: Added phy_enable and set_phy_speed sysfs callback support.
      mpt2sas: Added raid transport support
      mpt2sas: Use compat_ptr to setup the pointer compatibility.
      mpt2sas: Set ioc->fwfault_debug to the cmd line option mpt2sas_fwfault_debug.
      mpt2sas: User resource_size_t instead of unsigned long
      mpt2sas: Return -ENODATA on IOCTL timeout
      mpt2sas: Delete volume before HBA detach.
      mptfusion: Bump version 03.04.14
      mptfusion: corrected if condition check for SCSIIO and PASSTHROUGH commands
      mptfusion: block device when target is being removed by FW
      mptfusion: Added sysfs expander manufacture information at the time of expander add.
      mptfusion: Added MPI_SCSIIO_CONTROL_HEADOFQ priority

Martin K. Petersen (3):
      Fix printing of failed 32-byte commands
      Fix printing of variable length commands
      sd: Combine DIF/DIX error handling

Matt Gates (3):
      hpsa: Don't return DID_NO_CONNECT when a device is merely not ready
      hpsa: Retry commands completing with a sense key of ABORTED_COMMAND
      hpsa: Return DID_RESET for commands which complete with status of UNSOLICITED ABORT

Michael Reed (1):
      fusion: hold off error recovery while alternate ioc is initializing

Mike Christie (6):
      scsi_dh_alua: add netapp to dev list
      qla4xxx: fix compile warning due to invalid extHwConfig
      iscsi_tcp: wake xmit thread when killing session
      bnx2i: set change_queue_depth function
      libiscsi: reset cmd timer if cmds are making progress
      cxgb3i: check for setup netdev

Mike Miller (2):
      hpsa: print all the bytes of the CDB, not just the first one.
      hpsa: add pci ids for storageworks 1210m, remove p400, p800, p700m

Richard Lary (1):
      qla2xxx: EEH: Restore PCI saved state during pci slot reset.

Robert Love (2):
      MAINTAINERS: Adding FCoE information to the MAINTAINERS file.
      fcoe: Only rmmod fcoe.ko if there are no active connections

Roel Kluin (5):
      qla2xxx: negative error return in qla2x00_change_queue_depth()
      lpfc: unify two if branches with the same code in lpfc_decode_firmware_rev()
      ibmmca: fix buffer overflow
      u14-34f: fix buffer overflow
      eata: fix buffer overflow

Sarang Radke (1):
      qla2xxx: Initialize payload receive length in failure path of vendor commands

Stephen M. Cameron (24):
      hpsa: update driver version to 2.0.1-3
      hpsa: Reorder compat ioctl functions to eliminate some forward declarations.
      hpsa: eliminate lock_kernel in compat_ioctl
      hpsa: fix bug in adjust_hpsa_scsi_table
      hpsa: Fix hpsa_find_scsi_entry so that it doesn't try to dereference NULL pointers
      hpsa: clarify obscure comment in adjust_hpsa_scsi_table
      hpsa: when resetting devices, print out which device
      hpsa: use scan_start and scan_finished entry points for scanning
      hpsa: Add an shost_to_hba helper function.
      hpsa: Fix p1210m LUN assignment.
      hpsa: interrupt pending function should return bool not unsigned long
      hpsa: fix some debug printks to use dev_dbg instead
      hpsa: make tag macros into functions
      hpsa: eliminate unnecessary memcpys
      hpsa: remove unwanted debug code
      hpsa: use kzalloc not kmalloc plus memset
      hpsa: use sizeof() not an inline constant in memset.
      hpsa: return proper error codes not minus one.
      hpsa: remove superfluous returns from void functions.
      hpsa: make adjust_hpsa_scsi_table return void.
      hpsa: Use BUG_ON instead of an if statement.
      hpsa: avoid unwanted promotion from unsigned to signed for raid level index
      hpsa: Use kernel integer types, not userland ones
      hpsa: fix typo in comments

Vasu Dev (1):
      libfc: call ddp setup for only FCP reads to avoid accessing junk fsp pointer

Venkata Siva Vijayendra Bhamidipati (3):
      fnic: Set fnic driver version
      fnic: lport stats need to be initialized in fnic_probe()
      fnic: Allow multicast and unicast address registrations for fnic

Yang, Bo (4):
      megaraid_sas: version and documentation update
      megaraid_sas: driver fixed the device update issue
      megaraid_sas: add the logical drive list to driver
      megaraid_sas: Zero pad_0 in mfi structure

and the diffstat:

 Documentation/scsi/ChangeLog.megaraid_sas  |   16 
 MAINTAINERS                                |   11 
 drivers/message/fusion/mptbase.c           |    5 
 drivers/message/fusion/mptbase.h           |    4 
 drivers/message/fusion/mptctl.c            |    4 
 drivers/message/fusion/mptfc.c             |   17 
 drivers/message/fusion/mptsas.c            |  211 ++
 drivers/message/fusion/mptscsih.c          |    9 
 drivers/s390/scsi/zfcp_aux.c               |   90 -
 drivers/s390/scsi/zfcp_ccw.c               |   11 
 drivers/s390/scsi/zfcp_dbf.c               |   20 
 drivers/s390/scsi/zfcp_dbf.h               |   34 
 drivers/s390/scsi/zfcp_def.h               |  114 -
 drivers/s390/scsi/zfcp_erp.c               |   36 
 drivers/s390/scsi/zfcp_ext.h               |    9 
 drivers/s390/scsi/zfcp_fc.c                |   23 
 drivers/s390/scsi/zfcp_fsf.c               |  163 -
 drivers/s390/scsi/zfcp_qdio.c              |   50 
 drivers/s390/scsi/zfcp_qdio.h              |  109 +
 drivers/s390/scsi/zfcp_reqlist.h           |  183 ++
 drivers/s390/scsi/zfcp_scsi.c              |   38 
 drivers/s390/scsi/zfcp_sysfs.c             |   37 
 drivers/scsi/FlashPoint.c                  |    2 
 drivers/scsi/be2iscsi/be.h                 |   21 
 drivers/scsi/be2iscsi/be_cmds.c            |   88 -
 drivers/scsi/be2iscsi/be_cmds.h            |   14 
 drivers/scsi/be2iscsi/be_iscsi.c           |  136 +
 drivers/scsi/be2iscsi/be_iscsi.h           |    2 
 drivers/scsi/be2iscsi/be_main.c            |  488 ++---
 drivers/scsi/be2iscsi/be_main.h            |   27 
 drivers/scsi/be2iscsi/be_mgmt.c            |  139 -
 drivers/scsi/be2iscsi/be_mgmt.h            |    6 
 drivers/scsi/bnx2i/bnx2i_iscsi.c           |    5 
 drivers/scsi/constants.c                   |   20 
 drivers/scsi/cxgb3i/cxgb3i_iscsi.c         |   17 
 drivers/scsi/cxgb3i/cxgb3i_offload.c       |    7 
 drivers/scsi/cxgb3i/cxgb3i_pdu.c           |    6 
 drivers/scsi/device_handler/scsi_dh_alua.c |    2 
 drivers/scsi/eata.c                        |    2 
 drivers/scsi/esp_scsi.c                    |   14 
 drivers/scsi/fcoe/fcoe.c                   |   18 
 drivers/scsi/fcoe/libfcoe.c                |    2 
 drivers/scsi/fnic/fnic.h                   |    2 
 drivers/scsi/fnic/fnic_main.c              |    4 
 drivers/scsi/fnic/vnic_devcmd.h            |    2 
 drivers/scsi/gdth.c                        |  430 ++---
 drivers/scsi/gdth.h                        |  952 +++++------
 drivers/scsi/gdth_ioctl.h                  |  366 ++--
 drivers/scsi/gdth_proc.c                   |   42 
 drivers/scsi/gdth_proc.h                   |    4 
 drivers/scsi/hpsa.c                        |  793 ++++++---
 drivers/scsi/hpsa.h                        |  136 +
 drivers/scsi/hpsa_cmd.h                    |  204 +-
 drivers/scsi/ibmmca.c                      |    2 
 drivers/scsi/ibmvscsi/ibmvscsi.c           |    2 
 drivers/scsi/iscsi_tcp.c                   |    8 
 drivers/scsi/libfc/fc_exch.c               |    2 
 drivers/scsi/libfc/fc_fcp.c                |    3 
 drivers/scsi/libfc/fc_lport.c              |    3 
 drivers/scsi/libfc/fc_rport.c              |    2 
 drivers/scsi/libiscsi.c                    |   53 
 drivers/scsi/libsrp.c                      |    8 
 drivers/scsi/lpfc/lpfc.h                   |   14 
 drivers/scsi/lpfc/lpfc_attr.c              |  118 -
 drivers/scsi/lpfc/lpfc_bsg.c               | 2473 +++++++++++++++++++++++++----
 drivers/scsi/lpfc/lpfc_bsg.h               |   98 +
 drivers/scsi/lpfc/lpfc_crtn.h              |   22 
 drivers/scsi/lpfc/lpfc_ct.c                |   15 
 drivers/scsi/lpfc/lpfc_els.c               |  145 +
 drivers/scsi/lpfc/lpfc_hbadisc.c           |  735 +++++---
 drivers/scsi/lpfc/lpfc_hw.h                |   23 
 drivers/scsi/lpfc/lpfc_hw4.h               |  265 ++-
 drivers/scsi/lpfc/lpfc_init.c              |  547 +++++-
 drivers/scsi/lpfc/lpfc_mbox.c              |  111 +
 drivers/scsi/lpfc/lpfc_nl.h                |   22 
 drivers/scsi/lpfc/lpfc_nportdisc.c         |   85 
 drivers/scsi/lpfc/lpfc_scsi.c              |   46 
 drivers/scsi/lpfc/lpfc_scsi.h              |    1 
 drivers/scsi/lpfc/lpfc_sli.c               |  329 ++-
 drivers/scsi/lpfc/lpfc_sli.h               |   10 
 drivers/scsi/lpfc/lpfc_sli4.h              |   82 
 drivers/scsi/lpfc/lpfc_version.h           |    4 
 drivers/scsi/lpfc/lpfc_vport.c             |    7 
 drivers/scsi/mac_esp.c                     |   95 -
 drivers/scsi/megaraid/megaraid_sas.c       |  246 ++
 drivers/scsi/megaraid/megaraid_sas.h       |   36 
 drivers/scsi/mpt2sas/Kconfig               |    1 
 drivers/scsi/mpt2sas/mpi/mpi2.h            |   16 
 drivers/scsi/mpt2sas/mpi/mpi2_cnfg.h       |   25 
 drivers/scsi/mpt2sas/mpi/mpi2_history.txt  |   93 -
 drivers/scsi/mpt2sas/mpi/mpi2_init.h       |   24 
 drivers/scsi/mpt2sas/mpi/mpi2_ioc.h        |   77 
 drivers/scsi/mpt2sas/mpi/mpi2_sas.h        |    6 
 drivers/scsi/mpt2sas/mpt2sas_base.c        |   18 
 drivers/scsi/mpt2sas/mpt2sas_base.h        |   14 
 drivers/scsi/mpt2sas/mpt2sas_config.c      |   51 
 drivers/scsi/mpt2sas/mpt2sas_ctl.c         |   13 
 drivers/scsi/mpt2sas/mpt2sas_scsih.c       |  266 ++-
 drivers/scsi/mpt2sas/mpt2sas_transport.c   |  196 ++
 drivers/scsi/pm8001/pm8001_init.c          |    2 
 drivers/scsi/qla1280.c                     |    4 
 drivers/scsi/qla2xxx/qla_attr.c            |  732 ++++++++
 drivers/scsi/qla2xxx/qla_def.h             |  155 +
 drivers/scsi/qla2xxx/qla_fw.h              |   33 
 drivers/scsi/qla2xxx/qla_gbl.h             |    7 
 drivers/scsi/qla2xxx/qla_init.c            |   32 
 drivers/scsi/qla2xxx/qla_iocb.c            |  120 +
 drivers/scsi/qla2xxx/qla_isr.c             |  110 +
 drivers/scsi/qla2xxx/qla_mbx.c             |  151 +
 drivers/scsi/qla2xxx/qla_os.c              |  135 -
 drivers/scsi/qla2xxx/qla_version.h         |    6 
 drivers/scsi/qla4xxx/ql4_init.c            |   14 
 drivers/scsi/raid_class.c                  |    1 
 drivers/scsi/scsi.c                        |   40 
 drivers/scsi/scsi_lib.c                    |   10 
 drivers/scsi/scsi_sas_internal.h           |    2 
 drivers/scsi/scsi_scan.c                   |    9 
 drivers/scsi/scsi_sysfs.c                  |   18 
 drivers/scsi/scsi_transport_fc.c           |   26 
 drivers/scsi/scsi_transport_sas.c          |  103 +
 drivers/scsi/sd.c                          |   54 
 drivers/scsi/ses.c                         |   10 
 drivers/scsi/u14-34f.c                     |    2 
 drivers/scsi/vmw_pvscsi.c                  |    3 
 include/linux/raid_class.h                 |    1 
 include/scsi/scsi_device.h                 |    3 
 include/scsi/scsi_transport_sas.h          |    7 
 127 files changed, 10046 insertions(+), 3301 deletions(-)

James
