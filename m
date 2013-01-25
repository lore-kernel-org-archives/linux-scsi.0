From: "Mahesh Rajashekhara" <Mahesh.Rajashekhara@pmcs.com>
Subject: RE: [PATCH 1/1] aacraid: 1024 max outstanding command support
Date: Thu, 24 Jan 2013 21:57:43 -0800
Message-ID: <340C71CD25A7EB49BFA81AE8C83926671B09C742@BBY1EXM10.pmc_nt.nt.pmc-sierra.bc.ca>
References: <1357820571-1944-1-git-send-email-Mahesh_Rajashekhara@pmc-sierra.com>
Mime-Version: 1.0
Content-Type: text/plain;
	charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from bby1mta02.pmc-sierra.com ([216.241.235.117]:40277 "EHLO
	bby1mta02.pmc-sierra.bc.ca" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750961Ab3AYF5r convert rfc822-to-8bit
	(ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Fri, 25 Jan 2013 00:57:47 -0500
Content-class: urn:content-classes:message
In-Reply-To: <1357820571-1944-1-git-send-email-Mahesh_Rajashekhara@pmc-sierra.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: JBottomley@Parallels.com, linux-scsi@vger.kernel.org
Cc: aacraid@pmc-sierra.com, Vinay Goli <Vinay.Goli@pmcs.com>, Achim Leubner <Achim.Leubner@pmcs.com>, Tony Ruiz <Tony.Ruiz@pmcs.com>

Hi James,

Can you please let us know the status of this patch. Can we get a
sign-off/approval of this patch.

Regards,
Mahesh

-----Original Message-----
From: Mahesh Rajashekhara 
Sent: Thursday, January 10, 2013 5:53 PM
To: JBottomley@Parallels.com; linux-scsi@vger.kernel.org
Cc: aacraid@pmc-sierra.com; Vinay Goli; Achim Leubner; Tony Ruiz; Mahesh
Rajashekhara
Subject: [PATCH 1/1] aacraid: 1024 max outstanding command support

Hi James,

This patch adds 1024 max outstanding command support for Series 7 and
above controllers.

Signed-off-by: Mahesh Rajashekhara <Mahesh_Rajashekhara@pmc-sierra.com>
---
 drivers/scsi/aacraid/aacraid.h  |  8 ++++++--
drivers/scsi/aacraid/comminit.c | 11 ++++++++++-
 2 files changed, 16 insertions(+), 3 deletions(-)

diff --git a/drivers/scsi/aacraid/aacraid.h
b/drivers/scsi/aacraid/aacraid.h index 742f5d7..a6f7190 100644
--- a/drivers/scsi/aacraid/aacraid.h
+++ b/drivers/scsi/aacraid/aacraid.h
@@ -12,13 +12,13 @@
 
*-----------------------------------------------------------------------
-----*/
 
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
 #define aac_phys_to_logical(x)  ((x)+1)  #define aac_logical_to_phys(x)
((x)?(x)-1:0)
 
diff --git a/drivers/scsi/aacraid/comminit.c
b/drivers/scsi/aacraid/comminit.c index 8e5d3be..3f75995 100644
--- a/drivers/scsi/aacraid/comminit.c
+++ b/drivers/scsi/aacraid/comminit.c
@@ -404,7 +404,13 @@ struct aac_dev *aac_init_adapter(struct aac_dev
*dev)
 		dev->max_fib_size = status[1] & 0xFFE0;
 		host->sg_tablesize = status[2] >> 16;
 		dev->sg_tablesize = status[2] & 0xFFFF;
-		host->can_queue = (status[3] & 0xFFFF) -
AAC_NUM_MGT_FIB;
+		if (dev->pdev->device == PMC_DEVICE_S7 ||
+		    dev->pdev->device == PMC_DEVICE_S8 ||
+		    dev->pdev->device == PMC_DEVICE_S9)
+			host->can_queue = ((status[3] >> 16) ?
(status[3] >> 16) :
+				(status[3] & 0xFFFF)) - AAC_NUM_MGT_FIB;
+		else
+			host->can_queue = (status[3] & 0xFFFF) -
AAC_NUM_MGT_FIB;
 		dev->max_num_aif = status[4] & 0xFFFF;
 		/*
 		 *	NOTE:
@@ -452,6 +458,9 @@ struct aac_dev *aac_init_adapter(struct aac_dev
*dev)
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

