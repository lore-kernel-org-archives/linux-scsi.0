From: malahal@us.ibm.com
Subject: [PATCH] cleanup after a discovery error
Date: Wed, 18 Oct 2006 20:19:10 -0700
Message-ID: <20061019031910.GA16855@us.ibm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from e36.co.us.ibm.com ([32.97.110.154]:45703 "EHLO
	e36.co.us.ibm.com") by vger.kernel.org with ESMTP id S1030293AbWJSDTM
	(ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Wed, 18 Oct 2006 23:19:12 -0400
Received: from d03relay04.boulder.ibm.com (d03relay04.boulder.ibm.com [9.17.195.106])
	by e36.co.us.ibm.com (8.13.8/8.12.11) with ESMTP id k9J3JClC001823
	for <linux-scsi@vger.kernel.org>; Wed, 18 Oct 2006 23:19:12 -0400
Received: from d03av03.boulder.ibm.com (d03av03.boulder.ibm.com [9.17.195.169])
	by d03relay04.boulder.ibm.com (8.13.6/8.13.6/NCO v8.1.1) with ESMTP id k9J3JBMi343994
	for <linux-scsi@vger.kernel.org>; Wed, 18 Oct 2006 21:19:11 -0600
Received: from d03av03.boulder.ibm.com (loopback [127.0.0.1])
	by d03av03.boulder.ibm.com (8.12.11.20060308/8.13.3) with ESMTP id k9J3JBLM006552
	for <linux-scsi@vger.kernel.org>; Wed, 18 Oct 2006 21:19:11 -0600
Received: from malahal.beaverton.ibm.com (malahal.beaverton.ibm.com [9.47.17.93])
	by d03av03.boulder.ibm.com (8.12.11.20060308/8.12.11) with ESMTP id k9J3JBdN006539
	for <linux-scsi@vger.kernel.org>; Wed, 18 Oct 2006 21:19:11 -0600
Content-Disposition: inline
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org

Domain device is freed but the port dev list is not adjusted on some
discovery errors. Module unload will Oops if this happens.

Signed-off-by: Malahal Naineni <malahal@us.ibm.com>

diff -r 4e1720b3c71b drivers/scsi/libsas/sas_discover.c
--- a/drivers/scsi/libsas/sas_discover.c	Thu Oct 05 10:02:13 2006 -0700
+++ b/drivers/scsi/libsas/sas_discover.c	Fri Oct 13 19:58:54 2006 -0700
@@ -684,7 +684,23 @@ static void sas_discover_domain(void *da
 	}
 
 	if (error) {
-		kfree(port->port_dev); /* not kobject_register-ed yet */
+		struct domain_device *dev = port->port_dev;
+		
+		if (dev->rphy) {
+			sas_remove_children(&dev->rphy->dev);
+			sas_rphy_delete(dev->rphy);
+			dev->rphy = NULL;
+		}
+		if (dev->dev_type == EDGE_DEV || dev->dev_type == FANOUT_DEV) {
+			if (dev->ex_dev.ex_phy) {
+				kfree(dev->ex_dev.ex_phy);
+				dev->ex_dev.ex_phy = NULL;
+			}
+		}
+		spin_lock(&port->dev_list_lock);
+		list_del_init(&dev->dev_list_node);
+		spin_unlock(&port->dev_list_lock);
+		kfree(dev); /* not kobject_register-ed yet */
 		port->port_dev = NULL;
 	}
 
