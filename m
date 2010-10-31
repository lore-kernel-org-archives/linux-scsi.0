From: James Bottomley <James.Bottomley@suse.de>
Subject: [GIT PATCH] final SCSI updates for the merge window.
Date: Sun, 31 Oct 2010 09:46:03 -0500
Message-ID: <1288536363.3056.7.camel@mulgrave.site>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from cantor2.suse.de ([195.135.220.15]:38518 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755733Ab0JaOqJ (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Sun, 31 Oct 2010 10:46:09 -0400
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Andrew Morton <akpm@linux-foundation.org>, Linus Torvalds <torvalds@linux-foundation.org>
Cc: linux-scsi <linux-scsi@vger.kernel.org>, linux-kernel <linux-kernel@vger.kernel.org>

The main pieces of this are qla2xxx, qla4xxx, lpfc megaraid_sas, and
fcoe driver updates.  Plus some well documented bfa cleanups and a
couple of assorted bug fixes.

Also, I'd like to do a queuecommand API change in -rc1.  I'd like to
push the queue lock out of the mid layer and into the drivers'
queuecommand routine which will eliminate a spurious lock and unlock for
drivers that don't need it (should improve latency for multicore) Andi
Kleen has a coccinelle script to do this mechanically, so it will be a
big bang single commit for all drivers.  We'll do the optimisations as
part of the usual enhancements in the next merge window, but I'd like
the mechanical API change to go in last when the tree is getting stable.

The current patch is available here:

master.kernel.org:/pub/scm/linux/kernel/git/jejb/scsi-misc-2.6.git

The Short Changelog is:

Andrew Vasquez (2):
      qla2xxx: Correct PRLI failure response code handling.
      qla2xxx: Initialize the vport_slock spinlock.

Anil Ravindranath (2):
      pmcraid: add support for set timestamp command and other fixes
      pmcraid: remove duplicate struct member

Bhanu Prakash Gollapudi (1):
      libfc: Do not let disc work cancel itself

Boaz Harrosh (4):
      libosd: write/read_sg_kern API
      libosd: Support for scatter gather write/read commands
      libosd: Free resources in reverse order of allocation
      libosd: Fix bug in attr_page handling

Chad Dupuis (4):
      qla2xxx: Group CS_RESET return status with other link level event statuses.
      qla2xxx: Change del_timer_sync() to del_timer() in qla2x00_ctx_sp_free().
      qla2xxx: Add module parameter to enable/disable GFF_ID device type check.
      qla2xxx: Remove port down retry count.

Chauhan, Vijay (1):
      scsi_dh_rdac: Add two new SUN devices to rdac_dev_list

Christof Schmitt (3):
      Fix race when removing SCSI devices
      zfcp: Use correct length for FCP_RSP_INFO
      zfcp: Call get_device on port before calling put_device

Dan Carpenter (2):
      qla2xxx: locking problem in qla2x00_init_rings()
      gdth: integer overflow in ioctl

Giridhar Malavali (1):
      qla2xxx: Avoid depending on SCSI host_lock in queuecommand function.

Harish Zunjarrao (1):
      qla2xxx: Add flash read/update support using BSG interface

James Smart (7):
      lpfc 8.3.18: Update lpfc driver version to 8.3.18
      lpfc 8.3.18: Add new WQE support
      lpfc 8.3.18: Fix critical errors
      lpfc 8.3.18: Adapter Shutdown and Unregistration cleanup
      lpfc 8.3.18: Add logic to detect last devloss timeout
      lpfc 8.3.18: Add support of received ELS commands
      lpfc 8.3.18: FC/FCoE Discovery fixes

Jing Huang (6):
      bfa: fix comments for c files
      bfa: fix comments for header files
      bfa: fix frame size over 1024 compile warning
      bfa: remove os wrapper functions and macros
      bfa: replace endian swap macros with the ones provided by linux
      bfa: remove os wrapper and unused functions

Karen Higgins (1):
      qla4xxx: dump mailbox registers on System Error

Karen Xie (1):
      cxgb4i: ignore informational act-open-rpl message

Kiran Patil (1):
      libfcoe: VN2VN connection setup causing stack memory corruption.

Lalit Chandivade (1):
      qla4xxx: Reset seconds_since_last_heartbeat correctly.

Madhuranath Iyengar (2):
      qla2xxx: Addition of shutdown callback handler.
      qla2xxx: Remove scsi_cmnd->serial_number from debug traces

Martin K. Petersen (1):
      sd: Export effective protection mode in sysfs

Mike Christie (5):
      qla4xxx: Fix cmd check in qla4xxx_cmd_wait
      qla2xxx: Drop srb reference before waiting for completion.
      libfc: fix setting of rport dev loss
      qla4xxx: grab hardware_lock in eh_abort before accessing srb
      Fix regressions in scsi_internal_device_block

Nilesh Javali (1):
      qla4xxx: On firmware hang do not wait for the outstanding commands to complete

Robert Jennings (1):
      sr: fix sr_drive_status handling when initialization required

Robert Love (1):
      fcoe: Fix broken NPIV with correction to MAC validation

Shyam Sundar (3):
      qla4xxx: Clear the rom lock if the firmware died while holding it.
      qla4xxx: use CRB Register for Request Queue in-pointer
      qla4xxx: Add support for 8130/8131 AENs.

Swen Schillig (1):
      zfcp: Fix adapter activation on link down

Vasu Dev (4):
      libfc: possible race could panic system due to NULL fsp->cmd
      fcoe: set default FIP mode as FIP_MODE_FABRIC
      libfc: adds flogi retry in case DID is zero in RJT
      libfc: use DID_TRANSPORT_DISRUPTED while lport not ready

Vikas Chaudhary (8):
      qla4xxx: Update driver version to 5.02.00-k4
      qla4xxx: remove unwanted check for bad spd
      qla4xxx: update AER support for ISP82XX
      qla4xxx: free_irqs on failed initialize_adapter
      qla4xxx: correct data type of sense_len in qla4xxx_status_cont_entry
      qla4xxx: remove "ha->retry_reset_ha_cnt" from wait_for_hba_online
      qla4xxx: honor return status of qla4xxx_hw_reset
      qla4xxx: Trivial cleanup

Wayne Boyer (1):
      ipr: add definitions for a new adapter

Yang, Bo (4):
      megaraid_sas: Version and documentation update
      megaraid_sas: Add three times Online controller reset
      megaraid_sas: Add input parameter for max_sectors
      megaraid_sas: support devices update flag

And the diffstat:

 Documentation/scsi/ChangeLog.megaraid_sas  |   47 ++
 drivers/s390/scsi/zfcp_fc.h                |    2 
 drivers/s390/scsi/zfcp_fsf.c               |    3 
 drivers/s390/scsi/zfcp_unit.c              |    4 
 drivers/scsi/bfa/bfa.h                     |   48 +-
 drivers/scsi/bfa/bfa_cb_ioim.h             |   22 -
 drivers/scsi/bfa/bfa_core.c                |  178 +++++-----
 drivers/scsi/bfa/bfa_cs.h                  |   24 -
 drivers/scsi/bfa/bfa_defs.h                |   54 +--
 drivers/scsi/bfa/bfa_defs_fcs.h            |   48 +-
 drivers/scsi/bfa/bfa_defs_svc.h            |   82 ++--
 drivers/scsi/bfa/bfa_drv.c                 |    6 
 drivers/scsi/bfa/bfa_fc.h                  |   30 -
 drivers/scsi/bfa/bfa_fcbuild.c             |  196 +++++------
 drivers/scsi/bfa/bfa_fcpim.c               |  351 ++++++++++----------
 drivers/scsi/bfa/bfa_fcpim.h               |   18 -
 drivers/scsi/bfa/bfa_fcs.c                 |  335 +++----------------
 drivers/scsi/bfa/bfa_fcs.h                 |   43 --
 drivers/scsi/bfa/bfa_fcs_fcpim.c           |   34 -
 drivers/scsi/bfa/bfa_fcs_lport.c           |  468 +++++++++++---------------
 drivers/scsi/bfa/bfa_fcs_rport.c           |  198 +++++------
 drivers/scsi/bfa/bfa_hw_cb.c               |   16 
 drivers/scsi/bfa/bfa_hw_ct.c               |   22 -
 drivers/scsi/bfa/bfa_ioc.c                 |  397 +++++++++++-----------
 drivers/scsi/bfa/bfa_ioc.h                 |  108 +++---
 drivers/scsi/bfa/bfa_ioc_cb.c              |   90 ++---
 drivers/scsi/bfa/bfa_ioc_ct.c              |  167 ++++-----
 drivers/scsi/bfa/bfa_modules.h             |    6 
 drivers/scsi/bfa/bfa_os_inc.h              |   82 ----
 drivers/scsi/bfa/bfa_port.c                |   40 +-
 drivers/scsi/bfa/bfa_svc.c                 |  504 ++++++++++++++---------------
 drivers/scsi/bfa/bfa_svc.h                 |   41 +-
 drivers/scsi/bfa/bfad.c                    |   73 ----
 drivers/scsi/bfa/bfad_attr.c               |   38 +-
 drivers/scsi/bfa/bfad_debugfs.c            |    4 
 drivers/scsi/bfa/bfad_drv.h                |    5 
 drivers/scsi/bfa/bfad_im.c                 |   71 ++--
 drivers/scsi/bfa/bfi.h                     |   58 +--
 drivers/scsi/bfa/bfi_ms.h                  |   50 +-
 drivers/scsi/cxgbi/cxgb4i/cxgb4i.c         |    3 
 drivers/scsi/device_handler/scsi_dh_rdac.c |    2 
 drivers/scsi/fcoe/fcoe.c                   |   18 -
 drivers/scsi/fcoe/libfcoe.c                |    2 
 drivers/scsi/gdth.c                        |    8 
 drivers/scsi/ipr.c                         |    2 
 drivers/scsi/ipr.h                         |    1 
 drivers/scsi/libfc/fc_disc.c               |    5 
 drivers/scsi/libfc/fc_fcp.c                |   24 -
 drivers/scsi/libfc/fc_lport.c              |   12 
 drivers/scsi/libfc/fc_rport.c              |    4 
 drivers/scsi/lpfc/lpfc.h                   |   12 
 drivers/scsi/lpfc/lpfc_attr.c              |    7 
 drivers/scsi/lpfc/lpfc_bsg.c               |    4 
 drivers/scsi/lpfc/lpfc_crtn.h              |    4 
 drivers/scsi/lpfc/lpfc_els.c               |  439 +++++++++++++++++++++----
 drivers/scsi/lpfc/lpfc_hbadisc.c           |  437 ++++++++++++++++++-------
 drivers/scsi/lpfc/lpfc_hw.h                |   41 ++
 drivers/scsi/lpfc/lpfc_hw4.h               |  167 ++++-----
 drivers/scsi/lpfc/lpfc_init.c              |  102 ++++-
 drivers/scsi/lpfc/lpfc_mbox.c              |   28 +
 drivers/scsi/lpfc/lpfc_scsi.c              |    9 
 drivers/scsi/lpfc/lpfc_sli.c               |  458 +++++++++++++++-----------
 drivers/scsi/lpfc/lpfc_sli4.h              |    9 
 drivers/scsi/lpfc/lpfc_version.h           |    2 
 drivers/scsi/megaraid/megaraid_sas.c       |  126 +++++++
 drivers/scsi/megaraid/megaraid_sas.h       |    7 
 drivers/scsi/osd/osd_initiator.c           |  244 +++++++++++++-
 drivers/scsi/pmcraid.c                     |  129 ++++++-
 drivers/scsi/pmcraid.h                     |   23 +
 drivers/scsi/qla2xxx/qla_attr.c            |    4 
 drivers/scsi/qla2xxx/qla_bsg.c             |  125 +++++++
 drivers/scsi/qla2xxx/qla_bsg.h             |    2 
 drivers/scsi/qla2xxx/qla_def.h             |    2 
 drivers/scsi/qla2xxx/qla_gbl.h             |    1 
 drivers/scsi/qla2xxx/qla_init.c            |   28 -
 drivers/scsi/qla2xxx/qla_iocb.c            |    4 
 drivers/scsi/qla2xxx/qla_isr.c             |   21 -
 drivers/scsi/qla2xxx/qla_os.c              |  207 +++++------
 drivers/scsi/qla4xxx/ql4_dbg.c             |  101 +++++
 drivers/scsi/qla4xxx/ql4_def.h             |   20 -
 drivers/scsi/qla4xxx/ql4_fw.h              |    3 
 drivers/scsi/qla4xxx/ql4_glbl.h            |    1 
 drivers/scsi/qla4xxx/ql4_init.c            |   10 
 drivers/scsi/qla4xxx/ql4_iocb.c            |   10 
 drivers/scsi/qla4xxx/ql4_isr.c             |   16 
 drivers/scsi/qla4xxx/ql4_mbx.c             |   11 
 drivers/scsi/qla4xxx/ql4_nx.c              |   89 ++---
 drivers/scsi/qla4xxx/ql4_nx.h              |    5 
 drivers/scsi/qla4xxx/ql4_os.c              |  109 +++---
 drivers/scsi/qla4xxx/ql4_version.h         |    2 
 drivers/scsi/scsi_lib.c                    |    3 
 drivers/scsi/scsi_sysfs.c                  |    3 
 drivers/scsi/sd.c                          |   23 +
 drivers/scsi/sr_ioctl.c                    |    9 
 include/scsi/libfc.h                       |    2 
 include/scsi/osd_initiator.h               |   16 
 include/scsi/osd_protocol.h                |   42 ++
 include/scsi/osd_types.h                   |    5 
 98 files changed, 4160 insertions(+), 3006 deletions(-)

James


