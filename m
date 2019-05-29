From: John Garry <john.garry@huawei.com>
Subject: [PATCH 3/6] scsi: hisi_sas: Reduce HISI_SAS_SGE_PAGE_CNT in size
Date: Wed, 29 May 2019 17:58:44 +0800
Message-ID: <1559123927-160502-4-git-send-email-john.garry@huawei.com>
References: <1559123927-160502-1-git-send-email-john.garry@huawei.com>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <1559123927-160502-1-git-send-email-john.garry@huawei.com>
Sender: linux-kernel-owner@vger.kernel.org
To: jejb@linux.vnet.ibm.com, martin.petersen@oracle.com
Cc: linuxarm@huawei.com, linux-kernel@vger.kernel.org, linux-scsi@vger.kernel.org, John Garry <john.garry@huawei.com>, dann frazier <dann.frazier@canonical.com>
List-Id: linux-scsi@vger.kernel.org

Macro HISI_SAS_SGE_PAGE_CNT is defined to SG_CHUNK_SIZE, which is
128.

This means that sizeof(struct hisi_sas_slot_buf_table) is 4192. This is
just over a 4K, which can mean inefficient DMA memory usage (for no PI).

Reduce the size of HISI_SAS_SGE_PAGE_CNT to 124 to fit in a 4K page. With
this change, we experience no performance hit.

Cc: dann frazier <dann.frazier@canonical.com>
Signed-off-by: John Garry <john.garry@huawei.com>
---
 drivers/scsi/hisi_sas/hisi_sas.h | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/scsi/hisi_sas/hisi_sas.h b/drivers/scsi/hisi_sas/hisi_sas.h
index fc87994b5d73..06f22fb372b1 100644
--- a/drivers/scsi/hisi_sas/hisi_sas.h
+++ b/drivers/scsi/hisi_sas/hisi_sas.h
@@ -484,12 +484,12 @@ struct hisi_sas_command_table_stp {
 	u8	atapi_cdb[ATAPI_CDB_LEN];
 };
 
-#define HISI_SAS_SGE_PAGE_CNT SG_CHUNK_SIZE
+#define HISI_SAS_SGE_PAGE_CNT (124)
 struct hisi_sas_sge_page {
 	struct hisi_sas_sge sge[HISI_SAS_SGE_PAGE_CNT];
 }  __aligned(16);
 
-#define HISI_SAS_SGE_DIF_PAGE_CNT   SG_CHUNK_SIZE
+#define HISI_SAS_SGE_DIF_PAGE_CNT   HISI_SAS_SGE_PAGE_CNT
 struct hisi_sas_sge_dif_page {
 	struct hisi_sas_sge sge[HISI_SAS_SGE_DIF_PAGE_CNT];
 }  __aligned(16);
-- 
2.17.1
