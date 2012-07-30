From: "Nicholas A. Bellinger" <nab@linux-iscsi.org>
Subject: [PATCH] tcm_vhost: Post-merge review changes requested by MST
Date: Mon, 30 Jul 2012 22:13:19 +0000
Message-ID: <1343686399-3794-1-git-send-email-nab@linux-iscsi.org>
Return-path: <target-devel-owner@vger.kernel.org>
Sender: target-devel-owner@vger.kernel.org
To: target-devel <target-devel@vger.kernel.org>
Cc: linux-scsi <linux-scsi@vger.kernel.org>, lf-virt <virtualization@lists.linux-foundation.org>, kvm-devel <kvm@vger.kernel.org>, qemu-devel <qemu-devel@nongnu.org>, Stefan Hajnoczi <stefanha@linux.vnet.ibm.com>, Zhi Yong Wu <wuzhy@cn.ibm.com>, Anthony Liguori <aliguori@linux.vnet.ibm.com>, Paolo Bonzini <pbonzini@redhat.com>, "Michael S. Tsirkin" <mst@redhat.com>, Christoph Hellwig <hch@lst.de>, Jens Axboe <axboe@kernel.dk>, Hannes Reinecke <hare@suse.de>, Greg Kroah-Hartman <gregkh@linuxfoundation.org>, Nicholas Bellinger <nab@linux-iscsi.org>, Anthony Liguori <aliguori@us.ibm.com>
List-Id: linux-scsi@vger.kernel.org

From: Nicholas Bellinger <nab@linux-iscsi.org>

This patch contains the post RFC-v5 (post-merge) changes, this includes:

- Add locking comment
- Move vhost_scsi_complete_cmd ahead of TFO callbacks in order to
  drop forward declarations
- Drop extra '!= NULL' usage in vhost_scsi_complete_cmd_work()
- Change vhost_scsi_*_handle_kick() to use pr_debug
- Fix possible race in vhost_scsi_set_endpoint() for vs->vs_tpg checking
  + assignment.
- Convert tv_tpg->tpg_vhost_count + ->tv_tpg_port_count from atomic_t ->
  int, and make sure reference is protected by ->tv_tpg_mutex.
- Drop unnecessary vhost_scsi->vhost_ref_cnt
- Add 'err:' label for exception path in vhost_scsi_clear_endpoint()
- Add enum for VQ numbers, add usage in vhost_scsi_open()
- Add vhost_scsi_flush() + vhost_scsi_flush_vq() following
  drivers/vhost/net.c
- Add smp_wmb() + vhost_scsi_flush() call during vhost_scsi_set_features()
- Drop unnecessary copy_from_user() usage with GET_ABI_VERSION ioctl
- Add missing vhost_scsi_compat_ioctl() caller for vhost_scsi_fops
- Fix function parameter definition first line to follow existing
  vhost code style
- Change 'vHost' usage -> 'vhost' in handful of locations
- Change -EPERM -> -EBUSY usage for two failures in tcm_vhost_drop_nexus()
- Add comment for tcm_vhost_workqueue in tcm_vhost_init()
- Make GET_ABI_VERSION return 'int' + add comment in tcm_vhost.h

Reported-by: Michael S. Tsirkin <mst@redhat.com>
Cc: Michael S. Tsirkin <mst@redhat.com>
Cc: Stefan Hajnoczi <stefanha@linux.vnet.ibm.com>
Cc: Anthony Liguori <aliguori@us.ibm.com>
Cc: Zhi Yong Wu <wuzhy@cn.ibm.com>
Cc: Paolo Bonzini <pbonzini@redhat.com>
Signed-off-by: Nicholas Bellinger <nab@linux-iscsi.org>
---
 drivers/vhost/tcm_vhost.c |  195 ++++++++++++++++++++++++--------------------
 drivers/vhost/tcm_vhost.h |    9 +-
 2 files changed, 111 insertions(+), 93 deletions(-)

diff --git a/drivers/vhost/tcm_vhost.c b/drivers/vhost/tcm_vhost.c
index 481af88..74b2eda 100644
--- a/drivers/vhost/tcm_vhost.c
+++ b/drivers/vhost/tcm_vhost.c
@@ -53,9 +53,14 @@
 #include "vhost.h"
 #include "tcm_vhost.h"
 
+enum {
+	VHOST_SCSI_VQ_CTL = 0,
+	VHOST_SCSI_VQ_EVT = 1,
+	VHOST_SCSI_VQ_IO = 2,
+};
+
 struct vhost_scsi {
-	atomic_t vhost_ref_cnt;
-	struct tcm_vhost_tpg *vs_tpg;
+	struct tcm_vhost_tpg *vs_tpg;	/* Protected by vhost_scsi->dev.mutex */
 	struct vhost_dev dev;
 	struct vhost_virtqueue vqs[3];
 
@@ -131,8 +136,7 @@ static u32 tcm_vhost_get_default_depth(struct se_portal_group *se_tpg)
 	return 1;
 }
 
-static u32 tcm_vhost_get_pr_transport_id(
-	struct se_portal_group *se_tpg,
+static u32 tcm_vhost_get_pr_transport_id(struct se_portal_group *se_tpg,
 	struct se_node_acl *se_nacl,
 	struct t10_pr_registration *pr_reg,
 	int *format_code,
@@ -162,8 +166,7 @@ static u32 tcm_vhost_get_pr_transport_id(
 			format_code, buf);
 }
 
-static u32 tcm_vhost_get_pr_transport_id_len(
-	struct se_portal_group *se_tpg,
+static u32 tcm_vhost_get_pr_transport_id_len(struct se_portal_group *se_tpg,
 	struct se_node_acl *se_nacl,
 	struct t10_pr_registration *pr_reg,
 	int *format_code)
@@ -192,8 +195,7 @@ static u32 tcm_vhost_get_pr_transport_id_len(
 			format_code);
 }
 
-static char *tcm_vhost_parse_pr_out_transport_id(
-	struct se_portal_group *se_tpg,
+static char *tcm_vhost_parse_pr_out_transport_id(struct se_portal_group *se_tpg,
 	const char *buf,
 	u32 *out_tid_len,
 	char **port_nexus_ptr)
@@ -236,8 +238,7 @@ static struct se_node_acl *tcm_vhost_alloc_fabric_acl(
 	return &nacl->se_node_acl;
 }
 
-static void tcm_vhost_release_fabric_acl(
-	struct se_portal_group *se_tpg,
+static void tcm_vhost_release_fabric_acl(struct se_portal_group *se_tpg,
 	struct se_node_acl *se_nacl)
 {
 	struct tcm_vhost_nacl *nacl = container_of(se_nacl,
@@ -297,7 +298,16 @@ static int tcm_vhost_get_cmd_state(struct se_cmd *se_cmd)
 	return 0;
 }
 
-static void vhost_scsi_complete_cmd(struct tcm_vhost_cmd *);
+static void vhost_scsi_complete_cmd(struct tcm_vhost_cmd *tv_cmd)
+{
+	struct vhost_scsi *vs = tv_cmd->tvc_vhost;
+
+	spin_lock_bh(&vs->vs_completion_lock);
+	list_add_tail(&tv_cmd->tvc_completion_list, &vs->vs_completion_list);
+	spin_unlock_bh(&vs->vs_completion_lock);
+
+	vhost_work_queue(&vs->dev, &vs->vs_completion_work);
+}
 
 static int tcm_vhost_queue_data_in(struct se_cmd *se_cmd)
 {
@@ -381,7 +391,7 @@ static void vhost_scsi_complete_cmd_work(struct vhost_work *work)
 					vs_completion_work);
 	struct tcm_vhost_cmd *tv_cmd;
 
-	while ((tv_cmd = vhost_scsi_get_cmd_from_completion(vs)) != NULL) {
+	while ((tv_cmd = vhost_scsi_get_cmd_from_completion(vs))) {
 		struct virtio_scsi_cmd_resp v_rsp;
 		struct se_cmd *se_cmd = &tv_cmd->tvc_se_cmd;
 		int ret;
@@ -408,19 +418,6 @@ static void vhost_scsi_complete_cmd_work(struct vhost_work *work)
 	vhost_signal(&vs->dev, &vs->vqs[2]);
 }
 
-static void vhost_scsi_complete_cmd(struct tcm_vhost_cmd *tv_cmd)
-{
-	struct vhost_scsi *vs = tv_cmd->tvc_vhost;
-
-	pr_debug("%s tv_cmd %p\n", __func__, tv_cmd);
-
-	spin_lock_bh(&vs->vs_completion_lock);
-	list_add_tail(&tv_cmd->tvc_completion_list, &vs->vs_completion_list);
-	spin_unlock_bh(&vs->vs_completion_lock);
-
-	vhost_work_queue(&vs->dev, &vs->vs_completion_work);
-}
-
 static struct tcm_vhost_cmd *vhost_scsi_allocate_cmd(
 	struct tcm_vhost_tpg *tv_tpg,
 	struct virtio_scsi_cmd_req *v_req,
@@ -787,12 +784,12 @@ static void vhost_scsi_handle_vq(struct vhost_scsi *vs)
 
 static void vhost_scsi_ctl_handle_kick(struct vhost_work *work)
 {
-	pr_err("%s: The handling func for control queue.\n", __func__);
+	pr_debug("%s: The handling func for control queue.\n", __func__);
 }
 
 static void vhost_scsi_evt_handle_kick(struct vhost_work *work)
 {
-	pr_err("%s: The handling func for event queue.\n", __func__);
+	pr_debug("%s: The handling func for event queue.\n", __func__);
 }
 
 static void vhost_scsi_handle_kick(struct vhost_work *work)
@@ -825,11 +822,6 @@ static int vhost_scsi_set_endpoint(
 			return -EFAULT;
 		}
 	}
-
-	if (vs->vs_tpg) {
-		mutex_unlock(&vs->dev.mutex);
-		return -EEXIST;
-	}
 	mutex_unlock(&vs->dev.mutex);
 
 	mutex_lock(&tcm_vhost_mutex);
@@ -839,7 +831,7 @@ static int vhost_scsi_set_endpoint(
 			mutex_unlock(&tv_tpg->tv_tpg_mutex);
 			continue;
 		}
-		if (atomic_read(&tv_tpg->tv_tpg_vhost_count)) {
+		if (tv_tpg->tv_tpg_vhost_count != 0) {
 			mutex_unlock(&tv_tpg->tv_tpg_mutex);
 			continue;
 		}
@@ -847,14 +839,20 @@ static int vhost_scsi_set_endpoint(
 
 		if (!strcmp(tv_tport->tport_name, t->vhost_wwpn) &&
 		    (tv_tpg->tport_tpgt == t->vhost_tpgt)) {
-			atomic_inc(&tv_tpg->tv_tpg_vhost_count);
-			smp_mb__after_atomic_inc();
+			tv_tpg->tv_tpg_vhost_count++;
 			mutex_unlock(&tv_tpg->tv_tpg_mutex);
 			mutex_unlock(&tcm_vhost_mutex);
 
 			mutex_lock(&vs->dev.mutex);
+			if (vs->vs_tpg) {
+				mutex_unlock(&vs->dev.mutex);
+				mutex_lock(&tv_tpg->tv_tpg_mutex);
+				tv_tpg->tv_tpg_vhost_count--;
+				mutex_unlock(&tv_tpg->tv_tpg_mutex);
+				return -EEXIST;
+			}
+
 			vs->vs_tpg = tv_tpg;
-			atomic_inc(&vs->vhost_ref_cnt);
 			smp_mb__after_atomic_inc();
 			mutex_unlock(&vs->dev.mutex);
 			return 0;
@@ -871,38 +869,42 @@ static int vhost_scsi_clear_endpoint(
 {
 	struct tcm_vhost_tport *tv_tport;
 	struct tcm_vhost_tpg *tv_tpg;
-	int index;
+	int index, ret;
 
 	mutex_lock(&vs->dev.mutex);
 	/* Verify that ring has been setup correctly. */
 	for (index = 0; index < vs->dev.nvqs; ++index) {
 		if (!vhost_vq_access_ok(&vs->vqs[index])) {
-			mutex_unlock(&vs->dev.mutex);
-			return -EFAULT;
+			ret = -EFAULT;
+			goto err;
 		}
 	}
 
 	if (!vs->vs_tpg) {
-		mutex_unlock(&vs->dev.mutex);
-		return -ENODEV;
+		ret = -ENODEV;
+		goto err;
 	}
 	tv_tpg = vs->vs_tpg;
 	tv_tport = tv_tpg->tport;
 
 	if (strcmp(tv_tport->tport_name, t->vhost_wwpn) ||
 	    (tv_tpg->tport_tpgt != t->vhost_tpgt)) {
-		mutex_unlock(&vs->dev.mutex);
 		pr_warn("tv_tport->tport_name: %s, tv_tpg->tport_tpgt: %hu"
 			" does not match t->vhost_wwpn: %s, t->vhost_tpgt: %hu\n",
 			tv_tport->tport_name, tv_tpg->tport_tpgt,
 			t->vhost_wwpn, t->vhost_tpgt);
-		return -EINVAL;
+		ret = -EINVAL;
+		goto err;
 	}
-	atomic_dec(&tv_tpg->tv_tpg_vhost_count);
+	tv_tpg->tv_tpg_vhost_count--;
 	vs->vs_tpg = NULL;
 	mutex_unlock(&vs->dev.mutex);
 
 	return 0;
+
+err:
+	mutex_unlock(&vs->dev.mutex);
+	return ret;
 }
 
 static int vhost_scsi_open(struct inode *inode, struct file *f)
@@ -918,9 +920,9 @@ static int vhost_scsi_open(struct inode *inode, struct file *f)
 	INIT_LIST_HEAD(&s->vs_completion_list);
 	spin_lock_init(&s->vs_completion_lock);
 
-	s->vqs[0].handle_kick = vhost_scsi_ctl_handle_kick;
-	s->vqs[1].handle_kick = vhost_scsi_evt_handle_kick;
-	s->vqs[2].handle_kick = vhost_scsi_handle_kick;
+	s->vqs[VHOST_SCSI_VQ_CTL].handle_kick = vhost_scsi_ctl_handle_kick;
+	s->vqs[VHOST_SCSI_VQ_EVT].handle_kick = vhost_scsi_evt_handle_kick;
+	s->vqs[VHOST_SCSI_VQ_IO].handle_kick = vhost_scsi_handle_kick;
 	r = vhost_dev_init(&s->dev, s->vqs, 3);
 	if (r < 0) {
 		kfree(s);
@@ -949,6 +951,18 @@ static int vhost_scsi_release(struct inode *inode, struct file *f)
 	return 0;
 }
 
+static void vhost_scsi_flush_vq(struct vhost_scsi *vs, int index)
+{
+	vhost_poll_flush(&vs->dev.vqs[index].poll);
+}
+
+static void vhost_scsi_flush(struct vhost_scsi *vs)
+{
+	vhost_scsi_flush_vq(vs, VHOST_SCSI_VQ_CTL);
+	vhost_scsi_flush_vq(vs, VHOST_SCSI_VQ_EVT);
+	vhost_scsi_flush_vq(vs, VHOST_SCSI_VQ_IO);
+}
+
 static int vhost_scsi_set_features(struct vhost_scsi *vs, u64 features)
 {
 	if (features & ~VHOST_FEATURES)
@@ -961,7 +975,8 @@ static int vhost_scsi_set_features(struct vhost_scsi *vs, u64 features)
 		return -EFAULT;
 	}
 	vs->dev.acked_features = features;
-	/* TODO possibly smp_wmb() and flush vqs */
+	smp_wmb();
+	vhost_scsi_flush(vs);
 	mutex_unlock(&vs->dev.mutex);
 	return 0;
 }
@@ -974,7 +989,7 @@ static long vhost_scsi_ioctl(struct file *f, unsigned int ioctl,
 	void __user *argp = (void __user *)arg;
 	u64 __user *featurep = argp;
 	u64 features;
-	int r;
+	int r, abi_version = VHOST_SCSI_ABI_VERSION;
 
 	switch (ioctl) {
 	case VHOST_SCSI_SET_ENDPOINT:
@@ -988,12 +1003,7 @@ static long vhost_scsi_ioctl(struct file *f, unsigned int ioctl,
 
 		return vhost_scsi_clear_endpoint(vs, &backend);
 	case VHOST_SCSI_GET_ABI_VERSION:
-		if (copy_from_user(&backend, argp, sizeof backend))
-			return -EFAULT;
-
-		backend.abi_version = VHOST_SCSI_ABI_VERSION;
-
-		if (copy_to_user(argp, &backend, sizeof backend))
+		if (copy_to_user(argp, &abi_version, sizeof abi_version))
 			return -EFAULT;
 		return 0;
 	case VHOST_GET_FEATURES:
@@ -1013,11 +1023,21 @@ static long vhost_scsi_ioctl(struct file *f, unsigned int ioctl,
 	}
 }
 
+#ifdef CONFIG_COMPAT
+static long vhost_scsi_compat_ioctl(struct file *f, unsigned int ioctl,
+				unsigned long arg)
+{
+	return vhost_scsi_ioctl(f, ioctl, (unsigned long)compat_ptr(arg));
+}
+#endif
+
 static const struct file_operations vhost_scsi_fops = {
 	.owner          = THIS_MODULE,
 	.release        = vhost_scsi_release,
 	.unlocked_ioctl = vhost_scsi_ioctl,
-	/* TODO compat ioctl? */
+#ifdef CONFIG_COMPAT
+	.compat_ioctl	= vhost_scsi_compat_ioctl,
+#endif
 	.open           = vhost_scsi_open,
 	.llseek		= noop_llseek,
 };
@@ -1054,28 +1074,28 @@ static char *tcm_vhost_dump_proto_id(struct tcm_vhost_tport *tport)
 	return "Unknown";
 }
 
-static int tcm_vhost_port_link(
-	struct se_portal_group *se_tpg,
+static int tcm_vhost_port_link(struct se_portal_group *se_tpg,
 	struct se_lun *lun)
 {
 	struct tcm_vhost_tpg *tv_tpg = container_of(se_tpg,
 				struct tcm_vhost_tpg, se_tpg);
 
-	atomic_inc(&tv_tpg->tv_tpg_port_count);
-	smp_mb__after_atomic_inc();
+	mutex_lock(&tv_tpg->tv_tpg_mutex);
+	tv_tpg->tv_tpg_port_count++;
+	mutex_unlock(&tv_tpg->tv_tpg_mutex);
 
 	return 0;
 }
 
-static void tcm_vhost_port_unlink(
-	struct se_portal_group *se_tpg,
+static void tcm_vhost_port_unlink(struct se_portal_group *se_tpg,
 	struct se_lun *se_lun)
 {
 	struct tcm_vhost_tpg *tv_tpg = container_of(se_tpg,
 				struct tcm_vhost_tpg, se_tpg);
 
-	atomic_dec(&tv_tpg->tv_tpg_port_count);
-	smp_mb__after_atomic_dec();
+	mutex_lock(&tv_tpg->tv_tpg_mutex);
+	tv_tpg->tv_tpg_port_count--;
+	mutex_unlock(&tv_tpg->tv_tpg_mutex);
 }
 
 static struct se_node_acl *tcm_vhost_make_nodeacl(
@@ -1122,8 +1142,7 @@ static void tcm_vhost_drop_nodeacl(struct se_node_acl *se_acl)
 	kfree(nacl);
 }
 
-static int tcm_vhost_make_nexus(
-	struct tcm_vhost_tpg *tv_tpg,
+static int tcm_vhost_make_nexus(struct tcm_vhost_tpg *tv_tpg,
 	const char *name)
 {
 	struct se_portal_group *se_tpg;
@@ -1168,7 +1187,7 @@ static int tcm_vhost_make_nexus(
 		return -ENOMEM;
 	}
 	/*
-	 * Now register the TCM vHost virtual I_T Nexus as active with the
+	 * Now register the TCM vhost virtual I_T Nexus as active with the
 	 * call to __transport_register_session()
 	 */
 	__transport_register_session(se_tpg, tv_nexus->tvn_se_sess->se_node_acl,
@@ -1179,8 +1198,7 @@ static int tcm_vhost_make_nexus(
 	return 0;
 }
 
-static int tcm_vhost_drop_nexus(
-	struct tcm_vhost_tpg *tpg)
+static int tcm_vhost_drop_nexus(struct tcm_vhost_tpg *tpg)
 {
 	struct se_session *se_sess;
 	struct tcm_vhost_nexus *tv_nexus;
@@ -1198,27 +1216,27 @@ static int tcm_vhost_drop_nexus(
 		return -ENODEV;
 	}
 
-	if (atomic_read(&tpg->tv_tpg_port_count)) {
+	if (tpg->tv_tpg_port_count != 0) {
 		mutex_unlock(&tpg->tv_tpg_mutex);
-		pr_err("Unable to remove TCM_vHost I_T Nexus with"
+		pr_err("Unable to remove TCM_vhost I_T Nexus with"
 			" active TPG port count: %d\n",
-			atomic_read(&tpg->tv_tpg_port_count));
-		return -EPERM;
+			tpg->tv_tpg_port_count);
+		return -EBUSY;
 	}
 
-	if (atomic_read(&tpg->tv_tpg_vhost_count)) {
+	if (tpg->tv_tpg_vhost_count != 0) {
 		mutex_unlock(&tpg->tv_tpg_mutex);
-		pr_err("Unable to remove TCM_vHost I_T Nexus with"
+		pr_err("Unable to remove TCM_vhost I_T Nexus with"
 			" active TPG vhost count: %d\n",
-			atomic_read(&tpg->tv_tpg_vhost_count));
-		return -EPERM;
+			tpg->tv_tpg_vhost_count);
+		return -EBUSY;
 	}
 
-	pr_debug("TCM_vHost_ConfigFS: Removing I_T Nexus to emulated"
+	pr_debug("TCM_vhost_ConfigFS: Removing I_T Nexus to emulated"
 		" %s Initiator Port: %s\n", tcm_vhost_dump_proto_id(tpg->tport),
 		tv_nexus->tvn_se_sess->se_node_acl->initiatorname);
 	/*
-	 * Release the SCSI I_T Nexus to the emulated vHost Target Port
+	 * Release the SCSI I_T Nexus to the emulated vhost Target Port
 	 */
 	transport_deregister_session(tv_nexus->tvn_se_sess);
 	tpg->tpg_nexus = NULL;
@@ -1228,8 +1246,7 @@ static int tcm_vhost_drop_nexus(
 	return 0;
 }
 
-static ssize_t tcm_vhost_tpg_show_nexus(
-	struct se_portal_group *se_tpg,
+static ssize_t tcm_vhost_tpg_show_nexus(struct se_portal_group *se_tpg,
 	char *page)
 {
 	struct tcm_vhost_tpg *tv_tpg = container_of(se_tpg,
@@ -1250,8 +1267,7 @@ static ssize_t tcm_vhost_tpg_show_nexus(
 	return ret;
 }
 
-static ssize_t tcm_vhost_tpg_store_nexus(
-	struct se_portal_group *se_tpg,
+static ssize_t tcm_vhost_tpg_store_nexus(struct se_portal_group *se_tpg,
 	const char *page,
 	size_t count)
 {
@@ -1336,8 +1352,7 @@ static struct configfs_attribute *tcm_vhost_tpg_attrs[] = {
 	NULL,
 };
 
-static struct se_portal_group *tcm_vhost_make_tpg(
-	struct se_wwn *wwn,
+static struct se_portal_group *tcm_vhost_make_tpg(struct se_wwn *wwn,
 	struct config_group *group,
 	const char *name)
 {
@@ -1385,7 +1400,7 @@ static void tcm_vhost_drop_tpg(struct se_portal_group *se_tpg)
 	list_del(&tpg->tv_tpg_list);
 	mutex_unlock(&tcm_vhost_mutex);
 	/*
-	 * Release the virtual I_T Nexus for this vHost TPG
+	 * Release the virtual I_T Nexus for this vhost TPG
 	 */
 	tcm_vhost_drop_nexus(tpg);
 	/*
@@ -1395,8 +1410,7 @@ static void tcm_vhost_drop_tpg(struct se_portal_group *se_tpg)
 	kfree(tpg);
 }
 
-static struct se_wwn *tcm_vhost_make_tport(
-	struct target_fabric_configfs *tf,
+static struct se_wwn *tcm_vhost_make_tport(struct target_fabric_configfs *tf,
 	struct config_group *group,
 	const char *name)
 {
@@ -1592,7 +1606,10 @@ static void tcm_vhost_deregister_configfs(void)
 static int __init tcm_vhost_init(void)
 {
 	int ret = -ENOMEM;
-
+	/*
+	 * Use our own dedicated workqueue for submitting I/O into
+	 * target core to avoid contention within system_wq.
+	 */
 	tcm_vhost_workqueue = alloc_workqueue("tcm_vhost", 0, 0);
 	if (!tcm_vhost_workqueue)
 		goto out;
diff --git a/drivers/vhost/tcm_vhost.h b/drivers/vhost/tcm_vhost.h
index c983ed2..eff42df 100644
--- a/drivers/vhost/tcm_vhost.h
+++ b/drivers/vhost/tcm_vhost.h
@@ -47,9 +47,9 @@ struct tcm_vhost_tpg {
 	/* Vhost port target portal group tag for TCM */
 	u16 tport_tpgt;
 	/* Used to track number of TPG Port/Lun Links wrt to explict I_T Nexus shutdown */
-	atomic_t tv_tpg_port_count;
-	/* Used for vhost_scsi device reference to tpg_nexus */
-	atomic_t tv_tpg_vhost_count;
+	int tv_tpg_port_count;
+	/* Used for vhost_scsi device reference to tpg_nexus, protected by tv_tpg_mutex */
+	int tv_tpg_vhost_count;
 	/* list for tcm_vhost_list */
 	struct list_head tv_tpg_list;
 	/* Used to protect access for tpg_nexus */
@@ -98,4 +98,5 @@ struct vhost_scsi_target {
 /* VHOST_SCSI specific defines */
 #define VHOST_SCSI_SET_ENDPOINT _IOW(VHOST_VIRTIO, 0x40, struct vhost_scsi_target)
 #define VHOST_SCSI_CLEAR_ENDPOINT _IOW(VHOST_VIRTIO, 0x41, struct vhost_scsi_target)
-#define VHOST_SCSI_GET_ABI_VERSION _IOW(VHOST_VIRTIO, 0x42, struct vhost_scsi_target)
+/* Changing this breaks userspace. */
+#define VHOST_SCSI_GET_ABI_VERSION _IOW(VHOST_VIRTIO, 0x42, int)
-- 
1.7.2.5
