From: Mike Christie <mchristi@redhat.com>
Subject: [PATCH 11/19] tcmu: simplify scatter_data_area error handling
Date: Sun, 29 Oct 2017 22:44:31 -0500
Message-ID: <1509335079-5276-12-git-send-email-mchristi@redhat.com>
References: <1509335079-5276-1-git-send-email-mchristi@redhat.com>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:44684 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1752218AbdJ3Doz (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
        Sun, 29 Oct 2017 23:44:55 -0400
In-Reply-To: <1509335079-5276-1-git-send-email-mchristi@redhat.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: martin.petersen@oracle.com, jejb@linux.vnet.ibm.com, linux-scsi@vger.kernel.org, target-devel@vger.kernel.org, nab@linux-iscsi.org
Cc: Mike Christie <mchristi@redhat.com>

scatter_data_area always returns 0, so stop checking
for errors.

Signed-off-by: Mike Christie <mchristi@redhat.com>
---
 drivers/target/target_core_user.c | 31 +++++++------------------------
 1 file changed, 7 insertions(+), 24 deletions(-)

diff --git a/drivers/target/target_core_user.c b/drivers/target/target_core_user.c
index 612ac65..76f0e5a 100644
--- a/drivers/target/target_core_user.c
+++ b/drivers/target/target_core_user.c
@@ -519,7 +519,7 @@ static inline size_t iov_tail(struct iovec *iov)
 	return (size_t)iov->iov_base + iov->iov_len;
 }
 
-static int scatter_data_area(struct tcmu_dev *udev,
+static void scatter_data_area(struct tcmu_dev *udev,
 	struct tcmu_cmd *tcmu_cmd, struct scatterlist *data_sg,
 	unsigned int data_nents, struct iovec **iov,
 	int *iov_cnt, bool copy_data)
@@ -572,8 +572,6 @@ static int scatter_data_area(struct tcmu_dev *udev,
 	}
 	if (to)
 		kunmap_atomic(to);
-
-	return 0;
 }
 
 static void gather_data_area(struct tcmu_dev *udev, struct tcmu_cmd *cmd,
@@ -863,33 +861,18 @@ static int tcmu_setup_cmd_timer(struct tcmu_cmd *tcmu_cmd)
 	iov_cnt = 0;
 	copy_to_data_area = (se_cmd->data_direction == DMA_TO_DEVICE
 		|| se_cmd->se_cmd_flags & SCF_BIDI);
-	ret = scatter_data_area(udev, tcmu_cmd, se_cmd->t_data_sg,
-				se_cmd->t_data_nents, &iov, &iov_cnt,
-				copy_to_data_area);
-	if (ret) {
-		tcmu_cmd_free_data(tcmu_cmd, tcmu_cmd->dbi_cnt);
-		mutex_unlock(&udev->cmdr_lock);
-
-		pr_err("tcmu: alloc and scatter data failed\n");
-		return TCM_LOGICAL_UNIT_COMMUNICATION_FAILURE;
-	}
+	scatter_data_area(udev, tcmu_cmd, se_cmd->t_data_sg,
+			  se_cmd->t_data_nents, &iov, &iov_cnt,
+			  copy_to_data_area);
 	entry->req.iov_cnt = iov_cnt;
 
 	/* Handle BIDI commands */
 	iov_cnt = 0;
 	if (se_cmd->se_cmd_flags & SCF_BIDI) {
 		iov++;
-		ret = scatter_data_area(udev, tcmu_cmd,
-					se_cmd->t_bidi_data_sg,
-					se_cmd->t_bidi_data_nents,
-					&iov, &iov_cnt, false);
-		if (ret) {
-			tcmu_cmd_free_data(tcmu_cmd, tcmu_cmd->dbi_cnt);
-			mutex_unlock(&udev->cmdr_lock);
-
-			pr_err("tcmu: alloc and scatter bidi data failed\n");
-			return TCM_LOGICAL_UNIT_COMMUNICATION_FAILURE;
-		}
+		scatter_data_area(udev, tcmu_cmd, se_cmd->t_bidi_data_sg,
+				  se_cmd->t_bidi_data_nents, &iov, &iov_cnt,
+				  false);
 	}
 	entry->req.iov_bidi_cnt = iov_cnt;
 
-- 
1.8.3.1
