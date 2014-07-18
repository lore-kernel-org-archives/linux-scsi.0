From: Alexander Gordeev <agordeev@redhat.com>
Subject: [PATCH RFC 2/2] percpu_tags: Use percpu_tags instead of percpu_ida
Date: Fri, 18 Jul 2014 12:20:58 +0200
Message-ID: <142c07f0d2051ad1cc485af588de6e0c31417833.1405678629.git.agordeev@redhat.com>
References: <cover.1405678629.git.agordeev@redhat.com>
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <cover.1405678629.git.agordeev@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
To: linux-kernel@vger.kernel.org
Cc: Alexander Gordeev <agordeev@redhat.com>, linux-scsi@vger.kernel.org, qla2xxx-upstream@qlogic.com, Nicholas Bellinger <nab@daterainc.com>, Kent Overstreet <kmo@daterainc.com>, "Michael S. Tsirkin" <mst@redhat.com>
List-Id: linux-scsi@vger.kernel.org

All users of "percpu_ida" are blindly converted to
"percpu_tags" users. No testing has been conducted.

Signed-off-by: Alexander Gordeev <agordeev@redhat.com>
Cc: linux-scsi@vger.kernel.org
Cc: qla2xxx-upstream@qlogic.com
Cc: Nicholas Bellinger <nab@daterainc.com>
Cc: Kent Overstreet <kmo@daterainc.com>
Cc: "Michael S. Tsirkin" <mst@redhat.com>
---
 drivers/scsi/qla2xxx/qla_target.c        |    6 +++---
 drivers/target/iscsi/iscsi_target_util.c |    6 +++---
 drivers/target/target_core_transport.c   |    4 ++--
 drivers/target/tcm_fc/tfc_cmd.c          |    8 ++++----
 drivers/vhost/scsi.c                     |    6 +++---
 include/target/target_core_base.h        |    4 ++--
 6 files changed, 17 insertions(+), 17 deletions(-)

diff --git a/drivers/scsi/qla2xxx/qla_target.c b/drivers/scsi/qla2xxx/qla_target.c
index e632e14..cec4847 100644
--- a/drivers/scsi/qla2xxx/qla_target.c
+++ b/drivers/scsi/qla2xxx/qla_target.c
@@ -2729,7 +2729,7 @@ void qlt_free_cmd(struct qla_tgt_cmd *cmd)
 		WARN_ON(1);
 		return;
 	}
-	percpu_ida_free(&sess->se_sess->sess_tag_pool, cmd->se_cmd.map_tag);
+	percpu_tags_free(&sess->se_sess->sess_tag_pool, cmd->se_cmd.map_tag);
 }
 EXPORT_SYMBOL(qlt_free_cmd);
 
@@ -3153,7 +3153,7 @@ out_term:
 	 */
 	spin_lock_irqsave(&ha->hardware_lock, flags);
 	qlt_send_term_exchange(vha, NULL, &cmd->atio, 1);
-	percpu_ida_free(&sess->se_sess->sess_tag_pool, cmd->se_cmd.map_tag);
+	percpu_tags_free(&sess->se_sess->sess_tag_pool, cmd->se_cmd.map_tag);
 	ha->tgt.tgt_ops->put_sess(sess);
 	spin_unlock_irqrestore(&ha->hardware_lock, flags);
 }
@@ -3173,7 +3173,7 @@ static struct qla_tgt_cmd *qlt_get_tag(scsi_qla_host_t *vha,
 	struct qla_tgt_cmd *cmd;
 	int tag;
 
-	tag = percpu_ida_alloc(&se_sess->sess_tag_pool, TASK_RUNNING);
+	tag = percpu_tags_alloc(&se_sess->sess_tag_pool, TASK_RUNNING);
 	if (tag < 0)
 		return NULL;
 
diff --git a/drivers/target/iscsi/iscsi_target_util.c b/drivers/target/iscsi/iscsi_target_util.c
index fd90b28..f76729e 100644
--- a/drivers/target/iscsi/iscsi_target_util.c
+++ b/drivers/target/iscsi/iscsi_target_util.c
@@ -17,7 +17,7 @@
  ******************************************************************************/
 
 #include <linux/list.h>
-#include <linux/percpu_ida.h>
+#include <linux/percpu_tags.h>
 #include <scsi/scsi_tcq.h>
 #include <scsi/iscsi_proto.h>
 #include <target/target_core_base.h>
@@ -158,7 +158,7 @@ struct iscsi_cmd *iscsit_allocate_cmd(struct iscsi_conn *conn, int state)
 	struct se_session *se_sess = conn->sess->se_sess;
 	int size, tag;
 
-	tag = percpu_ida_alloc(&se_sess->sess_tag_pool, state);
+	tag = percpu_tags_alloc(&se_sess->sess_tag_pool, state);
 	if (tag < 0)
 		return NULL;
 
@@ -701,7 +701,7 @@ void iscsit_release_cmd(struct iscsi_cmd *cmd)
 	kfree(cmd->iov_data);
 	kfree(cmd->text_in_ptr);
 
-	percpu_ida_free(&sess->se_sess->sess_tag_pool, se_cmd->map_tag);
+	percpu_tags_free(&sess->se_sess->sess_tag_pool, se_cmd->map_tag);
 }
 EXPORT_SYMBOL(iscsit_release_cmd);
 
diff --git a/drivers/target/target_core_transport.c b/drivers/target/target_core_transport.c
index 7fa62fc..5c7f6f4 100644
--- a/drivers/target/target_core_transport.c
+++ b/drivers/target/target_core_transport.c
@@ -272,7 +272,7 @@ int transport_alloc_session_tags(struct se_session *se_sess,
 		}
 	}
 
-	rc = percpu_ida_init(&se_sess->sess_tag_pool, tag_num);
+	rc = percpu_tags_init(&se_sess->sess_tag_pool, tag_num);
 	if (rc < 0) {
 		pr_err("Unable to init se_sess->sess_tag_pool,"
 			" tag_num: %u\n", tag_num);
@@ -445,7 +445,7 @@ EXPORT_SYMBOL(transport_deregister_session_configfs);
 void transport_free_session(struct se_session *se_sess)
 {
 	if (se_sess->sess_cmd_map) {
-		percpu_ida_destroy(&se_sess->sess_tag_pool);
+		percpu_tags_destroy(&se_sess->sess_tag_pool);
 		if (is_vmalloc_addr(se_sess->sess_cmd_map))
 			vfree(se_sess->sess_cmd_map);
 		else
diff --git a/drivers/target/tcm_fc/tfc_cmd.c b/drivers/target/tcm_fc/tfc_cmd.c
index be0c0d0..6176c92 100644
--- a/drivers/target/tcm_fc/tfc_cmd.c
+++ b/drivers/target/tcm_fc/tfc_cmd.c
@@ -28,7 +28,7 @@
 #include <linux/configfs.h>
 #include <linux/ctype.h>
 #include <linux/hash.h>
-#include <linux/percpu_ida.h>
+#include <linux/percpu_tags.h>
 #include <asm/unaligned.h>
 #include <scsi/scsi.h>
 #include <scsi/scsi_host.h>
@@ -100,7 +100,7 @@ static void ft_free_cmd(struct ft_cmd *cmd)
 	if (fr_seq(fp))
 		lport->tt.seq_release(fr_seq(fp));
 	fc_frame_free(fp);
-	percpu_ida_free(&sess->se_sess->sess_tag_pool, cmd->se_cmd.map_tag);
+	percpu_tags_free(&sess->se_sess->sess_tag_pool, cmd->se_cmd.map_tag);
 	ft_sess_put(sess);	/* undo get from lookup at recv */
 }
 
@@ -456,7 +456,7 @@ static void ft_recv_cmd(struct ft_sess *sess, struct fc_frame *fp)
 	struct se_session *se_sess = sess->se_sess;
 	int tag;
 
-	tag = percpu_ida_alloc(&se_sess->sess_tag_pool, TASK_RUNNING);
+	tag = percpu_tags_alloc(&se_sess->sess_tag_pool, TASK_RUNNING);
 	if (tag < 0)
 		goto busy;
 
@@ -467,7 +467,7 @@ static void ft_recv_cmd(struct ft_sess *sess, struct fc_frame *fp)
 	cmd->sess = sess;
 	cmd->seq = lport->tt.seq_assign(lport, fp);
 	if (!cmd->seq) {
-		percpu_ida_free(&se_sess->sess_tag_pool, tag);
+		percpu_tags_free(&se_sess->sess_tag_pool, tag);
 		goto busy;
 	}
 	cmd->req_frame = fp;		/* hold frame during cmd */
diff --git a/drivers/vhost/scsi.c b/drivers/vhost/scsi.c
index 69906ca..30dd962 100644
--- a/drivers/vhost/scsi.c
+++ b/drivers/vhost/scsi.c
@@ -48,7 +48,7 @@
 #include <linux/virtio_scsi.h>
 #include <linux/llist.h>
 #include <linux/bitmap.h>
-#include <linux/percpu_ida.h>
+#include <linux/percpu_tags.h>
 
 #include "vhost.h"
 
@@ -472,7 +472,7 @@ static void tcm_vhost_release_cmd(struct se_cmd *se_cmd)
 	}
 
 	tcm_vhost_put_inflight(tv_cmd->inflight);
-	percpu_ida_free(&se_sess->sess_tag_pool, se_cmd->map_tag);
+	percpu_tags_free(&se_sess->sess_tag_pool, se_cmd->map_tag);
 }
 
 static int tcm_vhost_shutdown_session(struct se_session *se_sess)
@@ -739,7 +739,7 @@ vhost_scsi_get_tag(struct vhost_virtqueue *vq, struct tcm_vhost_tpg *tpg,
 	}
 	se_sess = tv_nexus->tvn_se_sess;
 
-	tag = percpu_ida_alloc(&se_sess->sess_tag_pool, TASK_RUNNING);
+	tag = percpu_tags_alloc(&se_sess->sess_tag_pool, TASK_RUNNING);
 	if (tag < 0) {
 		pr_err("Unable to obtain tag for tcm_vhost_cmd\n");
 		return ERR_PTR(-ENOMEM);
diff --git a/include/target/target_core_base.h b/include/target/target_core_base.h
index 9ec9864..fd06ecf 100644
--- a/include/target/target_core_base.h
+++ b/include/target/target_core_base.h
@@ -5,7 +5,7 @@
 #include <linux/configfs.h>
 #include <linux/dma-mapping.h>
 #include <linux/blkdev.h>
-#include <linux/percpu_ida.h>
+#include <linux/percpu_tags.h>
 #include <scsi/scsi_cmnd.h>
 #include <net/sock.h>
 #include <net/tcp.h>
@@ -620,7 +620,7 @@ struct se_session {
 	spinlock_t		sess_cmd_lock;
 	struct kref		sess_kref;
 	void			*sess_cmd_map;
-	struct percpu_ida	sess_tag_pool;
+	struct percpu_tags	sess_tag_pool;
 };
 
 struct se_device;
-- 
1.7.7.6
