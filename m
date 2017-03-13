From: Colin King <colin.king@canonical.com>
Subject: [PATCH] scsi: cxgb3i: remove redundant null check and kfree on skb
Date: Mon, 13 Mar 2017 19:14:08 +0000
Message-ID: <20170313191408.20080-1-colin.king@canonical.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
Return-path: <kernel-janitors-owner@vger.kernel.org>
Sender: kernel-janitors-owner@vger.kernel.org
To: Karen Xie <kxie@chelsio.com>, "James E . J . Bottomley" <jejb@linux.vnet.ibm.com>, "Martin K . Petersen" <martin.petersen@oracle.com>, linux-scsi@vger.kernel.org
Cc: kernel-janitors@vger.kernel.org, linux-kernel@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org

From: Colin Ian King <colin.king@canonical.com>

On the error exit path, skb is always null, so the non-null check
and __kfree_skb call are redundant.  Remove the redundant code,
rename the rel_release label to err and make error paths jump to
the err exit path.

Detected by CoverityScan, CID#114328 ("Logically Dead Code")

Signed-off-by: Colin Ian King <colin.king@canonical.com>
---
 drivers/scsi/cxgbi/cxgb3i/cxgb3i.c | 10 ++++------
 1 file changed, 4 insertions(+), 6 deletions(-)

diff --git a/drivers/scsi/cxgbi/cxgb3i/cxgb3i.c b/drivers/scsi/cxgbi/cxgb3i/cxgb3i.c
index 1880eb6..f453a78 100644
--- a/drivers/scsi/cxgbi/cxgb3i/cxgb3i.c
+++ b/drivers/scsi/cxgbi/cxgb3i/cxgb3i.c
@@ -972,21 +972,21 @@ static int init_act_open(struct cxgbi_sock *csk)
 			      &csk->daddr.sin_addr.s_addr);
 	if (!csk->l2t) {
 		pr_err("NO l2t available.\n");
-		return -EINVAL;
+		goto err;
 	}
 	cxgbi_sock_get(csk);
 
 	csk->atid = cxgb3_alloc_atid(t3dev, &t3_client, csk);
 	if (csk->atid < 0) {
 		pr_err("NO atid available.\n");
-		goto rel_resource;
+		goto err;
 	}
 	cxgbi_sock_set_flag(csk, CTPF_HAS_ATID);
 	cxgbi_sock_get(csk);
 
 	skb = alloc_wr(sizeof(struct cpl_act_open_req), 0, GFP_KERNEL);
 	if (!skb)
-		goto rel_resource;
+		goto err;
 	skb->sk = (struct sock *)csk;
 	set_arp_failure_handler(skb, act_open_arp_failure);
 	csk->snd_win = cxgb3i_snd_win;
@@ -1008,9 +1008,7 @@ static int init_act_open(struct cxgbi_sock *csk)
 	send_act_open_req(csk, skb, csk->l2t);
 	return 0;
 
-rel_resource:
-	if (skb)
-		__kfree_skb(skb);
+err:
 	return -EINVAL;
 }
 
-- 
2.10.2

