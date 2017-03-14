From: Colin King <colin.king@canonical.com>
Subject: [PATCH][V2] scsi: cxgb3i: remove redundant null check and kfree on skb
Date: Tue, 14 Mar 2017 10:48:43 +0000
Message-ID: <20170314104843.1358-1-colin.king@canonical.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
Return-path: <linux-kernel-owner@vger.kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
To: Karen Xie <kxie@chelsio.com>, "James E . J . Bottomley" <jejb@linux.vnet.ibm.com>, "Martin K . Petersen" <martin.petersen@oracle.com>, linux-scsi@vger.kernel.org
Cc: kernel-janitors@vger.kernel.org, linux-kernel@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org

From: Colin Ian King <colin.king@canonical.com>

On the error exit path, skb is always null, so the non-null check
and __kfree_skb call are redundant.  Remove the redundant code and
just directly return with the appropriate error return code.

Detected by CoverityScan, CID#114328 ("Logically Dead Code")

Signed-off-by: Colin Ian King <colin.king@canonical.com>
---
 drivers/scsi/cxgbi/cxgb3i/cxgb3i.c | 9 ++-------
 1 file changed, 2 insertions(+), 7 deletions(-)

diff --git a/drivers/scsi/cxgbi/cxgb3i/cxgb3i.c b/drivers/scsi/cxgbi/cxgb3i/cxgb3i.c
index 1880eb6..3c9f8cf2 100644
--- a/drivers/scsi/cxgbi/cxgb3i/cxgb3i.c
+++ b/drivers/scsi/cxgbi/cxgb3i/cxgb3i.c
@@ -979,14 +979,14 @@ static int init_act_open(struct cxgbi_sock *csk)
 	csk->atid = cxgb3_alloc_atid(t3dev, &t3_client, csk);
 	if (csk->atid < 0) {
 		pr_err("NO atid available.\n");
-		goto rel_resource;
+		return -EINVAL;
 	}
 	cxgbi_sock_set_flag(csk, CTPF_HAS_ATID);
 	cxgbi_sock_get(csk);
 
 	skb = alloc_wr(sizeof(struct cpl_act_open_req), 0, GFP_KERNEL);
 	if (!skb)
-		goto rel_resource;
+		return -ENOMEM;
 	skb->sk = (struct sock *)csk;
 	set_arp_failure_handler(skb, act_open_arp_failure);
 	csk->snd_win = cxgb3i_snd_win;
@@ -1007,11 +1007,6 @@ static int init_act_open(struct cxgbi_sock *csk)
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
2.10.2
