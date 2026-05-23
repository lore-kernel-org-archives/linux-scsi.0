Received: from mout02.posteo.de (mout02.posteo.de [185.67.36.66])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7DC6D187346
	for <linux-scsi@vger.kernel.org>; Sat, 23 May 2026 12:52:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=185.67.36.66
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1779540767; cv=none; b=C8pEWXksW8XnL2mDOZiCI50b3+dv5ceNtM8i8Ph4Zk4ZYEJh3BxFJc2ShfziXN6TGBcVhkQjtCQIQJjjbed3HVW6F+OTUduEW34wwZZoThwyU9DzXzeeS3Zwo8K0ezsEFmdH4QT5ldSw4lWl19PYql2YmKsuYANgPzsxXMzcf00=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1779540767; c=relaxed/simple;
	bh=6+fWAZt+4ivYTzLpmo8IvPTUCuA4JscxLqeYDtrKYs4=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=k1/u0ooWhG/RX7FI7r+mOySo7aBGzje80efVKl6PXWbisE6ULf4SJuUaxUqIMb+SYj4Ybqaow9VlNqRx5fRCHlSYjpG4Qv9gy1gfWGMWoGKU9vorwvJp7K+mJW+/1UhTDwxsig7neq4TGGR0NkqTXkDyejsCDoi/dP8PIDzDtn4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=posteo.net; spf=pass smtp.mailfrom=posteo.net; dkim=pass (2048-bit key) header.d=posteo.net header.i=@posteo.net header.b=j3gOBikg; arc=none smtp.client-ip=185.67.36.66
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=posteo.net
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=posteo.net
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=posteo.net header.i=@posteo.net header.b="j3gOBikg"
Received: from submission (posteo.de [185.67.36.169]) 
	by mout02.posteo.de (Postfix) with ESMTPS id 4BA79240105
	for <linux-scsi@vger.kernel.org>; Sat, 23 May 2026 14:52:37 +0200 (CEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=posteo.net; s=2017;
	t=1779540757; bh=bxiCjbyE4L9dPupS9cBbu4nnbIMmzEr7N/QwhywpPUo=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version:
	 Content-Transfer-Encoding:From;
	b=j3gOBikgfn1xTd/Gd2B+JyqhIyaLtMxcxXdZX3m9eLRzQ1vmLG/sQ2WOzYbxt+OPZ
	 0W3blV4pxc1wVtCgfZSjDG54sl27t3gA80+tuXxyJ7moJCzoVmjgSApuLW5Ji4lG9i
	 l4LZ5AIUIJmiODfR+WIAw9GRIxXdCd2rF/dsklQuP8H0trjRBYUjfcyd2/1+2gRyTR
	 HQOg+JgGmG3x/otZzozN/kbh7DQxC5md5txTL9dtXZiq8KlOXLB89O8cC4GXsBm1sf
	 ERoqvMz8i/ZQosK4gKjcCaj6DkgX6TtWjYS+jXTZcvhP4h3nyFqk+ossLfxPYJ2lcp
	 IacfcRFiAnelQ==
Received: from customer (localhost [127.0.0.1])
	by submission (posteo.de) with ESMTPSA id 4gN29W11Cqz6tvq;
	Sat, 23 May 2026 14:52:31 +0200 (CEST)
From: Mateusz Nowicki <mateusz.nowicki@posteo.net>
To: Jens Axboe <axboe@kernel.dk>
Cc: Caleb Sander Mateos <csander@purestorage.com>,
	Sung-woo Kim <iam@sung-woo.kim>,
	Josef Bacik <josef@toxicpanda.com>,
	Alasdair Kergon <agk@redhat.com>,
	Mike Snitzer <snitzer@kernel.org>,
	Mikulas Patocka <mpatocka@redhat.com>,
	Benjamin Marzinski <bmarzins@redhat.com>,
	Ulf Hansson <ulfh@kernel.org>,
	Richard Weinberger <richard@nod.at>,
	Zhihao Cheng <chengzhihao1@huawei.com>,
	Miquel Raynal <miquel.raynal@bootlin.com>,
	Vignesh Raghavendra <vigneshr@ti.com>,
	Sven Peter <sven@kernel.org>,
	Janne Grunau <j@jannau.net>,
	Neal Gompa <neal@gompa.dev>,
	Keith Busch <kbusch@kernel.org>,
	Christoph Hellwig <hch@lst.de>,
	Sagi Grimberg <sagi@grimberg.me>,
	Justin Tee <justin.tee@broadcom.com>,
	Naresh Gottumukkala <nareshgottumukkala83@gmail.com>,
	Paul Ely <paul.ely@broadcom.com>,
	Chaitanya Kulkarni <kch@nvidia.com>,
	"James E.J. Bottomley" <James.Bottomley@HansenPartnership.com>,
	"Martin K. Petersen" <martin.petersen@oracle.com>,
	Thomas Fourier <fourier.thomas@gmail.com>,
	Al Viro <viro@zeniv.linux.org.uk>,
	Luke Wang <ziniu.wang_1@nxp.com>,
	Kees Cook <kees@kernel.org>,
	linux-block@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	nbd@other.debian.org,
	dm-devel@lists.linux.dev,
	linux-mmc@vger.kernel.org,
	linux-mtd@lists.infradead.org,
	asahi@lists.linux.dev,
	linux-arm-kernel@lists.infradead.org,
	linux-nvme@lists.infradead.org,
	linux-scsi@vger.kernel.org
Subject: [PATCH v1] block: switch numa_node to int in blk_mq_hw_ctx and init_request
Date: Sat, 23 May 2026 12:52:35 +0000
Message-ID: <20260523125210.272274-1-mateusz.nowicki@posteo.net>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

numa_node in blk_mq_hw_ctx and the matching argument of
blk_mq_ops::init_request can be NUMA_NO_NODE (-1).  Declared as
unsigned int, NUMA_NO_NODE becomes UINT_MAX and walks off
nvme_dev::descriptor_pools[] on CONFIG_NUMA=n [1].

Switch the field and the callback prototype to int and update all
in-tree init_request implementations.  No functional change:
cpu_to_node(), kmalloc_node() and blk_alloc_flush_queue() already
take int.

Link: https://lore.kernel.org/linux-nvme/20260522150628.399288-1-mateusz.nowicki@posteo.net/ [1]
Link: https://lore.kernel.org/linux-nvme/20260309062840.2937858-2-iam@sung-woo.kim/
Suggested-by: Caleb Sander Mateos <csander@purestorage.com>
Suggested-by: Sung-woo Kim <iam@sung-woo.kim>
Signed-off-by: Mateusz Nowicki <mateusz.nowicki@posteo.net>
---
 block/bsg-lib.c                   | 2 +-
 drivers/block/mtip32xx/mtip32xx.c | 2 +-
 drivers/block/nbd.c               | 2 +-
 drivers/md/dm-rq.c                | 2 +-
 drivers/mmc/core/queue.c          | 2 +-
 drivers/mtd/ubi/block.c           | 2 +-
 drivers/nvme/host/apple.c         | 2 +-
 drivers/nvme/host/fc.c            | 2 +-
 drivers/nvme/host/pci.c           | 2 +-
 drivers/nvme/host/rdma.c          | 2 +-
 drivers/nvme/host/tcp.c           | 2 +-
 drivers/nvme/target/loop.c        | 2 +-
 drivers/scsi/scsi_lib.c           | 2 +-
 include/linux/blk-mq.h            | 4 ++--
 14 files changed, 15 insertions(+), 15 deletions(-)

diff --git a/block/bsg-lib.c b/block/bsg-lib.c
index fdb4b290ca68..895db30a7033 100644
--- a/block/bsg-lib.c
+++ b/block/bsg-lib.c
@@ -299,7 +299,7 @@ static blk_status_t bsg_queue_rq(struct blk_mq_hw_ctx *hctx,
 
 /* called right after the request is allocated for the request_queue */
 static int bsg_init_rq(struct blk_mq_tag_set *set, struct request *req,
-		       unsigned int hctx_idx, unsigned int numa_node)
+		       unsigned int hctx_idx, int numa_node)
 {
 	struct bsg_job *job = blk_mq_rq_to_pdu(req);
 
diff --git a/drivers/block/mtip32xx/mtip32xx.c b/drivers/block/mtip32xx/mtip32xx.c
index 567192e371a8..8aedba9b5690 100644
--- a/drivers/block/mtip32xx/mtip32xx.c
+++ b/drivers/block/mtip32xx/mtip32xx.c
@@ -3340,7 +3340,7 @@ static void mtip_free_cmd(struct blk_mq_tag_set *set, struct request *rq,
 }
 
 static int mtip_init_cmd(struct blk_mq_tag_set *set, struct request *rq,
-			 unsigned int hctx_idx, unsigned int numa_node)
+			 unsigned int hctx_idx, int numa_node)
 {
 	struct driver_data *dd = set->driver_data;
 	struct mtip_cmd *cmd = blk_mq_rq_to_pdu(rq);
diff --git a/drivers/block/nbd.c b/drivers/block/nbd.c
index fe63f3c55d0d..e2fe9e3308fc 100644
--- a/drivers/block/nbd.c
+++ b/drivers/block/nbd.c
@@ -1888,7 +1888,7 @@ static void nbd_dbg_close(void)
 #endif
 
 static int nbd_init_request(struct blk_mq_tag_set *set, struct request *rq,
-			    unsigned int hctx_idx, unsigned int numa_node)
+			    unsigned int hctx_idx, int numa_node)
 {
 	struct nbd_cmd *cmd = blk_mq_rq_to_pdu(rq);
 	cmd->nbd = set->driver_data;
diff --git a/drivers/md/dm-rq.c b/drivers/md/dm-rq.c
index 9703b3ae364e..9a386254d836 100644
--- a/drivers/md/dm-rq.c
+++ b/drivers/md/dm-rq.c
@@ -462,7 +462,7 @@ static void dm_start_request(struct mapped_device *md, struct request *orig)
 }
 
 static int dm_mq_init_request(struct blk_mq_tag_set *set, struct request *rq,
-			      unsigned int hctx_idx, unsigned int numa_node)
+			      unsigned int hctx_idx, int numa_node)
 {
 	struct mapped_device *md = set->driver_data;
 	struct dm_rq_target_io *tio = blk_mq_rq_to_pdu(rq);
diff --git a/drivers/mmc/core/queue.c b/drivers/mmc/core/queue.c
index 39fcb662c43f..cfa268925c26 100644
--- a/drivers/mmc/core/queue.c
+++ b/drivers/mmc/core/queue.c
@@ -208,7 +208,7 @@ static unsigned short mmc_get_max_segments(struct mmc_host *host)
 }
 
 static int mmc_mq_init_request(struct blk_mq_tag_set *set, struct request *req,
-			       unsigned int hctx_idx, unsigned int numa_node)
+			       unsigned int hctx_idx, int numa_node)
 {
 	struct mmc_queue_req *mq_rq = req_to_mmc_queue_req(req);
 	struct mmc_queue *mq = set->driver_data;
diff --git a/drivers/mtd/ubi/block.c b/drivers/mtd/ubi/block.c
index 8880a783c3bc..29c0d6941a81 100644
--- a/drivers/mtd/ubi/block.c
+++ b/drivers/mtd/ubi/block.c
@@ -312,7 +312,7 @@ static blk_status_t ubiblock_queue_rq(struct blk_mq_hw_ctx *hctx,
 
 static int ubiblock_init_request(struct blk_mq_tag_set *set,
 		struct request *req, unsigned int hctx_idx,
-		unsigned int numa_node)
+		int numa_node)
 {
 	struct ubiblock_pdu *pdu = blk_mq_rq_to_pdu(req);
 
diff --git a/drivers/nvme/host/apple.c b/drivers/nvme/host/apple.c
index c692fc73babf..97586307ac1a 100644
--- a/drivers/nvme/host/apple.c
+++ b/drivers/nvme/host/apple.c
@@ -819,7 +819,7 @@ static int apple_nvme_init_hctx(struct blk_mq_hw_ctx *hctx, void *data,
 
 static int apple_nvme_init_request(struct blk_mq_tag_set *set,
 				   struct request *req, unsigned int hctx_idx,
-				   unsigned int numa_node)
+				   int numa_node)
 {
 	struct apple_nvme_queue *q = set->driver_data;
 	struct apple_nvme *anv = queue_to_apple_nvme(q);
diff --git a/drivers/nvme/host/fc.c b/drivers/nvme/host/fc.c
index e4f4528fe2a2..1907da499ad2 100644
--- a/drivers/nvme/host/fc.c
+++ b/drivers/nvme/host/fc.c
@@ -2109,7 +2109,7 @@ __nvme_fc_init_request(struct nvme_fc_ctrl *ctrl,
 
 static int
 nvme_fc_init_request(struct blk_mq_tag_set *set, struct request *rq,
-		unsigned int hctx_idx, unsigned int numa_node)
+		unsigned int hctx_idx, int numa_node)
 {
 	struct nvme_fc_ctrl *ctrl = to_fc_ctrl(set->driver_data);
 	struct nvme_fcp_op_w_sgl *op = blk_mq_rq_to_pdu(rq);
diff --git a/drivers/nvme/host/pci.c b/drivers/nvme/host/pci.c
index 139a10cd687f..afd407df640f 100644
--- a/drivers/nvme/host/pci.c
+++ b/drivers/nvme/host/pci.c
@@ -660,7 +660,7 @@ static int nvme_init_hctx(struct blk_mq_hw_ctx *hctx, void *data,
 
 static int nvme_pci_init_request(struct blk_mq_tag_set *set,
 		struct request *req, unsigned int hctx_idx,
-		unsigned int numa_node)
+		int numa_node)
 {
 	struct nvme_iod *iod = blk_mq_rq_to_pdu(req);
 
diff --git a/drivers/nvme/host/rdma.c b/drivers/nvme/host/rdma.c
index f77c960f7632..08459c65c3d5 100644
--- a/drivers/nvme/host/rdma.c
+++ b/drivers/nvme/host/rdma.c
@@ -292,7 +292,7 @@ static void nvme_rdma_exit_request(struct blk_mq_tag_set *set,
 
 static int nvme_rdma_init_request(struct blk_mq_tag_set *set,
 		struct request *rq, unsigned int hctx_idx,
-		unsigned int numa_node)
+		int numa_node)
 {
 	struct nvme_rdma_ctrl *ctrl = to_rdma_ctrl(set->driver_data);
 	struct nvme_rdma_request *req = blk_mq_rq_to_pdu(rq);
diff --git a/drivers/nvme/host/tcp.c b/drivers/nvme/host/tcp.c
index 15d36d6a728e..36b3ec50a9fd 100644
--- a/drivers/nvme/host/tcp.c
+++ b/drivers/nvme/host/tcp.c
@@ -548,7 +548,7 @@ static void nvme_tcp_exit_request(struct blk_mq_tag_set *set,
 
 static int nvme_tcp_init_request(struct blk_mq_tag_set *set,
 		struct request *rq, unsigned int hctx_idx,
-		unsigned int numa_node)
+		int numa_node)
 {
 	struct nvme_tcp_ctrl *ctrl = to_tcp_ctrl(set->driver_data);
 	struct nvme_tcp_request *req = blk_mq_rq_to_pdu(rq);
diff --git a/drivers/nvme/target/loop.c b/drivers/nvme/target/loop.c
index d98d0cdc5d6f..ae00bcef2251 100644
--- a/drivers/nvme/target/loop.c
+++ b/drivers/nvme/target/loop.c
@@ -202,7 +202,7 @@ static int nvme_loop_init_iod(struct nvme_loop_ctrl *ctrl,
 
 static int nvme_loop_init_request(struct blk_mq_tag_set *set,
 		struct request *req, unsigned int hctx_idx,
-		unsigned int numa_node)
+		int numa_node)
 {
 	struct nvme_loop_ctrl *ctrl = to_loop_ctrl(set->driver_data);
 	struct nvme_loop_iod *iod = blk_mq_rq_to_pdu(req);
diff --git a/drivers/scsi/scsi_lib.c b/drivers/scsi/scsi_lib.c
index 6e8c7a42603e..67f789bd02e7 100644
--- a/drivers/scsi/scsi_lib.c
+++ b/drivers/scsi/scsi_lib.c
@@ -1950,7 +1950,7 @@ static blk_status_t scsi_queue_rq(struct blk_mq_hw_ctx *hctx,
 }
 
 static int scsi_mq_init_request(struct blk_mq_tag_set *set, struct request *rq,
-				unsigned int hctx_idx, unsigned int numa_node)
+				unsigned int hctx_idx, int numa_node)
 {
 	struct Scsi_Host *shost = set->driver_data;
 	struct scsi_cmnd *cmd = blk_mq_rq_to_pdu(rq);
diff --git a/include/linux/blk-mq.h b/include/linux/blk-mq.h
index 18a2388ba581..2e7f90048171 100644
--- a/include/linux/blk-mq.h
+++ b/include/linux/blk-mq.h
@@ -428,7 +428,7 @@ struct blk_mq_hw_ctx {
 	struct blk_mq_tags	*sched_tags;
 
 	/** @numa_node: NUMA node the storage adapter has been connected to. */
-	unsigned int		numa_node;
+	int			numa_node;
 	/** @queue_num: Index of this hardware queue. */
 	unsigned int		queue_num;
 
@@ -653,7 +653,7 @@ struct blk_mq_ops {
 	 * flush request.
 	 */
 	int (*init_request)(struct blk_mq_tag_set *set, struct request *,
-			    unsigned int, unsigned int);
+			    unsigned int, int);
 	/**
 	 * @exit_request: Ditto for exit/teardown.
 	 */

base-commit: 45255ea1ca096b11b1303c9b54502a28f3a31dd1
-- 
2.53.0

