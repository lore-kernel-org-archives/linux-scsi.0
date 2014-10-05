From: James Bottomley <James.Bottomley@HansenPartnership.com>
Subject: [GIT PULL] SCSI fixes for 3.17-rc7
Date: Sat, 04 Oct 2014 21:41:53 -0700
Message-ID: <1412484113.8656.3.camel@jarvis.lan>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from bedivere.hansenpartnership.com ([66.63.167.143]:59741 "EHLO
	bedivere.hansenpartnership.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750801AbaJEElz (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Sun, 5 Oct 2014 00:41:55 -0400
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Andrew Morton <akpm@linux-foundation.org>, Linus Torvalds <torvalds@linux-foundation.org>
Cc: linux-scsi <linux-scsi@vger.kernel.org>, linux-kernel <linux-kernel@vger.kernel.org>

This is a set of two small fixes, both to code which went in during the
merge window: cxgb4i has a scheduling in atomic bug in its new ipv6 code
and uas fails to work properly with the new scsi-mq code.

The patch is available here:

git://git.kernel.org/pub/scm/linux/kernel/git/jejb/scsi.git scsi-fixes

The short changelog is:

Anish Bhatt (1):
      cxgb4i: avoid holding mutex in interrupt context

Christoph Hellwig (1):
      uas: disable use of blk-mq I/O path

And the diffstat

 drivers/scsi/cxgbi/cxgb4i/cxgb4i.c |  2 +-
 drivers/scsi/cxgbi/libcxgbi.c      | 57 ++++++++++++++++++++++++++++++++++----
 drivers/scsi/cxgbi/libcxgbi.h      |  3 ++
 drivers/usb/storage/uas.c          |  7 +++++
 4 files changed, 62 insertions(+), 7 deletions(-)

With full diff below.

James

---

diff --git a/drivers/scsi/cxgbi/cxgb4i/cxgb4i.c b/drivers/scsi/cxgbi/cxgb4i/cxgb4i.c
index 79788a1..02e69e7 100644
--- a/drivers/scsi/cxgbi/cxgb4i/cxgb4i.c
+++ b/drivers/scsi/cxgbi/cxgb4i/cxgb4i.c
@@ -1647,7 +1647,7 @@ static int cxgbi_inet6addr_handler(struct notifier_block *this,
 	if (event_dev->priv_flags & IFF_802_1Q_VLAN)
 		event_dev = vlan_dev_real_dev(event_dev);
 
-	cdev = cxgbi_device_find_by_netdev(event_dev, NULL);
+	cdev = cxgbi_device_find_by_netdev_rcu(event_dev, NULL);
 
 	if (!cdev)
 		return ret;
diff --git a/drivers/scsi/cxgbi/libcxgbi.c b/drivers/scsi/cxgbi/libcxgbi.c
index d65df6d..addd1dd 100644
--- a/drivers/scsi/cxgbi/libcxgbi.c
+++ b/drivers/scsi/cxgbi/libcxgbi.c
@@ -57,6 +57,9 @@ MODULE_PARM_DESC(dbg_level, "libiscsi debug level (default=0)");
 static LIST_HEAD(cdev_list);
 static DEFINE_MUTEX(cdev_mutex);
 
+static LIST_HEAD(cdev_rcu_list);
+static DEFINE_SPINLOCK(cdev_rcu_lock);
+
 int cxgbi_device_portmap_create(struct cxgbi_device *cdev, unsigned int base,
 				unsigned int max_conn)
 {
@@ -142,6 +145,10 @@ struct cxgbi_device *cxgbi_device_register(unsigned int extra,
 	list_add_tail(&cdev->list_head, &cdev_list);
 	mutex_unlock(&cdev_mutex);
 
+	spin_lock(&cdev_rcu_lock);
+	list_add_tail_rcu(&cdev->rcu_node, &cdev_rcu_list);
+	spin_unlock(&cdev_rcu_lock);
+
 	log_debug(1 << CXGBI_DBG_DEV,
 		"cdev 0x%p, p# %u.\n", cdev, nports);
 	return cdev;
@@ -153,9 +160,16 @@ void cxgbi_device_unregister(struct cxgbi_device *cdev)
 	log_debug(1 << CXGBI_DBG_DEV,
 		"cdev 0x%p, p# %u,%s.\n",
 		cdev, cdev->nports, cdev->nports ? cdev->ports[0]->name : "");
+
 	mutex_lock(&cdev_mutex);
 	list_del(&cdev->list_head);
 	mutex_unlock(&cdev_mutex);
+
+	spin_lock(&cdev_rcu_lock);
+	list_del_rcu(&cdev->rcu_node);
+	spin_unlock(&cdev_rcu_lock);
+	synchronize_rcu();
+
 	cxgbi_device_destroy(cdev);
 }
 EXPORT_SYMBOL_GPL(cxgbi_device_unregister);
@@ -167,12 +181,9 @@ void cxgbi_device_unregister_all(unsigned int flag)
 	mutex_lock(&cdev_mutex);
 	list_for_each_entry_safe(cdev, tmp, &cdev_list, list_head) {
 		if ((cdev->flags & flag) == flag) {
-			log_debug(1 << CXGBI_DBG_DEV,
-				"cdev 0x%p, p# %u,%s.\n",
-				cdev, cdev->nports, cdev->nports ?
-				 cdev->ports[0]->name : "");
-			list_del(&cdev->list_head);
-			cxgbi_device_destroy(cdev);
+			mutex_unlock(&cdev_mutex);
+			cxgbi_device_unregister(cdev);
+			mutex_lock(&cdev_mutex);
 		}
 	}
 	mutex_unlock(&cdev_mutex);
@@ -191,6 +202,7 @@ struct cxgbi_device *cxgbi_device_find_by_lldev(void *lldev)
 		}
 	}
 	mutex_unlock(&cdev_mutex);
+
 	log_debug(1 << CXGBI_DBG_DEV,
 		"lldev 0x%p, NO match found.\n", lldev);
 	return NULL;
@@ -230,6 +242,39 @@ struct cxgbi_device *cxgbi_device_find_by_netdev(struct net_device *ndev,
 }
 EXPORT_SYMBOL_GPL(cxgbi_device_find_by_netdev);
 
+struct cxgbi_device *cxgbi_device_find_by_netdev_rcu(struct net_device *ndev,
+						     int *port)
+{
+	struct net_device *vdev = NULL;
+	struct cxgbi_device *cdev;
+	int i;
+
+	if (ndev->priv_flags & IFF_802_1Q_VLAN) {
+		vdev = ndev;
+		ndev = vlan_dev_real_dev(ndev);
+		pr_info("vlan dev %s -> %s.\n", vdev->name, ndev->name);
+	}
+
+	rcu_read_lock();
+	list_for_each_entry_rcu(cdev, &cdev_rcu_list, rcu_node) {
+		for (i = 0; i < cdev->nports; i++) {
+			if (ndev == cdev->ports[i]) {
+				cdev->hbas[i]->vdev = vdev;
+				rcu_read_unlock();
+				if (port)
+					*port = i;
+				return cdev;
+			}
+		}
+	}
+	rcu_read_unlock();
+
+	log_debug(1 << CXGBI_DBG_DEV,
+		  "ndev 0x%p, %s, NO match found.\n", ndev, ndev->name);
+	return NULL;
+}
+EXPORT_SYMBOL_GPL(cxgbi_device_find_by_netdev_rcu);
+
 static struct cxgbi_device *cxgbi_device_find_by_mac(struct net_device *ndev,
 						     int *port)
 {
diff --git a/drivers/scsi/cxgbi/libcxgbi.h b/drivers/scsi/cxgbi/libcxgbi.h
index b3e6e75..1d98fad 100644
--- a/drivers/scsi/cxgbi/libcxgbi.h
+++ b/drivers/scsi/cxgbi/libcxgbi.h
@@ -527,6 +527,7 @@ struct cxgbi_ports_map {
 #define CXGBI_FLAG_IPV4_SET		0x10
 struct cxgbi_device {
 	struct list_head list_head;
+	struct list_head rcu_node;
 	unsigned int flags;
 	struct net_device **ports;
 	void *lldev;
@@ -709,6 +710,8 @@ void cxgbi_device_unregister(struct cxgbi_device *);
 void cxgbi_device_unregister_all(unsigned int flag);
 struct cxgbi_device *cxgbi_device_find_by_lldev(void *);
 struct cxgbi_device *cxgbi_device_find_by_netdev(struct net_device *, int *);
+struct cxgbi_device *cxgbi_device_find_by_netdev_rcu(struct net_device *,
+						     int *);
 int cxgbi_hbas_add(struct cxgbi_device *, u64, unsigned int,
 			struct scsi_host_template *,
 			struct scsi_transport_template *);
diff --git a/drivers/usb/storage/uas.c b/drivers/usb/storage/uas.c
index 3f42785..9bfa725 100644
--- a/drivers/usb/storage/uas.c
+++ b/drivers/usb/storage/uas.c
@@ -970,6 +970,13 @@ static struct scsi_host_template uas_host_template = {
 	.cmd_per_lun = 1,	/* until we override it */
 	.skip_settle_delay = 1,
 	.ordered_tag = 1,
+
+	/*
+	 * The uas drivers expects tags not to be bigger than the maximum
+	 * per-device queue depth, which is not true with the blk-mq tag
+	 * allocator.
+	 */
+	.disable_blk_mq = true,
 };
 
 #define UNUSUAL_DEV(id_vendor, id_product, bcdDeviceMin, bcdDeviceMax, \


