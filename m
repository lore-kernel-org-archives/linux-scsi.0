From: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>
Subject: [PATCH 4/8] sg: remove __sg_start_req
Date: Tue,  2 Sep 2008 22:50:04 +0900
Message-ID: <1220363408-7134-5-git-send-email-fujita.tomonori@lab.ntt.co.jp>
References: <1220363408-7134-1-git-send-email-fujita.tomonori@lab.ntt.co.jp>
 <1220363408-7134-2-git-send-email-fujita.tomonori@lab.ntt.co.jp>
 <1220363408-7134-3-git-send-email-fujita.tomonori@lab.ntt.co.jp>
 <1220363408-7134-4-git-send-email-fujita.tomonori@lab.ntt.co.jp>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mo10.iij4u.or.jp ([210.138.174.78]:56061 "EHLO mo10.iij4u.or.jp"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751648AbYIBNww (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Tue, 2 Sep 2008 09:52:52 -0400
In-Reply-To: <1220363408-7134-4-git-send-email-fujita.tomonori@lab.ntt.co.jp>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: jens.axboe@oracle.com
Cc: linux-scsi@vger.kernel.org, dougg@torque.net, michaelc@cs.wisc.edu, James.Bottomley@HansenPartnership.com, fujita.tomonori@lab.ntt.co.jp

__sg_start_req() was used temporarily to call blk_get_request() during
converting sg to use the block layer.

Now sg always calls blk_get_request() so we can move blk_get_request()
to sg_start_req(). We don't need __sg_start_req anymore.

Signed-off-by: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>
---
 drivers/scsi/sg.c |   38 +++++++++++++-------------------------
 1 files changed, 13 insertions(+), 25 deletions(-)

diff --git a/drivers/scsi/sg.c b/drivers/scsi/sg.c
index ccce31a..9a56c0d 100644
--- a/drivers/scsi/sg.c
+++ b/drivers/scsi/sg.c
@@ -1626,14 +1626,23 @@ exit_sg(void)
 	idr_destroy(&sg_index_idr);
 }
 
-static int __sg_start_req(struct sg_request *srp, struct sg_io_hdr *hp,
-			  unsigned char *cmd)
+static int sg_start_req(Sg_request *srp, unsigned char *cmd)
 {
-	struct sg_fd *sfp = srp->parentfp;
-	struct request_queue *q = sfp->parentdp->device->request_queue;
+	int res = 0;
 	struct request *rq;
+	Sg_fd *sfp = srp->parentfp;
+	sg_io_hdr_t *hp = &srp->header;
+	int dxfer_len = (int) hp->dxfer_len;
+	int dxfer_dir = hp->dxfer_direction;
+	Sg_scatter_hold *req_schp = &srp->data;
+	Sg_scatter_hold *rsv_schp = &sfp->reserve;
+	struct request_queue *q = sfp->parentdp->device->request_queue;
+	struct rq_map_data map_data;
 	int rw = hp->dxfer_direction == SG_DXFER_TO_DEV ? WRITE : READ;
 
+	SCSI_LOG_TIMEOUT(4, printk(KERN_INFO "sg_start_req: dxfer_len=%d\n",
+				   dxfer_len));
+
 	rq = blk_get_request(q, rw, GFP_ATOMIC);
 	if (!rq)
 		return -ENOMEM;
@@ -1648,27 +1657,6 @@ static int __sg_start_req(struct sg_request *srp, struct sg_io_hdr *hp,
 	rq->sense = srp->sense_b;
 	rq->retries = SG_DEFAULT_RETRIES;
 
-	return 0;
-}
-
-static int sg_start_req(Sg_request *srp, unsigned char *cmd)
-{
-	int res;
-	Sg_fd *sfp = srp->parentfp;
-	sg_io_hdr_t *hp = &srp->header;
-	int dxfer_len = (int) hp->dxfer_len;
-	int dxfer_dir = hp->dxfer_direction;
-	Sg_scatter_hold *req_schp = &srp->data;
-	Sg_scatter_hold *rsv_schp = &sfp->reserve;
-	struct request_queue *q = sfp->parentdp->device->request_queue;
-	struct rq_map_data map_data;
-
-	SCSI_LOG_TIMEOUT(4, printk("sg_start_req: dxfer_len=%d\n", dxfer_len));
-
-	res = __sg_start_req(srp, hp, cmd);
-	if (res)
-		return res;
-
 	if ((dxfer_len <= 0) || (dxfer_dir == SG_DXFER_NONE))
 		return 0;
 
-- 
1.5.4.2

