From: "Nicholas A. Bellinger" <nab@linux-iscsi.org>
Subject: [PATCH 0/4] target: LUN_RESET bugfixes for HW target mode
Date: Fri, 30 Sep 2011 04:55:07 +0000
Message-ID: <1317358511-10664-1-git-send-email-nab@linux-iscsi.org>
Return-path: <target-devel-owner@vger.kernel.org>
Sender: target-devel-owner@vger.kernel.org
To: target-devel <target-devel@vger.kernel.org>, linux-scsi <linux-scsi@vger.kernel.org>
Cc: Roland Dreier <roland@purestorage.com>, Nicholas Bellinger <nab@linux-iscsi.org>
List-Id: linux-scsi@vger.kernel.org

From: Nicholas Bellinger <nab@linux-iscsi.org>

Hi folks,

This patch series addresses a number of issues that have come up recently for
TMR LUN_RESET operation with HW target mode + qla2xxx/tcm_qla2xxx code.  Aside
from the various bugfixes in this series, the big change is the re-org of
core_tmr_lun_reset() logic to prevent possible list corruption while scanning
the various lists and breaking this out of this code into seperate functions.

I know the re-org patch diff is very difficult to read without more context, so
apologies ahead of time for that.  At this point it makes sense to queue these
for v3.2, and CC stable to ensure they are also picked up for v3.1 target code
as well.

Please let us know if you have any comments.

Thank you,

--nab

Nicholas Bellinger (3):
  target: Re-org of core_tmr_lun_reset + FREE_CMD_INTR bugfix
  target: Fix transport_cmd_finish_abort queue removal bug
  target: Prevent transport_send_task_abort when CHECK_CONDITION status

Roland Dreier (1):
  target: Prevent cmd->se_queue_node double add

 drivers/target/target_core_tmr.c       |  228 ++++++++++++++++++++------------
 drivers/target/target_core_transport.c |   45 ++++---
 2 files changed, 169 insertions(+), 104 deletions(-)

-- 
1.7.2.5

