From: "Gustavo A. R. Silva" <gustavo@embeddedor.com>
Subject: [PATCH] scsi: hisi_sas: Fix NULL pointer dereference
Date: Thu, 18 Oct 2018 18:41:16 +0200
Message-ID: <20181018164116.GA24330@embeddedor.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
To: John Garry <john.garry@huawei.com>, "James E.J. Bottomley" <jejb@linux.vnet.ibm.com>, "Martin K. Petersen" <martin.petersen@oracle.com>, Xiang Chen <chenxiang66@hisilicon.com>
Cc: linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org, "Gustavo A. R. Silva" <gustavo@embeddedor.com>
List-Id: linux-scsi@vger.kernel.org

There is a NULL pointer dereference in case *slot* happens to
be NULL at line 1878:

struct hisi_sas_cq *cq =
	&hisi_hba->cq[slot->dlvry_queue];

Notice that *slot* is being NULL checked at line 1881: if (slot),
which implies it may be NULL.

Fix this by placing the declaration and definition of variable cq,
which contains the pointer dereference slot->dlvry_queue, after
*slot* has been properly NULL checked.

Addresses-Coverity-ID: 1474515 ("Dereference before null check")
Fixes: 584f53fe5f52 ("scsi: hisi_sas: Fix the race between IO completion and timeout for SMP/internal IO")
Signed-off-by: Gustavo A. R. Silva <gustavo@embeddedor.com>
---
 drivers/scsi/hisi_sas/hisi_sas_main.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/scsi/hisi_sas/hisi_sas_main.c b/drivers/scsi/hisi_sas/hisi_sas_main.c
index 2e5eaf1..e3f7c7b 100644
--- a/drivers/scsi/hisi_sas/hisi_sas_main.c
+++ b/drivers/scsi/hisi_sas/hisi_sas_main.c
@@ -1875,10 +1875,10 @@ hisi_sas_internal_task_abort(struct hisi_hba *hisi_hba,
 	if ((task->task_state_flags & SAS_TASK_STATE_ABORTED)) {
 		if (!(task->task_state_flags & SAS_TASK_STATE_DONE)) {
 			struct hisi_sas_slot *slot = task->lldd_task;
-			struct hisi_sas_cq *cq =
-				&hisi_hba->cq[slot->dlvry_queue];
 
 			if (slot) {
+				struct hisi_sas_cq *cq =
+					&hisi_hba->cq[slot->dlvry_queue];
 				/*
 				 * flush tasklet to avoid free'ing task
 				 * before using task in IO completion
-- 
2.7.4
