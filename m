From: "Nicholas A. Bellinger" <nab@linux-iscsi.org>
Subject: [RFC-v4 2/9] iscsi-target: Add iscsit_transport API template
Date: Fri, 12 Apr 2013 20:52:35 +0000
Message-ID: <1365799962-13543-3-git-send-email-nab@linux-iscsi.org>
References: <1365799962-13543-1-git-send-email-nab@linux-iscsi.org>
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <1365799962-13543-1-git-send-email-nab@linux-iscsi.org>
Sender: linux-kernel-owner@vger.kernel.org
To: target-devel <target-devel@vger.kernel.org>
Cc: linux-rdma <linux-rdma@vger.kernel.org>, linux-scsi <linux-scsi@vger.kernel.org>, linux-kernel <linux-kernel@vger.kernel.org>, Roland Dreier <roland@kernel.org>, Or Gerlitz <ogerlitz@mellanox.com>, Alexander Nezhinsky <alexandern@mellanox.com>, Nicholas Bellinger <nab@linux-iscsi.org>
List-Id: linux-scsi@vger.kernel.org

From: Nicholas Bellinger <nab@linux-iscsi.org>

Add basic struct iscsit_transport API template to allow iscsi-target for
running with external transport modules using existing iscsi_target_core.h
code.

For all external modules, this calls try_module_get() and module_put()
to obtain + release an external iscsit_transport module reference count.

Also include the iscsi-target symbols necessary in iscsi_transport.h to
allow external transport modules to function.

v3 changes:
- Add iscsit_build_reject export for ISTATE_SEND_REJECT usage

v2 changes:

- Drop unnecessary export of iscsit_get_transport + iscsit_put_transport (roland)
- Add ->iscsit_queue_data_in() to remove extra context switch on RDMA_WRITE
- Add ->iscsit_queue_status() to remove extra context switch on IB_SEND status
- Add ->iscsit_get_dataout() to remove extra context switch on RDMA_READ
- Drop ->iscsit_free_cmd()
- Drop ->iscsit_unmap_cmd()
- Rename iscsit_create_transport() -> iscsit_register_transport() (andy)
- Rename iscsit_destroy_transport() -> iscsit_unregister_transport() (andy)

Signed-off-by: Nicholas Bellinger <nab@linux-iscsi.org>
---
 drivers/target/iscsi/Makefile                 |    3 +-
 drivers/target/iscsi/iscsi_target_transport.c |   55 ++++++++++++++++
 include/target/iscsi/iscsi_transport.h        |   83 +++++++++++++++++++++++++
 3 files changed, 140 insertions(+), 1 deletions(-)
 create mode 100644 drivers/target/iscsi/iscsi_target_transport.c
 create mode 100644 include/target/iscsi/iscsi_transport.h

diff --git a/drivers/target/iscsi/Makefile b/drivers/target/iscsi/Makefile
index 5b9a2cf..13a9240 100644
--- a/drivers/target/iscsi/Makefile
+++ b/drivers/target/iscsi/Makefile
@@ -15,6 +15,7 @@ iscsi_target_mod-y +=		iscsi_target_parameters.o \
 				iscsi_target_util.o \
 				iscsi_target.o \
 				iscsi_target_configfs.o \
-				iscsi_target_stat.o
+				iscsi_target_stat.o \
+				iscsi_target_transport.o
 
 obj-$(CONFIG_ISCSI_TARGET)	+= iscsi_target_mod.o
diff --git a/drivers/target/iscsi/iscsi_target_transport.c b/drivers/target/iscsi/iscsi_target_transport.c
new file mode 100644
index 0000000..882728f
--- /dev/null
+++ b/drivers/target/iscsi/iscsi_target_transport.c
@@ -0,0 +1,55 @@
+#include <linux/spinlock.h>
+#include <linux/list.h>
+#include <target/iscsi/iscsi_transport.h>
+
+static LIST_HEAD(g_transport_list);
+static DEFINE_MUTEX(transport_mutex);
+
+struct iscsit_transport *iscsit_get_transport(int type)
+{
+	struct iscsit_transport *t;
+
+	mutex_lock(&transport_mutex);
+	list_for_each_entry(t, &g_transport_list, t_node) {
+		if (t->transport_type == type) {
+			if (t->owner && !try_module_get(t->owner)) {
+				t = NULL;
+			}
+			mutex_unlock(&transport_mutex);
+			return t;
+		}
+	}
+	mutex_unlock(&transport_mutex);
+
+	return NULL;
+}
+
+void iscsit_put_transport(struct iscsit_transport *t)
+{
+	if (t->owner)
+		module_put(t->owner);
+}
+
+int iscsit_register_transport(struct iscsit_transport *t)
+{
+	INIT_LIST_HEAD(&t->t_node);
+
+	mutex_lock(&transport_mutex);
+	list_add_tail(&t->t_node, &g_transport_list);
+	mutex_unlock(&transport_mutex);
+
+	pr_debug("Registered iSCSI transport: %s\n", t->name);
+
+	return 0;
+}
+EXPORT_SYMBOL(iscsit_register_transport);
+
+void iscsit_unregister_transport(struct iscsit_transport *t)
+{
+	mutex_lock(&transport_mutex);
+	list_del(&t->t_node);
+	mutex_unlock(&transport_mutex);
+
+	pr_debug("Unregistered iSCSI transport: %s\n", t->name);
+}
+EXPORT_SYMBOL(iscsit_unregister_transport);
diff --git a/include/target/iscsi/iscsi_transport.h b/include/target/iscsi/iscsi_transport.h
new file mode 100644
index 0000000..23a87d0
--- /dev/null
+++ b/include/target/iscsi/iscsi_transport.h
@@ -0,0 +1,83 @@
+#include <linux/module.h>
+#include <linux/list.h>
+#include "../../../drivers/target/iscsi/iscsi_target_core.h"
+
+struct iscsit_transport {
+#define ISCSIT_TRANSPORT_NAME	16
+	char name[ISCSIT_TRANSPORT_NAME];
+	int transport_type;
+	struct module *owner;
+	struct list_head t_node;
+	int (*iscsit_setup_np)(struct iscsi_np *, struct __kernel_sockaddr_storage *);
+	int (*iscsit_accept_np)(struct iscsi_np *, struct iscsi_conn *);
+	void (*iscsit_free_np)(struct iscsi_np *);
+	void (*iscsit_free_conn)(struct iscsi_conn *);
+	struct iscsi_cmd *(*iscsit_alloc_cmd)(struct iscsi_conn *, gfp_t);
+	int (*iscsit_get_login_rx)(struct iscsi_conn *, struct iscsi_login *);
+	int (*iscsit_put_login_tx)(struct iscsi_conn *, struct iscsi_login *, u32);
+	int (*iscsit_immediate_queue)(struct iscsi_conn *, struct iscsi_cmd *, int);
+	int (*iscsit_response_queue)(struct iscsi_conn *, struct iscsi_cmd *, int);
+	int (*iscsit_get_dataout)(struct iscsi_conn *, struct iscsi_cmd *, bool);
+	int (*iscsit_queue_data_in)(struct iscsi_conn *, struct iscsi_cmd *);
+	int (*iscsit_queue_status)(struct iscsi_conn *, struct iscsi_cmd *);
+};
+
+/*
+ * From iscsi_target_transport.c
+ */
+
+extern int iscsit_register_transport(struct iscsit_transport *);
+extern void iscsit_unregister_transport(struct iscsit_transport *);
+extern struct iscsit_transport *iscsit_get_transport(int);
+extern void iscsit_put_transport(struct iscsit_transport *);
+
+/*
+ * From iscsi_target.c
+ */
+extern int iscsit_add_reject_from_cmd(u8, int, int, unsigned char *,
+				struct iscsi_cmd *);
+extern int iscsit_setup_scsi_cmd(struct iscsi_conn *, struct iscsi_cmd *,
+				unsigned char *);
+extern void iscsit_set_unsoliticed_dataout(struct iscsi_cmd *);
+extern int iscsit_process_scsi_cmd(struct iscsi_conn *, struct iscsi_cmd *,
+				struct iscsi_scsi_req *);
+extern int iscsit_check_dataout_hdr(struct iscsi_conn *, unsigned char *,
+				struct iscsi_cmd **);
+extern int iscsit_check_dataout_payload(struct iscsi_cmd *, struct iscsi_data *,
+				bool);
+extern int iscsit_handle_nop_out(struct iscsi_conn *, struct iscsi_cmd *,
+				unsigned char *);
+extern int iscsit_handle_logout_cmd(struct iscsi_conn *, struct iscsi_cmd *,
+				unsigned char *);
+extern int iscsit_handle_task_mgt_cmd(struct iscsi_conn *, struct iscsi_cmd *,
+				unsigned char *);
+extern void iscsit_build_rsp_pdu(struct iscsi_cmd *, struct iscsi_conn *,
+				bool, struct iscsi_scsi_rsp *);
+extern void iscsit_build_nopin_rsp(struct iscsi_cmd *, struct iscsi_conn *,
+				struct iscsi_nopin *, bool);
+extern void iscsit_build_task_mgt_rsp(struct iscsi_cmd *, struct iscsi_conn *,
+				struct iscsi_tm_rsp *);
+extern void iscsit_build_reject(struct iscsi_cmd *, struct iscsi_conn *,
+				struct iscsi_reject *);
+extern int iscsit_build_logout_rsp(struct iscsi_cmd *, struct iscsi_conn *,
+				struct iscsi_logout_rsp *);
+extern int iscsit_logout_post_handler(struct iscsi_cmd *, struct iscsi_conn *);
+/*
+ * From iscsi_target_device.c
+ */
+extern void iscsit_increment_maxcmdsn(struct iscsi_cmd *, struct iscsi_session *);
+/*
+ * From iscsi_target_erl1.c
+ */
+extern void iscsit_stop_dataout_timer(struct iscsi_cmd *);
+
+/*
+ * From iscsi_target_tmr.c
+ */
+extern int iscsit_tmr_post_handler(struct iscsi_cmd *, struct iscsi_conn *);
+
+/*
+ * From iscsi_target_util.c
+ */
+extern struct iscsi_cmd *iscsit_allocate_cmd(struct iscsi_conn *, gfp_t);
+extern int iscsit_sequence_cmd(struct iscsi_conn *, struct iscsi_cmd *, __be32);
-- 
1.7.2.5
