From: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>
Subject: [PATCH 3/3] sg: use blk_rq_aligned helper function
Date: Thu, 28 Aug 2008 15:05:59 +0900
Message-ID: <1219903559-32612-4-git-send-email-fujita.tomonori@lab.ntt.co.jp>
References: <1219903559-32612-1-git-send-email-fujita.tomonori@lab.ntt.co.jp>
 <1219903559-32612-2-git-send-email-fujita.tomonori@lab.ntt.co.jp>
 <1219903559-32612-3-git-send-email-fujita.tomonori@lab.ntt.co.jp>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from sh.osrg.net ([192.16.179.4]:49399 "EHLO sh.osrg.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751750AbYH1GH0 (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Thu, 28 Aug 2008 02:07:26 -0400
In-Reply-To: <1219903559-32612-3-git-send-email-fujita.tomonori@lab.ntt.co.jp>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: jens.axboe@oracle.com
Cc: linux-scsi@vger.kernel.org, FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>, Douglas Gilbert <dougg@torque.net>

Signed-off-by: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>
Cc: Douglas Gilbert <dougg@torque.net>
Cc: Jens Axboe <jens.axboe@oracle.com>
---
 drivers/scsi/sg.c |    4 +---
 1 files changed, 1 insertions(+), 3 deletions(-)

diff --git a/drivers/scsi/sg.c b/drivers/scsi/sg.c
index 56a5d96..61262bd 100644
--- a/drivers/scsi/sg.c
+++ b/drivers/scsi/sg.c
@@ -1656,11 +1656,9 @@ static int sg_start_req(Sg_request *srp, unsigned char *cmd)
 	sg_io_hdr_t *hp = &srp->header;
 	int dxfer_len = (int) hp->dxfer_len;
 	int dxfer_dir = hp->dxfer_direction;
-	unsigned long uaddr = (unsigned long)hp->dxferp;
 	Sg_scatter_hold *req_schp = &srp->data;
 	Sg_scatter_hold *rsv_schp = &sfp->reserve;
 	struct request_queue *q = sfp->parentdp->device->request_queue;
-	unsigned long alignment = queue_dma_alignment(q) | q->dma_pad_mask;
 	struct rq_map_data map_data;
 
 	SCSI_LOG_TIMEOUT(4, printk("sg_start_req: dxfer_len=%d\n", dxfer_len));
@@ -1676,7 +1674,7 @@ static int sg_start_req(Sg_request *srp, unsigned char *cmd)
 	if (sg_allow_dio && (hp->flags & SG_FLAG_DIRECT_IO) &&
 	    (dxfer_dir != SG_DXFER_UNKNOWN) && (0 == hp->iovec_count) &&
 	    (!sfp->parentdp->device->host->unchecked_isa_dma) &&
-	    !(uaddr & alignment) && !(dxfer_len & alignment))
+	    blk_rq_aligned(q, hp->dxferp, dxfer_len))
 		return sg_build_direct(srp, sfp, dxfer_len);
 #endif
 	if ((!sg_res_in_use(sfp)) && (dxfer_len <= rsv_schp->bufflen))
-- 
1.5.5.GIT

