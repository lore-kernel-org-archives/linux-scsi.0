From: "Darrick J. Wong" <djwong@us.ibm.com>
Subject: [PATCH 01/21] libsas: Clean up rphys/port dev list after a discovery error.
Date: Thu, 11 Jan 2007 14:14:49 -0800
Message-ID: <20070111221449.3543.23480.stgit@elm3a70.beaverton.ibm.com>
References: <20070111221443.3543.95584.stgit@elm3a70.beaverton.ibm.com>
Content-Type: text/plain; charset=utf-8; format=fixed
Content-Transfer-Encoding: 8bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from e5.ny.us.ibm.com ([32.97.182.145]:35267 "EHLO e5.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751510AbXAKWOa (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Thu, 11 Jan 2007 17:14:30 -0500
Received: from d01relay02.pok.ibm.com (d01relay02.pok.ibm.com [9.56.227.234])
	by e5.ny.us.ibm.com (8.13.8/8.12.11) with ESMTP id l0BMET6U025852
	for <linux-scsi@vger.kernel.org>; Thu, 11 Jan 2007 17:14:29 -0500
Received: from d01av04.pok.ibm.com (d01av04.pok.ibm.com [9.56.224.64])
	by d01relay02.pok.ibm.com (8.13.6/8.13.6/NCO v8.1.1) with ESMTP id l0BMETBK243852
	for <linux-scsi@vger.kernel.org>; Thu, 11 Jan 2007 17:14:29 -0500
Received: from d01av04.pok.ibm.com (loopback [127.0.0.1])
	by d01av04.pok.ibm.com (8.12.11.20060308/8.13.3) with ESMTP id l0BMETnt016466
	for <linux-scsi@vger.kernel.org>; Thu, 11 Jan 2007 17:14:29 -0500
In-Reply-To: <20070111221443.3543.95584.stgit@elm3a70.beaverton.ibm.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: djwong@us.ibm.com, linux-scsi@vger.kernel.org
Cc: alexisb@us.ibm.com


sas_get_port_device assigns a rphy to a domain device in anticipation
of finding a disk.  When a discovery error occurs in
sas_discover_{sata,sas,expander}*, however, we need to clean up that
rphy and the port device list so that we don't GPF.  In addition, we
need to check the result of the second sas_notify_lldd_dev_found.
This patch seems ok on a x260, x366 and x206m.

Signed-off-by: Darrick J. Wong <djwong@us.ibm.com>
---

 drivers/scsi/libsas/sas_discover.c |   39 ++++++++++++++++++++++++++++++------
 1 files changed, 33 insertions(+), 6 deletions(-)

diff --git a/drivers/scsi/libsas/sas_discover.c b/drivers/scsi/libsas/sas_discover.c
index fb7df7b..21f538e 100644
--- a/drivers/scsi/libsas/sas_discover.c
+++ b/drivers/scsi/libsas/sas_discover.c
@@ -548,7 +548,7 @@ int sas_discover_sata(struct domain_devi
 
 	res = sas_notify_lldd_dev_found(dev);
 	if (res)
-		return res;
+		goto out_err2;
 
 	switch (dev->dev_type) {
 	case SATA_DEV:
@@ -560,11 +560,25 @@ int sas_discover_sata(struct domain_devi
 	default:
 		break;
 	}
+	if (res)
+		goto out_err;
 
 	sas_notify_lldd_dev_gone(dev);
-	if (!res) {
-		sas_notify_lldd_dev_found(dev);
-	}
+	res = sas_notify_lldd_dev_found(dev);
+	if (res)
+		goto out_err2;
+
+	res = sas_rphy_add(dev->rphy);
+	if (res)
+		goto out_err;
+
+	return res;
+
+out_err:
+	sas_notify_lldd_dev_gone(dev);
+out_err2:
+	sas_rphy_free(dev->rphy);
+	dev->rphy = NULL;
 	return res;
 }
 
@@ -580,7 +594,7 @@ int sas_discover_end_dev(struct domain_d
 
 	res = sas_notify_lldd_dev_found(dev);
 	if (res)
-		return res;
+		goto out_err2;
 
 	res = sas_rphy_add(dev->rphy);
 	if (res)
@@ -589,12 +603,21 @@ int sas_discover_end_dev(struct domain_d
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
 
@@ -686,6 +709,10 @@ static void sas_discover_domain(struct w
 	}
 
 	if (error) {
+		spin_lock(&port->dev_list_lock);
+		list_del_init(&port->port_dev->dev_list_node);
+		spin_unlock(&port->dev_list_lock);
+
 		kfree(port->port_dev); /* not kobject_register-ed yet */
 		port->port_dev = NULL;
 	}
