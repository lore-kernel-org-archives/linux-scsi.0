From: Jon Derrick <jonathan.derrick@intel.com>
Subject: [PATCH] nvme/scsi: Consider LBA format in IO splitting calculation
Date: Mon, 24 Apr 2017 18:02:43 -0600
Message-ID: <20170425000243.2019-1-jonathan.derrick@intel.com>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mga01.intel.com ([192.55.52.88]:2178 "EHLO mga01.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S979420AbdDYAFy (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
        Mon, 24 Apr 2017 20:05:54 -0400
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: axboe@fb.com
Cc: linux-nvme@lists.infradead.org, linux-scsi@vger.kernel.org, linux-block@vger.kernel.org, keith.busch@intel.com, hch@infradead.org, sagi@grimberg.me, Jon Derrick <jonathan.derrick@intel.com>

The current command submission code uses a sector-based value when
considering the maximum number of blocks per command. With a
4k-formatted namespace and a command exceeding max hardware limits, this
calculation doesn't split IOs which should be split and fails in the
nvme layer. This patch fixes that calculation and enables IO splitting
in these circumstances.

Signed-off-by: Jon Derrick <jonathan.derrick@intel.com>
---
 drivers/nvme/host/scsi.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/nvme/host/scsi.c b/drivers/nvme/host/scsi.c
index f49ae27..988da61 100644
--- a/drivers/nvme/host/scsi.c
+++ b/drivers/nvme/host/scsi.c
@@ -1609,7 +1609,7 @@ static int nvme_trans_do_nvme_io(struct nvme_ns *ns, struct sg_io_hdr *hdr,
 	struct nvme_command c;
 	u8 opcode = (is_write ? nvme_cmd_write : nvme_cmd_read);
 	u16 control;
-	u32 max_blocks = queue_max_hw_sectors(ns->queue);
+	u32 max_blocks = queue_max_hw_sectors(ns->queue) >> (ns->lba_shift - 9);
 
 	num_cmds = nvme_trans_io_get_num_cmds(hdr, cdb_info, max_blocks);
 
-- 
2.9.3
