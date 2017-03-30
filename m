From: Logan Gunthorpe <logang-OTvnGxWRz7hWk0Htik3J/w@public.gmane.org>
Subject: [RFC 6/8] nvmet: Be careful about using iomem accesses when dealing
 with p2pmem
Date: Thu, 30 Mar 2017 16:12:37 -0600
Message-ID: <1490911959-5146-7-git-send-email-logang@deltatee.com>
References: <1490911959-5146-1-git-send-email-logang@deltatee.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <linux-nvdimm-bounces-hn68Rpc1hR1g9hUCZPvPmw@public.gmane.org>
In-Reply-To: <1490911959-5146-1-git-send-email-logang-OTvnGxWRz7hWk0Htik3J/w@public.gmane.org>
List-Unsubscribe: <https://lists.01.org/mailman/options/linux-nvdimm>,
 <mailto:linux-nvdimm-request-hn68Rpc1hR1g9hUCZPvPmw@public.gmane.org?subject=unsubscribe>
List-Archive: <http://lists.01.org/pipermail/linux-nvdimm/>
List-Post: <mailto:linux-nvdimm-hn68Rpc1hR1g9hUCZPvPmw@public.gmane.org>
List-Help: <mailto:linux-nvdimm-request-hn68Rpc1hR1g9hUCZPvPmw@public.gmane.org?subject=help>
List-Subscribe: <https://lists.01.org/mailman/listinfo/linux-nvdimm>,
 <mailto:linux-nvdimm-request-hn68Rpc1hR1g9hUCZPvPmw@public.gmane.org?subject=subscribe>
Errors-To: linux-nvdimm-bounces-hn68Rpc1hR1g9hUCZPvPmw@public.gmane.org
Sender: "Linux-nvdimm" <linux-nvdimm-bounces-hn68Rpc1hR1g9hUCZPvPmw@public.gmane.org>
To: Christoph Hellwig <hch-jcswGhMUV9g@public.gmane.org>, Sagi Grimberg <sagi-NQWnxTmZq1alnMjI0IkVqw@public.gmane.org>, "James E.J. Bottomley" <jejb-23VcF4HTsmIX0ybBhKVfKdBPR1lH4CV8@public.gmane.org>, "Martin K. Petersen" <martin.petersen-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org>, Jens Axboe <axboe-tSWWG44O7X1aa/9Udqfwiw@public.gmane.org>, Steve Wise <swise-7bPotxP6k4+P2YhJcF5u+vpXobYPEAuW@public.gmane.org>, Stephen Bates <sbates-pv7U853sEMVWk0Htik3J/w@public.gmane.org>, Max Gurtovoy <maxg-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Dan Williams <dan.j.williams-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, Keith Busch <keith.busch-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, Jason Gunthorpe <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
Cc: linux-scsi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-nvdimm-hn68Rpc1hR1g9hUCZPvPmw@public.gmane.org, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-pci-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-nvme-IAPFreCvJWM7uuMidbF8XUB+6BGkLq7r@public.gmane.org
List-Id: linux-scsi@vger.kernel.org

p2pmem will always be iomem so if we ever access it, we should be using
the correct methods to read and write to it.

Signed-off-by: Logan Gunthorpe <logang-OTvnGxWRz7hWk0Htik3J/w@public.gmane.org>
Signed-off-by: Stephen Bates <sbates-pv7U853sEMVWk0Htik3J/w@public.gmane.org>
Signed-off-by: Steve Wise <swise-7bPotxP6k4+P2YhJcF5u+vpXobYPEAuW@public.gmane.org>
---
 drivers/nvme/target/core.c        | 18 ++++++++++++++++--
 drivers/nvme/target/fabrics-cmd.c | 28 +++++++++++++++-------------
 drivers/nvme/target/nvmet.h       |  1 +
 drivers/nvme/target/rdma.c        | 13 ++++++-------
 4 files changed, 38 insertions(+), 22 deletions(-)

diff --git a/drivers/nvme/target/core.c b/drivers/nvme/target/core.c
index 798653b..a1524d5 100644
--- a/drivers/nvme/target/core.c
+++ b/drivers/nvme/target/core.c
@@ -45,15 +45,29 @@ static struct nvmet_subsys *nvmet_find_get_subsys(struct nvmet_port *port,
 u16 nvmet_copy_to_sgl(struct nvmet_req *req, off_t off, const void *buf,
 		size_t len)
 {
-	if (sg_pcopy_from_buffer(req->sg, req->sg_cnt, buf, len, off) != len)
+	bool iomem = req->p2pmem;
+	size_t ret;
+
+	ret = sg_copy_buffer(req->sg, req->sg_cnt, (void *)buf, len, off,
+			     false, iomem);
+
+	if (ret != len)
 		return NVME_SC_SGL_INVALID_DATA | NVME_SC_DNR;
+
 	return 0;
 }
 
 u16 nvmet_copy_from_sgl(struct nvmet_req *req, off_t off, void *buf, size_t len)
 {
-	if (sg_pcopy_to_buffer(req->sg, req->sg_cnt, buf, len, off) != len)
+	bool iomem = req->p2pmem;
+	size_t ret;
+
+	ret = sg_copy_buffer(req->sg, req->sg_cnt, buf, len, off, true,
+			     iomem);
+
+	if (ret != len)
 		return NVME_SC_SGL_INVALID_DATA | NVME_SC_DNR;
+
 	return 0;
 }
 
diff --git a/drivers/nvme/target/fabrics-cmd.c b/drivers/nvme/target/fabrics-cmd.c
index 8bd022af..9d966f0 100644
--- a/drivers/nvme/target/fabrics-cmd.c
+++ b/drivers/nvme/target/fabrics-cmd.c
@@ -118,11 +118,13 @@ static u16 nvmet_install_queue(struct nvmet_ctrl *ctrl, struct nvmet_req *req)
 static void nvmet_execute_admin_connect(struct nvmet_req *req)
 {
 	struct nvmf_connect_command *c = &req->cmd->connect;
-	struct nvmf_connect_data *d;
+	struct nvmf_connect_data d;
 	struct nvmet_ctrl *ctrl = NULL;
 	u16 status = 0;
 
-	d = kmap(sg_page(req->sg)) + req->sg->offset;
+	status = nvmet_copy_from_sgl(req, 0, &d, sizeof(d));
+	if (status)
+		goto out;
 
 	/* zero out initial completion result, assign values as needed */
 	req->rsp->result.u32 = 0;
@@ -134,16 +136,16 @@ static void nvmet_execute_admin_connect(struct nvmet_req *req)
 		goto out;
 	}
 
-	if (unlikely(d->cntlid != cpu_to_le16(0xffff))) {
+	if (unlikely(d.cntlid != cpu_to_le16(0xffff))) {
 		pr_warn("connect attempt for invalid controller ID %#x\n",
-			d->cntlid);
+			d.cntlid);
 		status = NVME_SC_CONNECT_INVALID_PARAM | NVME_SC_DNR;
 		req->rsp->result.u32 = IPO_IATTR_CONNECT_DATA(cntlid);
 		goto out;
 	}
 
-	status = nvmet_alloc_ctrl(d->subsysnqn, d->hostnqn, req,
-			le32_to_cpu(c->kato), &ctrl);
+	status = nvmet_alloc_ctrl(d.subsysnqn, d.hostnqn, req,
+				  le32_to_cpu(c->kato), &ctrl);
 	if (status)
 		goto out;
 
@@ -158,19 +160,20 @@ static void nvmet_execute_admin_connect(struct nvmet_req *req)
 	req->rsp->result.u16 = cpu_to_le16(ctrl->cntlid);
 
 out:
-	kunmap(sg_page(req->sg));
 	nvmet_req_complete(req, status);
 }
 
 static void nvmet_execute_io_connect(struct nvmet_req *req)
 {
 	struct nvmf_connect_command *c = &req->cmd->connect;
-	struct nvmf_connect_data *d;
+	struct nvmf_connect_data d;
 	struct nvmet_ctrl *ctrl = NULL;
 	u16 qid = le16_to_cpu(c->qid);
 	u16 status = 0;
 
-	d = kmap(sg_page(req->sg)) + req->sg->offset;
+	status = nvmet_copy_from_sgl(req, 0, &d, sizeof(d));
+	if (status)
+		goto out;
 
 	/* zero out initial completion result, assign values as needed */
 	req->rsp->result.u32 = 0;
@@ -182,9 +185,9 @@ static void nvmet_execute_io_connect(struct nvmet_req *req)
 		goto out;
 	}
 
-	status = nvmet_ctrl_find_get(d->subsysnqn, d->hostnqn,
-			le16_to_cpu(d->cntlid),
-			req, &ctrl);
+	status = nvmet_ctrl_find_get(d.subsysnqn, d.hostnqn,
+				     le16_to_cpu(d.cntlid),
+				     req, &ctrl);
 	if (status)
 		goto out;
 
@@ -205,7 +208,6 @@ static void nvmet_execute_io_connect(struct nvmet_req *req)
 	pr_info("adding queue %d to ctrl %d.\n", qid, ctrl->cntlid);
 
 out:
-	kunmap(sg_page(req->sg));
 	nvmet_req_complete(req, status);
 	return;
 
diff --git a/drivers/nvme/target/nvmet.h b/drivers/nvme/target/nvmet.h
index ab67175..ccd79ed 100644
--- a/drivers/nvme/target/nvmet.h
+++ b/drivers/nvme/target/nvmet.h
@@ -226,6 +226,7 @@ struct nvmet_req {
 
 	void (*execute)(struct nvmet_req *req);
 	struct nvmet_fabrics_ops *ops;
+	struct p2pmem_dev       *p2pmem;
 };
 
 static inline void nvmet_set_status(struct nvmet_req *req, u16 status)
diff --git a/drivers/nvme/target/rdma.c b/drivers/nvme/target/rdma.c
index 7fd4840..abab544 100644
--- a/drivers/nvme/target/rdma.c
+++ b/drivers/nvme/target/rdma.c
@@ -65,7 +65,6 @@ struct nvmet_rdma_rsp {
 	struct rdma_rw_ctx	rw;
 
 	struct nvmet_req	req;
-	struct p2pmem_dev       *p2pmem;
 
 	u8			n_rdma;
 	u32			flags;
@@ -501,7 +500,7 @@ static void nvmet_rdma_release_rsp(struct nvmet_rdma_rsp *rsp)
 
 	if (rsp->req.sg != &rsp->cmd->inline_sg)
 		nvmet_rdma_free_sgl(rsp->req.sg, rsp->req.sg_cnt,
-				    rsp->p2pmem);
+				    rsp->req.p2pmem);
 
 	if (unlikely(!list_empty_careful(&queue->rsp_wr_wait_list)))
 		nvmet_rdma_process_wr_wait_list(queue);
@@ -642,14 +641,14 @@ static u16 nvmet_rdma_map_sgl_keyed(struct nvmet_rdma_rsp *rsp,
 	if (!len)
 		return 0;
 
-	rsp->p2pmem = rsp->queue->p2pmem;
+	rsp->req.p2pmem = rsp->queue->p2pmem;
 	status = nvmet_rdma_alloc_sgl(&rsp->req.sg, &rsp->req.sg_cnt,
-			len, rsp->p2pmem);
+				      len, rsp->req.p2pmem);
 
-	if (status && rsp->p2pmem) {
-		rsp->p2pmem = NULL;
+	if (status && rsp->req.p2pmem) {
+		rsp->req.p2pmem = NULL;
 		status = nvmet_rdma_alloc_sgl(&rsp->req.sg, &rsp->req.sg_cnt,
-					      len, rsp->p2pmem);
+					      len, rsp->req.p2pmem);
 	}
 
 	if (status)
-- 
2.1.4
