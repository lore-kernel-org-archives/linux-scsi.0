From: "Nicholas A. Bellinger" <nab@linux-iscsi.org>
Subject: [PATCH 1/9] ib_srpt: Fix potential out-of-bounds array access
Date: Mon, 24 Oct 2011 05:33:34 +0000
Message-ID: <1319434422-15354-2-git-send-email-nab@linux-iscsi.org>
References: <1319434422-15354-1-git-send-email-nab@linux-iscsi.org>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail.linux-iscsi.org ([67.23.28.174]:59561 "EHLO
	linux-iscsi.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753018Ab1JXFfS (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Mon, 24 Oct 2011 01:35:18 -0400
In-Reply-To: <1319434422-15354-1-git-send-email-nab@linux-iscsi.org>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: target-devel <target-devel@vger.kernel.org>, linux-rdma <linux-rdma@vger.kernel.org>
Cc: linux-scsi <linux-scsi@vger.kernel.org>, Roland Dreier <roland@purestorage.com>, Bart Van Assche <bvanassche@acm.org>, "Nicholas A. Bellinger" <nab@linux-iscsi.org>

From: Bart Van Assche <bvanassche@acm.org>

This patch fixes a potential out-of-bounds array access in
srpt_map_sg_to_ib_sge().  This is bugfix port from SCST svn r3262
as recommended by Bart Van Assche for the initial ib_srpt merge.

Cc: Bart Van Assche <bvanassche@acm.org>
Cc: Roland Dreier <roland@purestorage.com>
Signed-off-by: Nicholas A. Bellinger <nab@linux-iscsi.org>
---
 drivers/infiniband/ulp/srpt/ib_srpt.c |    7 ++++---
 1 files changed, 4 insertions(+), 3 deletions(-)

diff --git a/drivers/infiniband/ulp/srpt/ib_srpt.c b/drivers/infiniband/ulp/srpt/ib_srpt.c
index e412a35..383994d 100644
--- a/drivers/infiniband/ulp/srpt/ib_srpt.c
+++ b/drivers/infiniband/ulp/srpt/ib_srpt.c
@@ -1142,7 +1142,8 @@ static int srpt_map_sg_to_ib_sge(struct srpt_rdma_ch *ch,
 	if (ioctx->rdma_ius && ioctx->n_rdma_ius)
 		nrdma = ioctx->n_rdma_ius;
 	else {
-		nrdma = count / SRPT_DEF_SG_PER_WQE + ioctx->n_rbuf;
+		nrdma = (count + SRPT_DEF_SG_PER_WQE - 1) / SRPT_DEF_SG_PER_WQE
+			+ ioctx->n_rbuf;
 
 		ioctx->rdma_ius = kzalloc(nrdma * sizeof *riu, GFP_KERNEL);
 		if (!ioctx->rdma_ius)
@@ -1258,11 +1259,11 @@ static int srpt_map_sg_to_ib_sge(struct srpt_rdma_ch *ch,
 			}
 
 			++k;
-			if (k == riu->sge_cnt && rsize > 0) {
+			if (k == riu->sge_cnt && rsize > 0 && tsize > 0) {
 				++riu;
 				sge = riu->sge;
 				k = 0;
-			} else if (rsize > 0)
+			} else if (rsize > 0 && tsize > 0)
 				++sge;
 		}
 	}
-- 
1.7.2.5

