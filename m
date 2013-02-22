From: James Bottomley <James.Bottomley@HansenPartnership.com>
Subject: [GIT PULL] First round of SCSI updates for the 3.8+ merge window
Date: Fri, 22 Feb 2013 10:36:21 +0000
Message-ID: <1361529381.2372.23.camel@dabdike.int.hansenpartnership.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="ISO-8859-15"
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from bedivere.hansenpartnership.com ([66.63.167.143]:41347 "EHLO
	bedivere.hansenpartnership.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754440Ab3BVKgZ (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Fri, 22 Feb 2013 05:36:25 -0500
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Andrew Morton <akpm@linux-foundation.org>, Linus Torvalds <torvalds@linux-foundation.org>
Cc: linux-scsi <linux-scsi@vger.kernel.org>, linux-kernel <linux-kernel@vger.kernel.org>

This is the first round, consisting mostly of drivers and patches
submitted 3 weeks ago.  Since I've been travelling quite a bit, there
will be a second round just before the merge window closes for all the
patches three weeks or newer (that includes the FCoE tree).

The patch set is mostly driver updates (bnx2fc, ipr, lpfc, qla4) and a
few bug fixes.

The patch is available here:

git://git.kernel.org/pub/scm/linux/kernel/git/jejb/scsi.git scsi-misc

The short changelog is

Bhanu Prakash Gollapudi (6):
      bnx2fc: Bumped version to 1.0.13
      bnx2fc: Support max IO size to 512KB
      bnx2fc: Tx/Rx byte counts reset to 0 when exceeding 32 bit values
      bnx2fc: Map the doorbell register between offload and enable requests
      bnx2fc: Move offload/upload wait logic into a function
      bnx2fc: support software fcoe target

Bjorn Helgaas (1):
      gdth: Remove buggy ROM handling

Brian King (2):
      ipr: Resource path error logging cleanup
      ipr: Handler ID memory allocation failure at module load time

Cyril Roelandt (1):
      bnx2fc: remove useless calls to memset().

Dan Carpenter (2):
      bfa: fix strncpy() limiter in bfad_start_ops()
      mpt3sas: cut and paste bug storing trigger mpi

Harish Zunjarrao (1):
      qla4xxx: Allow reset in link down case

Hiral Patel (2):
      fnic: fix for trusted cos
      fnic: updated MAINTAINERS list

James Smart (11):
      lpfc 8.3.37: Update lpfc version for 8.3.37 driver release
      lpfc 8.3.37: Fixed infinite loop in lpfc_sli4_fcf_rr_next_index_get.
      lpfc 8.3.37: Fixed crash due to SLI Port invalid resource count
      lpfc 8.3.37: Provide support for FCoE protocol dual-chute (ULP) operation
      lpfc 8.3.37: Fixed stale ndlp state when the node is marked for deferred removal.
      lpfc 8.3.37: Fix potential memory corruption bug
      lpfc 8.3.37: Fixed no-context ABTS failed with BA_RJT
      lpfc 8.3.37: Removed use of NOP mailboxes for interrupt verification
      lpfc 8.3.37: Fixed exhausted retry for plogi to nameserver.
      lpfc 8.3.37: Fixed ELS_REC received on the unsolicited receive queue
      lpfc 8.3.37: Provide support for change_queue_type

Jesper Juhl (1):
      csiostor: Don't leak mem or fail to release firmware in csio_hw_flash_config()

Julia Lawall (2):
      bnx2fc: adjust duplicate test
      bnx2fc: Remove potential NULL dereference

Karen Higgins (2):
      qla4xxx: Throttle active IOCBs to firmware limits
      qla4xxx: Remove unnecessary code from qla4xxx_init_local_data

Mahesh Rajashekhara (1):
      aacraid: 1024 max outstanding command support for Series 7 and above

Manish Rangankar (4):
      qla4xxx: Fix return code for qla4xxx_session_get_param.
      qla4xxx: wait for boot target login response during probe.
      scsi_transport_iscsi: export iscsi class session's target_id in sysfs.
      qla4xxx: Fix memory corruption issue in qla4xxx_get_ep_fwdb.

Nilesh Javali (4):
      qla4xxx: Quiesce driver activities while loopback
      qla4xxx: Rename MBOX_ASTS_IDC_NOTIFY to MBOX_ASTS_IDC_REQUEST_NOTIFICATION
      qla4xxx: Add spurious interrupt messages under debug level 2
      qla4xxx: Correct the validation to check in get_sys_info mailbox

Poornima Vonti (1):
      qla4xxx: Re-register IRQ handler while retrying initialize of adapter

Sachin Kamat (1):
      mpt3sas: Remove unneeded version.h header inclusion

Sreekanth Reddy (1):
      mpt2sas: fix for driver fails EEH, recovery from injected pci bus error

Thadeu Lima de Souza Cascardo (1):
      cxgb4i: Remove the scsi host device when removing device

Tomas Henzl (1):
      bnx2i: fix the bit manipulation when setting the error mask

Vijaya Mohan Guvva (1):
      bfa: Update MAINTAINERS list for BFA driver

Vikas Chaudhary (6):
      qla4xxx: Update driver version to 5.03.00-k4
      qla4xxx: Added support for force firmware dump
      qla4xxx: Update driver version to 5.03.00-k3
      qla4xxx: Pass correct function param to qla4_8xxx_rd_direct
      qla4xxx: Update driver version to 5.03.00-k2
      qla4xxx: Fix MBOX intr switching from polling to intr mode for ISP83XX

Wei Yongjun (2):
      mpt3sas: remove unused variables
      csiostor: convert to use simple_open()

wenxiong@linux.vnet.ibm.com (6):
      ipr: Fix sparse error in ipr driver
      ipr: Driver version 2.6.0
      ipr: Implement block iopoll
      ipr: Reduce lock contention
      ipr: Add support for MSI-X and distributed completion
      ipr: Add sereral new CCIN definitions for new adapters support

And the diffstat:

 MAINTAINERS                                 |    7 +-
 drivers/scsi/aacraid/aacraid.h              |    8 +-
 drivers/scsi/aacraid/comminit.c             |   11 +-
 drivers/scsi/bfa/bfad.c                     |    2 +-
 drivers/scsi/bnx2fc/bnx2fc.h                |   27 +-
 drivers/scsi/bnx2fc/bnx2fc_fcoe.c           |   21 +-
 drivers/scsi/bnx2fc/bnx2fc_hwi.c            |   29 +-
 drivers/scsi/bnx2fc/bnx2fc_io.c             |    8 +-
 drivers/scsi/bnx2fc/bnx2fc_tgt.c            |   95 +-
 drivers/scsi/bnx2i/bnx2i_hwi.c              |    2 +-
 drivers/scsi/csiostor/csio_hw.c             |   15 +-
 drivers/scsi/csiostor/csio_init.c           |    9 +-
 drivers/scsi/cxgbi/cxgb4i/cxgb4i.c          |    1 +
 drivers/scsi/fnic/fnic_fcs.c                |    6 +-
 drivers/scsi/gdth.c                         |   10 +-
 drivers/scsi/ipr.c                          | 1296 ++++++++++++++++++++-------
 drivers/scsi/ipr.h                          |  101 ++-
 drivers/scsi/lpfc/lpfc.h                    |   17 +-
 drivers/scsi/lpfc/lpfc_bsg.c                |   51 +-
 drivers/scsi/lpfc/lpfc_crtn.h               |    4 +-
 drivers/scsi/lpfc/lpfc_ct.c                 |   37 +-
 drivers/scsi/lpfc/lpfc_els.c                |   25 +-
 drivers/scsi/lpfc/lpfc_hw.h                 |    2 +
 drivers/scsi/lpfc/lpfc_hw4.h                |  176 ++--
 drivers/scsi/lpfc/lpfc_init.c               |  251 ++----
 drivers/scsi/lpfc/lpfc_nportdisc.c          |   10 +
 drivers/scsi/lpfc/lpfc_scsi.c               |   24 +-
 drivers/scsi/lpfc/lpfc_sli.c                |  378 ++++++--
 drivers/scsi/lpfc/lpfc_sli4.h               |    8 +
 drivers/scsi/lpfc/lpfc_version.h            |    2 +-
 drivers/scsi/mpt2sas/mpt2sas_base.c         |   19 +-
 drivers/scsi/mpt2sas/mpt2sas_base.h         |    1 +
 drivers/scsi/mpt3sas/mpt3sas_base.c         |    5 +-
 drivers/scsi/mpt3sas/mpt3sas_config.c       |    1 -
 drivers/scsi/mpt3sas/mpt3sas_ctl.c          |    3 +-
 drivers/scsi/mpt3sas/mpt3sas_scsih.c        |    3 -
 drivers/scsi/mpt3sas/mpt3sas_trigger_diag.c |    1 -
 drivers/scsi/qla4xxx/ql4_83xx.c             |   55 +-
 drivers/scsi/qla4xxx/ql4_attr.c             |   16 +-
 drivers/scsi/qla4xxx/ql4_def.h              |   10 +-
 drivers/scsi/qla4xxx/ql4_fw.h               |    6 +-
 drivers/scsi/qla4xxx/ql4_glbl.h             |    6 +-
 drivers/scsi/qla4xxx/ql4_init.c             |   17 +-
 drivers/scsi/qla4xxx/ql4_iocb.c             |    2 +-
 drivers/scsi/qla4xxx/ql4_isr.c              |   68 +-
 drivers/scsi/qla4xxx/ql4_mbx.c              |   61 +-
 drivers/scsi/qla4xxx/ql4_nx.c               |   14 +-
 drivers/scsi/qla4xxx/ql4_os.c               |  160 ++--
 drivers/scsi/qla4xxx/ql4_version.h          |    2 +-
 drivers/scsi/scsi_transport_iscsi.c         |   12 +
 50 files changed, 2169 insertions(+), 926 deletions(-)

James


