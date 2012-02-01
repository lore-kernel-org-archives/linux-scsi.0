From: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
Subject: [PATCH RFC tip/core/rcu 08/41] tcm_fc: Convert call_rcu() to kfree_rcu()
Date: Wed,  1 Feb 2012 11:41:26 -0800
Message-ID: <1328125319-5205-8-git-send-email-paulmck@linux.vnet.ibm.com>
References: <20120201194131.GA10028@linux.vnet.ibm.com>
 <1328125319-5205-1-git-send-email-paulmck@linux.vnet.ibm.com>
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <1328125319-5205-1-git-send-email-paulmck@linux.vnet.ibm.com>
Sender: linux-kernel-owner@vger.kernel.org
To: linux-kernel@vger.kernel.org
Cc: mingo@elte.hu, laijs@cn.fujitsu.com, dipankar@in.ibm.com, akpm@linux-foundation.org, mathieu.desnoyers@polymtl.ca, josh@joshtriplett.org, niv@us.ibm.com, tglx@linutronix.de, peterz@infradead.org, rostedt@goodmis.org, Valdis.Kletnieks@vt.edu, dhowells@redhat.com, eric.dumazet@gmail.com, darren@dvhart.com, fweisbec@gmail.com, patches@linaro.org, "Paul E. McKenney" <paul.mckenney@linaro.org>, "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>, "Nicholas A. Bellinger" <nab@linux-iscsi.org>, Jiri Kosina <jkosina@suse.cz>, Jesper Juhl <jj@chaosbits.net>, linux-scsi@vger.kernel.org, target-devel@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org

From: "Paul E. McKenney" <paul.mckenney@linaro.org>

The call_rcu() in ft_tport_delete() invokes ft_tport_rcu_free(),
which just does a kfree().  So convert the call_rcu() to kfree_rcu(),
allowing ft_tport_rcu_free() to be eliminated.

Signed-off-by: Paul E. McKenney <paul.mckenney@linaro.org>
Signed-off-by: Paul E. McKenney <paulmck@linux.vnet.ibm.com>
Cc: "Nicholas A. Bellinger" <nab@linux-iscsi.org>
Cc: Jiri Kosina <jkosina@suse.cz>
Cc: Jesper Juhl <jj@chaosbits.net>
Cc: linux-scsi@vger.kernel.org
Cc: target-devel@vger.kernel.org
---
 drivers/target/tcm_fc/tfc_sess.c |   12 +-----------
 1 files changed, 1 insertions(+), 11 deletions(-)

diff --git a/drivers/target/tcm_fc/tfc_sess.c b/drivers/target/tcm_fc/tfc_sess.c
index 4c0507c..eff512b 100644
--- a/drivers/target/tcm_fc/tfc_sess.c
+++ b/drivers/target/tcm_fc/tfc_sess.c
@@ -86,16 +86,6 @@ static struct ft_tport *ft_tport_create(struct fc_lport *lport)
 }
 
 /*
- * Free tport via RCU.
- */
-static void ft_tport_rcu_free(struct rcu_head *rcu)
-{
-	struct ft_tport *tport = container_of(rcu, struct ft_tport, rcu);
-
-	kfree(tport);
-}
-
-/*
  * Delete a target local port.
  * Caller holds ft_lport_lock.
  */
@@ -114,7 +104,7 @@ static void ft_tport_delete(struct ft_tport *tport)
 		tpg->tport = NULL;
 		tport->tpg = NULL;
 	}
-	call_rcu(&tport->rcu, ft_tport_rcu_free);
+	kfree_rcu(tport, rcu);
 }
 
 /*
-- 
1.7.8
