From: Matthew Wilcox <willy@infradead.org>
Subject: [PATCH 1/2] Convert target drivers to use sbitmap
Date: Tue, 15 May 2018 09:00:42 -0700
Message-ID: <20180515160043.27044-2-willy@infradead.org>
References: <20180515160043.27044-1-willy@infradead.org>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <linux1394-devel-bounces@lists.sourceforge.net>
In-Reply-To: <20180515160043.27044-1-willy@infradead.org>
List-Unsubscribe: <https://lists.sourceforge.net/lists/options/linux1394-devel>,
 <mailto:linux1394-devel-request@lists.sourceforge.net?subject=unsubscribe>
List-Archive: <http://sourceforge.net/mailarchive/forum.php?forum_name=linux1394-devel>
List-Post: <mailto:linux1394-devel@lists.sourceforge.net>
List-Help: <mailto:linux1394-devel-request@lists.sourceforge.net?subject=help>
List-Subscribe: <https://lists.sourceforge.net/lists/listinfo/linux1394-devel>,
 <mailto:linux1394-devel-request@lists.sourceforge.net?subject=subscribe>
Errors-To: linux1394-devel-bounces@lists.sourceforge.net
To: linux-kernel@vger.kernel.org, linux-scsi@vger.kernel.org, target-devel@vger.kernel.org, linux1394-devel@lists.sourceforge.net, linux-usb@vger.kernel.org, kvm@vger.kernel.org, virtualization@lists.linux-foundation.org, netdev@vger.kernel.org, Juergen Gross <jgross@suse.com>, qla2xxx-upstream@qlogic.com, Kent Overstreet <kent.overstreet@gmail.com>, Jens Axboe <axboe@kernel.dk>
Cc: Matthew Wilcox <mawilcox@microsoft.com>
List-Id: linux-scsi@vger.kernel.org

From: Matthew Wilcox <mawilcox@microsoft.com>

The sbitmap and the percpu_ida perform essentially the same task,
allocating tags for commands.  Since the sbitmap is more used than
the percpu_ida, convert the percpu_ida users to the sbitmap API.

Signed-off-by: Matthew Wilcox <mawilcox@microsoft.com>
---
 drivers/scsi/qla2xxx/qla_target.c        | 16 ++++++-----
 drivers/target/iscsi/iscsi_target_util.c | 34 +++++++++++++++++++++---
 drivers/target/sbp/sbp_target.c          |  8 +++---
 drivers/target/target_core_transport.c   |  5 ++--
 drivers/target/tcm_fc/tfc_cmd.c          | 11 ++++----
 drivers/usb/gadget/function/f_tcm.c      |  8 +++---
 drivers/vhost/scsi.c                     |  9 ++++---
 drivers/xen/xen-scsiback.c               |  8 +++---
 include/target/iscsi/iscsi_target_core.h |  1 +
 include/target/target_core_base.h        |  5 ++--
 10 files changed, 73 insertions(+), 32 deletions(-)

diff --git a/drivers/scsi/qla2xxx/qla_target.c b/drivers/scsi/qla2xxx/qla_target.c
index 025dc2d3f3de..cdf671c2af61 100644
--- a/drivers/scsi/qla2xxx/qla_target.c
+++ b/drivers/scsi/qla2xxx/qla_target.c
@@ -3719,7 +3719,8 @@ void qlt_free_cmd(struct qla_tgt_cmd *cmd)
 		return;
 	}
 	cmd->jiffies_at_free = get_jiffies_64();
-	percpu_ida_free(&sess->se_sess->sess_tag_pool, cmd->se_cmd.map_tag);
+	sbitmap_queue_clear(&sess->se_sess->sess_tag_pool, cmd->se_cmd.map_tag,
+			cmd->se_cmd.map_cpu);
 }
 EXPORT_SYMBOL(qlt_free_cmd);
 
@@ -4084,7 +4085,8 @@ static void __qlt_do_work(struct qla_tgt_cmd *cmd)
 	qlt_send_term_exchange(qpair, NULL, &cmd->atio, 1, 0);
 
 	qlt_decr_num_pend_cmds(vha);
-	percpu_ida_free(&sess->se_sess->sess_tag_pool, cmd->se_cmd.map_tag);
+	sbitmap_queue_clear(&sess->se_sess->sess_tag_pool, cmd->se_cmd.map_tag,
+			cmd->se_cmd.map_cpu);
 	spin_unlock_irqrestore(qpair->qp_lock_ptr, flags);
 
 	spin_lock_irqsave(&ha->tgt.sess_lock, flags);
@@ -4215,9 +4217,9 @@ static struct qla_tgt_cmd *qlt_get_tag(scsi_qla_host_t *vha,
 {
 	struct se_session *se_sess = sess->se_sess;
 	struct qla_tgt_cmd *cmd;
-	int tag;
+	int tag, cpu;
 
-	tag = percpu_ida_alloc(&se_sess->sess_tag_pool, TASK_RUNNING);
+	tag = sbitmap_queue_get(&se_sess->sess_tag_pool, &cpu);
 	if (tag < 0)
 		return NULL;
 
@@ -4230,6 +4232,7 @@ static struct qla_tgt_cmd *qlt_get_tag(scsi_qla_host_t *vha,
 	qlt_incr_num_pend_cmds(vha);
 	cmd->vha = vha;
 	cmd->se_cmd.map_tag = tag;
+	cmd->se_cmd.map_cpu = cpu;
 	cmd->sess = sess;
 	cmd->loop_id = sess->loop_id;
 	cmd->conf_compl_supported = sess->conf_compl_supported;
@@ -5212,7 +5215,7 @@ qlt_alloc_qfull_cmd(struct scsi_qla_host *vha,
 	struct fc_port *sess;
 	struct se_session *se_sess;
 	struct qla_tgt_cmd *cmd;
-	int tag;
+	int tag, cpu;
 	unsigned long flags;
 
 	if (unlikely(tgt->tgt_stop)) {
@@ -5244,7 +5247,7 @@ qlt_alloc_qfull_cmd(struct scsi_qla_host *vha,
 
 	se_sess = sess->se_sess;
 
-	tag = percpu_ida_alloc(&se_sess->sess_tag_pool, TASK_RUNNING);
+	tag = sbitmap_queue_get(&se_sess->sess_tag_pool, &cpu);
 	if (tag < 0)
 		return;
 
@@ -5275,6 +5278,7 @@ qlt_alloc_qfull_cmd(struct scsi_qla_host *vha,
 	cmd->reset_count = ha->base_qpair->chip_reset;
 	cmd->q_full = 1;
 	cmd->qpair = ha->base_qpair;
+	cmd->se_cmd.map_cpu = cpu;
 
 	if (qfull) {
 		cmd->q_full = 1;
diff --git a/drivers/target/iscsi/iscsi_target_util.c b/drivers/target/iscsi/iscsi_target_util.c
index 4435bf374d2d..28bcffae609f 100644
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
@@ -147,6 +147,28 @@ void iscsit_free_r2ts_from_list(struct iscsi_cmd *cmd)
 	spin_unlock_bh(&cmd->r2t_lock);
 }
 
+int iscsit_wait_for_tag(struct se_session *se_sess, int state, int *cpup)
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
+		schedule();
+		tag = sbitmap_queue_get(&se_sess->sess_tag_pool, cpup);
+	}
+
+	finish_wait(&ws->wait, &wait);
+	return tag;
+}
+
 /*
  * May be called from software interrupt (timer) context for allocating
  * iSCSI NopINs.
@@ -155,9 +177,11 @@ struct iscsi_cmd *iscsit_allocate_cmd(struct iscsi_conn *conn, int state)
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
 
@@ -166,6 +190,7 @@ struct iscsi_cmd *iscsit_allocate_cmd(struct iscsi_conn *conn, int state)
 	memset(cmd, 0, size);
 
 	cmd->se_cmd.map_tag = tag;
+	cmd->se_cmd.map_cpu = cpu;
 	cmd->conn = conn;
 	cmd->data_direction = DMA_NONE;
 	INIT_LIST_HEAD(&cmd->i_conn_node);
@@ -711,7 +736,8 @@ void iscsit_release_cmd(struct iscsi_cmd *cmd)
 	kfree(cmd->iov_data);
 	kfree(cmd->text_in_ptr);
 
-	percpu_ida_free(&sess->se_sess->sess_tag_pool, se_cmd->map_tag);
+	sbitmap_queue_clear(&sess->se_sess->sess_tag_pool, se_cmd->map_tag,
+			se_cmd->map_cpu);
 }
 EXPORT_SYMBOL(iscsit_release_cmd);
 
diff --git a/drivers/target/sbp/sbp_target.c b/drivers/target/sbp/sbp_target.c
index fb1003921d85..c58f9f04c6be 100644
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
@@ -1460,7 +1461,8 @@ static void sbp_free_request(struct sbp_target_request *req)
 	kfree(req->pg_tbl);
 	kfree(req->cmd_buf);
 
-	percpu_ida_free(&se_sess->sess_tag_pool, se_cmd->map_tag);
+	sbitmap_queue_clear(&se_sess->sess_tag_pool, se_cmd->map_tag,
+			se_cmd->map_cpu);
 }
 
 static void sbp_mgt_agent_process(struct work_struct *work)
diff --git a/drivers/target/target_core_transport.c b/drivers/target/target_core_transport.c
index 4558f2e1fe1b..3103890ed109 100644
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
index ec372860106f..b3e3364b7147 100644
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
@@ -92,7 +91,8 @@ static void ft_free_cmd(struct ft_cmd *cmd)
 	if (fr_seq(fp))
 		fc_seq_release(fr_seq(fp));
 	fc_frame_free(fp);
-	percpu_ida_free(&sess->se_sess->sess_tag_pool, cmd->se_cmd.map_tag);
+	sbitmap_queue_clear(&sess->se_sess->sess_tag_pool, cmd->se_cmd.map_tag,
+			cmd->se_cmd.map_cpu);
 	ft_sess_put(sess);	/* undo get from lookup at recv */
 }
 
@@ -448,9 +448,9 @@ static void ft_recv_cmd(struct ft_sess *sess, struct fc_frame *fp)
 	struct ft_cmd *cmd;
 	struct fc_lport *lport = sess->tport->lport;
 	struct se_session *se_sess = sess->se_sess;
-	int tag;
+	int tag, cpu;
 
-	tag = percpu_ida_alloc(&se_sess->sess_tag_pool, TASK_RUNNING);
+	tag = sbitmap_queue_get(&se_sess->sess_tag_pool, &cpu);
 	if (tag < 0)
 		goto busy;
 
@@ -458,10 +458,11 @@ static void ft_recv_cmd(struct ft_sess *sess, struct fc_frame *fp)
 	memset(cmd, 0, sizeof(struct ft_cmd));
 
 	cmd->se_cmd.map_tag = tag;
+	cmd->se_cmd.map_cpu = cpu;
 	cmd->sess = sess;
 	cmd->seq = fc_seq_assign(lport, fp);
 	if (!cmd->seq) {
-		percpu_ida_free(&se_sess->sess_tag_pool, tag);
+		sbitmap_queue_clear(&se_sess->sess_tag_pool, tag, cpu);
 		goto busy;
 	}
 	cmd->req_frame = fp;		/* hold frame during cmd */
diff --git a/drivers/usb/gadget/function/f_tcm.c b/drivers/usb/gadget/function/f_tcm.c
index d78dbb73bde8..b335f4f33bc3 100644
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
 
@@ -1288,7 +1289,8 @@ static void usbg_release_cmd(struct se_cmd *se_cmd)
 	struct se_session *se_sess = se_cmd->se_sess;
 
 	kfree(cmd->data_buf);
-	percpu_ida_free(&se_sess->sess_tag_pool, se_cmd->map_tag);
+	sbitmap_queue_clear(&se_sess->sess_tag_pool, se_cmd->map_tag,
+			se_cmd->map_cpu);
 }
 
 static u32 usbg_sess_get_index(struct se_session *se_sess)
diff --git a/drivers/vhost/scsi.c b/drivers/vhost/scsi.c
index 7ad57094d736..1fadaa39f322 100644
--- a/drivers/vhost/scsi.c
+++ b/drivers/vhost/scsi.c
@@ -46,7 +46,6 @@
 #include <linux/virtio_scsi.h>
 #include <linux/llist.h>
 #include <linux/bitmap.h>
-#include <linux/percpu_ida.h>
 
 #include "vhost.h"
 
@@ -324,7 +323,8 @@ static void vhost_scsi_release_cmd(struct se_cmd *se_cmd)
 	}
 
 	vhost_scsi_put_inflight(tv_cmd->inflight);
-	percpu_ida_free(&se_sess->sess_tag_pool, se_cmd->map_tag);
+	sbitmap_queue_clear(&se_sess->sess_tag_pool, se_cmd->map_tag,
+			se_cmd->map_cpu);
 }
 
 static u32 vhost_scsi_sess_get_index(struct se_session *se_sess)
@@ -567,7 +567,7 @@ vhost_scsi_get_tag(struct vhost_virtqueue *vq, struct vhost_scsi_tpg *tpg,
 	struct se_session *se_sess;
 	struct scatterlist *sg, *prot_sg;
 	struct page **pages;
-	int tag;
+	int tag, cpu;
 
 	tv_nexus = tpg->tpg_nexus;
 	if (!tv_nexus) {
@@ -576,7 +576,7 @@ vhost_scsi_get_tag(struct vhost_virtqueue *vq, struct vhost_scsi_tpg *tpg,
 	}
 	se_sess = tv_nexus->tvn_se_sess;
 
-	tag = percpu_ida_alloc(&se_sess->sess_tag_pool, TASK_RUNNING);
+	tag = sbitmap_queue_get(&se_sess->sess_tag_pool, &cpu);
 	if (tag < 0) {
 		pr_err("Unable to obtain tag for vhost_scsi_cmd\n");
 		return ERR_PTR(-ENOMEM);
@@ -591,6 +591,7 @@ vhost_scsi_get_tag(struct vhost_virtqueue *vq, struct vhost_scsi_tpg *tpg,
 	cmd->tvc_prot_sgl = prot_sg;
 	cmd->tvc_upages = pages;
 	cmd->tvc_se_cmd.map_tag = tag;
+	cmd->tvc_se_cmd.map_cpu = cpu;
 	cmd->tvc_tag = scsi_tag;
 	cmd->tvc_lun = lun;
 	cmd->tvc_task_attr = task_attr;
diff --git a/drivers/xen/xen-scsiback.c b/drivers/xen/xen-scsiback.c
index 7bc88fd43cfc..d2c71b8608f0 100644
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
@@ -1379,7 +1380,8 @@ static void scsiback_release_cmd(struct se_cmd *se_cmd)
 {
 	struct se_session *se_sess = se_cmd->se_sess;
 
-	percpu_ida_free(&se_sess->sess_tag_pool, se_cmd->map_tag);
+	sbitmap_queue_clear(&se_sess->sess_tag_pool, se_cmd->map_tag,
+			se_cmd->map_cpu);
 }
 
 static u32 scsiback_sess_get_index(struct se_session *se_sess)
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
index 9f9f5902af38..cd417b17fee6 100644
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
@@ -454,6 +454,7 @@ struct se_cmd {
 	int			sam_task_attr;
 	/* Used for se_sess->sess_tag_pool */
 	unsigned int		map_tag;
+	int			map_cpu;
 	/* Transport protocol dependent state, see transport_state_table */
 	enum transport_state_table t_state;
 	/* See se_cmd_flags_table */
@@ -607,7 +608,7 @@ struct se_session {
 	struct list_head	sess_wait_list;
 	spinlock_t		sess_cmd_lock;
 	void			*sess_cmd_map;
-	struct percpu_ida	sess_tag_pool;
+	struct sbitmap_queue	sess_tag_pool;
 };
 
 struct se_device;
-- 
2.17.0


------------------------------------------------------------------------------
Check out the vibrant tech community on one of the world's most
engaging tech sites, Slashdot.org! http://sdm.link/slashdot
