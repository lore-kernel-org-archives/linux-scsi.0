From: Sasha Levin <sashal@kernel.org>
Subject: [PATCH AUTOSEL 4.19 08/36] scsi: hisi_sas: Remove set but not used variable 'dq_list'
Date: Thu, 22 Nov 2018 14:52:12 -0500
Message-ID: <20181122195240.13123-8-sashal@kernel.org>
References: <20181122195240.13123-1-sashal@kernel.org>
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20181122195240.13123-1-sashal@kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
To: stable@vger.kernel.org, linux-kernel@vger.kernel.org
Cc: YueHaibing <yuehaibing@huawei.com>, "Martin K . Petersen" <martin.petersen@oracle.com>, Sasha Levin <sashal@kernel.org>, linux-scsi@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org

From: YueHaibing <yuehaibing@huawei.com>

[ Upstream commit e34ff8edcae89922d187425ab0b82e6a039aa371 ]

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
Acked-by: John Garry <john.garry@huawei.com>
Signed-off-by: Martin K. Petersen <martin.petersen@oracle.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/scsi/hisi_sas/hisi_sas_v1_hw.c | 2 --
 drivers/scsi/hisi_sas/hisi_sas_v2_hw.c | 2 --
 drivers/scsi/hisi_sas/hisi_sas_v3_hw.c | 2 --
 3 files changed, 6 deletions(-)

diff --git a/drivers/scsi/hisi_sas/hisi_sas_v1_hw.c b/drivers/scsi/hisi_sas/hisi_sas_v1_hw.c
index 8f60f0e04599..410eccf0bc5e 100644
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
index 9c5c5a601332..1c4ea58da1ae 100644
--- a/drivers/scsi/hisi_sas/hisi_sas_v2_hw.c
+++ b/drivers/scsi/hisi_sas/hisi_sas_v2_hw.c
@@ -1666,11 +1666,9 @@ static void start_delivery_v2_hw(struct hisi_sas_dq *dq)
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
index 08b503e274b8..687ff61bba9f 100644
--- a/drivers/scsi/hisi_sas/hisi_sas_v3_hw.c
+++ b/drivers/scsi/hisi_sas/hisi_sas_v3_hw.c
@@ -883,11 +883,9 @@ static void start_delivery_v3_hw(struct hisi_sas_dq *dq)
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
2.17.1
