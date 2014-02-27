From: Sagi Grimberg <sagig@mellanox.com>
Subject: [PATCH v1 05/13] IB/iser: Replace fastreg descriptor valid bool with indicators container
Date: Thu, 27 Feb 2014 13:13:01 +0200
Message-ID: <1393499589-15633-6-git-send-email-sagig@mellanox.com>
References: <1393499589-15633-1-git-send-email-sagig@mellanox.com>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mailp.voltaire.com ([193.47.165.129]:37263 "EHLO mellanox.co.il"
	rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org with ESMTP
	id S1752677AbaB0LNU (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Thu, 27 Feb 2014 06:13:20 -0500
In-Reply-To: <1393499589-15633-1-git-send-email-sagig@mellanox.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: roland@kernel.org, nab@linux-iscsi.org
Cc: oren@mellanox.com, martin.petersen@oracle.com, michaelc@cs.wisc.edu, linux-scsi@vger.kernel.org, linux-rdma@vger.kernel.org

In T10-PI support we will have memory keys for protection
buffers and signature transactions. We prefer to compact
indicators rather than keeping multiple bools.

This commit does not change any functionality.

Signed-off-by: Sagi Grimberg <sagig@mellanox.com>
Signed-off-by: Alex Tabachnik <alext@mellanox.com>
---
 drivers/infiniband/ulp/iser/iscsi_iser.h  |    8 ++++++--
 drivers/infiniband/ulp/iser/iser_memory.c |    4 ++--
 drivers/infiniband/ulp/iser/iser_verbs.c  |    2 +-
 3 files changed, 9 insertions(+), 5 deletions(-)

diff --git a/drivers/infiniband/ulp/iser/iscsi_iser.h b/drivers/infiniband/ulp/iser/iscsi_iser.h
index b4290f5..5660714 100644
--- a/drivers/infiniband/ulp/iser/iscsi_iser.h
+++ b/drivers/infiniband/ulp/iser/iscsi_iser.h
@@ -280,13 +280,17 @@ struct iser_device {
 							    enum iser_data_dir cmd_dir);
 };
 
+enum iser_reg_indicator {
+	ISER_DATA_KEY_VALID = 1 << 0,
+};
+
 struct fast_reg_descriptor {
 	struct list_head		  list;
 	/* For fast registration - FRWR */
 	struct ib_mr			 *data_mr;
 	struct ib_fast_reg_page_list     *data_frpl;
-	/* Valid for fast registration flag */
-	bool				  valid;
+	/* registration indicators container */
+	u8				  reg_indicators;
 };
 
 struct iser_conn {
diff --git a/drivers/infiniband/ulp/iser/iser_memory.c b/drivers/infiniband/ulp/iser/iser_memory.c
index d25587e..a7a0d3e 100644
--- a/drivers/infiniband/ulp/iser/iser_memory.c
+++ b/drivers/infiniband/ulp/iser/iser_memory.c
@@ -479,7 +479,7 @@ static int iser_fast_reg_mr(struct iscsi_iser_task *iser_task,
 		return -EINVAL;
 	}
 
-	if (!desc->valid) {
+	if (!(desc->reg_indicators & ISER_DATA_KEY_VALID)) {
 		memset(&inv_wr, 0, sizeof(inv_wr));
 		inv_wr.wr_id = ISER_FASTREG_LI_WRID;
 		inv_wr.opcode = IB_WR_LOCAL_INV;
@@ -514,7 +514,7 @@ static int iser_fast_reg_mr(struct iscsi_iser_task *iser_task,
 		iser_err("fast registration failed, ret:%d\n", ret);
 		return ret;
 	}
-	desc->valid = false;
+	desc->reg_indicators &= ~ISER_DATA_KEY_VALID;
 
 	sge->lkey = desc->data_mr->lkey;
 	sge->addr = desc->data_frpl->page_list[0] + offset;
diff --git a/drivers/infiniband/ulp/iser/iser_verbs.c b/drivers/infiniband/ulp/iser/iser_verbs.c
index 95fcfca..6a5f424 100644
--- a/drivers/infiniband/ulp/iser/iser_verbs.c
+++ b/drivers/infiniband/ulp/iser/iser_verbs.c
@@ -296,7 +296,7 @@ iser_create_fastreg_desc(struct ib_device *ib_device, struct ib_pd *pd,
 	}
 	iser_info("Create fr_desc %p page_list %p\n",
 		  desc, desc->data_frpl->page_list);
-	desc->valid = true;
+	desc->reg_indicators |= ISER_DATA_KEY_VALID;
 
 	return 0;
 
-- 
1.7.1

