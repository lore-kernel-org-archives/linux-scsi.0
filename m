From: Monam Agarwal <monamagarwal123@gmail.com>
Subject: [PATCH] drivers/target: Use RCU_INIT_POINTER(x, NULL) in tcm_fc/tfc_sess.c
Date: Mon, 24 Mar 2014 00:09:49 +0530
Message-ID: <1395599989-8183-1-git-send-email-monamagarwal123@gmail.com>
Return-path: <target-devel-owner@vger.kernel.org>
Sender: target-devel-owner@vger.kernel.org
To: nab@linux-iscsi.org, nab@daterainc.com, yongjun_wei@trendmicro.com.cn, linux-scsi@vger.kernel.org, target-devel@vger.kernel.org, linux-kernel@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org

This patch replaces rcu_assign_pointer(x, NULL) with RCU_INIT_POINTER(x, NULL)

The rcu_assign_pointer() ensures that the initialization of a structure       
is carried out before storing a pointer to that structure. 
And in the case of the NULL pointer, there is no structure to initialize. 
So, rcu_assign_pointer(p, NULL) can be safely converted to RCU_INIT_POINTER(p, NULL)

Signed-off-by: Monam Agarwal <monamagarwal123@gmail.com>
---
 drivers/target/tcm_fc/tfc_sess.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/target/tcm_fc/tfc_sess.c b/drivers/target/tcm_fc/tfc_sess.c
index ae52c08..ca7b1ed 100644
--- a/drivers/target/tcm_fc/tfc_sess.c
+++ b/drivers/target/tcm_fc/tfc_sess.c
@@ -97,7 +97,7 @@ static void ft_tport_delete(struct ft_tport *tport)
 	ft_sess_delete_all(tport);
 	lport = tport->lport;
 	BUG_ON(tport != lport->prov[FC_TYPE_FCP]);
-	rcu_assign_pointer(lport->prov[FC_TYPE_FCP], NULL);
+	RCU_INIT_POINTER(lport->prov[FC_TYPE_FCP], NULL);
 
 	tpg = tport->tpg;
 	if (tpg) {
-- 
1.7.9.5
