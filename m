From: Neil Horman <nhorman@tuxdriver.com>
Subject: [PATCH] cxgb3i: ref count cdev access to prevent modification while in use (v2)
Date: Thu, 11 Aug 2011 10:55:11 -0400
Message-ID: <1313074511-11431-1-git-send-email-nhorman@tuxdriver.com>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from charlotte.tuxdriver.com ([70.61.120.58]:56431 "EHLO
	smtp.tuxdriver.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751067Ab1HKOzX (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Thu, 11 Aug 2011 10:55:23 -0400
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org
Cc: Neil Horman <nhorman@tuxdriver.com>, Divy Le Ray <divy@chelsio.com>, Steve Wise <swise@chelsio.com>, Karen Xie <kxie@chelsio.com>, Mike Christie <michaelc@cs.wisc.edu>, "James E.J. Bottomley" <JBottomley@parallels.com>, stable@vger.kernel.org

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
[c0000000fd4c7500] d000000000e45378 .cxgbi_ep_connect+0x784/0x8e8 [libcxgbi]
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

The root cause was an EEH error, which sent us down the offload_close path in
the cxgb3 driver, which in turn sets cdev->lldev to NULL, without regard for
upper layer driver (like the cxgbi drivers) which might have execution contexts
in the middle of its use. The result is the oops above, when t3_l2t_get attempts
to dereference cdev->lldev right after the EEH error handler sets it to NULL.

The fix is to reference count the cdev structure.  When an EEH error occurs, the
shutdown path:
t3_adapter_error->offload_close->cxgb3i_remove_clients->cxgb3i_dev_close
will now block until such time as the cdev pointer has a use count of zero.
This coupled with the fact that lookups will now skip finding any registered
cdev's in cxgbi_device_find_by_[lldev|netdev] with the CXGBI_FLAG_ADAPTER_RESET
bit set ensures that on an EEH, the setting of lldev to NULL in offload_close
will only happen after there are no longer any active users of the data
structure.

This has been tested by the reporter and shown to fix the reproted oops

Change notes:

v2) Resent because of some build warnings with the first version on request of
JBottomley

Signed-off-by: Neil Horman <nhorman@tuxdriver.com>
CC: Divy Le Ray <divy@chelsio.com>
CC: Steve Wise <swise@chelsio.com>
CC: Karen Xie <kxie@chelsio.com>
CC: Mike Christie <michaelc@cs.wisc.edu>
CC: "James E.J. Bottomley" <JBottomley@parallels.com>
CC: stable@vger.kernel.org
---
 drivers/scsi/cxgbi/cxgb3i/cxgb3i.c |    8 +++++++-
 drivers/scsi/cxgbi/libcxgbi.c      |   11 ++++++++++-
 drivers/scsi/cxgbi/libcxgbi.h      |    3 +++
 3 files changed, 20 insertions(+), 2 deletions(-)

diff --git a/drivers/scsi/cxgbi/cxgb3i/cxgb3i.c b/drivers/scsi/cxgbi/cxgb3i/cxgb3i.c
index bd22041..d04e167 100644
--- a/drivers/scsi/cxgbi/cxgb3i/cxgb3i.c
+++ b/drivers/scsi/cxgbi/cxgb3i/cxgb3i.c
@@ -1303,9 +1303,13 @@ static void cxgb3i_dev_close(struct t3cdev *t3dev)
 
 	if (!cdev || cdev->flags & CXGBI_FLAG_ADAPTER_RESET) {
 		pr_info("0x%p close, f 0x%x.\n", cdev, cdev ? cdev->flags : 0);
+		if (cdev)
+			cdev_put(cdev);
+		while (cdev && atomic_read(&cdev->use_count) != 0)
+			msleep(1);
 		return;
 	}
-
+	cdev_put(cdev);
 	cxgbi_device_unregister(cdev);
 }
 
@@ -1320,6 +1324,7 @@ static void cxgb3i_dev_open(struct t3cdev *t3dev)
 	int i, err;
 
 	if (cdev) {
+		cdev_put(cdev);
 		pr_info("0x%p, updating.\n", cdev);
 		return;
 	}
@@ -1392,6 +1397,7 @@ static void cxgb3i_dev_event_handler(struct t3cdev *t3dev, u32 event, u32 port)
 		cdev->flags &= ~CXGBI_FLAG_ADAPTER_RESET;
 		break;
 	}
+	cdev_put(cdev);
 }
 
 /**
diff --git a/drivers/scsi/cxgbi/libcxgbi.c b/drivers/scsi/cxgbi/libcxgbi.c
index 77ac217..0890728 100644
--- a/drivers/scsi/cxgbi/libcxgbi.c
+++ b/drivers/scsi/cxgbi/libcxgbi.c
@@ -181,6 +181,9 @@ struct cxgbi_device *cxgbi_device_find_by_lldev(void *lldev)
 	mutex_lock(&cdev_mutex);
 	list_for_each_entry_safe(cdev, tmp, &cdev_list, list_head) {
 		if (cdev->lldev == lldev) {
+			if (cdev->flags & CXGBI_FLAG_ADAPTER_RESET)
+				continue;
+			cdev_hold(cdev);
 			mutex_unlock(&cdev_mutex);
 			return cdev;
 		}
@@ -210,7 +213,10 @@ static struct cxgbi_device *cxgbi_device_find_by_netdev(struct net_device *ndev,
 	list_for_each_entry_safe(cdev, tmp, &cdev_list, list_head) {
 		for (i = 0; i < cdev->nports; i++) {
 			if (ndev == cdev->ports[i]) {
+				if (cdev->flags & CXGBI_FLAG_ADAPTER_RESET)
+					continue;
 				cdev->hbas[i]->vdev = vdev;
+				cdev_hold(cdev);
 				mutex_unlock(&cdev_mutex);
 				if (port)
 					*port = i;
@@ -469,7 +475,7 @@ static struct cxgbi_sock *cxgbi_check_route(struct sockaddr *dst_addr)
 	struct sockaddr_in *daddr = (struct sockaddr_in *)dst_addr;
 	struct dst_entry *dst;
 	struct net_device *ndev;
-	struct cxgbi_device *cdev;
+	struct cxgbi_device *cdev = NULL;
 	struct rtable *rt = NULL;
 	struct flowi4 fl4;
 	struct cxgbi_sock *csk = NULL;
@@ -542,6 +548,8 @@ rel_rt:
 	if (csk)
 		cxgbi_sock_closed(csk);
 err_out:
+	if (cdev)
+		cdev_put(cdev);
 	return ERR_PTR(err);
 }
 
@@ -2491,6 +2499,7 @@ struct iscsi_endpoint *cxgbi_ep_connect(struct Scsi_Host *shost,
 	return ep;
 
 release_conn:
+	cdev_put(csk->cdev);
 	cxgbi_sock_put(csk);
 	cxgbi_sock_closed(csk);
 err_out:
diff --git a/drivers/scsi/cxgbi/libcxgbi.h b/drivers/scsi/cxgbi/libcxgbi.h
index 9267844..aad1749 100644
--- a/drivers/scsi/cxgbi/libcxgbi.h
+++ b/drivers/scsi/cxgbi/libcxgbi.h
@@ -514,6 +514,7 @@ struct cxgbi_device {
 	unsigned int flags;
 	struct net_device **ports;
 	void *lldev;
+	atomic_t use_count;
 	struct cxgbi_hba **hbas;
 	const unsigned short *mtus;
 	unsigned char nmtus;
@@ -557,6 +558,8 @@ struct cxgbi_device {
 	void *dd_data;
 };
 #define cxgbi_cdev_priv(cdev)	((cdev)->dd_data)
+#define cdev_hold(x) do {atomic_inc(&x->use_count);} while(0)
+#define cdev_put(x) do {atomic_dec(&x->use_count);} while(0)
 
 struct cxgbi_conn {
 	struct cxgbi_endpoint *cep;
-- 
1.7.6

