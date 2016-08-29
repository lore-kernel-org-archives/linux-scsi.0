From: Baoyou Xie <baoyou.xie@linaro.org>
Subject: [PATCH] [SCSI] qla4xxx: mark symbols static where possible
Date: Mon, 29 Aug 2016 18:46:51 +0800
Message-ID: <1472467611-8574-1-git-send-email-baoyou.xie@linaro.org>
Return-path: <linux-kernel-owner@vger.kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
To: QLogic-Storage-Upstream@qlogic.com, jejb@linux.vnet.ibm.com
Cc: linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org, arnd@linaro.org, baoyou.xie@linaro.org, xie.baoyou@zte.com.cn
List-Id: linux-scsi@vger.kernel.org

We get 1 warning when build kernel with W=1:
drivers/scsi/qla4xxx/ql4_nx.c:1846:10: warning: no previous prototype for 'ql4_84xx_ipmdio_rd_reg' [-Wmissing-prototypes]

In fact, this function is only used in the file in which it is
declared and don't need a declaration, but can be made static.
so this patch marks this function with 'static'.

Signed-off-by: Baoyou Xie <baoyou.xie@linaro.org>
---
 drivers/scsi/qla4xxx/ql4_nx.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/scsi/qla4xxx/ql4_nx.c b/drivers/scsi/qla4xxx/ql4_nx.c
index ae87d6c..06ddd13 100644
--- a/drivers/scsi/qla4xxx/ql4_nx.c
+++ b/drivers/scsi/qla4xxx/ql4_nx.c
@@ -1843,7 +1843,7 @@ static uint32_t ql4_84xx_poll_wait_for_ready(struct scsi_qla_host *ha,
 	return rval;
 }
 
-uint32_t ql4_84xx_ipmdio_rd_reg(struct scsi_qla_host *ha, uint32_t addr1,
+static uint32_t ql4_84xx_ipmdio_rd_reg(struct scsi_qla_host *ha, uint32_t addr1,
 				uint32_t addr3, uint32_t mask, uint32_t addr,
 				uint32_t *data_ptr)
 {
-- 
2.7.4
