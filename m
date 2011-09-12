From: "Karen Xie" <kxie@chelsio.com>
Subject: RE: [PATCH] cxgb3i: convert cdev->l2opt to use rcu to prevent NULL dereference (v2)
Date: Mon, 12 Sep 2011 08:57:54 -0700
Message-ID: <8A71B368A89016469F72CD08050AD3340A17E066@maui.asicdesigners.com>
References: <1315331953-11456-1-git-send-email-nhorman@tuxdriver.com>
Mime-Version: 1.0
Content-Type: text/plain;
	charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from stargate.chelsio.com ([67.207.112.58]:13745 "EHLO
	stargate.chelsio.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758235Ab1ILQCj convert rfc822-to-8bit (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Mon, 12 Sep 2011 12:02:39 -0400
Content-class: urn:content-classes:message
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Neil Horman <nhorman@tuxdriver.com>, linux-scsi@vger.kernel.org
Cc: Divy Le Ray <divy@chelsio.com>, Steve Wise <swise@chelsio.com>, Mike Christie <michaelc@cs.wisc.edu>, stable-commits@vger.kernel.org, James.Bottomley@HansenPartnership.com

The patch looks OK to me.

Thanks, Neil.

Reviewed-by: Karen Xie <kxie@chelsio.com>

-----Original Message-----
From: Neil Horman [mailto:nhorman@tuxdriver.com] 
Sent: Tuesday, September 06, 2011 10:59 AM
To: linux-scsi@vger.kernel.org
Cc: Neil Horman; Divy Le Ray; Steve Wise; Karen Xie; Mike Christie;
stable-commits@vger.kernel.org; James.Bottomley@HansenPartnership.com
Subject: [PATCH] cxgb3i: convert cdev->l2opt to use rcu to prevent NULL
dereference (v2)

This oops was reported recently:
d:mon> e
cpu 0xd: Vector: 300 (Data Access) at [c0000000fd4c7120]
    pc: d00000000076f194: .t3_l2t_get+0x44/0x524 [cxgb3]
    lr: d000000000b02108: .init_act_open+0x150/0x3d4 [cxgb3i]
    sp: c0000000fd4c73a0
   msr: 8000000000009032
   dar: 0
 dsisr: 40000000
  current = 0xc0000000fd640d40
  paca    = 0xc00000000054ff80
    pid   = 5085, comm = iscsid
d:mon> t
[c0000000fd4c7450] d000000000b02108 .init_act_open+0x150/0x3d4 [cxgb3i]
[c0000000fd4c7500] d000000000e45378 .cxgbi_ep_connect+0x784/0x8e8
[libcxgbi]
[c0000000fd4c7650] d000000000db33f0 .iscsi_if_rx+0x71c/0xb18
[scsi_transport_iscsi2]
[c0000000fd4c7740] c000000000370c9c .netlink_data_ready+0x40/0xa4
[c0000000fd4c77c0] c00000000036f010 .netlink_sendskb+0x4c/0x9c
[c0000000fd4c7850] c000000000370c18 .netlink_sendmsg+0x358/0x39c
[c0000000fd4c7950] c00000000033be24 .sock_sendmsg+0x114/0x1b8
[c0000000fd4c7b50] c00000000033d208 .sys_sendmsg+0x218/0x2ac
[c0000000fd4c7d70] c00000000033f55c .sys_socketcall+0x228/0x27c
[c0000000fd4c7e30] c0000000000086a4 syscall_exit+0x0/0x40
--- Exception: c01 (System Call) at 00000080da560cfc

The root cause was an EEH error, which sent us down the offload_close
path in
the cxgb3 driver, which in turn sets cdev->l2opt to NULL, without regard
for
upper layer driver (like the cxgbi drivers) which might have execution
contexts
in the middle of its use. The result is the oops above, when t3_l2t_get
attempts
to dereference L2DATA(cdev)->nentries in arp_hash right after the EEH
error handler sets it to NULL.

The fix is to prevent the setting of the NULL pointer until after there
are no
further users of it.  The t3cdev->l2opt pointer is now converted to be
an rcu
pointer and the L2DATA macro is now called under the protection of the
rcu_read_lock().  When the EEH error path:
t3_adapter_error->offload_close->cxgb3_offload_deactivate
Is exectured, setting of that l2opt pointer to NULL, is now gated on an
rcu
quiescence point, preventing, allowing L2DATA callers to safely check
for a NULL
pointer without concern that the underlying data will be freeded before
the
pointer is dereferenced.

This has been tested by the reporter and shown to fix the reproted oops

Note: I had attempted to post a fix for this bug previously.  While it
solved
the issue, James B. pointed out that it really didn't make much sense,
and on
closer inspection I agree. Some internal structures to this affected
pointer are
already refcounted and so all we should need to do is prevent the race
that
arises between the reading of the affected pointer and its setting to
NULL.

Signed-off-by: Neil Horman <nhorman@tuxdriver.com>
CC: Divy Le Ray <divy@chelsio.com>
CC: Steve Wise <swise@chelsio.com>
CC: Karen Xie <kxie@chelsio.com>
CC: Mike Christie <michaelc@cs.wisc.edu>
CC: stable-commits@vger.kernel.org
CC: James.Bottomley@HansenPartnership.com
---
 drivers/infiniband/hw/cxgb3/iwch_cm.c |   10 +++++-----
 drivers/net/cxgb3/cxgb3_offload.c     |   23 ++++++++++++++++++-----
 drivers/net/cxgb3/l2t.c               |   11 +++++++++--
 drivers/net/cxgb3/l2t.h               |   16 ++++++++++++----
 drivers/scsi/cxgbi/cxgb3i/cxgb3i.c    |    2 +-
 5 files changed, 45 insertions(+), 17 deletions(-)

diff --git a/drivers/infiniband/hw/cxgb3/iwch_cm.c
b/drivers/infiniband/hw/cxgb3/iwch_cm.c
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
@@ -1178,7 +1178,7 @@ static int act_open_rpl(struct t3cdev *tdev,
struct sk_buff *skb, void *ctx)
 		release_tid(ep->com.tdev, GET_TID(rpl), NULL);
 	cxgb3_free_atid(ep->com.tdev, ep->atid);
 	dst_release(ep->dst);
-	l2t_release(L2DATA(ep->com.tdev), ep->l2t);
+	l2t_release(ep->com.tdev, ep->l2t);
 	put_ep(&ep->com);
 	return CPL_RET_BUF_DONE;
 }
@@ -1377,7 +1377,7 @@ static int pass_accept_req(struct t3cdev *tdev,
struct sk_buff *skb, void *ctx)
 	if (!child_ep) {
 		printk(KERN_ERR MOD "%s - failed to allocate ep
entry!\n",
 		       __func__);
-		l2t_release(L2DATA(tdev), l2t);
+		l2t_release(tdev, l2t);
 		dst_release(dst);
 		goto reject;
 	}
@@ -1956,7 +1956,7 @@ int iwch_connect(struct iw_cm_id *cm_id, struct
iw_cm_conn_param *conn_param)
 	if (!err)
 		goto out;
 
-	l2t_release(L2DATA(h->rdev.t3cdev_p), ep->l2t);
+	l2t_release(h->rdev.t3cdev_p, ep->l2t);
 fail4:
 	dst_release(ep->dst);
 fail3:
@@ -2127,7 +2127,7 @@ int iwch_ep_redirect(void *ctx, struct dst_entry
*old, struct dst_entry *new,
 	PDBG("%s ep %p redirect to dst %p l2t %p\n", __func__, ep, new,
 	     l2t);
 	dst_hold(new);
-	l2t_release(L2DATA(ep->com.tdev), ep->l2t);
+	l2t_release(ep->com.tdev, ep->l2t);
 	ep->l2t = l2t;
 	dst_release(old);
 	ep->dst = new;
diff --git a/drivers/net/cxgb3/cxgb3_offload.c
b/drivers/net/cxgb3/cxgb3_offload.c
index 805076c..da5a5d9 100644
--- a/drivers/net/cxgb3/cxgb3_offload.c
+++ b/drivers/net/cxgb3/cxgb3_offload.c
@@ -1146,12 +1146,14 @@ static void cxgb_redirect(struct dst_entry *old,
struct dst_entry *new)
 		if (te && te->ctx && te->client && te->client->redirect)
{
 			update_tcb = te->client->redirect(te->ctx, old,
new, e);
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
@@ -1264,7 +1266,7 @@ int cxgb3_offload_activate(struct adapter
*adapter)
 		goto out_free;
 
 	err = -ENOMEM;
-	L2DATA(dev) = t3_init_l2t(l2t_capacity);
+	RCU_INIT_POINTER(dev->l2opt, t3_init_l2t(l2t_capacity));
 	if (!L2DATA(dev))
 		goto out_free;
 
@@ -1298,16 +1300,24 @@ int cxgb3_offload_activate(struct adapter
*adapter)
 
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
+	struct l2t_data *d = container_of(head, struct l2t_data,
rcu_head);
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
@@ -1315,8 +1325,11 @@ void cxgb3_offload_deactivate(struct adapter
*adapter)
 
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
index f452c40..3808f99 100644
--- a/drivers/net/cxgb3/l2t.c
+++ b/drivers/net/cxgb3/l2t.c
@@ -300,14 +300,19 @@ static inline void reuse_entry(struct l2t_entry
*e, struct neighbour *neigh)
 struct l2t_entry *t3_l2t_get(struct t3cdev *cdev, struct neighbour
*neigh,
 			     struct net_device *dev)
 {
-	struct l2t_entry *e;
-	struct l2t_data *d = L2DATA(cdev);
+	struct l2t_entry *e = NULL;
+	struct l2t_data *d;
 	u32 addr = *(u32 *) neigh->primary_key;
 	int ifidx = neigh->dev->ifindex;
 	int hash = arp_hash(addr, ifidx, d);
 	struct port_info *p = netdev_priv(dev);
 	int smt_idx = p->port_id;
 
+	rcu_read_lock();
+	d = L2DATA(cdev);
+	if (!d)
+		goto done_rcu;
+
 	write_lock_bh(&d->lock);
 	for (e = d->l2tab[hash].first; e; e = e->next)
 		if (e->addr == addr && e->ifindex == ifidx &&
@@ -338,6 +343,8 @@ struct l2t_entry *t3_l2t_get(struct t3cdev *cdev,
struct neighbour *neigh,
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
@@ -99,7 +100,7 @@ static inline void set_arp_failure_handler(struct
sk_buff *skb,
 /*
  * Getting to the L2 data from an offload device.
  */
-#define L2DATA(dev) ((dev)->l2opt)
+#define L2DATA(cdev) (rcu_dereference((cdev)->l2opt))
 
 #define W_TCB_L2T_IX    0
 #define S_TCB_L2T_IX    7
@@ -126,15 +127,22 @@ static inline int l2t_send(struct t3cdev *dev,
struct sk_buff *skb,
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
-	if (atomic_add_return(1, &e->refcnt) == 1)	/* 0 -> 1
transition */
+	if (d && atomic_add_return(1, &e->refcnt) == 1)	/* 0 -> 1
transition */
 		atomic_dec(&d->nfree);
 }
 
diff --git a/drivers/scsi/cxgbi/cxgb3i/cxgb3i.c
b/drivers/scsi/cxgbi/cxgb3i/cxgb3i.c
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
-- 
1.7.6

