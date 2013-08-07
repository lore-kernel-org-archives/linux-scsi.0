From: Kent Overstreet <kmo@daterainc.com>
Subject: [PATCH 10/10] idr: Rework idr_preload()
Date: Wed,  7 Aug 2013 10:46:19 -0700
Message-ID: <1375897579-8202-10-git-send-email-kmo@daterainc.com>
References: <1375896905-6074-1-git-send-email-kmo@daterainc.com>
Return-path: <cluster-devel-bounces@redhat.com>
In-Reply-To: <1375896905-6074-1-git-send-email-kmo@daterainc.com>
List-Unsubscribe: <https://www.redhat.com/mailman/options/cluster-devel>,
	<mailto:cluster-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/cluster-devel>
List-Post: <mailto:cluster-devel@redhat.com>
List-Help: <mailto:cluster-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/cluster-devel>,
	<mailto:cluster-devel-request@redhat.com?subject=subscribe>
Sender: cluster-devel-bounces@redhat.com
Errors-To: cluster-devel-bounces@redhat.com
To: akpm@linux-foundation.org, linux-kernel@vger.kernel.org
Cc: Dmitry Torokhov <dtor@vmware.com>, David Airlie <airlied@linux.ie>, Davidlohr Bueso <davidlohr.bueso@hp.com>, Trond Myklebust <Trond.Myklebust@netapp.com>, dri-devel@lists.freedesktop.org, Sean Hefty <sean.hefty@intel.com>, Michel Lespinasse <walken@google.com>, John McCutchan <john@johnmccutchan.com>, Roland Dreier <roland@kernel.org>, Thomas Hellstrom <thellstrom@vmware.com>, linux1394-devel@lists.sourceforge.net, linux-scsi@vger.kernel.org, Robert Love <rlove@rlove.org>, linux-rdma@vger.kernel.org, cluster-devel@redhat.com, Brian Paul <brianp@vmware.com>, Doug Gilbert <dgilbert@interlog.com>, Dave Airlie <airlied@redhat.com>, Hal Rosenstock <hal.rosenstock@gmail.com>, Rik van Riel <riel@redhat.com>, Erez Shitrit <erezsh@mellanox.co.il>, Steve Wise <swise@chelsio.com>, Wo
List-Id: linux-scsi@vger.kernel.org

The old idr_preload() used percpu buffers - since the
bitmap/radix/whatever tree only grew by fixed sized nodes, it only had
to ensure there was a node available in the percpu buffer and disable
preemption. This conveniently meant that you didn't have to pass the idr
you were going to allocate from to it.

With the new ida implementation, that doesn't work anymore - the new ida
code grows its bitmap tree by reallocating the entire thing in power of
two increments. Doh.

So we need a slightly different trick. Note that if all allocations from
an idr start by calling idr_prealloc() and disabling premption, at
most nr_cpus() allocations can happen before someone calls
idr_prealloc() again.

So, we just change idr_prealloc() to resize the ida bitmap tree if
there's less than num_possible_cpus() ids available - conveniently, we
already track the number of allocated ids, and the total number of ids
we can have allocated is just nr_leaf_nodes * BITS_PER_LONG. Easy.

This does require a fairly trivial interface change - we now have to
pass the idr we're going to allocate from (and the starting id we're
going to pass to idr_allocate_range()) to idr_prealloc(), so this patch
updates all the callers.

Signed-off-by: Kent Overstreet <kmo@daterainc.com>
Cc: Andrew Morton <akpm@linux-foundation.org>
Cc: Tejun Heo <tj@kernel.org>
Cc: Stefan Richter <stefanr@s5r6.in-berlin.de>
Cc: David Airlie <airlied@linux.ie>
Cc: Roland Dreier <roland@kernel.org>
Cc: Sean Hefty <sean.hefty@intel.com>
Cc: Hal Rosenstock <hal.rosenstock@gmail.com>
Cc: Steve Wise <swise@chelsio.com>
Cc: Hoang-Nam Nguyen <hnguyen@de.ibm.com>
Cc: Christoph Raisch <raisch@de.ibm.com>
Cc: Mike Marciniszyn <infinipath@intel.com>
Cc: Doug Gilbert <dgilbert@interlog.com>
Cc: "James E.J. Bottomley" <JBottomley@parallels.com>
Cc: Christine Caulfield <ccaulfie@redhat.com>
Cc: David Teigland <teigland@redhat.com>
Cc: Trond Myklebust <Trond.Myklebust@netapp.com>
Cc: John McCutchan <john@johnmccutchan.com>
Cc: Robert Love <rlove@rlove.org>
Cc: Eric Paris <eparis@parisplace.org>
Cc: Dave Airlie <airlied@redhat.com>
Cc: Thomas Hellstrom <thellstrom@vmware.com>
Cc: Brian Paul <brianp@vmware.com>
Cc: Maarten Lankhorst <maarten.lankhorst@canonical.com>
Cc: Dmitry Torokhov <dtor@vmware.com>
Cc: Erez Shitrit <erezsh@mellanox.co.il>
Cc: Al Viro <viro@zeniv.linux.org.uk>
Cc: Haggai Eran <haggaie@mellanox.com>
Cc: Jack Morgenstein <jackm@dev.mellanox.co.il>
Cc: Wolfram Sang <wolfram@the-dreams.de>
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: Davidlohr Bueso <davidlohr.bueso@hp.com>
Cc: Rik van Riel <riel@redhat.com>
Cc: Michel Lespinasse <walken@google.com>
Cc: linux1394-devel@lists.sourceforge.net
Cc: linux-kernel@vger.kernel.org
Cc: dri-devel@lists.freedesktop.org
Cc: linux-rdma@vger.kernel.org
Cc: linux-scsi@vger.kernel.org
Cc: cluster-devel@redhat.com
Cc: linux-nfs@vger.kernel.org
---
 drivers/firewire/core-cdev.c               |  2 +-
 drivers/gpu/drm/drm_gem.c                  |  4 +-
 drivers/gpu/drm/vmwgfx/vmwgfx_resource.c   |  2 +-
 drivers/infiniband/core/cm.c               |  8 +---
 drivers/infiniband/core/sa_query.c         |  2 +-
 drivers/infiniband/core/uverbs_cmd.c       |  2 +-
 drivers/infiniband/hw/cxgb3/iwch.h         |  2 +-
 drivers/infiniband/hw/cxgb4/iw_cxgb4.h     |  2 +-
 drivers/infiniband/hw/ehca/ehca_cq.c       |  2 +-
 drivers/infiniband/hw/ehca/ehca_qp.c       |  2 +-
 drivers/infiniband/hw/ipath/ipath_driver.c |  2 +-
 drivers/infiniband/hw/mlx4/cm.c            |  2 +-
 drivers/infiniband/hw/qib/qib_init.c       |  2 +-
 drivers/scsi/sg.c                          |  2 +-
 fs/dlm/lock.c                              |  2 +-
 fs/dlm/recover.c                           |  2 +-
 fs/nfs/nfs4client.c                        |  2 +-
 fs/notify/inotify/inotify_user.c           |  2 +-
 include/linux/idr.h                        | 37 +----------------
 ipc/util.c                                 |  4 +-
 lib/idr.c                                  | 66 ++++++++++++++++++++++++++++++
 21 files changed, 91 insertions(+), 60 deletions(-)

diff --git a/drivers/firewire/core-cdev.c b/drivers/firewire/core-cdev.c
index ba78d08..08d31da 100644
--- a/drivers/firewire/core-cdev.c
+++ b/drivers/firewire/core-cdev.c
@@ -491,7 +491,7 @@ static int add_client_resource(struct client *client,
 	int ret;
 
 	if (preload)
-		idr_preload(gfp_mask);
+		idr_preload(&client->resource_idr, 0, gfp_mask);
 	spin_lock_irqsave(&client->lock, flags);
 
 	if (client->in_shutdown)
diff --git a/drivers/gpu/drm/drm_gem.c b/drivers/gpu/drm/drm_gem.c
index d12ea60..c8ed531 100644
--- a/drivers/gpu/drm/drm_gem.c
+++ b/drivers/gpu/drm/drm_gem.c
@@ -269,7 +269,7 @@ drm_gem_handle_create(struct drm_file *file_priv,
 	 * Get the user-visible handle using idr.  Preload and perform
 	 * allocation under our spinlock.
 	 */
-	idr_preload(GFP_KERNEL);
+	idr_preload(&file_priv->object_idr, 1, GFP_KERNEL);
 	spin_lock(&file_priv->table_lock);
 
 	ret = idr_alloc_range(&file_priv->object_idr, obj, 1, 0, GFP_NOWAIT);
@@ -445,7 +445,7 @@ drm_gem_flink_ioctl(struct drm_device *dev, void *data,
 	if (obj == NULL)
 		return -ENOENT;
 
-	idr_preload(GFP_KERNEL);
+	idr_preload(&dev->object_name_idr, 1, GFP_KERNEL);
 	spin_lock(&dev->object_name_lock);
 	if (!obj->name) {
 		ret = idr_alloc_range(&dev->object_name_idr,
diff --git a/drivers/gpu/drm/vmwgfx/vmwgfx_resource.c b/drivers/gpu/drm/vmwgfx/vmwgfx_resource.c
index 4838238..1078b51 100644
--- a/drivers/gpu/drm/vmwgfx/vmwgfx_resource.c
+++ b/drivers/gpu/drm/vmwgfx/vmwgfx_resource.c
@@ -177,7 +177,7 @@ int vmw_resource_alloc_id(struct vmw_resource *res)
 
 	BUG_ON(res->id != -1);
 
-	idr_preload(GFP_KERNEL);
+	idr_preload(idr, 1, GFP_KERNEL);
 	write_lock(&dev_priv->resource_lock);
 
 	ret = idr_alloc_range(idr, res, 1, 0, GFP_NOWAIT);
diff --git a/drivers/infiniband/core/cm.c b/drivers/infiniband/core/cm.c
index c686690..a11bb5e 100644
--- a/drivers/infiniband/core/cm.c
+++ b/drivers/infiniband/core/cm.c
@@ -383,15 +383,11 @@ static int cm_alloc_id(struct cm_id_private *cm_id_priv)
 {
 	unsigned long flags;
 	int id;
-	static int next_id;
 
-	idr_preload(GFP_KERNEL);
+	idr_preload(&cm.local_id_table, 0, GFP_KERNEL);
 	spin_lock_irqsave(&cm.lock, flags);
 
-	id = idr_alloc_range(&cm.local_id_table, cm_id_priv,
-			     next_id, 0, GFP_NOWAIT);
-	if (id >= 0)
-		next_id = max(id + 1, 0);
+	id = idr_alloc_cyclic(&cm.local_id_table, cm_id_priv, 0, 0, GFP_NOWAIT);
 
 	spin_unlock_irqrestore(&cm.lock, flags);
 	idr_preload_end();
diff --git a/drivers/infiniband/core/sa_query.c b/drivers/infiniband/core/sa_query.c
index ce757fd..b1ed7fd 100644
--- a/drivers/infiniband/core/sa_query.c
+++ b/drivers/infiniband/core/sa_query.c
@@ -616,7 +616,7 @@ static int send_mad(struct ib_sa_query *query, int timeout_ms, gfp_t gfp_mask)
 	int ret, id;
 
 	if (preload)
-		idr_preload(gfp_mask);
+		idr_preload(&query_idr, 0, gfp_mask);
 	spin_lock_irqsave(&idr_lock, flags);
 
 	id = idr_alloc(&query_idr, query, GFP_NOWAIT);
diff --git a/drivers/infiniband/core/uverbs_cmd.c b/drivers/infiniband/core/uverbs_cmd.c
index 9ddc2e0..0f20a27 100644
--- a/drivers/infiniband/core/uverbs_cmd.c
+++ b/drivers/infiniband/core/uverbs_cmd.c
@@ -125,7 +125,7 @@ static int idr_add_uobj(struct idr *idr, struct ib_uobject *uobj)
 {
 	int ret;
 
-	idr_preload(GFP_KERNEL);
+	idr_preload(idr, 0, GFP_KERNEL);
 	spin_lock(&ib_uverbs_idr_lock);
 
 	ret = idr_alloc(idr, uobj, GFP_NOWAIT);
diff --git a/drivers/infiniband/hw/cxgb3/iwch.h b/drivers/infiniband/hw/cxgb3/iwch.h
index f28c585..12e5f29 100644
--- a/drivers/infiniband/hw/cxgb3/iwch.h
+++ b/drivers/infiniband/hw/cxgb3/iwch.h
@@ -154,7 +154,7 @@ static inline int insert_handle(struct iwch_dev *rhp, struct idr *idr,
 {
 	int ret;
 
-	idr_preload(GFP_KERNEL);
+	idr_preload(idr, id, GFP_KERNEL);
 	spin_lock_irq(&rhp->lock);
 
 	ret = idr_alloc_range(idr, handle, id, id + 1, GFP_NOWAIT);
diff --git a/drivers/infiniband/hw/cxgb4/iw_cxgb4.h b/drivers/infiniband/hw/cxgb4/iw_cxgb4.h
index 50e5a3f..e6a5fc3 100644
--- a/drivers/infiniband/hw/cxgb4/iw_cxgb4.h
+++ b/drivers/infiniband/hw/cxgb4/iw_cxgb4.h
@@ -262,7 +262,7 @@ static inline int _insert_handle(struct c4iw_dev *rhp, struct idr *idr,
 	int ret;
 
 	if (lock) {
-		idr_preload(GFP_KERNEL);
+		idr_preload(idr, id, GFP_KERNEL);
 		spin_lock_irq(&rhp->lock);
 	}
 
diff --git a/drivers/infiniband/hw/ehca/ehca_cq.c b/drivers/infiniband/hw/ehca/ehca_cq.c
index a3632ee..3886f43 100644
--- a/drivers/infiniband/hw/ehca/ehca_cq.c
+++ b/drivers/infiniband/hw/ehca/ehca_cq.c
@@ -163,7 +163,7 @@ struct ib_cq *ehca_create_cq(struct ib_device *device, int cqe, int comp_vector,
 	adapter_handle = shca->ipz_hca_handle;
 	param.eq_handle = shca->eq.ipz_eq_handle;
 
-	idr_preload(GFP_KERNEL);
+	idr_preload(&ehca_cq_idr, 0, GFP_KERNEL);
 	write_lock_irqsave(&ehca_cq_idr_lock, flags);
 	my_cq->token = idr_alloc_range(&ehca_cq_idr, my_cq, 0,
 				       0x2000000, GFP_NOWAIT);
diff --git a/drivers/infiniband/hw/ehca/ehca_qp.c b/drivers/infiniband/hw/ehca/ehca_qp.c
index 758a265..4184133 100644
--- a/drivers/infiniband/hw/ehca/ehca_qp.c
+++ b/drivers/infiniband/hw/ehca/ehca_qp.c
@@ -636,7 +636,7 @@ static struct ehca_qp *internal_create_qp(
 		my_qp->send_cq =
 			container_of(init_attr->send_cq, struct ehca_cq, ib_cq);
 
-	idr_preload(GFP_KERNEL);
+	idr_preload(&ehca_qp_idr, 0, GFP_KERNEL);
 	write_lock_irqsave(&ehca_qp_idr_lock, flags);
 
 	ret = idr_alloc_range(&ehca_qp_idr, my_qp, 0, 0x2000000, GFP_NOWAIT);
diff --git a/drivers/infiniband/hw/ipath/ipath_driver.c b/drivers/infiniband/hw/ipath/ipath_driver.c
index 83a40a5..b241f42 100644
--- a/drivers/infiniband/hw/ipath/ipath_driver.c
+++ b/drivers/infiniband/hw/ipath/ipath_driver.c
@@ -201,7 +201,7 @@ static struct ipath_devdata *ipath_alloc_devdata(struct pci_dev *pdev)
 	}
 	dd->ipath_unit = -1;
 
-	idr_preload(GFP_KERNEL);
+	idr_preload(&unit_table, 0, GFP_KERNEL);
 	spin_lock_irqsave(&ipath_devs_lock, flags);
 
 	ret = idr_alloc(&unit_table, dd, GFP_NOWAIT);
diff --git a/drivers/infiniband/hw/mlx4/cm.c b/drivers/infiniband/hw/mlx4/cm.c
index d1f5f1d..ac089e6 100644
--- a/drivers/infiniband/hw/mlx4/cm.c
+++ b/drivers/infiniband/hw/mlx4/cm.c
@@ -219,7 +219,7 @@ id_map_alloc(struct ib_device *ibdev, int slave_id, u32 sl_cm_id)
 	ent->dev = to_mdev(ibdev);
 	INIT_DELAYED_WORK(&ent->timeout, id_map_ent_timeout);
 
-	idr_preload(GFP_KERNEL);
+	idr_preload(&sriov->pv_id_table, 0, GFP_KERNEL);
 	spin_lock(&to_mdev(ibdev)->sriov.id_map_lock);
 
 	ret = idr_alloc_cyclic(&sriov->pv_id_table, ent, 0, 0, GFP_NOWAIT);
diff --git a/drivers/infiniband/hw/qib/qib_init.c b/drivers/infiniband/hw/qib/qib_init.c
index 17adbd10c..e7101b2 100644
--- a/drivers/infiniband/hw/qib/qib_init.c
+++ b/drivers/infiniband/hw/qib/qib_init.c
@@ -1106,7 +1106,7 @@ struct qib_devdata *qib_alloc_devdata(struct pci_dev *pdev, size_t extra)
 	qib_dbg_ibdev_init(&dd->verbs_dev);
 #endif
 
-	idr_preload(GFP_KERNEL);
+	idr_preload(&qib_unit_table, 0, GFP_KERNEL);
 	spin_lock_irqsave(&qib_devs_lock, flags);
 
 	ret = idr_alloc(&qib_unit_table, dd, GFP_NOWAIT);
diff --git a/drivers/scsi/sg.c b/drivers/scsi/sg.c
index 23856c8..d226a64 100644
--- a/drivers/scsi/sg.c
+++ b/drivers/scsi/sg.c
@@ -1392,7 +1392,7 @@ static Sg_device *sg_alloc(struct gendisk *disk, struct scsi_device *scsidp)
 		return ERR_PTR(-ENOMEM);
 	}
 
-	idr_preload(GFP_KERNEL);
+	idr_preload(&sg_index_idr, 0, GFP_KERNEL);
 	write_lock_irqsave(&sg_index_lock, iflags);
 
 	error = idr_alloc_range(&sg_index_idr, sdp, 0, SG_MAX_DEVS, GFP_NOWAIT);
diff --git a/fs/dlm/lock.c b/fs/dlm/lock.c
index 75f0421..47edc23 100644
--- a/fs/dlm/lock.c
+++ b/fs/dlm/lock.c
@@ -1199,7 +1199,7 @@ static int create_lkb(struct dlm_ls *ls, struct dlm_lkb **lkb_ret)
 	mutex_init(&lkb->lkb_cb_mutex);
 	INIT_WORK(&lkb->lkb_cb_work, dlm_callback_work);
 
-	idr_preload(GFP_NOFS);
+	idr_preload(&ls->ls_lkbidr, 1, GFP_NOFS);
 	spin_lock(&ls->ls_lkbidr_spin);
 	rv = idr_alloc_range(&ls->ls_lkbidr, lkb, 1, 0, GFP_NOWAIT);
 	if (rv >= 0)
diff --git a/fs/dlm/recover.c b/fs/dlm/recover.c
index 2babe5e..757b7a6 100644
--- a/fs/dlm/recover.c
+++ b/fs/dlm/recover.c
@@ -307,7 +307,7 @@ static int recover_idr_add(struct dlm_rsb *r)
 	struct dlm_ls *ls = r->res_ls;
 	int rv;
 
-	idr_preload(GFP_NOFS);
+	idr_preload(&ls->ls_recover_idr, 1, GFP_NOFS);
 	spin_lock(&ls->ls_recover_idr_lock);
 	if (r->res_id) {
 		rv = -1;
diff --git a/fs/nfs/nfs4client.c b/fs/nfs/nfs4client.c
index dd8451d..14ab2da 100644
--- a/fs/nfs/nfs4client.c
+++ b/fs/nfs/nfs4client.c
@@ -30,7 +30,7 @@ static int nfs_get_cb_ident_idr(struct nfs_client *clp, int minorversion)
 
 	if (clp->rpc_ops->version != 4 || minorversion != 0)
 		return ret;
-	idr_preload(GFP_KERNEL);
+	idr_preload(&nn->cb_ident_idr, 0, GFP_KERNEL);
 	spin_lock(&nn->nfs_client_lock);
 	ret = idr_alloc(&nn->cb_ident_idr, clp, GFP_NOWAIT);
 	if (ret >= 0)
diff --git a/fs/notify/inotify/inotify_user.c b/fs/notify/inotify/inotify_user.c
index 60f954a..c6bcf73 100644
--- a/fs/notify/inotify/inotify_user.c
+++ b/fs/notify/inotify/inotify_user.c
@@ -360,7 +360,7 @@ static int inotify_add_to_idr(struct idr *idr, spinlock_t *idr_lock,
 {
 	int ret;
 
-	idr_preload(GFP_KERNEL);
+	idr_preload(idr, 1, GFP_KERNEL);
 	spin_lock(idr_lock);
 
 	ret = idr_alloc_cyclic(idr, i_mark, 1, 0, GFP_NOWAIT);
diff --git a/include/linux/idr.h b/include/linux/idr.h
index 85355d7..418d87c 100644
--- a/include/linux/idr.h
+++ b/include/linux/idr.h
@@ -177,6 +177,7 @@ int idr_for_each(struct idr *idr,
 		 int (*fn)(int id, void *p, void *data), void *data);
 void *idr_replace(struct idr *idr, void *ptr, unsigned id);
 void idr_remove(struct idr *idr, unsigned id);
+int idr_preload(struct idr *idr, unsigned start, gfp_t gfp);
 int idr_alloc_range(struct idr *idr, void *ptr, unsigned start,
 		    unsigned end, gfp_t gfp);
 int idr_alloc_cyclic(struct idr *idr, void *ptr, unsigned start,
@@ -197,41 +198,7 @@ static inline int idr_alloc(struct idr *idr, void *ptr, gfp_t gfp)
  */
 static inline void idr_preload_end(void)
 {
-	radix_tree_preload_end();
-}
-
-/**
- * idr_preload - preload for idr_alloc_range()
- * @gfp: allocation mask to use for preloading
- *
- * Preload per-cpu layer buffer for idr_alloc_range().  Can only be used from
- * process context and each idr_preload() invocation should be matched with
- * idr_preload_end().  Note that preemption is disabled while preloaded.
- *
- * The first idr_alloc_range() in the preloaded section can be treated as if it
- * were invoked with @gfp_mask used for preloading.  This allows using more
- * permissive allocation masks for idrs protected by spinlocks.
- *
- * For example, if idr_alloc_range() below fails, the failure can be treated as
- * if idr_alloc_range() were called with GFP_KERNEL rather than GFP_NOWAIT.
- *
- *	idr_preload(GFP_KERNEL);
- *	spin_lock(lock);
- *
- *	id = idr_alloc_range(idr, ptr, start, end, GFP_NOWAIT);
- *
- *	spin_unlock(lock);
- *	idr_preload_end();
- *	if (id < 0)
- *		error;
- */
-static inline void idr_preload(gfp_t gfp)
-{
-	might_sleep_if(gfp & __GFP_WAIT);
-
-	/* Well this is horrible, but idr_preload doesn't return errors */
-	if (radix_tree_preload(gfp))
-		preempt_disable();
+	preempt_enable();
 }
 
 /* radix tree can't store NULL pointers, so we have to translate...  */
diff --git a/ipc/util.c b/ipc/util.c
index e31ecb8..d6453c1 100644
--- a/ipc/util.c
+++ b/ipc/util.c
@@ -261,7 +261,9 @@ int ipc_addid(struct ipc_ids* ids, struct kern_ipc_perm* new, int size)
 	if (ids->in_use >= size)
 		return -ENOSPC;
 
-	idr_preload(GFP_KERNEL);
+	idr_preload(&ids->ipcs_idr,
+		    (next_id < 0) ? 0 : ipcid_to_idx(next_id),
+		    GFP_KERNEL);
 
 	spin_lock_init(&new->lock);
 	new->deleted = 0;
diff --git a/lib/idr.c b/lib/idr.c
index 89ec59f..fb374c3 100644
--- a/lib/idr.c
+++ b/lib/idr.c
@@ -295,6 +295,23 @@ err:
 	return -ENOMEM;
 }
 
+static int ida_preload(struct ida *ida, unsigned start, gfp_t gfp)
+{
+	int ret = 0;
+	unsigned long flags;
+
+	spin_lock_irqsave(&ida->lock, flags);
+
+	while (!ret &&
+	       (ida->nodes - ida->first_leaf * BITS_PER_LONG <
+		start + ida->allocated_ids + num_possible_cpus()))
+		ret = __ida_resize(ida, gfp, &flags);
+
+	spin_unlock_irqrestore(&ida->lock, flags);
+
+	return ret;
+}
+
 /*
  * Ganged allocation - amortize locking and tree traversal for when we've got
  * another allocator (i.e. a percpu version) acting as a frontend to this code
@@ -1032,6 +1049,55 @@ void idr_remove(struct idr *idr, unsigned id)
 }
 EXPORT_SYMBOL(idr_remove);
 
+/**
+ * idr_preload - preload for idr_alloc_range()
+ * @idr: idr to ensure has room to allocate an id
+ * @start: value that will be passed to ida_alloc_range()
+ * @gfp: allocation mask to use for preloading
+ *
+ * On success, guarantees that one call of idr_alloc()/idr_alloc_range() won't
+ * fail. Returns with preemption disabled; use idr_preload_end() when
+ * finished.
+ *
+ * It's not required to check for failure if you're still checking for
+ * idr_alloc() failure.
+ *
+ * In order to guarantee idr_alloc() won't fail, all allocations from @idr must
+ * make use of idr_preload().
+ */
+int idr_preload(struct idr *idr, unsigned start, gfp_t gfp)
+{
+	int radix_ret, ida_ret = 0;
+
+	might_sleep_if(gfp & __GFP_WAIT);
+
+	while (1) {
+		radix_ret = radix_tree_preload(gfp);
+
+		/*
+		 * Well this is horrible, but radix_tree_preload() doesn't
+		 * disable preemption if it fails, and idr_preload() users don't
+		 * check for errors
+		 */
+		if (radix_ret)
+			preempt_disable();
+
+		/* if ida_preload with GFP_WAIT failed, don't retry */
+		if (ida_ret)
+			break;
+
+		if (!ida_preload(&idr->ida, start, GFP_NOWAIT) ||
+		    !(gfp & __GFP_WAIT))
+			break;
+
+		radix_tree_preload_end();
+		ida_ret = ida_preload(&idr->ida, start, gfp);
+	}
+
+	return radix_ret ?: ida_ret;
+}
+EXPORT_SYMBOL(idr_preload);
+
 static int idr_insert(struct idr *idr, void *ptr, unsigned id,
 		      gfp_t gfp, unsigned long *flags)
 {
-- 
1.8.4.rc1
