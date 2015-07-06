From: Hannes Reinecke <hare@suse.de>
Subject: [PATCH 6/9] scsi_dh: kill struct scsi_dh_data
Date: Mon,  6 Jul 2015 16:15:02 +0200
Message-ID: <1436192105-44064-7-git-send-email-hare@suse.de>
References: <1436192105-44064-1-git-send-email-hare@suse.de>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from cantor2.suse.de ([195.135.220.15]:51828 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751412AbbGFOPM (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Mon, 6 Jul 2015 10:15:12 -0400
In-Reply-To: <1436192105-44064-1-git-send-email-hare@suse.de>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James Bottomley <james.bottomley@hansenpartnership.com>
Cc: Christoph Hellwig <hch@lst.de>, linux-scsi@vger.kernel.org, "Martin K. Petersen" <martin.petersen@oracle.com>, Mike Snitzer <snitzer@redhat.com>

From: Christoph Hellwig <hch@lst.de>

Add a ->handler and a ->handler_data field to struct scsi_device and kill
this indirection.  Also move struct scsi_device_handler to scsi_dh.h so that
changes to it don't require rebuilding every SCSI LLDD.

Signed-off-by: Christoph Hellwig <hch@lst.de>
Reviewed-by: Martin K. Petersen <martin.petersen@oracle.com>
Reviewed-by: Hannes Reinecke <hare@suse.de>
---
 drivers/scsi/device_handler/scsi_dh_alua.c  | 24 ++++------
 drivers/scsi/device_handler/scsi_dh_emc.c   | 28 ++++-------
 drivers/scsi/device_handler/scsi_dh_hp_sw.c | 24 ++++------
 drivers/scsi/device_handler/scsi_dh_rdac.c  | 29 +++++-------
 drivers/scsi/scsi_dh.c                      | 72 +++++++++++------------------
 drivers/scsi/scsi_error.c                   |  6 +--
 drivers/scsi/scsi_lib.c                     |  6 +--
 include/scsi/scsi_device.h                  | 25 ++--------
 include/scsi/scsi_dh.h                      | 17 +++++++
 9 files changed, 92 insertions(+), 139 deletions(-)

diff --git a/drivers/scsi/device_handler/scsi_dh_alua.c b/drivers/scsi/device_handler/scsi_dh_alua.c
index ace2457..e418849 100644
--- a/drivers/scsi/device_handler/scsi_dh_alua.c
+++ b/drivers/scsi/device_handler/scsi_dh_alua.c
@@ -62,7 +62,6 @@
 #define ALUA_OPTIMIZE_STPG		1
 
 struct alua_dh_data {
-	struct scsi_dh_data	dh_data;
 	int			group_id;
 	int			rel_port;
 	int			tpgs;
@@ -86,11 +85,6 @@ struct alua_dh_data {
 static char print_alua_state(int);
 static int alua_check_sense(struct scsi_device *, struct scsi_sense_hdr *);
 
-static inline struct alua_dh_data *get_alua_data(struct scsi_device *sdev)
-{
-	return container_of(sdev->scsi_dh_data, struct alua_dh_data, dh_data);
-}
-
 static int realloc_buffer(struct alua_dh_data *h, unsigned len)
 {
 	if (h->buff && h->buff != h->inq)
@@ -708,7 +702,7 @@ out:
  */
 static int alua_set_params(struct scsi_device *sdev, const char *params)
 {
-	struct alua_dh_data *h = get_alua_data(sdev);
+	struct alua_dh_data *h = sdev->handler_data;
 	unsigned int optimize = 0, argc;
 	const char *p = params;
 	int result = SCSI_DH_OK;
@@ -746,7 +740,7 @@ MODULE_PARM_DESC(optimize_stpg, "Allow use of a non-optimized path, rather than
 static int alua_activate(struct scsi_device *sdev,
 			activate_complete fn, void *data)
 {
-	struct alua_dh_data *h = get_alua_data(sdev);
+	struct alua_dh_data *h = sdev->handler_data;
 	int err = SCSI_DH_OK;
 	int stpg = 0;
 
@@ -804,7 +798,7 @@ out:
  */
 static int alua_prep_fn(struct scsi_device *sdev, struct request *req)
 {
-	struct alua_dh_data *h = get_alua_data(sdev);
+	struct alua_dh_data *h = sdev->handler_data;
 	int ret = BLKPREP_OK;
 
 	if (h->state == TPGS_STATE_TRANSITIONING)
@@ -823,14 +817,14 @@ static int alua_prep_fn(struct scsi_device *sdev, struct request *req)
  * alua_bus_attach - Attach device handler
  * @sdev: device to be attached to
  */
-static struct scsi_dh_data *alua_bus_attach(struct scsi_device *sdev)
+static int alua_bus_attach(struct scsi_device *sdev)
 {
 	struct alua_dh_data *h;
 	int err;
 
 	h = kzalloc(sizeof(*h) , GFP_KERNEL);
 	if (!h)
-		return ERR_PTR(-ENOMEM);
+		return -ENOMEM;
 	h->tpgs = TPGS_MODE_UNINITIALIZED;
 	h->state = TPGS_STATE_OPTIMIZED;
 	h->group_id = -1;
@@ -843,11 +837,11 @@ static struct scsi_dh_data *alua_bus_attach(struct scsi_device *sdev)
 	if (err != SCSI_DH_OK && err != SCSI_DH_DEV_OFFLINED)
 		goto failed;
 
-	sdev_printk(KERN_NOTICE, sdev, "%s: Attached\n", ALUA_DH_NAME);
-	return &h->dh_data;
+	sdev->handler_data = h;
+	return 0;
 failed:
 	kfree(h);
-	return ERR_PTR(-EINVAL);
+	return -EINVAL;
 }
 
 /*
@@ -856,7 +850,7 @@ failed:
  */
 static void alua_bus_detach(struct scsi_device *sdev)
 {
-	struct alua_dh_data *h = get_alua_data(sdev);
+	struct alua_dh_data *h = sdev->handler_data;
 
 	if (h->buff && h->inq != h->buff)
 		kfree(h->buff);
diff --git a/drivers/scsi/device_handler/scsi_dh_emc.c b/drivers/scsi/device_handler/scsi_dh_emc.c
index fd31e67..4b75b50 100644
--- a/drivers/scsi/device_handler/scsi_dh_emc.c
+++ b/drivers/scsi/device_handler/scsi_dh_emc.c
@@ -72,7 +72,6 @@ static const char * lun_state[] =
 };
 
 struct clariion_dh_data {
-	struct scsi_dh_data dh_data;
 	/*
 	 * Flags:
 	 *  CLARIION_SHORT_TRESPASS
@@ -114,13 +113,6 @@ struct clariion_dh_data {
 	int current_sp;
 };
 
-static inline struct clariion_dh_data
-			*get_clariion_data(struct scsi_device *sdev)
-{
-	return container_of(sdev->scsi_dh_data, struct clariion_dh_data,
-			dh_data);
-}
-
 /*
  * Parse MODE_SELECT cmd reply.
  */
@@ -450,7 +442,7 @@ static int clariion_check_sense(struct scsi_device *sdev,
 
 static int clariion_prep_fn(struct scsi_device *sdev, struct request *req)
 {
-	struct clariion_dh_data *h = get_clariion_data(sdev);
+	struct clariion_dh_data *h = sdev->handler_data;
 	int ret = BLKPREP_OK;
 
 	if (h->lun_state != CLARIION_LUN_OWNED) {
@@ -533,7 +525,7 @@ retry:
 static int clariion_activate(struct scsi_device *sdev,
 				activate_complete fn, void *data)
 {
-	struct clariion_dh_data *csdev = get_clariion_data(sdev);
+	struct clariion_dh_data *csdev = sdev->handler_data;
 	int result;
 
 	result = clariion_send_inquiry(sdev, csdev);
@@ -574,7 +566,7 @@ done:
  */
 static int clariion_set_params(struct scsi_device *sdev, const char *params)
 {
-	struct clariion_dh_data *csdev = get_clariion_data(sdev);
+	struct clariion_dh_data *csdev = sdev->handler_data;
 	unsigned int hr = 0, st = 0, argc;
 	const char *p = params;
 	int result = SCSI_DH_OK;
@@ -622,14 +614,14 @@ done:
 	return result;
 }
 
-static struct scsi_dh_data *clariion_bus_attach(struct scsi_device *sdev)
+static int clariion_bus_attach(struct scsi_device *sdev)
 {
 	struct clariion_dh_data *h;
 	int err;
 
 	h = kzalloc(sizeof(*h) , GFP_KERNEL);
 	if (!h)
-		return ERR_PTR(-ENOMEM);
+		return -ENOMEM;
 	h->lun_state = CLARIION_LUN_UNINITIALIZED;
 	h->default_sp = CLARIION_UNBOUND_LU;
 	h->current_sp = CLARIION_UNBOUND_LU;
@@ -647,18 +639,18 @@ static struct scsi_dh_data *clariion_bus_attach(struct scsi_device *sdev)
 		    CLARIION_NAME, h->current_sp + 'A',
 		    h->port, lun_state[h->lun_state],
 		    h->default_sp + 'A');
-	return &h->dh_data;
+
+	sdev->handler_data = h;
+	return 0;
 
 failed:
 	kfree(h);
-	return ERR_PTR(-EINVAL);
+	return -EINVAL;
 }
 
 static void clariion_bus_detach(struct scsi_device *sdev)
 {
-	struct clariion_dh_data *h = get_clariion_data(sdev);
-
-	kfree(h);
+	kfree(sdev->handler_data);
 }
 
 static struct scsi_device_handler clariion_dh = {
diff --git a/drivers/scsi/device_handler/scsi_dh_hp_sw.c b/drivers/scsi/device_handler/scsi_dh_hp_sw.c
index 1bf10d3..d5390ba 100644
--- a/drivers/scsi/device_handler/scsi_dh_hp_sw.c
+++ b/drivers/scsi/device_handler/scsi_dh_hp_sw.c
@@ -38,7 +38,6 @@
 #define HP_SW_PATH_PASSIVE		1
 
 struct hp_sw_dh_data {
-	struct scsi_dh_data dh_data;
 	unsigned char sense[SCSI_SENSE_BUFFERSIZE];
 	int path_state;
 	int retries;
@@ -50,11 +49,6 @@ struct hp_sw_dh_data {
 
 static int hp_sw_start_stop(struct hp_sw_dh_data *);
 
-static inline struct hp_sw_dh_data *get_hp_sw_data(struct scsi_device *sdev)
-{
-	return container_of(sdev->scsi_dh_data, struct hp_sw_dh_data, dh_data);
-}
-
 /*
  * tur_done - Handle TEST UNIT READY return status
  * @sdev: sdev the command has been sent to
@@ -267,7 +261,7 @@ static int hp_sw_start_stop(struct hp_sw_dh_data *h)
 
 static int hp_sw_prep_fn(struct scsi_device *sdev, struct request *req)
 {
-	struct hp_sw_dh_data *h = get_hp_sw_data(sdev);
+	struct hp_sw_dh_data *h = sdev->handler_data;
 	int ret = BLKPREP_OK;
 
 	if (h->path_state != HP_SW_PATH_ACTIVE) {
@@ -292,7 +286,7 @@ static int hp_sw_activate(struct scsi_device *sdev,
 				activate_complete fn, void *data)
 {
 	int ret = SCSI_DH_OK;
-	struct hp_sw_dh_data *h = get_hp_sw_data(sdev);
+	struct hp_sw_dh_data *h = sdev->handler_data;
 
 	ret = hp_sw_tur(sdev, h);
 
@@ -311,14 +305,14 @@ static int hp_sw_activate(struct scsi_device *sdev,
 	return 0;
 }
 
-static struct scsi_dh_data *hp_sw_bus_attach(struct scsi_device *sdev)
+static int hp_sw_bus_attach(struct scsi_device *sdev)
 {
 	struct hp_sw_dh_data *h;
 	int ret;
 
 	h = kzalloc(sizeof(*h), GFP_KERNEL);
 	if (!h)
-		return ERR_PTR(-ENOMEM);
+		return -ENOMEM;
 	h->path_state = HP_SW_PATH_UNINITIALIZED;
 	h->retries = HP_SW_RETRIES;
 	h->sdev = sdev;
@@ -330,17 +324,17 @@ static struct scsi_dh_data *hp_sw_bus_attach(struct scsi_device *sdev)
 	sdev_printk(KERN_INFO, sdev, "%s: attached to %s path\n",
 		    HP_SW_NAME, h->path_state == HP_SW_PATH_ACTIVE?
 		    "active":"passive");
-	return &h->dh_data;
+
+	sdev->handler_data = h;
+	return 0;
 failed:
 	kfree(h);
-	return ERR_PTR(-EINVAL);
+	return -EINVAL;
 }
 
 static void hp_sw_bus_detach( struct scsi_device *sdev )
 {
-	struct hp_sw_dh_data *h = get_hp_sw_data(sdev);
-
-	kfree(h);
+	kfree(sdev->handler_data);
 }
 
 static struct scsi_device_handler hp_sw_dh = {
diff --git a/drivers/scsi/device_handler/scsi_dh_rdac.c b/drivers/scsi/device_handler/scsi_dh_rdac.c
index d89616f..0c6d612 100644
--- a/drivers/scsi/device_handler/scsi_dh_rdac.c
+++ b/drivers/scsi/device_handler/scsi_dh_rdac.c
@@ -181,7 +181,6 @@ struct c2_inquiry {
 };
 
 struct rdac_dh_data {
-	struct scsi_dh_data	dh_data;
 	struct rdac_controller	*ctlr;
 #define UNINITIALIZED_LUN	(1 << 8)
 	unsigned		lun;
@@ -260,11 +259,6 @@ do { \
 		sdev_printk(KERN_INFO, sdev, RDAC_NAME ": " f "\n", ## arg); \
 } while (0);
 
-static inline struct rdac_dh_data *get_rdac_data(struct scsi_device *sdev)
-{
-	return container_of(sdev->scsi_dh_data, struct rdac_dh_data, dh_data);
-}
-
 static struct request *get_rdac_req(struct scsi_device *sdev,
 			void *buffer, unsigned buflen, int rw)
 {
@@ -544,7 +538,7 @@ static int mode_select_handle_sense(struct scsi_device *sdev,
 {
 	struct scsi_sense_hdr sense_hdr;
 	int err = SCSI_DH_IO, ret;
-	struct rdac_dh_data *h = get_rdac_data(sdev);
+	struct rdac_dh_data *h = sdev->handler_data;
 
 	ret = scsi_normalize_sense(sensebuf, SCSI_SENSE_BUFFERSIZE, &sense_hdr);
 	if (!ret)
@@ -589,7 +583,7 @@ static void send_mode_select(struct work_struct *work)
 		container_of(work, struct rdac_controller, ms_work);
 	struct request *rq;
 	struct scsi_device *sdev = ctlr->ms_sdev;
-	struct rdac_dh_data *h = get_rdac_data(sdev);
+	struct rdac_dh_data *h = sdev->handler_data;
 	struct request_queue *q = sdev->request_queue;
 	int err, retry_cnt = RDAC_RETRY_COUNT;
 	struct rdac_queue_data *tmp, *qdata;
@@ -648,7 +642,7 @@ static int queue_mode_select(struct scsi_device *sdev,
 	if (!qdata)
 		return SCSI_DH_RETRY;
 
-	qdata->h = get_rdac_data(sdev);
+	qdata->h = sdev->handler_data;
 	qdata->callback_fn = fn;
 	qdata->callback_data = data;
 
@@ -667,7 +661,7 @@ static int queue_mode_select(struct scsi_device *sdev,
 static int rdac_activate(struct scsi_device *sdev,
 			activate_complete fn, void *data)
 {
-	struct rdac_dh_data *h = get_rdac_data(sdev);
+	struct rdac_dh_data *h = sdev->handler_data;
 	int err = SCSI_DH_OK;
 	int act = 0;
 
@@ -702,7 +696,7 @@ done:
 
 static int rdac_prep_fn(struct scsi_device *sdev, struct request *req)
 {
-	struct rdac_dh_data *h = get_rdac_data(sdev);
+	struct rdac_dh_data *h = sdev->handler_data;
 	int ret = BLKPREP_OK;
 
 	if (h->state != RDAC_STATE_ACTIVE) {
@@ -716,7 +710,7 @@ static int rdac_prep_fn(struct scsi_device *sdev, struct request *req)
 static int rdac_check_sense(struct scsi_device *sdev,
 				struct scsi_sense_hdr *sense_hdr)
 {
-	struct rdac_dh_data *h = get_rdac_data(sdev);
+	struct rdac_dh_data *h = sdev->handler_data;
 
 	RDAC_LOG(RDAC_LOG_SENSE, sdev, "array %s, ctlr %d, "
 			"I/O returned with sense %02x/%02x/%02x",
@@ -778,7 +772,7 @@ static int rdac_check_sense(struct scsi_device *sdev,
 	return SCSI_RETURN_NOT_HANDLED;
 }
 
-static struct scsi_dh_data *rdac_bus_attach(struct scsi_device *sdev)
+static int rdac_bus_attach(struct scsi_device *sdev)
 {
 	struct rdac_dh_data *h;
 	int err;
@@ -787,7 +781,7 @@ static struct scsi_dh_data *rdac_bus_attach(struct scsi_device *sdev)
 
 	h = kzalloc(sizeof(*h) , GFP_KERNEL);
 	if (!h)
-		return ERR_PTR(-ENOMEM);
+		return -ENOMEM;
 	h->lun = UNINITIALIZED_LUN;
 	h->state = RDAC_STATE_ACTIVE;
 
@@ -812,7 +806,8 @@ static struct scsi_dh_data *rdac_bus_attach(struct scsi_device *sdev)
 		    RDAC_NAME, h->lun, mode[(int)h->mode],
 		    lun_state[(int)h->lun_state]);
 
-	return &h->dh_data;
+	sdev->handler_data = h;
+	return 0;
 
 clean_ctlr:
 	spin_lock(&list_lock);
@@ -821,12 +816,12 @@ clean_ctlr:
 
 failed:
 	kfree(h);
-	return ERR_PTR(-EINVAL);
+	return -EINVAL;
 }
 
 static void rdac_bus_detach( struct scsi_device *sdev )
 {
-	struct rdac_dh_data *h = get_rdac_data(sdev);
+	struct rdac_dh_data *h = sdev->handler_data;
 
 	if (h->ctlr && h->ctlr->ms_queued)
 		flush_workqueue(kmpath_rdacd);
diff --git a/drivers/scsi/scsi_dh.c b/drivers/scsi/scsi_dh.c
index 8f0a6dc..f0b100e 100644
--- a/drivers/scsi/scsi_dh.c
+++ b/drivers/scsi/scsi_dh.c
@@ -126,26 +126,19 @@ static struct scsi_device_handler *scsi_dh_lookup(const char *name)
 static int scsi_dh_handler_attach(struct scsi_device *sdev,
 				  struct scsi_device_handler *scsi_dh)
 {
-	struct scsi_dh_data *d;
+	int error;
 
 	if (!try_module_get(scsi_dh->module))
 		return -EINVAL;
 
-	d = scsi_dh->attach(sdev);
-	if (IS_ERR(d)) {
-		sdev_printk(KERN_ERR, sdev, "%s: Attach failed (%ld)\n",
-			    scsi_dh->name, PTR_ERR(d));
+	error = scsi_dh->attach(sdev);
+	if (error) {
+		sdev_printk(KERN_ERR, sdev, "%s: Attach failed (%d)\n",
+			    scsi_dh->name, error);
 		module_put(scsi_dh->module);
-		return PTR_ERR(d);
 	}
 
-	d->scsi_dh = scsi_dh;
-	d->sdev = sdev;
-
-	spin_lock_irq(sdev->request_queue->queue_lock);
-	sdev->scsi_dh_data = d;
-	spin_unlock_irq(sdev->request_queue->queue_lock);
-	return 0;
+	return error;
 }
 
 /*
@@ -154,17 +147,9 @@ static int scsi_dh_handler_attach(struct scsi_device *sdev,
  */
 static void scsi_dh_handler_detach(struct scsi_device *sdev)
 {
-	struct scsi_dh_data *scsi_dh_data = sdev->scsi_dh_data;
-	struct scsi_device_handler *scsi_dh = scsi_dh_data->scsi_dh;
-
-	scsi_dh->detach(sdev);
-
-	spin_lock_irq(sdev->request_queue->queue_lock);
-	sdev->scsi_dh_data = NULL;
-	spin_unlock_irq(sdev->request_queue->queue_lock);
-
-	sdev_printk(KERN_NOTICE, sdev, "%s: Detached\n", scsi_dh->name);
-	module_put(scsi_dh->module);
+	sdev->handler->detach(sdev);
+	sdev_printk(KERN_NOTICE, sdev, "%s: Detached\n", sdev->handler->name);
+	module_put(sdev->handler->module);
 }
 
 /*
@@ -182,7 +167,7 @@ store_dh_state(struct device *dev, struct device_attribute *attr,
 	    sdev->sdev_state == SDEV_DEL)
 		return -ENODEV;
 
-	if (!sdev->scsi_dh_data) {
+	if (!sdev->handler) {
 		/*
 		 * Attach to a device handler
 		 */
@@ -190,7 +175,6 @@ store_dh_state(struct device *dev, struct device_attribute *attr,
 			return err;
 		err = scsi_dh_handler_attach(sdev, scsi_dh);
 	} else {
-		scsi_dh = sdev->scsi_dh_data->scsi_dh;
 		if (!strncmp(buf, "detach", 6)) {
 			/*
 			 * Detach from a device handler
@@ -201,8 +185,8 @@ store_dh_state(struct device *dev, struct device_attribute *attr,
 			/*
 			 * Activate a device handler
 			 */
-			if (scsi_dh->activate)
-				err = scsi_dh->activate(sdev, NULL, NULL);
+			if (sdev->handler->activate)
+				err = sdev->handler->activate(sdev, NULL, NULL);
 			else
 				err = 0;
 		}
@@ -216,10 +200,10 @@ show_dh_state(struct device *dev, struct device_attribute *attr, char *buf)
 {
 	struct scsi_device *sdev = to_scsi_device(dev);
 
-	if (!sdev->scsi_dh_data)
+	if (!sdev->handler)
 		return snprintf(buf, 20, "detached\n");
 
-	return snprintf(buf, 20, "%s\n", sdev->scsi_dh_data->scsi_dh->name);
+	return snprintf(buf, 20, "%s\n", sdev->handler->name);
 }
 
 static struct device_attribute scsi_dh_state_attr =
@@ -246,7 +230,7 @@ int scsi_dh_add_device(struct scsi_device *sdev)
 
 void scsi_dh_remove_device(struct scsi_device *sdev)
 {
-	if (sdev->scsi_dh_data)
+	if (sdev->handler)
 		scsi_dh_handler_detach(sdev);
 	device_remove_file(&sdev->sdev_gendev, &scsi_dh_state_attr);
 }
@@ -315,7 +299,6 @@ int scsi_dh_activate(struct request_queue *q, activate_complete fn, void *data)
 	int err = 0;
 	unsigned long flags;
 	struct scsi_device *sdev;
-	struct scsi_device_handler *scsi_dh = NULL;
 	struct device *dev = NULL;
 
 	spin_lock_irqsave(q->queue_lock, flags);
@@ -328,10 +311,8 @@ int scsi_dh_activate(struct request_queue *q, activate_complete fn, void *data)
 		return err;
 	}
 
-	if (sdev->scsi_dh_data)
-		scsi_dh = sdev->scsi_dh_data->scsi_dh;
 	dev = get_device(&sdev->sdev_gendev);
-	if (!scsi_dh || !dev ||
+	if (!sdev->handler || !dev ||
 	    sdev->sdev_state == SDEV_CANCEL ||
 	    sdev->sdev_state == SDEV_DEL)
 		err = SCSI_DH_NOSYS;
@@ -345,8 +326,8 @@ int scsi_dh_activate(struct request_queue *q, activate_complete fn, void *data)
 		goto out;
 	}
 
-	if (scsi_dh->activate)
-		err = scsi_dh->activate(sdev, fn, data);
+	if (sdev->handler->activate)
+		err = sdev->handler->activate(sdev, fn, data);
 out:
 	put_device(dev);
 	return err;
@@ -368,19 +349,18 @@ int scsi_dh_set_params(struct request_queue *q, const char *params)
 	int err = -SCSI_DH_NOSYS;
 	unsigned long flags;
 	struct scsi_device *sdev;
-	struct scsi_device_handler *scsi_dh = NULL;
 
 	spin_lock_irqsave(q->queue_lock, flags);
 	sdev = q->queuedata;
-	if (sdev && sdev->scsi_dh_data)
-		scsi_dh = sdev->scsi_dh_data->scsi_dh;
-	if (scsi_dh && scsi_dh->set_params && get_device(&sdev->sdev_gendev))
+	if (sdev->handler &&
+	    sdev->handler->set_params &&
+	    get_device(&sdev->sdev_gendev))
 		err = 0;
 	spin_unlock_irqrestore(q->queue_lock, flags);
 
 	if (err)
 		return err;
-	err = scsi_dh->set_params(sdev, params);
+	err = sdev->handler->set_params(sdev, params);
 	put_device(&sdev->sdev_gendev);
 	return err;
 }
@@ -412,8 +392,8 @@ int scsi_dh_attach(struct request_queue *q, const char *name)
 	if (err)
 		return err;
 
-	if (sdev->scsi_dh_data) {
-		if (sdev->scsi_dh_data->scsi_dh != scsi_dh)
+	if (sdev->handler) {
+		if (sdev->handler != scsi_dh)
 			err = -EBUSY;
 		goto out_put_device;
 	}
@@ -450,8 +430,8 @@ const char *scsi_dh_attached_handler_name(struct request_queue *q, gfp_t gfp)
 	if (!sdev)
 		return NULL;
 
-	if (sdev->scsi_dh_data)
-		handler_name = kstrdup(sdev->scsi_dh_data->scsi_dh->name, gfp);
+	if (sdev->handler)
+		handler_name = kstrdup(sdev->handler->name, gfp);
 
 	put_device(&sdev->sdev_gendev);
 	return handler_name;
diff --git a/drivers/scsi/scsi_error.c b/drivers/scsi/scsi_error.c
index 106884a..569957d 100644
--- a/drivers/scsi/scsi_error.c
+++ b/drivers/scsi/scsi_error.c
@@ -37,6 +37,7 @@
 #include <scsi/scsi_transport.h>
 #include <scsi/scsi_host.h>
 #include <scsi/scsi_ioctl.h>
+#include <scsi/scsi_dh.h>
 #include <scsi/sg.h>
 
 #include "scsi_priv.h"
@@ -460,11 +461,10 @@ static int scsi_check_sense(struct scsi_cmnd *scmd)
 	if (scsi_sense_is_deferred(&sshdr))
 		return NEEDS_RETRY;
 
-	if (sdev->scsi_dh_data && sdev->scsi_dh_data->scsi_dh &&
-			sdev->scsi_dh_data->scsi_dh->check_sense) {
+	if (sdev->handler && sdev->handler->check_sense) {
 		int rc;
 
-		rc = sdev->scsi_dh_data->scsi_dh->check_sense(sdev, &sshdr);
+		rc = sdev->handler->check_sense(sdev, &sshdr);
 		if (rc != SCSI_RETURN_NOT_HANDLED)
 			return rc;
 		/* handler does not care. Drop down to default handling */
diff --git a/drivers/scsi/scsi_lib.c b/drivers/scsi/scsi_lib.c
index 4f3c120..b4ef3ff 100644
--- a/drivers/scsi/scsi_lib.c
+++ b/drivers/scsi/scsi_lib.c
@@ -31,6 +31,7 @@
 #include <scsi/scsi_driver.h>
 #include <scsi/scsi_eh.h>
 #include <scsi/scsi_host.h>
+#include <scsi/scsi_dh.h>
 
 #include <trace/events/scsi.h>
 
@@ -1248,9 +1249,8 @@ static int scsi_setup_fs_cmnd(struct scsi_device *sdev, struct request *req)
 {
 	struct scsi_cmnd *cmd = req->special;
 
-	if (unlikely(sdev->scsi_dh_data && sdev->scsi_dh_data->scsi_dh
-			 && sdev->scsi_dh_data->scsi_dh->prep_fn)) {
-		int ret = sdev->scsi_dh_data->scsi_dh->prep_fn(sdev, req);
+	if (unlikely(sdev->handler && sdev->handler->prep_fn)) {
+		int ret = sdev->handler->prep_fn(sdev, req);
 		if (ret != BLKPREP_OK)
 			return ret;
 	}
diff --git a/include/scsi/scsi_device.h b/include/scsi/scsi_device.h
index 409e15b..b6b1dc4 100644
--- a/include/scsi/scsi_device.h
+++ b/include/scsi/scsi_device.h
@@ -195,32 +195,13 @@ struct scsi_device {
 	struct execute_work	ew; /* used to get process context on put */
 	struct work_struct	requeue_work;
 
-	struct scsi_dh_data	*scsi_dh_data;
+	struct scsi_device_handler *handler;
+	void			*handler_data;
+
 	enum scsi_device_state sdev_state;
 	unsigned long		sdev_data[0];
 } __attribute__((aligned(sizeof(unsigned long))));
 
-typedef void (*activate_complete)(void *, int);
-struct scsi_device_handler {
-	/* Used by the infrastructure */
-	struct list_head list; /* list of scsi_device_handlers */
-
-	/* Filled by the hardware handler */
-	struct module *module;
-	const char *name;
-	int (*check_sense)(struct scsi_device *, struct scsi_sense_hdr *);
-	struct scsi_dh_data *(*attach)(struct scsi_device *);
-	void (*detach)(struct scsi_device *);
-	int (*activate)(struct scsi_device *, activate_complete, void *);
-	int (*prep_fn)(struct scsi_device *, struct request *);
-	int (*set_params)(struct scsi_device *, const char *);
-};
-
-struct scsi_dh_data {
-	struct scsi_device_handler *scsi_dh;
-	struct scsi_device *sdev;
-};
-
 #define	to_scsi_device(d)	\
 	container_of(d, struct scsi_device, sdev_gendev)
 #define	class_to_sdev(d)	\
diff --git a/include/scsi/scsi_dh.h b/include/scsi/scsi_dh.h
index 3a37b4c45..85d7317 100644
--- a/include/scsi/scsi_dh.h
+++ b/include/scsi/scsi_dh.h
@@ -55,6 +55,23 @@ enum {
 	SCSI_DH_NOSYS,
 	SCSI_DH_DRIVER_MAX,
 };
+
+typedef void (*activate_complete)(void *, int);
+struct scsi_device_handler {
+	/* Used by the infrastructure */
+	struct list_head list; /* list of scsi_device_handlers */
+
+	/* Filled by the hardware handler */
+	struct module *module;
+	const char *name;
+	int (*check_sense)(struct scsi_device *, struct scsi_sense_hdr *);
+	int (*attach)(struct scsi_device *);
+	void (*detach)(struct scsi_device *);
+	int (*activate)(struct scsi_device *, activate_complete, void *);
+	int (*prep_fn)(struct scsi_device *, struct request *);
+	int (*set_params)(struct scsi_device *, const char *);
+};
+
 #ifdef CONFIG_SCSI_DH
 extern int scsi_dh_activate(struct request_queue *, activate_complete, void *);
 extern int scsi_dh_attach(struct request_queue *, const char *);
-- 
1.8.5.2

