From: Mahesh Rajashekhara <Mahesh.Rajashekhara@pmcs.com>
Subject: [PATCH 1/1] aacraid: kdump fix
Date: Mon, 23 Dec 2013 15:37:53 +0530
Message-ID: <1387793273-7284-1-git-send-email-Mahesh.Rajashekhara@pmcs.com>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from bby1mta03.pmc-sierra.com ([216.241.235.118]:60065 "EHLO
	bby1mta03.pmc-sierra.bc.ca" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753518Ab3LWLjI (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Mon, 23 Dec 2013 06:39:08 -0500
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: JBottomley@Parallels.com, linux-scsi@vger.kernel.org
Cc: aacraid@pmc-sierra.com, Harry.Yang@pmcs.com, Achim.Leubner@pmcs.com, Rich.Bono@pmcs.com, Mahesh.Rajashekhara@pmcs.com

This patch fixes kernel panic issue while booting into the kdump kernel.

We have triggered crash and kdump vmcore was successful. No issues seen while booting into the OS.

Signed-off-by: Mahesh Rajashekhara <Mahesh.Rajashekhara@pmcs.com>
---
 drivers/scsi/aacraid/aacraid.h |    2 +-
 drivers/scsi/aacraid/rx.c      |    5 +++--
 2 files changed, 4 insertions(+), 3 deletions(-)

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
index dada38a..9f2d88f 100644
--- a/drivers/scsi/aacraid/rx.c
+++ b/drivers/scsi/aacraid/rx.c
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

