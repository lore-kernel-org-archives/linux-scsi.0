From: "Nicholas A. Bellinger" <nab@linux-iscsi.org>
Subject: [PATCH 3/3] vhost/scsi: Convert to generic tag_alloc + tag_free command map
Date: Sat,  8 Jun 2013 02:42:18 +0000
Message-ID: <1370659338-23841-4-git-send-email-nab@linux-iscsi.org>
References: <1370659338-23841-1-git-send-email-nab@linux-iscsi.org>
Return-path: <target-devel-owner@vger.kernel.org>
In-Reply-To: <1370659338-23841-1-git-send-email-nab@linux-iscsi.org>
Sender: target-devel-owner@vger.kernel.org
To: target-devel <target-devel@vger.kernel.org>
Cc: linux-scsi <linux-scsi@vger.kernel.org>, Christoph Hellwig <hch@lst.de>, Roland Dreier <roland@kernel.org>, Kent Overstreet <koverstreet@google.com>, Asias He <asias@redhat.com>, "Michael S. Tsirkin" <mst@redhat.com>, Or Gerlitz <ogerlitz@mellanox.com>, Moussa Ba <moussaba@micron.com>, Nicholas Bellinger <nab@linux-iscsi.org>
List-Id: linux-scsi@vger.kernel.org

From: Nicholas Bellinger <nab@linux-iscsi.org>

This patch changes vhost/scsi to use transport_init_session_tagpool()
pre-allocation logic for per-cpu session tag pooling with internal
tag_alloc() + tag_free() calls based upon the saved se_cmd->map_tag id.

FIXME: Make transport_init_session_tagpool() number of tags
configurable per vring client setting

Cc: Kent Overstreet <koverstreet@google.com>
Cc: Michael S. Tsirkin <mst@redhat.com>
Cc: Asias He <asias@redhat.com>
Cc: Christoph Hellwig <hch@lst.de>
Cc: Roland Dreier <roland@kernel.org>
Signed-off-by: Nicholas Bellinger <nab@linux-iscsi.org>
---
 drivers/vhost/scsi.c |   31 +++++++++++++++++++------------
 1 files changed, 19 insertions(+), 12 deletions(-)

diff --git a/drivers/vhost/scsi.c b/drivers/vhost/scsi.c
index 1e5e820..0f33451 100644
--- a/drivers/vhost/scsi.c
+++ b/drivers/vhost/scsi.c
@@ -48,6 +48,7 @@
 #include <linux/virtio_scsi.h>
 #include <linux/llist.h>
 #include <linux/bitmap.h>
+#include <linux/tags.h>
 
 #include "vhost.c"
 #include "vhost.h"
@@ -448,6 +449,7 @@ static void tcm_vhost_release_cmd(struct se_cmd *se_cmd)
 {
 	struct tcm_vhost_cmd *tv_cmd = container_of(se_cmd,
 				struct tcm_vhost_cmd, tvc_se_cmd);
+	struct se_session *se_sess = se_cmd->se_sess;
 
 	if (tv_cmd->tvc_sgl_count) {
 		u32 i;
@@ -458,7 +460,7 @@ static void tcm_vhost_release_cmd(struct se_cmd *se_cmd)
         }
 
 	tcm_vhost_put_inflight(tv_cmd->inflight);
-	kfree(tv_cmd);
+	tag_free(&se_sess->sess_tag_pool, se_cmd->map_tag);
 }
 
 static int tcm_vhost_shutdown_session(struct se_session *se_sess)
@@ -700,7 +702,7 @@ static void vhost_scsi_complete_cmd_work(struct vhost_work *work)
 		vhost_signal(&vs->dev, &vs->vqs[vq].vq);
 }
 
-static struct tcm_vhost_cmd *vhost_scsi_allocate_cmd(
+static struct tcm_vhost_cmd *vhost_scsi_get_tag(
 	struct vhost_virtqueue *vq,
 	struct tcm_vhost_tpg *tv_tpg,
 	struct virtio_scsi_cmd_req *v_req,
@@ -709,18 +711,21 @@ static struct tcm_vhost_cmd *vhost_scsi_allocate_cmd(
 {
 	struct tcm_vhost_cmd *tv_cmd;
 	struct tcm_vhost_nexus *tv_nexus;
+	struct se_session *se_sess;
+	int tag;
 
 	tv_nexus = tv_tpg->tpg_nexus;
 	if (!tv_nexus) {
 		pr_err("Unable to locate active struct tcm_vhost_nexus\n");
 		return ERR_PTR(-EIO);
 	}
+	se_sess = tv_nexus->tvn_se_sess;
 
-	tv_cmd = kzalloc(sizeof(struct tcm_vhost_cmd), GFP_ATOMIC);
-	if (!tv_cmd) {
-		pr_err("Unable to allocate struct tcm_vhost_cmd\n");
-		return ERR_PTR(-ENOMEM);
-	}
+	tag = tag_alloc(&se_sess->sess_tag_pool, true);
+	tv_cmd = &((struct tcm_vhost_cmd *)se_sess->sess_cmd_map)[tag];
+	memset(tv_cmd, 0, sizeof(struct tcm_vhost_cmd));
+
+	tv_cmd->tvc_se_cmd.map_tag = tag;
 	tv_cmd->tvc_tag = v_req->tag;
 	tv_cmd->tvc_task_attr = v_req->task_attr;
 	tv_cmd->tvc_exp_data_len = exp_data_len;
@@ -982,10 +987,10 @@ static void vhost_scsi_handle_vq(struct vhost_scsi *vs,
 		for (i = 0; i < data_num; i++)
 			exp_data_len += vq->iov[data_first + i].iov_len;
 
-		tv_cmd = vhost_scsi_allocate_cmd(vq, tv_tpg, &v_req,
-					exp_data_len, data_direction);
+		tv_cmd = vhost_scsi_get_tag(vq, tv_tpg, &v_req,
+					    exp_data_len, data_direction);
 		if (IS_ERR(tv_cmd)) {
-			vq_err(vq, "vhost_scsi_allocate_cmd failed %ld\n",
+			vq_err(vq, "vhost_scsi_get_tag failed %ld\n",
 					PTR_ERR(tv_cmd));
 			goto err_cmd;
 		}
@@ -1662,9 +1667,11 @@ static int tcm_vhost_make_nexus(struct tcm_vhost_tpg *tv_tpg,
 		return -ENOMEM;
 	}
 	/*
-	 *  Initialize the struct se_session pointer
+	 *  Initialize the struct se_session pointer and setup tagpool
+	 *  for struct tcm_vhost_cmd descriptors
 	 */
-	tv_nexus->tvn_se_sess = transport_init_session();
+	tv_nexus->tvn_se_sess = transport_init_session_tagpool(256,
+						sizeof(struct tcm_vhost_cmd));
 	if (IS_ERR(tv_nexus->tvn_se_sess)) {
 		mutex_unlock(&tv_tpg->tv_tpg_mutex);
 		kfree(tv_nexus);
-- 
1.7.2.5
