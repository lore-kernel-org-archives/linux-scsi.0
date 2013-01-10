From: Mahesh Rajashekhara <Mahesh_Rajashekhara@pmc-sierra.com>
Subject: [PATCH 1/1] aacraid: 1024 max outstanding command support
Date: Thu, 10 Jan 2013 17:52:51 +0530
Message-ID: <1357820571-1944-1-git-send-email-Mahesh_Rajashekhara@pmc-sierra.com>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from bby1mta03.pmc-sierra.com ([216.241.235.118]:39134 "EHLO
	bby1mta03.pmc-sierra.bc.ca" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754463Ab3AJM53 (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Thu, 10 Jan 2013 07:57:29 -0500
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: JBottomley@Parallels.com, linux-scsi@vger.kernel.org
Cc: aacraid@pmc-sierra.com, Vinay_Goli@pmc-sierra.com, Achim_Leubner@pmc-sierra.com, Tony_Ruiz@pmc-sierra.com, Mahesh_Rajashekhara@pmc-sierra.com

Hi James,

This patch adds 1024 max outstanding command support for Series 7 and above controllers.

Signed-off-by: Mahesh Rajashekhara <Mahesh_Rajashekhara@pmc-sierra.com>
---
 drivers/scsi/aacraid/aacraid.h  |  8 ++++++--
 drivers/scsi/aacraid/comminit.c | 11 ++++++++++-
 2 files changed, 16 insertions(+), 3 deletions(-)

diff --git a/drivers/scsi/aacraid/aacraid.h b/drivers/scsi/aacraid/aacraid.h
index 742f5d7..a6f7190 100644
--- a/drivers/scsi/aacraid/aacraid.h
+++ b/drivers/scsi/aacraid/aacraid.h
@@ -12,13 +12,13 @@
  *----------------------------------------------------------------------------*/
 
 #ifndef AAC_DRIVER_BUILD
-# define AAC_DRIVER_BUILD 29801
+# define AAC_DRIVER_BUILD 30000
 # define AAC_DRIVER_BRANCH "-ms"
 #endif
 #define MAXIMUM_NUM_CONTAINERS	32
 
 #define AAC_NUM_MGT_FIB         8
-#define AAC_NUM_IO_FIB		(512 - AAC_NUM_MGT_FIB)
+#define AAC_NUM_IO_FIB		(1024 - AAC_NUM_MGT_FIB)
 #define AAC_NUM_FIB		(AAC_NUM_IO_FIB + AAC_NUM_MGT_FIB)
 
 #define AAC_MAX_LUN		(8)
@@ -36,6 +36,10 @@
 #define CONTAINER_TO_ID(cont)		(cont)
 #define CONTAINER_TO_LUN(cont)		(0)
 
+#define PMC_DEVICE_S7	0x28c
+#define PMC_DEVICE_S8	0x28d
+#define PMC_DEVICE_S9	0x28f
+
 #define aac_phys_to_logical(x)  ((x)+1)
 #define aac_logical_to_phys(x)  ((x)?(x)-1:0)
 
diff --git a/drivers/scsi/aacraid/comminit.c b/drivers/scsi/aacraid/comminit.c
index 8e5d3be..3f75995 100644
--- a/drivers/scsi/aacraid/comminit.c
+++ b/drivers/scsi/aacraid/comminit.c
@@ -404,7 +404,13 @@ struct aac_dev *aac_init_adapter(struct aac_dev *dev)
 		dev->max_fib_size = status[1] & 0xFFE0;
 		host->sg_tablesize = status[2] >> 16;
 		dev->sg_tablesize = status[2] & 0xFFFF;
-		host->can_queue = (status[3] & 0xFFFF) - AAC_NUM_MGT_FIB;
+		if (dev->pdev->device == PMC_DEVICE_S7 ||
+		    dev->pdev->device == PMC_DEVICE_S8 ||
+		    dev->pdev->device == PMC_DEVICE_S9)
+			host->can_queue = ((status[3] >> 16) ? (status[3] >> 16) :
+				(status[3] & 0xFFFF)) - AAC_NUM_MGT_FIB;
+		else
+			host->can_queue = (status[3] & 0xFFFF) - AAC_NUM_MGT_FIB;
 		dev->max_num_aif = status[4] & 0xFFFF;
 		/*
 		 *	NOTE:
@@ -452,6 +458,9 @@ struct aac_dev *aac_init_adapter(struct aac_dev *dev)
 		}
 	}
 
+	if (host->can_queue > AAC_NUM_IO_FIB)
+		host->can_queue = AAC_NUM_IO_FIB;
+
 	/*
 	 *	Ok now init the communication subsystem
 	 */
-- 
1.7.11.7

