From: Rajat Jain <rajatja@google.com>
Subject: [PATCH] scsi: Avoid potential infinite eh_timeout_handler() loop
Date: Thu,  4 Jun 2015 11:40:21 -0700
Message-ID: <1433443222-8260-1-git-send-email-rajatja@google.com>
Return-path: <linux-kernel-owner@vger.kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
To: "James E.J. Bottomley" <JBottomley@odin.com>, linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org
Cc: rajatxjain@gmail.com, Rajat Jain <rajatja@google.com>
List-Id: linux-scsi@vger.kernel.org

Each cmd timeout should result in scmd->retries++. Currently it happens
just only before a command is requeued back. However, if the LLD
eh_timed_out() handler asks to reset timer back again, then also it should
be incremented because effectively LLD will be given a full time period
(SD_TIMEOUT = 30 secs!) to attempt to complete the command.

Why this is a problem:

  => Currently the SCSI low level transport drivers can provide
     eh_timeout_handler() calls (for e.g. iscsi provides this) to deal
     with command timeouts.

  => The eh_timeout_handler() can return BLK_EH_RESET_TIMER that causes the
     SCSI / block layer to reset the timer, thus giving more time to the
     LLD.

  => Currently a LLD can potentially loop infinitely on a command if it
     always keeps on returning BLK_EH_RESET_TIMER.

* => Other than choking its own devices, if the command that is stuck is a
     command issued during sd_probe_async() (e.g. a partition table scan),
     then it impacts all the disks because no other disks can be removed
     from the system until sd_probe_async() returns. (sd_remove waits on
     async_synchronize_full_domain(...))

  => This problem actually resulted in the situation mentioned above,
     whereby no disks in the system (on other scsi hosts) could be removed,
     because of a stuck scsi command to read the partition tables of an
     unrelated problematic disk during probe. The threads were stuck at:

	 schedule+0x312/0x7a0
	 async_synchronize_cookie_domain+0xb8/0x115
	 ? __wake_up_bit+0x40/0x40
	 async_synchronize_full_domain+0x15/0x17
	 sd_remove+0x5f/0x135
	 __device_release_driver+0x8a/0xe0
	 device_release_driver+0x23/0x30
	 bus_remove_device+0x10f/0x123
	 device_del+0x132/0x18e
	 __scsi_remove_device+0x56/0xb6
	 scsi_remove_device+0x26/0x33
	 scsi_remove_target+0x12d/0x1a0
	 ...

What this patch does:
  => Ensure that any quests to reset the timer are accounted for, so that
     there is a finite upper bound on the time that a command is tried.
     Once allowed number of retries is reached, we proceed to standard
     error handling procedure (abort etc.) by scheduling the command
     for EH.

Signed-off-by: Rajat Jain <rajatja@google.com>
---
 drivers/scsi/scsi_error.c | 11 +++++++++++
 1 file changed, 11 insertions(+)

diff --git a/drivers/scsi/scsi_error.c b/drivers/scsi/scsi_error.c
index c95a4e9..9671ec5 100644
--- a/drivers/scsi/scsi_error.c
+++ b/drivers/scsi/scsi_error.c
@@ -283,6 +283,17 @@ enum blk_eh_timer_return scsi_times_out(struct request *req)
 	else if (host->hostt->eh_timed_out)
 		rtn = host->hostt->eh_timed_out(scmd);
 
+	/*
+	 * If a scmd times out because LLD failed to complete it, make sure that
+	 * LLD can ask for more time only finite number of times. Also each such
+	 * request must account towards the time the LLD has been spent on that
+	 * cmd. Thus each timeout attempt by an LLD to complete a scmd must be
+	 * treated as a retry since it involves waiting for another whole period
+	 * of time before it times out again.
+	 */
+	if (rtn == BLK_EH_RESET_TIMER && (++scmd->retries > scmd->allowed))
+		rtn = BLK_EH_NOT_HANDLED;
+
 	if (rtn == BLK_EH_NOT_HANDLED) {
 		if (!host->hostt->no_async_abort &&
 		    scsi_abort_command(scmd) == SUCCESS)
-- 
2.2.0.rc0.207.ga3a616c
