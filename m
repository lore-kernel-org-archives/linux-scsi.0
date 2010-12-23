From: Bart Van Assche <bvanassche@acm.org>
Subject: [SCSI] ibmvstgt: Remove sysfs attributes
Date: Thu, 23 Dec 2010 11:12:31 +0100
Message-ID: <201012231112.31775.bvanassche@acm.org>
Mime-Version: 1.0
Content-Type: Text/Plain;
  charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from jester.euphonynet.be ([212.87.96.13]:58552 "EHLO
	mailpush2.euphonynet.be" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752522Ab0LWKMm (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Thu, 23 Dec 2010 05:12:42 -0500
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org
Cc: scst-devel@lists.sourceforge.net, Fujita Tomonori <fujita.tomonori@lab.ntt.co.jp>, Brian King <brking@linux.vnet.ibm.com>, Robert Jennings <rcj@linux.vnet.ibm.com>

The sysfs attributes system_id, partition_number and unit address as
made available by the ibmvstgt driver based on SCST are not used by any
user space software, hence remove these.

Signed-off-by: Bart Van Assche <bvanassche@acm.org>
Cc: Fujita Tomonori <fujita.tomonori@lab.ntt.co.jp>
Cc: Brian King <brking@linux.vnet.ibm.com>
Cc: Robert Jennings <rcj@linux.vnet.ibm.com>
---
 drivers/scsi/ibmvscsi/ibmvstgt.c |   60 +-------------------------------------
 1 files changed, 1 insertions(+), 59 deletions(-)

diff --git a/drivers/scsi/ibmvscsi/ibmvstgt.c b/drivers/scsi/ibmvscsi/ibmvstgt.c
index 9904c8c..d12e4e5 100644
--- a/drivers/scsi/ibmvscsi/ibmvstgt.c
+++ b/drivers/scsi/ibmvscsi/ibmvstgt.c
@@ -81,7 +81,6 @@ struct vio_port {
 	struct srp_target *target;
 
 	struct scst_session *sess;
-	struct device dev;
 	bool releasing;
 	bool enabled;
 };
@@ -1113,46 +1112,6 @@ out:
 	return res;
 }
 
-static ssize_t system_id_show(struct device *dev,
-			      struct device_attribute *attr, char *buf)
-{
-	return snprintf(buf, PAGE_SIZE, "%s\n", system_id);
-}
-
-static ssize_t partition_number_show(struct device *dev,
-				     struct device_attribute *attr, char *buf)
-{
-	return snprintf(buf, PAGE_SIZE, "%x\n", partition_number);
-}
-
-static ssize_t unit_address_show(struct device *dev,
-				  struct device_attribute *attr, char *buf)
-{
-	struct vio_port *vport = container_of(dev, struct vio_port, dev);
-	return snprintf(buf, PAGE_SIZE, "%x\n", vport->dma_dev->unit_address);
-}
-
-static struct class_attribute ibmvstgt_class_attrs[] = {
-	__ATTR_NULL,
-};
-
-static struct device_attribute ibmvstgt_attrs[] = {
-	__ATTR(system_id, S_IRUGO, system_id_show, NULL),
-	__ATTR(partition_number, S_IRUGO, partition_number_show, NULL),
-	__ATTR(unit_address, S_IRUGO, unit_address_show, NULL),
-	__ATTR_NULL,
-};
-
-static void ibmvstgt_dev_release(struct device *dev)
-{ }
-
-static struct class ibmvstgt_class = {
-	.name		= "ibmvstgt",
-	.dev_release	= ibmvstgt_dev_release,
-	.class_attrs	= ibmvstgt_class_attrs,
-	.dev_attrs	= ibmvstgt_attrs,
-};
-
 static struct scst_tgt_template ibmvstgt_template = {
 	.name			= TGT_NAME,
 	.owner			= THIS_MODULE,
@@ -1227,19 +1186,10 @@ static int ibmvstgt_probe(struct vio_dev *dev, const struct vio_device_id *id)
 	if (err)
 		goto free_srp_target;
 
-	vport->dev.class = &ibmvstgt_class;
-	vport->dev.parent = &dev->dev;
-	dev_set_name(&vport->dev, "ibmvstgt-%d",
-		     vport->dma_dev->unit_address);
-	if (device_register(&vport->dev))
-		goto destroy_crq_queue;
-
 	atomic_inc(&ibmvstgt_device_count);
 
 	return 0;
 
-destroy_crq_queue:
-	crq_queue_destroy(target);
 free_srp_target:
 	srp_target_free(target);
 unregister_target:
@@ -1263,7 +1213,6 @@ static int ibmvstgt_remove(struct vio_dev *dev)
 	atomic_dec(&ibmvstgt_device_count);
 
 	vport = target->ldata;
-	device_unregister(&vport->dev);
 	crq_queue_destroy(target);
 	srp_target_free(target);
 	scst_unregister_target(target->tgt);
@@ -1346,13 +1295,9 @@ static int __init ibmvstgt_init(void)
 	if (err)
 		goto out;
 
-	err = class_register(&ibmvstgt_class);
-	if (err)
-		goto out;
-
 	err = scst_register_target_template(&ibmvstgt_template);
 	if (err)
-		goto unregister_class;
+		goto out;
 
 	vtgtd = create_workqueue("ibmvtgtd");
 	if (!vtgtd)
@@ -1368,8 +1313,6 @@ destroy_wq:
 	destroy_workqueue(vtgtd);
 unregister_tgt:
 	scst_unregister_target_template(&ibmvstgt_template);
-unregister_class:
-	class_unregister(&ibmvstgt_class);
 out:
 	return err;
 }
@@ -1381,7 +1324,6 @@ static void __exit ibmvstgt_exit(void)
 	vio_unregister_driver(&ibmvstgt_driver);
 	destroy_workqueue(vtgtd);
 	scst_unregister_target_template(&ibmvstgt_template);
-	class_unregister(&ibmvstgt_class);
 }
 
 MODULE_DESCRIPTION("IBM Virtual SCSI Target");
-- 
1.7.1

