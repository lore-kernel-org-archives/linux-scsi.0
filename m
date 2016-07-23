From: james.smart@broadcom.com (James Smart)
Subject: [PATCH] nvme-fabrics: set sqe.command_id in core, not transports
Date: Fri, 22 Jul 2016 17:23:52 -0700
Message-ID: <5792b918.ManFlYqqCmUKB4ry%james.smart@broadcom.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-pf0-f172.google.com ([209.85.192.172]:34568 "EHLO
	mail-pf0-f172.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750713AbcGWAXz (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Fri, 22 Jul 2016 20:23:55 -0400
Received: by mail-pf0-f172.google.com with SMTP id p64so45836786pfb.1
        for <linux-scsi@vger.kernel.org>; Fri, 22 Jul 2016 17:23:54 -0700 (PDT)
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-nvme@lists.infradead.org, linux-scsi@vger.kernel.org


set sqe.command_id in core, not transports

Patch is cut against the linux-nvme for-4.8/drivers branch

Signed-off-by: James Smart <james.smart@broadcom.com>
---
 drivers/nvme/host/core.c | 3 ++-
 drivers/nvme/host/rdma.c | 1 -
 2 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/nvme/host/core.c b/drivers/nvme/host/core.c
index 74b1d38..b391f54 100644
--- a/drivers/nvme/host/core.c
+++ b/drivers/nvme/host/core.c
@@ -290,7 +290,6 @@ static inline void nvme_setup_rw(struct nvme_ns *ns, struct request *req,
 
 	memset(cmnd, 0, sizeof(*cmnd));
 	cmnd->rw.opcode = (rq_data_dir(req) ? nvme_cmd_write : nvme_cmd_read);
-	cmnd->rw.command_id = req->tag;
 	cmnd->rw.nsid = cpu_to_le32(ns->ns_id);
 	cmnd->rw.slba = cpu_to_le64(nvme_block_nr(ns, blk_rq_pos(req)));
 	cmnd->rw.length = cpu_to_le16((blk_rq_bytes(req) >> ns->lba_shift) - 1);
@@ -330,6 +329,8 @@ int nvme_setup_cmd(struct nvme_ns *ns, struct request *req,
 	else
 		nvme_setup_rw(ns, req, cmd);
 
+	cmd->common.command_id = req->tag;
+
 	return ret;
 }
 EXPORT_SYMBOL_GPL(nvme_setup_cmd);
diff --git a/drivers/nvme/host/rdma.c b/drivers/nvme/host/rdma.c
index 3e3ce2b..0cd7c3e 100644
--- a/drivers/nvme/host/rdma.c
+++ b/drivers/nvme/host/rdma.c
@@ -1447,7 +1447,6 @@ static int nvme_rdma_queue_rq(struct blk_mq_hw_ctx *hctx,
 	if (ret)
 		return ret;
 
-	c->common.command_id = rq->tag;
 	blk_mq_start_request(rq);
 
 	map_len = nvme_map_len(rq);
-- 
2.5.0

