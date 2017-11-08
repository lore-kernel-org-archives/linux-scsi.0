From: "Nicholas A. Bellinger" <nab@linux-iscsi.org>
Subject: [PATCH 2/6] target: Fix caw_sem leak in transport_generic_request_failure
Date: Wed,  8 Nov 2017 04:31:48 +0000
Message-ID: <1510115512-15617-3-git-send-email-nab@linux-iscsi.org>
References: <1510115512-15617-1-git-send-email-nab@linux-iscsi.org>
Return-path: <target-devel-owner@vger.kernel.org>
In-Reply-To: <1510115512-15617-1-git-send-email-nab@linux-iscsi.org>
Sender: target-devel-owner@vger.kernel.org
To: target-devel <target-devel@vger.kernel.org>
Cc: linux-scsi <linux-scsi@vger.kernel.org>, lkml <linux-kernel@vger.kernel.org>, Nicholas Bellinger <nab@linux-iscsi.org>, Mike Christie <mchristi@redhat.com>, Hannes Reinecke <hare@suse.com>, Bart Van Assche <bart.vanassche@sandisk.com>
List-Id: linux-scsi@vger.kernel.org

From: Nicholas Bellinger <nab@linux-iscsi.org>

With the recent addition of transport_check_aborted_status() within
transport_generic_request_failure() to avoid sending a SCSI status
exception after CMD_T_ABORTED w/ TAS=1 has occured, it introduced
a COMPARE_AND_WRITE early failure regression.

Namely when COMPARE_AND_WRITE fails and se_device->caw_sem has
been taken by sbc_compare_and_write(), if the new check for
transport_check_aborted_status() returns true and exits,
cmd->transport_complete_callback() -> compare_and_write_post()
is skipped never releasing se_device->caw_sem.

This regression was originally introduced by:

  commit e3b88ee95b4e4bf3e9729a4695d695b9c7c296c8
  Author: Bart Van Assche <bart.vanassche@sandisk.com>
  Date:   Tue Feb 14 16:25:45 2017 -0800

      target: Fix handling of aborted failed commands

To address this bug, move the transport_check_aborted_status()
call after transport_complete_task_attr() and
cmd->transport_complete_callback().

Cc: Mike Christie <mchristi@redhat.com>
Cc: Hannes Reinecke <hare@suse.com>
Cc: Bart Van Assche <bart.vanassche@sandisk.com>
Signed-off-by: Nicholas Bellinger <nab@linux-iscsi.org>
---
 drivers/target/target_core_transport.c | 7 ++++---
 1 file changed, 4 insertions(+), 3 deletions(-)

diff --git a/drivers/target/target_core_transport.c b/drivers/target/target_core_transport.c
index c33d1e9..d02218c 100644
--- a/drivers/target/target_core_transport.c
+++ b/drivers/target/target_core_transport.c
@@ -1729,9 +1729,6 @@ void transport_generic_request_failure(struct se_cmd *cmd,
 {
 	int ret = 0, post_ret = 0;
 
-	if (transport_check_aborted_status(cmd, 1))
-		return;
-
 	pr_debug("-----[ Storage Engine Exception; sense_reason %d\n",
 		 sense_reason);
 	target_show_cmd("-----[ ", cmd);
@@ -1740,6 +1737,7 @@ void transport_generic_request_failure(struct se_cmd *cmd,
 	 * For SAM Task Attribute emulation for failed struct se_cmd
 	 */
 	transport_complete_task_attr(cmd);
+
 	/*
 	 * Handle special case for COMPARE_AND_WRITE failure, where the
 	 * callback is expected to drop the per device ->caw_sem.
@@ -1748,6 +1746,9 @@ void transport_generic_request_failure(struct se_cmd *cmd,
 	     cmd->transport_complete_callback)
 		cmd->transport_complete_callback(cmd, false, &post_ret);
 
+	if (transport_check_aborted_status(cmd, 1))
+		return;
+
 	switch (sense_reason) {
 	case TCM_NON_EXISTENT_LUN:
 	case TCM_UNSUPPORTED_SCSI_OPCODE:
-- 
1.9.1
