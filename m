From: michaelc@cs.wisc.edu
Subject: [PATCH 5/5] cxgb3i: fix ddp map overrun (v2)
Date: Tue, 21 Apr 2009 15:32:35 -0500
Message-ID: <12403459582955-git-send-email-michaelc@cs.wisc.edu>
References: <1240345955183-git-send-email-michaelc@cs.wisc.edu>
 <1240345956764-git-send-email-michaelc@cs.wisc.edu>
 <1240345956886-git-send-email-michaelc@cs.wisc.edu>
 <12403459572661-git-send-email-michaelc@cs.wisc.edu>
 <12403459572541-git-send-email-michaelc@cs.wisc.edu>
 <12403459572736-git-send-email-michaelc@cs.wisc.edu>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mx2.redhat.com ([66.187.237.31]:35827 "EHLO mx2.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756913AbZDUUcq (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Tue, 21 Apr 2009 16:32:46 -0400
In-Reply-To: <12403459572736-git-send-email-michaelc@cs.wisc.edu>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org
Cc: "kxie@chelsio.com" <kxie@chelsio.com>, Mike Christie <michaelc@cs.wisc.edu>

From: kxie@chelsio.com <kxie@chelsio.com>

[PATCH v2] cxgb3i: fix ddp map overrun (version 2)

From: Karen Xie <kxie@chelsio.com>

Fixed a bug in calculating ddp map range when search for free entries:
it was going beyond the end by one, thus corrupting gl_skb[0].

Signed-off-by: Karen Xie <kxie@chelsio.com>
Signed-off-by: Mike Christie <michaelc@cs.wisc.edu>
---
 drivers/scsi/cxgb3i/cxgb3i_ddp.c |   32 +++++++++++++++++++-------------
 1 files changed, 19 insertions(+), 13 deletions(-)

diff --git a/drivers/scsi/cxgb3i/cxgb3i_ddp.c b/drivers/scsi/cxgb3i/cxgb3i_ddp.c
index d06a661..99c9125 100644
--- a/drivers/scsi/cxgb3i/cxgb3i_ddp.c
+++ b/drivers/scsi/cxgb3i/cxgb3i_ddp.c
@@ -120,20 +120,26 @@ static void clear_ddp_map(struct cxgb3i_ddp_info *ddp, unsigned int tag,
 }
 
 static inline int ddp_find_unused_entries(struct cxgb3i_ddp_info *ddp,
-					  int start, int max, int count,
+					  unsigned int start, unsigned int max,
+					  unsigned int count,
 					  struct cxgb3i_gather_list *gl)
 {
-	unsigned int i, j;
+	unsigned int i, j, k;
 
+	/* not enough entries */
+	if ((max - start) < count)
+		return -EBUSY;
+
+	max -= count;
 	spin_lock(&ddp->map_lock);
-	for (i = start; i <= max;) {
-		for (j = 0; j < count; j++) {
-			if (ddp->gl_map[i + j])
+	for (i = start; i < max;) {
+		for (j = 0, k = i; j < count; j++, k++) {
+			if (ddp->gl_map[k])
 				break;
 		}
 		if (j == count) {
-			for (j = 0; j < count; j++)
-				ddp->gl_map[i + j] = gl;
+			for (j = 0, k = i; j < count; j++, k++)
+				ddp->gl_map[k] = gl;
 			spin_unlock(&ddp->map_lock);
 			return i;
 		}
@@ -354,7 +360,7 @@ int cxgb3i_ddp_tag_reserve(struct t3cdev *tdev, unsigned int tid,
 	struct cxgb3i_ddp_info *ddp = tdev->ulp_iscsi;
 	struct pagepod_hdr hdr;
 	unsigned int npods;
-	int idx = -1, idx_max;
+	int idx = -1;
 	int err = -ENOMEM;
 	u32 sw_tag = *tagp;
 	u32 tag;
@@ -367,17 +373,17 @@ int cxgb3i_ddp_tag_reserve(struct t3cdev *tdev, unsigned int tid,
 	}
 
 	npods = (gl->nelem + PPOD_PAGES_MAX - 1) >> PPOD_PAGES_SHIFT;
-	idx_max = ddp->nppods - npods + 1;
 
 	if (ddp->idx_last == ddp->nppods)
-		idx = ddp_find_unused_entries(ddp, 0, idx_max, npods, gl);
+		idx = ddp_find_unused_entries(ddp, 0, ddp->nppods, npods, gl);
 	else {
 		idx = ddp_find_unused_entries(ddp, ddp->idx_last + 1,
-					      idx_max, npods, gl);
-		if (idx < 0 && ddp->idx_last >= npods)
+					      ddp->nppods, npods, gl);
+		if (idx < 0 && ddp->idx_last >= npods) {
 			idx = ddp_find_unused_entries(ddp, 0,
-						      ddp->idx_last - npods + 1,
+				min(ddp->idx_last + npods, ddp->nppods),
 						      npods, gl);
+		}
 	}
 	if (idx < 0) {
 		ddp_log_debug("xferlen %u, gl %u, npods %u NO DDP.\n",
-- 
1.6.0.6

