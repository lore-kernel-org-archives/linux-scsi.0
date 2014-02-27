From: Sagi Grimberg <sagig-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Subject: [PATCH v1 08/13] IB/iser: Introduce pi_enable, pi_guard module parameters
Date: Thu, 27 Feb 2014 13:13:04 +0200
Message-ID: <1393499589-15633-9-git-send-email-sagig@mellanox.com>
References: <1393499589-15633-1-git-send-email-sagig@mellanox.com>
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1393499589-15633-1-git-send-email-sagig-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: roland-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org, nab-IzHhD5pYlfBP7FQvKIMDCQ@public.gmane.org
Cc: oren-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org, martin.petersen-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org, michaelc-hcNo3dDEHLuVc3sceRu5cw@public.gmane.org, linux-scsi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Alex Tabachnik <alext-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
List-Id: linux-scsi@vger.kernel.org

From: Alex Tabachnik <alext-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>

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

Signed-off-by: Alex Tabachnik <alext-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Signed-off-by: Sagi Grimberg <sagig-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
---
 drivers/infiniband/ulp/iser/iscsi_iser.c |    8 ++++++++
 drivers/infiniband/ulp/iser/iscsi_iser.h |    3 +++
 drivers/infiniband/ulp/iser/iser_verbs.c |   13 +++++++++++++
 3 files changed, 24 insertions(+), 0 deletions(-)

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
index 623defa..011003f 100644
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
index 6a5f424..4c27f55 100644
--- a/drivers/infiniband/ulp/iser/iser_verbs.c
+++ b/drivers/infiniband/ulp/iser/iser_verbs.c
@@ -607,6 +607,19 @@ static int iser_addr_handler(struct rdma_cm_id *cma_id)
 	ib_conn = (struct iser_conn *)cma_id->context;
 	ib_conn->device = device;
 
+	/* connection T10-PI support */
+	if (iser_pi_enable) {
+		if (!(device->dev_attr.device_cap_flags &
+		      IB_DEVICE_SIGNATURE_HANDOVER)) {
+			iser_warn("T10-PI requested but not supported on %s, "
+				  "continue without T10-PI\n",
+				  ib_conn->device->ib_device->name);
+			ib_conn->pi_support = false;
+		} else {
+			ib_conn->pi_support = true;
+		}
+	}
+
 	ret = rdma_resolve_route(cma_id, 1000);
 	if (ret) {
 		iser_err("resolve route failed: %d\n", ret);
-- 
1.7.1

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
