From: Sagi Grimberg <sagig@mellanox.com>
Subject: [PATCH] IB/mlx5: Fix smatch warnings
Date: Sun, 19 Jan 2014 11:23:57 +0200
Message-ID: <1390123437-27517-1-git-send-email-sagig@mellanox.com>
Return-path: <target-devel-owner@vger.kernel.org>
Sender: target-devel-owner@vger.kernel.org
To: nab@linux-iscsi.org
Cc: dan.carpenter@oracle.com, linux-scsi@vger.kernel.org, target-devel@vger.kernel.org, linux-rdma@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org

Possible double free on in-mailbox.

Signed-off-by: Sagi Grimberg <sagig@mellanox.com>
---
 drivers/infiniband/hw/mlx5/mr.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/drivers/infiniband/hw/mlx5/mr.c b/drivers/infiniband/hw/mlx5/mr.c
index bc27f6b..f023711 100644
--- a/drivers/infiniband/hw/mlx5/mr.c
+++ b/drivers/infiniband/hw/mlx5/mr.c
@@ -1050,13 +1050,13 @@ struct ib_mr *mlx5_ib_create_mr(struct ib_pd *pd,
 	in->seg.flags = MLX5_PERM_UMR_EN | access_mode;
 	err = mlx5_core_create_mkey(&dev->mdev, &mr->mmr, in, sizeof(*in),
 				    NULL, NULL, NULL);
-	kfree(in);
 	if (err)
 		goto err_destroy_psv;
 
 	mr->ibmr.lkey = mr->mmr.key;
 	mr->ibmr.rkey = mr->mmr.key;
 	mr->umem = NULL;
+	kfree(in);
 
 	return &mr->ibmr;
 
-- 
1.7.8.2
