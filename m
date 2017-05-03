From: "Nicholas A. Bellinger" <nab@linux-iscsi.org>
Subject: [PATCH 3/3] target: Don't force session reset if queue_depth does not change
Date: Wed,  3 May 2017 06:13:36 +0000
Message-ID: <1493792016-6435-4-git-send-email-nab@linux-iscsi.org>
References: <1493792016-6435-1-git-send-email-nab@linux-iscsi.org>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail.linux-iscsi.org ([67.23.28.174]:42696 "EHLO
        linux-iscsi.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751866AbdECGMH (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Wed, 3 May 2017 02:12:07 -0400
In-Reply-To: <1493792016-6435-1-git-send-email-nab@linux-iscsi.org>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: target-devel <target-devel@vger.kernel.org>
Cc: linux-scsi <linux-scsi@vger.kernel.org>, lkml <linux-kernel@vger.kernel.org>, Gary Guo <ghg@datera.io>, Bill Borsari <wgb@datera.io>, Raghu Krishnamurthy <rk@datera.io>, Nicholas Bellinger <nab@linux-iscsi.org>

From: Nicholas Bellinger <nab@linux-iscsi.org>

Keeping in the idempotent nature of target_core_fabric_configfs.c,
if a queue_depth value is set and it's the same as the existing
value, don't attempt to force session reinstatement.

Reported-by: Raghu Krishnamurthy <rk@datera.io>
Cc: Raghu Krishnamurthy <rk@datera.io>
Tested-by: Gary Guo <ghg@datera.io>
Cc: Gary Guo <ghg@datera.io>
Signed-off-by: Nicholas Bellinger <nab@linux-iscsi.org>
---
 drivers/target/target_core_tpg.c | 7 +++++++
 1 file changed, 7 insertions(+)

diff --git a/drivers/target/target_core_tpg.c b/drivers/target/target_core_tpg.c
index dfaef4d..310d9e5 100644
--- a/drivers/target/target_core_tpg.c
+++ b/drivers/target/target_core_tpg.c
@@ -398,6 +398,13 @@ int core_tpg_set_initiator_node_queue_depth(
 	struct se_portal_group *tpg = acl->se_tpg;
 
 	/*
+	 * Allow the setting of se_node_acl queue_depth to be idempotent,
+	 * and not force a session shutdown event if the value is not
+	 * changing.
+	 */
+	if (acl->queue_depth == queue_depth)
+		return 0;
+	/*
 	 * User has requested to change the queue depth for a Initiator Node.
 	 * Change the value in the Node's struct se_node_acl, and call
 	 * target_set_nacl_queue_depth() to set the new queue depth.
-- 
1.9.1
