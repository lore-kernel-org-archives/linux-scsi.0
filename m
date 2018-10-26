From: YueHaibing <yuehaibing@huawei.com>
Subject: [PATCH -next] scsi: hisi_sas: Remove set but not used variable 'dq_list'
Date: Fri, 26 Oct 2018 15:07:31 +0800
Message-ID: <20181026070731.20024-1-yuehaibing@huawei.com>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <linux-kernel-owner@vger.kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
To: john.garry@huawei.com, jejb@linux.vnet.ibm.com, martin.petersen@oracle.com
Cc: linux-kernel@vger.kernel.org, linux-scsi@vger.kernel.org, YueHaibing <yuehaibing@huawei.com>
List-Id: linux-scsi@vger.kernel.org

Fixes gcc '-Wunused-but-set-variable' warning:

drivers/scsi/hisi_sas/hisi_sas_v1_hw.c: In function 'start_delivery_v1_hw':
drivers/scsi/hisi_sas/hisi_sas_v1_hw.c:907:20: warning:
 variable 'dq_list' set but not used [-Wunused-but-set-variable]

drivers/scsi/hisi_sas/hisi_sas_v2_hw.c: In function 'start_delivery_v2_hw':
drivers/scsi/hisi_sas/hisi_sas_v2_hw.c:1671:20: warning:
 variable 'dq_list' set but not used [-Wunused-but-set-variable]

drivers/scsi/hisi_sas/hisi_sas_v3_hw.c: In function 'start_delivery_v3_hw':
drivers/scsi/hisi_sas/hisi_sas_v3_hw.c:889:20: warning:
 variable 'dq_list' set but not used [-Wunused-but-set-variable]

It never used since introduction in commit
fa222db0b036 ("scsi: hisi_sas: Don't lock DQ for complete task sending")

Signed-off-by: YueHaibing <yuehaibing@huawei.com>
---
 drivers/scsi/hisi_sas/hisi_sas_v1_hw.c | 2 --
 drivers/scsi/hisi_sas/hisi_sas_v2_hw.c | 2 --
 drivers/scsi/hisi_sas/hisi_sas_v3_hw.c | 2 --
 3 files changed, 6 deletions(-)

diff --git a/drivers/scsi/hisi_sas/hisi_sas_v1_hw.c b/drivers/scsi/hisi_sas/hisi_sas_v1_hw.c
index f0e457e..8df822a 100644
--- a/drivers/scsi/hisi_sas/hisi_sas_v1_hw.c
+++ b/drivers/scsi/hisi_sas/hisi_sas_v1_hw.c
@@ -904,11 +904,9 @@ static void start_delivery_v1_hw(struct hisi_sas_dq *dq)
 {
 	struct hisi_hba *hisi_hba = dq->hisi_hba;
 	struct hisi_sas_slot *s, *s1, *s2 = NULL;
-	struct list_head *dq_list;
 	int dlvry_queue = dq->id;
 	int wp;
 
-	dq_list = &dq->list;
 	list_for_each_entry_safe(s, s1, &dq->list, delivery) {
 		if (!s->ready)
 			break;
diff --git a/drivers/scsi/hisi_sas/hisi_sas_v2_hw.c b/drivers/scsi/hisi_sas/hisi_sas_v2_hw.c
index cc36b64..77a85ea 100644
--- a/drivers/scsi/hisi_sas/hisi_sas_v2_hw.c
+++ b/drivers/scsi/hisi_sas/hisi_sas_v2_hw.c
@@ -1670,11 +1670,9 @@ static void start_delivery_v2_hw(struct hisi_sas_dq *dq)
 {
 	struct hisi_hba *hisi_hba = dq->hisi_hba;
 	struct hisi_sas_slot *s, *s1, *s2 = NULL;
-	struct list_head *dq_list;
 	int dlvry_queue = dq->id;
 	int wp;
 
-	dq_list = &dq->list;
 	list_for_each_entry_safe(s, s1, &dq->list, delivery) {
 		if (!s->ready)
 			break;
diff --git a/drivers/scsi/hisi_sas/hisi_sas_v3_hw.c b/drivers/scsi/hisi_sas/hisi_sas_v3_hw.c
index bd4ce38..a369450 100644
--- a/drivers/scsi/hisi_sas/hisi_sas_v3_hw.c
+++ b/drivers/scsi/hisi_sas/hisi_sas_v3_hw.c
@@ -886,11 +886,9 @@ static void start_delivery_v3_hw(struct hisi_sas_dq *dq)
 {
 	struct hisi_hba *hisi_hba = dq->hisi_hba;
 	struct hisi_sas_slot *s, *s1, *s2 = NULL;
-	struct list_head *dq_list;
 	int dlvry_queue = dq->id;
 	int wp;
 
-	dq_list = &dq->list;
 	list_for_each_entry_safe(s, s1, &dq->list, delivery) {
 		if (!s->ready)
 			break;
-- 
2.7.0
