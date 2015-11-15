From: Christoph Hellwig <hch@lst.de>
Subject: [PATCH] ib_srp: initialize dma_length in srp_map_idb
Date: Sun, 15 Nov 2015 18:59:53 +0100
Message-ID: <1447610393-2899-1-git-send-email-hch@lst.de>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([198.137.202.9]:48284 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752265AbbKOSEU (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Sun, 15 Nov 2015 13:04:20 -0500
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Bart Van Assche <bart.vanassche@sandisk.com>
Cc: sagig@dev.mellanox.co.il, linux-scsi@vger.kernel.org, linux-rdma@vger.kernel.org

Without this sg_dma_len will return 0 on architectures tha have
the dma_length field.

Signed-off-by: Christoph Hellwig <hch@lst.de>
---
 drivers/infiniband/ulp/srp/ib_srp.c | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/drivers/infiniband/ulp/srp/ib_srp.c b/drivers/infiniband/ulp/srp/ib_srp.c
index 32f7962..445c0a6 100644
--- a/drivers/infiniband/ulp/srp/ib_srp.c
+++ b/drivers/infiniband/ulp/srp/ib_srp.c
@@ -1520,6 +1520,9 @@ static int srp_map_idb(struct srp_rdma_ch *ch, struct srp_request *req,
 		state.sg_nents = 1;
 		sg_set_buf(idb_sg, req->indirect_desc, idb_len);
 		idb_sg->dma_address = req->indirect_dma_addr; /* hack! */
+#ifdef CONFIG_NEED_SG_DMA_LENGTH
+		idb_sg->dma_length = idb_sg->length;	      /* hack^2 */
+#endif
 		ret = srp_map_finish_fr(&state, ch);
 		if (ret < 0)
 			return ret;
-- 
1.9.1

