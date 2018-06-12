From: Matthew Wilcox <willy@infradead.org>
Subject: [PATCH 2/3] Convert target drivers to use sbitmap
Date: Tue, 12 Jun 2018 12:05:44 -0700
Message-ID: <20180612190545.10781-3-willy@infradead.org>
References: <20180612190545.10781-1-willy@infradead.org>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <linux1394-devel-bounces@lists.sourceforge.net>
In-Reply-To: <20180612190545.10781-1-willy@infradead.org>
List-Unsubscribe: <https://lists.sourceforge.net/lists/options/linux1394-devel>,
 <mailto:linux1394-devel-request@lists.sourceforge.net?subject=unsubscribe>
List-Archive: <http://sourceforge.net/mailarchive/forum.php?forum_name=linux1394-devel>
List-Post: <mailto:linux1394-devel@lists.sourceforge.net>
List-Help: <mailto:linux1394-devel-request@lists.sourceforge.net?subject=help>
List-Subscribe: <https://lists.sourceforge.net/lists/listinfo/linux1394-devel>,
 <mailto:linux1394-devel-request@lists.sourceforge.net?subject=subscribe>
Errors-To: linux1394-devel-bounces@lists.sourceforge.net
To: linux-kernel@vger.kernel.org, linux-scsi@vger.kernel.org, target-devel@vger.kernel.org, linux1394-devel@lists.sourceforge.net, linux-usb@vger.kernel.org, kvm@vger.kernel.org, virtualization@lists.linux-foundation.org, netdev@vger.kernel.org, Juergen Gross <jgross@suse.com>, qla2xxx-upstream@qlogic.com, Kent Overstreet <kent.overstreet@gmail.com>, Jens Axboe <axboe@kernel.dk>
Cc: Matthew Wilcox <willy@infradead.org>
List-Id: linux-scsi@vger.kernel.org

The sbitmap and the percpu_ida perform essentially the same task,
allocating tags for commands.  The sbitmap outperforms the percpu_ida
as documented here: https://lkml.org/lkml/2014/4/22/553

The sbitmap interface is a little harder to use, but being able to
remove the percpu_ida code and getting better performance justifies the
additional complexity.

Signed-off-by: Matthew Wilcox <willy@infradead.org>
Acked-by: Felipe Balbi <felipe.balbi@linux.intel.com>	# f_tcm
---
 drivers/scsi/qla2xxx/qla_target.c        | 10 ++++---
 drivers/target/iscsi/iscsi_target_util.c | 33 +++++++++++++++++++++---
 drivers/target/sbp/sbp_target.c          |  5 ++--
 drivers/target/target_core_transport.c   |  5 ++--
 drivers/target/tcm_fc/tfc_cmd.c          |  6 ++---
 drivers/usb/gadget/function/f_tcm.c      |  5 ++--
 drivers/vhost/scsi.c                     |  6 ++---
 drivers/xen/xen-scsiback.c               |  5 ++--
 include/target/iscsi/iscsi_target_core.h |  1 +
 include/target/target_core_base.h        |  7 ++---
 10 files changed, 59 insertions(+), 24 deletions(-)

diff --git a/drivers/scsi/qla2xxx/qla_target.c b/drivers/scsi/qla2xxx/qla_target.c
index 05290966e630..a1725a054749 100644
--- a/drivers/scsi/qla2xxx/qla_target.c
+++ b/drivers/scsi/qla2xxx/qla_target.c
@@ -4277,9 +4277,9 @@ static struct qla_tgt_cmd *qlt_get_tag(scsi_qla_host_t *vha,
 {
 	struct se_session *se_sess = sess->se_sess;
 	struct qla_tgt_cmd *cmd;
-	int tag;
+	int tag, cpu;
 
-	tag = percpu_ida_alloc(&se_sess->sess_tag_pool, TASK_RUNNING);
+	tag = sbitmap_queue_get(&se_sess->sess_tag_pool, &cpu);
 	if (tag < 0)
 		return NULL;
 
@@ -4292,6 +4292,7 @@ static struct qla_tgt_cmd *qlt_get_tag(scsi_qla_host_t *vha,
 	qlt_incr_num_pend_cmds(vha);
 	cmd->vha = vha;
 	cmd->se_cmd.map_tag = tag;
+	cmd->se_cmd.map_cpu = cpu;
 	cmd->sess = sess;
 	cmd->loop_id = sess->loop_id;
 	cmd->conf_compl_supported = sess->conf_compl_supported;
@@ -5294,7 +5295,7 @@ qlt_alloc_qfull_cmd(struct scsi_qla_host *vha,
 	struct fc_port *sess;
 	struct se_session *se_sess;
 	struct qla_tgt_cmd *cmd;
-	int tag;
+	int tag, cpu;
 	unsigned long flags;
 
 	if (unlikely(tgt->tgt_stop)) {
@@ -5326,7 +5327,7 @@ qlt_alloc_qfull_cmd(struct scsi_qla_host *vha,
 
 	se_sess = sess->se_sess;
 
-	tag = percpu_ida_alloc(&se_sess->sess_tag_pool, TASK_RUNNING);
+	tag = sbitmap_queue_get(&se_sess->sess_tag_pool, &cpu);
 	if (tag < 0)
 		return;
 
@@ -5357,6 +5358,7 @@ qlt_alloc_qfull_cmd(struct scsi_qla_host *vha,
 	cmd->reset_count = ha->base_qpair->chip_reset;
 	cmd->q_full = 1;
 	cmd->qpair = ha->base_qpair;
+	cmd->se_cmd.map_cpu = cpu;
 
 	if (qfull) {
 		cmd->q_full = 1;
diff --git a/drivers/target/iscsi/iscsi_target_util.c b/drivers/target/iscsi/iscsi_target_util.c
index 7e98697cfb8e..8cfcf9033507 100644
--- a/drivers/target/iscsi/iscsi_target_util.c
+++ b/drivers/target/iscsi/iscsi_target_util.c
@@ -17,7 +17,7 @@
  ******************************************************************************/
 
 #include <linux/list.h>
-#include <linux/percpu_ida.h>
+#include <linux/sched/signal.h>
 #include <net/ipv6.h>         /* ipv6_addr_equal() */
 #include <scsi/scsi_tcq.h>
 #include <scsi/iscsi_proto.h>
@@ -147,6 +147,30 @@ void iscsit_free_r2ts_from_list(struct iscsi_cmd *cmd)
 	spin_unlock_bh(&cmd->r2t_lock);
 }
 
+static int iscsit_wait_for_tag(struct se_session *se_sess, int state, int *cpup)
+{
+	int tag = -1;
+	DEFINE_WAIT(wait);
+	struct sbq_wait_state *ws;
+
+	if (state == TASK_RUNNING)
+		return tag;
+
+	ws = &se_sess->sess_tag_pool.ws[0];
+	for (;;) {
+		prepare_to_wait_exclusive(&ws->wait, &wait, state);
+		if (signal_pending_state(state, current))
+			break;
+		tag = sbitmap_queue_get(&se_sess->sess_tag_pool, cpup);
+		if (tag >= 0)
+			break;
+		schedule();
+	}
+
+	finish_wait(&ws->wait, &wait);
+	return tag;
+}
+
 /*
  * May be called from software interrupt (timer) context for allocating
  * iSCSI NopINs.
@@ -155,9 +179,11 @@ struct iscsi_cmd *iscsit_allocate_cmd(struct iscsi_conn *conn, int state)
 {
 	struct iscsi_cmd *cmd;
 	struct se_session *se_sess = conn->sess->se_sess;
-	int size, tag;
+	int size, tag, cpu;
 
-	tag = percpu_ida_alloc(&se_sess->sess_tag_pool, state);
+	tag = sbitmap_queue_get(&se_sess->sess_tag_pool, &cpu);
+	if (tag < 0)
+		tag = iscsit_wait_for_tag(se_sess, state, &cpu);
 	if (tag < 0)
 		return NULL;
 
@@ -166,6 +192,7 @@ struct iscsi_cmd *iscsit_allocate_cmd(struct iscsi_conn *conn, int state)
 	memset(cmd, 0, size);
 
 	cmd->se_cmd.map_tag = tag;
+	cmd->se_cmd.map_cpu = cpu;
 	cmd->conn = conn;
 	cmd->data_direction = DMA_NONE;
 	INIT_LIST_HEAD(&cmd->i_conn_node);
diff --git a/drivers/target/sbp/sbp_target.c b/drivers/target/sbp/sbp_target.c
index 679ae29d25ab..42b21f2ac8b0 100644
--- a/drivers/target/sbp/sbp_target.c
+++ b/drivers/target/sbp/sbp_target.c
@@ -926,15 +926,16 @@ static struct sbp_target_request *sbp_mgt_get_req(struct sbp_session *sess,
 {
 	struct se_session *se_sess = sess->se_sess;
 	struct sbp_target_request *req;
-	int tag;
+	int tag, cpu;
 
-	tag = percpu_ida_alloc(&se_sess->sess_tag_pool, TASK_RUNNING);
+	tag = sbitmap_queue_get(&se_sess->sess_tag_pool, &cpu);
 	if (tag < 0)
 		return ERR_PTR(-ENOMEM);
 
 	req = &((struct sbp_target_request *)se_sess->sess_cmd_map)[tag];
 	memset(req, 0, sizeof(*req));
 	req->se_cmd.map_tag = tag;
+	req->se_cmd.map_cpu = cpu;
 	req->se_cmd.tag = next_orb;
 
 	return req;
diff --git a/drivers/target/target_core_transport.c b/drivers/target/target_core_transport.c
index f0e8f0f4ccb4..18c53c5cdd3d 100644
--- a/drivers/target/target_core_transport.c
+++ b/drivers/target/target_core_transport.c
@@ -260,7 +260,8 @@ int transport_alloc_session_tags(struct se_session *se_sess,
 		}
 	}
 
-	rc = percpu_ida_init(&se_sess->sess_tag_pool, tag_num);
+	rc = sbitmap_queue_init_node(&se_sess->sess_tag_pool, tag_num, -1,
+			false, GFP_KERNEL, NUMA_NO_NODE);
 	if (rc < 0) {
 		pr_err("Unable to init se_sess->sess_tag_pool,"
 			" tag_num: %u\n", tag_num);
@@ -547,7 +548,7 @@ void transport_free_session(struct se_session *se_sess)
 		target_put_nacl(se_nacl);
 	}
 	if (se_sess->sess_cmd_map) {
-		percpu_ida_destroy(&se_sess->sess_tag_pool);
+		sbitmap_queue_free(&se_sess->sess_tag_pool);
 		kvfree(se_sess->sess_cmd_map);
 	}
 	kmem_cache_free(se_sess_cache, se_sess);
diff --git a/drivers/target/tcm_fc/tfc_cmd.c b/drivers/target/tcm_fc/tfc_cmd.c
index 13e4efbe1ce7..a183d4da7db2 100644
--- a/drivers/target/tcm_fc/tfc_cmd.c
+++ b/drivers/target/tcm_fc/tfc_cmd.c
@@ -28,7 +28,6 @@
 #include <linux/configfs.h>
 #include <linux/ctype.h>
 #include <linux/hash.h>
-#include <linux/percpu_ida.h>
 #include <asm/unaligned.h>
 #include <scsi/scsi_tcq.h>
 #include <scsi/libfc.h>
@@ -448,9 +447,9 @@ static void ft_recv_cmd(struct ft_sess *sess, struct fc_frame *fp)
 	struct ft_cmd *cmd;
 	struct fc_lport *lport = sess->tport->lport;
 	struct se_session *se_sess = sess->se_sess;
-	int tag;
+	int tag, cpu;
 
-	tag = percpu_ida_alloc(&se_sess->sess_tag_pool, TASK_RUNNING);
+	tag = sbitmap_queue_get(&se_sess->sess_tag_pool, &cpu);
 	if (tag < 0)
 		goto busy;
 
@@ -458,6 +457,7 @@ static void ft_recv_cmd(struct ft_sess *sess, struct fc_frame *fp)
 	memset(cmd, 0, sizeof(struct ft_cmd));
 
 	cmd->se_cmd.map_tag = tag;
+	cmd->se_cmd.map_cpu = cpu;
 	cmd->sess = sess;
 	cmd->seq = fc_seq_assign(lport, fp);
 	if (!cmd->seq) {
diff --git a/drivers/usb/gadget/function/f_tcm.c b/drivers/usb/gadget/function/f_tcm.c
index 9f670d9224b9..5003e857dce7 100644
--- a/drivers/usb/gadget/function/f_tcm.c
+++ b/drivers/usb/gadget/function/f_tcm.c
@@ -1071,15 +1071,16 @@ static struct usbg_cmd *usbg_get_cmd(struct f_uas *fu,
 {
 	struct se_session *se_sess = tv_nexus->tvn_se_sess;
 	struct usbg_cmd *cmd;
-	int tag;
+	int tag, cpu;
 
-	tag = percpu_ida_alloc(&se_sess->sess_tag_pool, TASK_RUNNING);
+	tag = sbitmap_queue_get(&se_sess->sess_tag_pool, &cpu);
 	if (tag < 0)
 		return ERR_PTR(-ENOMEM);
 
 	cmd = &((struct usbg_cmd *)se_sess->sess_cmd_map)[tag];
 	memset(cmd, 0, sizeof(*cmd));
 	cmd->se_cmd.map_tag = tag;
+	cmd->se_cmd.map_cpu = cpu;
 	cmd->se_cmd.tag = cmd->tag = scsi_tag;
 	cmd->fu = fu;
 
diff --git a/drivers/vhost/scsi.c b/drivers/vhost/scsi.c
index 70d35e696533..c9c5d6b291cc 100644
--- a/drivers/vhost/scsi.c
+++ b/drivers/vhost/scsi.c
@@ -46,7 +46,6 @@
 #include <linux/virtio_scsi.h>
 #include <linux/llist.h>
 #include <linux/bitmap.h>
-#include <linux/percpu_ida.h>
 
 #include "vhost.h"
 
@@ -567,7 +566,7 @@ vhost_scsi_get_tag(struct vhost_virtqueue *vq, struct vhost_scsi_tpg *tpg,
 	struct se_session *se_sess;
 	struct scatterlist *sg, *prot_sg;
 	struct page **pages;
-	int tag;
+	int tag, cpu;
 
 	tv_nexus = tpg->tpg_nexus;
 	if (!tv_nexus) {
@@ -576,7 +575,7 @@ vhost_scsi_get_tag(struct vhost_virtqueue *vq, struct vhost_scsi_tpg *tpg,
 	}
 	se_sess = tv_nexus->tvn_se_sess;
 
-	tag = percpu_ida_alloc(&se_sess->sess_tag_pool, TASK_RUNNING);
+	tag = sbitmap_queue_get(&se_sess->sess_tag_pool, &cpu);
 	if (tag < 0) {
 		pr_err("Unable to obtain tag for vhost_scsi_cmd\n");
 		return ERR_PTR(-ENOMEM);
@@ -591,6 +590,7 @@ vhost_scsi_get_tag(struct vhost_virtqueue *vq, struct vhost_scsi_tpg *tpg,
 	cmd->tvc_prot_sgl = prot_sg;
 	cmd->tvc_upages = pages;
 	cmd->tvc_se_cmd.map_tag = tag;
+	cmd->tvc_se_cmd.map_cpu = cpu;
 	cmd->tvc_tag = scsi_tag;
 	cmd->tvc_lun = lun;
 	cmd->tvc_task_attr = task_attr;
diff --git a/drivers/xen/xen-scsiback.c b/drivers/xen/xen-scsiback.c
index ec6635258ed8..764dd9aa0131 100644
--- a/drivers/xen/xen-scsiback.c
+++ b/drivers/xen/xen-scsiback.c
@@ -654,9 +654,9 @@ static struct vscsibk_pend *scsiback_get_pend_req(struct vscsiif_back_ring *ring
 	struct scsiback_nexus *nexus = tpg->tpg_nexus;
 	struct se_session *se_sess = nexus->tvn_se_sess;
 	struct vscsibk_pend *req;
-	int tag, i;
+	int tag, cpu, i;
 
-	tag = percpu_ida_alloc(&se_sess->sess_tag_pool, TASK_RUNNING);
+	tag = sbitmap_queue_get(&se_sess->sess_tag_pool, &cpu);
 	if (tag < 0) {
 		pr_err("Unable to obtain tag for vscsiif_request\n");
 		return ERR_PTR(-ENOMEM);
@@ -665,6 +665,7 @@ static struct vscsibk_pend *scsiback_get_pend_req(struct vscsiif_back_ring *ring
 	req = &((struct vscsibk_pend *)se_sess->sess_cmd_map)[tag];
 	memset(req, 0, sizeof(*req));
 	req->se_cmd.map_tag = tag;
+	req->se_cmd.map_cpu = cpu;
 
 	for (i = 0; i < VSCSI_MAX_GRANTS; i++)
 		req->grant_handles[i] = SCSIBACK_INVALID_HANDLE;
diff --git a/include/target/iscsi/iscsi_target_core.h b/include/target/iscsi/iscsi_target_core.h
index cf5f3fff1f1a..f2e6abea8490 100644
--- a/include/target/iscsi/iscsi_target_core.h
+++ b/include/target/iscsi/iscsi_target_core.h
@@ -4,6 +4,7 @@
 
 #include <linux/dma-direction.h>     /* enum dma_data_direction */
 #include <linux/list.h>              /* struct list_head */
+#include <linux/sched.h>
 #include <linux/socket.h>            /* struct sockaddr_storage */
 #include <linux/types.h>             /* u8 */
 #include <scsi/iscsi_proto.h>        /* itt_t */
diff --git a/include/target/target_core_base.h b/include/target/target_core_base.h
index 260c2f3e9460..448f291125c2 100644
--- a/include/target/target_core_base.h
+++ b/include/target/target_core_base.h
@@ -4,7 +4,7 @@
 
 #include <linux/configfs.h>      /* struct config_group */
 #include <linux/dma-direction.h> /* enum dma_data_direction */
-#include <linux/percpu_ida.h>    /* struct percpu_ida */
+#include <linux/sbitmap.h>
 #include <linux/percpu-refcount.h>
 #include <linux/semaphore.h>     /* struct semaphore */
 #include <linux/completion.h>
@@ -455,6 +455,7 @@ struct se_cmd {
 	int			sam_task_attr;
 	/* Used for se_sess->sess_tag_pool */
 	unsigned int		map_tag;
+	int			map_cpu;
 	/* Transport protocol dependent state, see transport_state_table */
 	enum transport_state_table t_state;
 	/* See se_cmd_flags_table */
@@ -608,7 +609,7 @@ struct se_session {
 	struct list_head	sess_wait_list;
 	spinlock_t		sess_cmd_lock;
 	void			*sess_cmd_map;
-	struct percpu_ida	sess_tag_pool;
+	struct sbitmap_queue	sess_tag_pool;
 };
 
 struct se_device;
@@ -936,7 +937,7 @@ static inline void atomic_dec_mb(atomic_t *v)
 
 static inline void target_free_tag(struct se_session *sess, struct se_cmd *cmd)
 {
-	percpu_ida_free(&sess->sess_tag_pool, cmd->map_tag);
+	sbitmap_queue_clear(&sess->sess_tag_pool, cmd->map_tag, cmd->map_cpu);
 }
 
 #endif /* TARGET_CORE_BASE_H */
-- 
2.17.1


------------------------------------------------------------------------------
Check out the vibrant tech community on one of the world's most
engaging tech sites, Slashdot.org! http://sdm.link/slashdot
