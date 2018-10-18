From: "Gustavo A. R. Silva" <gustavo@embeddedor.com>
Subject: [PATCH v2] scsi: hisi_sas: Fix NULL pointer dereference
Date: Thu, 18 Oct 2018 18:59:39 +0200
Message-ID: <20181018165939.GA26491@embeddedor.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
To: John Garry <john.garry@huawei.com>, "James E.J. Bottomley" <jejb@linux.vnet.ibm.com>, "Martin K. Petersen" <martin.petersen@oracle.com>, Xiang Chen <chenxiang66@hisilicon.com>
Cc: linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org, "Gustavo A. R. Silva" <gustavo@embeddedor.com>
List-Id: linux-scsi@vger.kernel.org

There is a NULL pointer dereference in case *slot* happens to
be NULL at lines 1053 and 1878:

struct hisi_sas_cq *cq =
	&hisi_hba->cq[slot->dlvry_queue];

Notice that *slot* is being NULL checked at lines 1057 and 1881:
if (slot), which implies it may be NULL.

Fix this by placing the declaration and definition of variable cq,
which contains the pointer dereference slot->dlvry_queue, after
slot has been properly NULL checked.

Addresses-Coverity-ID: 1474515 ("Dereference before null check")
Addresses-Coverity-ID: 1474520 ("Dereference before null check")
Fixes: 584f53fe5f52 ("scsi: hisi_sas: Fix the race between IO completion and timeout for SMP/internal IO")
Signed-off-by: Gustavo A. R. Silva <gustavo@embeddedor.com>
---
Changes in v2:
 - Fix another instance of the same issue at line 1053.
 - Update commit log.

 drivers/scsi/hisi_sas/hisi_sas_main.c | 8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

diff --git a/drivers/scsi/hisi_sas/hisi_sas_main.c b/drivers/scsi/hisi_sas/hisi_sas_main.c
index 2e5eaf1..b3f01d5 100644
--- a/drivers/scsi/hisi_sas/hisi_sas_main.c
+++ b/drivers/scsi/hisi_sas/hisi_sas_main.c
@@ -1050,11 +1050,11 @@ static int hisi_sas_exec_internal_tmf_task(struct domain_device *device,
 		if ((task->task_state_flags & SAS_TASK_STATE_ABORTED)) {
 			if (!(task->task_state_flags & SAS_TASK_STATE_DONE)) {
 				struct hisi_sas_slot *slot = task->lldd_task;
-				struct hisi_sas_cq *cq =
-					&hisi_hba->cq[slot->dlvry_queue];
 
 				dev_err(dev, "abort tmf: TMF task timeout and not done\n");
 				if (slot) {
+					struct hisi_sas_cq *cq =
+					       &hisi_hba->cq[slot->dlvry_queue];
 					/*
 					 * flush tasklet to avoid free'ing task
 					 * before using task in IO completion
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
