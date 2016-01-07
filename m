From: Raghava Aditya Renukunta <RaghavaAditya.Renukunta@pmcs.com>
Subject: [PATCH V2 5/9] aacraid: Set correct msix count for EEH recovery
Date: Wed, 6 Jan 2016 23:22:20 -0800
Message-ID: <1452151344-417-6-git-send-email-RaghavaAditya.Renukunta@pmcs.com>
References: <1452151344-417-1-git-send-email-RaghavaAditya.Renukunta@pmcs.com>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from bby1mta03.pmc-sierra.com ([216.241.235.118]:44837 "EHLO
	bby1mta03.pmc-sierra.bc.ca" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752120AbcAFXMg (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Wed, 6 Jan 2016 18:12:36 -0500
In-Reply-To: <1452151344-417-1-git-send-email-RaghavaAditya.Renukunta@pmcs.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: JBottomley@odin.com, linux-scsi@vger.kernel.org
Cc: Mahesh.Rajashekhara@pmcs.com, Murthy.Bhat@pmcs.com, Gana.Sridaran@pmcs.com, aacraid@pmc-sierra.com, Scott.Benesh@pmcs.com, jthumshirn@suse.de, thenzl@redhat.com, David.Carroll@pmcs.com, RaghavaAditya.Renukunta@pmcs.com

From: Raghava Aditya Renukunta <raghavaaditya.renukunta@pmcs.com>

During EEH recovery number of online CPU's might change thereby changing
the number of MSIx vectors. Since each fib is allocated to a vector,
changes in the number of vectors causes fib to be sent thru invalid
vectors.In addition the correct number of MSIx vectors is not
updated in the INIT struct sent to the controller, when it is
reinitialized.

Fixed by reassigning vectors to fibs based on the updated number of MSIx
vectors and updating the INIT structure before sending to controller.

Changes in V2:
Replaced fib vector allocation code with aac_fib_vector_assign

Fixes: MSI-X vector calculation for suspend/resume
Cc: stable@vger.kernel.org

Signed-off-by: Raghava Aditya Renukunta <raghavaaditya.renukunta@pmcs.com>
---
 drivers/scsi/aacraid/linit.c | 12 +++++++++++-
 1 file changed, 11 insertions(+), 1 deletion(-)

diff --git a/drivers/scsi/aacraid/linit.c b/drivers/scsi/aacraid/linit.c
index 08c6835..6d79181 100644
--- a/drivers/scsi/aacraid/linit.c
+++ b/drivers/scsi/aacraid/linit.c
@@ -1410,8 +1410,18 @@ static int aac_acquire_resources(struct aac_dev *dev)
 
 	aac_adapter_enable_int(dev);
 
-	if (!dev->sync_mode)
+	/*max msix may change  after EEH
+	 * Re-assign vectors to fibs
+	 */
+	aac_fib_vector_assign(dev);
+
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

