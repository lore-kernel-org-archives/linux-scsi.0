From: YueHaibing <yuehaibing@huawei.com>
Subject: [PATCH v2 -next] scsi: qla2xxx: Remove unnecessary null check
Date: Thu, 11 Jul 2019 22:13:17 +0800
Message-ID: <20190711141317.52192-1-yuehaibing@huawei.com>
References: <20190711140908.26896-1-yuehaibing@huawei.com>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20190711140908.26896-1-yuehaibing@huawei.com>
Sender: linux-kernel-owner@vger.kernel.org
To: qla2xxx-upstream@qlogic.com, jejb@linux.ibm.com, martin.petersen@oracle.com
Cc: linux-kernel@vger.kernel.org, linux-scsi@vger.kernel.org, YueHaibing <yuehaibing@huawei.com>
List-Id: linux-scsi@vger.kernel.org

A null check before dma_pool_destroy is redundant,
so remove it. This is detected by coccinelle.

Signed-off-by: YueHaibing <yuehaibing@huawei.com>
---
v2: fix commit log
---
 drivers/scsi/qla2xxx/qla_os.c | 3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

diff --git a/drivers/scsi/qla2xxx/qla_os.c b/drivers/scsi/qla2xxx/qla_os.c
index 2e58cff..3c59157 100644
--- a/drivers/scsi/qla2xxx/qla_os.c
+++ b/drivers/scsi/qla2xxx/qla_os.c
@@ -4731,8 +4731,7 @@ qla2x00_mem_free(struct qla_hw_data *ha)
 		}
 	}
 
-	if (ha->dif_bundl_pool)
-		dma_pool_destroy(ha->dif_bundl_pool);
+	dma_pool_destroy(ha->dif_bundl_pool);
 	ha->dif_bundl_pool = NULL;
 
 	qlt_mem_free(ha);
-- 
2.7.4
