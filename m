From: Sagi Grimberg <sagig-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Subject: [PATCH 05/11] Target/iscsi: Add T10-PI indication for iscsi_portal_group
Date: Thu,  9 Jan 2014 18:40:52 +0200
Message-ID: <1389285658-7037-6-git-send-email-sagig@mellanox.com>
References: <1389285658-7037-1-git-send-email-sagig@mellanox.com>
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1389285658-7037-1-git-send-email-sagig-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: target-devel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
Cc: linux-scsi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, martin.petersen-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org, nab-IzHhD5pYlfBP7FQvKIMDCQ@public.gmane.org, ogerlitz-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org, oren-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org
List-Id: linux-scsi@vger.kernel.org

In case an iscsi portal group will be defined as t10_pi enabled,
all connections on top of it will support protected transactions.

T10-PI support may require extra reource allocation and maintenance by
the transport layer, so we don't want to apply them on non-t10_pi network
portals. This is a hook for the iscsi target layer to signal the transport
at connection establishment that this connection will carry protected
transactions.

Signed-off-by: Sagi Grimberg <sagig-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
---
 drivers/target/iscsi/iscsi_target_core.h |    5 ++++-
 drivers/target/iscsi/iscsi_target_tpg.c  |    2 ++
 2 files changed, 6 insertions(+), 1 deletions(-)

diff --git a/drivers/target/iscsi/iscsi_target_core.h b/drivers/target/iscsi/iscsi_target_core.h
index 48f7b3b..886d74d 100644
--- a/drivers/target/iscsi/iscsi_target_core.h
+++ b/drivers/target/iscsi/iscsi_target_core.h
@@ -58,7 +58,8 @@
 #define TA_DEMO_MODE_DISCOVERY		1
 #define TA_DEFAULT_ERL			0
 #define TA_CACHE_CORE_NPS		0
-
+/* T10 protection information disabled by default */
+#define TA_DEFAULT_T10_PI		0
 
 #define ISCSI_IOV_DATA_BUFFER		5
 
@@ -765,6 +766,7 @@ struct iscsi_tpg_attrib {
 	u32			prod_mode_write_protect;
 	u32			demo_mode_discovery;
 	u32			default_erl;
+	u8			t10_pi;
 	struct iscsi_portal_group *tpg;
 };
 
@@ -787,6 +789,7 @@ struct iscsi_np {
 	void			*np_context;
 	struct iscsit_transport *np_transport;
 	struct list_head	np_list;
+	struct iscsi_tpg_np	*tpg_np;
 } ____cacheline_aligned;
 
 struct iscsi_tpg_np {
diff --git a/drivers/target/iscsi/iscsi_target_tpg.c b/drivers/target/iscsi/iscsi_target_tpg.c
index 3976183..80ae14c 100644
--- a/drivers/target/iscsi/iscsi_target_tpg.c
+++ b/drivers/target/iscsi/iscsi_target_tpg.c
@@ -225,6 +225,7 @@ static void iscsit_set_default_tpg_attribs(struct iscsi_portal_group *tpg)
 	a->prod_mode_write_protect = TA_PROD_MODE_WRITE_PROTECT;
 	a->demo_mode_discovery = TA_DEMO_MODE_DISCOVERY;
 	a->default_erl = TA_DEFAULT_ERL;
+	a->t10_pi = TA_DEFAULT_T10_PI;
 }
 
 int iscsit_tpg_add_portal_group(struct iscsi_tiqn *tiqn, struct iscsi_portal_group *tpg)
@@ -500,6 +501,7 @@ struct iscsi_tpg_np *iscsit_tpg_add_network_portal(
 	init_completion(&tpg_np->tpg_np_comp);
 	kref_init(&tpg_np->tpg_np_kref);
 	tpg_np->tpg_np		= np;
+	np->tpg_np		= tpg_np;
 	tpg_np->tpg		= tpg;
 
 	spin_lock(&tpg->tpg_np_lock);
-- 
1.7.1

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
