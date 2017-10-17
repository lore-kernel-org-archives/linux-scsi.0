From: Raghava Aditya Renukunta <RaghavaAditya.Renukunta@microsemi.com>
Subject: [PATCH] aacraid: Fix controller initialization failure
Date: Mon, 16 Oct 2017 17:22:31 -0700
Message-ID: <150819975151.22574.15488858870979477962.stgit@rslab209.pmc-sierra.bc.ca>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-dm3nam03on0066.outbound.protection.outlook.com ([104.47.41.66]:64416
        "EHLO NAM03-DM3-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1755198AbdJQAWr (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
        Mon, 16 Oct 2017 20:22:47 -0400
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org
Cc: David.Carroll@microsemi.com, Scott.Benesh@microsemi.com

This is a fix to an issue where the driver sends its periodic WELLNESS
command to the controller after the driver shut it down.This causes the
controller to crash. The window where this can happen is small, but it
can be hit at around 4 hours of constant resets.

Cc: <stable@vger.kernel.org>
Fixes: fbd185986eba (aacraid: Fix AIF triggered IOP_RESET)
Signed-off-by: Raghava Aditya Renukunta <RaghavaAditya.Renukunta@microsemi.com>
Reviewed-by: Dave Carroll <david.carroll@microsemi.com>
---
 drivers/scsi/aacraid/comminit.c |    8 +++++---
 drivers/scsi/aacraid/linit.c    |    7 ++++++-
 2 files changed, 11 insertions(+), 4 deletions(-)

diff --git a/drivers/scsi/aacraid/comminit.c b/drivers/scsi/aacraid/comminit.c
index 97d269f..1bc623a 100644
--- a/drivers/scsi/aacraid/comminit.c
+++ b/drivers/scsi/aacraid/comminit.c
@@ -302,9 +302,11 @@ int aac_send_shutdown(struct aac_dev * dev)
 		return -ENOMEM;
 	aac_fib_init(fibctx);
 
-	mutex_lock(&dev->ioctl_mutex);
-	dev->adapter_shutdown = 1;
-	mutex_unlock(&dev->ioctl_mutex);
+	if (!dev->adapter_shutdown) {
+		mutex_lock(&dev->ioctl_mutex);
+		dev->adapter_shutdown = 1;
+		mutex_unlock(&dev->ioctl_mutex);
+	}
 
 	cmd = (struct aac_close *) fib_data(fibctx);
 	cmd->command = cpu_to_le32(VM_CloseAll);
diff --git a/drivers/scsi/aacraid/linit.c b/drivers/scsi/aacraid/linit.c
index 87cc4a9..710ace6 100644
--- a/drivers/scsi/aacraid/linit.c
+++ b/drivers/scsi/aacraid/linit.c
@@ -1547,8 +1547,9 @@ static void __aac_shutdown(struct aac_dev * aac)
 {
 	int i;
 
+	mutex_lock(&aac->ioctl_mutex);
 	aac->adapter_shutdown = 1;
-	aac_send_shutdown(aac);
+	mutex_unlock(&aac->ioctl_mutex);
 
 	if (aac->aif_thread) {
 		int i;
@@ -1561,7 +1562,11 @@ static void __aac_shutdown(struct aac_dev * aac)
 		}
 		kthread_stop(aac->thread);
 	}
+
+	aac_send_shutdown(aac);
+
 	aac_adapter_disable_int(aac);
+
 	if (aac_is_src(aac)) {
 		if (aac->max_msix > 1) {
 			for (i = 0; i < aac->max_msix; i++) {
