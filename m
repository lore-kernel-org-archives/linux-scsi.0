From: Raghava Aditya Renukunta <RaghavaAditya.Renukunta@pmcs.com>
Subject: [PATCH 05/10] aacraid: Set correct msix count for EEH recovery
Date: Tue, 1 Dec 2015 04:39:43 -0800
Message-ID: <1448973589-9216-6-git-send-email-RaghavaAditya.Renukunta@pmcs.com>
References: <1448973589-9216-1-git-send-email-RaghavaAditya.Renukunta@pmcs.com>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from bby1mta03.pmc-sierra.com ([216.241.235.118]:55980 "EHLO
	bby1mta03.pmc-sierra.bc.ca" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753760AbbLATeT (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Tue, 1 Dec 2015 14:34:19 -0500
In-Reply-To: <1448973589-9216-1-git-send-email-RaghavaAditya.Renukunta@pmcs.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: JBottomley@Parallels.com, linux-scsi@vger.kernel.org
Cc: Mahesh.Rajashekhara@pmcs.com, Murthy.Bhat@pmcs.com, Santosh.Akula@pmcs.com, Gana.Sridaran@pmcs.com, aacraid@pmc-sierra.com, Rich.Bono@pmcs.com, RaghavaAditya.Renukunta@pmcs.com

From: Raghava Aditya Renukunta <raghavaaditya.renukunta@pmcs.com>

During EEH recovery number of online CPU's might change thereby changing
the number of MSIx vectors. Since each fib is allocated to a vector,
changes in the number of vectors causes fib to be sent thru invalid
vectors.In addition the correct number of MSIx vectors is not
updated in the INIT struct sent to the controller, when it is
reinitialized.

Fixed by reassigning vectors to fibs based on the updated number of MSIx
vectors and updating the INIT structure before sending to controller.

Signed-off-by: Raghava Aditya Renukunta <raghavaaditya.renukunta@pmcs.com>
---
 drivers/scsi/aacraid/linit.c | 25 ++++++++++++++++++++++++-
 1 file changed, 24 insertions(+), 1 deletion(-)

diff --git a/drivers/scsi/aacraid/linit.c b/drivers/scsi/aacraid/linit.c
index 0147210..f88f1132 100644
--- a/drivers/scsi/aacraid/linit.c
+++ b/drivers/scsi/aacraid/linit.c
@@ -1355,6 +1355,7 @@ static int aac_acquire_resources(struct aac_dev *dev)
 	int i, j;
 	int instance = dev->id;
 	const char *name = dev->name;
+	int vector = 0;
 	unsigned long status;
 	/*
 	 *	First clear out all interrupts.  Then enable the one's that we
@@ -1409,9 +1410,31 @@ static int aac_acquire_resources(struct aac_dev *dev)
 	}
 
 	aac_adapter_enable_int(dev);
+	/*max msix may change  after EEH
+	 * Re-assign vectors to fibs
+	 */
+	 for (i = 0;
+		i < (dev->scsi_host_ptr->can_queue + AAC_NUM_MGT_FIB);
+		i++) {
+		if ((dev->max_msix == 1) ||
+		   (i > ((dev->scsi_host_ptr->can_queue + AAC_NUM_MGT_FIB - 1)
+			- dev->vector_cap))) {
+			dev->fibs[i].vector_no = 0;
+		} else {
+			dev->fibs[i].vector_no = vector;
+			vector++;
+			if (vector == dev->max_msix)
+				vector = 1;
+		}
+	}
 
-	if (!dev->sync_mode)
+	if (!dev->sync_mode) {
+		/* After EEH recovery or suspend resume, max_msix count
+		 * may change, therfore updating in init as well.
+		 */
 		aac_adapter_start(dev);
+		dev->init->Sa_MSIXVectors = cpu_to_le32(dev->max_msix);
+	}
 	return 0;
 
 error_iounmap:
-- 
1.9.1

