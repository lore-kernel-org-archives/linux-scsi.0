From: Colin King <colin.king@canonical.com>
Subject: [PATCH][V2] scsi: cxgbi: remove redundant __kfree_skb call on skb and free cst->atid
Date: Wed, 10 Apr 2019 16:54:31 +0100
Message-ID: <20190410155431.10045-1-colin.king@canonical.com>
Mime-Version: 1.0
Content-Transfer-Encoding: 8bit
Return-path: <linux-kernel-owner@vger.kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
To: Karen Xie <kxie@chelsio.com>, "James E . J . Bottomley" <jejb@linux.ibm.com>, "Martin K . Petersen" <martin.petersen@oracle.com>, linux-scsi@vger.kernel.org
Cc: kernel-janitors@vger.kernel.org, linux-kernel@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org

From: Colin Ian King <colin.king@canonical.com>

The error return path via label rel_resource checks for a non-null
skb before free'ing it.  However, skb is always null at this exit
path, so the null check and the free are redundant and can be removed.
Removing this allows the original goto's to rel_resource to be cleaned
up; the first can be replaced by a return of -EINVAL, the second can
be replaced by a more appropriate -ENOMEM return and fix a memory
leak by freeing csk->atid

Addresses-Coverity: ("Logically Dead Code")
Signed-off-by: Colin Ian King <colin.king@canonical.com>
---

V2: Ensure cst->atid is free'd to fix memory leak, thanks to
    Walter Harms for spotting this mistake in V1.
---
 drivers/scsi/cxgbi/cxgb3i/cxgb3i.c | 13 +++++--------
 1 file changed, 5 insertions(+), 8 deletions(-)

diff --git a/drivers/scsi/cxgbi/cxgb3i/cxgb3i.c b/drivers/scsi/cxgbi/cxgb3i/cxgb3i.c
index 75e1273a44b3..15a48c2ac536 100644
--- a/drivers/scsi/cxgbi/cxgb3i/cxgb3i.c
+++ b/drivers/scsi/cxgbi/cxgb3i/cxgb3i.c
@@ -979,14 +979,16 @@ static int init_act_open(struct cxgbi_sock *csk)
 	csk->atid = cxgb3_alloc_atid(t3dev, &t3_client, csk);
 	if (csk->atid < 0) {
 		pr_err("NO atid available.\n");
-		goto rel_resource;
+		return -EINVAL;
 	}
 	cxgbi_sock_set_flag(csk, CTPF_HAS_ATID);
 	cxgbi_sock_get(csk);
 
 	skb = alloc_wr(sizeof(struct cpl_act_open_req), 0, GFP_KERNEL);
-	if (!skb)
-		goto rel_resource;
+	if (!skb) {
+		cxgb3_free_atid(t3dev, csk->atid);
+		return -ENOMEM;
+	}
 	skb->sk = (struct sock *)csk;
 	set_arp_failure_handler(skb, act_open_arp_failure);
 	csk->snd_win = cxgb3i_snd_win;
@@ -1007,11 +1009,6 @@ static int init_act_open(struct cxgbi_sock *csk)
 	cxgbi_sock_set_state(csk, CTP_ACTIVE_OPEN);
 	send_act_open_req(csk, skb, csk->l2t);
 	return 0;
-
-rel_resource:
-	if (skb)
-		__kfree_skb(skb);
-	return -EINVAL;
 }
 
 cxgb3_cpl_handler_func cxgb3i_cpl_handlers[NUM_CPL_CMDS] = {
-- 
2.20.1
