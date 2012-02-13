From: "Nicholas A. Bellinger" <nab@linux-iscsi.org>
Subject: [PATCH 0/4] target/tcm_qla2xxx: Add TMR_ABORT_TASK support
Date: Mon, 13 Feb 2012 11:42:23 +0000
Message-ID: <1329133347-13359-1-git-send-email-nab@linux-iscsi.org>
Return-path: <target-devel-owner@vger.kernel.org>
Sender: target-devel-owner@vger.kernel.org
To: target-devel <target-devel@vger.kernel.org>, linux-scsi <linux-scsi@vger.kernel.org>
Cc: Andrew Vasquez <andrew.vasquez@qlogic.com>, Giridhar Malavali <giridhar.malavali@qlogic.com>, Arun Easi <arun.easi@qlogic.com>, Christoph Hellwig <hch@lst.de>, Roland Dreier <roland@purestorage.com>, Madhuranath Iyengar <mni@risingtidesystems.com>, Nicholas Bellinger <nab@linux-iscsi.org>
List-Id: linux-scsi@vger.kernel.org

From: Nicholas Bellinger <nab@linux-iscsi.org>

Hi folks,

The following series adds explict TMR_ABORT_TASK support using session
command list descriptors for target_submit_cmd() fabric module users.

The logic performs explict abort using tmr->ref_task_tag for outstanding
descriptors have not been set CMD_T_COMPLETE in transport_complete_task()
during backend I/O completion.  It also cancels se_cmd->work and wait for
backing I/O to complete before attempting to send SAM_STAT_TASK_ABORTED
and perform necessary target_put_sess_cmd() to drop outstanding cmd_kref
references.

So far this has been tested with tcm_qla2xxx using target-core debug code
to simulate delayed execution of a referenced tag descriptor in the
following locations:

- Before execution of tasks in transport_generic_new_cmd()
- Before completion of tasks in transport_complete_task() 
- After completion of tasks in transport_complete_task()

The code can use some more testing and review, but so far these changes
with simulated I/O delays are generating SAM_STAT_TASK_ABORTED status for
the aborted tag, or failing with TMR_TASK_DOES_NOT_EXIST as expected..

Please have a look,

--nab

Nicholas Bellinger (4):
  target: Add SCF_ACK_KREF flag for acknowledgement kref
  target: Make target_release_cmd_kref release on empty list
  target: Add TMR_ABORT_TASK task management support
  qla_target/tcm_qla2xxx: Fix TMR_ABORT_TASK with target mode usage

 drivers/scsi/qla2xxx/qla_target.c      |   15 +++----
 drivers/scsi/qla2xxx/qla_target.h      |    2 +-
 drivers/scsi/qla2xxx/tcm_qla2xxx.c     |    6 ++-
 drivers/scsi/qla2xxx/tcm_qla2xxx.h     |    3 +-
 drivers/target/target_core_internal.h  |    2 +
 drivers/target/target_core_tmr.c       |   64 ++++++++++++++++++++++++++++++++
 drivers/target/target_core_transport.c |   26 ++++++++----
 include/target/target_core_base.h      |    3 +-
 8 files changed, 100 insertions(+), 21 deletions(-)

-- 
1.7.2.5
