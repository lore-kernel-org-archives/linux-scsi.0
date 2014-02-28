From: Eiichi Tsukata <eiichi.tsukata.xh@hitachi.com>
Subject: [RESEND PATCH v3] scsi: Add timeout to avoid infinite command retry
Date: Fri, 28 Feb 2014 10:13:02 +0900
Message-ID: <20140228011302.7250.37517.stgit@ltc223.sdl.hitachi.co.jp>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner@vger.kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
To: JBottomley@parallels.com, linux-scsi@vger.kernel.org
Cc: clbchenlibo.chen@huawei.com, handai.szj@gmail.com, linux-kernel@vger.kernel.org, yrl.pp-manager.tt@hitachi.com
List-Id: linux-scsi@vger.kernel.org

Currently, scsi error handling in scsi_io_completion() tries to
unconditionally requeue scsi command when device keeps some error state.
For example, UNIT_ATTENTION causes infinite retry with
action == ACTION_RETRY.
This is because retryable errors are thought to be temporary and the scsi
device will soon recover from those errors. Normally, such retry policy is
appropriate because the device will soon recover from temporary error state.

But there is no guarantee that device is able to recover from error state
immediately. Some hardware error can prevent device from recovering.

This patch adds timeout in scsi_io_completion() to avoid infinite command
retry in scsi_io_completion(). Once scsi command retry time is longer than
this timeout, the command is treated as failure.

Changes in v3:
 - use existing timeout instead of adding new sysfs attribute
   (Thanks to James)

Changes in v2:
 - check retry timeout in scsi_io_completion() instead of scsi_softirq_done()

Signed-off-by: Eiichi Tsukata <eiichi.tsukata.xh@hitachi.com>
Cc: "James E.J. Bottomley" <JBottomley@parallels.com>
Cc: linux-scsi@vger.kernel.org
Cc: linux-kernel@vger.kernel.org
---
 drivers/scsi/scsi_lib.c |    7 +++++++
 1 file changed, 7 insertions(+)

diff --git a/drivers/scsi/scsi_lib.c b/drivers/scsi/scsi_lib.c
index 62ec84b..f97a1a6 100644
--- a/drivers/scsi/scsi_lib.c
+++ b/drivers/scsi/scsi_lib.c
@@ -788,6 +788,7 @@ void scsi_io_completion(struct scsi_cmnd *cmd, unsigned int good_bytes)
 	enum {ACTION_FAIL, ACTION_REPREP, ACTION_RETRY,
 	      ACTION_DELAYED_RETRY} action;
 	char *description = NULL;
+	unsigned long wait_for = (cmd->allowed + 1) * req->timeout;
 
 	if (result) {
 		sense_valid = scsi_command_normalize_sense(cmd, &sshdr);
@@ -989,6 +990,12 @@ void scsi_io_completion(struct scsi_cmnd *cmd, unsigned int good_bytes)
 		action = ACTION_FAIL;
 	}
 
+	if (action != ACTION_FAIL &&
+	    time_before(cmd->jiffies_at_alloc + wait_for, jiffies)) {
+		action = ACTION_FAIL;
+		description = "Command timed out";
+	}
+
 	switch (action) {
 	case ACTION_FAIL:
 		/* Give up and fail the remainder of the request */
