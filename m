From: Alexis Bruemmer <alexisb@us.ibm.com>
Subject: [PATCH] aic94xx: Hotplug ex_change_count race fix
Date: Tue, 26 Sep 2006 15:05:20 -0700
Message-ID: <1159308320.9567.55.camel@alexis>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from e6.ny.us.ibm.com ([32.97.182.146]:46977 "EHLO e6.ny.us.ibm.com")
	by vger.kernel.org with ESMTP id S932437AbWIZWF2 (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Tue, 26 Sep 2006 18:05:28 -0400
Received: from d01relay04.pok.ibm.com (d01relay04.pok.ibm.com [9.56.227.236])
	by e6.ny.us.ibm.com (8.13.8/8.12.11) with ESMTP id k8QM5Z0C021238
	for <linux-scsi@vger.kernel.org>; Tue, 26 Sep 2006 18:05:35 -0400
Received: from d01av04.pok.ibm.com (d01av04.pok.ibm.com [9.56.224.64])
	by d01relay04.pok.ibm.com (8.13.6/8.13.6/NCO v8.1.1) with ESMTP id k8QM5SCN104602
	for <linux-scsi@vger.kernel.org>; Tue, 26 Sep 2006 18:05:28 -0400
Received: from d01av04.pok.ibm.com (loopback [127.0.0.1])
	by d01av04.pok.ibm.com (8.12.11.20060308/8.13.3) with ESMTP id k8QM5RAY029806
	for <linux-scsi@vger.kernel.org>; Tue, 26 Sep 2006 18:05:27 -0400
Received: from [9.47.17.62] (dyn9047017062.beaverton.ibm.com [9.47.17.62])
	by d01av04.pok.ibm.com (8.12.11.20060308/8.12.11) with ESMTP id k8QM5RR9029748
	for <linux-scsi@vger.kernel.org>; Tue, 26 Sep 2006 18:05:27 -0400
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi <linux-scsi@vger.kernel.org>

In some cases while hotplugging disks on a system with an expander the
broadcast primitive will be posted and begin processing before the
expander change count is updated.  This causes the device that triggered
the broadcast to not be found.

--Alexis   



Signed-off-by: Alexis Bruemmer <alexisb@us.ibm.com>

-------

diff -pNura linux-2.6.18-git4-orig/drivers/scsi/libsas/sas_expander.c linux-2.6.18-git4/drivers/scsi/libsas/sas_expander.c
--- linux-2.6.18-git4-orig/drivers/scsi/libsas/sas_expander.c	2006-09-26 07:42:43.000000000 -0700
+++ linux-2.6.18-git4/drivers/scsi/libsas/sas_expander.c	2006-09-26 08:28:50.000000000 -0700
@@ -24,6 +24,7 @@
 
 #include <linux/pci.h>
 #include <linux/scatterlist.h>
+#include <linux/delay.h>
 
 #include "sas_internal.h"
 
@@ -1760,23 +1761,34 @@ out:
 int sas_ex_revalidate_domain(struct domain_device *port_dev)
 {
 	int res;
+	int i;
 	struct domain_device *dev = NULL;
 
-	res = sas_find_bcast_dev(port_dev, &dev);
-	if (res)
-		goto out;
-	if (dev) {
-		struct expander_device *ex = &dev->ex_dev;
-		int i = 0, phy_id;
-
-		do {
-			phy_id = -1;
-			res = sas_find_bcast_phy(dev, &phy_id, i);
-			if (phy_id == -1)
-				break;
-			res = sas_rediscover(dev, phy_id);
-			i = phy_id + 1;
-		} while (i < ex->num_phys);
+	
+	/* Some expanders seem to generate a BROADCAST primitive before
+	 * they actually update their own "expander change count" field!
+	 * If we didn't find a device that caused the BROADCAST
+	 * primitive, let us wait and retry.
+	 */
+	for (i = 0; i < 2; i++) {
+		res = sas_find_bcast_dev(port_dev, &dev);
+		if (res)
+			goto out;
+		if (dev) {
+			struct expander_device *ex = &dev->ex_dev;
+			int i = 0, phy_id;
+
+			do {
+				phy_id = -1;
+				res = sas_find_bcast_phy(dev, &phy_id, i);
+				if (phy_id == -1)
+					break;
+				res = sas_rediscover(dev, phy_id);
+				i = phy_id + 1;
+			} while (i < ex->num_phys);
+			break;
+		}
+		ssleep(1);
 	}
 out:
 	return res;


