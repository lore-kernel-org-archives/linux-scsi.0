From: Chuhong Yuan <hslester96@gmail.com>
Subject: [PATCH 3/3] scsi: qedf: Replace vmalloc + memset with vzalloc
Date: Thu, 18 Jul 2019 16:18:32 +0800
Message-ID: <20190718081832.28808-1-hslester96@gmail.com>
Return-path: <linux-kernel-owner@vger.kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
Cc: QLogic-Storage-Upstream@cavium.com, "James E . J . Bottomley" <jejb@linux.ibm.com>, "Martin K . Petersen" <martin.petersen@oracle.com>, linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org, Chuhong Yuan <hslester96@gmail.com>
List-Id: linux-scsi@vger.kernel.org

Use vzalloc instead of using vmalloc to allocate memory
and then zeroing it with memset 0.
This simplifies the code.

Signed-off-by: Chuhong Yuan <hslester96@gmail.com>
---
 drivers/scsi/qedf/qedf_dbg.c | 3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

diff --git a/drivers/scsi/qedf/qedf_dbg.c b/drivers/scsi/qedf/qedf_dbg.c
index e0387e495261..0d2aed82882a 100644
--- a/drivers/scsi/qedf/qedf_dbg.c
+++ b/drivers/scsi/qedf/qedf_dbg.c
@@ -106,11 +106,10 @@ qedf_dbg_info(struct qedf_dbg_ctx *qedf, const char *func, u32 line,
 int
 qedf_alloc_grc_dump_buf(u8 **buf, uint32_t len)
 {
-		*buf = vmalloc(len);
+		*buf = vzalloc(len);
 		if (!(*buf))
 			return -ENOMEM;
 
-		memset(*buf, 0, len);
 		return 0;
 }
 
-- 
2.20.1
