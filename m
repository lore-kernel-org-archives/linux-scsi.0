From: Andy Grover <agrover@redhat.com>
Subject: [PATCH 1/3] target/iscsi: Set np_thread_state to ACTIVE before adding to g_np_list
Date: Fri, 24 Jan 2014 16:18:54 -0800
Message-ID: <1390609136-28674-2-git-send-email-agrover@redhat.com>
References: <1390609136-28674-1-git-send-email-agrover@redhat.com>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:57657 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751153AbaAYATL (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Fri, 24 Jan 2014 19:19:11 -0500
In-Reply-To: <1390609136-28674-1-git-send-email-agrover@redhat.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: target-devel@vger.kernel.org
Cc: linux-scsi@vger.kernel.org

When creating network portals rapidly, such as when restoring a
configuration, LIO's code to reuse existing portals can return a false
negative if the thread hasn't run yet and set np_thread_state to
ISCSI_NP_THREAD_ACTIVE. This causes an error in the network stack
when attempting to bind to the same address/port.

This patch sets NP_THREAD_ACTIVE before the np is placed on g_np_list,
so even if the thread hasn't run yet, iscsit_get_np will return the
existing np.

Signed-off-by: Andy Grover <agrover@redhat.com>
---
 drivers/target/iscsi/iscsi_target.c |    1 +
 1 files changed, 1 insertions(+), 0 deletions(-)

diff --git a/drivers/target/iscsi/iscsi_target.c b/drivers/target/iscsi/iscsi_target.c
index d70e911..bfd4bf7 100644
--- a/drivers/target/iscsi/iscsi_target.c
+++ b/drivers/target/iscsi/iscsi_target.c
@@ -400,6 +400,7 @@ struct iscsi_np *iscsit_add_np(
 	 * point because iscsi_np has not been added to g_np_list yet.
 	 */
 	np->np_exports = 1;
+	np->np_thread_state = ISCSI_NP_THREAD_ACTIVE;
 
 	spin_lock_bh(&np_lock);
 	list_add_tail(&np->np_list, &g_np_list);
-- 
1.7.1

