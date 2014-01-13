From: Mahesh Rajashekhara <Mahesh.Rajashekhara@pmcs.com>
Subject: [PATCH 1/1] aacraid: kdump fix
Date: Mon, 13 Jan 2014 13:50:30 +0530
Message-ID: <1389601230-4792-1-git-send-email-Mahesh.Rajashekhara@pmcs.com>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from bby1mta02.pmc-sierra.com ([216.241.235.117]:47137 "EHLO
	bby1mta02.pmc-sierra.bc.ca" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750991AbaAMJwL (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Mon, 13 Jan 2014 04:52:11 -0500
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: JBottomley@Parallels.com, linux-scsi@vger.kernel.org
Cc: thenzl@redhat.com, aacraid@pmc-sierra.com, Harry.Yang@pmcs.com, Achim.Leubner@pmcs.com, Rich.Bono@pmcs.com, Mahesh.Rajashekhara@pmcs.com

Thanks for your review comments, Tomas

We have initialized var in this driver patch. This patch fixes kernel panic issue while booting into the kdump kernel.

We have triggered crash and kdump vmcore was successful. No issues seen while booting into the OS.

Signed-off-by: Mahesh Rajashekhara <Mahesh.Rajashekhara@pmcs.com>
---
 drivers/scsi/aacraid/aacraid.h |    2 +-
 drivers/scsi/aacraid/rx.c      |    7 ++++---
 2 files changed, 5 insertions(+), 4 deletions(-)

diff --git a/drivers/scsi/aacraid/aacraid.h b/drivers/scsi/aacraid/aacraid.h
index 9323d05..eaaf870 100644
--- a/drivers/scsi/aacraid/aacraid.h
+++ b/drivers/scsi/aacraid/aacraid.h
@@ -12,7 +12,7 @@
  *----------------------------------------------------------------------------*/
 
 #ifndef AAC_DRIVER_BUILD
-# define AAC_DRIVER_BUILD 30200
+# define AAC_DRIVER_BUILD 30300
 # define AAC_DRIVER_BRANCH "-ms"
 #endif
 #define MAXIMUM_NUM_CONTAINERS	32
diff --git a/drivers/scsi/aacraid/rx.c b/drivers/scsi/aacraid/rx.c
index dada38a..bb9917c 100644
--- a/drivers/scsi/aacraid/rx.c
+++ b/drivers/scsi/aacraid/rx.c
@@ -480,7 +480,7 @@ static int aac_rx_ioremap(struct aac_dev * dev, u32 size)
 
 static int aac_rx_restart_adapter(struct aac_dev *dev, int bled)
 {
-	u32 var;
+	u32 var = 0;
 
 	if (!(dev->supplement_adapter_info.SupportedOptions2 &
 	  AAC_OPTION_MU_RESET) || (bled >= 0) || (bled == -2)) {
@@ -500,13 +500,14 @@ static int aac_rx_restart_adapter(struct aac_dev *dev, int bled)
 		if (bled && (bled != -ETIMEDOUT))
 			return -EINVAL;
 	}
-	if (bled || (var == 0x3803000F)) { /* USE_OTHER_METHOD */
+	if (bled && (var == 0x3803000F)) { /* USE_OTHER_METHOD */
 		rx_writel(dev, MUnit.reserved2, 3);
 		msleep(5000); /* Delay 5 seconds */
 		var = 0x00000001;
 	}
-	if (var != 0x00000001)
+	if (bled && (var != 0x00000001))
 		return -EINVAL;
+	ssleep(5);
 	if (rx_readl(dev, MUnit.OMRx[0]) & KERNEL_PANIC)
 		return -ENODEV;
 	if (startup_timeout < 300)
-- 
1.7.7.3

