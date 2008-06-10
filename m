From: Christof Schmitt <christof.schmitt@de.ibm.com>
Subject: [patch 8/8] zfcp: Remove sysfs attribute port_add
Date: Tue, 10 Jun 2008 18:21:01 +0200
Message-ID: <20080610162519.454157000@de.ibm.com>
References: <20080610162053.144590000@de.ibm.com>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mtagate4.de.ibm.com ([195.212.29.153]:47128 "EHLO
	mtagate4.de.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753054AbYFJQZY (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Tue, 10 Jun 2008 12:25:24 -0400
Content-Disposition: inline; filename=zfcp_remove_port_add_sysfs_attribute.diff
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James Bottomley <James.Bottomley@HansenPartnership.com>
Cc: linux-scsi@vger.kernel.org, linux-s390@vger.kernel.org, Martin Peschke <mp3@de.ibm.com>, Christof Schmitt <christof.schmitt@de.ibm.com>

From: Martin Peschke <mp3@de.ibm.com>

With the automatic scanning of remote ports in place, there is no need
to add remote ports manually. So, remove the port_add attribute.

Signed-off-by: Martin Peschke <mp3@de.ibm.com>
Signed-off-by: Christof Schmitt <christof.schmitt@de.ibm.com>
---
 drivers/s390/scsi/zfcp_sysfs_adapter.c |   46 ---------------------------------
 1 file changed, 46 deletions(-)

--- a/drivers/s390/scsi/zfcp_sysfs_adapter.c	2008-06-04 14:31:05.000000000 +0200
+++ b/drivers/s390/scsi/zfcp_sysfs_adapter.c	2008-06-04 14:31:08.000000000 +0200
@@ -40,51 +40,6 @@ ZFCP_DEFINE_ADAPTER_ATTR(in_recovery, "%
 			 (ZFCP_STATUS_COMMON_ERP_INUSE, &adapter->status));
 
 /**
- * zfcp_sysfs_port_add_store - add a port to sysfs tree
- * @dev: pointer to belonging device
- * @buf: pointer to input buffer
- * @count: number of bytes in buffer
- *
- * Store function of the "port_add" attribute of an adapter.
- */
-static ssize_t
-zfcp_sysfs_port_add_store(struct device *dev, struct device_attribute *attr, const char *buf, size_t count)
-{
-	wwn_t wwpn;
-	char *endp;
-	struct zfcp_adapter *adapter;
-	struct zfcp_port *port;
-	int retval = -EINVAL;
-
-	down(&zfcp_data.config_sema);
-
-	adapter = dev_get_drvdata(dev);
-	if (atomic_test_mask(ZFCP_STATUS_COMMON_REMOVE, &adapter->status)) {
-		retval = -EBUSY;
-		goto out;
-	}
-
-	wwpn = simple_strtoull(buf, &endp, 0);
-	if ((endp + 1) < (buf + count))
-		goto out;
-
-	port = zfcp_port_enqueue(adapter, wwpn, 0, 0);
-	if (!port)
-		goto out;
-
-	retval = 0;
-
-	zfcp_erp_port_reopen(port, 0, 91, NULL);
-	zfcp_erp_wait(port->adapter);
-	zfcp_port_put(port);
- out:
-	up(&zfcp_data.config_sema);
-	return retval ? retval : (ssize_t) count;
-}
-
-static DEVICE_ATTR(port_add, S_IWUSR, NULL, zfcp_sysfs_port_add_store);
-
-/**
  * zfcp_sysfs_port_rescan - trigger manual port rescan
  * @dev: pointer to belonging device
  * @attr: pointer to struct device_attribute
@@ -237,7 +192,6 @@ static struct attribute *zfcp_adapter_at
 	&dev_attr_failed.attr,
 	&dev_attr_in_recovery.attr,
 	&dev_attr_port_remove.attr,
-	&dev_attr_port_add.attr,
 	&dev_attr_port_rescan.attr,
 	&dev_attr_peer_wwnn.attr,
 	&dev_attr_peer_wwpn.attr,

-- 
