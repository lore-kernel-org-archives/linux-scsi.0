From: James Bottomley <James.Bottomley@HansenPartnership.com>
Subject: [GIT PULL] SCSI fixes for 3.1-rc8
Date: Wed, 28 Sep 2011 09:15:20 -0500
Message-ID: <1317219320.19034.8.camel@dabdike.hansenpartnership.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner@vger.kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
To: Andrew Morton <akpm@linux-foundation.org>, Linus Torvalds <torvalds@linux-foundation.org>
Cc: linux-scsi <linux-scsi@vger.kernel.org>, linux-kernel@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org

This is a set of minor fixes around various things (build, aacraid,
3w-9xxx, cxgbi3 and libsas) at least two of them are regular oops
producers and the others have the potential to cause grave annoyance to
users.

The head sha1 is

commit 96067723e46b0dd24ae7b934085ab4eff4d26a1b

The fix is available here:

git://bedivere.hansenpartnership.com/git/scsi-rc-fixes-2.6.git

The short changelog is:

James Bottomley (1):
      3w-9xxx: fix iommu_iova leak

Mark Salyzyn (1):
      libsas: fix failure to revalidate domain for anything but the first expander child.

Neil Horman (1):
      cxgb3i: convert cdev->l2opt to use rcu to prevent NULL dereference

Randy Dunlap (1):
      scsi: qla4xxx needs libiscsi.o

Vasily Averin (1):
      aacraid: reset should disable MSI interrupt

And the diffstat:

 drivers/infiniband/hw/cxgb3/iwch_cm.c |   10 +++++-----
 drivers/net/cxgb3/cxgb3_offload.c     |   23 ++++++++++++++++++-----
 drivers/net/cxgb3/l2t.c               |   15 ++++++++++++---
 drivers/net/cxgb3/l2t.h               |   16 ++++++++++++----
 drivers/scsi/3w-9xxx.c                |    2 ++
 drivers/scsi/Makefile                 |    2 +-
 drivers/scsi/aacraid/commsup.c        |    2 ++
 drivers/scsi/cxgbi/cxgb3i/cxgb3i.c    |    2 +-
 drivers/scsi/libsas/sas_expander.c    |    2 +-
 9 files changed, 54 insertions(+), 20 deletions(-)

The full diff is below.

James

---

diff --git a/drivers/infiniband/hw/cxgb3/iwch_cm.c b/drivers/infiniband/hw/cxgb3/iwch_cm.c
index 17bf9d9..6cd642a 100644
--- a/drivers/infiniband/hw/cxgb3/iwch_cm.c
+++ b/drivers/infiniband/hw/cxgb3/iwch_cm.c
@@ -287,7 +287,7 @@ void __free_ep(struct kref *kref)
 	if (test_bit(RELEASE_RESOURCES, &ep->com.flags)) {
 		cxgb3_remove_tid(ep->com.tdev, (void *)ep, ep->hwtid);
 		dst_release(ep->dst);
-		l2t_release(L2DATA(ep->com.tdev), ep->l2t);
+		l2t_release(ep->com.tdev, ep->l2t);
 	}
 	kfree(ep);
 }
@@ -1178,7 +1178,7 @@ static int act_open_rpl(struct t3cdev *tdev, struct sk_buff *skb, void *ctx)
 		release_tid(ep->com.tdev, GET_TID(rpl), NULL);
 	cxgb3_free_atid(ep->com.tdev, ep->atid);
 	dst_release(ep->dst);
-	l2t_release(L2DATA(ep->com.tdev), ep->l2t);
+	l2t_release(ep->com.tdev, ep->l2t);
 	put_ep(&ep->com);
 	return CPL_RET_BUF_DONE;
 }
@@ -1377,7 +1377,7 @@ static int pass_accept_req(struct t3cdev *tdev, struct sk_buff *skb, void *ctx)
 	if (!child_ep) {
 		printk(KERN_ERR MOD "%s - failed to allocate ep entry!\n",
 		       __func__);
-		l2t_release(L2DATA(tdev), l2t);
+		l2t_release(tdev, l2t);
 		dst_release(dst);
 		goto reject;
 	}
@@ -1956,7 +1956,7 @@ int iwch_connect(struct iw_cm_id *cm_id, struct iw_cm_conn_param *conn_param)
 	if (!err)
 		goto out;
 
-	l2t_release(L2DATA(h->rdev.t3cdev_p), ep->l2t);
+	l2t_release(h->rdev.t3cdev_p, ep->l2t);
 fail4:
 	dst_release(ep->dst);
 fail3:
@@ -2127,7 +2127,7 @@ int iwch_ep_redirect(void *ctx, struct dst_entry *old, struct dst_entry *new,
 	PDBG("%s ep %p redirect to dst %p l2t %p\n", __func__, ep, new,
 	     l2t);
 	dst_hold(new);
-	l2t_release(L2DATA(ep->com.tdev), ep->l2t);
+	l2t_release(ep->com.tdev, ep->l2t);
 	ep->l2t = l2t;
 	dst_release(old);
 	ep->dst = new;
diff --git a/drivers/net/cxgb3/cxgb3_offload.c b/drivers/net/cxgb3/cxgb3_offload.c
index 805076c..da5a5d9 100644
--- a/drivers/net/cxgb3/cxgb3_offload.c
+++ b/drivers/net/cxgb3/cxgb3_offload.c
@@ -1146,12 +1146,14 @@ static void cxgb_redirect(struct dst_entry *old, struct dst_entry *new)
 		if (te && te->ctx && te->client && te->client->redirect) {
 			update_tcb = te->client->redirect(te->ctx, old, new, e);
 			if (update_tcb) {
+				rcu_read_lock();
 				l2t_hold(L2DATA(tdev), e);
+				rcu_read_unlock();
 				set_l2t_ix(tdev, tid, e);
 			}
 		}
 	}
-	l2t_release(L2DATA(tdev), e);
+	l2t_release(tdev, e);
 }
 
 /*
@@ -1264,7 +1266,7 @@ int cxgb3_offload_activate(struct adapter *adapter)
 		goto out_free;
 
 	err = -ENOMEM;
-	L2DATA(dev) = t3_init_l2t(l2t_capacity);
+	RCU_INIT_POINTER(dev->l2opt, t3_init_l2t(l2t_capacity));
 	if (!L2DATA(dev))
 		goto out_free;
 
@@ -1298,16 +1300,24 @@ int cxgb3_offload_activate(struct adapter *adapter)
 
 out_free_l2t:
 	t3_free_l2t(L2DATA(dev));
-	L2DATA(dev) = NULL;
+	rcu_assign_pointer(dev->l2opt, NULL);
 out_free:
 	kfree(t);
 	return err;
 }
 
+static void clean_l2_data(struct rcu_head *head)
+{
+	struct l2t_data *d = container_of(head, struct l2t_data, rcu_head);
+	t3_free_l2t(d);
+}
+
+
 void cxgb3_offload_deactivate(struct adapter *adapter)
 {
 	struct t3cdev *tdev = &adapter->tdev;
 	struct t3c_data *t = T3C_DATA(tdev);
+	struct l2t_data *d;
 
 	remove_adapter(adapter);
 	if (list_empty(&adapter_list))
@@ -1315,8 +1325,11 @@ void cxgb3_offload_deactivate(struct adapter *adapter)
 
 	free_tid_maps(&t->tid_maps);
 	T3C_DATA(tdev) = NULL;
-	t3_free_l2t(L2DATA(tdev));
-	L2DATA(tdev) = NULL;
+	rcu_read_lock();
+	d = L2DATA(tdev);
+	rcu_read_unlock();
+	rcu_assign_pointer(tdev->l2opt, NULL);
+	call_rcu(&d->rcu_head, clean_l2_data);
 	if (t->nofail_skb)
 		kfree_skb(t->nofail_skb);
 	kfree(t);
diff --git a/drivers/net/cxgb3/l2t.c b/drivers/net/cxgb3/l2t.c
index f452c40..4154097 100644
--- a/drivers/net/cxgb3/l2t.c
+++ b/drivers/net/cxgb3/l2t.c
@@ -300,14 +300,21 @@ static inline void reuse_entry(struct l2t_entry *e, struct neighbour *neigh)
 struct l2t_entry *t3_l2t_get(struct t3cdev *cdev, struct neighbour *neigh,
 			     struct net_device *dev)
 {
-	struct l2t_entry *e;
-	struct l2t_data *d = L2DATA(cdev);
+	struct l2t_entry *e = NULL;
+	struct l2t_data *d;
+	int hash;
 	u32 addr = *(u32 *) neigh->primary_key;
 	int ifidx = neigh->dev->ifindex;
-	int hash = arp_hash(addr, ifidx, d);
 	struct port_info *p = netdev_priv(dev);
 	int smt_idx = p->port_id;
 
+	rcu_read_lock();
+	d = L2DATA(cdev);
+	if (!d)
+		goto done_rcu;
+
+	hash = arp_hash(addr, ifidx, d);
+
 	write_lock_bh(&d->lock);
 	for (e = d->l2tab[hash].first; e; e = e->next)
 		if (e->addr == addr && e->ifindex == ifidx &&
@@ -338,6 +345,8 @@ struct l2t_entry *t3_l2t_get(struct t3cdev *cdev, struct neighbour *neigh,
 	}
 done:
 	write_unlock_bh(&d->lock);
+done_rcu:
+	rcu_read_unlock();
 	return e;
 }
 
diff --git a/drivers/net/cxgb3/l2t.h b/drivers/net/cxgb3/l2t.h
index 7a12d52..c5f5479 100644
--- a/drivers/net/cxgb3/l2t.h
+++ b/drivers/net/cxgb3/l2t.h
@@ -76,6 +76,7 @@ struct l2t_data {
 	atomic_t nfree;		/* number of free entries */
 	rwlock_t lock;
 	struct l2t_entry l2tab[0];
+	struct rcu_head rcu_head;	/* to handle rcu cleanup */
 };
 
 typedef void (*arp_failure_handler_func)(struct t3cdev * dev,
@@ -99,7 +100,7 @@ static inline void set_arp_failure_handler(struct sk_buff *skb,
 /*
  * Getting to the L2 data from an offload device.
  */
-#define L2DATA(dev) ((dev)->l2opt)
+#define L2DATA(cdev) (rcu_dereference((cdev)->l2opt))
 
 #define W_TCB_L2T_IX    0
 #define S_TCB_L2T_IX    7
@@ -126,15 +127,22 @@ static inline int l2t_send(struct t3cdev *dev, struct sk_buff *skb,
 	return t3_l2t_send_slow(dev, skb, e);
 }
 
-static inline void l2t_release(struct l2t_data *d, struct l2t_entry *e)
+static inline void l2t_release(struct t3cdev *t, struct l2t_entry *e)
 {
-	if (atomic_dec_and_test(&e->refcnt))
+	struct l2t_data *d;
+
+	rcu_read_lock();
+	d = L2DATA(t);
+
+	if (atomic_dec_and_test(&e->refcnt) && d)
 		t3_l2e_free(d, e);
+
+	rcu_read_unlock();
 }
 
 static inline void l2t_hold(struct l2t_data *d, struct l2t_entry *e)
 {
-	if (atomic_add_return(1, &e->refcnt) == 1)	/* 0 -> 1 transition */
+	if (d && atomic_add_return(1, &e->refcnt) == 1)	/* 0 -> 1 transition */
 		atomic_dec(&d->nfree);
 }
 
diff --git a/drivers/scsi/3w-9xxx.c b/drivers/scsi/3w-9xxx.c
index b7bd5b0..3868ab2 100644
--- a/drivers/scsi/3w-9xxx.c
+++ b/drivers/scsi/3w-9xxx.c
@@ -1800,10 +1800,12 @@ static int twa_scsi_queue_lck(struct scsi_cmnd *SCpnt, void (*done)(struct scsi_
 	switch (retval) {
 	case SCSI_MLQUEUE_HOST_BUSY:
 		twa_free_request_id(tw_dev, request_id);
+		twa_unmap_scsi_data(tw_dev, request_id);
 		break;
 	case 1:
 		tw_dev->state[request_id] = TW_S_COMPLETED;
 		twa_free_request_id(tw_dev, request_id);
+		twa_unmap_scsi_data(tw_dev, request_id);
 		SCpnt->result = (DID_ERROR << 16);
 		done(SCpnt);
 		retval = 0;
diff --git a/drivers/scsi/Makefile b/drivers/scsi/Makefile
index 3c08f53..6153a66 100644
--- a/drivers/scsi/Makefile
+++ b/drivers/scsi/Makefile
@@ -88,7 +88,7 @@ obj-$(CONFIG_SCSI_QLOGIC_FAS)	+= qlogicfas408.o	qlogicfas.o
 obj-$(CONFIG_PCMCIA_QLOGIC)	+= qlogicfas408.o
 obj-$(CONFIG_SCSI_QLOGIC_1280)	+= qla1280.o 
 obj-$(CONFIG_SCSI_QLA_FC)	+= qla2xxx/
-obj-$(CONFIG_SCSI_QLA_ISCSI)	+= qla4xxx/
+obj-$(CONFIG_SCSI_QLA_ISCSI)	+= libiscsi.o qla4xxx/
 obj-$(CONFIG_SCSI_LPFC)		+= lpfc/
 obj-$(CONFIG_SCSI_BFA_FC)	+= bfa/
 obj-$(CONFIG_SCSI_PAS16)	+= pas16.o
diff --git a/drivers/scsi/aacraid/commsup.c b/drivers/scsi/aacraid/commsup.c
index e7d0d47..e5f2d7d 100644
--- a/drivers/scsi/aacraid/commsup.c
+++ b/drivers/scsi/aacraid/commsup.c
@@ -1283,6 +1283,8 @@ static int _aac_reset_adapter(struct aac_dev *aac, int forced)
 	kfree(aac->queues);
 	aac->queues = NULL;
 	free_irq(aac->pdev->irq, aac);
+	if (aac->msi)
+		pci_disable_msi(aac->pdev);
 	kfree(aac->fsa_dev);
 	aac->fsa_dev = NULL;
 	quirks = aac_get_driver_ident(index)->quirks;
diff --git a/drivers/scsi/cxgbi/cxgb3i/cxgb3i.c b/drivers/scsi/cxgbi/cxgb3i/cxgb3i.c
index bd22041..f586448 100644
--- a/drivers/scsi/cxgbi/cxgb3i/cxgb3i.c
+++ b/drivers/scsi/cxgbi/cxgb3i/cxgb3i.c
@@ -913,7 +913,7 @@ static void l2t_put(struct cxgbi_sock *csk)
 	struct t3cdev *t3dev = (struct t3cdev *)csk->cdev->lldev;
 
 	if (csk->l2t) {
-		l2t_release(L2DATA(t3dev), csk->l2t);
+		l2t_release(t3dev, csk->l2t);
 		csk->l2t = NULL;
 		cxgbi_sock_put(csk);
 	}
diff --git a/drivers/scsi/libsas/sas_expander.c b/drivers/scsi/libsas/sas_expander.c
index f84084b..c9e3dc0 100644
--- a/drivers/scsi/libsas/sas_expander.c
+++ b/drivers/scsi/libsas/sas_expander.c
@@ -1721,7 +1721,7 @@ static int sas_find_bcast_dev(struct domain_device *dev,
 	list_for_each_entry(ch, &ex->children, siblings) {
 		if (ch->dev_type == EDGE_DEV || ch->dev_type == FANOUT_DEV) {
 			res = sas_find_bcast_dev(ch, src_dev);
-			if (src_dev)
+			if (*src_dev)
 				return res;
 		}
 	}
