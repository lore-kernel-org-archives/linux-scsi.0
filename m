From: Pete Wyckoff <pw@osc.edu>
Subject: [PATCH 3/3] iscsi iser: increase sg_tablesize
Date: Tue, 12 Feb 2008 15:54:31 -0500
Message-ID: <20080212205431.GE13643@osc.edu>
References: <20080212205252.GB13643@osc.edu>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from marge.padd.com ([66.127.62.138]:39891 "EHLO marge.padd.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756131AbYBLUyf (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Tue, 12 Feb 2008 15:54:35 -0500
Content-Disposition: inline
In-Reply-To: <20080212205252.GB13643@osc.edu>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Mike Christie <michaelc@cs.wisc.edu>, Erez Zilber <erezz@voltaire.com>, Roland Dreier <rolandd@cisco.com>
Cc: linux-scsi <linux-scsi@vger.kernel.org>

Increase FMR limits from 512 kB to 1 MB.  This matches the limit
used by SRP which also uses FMRs for memory mapping.  Also
correct a bug where the sg_tablesize was 1 smaller than what was
allocated, by folding the "+ 1" used everywhere into the
definition of the constant.

Signed-off-by: Pete Wyckoff <pw@osc.edu>
---
 drivers/infiniband/ulp/iser/iscsi_iser.h |    3 ++-
 drivers/infiniband/ulp/iser/iser_verbs.c |    6 ++----
 2 files changed, 4 insertions(+), 5 deletions(-)

diff --git a/drivers/infiniband/ulp/iser/iscsi_iser.h b/drivers/infiniband/ulp/iser/iscsi_iser.h
index 1ee867b..db8f81a 100644
--- a/drivers/infiniband/ulp/iser/iscsi_iser.h
+++ b/drivers/infiniband/ulp/iser/iscsi_iser.h
@@ -87,7 +87,8 @@
 #define MASK_4K	(~(SIZE_4K-1))
 
 					/* support upto 512KB in one RDMA */
-#define ISCSI_ISER_SG_TABLESIZE         (0x80000 >> SHIFT_4K)
+/* FMR space for 1 MB of 4k-page transfers, plus 1 if not page aligned */
+#define ISCSI_ISER_SG_TABLESIZE         (((1<<20) >> SHIFT_4K) + 1)
 #define ISCSI_ISER_MAX_LUN		256
 #define ISCSI_ISER_MAX_CMD_LEN		16
 
diff --git a/drivers/infiniband/ulp/iser/iser_verbs.c b/drivers/infiniband/ulp/iser/iser_verbs.c
index 714b8db..c5b374f 100644
--- a/drivers/infiniband/ulp/iser/iser_verbs.c
+++ b/drivers/infiniband/ulp/iser/iser_verbs.c
@@ -140,7 +140,7 @@ static int iser_create_ib_conn_res(struct iser_conn *ib_conn)
 	device = ib_conn->device;
 
 	ib_conn->page_vec = kmalloc(sizeof(struct iser_page_vec) +
-				    (sizeof(u64) * (ISCSI_ISER_SG_TABLESIZE +1)),
+				    sizeof(u64) * ISCSI_ISER_SG_TABLESIZE,
 				    GFP_KERNEL);
 	if (!ib_conn->page_vec) {
 		ret = -ENOMEM;
@@ -149,9 +149,7 @@ static int iser_create_ib_conn_res(struct iser_conn *ib_conn)
 	ib_conn->page_vec->pages = (u64 *) (ib_conn->page_vec + 1);
 
 	params.page_shift        = SHIFT_4K;
-	/* when the first/last SG element are not start/end *
-	 * page aligned, the map whould be of N+1 pages     */
-	params.max_pages_per_fmr = ISCSI_ISER_SG_TABLESIZE + 1;
+	params.max_pages_per_fmr = ISCSI_ISER_SG_TABLESIZE;
 	/* make the pool size twice the max number of SCSI commands *
 	 * the ML is expected to queue, watermark for unmap at 50%  */
 	params.pool_size	 = ISCSI_DEF_XMIT_CMDS_MAX * 2;
-- 
1.5.3.8

