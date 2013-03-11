From: Wei Yongjun <weiyj.lk@gmail.com>
Subject: [PATCH] tcm_fc: using kfree_rcu() to simplify the code
Date: Mon, 11 Mar 2013 21:48:28 +0800
Message-ID: <CAPgLHd9BaUSZf4PmF9UMn8c5CEJXEq9taNtYme5RV6COBztqAA@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-bk0-f46.google.com ([209.85.214.46]:60740 "EHLO
	mail-bk0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753062Ab3CKNsa (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Mon, 11 Mar 2013 09:48:30 -0400
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: nab@linux-iscsi.org, mark.d.rustad@intel.com, bprakash@broadcom.com, sasha.levin@oracle.com, akpm@linux-foundation.org
Cc: yongjun_wei@trendmicro.com.cn, linux-scsi@vger.kernel.org, target-devel@vger.kernel.org

From: Wei Yongjun <yongjun_wei@trendmicro.com.cn>

The callback function of call_rcu() just calls a kfree(), so we
can use kfree_rcu() instead of call_rcu() + callback function.

Signed-off-by: Wei Yongjun <yongjun_wei@trendmicro.com.cn>
---
 drivers/target/tcm_fc/tfc_sess.c | 9 +--------
 1 file changed, 1 insertion(+), 8 deletions(-)

diff --git a/drivers/target/tcm_fc/tfc_sess.c b/drivers/target/tcm_fc/tfc_sess.c
index 113f335..4859505 100644
--- a/drivers/target/tcm_fc/tfc_sess.c
+++ b/drivers/target/tcm_fc/tfc_sess.c
@@ -428,19 +428,12 @@ static int ft_prli(struct fc_rport_priv *rdata, u32 spp_len,
 	return ret;
 }
 
-static void ft_sess_rcu_free(struct rcu_head *rcu)
-{
-	struct ft_sess *sess = container_of(rcu, struct ft_sess, rcu);
-
-	kfree(sess);
-}
-
 static void ft_sess_free(struct kref *kref)
 {
 	struct ft_sess *sess = container_of(kref, struct ft_sess, kref);
 
 	transport_deregister_session(sess->se_sess);
-	call_rcu(&sess->rcu, ft_sess_rcu_free);
+	kfree_rcu(sess, rcu);
 }
 
 void ft_sess_put(struct ft_sess *sess)

