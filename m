From: Sagi Grimberg <sagig@mellanox.com>
Subject: [PATCH 03/11] IB/iser: Move fast_reg_descriptor initialization to a function
Date: Sun, 23 Feb 2014 14:19:26 +0200
Message-ID: <1393157974-24931-4-git-send-email-sagig@mellanox.com>
References: <1393157974-24931-1-git-send-email-sagig@mellanox.com>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mailp.voltaire.com ([193.47.165.129]:40908 "EHLO mellanox.co.il"
	rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org with ESMTP
	id S1751300AbaBWMTm (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Sun, 23 Feb 2014 07:19:42 -0500
In-Reply-To: <1393157974-24931-1-git-send-email-sagig@mellanox.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: roland@kernel.org, nab@linux-iscsi.org
Cc: oren@mellanox.com, martin.petersen@oracle.com, michaelc@cs.wisc.edu, linux-scsi@vger.kernel.org, linux-rdma@vger.kernel.org

fastreg descriptor will include protection information context.
In order to place the logic in one place we introduce
iser_create_fr_desc function.

This patch does not change any functionality.

Signed-off-by: Sagi Grimberg <sagig@mellanox.com>
---
 drivers/infiniband/ulp/iser/iser_verbs.c |   58 ++++++++++++++++++++---------
 1 files changed, 40 insertions(+), 18 deletions(-)

diff --git a/drivers/infiniband/ulp/iser/iser_verbs.c b/drivers/infiniband/ulp/iser/iser_verbs.c
index 4809693..0cc76de 100644
--- a/drivers/infiniband/ulp/iser/iser_verbs.c
+++ b/drivers/infiniband/ulp/iser/iser_verbs.c
@@ -279,6 +279,39 @@ void iser_free_fmr_pool(struct iser_conn *ib_conn)
 	ib_conn->fmr.page_vec = NULL;
 }
 
+static int
+iser_create_fastreg_desc(struct ib_device *ib_device, struct ib_pd *pd,
+			 struct fast_reg_descriptor *desc)
+{
+	int ret;
+
+	desc->data_frpl = ib_alloc_fast_reg_page_list(ib_device,
+						      ISCSI_ISER_SG_TABLESIZE + 1);
+	if (IS_ERR(desc->data_frpl)) {
+		ret = PTR_ERR(desc->data_frpl);
+		iser_err("Failed to allocate ib_fast_reg_page_list err=%d\n",
+			 ret);
+		return PTR_ERR(desc->data_frpl);
+	}
+
+	desc->data_mr = ib_alloc_fast_reg_mr(pd, ISCSI_ISER_SG_TABLESIZE + 1);
+	if (IS_ERR(desc->data_mr)) {
+		ret = PTR_ERR(desc->data_mr);
+		iser_err("Failed to allocate ib_fast_reg_mr err=%d\n", ret);
+		goto fast_reg_mr_failure;
+	}
+	iser_info("Create fr_desc %p page_list %p\n",
+		  desc, desc->data_frpl->page_list);
+	desc->valid = true;
+
+	return 0;
+
+fast_reg_mr_failure:
+	ib_free_fast_reg_page_list(desc->data_frpl);
+
+	return ret;
+}
+
 /**
  * iser_create_fastreg_pool - Creates pool of fast_reg descriptors
  * for fast registration work requests.
@@ -300,32 +333,21 @@ int iser_create_fastreg_pool(struct iser_conn *ib_conn, unsigned cmds_max)
 			goto err;
 		}
 
-		desc->data_frpl = ib_alloc_fast_reg_page_list(device->ib_device,
-							 ISCSI_ISER_SG_TABLESIZE + 1);
-		if (IS_ERR(desc->data_frpl)) {
-			ret = PTR_ERR(desc->data_frpl);
-			iser_err("Failed to allocate ib_fast_reg_page_list err=%d\n", ret);
-			goto fast_reg_page_failure;
+		ret = iser_create_fastreg_desc(device->ib_device,
+					       device->pd, desc);
+		if (ret) {
+			iser_err("Failed to create fastreg descriptor err=%d\n",
+				 ret);
+			kfree(desc);
+			goto err;
 		}
 
-		desc->data_mr = ib_alloc_fast_reg_mr(device->pd,
-						     ISCSI_ISER_SG_TABLESIZE + 1);
-		if (IS_ERR(desc->data_mr)) {
-			ret = PTR_ERR(desc->data_mr);
-			iser_err("Failed to allocate ib_fast_reg_mr err=%d\n", ret);
-			goto fast_reg_mr_failure;
-		}
-		desc->valid = true;
 		list_add_tail(&desc->list, &ib_conn->fastreg.pool);
 		ib_conn->fastreg.pool_size++;
 	}
 
 	return 0;
 
-fast_reg_mr_failure:
-	ib_free_fast_reg_page_list(desc->data_frpl);
-fast_reg_page_failure:
-	kfree(desc);
 err:
 	iser_free_fastreg_pool(ib_conn);
 	return ret;
-- 
1.7.1

