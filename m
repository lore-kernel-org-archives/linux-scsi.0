From: Dan Williams <dan.j.williams@intel.com>
Subject: [RFT PATCH] libsas: fix port->dev_list locking
Date: Wed, 21 Sep 2011 22:05:34 -0700
Message-ID: <20110922050125.32188.27056.stgit@localhost6.localdomain6>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mga02.intel.com ([134.134.136.20]:47862 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750721Ab1IVFFp (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Thu, 22 Sep 2011 01:05:45 -0400
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org
Cc: Xiangliang Yu <yuxiangl@marvell.com>, Mark Salyzyn <msalyzyn@us.xyratex.com>, Christoph Hellwig <hch@lst.de>, Luben Tuikov <ltuikov@yahoo.com>, Jack Wang <jack_wang@usish.com>

port->dev_list maintains a list of devices attached to a given sas root port.
It needs to be mutated under a lock as contexts outside of the
single-threaded-libsas-workqueue access the list via sas_find_dev_by_rphy().
Fixup locations where the list was being mutated without a lock.

This is a follow-up to commit 5911e963 "[SCSI] libsas: remove expander
from dev list on error", where Luben noted [1]:

    > 2/ We have unlocked list manipulations in sas_ex_discover_end_dev(),
    > sas_unregister_common_dev(), and sas_ex_discover_end_dev()

    Yes, I can see that and that is very unfortunate.

[1]: http://marc.info/?l=linux-scsi&m=131480962006471&w=2

Cc: Christoph Hellwig <hch@lst.de>
Cc: Xiangliang Yu <yuxiangl@marvell.com>
Cc: Jack Wang <jack_wang@usish.com>
Cc: Mark Salyzyn <msalyzyn@us.xyratex.com>
Cc: Luben Tuikov <ltuikov@yahoo.com>
Signed-off-by: Dan Williams <dan.j.williams@intel.com>
---
lockdep does not complain in a simple driver load/unload test on an expander
topology, but want to get wider review / testing before committing.

 drivers/scsi/libsas/sas_discover.c |   13 ++++++++-----
 drivers/scsi/libsas/sas_expander.c |   15 +++++++++------
 include/scsi/libsas.h              |    2 +-
 3 files changed, 18 insertions(+), 12 deletions(-)

diff --git a/drivers/scsi/libsas/sas_discover.c b/drivers/scsi/libsas/sas_discover.c
index f583193..54a5199 100644
--- a/drivers/scsi/libsas/sas_discover.c
+++ b/drivers/scsi/libsas/sas_discover.c
@@ -219,17 +219,20 @@ out_err2:
 
 /* ---------- Device registration and unregistration ---------- */
 
-static inline void sas_unregister_common_dev(struct domain_device *dev)
+static void sas_unregister_common_dev(struct asd_sas_port *port, struct domain_device *dev)
 {
 	sas_notify_lldd_dev_gone(dev);
 	if (!dev->parent)
 		dev->port->port_dev = NULL;
 	else
 		list_del_init(&dev->siblings);
+
+	spin_lock_irq(&port->dev_list_lock);
 	list_del_init(&dev->dev_list_node);
+	spin_unlock_irq(&port->dev_list_lock);
 }
 
-void sas_unregister_dev(struct domain_device *dev)
+void sas_unregister_dev(struct asd_sas_port *port, struct domain_device *dev)
 {
 	if (dev->rphy) {
 		sas_remove_children(&dev->rphy->dev);
@@ -241,15 +244,15 @@ void sas_unregister_dev(struct domain_device *dev)
 		kfree(dev->ex_dev.ex_phy);
 		dev->ex_dev.ex_phy = NULL;
 	}
-	sas_unregister_common_dev(dev);
+	sas_unregister_common_dev(port, dev);
 }
 
 void sas_unregister_domain_devices(struct asd_sas_port *port)
 {
 	struct domain_device *dev, *n;
 
-	list_for_each_entry_safe_reverse(dev,n,&port->dev_list,dev_list_node)
-		sas_unregister_dev(dev);
+	list_for_each_entry_safe_reverse(dev, n, &port->dev_list, dev_list_node)
+		sas_unregister_dev(port, dev);
 
 	port->port->rphy = NULL;
 
diff --git a/drivers/scsi/libsas/sas_expander.c b/drivers/scsi/libsas/sas_expander.c
index 281d01b..969b315 100644
--- a/drivers/scsi/libsas/sas_expander.c
+++ b/drivers/scsi/libsas/sas_expander.c
@@ -752,7 +752,10 @@ static struct domain_device *sas_ex_discover_end_dev(
  out_list_del:
 	sas_rphy_free(child->rphy);
 	child->rphy = NULL;
+
+	spin_lock_irq(&parent->port->dev_list_lock);
 	list_del(&child->dev_list_node);
+	spin_unlock_irq(&parent->port->dev_list_lock);
  out_free:
 	sas_port_delete(phy->port);
  out_err:
@@ -1737,7 +1740,7 @@ out:
 	return res;
 }
 
-static void sas_unregister_ex_tree(struct domain_device *dev)
+static void sas_unregister_ex_tree(struct asd_sas_port *port, struct domain_device *dev)
 {
 	struct expander_device *ex = &dev->ex_dev;
 	struct domain_device *child, *n;
@@ -1746,11 +1749,11 @@ static void sas_unregister_ex_tree(struct domain_device *dev)
 		child->gone = 1;
 		if (child->dev_type == EDGE_DEV ||
 		    child->dev_type == FANOUT_DEV)
-			sas_unregister_ex_tree(child);
+			sas_unregister_ex_tree(port, child);
 		else
-			sas_unregister_dev(child);
+			sas_unregister_dev(port, child);
 	}
-	sas_unregister_dev(dev);
+	sas_unregister_dev(port, dev);
 }
 
 static void sas_unregister_devs_sas_addr(struct domain_device *parent,
@@ -1767,9 +1770,9 @@ static void sas_unregister_devs_sas_addr(struct domain_device *parent,
 				child->gone = 1;
 				if (child->dev_type == EDGE_DEV ||
 				    child->dev_type == FANOUT_DEV)
-					sas_unregister_ex_tree(child);
+					sas_unregister_ex_tree(parent->port, child);
 				else
-					sas_unregister_dev(child);
+					sas_unregister_dev(parent->port, child);
 				break;
 			}
 		}
diff --git a/include/scsi/libsas.h b/include/scsi/libsas.h
index 793f80b..67be7f5 100644
--- a/include/scsi/libsas.h
+++ b/include/scsi/libsas.h
@@ -655,7 +655,7 @@ int  sas_discover_event(struct asd_sas_port *, enum discover_event ev);
 int  sas_discover_sata(struct domain_device *);
 int  sas_discover_end_dev(struct domain_device *);
 
-void sas_unregister_dev(struct domain_device *);
+void sas_unregister_dev(struct asd_sas_port *port, struct domain_device *);
 
 void sas_init_dev(struct domain_device *);
 

