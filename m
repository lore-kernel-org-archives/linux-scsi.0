From: James Bottomley <James.Bottomley@suse.de>
Subject: [GIT PULL] First round of SCSI updates for 2.6.38 merge window
Date: Thu, 17 Mar 2011 16:10:35 -0400
Message-ID: <1300392635.17266.5.camel@mulgrave.site>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from cantor2.suse.de ([195.135.220.15]:57898 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754939Ab1CQUKt (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Thu, 17 Mar 2011 16:10:49 -0400
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Andrew Morton <akpm@linux-foundation.org>, Linus Torvalds <torvalds@linux-foundation.org>
Cc: linux-scsi <linux-scsi@vger.kernel.org>, linux-kernel <linux-kernel@vger.kernel.org>

This represents the usual round of driver updates (fcoe, lpfc, qla2xxx,
zfcp, bnx2i, mpt2sas, megaraid_sas, iscsi, cxgbi and hpsa) plus one new
driver (bnx2fc) and as a bonus we move libsas from the old libata eh to
the new one paving the way for junking the old one (once we can get ipr
converted).

The patch is available here:

master.kernel.org:/pub/scm/linux/kernel/git/jejb/scsi-misc-2.6.git

The short changelog is:

Adam Radford (13):
      megaraid_sas: Version and Changelog update
      megaraid_sas: Fix iMR OCR support to work correctly
      megaraid_sas: Fix max_sectors for IEEE SGL
      megaraid_sas: Fix fault state handling
      megaraid_sas: Fix tasklet_init call
      megaraid_sas: Add CFG_CLEARED AEN
      megaraid_sas: Fix megasas_build_dcdb_fusion to use correct LUN fi=
eld
      megaraid_sas: Fix megasas_build_dcdb_fusion to not filter by TYPE=
_DISK
      megaraid_sas: Fix probe_one to clear MSI-X flags in kdump
      megaraid_sas: Call tasklet_schedule for MSI-X
      megaraid_sas: Enable MSI-X before calling megasas_init_fw
      megaraid_sas: Add missing check_and_restore_queue_depth call
      megaraid_sas: Fix failure gotos

Andrew Vasquez (5):
      qla2xxx: Check return value of fc_block_scsi_eh()
      qla2xxx: Propagate block-layer tags on submitted I/Os.
      qla2xxx: Adjust FCP_RSP response-info field check after TMF compl=
etion.
      qla2xxx: Clear any stale login-states during an adapter reset.
      qla2xxx: Pass right CT command string for CT status processing.

Bhanu Gollapudi (1):
      bnx2fc: Broadcom FCoE offload driver

Bhanu Prakash Gollapudi (5):
      libfcoe: Remove stale fcoe-netdev entries
      libfcoe: Move FCOE_MTU definition from fcoe.h to libfcoe.h
      libfc: introduce __fc_fill_fc_hdr that accepts fc_hdr as an argum=
ent
      libfcoe: Move common code from fcoe to libfcoe module
      libfc: introduce LLD event callback

Bj=C3=B8rn Mork (1):
      megaraid_sas: Sanity check user supplied length before passing it=
 to dma_alloc_coherent()

Boaz Harrosh (1):
      libosd: osd_req_read_sg, optimize the single entry case

Chad Dupuis (1):
      qla2xxx: Fix array subscript is above array bounds in qla2xx_buil=
d_scsi_type_6_iocbs().

Christof Schmitt (11):
      zfcp: Add information to symbolic port name when running in NPIV =
mode
      fc: Add GSPN_ID request to header file
      zfcp: Move SCSI host and transport templates out of struct zfcp_d=
ata
      zfcp: Merge FCP task management setup with regular FCP command se=
tup
      zfcp: Move qtcb kmem_cache to zfcp_fsf.c
      zfcp: Use common FC kmem_cache for GPN_FT request
      zfcp: Allocate GID_PN data through new FC kmem_cache
      zfcp: Introduce new kmem_cache for FC request and response data
      zfcp: Replace kmem_cache for "status read" data
      zfcp: Remove unused flag ZFCP_STATUS_FSFREQ_TASK_MANAGEMENT
      MAINTAINERS: Update zfcp entry

Dan Carpenter (3):
      fcoe: precedence bug in fcoe_filter_frames()
      hpsa: fix bad comparison
      libfc:prevent  dereferencing ERR_PTR in fc_tm_done()

Douglas Gilbert (2):
      scsi_debug: add consecutive medium errors
      scsi_mid_low_api.txt recommend resid usage

Eddie Wai (8):
      bnx2i: Updated to version 2.6.2.3
      bnx2i: Added iSCSI text pdu support for iSCSI offload
      bnx2i: Added jumbo MTU support for the no shost case
      bnx2i: Added support for the 57712(E) devices
      bnx2i: Added handling for unsupported iSCSI offload hba
      bnx2i: Fixed the 32-bit swapping of the LUN field for nopouts for=
 5771X
      bnx2i: Allow ep CONNECT_FAILED condition to go through proper cle=
anup
      bnx2i: Added reconnect fix connecting against Lefthand targets

Giridhar Malavali (4):
      qla2xxx: Don't wait for active mailbox command completion when fi=
rmware is hung.
      qla2xxx: Abort pending commands for faster recovery during ISP re=
set.
      qla2xxx: Display nport_id when any SNS command fails.
      qla2xxx: Reinitialize the device initialize timeout value after r=
eset on ISP82xx.

Hannes Reinecke (3):
      block: improve detail in I/O error messages
      dm mpath: propagate target errors immediately
      Add detailed SCSI I/O errors

Hillf Danton (3):
      scsi_dh: cosmetic change to sizeof()
      libfc: Cleanup return paths in fc_rport_error_retry
      libfc: Return a valid return code in fc_fcp_pkt_abort()

Ilgu Hong (1):
      scsi_dh_alua: Add Promise VTrak to dev list

James Bottomley (9):
      libsas: fix ata list corruption issue
      libsas: convert to libata new error handler
      libata: separate error handler into usable components
      libata: fix eh locking
      libata: fix locking for sas paths
      libata: plumb sas port scan into standard libata paths
      libsas: remove spurious sata control register read/write
      libsas: convert to standard kernel debugging
      libsas: fix ATAPI check condition termination

James Smart (6):
      lpfc 8.3.21: Change lpfc driver version to 8.3.21
      lpfc 8.3.21: Debugfs additions
      lpfc 8.3.21: Initialization and user interface changes
      lpfc 8.3.21: FC Discovery changes
      lpfc 8.3.21: RRQ Implementation fixes
      lpfc 8.3.21: Critical Errors and Bug Fixes

Jesper Juhl (1):
      mptfusion: Fix memory leak in mptctl_getiocinfo()

Joe Eykholt (6):
      libfc: export seq_release() for users of seq_assign()
      libfc: use PRLI hook to get parameters when sending outgoing PRLI
      libfc: add hook to notify providers of local port changes
      libfc: add local port hook for provider session lookup
      libfc: add method for setting handler for incoming exchange
      libfc: add hook for FC-4 provider registration

Joseph Gruher (3):
      scsi_dh_alua: fix stpg_endio group state reporting
      scsi_dh_alua: fix deadlock in stpg_endio
      scsi_dh_alua: fix submit_stpg return

Kashyap, Desai (6):
      mptfusion: Remove bus reset for mptsas module
      mptfusion: Support SAS2.0 Devices with SAS1.0 Controllers
      mpt2sas: Bump version 08.100.00.00
      mpt2sas: Basic Code Cleanup in mpt2sas_base
      mpt2sas: Add support for Customer specific branding messages
      mpt2sas: Revision P MPI Header Update

Kiran Patil (2):
      libfc: Extending lport's roles for target if there is a registere=
d target.
      libfc: Enhanced exchange ID selection mechanism and fix related E=
MA selection logic.

Kleber Sacilotto de Souza (1):
      ipr: Fix a race on multiple configuration changes

Madhuranath Iyengar (2):
      qla2xxx: Update version number to 8.03.07.00
      qla2xxx: Remove host_lock in queuecommand function

Martin K. Petersen (3):
      scsi_debug: Logical Block Provisioning (SBC3r26)
      sd: Logical Block Provisioning update
      Include protection operation in SCSI command trace

Mike Christie (12):
      lpfc: block target when port queueing limit is hit
      lpfc: force retry in queuecommand when port is transitioning
      be2iscsi: fix null ptr ref in conn get param
      iser: export addr and port
      bnx2i: fix null ptr ref in conn get param
      cxgbi: convert to use iscsi_conn_get_addr_param
      iscsi class: add callout to get iscsi_endpoint values
      iscsi_tcp: use iscsi_conn_get_addr_param libiscsi function
      libiscsi: add helper to convert addr to string
      iscsi class: remove unused active variable
      iscsi: fix iscsi_endpoint leak
      cxgbi: enable TEXT PDU support

Mike Snitzer (2):
      scsi_dh_hp_sw: fix deadlock in start_stop_endio
      scsi_dh_alua: add scalable ONTAP lun to dev list

Moger, Babu (2):
      scsi_dh_rdac : Adding MODULE VERSION for rdac device handler
      scsi_dh_rdac: fix for lun_table update for rdac device handler

Nicholas Bellinger (1):
      target: Fix volume size misreporting for volumes > 2TB

Parikh, Neerav (2):
      Revert "[SCSI] libfc: fix exchange being deleted when the abort i=
tself is timed out"
      libfc: Fixing a memory leak when destroying an interface

Peter Jones (2):
      scsi_dh: Use scsi_devinfo functions to do matching of device_hand=
ler tables.
      Add scsi_dev_info_list_del_keyed()

Randy Dunlap (1):
      libfc: fix sparse static and non-ANSI warnings

Robert Love (2):
      libfc: Remove usage of the Scsi_Host's host_lock
      fcoe: Fix module reference count for vports

Saurav Kashyap (1):
      qla2xxx: The ISP82XX should be online while waiting for commands =
completion.

Stephen M. Cameron (20):
      hpsa: export resettable host attribute
      hpsa: move device attributes to avoid forward declarations
      hpsa: Do not attempt kdump if we detect resetting controller fail=
ed.
      hpsa: Inform controller we are using 32-bit tags.
      hpsa: Add transport_mode host attribute in /sys
      hpsa: make hpsa.hpsa_simple_mode=3D1 module parameter actually wo=
rk
      hpsa: do not re-order commands in internal queues
      hpsa: Fix problem that CMD_UNABORTABLE command status was treated=
 as unknown
      hpsa: fix use of uninitialized variable in hpsa_add_msa2xxx_enclo=
sure_device()
      hpsa: Add a per controller commands_outstanding entry in /sys
      hpsa: use usleep_range not msleep for small sleeps
      hpsa: allow driver to put controller in either simple or performa=
nt mode
      hpsa: take the adapter lock in hpsa_wait_for_mode_change_ack
      hpsa: do not reset unknown boards on reset_devices
      hpsa: limit commands allocated on reset_devices
      hpsa: Use kernel provided PCI state save and restore functions
      hpsa: fix board status waiting code
      hpsa: Remove duplicate defines of DIRECT_LOOKUP_ constants
      hpsa: fixup DMA address before freeing.
      hpsa: defend against zero sized buffers in passthru ioctls

Tejun Heo (3):
      fcoe: use dedicated workqueue instead of system_wq
      pm8001: simplify workqueue usage
      remove flush_scheduled_work() usages

Tobias Klauser (1):
      zfcp: Remove redundant unlikely()

Vasiliy Kulikov (1):
      hpsa: avoid leaking stack contents to userland

Vasu Dev (3):
      fcoe: fix broken fcoe interface reset
      fcoe, libfc: initialize EM anchors list and then update npiv EMs
      fcoe: drop FCoE LOGO in FIP mode

Venkata Siva Vijayendra Bhamidipati (2):
      fnic: Bumping up fnic version from 1.4.0.145 to 1.5.0.1.
      fnic: fix memory leak

Yanqing_Liu@Dell.com (1):
      scsi_dh_rdac: Add MD36xxf into device list

Yi Zou (8):
      fcoe: convert fcoe.ko to become an fcoe transport provider driver
      fcoe: prepare fcoe for using fcoe transport
      libfcoe: include fcoe_transport.c into kernel libfcoe module
      libfcoe: rename libfcoe.c to fcoe_cltr.c for the coming fcoe_tran=
sport.c
      libfcoe: add implementation to support fcoe transport
      libfcoe: add fcoe_transport structure defines to include/scsi/lib=
fcoe.h
      libfcoe: move logging macros into the local libfcoe.h header file
      libfc: always initialize the FCoE DDP exchange id for fsp as FC_X=
ID_UNKNOWN

jack_wang (1):
      libsas: fix loopback topology bug during discovery

kxie@chelsio.com (3):
      cxgb3i: fixed connection problem with iscsi private ip
      cxgbi: get rid of gl_skb in cxgbi_ddp_info
      cxgbi: set ulpmode only if digest is on

scameron@beardog.cce.hp.com (1):
      hpsa: fix incorrect PCI IDs and add two new ones (2nd try)

And the diffstat:

 Documentation/scsi/ChangeLog.megaraid_sas    |   23 +
 Documentation/scsi/hpsa.txt                  |   23 +
 Documentation/scsi/scsi_mid_low_api.txt      |   14 +-
 MAINTAINERS                                  |    3 +-
 block/blk-core.c                             |   23 +-
 drivers/ata/libata-core.c                    |   46 +-
 drivers/ata/libata-eh.c                      |   58 +-
 drivers/ata/libata-scsi.c                    |    4 +-
 drivers/ata/libata.h                         |    1 +
 drivers/infiniband/ulp/iser/iscsi_iser.c     |   26 +
 drivers/md/dm-mpath.c                        |   22 +-
 drivers/message/fusion/lsi/mpi_cnfg.h        |    1 +
 drivers/message/fusion/lsi/mpi_ioc.h         |    1 +
 drivers/message/fusion/mptbase.c             |    7 +-
 drivers/message/fusion/mptctl.c              |    4 +-
 drivers/message/fusion/mptsas.c              |    7 +-
 drivers/net/bnx2x/bnx2x_main.c               |    7 -
 drivers/s390/scsi/zfcp_aux.c                 |   80 +-
 drivers/s390/scsi/zfcp_def.h                 |   15 +-
 drivers/s390/scsi/zfcp_erp.c                 |    4 +-
 drivers/s390/scsi/zfcp_ext.h                 |    9 +-
 drivers/s390/scsi/zfcp_fc.c                  |  333 +++--
 drivers/s390/scsi/zfcp_fc.h                  |  124 +-
 drivers/s390/scsi/zfcp_fsf.c                 |   27 +-
 drivers/s390/scsi/zfcp_scsi.c                |   71 +-
 drivers/scsi/Kconfig                         |    1 +
 drivers/scsi/Makefile                        |    1 +
 drivers/scsi/NCR5380.c                       |    3 +-
 drivers/scsi/arcmsr/arcmsr_hba.c             |    4 +-
 drivers/scsi/be2iscsi/be_iscsi.c             |   18 +-
 drivers/scsi/be2iscsi/be_iscsi.h             |    4 +-
 drivers/scsi/be2iscsi/be_main.c              |    3 +-
 drivers/scsi/bnx2fc/57xx_hsi_bnx2fc.h        | 1080 +++++++++++
 drivers/scsi/bnx2fc/Kconfig                  |   11 +
 drivers/scsi/bnx2fc/Makefile                 |    3 +
 drivers/scsi/bnx2fc/bnx2fc.h                 |  511 ++++++
 drivers/scsi/bnx2fc/bnx2fc_constants.h       |  206 +++
 drivers/scsi/bnx2fc/bnx2fc_debug.h           |   70 +
 drivers/scsi/bnx2fc/bnx2fc_els.c             |  515 ++++++
 drivers/scsi/bnx2fc/bnx2fc_fcoe.c            | 2535 ++++++++++++++++++=
++++++++
 drivers/scsi/bnx2fc/bnx2fc_hwi.c             | 1868 ++++++++++++++++++=
+
 drivers/scsi/bnx2fc/bnx2fc_io.c              | 1833 ++++++++++++++++++=
+
 drivers/scsi/bnx2fc/bnx2fc_tgt.c             |  844 +++++++++
 drivers/scsi/bnx2i/bnx2i.h                   |    4 +-
 drivers/scsi/bnx2i/bnx2i_hwi.c               |  125 ++-
 drivers/scsi/bnx2i/bnx2i_init.c              |   29 +-
 drivers/scsi/bnx2i/bnx2i_iscsi.c             |   53 +-
 drivers/scsi/cxgbi/cxgb3i/cxgb3i.c           |   56 +-
 drivers/scsi/cxgbi/cxgb3i/cxgb3i.h           |   19 +-
 drivers/scsi/cxgbi/cxgb4i/cxgb4i.c           |    7 +-
 drivers/scsi/cxgbi/libcxgbi.c                |   66 +-
 drivers/scsi/cxgbi/libcxgbi.h                |    5 +-
 drivers/scsi/device_handler/scsi_dh.c        |  112 +-
 drivers/scsi/device_handler/scsi_dh_alua.c   |   18 +-
 drivers/scsi/device_handler/scsi_dh_emc.c    |    2 +-
 drivers/scsi/device_handler/scsi_dh_hp_sw.c  |    7 +-
 drivers/scsi/device_handler/scsi_dh_rdac.c   |   26 +-
 drivers/scsi/fcoe/Makefile                   |    2 +
 drivers/scsi/fcoe/fcoe.c                     |  621 +++----
 drivers/scsi/fcoe/fcoe.h                     |   50 +-
 drivers/scsi/fcoe/{libfcoe.c =3D> fcoe_ctlr.c} |   40 +-
 drivers/scsi/fcoe/fcoe_transport.c           |  770 ++++++++
 drivers/scsi/fcoe/libfcoe.h                  |   31 +
 drivers/scsi/fnic/fnic.h                     |    2 +-
 drivers/scsi/fnic/vnic_dev.c                 |    2 +-
 drivers/scsi/hpsa.c                          |  579 ++++---
 drivers/scsi/hpsa.h                          |    9 +-
 drivers/scsi/hpsa_cmd.h                      |    4 +-
 drivers/scsi/ipr.c                           |    9 +-
 drivers/scsi/iscsi_tcp.c                     |  134 +-
 drivers/scsi/iscsi_tcp.h                     |    4 +
 drivers/scsi/libfc/fc_exch.c                 |  111 +-
 drivers/scsi/libfc/fc_fcp.c                  |   39 +-
 drivers/scsi/libfc/fc_libfc.c                |  120 ++
 drivers/scsi/libfc/fc_libfc.h                |   14 +
 drivers/scsi/libfc/fc_lport.c                |   69 +-
 drivers/scsi/libfc/fc_npiv.c                 |   10 +-
 drivers/scsi/libfc/fc_rport.c                |  191 ++-
 drivers/scsi/libiscsi.c                      |   44 +-
 drivers/scsi/libsas/Kconfig                  |    8 -
 drivers/scsi/libsas/Makefile                 |    4 -
 drivers/scsi/libsas/sas_ata.c                |  159 +-
 drivers/scsi/libsas/sas_dump.c               |    4 -
 drivers/scsi/libsas/sas_dump.h               |   12 -
 drivers/scsi/libsas/sas_expander.c           |    5 +
 drivers/scsi/libsas/sas_internal.h           |    6 +-
 drivers/scsi/libsas/sas_scsi_host.c          |   14 +-
 drivers/scsi/lpfc/lpfc.h                     |   15 +-
 drivers/scsi/lpfc/lpfc_attr.c                |  123 +-
 drivers/scsi/lpfc/lpfc_crtn.h                |    9 +-
 drivers/scsi/lpfc/lpfc_ct.c                  |   49 +
 drivers/scsi/lpfc/lpfc_debugfs.c             |  962 +++++++++-
 drivers/scsi/lpfc/lpfc_debugfs.h             |   60 +-
 drivers/scsi/lpfc/lpfc_els.c                 |  173 ++-
 drivers/scsi/lpfc/lpfc_hbadisc.c             |   18 +-
 drivers/scsi/lpfc/lpfc_hw.h                  |   11 +-
 drivers/scsi/lpfc/lpfc_hw4.h                 |  104 +-
 drivers/scsi/lpfc/lpfc_init.c                |  134 +-
 drivers/scsi/lpfc/lpfc_mbox.c                |   19 +-
 drivers/scsi/lpfc/lpfc_nportdisc.c           |   11 +-
 drivers/scsi/lpfc/lpfc_scsi.c                |  113 +-
 drivers/scsi/lpfc/lpfc_sli.c                 |  217 ++--
 drivers/scsi/lpfc/lpfc_sli4.h                |    8 +-
 drivers/scsi/lpfc/lpfc_version.h             |    4 +-
 drivers/scsi/lpfc/lpfc_vport.c               |    4 +
 drivers/scsi/megaraid/megaraid_sas.h         |   10 +-
 drivers/scsi/megaraid/megaraid_sas_base.c    |  147 +-
 drivers/scsi/megaraid/megaraid_sas_fusion.c  |   19 +-
 drivers/scsi/mpt2sas/mpi/mpi2.h              |    5 +-
 drivers/scsi/mpt2sas/mpi/mpi2_cnfg.h         |    6 +-
 drivers/scsi/mpt2sas/mpi/mpi2_history.txt    |  384 ----
 drivers/scsi/mpt2sas/mpi/mpi2_sas.h          |    7 +-
 drivers/scsi/mpt2sas/mpi/mpi2_tool.h         |    8 +-
 drivers/scsi/mpt2sas/mpt2sas_base.c          |  128 +-
 drivers/scsi/mpt2sas/mpt2sas_base.h          |   40 +-
 drivers/scsi/mpt2sas/mpt2sas_scsih.c         |    1 -
 drivers/scsi/osd/osd_initiator.c             |   20 +-
 drivers/scsi/pm8001/pm8001_hwi.c             |   37 +-
 drivers/scsi/pm8001/pm8001_init.c            |   27 +-
 drivers/scsi/pm8001/pm8001_sas.h             |   10 +-
 drivers/scsi/pmcraid.c                       |    2 +-
 drivers/scsi/qla2xxx/qla_def.h               |    9 +-
 drivers/scsi/qla2xxx/qla_gbl.h               |    1 +
 drivers/scsi/qla2xxx/qla_gs.c                |   21 +-
 drivers/scsi/qla2xxx/qla_init.c              |   41 +-
 drivers/scsi/qla2xxx/qla_iocb.c              |   52 +-
 drivers/scsi/qla2xxx/qla_mbx.c               |   45 +-
 drivers/scsi/qla2xxx/qla_nx.c                |  191 ++-
 drivers/scsi/qla2xxx/qla_os.c                |   57 +-
 drivers/scsi/qla2xxx/qla_version.h           |    4 +-
 drivers/scsi/scsi_debug.c                    |  192 ++-
 drivers/scsi/scsi_devinfo.c                  |   85 +
 drivers/scsi/scsi_error.c                    |   24 +-
 drivers/scsi/scsi_lib.c                      |   36 +-
 drivers/scsi/scsi_priv.h                     |    2 +
 drivers/scsi/scsi_transport_iscsi.c          |  104 +-
 drivers/scsi/sd.c                            |  229 ++-
 drivers/scsi/sd.h                            |   25 +-
 drivers/target/target_core_cdb.c             |    8 +-
 include/linux/libata.h                       |    2 +
 include/linux/pci_ids.h                      |    2 +
 include/scsi/fc/fc_ns.h                      |   11 +-
 include/scsi/fc_encode.h                     |   26 +-
 include/scsi/libfc.h                         |   74 +-
 include/scsi/libfcoe.h                       |  105 ++
 include/scsi/libiscsi.h                      |    8 +-
 include/scsi/sas_ata.h                       |   22 +
 include/scsi/scsi.h                          |    5 +
 include/scsi/scsi_device.h                   |    1 +
 include/scsi/scsi_transport_iscsi.h          |    6 +-
 include/trace/events/scsi.h                  |   28 +-
 151 files changed, 15570 insertions(+), 2770 deletions(-)
 create mode 100644 drivers/scsi/bnx2fc/57xx_hsi_bnx2fc.h
 create mode 100644 drivers/scsi/bnx2fc/Kconfig
 create mode 100644 drivers/scsi/bnx2fc/Makefile
 create mode 100644 drivers/scsi/bnx2fc/bnx2fc.h
 create mode 100644 drivers/scsi/bnx2fc/bnx2fc_constants.h
 create mode 100644 drivers/scsi/bnx2fc/bnx2fc_debug.h
 create mode 100644 drivers/scsi/bnx2fc/bnx2fc_els.c
 create mode 100644 drivers/scsi/bnx2fc/bnx2fc_fcoe.c
 create mode 100644 drivers/scsi/bnx2fc/bnx2fc_hwi.c
 create mode 100644 drivers/scsi/bnx2fc/bnx2fc_io.c
 create mode 100644 drivers/scsi/bnx2fc/bnx2fc_tgt.c
 rename drivers/scsi/fcoe/{libfcoe.c =3D> fcoe_ctlr.c} (98%)
 create mode 100644 drivers/scsi/fcoe/fcoe_transport.c
 create mode 100644 drivers/scsi/fcoe/libfcoe.h
 delete mode 100644 drivers/scsi/mpt2sas/mpi/mpi2_history.txt

James


--
To unsubscribe from this list: send the line "unsubscribe linux-scsi" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
