From: Alexis Bruemmer <alexisb@us.ibm.com>
Subject: [PATCH 3/4] aic94xx: cleanup after a discovery error
Date: Thu, 09 Nov 2006 12:03:56 -0800
Message-ID: <1163102636.6521.19.camel@localhost.localdomain>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from e1.ny.us.ibm.com ([32.97.182.141]:1975 "EHLO e1.ny.us.ibm.com")
	by vger.kernel.org with ESMTP id S965418AbWKIUES (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Thu, 9 Nov 2006 15:04:18 -0500
Received: from d01relay04.pok.ibm.com (d01relay04.pok.ibm.com [9.56.227.236])
	by e1.ny.us.ibm.com (8.13.8/8.12.11) with ESMTP id kA9K4I30015332
	for <linux-scsi@vger.kernel.org>; Thu, 9 Nov 2006 15:04:18 -0500
Received: from d01av02.pok.ibm.com (d01av02.pok.ibm.com [9.56.224.216])
	by d01relay04.pok.ibm.com (8.13.6/8.13.6/NCO v8.1.1) with ESMTP id kA9K3wqa226030
	for <linux-scsi@vger.kernel.org>; Thu, 9 Nov 2006 15:04:00 -0500
Received: from d01av02.pok.ibm.com (loopback [127.0.0.1])
	by d01av02.pok.ibm.com (8.12.11.20060308/8.13.3) with ESMTP id kA9K3wcF027521
	for <linux-scsi@vger.kernel.org>; Thu, 9 Nov 2006 15:03:58 -0500
Received: from [9.48.54.0] ([9.48.54.0])
	by d01av02.pok.ibm.com (8.12.11.20060308/8.12.11) with ESMTP id kA9K3vk2027489
	for <linux-scsi@vger.kernel.org>; Thu, 9 Nov 2006 15:03:58 -0500
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi <linux-scsi@vger.kernel.org>

Domain device is freed but the port dev list is not adjusted on some
discovery errors. Module unload will Oops if this happens.


Signed-off-by: Darrick J. Wong <djwong@us.ibm.com>

--- 

diff --git a/drivers/scsi/libsas/sas_discover.c b/drivers/scsi/libsas/sas_discover.c
index 23461dc..dcd0461 100644
--- a/drivers/scsi/libsas/sas_discover.c
+++ b/drivers/scsi/libsas/sas_discover.c
@@ -585,7 +598,7 @@ int sas_discover_end_dev(struct domain_d
 
 	res = sas_notify_lldd_dev_found(dev);
 	if (res)
-		return res;
+		goto out_err2;
 
 	res = sas_rphy_add(dev->rphy);
 	if (res)
@@ -594,12 +607,21 @@ int sas_discover_end_dev(struct domain_d
 	/* do this to get the end device port attributes which will have
 	 * been scanned in sas_rphy_add */
 	sas_notify_lldd_dev_gone(dev);
-	sas_notify_lldd_dev_found(dev);
+	res = sas_notify_lldd_dev_found(dev);
+	if (res)
+		goto out_err3;
 
 	return 0;
 
 out_err:
 	sas_notify_lldd_dev_gone(dev);
+out_err2:
+	sas_rphy_free(dev->rphy);
+	dev->rphy = NULL;
+	return res;
+out_err3:
+	sas_rphy_delete(dev->rphy);
+	dev->rphy = NULL;
 	return res;
 }
 
@@ -689,6 +711,10 @@ static void sas_discover_domain(void *da
 	}
 
 	if (error) {
+		spin_lock(&port->dev_list_lock);
+		list_del_init(&port->port_dev->dev_list_node);
+		spin_unlock(&port->dev_list_lock);
+
 		kfree(port->port_dev); /* not kobject_register-ed yet */
 		port->port_dev = NULL;
 	}
diff --git a/drivers/scsi/libsas/sas_expander.c b/drivers/scsi/libsas/sas_expander.c
index 4cc7457..a79e89c 100644
--- a/drivers/scsi/libsas/sas_expander.c
+++ b/drivers/scsi/libsas/sas_expander.c
@@ -1474,14 +1474,27 @@ int sas_discover_root_expander(struct do
 	int res;
 	struct sas_expander_device *ex = rphy_to_expander_device(dev->rphy);
 
-	sas_rphy_add(dev->rphy);
+	res = sas_rphy_add(dev->rphy);
+	if (res)
+		goto out_err;
 
 	ex->level = dev->port->disc.max_level; /* 0 */
 	res = sas_discover_expander(dev);
-	if (!res)
-		sas_ex_bfs_disc(dev->port);
+	if (res)
+		goto out_err2;
+
+	sas_ex_bfs_disc(dev->port);
 
 	return res;
+
+out_err2:
+	sas_rphy_delete(dev->rphy);
+	dev->rphy = NULL;
+	return res;
+out_err:
+	sas_rphy_free(dev->rphy);
+	dev->rphy = NULL;
+	return res;
 }
 
 /* ---------- Domain revalidation ---------- */

---

One question that remains with this patch is whether or not 
sas_get_port_device should be moved into sas_discover_{sas,expander} to
ensure that the rphy struct is allocated and freed-in-error in the same
function 


