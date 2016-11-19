From: Quentin Lambert <lambert.quentin@gmail.com>
Subject: [PATCH] cxgb4i: Add a missing call to neigh_release
Date: Sat, 19 Nov 2016 18:42:14 +0100
Message-ID: <20161119174214.20241-1-lambert.quentin@gmail.com>
Return-path: <kernel-janitors-owner@vger.kernel.org>
Sender: kernel-janitors-owner@vger.kernel.org
To: Karen Xie <kxie@chelsio.com>, "James E.J. Bottomley" <jejb@linux.vnet.ibm.com>, "Martin K. Petersen" <martin.petersen@oracle.com>, linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org, kernel-janitors@vger.kernel.org
Cc: Quentin Lambert <lambert.quentin@gmail.com>
List-Id: linux-scsi@vger.kernel.org

Most error branches following the call to dst_neigh_lookup contain
a call to neigh_release. This patch add these calls where they are
missing.

This issue was found with Hector.

Signed-off-by: Quentin Lambert <lambert.quentin@gmail.com>

---
 drivers/scsi/cxgbi/cxgb4i/cxgb4i.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/drivers/scsi/cxgbi/cxgb4i/cxgb4i.c
+++ b/drivers/scsi/cxgbi/cxgb4i/cxgb4i.c
@@ -1410,7 +1410,7 @@ static int init_act_open(struct cxgbi_so
 	csk->atid = cxgb4_alloc_atid(lldi->tids, csk);
 	if (csk->atid < 0) {
 		pr_err("%s, NO atid available.\n", ndev->name);
-		return -EINVAL;
+		goto rel_resource_without_clip;
 	}
 	cxgbi_sock_set_flag(csk, CTPF_HAS_ATID);
 	cxgbi_sock_get(csk);
