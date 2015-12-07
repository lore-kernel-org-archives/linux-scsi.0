From: Christoph Hellwig <hch@lst.de>
Subject: [PATCH 12/13] IB/iser: Use helper for container_of
Date: Mon,  7 Dec 2015 12:51:51 -0800
Message-ID: <1449521512-22921-13-git-send-email-hch@lst.de>
References: <1449521512-22921-1-git-send-email-hch@lst.de>
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <1449521512-22921-1-git-send-email-hch@lst.de>
Sender: linux-kernel-owner@vger.kernel.org
To: linux-rdma@vger.kernel.org
Cc: sagig@dev.mellanox.co.il, bart.vanassche@sandisk.com, axboe@fb.com, linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org, Sagi Grimberg <sagig@mellanox.com>
List-Id: linux-scsi@vger.kernel.org

From: Sagi Grimberg <sagig@mellanox.com>

Nicer this way.

Signed-off-by: Sagi Grimberg <sagig@mellanox.com>
Signed-off-by: Christoph Hellwig <hch@lst.de>
---
 drivers/infiniband/ulp/iser/iscsi_iser.h     | 6 ++++++
 drivers/infiniband/ulp/iser/iser_initiator.c | 3 +--
 drivers/infiniband/ulp/iser/iser_verbs.c     | 6 ++----
 3 files changed, 9 insertions(+), 6 deletions(-)

diff --git a/drivers/infiniband/ulp/iser/iscsi_iser.h b/drivers/infiniband/ulp/iser/iscsi_iser.h
index 5648409..cf4c4ce 100644
--- a/drivers/infiniband/ulp/iser/iscsi_iser.h
+++ b/drivers/infiniband/ulp/iser/iscsi_iser.h
@@ -729,4 +729,10 @@ iser_tx_next_wr(struct iser_tx_desc *tx_desc)
 	return cur_wr;
 }
 
+static inline struct iser_conn *
+to_iser_conn(struct ib_conn *ib_conn)
+{
+	return container_of(ib_conn, struct iser_conn, ib_conn);
+}
+
 #endif
diff --git a/drivers/infiniband/ulp/iser/iser_initiator.c b/drivers/infiniband/ulp/iser/iser_initiator.c
index 21f28c8..21148b6 100644
--- a/drivers/infiniband/ulp/iser/iser_initiator.c
+++ b/drivers/infiniband/ulp/iser/iser_initiator.c
@@ -559,8 +559,7 @@ void iser_rcv_completion(struct iser_rx_desc *rx_desc,
 			 unsigned long rx_xfer_len,
 			 struct ib_conn *ib_conn)
 {
-	struct iser_conn *iser_conn = container_of(ib_conn, struct iser_conn,
-						   ib_conn);
+	struct iser_conn *iser_conn = to_iser_conn(ib_conn);
 	struct iscsi_hdr *hdr;
 	char *data;
 	u64 rx_dma;
diff --git a/drivers/infiniband/ulp/iser/iser_verbs.c b/drivers/infiniband/ulp/iser/iser_verbs.c
index ee4cebc..f75ef0c 100644
--- a/drivers/infiniband/ulp/iser/iser_verbs.c
+++ b/drivers/infiniband/ulp/iser/iser_verbs.c
@@ -455,8 +455,7 @@ void iser_free_fastreg_pool(struct ib_conn *ib_conn)
  */
 static int iser_create_ib_conn_res(struct ib_conn *ib_conn)
 {
-	struct iser_conn *iser_conn = container_of(ib_conn, struct iser_conn,
-						   ib_conn);
+	struct iser_conn *iser_conn = to_iser_conn(ib_conn);
 	struct iser_device	*device;
 	struct ib_device	*ib_dev;
 	struct ib_qp_init_attr	init_attr;
@@ -1160,9 +1159,8 @@ static void
 iser_handle_comp_error(struct ib_conn *ib_conn,
 		       struct ib_wc *wc)
 {
+	struct iser_conn *iser_conn = to_iser_conn(ib_conn);
 	void *wr_id = (void *)(uintptr_t)wc->wr_id;
-	struct iser_conn *iser_conn = container_of(ib_conn, struct iser_conn,
-						   ib_conn);
 
 	if (wc->status != IB_WC_WR_FLUSH_ERR)
 		if (iser_conn->iscsi_conn)
-- 
1.9.1
