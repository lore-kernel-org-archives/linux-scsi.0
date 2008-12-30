From: James Bottomley <James.Bottomley@HansenPartnership.com>
Subject: [PATCH] fcoe: fix incorrect use of struct module
Date: Tue, 30 Dec 2008 09:48:32 -0600
Message-ID: <1230652112.3296.5.camel@localhost.localdomain>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from accolon.hansenpartnership.com ([76.243.235.52]:58671 "EHLO
	accolon.hansenpartnership.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751076AbYL3Psf (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Tue, 30 Dec 2008 10:48:35 -0500
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: "Love, Robert W" <robert.w.love@intel.com>
Cc: linux-scsi <linux-scsi@vger.kernel.org>, Randy Dunlap <randy.dunlap@oracle.com>

This structure may not be defined if CONFIG_MODULE=n, so never deref
it.  Change uses of module->name to module_name(module) and corrects
some dyslexic printks and docbook comments.

Reported-by: Randy Dunlap <randy.dunlap@oracle.com>
Signed-off-by: James Bottomley <James.Bottomley@HansenPartnership.com>
---
 drivers/scsi/fcoe/libfcoe.c |   10 +++++-----
 1 files changed, 5 insertions(+), 5 deletions(-)

diff --git a/drivers/scsi/fcoe/libfcoe.c b/drivers/scsi/fcoe/libfcoe.c
index 1cb549c..e419f48 100644
--- a/drivers/scsi/fcoe/libfcoe.c
+++ b/drivers/scsi/fcoe/libfcoe.c
@@ -166,7 +166,7 @@ static int fcoe_cpu_callback(struct notifier_block *nfb, unsigned long action,
 #endif /* CONFIG_HOTPLUG_CPU */
 
 /**
- * foce_rcv - this is the fcoe receive function called by NET_RX_SOFTIRQ
+ * fcoe_rcv - this is the fcoe receive function called by NET_RX_SOFTIRQ
  * @skb: the receive skb
  * @dev: associated net device
  * @ptype: context
@@ -991,8 +991,8 @@ static int fcoe_ethdrv_get(const struct net_device *netdev)
 
 	owner = fcoe_netdev_to_module_owner(netdev);
 	if (owner) {
-		printk(KERN_DEBUG "foce:hold driver module %s for %s\n",
-		       owner->name, netdev->name);
+		printk(KERN_DEBUG "fcoe:hold driver module %s for %s\n",
+		       module_name(owner), netdev->name);
 		return  try_module_get(owner);
 	}
 	return -ENODEV;
@@ -1011,8 +1011,8 @@ static int fcoe_ethdrv_put(const struct net_device *netdev)
 
 	owner = fcoe_netdev_to_module_owner(netdev);
 	if (owner) {
-		printk(KERN_DEBUG "foce:release driver module %s for %s\n",
-		       owner->name, netdev->name);
+		printk(KERN_DEBUG "fcoe:release driver module %s for %s\n",
+		       module_name(owner), netdev->name);
 		module_put(owner);
 		return 0;
 	}
-- 
1.5.6.6



