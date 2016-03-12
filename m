From: Shawn Lin <shawn.lin@rock-chips.com>
Subject: [PATCH] vmw_pscsi: reuse PAGE_ALIGNED to simplify the code
Date: Sat, 12 Mar 2016 15:39:26 +0800
Message-ID: <1457768366-30362-1-git-send-email-shawn.lin@rock-chips.com>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from lucky1.263xmail.com ([211.157.147.133]:60652 "EHLO
	lucky1.263xmail.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751028AbcCLHs2 (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Sat, 12 Mar 2016 02:48:28 -0500
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Arvind Kumar <arvindkumar@vmware.com>, VMware PV-Drivers <pv-drivers@vmware.com>, JBottomley@odin.com, martin.petersen@oracle.com
Cc: linux-scsi@vger.kernel.org, Shawn Lin <shawn.lin@rock-chips.com>

Aligned check with page size can be replaced with PAGE_ALIGNED
to simplify the code.

Signed-off-by: Shawn Lin <shawn.lin@rock-chips.com>
---

 drivers/scsi/vmw_pvscsi.c | 10 +++++-----
 1 file changed, 5 insertions(+), 5 deletions(-)

diff --git a/drivers/scsi/vmw_pvscsi.c b/drivers/scsi/vmw_pvscsi.c
index 6164634..0b0b0bd 100644
--- a/drivers/scsi/vmw_pvscsi.c
+++ b/drivers/scsi/vmw_pvscsi.c
@@ -458,9 +458,9 @@ static int pvscsi_allocate_rings(struct pvscsi_adapter *adapter)
 	if (!adapter->cmp_ring)
 		return -ENOMEM;
 
-	BUG_ON(!IS_ALIGNED(adapter->ringStatePA, PAGE_SIZE));
-	BUG_ON(!IS_ALIGNED(adapter->reqRingPA, PAGE_SIZE));
-	BUG_ON(!IS_ALIGNED(adapter->cmpRingPA, PAGE_SIZE));
+	BUG_ON(!PAGE_ALIGNED(adapter->ringStatePA));
+	BUG_ON(!PAGE_ALIGNED(adapter->reqRingPA));
+	BUG_ON(!PAGE_ALIGNED(adapter->cmpRingPA));
 
 	if (!adapter->use_msg)
 		return 0;
@@ -472,7 +472,7 @@ static int pvscsi_allocate_rings(struct pvscsi_adapter *adapter)
 						 &adapter->msgRingPA);
 	if (!adapter->msg_ring)
 		return -ENOMEM;
-	BUG_ON(!IS_ALIGNED(adapter->msgRingPA, PAGE_SIZE));
+	BUG_ON(!PAGE_ALIGNED(adapter->msgRingPA));
 
 	return 0;
 }
@@ -1287,7 +1287,7 @@ static int pvscsi_allocate_sg(struct pvscsi_adapter *adapter)
 		ctx->sgl = (void *)__get_free_pages(GFP_KERNEL,
 						    get_order(SGL_SIZE));
 		ctx->sglPA = 0;
-		BUG_ON(!IS_ALIGNED(((unsigned long)ctx->sgl), PAGE_SIZE));
+		BUG_ON(!PAGE_ALIGNED(((unsigned long)ctx->sgl)));
 		if (!ctx->sgl) {
 			for (; i >= 0; --i, --ctx) {
 				free_pages((unsigned long)ctx->sgl,
-- 
2.3.7


