From: "Darrick J. Wong" <djwong@us.ibm.com>
Subject: [PATCH 3/7] libsas: Check return values of sysfs_create_link
Date: Fri, 26 Jan 2007 14:08:46 -0800
Message-ID: <20070126220846.20198.13342.stgit@elm3a70.beaverton.ibm.com>
References: <20070126220834.20198.21100.stgit@elm3a70.beaverton.ibm.com>
Content-Type: text/plain; charset=utf-8; format=fixed
Content-Transfer-Encoding: 8bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from e4.ny.us.ibm.com ([32.97.182.144]:48491 "EHLO e4.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1030243AbXAZWJP (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Fri, 26 Jan 2007 17:09:15 -0500
Received: from d01relay04.pok.ibm.com (d01relay04.pok.ibm.com [9.56.227.236])
	by e4.ny.us.ibm.com (8.13.8/8.12.11) with ESMTP id l0QM9C27002567
	for <linux-scsi@vger.kernel.org>; Fri, 26 Jan 2007 17:09:12 -0500
Received: from d01av03.pok.ibm.com (d01av03.pok.ibm.com [9.56.224.217])
	by d01relay04.pok.ibm.com (8.13.8/8.13.8/NCO v8.2) with ESMTP id l0QM6rNT290288
	for <linux-scsi@vger.kernel.org>; Fri, 26 Jan 2007 17:06:53 -0500
Received: from d01av03.pok.ibm.com (loopback [127.0.0.1])
	by d01av03.pok.ibm.com (8.12.11.20060308/8.13.3) with ESMTP id l0QM6rod012326
	for <linux-scsi@vger.kernel.org>; Fri, 26 Jan 2007 17:06:53 -0500
In-Reply-To: <20070126220834.20198.21100.stgit@elm3a70.beaverton.ibm.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: djwong@us.ibm.com, linux-scsi@vger.kernel.org
Cc: alexisb@us.ibm.com


Get rid of: "warning: ignoring return value of sysfs_create_link..."

Signed-off-by: Darrick J. Wong <djwong@us.ibm.com>
---

 drivers/scsi/scsi_transport_sas.c |   26 ++++++++++++++++++++++----
 1 files changed, 22 insertions(+), 4 deletions(-)

diff --git a/drivers/scsi/scsi_transport_sas.c b/drivers/scsi/scsi_transport_sas.c
index a5142eb..bd18f01 100644
--- a/drivers/scsi/scsi_transport_sas.c
+++ b/drivers/scsi/scsi_transport_sas.c
@@ -625,8 +625,19 @@ static void sas_port_release(struct devi
 static void sas_port_create_link(struct sas_port *port,
 				 struct sas_phy *phy)
 {
-	sysfs_create_link(&port->dev.kobj, &phy->dev.kobj, phy->dev.bus_id);
-	sysfs_create_link(&phy->dev.kobj, &port->dev.kobj, "port");
+	int res;
+
+	res = sysfs_create_link(&port->dev.kobj, &phy->dev.kobj,
+				phy->dev.bus_id);
+	if (res)
+		goto err;
+	res = sysfs_create_link(&phy->dev.kobj, &port->dev.kobj, "port");
+	if (res)
+		goto err;
+	return;
+err:
+	printk(KERN_ERR "%s: Cannot create port links, err=%d\n",
+	       __FUNCTION__, res);
 }
 
 static void sas_port_delete_link(struct sas_port *port,
@@ -864,13 +875,20 @@ EXPORT_SYMBOL(sas_port_delete_phy);
 
 void sas_port_mark_backlink(struct sas_port *port)
 {
+	int res;
 	struct device *parent = port->dev.parent->parent->parent;
 
 	if (port->is_backlink)
 		return;
 	port->is_backlink = 1;
-	sysfs_create_link(&port->dev.kobj, &parent->kobj,
-			  parent->bus_id);
+	res = sysfs_create_link(&port->dev.kobj, &parent->kobj,
+				parent->bus_id);
+	if (res)
+		goto err;
+	return;
+err:
+	printk(KERN_ERR "%s: Cannot create port backlink, err=%d\n",
+	       __FUNCTION__, res);
 
 }
 EXPORT_SYMBOL(sas_port_mark_backlink);
