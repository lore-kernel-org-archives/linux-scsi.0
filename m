From: Christoph Hellwig <hch@lst.de>
Subject: [PATCH 3/9] IB: add a helper to safely drain a QP
Date: Fri, 13 Nov 2015 14:46:44 +0100
Message-ID: <1447422410-20891-4-git-send-email-hch@lst.de>
References: <1447422410-20891-1-git-send-email-hch@lst.de>
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <1447422410-20891-1-git-send-email-hch@lst.de>
Sender: linux-kernel-owner@vger.kernel.org
To: linux-rdma@vger.kernel.org
Cc: sagig@dev.mellanox.co.il, bart.vanassche@sandisk.com, axboe@fb.com, linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org

Signed-off-by: Christoph Hellwig <hch@lst.de>
---
 drivers/infiniband/core/cq.c | 46 ++++++++++++++++++++++++++++++++++++++++++++
 include/rdma/ib_verbs.h      |  2 ++
 2 files changed, 48 insertions(+)

diff --git a/drivers/infiniband/core/cq.c b/drivers/infiniband/core/cq.c
index d9eb796..bf2a079 100644
--- a/drivers/infiniband/core/cq.c
+++ b/drivers/infiniband/core/cq.c
@@ -206,3 +206,49 @@ void ib_free_cq(struct ib_cq *cq)
 	WARN_ON_ONCE(ret);
 }
 EXPORT_SYMBOL(ib_free_cq);
+
+struct ib_stop_cqe {
+	struct ib_cqe	cqe;
+	struct completion done;
+};
+
+static void ib_stop_done(struct ib_cq *cq, struct ib_wc *wc)
+{
+	struct ib_stop_cqe *stop =
+		container_of(wc->wr_cqe, struct ib_stop_cqe, cqe);
+
+	complete(&stop->done);
+}
+
+/*
+ * Change a queue pair into the error state and wait until all receive
+ * completions have been processed before destroying it. This avoids that
+ * the receive completion handler can access the queue pair while it is
+ * being destroyed.
+ */
+void ib_drain_qp(struct ib_qp *qp)
+{
+	struct ib_qp_attr attr = { .qp_state = IB_QPS_ERR };
+	struct ib_stop_cqe stop = { };
+	struct ib_recv_wr wr, *bad_wr;
+	int ret;
+
+	wr.wr_cqe = &stop.cqe;
+	stop.cqe.done = ib_stop_done;
+	init_completion(&stop.done);
+
+	ret = ib_modify_qp(qp, &attr, IB_QP_STATE);
+	if (ret) {
+		WARN_ONCE(ret, "failed to drain QP: %d\n", ret);
+		return;
+	}
+
+	ret = ib_post_recv(qp, &wr, &bad_wr);
+	if (ret) {
+		WARN_ONCE(ret, "failed to drain QP: %d\n", ret);
+		return;
+	}
+
+	wait_for_completion(&stop.done);
+}
+EXPORT_SYMBOL(ib_drain_qp);
diff --git a/include/rdma/ib_verbs.h b/include/rdma/ib_verbs.h
index e11e038..f59a8d3 100644
--- a/include/rdma/ib_verbs.h
+++ b/include/rdma/ib_verbs.h
@@ -3075,4 +3075,6 @@ int ib_sg_to_pages(struct ib_mr *mr,
 		   int sg_nents,
 		   int (*set_page)(struct ib_mr *, u64));
 
+void ib_drain_qp(struct ib_qp *qp);
+
 #endif /* IB_VERBS_H */
-- 
1.9.1
