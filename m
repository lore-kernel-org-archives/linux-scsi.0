From: Jia-Ju Bai <baijiaju1990@gmail.com>
Subject: [PATCH] target: iscsi: iscsi_target_tpg: Fix a possible null-pointer dereference in iscsit_tpg_add_network_portal()
Date: Mon, 29 Jul 2019 10:29:56 +0800
Message-ID: <20190729022956.18192-1-baijiaju1990@gmail.com>
Return-path: <linux-kernel-owner@vger.kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
To: martin.petersen@oracle.com, kstewart@linuxfoundation.org, allison@lohutok.net, rfontana@redhat.com, tglx@linutronix.de, gregkh@linuxfoundation.org
Cc: linux-scsi@vger.kernel.org, target-devel@vger.kernel.org, linux-kernel@vger.kernel.org, Jia-Ju Bai <baijiaju1990@gmail.com>
List-Id: linux-scsi@vger.kernel.org

In iscsit_tpg_add_network_portal(), there is an if statement on line 496
to check whether tpg->tpg_tiqn is NULL:
    if (tpg->tpg_tiqn)

When tpg->tpg_tiqn is NULL, it is used on line 508:
    pr_debug(..., tpg->tpg_tiqn->tiqn, ...);

Thus, a possible null-pointer dereference may occur.

To fix this bug, tpg->tpg_tiqn is checked before being used.

This bug is found by a static analysis tool STCheck written by us.

Signed-off-by: Jia-Ju Bai <baijiaju1990@gmail.com>
---
 drivers/target/iscsi/iscsi_target_tpg.c | 8 +++++---
 1 file changed, 5 insertions(+), 3 deletions(-)

diff --git a/drivers/target/iscsi/iscsi_target_tpg.c b/drivers/target/iscsi/iscsi_target_tpg.c
index 8075f60fd02c..bf97be36ec1f 100644
--- a/drivers/target/iscsi/iscsi_target_tpg.c
+++ b/drivers/target/iscsi/iscsi_target_tpg.c
@@ -505,9 +505,11 @@ struct iscsi_tpg_np *iscsit_tpg_add_network_portal(
 		spin_unlock(&tpg_np_parent->tpg_np_parent_lock);
 	}
 
-	pr_debug("CORE[%s] - Added Network Portal: %pISpc,%hu on %s\n",
-		tpg->tpg_tiqn->tiqn, &np->np_sockaddr, tpg->tpgt,
-		np->np_transport->name);
+	if (tpg->tpg_tiqn) {
+		pr_debug("CORE[%s] - Added Network Portal: %pISpc,%hu on %s\n",
+			tpg->tpg_tiqn->tiqn, &np->np_sockaddr, tpg->tpgt,
+			np->np_transport->name);
+	}
 
 	return tpg_np;
 }
-- 
2.17.0
