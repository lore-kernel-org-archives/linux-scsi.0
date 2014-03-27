From: Matthew Wilcox <matthew.r.wilcox@intel.com>
Subject: [PATCH 6/7] fusion: Add free msg frames to the head, not tail of list
Date: Thu, 27 Mar 2014 16:40:35 -0400
Message-ID: <4266795d6c7763363a455a37610481172f33351e.1395952569.git.matthew.r.wilcox@intel.com>
References: <cover.1395952569.git.matthew.r.wilcox@intel.com>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mga01.intel.com ([192.55.52.88]:55444 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757263AbaC0UlX (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Thu, 27 Mar 2014 16:41:23 -0400
In-Reply-To: <cover.1395952569.git.matthew.r.wilcox@intel.com>
In-Reply-To: <cover.1395952569.git.matthew.r.wilcox@intel.com>
References: <cover.1395952569.git.matthew.r.wilcox@intel.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org
Cc: Matthew Wilcox <matthew.r.wilcox@intel.com>, willy@linux.intel.com

Reusing a msg frame quickly means it's still cache-hot.  This yields
a small but noticable performance improvement in a well-known database
benchmark.  This improvement is already present in the mpt3sas driver.

Signed-off-by: Matthew Wilcox <matthew.r.wilcox@intel.com>
---
 drivers/message/fusion/mptbase.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/message/fusion/mptbase.c b/drivers/message/fusion/mptbase.c
index 570b18a..ebc0af7 100644
--- a/drivers/message/fusion/mptbase.c
+++ b/drivers/message/fusion/mptbase.c
@@ -1037,7 +1037,7 @@ mpt_free_msg_frame(MPT_ADAPTER *ioc, MPT_FRAME_HDR *mf)
 		goto out;
 	/* signature to know if this mf is freed */
 	mf->u.frame.linkage.arg1 = cpu_to_le32(0xdeadbeaf);
-	list_add_tail(&mf->u.frame.linkage.list, &ioc->FreeQ);
+	list_add(&mf->u.frame.linkage.list, &ioc->FreeQ);
 #ifdef MFCNT
 	ioc->mfcnt--;
 #endif
-- 
1.9.0

