From: Raghava Aditya Renukunta <RaghavaAditya.Renukunta@microsemi.com>
Subject: [PATCH V2 15/19] aacraid: Make sure ioctl returns on controller reset
Date: Wed, 10 May 2017 09:39:49 -0700
Message-ID: <1494434393-17261-16-git-send-email-RaghavaAditya.Renukunta@microsemi.com>
References: <1494434393-17261-1-git-send-email-RaghavaAditya.Renukunta@microsemi.com>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-bl2nam02on0083.outbound.protection.outlook.com ([104.47.38.83]:60837
        "EHLO NAM02-BL2-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1751483AbdEJGY0 (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
        Wed, 10 May 2017 02:24:26 -0400
In-Reply-To: <1494434393-17261-1-git-send-email-RaghavaAditya.Renukunta@microsemi.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: jejb@linux.vnet.ibm.com, martin.petersen@oracle.com, linux-scsi@vger.kernel.org
Cc: David.Carroll@microsemi.com, Gana.Sridaran@microsemi.com, Scott.Benesh@microsemi.com, Prasad.Munirathnam@microsemi.com

Made sure that ioctl commands return in case of a controller reset.

Signed-off-by: Raghava Aditya Renukunta <RaghavaAditya.Renukunta@microsemi.com>

---
Changes in V2:
Removed incorrect up
Cleared wait flag once event is received not before

 drivers/scsi/aacraid/commsup.c | 25 ++++++++++++++++++-------
 1 file changed, 18 insertions(+), 7 deletions(-)

diff --git a/drivers/scsi/aacraid/commsup.c b/drivers/scsi/aacraid/commsup.c
index f26543a..7bb0253 100644
--- a/drivers/scsi/aacraid/commsup.c
+++ b/drivers/scsi/aacraid/commsup.c
@@ -803,11 +803,11 @@ int aac_hba_send(u8 command, struct fib *fibptr, fib_callback callback,
 		if (aac_check_eeh_failure(dev))
 			return -EFAULT;
 
-		/* Only set for first known interruptable command */
-		if (down_interruptible(&fibptr->event_wait)) {
+		fibptr->flags |= FIB_CONTEXT_FLAG_WAIT;
+		if (down_interruptible(&fibptr->event_wait))
 			fibptr->done = 2;
-			up(&fibptr->event_wait);
-		}
+		fibptr->flags &= ~(FIB_CONTEXT_FLAG_WAIT);
+
 		spin_lock_irqsave(&fibptr->event_lock, flags);
 		if ((fibptr->done == 0) || (fibptr->done == 2)) {
 			fibptr->done = 2; /* Tell interrupt we aborted */
@@ -1514,6 +1514,7 @@ static int _aac_reset_adapter(struct aac_dev *aac, int forced, u8 reset_type)
 	int jafo = 0;
 	int bled;
 	u64 dmamask;
+	int num_of_fibs = 0;
 
 	/*
 	 * Assumptions:
@@ -1547,10 +1548,20 @@ static int _aac_reset_adapter(struct aac_dev *aac, int forced, u8 reset_type)
 	/*
 	 *	Loop through the fibs, close the synchronous FIBS
 	 */
-	for (retval = 1, index = 0; index < (aac->scsi_host_ptr->can_queue + AAC_NUM_MGT_FIB); index++) {
+	retval = 1;
+	num_of_fibs = aac->scsi_host_ptr->can_queue + AAC_NUM_MGT_FIB;
+	for (index = 0; index <  num_of_fibs; index++) {
+
 		struct fib *fib = &aac->fibs[index];
-		if (!(fib->hw_fib_va->header.XferState & cpu_to_le32(NoResponseExpected | Async)) &&
-		  (fib->hw_fib_va->header.XferState & cpu_to_le32(ResponseExpected))) {
+		__le32 XferState = fib->hw_fib_va->header.XferState;
+		bool is_response_expected = false;
+
+		if (!(XferState & cpu_to_le32(NoResponseExpected | Async)) &&
+		   (XferState & cpu_to_le32(ResponseExpected)))
+			is_response_expected = true;
+
+		if (is_response_expected
+		  || fib->flags & FIB_CONTEXT_FLAG_WAIT) {
 			unsigned long flagv;
 			spin_lock_irqsave(&fib->event_lock, flagv);
 			up(&fib->event_wait);
-- 
2.7.4
