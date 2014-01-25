From: Andy Grover <agrover@redhat.com>
Subject: [PATCH 2/3] target/iscsi: Convert np_lock from a spinlock to a mutex
Date: Fri, 24 Jan 2014 16:18:55 -0800
Message-ID: <1390609136-28674-3-git-send-email-agrover@redhat.com>
References: <1390609136-28674-1-git-send-email-agrover@redhat.com>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:20151 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751534AbaAYATM (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Fri, 24 Jan 2014 19:19:12 -0500
In-Reply-To: <1390609136-28674-1-git-send-email-agrover@redhat.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: target-devel@vger.kernel.org
Cc: linux-scsi@vger.kernel.org

All callers are in process context.

Convert spin_lock to spin_lock_bh in iscsit_get_np since outer spin_lock_bh
is now not there.

Signed-off-by: Andy Grover <agrover@redhat.com>
---
 drivers/target/iscsi/iscsi_target.c |   22 +++++++++++-----------
 1 files changed, 11 insertions(+), 11 deletions(-)

diff --git a/drivers/target/iscsi/iscsi_target.c b/drivers/target/iscsi/iscsi_target.c
index bfd4bf7..45ec498 100644
--- a/drivers/target/iscsi/iscsi_target.c
+++ b/drivers/target/iscsi/iscsi_target.c
@@ -52,7 +52,7 @@
 static LIST_HEAD(g_tiqn_list);
 static LIST_HEAD(g_np_list);
 static DEFINE_SPINLOCK(tiqn_lock);
-static DEFINE_SPINLOCK(np_lock);
+static DEFINE_MUTEX(np_lock);
 
 static struct idr tiqn_idr;
 struct idr sess_idr;
@@ -314,9 +314,9 @@ static struct iscsi_np *iscsit_get_np(
 	struct iscsi_np *np;
 	bool match;
 
-	spin_lock_bh(&np_lock);
+	mutex_lock(&np_lock);
 	list_for_each_entry(np, &g_np_list, np_list) {
-		spin_lock(&np->np_thread_lock);
+		spin_lock_bh(&np->np_thread_lock);
 		if (np->np_thread_state != ISCSI_NP_THREAD_ACTIVE) {
 			spin_unlock(&np->np_thread_lock);
 			continue;
@@ -330,13 +330,13 @@ static struct iscsi_np *iscsit_get_np(
 			 * while iscsi_tpg_add_network_portal() is called.
 			 */
 			np->np_exports++;
-			spin_unlock(&np->np_thread_lock);
-			spin_unlock_bh(&np_lock);
+			spin_unlock_bh(&np->np_thread_lock);
+			mutex_unlock(&np_lock);
 			return np;
 		}
-		spin_unlock(&np->np_thread_lock);
+		spin_unlock_bh(&np->np_thread_lock);
 	}
-	spin_unlock_bh(&np_lock);
+	mutex_unlock(&np_lock);
 
 	return NULL;
 }
@@ -402,9 +402,9 @@ struct iscsi_np *iscsit_add_np(
 	np->np_exports = 1;
 	np->np_thread_state = ISCSI_NP_THREAD_ACTIVE;
 
-	spin_lock_bh(&np_lock);
+	mutex_lock(&np_lock);
 	list_add_tail(&np->np_list, &g_np_list);
-	spin_unlock_bh(&np_lock);
+	mutex_unlock(&np_lock);
 
 	pr_debug("CORE[0] - Added Network Portal: %s:%hu on %s\n",
 		np->np_ip, np->np_port, np->np_transport->name);
@@ -470,9 +470,9 @@ int iscsit_del_np(struct iscsi_np *np)
 
 	np->np_transport->iscsit_free_np(np);
 
-	spin_lock_bh(&np_lock);
+	mutex_lock(&np_lock);
 	list_del(&np->np_list);
-	spin_unlock_bh(&np_lock);
+	mutex_unlock(&np_lock);
 
 	pr_debug("CORE[0] - Removed Network Portal: %s:%hu on %s\n",
 		np->np_ip, np->np_port, np->np_transport->name);
-- 
1.7.1

