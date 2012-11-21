From: David Howells <dhowells-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Subject: [PATCH] UAPI: (Scripted) Disintegrate include/rdma
Date: Wed, 21 Nov 2012 15:47:40 +0000
Message-ID: <20121121154740.9777.72384.stgit@warthog.procyon.org.uk>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: dillowda-1Heg1YXhbW8@public.gmane.org, roland-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-scsi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-scsi@vger.kernel.org

Signed-off-by: David Howells <dhowells-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Acked-by: Arnd Bergmann <arnd-r2nGTMty4D4@public.gmane.org>
Acked-by: Thomas Gleixner <tglx-hfZtesqFncYOwBW4kG4KsQ@public.gmane.org>
Acked-by: Michael Kerrisk <mtk.manpages-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Acked-by: Paul E. McKenney <paulmck-23VcF4HTsmIX0ybBhKVfKdBPR1lH4CV8@public.gmane.org>
Acked-by: Dave Jones <davej-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
---

 include/rdma/Kbuild               |    6 ------
 include/rdma/rdma_netlink.h       |   36 +-----------------------------------
 include/uapi/rdma/Kbuild          |    6 ++++++
 include/uapi/rdma/ib_user_cm.h    |    0 
 include/uapi/rdma/ib_user_mad.h   |    0 
 include/uapi/rdma/ib_user_sa.h    |    0 
 include/uapi/rdma/ib_user_verbs.h |    0 
 include/uapi/rdma/rdma_netlink.h  |   37 +++++++++++++++++++++++++++++++++++++
 include/uapi/rdma/rdma_user_cm.h  |    0 
 9 files changed, 44 insertions(+), 41 deletions(-)
 rename include/{rdma/ib_user_cm.h => uapi/rdma/ib_user_cm.h} (100%)
 rename include/{rdma/ib_user_mad.h => uapi/rdma/ib_user_mad.h} (100%)
 rename include/{rdma/ib_user_sa.h => uapi/rdma/ib_user_sa.h} (100%)
 rename include/{rdma/ib_user_verbs.h => uapi/rdma/ib_user_verbs.h} (100%)
 create mode 100644 include/uapi/rdma/rdma_netlink.h
 rename include/{rdma/rdma_user_cm.h => uapi/rdma/rdma_user_cm.h} (100%)

diff --git a/include/rdma/Kbuild b/include/rdma/Kbuild
index ea56f76..e69de29 100644
--- a/include/rdma/Kbuild
+++ b/include/rdma/Kbuild
@@ -1,6 +0,0 @@
-header-y += ib_user_cm.h
-header-y += ib_user_mad.h
-header-y += ib_user_sa.h
-header-y += ib_user_verbs.h
-header-y += rdma_netlink.h
-header-y += rdma_user_cm.h
diff --git a/include/rdma/rdma_netlink.h b/include/rdma/rdma_netlink.h
index bd3d8b2..e38de79 100644
--- a/include/rdma/rdma_netlink.h
+++ b/include/rdma/rdma_netlink.h
@@ -1,41 +1,9 @@
 #ifndef _RDMA_NETLINK_H
 #define _RDMA_NETLINK_H
 
-#include <linux/types.h>
-
-enum {
-	RDMA_NL_RDMA_CM = 1
-};
-
-#define RDMA_NL_GET_CLIENT(type) ((type & (((1 << 6) - 1) << 10)) >> 10)
-#define RDMA_NL_GET_OP(type) (type & ((1 << 10) - 1))
-#define RDMA_NL_GET_TYPE(client, op) ((client << 10) + op)
-
-enum {
-	RDMA_NL_RDMA_CM_ID_STATS = 0,
-	RDMA_NL_RDMA_CM_NUM_OPS
-};
-
-enum {
-	RDMA_NL_RDMA_CM_ATTR_SRC_ADDR = 1,
-	RDMA_NL_RDMA_CM_ATTR_DST_ADDR,
-	RDMA_NL_RDMA_CM_NUM_ATTR,
-};
-
-struct rdma_cm_id_stats {
-	__u32	qp_num;
-	__u32	bound_dev_if;
-	__u32	port_space;
-	__s32	pid;
-	__u8	cm_state;
-	__u8	node_type;
-	__u8	port_num;
-	__u8	qp_type;
-};
-
-#ifdef __KERNEL__
 
 #include <linux/netlink.h>
+#include <uapi/rdma/rdma_netlink.h>
 
 struct ibnl_client_cbs {
 	int (*dump)(struct sk_buff *skb, struct netlink_callback *nlcb);
@@ -88,6 +56,4 @@ void *ibnl_put_msg(struct sk_buff *skb, struct nlmsghdr **nlh, int seq,
 int ibnl_put_attr(struct sk_buff *skb, struct nlmsghdr *nlh,
 		  int len, void *data, int type);
 
-#endif /* __KERNEL__ */
-
 #endif /* _RDMA_NETLINK_H */
diff --git a/include/uapi/rdma/Kbuild b/include/uapi/rdma/Kbuild
index aafaa5a..687ae33 100644
--- a/include/uapi/rdma/Kbuild
+++ b/include/uapi/rdma/Kbuild
@@ -1 +1,7 @@
 # UAPI Header export list
+header-y += ib_user_cm.h
+header-y += ib_user_mad.h
+header-y += ib_user_sa.h
+header-y += ib_user_verbs.h
+header-y += rdma_netlink.h
+header-y += rdma_user_cm.h
diff --git a/include/rdma/ib_user_cm.h b/include/uapi/rdma/ib_user_cm.h
similarity index 100%
rename from include/rdma/ib_user_cm.h
rename to include/uapi/rdma/ib_user_cm.h
diff --git a/include/rdma/ib_user_mad.h b/include/uapi/rdma/ib_user_mad.h
similarity index 100%
rename from include/rdma/ib_user_mad.h
rename to include/uapi/rdma/ib_user_mad.h
diff --git a/include/rdma/ib_user_sa.h b/include/uapi/rdma/ib_user_sa.h
similarity index 100%
rename from include/rdma/ib_user_sa.h
rename to include/uapi/rdma/ib_user_sa.h
diff --git a/include/rdma/ib_user_verbs.h b/include/uapi/rdma/ib_user_verbs.h
similarity index 100%
rename from include/rdma/ib_user_verbs.h
rename to include/uapi/rdma/ib_user_verbs.h
diff --git a/include/uapi/rdma/rdma_netlink.h b/include/uapi/rdma/rdma_netlink.h
new file mode 100644
index 0000000..8297285
--- /dev/null
+++ b/include/uapi/rdma/rdma_netlink.h
@@ -0,0 +1,37 @@
+#ifndef _UAPI_RDMA_NETLINK_H
+#define _UAPI_RDMA_NETLINK_H
+
+#include <linux/types.h>
+
+enum {
+	RDMA_NL_RDMA_CM = 1
+};
+
+#define RDMA_NL_GET_CLIENT(type) ((type & (((1 << 6) - 1) << 10)) >> 10)
+#define RDMA_NL_GET_OP(type) (type & ((1 << 10) - 1))
+#define RDMA_NL_GET_TYPE(client, op) ((client << 10) + op)
+
+enum {
+	RDMA_NL_RDMA_CM_ID_STATS = 0,
+	RDMA_NL_RDMA_CM_NUM_OPS
+};
+
+enum {
+	RDMA_NL_RDMA_CM_ATTR_SRC_ADDR = 1,
+	RDMA_NL_RDMA_CM_ATTR_DST_ADDR,
+	RDMA_NL_RDMA_CM_NUM_ATTR,
+};
+
+struct rdma_cm_id_stats {
+	__u32	qp_num;
+	__u32	bound_dev_if;
+	__u32	port_space;
+	__s32	pid;
+	__u8	cm_state;
+	__u8	node_type;
+	__u8	port_num;
+	__u8	qp_type;
+};
+
+
+#endif /* _UAPI_RDMA_NETLINK_H */
diff --git a/include/rdma/rdma_user_cm.h b/include/uapi/rdma/rdma_user_cm.h
similarity index 100%
rename from include/rdma/rdma_user_cm.h
rename to include/uapi/rdma/rdma_user_cm.h

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
