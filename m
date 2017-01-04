From: Kees Cook <keescook@chromium.org>
Subject: [PATCH v2] scsi: esas2r: Fix format string type mistakes
Date: Tue, 3 Jan 2017 16:01:40 -0800
Message-ID: <20170104000140.GA120826@beast>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-pg0-f46.google.com ([74.125.83.46]:33300 "EHLO
        mail-pg0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1759762AbdADABn (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Tue, 3 Jan 2017 19:01:43 -0500
Received: by mail-pg0-f46.google.com with SMTP id g1so180861037pgn.0
        for <linux-scsi@vger.kernel.org>; Tue, 03 Jan 2017 16:01:43 -0800 (PST)
Content-Disposition: inline
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Bart Van Assche <bart.vanassche@gmail.com>
Cc: Bradley Grove <linuxdrivers@attotech.com>, "James E.J. Bottomley" <jejb@linux.vnet.ibm.com>, "Martin K. Petersen" <martin.petersen@oracle.com>, linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org, Emese Revfy <re.emese@gmail.com>

From: Emese Revfy <re.emese@gmail.com>

This adds the missing __printf attribute which allows compile time
format string checking (and will be used by the coming initify gcc
plugin). Additionally, this fixes the warnings exposed by the attribute.

Signed-off-by: Emese Revfy <re.emese@gmail.com>
[kees: split scsi/acpi, merged attr and fix, new commit messages]
Signed-off-by: Kees Cook <keescook@chromium.org>
---
v2:
- fix %lu to %zu on sizeof() values, bart
---
 drivers/scsi/esas2r/esas2r_init.c  | 2 +-
 drivers/scsi/esas2r/esas2r_ioctl.c | 2 +-
 drivers/scsi/esas2r/esas2r_log.h   | 4 ++--
 drivers/scsi/esas2r/esas2r_main.c  | 4 ++--
 4 files changed, 6 insertions(+), 6 deletions(-)

diff --git a/drivers/scsi/esas2r/esas2r_init.c b/drivers/scsi/esas2r/esas2r_init.c
index d6e53aee2295..6432a50b26d8 100644
--- a/drivers/scsi/esas2r/esas2r_init.c
+++ b/drivers/scsi/esas2r/esas2r_init.c
@@ -237,7 +237,7 @@ static void esas2r_claim_interrupts(struct esas2r_adapter *a)
 		flags |= IRQF_SHARED;
 
 	esas2r_log(ESAS2R_LOG_INFO,
-		   "esas2r_claim_interrupts irq=%d (%p, %s, %x)",
+		   "esas2r_claim_interrupts irq=%d (%p, %s, %lx)",
 		   a->pcid->irq, a, a->name, flags);
 
 	if (request_irq(a->pcid->irq,
diff --git a/drivers/scsi/esas2r/esas2r_ioctl.c b/drivers/scsi/esas2r/esas2r_ioctl.c
index 3e8483410f61..b35ed3829421 100644
--- a/drivers/scsi/esas2r/esas2r_ioctl.c
+++ b/drivers/scsi/esas2r/esas2r_ioctl.c
@@ -1301,7 +1301,7 @@ int esas2r_ioctl_handler(void *hostdata, int cmd, void __user *arg)
 	ioctl = kzalloc(sizeof(struct atto_express_ioctl), GFP_KERNEL);
 	if (ioctl == NULL) {
 		esas2r_log(ESAS2R_LOG_WARN,
-			   "ioctl_handler kzalloc failed for %d bytes",
+			   "ioctl_handler kzalloc failed for %zu bytes",
 			   sizeof(struct atto_express_ioctl));
 		return -ENOMEM;
 	}
diff --git a/drivers/scsi/esas2r/esas2r_log.h b/drivers/scsi/esas2r/esas2r_log.h
index 7b6397bb5b94..75b9d23cd736 100644
--- a/drivers/scsi/esas2r/esas2r_log.h
+++ b/drivers/scsi/esas2r/esas2r_log.h
@@ -61,8 +61,8 @@ enum {
 #endif
 };
 
-int esas2r_log(const long level, const char *format, ...);
-int esas2r_log_dev(const long level,
+__printf(2, 3) int esas2r_log(const long level, const char *format, ...);
+__printf(3, 4) int esas2r_log_dev(const long level,
 		   const struct device *dev,
 		   const char *format,
 		   ...);
diff --git a/drivers/scsi/esas2r/esas2r_main.c b/drivers/scsi/esas2r/esas2r_main.c
index 5092c821d088..f2e9d8aa979c 100644
--- a/drivers/scsi/esas2r/esas2r_main.c
+++ b/drivers/scsi/esas2r/esas2r_main.c
@@ -198,7 +198,7 @@ static ssize_t write_hw(struct file *file, struct kobject *kobj,
 					      GFP_KERNEL);
 		if (a->local_atto_ioctl == NULL) {
 			esas2r_log(ESAS2R_LOG_WARN,
-				   "write_hw kzalloc failed for %d bytes",
+				   "write_hw kzalloc failed for %zu bytes",
 				   sizeof(struct atto_ioctl));
 			return -ENOMEM;
 		}
@@ -1186,7 +1186,7 @@ static int esas2r_dev_targ_reset(struct scsi_cmnd *cmd, bool target_reset)
 		} else {
 			esas2r_log(ESAS2R_LOG_CRIT,
 				   "unable to allocate a request for a "
-				   "device reset (%d:%d)!",
+				   "device reset (%d:%llu)!",
 				   cmd->device->id,
 				   cmd->device->lun);
 		}
-- 
2.7.4


-- 
Kees Cook
Nexus Security
