From: Christoph Hellwig <hch@lst.de>
Subject: [PATCH 2/6] scsi: use container_of to get at device handler private data
Date: Thu, 30 Oct 2014 10:19:10 +0100
Message-ID: <1414660754-8431-3-git-send-email-hch@lst.de>
References: <1414660754-8431-1-git-send-email-hch@lst.de>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from casper.infradead.org ([85.118.1.10]:50822 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758526AbaJ3JTF (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Thu, 30 Oct 2014 05:19:05 -0400
In-Reply-To: <1414660754-8431-1-git-send-email-hch@lst.de>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Hannes Reinecke <hare@suse.de>, Mike Christie <michaelc@cs.wisc.edu>
Cc: Sean Stewart <Sean.Stewart@netapp.com>, Bart Van Assche <bvanassche@acm.org>, linux-scsi@vger.kernel.org

Signed-off-by: Christoph Hellwig <hch@lst.de>
Reviewed-by: Hannes Reinecke <hare@suse.de>
---
 drivers/scsi/device_handler/scsi_dh_alua.c  | 25 +++++++++----------------
 drivers/scsi/device_handler/scsi_dh_emc.c   | 24 ++++++++++--------------
 drivers/scsi/device_handler/scsi_dh_hp_sw.c | 23 +++++++++--------------
 drivers/scsi/device_handler/scsi_dh_rdac.c  | 25 +++++++++----------------
 include/scsi/scsi_device.h                  |  1 -
 5 files changed, 37 insertions(+), 61 deletions(-)

diff --git a/drivers/scsi/device_handler/scsi_dh_alua.c b/drivers/scsi/device_handler/scsi_dh_alua.c
index 45b1795..40a2b0e 100644
--- a/drivers/scsi/device_handler/scsi_dh_alua.c
+++ b/drivers/scsi/device_handler/scsi_dh_alua.c
@@ -62,6 +62,7 @@
 #define ALUA_OPTIMIZE_STPG		1
 
 struct alua_dh_data {
+	struct scsi_dh_data	dh_data;
 	int			group_id;
 	int			rel_port;
 	int			tpgs;
@@ -87,9 +88,7 @@ static int alua_check_sense(struct scsi_device *, struct scsi_sense_hdr *);
 
 static inline struct alua_dh_data *get_alua_data(struct scsi_device *sdev)
 {
-	struct scsi_dh_data *scsi_dh_data = sdev->scsi_dh_data;
-	BUG_ON(scsi_dh_data == NULL);
-	return ((struct alua_dh_data *) scsi_dh_data->buf);
+	return container_of(sdev->scsi_dh_data, struct alua_dh_data, dh_data);
 }
 
 static int realloc_buffer(struct alua_dh_data *h, unsigned len)
@@ -839,21 +838,18 @@ static struct scsi_device_handler alua_dh = {
  */
 static int alua_bus_attach(struct scsi_device *sdev)
 {
-	struct scsi_dh_data *scsi_dh_data;
 	struct alua_dh_data *h;
 	unsigned long flags;
 	int err = SCSI_DH_OK;
 
-	scsi_dh_data = kzalloc(sizeof(*scsi_dh_data)
-			       + sizeof(*h) , GFP_KERNEL);
-	if (!scsi_dh_data) {
+	h = kzalloc(sizeof(*h) , GFP_KERNEL);
+	if (!h) {
 		sdev_printk(KERN_ERR, sdev, "%s: Attach failed\n",
 			    ALUA_DH_NAME);
 		return -ENOMEM;
 	}
 
-	scsi_dh_data->scsi_dh = &alua_dh;
-	h = (struct alua_dh_data *) scsi_dh_data->buf;
+	h->dh_data.scsi_dh = &alua_dh;
 	h->tpgs = TPGS_MODE_UNINITIALIZED;
 	h->state = TPGS_STATE_OPTIMIZED;
 	h->group_id = -1;
@@ -867,14 +863,14 @@ static int alua_bus_attach(struct scsi_device *sdev)
 		goto failed;
 
 	spin_lock_irqsave(sdev->request_queue->queue_lock, flags);
-	sdev->scsi_dh_data = scsi_dh_data;
+	sdev->scsi_dh_data = &h->dh_data;
 	spin_unlock_irqrestore(sdev->request_queue->queue_lock, flags);
 	sdev_printk(KERN_NOTICE, sdev, "%s: Attached\n", ALUA_DH_NAME);
 
 	return 0;
 
 failed:
-	kfree(scsi_dh_data);
+	kfree(h);
 	sdev_printk(KERN_ERR, sdev, "%s: not attached\n", ALUA_DH_NAME);
 	return -EINVAL;
 }
@@ -885,19 +881,16 @@ failed:
  */
 static void alua_bus_detach(struct scsi_device *sdev)
 {
-	struct scsi_dh_data *scsi_dh_data;
-	struct alua_dh_data *h;
+	struct alua_dh_data *h = get_alua_data(sdev);
 	unsigned long flags;
 
 	spin_lock_irqsave(sdev->request_queue->queue_lock, flags);
-	scsi_dh_data = sdev->scsi_dh_data;
 	sdev->scsi_dh_data = NULL;
 	spin_unlock_irqrestore(sdev->request_queue->queue_lock, flags);
 
-	h = (struct alua_dh_data *) scsi_dh_data->buf;
 	if (h->buff && h->inq != h->buff)
 		kfree(h->buff);
-	kfree(scsi_dh_data);
+	kfree(h);
 	sdev_printk(KERN_NOTICE, sdev, "%s: Detached\n", ALUA_DH_NAME);
 }
 
diff --git a/drivers/scsi/device_handler/scsi_dh_emc.c b/drivers/scsi/device_handler/scsi_dh_emc.c
index 153b4c3..c2e26cd 100644
--- a/drivers/scsi/device_handler/scsi_dh_emc.c
+++ b/drivers/scsi/device_handler/scsi_dh_emc.c
@@ -72,6 +72,7 @@ static const char * lun_state[] =
 };
 
 struct clariion_dh_data {
+	struct scsi_dh_data dh_data;
 	/*
 	 * Flags:
 	 *  CLARIION_SHORT_TRESPASS
@@ -116,9 +117,8 @@ struct clariion_dh_data {
 static inline struct clariion_dh_data
 			*get_clariion_data(struct scsi_device *sdev)
 {
-	struct scsi_dh_data *scsi_dh_data = sdev->scsi_dh_data;
-	BUG_ON(scsi_dh_data == NULL);
-	return ((struct clariion_dh_data *) scsi_dh_data->buf);
+	return container_of(sdev->scsi_dh_data, struct clariion_dh_data,
+			dh_data);
 }
 
 /*
@@ -665,21 +665,18 @@ static struct scsi_device_handler clariion_dh = {
 
 static int clariion_bus_attach(struct scsi_device *sdev)
 {
-	struct scsi_dh_data *scsi_dh_data;
 	struct clariion_dh_data *h;
 	unsigned long flags;
 	int err;
 
-	scsi_dh_data = kzalloc(sizeof(*scsi_dh_data)
-			       + sizeof(*h) , GFP_KERNEL);
-	if (!scsi_dh_data) {
+	h = kzalloc(sizeof(*h) , GFP_KERNEL);
+	if (!h) {
 		sdev_printk(KERN_ERR, sdev, "%s: Attach failed\n",
 			    CLARIION_NAME);
 		return -ENOMEM;
 	}
 
-	scsi_dh_data->scsi_dh = &clariion_dh;
-	h = (struct clariion_dh_data *) scsi_dh_data->buf;
+	h->dh_data.scsi_dh = &clariion_dh;
 	h->lun_state = CLARIION_LUN_UNINITIALIZED;
 	h->default_sp = CLARIION_UNBOUND_LU;
 	h->current_sp = CLARIION_UNBOUND_LU;
@@ -693,7 +690,7 @@ static int clariion_bus_attach(struct scsi_device *sdev)
 		goto failed;
 
 	spin_lock_irqsave(sdev->request_queue->queue_lock, flags);
-	sdev->scsi_dh_data = scsi_dh_data;
+	sdev->scsi_dh_data = &h->dh_data;
 	spin_unlock_irqrestore(sdev->request_queue->queue_lock, flags);
 
 	sdev_printk(KERN_INFO, sdev,
@@ -705,7 +702,7 @@ static int clariion_bus_attach(struct scsi_device *sdev)
 	return 0;
 
 failed:
-	kfree(scsi_dh_data);
+	kfree(h);
 	sdev_printk(KERN_ERR, sdev, "%s: not attached\n",
 		    CLARIION_NAME);
 	return -EINVAL;
@@ -713,18 +710,17 @@ failed:
 
 static void clariion_bus_detach(struct scsi_device *sdev)
 {
-	struct scsi_dh_data *scsi_dh_data;
+	struct clariion_dh_data *h = get_clariion_data(sdev);
 	unsigned long flags;
 
 	spin_lock_irqsave(sdev->request_queue->queue_lock, flags);
-	scsi_dh_data = sdev->scsi_dh_data;
 	sdev->scsi_dh_data = NULL;
 	spin_unlock_irqrestore(sdev->request_queue->queue_lock, flags);
 
 	sdev_printk(KERN_NOTICE, sdev, "%s: Detached\n",
 		    CLARIION_NAME);
 
-	kfree(scsi_dh_data);
+	kfree(h);
 }
 
 static int __init clariion_init(void)
diff --git a/drivers/scsi/device_handler/scsi_dh_hp_sw.c b/drivers/scsi/device_handler/scsi_dh_hp_sw.c
index 367e6f5..040998c 100644
--- a/drivers/scsi/device_handler/scsi_dh_hp_sw.c
+++ b/drivers/scsi/device_handler/scsi_dh_hp_sw.c
@@ -38,6 +38,7 @@
 #define HP_SW_PATH_PASSIVE		1
 
 struct hp_sw_dh_data {
+	struct scsi_dh_data dh_data;
 	unsigned char sense[SCSI_SENSE_BUFFERSIZE];
 	int path_state;
 	int retries;
@@ -51,9 +52,7 @@ static int hp_sw_start_stop(struct hp_sw_dh_data *);
 
 static inline struct hp_sw_dh_data *get_hp_sw_data(struct scsi_device *sdev)
 {
-	struct scsi_dh_data *scsi_dh_data = sdev->scsi_dh_data;
-	BUG_ON(scsi_dh_data == NULL);
-	return ((struct hp_sw_dh_data *) scsi_dh_data->buf);
+	return container_of(sdev->scsi_dh_data, struct hp_sw_dh_data, dh_data);
 }
 
 /*
@@ -354,21 +353,18 @@ static struct scsi_device_handler hp_sw_dh = {
 
 static int hp_sw_bus_attach(struct scsi_device *sdev)
 {
-	struct scsi_dh_data *scsi_dh_data;
 	struct hp_sw_dh_data *h;
 	unsigned long flags;
 	int ret;
 
-	scsi_dh_data = kzalloc(sizeof(*scsi_dh_data)
-			       + sizeof(*h) , GFP_KERNEL);
-	if (!scsi_dh_data) {
+	h = kzalloc(sizeof(*h), GFP_KERNEL);
+	if (!h) {
 		sdev_printk(KERN_ERR, sdev, "%s: Attach Failed\n",
 			    HP_SW_NAME);
 		return 0;
 	}
 
-	scsi_dh_data->scsi_dh = &hp_sw_dh;
-	h = (struct hp_sw_dh_data *) scsi_dh_data->buf;
+	h->dh_data.scsi_dh = &hp_sw_dh;
 	h->path_state = HP_SW_PATH_UNINITIALIZED;
 	h->retries = HP_SW_RETRIES;
 	h->sdev = sdev;
@@ -378,7 +374,7 @@ static int hp_sw_bus_attach(struct scsi_device *sdev)
 		goto failed;
 
 	spin_lock_irqsave(sdev->request_queue->queue_lock, flags);
-	sdev->scsi_dh_data = scsi_dh_data;
+	sdev->scsi_dh_data = &h->dh_data;
 	spin_unlock_irqrestore(sdev->request_queue->queue_lock, flags);
 
 	sdev_printk(KERN_INFO, sdev, "%s: attached to %s path\n",
@@ -388,7 +384,7 @@ static int hp_sw_bus_attach(struct scsi_device *sdev)
 	return 0;
 
 failed:
-	kfree(scsi_dh_data);
+	kfree(h);
 	sdev_printk(KERN_ERR, sdev, "%s: not attached\n",
 		    HP_SW_NAME);
 	return -EINVAL;
@@ -396,17 +392,16 @@ failed:
 
 static void hp_sw_bus_detach( struct scsi_device *sdev )
 {
-	struct scsi_dh_data *scsi_dh_data;
+	struct hp_sw_dh_data *h = get_hp_sw_data(sdev);
 	unsigned long flags;
 
 	spin_lock_irqsave(sdev->request_queue->queue_lock, flags);
-	scsi_dh_data = sdev->scsi_dh_data;
 	sdev->scsi_dh_data = NULL;
 	spin_unlock_irqrestore(sdev->request_queue->queue_lock, flags);
 
 	sdev_printk(KERN_NOTICE, sdev, "%s: Detached\n", HP_SW_NAME);
 
-	kfree(scsi_dh_data);
+	kfree(h);
 }
 
 static int __init hp_sw_init(void)
diff --git a/drivers/scsi/device_handler/scsi_dh_rdac.c b/drivers/scsi/device_handler/scsi_dh_rdac.c
index b850954..ef8caaa 100644
--- a/drivers/scsi/device_handler/scsi_dh_rdac.c
+++ b/drivers/scsi/device_handler/scsi_dh_rdac.c
@@ -181,6 +181,7 @@ struct c2_inquiry {
 };
 
 struct rdac_dh_data {
+	struct scsi_dh_data	dh_data;
 	struct rdac_controller	*ctlr;
 #define UNINITIALIZED_LUN	(1 << 8)
 	unsigned		lun;
@@ -261,9 +262,7 @@ do { \
 
 static inline struct rdac_dh_data *get_rdac_data(struct scsi_device *sdev)
 {
-	struct scsi_dh_data *scsi_dh_data = sdev->scsi_dh_data;
-	BUG_ON(scsi_dh_data == NULL);
-	return ((struct rdac_dh_data *) scsi_dh_data->buf);
+	return container_of(sdev->scsi_dh_data, struct rdac_dh_data, dh_data);
 }
 
 static struct request *get_rdac_req(struct scsi_device *sdev,
@@ -842,23 +841,20 @@ static struct scsi_device_handler rdac_dh = {
 
 static int rdac_bus_attach(struct scsi_device *sdev)
 {
-	struct scsi_dh_data *scsi_dh_data;
 	struct rdac_dh_data *h;
 	unsigned long flags;
 	int err;
 	char array_name[ARRAY_LABEL_LEN];
 	char array_id[UNIQUE_ID_LEN];
 
-	scsi_dh_data = kzalloc(sizeof(*scsi_dh_data)
-			       + sizeof(*h) , GFP_KERNEL);
-	if (!scsi_dh_data) {
+	h = kzalloc(sizeof(*h) , GFP_KERNEL);
+	if (!h) {
 		sdev_printk(KERN_ERR, sdev, "%s: Attach failed\n",
 			    RDAC_NAME);
 		return -ENOMEM;
 	}
 
-	scsi_dh_data->scsi_dh = &rdac_dh;
-	h = (struct rdac_dh_data *) scsi_dh_data->buf;
+	h->dh_data.scsi_dh = &rdac_dh;
 	h->lun = UNINITIALIZED_LUN;
 	h->state = RDAC_STATE_ACTIVE;
 
@@ -879,7 +875,7 @@ static int rdac_bus_attach(struct scsi_device *sdev)
 		goto clean_ctlr;
 
 	spin_lock_irqsave(sdev->request_queue->queue_lock, flags);
-	sdev->scsi_dh_data = scsi_dh_data;
+	sdev->scsi_dh_data = &h->dh_data;
 	spin_unlock_irqrestore(sdev->request_queue->queue_lock, flags);
 
 	sdev_printk(KERN_NOTICE, sdev,
@@ -895,7 +891,7 @@ clean_ctlr:
 	spin_unlock(&list_lock);
 
 failed:
-	kfree(scsi_dh_data);
+	kfree(h);
 	sdev_printk(KERN_ERR, sdev, "%s: not attached\n",
 		    RDAC_NAME);
 	return -EINVAL;
@@ -903,12 +899,9 @@ failed:
 
 static void rdac_bus_detach( struct scsi_device *sdev )
 {
-	struct scsi_dh_data *scsi_dh_data;
-	struct rdac_dh_data *h;
+	struct rdac_dh_data *h = get_rdac_data(sdev);
 	unsigned long flags;
 
-	scsi_dh_data = sdev->scsi_dh_data;
-	h = (struct rdac_dh_data *) scsi_dh_data->buf;
 	if (h->ctlr && h->ctlr->ms_queued)
 		flush_workqueue(kmpath_rdacd);
 
@@ -920,7 +913,7 @@ static void rdac_bus_detach( struct scsi_device *sdev )
 	if (h->ctlr)
 		kref_put(&h->ctlr->kref, release_controller);
 	spin_unlock(&list_lock);
-	kfree(scsi_dh_data);
+	kfree(h);
 	sdev_printk(KERN_NOTICE, sdev, "%s: Detached\n", RDAC_NAME);
 }
 
diff --git a/include/scsi/scsi_device.h b/include/scsi/scsi_device.h
index 0b18a09..04cd5ad 100644
--- a/include/scsi/scsi_device.h
+++ b/include/scsi/scsi_device.h
@@ -228,7 +228,6 @@ struct scsi_dh_data {
 	struct scsi_device_handler *scsi_dh;
 	struct scsi_device *sdev;
 	struct kref kref;
-	char buf[0];
 };
 
 #define	to_scsi_device(d)	\
-- 
1.9.1

