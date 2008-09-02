From: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>
Subject: [PATCH 5/8] sg: incorporate sg_build_direct into sg_start_req
Date: Tue,  2 Sep 2008 22:50:05 +0900
Message-ID: <1220363408-7134-6-git-send-email-fujita.tomonori@lab.ntt.co.jp>
References: <1220363408-7134-1-git-send-email-fujita.tomonori@lab.ntt.co.jp>
 <1220363408-7134-2-git-send-email-fujita.tomonori@lab.ntt.co.jp>
 <1220363408-7134-3-git-send-email-fujita.tomonori@lab.ntt.co.jp>
 <1220363408-7134-4-git-send-email-fujita.tomonori@lab.ntt.co.jp>
 <1220363408-7134-5-git-send-email-fujita.tomonori@lab.ntt.co.jp>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mo11.iij4u.or.jp ([210.138.174.79]:50958 "EHLO mo11.iij4u.or.jp"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751538AbYIBNx0 (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Tue, 2 Sep 2008 09:53:26 -0400
In-Reply-To: <1220363408-7134-5-git-send-email-fujita.tomonori@lab.ntt.co.jp>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: jens.axboe@oracle.com
Cc: linux-scsi@vger.kernel.org, dougg@torque.net, michaelc@cs.wisc.edu, James.Bottomley@HansenPartnership.com, fujita.tomonori@lab.ntt.co.jp

Calling blk_rq_map_user() at a single place is better than at
different two places. It makes the code more understandable.

Signed-off-by: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>
---
 drivers/scsi/sg.c |   82 ++++++++++++++++++++++-------------------------------
 1 files changed, 34 insertions(+), 48 deletions(-)

diff --git a/drivers/scsi/sg.c b/drivers/scsi/sg.c
index 9a56c0d..c0b6866 100644
--- a/drivers/scsi/sg.c
+++ b/drivers/scsi/sg.c
@@ -202,7 +202,6 @@ static Sg_request *sg_get_rq_mark(Sg_fd * sfp, int pack_id);
 static Sg_request *sg_add_request(Sg_fd * sfp);
 static int sg_remove_request(Sg_fd * sfp, Sg_request * srp);
 static int sg_res_in_use(Sg_fd * sfp);
-static int sg_build_direct(Sg_request * srp, Sg_fd * sfp, int dxfer_len);
 static Sg_device *sg_get_dev(int dev);
 #ifdef CONFIG_SCSI_PROC_FS
 static int sg_last_dev(void);
@@ -1628,16 +1627,17 @@ exit_sg(void)
 
 static int sg_start_req(Sg_request *srp, unsigned char *cmd)
 {
-	int res = 0;
+	int res;
 	struct request *rq;
 	Sg_fd *sfp = srp->parentfp;
 	sg_io_hdr_t *hp = &srp->header;
 	int dxfer_len = (int) hp->dxfer_len;
 	int dxfer_dir = hp->dxfer_direction;
+	unsigned int iov_count = hp->iovec_count;
 	Sg_scatter_hold *req_schp = &srp->data;
 	Sg_scatter_hold *rsv_schp = &sfp->reserve;
 	struct request_queue *q = sfp->parentdp->device->request_queue;
-	struct rq_map_data map_data;
+	struct rq_map_data *md, map_data;
 	int rw = hp->dxfer_direction == SG_DXFER_TO_DEV ? WRITE : READ;
 
 	SCSI_LOG_TIMEOUT(4, printk(KERN_INFO "sg_start_req: dxfer_len=%d\n",
@@ -1660,38 +1660,43 @@ static int sg_start_req(Sg_request *srp, unsigned char *cmd)
 	if ((dxfer_len <= 0) || (dxfer_dir == SG_DXFER_NONE))
 		return 0;
 
-	if (sg_allow_dio && (hp->flags & SG_FLAG_DIRECT_IO) &&
-	    (dxfer_dir != SG_DXFER_UNKNOWN) && (0 == hp->iovec_count) &&
-	    (!sfp->parentdp->device->host->unchecked_isa_dma) &&
+	if (sg_allow_dio && hp->flags & SG_FLAG_DIRECT_IO &&
+	    dxfer_dir != SG_DXFER_UNKNOWN && !iov_count &&
+	    !sfp->parentdp->device->host->unchecked_isa_dma &&
 	    blk_rq_aligned(q, hp->dxferp, dxfer_len))
-		return sg_build_direct(srp, sfp, dxfer_len);
+		md = NULL;
+	else
+		md = &map_data;
+
+	if (md) {
+		if (!sg_res_in_use(sfp) && dxfer_len <= rsv_schp->bufflen)
+			sg_link_reserve(sfp, srp, dxfer_len);
+		else {
+			res = sg_build_indirect(req_schp, sfp, dxfer_len);
+			if (res)
+				return res;
+		}
 
-	if ((!sg_res_in_use(sfp)) && (dxfer_len <= rsv_schp->bufflen))
-		sg_link_reserve(sfp, srp, dxfer_len);
+		md->pages = req_schp->pages;
+		md->page_order = req_schp->page_order;
+		md->nr_entries = req_schp->k_use_sg;
+	}
+
+	if (iov_count)
+		res = blk_rq_map_user_iov(q, rq, md, hp->dxferp, iov_count,
+					  hp->dxfer_len, GFP_ATOMIC);
 	else
-		res = sg_build_indirect(req_schp, sfp, dxfer_len);
+		res = blk_rq_map_user(q, rq, md, hp->dxferp,
+				      hp->dxfer_len, GFP_ATOMIC);
 
 	if (!res) {
-		struct request *rq = srp->rq;
-		Sg_scatter_hold *schp = &srp->data;
-		int iovec_count = (int) hp->iovec_count;
-
-		map_data.pages = schp->pages;
-		map_data.page_order = schp->page_order;
-		map_data.nr_entries = schp->k_use_sg;
-
-		if (iovec_count)
-			res = blk_rq_map_user_iov(q, rq, &map_data, hp->dxferp,
-						  iovec_count,
-						  hp->dxfer_len, GFP_ATOMIC);
-		else
-			res = blk_rq_map_user(q, rq, &map_data, hp->dxferp,
-					      hp->dxfer_len, GFP_ATOMIC);
+		srp->bio = rq->bio;
 
-		if (!res)
-			srp->bio = rq->bio;
+		if (!md) {
+			req_schp->dio_in_use = 1;
+			hp->info |= SG_INFO_DIRECT_IO;
+		}
 	}
-
 	return res;
 }
 
@@ -1730,25 +1735,6 @@ sg_build_sgat(Sg_scatter_hold * schp, const Sg_fd * sfp, int tablesize)
 	return tablesize;	/* number of scat_gath elements allocated */
 }
 
-/* Returns: -ve -> error, 0 -> done, 1 -> try indirect */
-static int
-sg_build_direct(Sg_request * srp, Sg_fd * sfp, int dxfer_len)
-{
-	sg_io_hdr_t *hp = &srp->header;
-	Sg_scatter_hold *schp = &srp->data;
-	int res;
-	struct request *rq = srp->rq;
-	struct request_queue *q = sfp->parentdp->device->request_queue;
-
-	res = blk_rq_map_user(q, rq, NULL, hp->dxferp, dxfer_len, GFP_ATOMIC);
-	if (res)
-		return res;
-	srp->bio = rq->bio;
-	schp->dio_in_use = 1;
-	hp->info |= SG_INFO_DIRECT_IO;
-	return 0;
-}
-
 static int
 sg_build_indirect(Sg_scatter_hold * schp, Sg_fd * sfp, int buff_size)
 {
-- 
1.5.4.2

