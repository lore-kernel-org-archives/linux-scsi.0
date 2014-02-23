From: Sagi Grimberg <sagig@mellanox.com>
Subject: [PATCH 06/11] IB/iser: Introduce pi_enable, pi_guard module parameters
Date: Sun, 23 Feb 2014 14:19:29 +0200
Message-ID: <1393157974-24931-7-git-send-email-sagig@mellanox.com>
References: <1393157974-24931-1-git-send-email-sagig@mellanox.com>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mailp.voltaire.com ([193.47.165.129]:57211 "EHLO mellanox.co.il"
	rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org with ESMTP
	id S1751268AbaBWMTm (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Sun, 23 Feb 2014 07:19:42 -0500
In-Reply-To: <1393157974-24931-1-git-send-email-sagig@mellanox.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: roland@kernel.org, nab@linux-iscsi.org
Cc: oren@mellanox.com, martin.petersen@oracle.com, michaelc@cs.wisc.edu, linux-scsi@vger.kernel.org, linux-rdma@vger.kernel.org

Use modparams to activate protection information support.

pi_enable bool: Based on this parameter iSER will know
if it should support T10-PI. We don't want to do this by
default as it requires to allocate and initiatlize extra
resources. In case pi_enable=N, iSER won't publish to
SCSI midlayer any DIF capabilities.

pi_guard int: Based on this parameter iSER will publish
DIX guard type support to SCSI midlayer. 0 means CRC is
allowed to be passed in DIX buffers, 1 (or non-zero)
means IP-CSUM is allowed to be passed in DIX buffers.
Note that over the wire, only CRC is allowed.

In the next phase, it is worth considering passing these
parameters from iscsid via nlmsg. This will allow these
parameters to be connection based rather than global.

Signed-off-by: Sagi Grimberg <sagig@mellanox.com>
---
 drivers/infiniband/ulp/iser/iscsi_iser.c |    8 ++++++++
 drivers/infiniband/ulp/iser/iscsi_iser.h |    3 +++
 drivers/infiniband/ulp/iser/iser_verbs.c |    3 +++
 3 files changed, 14 insertions(+), 0 deletions(-)

diff --git a/drivers/infiniband/ulp/iser/iscsi_iser.c b/drivers/infiniband/ulp/iser/iscsi_iser.c
index dd03cfe..cfa952e 100644
--- a/drivers/infiniband/ulp/iser/iscsi_iser.c
+++ b/drivers/infiniband/ulp/iser/iscsi_iser.c
@@ -82,6 +82,8 @@ static unsigned int iscsi_max_lun = 512;
 module_param_named(max_lun, iscsi_max_lun, uint, S_IRUGO);
 
 int iser_debug_level = 0;
+bool iser_pi_enable = false;
+int iser_pi_guard = 0;
 
 MODULE_DESCRIPTION("iSER (iSCSI Extensions for RDMA) Datamover");
 MODULE_LICENSE("Dual BSD/GPL");
@@ -91,6 +93,12 @@ MODULE_VERSION(DRV_VER);
 module_param_named(debug_level, iser_debug_level, int, 0644);
 MODULE_PARM_DESC(debug_level, "Enable debug tracing if > 0 (default:disabled)");
 
+module_param_named(pi_enable, iser_pi_enable, bool, 0644);
+MODULE_PARM_DESC(pi_enable, "Enable T10-PI offload support (default:disabled)");
+
+module_param_named(pi_guard, iser_pi_guard, int, 0644);
+MODULE_PARM_DESC(pi_guard, "T10-PI guard_type, 0:CRC|1:IP_CSUM (default:CRC)");
+
 struct iser_global ig;
 
 void
diff --git a/drivers/infiniband/ulp/iser/iscsi_iser.h b/drivers/infiniband/ulp/iser/iscsi_iser.h
index 5f7dbfd..76b2124 100644
--- a/drivers/infiniband/ulp/iser/iscsi_iser.h
+++ b/drivers/infiniband/ulp/iser/iscsi_iser.h
@@ -317,6 +317,7 @@ struct iser_conn {
 	unsigned int 		     rx_desc_head;
 	struct iser_rx_desc	     *rx_descs;
 	struct ib_recv_wr	     rx_wr[ISER_MIN_POSTED_RX];
+	bool			     pi_support;
 
 	/* Connection memory registration pool */
 	union {
@@ -371,6 +372,8 @@ struct iser_global {
 
 extern struct iser_global ig;
 extern int iser_debug_level;
+extern bool iser_pi_enable;
+extern int iser_pi_guard;
 
 /* allocate connection resources needed for rdma functionality */
 int iser_conn_set_full_featured_mode(struct iscsi_conn *conn);
diff --git a/drivers/infiniband/ulp/iser/iser_verbs.c b/drivers/infiniband/ulp/iser/iser_verbs.c
index fd32d63..94f967c 100644
--- a/drivers/infiniband/ulp/iser/iser_verbs.c
+++ b/drivers/infiniband/ulp/iser/iser_verbs.c
@@ -757,6 +757,9 @@ int iser_connect(struct iser_conn   *ib_conn,
 
 	ib_conn->state = ISER_CONN_PENDING;
 
+	/* connection T10-PI support */
+	ib_conn->pi_support = iser_pi_enable;
+
 	iser_conn_get(ib_conn); /* ref ib conn's cma id */
 	ib_conn->cma_id = rdma_create_id(iser_cma_handler,
 					     (void *)ib_conn,
-- 
1.7.1

