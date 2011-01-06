From: James Bottomley <James.Bottomley@suse.de>
Subject: [GIT PULL] first set of SCSI patches for the 2.6.38 merge window
Date: Thu, 06 Jan 2011 14:29:42 -0600
Message-ID: <1294345782.22825.341.camel@mulgrave.site>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner@vger.kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
To: Andrew Morton <akpm@linux-foundation.org>, Linus Torvalds <torvalds@linux-foundation.org>
Cc: linux-scsi <linux-scsi@vger.kernel.org>, linux-kernel <linux-kernel@vger.kernel.org>
List-Id: linux-scsi@vger.kernel.org

This is a first set because we've got a postmerge tree waiting on block
and a few in the pending queue.  The current tranche has all been
incubated in linux-next for at least 5 days.

It's mostly driver updates: qla2, qla4, lpfc, mpt2sas, megaraid_sas,
iscsi and fcoe/libfc.  Plus there's a herculean cleanup of bfa and a
redesign of the tracing in zfcp.  The rest are assorted minor fixes and
cleanups, plus one attempt to plug a data corruption problem with a
specific set of arrays (this isn't marked for backport to stable yet,
because I want to try it out in the field first).

The patch is available here:

master.kernel.org:/pub/scm/linux/kernel/git/jejb/scsi-misc-2.6.git

The short changelog is:

Adam Radford (7):
      megaraid_sas: Documentation update
      megaraid_sas: Add 9565/9285 specific code
      megaraid_sas: Add struct megasas_instance_template changes
      megaraid_sas: Use lowest memory bar for SR-IOV VF support
      megaraid_sas: Add MSI-X support and msix_disable module parameter
      megaraid_sas: Update GPL headers.
      megaraid_sas: Rename megaraid_sas.c to megaraid_sas_base.c

Alan Stern (2):
      eliminate an unnecessary local variable from scsi_remove_target()
      sd: improve logic and efficiecy of media-change detection

Andrew Vasquez (4):
      qla2xxx: Display mailbox register 4 during 8012 AEN for ISP82XX parts.
      qla2xxx: Don't perform a BIG_HAMMER if Get-ID (0x20) mailbox command fails on CNAs.
      qla2xxx: Add sysfs node for displaying board temperature.
      qla2xxx: Populate FCP_PRIO location for no *FLT* case

Christof Schmitt (3):
      zfcp: Add allow_lun_scan module parameter
      zfcp: Add __init declaration to zfcp_cache_hw_align
      zfcp: Move qdio setup from erp to zfcp_qdio.c

Dan Carpenter (1):
      qla2xxx: list cursors are not null

Dan Williams (1):
      libsas: fix definition of wideport, include local sas address

Douglas Gilbert (1):
      scsi_debug: set resid to indicate no data-in when medium error

Eddie Wai (13):
      bnx2i: Updated version to 2.6.2.2
      bnx2i: Updated copyright and maintainer info
      bnx2i: Cleaned up various error conditions in ep_connect/disconnect
      bnx2i: Added return code check for chip kwqe submission request
      bnx2i: Modified the bnx2i stop path to compensate for in progress ops
      bnx2i: Removed the dynamic registration of CNIC
      bnx2i: Added mutex lock protection to conn_get_param
      bnx2i: Allow to abort the connection if connect request times out
      bnx2i: Fixed the remote TCP RST handling for the 570X (1g)
      bnx2i: Fixed a cid leak issue for 5771X (10g)
      bnx2i: Fixed the endian bug in the TMF LUN cmd send
      bnx2i: Added fix for NOP-Out response panic from unsolicited NOP-In
      bnx2i: Fixed bugs in the handling of unsolicited NOP-Ins

FUJITA Tomonori (1):
      st: Increase success probability in driver buffer allocation

Giridhar Malavali (4):
      qla2xxx: Use sg_next to fetch next sg element while walking sg list.
      qla2xxx: Fix to avoid recursive lock failure during BSG timeout.
      qla2xxx: Remove code to not reset ISP82xx on failure.
      qla2xxx: Code cleanup to remove unwanted comments and code.

Hillf Danton (9):
      fix the return value of scsi_target_queue_read()
      libfc: fix memory leakage in remote port
      libfc: fix memory leakage in local port
      libfc: fix memory leakage in local port
      libfc: fix stats computation in fc_queuecommand()
      libfc: fix mem leak in fc_seq_assign()
      libfc: tune fc_exch_em_alloc() to be O(2)
      libfc: fix mem leak in fc_exch_recv_seq_resp()
      libfc: remove define of fc_seq_exch in fc_exch.c

James Bottomley (2):
      fix medium error problems with some arrays which can cause data corruption
      fix id computation in scsi_eh_target_reset()

James Smart (11):
      lpfc 8.3.20: Update lpfc driver version to 8.3.20
      lpfc 8.3.20: Updates to FC discovery commands
      lpfc 8.3.20: Implement new SLI4 init procedures based on if_type
      lpfc 8.3.20: Implement the FC and SLI async event handlers
      lpfc 8.3.20: Critical fixes
      lpfc 8.3.19: Update lpfc driver version to 8.3.19
      lpfc 8.3.19: Change heartbeat to default to disabled
      lpfc 8.3.19: Added support for ELS RRQ command
      lpfc 8.3.19: Add SLI4 FC Discovery support
      lpfc 8.3.19: Add latest SLI4 Hardware initialization support
      lpfc 8.3.19: Fix critical errors and crashes

Jing Huang (3):
      bfa: remove unused defintions and misc cleanups
      bfa: remove inactive functions
      bfa: replace bfa_assert with WARN_ON

Joe Carnuccio (2):
      qla2xxx: Remove redundant module parameter permission bits
      qla2xxx: Fixed zero test on new_config in qla2x00_process_loopback().

Joe Eykholt (8):
      libfc: fix statistics for FCP input/output megabytes
      libfcoe: change fip_select to return new FCF
      libfcoe: reorder FCF list to put latest advertiser first
      libfcoe: add debug message for FCF destination MAC
      libfcoe: retry rejected FLOGI to another FCF if possible
      libfcoe: fix checking of conflicting fabrics in fcoe_ctlr_select()
      libfcoe: move some timer code to make it reusable.
      libfcoe: update FIP FCF announcements

Joe Perches (1):
      drivers/scsi/fcoe: Update WARN uses

Julia Lawall (1):
      gdth: Add missing call to gdth_ioctl_free

Kai Makisara (1):
      st: Store page order before driver buffer allocation

Karen Higgins (1):
      qla4xxx: use correct fw_ddb_index in abort task

Kashyap, Desai (11):
      mpt2sas: Bump version 07.100.00.00
      mpt2sas: Debug string changes from target to device.
      mpt2sas: Sanity check for phy count is added using max phy count
      mpt2sas: change queue depth with reason argument more appropriately
      mpt2sas: Remove code for TASK_SET_FULL from driver.
      mpt2sas: MPI 2.0 Header updated
      mpt2sas: Modify code to support Expander switch
      mpt2sas: Create a pool of chain buffer instead of dedicated per IOs
      mpt2sas: Added loadtime para for IOMissingDelay and DMD
      mpt2sas: Added sanity check for cb_idx and smid access.
      mpt2sas: Removed compiler warnnings when logging is disabled

Krishna Gudipati (6):
      bfa: Update the driver version to 2.3.2.3
      bfa: io tag handling and minor bug fix.
      bfa: direct attach mode fix.
      bfa: IOC auto recovery fix.
      bfa: Store port configuration in flash for persistency.
      bfa: IOC fwtrace save logic & state machine fixes.

Lalit Chandivade (4):
      qla4xxx: do not check for fw hung if reset retry is in progress
      qla4xxx: Fail initialization if qla4_8xxx_pci_mem_write_2M fails
      qla4xxx: put device in FAILED state for 82XX initialization failure
      qla4xxx: do not process interrupt unconditionally

Luben Tuikov (1):
      Retrieve the Caching mode page

Madhuranath Iyengar (2):
      qla2xxx: Fix for memory wedge on fw halt for ISP82XX
      qla2xxx: Update FCP priority information to firmware before sending IOs

Maggie (2):
      bfa: fix endianess sparse check warnings
      bfa: fix regular sparse check warnings.

Maggie Zhang (7):
      bfa: remove unused functions and misc cleanups
      bfa: remove all OS wrappers
      bfa: remove all SCSI IO callbacks
      bfa: scatter gather processing change
      bfa: remove a file with small size
      bfa: clean up one line functions
      bfa: remove unused and empty functions

Menny Hamburger (1):
      scsi_dh: propagate SCSI device deletion

Mike Christie (5):
      libiscsi: use bh locking instead of irq with session lock
      libiscsi: do not take host lock in queuecommand
      be2iscsi: fix null ptr when accessing task hdr
      be2iscsi: fix gfp use in alloc_pdu
      libiscsi: add more informative failure message during iscsi scsi eh

Nicholas Bellinger (1):
      Add missing SPC-4 CDB and MAINTENANCE_[IN,OUT] service action definitions

Prasanna Mumbai (1):
      qla4xxx: cache new IP address acquired via DHCP

Robert Jennings (1):
      ibmvfc: Improve ibmvfc_async_desc memory layout

Robert Love (1):
      libfc: Fix incorrect locking and unlocking in FCP

Saurav Kashyap (1):
      qla2xxx: Added support for quiescence mode for ISP82xx.

Shyam Sundar (1):
      qla4xxx: initialize MSI in correct way

Stephen Hemminger (1):
      iscsi: add module alias

Stephen M. Cameron (2):
      hpsa: do not consider RAID level to be part of device identity
      hpsa: do not consider firmware revision when looking for device changes.

Swapnil Nagle (1):
      qla4xxx: memory wedge with peg_halt test in loop

Swen Schillig (5):
      zfcp: Redesign of the debug tracing final cleanup.
      zfcp: Redesign of the debug tracing for SCSI records.
      zfcp: Redesign of the debug tracing for HBA records.
      zfcp: Redesign of the debug tracing for SAN records.
      zfcp: Redesign of the debug tracing for recovery actions.

Tomas Henzl (1):
      lpfc: lower stack use in lpfc_fc_frame_check

Vikas Chaudhary (4):
      qla4xxx: Update driver version to 5.02.00-k5
      qla4xxx: Updated the Copyright header
      qla4xxx: do not reset hba if ql4xdontresethba is set
      qla4xxx: Drop use of IRQF_DISABLE

Wayne Boyer (2):
      ipr: fix mailbox register definition and add a delay before reading
      ipr: fix lun assignment and comparison

Yi Zou (6):
      libfc: fix fc_tm_done not freeing the allocated fsp pkt
      libfc: the timeout for the REC itself is 2 * R_A_TOV_els
      libfc: fix exchange being deleted when the abort itself is timed out
      libfc: do not fc_io_compl on fsp w/o any scsi_cmnd associated
      libfc: add print of exchange id for debugging fc_fcp
      libfc: fix NULL pointer dereference bug in fc_fcp_pkt_release

john fastabend (3):
      libfc: remove tgt_flags from fc_fcp_pkt struct
      libfc: use rport timeout values for fcp recovery
      libfc: incorrect scsi host byte codes returned to scsi-ml

roel kluin (1):
      arcmsr: fix write to device check

and the diffstat:

 Documentation/scsi/ChangeLog.megaraid_sas   |   22 
 drivers/s390/scsi/zfcp_aux.c                |    9 
 drivers/s390/scsi/zfcp_ccw.c                |   14 
 drivers/s390/scsi/zfcp_cfdc.c               |    8 
 drivers/s390/scsi/zfcp_dbf.c                | 1177 +-----
 drivers/s390/scsi/zfcp_dbf.h                |  497 +-
 drivers/s390/scsi/zfcp_erp.c                |  141 
 drivers/s390/scsi/zfcp_ext.h                |   52 
 drivers/s390/scsi/zfcp_fc.c                 |   20 
 drivers/s390/scsi/zfcp_fsf.c                |  113 
 drivers/s390/scsi/zfcp_qdio.c               |   10 
 drivers/s390/scsi/zfcp_scsi.c               |   43 
 drivers/s390/scsi/zfcp_sysfs.c              |    9 
 drivers/scsi/arcmsr/arcmsr_hba.c            |    3 
 drivers/scsi/be2iscsi/be_main.c             |    5 
 drivers/scsi/bfa/Makefile                   |    4 
 drivers/scsi/bfa/bfa.h                      |   36 
 drivers/scsi/bfa/bfa_cb_ioim.h              |  169 
 drivers/scsi/bfa/bfa_core.c                 |  373 -
 drivers/scsi/bfa/bfa_cs.h                   |   96 
 drivers/scsi/bfa/bfa_defs.h                 |    6 
 drivers/scsi/bfa/bfa_defs_svc.h             |    8 
 drivers/scsi/bfa/bfa_drv.c                  |  107 
 drivers/scsi/bfa/bfa_fc.h                   |  633 ---
 drivers/scsi/bfa/bfa_fcbuild.c              |  109 
 drivers/scsi/bfa/bfa_fcbuild.h              |   30 
 drivers/scsi/bfa/bfa_fcpim.c                |  698 ---
 drivers/scsi/bfa/bfa_fcpim.h                |  188 
 drivers/scsi/bfa/bfa_fcs.c                  |  206 -
 drivers/scsi/bfa/bfa_fcs.h                  |  124 
 drivers/scsi/bfa/bfa_fcs_fcpim.c            |   30 
 drivers/scsi/bfa/bfa_fcs_lport.c            |  390 --
 drivers/scsi/bfa/bfa_fcs_rport.c            |  230 -
 drivers/scsi/bfa/bfa_hw_cb.c                |    3 
 drivers/scsi/bfa/bfa_hw_ct.c                |    5 
 drivers/scsi/bfa/bfa_ioc.c                  |  749 +--
 drivers/scsi/bfa/bfa_ioc.h                  |   44 
 drivers/scsi/bfa/bfa_ioc_cb.c               |   97 
 drivers/scsi/bfa/bfa_ioc_ct.c               |  120 
 drivers/scsi/bfa/bfa_modules.h              |    3 
 drivers/scsi/bfa/bfa_os_inc.h               |  143 
 drivers/scsi/bfa/bfa_plog.h                 |    4 
 drivers/scsi/bfa/bfa_port.c                 |   37 
 drivers/scsi/bfa/bfa_port.h                 |    1 
 drivers/scsi/bfa/bfa_svc.c                  |  746 +--
 drivers/scsi/bfa/bfa_svc.h                  |   63 
 drivers/scsi/bfa/bfad.c                     |   38 
 drivers/scsi/bfa/bfad_attr.c                |   18 
 drivers/scsi/bfa/bfad_debugfs.c             |   46 
 drivers/scsi/bfa/bfad_drv.h                 |   45 
 drivers/scsi/bfa/bfad_im.c                  |   59 
 drivers/scsi/bfa/bfad_im.h                  |   16 
 drivers/scsi/bfa/bfi.h                      |    8 
 drivers/scsi/bfa/bfi_cbreg.h                |    1 
 drivers/scsi/bfa/bfi_ctreg.h                |   41 
 drivers/scsi/bfa/bfi_ms.h                   |   66 
 drivers/scsi/bnx2i/57xx_iscsi_constants.h   |    3 
 drivers/scsi/bnx2i/57xx_iscsi_hsi.h         |    3 
 drivers/scsi/bnx2i/bnx2i.h                  |   15 
 drivers/scsi/bnx2i/bnx2i_hwi.c              |   96 
 drivers/scsi/bnx2i/bnx2i_init.c             |  108 
 drivers/scsi/bnx2i/bnx2i_iscsi.c            |  148 
 drivers/scsi/bnx2i/bnx2i_sysfs.c            |    3 
 drivers/scsi/device_handler/scsi_dh.c       |   11 
 drivers/scsi/fcoe/fcoe.c                    |    4 
 drivers/scsi/fcoe/libfcoe.c                 |  300 +
 drivers/scsi/gdth.c                         |    4 
 drivers/scsi/gdth_proc.c                    |   16 
 drivers/scsi/hpsa.c                         |   11 
 drivers/scsi/hpsa.h                         |    1 
 drivers/scsi/ibmvscsi/ibmvfc.c              |   28 
 drivers/scsi/ibmvscsi/ibmvfc.h              |    2 
 drivers/scsi/ipr.c                          |   54 
 drivers/scsi/ipr.h                          |    2 
 drivers/scsi/libfc/fc_exch.c                |   48 
 drivers/scsi/libfc/fc_fcp.c                 |  147 
 drivers/scsi/libfc/fc_libfc.h               |   16 
 drivers/scsi/libfc/fc_lport.c               |   16 
 drivers/scsi/libfc/fc_rport.c               |    3 
 drivers/scsi/libiscsi.c                     |   64 
 drivers/scsi/libsas/sas_port.c              |   18 
 drivers/scsi/lpfc/lpfc.h                    |   26 
 drivers/scsi/lpfc/lpfc_attr.c               |  104 
 drivers/scsi/lpfc/lpfc_bsg.c                |   65 
 drivers/scsi/lpfc/lpfc_crtn.h               |   19 
 drivers/scsi/lpfc/lpfc_ct.c                 |   48 
 drivers/scsi/lpfc/lpfc_disc.h               |   19 
 drivers/scsi/lpfc/lpfc_els.c                |  327 +
 drivers/scsi/lpfc/lpfc_hbadisc.c            |  239 -
 drivers/scsi/lpfc/lpfc_hw.h                 |  222 -
 drivers/scsi/lpfc/lpfc_hw4.h                |  292 +
 drivers/scsi/lpfc/lpfc_init.c               | 1062 +++--
 drivers/scsi/lpfc/lpfc_logmsg.h             |    2 
 drivers/scsi/lpfc/lpfc_mbox.c               |   76 
 drivers/scsi/lpfc/lpfc_mem.c                |   10 
 drivers/scsi/lpfc/lpfc_nportdisc.c          |   16 
 drivers/scsi/lpfc/lpfc_scsi.c               |   82 
 drivers/scsi/lpfc/lpfc_sli.c                |  663 ++-
 drivers/scsi/lpfc/lpfc_sli.h                |    5 
 drivers/scsi/lpfc/lpfc_sli4.h               |   58 
 drivers/scsi/lpfc/lpfc_version.h            |    2 
 drivers/scsi/lpfc/lpfc_vport.c              |   10 
 drivers/scsi/megaraid/Makefile              |    2 
 drivers/scsi/megaraid/megaraid_sas.c        | 5193 --------------------------
 drivers/scsi/megaraid/megaraid_sas.h        |   78 
 drivers/scsi/megaraid/megaraid_sas_base.c   | 5444 ++++++++++++++++++++++++++++
 drivers/scsi/megaraid/megaraid_sas_fp.c     |  516 ++
 drivers/scsi/megaraid/megaraid_sas_fusion.c | 2248 +++++++++++
 drivers/scsi/megaraid/megaraid_sas_fusion.h |  695 +++
 drivers/scsi/mpt2sas/mpi/mpi2.h             |    9 
 drivers/scsi/mpt2sas/mpi/mpi2_cnfg.h        |   20 
 drivers/scsi/mpt2sas/mpi/mpi2_history.txt   |    3 
 drivers/scsi/mpt2sas/mpi/mpi2_init.h        |    9 
 drivers/scsi/mpt2sas/mpi/mpi2_ioc.h         |    8 
 drivers/scsi/mpt2sas/mpi/mpi2_raid.h        |    6 
 drivers/scsi/mpt2sas/mpi/mpi2_sas.h         |    9 
 drivers/scsi/mpt2sas/mpi/mpi2_tool.h        |   49 
 drivers/scsi/mpt2sas/mpt2sas_base.c         |  199 -
 drivers/scsi/mpt2sas/mpt2sas_base.h         |   27 
 drivers/scsi/mpt2sas/mpt2sas_ctl.c          |    2 
 drivers/scsi/mpt2sas/mpt2sas_scsih.c        |  343 -
 drivers/scsi/mpt2sas/mpt2sas_transport.c    |  185 
 drivers/scsi/qla2xxx/qla_attr.c             |   27 
 drivers/scsi/qla2xxx/qla_bsg.c              |    6 
 drivers/scsi/qla2xxx/qla_def.h              |    4 
 drivers/scsi/qla2xxx/qla_gbl.h              |    8 
 drivers/scsi/qla2xxx/qla_init.c             |   89 
 drivers/scsi/qla2xxx/qla_isr.c              |    2 
 drivers/scsi/qla2xxx/qla_mbx.c              |   67 
 drivers/scsi/qla2xxx/qla_nx.c               |  217 -
 drivers/scsi/qla2xxx/qla_nx.h               |    2 
 drivers/scsi/qla2xxx/qla_os.c               |   63 
 drivers/scsi/qla2xxx/qla_sup.c              |   11 
 drivers/scsi/qla4xxx/ql4_dbg.c              |    2 
 drivers/scsi/qla4xxx/ql4_dbg.h              |    2 
 drivers/scsi/qla4xxx/ql4_def.h              |    5 
 drivers/scsi/qla4xxx/ql4_fw.h               |    2 
 drivers/scsi/qla4xxx/ql4_glbl.h             |    2 
 drivers/scsi/qla4xxx/ql4_init.c             |    2 
 drivers/scsi/qla4xxx/ql4_inline.h           |    2 
 drivers/scsi/qla4xxx/ql4_iocb.c             |    2 
 drivers/scsi/qla4xxx/ql4_isr.c              |    9 
 drivers/scsi/qla4xxx/ql4_mbx.c              |   22 
 drivers/scsi/qla4xxx/ql4_nvram.c            |    2 
 drivers/scsi/qla4xxx/ql4_nvram.h            |    2 
 drivers/scsi/qla4xxx/ql4_nx.c               |   62 
 drivers/scsi/qla4xxx/ql4_nx.h               |    6 
 drivers/scsi/qla4xxx/ql4_os.c               |   30 
 drivers/scsi/qla4xxx/ql4_version.h          |    4 
 drivers/scsi/scsi_debug.c                   |    1 
 drivers/scsi/scsi_error.c                   |   61 
 drivers/scsi/scsi_lib.c                     |    5 
 drivers/scsi/scsi_sysfs.c                   |    6 
 drivers/scsi/scsi_transport_iscsi.c         |    1 
 drivers/scsi/sd.c                           |   99 
 drivers/scsi/st.c                           |    7 
 include/scsi/iscsi_if.h                     |    1 
 include/scsi/libfc.h                        |   10 
 include/scsi/libfcoe.h                      |    8 
 include/scsi/libiscsi.h                     |    4 
 include/scsi/libsas.h                       |    2 
 include/scsi/scsi.h                         |   28 
 162 files changed, 16069 insertions(+), 12242 deletions(-)

James
