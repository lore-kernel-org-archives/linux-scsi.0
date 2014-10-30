From: Christoph Hellwig <hch@lst.de>
Subject: [PATCH 6/6] scsi: handle more device handler setup/teardown in common code
Date: Thu, 30 Oct 2014 10:19:14 +0100
Message-ID: <1414660754-8431-7-git-send-email-hch@lst.de>
References: <1414660754-8431-1-git-send-email-hch@lst.de>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from casper.infradead.org ([85.118.1.10]:50864 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758537AbaJ3JTJ (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Thu, 30 Oct 2014 05:19:09 -0400
In-Reply-To: <1414660754-8431-1-git-send-email-hch@lst.de>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Hannes Reinecke <hare@suse.de>, Mike Christie <michaelc@cs.wisc.edu>
Cc: Sean Stewart <Sean.Stewart@netapp.com>, Bart Van Assche <bvanassche@acm.org>, linux-scsi@vger.kernel.org

Move all code to set up and tear down sdev->scsi_dh_data to common code.

Signed-off-by: Christoph Hellwig <hch@lst.de>
Reviewed-by: Hannes Reinecke <hare@suse.de>
---
 drivers/scsi/device_handler/scsi_dh.c       | 29 ++++++++++----
 drivers/scsi/device_handler/scsi_dh_alua.c  | 59 ++++++++++-------------------
 drivers/scsi/device_handler/scsi_dh_emc.c   | 58 +++++++++-------------------
 drivers/scsi/device_handler/scsi_dh_hp_sw.c | 54 ++++++++------------------
 drivers/scsi/device_handler/scsi_dh_rdac.c  | 53 ++++++++------------------
 include/scsi/scsi_device.h                  |  2 +-
 6 files changed, 88 insertions(+), 167 deletions(-)

diff --git a/drivers/scsi/device_handler/scsi_dh.c b/drivers/scsi/device_handler/scsi_dh.c
index d8a8aac..1dba62c 100644
--- a/drivers/scsi/device_handler/scsi_dh.c
+++ b/drivers/scsi/device_handler/scsi_dh.c
@@ -98,7 +98,7 @@ device_handler_match(struct scsi_device_handler *scsi_dh,
 static int scsi_dh_handler_attach(struct scsi_device *sdev,
 				  struct scsi_device_handler *scsi_dh)
 {
-	int err = 0;
+	struct scsi_dh_data *d;
 
 	if (sdev->scsi_dh_data) {
 		if (sdev->scsi_dh_data->scsi_dh != scsi_dh)
@@ -111,15 +111,22 @@ static int scsi_dh_handler_attach(struct scsi_device *sdev,
 	if (!try_module_get(scsi_dh->module))
 		return -EINVAL;
 
-	err = scsi_dh->attach(sdev);
-	if (err) {
+	d = scsi_dh->attach(sdev);
+	if (IS_ERR(d)) {
+		sdev_printk(KERN_ERR, sdev, "%s: Attach failed (%ld)\n",
+			    scsi_dh->name, PTR_ERR(d));
 		module_put(scsi_dh->module);
-		return err;
+		return PTR_ERR(d);
 	}
 
-	kref_init(&sdev->scsi_dh_data->kref);
-	sdev->scsi_dh_data->sdev = sdev;
-	return err;
+	d->scsi_dh = scsi_dh;
+	kref_init(&d->kref);
+	d->sdev = sdev;
+
+	spin_lock_irq(sdev->request_queue->queue_lock);
+	sdev->scsi_dh_data = d;
+	spin_unlock_irq(sdev->request_queue->queue_lock);
+	return 0;
 }
 
 static void __detach_handler (struct kref *kref)
@@ -127,8 +134,14 @@ static void __detach_handler (struct kref *kref)
 	struct scsi_dh_data *scsi_dh_data =
 		container_of(kref, struct scsi_dh_data, kref);
 	struct scsi_device_handler *scsi_dh = scsi_dh_data->scsi_dh;
+	struct scsi_device *sdev = scsi_dh_data->sdev;
+
+	spin_lock_irq(sdev->request_queue->queue_lock);
+	sdev->scsi_dh_data = NULL;
+	spin_unlock_irq(sdev->request_queue->queue_lock);
 
-	scsi_dh->detach(scsi_dh_data->sdev);
+	scsi_dh->detach(sdev);
+	sdev_printk(KERN_NOTICE, sdev, "%s: Detached\n", scsi_dh->name);
 	module_put(scsi_dh->module);
 }
 
diff --git a/drivers/scsi/device_handler/scsi_dh_alua.c b/drivers/scsi/device_handler/scsi_dh_alua.c
index 40a2b0e..94d1c36 100644
--- a/drivers/scsi/device_handler/scsi_dh_alua.c
+++ b/drivers/scsi/device_handler/scsi_dh_alua.c
@@ -817,39 +817,18 @@ static bool alua_match(struct scsi_device *sdev)
 	return (scsi_device_tpgs(sdev) != 0);
 }
 
-static int alua_bus_attach(struct scsi_device *sdev);
-static void alua_bus_detach(struct scsi_device *sdev);
-
-static struct scsi_device_handler alua_dh = {
-	.name = ALUA_DH_NAME,
-	.module = THIS_MODULE,
-	.attach = alua_bus_attach,
-	.detach = alua_bus_detach,
-	.prep_fn = alua_prep_fn,
-	.check_sense = alua_check_sense,
-	.activate = alua_activate,
-	.set_params = alua_set_params,
-	.match = alua_match,
-};
-
 /*
  * alua_bus_attach - Attach device handler
  * @sdev: device to be attached to
  */
-static int alua_bus_attach(struct scsi_device *sdev)
+static struct scsi_dh_data *alua_bus_attach(struct scsi_device *sdev)
 {
 	struct alua_dh_data *h;
-	unsigned long flags;
-	int err = SCSI_DH_OK;
+	int err;
 
 	h = kzalloc(sizeof(*h) , GFP_KERNEL);
-	if (!h) {
-		sdev_printk(KERN_ERR, sdev, "%s: Attach failed\n",
-			    ALUA_DH_NAME);
-		return -ENOMEM;
-	}
-
-	h->dh_data.scsi_dh = &alua_dh;
+	if (!h)
+		return ERR_PTR(-ENOMEM);
 	h->tpgs = TPGS_MODE_UNINITIALIZED;
 	h->state = TPGS_STATE_OPTIMIZED;
 	h->group_id = -1;
@@ -859,20 +838,14 @@ static int alua_bus_attach(struct scsi_device *sdev)
 	h->sdev = sdev;
 
 	err = alua_initialize(sdev, h);
-	if ((err != SCSI_DH_OK) && (err != SCSI_DH_DEV_OFFLINED))
+	if (err != SCSI_DH_OK && err != SCSI_DH_DEV_OFFLINED)
 		goto failed;
 
-	spin_lock_irqsave(sdev->request_queue->queue_lock, flags);
-	sdev->scsi_dh_data = &h->dh_data;
-	spin_unlock_irqrestore(sdev->request_queue->queue_lock, flags);
 	sdev_printk(KERN_NOTICE, sdev, "%s: Attached\n", ALUA_DH_NAME);
-
-	return 0;
-
+	return &h->dh_data;
 failed:
 	kfree(h);
-	sdev_printk(KERN_ERR, sdev, "%s: not attached\n", ALUA_DH_NAME);
-	return -EINVAL;
+	return ERR_PTR(-EINVAL);
 }
 
 /*
@@ -882,18 +855,24 @@ failed:
 static void alua_bus_detach(struct scsi_device *sdev)
 {
 	struct alua_dh_data *h = get_alua_data(sdev);
-	unsigned long flags;
-
-	spin_lock_irqsave(sdev->request_queue->queue_lock, flags);
-	sdev->scsi_dh_data = NULL;
-	spin_unlock_irqrestore(sdev->request_queue->queue_lock, flags);
 
 	if (h->buff && h->inq != h->buff)
 		kfree(h->buff);
 	kfree(h);
-	sdev_printk(KERN_NOTICE, sdev, "%s: Detached\n", ALUA_DH_NAME);
 }
 
+static struct scsi_device_handler alua_dh = {
+	.name = ALUA_DH_NAME,
+	.module = THIS_MODULE,
+	.attach = alua_bus_attach,
+	.detach = alua_bus_detach,
+	.prep_fn = alua_prep_fn,
+	.check_sense = alua_check_sense,
+	.activate = alua_activate,
+	.set_params = alua_set_params,
+	.match = alua_match,
+};
+
 static int __init alua_init(void)
 {
 	int r;
diff --git a/drivers/scsi/device_handler/scsi_dh_emc.c b/drivers/scsi/device_handler/scsi_dh_emc.c
index 800deb7..6ed1caa 100644
--- a/drivers/scsi/device_handler/scsi_dh_emc.c
+++ b/drivers/scsi/device_handler/scsi_dh_emc.c
@@ -650,35 +650,14 @@ static bool clariion_match(struct scsi_device *sdev)
 	return false;
 }
 
-static int clariion_bus_attach(struct scsi_device *sdev);
-static void clariion_bus_detach(struct scsi_device *sdev);
-
-static struct scsi_device_handler clariion_dh = {
-	.name		= CLARIION_NAME,
-	.module		= THIS_MODULE,
-	.attach		= clariion_bus_attach,
-	.detach		= clariion_bus_detach,
-	.check_sense	= clariion_check_sense,
-	.activate	= clariion_activate,
-	.prep_fn	= clariion_prep_fn,
-	.set_params	= clariion_set_params,
-	.match		= clariion_match,
-};
-
-static int clariion_bus_attach(struct scsi_device *sdev)
+static struct scsi_dh_data *clariion_bus_attach(struct scsi_device *sdev)
 {
 	struct clariion_dh_data *h;
-	unsigned long flags;
 	int err;
 
 	h = kzalloc(sizeof(*h) , GFP_KERNEL);
-	if (!h) {
-		sdev_printk(KERN_ERR, sdev, "%s: Attach failed\n",
-			    CLARIION_NAME);
-		return -ENOMEM;
-	}
-
-	h->dh_data.scsi_dh = &clariion_dh;
+	if (!h)
+		return ERR_PTR(-ENOMEM);
 	h->lun_state = CLARIION_LUN_UNINITIALIZED;
 	h->default_sp = CLARIION_UNBOUND_LU;
 	h->current_sp = CLARIION_UNBOUND_LU;
@@ -691,40 +670,37 @@ static int clariion_bus_attach(struct scsi_device *sdev)
 	if (err != SCSI_DH_OK)
 		goto failed;
 
-	spin_lock_irqsave(sdev->request_queue->queue_lock, flags);
-	sdev->scsi_dh_data = &h->dh_data;
-	spin_unlock_irqrestore(sdev->request_queue->queue_lock, flags);
-
 	sdev_printk(KERN_INFO, sdev,
 		    "%s: connected to SP %c Port %d (%s, default SP %c)\n",
 		    CLARIION_NAME, h->current_sp + 'A',
 		    h->port, lun_state[h->lun_state],
 		    h->default_sp + 'A');
-
-	return 0;
+	return &h->dh_data;
 
 failed:
 	kfree(h);
-	sdev_printk(KERN_ERR, sdev, "%s: not attached\n",
-		    CLARIION_NAME);
-	return -EINVAL;
+	return ERR_PTR(-EINVAL);
 }
 
 static void clariion_bus_detach(struct scsi_device *sdev)
 {
 	struct clariion_dh_data *h = get_clariion_data(sdev);
-	unsigned long flags;
-
-	spin_lock_irqsave(sdev->request_queue->queue_lock, flags);
-	sdev->scsi_dh_data = NULL;
-	spin_unlock_irqrestore(sdev->request_queue->queue_lock, flags);
-
-	sdev_printk(KERN_NOTICE, sdev, "%s: Detached\n",
-		    CLARIION_NAME);
 
 	kfree(h);
 }
 
+static struct scsi_device_handler clariion_dh = {
+	.name		= CLARIION_NAME,
+	.module		= THIS_MODULE,
+	.attach		= clariion_bus_attach,
+	.detach		= clariion_bus_detach,
+	.check_sense	= clariion_check_sense,
+	.activate	= clariion_activate,
+	.prep_fn	= clariion_prep_fn,
+	.set_params	= clariion_set_params,
+	.match		= clariion_match,
+};
+
 static int __init clariion_init(void)
 {
 	int r;
diff --git a/drivers/scsi/device_handler/scsi_dh_hp_sw.c b/drivers/scsi/device_handler/scsi_dh_hp_sw.c
index 471ffd1..485d995 100644
--- a/drivers/scsi/device_handler/scsi_dh_hp_sw.c
+++ b/drivers/scsi/device_handler/scsi_dh_hp_sw.c
@@ -340,33 +340,14 @@ static bool hp_sw_match(struct scsi_device *sdev)
 	return false;
 }
 
-static int hp_sw_bus_attach(struct scsi_device *sdev);
-static void hp_sw_bus_detach(struct scsi_device *sdev);
-
-static struct scsi_device_handler hp_sw_dh = {
-	.name		= HP_SW_NAME,
-	.module		= THIS_MODULE,
-	.attach		= hp_sw_bus_attach,
-	.detach		= hp_sw_bus_detach,
-	.activate	= hp_sw_activate,
-	.prep_fn	= hp_sw_prep_fn,
-	.match		= hp_sw_match,
-};
-
-static int hp_sw_bus_attach(struct scsi_device *sdev)
+static struct scsi_dh_data *hp_sw_bus_attach(struct scsi_device *sdev)
 {
 	struct hp_sw_dh_data *h;
-	unsigned long flags;
 	int ret;
 
 	h = kzalloc(sizeof(*h), GFP_KERNEL);
-	if (!h) {
-		sdev_printk(KERN_ERR, sdev, "%s: Attach Failed\n",
-			    HP_SW_NAME);
-		return -ENOMEM;
-	}
-
-	h->dh_data.scsi_dh = &hp_sw_dh;
+	if (!h)
+		return ERR_PTR(-ENOMEM);
 	h->path_state = HP_SW_PATH_UNINITIALIZED;
 	h->retries = HP_SW_RETRIES;
 	h->sdev = sdev;
@@ -375,37 +356,32 @@ static int hp_sw_bus_attach(struct scsi_device *sdev)
 	if (ret != SCSI_DH_OK || h->path_state == HP_SW_PATH_UNINITIALIZED)
 		goto failed;
 
-	spin_lock_irqsave(sdev->request_queue->queue_lock, flags);
-	sdev->scsi_dh_data = &h->dh_data;
-	spin_unlock_irqrestore(sdev->request_queue->queue_lock, flags);
-
 	sdev_printk(KERN_INFO, sdev, "%s: attached to %s path\n",
 		    HP_SW_NAME, h->path_state == HP_SW_PATH_ACTIVE?
 		    "active":"passive");
-
-	return 0;
-
+	return &h->dh_data;
 failed:
 	kfree(h);
-	sdev_printk(KERN_ERR, sdev, "%s: not attached\n",
-		    HP_SW_NAME);
-	return -EINVAL;
+	return ERR_PTR(-EINVAL);
 }
 
 static void hp_sw_bus_detach( struct scsi_device *sdev )
 {
 	struct hp_sw_dh_data *h = get_hp_sw_data(sdev);
-	unsigned long flags;
-
-	spin_lock_irqsave(sdev->request_queue->queue_lock, flags);
-	sdev->scsi_dh_data = NULL;
-	spin_unlock_irqrestore(sdev->request_queue->queue_lock, flags);
-
-	sdev_printk(KERN_NOTICE, sdev, "%s: Detached\n", HP_SW_NAME);
 
 	kfree(h);
 }
 
+static struct scsi_device_handler hp_sw_dh = {
+	.name		= HP_SW_NAME,
+	.module		= THIS_MODULE,
+	.attach		= hp_sw_bus_attach,
+	.detach		= hp_sw_bus_detach,
+	.activate	= hp_sw_activate,
+	.prep_fn	= hp_sw_prep_fn,
+	.match		= hp_sw_match,
+};
+
 static int __init hp_sw_init(void)
 {
 	return scsi_register_device_handler(&hp_sw_dh);
diff --git a/drivers/scsi/device_handler/scsi_dh_rdac.c b/drivers/scsi/device_handler/scsi_dh_rdac.c
index 8b09528..b46ace3 100644
--- a/drivers/scsi/device_handler/scsi_dh_rdac.c
+++ b/drivers/scsi/device_handler/scsi_dh_rdac.c
@@ -827,36 +827,16 @@ static bool rdac_match(struct scsi_device *sdev)
 	return false;
 }
 
-static int rdac_bus_attach(struct scsi_device *sdev);
-static void rdac_bus_detach(struct scsi_device *sdev);
-
-static struct scsi_device_handler rdac_dh = {
-	.name = RDAC_NAME,
-	.module = THIS_MODULE,
-	.prep_fn = rdac_prep_fn,
-	.check_sense = rdac_check_sense,
-	.attach = rdac_bus_attach,
-	.detach = rdac_bus_detach,
-	.activate = rdac_activate,
-	.match = rdac_match,
-};
-
-static int rdac_bus_attach(struct scsi_device *sdev)
+static struct scsi_dh_data *rdac_bus_attach(struct scsi_device *sdev)
 {
 	struct rdac_dh_data *h;
-	unsigned long flags;
 	int err;
 	char array_name[ARRAY_LABEL_LEN];
 	char array_id[UNIQUE_ID_LEN];
 
 	h = kzalloc(sizeof(*h) , GFP_KERNEL);
-	if (!h) {
-		sdev_printk(KERN_ERR, sdev, "%s: Attach failed\n",
-			    RDAC_NAME);
-		return -ENOMEM;
-	}
-
-	h->dh_data.scsi_dh = &rdac_dh;
+	if (!h)
+		return ERR_PTR(-ENOMEM);
 	h->lun = UNINITIALIZED_LUN;
 	h->state = RDAC_STATE_ACTIVE;
 
@@ -876,16 +856,12 @@ static int rdac_bus_attach(struct scsi_device *sdev)
 	if (err != SCSI_DH_OK)
 		goto clean_ctlr;
 
-	spin_lock_irqsave(sdev->request_queue->queue_lock, flags);
-	sdev->scsi_dh_data = &h->dh_data;
-	spin_unlock_irqrestore(sdev->request_queue->queue_lock, flags);
-
 	sdev_printk(KERN_NOTICE, sdev,
 		    "%s: LUN %d (%s) (%s)\n",
 		    RDAC_NAME, h->lun, mode[(int)h->mode],
 		    lun_state[(int)h->lun_state]);
 
-	return 0;
+	return &h->dh_data;
 
 clean_ctlr:
 	spin_lock(&list_lock);
@@ -894,32 +870,33 @@ clean_ctlr:
 
 failed:
 	kfree(h);
-	sdev_printk(KERN_ERR, sdev, "%s: not attached\n",
-		    RDAC_NAME);
-	return -EINVAL;
+	return ERR_PTR(-EINVAL);
 }
 
 static void rdac_bus_detach( struct scsi_device *sdev )
 {
 	struct rdac_dh_data *h = get_rdac_data(sdev);
-	unsigned long flags;
 
 	if (h->ctlr && h->ctlr->ms_queued)
 		flush_workqueue(kmpath_rdacd);
 
-	spin_lock_irqsave(sdev->request_queue->queue_lock, flags);
-	sdev->scsi_dh_data = NULL;
-	spin_unlock_irqrestore(sdev->request_queue->queue_lock, flags);
-
 	spin_lock(&list_lock);
 	if (h->ctlr)
 		kref_put(&h->ctlr->kref, release_controller);
 	spin_unlock(&list_lock);
 	kfree(h);
-	sdev_printk(KERN_NOTICE, sdev, "%s: Detached\n", RDAC_NAME);
 }
 
-
+static struct scsi_device_handler rdac_dh = {
+	.name = RDAC_NAME,
+	.module = THIS_MODULE,
+	.prep_fn = rdac_prep_fn,
+	.check_sense = rdac_check_sense,
+	.attach = rdac_bus_attach,
+	.detach = rdac_bus_detach,
+	.activate = rdac_activate,
+	.match = rdac_match,
+};
 
 static int __init rdac_init(void)
 {
diff --git a/include/scsi/scsi_device.h b/include/scsi/scsi_device.h
index 2601c97..50d47e6 100644
--- a/include/scsi/scsi_device.h
+++ b/include/scsi/scsi_device.h
@@ -210,7 +210,7 @@ struct scsi_device_handler {
 	struct module *module;
 	const char *name;
 	int (*check_sense)(struct scsi_device *, struct scsi_sense_hdr *);
-	int (*attach)(struct scsi_device *);
+	struct scsi_dh_data *(*attach)(struct scsi_device *);
 	void (*detach)(struct scsi_device *);
 	int (*activate)(struct scsi_device *, activate_complete, void *);
 	int (*prep_fn)(struct scsi_device *, struct request *);
-- 
1.9.1

