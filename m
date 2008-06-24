From: hare@suse.de (Hannes Reinecke)
Subject: [PATCH 1/9] scsi_dh: Implement common device table handling
Date: Tue, 24 Jun 2008 12:03:48 +0200
Message-ID: <20080624100349.06F5A10B5DE@craiglockhart-ipmi.suse.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from ns2.suse.de ([195.135.220.15]:49439 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752058AbYFXKDu (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Tue, 24 Jun 2008 06:03:50 -0400
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James Bottomley <James.Bottomley@HansenPartnership.com>
Cc: dm-devel@redhat.com, linux-scsi@vger.kernel.org


Instead of having each and every driver implement its own
device table scanning code we should rather implement a common
routine and scan the device tables there.
This allows us also to implement a general notifier chain
callback for all device handler instead for one per handler.

Signed-off-by: Hannes Reinecke <hare@suse.de>
---
 drivers/scsi/device_handler/scsi_dh.c       |  199 ++++++++++++++++++++++-----
 drivers/scsi/device_handler/scsi_dh_emc.c   |   92 +++++--------
 drivers/scsi/device_handler/scsi_dh_hp_sw.c |   85 +++++-------
 drivers/scsi/device_handler/scsi_dh_rdac.c  |  106 ++++++---------
 include/scsi/scsi_device.h                  |    9 +-
 5 files changed, 289 insertions(+), 202 deletions(-)

diff --git a/drivers/scsi/device_handler/scsi_dh.c b/drivers/scsi/device_handler/scsi_dh.c
index ab6c21c..21cd645 100644
--- a/drivers/scsi/device_handler/scsi_dh.c
+++ b/drivers/scsi/device_handler/scsi_dh.c
@@ -33,7 +33,7 @@ static struct scsi_device_handler *get_device_handler(const char *name)
 
 	spin_lock(&list_lock);
 	list_for_each_entry(tmp, &scsi_dh_list, list) {
-		if (!strcmp(tmp->name, name)) {
+		if (!strncmp(tmp->name, name, strlen(tmp->name))) {
 			found = tmp;
 			break;
 		}
@@ -42,51 +42,170 @@ static struct scsi_device_handler *get_device_handler(const char *name)
 	return found;
 }
 
-static int scsi_dh_notifier_add(struct device *dev, void *data)
+static int device_handler_match(struct scsi_device_handler *tmp,
+				struct scsi_device *sdev)
 {
-	struct scsi_device_handler *scsi_dh = data;
+	int i;
+
+	for(i = 0; tmp->devlist[i].vendor; i++) {
+		if (!strncmp(sdev->vendor, tmp->devlist[i].vendor,
+			     strlen(tmp->devlist[i].vendor)) &&
+		    !strncmp(sdev->model, tmp->devlist[i].model,
+			     strlen(tmp->devlist[i].model))) {
+			return 1;
+		}
+	}
 
-	scsi_dh->nb.notifier_call(&scsi_dh->nb, BUS_NOTIFY_ADD_DEVICE, dev);
 	return 0;
 }
 
 /*
- * scsi_register_device_handler - register a device handler personality
- *      module.
- * @scsi_dh - device handler to be registered.
+ * scsi_dh_handler_attach - Attach a device handler to a device
+ * @sdev - SCSI device the device handler should attach to
+ * @scsi_dh - The device handler to attach
+ */
+static int scsi_dh_handler_attach(struct scsi_device *sdev,
+				  struct scsi_device_handler *scsi_dh)
+{
+	int err = 0;
+
+	if (sdev->scsi_dh_data) {
+		if (sdev->scsi_dh_data->scsi_dh != scsi_dh)
+			err = -EBUSY;
+	} else if (scsi_dh->attach)
+		err = scsi_dh->attach(sdev);
+
+	return err;
+}
+
+/*
+ * scsi_dh_handler_detach - Detach a device handler from a device
+ * @sdev - SCSI device the device handler should be detached from
+ * @scsi_dh - Device handler to be detached
  *
- * Returns 0 on success, -EBUSY if handler already registered.
+ * Detach from a device handler. If a device handler is specified,
+ * only detach if the currently attached handler is equal to it.
  */
-int scsi_register_device_handler(struct scsi_device_handler *scsi_dh)
+static void scsi_dh_handler_detach(struct scsi_device *sdev,
+				   struct scsi_device_handler *scsi_dh)
 {
-	int ret = -EBUSY;
-	struct scsi_device_handler *tmp;
+	if (!sdev->scsi_dh_data)
+		return;
 
-	tmp = get_device_handler(scsi_dh->name);
-	if (tmp)
-		goto done;
+	if (scsi_dh && scsi_dh != sdev->scsi_dh_data->scsi_dh)
+		return;
 
-	ret = bus_register_notifier(&scsi_bus_type, &scsi_dh->nb);
+	if (scsi_dh->detach)
+		scsi_dh->detach(sdev);
+}
+
+/*
+ * scsi_dh_notifier - notifier chain callback
+ */
+static int scsi_dh_notifier(struct notifier_block *nb,
+			    unsigned long action, void *data)
+{
+	struct device *dev = data;
+	struct scsi_device *sdev;
+	int err = 0;
+	struct scsi_device_handler *tmp, *devinfo = NULL;
+
+	if (!scsi_is_sdev_device(dev))
+		return 0;
+
+	sdev = to_scsi_device(dev);
 
-	bus_for_each_dev(&scsi_bus_type, NULL, scsi_dh, scsi_dh_notifier_add);
 	spin_lock(&list_lock);
-	list_add(&scsi_dh->list, &scsi_dh_list);
+	list_for_each_entry(tmp, &scsi_dh_list, list) {
+		if (device_handler_match(tmp, sdev)) {
+			devinfo = tmp;
+			break;
+		}
+	}
 	spin_unlock(&list_lock);
 
-done:
-	return ret;
+	if (!devinfo)
+		goto out;
+
+	if (action == BUS_NOTIFY_ADD_DEVICE) {
+		err = scsi_dh_handler_attach(sdev, devinfo);
+	} else if (action == BUS_NOTIFY_DEL_DEVICE) {
+		scsi_dh_handler_detach(sdev, NULL);
+	}
+out:
+	return err;
 }
-EXPORT_SYMBOL_GPL(scsi_register_device_handler);
 
+/*
+ * scsi_dh_notifier_add - Callback for scsi_register_device_handler
+ */
+static int scsi_dh_notifier_add(struct device *dev, void *data)
+{
+	struct scsi_device_handler *scsi_dh = data;
+	struct scsi_device *sdev;
+
+	if (!scsi_is_sdev_device(dev))
+		return 0;
+
+	if (!get_device(dev))
+		return 0;
+
+	sdev = to_scsi_device(dev);
+
+	if (device_handler_match(scsi_dh, sdev))
+		scsi_dh_handler_attach(sdev, scsi_dh);
+
+	put_device(dev);
+
+	return 0;
+}
+
+/*
+ * scsi_dh_notifier_remove - Callback for scsi_unregister_device_handler
+ */
 static int scsi_dh_notifier_remove(struct device *dev, void *data)
 {
 	struct scsi_device_handler *scsi_dh = data;
+	struct scsi_device *sdev;
+
+	if (!scsi_is_sdev_device(dev))
+		return 0;
+
+	if (!get_device(dev))
+		return 0;
+
+	sdev = to_scsi_device(dev);
+
+	scsi_dh_handler_detach(sdev, scsi_dh);
+
+	put_device(dev);
 
-	scsi_dh->nb.notifier_call(&scsi_dh->nb, BUS_NOTIFY_DEL_DEVICE, dev);
 	return 0;
 }
 
 /*
+ * scsi_register_device_handler - register a device handler personality
+ *      module.
+ * @scsi_dh - device handler to be registered.
+ *
+ * Returns 0 on success, -EBUSY if handler already registered.
+ */
+int scsi_register_device_handler(struct scsi_device_handler *scsi_dh)
+{
+	if (get_device_handler(scsi_dh->name))
+		return -EBUSY;
+
+	spin_lock(&list_lock);
+	list_add(&scsi_dh->list, &scsi_dh_list);
+	spin_unlock(&list_lock);
+	bus_for_each_dev(&scsi_bus_type, NULL, scsi_dh, scsi_dh_notifier_add);
+	printk(KERN_INFO "%s: device handler registered\n", scsi_dh->name);
+
+	return SCSI_DH_OK;
+}
+EXPORT_SYMBOL_GPL(scsi_register_device_handler);
+
+/*
  * scsi_unregister_device_handler - register a device handler personality
  *      module.
  * @scsi_dh - device handler to be unregistered.
@@ -95,23 +214,18 @@ static int scsi_dh_notifier_remove(struct device *dev, void *data)
  */
 int scsi_unregister_device_handler(struct scsi_device_handler *scsi_dh)
 {
-	int ret = -ENODEV;
-	struct scsi_device_handler *tmp;
-
-	tmp = get_device_handler(scsi_dh->name);
-	if (!tmp)
-		goto done;
-
-	ret = bus_unregister_notifier(&scsi_bus_type, &scsi_dh->nb);
+	if (!get_device_handler(scsi_dh->name))
+		return -ENODEV;
 
 	bus_for_each_dev(&scsi_bus_type, NULL, scsi_dh,
-					scsi_dh_notifier_remove);
+			 scsi_dh_notifier_remove);
+
 	spin_lock(&list_lock);
 	list_del(&scsi_dh->list);
 	spin_unlock(&list_lock);
+	printk(KERN_INFO "%s: device handler unregistered\n", scsi_dh->name);
 
-done:
-	return ret;
+	return SCSI_DH_OK;
 }
 EXPORT_SYMBOL_GPL(scsi_unregister_device_handler);
 
@@ -157,6 +271,27 @@ int scsi_dh_handler_exist(const char *name)
 }
 EXPORT_SYMBOL_GPL(scsi_dh_handler_exist);
 
+static struct notifier_block scsi_dh_nb = {
+	.notifier_call = scsi_dh_notifier
+};
+
+static int __init scsi_dh_init(void)
+{
+	int r;
+
+	r = bus_register_notifier(&scsi_bus_type, &scsi_dh_nb);
+
+	return r;
+}
+
+static void __exit scsi_dh_exit(void)
+{
+	bus_unregister_notifier(&scsi_bus_type, &scsi_dh_nb);
+}
+
+module_init(scsi_dh_init);
+module_exit(scsi_dh_exit);
+
 MODULE_DESCRIPTION("SCSI device handler");
 MODULE_AUTHOR("Chandra Seetharaman <sekharan@us.ibm.com>");
 MODULE_LICENSE("GPL");
diff --git a/drivers/scsi/device_handler/scsi_dh_emc.c b/drivers/scsi/device_handler/scsi_dh_emc.c
index ed53f14..8a20eb2 100644
--- a/drivers/scsi/device_handler/scsi_dh_emc.c
+++ b/drivers/scsi/device_handler/scsi_dh_emc.c
@@ -390,21 +390,21 @@ static int clariion_check_sense(struct scsi_device *sdev,
 	return SUCCESS;
 }
 
-static const struct {
-	char *vendor;
-	char *model;
-} clariion_dev_list[] = {
+const struct scsi_dh_devlist clariion_dev_list[] = {
 	{"DGC", "RAID"},
 	{"DGC", "DISK"},
 	{NULL, NULL},
 };
 
-static int clariion_bus_notify(struct notifier_block *, unsigned long, void *);
+static int clariion_bus_attach(struct scsi_device *sdev);
+static void clariion_bus_detach(struct scsi_device *sdev);
 
 static struct scsi_device_handler clariion_dh = {
 	.name		= CLARIION_NAME,
 	.module		= THIS_MODULE,
-	.nb.notifier_call = clariion_bus_notify,
+	.devlist	= clariion_dev_list,
+	.attach		= clariion_bus_attach,
+	.detach		= clariion_bus_detach,
 	.check_sense	= clariion_check_sense,
 	.activate	= clariion_activate,
 };
@@ -412,68 +412,50 @@ static struct scsi_device_handler clariion_dh = {
 /*
  * TODO: need some interface so we can set trespass values
  */
-static int clariion_bus_notify(struct notifier_block *nb,
-				unsigned long action, void *data)
+static int clariion_bus_attach(struct scsi_device *sdev)
 {
-	struct device *dev = data;
-	struct scsi_device *sdev = to_scsi_device(dev);
 	struct scsi_dh_data *scsi_dh_data;
 	struct clariion_dh_data *h;
-	int i, found = 0;
 	unsigned long flags;
 
-	if (action == BUS_NOTIFY_ADD_DEVICE) {
-		for (i = 0; clariion_dev_list[i].vendor; i++) {
-			if (!strncmp(sdev->vendor, clariion_dev_list[i].vendor,
-				     strlen(clariion_dev_list[i].vendor)) &&
-			    !strncmp(sdev->model, clariion_dev_list[i].model,
-				     strlen(clariion_dev_list[i].model))) {
-				found = 1;
-				break;
-			}
-		}
-		if (!found)
-			goto out;
-
-		scsi_dh_data = kzalloc(sizeof(struct scsi_device_handler *)
-				+ sizeof(*h) , GFP_KERNEL);
-		if (!scsi_dh_data) {
-			sdev_printk(KERN_ERR, sdev, "Attach failed %s.\n",
-				    CLARIION_NAME);
-			goto out;
-		}
+	scsi_dh_data = kzalloc(sizeof(struct scsi_device_handler *)
+			       + sizeof(*h) , GFP_KERNEL);
+	if (!scsi_dh_data) {
+		sdev_printk(KERN_ERR, sdev, "Attach failed %s.\n",
+			    CLARIION_NAME);
+		return -ENOMEM;
+	}
 
-		scsi_dh_data->scsi_dh = &clariion_dh;
-		h = (struct clariion_dh_data *) scsi_dh_data->buf;
-		h->default_sp = CLARIION_UNBOUND_LU;
-		h->current_sp = CLARIION_UNBOUND_LU;
+	scsi_dh_data->scsi_dh = &clariion_dh;
+	h = (struct clariion_dh_data *) scsi_dh_data->buf;
+	h->default_sp = CLARIION_UNBOUND_LU;
+	h->current_sp = CLARIION_UNBOUND_LU;
 
-		spin_lock_irqsave(sdev->request_queue->queue_lock, flags);
-		sdev->scsi_dh_data = scsi_dh_data;
-		spin_unlock_irqrestore(sdev->request_queue->queue_lock, flags);
+	spin_lock_irqsave(sdev->request_queue->queue_lock, flags);
+	sdev->scsi_dh_data = scsi_dh_data;
+	spin_unlock_irqrestore(sdev->request_queue->queue_lock, flags);
 
-		sdev_printk(KERN_NOTICE, sdev, "Attached %s.\n", CLARIION_NAME);
-		try_module_get(THIS_MODULE);
+	sdev_printk(KERN_NOTICE, sdev, "Attached %s.\n", CLARIION_NAME);
+	try_module_get(THIS_MODULE);
 
-	} else if (action == BUS_NOTIFY_DEL_DEVICE) {
-		if (sdev->scsi_dh_data == NULL ||
-				sdev->scsi_dh_data->scsi_dh != &clariion_dh)
-			goto out;
+	return 0;
+}
 
-		spin_lock_irqsave(sdev->request_queue->queue_lock, flags);
-		scsi_dh_data = sdev->scsi_dh_data;
-		sdev->scsi_dh_data = NULL;
-		spin_unlock_irqrestore(sdev->request_queue->queue_lock, flags);
+static void clariion_bus_detach(struct scsi_device *sdev)
+{
+	struct scsi_dh_data *scsi_dh_data;
+	unsigned long flags;
 
-		sdev_printk(KERN_NOTICE, sdev, "Dettached %s.\n",
-			    CLARIION_NAME);
+	spin_lock_irqsave(sdev->request_queue->queue_lock, flags);
+	scsi_dh_data = sdev->scsi_dh_data;
+	sdev->scsi_dh_data = NULL;
+	spin_unlock_irqrestore(sdev->request_queue->queue_lock, flags);
 
-		kfree(scsi_dh_data);
-		module_put(THIS_MODULE);
-	}
+	sdev_printk(KERN_NOTICE, sdev, "Detached %s.\n",
+		    CLARIION_NAME);
 
-out:
-	return 0;
+	kfree(scsi_dh_data);
+	module_put(THIS_MODULE);
 }
 
 static int __init clariion_init(void)
diff --git a/drivers/scsi/device_handler/scsi_dh_hp_sw.c b/drivers/scsi/device_handler/scsi_dh_hp_sw.c
index 12ceab7..78259bc 100644
--- a/drivers/scsi/device_handler/scsi_dh_hp_sw.c
+++ b/drivers/scsi/device_handler/scsi_dh_hp_sw.c
@@ -108,80 +108,63 @@ done:
 	return ret;
 }
 
-static const struct {
-	char *vendor;
-	char *model;
-} hp_sw_dh_data_list[] = {
+const struct scsi_dh_devlist hp_sw_dh_data_list[] = {
 	{"COMPAQ", "MSA"},
 	{"HP", "HSV"},
 	{"DEC", "HSG80"},
 	{NULL, NULL},
 };
 
-static int hp_sw_bus_notify(struct notifier_block *, unsigned long, void *);
+static int hp_sw_bus_attach(struct scsi_device *sdev);
+static void hp_sw_bus_detach(struct scsi_device *sdev);
 
 static struct scsi_device_handler hp_sw_dh = {
 	.name		= HP_SW_NAME,
 	.module		= THIS_MODULE,
-	.nb.notifier_call = hp_sw_bus_notify,
+	.devlist	= hp_sw_dh_data_list,
+	.attach		= hp_sw_bus_attach,
+	.detach		= hp_sw_bus_detach,
 	.activate	= hp_sw_activate,
 };
 
-static int hp_sw_bus_notify(struct notifier_block *nb,
-			    unsigned long action, void *data)
+static int hp_sw_bus_attach(struct scsi_device *sdev)
 {
-	struct device *dev = data;
-	struct scsi_device *sdev = to_scsi_device(dev);
 	struct scsi_dh_data *scsi_dh_data;
-	int i, found = 0;
 	unsigned long flags;
 
-	if (action == BUS_NOTIFY_ADD_DEVICE) {
-		for (i = 0; hp_sw_dh_data_list[i].vendor; i++) {
-			if (!strncmp(sdev->vendor, hp_sw_dh_data_list[i].vendor,
-				     strlen(hp_sw_dh_data_list[i].vendor)) &&
-			    !strncmp(sdev->model, hp_sw_dh_data_list[i].model,
-				     strlen(hp_sw_dh_data_list[i].model))) {
-				found = 1;
-				break;
-			}
-		}
-		if (!found)
-			goto out;
-
-		scsi_dh_data = kzalloc(sizeof(struct scsi_device_handler *)
-				+ sizeof(struct hp_sw_dh_data) , GFP_KERNEL);
-		if (!scsi_dh_data) {
-			sdev_printk(KERN_ERR, sdev, "Attach Failed %s.\n",
-				    HP_SW_NAME);
-			goto out;
-		}
+	scsi_dh_data = kzalloc(sizeof(struct scsi_device_handler *)
+			       + sizeof(struct hp_sw_dh_data) , GFP_KERNEL);
+	if (!scsi_dh_data) {
+		sdev_printk(KERN_ERR, sdev, "Attach Failed %s.\n",
+			    HP_SW_NAME);
+		return 0;
+	}
 
-		scsi_dh_data->scsi_dh = &hp_sw_dh;
-		spin_lock_irqsave(sdev->request_queue->queue_lock, flags);
-		sdev->scsi_dh_data = scsi_dh_data;
-		spin_unlock_irqrestore(sdev->request_queue->queue_lock, flags);
-		try_module_get(THIS_MODULE);
+	scsi_dh_data->scsi_dh = &hp_sw_dh;
+	spin_lock_irqsave(sdev->request_queue->queue_lock, flags);
+	sdev->scsi_dh_data = scsi_dh_data;
+	spin_unlock_irqrestore(sdev->request_queue->queue_lock, flags);
+	try_module_get(THIS_MODULE);
 
-		sdev_printk(KERN_NOTICE, sdev, "Attached %s.\n", HP_SW_NAME);
-	} else if (action == BUS_NOTIFY_DEL_DEVICE) {
-		if (sdev->scsi_dh_data == NULL ||
-				sdev->scsi_dh_data->scsi_dh != &hp_sw_dh)
-			goto out;
+	sdev_printk(KERN_NOTICE, sdev, "Attached %s.\n", HP_SW_NAME);
 
-		spin_lock_irqsave(sdev->request_queue->queue_lock, flags);
-		scsi_dh_data = sdev->scsi_dh_data;
-		sdev->scsi_dh_data = NULL;
-		spin_unlock_irqrestore(sdev->request_queue->queue_lock, flags);
-		module_put(THIS_MODULE);
+	return 0;
+}
 
-		sdev_printk(KERN_NOTICE, sdev, "Dettached %s.\n", HP_SW_NAME);
+static void hp_sw_bus_detach( struct scsi_device *sdev )
+{
+	struct scsi_dh_data *scsi_dh_data;
+	unsigned long flags;
 
-		kfree(scsi_dh_data);
-	}
+	spin_lock_irqsave(sdev->request_queue->queue_lock, flags);
+	scsi_dh_data = sdev->scsi_dh_data;
+	sdev->scsi_dh_data = NULL;
+	spin_unlock_irqrestore(sdev->request_queue->queue_lock, flags);
+	module_put(THIS_MODULE);
 
-out:
-	return 0;
+	sdev_printk(KERN_NOTICE, sdev, "Detached %s\n", HP_SW_NAME);
+
+	kfree(scsi_dh_data);
 }
 
 static int __init hp_sw_init(void)
diff --git a/drivers/scsi/device_handler/scsi_dh_rdac.c b/drivers/scsi/device_handler/scsi_dh_rdac.c
index 6fff077..e61cde6 100644
--- a/drivers/scsi/device_handler/scsi_dh_rdac.c
+++ b/drivers/scsi/device_handler/scsi_dh_rdac.c
@@ -569,10 +569,7 @@ static int rdac_check_sense(struct scsi_device *sdev,
 	return SCSI_RETURN_NOT_HANDLED;
 }
 
-static const struct {
-	char *vendor;
-	char *model;
-} rdac_dev_list[] = {
+const struct scsi_dh_devlist rdac_dev_list[] = {
 	{"IBM", "1722"},
 	{"IBM", "1724"},
 	{"IBM", "1726"},
@@ -590,84 +587,67 @@ static const struct {
 	{NULL, NULL},
 };
 
-static int rdac_bus_notify(struct notifier_block *, unsigned long, void *);
+static int rdac_bus_attach(struct scsi_device *sdev);
+static void rdac_bus_detach(struct scsi_device *sdev);
 
 static struct scsi_device_handler rdac_dh = {
 	.name = RDAC_NAME,
 	.module = THIS_MODULE,
-	.nb.notifier_call = rdac_bus_notify,
+	.devlist = rdac_dev_list,
 	.prep_fn = rdac_prep_fn,
 	.check_sense = rdac_check_sense,
+	.attach = rdac_bus_attach,
+	.detach = rdac_bus_detach,
 	.activate = rdac_activate,
 };
 
-/*
- * TODO: need some interface so we can set trespass values
- */
-static int rdac_bus_notify(struct notifier_block *nb,
-			    unsigned long action, void *data)
+static int rdac_bus_attach(struct scsi_device *sdev)
 {
-	struct device *dev = data;
-	struct scsi_device *sdev = to_scsi_device(dev);
 	struct scsi_dh_data *scsi_dh_data;
 	struct rdac_dh_data *h;
-	int i, found = 0;
 	unsigned long flags;
 
-	if (action == BUS_NOTIFY_ADD_DEVICE) {
-		for (i = 0; rdac_dev_list[i].vendor; i++) {
-			if (!strncmp(sdev->vendor, rdac_dev_list[i].vendor,
-				     strlen(rdac_dev_list[i].vendor)) &&
-			    !strncmp(sdev->model, rdac_dev_list[i].model,
-				     strlen(rdac_dev_list[i].model))) {
-				found = 1;
-				break;
-			}
-		}
-		if (!found)
-			goto out;
-
-		scsi_dh_data = kzalloc(sizeof(struct scsi_device_handler *)
-				+ sizeof(*h) , GFP_KERNEL);
-		if (!scsi_dh_data) {
-			sdev_printk(KERN_ERR, sdev, "Attach failed %s.\n",
-				    RDAC_NAME);
-			goto out;
-		}
-
-		scsi_dh_data->scsi_dh = &rdac_dh;
-		h = (struct rdac_dh_data *) scsi_dh_data->buf;
-		h->lun = UNINITIALIZED_LUN;
-		h->state = RDAC_STATE_ACTIVE;
-		spin_lock_irqsave(sdev->request_queue->queue_lock, flags);
-		sdev->scsi_dh_data = scsi_dh_data;
-		spin_unlock_irqrestore(sdev->request_queue->queue_lock, flags);
-		try_module_get(THIS_MODULE);
-
-		sdev_printk(KERN_NOTICE, sdev, "Attached %s.\n", RDAC_NAME);
-
-	} else if (action == BUS_NOTIFY_DEL_DEVICE) {
-		if (sdev->scsi_dh_data == NULL ||
-				sdev->scsi_dh_data->scsi_dh != &rdac_dh)
-			goto out;
-
-		spin_lock_irqsave(sdev->request_queue->queue_lock, flags);
-		scsi_dh_data = sdev->scsi_dh_data;
-		sdev->scsi_dh_data = NULL;
-		spin_unlock_irqrestore(sdev->request_queue->queue_lock, flags);
-
-		h = (struct rdac_dh_data *) scsi_dh_data->buf;
-		if (h->ctlr)
-			kref_put(&h->ctlr->kref, release_controller);
-		kfree(scsi_dh_data);
-		module_put(THIS_MODULE);
-		sdev_printk(KERN_NOTICE, sdev, "Dettached %s.\n", RDAC_NAME);
+	scsi_dh_data = kzalloc(sizeof(struct scsi_device_handler *)
+			       + sizeof(*h) , GFP_KERNEL);
+	if (!scsi_dh_data) {
+		sdev_printk(KERN_ERR, sdev, "Attach failed %s.\n",
+			    RDAC_NAME);
+		return 0;
 	}
 
-out:
+	scsi_dh_data->scsi_dh = &rdac_dh;
+	h = (struct rdac_dh_data *) scsi_dh_data->buf;
+	h->lun = UNINITIALIZED_LUN;
+	h->state = RDAC_STATE_ACTIVE;
+	spin_lock_irqsave(sdev->request_queue->queue_lock, flags);
+	sdev->scsi_dh_data = scsi_dh_data;
+	spin_unlock_irqrestore(sdev->request_queue->queue_lock, flags);
+	try_module_get(THIS_MODULE);
+
+	sdev_printk(KERN_NOTICE, sdev, "Attached %s\n", RDAC_NAME);
+
 	return 0;
 }
 
+static void rdac_bus_detach( struct scsi_device *sdev )
+{
+	struct scsi_dh_data *scsi_dh_data;
+	struct rdac_dh_data *h;
+	unsigned long flags;
+
+	spin_lock_irqsave(sdev->request_queue->queue_lock, flags);
+	scsi_dh_data = sdev->scsi_dh_data;
+	sdev->scsi_dh_data = NULL;
+	spin_unlock_irqrestore(sdev->request_queue->queue_lock, flags);
+
+	h = (struct rdac_dh_data *) scsi_dh_data->buf;
+	if (h->ctlr)
+		kref_put(&h->ctlr->kref, release_controller);
+	kfree(scsi_dh_data);
+	module_put(THIS_MODULE);
+	sdev_printk(KERN_NOTICE, sdev, "Detached %s\n", RDAC_NAME);
+}
+
 static int __init rdac_init(void)
 {
 	int r;
diff --git a/include/scsi/scsi_device.h b/include/scsi/scsi_device.h
index 06b979f..62ce167 100644
--- a/include/scsi/scsi_device.h
+++ b/include/scsi/scsi_device.h
@@ -166,15 +166,22 @@ struct scsi_device {
 	unsigned long		sdev_data[0];
 } __attribute__((aligned(sizeof(unsigned long))));
 
+struct scsi_dh_devlist {
+	char *vendor;
+	char *model;
+};
+
 struct scsi_device_handler {
 	/* Used by the infrastructure */
 	struct list_head list; /* list of scsi_device_handlers */
-	struct notifier_block nb;
 
 	/* Filled by the hardware handler */
 	struct module *module;
 	const char *name;
+	const struct scsi_dh_devlist *devlist;
 	int (*check_sense)(struct scsi_device *, struct scsi_sense_hdr *);
+	int (*attach)(struct scsi_device *);
+	void (*detach)(struct scsi_device *);
 	int (*activate)(struct scsi_device *);
 	int (*prep_fn)(struct scsi_device *, struct request *);
 };
-- 
1.5.2.4

