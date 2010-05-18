From: James Bottomley <James.Bottomley@suse.de>
Subject: [GIT PULL] first round of SCSI updates for the 2.6.35 merge window
Date: Tue, 18 May 2010 10:49:08 -0400
Message-ID: <1274194148.10304.49.camel@mulgrave.site>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from cantor2.suse.de ([195.135.220.15]:45493 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757243Ab0EROtP (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Tue, 18 May 2010 10:49:15 -0400
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Andrew Morton <akpm@linux-foundation.org>, Linus Torvalds <torvalds@linux-foundation.org>
Cc: linux-scsi <linux-scsi@vger.kernel.org>, linux-kernel <linux-kernel@vger.kernel.org>

This is actually the scsi-misc tree plus one fix for 2.6.34 I didn't
manage to send in time (now tagged for stable).  It contains the usual
driver updates (qla2, qla4, lpfc, bfa, zfcp, fusion, mpt2sas, zfcp) plus
one non marvell update for mvsas which seems to ease some of that
driver's current problems.  This patch also adds SCSI to the trace
infrastructure, with some dependent trace changes (acked by Steve
Rostedt).

The patch is available from:

master.kernel.org:/pub/scm/linux/kernel/git/jejb/scsi-misc-2.6.git

The short changelog is:

Adam Radford (2):
      3ware maintainers update
      3w-xxxx, 3w-9xxx: force 60 second timeout

Alan Stern (2):
      don't kfree an initialized struct device
      don't reap targets upon device_add failure

Andrew Vasquez (6):
      qla2xxx: Cleanup FCP-command-status processing debug statements.
      qla2xxx: Limit mailbox command contention for ADISC requests.
      qla2xxx: Further generalization of SRB CTX infrastructure.
      qla2xxx: Display proper link state for disconnected ports.
      qla2xxx: Check for ISP84xx before processing to get 84xx firmware version.
      qla2xxx: General checkpatch corrections.

Anil Veerabhadrappa (3):
      bnx2i: Update version and module description
      bnx2i: link bnx2i hba and cnic device before registering the device
      bnx2i: make firmware use statsn field when constructing header

Arun Easi (1):
      qla2xxx: T10 DIF support added.

Avi Kaplan (2):
      iscsi_tcp: Remove unused field iscsi_conn from struct iscsi_sw_tcp_conn
      iscsi_tcp: Change iscsi_sw_tcp_conn_restore_callbacks arguments

Brian King (2):
      ibmvfc: Reduce error recovery timeout
      ibmvfc: Fix command completion handling

Brian Uchino (2):
      fnic: Change fnic_flush_tx() to flush tx instead of rx queue
      fnic: Update version to 1.4.0.145

Chris Leech (4):
      libfc, fcoe: normalize format specifies for world wide names
      libfc: set both precision and field with when printing FC IDs
      fcoe: check netif operstate instead of IFF_UP & link state
      fcoe: reset FIP ctlr link state on disable/enable

Christof Schmitt (7):
      zfcp: Zero memory for gpn_ft and adisc requests
      zfcp: Use status_read_buf_num provided by FCP channel
      zfcp: Move sbal_get function to zfcp_qdio.c
      zfcp: Move sbale handling to zfcp_qdio files
      zfcp: Report scatter-gather limits to SCSI and block layer
      zfcp: Pass return code from fc_block_scsi_eh to scsi eh
      Allow FC LLD to fast-fail scsi eh by introducing new eh return

Dan Carpenter (2):
      pm8001: potential null dereference in pm8001_dev_gone_notify()
      iscsi_tcp: change & to &&

Douglas Gilbert (1):
      scsi_debug: add max_queue + no_uld parameters

FUJITA Tomonori (1):
      mpt2sas: fix the incorrect scsi_dma_map error checking

Ferenc Wagner (1):
      qla2xxx: Fix documentation of ql2xfdmienable module parameter

Geert Uytterhoeven (10):
      a2091: Kill ugly DMA() macro
      a3000: Use shost_priv() and kill ugly HDATA() macro
      mvme147: Use shost_priv() and kill ugly HDATA() macro
      gvp11: Use shost_priv() and kill ugly HDATA() macro
      a2091: Use shost_priv() and kill ugly HDATA() macro
      a3000: Reindentation
      mvme147: Reindentation
      gvp11: Reindentation
      a2091: Reindentation
      wd33c93: Kill empty wd33c93_release()

Giridhar Malavali (4):
      qla2xxx: Updates to ISP82xx support.
      qla2xxx: Optionally disable target reset.
      qla2xxx: Add ISP82XX support.
      qla2xxx: Re-organized BSG interface specific code.

Hannes Reinecke (2):
      sd: quiet spurious error messages in READ_CAPACITY(16)
      scsi_transport_fc: Protect against overflow in dev_loss_tmo

Harish Zunjarrao (2):
      qla2xxx: Add char device to increase driver use count
      qla2xxx: Free DMA memory only if it is allocated in vendor specific BSG command

James Bottomley (2):
      libsas: fix deref before check in commit 70b25f890ce
      sd: retry read_capacity on UNIT_ATTENTION

James Smart (13):
      lpfc 8.3.12: Update Driver version to 8.3.12
      lpfc 8.3.12: Fix discovery issues
      lpfc 8.3.12: BSG Fixes and enhancements
      lpfc 8.3.12: Critical fixes
      lpfc 8.3.12: T10-PI/DIF changes
      lpfc 8.3.12: Miscellaneous Changes
      lpfc 8.3.12: Emulex SLI enhancements
      lpfc 8.3.11: Update Driver version to 8.3.11
      lpfc 8.3.11: NPIV changes
      lpfc 8.3.11: Fix AER uncorrectable non-fatal error handling
      lpfc 8.3.11: Driver management improvements via BSG
      lpfc 8.3.11: SLI4 Improvements
      lpfc 8.3.11: FCF failover improvements

Jing Huang (6):
      bfa: fix compilation warning in powerpc
      bfa: sg addr big endian fix
      bfa: protect idr using bfad_mutex
      bfa: use pci_iomap() and pci_iounmap()
      bfa: fix the issue of not handling scsi_cmnd sg chaining case
      bfa: add fc transport class based vport create/delete

Joe Eykholt (15):
      libfc: set seq_id for incoming sequence
      libfc: fix hton24 macro to take expressions as args
      libfc: remove unneeded variables in fc_exch_recv_req()
      libfc, libfcoe, fcoe: use smp_processor_id() only when preempt disabled
      libfc: fix sequence-initiative WARN in fc_seq_start_next
      libfcoe: eliminate unused link and last_link fields
      fcoe: remove an unused variable in fcoe_recv_frame()
      libfc: send point-to-poin FLOGI LS_ACC to assigned D_DID
      libfc: recognize incoming FLOGI for point-to-point mode
      fcoe: save gateway address when receiving FLOGI request
      libfcoe: fix debug message entering non-FIP mode
      fcoe: call fcoe_ctlr_els_send even for ELS responses
      libfc: fix oops in point-to-point mode
      libfc: add definition for task attribute mask
      libfc: recode incoming PRLI handling

Julia Lawall (2):
      bfa: eliminate useless code
      pm8001: drop redundant memset

Kaladhar Musunuru (2):
      libfcoe: FIP Keep-Alive messages for VPorts are sent with incorrect port_id and wwn
      libfcoe: Fix incorrect MAC address clearing

Kashyap, Desai (37):
      mpt2sas: Bump version 05.100.00.02
      mpt2sas: Before removing sas_device search device in list for _scsih_sas_device_remove
      mpt2sas: Reworked scmd->result priority for _scsih_qcmd.
      mpt2sas: Upgrade version 05.100.00.01
      mpt2sas: Check for NULL pointer before free_pages is added.
      mpt2sas: Added support for PCIe Advanced Error Recovery.
      mpt2sas: Send default descriptor for RAID pass through in mpt2ctl
      mpt2sas: sanity added to remove duplicate port from topology
      mpt2sas : IOs needs to be pause until handles are refreshed for all device after recovery
      mptfusion: Bump version 03.04.15
      mptfusion: Proper error handling is added after mpt_config timeout
      mptfusion: Event data alignment with 4 byte.
      mptfusion: Check for command status is added after completion.
      mptfusion: Task abort is not supported for Volumes
      mptfusion: sanity check for vdevice pointer is added
      mptfusion: Setting period,offset and width for SPI driver
      mptfusion: Proper bus_type check is added
      mptfusion: mpt_detach is called properly at the time of rmmod
      mptfusion: mpt config will do Hard Reset based upon retry counts
      mptfusion: Updated SCSI IO IOCTL error handling.
      mptfusion: Added new less expensive RESET (Message Unit Reset)
      mpt2sas: Bump version 05.100.00.00
      mpt2sas: Copyright 2010.
      mpt2sas: Default descriptor for RAID Passthru command.
      mpt2sas: return -ENOMEM if memory allocation failed.
      mpt2sas: removed use of tm_cmds.mutex in IOCTL branch.
      mpt2sas: Fix for little endian
      mpt2sas: Driver will not treat NEEDS_INIT as failure.
      mpt2sas: Early return from function if shost is in recovery.
      mpt2sas: Use of get_free_pages for huge memorary allocation.
      mpt2sas: Corrected conditional checks for Internal device Reset
      mpt2sas: Corrected time stamp
      mpt2sas : Do not reset handle before calling _scsih_remove_device in RESCAN task after HBA RESET
      mpt2sas : Device removal algorithm in interrupt context only
      mpt2sas: Upgrading version to 04.100.01.02
      mpt2sas: modified _scsih_sas_device_find_by_handle/sas_address
      mpt2sas: RESCAN Barrier work is added in case of HBA reset.

Kei Tokunaga (3):
      add scsi trace core functions and put trace points
      ftrace: add __print_hex()
      mpt: modify mptctl_exit() to call proper deregister functions

Lalit Chandivade (2):
      qla2xxx: ensure flash operation and host reset via sg_reset are mutually exclusive
      qla2xxx: Clear error status after uncorrectable non-fatal errors.

Madhuranath Iyengar (2):
      qla2xxx: Support for asynchronous TM and Marker IOCBs.
      qla2xxx: Provide common framework for BSG and IOCB commands.

Martin K. Petersen (3):
      scsi_trace: Enhance SCSI command tracing
      Add missing scsi command definitions
      scsi_debug: Block Limits VPD page fixes

Mike Christie (1):
      scsi_dh_emc: request flag cleanup

Mike Miller (1):
      hpsa: remove unneeded defines

Mike Waychison (1):
      qla2xxx: Silence bogus warning by gcc for wrap and did.

Rajashekhara, Mahesh (5):
      aacraid: add an ifdef'd device delete case instead of taking the device offline
      aacraid: prohibit access to array container space
      aacraid: add support for handling ATA pass-through commands.
      aacraid: expose physical devices for models with newer firmware
      aacraid: respond automatically to volumes added by config tool

Ravi Anand (1):
      Adding MAINTAINERS for qla4xxx iSCSI driver.

Richard A Lary (1):
      mpt2sas: use correct pci_resource_flag for comparison

Robert Love (6):
      libfc: Move the port_id into lport
      fcoe: move link speed checking into its own routine
      libfc: Remove extra pointer check
      libfc: Remove unused fc_get_host_port_type
      libfcoe: Don't fill MAC desc in FLOGI if FIP negotiated FPMA
      libfc: Add debug statements when fc_fcp returns DID_ERROR to scsi-ml

Roel Kluin (2):
      pmcraid: redundant check in pmcraid_check_ioctl_buffer()
      gdth: fix buffer overflow

Roland Dreier (1):
      cxgb3i: Fix error path for module init

Sarang Radke (2):
      qla2xxx: Fix to make conditional decision based on port number.
      qla2xxx: Add APEX support.

Srinivas (1):
      mvsas: fix hot plug handling and IO issues

Tom Rini (1):
      Unexport scsi/scsi.h from headers_install

Tomohiro Kusumi (1):
      fix sdev_rw_attr macro for scsi device sysfs entries

Vasu Dev (8):
      fcoe: fix fcoe module ref counting
      fcoe: fix a circular locking issue with rtnl and sysfs mutex
      fcoe: fixes wrong error exit in fcoe_create
      fcoe, fnic, libfc: increased CDB size to 16 bytes for fcoe.
      fcoe: removes unused shost in fcoe_shost_config
      libfc: fix fcp pkt recovery in fc_fcp_recv_data
      libfc: use offload EM instance again instead jumping to next EM
      libfc: fixes unnecessary seq id jump

Vikas Chaudhary (8):
      qla4xxx: Update driver version to 5.02.00-k1
      qla4xxx: added support for abort task management command
      qla4xxx: correct use of cmd->host_scribble
      qla4xxx: do not retry login to CHAP auth failed targets
      qla4xxx: Updated firmware ready timeout algorithm
      qla4xxx: Code Clean up - remove "marker_needed"
      qla4xxx: set device state as per Link UP and LINK DOWN
      qla4xxx: added IPv6 support.

Yi Zou (1):
      libfc: bug in erroring out upon FCP_RSP_LEN_VAL in fc_fcp_resp

And the diffstat:

 MAINTAINERS                               |   23 
 drivers/message/fusion/mptbase.c          |  177 +
 drivers/message/fusion/mptbase.h          |    5 
 drivers/message/fusion/mptctl.c           |  181 -
 drivers/message/fusion/mptfc.c            |   22 
 drivers/message/fusion/mptsas.c           |   55 
 drivers/message/fusion/mptsas.h           |    2 
 drivers/message/fusion/mptscsih.c         |   27 
 drivers/message/fusion/mptspi.c           |   10 
 drivers/s390/scsi/zfcp_aux.c              |    7 
 drivers/s390/scsi/zfcp_def.h              |   19 
 drivers/s390/scsi/zfcp_erp.c              |    2 
 drivers/s390/scsi/zfcp_ext.h              |    6 
 drivers/s390/scsi/zfcp_fc.c               |    4 
 drivers/s390/scsi/zfcp_fsf.c              |  246 --
 drivers/s390/scsi/zfcp_fsf.h              |   11 
 drivers/s390/scsi/zfcp_qdio.c             |  108 
 drivers/s390/scsi/zfcp_qdio.h             |  104 
 drivers/s390/scsi/zfcp_scsi.c             |   23 
 drivers/scsi/3w-9xxx.c                    |   24 
 drivers/scsi/3w-9xxx.h                    |    9 
 drivers/scsi/3w-xxxx.c                    |   23 
 drivers/scsi/3w-xxxx.h                    |    8 
 drivers/scsi/Makefile                     |    1 
 drivers/scsi/a2091.c                      |  309 +-
 drivers/scsi/a2091.h                      |   42 
 drivers/scsi/a3000.c                      |  285 +-
 drivers/scsi/a3000.h                      |   46 
 drivers/scsi/aacraid/aachba.c             |   67 
 drivers/scsi/aacraid/aacraid.h            |    4 
 drivers/scsi/aacraid/commsup.c            |   18 
 drivers/scsi/bfa/bfa_cb_ioim_macros.h     |   29 
 drivers/scsi/bfa/bfa_ioim.c               |   22 
 drivers/scsi/bfa/bfa_os_inc.h             |   23 
 drivers/scsi/bfa/bfad.c                   |   21 
 drivers/scsi/bfa/bfad_attr.c              |  201 +
 drivers/scsi/bfa/bfad_drv.h               |    4 
 drivers/scsi/bfa/bfad_im.c                |   67 
 drivers/scsi/bfa/bfad_im.h                |    6 
 drivers/scsi/bnx2i/bnx2i_hwi.c            |    2 
 drivers/scsi/bnx2i/bnx2i_init.c           |   11 
 drivers/scsi/cxgb3i/cxgb3i_init.c         |    4 
 drivers/scsi/device_handler/scsi_dh_emc.c |    2 
 drivers/scsi/fcoe/fcoe.c                  |  194 +
 drivers/scsi/fcoe/libfcoe.c               |  111 
 drivers/scsi/fnic/fnic.h                  |    4 
 drivers/scsi/fnic/fnic_fcs.c              |    2 
 drivers/scsi/fnic/fnic_main.c             |    2 
 drivers/scsi/gdth.c                       |    2 
 drivers/scsi/gvp11.c                      |  565 ++--
 drivers/scsi/gvp11.h                      |   36 
 drivers/scsi/hpsa.c                       |    8 
 drivers/scsi/hpsa_cmd.h                   |   15 
 drivers/scsi/ibmvscsi/ibmvfc.c            |    8 
 drivers/scsi/ibmvscsi/ibmvfc.h            |    1 
 drivers/scsi/iscsi_tcp.c                  |    6 
 drivers/scsi/iscsi_tcp.h                  |    1 
 drivers/scsi/libfc/fc_disc.c              |    8 
 drivers/scsi/libfc/fc_elsct.c             |    2 
 drivers/scsi/libfc/fc_exch.c              |   51 
 drivers/scsi/libfc/fc_fcp.c               |  103 
 drivers/scsi/libfc/fc_libfc.h             |    8 
 drivers/scsi/libfc/fc_lport.c             |   58 
 drivers/scsi/libfc/fc_npiv.c              |    7 
 drivers/scsi/libfc/fc_rport.c             |  195 -
 drivers/scsi/libiscsi_tcp.c               |    2 
 drivers/scsi/libsas/sas_ata.c             |    5 
 drivers/scsi/libsas/sas_scsi_host.c       |   16 
 drivers/scsi/lpfc/lpfc.h                  |    4 
 drivers/scsi/lpfc/lpfc_attr.c             |   20 
 drivers/scsi/lpfc/lpfc_bsg.c              |  498 +++-
 drivers/scsi/lpfc/lpfc_bsg.h              |    3 
 drivers/scsi/lpfc/lpfc_crtn.h             |    1 
 drivers/scsi/lpfc/lpfc_disc.h             |    1 
 drivers/scsi/lpfc/lpfc_els.c              |   24 
 drivers/scsi/lpfc/lpfc_hbadisc.c          |   79 
 drivers/scsi/lpfc/lpfc_hw.h               |  190 -
 drivers/scsi/lpfc/lpfc_hw4.h              |   60 
 drivers/scsi/lpfc/lpfc_init.c             |  213 +
 drivers/scsi/lpfc/lpfc_mbox.c             |   69 
 drivers/scsi/lpfc/lpfc_nportdisc.c        |   99 
 drivers/scsi/lpfc/lpfc_scsi.c             |  149 -
 drivers/scsi/lpfc/lpfc_sli.c              |  269 +-
 drivers/scsi/lpfc/lpfc_sli.h              |    4 
 drivers/scsi/lpfc/lpfc_sli4.h             |    5 
 drivers/scsi/lpfc/lpfc_version.h          |    2 
 drivers/scsi/lpfc/lpfc_vport.c            |    4 
 drivers/scsi/mpt2sas/Kconfig              |    2 
 drivers/scsi/mpt2sas/mpi/mpi2.h           |    2 
 drivers/scsi/mpt2sas/mpi/mpi2_cnfg.h      |    2 
 drivers/scsi/mpt2sas/mpi/mpi2_history.txt |    2 
 drivers/scsi/mpt2sas/mpi/mpi2_init.h      |    2 
 drivers/scsi/mpt2sas/mpi/mpi2_ioc.h       |    2 
 drivers/scsi/mpt2sas/mpi/mpi2_tool.h      |    2 
 drivers/scsi/mpt2sas/mpt2sas_base.c       |   90 
 drivers/scsi/mpt2sas/mpt2sas_base.h       |   36 
 drivers/scsi/mpt2sas/mpt2sas_config.c     |    8 
 drivers/scsi/mpt2sas/mpt2sas_ctl.c        |   46 
 drivers/scsi/mpt2sas/mpt2sas_ctl.h        |    2 
 drivers/scsi/mpt2sas/mpt2sas_debug.h      |    2 
 drivers/scsi/mpt2sas/mpt2sas_scsih.c      | 1055 +++++---
 drivers/scsi/mpt2sas/mpt2sas_transport.c  |   89 
 drivers/scsi/mvme147.c                    |  169 -
 drivers/scsi/mvme147.h                    |    4 
 drivers/scsi/mvsas/mv_64xx.c              |   25 
 drivers/scsi/mvsas/mv_94xx.c              |   10 
 drivers/scsi/mvsas/mv_init.c              |   19 
 drivers/scsi/mvsas/mv_sas.c               |  201 +
 drivers/scsi/mvsas/mv_sas.h               |   11 
 drivers/scsi/pm8001/pm8001_hwi.c          |    1 
 drivers/scsi/pm8001/pm8001_sas.c          |    4 
 drivers/scsi/pmcraid.c                    |    6 
 drivers/scsi/qla2xxx/Makefile             |    3 
 drivers/scsi/qla2xxx/qla_attr.c           |  772 ------
 drivers/scsi/qla2xxx/qla_bsg.c            | 1212 ++++++++++
 drivers/scsi/qla2xxx/qla_bsg.h            |  135 +
 drivers/scsi/qla2xxx/qla_dbg.c            |   61 
 drivers/scsi/qla2xxx/qla_dbg.h            |   10 
 drivers/scsi/qla2xxx/qla_def.h            |  343 +-
 drivers/scsi/qla2xxx/qla_fw.h             |  106 
 drivers/scsi/qla2xxx/qla_gbl.h            |  126 +
 drivers/scsi/qla2xxx/qla_gs.c             |    2 
 drivers/scsi/qla2xxx/qla_init.c           |  724 +++++
 drivers/scsi/qla2xxx/qla_inline.h         |   21 
 drivers/scsi/qla2xxx/qla_iocb.c           |  879 ++++++-
 drivers/scsi/qla2xxx/qla_isr.c            |  540 ++--
 drivers/scsi/qla2xxx/qla_mbx.c            |  266 +-
 drivers/scsi/qla2xxx/qla_nx.c             | 3636 ++++++++++++++++++++++++++++++
 drivers/scsi/qla2xxx/qla_nx.h             |  889 +++++++
 drivers/scsi/qla2xxx/qla_os.c             |  543 ++++
 drivers/scsi/qla2xxx/qla_sup.c            |  149 +
 drivers/scsi/qla4xxx/ql4_def.h            |   48 
 drivers/scsi/qla4xxx/ql4_fw.h             |   46 
 drivers/scsi/qla4xxx/ql4_glbl.h           |    8 
 drivers/scsi/qla4xxx/ql4_init.c           |  374 ++-
 drivers/scsi/qla4xxx/ql4_iocb.c           |    2 
 drivers/scsi/qla4xxx/ql4_isr.c            |   23 
 drivers/scsi/qla4xxx/ql4_mbx.c            |  337 ++
 drivers/scsi/qla4xxx/ql4_os.c             |  135 +
 drivers/scsi/qla4xxx/ql4_version.h        |    3 
 drivers/scsi/scsi.c                       |    6 
 drivers/scsi/scsi_debug.c                 |   89 
 drivers/scsi/scsi_error.c                 |   19 
 drivers/scsi/scsi_scan.c                  |    3 
 drivers/scsi/scsi_sysfs.c                 |    7 
 drivers/scsi/scsi_trace.c                 |  284 ++
 drivers/scsi/scsi_transport_fc.c          |   30 
 drivers/scsi/sd.c                         |   25 
 drivers/scsi/wd33c93.c                    |    6 
 drivers/scsi/wd33c93.h                    |    1 
 include/linux/ftrace_event.h              |    3 
 include/scsi/Kbuild                       |    1 
 include/scsi/fc/fc_fcp.h                  |    1 
 include/scsi/fc_encode.h                  |   18 
 include/scsi/libfc.h                      |   29 
 include/scsi/libfcoe.h                    |   10 
 include/scsi/scsi.h                       |    3 
 include/scsi/scsi_transport_fc.h          |    2 
 include/trace/events/scsi.h               |  345 ++
 include/trace/ftrace.h                    |    3 
 kernel/trace/trace_output.c               |   16 
 161 files changed, 15301 insertions(+), 4149 deletions(-)

James


