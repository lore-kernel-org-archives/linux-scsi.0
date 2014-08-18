From: Andreea-Cristina Bernat <bernat.ada@gmail.com>
Subject: [PATCH] tcm_fc: Replace rcu_assign_pointer() with RCU_INIT_POINTER()
Date: Mon, 18 Aug 2014 15:05:37 +0300
Message-ID: <20140818120537.GA19578@ada>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <target-devel-owner@vger.kernel.org>
Content-Disposition: inline
Sender: target-devel-owner@vger.kernel.org
To: nab@linux-iscsi.org, agrover@redhat.com, linux-scsi@vger.kernel.org, target-devel@vger.kernel.org, linux-kernel@vger.kernel.org
Cc: paulmck@linux.vnet.ibm.com
List-Id: linux-scsi@vger.kernel.org

The use of "rcu_assign_pointer()" is NULLing out the pointer.
According to RCU_INIT_POINTER()'s block comment:
"1.   This use of RCU_INIT_POINTER() is NULLing out the pointer"
it is better to use it instead of rcu_assign_pointer() because it has a
smaller overhead.

The following Coccinelle semantic patch was used:
@@
@@

- rcu_assign_pointer
+ RCU_INIT_POINTER
  (..., NULL)

Signed-off-by: Andreea-Cristina Bernat <bernat.ada@gmail.com>
---
 drivers/target/tcm_fc/tfc_sess.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/target/tcm_fc/tfc_sess.c b/drivers/target/tcm_fc/tfc_sess.c
index 21ce508..ccee7e3 100644
--- a/drivers/target/tcm_fc/tfc_sess.c
+++ b/drivers/target/tcm_fc/tfc_sess.c
@@ -98,7 +98,7 @@ static void ft_tport_delete(struct ft_tport *tport)
 	ft_sess_delete_all(tport);
 	lport = tport->lport;
 	BUG_ON(tport != lport->prov[FC_TYPE_FCP]);
-	rcu_assign_pointer(lport->prov[FC_TYPE_FCP], NULL);
+	RCU_INIT_POINTER(lport->prov[FC_TYPE_FCP], NULL);
 
 	tpg = tport->tpg;
 	if (tpg) {
-- 
1.9.1
