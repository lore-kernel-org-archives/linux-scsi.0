From: Andy Grover <agrover@redhat.com>
Subject: [PATCH 3/3] target/iscsi: hold np_lock mutex across adding new net portal to g_np_list
Date: Fri, 24 Jan 2014 16:18:56 -0800
Message-ID: <1390609136-28674-4-git-send-email-agrover@redhat.com>
References: <1390609136-28674-1-git-send-email-agrover@redhat.com>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:56937 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751093AbaAYATM (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Fri, 24 Jan 2014 19:19:12 -0500
In-Reply-To: <1390609136-28674-1-git-send-email-agrover@redhat.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: target-devel@vger.kernel.org
Cc: linux-scsi@vger.kernel.org

This prevents a race where two threads may attempt to create the same
network portal, resulting in one of them failing.

Signed-off-by: Andy Grover <agrover@redhat.com>
---
 drivers/target/iscsi/iscsi_target.c |   14 +++++++++-----
 1 files changed, 9 insertions(+), 5 deletions(-)

diff --git a/drivers/target/iscsi/iscsi_target.c b/drivers/target/iscsi/iscsi_target.c
index 45ec498..4e91586 100644
--- a/drivers/target/iscsi/iscsi_target.c
+++ b/drivers/target/iscsi/iscsi_target.c
@@ -307,6 +307,9 @@ bool iscsit_check_np_match(
 	return false;
 }
 
+/*
+ * Called with mutex np_lock held
+ */
 static struct iscsi_np *iscsit_get_np(
 	struct __kernel_sockaddr_storage *sockaddr,
 	int network_transport)
@@ -314,7 +317,6 @@ static struct iscsi_np *iscsit_get_np(
 	struct iscsi_np *np;
 	bool match;
 
-	mutex_lock(&np_lock);
 	list_for_each_entry(np, &g_np_list, np_list) {
 		spin_lock_bh(&np->np_thread_lock);
 		if (np->np_thread_state != ISCSI_NP_THREAD_ACTIVE) {
@@ -331,12 +333,10 @@ static struct iscsi_np *iscsit_get_np(
 			 */
 			np->np_exports++;
 			spin_unlock_bh(&np->np_thread_lock);
-			mutex_unlock(&np_lock);
 			return np;
 		}
 		spin_unlock_bh(&np->np_thread_lock);
 	}
-	mutex_unlock(&np_lock);
 
 	return NULL;
 }
@@ -350,12 +350,17 @@ struct iscsi_np *iscsit_add_np(
 	struct sockaddr_in6 *sock_in6;
 	struct iscsi_np *np;
 	int ret;
+
+	mutex_lock(&np_lock);
+
 	/*
 	 * Locate the existing struct iscsi_np if already active..
 	 */
 	np = iscsit_get_np(sockaddr, network_transport);
-	if (np)
+	if (np) {
+		mutex_unlock(&np_lock);
 		return np;
+	}
 
 	np = kzalloc(sizeof(struct iscsi_np), GFP_KERNEL);
 	if (!np) {
@@ -402,7 +407,6 @@ struct iscsi_np *iscsit_add_np(
 	np->np_exports = 1;
 	np->np_thread_state = ISCSI_NP_THREAD_ACTIVE;
 
-	mutex_lock(&np_lock);
 	list_add_tail(&np->np_list, &g_np_list);
 	mutex_unlock(&np_lock);
 
-- 
1.7.1

