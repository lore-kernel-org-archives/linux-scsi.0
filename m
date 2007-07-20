From: James Bottomley <James.Bottomley@SteelEye.com>
Subject: [PATCH] scsi_transport_sas: add destructor for bsg
Date: Fri, 20 Jul 2007 11:10:05 -0500
Message-ID: <1184947805.3455.21.camel@localhost.localdomain>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from hancock.steeleye.com ([71.30.118.248]:40384 "EHLO
	hancock.sc.steeleye.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S940879AbXGTQKH (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Fri, 20 Jul 2007 12:10:07 -0400
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>
Cc: linux-scsi <linux-scsi@vger.kernel.org>

There's currently no destructor for the bsg components.  If you insert
and remove the module, you see the bsg devices building up and up.  This
patch adds the destructor in the correct place in the transport class so
that the bsg and request queue are removed just before the device
destruction.

James

Index: BUILD-2.6/drivers/scsi/scsi_transport_sas.c
===================================================================
--- BUILD-2.6.orig/drivers/scsi/scsi_transport_sas.c	2007-07-20 10:37:01.000000000 -0500
+++ BUILD-2.6/drivers/scsi/scsi_transport_sas.c	2007-07-20 11:01:07.000000000 -0500
@@ -42,6 +42,7 @@
 struct sas_host_attrs {
 	struct list_head rphy_list;
 	struct mutex lock;
+	struct request_queue *q;
 	u32 next_target_id;
 	u32 next_expander_id;
 	int next_port_id;
@@ -215,6 +216,11 @@ static int sas_bsg_initialize(struct Scs
 	}
 
 	if (rphy)
+		rphy->q = q;
+	else
+		to_sas_host_attrs(shost)->q = q;
+
+	if (rphy)
 		q->queuedata = rphy;
 	else
 		q->queuedata = shost;
@@ -224,6 +230,22 @@ static int sas_bsg_initialize(struct Scs
 	return 0;
 }
 
+static void sas_bsg_remove(struct Scsi_Host *shost, struct sas_rphy *rphy)
+{
+	struct request_queue *q;
+
+	if (rphy)
+		q = rphy->q;
+	else
+		q = to_sas_host_attrs(shost)->q;
+
+	if (!q)
+		return;
+
+	bsg_unregister_queue(q);
+	blk_cleanup_queue(q);
+}
+
 /*
  * SAS host attributes
  */
@@ -249,8 +271,18 @@ static int sas_host_setup(struct transpo
 	return 0;
 }
 
+static int sas_host_remove(struct transport_container *tc, struct device *dev,
+			   struct class_device *cdev)
+{
+	struct Scsi_Host *shost = dev_to_shost(dev);
+
+	sas_bsg_remove(shost, NULL);
+
+	return 0;
+}
+
 static DECLARE_TRANSPORT_CLASS(sas_host_class,
-		"sas_host", sas_host_setup, NULL, NULL);
+		"sas_host", sas_host_setup, sas_host_remove, NULL);
 
 static int sas_host_match(struct attribute_container *cont,
 			    struct device *dev)
@@ -1414,6 +1446,8 @@ void sas_rphy_free(struct sas_rphy *rphy
 	list_del(&rphy->list);
 	mutex_unlock(&sas_host->lock);
 
+	sas_bsg_remove(shost, rphy);
+
 	transport_destroy_device(dev);
 
 	put_device(dev);
Index: BUILD-2.6/include/scsi/scsi_transport_sas.h
===================================================================
--- BUILD-2.6.orig/include/scsi/scsi_transport_sas.h	2007-07-20 10:42:26.000000000 -0500
+++ BUILD-2.6/include/scsi/scsi_transport_sas.h	2007-07-20 10:42:57.000000000 -0500
@@ -91,10 +91,12 @@ struct sas_phy {
 #define phy_to_shost(phy) \
 	dev_to_shost((phy)->dev.parent)
 
+struct request_queue;
 struct sas_rphy {
 	struct device		dev;
 	struct sas_identify	identify;
 	struct list_head	list;
+	struct request_queue	*q;
 	u32			scsi_target_id;
 };
 


