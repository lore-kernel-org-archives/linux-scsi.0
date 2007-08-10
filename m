From: akpm@linux-foundation.org
Subject: [patch 02/30] aacraid: rename check_reset
Date: Fri, 10 Aug 2007 14:50:30 -0700
Message-ID: <200708102150.l7ALoUPQ011320@imap1.linux-foundation.org>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:39177 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751032AbXHJVvX (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Fri, 10 Aug 2007 17:51:23 -0400
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
Cc: linux-scsi@vger.kernel.org, akpm@linux-foundation.org, James.Bottomley@steeleye.com, aacraid@adaptec.com

From: Andrew Morton <akpm@linux-foundation.org>

Too generic, clashes with ISDN.

Acked-by: Mark Salyzyn <aacraid@adaptec.com>
Cc: James Bottomley <James.Bottomley@SteelEye.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/scsi/aacraid/aachba.c  |    8 ++++----
 drivers/scsi/aacraid/aacraid.h |    2 +-
 drivers/scsi/aacraid/commsup.c |    5 +++--
 3 files changed, 8 insertions(+), 7 deletions(-)

diff -puN drivers/scsi/aacraid/aachba.c~aacraid-rename-check_reset drivers/scsi/aacraid/aachba.c
--- a/drivers/scsi/aacraid/aachba.c~aacraid-rename-check_reset
+++ a/drivers/scsi/aacraid/aachba.c
@@ -177,9 +177,9 @@ int check_interval = 24 * 60 * 60;
 module_param(check_interval, int, S_IRUGO|S_IWUSR);
 MODULE_PARM_DESC(check_interval, "Interval in seconds between adapter health checks.");
 
-int check_reset = 1;
-module_param(check_reset, int, S_IRUGO|S_IWUSR);
-MODULE_PARM_DESC(check_reset, "If adapter fails health check, reset the adapter.");
+int aac_check_reset = 1;
+module_param_named(check_reset, aac_check_reset, int, S_IRUGO|S_IWUSR);
+MODULE_PARM_DESC(aac_check_reset, "If adapter fails health check, reset the adapter.");
 
 int expose_physicals = -1;
 module_param(expose_physicals, int, S_IRUGO|S_IWUSR);
@@ -1305,7 +1305,7 @@ int aac_get_adapter_info(struct aac_dev*
 			  (int)sizeof(dev->supplement_adapter_info.VpdInfo.Tsid),
 			  dev->supplement_adapter_info.VpdInfo.Tsid);
 		}
-		if (!check_reset ||
+		if (!aac_check_reset ||
 		  (dev->supplement_adapter_info.SupportedOptions2 &
 		  le32_to_cpu(AAC_OPTION_IGNORE_RESET))) {
 			printk(KERN_INFO "%s%d: Reset Adapter Ignored\n",
diff -puN drivers/scsi/aacraid/aacraid.h~aacraid-rename-check_reset drivers/scsi/aacraid/aacraid.h
--- a/drivers/scsi/aacraid/aacraid.h~aacraid-rename-check_reset
+++ a/drivers/scsi/aacraid/aacraid.h
@@ -1871,4 +1871,4 @@ extern int aac_reset_devices;
 extern int aac_commit;
 extern int update_interval;
 extern int check_interval;
-extern int check_reset;
+extern int aac_check_reset;
diff -puN drivers/scsi/aacraid/commsup.c~aacraid-rename-check_reset drivers/scsi/aacraid/commsup.c
--- a/drivers/scsi/aacraid/commsup.c~aacraid-rename-check_reset
+++ a/drivers/scsi/aacraid/commsup.c
@@ -1372,8 +1372,9 @@ int aac_check_health(struct aac_dev * aa
 
 	printk(KERN_ERR "%s: Host adapter BLINK LED 0x%x\n", aac->name, BlinkLED);
 
-	if (!check_reset || (aac->supplement_adapter_info.SupportedOptions2 &
-	  le32_to_cpu(AAC_OPTION_IGNORE_RESET)))
+	if (!aac_check_reset ||
+		(aac->supplement_adapter_info.SupportedOptions2 &
+			le32_to_cpu(AAC_OPTION_IGNORE_RESET)))
 		goto out;
 	host = aac->scsi_host_ptr;
 	if (aac->thread->pid != current->pid)
_
