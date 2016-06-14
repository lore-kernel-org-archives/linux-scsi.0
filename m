From: "Nicholas A. Bellinger" <nab@linux-iscsi.org>
Subject: [RFC-v2 04/11] nvmet: Hookup nvmet_ns->dev to nvmet_ns_enable
Date: Tue, 14 Jun 2016 04:35:39 +0000
Message-ID: <1465878946-26556-5-git-send-email-nab@linux-iscsi.org>
References: <1465878946-26556-1-git-send-email-nab@linux-iscsi.org>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail.linux-iscsi.org ([67.23.28.174]:38505 "EHLO
	linux-iscsi.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933265AbcFNEgy (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Tue, 14 Jun 2016 00:36:54 -0400
In-Reply-To: <1465878946-26556-1-git-send-email-nab@linux-iscsi.org>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: target-devel <target-devel@vger.kernel.org>
Cc: linux-scsi <linux-scsi@vger.kernel.org>, linux-nvme <linux-nvme@lists.infradead.org>, Jens Axboe <axboe@fb.com>, Christoph Hellwig <hch@lst.de>, Keith Busch <keith.busch@intel.com>, Jay Freyensee <james.p.freyensee@intel.com>, Martin Petersen <martin.petersen@oracle.com>, Sagi Grimberg <sagi@grimberg.me>, Hannes Reinecke <hare@suse.de>, Mike Christie <michaelc@cs.wisc.edu>, Dave B Minturn <dave.b.minturn@intel.com>, Nicholas Bellinger <nab@linux-iscsi.org>

From: Nicholas Bellinger <nab@linux-iscsi.org>

This patch hooks up nvmet_ns_enable() to accept the RCU protected
struct se_device provided as a configfs symlink from existing
/sys/kernel/config/target/core/ driver backends.

Also, drop the now unused internal ns->bdev + ns->device_path
usage, and add WIP stubs for nvmet/io-cmd sbc_ops backend
conversion to be added in subsequent patches.

Cc: Jens Axboe <axboe@fb.com>
Cc: Christoph Hellwig <hch@lst.de>
Cc: Martin Petersen <martin.petersen@oracle.com>
Cc: Sagi Grimberg <sagi@grimberg.me>
Cc: Hannes Reinecke <hare@suse.de>
Cc: Mike Christie <michaelc@cs.wisc.edu>
Signed-off-by: Nicholas Bellinger <nab@linux-iscsi.org>
---
 drivers/nvme/target/configfs-ng.c |  3 +--
 drivers/nvme/target/core.c        | 30 ++++++++----------------------
 drivers/nvme/target/io-cmd.c      | 17 +++++++++++++++--
 drivers/nvme/target/nvmet.h       |  6 ++----
 4 files changed, 26 insertions(+), 30 deletions(-)

diff --git a/drivers/nvme/target/configfs-ng.c b/drivers/nvme/target/configfs-ng.c
index 28dc24b..1cd1e8e 100644
--- a/drivers/nvme/target/configfs-ng.c
+++ b/drivers/nvme/target/configfs-ng.c
@@ -470,8 +470,7 @@ static int nvmet_ns_link(struct config_item *ns_ci, struct config_item *dev_ci)
 		return -ENOSYS;
 	}
 
-	// XXX: Pass in struct se_device into nvmet_ns_enable
-	return nvmet_ns_enable(ns);
+	return nvmet_ns_enable(ns, dev);
 }
 
 static int nvmet_ns_unlink(struct config_item *ns_ci, struct config_item *dev_ci)
diff --git a/drivers/nvme/target/core.c b/drivers/nvme/target/core.c
index 3357696..e2176e0 100644
--- a/drivers/nvme/target/core.c
+++ b/drivers/nvme/target/core.c
@@ -13,6 +13,8 @@
  */
 #define pr_fmt(fmt) KBUILD_MODNAME ": " fmt
 #include <linux/module.h>
+#include <target/target_core_base.h>
+#include <target/target_core_backend.h>
 #include "nvmet.h"
 
 static struct nvmet_fabrics_ops *nvmet_transports[NVMF_TRTYPE_MAX];
@@ -292,7 +294,7 @@ void nvmet_put_namespace(struct nvmet_ns *ns)
 	percpu_ref_put(&ns->ref);
 }
 
-int nvmet_ns_enable(struct nvmet_ns *ns)
+int nvmet_ns_enable(struct nvmet_ns *ns, struct se_device *dev)
 {
 	struct nvmet_subsys *subsys = ns->subsys;
 	struct nvmet_ctrl *ctrl;
@@ -302,23 +304,14 @@ int nvmet_ns_enable(struct nvmet_ns *ns)
 	if (!list_empty(&ns->dev_link))
 		goto out_unlock;
 
-	ns->bdev = blkdev_get_by_path(ns->device_path, FMODE_READ | FMODE_WRITE,
-			NULL);
-	if (IS_ERR(ns->bdev)) {
-		pr_err("nvmet: failed to open block device %s: (%ld)\n",
-			ns->device_path, PTR_ERR(ns->bdev));
-		ret = PTR_ERR(ns->bdev);
-		ns->bdev = NULL;
-		goto out_unlock;
-	}
-
-	ns->size = i_size_read(ns->bdev->bd_inode);
-	ns->blksize_shift = blksize_bits(bdev_logical_block_size(ns->bdev));
+	rcu_assign_pointer(ns->dev, dev);
+	ns->size = dev->transport->get_blocks(dev) * dev->dev_attrib.hw_block_size;
+	ns->blksize_shift = blksize_bits(dev->dev_attrib.hw_block_size);
 
 	ret = percpu_ref_init(&ns->ref, nvmet_destroy_namespace,
 				0, GFP_KERNEL);
 	if (ret)
-		goto out_blkdev_put;
+		goto out_unlock;
 
 	if (ns->nsid > subsys->max_nsid)
 		subsys->max_nsid = ns->nsid;
@@ -348,10 +341,6 @@ int nvmet_ns_enable(struct nvmet_ns *ns)
 out_unlock:
 	mutex_unlock(&subsys->lock);
 	return ret;
-out_blkdev_put:
-	blkdev_put(ns->bdev, FMODE_WRITE|FMODE_READ);
-	ns->bdev = NULL;
-	goto out_unlock;
 }
 
 void nvmet_ns_disable(struct nvmet_ns *ns)
@@ -384,16 +373,13 @@ void nvmet_ns_disable(struct nvmet_ns *ns)
 	list_for_each_entry(ctrl, &subsys->ctrls, subsys_entry)
 		nvmet_add_async_event(ctrl, NVME_AER_TYPE_NOTICE, 0, 0);
 
-	if (ns->bdev)
-		blkdev_put(ns->bdev, FMODE_WRITE|FMODE_READ);
+	rcu_assign_pointer(ns->dev, NULL);
 	mutex_unlock(&subsys->lock);
 }
 
 void nvmet_ns_free(struct nvmet_ns *ns)
 {
 	nvmet_ns_disable(ns);
-
-	kfree(ns->device_path);
 	kfree(ns);
 }
 
diff --git a/drivers/nvme/target/io-cmd.c b/drivers/nvme/target/io-cmd.c
index 76dbf73..38c2e97 100644
--- a/drivers/nvme/target/io-cmd.c
+++ b/drivers/nvme/target/io-cmd.c
@@ -16,6 +16,7 @@
 #include <linux/module.h>
 #include "nvmet.h"
 
+#if 0
 static void nvmet_bio_done(struct bio *bio)
 {
 	struct nvmet_req *req = bio->bi_private;
@@ -26,6 +27,7 @@ static void nvmet_bio_done(struct bio *bio)
 	if (bio != &req->inline_bio)
 		bio_put(bio);
 }
+#endif
 
 static inline u32 nvmet_rw_len(struct nvmet_req *req)
 {
@@ -33,6 +35,7 @@ static inline u32 nvmet_rw_len(struct nvmet_req *req)
 			req->ns->blksize_shift;
 }
 
+#if 0
 static void nvmet_inline_bio_init(struct nvmet_req *req)
 {
 	struct bio *bio = &req->inline_bio;
@@ -41,21 +44,23 @@ static void nvmet_inline_bio_init(struct nvmet_req *req)
 	bio->bi_max_vecs = NVMET_MAX_INLINE_BIOVEC;
 	bio->bi_io_vec = req->inline_bvec;
 }
+#endif
 
 static void nvmet_execute_rw(struct nvmet_req *req)
 {
+#if 0
 	int sg_cnt = req->sg_cnt;
 	struct scatterlist *sg;
 	struct bio *bio;
 	sector_t sector;
 	blk_qc_t cookie;
 	int rw, i;
-
+#endif
 	if (!req->sg_cnt) {
 		nvmet_req_complete(req, 0);
 		return;
 	}
-
+#if 0
 	if (req->cmd->rw.opcode == nvme_cmd_write) {
 		if (req->cmd->rw.control & cpu_to_le16(NVME_RW_FUA))
 			rw = WRITE_FUA;
@@ -95,10 +100,12 @@ static void nvmet_execute_rw(struct nvmet_req *req)
 	cookie = submit_bio(rw, bio);
 
 	blk_poll(bdev_get_queue(req->ns->bdev), cookie);
+#endif
 }
 
 static void nvmet_execute_flush(struct nvmet_req *req)
 {
+#if 0
 	struct bio *bio;
 
 	nvmet_inline_bio_init(req);
@@ -109,8 +116,10 @@ static void nvmet_execute_flush(struct nvmet_req *req)
 	bio->bi_end_io = nvmet_bio_done;
 
 	submit_bio(WRITE_FLUSH, bio);
+#endif
 }
 
+#if 0
 static u16 nvmet_discard_range(struct nvmet_ns *ns,
 		struct nvme_dsm_range *range, int type, struct bio **bio)
 {
@@ -119,11 +128,14 @@ static u16 nvmet_discard_range(struct nvmet_ns *ns,
 			le32_to_cpu(range->nlb) << (ns->blksize_shift - 9),
 			GFP_KERNEL, type, bio))
 		return NVME_SC_INTERNAL | NVME_SC_DNR;
+
 	return 0;
 }
+#endif
 
 static void nvmet_execute_discard(struct nvmet_req *req)
 {
+#if 0
 	struct nvme_dsm_range range;
 	struct bio *bio = NULL;
 	int type = REQ_WRITE | REQ_DISCARD, i;
@@ -152,6 +164,7 @@ static void nvmet_execute_discard(struct nvmet_req *req)
 	} else {
 		nvmet_req_complete(req, status);
 	}
+#endif
 }
 
 static void nvmet_execute_dsm(struct nvmet_req *req)
diff --git a/drivers/nvme/target/nvmet.h b/drivers/nvme/target/nvmet.h
index 265f56f..af616d0 100644
--- a/drivers/nvme/target/nvmet.h
+++ b/drivers/nvme/target/nvmet.h
@@ -41,15 +41,13 @@
 struct nvmet_ns {
 	struct list_head	dev_link;
 	struct percpu_ref	ref;
-	struct block_device	*bdev;
+	struct se_device __rcu	*dev;
 	u32			nsid;
 	u32			blksize_shift;
 	loff_t			size;
 	u8			nguid[16];
 
 	struct nvmet_subsys	*subsys;
-	const char		*device_path;
-
 	struct config_group	device_group;
 	struct config_group	group;
 
@@ -330,7 +328,7 @@ void nvmet_subsys_put(struct nvmet_subsys *subsys);
 
 struct nvmet_ns *nvmet_find_namespace(struct nvmet_ctrl *ctrl, __le32 nsid);
 void nvmet_put_namespace(struct nvmet_ns *ns);
-int nvmet_ns_enable(struct nvmet_ns *ns);
+int nvmet_ns_enable(struct nvmet_ns *ns, struct se_device *dev);
 void nvmet_ns_disable(struct nvmet_ns *ns);
 struct nvmet_ns *nvmet_ns_alloc(struct nvmet_subsys *subsys, u32 nsid);
 void nvmet_ns_free(struct nvmet_ns *ns);
-- 
1.9.1

