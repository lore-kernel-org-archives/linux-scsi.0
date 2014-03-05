From: Sagi Grimberg <sagig-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Subject: [PATCH v2 05/13] IB/iser: Replace fastreg descriptor valid bool with indicators container
Date: Wed,  5 Mar 2014 19:43:43 +0200
Message-ID: <1394041431-28399-6-git-send-email-sagig@mellanox.com>
References: <1394041431-28399-1-git-send-email-sagig@mellanox.com>
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1394041431-28399-1-git-send-email-sagig-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: roland-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org, nab-IzHhD5pYlfBP7FQvKIMDCQ@public.gmane.org, michaelc-hcNo3dDEHLuVc3sceRu5cw@public.gmane.org
Cc: martin.petersen-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org, oren-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org, linux-scsi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-scsi@vger.kernel.org

In T10-PI support we will have memory keys for protection
buffers and signature transactions. We prefer to compact
indicators rather than keeping multiple bools.

This commit does not change any functionality.

Signed-off-by: Sagi Grimberg <sagig-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Signed-off-by: Alex Tabachnik <alext-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
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

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
