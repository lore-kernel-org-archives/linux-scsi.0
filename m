From: hare@suse.de (Hannes Reinecke)
Subject: [PATCH 1/5] scsi_dh: Implement generic device table handling
Date: Fri, 09 May 2008 11:39:07 +0200
Message-ID: <20080509093907.250BF10B5DF@craiglockhart-ipmi.suse.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail.suse.de ([195.135.220.2]:55050 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752847AbYEIJjJ (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Fri, 9 May 2008 05:39:09 -0400
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James Bottomley <James.Bottomley@HansenPartnership.com>
Cc: linux-scsi@vger.kernel.org


Instead of having each and every driver maintaining and scanning
their own device table we should rather have a general list
and just add any new entries from the device handlers.
This allows us also to implement a general callback for all
device handler instead of having one per handler.

Signed-off-by: Hannes Reinecke <hare@suse.de>
---
 drivers/scsi/device_handler/scsi_dh.c       |  176 +++++++++++++++++++++++++--
 drivers/scsi/device_handler/scsi_dh_emc.c   |   99 +++++++---------
 drivers/scsi/device_handler/scsi_dh_hp_sw.c |   89 ++++++--------
 drivers/scsi/device_handler/scsi_dh_rdac.c  |  106 +++++++----------
 include/scsi/scsi_device.h                  |    9 ++-
 5 files changed, 300 insertions(+), 179 deletions(-)

diff --git a/drivers/scsi/device_handler/scsi_dh.c b/drivers/scsi/device_handler/scsi_dh.c
index ab6c21c..55e5fd2 100644
--- a/drivers/scsi/device_handler/scsi_dh.c
+++ b/drivers/scsi/device_handler/scsi_dh.c
@@ -26,6 +26,18 @@
 
 static DEFINE_SPINLOCK(list_lock);
 static LIST_HEAD(scsi_dh_list);
+static LIST_HEAD(scsi_dh_dev_list);
+
+struct scsi_dh_devinfo_list {
+	struct list_head node;
+	char vendor[9];
+	char model[17];
+	struct scsi_device_handler *handler;
+};
+
+int scsi_dh_handler_attach(struct scsi_device *sdev,
+			   struct scsi_device_handler *scsi_dh);
+int scsi_dh_handler_detach(struct scsi_device *sdev);
 
 static struct scsi_device_handler *get_device_handler(const char *name)
 {
@@ -33,7 +45,7 @@ static struct scsi_device_handler *get_device_handler(const char *name)
 
 	spin_lock(&list_lock);
 	list_for_each_entry(tmp, &scsi_dh_list, list) {
-		if (!strcmp(tmp->name, name)) {
+		if (!strncmp(tmp->name, name, strlen(tmp->name))) {
 			found = tmp;
 			break;
 		}
@@ -42,11 +54,98 @@ static struct scsi_device_handler *get_device_handler(const char *name)
 	return found;
 }
 
+/*
+ * scsi_dh_handler_attach - Attach a device handler to a device
+ * @sdev - SCSI device the device handler should attach to
+ * @scsi_dh - The device handler to attach
+ */
+int scsi_dh_handler_attach(struct scsi_device *sdev,
+			   struct scsi_device_handler *scsi_dh)
+{
+	int err = -EBUSY;
+
+	if (sdev->scsi_dh_data)
+		return err;
+
+	err = scsi_dh->attach(sdev);
+
+	return err;
+}
+
+/*
+ * scsi_dh_handler_detach - Detach a device handler to a device
+ * @sdev - SCSI device the device handler should be detached from
+ */
+int scsi_dh_handler_detach(struct scsi_device *sdev)
+{
+	struct scsi_device_handler *scsi_dh;
+
+	if (!sdev->scsi_dh_data)
+		return -ENODEV;
+
+	scsi_dh = sdev->scsi_dh_data->scsi_dh;
+
+	scsi_dh->detach(sdev);
+
+	return 0;
+}
+
+static int scsi_dh_notifier(struct notifier_block *nb,
+			    unsigned long action, void *data)
+{
+	struct device *dev = data;
+	struct scsi_device *sdev;
+	struct scsi_dh_devinfo_list *tmp, *devinfo = NULL;
+
+	if (!scsi_is_sdev_device(dev))
+		return 0;
+
+	sdev = to_scsi_device(dev);
+
+	list_for_each_entry(tmp, &scsi_dh_dev_list, node) {
+		if (!strncmp(sdev->vendor, tmp->vendor, strlen(tmp->vendor)) &&
+		    !strncmp(sdev->model, tmp->model, strlen(tmp->model))) {
+			devinfo = tmp;
+			break;
+		}
+	}
+
+	if (!devinfo)
+		goto out;
+
+	if (action == BUS_NOTIFY_ADD_DEVICE) {
+		scsi_dh_handler_attach(sdev, devinfo->handler);
+	} else if (action == BUS_NOTIFY_DEL_DEVICE) {
+		if (sdev->scsi_dh_data == NULL)
+			goto out;
+		scsi_dh_handler_detach(sdev);
+	}
+out:
+	return 0;
+}
+
 static int scsi_dh_notifier_add(struct device *dev, void *data)
 {
 	struct scsi_device_handler *scsi_dh = data;
+	struct scsi_device *sdev;
+	struct scsi_dh_devinfo_list *tmp;
+
+	if (!scsi_is_sdev_device(dev))
+		return 0;
+
+	sdev = to_scsi_device(dev);
+
+	list_for_each_entry(tmp, &scsi_dh_dev_list, node) {
+		if (tmp->handler != scsi_dh)
+			continue;
+
+		if (!strncmp(sdev->vendor, tmp->vendor, strlen(tmp->vendor)) &&
+		    !strncmp(sdev->model, tmp->model, strlen(tmp->model))) {
+			scsi_dh_handler_attach(sdev, scsi_dh);
+			break;
+		}
+	}
 
-	scsi_dh->nb.notifier_call(&scsi_dh->nb, BUS_NOTIFY_ADD_DEVICE, dev);
 	return 0;
 }
 
@@ -60,18 +159,37 @@ static int scsi_dh_notifier_add(struct device *dev, void *data)
 int scsi_register_device_handler(struct scsi_device_handler *scsi_dh)
 {
 	int ret = -EBUSY;
+	int i;
 	struct scsi_device_handler *tmp;
+	struct scsi_dh_devinfo_list *devinfo;
 
 	tmp = get_device_handler(scsi_dh->name);
 	if (tmp)
 		goto done;
 
-	ret = bus_register_notifier(&scsi_bus_type, &scsi_dh->nb);
-
-	bus_for_each_dev(&scsi_bus_type, NULL, scsi_dh, scsi_dh_notifier_add);
 	spin_lock(&list_lock);
+	for (i = 0; scsi_dh->devlist[i].vendor; i++) {
+		devinfo = kmalloc(sizeof(*devinfo), GFP_KERNEL);
+		if (!devinfo) {
+			printk(KERN_ERR "%s: no memory\n", __FUNCTION__);
+			ret = -ENOMEM;
+			goto done;
+		}
+		strncpy(devinfo->vendor, scsi_dh->devlist[i].vendor, 8);
+		strncpy(devinfo->model, scsi_dh->devlist[i].model, 16);
+		devinfo->vendor[8] = '\0';
+		devinfo->model[16] = '\0';
+		devinfo->handler = scsi_dh;
+		list_add(&devinfo->node, &scsi_dh_dev_list);
+		printk(KERN_INFO "%s: registered device '%s/%s'\n",
+		       scsi_dh->name, devinfo->vendor, devinfo->model);
+	}
+
 	list_add(&scsi_dh->list, &scsi_dh_list);
 	spin_unlock(&list_lock);
+	bus_for_each_dev(&scsi_bus_type, NULL, scsi_dh, scsi_dh_notifier_add);
+	printk(KERN_INFO "%s: registered\n", scsi_dh->name);
+	ret = SCSI_DH_OK;
 
 done:
 	return ret;
@@ -81,8 +199,18 @@ EXPORT_SYMBOL_GPL(scsi_register_device_handler);
 static int scsi_dh_notifier_remove(struct device *dev, void *data)
 {
 	struct scsi_device_handler *scsi_dh = data;
+	struct scsi_device *sdev;
+
+	if (!scsi_is_sdev_device(dev))
+		return 0;
+
+	sdev = to_scsi_device(dev);
+
+	if (!sdev->scsi_dh_data || sdev->scsi_dh_data->scsi_dh != scsi_dh)
+		return 0;
+
+	scsi_dh_handler_detach(sdev);
 
-	scsi_dh->nb.notifier_call(&scsi_dh->nb, BUS_NOTIFY_DEL_DEVICE, dev);
 	return 0;
 }
 
@@ -97,18 +225,27 @@ int scsi_unregister_device_handler(struct scsi_device_handler *scsi_dh)
 {
 	int ret = -ENODEV;
 	struct scsi_device_handler *tmp;
+	struct scsi_dh_devinfo_list *devinfo, *tmpdev;
 
 	tmp = get_device_handler(scsi_dh->name);
 	if (!tmp)
 		goto done;
 
-	ret = bus_unregister_notifier(&scsi_bus_type, &scsi_dh->nb);
-
 	bus_for_each_dev(&scsi_bus_type, NULL, scsi_dh,
-					scsi_dh_notifier_remove);
+			 scsi_dh_notifier_remove);
+
 	spin_lock(&list_lock);
+	list_for_each_entry_safe(devinfo, tmpdev, &scsi_dh_dev_list, node) {
+		if (devinfo->handler != scsi_dh)
+			continue;
+
+		list_del_init(&devinfo->node);
+		kfree(devinfo);
+	}
 	list_del(&scsi_dh->list);
 	spin_unlock(&list_lock);
+	printk(KERN_INFO "%s: unregistered\n", scsi_dh->name);
+	ret = SCSI_DH_OK;
 
 done:
 	return ret;
@@ -157,6 +294,27 @@ int scsi_dh_handler_exist(const char *name)
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
index ed53f14..6b81ee5 100644
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
@@ -412,68 +412,57 @@ static struct scsi_device_handler clariion_dh = {
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
+	if (sdev->scsi_dh_data)
+		return -EBUSY;
 
-		scsi_dh_data->scsi_dh = &clariion_dh;
-		h = (struct clariion_dh_data *) scsi_dh_data->buf;
-		h->default_sp = CLARIION_UNBOUND_LU;
-		h->current_sp = CLARIION_UNBOUND_LU;
+	scsi_dh_data = kzalloc(sizeof(struct scsi_device_handler *)
+			       + sizeof(*h) , GFP_KERNEL);
+	if (!scsi_dh_data) {
+		sdev_printk(KERN_ERR, sdev, "Attach failed %s.\n",
+			    CLARIION_NAME);
+		return -ENOMEM;
+	}
 
-		spin_lock_irqsave(sdev->request_queue->queue_lock, flags);
-		sdev->scsi_dh_data = scsi_dh_data;
-		spin_unlock_irqrestore(sdev->request_queue->queue_lock, flags);
+	scsi_dh_data->scsi_dh = &clariion_dh;
+	h = (struct clariion_dh_data *) scsi_dh_data->buf;
+	h->default_sp = CLARIION_UNBOUND_LU;
+	h->current_sp = CLARIION_UNBOUND_LU;
 
-		sdev_printk(KERN_NOTICE, sdev, "Attached %s.\n", CLARIION_NAME);
-		try_module_get(THIS_MODULE);
+	spin_lock_irqsave(sdev->request_queue->queue_lock, flags);
+	sdev->scsi_dh_data = scsi_dh_data;
+	spin_unlock_irqrestore(sdev->request_queue->queue_lock, flags);
 
-	} else if (action == BUS_NOTIFY_DEL_DEVICE) {
-		if (sdev->scsi_dh_data == NULL ||
-				sdev->scsi_dh_data->scsi_dh != &clariion_dh)
-			goto out;
+	sdev_printk(KERN_NOTICE, sdev, "Attached %s.\n", CLARIION_NAME);
+	try_module_get(THIS_MODULE);
 
-		spin_lock_irqsave(sdev->request_queue->queue_lock, flags);
-		scsi_dh_data = sdev->scsi_dh_data;
-		sdev->scsi_dh_data = NULL;
-		spin_unlock_irqrestore(sdev->request_queue->queue_lock, flags);
+	return 0;
+}
 
-		sdev_printk(KERN_NOTICE, sdev, "Dettached %s.\n",
-			    CLARIION_NAME);
+static void clariion_bus_detach(struct scsi_device *sdev)
+{
+	struct scsi_dh_data *scsi_dh_data;
+	unsigned long flags;
 
-		kfree(scsi_dh_data);
-		module_put(THIS_MODULE);
-	}
+	if (sdev->scsi_dh_data == NULL ||
+	    sdev->scsi_dh_data->scsi_dh != &clariion_dh)
+		return;
 
-out:
-	return 0;
+	spin_lock_irqsave(sdev->request_queue->queue_lock, flags);
+	scsi_dh_data = sdev->scsi_dh_data;
+	sdev->scsi_dh_data = NULL;
+	spin_unlock_irqrestore(sdev->request_queue->queue_lock, flags);
+
+	sdev_printk(KERN_NOTICE, sdev, "Detached %s.\n",
+		    CLARIION_NAME);
+
+	kfree(scsi_dh_data);
+	module_put(THIS_MODULE);
 }
 
 static int __init clariion_init(void)
diff --git a/drivers/scsi/device_handler/scsi_dh_hp_sw.c b/drivers/scsi/device_handler/scsi_dh_hp_sw.c
index 12ceab7..505c5dd 100644
--- a/drivers/scsi/device_handler/scsi_dh_hp_sw.c
+++ b/drivers/scsi/device_handler/scsi_dh_hp_sw.c
@@ -108,80 +108,67 @@ done:
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
+
+	sdev_printk(KERN_NOTICE, sdev, "Attached %s.\n", HP_SW_NAME);
+
+	return 0;
+}
 
-		sdev_printk(KERN_NOTICE, sdev, "Attached %s.\n", HP_SW_NAME);
-	} else if (action == BUS_NOTIFY_DEL_DEVICE) {
-		if (sdev->scsi_dh_data == NULL ||
-				sdev->scsi_dh_data->scsi_dh != &hp_sw_dh)
-			goto out;
+static void hp_sw_bus_detach( struct scsi_device *sdev )
+{
+	struct scsi_dh_data *scsi_dh_data;
+	unsigned long flags;
 
-		spin_lock_irqsave(sdev->request_queue->queue_lock, flags);
-		scsi_dh_data = sdev->scsi_dh_data;
-		sdev->scsi_dh_data = NULL;
-		spin_unlock_irqrestore(sdev->request_queue->queue_lock, flags);
-		module_put(THIS_MODULE);
+	if (sdev->scsi_dh_data == NULL ||
+	    sdev->scsi_dh_data->scsi_dh != &hp_sw_dh)
+		return;
 
-		sdev_printk(KERN_NOTICE, sdev, "Dettached %s.\n", HP_SW_NAME);
+	spin_lock_irqsave(sdev->request_queue->queue_lock, flags);
+	scsi_dh_data = sdev->scsi_dh_data;
+	sdev->scsi_dh_data = NULL;
+	spin_unlock_irqrestore(sdev->request_queue->queue_lock, flags);
+	module_put(THIS_MODULE);
 
-		kfree(scsi_dh_data);
-	}
+	sdev_printk(KERN_NOTICE, sdev, "Detached %s\n", HP_SW_NAME);
 
-out:
-	return 0;
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

