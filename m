From: Tejun Heo <tj@kernel.org>
Subject: [PATCH 2/6] scsi: pm8001: simplify workqueue usage
Date: Tue, 21 Dec 2010 16:01:57 +0100
Message-ID: <1292943721-4519-3-git-send-email-tj@kernel.org>
References: <1292943721-4519-1-git-send-email-tj@kernel.org>
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <1292943721-4519-1-git-send-email-tj@kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
To: linux-scsi@vger.kernel.org, James.Bottomley@suse.de, fujita.tomonori@lab.ntt.co.jp, linux-kernel@vger.kernel.org, Eric.Moore@lsi.com, dgilbert@interlog.com
Cc: Tejun Heo <tj@kernel.org>
List-Id: linux-scsi@vger.kernel.org

pm8001 manages its own list of pending works and cancel them on device
free.  It is unnecessarily complex and has a race condition - the
works are canceled but not synced, so the work could still be running
during and after the data structures are freed.

This patch simplifies workqueue usage.

* A driver specific workqueue pm8001_wq is created to serve these
  work items.

* To avoid confusion, the "queue" suffixes are dropped from work items
  and functions.

* Delayed queueing was never used.  pm8001_work now uses work_struct
  instead.

* The driver no longer keeps track of pending works.  All pm8001_works
  are queued to pm8001_wq and the workqueue is flushed as necessary.

flush_scheduled_work() usage is removed during conversion.

Signed-off-by: Tejun Heo <tj@kernel.org>
---
 drivers/scsi/pm8001/pm8001_hwi.c  |   37 +++++++++++++++++--------------------
 drivers/scsi/pm8001/pm8001_init.c |   27 ++++++++++++++++++---------
 drivers/scsi/pm8001/pm8001_sas.h  |   10 ++++++----
 3 files changed, 41 insertions(+), 33 deletions(-)

diff --git a/drivers/scsi/pm8001/pm8001_hwi.c b/drivers/scsi/pm8001/pm8001_hwi.c
index d8db013..18b6c55 100644
--- a/drivers/scsi/pm8001/pm8001_hwi.c
+++ b/drivers/scsi/pm8001/pm8001_hwi.c
@@ -1382,53 +1382,50 @@ static u32 mpi_msg_consume(struct pm8001_hba_info *pm8001_ha,
 	return MPI_IO_STATUS_BUSY;
 }
 
-static void pm8001_work_queue(struct work_struct *work)
+static void pm8001_work_fn(struct work_struct *work)
 {
-	struct delayed_work *dw = container_of(work, struct delayed_work, work);
-	struct pm8001_wq *wq = container_of(dw, struct pm8001_wq, work_q);
+	struct pm8001_work *pw = container_of(work, struct pm8001_work, work);
 	struct pm8001_device *pm8001_dev;
-	struct domain_device	*dev;
+	struct domain_device *dev;
 
-	switch (wq->handler) {
+	switch (pw->handler) {
 	case IO_OPEN_CNX_ERROR_IT_NEXUS_LOSS:
-		pm8001_dev = wq->data;
+		pm8001_dev = pw->data;
 		dev = pm8001_dev->sas_device;
 		pm8001_I_T_nexus_reset(dev);
 		break;
 	case IO_OPEN_CNX_ERROR_STP_RESOURCES_BUSY:
-		pm8001_dev = wq->data;
+		pm8001_dev = pw->data;
 		dev = pm8001_dev->sas_device;
 		pm8001_I_T_nexus_reset(dev);
 		break;
 	case IO_DS_IN_ERROR:
-		pm8001_dev = wq->data;
+		pm8001_dev = pw->data;
 		dev = pm8001_dev->sas_device;
 		pm8001_I_T_nexus_reset(dev);
 		break;
 	case IO_DS_NON_OPERATIONAL:
-		pm8001_dev = wq->data;
+		pm8001_dev = pw->data;
 		dev = pm8001_dev->sas_device;
 		pm8001_I_T_nexus_reset(dev);
 		break;
 	}
-	list_del(&wq->entry);
-	kfree(wq);
+	kfree(pw);
 }
 
 static int pm8001_handle_event(struct pm8001_hba_info *pm8001_ha, void *data,
 			       int handler)
 {
-	struct pm8001_wq *wq;
+	struct pm8001_work *pw;
 	int ret = 0;
 
-	wq = kmalloc(sizeof(struct pm8001_wq), GFP_ATOMIC);
-	if (wq) {
-		wq->pm8001_ha = pm8001_ha;
-		wq->data = data;
-		wq->handler = handler;
-		INIT_DELAYED_WORK(&wq->work_q, pm8001_work_queue);
-		list_add_tail(&wq->entry, &pm8001_ha->wq_list);
-		schedule_delayed_work(&wq->work_q, 0);
+	pw = kmalloc(sizeof(struct pm8001_work), GFP_ATOMIC);
+	if (pw) {
+		pw->pm8001_ha = pm8001_ha;
+		pw->data = data;
+		pw->handler = handler;
+		INIT_WORK(&pw->work, pm8001_work_fn);
+		queue_work(pm8001_wq, &pw->work);
 	} else
 		ret = -ENOMEM;
 
diff --git a/drivers/scsi/pm8001/pm8001_init.c b/drivers/scsi/pm8001/pm8001_init.c
index f8c86b2..40cf80d 100644
--- a/drivers/scsi/pm8001/pm8001_init.c
+++ b/drivers/scsi/pm8001/pm8001_init.c
@@ -51,6 +51,8 @@ static int pm8001_id;
 
 LIST_HEAD(hba_list);
 
+struct workqueue_struct *pm8001_wq;
+
 /**
  * The main structure which LLDD must register for scsi core.
  */
@@ -134,7 +136,6 @@ static void __devinit pm8001_phy_init(struct pm8001_hba_info *pm8001_ha,
 static void pm8001_free(struct pm8001_hba_info *pm8001_ha)
 {
 	int i;
-	struct pm8001_wq *wq;
 
 	if (!pm8001_ha)
 		return;
@@ -150,8 +151,7 @@ static void pm8001_free(struct pm8001_hba_info *pm8001_ha)
 	PM8001_CHIP_DISP->chip_iounmap(pm8001_ha);
 	if (pm8001_ha->shost)
 		scsi_host_put(pm8001_ha->shost);
-	list_for_each_entry(wq, &pm8001_ha->wq_list, entry)
-		cancel_delayed_work(&wq->work_q);
+	flush_workqueue(pm8001_wq);
 	kfree(pm8001_ha->tags);
 	kfree(pm8001_ha);
 }
@@ -381,7 +381,6 @@ pm8001_pci_alloc(struct pci_dev *pdev, u32 chip_id, struct Scsi_Host *shost)
 	pm8001_ha->sas = sha;
 	pm8001_ha->shost = shost;
 	pm8001_ha->id = pm8001_id++;
-	INIT_LIST_HEAD(&pm8001_ha->wq_list);
 	pm8001_ha->logging_level = 0x01;
 	sprintf(pm8001_ha->name, "%s%d", DRV_NAME, pm8001_ha->id);
 #ifdef PM8001_USE_TASKLET
@@ -758,7 +757,7 @@ static int pm8001_pci_suspend(struct pci_dev *pdev, pm_message_t state)
 	int i , pos;
 	u32 device_state;
 	pm8001_ha = sha->lldd_ha;
-	flush_scheduled_work();
+	flush_workqueue(pm8001_wq);
 	scsi_block_requests(pm8001_ha->shost);
 	pos = pci_find_capability(pdev, PCI_CAP_ID_PM);
 	if (pos == 0) {
@@ -870,17 +869,26 @@ static struct pci_driver pm8001_pci_driver = {
  */
 static int __init pm8001_init(void)
 {
-	int rc;
+	int rc = -ENOMEM;
+
+	pm8001_wq = alloc_workqueue("pm8001", 0, 0);
+	if (!pm8001_wq)
+		goto err;
+
 	pm8001_id = 0;
 	pm8001_stt = sas_domain_attach_transport(&pm8001_transport_ops);
 	if (!pm8001_stt)
-		return -ENOMEM;
+		goto err_wq;
 	rc = pci_register_driver(&pm8001_pci_driver);
 	if (rc)
-		goto err_out;
+		goto err_tp;
 	return 0;
-err_out:
+
+err_tp:
 	sas_release_transport(pm8001_stt);
+err_wq:
+	destroy_workqueue(pm8001_wq);
+err:
 	return rc;
 }
 
@@ -888,6 +896,7 @@ static void __exit pm8001_exit(void)
 {
 	pci_unregister_driver(&pm8001_pci_driver);
 	sas_release_transport(pm8001_stt);
+	destroy_workqueue(pm8001_wq);
 }
 
 module_init(pm8001_init);
diff --git a/drivers/scsi/pm8001/pm8001_sas.h b/drivers/scsi/pm8001/pm8001_sas.h
index 7f064f9..bdb6b27 100644
--- a/drivers/scsi/pm8001/pm8001_sas.h
+++ b/drivers/scsi/pm8001/pm8001_sas.h
@@ -50,6 +50,7 @@
 #include <linux/dma-mapping.h>
 #include <linux/pci.h>
 #include <linux/interrupt.h>
+#include <linux/workqueue.h>
 #include <scsi/libsas.h>
 #include <scsi/scsi_tcq.h>
 #include <scsi/sas_ata.h>
@@ -379,18 +380,16 @@ struct pm8001_hba_info {
 #ifdef PM8001_USE_TASKLET
 	struct tasklet_struct	tasklet;
 #endif
-	struct list_head 	wq_list;
 	u32			logging_level;
 	u32			fw_status;
 	const struct firmware 	*fw_image;
 };
 
-struct pm8001_wq {
-	struct delayed_work work_q;
+struct pm8001_work {
+	struct work_struct work;
 	struct pm8001_hba_info *pm8001_ha;
 	void *data;
 	int handler;
-	struct list_head entry;
 };
 
 struct pm8001_fw_image_header {
@@ -460,6 +459,9 @@ struct fw_control_ex {
 	void			*param3;
 };
 
+/* pm8001 workqueue */
+extern struct workqueue_struct *pm8001_wq;
+
 /******************** function prototype *********************/
 int pm8001_tag_alloc(struct pm8001_hba_info *pm8001_ha, u32 *tag_out);
 void pm8001_tag_init(struct pm8001_hba_info *pm8001_ha);
-- 
1.7.1
