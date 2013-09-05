From: Eiichi Tsukata <eiichi.tsukata.xh@hitachi.com>
Subject: [PATCH] scsi: Add printk to detect retry loop
Date: Thu, 05 Sep 2013 17:33:13 +0900
Message-ID: <20130905083313.3079.44285.stgit@ltc223.sdl.hitachi.co.jp>
References: <20130905083310.3079.7106.stgit@ltc223.sdl.hitachi.co.jp>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20130905083310.3079.7106.stgit@ltc223.sdl.hitachi.co.jp>
Sender: linux-kernel-owner@vger.kernel.org
To: JBottomley@parallels.com, linux-scsi@vger.kernel.org
Cc: linux-kernel@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org

Currently, scsi error handling in scsi_decide_disposition() unconditionally
retries on some errors. This is because retriable errors are thought to be
temporary and the scsi device will soon recover from those errors. But there
is no guarantee that the device is able to recover from error state
immediately. The problem is that there is no easy way to detect retry loop in
user space.

This patch adds printk to detect command retry loop in user space. When
the command retry count exceeds the allowed count(scmd->allowed), the
kernel prints messages, which can be handled in user space application.
Here the allowed count(scmd->allowed) is currently used as finite retry
limit count. Once retry count exceeds the allowed count on a device,
the message is suppressed on the device to avoid too much messages
outputted in dmesg.

Signed-off-by: Eiichi Tsukata <eiichi.tsukata.xh@hitachi.com>
Cc: "James E.J. Bottomley" <JBottomley@parallels.com>
Cc: linux-scsi@vger.kernel.org
Cc: linux-kernel@vger.kernel.org
---
 drivers/scsi/scsi_error.c  |    3 +--
 drivers/scsi/scsi_lib.c    |   14 ++++++++++++++
 include/scsi/scsi_device.h |    1 +
 3 files changed, 16 insertions(+), 2 deletions(-)

diff --git a/drivers/scsi/scsi_error.c b/drivers/scsi/scsi_error.c
index 2150596..31d10f4 100644
--- a/drivers/scsi/scsi_error.c
+++ b/drivers/scsi/scsi_error.c
@@ -1615,8 +1615,7 @@ int scsi_decide_disposition(struct scsi_cmnd *scmd)
 	 * the request was not marked fast fail.  Note that above,
 	 * even if the request is marked fast fail, we still requeue
 	 * for queue congestion conditions (QUEUE_FULL or BUSY) */
-	if ((++scmd->retries) <= scmd->allowed
-	    && !scsi_noretry_cmd(scmd)) {
+	if (scmd->retries < scmd->allowed && !scsi_noretry_cmd(scmd)) {
 		return NEEDS_RETRY;
 	} else {
 		/*
diff --git a/drivers/scsi/scsi_lib.c b/drivers/scsi/scsi_lib.c
index 124392f..0198490 100644
--- a/drivers/scsi/scsi_lib.c
+++ b/drivers/scsi/scsi_lib.c
@@ -1513,6 +1513,20 @@ static void scsi_softirq_done(struct request *rq)
 		disposition = SUCCESS;
 	}
 			
+	/*
+	 * Print message if retry count exceeds allowed count.
+	 * This message can be used by user space application to detect
+	 * indefinite command retry loop.
+	 */
+	if (cmd->allowed > 0 && ++cmd->retries == cmd->allowed) {
+		/* Once a command retry over was detected, suppress message */
+		if (!cmd->device->retry_over) {
+			scmd_printk(KERN_INFO, cmd,
+				    "command retried %d times\n", cmd->allowed);
+			scsi_print_command(cmd);
+			cmd->device->retry_over = 1;
+		}
+	}
 	scsi_log_completion(cmd, disposition);
 
 	switch (disposition) {
diff --git a/include/scsi/scsi_device.h b/include/scsi/scsi_device.h
index a44954c..8751d82 100644
--- a/include/scsi/scsi_device.h
+++ b/include/scsi/scsi_device.h
@@ -160,6 +160,7 @@ struct scsi_device {
 	unsigned is_visible:1;	/* is the device visible in sysfs */
 	unsigned wce_default_on:1;	/* Cache is ON by default */
 	unsigned no_dif:1;	/* T10 PI (DIF) should be disabled */
+	unsigned retry_over:1;	/* retry count exceeded allowed count */
 
 	atomic_t disk_events_disable_depth; /* disable depth for disk events */
 
