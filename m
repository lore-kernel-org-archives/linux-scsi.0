From: Sagi Grimberg <sagi@grimberg.me>
Subject: [PATCH] iser: set sector for ambiguous mr status errors
Date: Wed, 14 Nov 2018 10:17:01 -0800
Message-ID: <20181114181701.26417-1-sagi@grimberg.me>
Return-path: <stable-owner@vger.kernel.org>
Sender: stable-owner@vger.kernel.org
To: linux-rdma@vger.kernel.org, linux-scsi@vger.kernel.org
Cc: Dan Carpenter <dan.carpenter@oracle.com>, stable@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org

If for some reason we failed to query the mr status, we need to make sure
to provide sufficient information for an ambiguous error (guard error on
sector 0).

Fixes: 0a7a08ad6f5f ("IB/iser: Implement check_protection")
Cc: <stable@vger.kernel.org>
Reported-by: Dan Carpenter <dan.carpenter@oracle.com>
Signed-off-by: Sagi Grimberg <sagi@grimberg.me>
---
 drivers/infiniband/ulp/iser/iser_verbs.c | 7 +++----
 1 file changed, 3 insertions(+), 4 deletions(-)

diff --git a/drivers/infiniband/ulp/iser/iser_verbs.c b/drivers/infiniband/ulp/iser/iser_verbs.c
index 946b623ba5eb..ab137bafa8a8 100644
--- a/drivers/infiniband/ulp/iser/iser_verbs.c
+++ b/drivers/infiniband/ulp/iser/iser_verbs.c
@@ -1124,7 +1124,9 @@ u8 iser_check_task_pi_status(struct iscsi_iser_task *iser_task,
 					 IB_MR_CHECK_SIG_STATUS, &mr_status);
 		if (ret) {
 			pr_err("ib_check_mr_status failed, ret %d\n", ret);
-			goto err;
+			/* Not alot we can do, return ambiguous guard error */
+			*sector = 0;
+			return 0x1;
 		}
 
 		if (mr_status.fail_status & IB_MR_CHECK_SIG_STATUS) {
@@ -1152,9 +1154,6 @@ u8 iser_check_task_pi_status(struct iscsi_iser_task *iser_task,
 	}
 
 	return 0;
-err:
-	/* Not alot we can do here, return ambiguous guard error */
-	return 0x1;
 }
 
 void iser_err_comp(struct ib_wc *wc, const char *type)
-- 
2.17.1
