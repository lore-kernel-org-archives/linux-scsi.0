From: "Nicholas A. Bellinger" <nab@linux-iscsi.org>
Subject: [PATCH 5/9] ib_srpt: Fix sport->port_guid formatting code
Date: Mon, 24 Oct 2011 05:33:38 +0000
Message-ID: <1319434422-15354-6-git-send-email-nab@linux-iscsi.org>
References: <1319434422-15354-1-git-send-email-nab@linux-iscsi.org>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail.linux-iscsi.org ([67.23.28.174]:59576 "EHLO
	linux-iscsi.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753202Ab1JXFf0 (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Mon, 24 Oct 2011 01:35:26 -0400
In-Reply-To: <1319434422-15354-1-git-send-email-nab@linux-iscsi.org>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: target-devel <target-devel@vger.kernel.org>, linux-rdma <linux-rdma@vger.kernel.org>
Cc: linux-scsi <linux-scsi@vger.kernel.org>, Roland Dreier <roland@purestorage.com>, Bart Van Assche <bvanassche@acm.org>, Nicholas Bellinger <nab@linux-iscsi.org>

From: Nicholas Bellinger <nab@linux-iscsi.org>

This patch fixes the sport->port_guid formatting code in srpt_add_one() to
properly use sport->gid.global.interface_id instead of device->node_guid w/
a port offset.  This requires using ib_query_gid() from srpt_refresh_port(),
so the sport->port_guid assignment has been moved after srpt_refresh_port().

Reported-by: Bart Van Assche <bvanassche@acm.org>
Cc: Bart Van Assche <bvanassche@acm.org>
Cc: Roland Dreier <roland@purestorage.com>
Signed-off-by: Nicholas A. Bellinger <nab@linux-iscsi.org>
---
 drivers/infiniband/ulp/srpt/ib_srpt.c |    9 +++------
 1 files changed, 3 insertions(+), 6 deletions(-)

diff --git a/drivers/infiniband/ulp/srpt/ib_srpt.c b/drivers/infiniband/ulp/srpt/ib_srpt.c
index 6e19816..ae9fd0e 100644
--- a/drivers/infiniband/ulp/srpt/ib_srpt.c
+++ b/drivers/infiniband/ulp/srpt/ib_srpt.c
@@ -3325,17 +3325,14 @@ static void srpt_add_one(struct ib_device *device)
 		INIT_LIST_HEAD(&sport->port_acl_list);
 		spin_lock_init(&sport->port_acl_lock);
 
-		sprintf(sport->port_guid, "0x0000000000000000%04x%04x%04x%04x",
-                                be16_to_cpu(((__be16 *)&device->node_guid)[0]),
-                                be16_to_cpu(((__be16 *)&device->node_guid)[1]),
-                                be16_to_cpu(((__be16 *)&device->node_guid)[2]),
-                                be16_to_cpu(((__be16 *)&device->node_guid)[3]) + i);
-
 		if (srpt_refresh_port(sport)) {
 			printk(KERN_ERR "MAD registration failed for %s-%d.\n",
 			       srpt_sdev_name(sdev), i);
 			goto err_ring;
 		}
+		snprintf(sport->port_guid, sizeof(sport->port_guid),
+				"0x0000000000000000%016llx",
+				be64_to_cpu(sport->gid.global.interface_id));
 	}
 
 	spin_lock(&srpt_dev_lock);
-- 
1.7.2.5

