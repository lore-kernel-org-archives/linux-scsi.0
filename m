From: Vaishali Thakkar <vaishali.thakkar@oracle.com>
Subject: [PATCH] [SCSI] csiostor: Do not use sizeof on pointer type
Date: Thu, 28 Apr 2016 22:02:10 +0530
Message-ID: <1461861130-22995-1-git-send-email-vaishali.thakkar@oracle.com>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from aserp1040.oracle.com ([141.146.126.69]:45492 "EHLO
	aserp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751910AbcD1Qcl (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Thu, 28 Apr 2016 12:32:41 -0400
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: jejb@linux.vnet.ibm.com
Cc: naresh@chelsio.com, martin.petersen@oracle.com, linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org, Vaishali Thakkar <vaishali.thakkar@oracle.com>

When sizeof is applied to a pointer typed expression, it gives
the size of the pointer. So, here do not use sizeof on pointer
type.

Problem found using Coccinelle.

Fixes: a3667aaed569 ('[SCSI] csiostor: Chelsio FCoE offload driver')

Signed-off-by: Vaishali Thakkar <vaishali.thakkar@oracle.com>
---
 drivers/scsi/csiostor/csio_mb.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/scsi/csiostor/csio_mb.c b/drivers/scsi/csiostor/csio_mb.c
index 9451787..a736de0 100644
--- a/drivers/scsi/csiostor/csio_mb.c
+++ b/drivers/scsi/csiostor/csio_mb.c
@@ -1534,7 +1534,7 @@ csio_mb_isr_handler(struct csio_hw *hw)
 		 * Enqueue event to EventQ. Events processing happens
 		 * in Event worker thread context
 		 */
-		if (csio_enqueue_evt(hw, CSIO_EVT_MBX, mbp, sizeof(mbp)))
+		if (csio_enqueue_evt(hw, CSIO_EVT_MBX, mbp, sizeof(*mbp)))
 			CSIO_INC_STATS(hw, n_evt_drop);
 
 		return 0;
-- 
2.1.4

