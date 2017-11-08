From: "Nicholas A. Bellinger" <nab@linux-iscsi.org>
Subject: [PATCH 0/6] target fixes for v4.15-rc1
Date: Wed,  8 Nov 2017 04:31:46 +0000
Message-ID: <1510115512-15617-1-git-send-email-nab@linux-iscsi.org>
Return-path: <target-devel-owner@vger.kernel.org>
Sender: target-devel-owner@vger.kernel.org
To: target-devel <target-devel@vger.kernel.org>
Cc: linux-scsi <linux-scsi@vger.kernel.org>, lkml <linux-kernel@vger.kernel.org>, Nicholas Bellinger <nab@linux-iscsi.org>
List-Id: linux-scsi@vger.kernel.org

From: Nicholas Bellinger <nab@linux-iscsi.org>

Hi all,

Here are the outstanding target bugfixes in queue for v4.15-rc1
code.

Patch #1 addresses a long standing bug wrt to QUEUE_FULL and
SCSI task attribute handling, that results in SCSI task related
counters getting updated multiple times during QUEUE_FULL.

It primarly effects hosts using ORDERED tasks, which depend upon
these counters to know when to delay incoming tasks.

Patch #2 is for a recent v4.11+ regression, which during ABORT
of COMPARE_AND_WRITE can result in se_device->cam_sem getting
leaked due to se_cmd->transport_complete_callback() being
skipped.

Patch #3 addresses a possible end-less loop during QUEUE_FULL +
TFO->write_pending() failure, allowing se_cmd quiese to properly
complete the outstanding descriptor when requested.

Patch #4 addresses a use-after-tree that was hit in the field,
involving pre-backend execution se_cmd exceptions + subsequent
ABORT_TASK for a matching tag.

Patch #5 + #6 address a iscsi-target TMR related memory and
se_cmd->cmd_kref reference leaks respectively.

We've been testing #4, #5, and #6 internally on v4.1.y stable
code, and have not run into additional regressions.

The rest are straight-forward.

Please review.

--nab

Nicholas Bellinger (6):
  target: Fix QUEUE_FULL + SCSI task attribute handling
  target: Fix caw_sem leak in transport_generic_request_failure
  target: Fix quiese during transport_write_pending_qf endless loop
  target: Avoid early CMD_T_PRE_EXECUTE failures during ABORT_TASK
  iscsi-target: Make TASK_REASSIGN use proper se_cmd->cmd_kref
  iscsi-target: Fix non-immediate TMR reference leak

 drivers/target/iscsi/iscsi_target.c    | 30 ++++++++++++++----------------
 drivers/target/target_core_tmr.c       |  9 +++++++++
 drivers/target/target_core_transport.c | 26 +++++++++++++++++++++++---
 include/target/target_core_base.h      |  1 +
 4 files changed, 47 insertions(+), 19 deletions(-)

-- 
1.9.1
