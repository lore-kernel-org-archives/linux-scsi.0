From: "Nicholas A. Bellinger" <nab@daterainc.com>
Subject: [PATCH 0/2] tcm_fc: Generate TASK_SET_FULL for DataIN + response failures
Date: Thu,  5 Jun 2014 23:30:00 +0000
Message-ID: <1402011002-20771-1-git-send-email-nab@daterainc.com>
Return-path: <target-devel-owner@vger.kernel.org>
Sender: target-devel-owner@vger.kernel.org
To: target-devel <target-devel@vger.kernel.org>
Cc: linux-scsi <linux-scsi@vger.kernel.org>, fcoe-devel <fcoe-devel@open-fcoe.org>, Nicholas Bellinger <nab@linux-iscsi.org>
List-Id: linux-scsi@vger.kernel.org

From: Nicholas Bellinger <nab@linux-iscsi.org>

Hi Vasu,

This series generates SAM_STAT_TASK_SET_FULL status for lport->tt.seq_send()
failures in DataIN + response status codepaths, which is done in order to get
the initiator to reduce it's current queue_depth thus reducing the number of
outstanding I/Os permitted in flight on the wire.

For the DataIN case, once a lport->tt.seq_send() failure occurs it will stop
attempting to send subsequent DataIN payload data, and immediately attempt to
send a response packet with SAM_STAT_TASK_SET_FULL status.

For the response case, once a lport->tt.seq_send() failure occurs it will
set SAM_STAT_TASK_SET_FULL status and return -ENOMEM to the target, forcing
the response to be requeued by target-core

Note this series has been compile tested only, so please review + test.

Thank you,

--nab

Nicholas Bellinger (2):
  tcm_fc: Generate TASK_SET_FULL status for DataIN failures
  tcm_fc: Generate TASK_SET_FULL status for response failures

 drivers/target/tcm_fc/tfc_cmd.c |   19 ++++++++++++++++---
 drivers/target/tcm_fc/tfc_io.c  |   14 +++++++++++++-
 2 files changed, 29 insertions(+), 4 deletions(-)

-- 
1.7.10.4
