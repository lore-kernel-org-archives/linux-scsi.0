From: Sagi Grimberg <sagig@mellanox.com>
Subject: [PATCH 04/11] IB/isert: Move fastreg descriptor creation to a function
Date: Thu,  9 Jan 2014 18:40:51 +0200
Message-ID: <1389285658-7037-5-git-send-email-sagig@mellanox.com>
References: <1389285658-7037-1-git-send-email-sagig@mellanox.com>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mailp.voltaire.com ([193.47.165.129]:57701 "EHLO mellanox.co.il"
	rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org with ESMTP
	id S1755219AbaAIQlI (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Thu, 9 Jan 2014 11:41:08 -0500
In-Reply-To: <1389285658-7037-1-git-send-email-sagig@mellanox.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: target-devel@vger.kernel.org
Cc: linux-scsi@vger.kernel.org, linux-rdma@vger.kernel.org, martin.petersen@oracle.com, nab@linux-iscsi.org, ogerlitz@mellanox.com, oren@mellanox.com

This routine may be called both by fast registration
descriptors for data and for integrity buffers.

This patch does not change any functionality.

Signed-off-by: Sagi Grimberg <sagig@mellanox.com>
---
 drivers/infiniband/ulp/isert/ib_isert.c |   52 +++++++++++++++++++------------
 1 files changed, 32 insertions(+), 20 deletions(-)

diff --git a/drivers/infiniband/ulp/isert/ib_isert.c b/drivers/infiniband/ulp/isert/ib_isert.c
index 295d2be..9ef9193 100644
--- a/drivers/infiniband/ulp/isert/ib_isert.c
+++ b/drivers/infiniband/ulp/isert/ib_isert.c
@@ -393,6 +393,33 @@ isert_conn_free_fastreg_pool(struct isert_conn *isert_conn)
 }
 
 static int
+isert_create_fr_desc(struct ib_device *ib_device, struct ib_pd *pd,
+		     struct fast_reg_descriptor *fr_desc)
+{
+	fr_desc->data_frpl = ib_alloc_fast_reg_page_list(ib_device,
+							 ISCSI_ISER_SG_TABLESIZE);
+	if (IS_ERR(fr_desc->data_frpl)) {
+		pr_err("Failed to allocate data frpl err=%ld\n",
+		       PTR_ERR(fr_desc->data_frpl));
+		return PTR_ERR(fr_desc->data_frpl);
+	}
+
+	fr_desc->data_mr = ib_alloc_fast_reg_mr(pd, ISCSI_ISER_SG_TABLESIZE);
+	if (IS_ERR(fr_desc->data_mr)) {
+		pr_err("Failed to allocate data frmr err=%ld\n",
+		       PTR_ERR(fr_desc->data_mr));
+		ib_free_fast_reg_page_list(fr_desc->data_frpl);
+		return PTR_ERR(fr_desc->data_mr);
+	}
+	pr_debug("Create fr_desc %p page_list %p\n",
+		 fr_desc, fr_desc->data_frpl->page_list);
+
+	fr_desc->valid = true;
+
+	return 0;
+}
+
+static int
 isert_conn_create_fastreg_pool(struct isert_conn *isert_conn)
 {
 	struct fast_reg_descriptor *fr_desc;
@@ -409,29 +436,14 @@ isert_conn_create_fastreg_pool(struct isert_conn *isert_conn)
 			goto err;
 		}
 
-		fr_desc->data_frpl =
-			ib_alloc_fast_reg_page_list(device->ib_device,
-						    ISCSI_ISER_SG_TABLESIZE);
-		if (IS_ERR(fr_desc->data_frpl)) {
-			pr_err("Failed to allocate fr_pg_list err=%ld\n",
-			       PTR_ERR(fr_desc->data_frpl));
-			ret = PTR_ERR(fr_desc->data_frpl);
-			goto err;
-		}
-
-		fr_desc->data_mr = ib_alloc_fast_reg_mr(isert_conn->conn_pd,
-					ISCSI_ISER_SG_TABLESIZE);
-		if (IS_ERR(fr_desc->data_mr)) {
-			pr_err("Failed to allocate frmr err=%ld\n",
-			       PTR_ERR(fr_desc->data_mr));
-			ret = PTR_ERR(fr_desc->data_mr);
-			ib_free_fast_reg_page_list(fr_desc->data_frpl);
+		ret = isert_create_fr_desc(device->ib_device,
+					   isert_conn->conn_pd, fr_desc);
+		if (ret) {
+			pr_err("Failed to create fastreg descriptor err=%d\n",
+			       ret);
 			goto err;
 		}
-		pr_debug("Create fr_desc %p page_list %p\n",
-			 fr_desc, fr_desc->data_frpl->page_list);
 
-		fr_desc->valid = true;
 		list_add_tail(&fr_desc->list, &isert_conn->conn_fr_pool);
 		isert_conn->conn_fr_pool_size++;
 	}
-- 
1.7.1

